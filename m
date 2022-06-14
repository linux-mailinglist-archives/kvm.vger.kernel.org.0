Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9191D54BD21
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 23:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbiFNV6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 17:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357650AbiFNV6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 17:58:40 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB03E1D322
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oa9-20020a17090b1bc900b001e67bbd7f83so145739pjb.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 14:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4cmqk23DQrPKWneD8bfnXS0oC9sry0DDafSS8X/CWrY=;
        b=l7Hyql+C78Kd52RjmTYdrcgLYsY6UXxV7s65+2yyhvoLQjvsARJmTI0lrfWXIJZGou
         xooLNsnrvS4ofkFC7QyPahtMB1e0c3DxonlLqJ4xSbrZtgmzqqHvduPqwfoYbIMkdyMW
         SSIWWqyg16Y7cJPZpK7LGta0EC1Kxhe/6uHv1PKhLVhBdUPcWcsyNWzwHtGxnW/Br3pC
         vw95EhjCh7ZvWRtnQ+7PIe/cW695vLsl/jP0P2UE1QVcoIuSzJ6bWlCPblWqtGIGF0eC
         gslGW6JDKfEIN8aGlriT/8pHt+3MDWPq7002wmNeWY6Q/fQY6hc5byK0nTTv3ToXXQbS
         61zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4cmqk23DQrPKWneD8bfnXS0oC9sry0DDafSS8X/CWrY=;
        b=49Hn+H8oky3UxEHH3Er6o058eYtJpUxKneDjmuy5ASa71Fasrmod7r/yBl2JZ2yrSX
         PoLgw/8T1FSbIXW5v51z5rD0Eu3tfVXdUXqB6bPzNMzW5lF+65fWTAcimSWTZ5o+Y+LI
         sl9aeFN6FVgJ/kBE7mUN/FpbBz5WyUpZXcO15V1JvoM/vubd65xX7f8pnAbqYp9oE5Qm
         +qHMUrtt6r5Ls0wpRPNpeSfuLOi799k9NUT1PVlA4KzMw2YkdbTEvTCkrBKsApIktF/d
         7smUcSjPCh6kOMW1DGHHjiUQYGXfJ5PbJ4IvtNnin2DqzgVvrkDAIVeW/brJATTnOjue
         PmRA==
X-Gm-Message-State: AOAM532/kBGiKL+U2R4HwhOL23F0xSvNgpeqEExs7mbX1KOA1vEL7cHm
        sg4fUGc3rpqIl+b2glusOasED6dsmGA=
X-Google-Smtp-Source: AGRyM1tppxzX8x/S4uyoNAr8Mb9Nltty5GKCKylv/JWEvOgXdviTwh9iRY9BihNAmupoKG78fgFqDFdvczE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1688:b0:517:cf7b:9293 with SMTP id
 k8-20020a056a00168800b00517cf7b9293mr6709889pfc.7.1655243919477; Tue, 14 Jun
 2022 14:58:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 21:58:29 +0000
In-Reply-To: <20220614215831.3762138-1-seanjc@google.com>
Message-Id: <20220614215831.3762138-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220614215831.3762138-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 3/5] KVM: nVMX: Rename nested.vmcs01_* fields to nested.pre_vmenter_*
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Wang <lei4.wang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the fields in struct nested_vmx used to snapshot pre-VM-Enter
values to reflect that they can hold L2's values when restoring nested
state, e.g. if userspace restores MSRs before nested state.  As crazy as
it seems, restoring MSRs before nested state actually works (because KVM
goes out if it's way to make it work), even though the initial MSR writes
will hit vmcs01 despite holding L2 values.

Add a related comment to vmx_enter_smm() to call out that using the
common VM-Exit and VM-Enter helpers to emulate SMI and RSM is wrong and
broken.  The few MSRs that have snapshots _could_ be fixed by taking a
snapshot prior to the forced VM-Exit instead of at forced VM-Enter, but
that's just the tip of the iceberg as the rather long list of MSRs that
aren't snapshotted (hello, VM-Exit MSR load list) can't be handled this
way.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  8 ++++----
 arch/x86/kvm/vmx/vmx.c    |  7 +++++++
 arch/x86/kvm/vmx/vmx.h    | 15 ++++++++++++---
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4a53e0c73445..38015f4ecc54 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2520,11 +2520,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.vmcs01_debugctl);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
 	}
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
-		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
+		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
 
 	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
@@ -3381,11 +3381,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
-		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
 	    (!vmx->nested.nested_run_pending ||
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
-		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*
 	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..b3f9b8bb1fa8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7843,6 +7843,13 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	/*
+	 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
+	 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
+	 * SMI and RSM only modify state that is saved and restored via SMRAM.
+	 * E.g. most MSRs are left untouched, but many are modified by VM-Exit
+	 * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
+	 */
 	vmx->nested.smm.guest_mode = is_guest_mode(vcpu);
 	if (vmx->nested.smm.guest_mode)
 		nested_vmx_vmexit(vcpu, -1, 0, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 71bcb486e73f..a84c91ee2a48 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -219,9 +219,18 @@ struct nested_vmx {
 	bool has_preemption_timer_deadline;
 	bool preemption_timer_expired;
 
-	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
-	u64 vmcs01_debugctl;
-	u64 vmcs01_guest_bndcfgs;
+	/*
+	 * Used to snapshot MSRs that are conditionally loaded on VM-Enter in
+	 * order to propagate the guest's pre-VM-Enter value into vmcs02.  For
+	 * emulation of VMLAUNCH/VMRESUME, the snapshot will be of L1's value.
+	 * For KVM_SET_NESTED_STATE, the snapshot is of L2's value, _if_
+	 * userspace restores MSRs before nested state.  If userspace restores
+	 * MSRs after nested state, the snapshot holds garbage, but KVM can't
+	 * detect that, and the garbage value in vmcs02 will be overwritten by
+	 * MSR restoration in any case.
+	 */
+	u64 pre_vmenter_debugctl;
+	u64 pre_vmenter_bndcfgs;
 
 	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
 	int l1_tpr_threshold;
-- 
2.36.1.476.g0c4daa206d-goog

