Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333FB542701
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443520AbiFHBAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385323AbiFGXjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187CF22E689
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso9797631pjd.6
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WZpB3yHrMHQls3IHqVi5lPdjdnlbxe8rlI8VYkmKcTg=;
        b=qgrHcXETJXkpmlZPmQS/NOZ+KytYM0pxovZrSQu80fEFQAeT1XKVcSb9kzkmZup4eE
         5Wlr/4msmFRYT9gS5ET8AIj5cPDazkEpx2qKO7C2NUUnVjeri8WGTVZCJU6yjeH38DuL
         /Ei3bG7FuhJVV1lcd7w3GEuVXCx45srEvSrlYsdeDjz63sMPqNcUDzgzgKBvae9f6TvS
         +XxUBg67gMqW++6V+yGem7WOz27qunQPbP1PPfEXM9AcmMycnB0WPxTVH5MrTNeCTBEa
         q+jZL1ixhaqja25GsCBXcaHv2fWCOR8f4wl57m0b1tsIHPfsx10T72usJJum5N7k3cJD
         OlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WZpB3yHrMHQls3IHqVi5lPdjdnlbxe8rlI8VYkmKcTg=;
        b=lkxwUGRWjKp+FfpedXadvVHpNCB3luF+074aTYCl1T18QZ86FbJJLVDxJLuL73PM+r
         ABparja6xzJ2hxodGx2kDVDQX7a/KGLEEiRgWRHr/t4nozeaEQ7ZHj+Ek0P8GkrnqKo0
         DfUrobxg+iJ9kxHj+yyKGUyt08gr/QBGkLIk9F/wvYewxSWE2K9phjjga2MqDQSFvW1N
         ha5tV7zvQin2/Km/Ggc8nthj92Z+EMBRMBiVCWit0mn999qdwUpcOHdVrO1YrJHgAucw
         3DXJH9xzrQWi03SPy/anpdeMqIYCe6i3xo2XvzU8ufZEY69QbK52WHJP4GCgrEdfHZLF
         NtRg==
X-Gm-Message-State: AOAM532zoBTpwf6m+pIpQLitsZgcQJFScnd36N/ZHh0RDCqwTrTu/IaU
        KXTBBZY3hll3M9yL7STuU1m1Ku7A1ts=
X-Google-Smtp-Source: ABdhPJycgDWrLZOXZYxn7zpkwQ3Ufqj9H70i8GawTN7PJv9ONWWssntAX0LWLtrHHvzpYelwHn301CR9IPM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:d045:0:b0:51b:fcf6:3add with SMTP id
 p66-20020a62d045000000b0051bfcf63addmr17692776pfg.68.1654637795122; Tue, 07
 Jun 2022 14:36:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:59 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 10/15] KVM: nVMX: Add a quirk for KVM tweaks to VMX MSRs
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

From: Oliver Upton <oupton@google.com>

Quirk KVM's misguided behavior of manipulating VMX MSRs based on guest
CPUID state.  There is no requirement, at all, that a CPU support
virtualizing a feature if said feature is supported in bare metal.  I.e.
the VMX MSRs exist independent of CPUID for a reason.

One could argue that disabling features, as KVM does for the entry/exit
controls for the IA32_PERF_GLOBAL_CTRL and IA32_BNDCFGS MSRs, is correct
as such a configuration is contradictory, but KVM's policy is to let
userspace have full control of the guest vCPU model so long as the host
kernel is not at risk.  Furthermore, mucking with the VMX MSRs creates a
subtle, difficult to maintain ABI as KVM must ensure that any internal
changes, e.g. to how KVM handles _any_ guest CPUID changes, yield the
same functional result.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  | 21 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  5 +++--
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 42a1984fafc8..1095692ddab7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7374,6 +7374,27 @@ The valid bits in cap.args[0] are:
                                     hypercall instructions. Executing the
                                     incorrect hypercall instruction will
                                     generate a #UD within the guest.
+
+ KVM_X86_QUIRK_TWEAK_VMX_MSRS       By default, during a guest CPUID update,
+                                    KVM adjusts the values of select VMX MSRs
+                                    (usually based on guest CPUID):
+
+                                    - If CPUID.07H:EBX[bit 14] (MPX) is set, KVM
+                                      sets IA32_VMX_TRUE_ENTRY_CTLS[bit 48]
+                                      ('load IA32_BNDCFGS') and
+                                      IA32_VMX_TRUE_EXIT_CTLS[bit 55]
+                                      ('clear IA32_BNDCFGS'). Otherwise, these
+                                      corresponding MSR bits are cleared.
+                                    - If CPUID.0AH:EAX[bits 7:0] > 1, KVM sets
+                                      IA32_VMX_TRUE_ENTRY_CTLS[bit 45]
+                                      ('load IA32_PERF_GLOBAL_CTRL') and
+                                      IA32_VMX_TRUE_EXIT_CTLS[bit 44]
+                                      ('load IA32_PERF_GLOBAL_CTRL'). Otherwise,
+                                      these corresponding MSR bits are cleared.
+
+                                    When this quirk is disabled, KVM will not
+                                    change the values of the aformentioned VMX
+                                    MSRs during guest CPUID updates.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6cf5d77d7896..a783c82fb902 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2011,6 +2011,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
-	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN)
+	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
+	 KVM_X86_QUIRK_TWEAK_VMX_MSRS)
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 24c807c8d5f7..0705178bd93d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -438,6 +438,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP		(1 << 3)
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
+#define KVM_X86_QUIRK_TWEAK_VMX_MSRS		(1 << 6)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4ba0e5540908..dc2f9b06b99a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1301,8 +1301,9 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	 * To preserve an old, kludgy ABI, ensure KVM fiddling with the "true"
 	 * entry/exit controls MSRs is preserved after userspace modifications.
 	 */
-	if (msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
-	    msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS)
+	if ((msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
+	     msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS) &&
+	    kvm_check_has_quirk(vmx->vcpu.kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS))
 		nested_vmx_entry_exit_ctls_update(&vmx->vcpu);
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 73ec4746a4e6..4c31c8f24329 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7522,7 +7522,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	if (nested_vmx_allowed(vcpu)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
-		nested_vmx_entry_exit_ctls_update(vcpu);
+		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_MSRS))
+			nested_vmx_entry_exit_ctls_update(vcpu);
 	}
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-- 
2.36.1.255.ge46751e96f-goog

