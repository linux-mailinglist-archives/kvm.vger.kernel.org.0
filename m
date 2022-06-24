Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDE559F92
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiFXRTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiFXRS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7310141985
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M2VwHIzlgf6suh30aCXnA2oy96t8J5oIFCGlpyPJlL0=;
        b=eIjUf34O1wq42YfjHqrhOycso6CT3WM3YcV0W2Dvupxo56alMqWy2Ie3xyEzvn7gGsTGc5
        9DJuyDbMBBbfpXk+nKLHEHtDwZhwI6SGiHWiqR8H7IOeupgA9i4YUbt1vKSE8UuwJxUFue
        /zV/AiRmMiQ8mbgOKdgHd5grB+ANdFs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-TBuJJVdHPdGQ85PvV6Cz5Q-1; Fri, 24 Jun 2022 13:18:50 -0400
X-MC-Unique: TBuJJVdHPdGQ85PvV6Cz5Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F26CA801231;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAD87492C3B;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 7/8] KVM: x86: de-underscorify __emulator_pio_in
Date:   Fri, 24 Jun 2022 13:18:47 -0400
Message-Id: <20220624171848.2801602-8-pbonzini@redhat.com>
In-Reply-To: <20220624171848.2801602-1-pbonzini@redhat.com>
References: <20220624171848.2801602-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now all callers except emulator_pio_in_emulated are using
__emulator_pio_in/complete_emulator_pio_in explicitly.
Move the "either copy the result or attempt PIO" logic in
emulator_pio_in_emulated, and rename __emulator_pio_in to
just emulator_pio_in.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b824ffc63b17..1a017a5a680b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7626,8 +7626,8 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 	return 0;
 }
 
-static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			     unsigned short port, void *val, unsigned int count)
+static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
+      			   unsigned short port, void *val, unsigned int count)
 {
 	int r = emulator_pio_in_out(vcpu, size, port, val, count, true);
 	if (r)
@@ -7645,9 +7645,11 @@ static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
 	vcpu->arch.pio.count = 0;
 }
 
-static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
-			   unsigned short port, void *val, unsigned int count)
+static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
+				    int size, unsigned short port, void *val,
+				    unsigned int count)
 {
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	if (vcpu->arch.pio.count) {
 		/*
 		 * Complete a previous iteration that required userspace I/O.
@@ -7660,15 +7662,7 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
 		return 1;
 	}
 
-	return __emulator_pio_in(vcpu, size, port, val, count);
-}
-
-static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
-				    int size, unsigned short port, void *val,
-				    unsigned int count)
-{
-	return emulator_pio_in(emul_to_vcpu(ctxt), size, port, val, count);
-
+	return emulator_pio_in(vcpu, size, port, val, count);
 }
 
 static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
@@ -8886,7 +8880,7 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 	/* For size less than 4 we merge, else we zero extend */
 	val = (size < 4) ? kvm_rax_read(vcpu) : 0;
 
-	ret = __emulator_pio_in(vcpu, size, port, &val, 1);
+	ret = emulator_pio_in(vcpu, size, port, &val, 1);
 	if (ret) {
 		kvm_rax_write(vcpu, val);
 		return ret;
@@ -13277,7 +13271,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
 	for (;;) {
 		unsigned int count =
 			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
-		if (!__emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
+		if (!emulator_pio_in(vcpu, size, port, vcpu->arch.sev_pio_data, count))
 			break;
 
 		/* Emulation done by the kernel.  */
-- 
2.31.1


