Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49CF54270A
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384395AbiFHA7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 20:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578998AbiFGXjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 19:39:09 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCFD40078A
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 14:36:41 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k92-20020a17090a4ce500b001e69e8a98a4so7215442pjh.3
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 14:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A1QzBL/Nmqz2F6BNd27eYTxcbJ/pZ61eqO0oiIixNDI=;
        b=Db1SvxBIb2DsUy46A0dAj6+ZmFkSPF27w+9DEhO6qhsgUf1mF7uhTxBpIVMqodwop5
         hl59ox8ukdMh6gqTO+TVRsOjuVyydSw2Ch1+iQ/51z02ULBPNGGCVBXCXHZBJORabQQr
         yAzTWmdbP0G9QqrpoF3qp/mF7nwOdbY42N40ypztvPYkD0GmhkGpohsNNbVO+nOi+Oln
         DH17NxAMQLpue4YNQP5sL5WKI1253rM1qQXwoXI0lpgbsV+h1fwSAqzsZvx7NIVn/rAP
         An5btIOpDLEhQZH4+DjuuhfSi82Ddfcgkmptvjtp3mAMupEcgw9OenMvw78lId0WAxkl
         42mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A1QzBL/Nmqz2F6BNd27eYTxcbJ/pZ61eqO0oiIixNDI=;
        b=K50+kj8vuOADbVTPWX4rgCV5ZGdEunzEKtp+sX1ra0CopkyovCTISZGGsN40RBIwdK
         ueiwtxnhDMCvNlPOgDia9WoramIJz1gB7v79JHXMV5GBpjTmsmgTPQH11NmspUa6sXfy
         4KZOd/i44QE5q3LU3dAENSDlNlAqlmGl+hDi3zYW/T9aDGqJWzr15yzXJoMiXcjmOCw6
         zkYlDUxeQOw+QT8l7dUgGiZZ0epD50Mvz7dVlCSElajW5SbB7HrHcNf/+ssFjF1CmPHG
         l99jT64P/GwBNSHSc87e4nCJk523PuuUm5Q9IgIBopOQGsQ33xIroIjYAIHdbvugg3Tk
         Ll7Q==
X-Gm-Message-State: AOAM5306H/VWYNMu09WmVytrBsOn8piI+b666+KZ/5Kx+aFiuIyQJrEo
        jwwEC0hODKD2vODdipz3fIzotR8qb90=
X-Google-Smtp-Source: ABdhPJy3l2yd61SiPhtcX+F+gl5mfqfQO84DcbbvRYxt/Y/zuLGXuz0A4cZ3aBAfXillFcWAGIViKSVWEhM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a8f:b0:51c:2f82:cdba with SMTP id
 e15-20020a056a001a8f00b0051c2f82cdbamr7674725pfv.85.1654637800483; Tue, 07
 Jun 2022 14:36:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Jun 2022 21:36:02 +0000
In-Reply-To: <20220607213604.3346000-1-seanjc@google.com>
Message-Id: <20220607213604.3346000-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220607213604.3346000-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 13/15] KVM: selftests: Add test to verify KVM's VMX MSRs
 quirk for controls
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

Add a test to verify KVM's established ABI with respect to the entry/exit
controls for PERF_GLOBAL_CTRL and BNDCFGS.  KVM has a quirk where KVM
updates the VMX "true" entry/exit control MSRs to force PERF_GLOBAL_CTRL
and BNDCFGS to follow the guest CPUID model, i.e. set when supported,
clear when not, even though the MSR values are not strictly associated
with CPUID.  Note, KVM's ABI is that its modifications to the MSRs are
preserved even when userspace explicitly writes the MSRs.

Verify that KVM correctly tweaks the MSRs When the quirk is enabled (the
default behavior), and does not touch them when the quirk is disabled.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/include/x86_64/vmx.h        |   2 +
 .../selftests/kvm/x86_64/vmx_msrs_test.c      | 161 ++++++++++++++++++
 5 files changed, 166 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0ab0e255d292..5893804b5196 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -47,6 +47,7 @@
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_exception_with_invalid_guest_state
 /x86_64/vmx_invalid_nested_guest_state
