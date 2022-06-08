Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9E054300C
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiFHMNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238886AbiFHMNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:13:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1B1A25F92A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZZuPTlsr0p/zFJmJe7+skZgHwdJ/X5lOwubK5xlBlQ=;
        b=feGV13HsHa3RnTzYrEzP86wWy0gMWCZYSWpzFO/v+Zs5PmLL3OUzOmGXYNyNDOLypvZoG3
        nybX3O7SE1e+jUYbvqZh11fAM4SL1+GUYmo5BwtnpGRUlWJI+6OswlfUKLkJHlhepj7MSo
        lNLClGYiXtnP0eCQhXLoYuehhjCITi8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-KYvN-GiRPma_N-xghQT3Ig-1; Wed, 08 Jun 2022 08:12:54 -0400
X-MC-Unique: KYvN-GiRPma_N-xghQT3Ig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74C39101AA52;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5886B1415102;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 3/6] KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
Date:   Wed,  8 Jun 2022 08:12:50 -0400
Message-Id: <20220608121253.867333-4-pbonzini@redhat.com>
In-Reply-To: <20220608121253.867333-1-pbonzini@redhat.com>
References: <20220608121253.867333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
PIO, __emulator_pio_in does not have to be always followed
by complete_emulator_pio_in.  This affects emulator_pio_in and
kvm_sev_es_ins; for the latter, that is why the call moves from
advance_sev_es_emulated_ins to complete_sev_es_emulated_ins.

For output, it means that vcpu->pio.count is never set unnecessarily
and there is no need to clear it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 61 ++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e1e76d0378b..3b641cd2ff6f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7423,16 +7423,6 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	int r;
 
 	WARN_ON_ONCE(vcpu->arch.pio.count);
-	vcpu->arch.pio.port = port;
-	vcpu->arch.pio.in = in;
-	vcpu->arch.pio.count = count;
-	vcpu->arch.pio.size = size;
-	if (in)
-		memset(vcpu->arch.pio_data, 0, size * count);
-	else
-		memcpy(vcpu->arch.pio_data, data, size * count);
-	data = vcpu->arch.pio_data;
-
 	for (i = 0; i < count; i++) {
 		if (in)
 			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS, port, size, data);
@@ -7446,6 +7436,16 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 
 userspace_io:
 	WARN_ON(i != 0);
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
@@ -7457,9 +7457,13 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
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
@@ -7482,16 +7486,11 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 		 * shenanigans as KVM doesn't support modifying the rep count,
 		 * and the emulator ensures @count doesn't overflow the buffer.
 		 */
+		complete_emulator_pio_in(vcpu, val);
+		return 1;
 	} else {
-		int r = __emulator_pio_in(vcpu, size, port, count);
-		if (!r)
-			return r;
-
-		/* Results already available, fall through.  */
+		return __emulator_pio_in(vcpu, size, port, val, count);
 	}
-
-	complete_emulator_pio_in(vcpu, val);
-	return 1;
 }
 
 static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
@@ -7506,14 +7505,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
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
@@ -13064,20 +13057,20 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
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
@@ -13089,11 +13082,11 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
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


