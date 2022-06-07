Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6667854231F
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391343AbiFHBAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 21:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381432AbiFGXjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF29122E681
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h11-20020a65638b000000b003fad8e1cc9bso9186202pgv.2
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QDhCTBvKksOgW3yltrev1z9m075RHWrH68Rp9z9odIU=;
        b=eHTU7XIQc58CpLgbBEygq7L2SQypYU0MagyyVlUopG1gE8AJx0F+aZHvE2r/hK415I
         qjsF+JPz+x6DvnKHVEuc1z7WLvdvsp6CDXL9dK+ZA48Sv6mIak40kdM5QBe/K5hKO1GD
         TtdcZCGYCBp3P2992BGn3vfIpsKsvWzkEsiB5RcuttYS2oMjNrwYhJE2nn2HWYxmrMoi
         WB4R3K4sNeo4D5O286ILY17iJm1pEQKGPNnTUga8shI3bUNo0fWv2M7ZhkP+oAhm1yEz
         rK4eyhIlwxNnitq/y5Xu32ygJuUgOVbbtmQi8YE2Xu3vm2Tl/FsWOJ9KVXoxWg8Ftidp
         58AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QDhCTBvKksOgW3yltrev1z9m075RHWrH68Rp9z9odIU=;
        b=N14iqSsuJV1fOdcDVQMqdmW3I0xIqWtMeCROjcNKSaNxFHSjZ/kMrkiAa0Ui2mFSl9
         PpGwsnmaNNEAS41tn1hr8cEOnMsqb8w3RkBdWGxgiACwLOUPHisSBrb3afA6Nl3YCI3i
         c3vFshZaLAobJeheuVifJXKLn0MxlPwdAIFcw6OhuGGpBKS6UJrrtHZTt9eL0y3WVkwl
         SqcRuYJcREOoel7lMx7PH3egDfWYghov7uYgD7Ua6C/+usLqsKUTjcvdD5n1R9yexWHL
         XCnyF+k5KI8TkVi6zu5Ku1AOcGj2pBUXO0MWYGu7PTC1vyNGpTVwTWLEk6t2SpOPqpK1
         kzgQ==
X-Gm-Message-State: AOAM5319oTAzoESMGYXlZcrlc+2GKZjZcyvi5PgqPL4hQ4u3z+K2TyzE
        e6meqC3HZO0KmPWrNyVk6rHq1WWQAlc=
X-Google-Smtp-Source: ABdhPJx/KMFWqCTxyQ9O6UQQqXbMKyHRzRmss/NznagKocVXY9AyFHedpTFWR5JWygryIHwK8G21Q8StQbs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:df14:b0:1e3:33ba:a94 with SMTP id
 gp20-20020a17090adf1400b001e333ba0a94mr33864474pjb.83.1654637788240; Tue, 07
 Jun 2022 14:36:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:35:55 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 06/15] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
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

Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
when guest MPX disabled"), KVM has taken ownership of the "load
IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
MSRs if the guest's CPUID supports MPX, and clear otherwise.

However, commit aedbaf4f6afd ("KVM: x86: Extract
kvm_update_cpuid_runtime() from kvm_update_cpuid()") partially broke KVM
ownership of the aforementioned bits. Before, kvm_update_cpuid() was
exercised frequently when running a guest and constantly applied its own
changes to the BNDCFGS bits. Now, the BNDCFGS bits are only ever
updated after a KVM_SET_CPUID/KVM_SET_CPUID2 ioctl, meaning that a
subsequent MSR write from userspace will clobber these values.

Uphold the old ABI by reapplying KVM's tweaks to the BNDCFGS bits after
an MSR write from userspace.

Note, the old ABI that is being preserved is a KVM hack to workaround a
userspace bug; see commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX
controls when guest MPX disabled").  VMCS controls are not tied to CPUID,
i.e. KVM should not be mucking with unrelated things.  The argument that
it's KVM's responsibility to propagate CPUID state to VMX MSRs doesn't
hold water, as the MPX shenanigans are an exception, not the norm, e.g.
KVM doesn't perform the following adjustments (and this is but a subset
of all possible tweaks):

  X86_FEATURE_LM => VM_EXIT_HOST_ADDR_SPACE_SIZE, VM_ENTRY_IA32E_MODE,
                    VMX_MISC_SAVE_EFER_LMA

  X86_FEATURE_TSC => CPU_BASED_RDTSC_EXITING, CPU_BASED_USE_TSC_OFFSETTING,
                     SECONDARY_EXEC_TSC_SCALING

  X86_FEATURE_INVPCID_SINGLE => SECONDARY_EXEC_ENABLE_INVPCID

  X86_FEATURE_MWAIT => CPU_BASED_MONITOR_EXITING, CPU_BASED_MWAIT_EXITING

  X86_FEATURE_INTEL_PT => SECONDARY_EXEC_PT_CONCEAL_VMX, SECONDARY_EXEC_PT_USE_GPA,
                          VM_EXIT_CLEAR_IA32_RTIT_CTL, VM_ENTRY_LOAD_IA32_RTIT_CTL

  X86_FEATURE_XSAVES => SECONDARY_EXEC_XSAVES

Fixes: aedbaf4f6afd ("KVM: x86: Extract kvm_update_cpuid_runtime() from kvm_update_cpuid()")
Signed-off-by: Oliver Upton <oupton@google.com>
[sean: explicitly document the original KVM hack]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fca30e79b3a0..d1c21d387716 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1296,6 +1296,15 @@ vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 	vmx_get_control_msr(&vmx->nested.msrs, msr_index, &lowp, &highp);
 	*lowp = data;
 	*highp = data >> 32;
+
+	/*
+	 * To preserve an old, kludgy ABI, ensure KVM fiddling with the "true"
+	 * entry/exit controls MSRs is preserved after userspace modifications.
+	 */
+	if (msr_index == MSR_IA32_VMX_TRUE_ENTRY_CTLS ||
+	    msr_index == MSR_IA32_VMX_TRUE_EXIT_CTLS)
+		nested_vmx_entry_exit_ctls_update(&vmx->vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57df799ffa29..3f1671d7cbe4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7398,7 +7398,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 #undef cr4_fixed1_update
 }
 
-static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
+void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 71bcb486e73f..576fed7e33de 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -425,6 +425,8 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
  * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
-- 
2.36.1.255.ge46751e96f-goog