+/x86_64/vmx_msrs_test
 /x86_64/vmx_preemption_timer_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 9a256c1f1bdf..2ee2dc55c100 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -74,6 +74,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 3fd3d58148c2..51cab9b080f7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -98,6 +98,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_SMEP	        KVM_X86_CPU_FEATURE(0x7, 0, EBX, 7)
 #define	X86_FEATURE_INVPCID		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 10)
 #define	X86_FEATURE_RTM			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 11)
+#define	X86_FEATURE_MPX			KVM_X86_CPU_FEATURE(0x7, 0, EBX, 14)
 #define	X86_FEATURE_SMAP		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 20)
 #define	X86_FEATURE_PCOMMIT		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 22)
 #define	X86_FEATURE_CLFLUSHOPT		KVM_X86_CPU_FEATURE(0x7, 0, EBX, 23)
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index fe0ebb790b49..5a6002b34d2b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -80,6 +80,7 @@
 #define VM_EXIT_SAVE_IA32_EFER			0x00100000
 #define VM_EXIT_LOAD_IA32_EFER			0x00200000
 #define VM_EXIT_SAVE_VMX_PREEMPTION_TIMER	0x00400000
+#define VM_EXIT_CLEAR_BNDCFGS			0x00800000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -90,6 +91,7 @@
 #define VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL	0x00002000
 #define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 #define VM_ENTRY_LOAD_IA32_EFER			0x00008000
