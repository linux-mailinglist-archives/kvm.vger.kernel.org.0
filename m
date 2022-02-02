Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE4A4A7B6C
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347982AbiBBXEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 18:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347564AbiBBXEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 18:04:39 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CC8C06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 15:04:39 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id g7-20020a5ec747000000b00612ad6f568cso555431iop.8
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 15:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MIwCYZH3r3Ceo/mjnKh2jsf8QZJx6ARLg+NOdUzNo8g=;
        b=EiubVy2lkr2XETIZVGdTjG9TOJpYOGAn1pMCwwW5wBHcFg3tmmlS/vpLEFy54wsh2z
         Ikk3DreBXUX9RZJ6Ki/J1vuer5L4JEvUnwhYKYPdFfp/vDpjqnFZQEEdKi90ZgnhNoon
         WYxoENIwwuYJVi+y2H7nxeURzX6r3xrUq0L97biFzXeTkUBeztsnFt8A4JqHrzN4RSDx
         zazXxmJ5OK7kw/iS4onaHm/NouJVVRN3jn+uyvSwInDWzVRl3OQcmUXJaiTvtWN9XcNS
         yUVsXzMn+UIKnvkbF1SkrXlRhm4O3zQA0tKffNZCqGkhY+1b6YSU5toyAK1B4FQBe4XC
         0BDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MIwCYZH3r3Ceo/mjnKh2jsf8QZJx6ARLg+NOdUzNo8g=;
        b=A/J1ryGJCAx/w9QzOp4+k4AlSQqyEaVbe3aP77HxzmxUq2K/9/PZV996yU4DY6p16e
         0UXdjtjl2svzfR/u0/3hYPF4s40SyahHJA5xOv39XrkLpds/20LiwnlAzIHikQDdKZjL
         OKqpC72T/keisAy5a4wZ0QkQXMOApq5nlYWUXcHRnaoXwe1JnokB5ep/xXRkQszcxxRH
         Hl0E6ClFtpmGT3XRgQ2QjwvLdwzU0VrW1E3pHHfmTU8LBMukuNgVphUT6rAnK0miu9J0
         XPUO2yyQ2aaBb8y8egMlxS61v2VMAOFVa9lfU9CAnssE5rZhgF1Fetn4hjmh9ZLbbCPj
         d/SQ==
X-Gm-Message-State: AOAM533C7p1YEb4SID+qpfJsQGR6Bpynvq4fYFfAoc6dqBDkHu0FAV4x
        wQ+MUUCc2fMliaXQgAUlFV5WBdXZi4eZaYA67G+oY8DISPVL4CcvY9AaFzc+qQpxDtT57r/edg5
        jvcvzgV7rXOiwSCbuflUURTCxV73z3fdLMKWIhc2Ol/KyuZg3v78LNXYsmQ==
X-Google-Smtp-Source: ABdhPJyPVM51RZ0HisgZs/067U/34F/AvxhnJ2Y2bffbTftEjszveYhNgpg484n0Qu862FOgjJ0WLMvqRRY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b0a:: with SMTP id
 i10mr19869107ilv.21.1643843078787; Wed, 02 Feb 2022 15:04:38 -0800 (PST)
Date:   Wed,  2 Feb 2022 23:04:30 +0000
In-Reply-To: <20220202230433.2468479-1-oupton@google.com>
Message-Id: <20220202230433.2468479-2-oupton@google.com>
Mime-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 1/4] KVM: nVMX: Don't change VM-{Entry,Exit} ctrl MSRs on PMU
 CPUID update
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ultimately, it is up to userspace to decide what capabilities should be
advertised to the guest, including the VMX capability MSRs. Furthermore,
there shouldn't be any ordering requirements around the KVM_SET_MSR and
KVM_SET_CPUID2 ioctls. However, KVM has not respected the values written
by userspace for IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS. Instead, KVM
updates the value of these MSRs when CPUID is changed. If userspace
advertises a PMU to the guest that supports IA32_PERF_GLOBAL_CTRL
(CPUID.0AH:EAX[7:0] > 1), KVM will adjust the values for
MSR_IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS to unconditionally advertise the
"load IA32_PERF_GLOBAL_CTRL" control bit (or not, if the PMU doesn't
support the MSR).

The end result of these shenanigans is that VMMs that clear the "load
PERF_GLOBAL_CTRL" bits before setting CPUID will see the bits re-enabled
if it provides a supporting vPMU to the guest. Only if the MSR writes
happen after setting CPUID will userspace's intentions be upheld.

Since there are no ordering expectations around these ioctls, fix the
issue by simply not touching the VMX capability MSRs during an update
to guest CPUID. Note that the "load IA32_PERF_GLOBAL_CTRL" bits are
already set by default in the respective VMX capability MSRs,
if supported by hardware.

Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 21 ---------------------
 arch/x86/kvm/vmx/nested.h    |  1 -
 arch/x86/kvm/vmx/pmu_intel.c |  2 --
 3 files changed, 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ba34e94049c7..4ed2409c2bd7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4797,27 +4797,6 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx;
-
-	if (!nested_vmx_allowed(vcpu))
-		return;
-
-	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
-		vmx->nested.msrs.entry_ctls_high |=
-				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		vmx->nested.msrs.exit_ctls_high |=
-				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-	} else {
-		vmx->nested.msrs.entry_ctls_high &=
-				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		vmx->nested.msrs.exit_ctls_high &=
-				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-	}
-}
-
 static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 				int *ret)
 {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b69a80f43b37..14ad756aac46 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,7 +32,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 466d18fc0c5d..ad1adbaa7d9e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -541,8 +541,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
-
 	if (intel_pmu_lbr_is_compatible(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
-- 
2.35.0.rc2.247.g8bbb082509-goog

