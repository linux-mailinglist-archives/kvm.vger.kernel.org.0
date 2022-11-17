Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F462DE44
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbiKQOee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240389AbiKQOeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306D7C02C
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNEoyeGAEVTCdztuKwF4HOV2ZBQ699jUuFAvu0ZmBLc=;
        b=R6ZxpRzdPf6bosBm/IOgEIZbvQzM1BGRrC3nhgiE+1F1s1k2xxaHsPuZLU/9bYCzpxNmAM
        UP2IoUNRbPe0QeMTXuH283gnHSokVQULI4UZfctjCQfptTMGmyJMWDGyZVK/ec5Mi0dA/I
        D7Nek4iC9zQyK1+/+Yb3BZsX777T590=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-mlndjeDoN665rlDIW81BqQ-1; Thu, 17 Nov 2022 09:33:03 -0500
X-MC-Unique: mlndjeDoN665rlDIW81BqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A46F887403;
        Thu, 17 Nov 2022 14:33:02 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B99BA2166B29;
        Thu, 17 Nov 2022 14:32:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 04/13] KVM: nSVM: clean up copying of int_ctl fields back to vmcb01/vmcb12
Date:   Thu, 17 Nov 2022 16:32:33 +0200
Message-Id: <20221117143242.102721-5-mlevitsk@redhat.com>
In-Reply-To: <20221117143242.102721-1-mlevitsk@redhat.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up the nested_sync_int_ctl_from_vmcb02:

1. The comment about preservation of V_IRQ is wrong: when the L2 doesn't
   use virtual interrupt masking, then the field just doesn't exist in
   vmcb12 thus it should not be touched at all.
   Since it is unused in this case, touching it doesn't matter that much,
   so the bug is theoretical.

2. When the L2 doesn't use virtual interrupt masking, then in the *theory*
   if KVM uses the feature, it should copy the changes to V_IRQ* bits from
   vmcb02 to vmcb01.

   In practise, KVM only uses it for detection of the interrupt window,
   and it happens to re-open it on each nested VM exit because
   kvm_set_rflags happens to raise the KVM_REQ_EVENT.
   Do this explicitly.

3. Add comment on why we don't need to copy V_GIF from vmcb02 to vmcb01
   when nested guest doesn't use nested V_GIF (and thus L1's GIF is in
   vmcb02 while nested), even though it can in theory affect L1's GIF.

4. Add support code to also copy some bits of int_ctl from
   vmcb02 to vmcb01.
   Currently there are none.

No (visible) functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 47 ++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 54eb152e2b60b6..1f2b8492c8782f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -410,28 +410,45 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 static void nested_sync_int_ctl_from_vmcb02(struct vcpu_svm *svm,
 					    struct vmcb *vmcb12)
 {
-	u32 mask;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+
+	/* bitmask of bits of int_ctl that we copy from vmcb02 to vmcb12*/
+	u32 l2_to_l1_mask = 0;
+	/* bitmask of bits of int_ctl that we copy from vmcb02 to vmcb01*/
+	u32 l2_to_l0_mask = 0;
 
-	/* Only a few fields of int_ctl are written by the processor.  */
-	mask = V_IRQ_MASK | V_TPR_MASK;
-	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
-	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
+	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
+		l2_to_l1_mask |= V_IRQ_MASK | V_TPR_MASK;
+	else {
 		/*
-		 * In order to request an interrupt window, L0 is usurping
-		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
-		 * even if it was clear in L1's VMCB.  Restoring it would be
-		 * wrong.  However, in this case V_IRQ will remain true until
-		 * interrupt_window_interception calls svm_clear_vintr and
-		 * restores int_ctl.  We can just leave it aside.
+		 * If IRQ window was opened while in L2, it must be reopened
+		 * after the VM exit
+		 *
+		 * vTPR value doesn't need to be copied from vmcb02 to vmcb01
+		 * because it is synced from/to apic registers on each VM exit
 		 */
-		mask &= ~V_IRQ_MASK;
+		if (vmcb02->control.int_ctl & V_IRQ_MASK)
+			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	}
 
 	if (nested_vgif_enabled(svm))
-		mask |= V_GIF_MASK;
+		l2_to_l1_mask |= V_GIF_MASK;
+	else
+		/* There is no need to sync V_GIF from vmcb02 to vmcb01
+		 * because GIF is cleared on VMexit, thus even though
+		 * nested guest can control host's GIF, on VM exit
+		 * its set value is lost
+		 */
+		;
+
+	vmcb12->control.int_ctl =
+		(svm->nested.ctl.int_ctl & ~l2_to_l1_mask) |
+		(vmcb02->control.int_ctl & l2_to_l1_mask);
 
-	vmcb12->control.int_ctl        &= ~mask;
-	vmcb12->control.int_ctl        |= svm->vmcb->control.int_ctl & mask;
+	vmcb01->control.int_ctl =
+		(vmcb01->control.int_ctl & ~l2_to_l0_mask) |
+		(vmcb02->control.int_ctl & l2_to_l0_mask);
 }
 
 /*
-- 
2.34.3