+#define VM_ENTRY_LOAD_BNDCFGS			0x00010000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
new file mode 100644
index 000000000000..9be2c2e3acf1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VMX control MSR test
+ *
+ * Copyright (C) 2022 Google LLC.
+ *
+ * Tests for KVM ownership of bits in the VMX entry/exit control MSRs. Checks
+ * that KVM will set owned bits where appropriate, and will not if
+ * KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS is disabled.
+ */
+
+#include "kvm_util.h"
+#include "vmx.h"
+
+#define SUBTEST_REQUIRE(f)					\
+	if (!(f)) {						\
+		print_skip("Requirement not met: %s", #f);	\
+		return;						\
+	}
+
+static bool vmx_has_ctrl(struct kvm_vcpu *vcpu, uint32_t msr, uint32_t ctrl_mask)
+{
+	return (vcpu_get_msr(vcpu, msr) >> 32) & ctrl_mask;
+}
+
+static void test_vmx_ctrl_msr(struct kvm_vcpu *vcpu,
+			      uint32_t msr, uint64_t ctrl_mask,
+			      bool quirk_enabled, bool feature_enabled)
+{
+	uint64_t ctrl_allowed1 = ctrl_mask << 32;
+	uint64_t val = vcpu_get_msr(vcpu, msr);
+
+	/*
+	 * If the quirk is enabled, KVM should have modified the MSR when the
+	 * guest's CPUID was set.  Don't assert anything when the quirk is
+	 * disabled, the value of the MSR is not known (it could be made known,
+	 * but it gets messy and the added value is minimal).
+	 */
+	TEST_ASSERT(!quirk_enabled || (!!(val & ctrl_allowed1) == feature_enabled),
+		    "KVM owns the ctrl when the quirk is enabled, want 0x%lx, got 0x%lx",
+		    feature_enabled ? ctrl_allowed1 : 0, val & ctrl_allowed1);
+
+	val |= ctrl_allowed1;
+	vcpu_set_msr(vcpu, msr, val);
+
+	val = vcpu_get_msr(vcpu, msr);
+	if (quirk_enabled)
+		TEST_ASSERT(!!(val & ctrl_allowed1) == feature_enabled,
+			    "KVM owns the ctrl when the quirk is enabled, want 0x%lx, got 0x%lx",
+			    feature_enabled ? ctrl_allowed1 : 0, val & ctrl_allowed1);
+	else
+		TEST_ASSERT(val & ctrl_allowed1,
+			    "KVM shouldn't clear the ctrl when the quirk is disabled");
+
+	val &= ~ctrl_allowed1;
+	vcpu_set_msr(vcpu, msr, val);
+
+	val = vcpu_get_msr(vcpu, msr);
+	if (quirk_enabled)
+		TEST_ASSERT(!!(val & ctrl_allowed1) == feature_enabled,
+			    "KVM owns the ctrl when the quirk is enabled, want 0x%lx, got 0x%lx",
+			    feature_enabled ? ctrl_allowed1 : 0, val & ctrl_allowed1);
+	else
+		TEST_ASSERT(!(val & ctrl_allowed1),
+			    "KVM shouldn't set the ctrl when the quirk is disabled");
+}
+
+static void test_vmx_ctrl_msrs_pair(struct kvm_vcpu *vcpu,
+				    bool quirk_enabled, bool feature_enabled,
+				    uint32_t entry_msr, uint64_t entry_mask,
+				    uint32_t exit_msr, uint64_t exit_mask)
+{
+	test_vmx_ctrl_msr(vcpu, entry_msr, entry_mask, quirk_enabled, feature_enabled);
+	test_vmx_ctrl_msr(vcpu, exit_msr, exit_mask, quirk_enabled, feature_enabled);
+}
+
+static void test_vmx_ctrls(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
+			   uint64_t entry_ctrl, uint64_t exit_ctrl)
+{
+	/*
+	 * KVM's quirky behavior only exists for PERF_GLOBAL_CTRL and BNDCFGS,
+	 * any attempt to extend KVM's quirky behavior must be met with fierce
+	 * resistance!
+	 */
+	TEST_ASSERT(entry_ctrl == VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL ||
+		    entry_ctrl == VM_ENTRY_LOAD_BNDCFGS,
+		    "Don't let KVM expand its quirk beyond PERF_GLOBAL_CTRL and BNDCFSG");
+
+	SUBTEST_REQUIRE(vmx_has_ctrl(vcpu, MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_ctrl));
+	SUBTEST_REQUIRE(vmx_has_ctrl(vcpu, MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_ctrl));
+
+	/*
+	 * Test that, when the quirk is enabled, KVM sets/clears the VMX MSR
+	 * bits based on whether or not the feature is exposed to the guest.
+	 */
+	test_vmx_ctrl_msrs_pair(vcpu, true, true,
+				MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_ctrl,
+				MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_ctrl);
+
+	/* Hide the feature in CPUID. */
+	if (entry_ctrl == VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+		vcpu_clear_cpuid_entry(vcpu, 0xa);
+	else
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MPX);
+
+	test_vmx_ctrl_msrs_pair(vcpu, true, false,
+				MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_ctrl,
+				MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_ctrl);
+
+	/*
+	 * Disable the quirk, giving userspace control of the VMX MSRs.  KVM
+	 * should not touch the MSR, i.e. should allow hiding the control when
+	 * a vPMU is supported, and should allow exposing the control when a
+	 * vPMU is not supported.
+	 */
+	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_TWEAK_VMX_MSRS);
+
+	test_vmx_ctrl_msrs_pair(vcpu, false, false,
+				MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_ctrl,
+				MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_ctrl);
+
+	/* Restore the full CPUID to expose the feature to the guest. */
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
+	test_vmx_ctrl_msrs_pair(vcpu, false, true,
+				MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_ctrl,
+				MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_ctrl);
+
+	vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, 0);
+}
+
+static void load_perf_global_ctrl_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	SUBTEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xa);
+
+	test_vmx_ctrls(vm, vcpu, VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+		       VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+}
+
+static void load_and_clear_bndcfgs_test(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	SUBTEST_REQUIRE(kvm_cpu_has(X86_FEATURE_MPX));
+
+	test_vmx_ctrls(vm, vcpu, VM_ENTRY_LOAD_BNDCFGS, VM_EXIT_CLEAR_BNDCFGS);
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	/* No need to actually do KVM_RUN, thus no guest code. */
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	load_perf_global_ctrl_test(vm, vcpu);
+	load_and_clear_bndcfgs_test(vm, vcpu);
+
+	kvm_vm_free(vm);
+}
-- 
2.36.1.255.ge46751e96f-goog

