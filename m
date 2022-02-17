Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8D4BAB6F
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbiBQVEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244299AbiBQVEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98FDD163D79
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NX/p+3ovzAsh1RMwMjnRGHxJsp1FvXTx8d19l00fGLI=;
        b=N1NmM3I/mO4iGNiHkKsRFyde2xZESuqgMd2lBpkakwKWH013taYflQ/XyF+eC6/Jwq0hxk
        8NC9F4G1ebfFXEbAODN0VYZWKhN5aRw3zxDlTrPOm74XHZzjxoVyxQLMd73DQWhSmHAwY/
        RW3+m8GnmXpqFUh8vsevN/VQyyp56oA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-at2ZsQzxN1-8gbUmI3ucJw-1; Thu, 17 Feb 2022 16:03:50 -0500
X-MC-Unique: at2ZsQzxN1-8gbUmI3ucJw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B661814245;
        Thu, 17 Feb 2022 21:03:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C82F6AB90;
        Thu, 17 Feb 2022 21:03:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 17/18] KVM: x86: flush TLB separately from MMU reset
Date:   Thu, 17 Feb 2022 16:03:39 -0500
Message-Id: <20220217210340.312449-18-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For both CR0 and CR4, disassociate the TLB flush logic from the
MMU role logic.  Instead  of relying on kvm_mmu_reset_context() being
a superset of various TLB flushes (which is not necessarily going to
be the case in the future), always call it if the role changes
but also set the various TLB flush requests according to what is
in the manual.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 58 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9043548e6baf..2b4663dfcd8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -871,6 +871,13 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
+
+		/*
+		 * Clearing CR0.PG is defined to flush the TLB from the guest's
+		 * perspective.
+		 */
+		if (!(cr0 & X86_CR0_PG))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
 
 	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
@@ -1057,28 +1064,41 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
 
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
 {
+	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
+		kvm_mmu_reset_context(vcpu);
+
 	/*
-	 * If any role bit is changed, the MMU needs to be reset.
-	 *
-	 * If CR4.PCIDE is changed 1 -> 0, the guest TLB must be flushed.
 	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
 	 * according to the SDM; however, stale prev_roots could be reused
 	 * incorrectly in the future after a MOV to CR3 with NOFLUSH=1, so we
-	 * free them all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
-	 * is slow, but changing CR4.PCIDE is a rare case.
-	 *
-	 * If CR4.PGE is changed, the guest TLB must be flushed.
-	 *
-	 * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
-	 * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
-	 * the usage of "else if".
+	 * free them all.  This is *not* a superset of KVM_REQ_TLB_FLUSH_GUEST
+	 * or KVM_REQ_TLB_FLUSH_CURRENT, because the hardware TLB is not flushed,
+	 * so fall through.
 	 */
-	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
-		kvm_mmu_reset_context(vcpu);
-	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
+	if (!tdp_enabled &&
+	    (cr4 & X86_CR4_PCIDE) && !(old_cr4 & X86_CR4_PCIDE))
 		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
-	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
-		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
+	/*
+	 * The TLB has to be flushed for all PCIDs on:
+	 * - CR4.PCIDE changed from 1 to 0
+	 * - any change to CR4.PGE
+	 *
+	 * This is a superset of KVM_REQ_TLB_FLUSH_CURRENT.
+	 */
+	if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
+	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
+		 kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
+	/*
+	 * The TLB has to be flushed for the current PCID on:
+	 * - CR4.SMEP changed from 0 to 1
+	 * - any change to CR4.PAE
+	 */
+	else if (((cr4 ^ old_cr4) & X86_CR4_PAE) ||
+		 ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP)))
+		 kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
 
@@ -11323,15 +11343,17 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
 
 	/*
-	 * Reset the MMU context if paging was enabled prior to INIT (which is
+	 * A TLB flush is needed if paging was enabled prior to INIT (which is
 	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
 	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
 	 * checked because it is unconditionally cleared on INIT and all other
 	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
 	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
 	 */
-	if (old_cr0 & X86_CR0_PG)
+	if (old_cr0 & X86_CR0_PG) {
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 		kvm_mmu_reset_context(vcpu);
+	}
 
 	/*
 	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
-- 
2.31.1


