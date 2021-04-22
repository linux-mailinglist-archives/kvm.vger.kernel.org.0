Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B1F367789
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhDVCjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbhDVCjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:39:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E286C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:38:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s34-20020a252d620000b02904e34d3a48abso18194379ybe.13
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=xbd22aCtQRBPSIBux5x1ONfW3mzcaq+9oc3GdPhDL5A=;
        b=CQNZmCRn6tjpHmZXXODOgrYWhlhpa5V8QSPvAOYAmgGvNfkkZr0U7ML3JW+RkPYPPY
         +1rAfFq+0zB61kdoNZlgZM63U2qHKsUK9NzCEPuV0c4YwnmL4ih52ThlPHMCCxxHrwNr
         FeDr2TYhk3INAUrrQHwLF6HjW6P/uutql80C6h6UOlBP2xcWNtfYCXQd6Xa27tNRDVcH
         0tX/Y/0d79FaHQ654iTuI+fGRFAR6+QkXJIkoqTEMELekTkH8QWtjCgRL+him5ULG9Di
         DFoeWvq+L4DD0d9Qbo3aF/lyG9vG36/HovZbCetSNI1sJd7xA01c5R7D/ycfMcHzWw1r
         VKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=xbd22aCtQRBPSIBux5x1ONfW3mzcaq+9oc3GdPhDL5A=;
        b=Jew+5qmNNfR7f3JK/RwiK4DYqG/uQzx2LHCfIpRU22EhifOiJPaCzKN2Q2kHFj09k4
         re94NwEBbqMsryUuRGUxxHaQBoi2YwVZf5A7abrTpLJ3L69EMGb9G/QFMkcYvEBKtQRt
         UhoE68hBzuM+ELHJQrVkGlUQg91NBLXqLJl6hbuLMnXtlhXI6ETLrTIdEUHz2WYIGkK2
         uo0XT6C9zFC7sTF1co4g4/kS80tTuZ+JybS1rPIeup6CjqJCQnIeVmMRoV+AbwZ6OTtJ
         jXgQuNYMPcmDogPOU0f9STWoTlgk6f2goZ6D2hvvxO+Kvt3FpMJYnD/KNaFybKy+WQaq
         irKw==
X-Gm-Message-State: AOAM532+Q+yJZQikamwC2njMMek+izYPG4FRgV/Elq4LkX11FTex4LtB
        XpiAcQZtISbEi0aaTc+J6rEd8qDRobc=
X-Google-Smtp-Source: ABdhPJzDJe6RG1R6CFv4PyI3kz6h2OZBhalOq3sWRQX107uJCy6Z9sEu6/7T5WqnCSiXcRX/RnlUnwRfW6o=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:2fc5:: with SMTP id v188mr1593060ybv.140.1619059114437;
 Wed, 21 Apr 2021 19:38:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:38:31 -0700
Message-Id: <20210422023831.3473491-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH] KVM: VMX: Intercept FS/GS_BASE MSR accesses for 32-bit KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable pass-through of the FS and GS base MSRs for 32-bit KVM.  Intel's
SDM unequivocally states that the MSRs exist if and only if the CPU
supports x86-64.  FS_BASE and GS_BASE are mostly a non-issue; a clever
guest could opportunistically use the MSRs without issue.  KERNEL_GS_BASE
is a bigger problem, as a clever guest would subtly be broken if it were
migrated, as KVM disallows software access to the MSRs, and unlike the
direct variants, KERNEL_GS_BASE needs to be explicitly migrated as it's
not captured in the VMCS.

Fixes: 25c5f225beda ("KVM: VMX: Enable MSR Bitmap feature")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Note, this breaks kvm-unit-tests on 32-bit KVM VMX due to the boot code
using WRMSR(MSR_GS_BASE).  But, the tests are already broken on SVM, and
have always been broken on SVM, which is honestly the main reason I
didn't just turn a blind eye.  :-)  I post the fix shortly.

 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8b111682fe5c..0f8c118ebc35 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -614,6 +614,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	}
 
 	/* KVM unconditionally exposes the FS/GS base MSRs to L1. */
+#ifdef CONFIG_X86_64
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_FS_BASE, MSR_TYPE_RW);
 
@@ -622,6 +623,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 
 	nested_vmx_disable_intercept_for_msr(msr_bitmap_l1, msr_bitmap_l0,
 					     MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+#endif
 
 	/*
 	 * Checking the L0->L1 bitmap is trying to verify two things:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6501d66167b8..b58dc2d454f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -157,9 +157,11 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
 	MSR_IA32_PRED_CMD,
 	MSR_IA32_TSC,
+#ifdef CONFIG_X86_64
 	MSR_FS_BASE,
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
+#endif
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
 	MSR_IA32_SYSENTER_EIP,
@@ -6969,9 +6971,11 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
+#ifdef CONFIG_X86_64
 	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+#endif
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-- 
2.31.1.498.g6c1eba8ee3d-goog

