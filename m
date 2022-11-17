Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FBC62DE48
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240458AbiKQOeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240422AbiKQOeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEC9D13A
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTfKFD0cFY/1sVq1cxqtG2BQAiBGe959F/rhRBmBw68=;
        b=Sz6nLMlCRHGLR4ex9CMk2bvejscb310q/lkc1+yWFCBA2V4F4k/vaYimZkztzNq2kih6K7
        KSqfTN8ebfUGHo5/QF5JbL4HPFuBjhmgUMkTAuAeJVtqesOoqXQOe0Lc20lsdse5rGUVJe
        JAxdhmlGf8ZTQaxpg+pEMaw2/UM89m8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-3XWKG39ROWm9iWhpwhjDNw-1; Thu, 17 Nov 2022 09:33:24 -0500
X-MC-Unique: 3XWKG39ROWm9iWhpwhjDNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C51CD887402;
        Thu, 17 Nov 2022 14:32:54 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F09B2166B29;
        Thu, 17 Nov 2022 14:32:51 +0000 (UTC)
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
Subject: [PATCH 02/13] KVM: nSVM: don't call nested_sync_control_from_vmcb02 on each VM exit
Date:   Thu, 17 Nov 2022 16:32:31 +0200
Message-Id: <20221117143242.102721-3-mlevitsk@redhat.com>
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

Calling nested_sync_control_from_vmcb02 on each VM exit (nested or not),
was an attempt to keep the int_ctl field in the vmcb12 cache
up to date on each VM exit.

However all other fields in the vmcb12 cache are not kept up to	 date,
therefore for consistency it is better to do this on a nested VM exit only.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 17 ++++++++---------
 arch/x86/kvm/svm/svm.c    |  2 --
 arch/x86/kvm/svm/svm.h    |  1 -
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 43cc4a5d22e012..91a51e75717dca 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -407,11 +407,12 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
  * Synchronize fields that are written by the processor, so that
  * they can be copied back into the vmcb12.
  */
-void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
+static void nested_sync_control_from_vmcb02(struct vcpu_svm *svm,
+					    struct vmcb *vmcb12)
 {
 	u32 mask;
-	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
-	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+	vmcb12->control.event_inj      = svm->vmcb->control.event_inj;
+	vmcb12->control.event_inj_err  = svm->vmcb->control.event_inj_err;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
@@ -431,8 +432,8 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 	if (nested_vgif_enabled(svm))
 		mask |= V_GIF_MASK;
 
-	svm->nested.ctl.int_ctl        &= ~mask;
-	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
+	vmcb12->control.int_ctl        &= ~mask;
+	vmcb12->control.int_ctl        |= svm->vmcb->control.int_ctl & mask;
 }
 
 /*
@@ -985,13 +986,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
+	nested_sync_control_from_vmcb02(svm, vmcb12);
+
 	if (svm->nrips_enabled)
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
-	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
-
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 527f18d8cc4489..03acbe8ff34edb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4016,8 +4016,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm->next_rip = 0;
 	if (is_guest_mode(vcpu)) {
-		nested_sync_control_from_vmcb02(svm);
-
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
 		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 199a2ecef1cec6..f5383104d00580 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -618,7 +618,6 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 				       struct vmcb_control_area *control);
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save);
-void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
-- 
2.34.3

