Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39049559F90
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiFXRTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiFXRS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC988680A0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fg5ajEwsaDOi0mRWYQQiQq63ErgdP2nROPRnrIqW490=;
        b=RFKSw4iUtwZp9J53CwW60KQUWKkLj+Mit+sGkRN6c4XUrKHNt4r9oynGTm27mVgxrYg2rN
        4b1tuoDlIcwJQEFLibLjpmuN4/zC4sbVzSJC47PtajxRieDAxhEAfQRkq3mD6xLuAJutRh
        OPliadDmJcO7/80227FBi+eV04LRFA4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-gbrX7sijMUqUT3oXtBPjnA-1; Fri, 24 Jun 2022 13:18:50 -0400
X-MC-Unique: gbrX7sijMUqUT3oXtBPjnA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B36F72919EC2;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C2A7492C3B;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 5/8] KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
Date:   Fri, 24 Jun 2022 13:18:45 -0400
Message-Id: <20220624171848.2801602-6-pbonzini@redhat.com>
In-Reply-To: <20220624171848.2801602-1-pbonzini@redhat.com>
References: <20220624171848.2801602-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make emulator_pio_in_out operate directly on the provided buffer
as long as PIO is handled inside KVM.

For input operations, this means that, in the case of in-kernel
PIO, __emulator_pio_in() does not have to be always followed
by complete_emulator_pio_in().  This affects emulator_pio_in() and
kvm_sev_es_ins(); for the latter, that is why the call moves from
advance_sev_es_emulated_ins() to complete_sev_es_emulated_ins().

For output, it means that vcpu->pio.count is never set unnecessarily
and there is no need to clear it; but also vcpu->pio.size must not
be used in kvm_sev_es_outs(), because it will not be updated for
in-kernel OUT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 73 ++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 368d0d4d56ff..716ae5c92687 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7583,19 +7583,6 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	int r;
 
 	WARN_ON_ONCE(vcpu->arch.pio.count);
-	vcpu->arch.pio.port = port;
-	vcpu->arch.pio.in = in;
-	vcpu->arch.pio.count = count;
-	vcpu->arch.pio.size = size;
-	if (in) {
-		/* The buffer is only used in complete_emulator_pio_in().  */
-		WARN_ON(data);
-		memset(vcpu->arch.pio_data, 0, size * count);
-	} else {
-		memcpy(vcpu->arch.pio_data, data, size * count);
-	}
-	data = vcpu->arch.pio_data;
-
 	for (i = 0; i < count; i++) {
 		if (in)
 			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
@@ -7608,9 +7595,10 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 
 			/*
 			 * Userspace must have unregistered the device while PIO
-			 * was running.  Drop writes / read as 0 (the buffer
-			 * was zeroed in __emulator_pio_in).
+			 * was running.  Drop writes / read as 0.
 			 */
+			if (in)
+				memset(data, 0, size * (count - i));
 			break;
 		}
 
@@ -7619,6 +7607,16 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 1;
 
 userspace_io:
+	vcpu->arch.pio.port = port;
+	vcpu->arch.pio.in = in;
+	vcpu->arch.pio.count = count;
+	vcpu->arch.pio.size = size;
+
+	if (in)
+		memset(vcpu->arch.pio_data, 0, size * count);
+	else
+		memcpy(vcpu->arch.pio_data, data, size * count);
+
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
 	vcpu->run->io.size = size;
@@ -7629,15 +7627,19 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 }
 
 static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			     unsigned short port, unsigned int count)
+			     unsigned short port, void *val, unsigned int count)
 {
-	return emulator_pio_in_out(vcpu, size, port, NULL, count, true);
+	int r = emulator_pio_in_out(vcpu, size, port, val, count, true);
+	if (r)
+		trace_kvm_pio(KVM_PIO_IN, port, size, count, val);
+
+	return r;
 }
 
 static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
 {
 	int size = vcpu->arch.pio.size;
-	unsigned count = vcpu->arch.pio.count;
+	unsigned int count = vcpu->arch.pio.count;
 	memcpy(val, vcpu->arch.pio_data, size * count);
 	trace_kvm_pio(KVM_PIO_IN, vcpu->arch.pio.port, size, count, vcpu->arch.pio_data);
 	vcpu->arch.pio.count = 0;
@@ -7654,16 +7656,11 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 		 * shenanigans as KVM doesn't support modifying the rep count,
 		 * and the emulator ensures @count doesn't overflow the buffer.
 		 */
-	} else {
-		int r = __emulator_pio_in(vcpu, size, port, count);
-		if (!r)
-			return r;
-
-		/* Results already available, fall through.  */
+		complete_emulator_pio_in(vcpu, val);
+		return 1;
 	}
 
-	complete_emulator_pio_in(vcpu, val);
-	return 1;
+	return __emulator_pio_in(vcpu, size, port, val, count);
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -7678,14 +7675,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 			    unsigned short port, const void *val,
 			    unsigned int count)
 {
-	int ret;
-
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
-	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
-	if (ret)
-                vcpu->arch.pio.count = 0;
-
-        return ret;
+	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
@@ -13245,7 +13236,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 
 		/* memcpy done already by emulator_pio_out.  */
 		vcpu->arch.sev_pio_count -= count;
-		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+		vcpu->arch.sev_pio_data += count * size;
 		if (!ret)
 			break;
 
@@ -13261,20 +13252,20 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
 static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 			  unsigned int port);
 
-static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu, unsigned count, int size)
 {
-	unsigned count = vcpu->arch.pio.count;
-	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
 	vcpu->arch.sev_pio_count -= count;
-	vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
+	vcpu->arch.sev_pio_data += count * size;
 }
 
 static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
 {
+	unsigned count = vcpu->arch.pio.count;
 	int size = vcpu->arch.pio.size;
 	int port = vcpu->arch.pio.port;
 
-	advance_sev_es_emulated_ins(vcpu);
+	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
+	advance_sev_es_emulated_ins(vcpu, count, size);
 	if (vcpu->arch.sev_pio_count)
 		return kvm_sev_es_ins(vcpu, size, port);
 	return 1;
@@ -13286,11 +13277,11 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	for (;;) {
 		unsigned int count =
 			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
-		if (!__emulator_pio_in(vcpu, size, port, count))
+		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
 			break;
 
 		/* Emulation done by the kernel.  */
-		advance_sev_es_emulated_ins(vcpu);
+		advance_sev_es_emulated_ins(vcpu, count, size);
 		if (!vcpu->arch.sev_pio_count)
 			return 1;
 	}
-- 
2.31.1


