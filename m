Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0884D54248C
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390064AbiFHBAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382840AbiFGXjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AD422EFDB
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a68-20020a25ca47000000b006605f788ff1so12671360ybg.16
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=liucOeq+i8wBW37ckX9CitJW/au6CJxD8EZtE2Dscgc=;
        b=IN4fgLOAlV1KfJqGAahoaf3ef2R61NuhCc8Zcuigfom73c04gZoF4gqmTlUtsMkVpC
         JJjG5PLhtp0idJcE3GQZIUcLYjAFyliljLpmJEtskP/d9vDA+SUVMTiFr2hP1UxPLYHS
         l6qT8pIGPWE5c8PmBss+TQAa+aDolxVsk5hpUIWrgBd/eOL+Ni75YM8tBNHcv5KC2108
         hX4vi4h52X6J7ztyPP6LvuYeEc4Q8rr/3H40NyyOkO82MsQgFndVerbRD480mQnmy87g
         d0+G/e3Pf8MNkO8RgEMH0iZYVzv21SEneAUSiIpjkqmdtoD+EB3MUXh+XkggzrR2H7DJ
         wsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=liucOeq+i8wBW37ckX9CitJW/au6CJxD8EZtE2Dscgc=;
        b=8Qs2KINAO3rcPsp0fFGcK4TY+sg4vdwZHtW/Mp04sAyNTqO6sVRteDB9Ms2+bNV2Tx
         7oovEKPbJVftIYqvBXKrjpDRUasTzt9k68sSx7FGbLllE5bI24FyYGxArRiLtSxv9YbB
         JggUw2AOa3koqcEVqKXrqrr+XDPUSs9XmfmF+5GmhTPuJQ1QDK+11tIZFS5bFkPZ8q/i
         7auy2KgIZ1VFR04JfMtetZwx5uptlpLhvKHfscCb2C71zpynXAucfSlLLPiXeJ/7YdYd
         MehJyLIuckvc1yD3QHrA0daK23NAKelD1vffYwnPMiGLjCyGtkgnf6aU28Ilpr18qpjE
         1Okg==
X-Gm-Message-State: AOAM533nSlHIQLyd3P3rSo5VcezsmSB1y2mRaJDJ9CYfCTOIbhtkRiVo
        mKMT8LEiN+PVZaG/RZexHs5Ev4I0eOI=
X-Google-Smtp-Source: ABdhPJwaMXUoyu3EtfXs0KZLcGC4hnzNLLKfYxjZfrDEVK3xRQ3CoJWyKoyj8BCWfKvB0yvC4Lb3ZojZyZM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:9d5:0:b0:2f4:dd93:4513 with SMTP id
 204-20020a8109d5000000b002f4dd934513mr33067623ywj.54.1654637798700; Tue, 07
 Jun 2022 14:36:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:36:01 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 12/15] KVM: nVMX: Extend VMX MSRs quirk to CR0/4 fixed1 bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the VMX MSRs quirk to the CR0/4_FIXED1 MSRs, i.e. when the quirk
is disabled, allow userspace to set the MSRs and do not rewrite the MSRs
during CPUID updates.  The bits that the guest (L2 in this case) is
allowed to set are not directly tied to CPUID.  Enumerating to L1 that it
can set reserved CR0/4 bits is nonsensical and will ultimately result in
a failed nested VM-Entry (KVM enforces guest reserved CR4 bits on top of
the VMX MSRs), but KVM typically doesn't police the vCPU model except
when doing so is necessary to protect the host kernel.

Further restricting CR4 bits is however a reasonable thing to do, e.g. to
work around a bug in nested virtualization, in which case exposing a
feature to L1 is ok, but letting L2 use the feature is not.  Of course,
whether or not the L1 hypervisor will actually _check_ the FIXED1 bits is
another matter entirely, e.g. KVM currently assumes all bits that can be
set in the host can also be set in the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  8 ++++++++
 arch/x86/kvm/vmx/nested.c      | 33 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c         |  6 +++---
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1095692ddab7..88d1bbae031e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7391,6 +7391,14 @@ The valid bits in cap.args[0] are:
                                       IA32_VMX_TRUE_EXIT_CTLS[bit 44]
                                       ('load IA32_PERF_GLOBAL_CTRL'). Otherwise,
                                       these corresponding MSR bits are cleared.
+                                    - MSR_IA32_VMX_CR0_FIXED1 is unconditionally
+                                      set to 0xffffffff
+                                    - CR4.PCE is unconditionally set in
+                                      MSR_IA32_VMX_CR4_FIXED1.
+                                    - All CR4 bits with an associated CPUID
+                                      feature flag are set in
+                                      MSR_IA32_VMX_CR4_FIXED1 if the feature is
+                                      reported as supported in guest CPUID.
 
                                     When this quirk is disabled, KVM will not
                                     change the values of the aformentioned VMX
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5533c2474128..abce74cfefc9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1385,6 +1385,30 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	return 0;
 }
 
+static u64 *vmx_get_fixed1_msr(struct nested_vmx_msrs *msrs, u32 msr_index)
+{
+	switch (msr_index) {
+	case MSR_IA32_VMX_CR0_FIXED1:
+		return &msrs->cr0_fixed1;
+	case MSR_IA32_VMX_CR4_FIXED1:
+		return &msrs->cr4_fixed1;
+	default:
+		BUG();
+	}
+}
+
+static int vmx_restore_fixed1_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
+{
+	const u64 *msr = vmx_get_fixed1_msr(&vmcs_config.nested, msr_index);
+
+	/* Bits that "must-be-0" must not be set in the restored value. */
+	if (!is_bitwise_subset(*msr, data, -1ULL))
+		return -EINVAL;
+
+	*vmx_get_fixed1_msr(&vmx->nested.msrs, msr_index) = data;
+	return 0;
+}
+
 /*
  * Called when userspace is restoring VMX MSRs.
  *
@@ -1432,10 +1456,13 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_CR0_FIXED1:
 	case MSR_IA32_VMX_CR4_FIXED1:
 		/*
-		 * These MSRs are generated based on the vCPU's CPUID, so we
-		 * do not support restoring them directly.
+		 * These MSRs are generated based on the vCPU's CPUID when KVM
+		 * "owns" the VMX MSRs, do not allow restoring them directly.
 		 */
-		return -EINVAL;
+		if (kvm_check_has_quirk(vmx->vcpu.kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS))
+			return -EINVAL;
+
+		return vmx_restore_fixed1_msr(vmx, msr_index, data);
 	case MSR_IA32_VMX_EPT_VPID_CAP:
 		return vmx_restore_vmx_ept_vpid_cap(vmx, data);
 	case MSR_IA32_VMX_VMCS_ENUM:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4c31c8f24329..139f365ca6bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7520,10 +7520,10 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
 
-	if (nested_vmx_allowed(vcpu)) {
+	if (nested_vmx_allowed(vcpu) &&
+	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
-		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS))
-			nested_vmx_entry_exit_ctls_update(vcpu);
+		nested_vmx_entry_exit_ctls_update(vcpu);
 	}
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-- 
2.36.1.255.ge46751e96f-goog

