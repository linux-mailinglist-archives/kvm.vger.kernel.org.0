Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC9B4C4F4D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiBYUJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiBYUJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:12 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13C01F03AD
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:39 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id a5-20020a92c545000000b002c2875a2a57so4272986ilj.0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dlHVUwHA9h0dD7Efqah9IiFP4/Q+M9gjkciav/AK0yE=;
        b=SnFGWJZ07jUI8EsxmtklnGicBs1Engc4Cuve7ejpmD4FfxSmmvh+sZw27kWx98iXZA
         nohRpOyCOlqHd/5g4znmm+4fTHnQnludLb577ty5dWzkBpQmAz6vg5pyy4dKNk+VWyg9
         i98cDCc10Dtoc+rfS6lTt8dw9GmzB6RTsdvvEpJPxLSkXpIL9ypOEQHfNWu4rWYse08v
         UBv1IAhs7YloDJKOkIr2hy61TGJphhHNjSpi+1VcDECtXK91Jdlsfnjm5kvXQpdTpgnS
         jRKwyHQjZWRRpDNu+khzMO99FPW5B1fy4pj2mI5GU6NikwJr9D3fo5adqoJfEEQgDjrR
         ug5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dlHVUwHA9h0dD7Efqah9IiFP4/Q+M9gjkciav/AK0yE=;
        b=K/rzymF+sDr9CMsoPuThwAICA+KcTs7QCmtkUj9ywaK0aZv0Hpm88iVk6f1y9GYVyX
         ZM8WiBuvyyadt2hAywoBbtS5RE2j0xKHkeK4mWcpayvL7f2OK1EzNnO7IcMEnpDWs0KG
         +m6zQJeR1JeV0mTuO6oXjeHa0oehXayvDOf0TRojIFOjbE0nyjT42Awc0WIDhAaIGx1o
         zX55NXtImjcMpE8590IDd0gr1Z9jEvM0QlWIXYZ+U0Avi8VMZuQpw/gBc+cqZ/WQYpyB
         2zeBhHv7se5B3Bxt8I7cHg4YDFFG4JyQ0WWUlKupYO4FoQSLgnXNBd5Y3/PQagc2vho3
         AS1g==
X-Gm-Message-State: AOAM533Q3ONnd8J9nywquOOUBXuXrJHk+qA2xCMxSQULayYbT5Xx514J
        V92N/QH5itGOovbS6GbsVEFirrfwWctT4MZBI8LXEMWMqh4pT5fQgh7jVdNiOYaALwc0sdRv0uk
        FtpJXBtj7YiGeO5b/9JhHX3aneoT20VdgbdpiOd/j8vdciQV9KxBk3zSySg==
X-Google-Smtp-Source: ABdhPJxtdPWc+WqTh4ad+92IIVMEJNL4uB+gt4H92tuMH7jjBpdqQTW2r2BUd2J7I9ohDbTHaCnhFmjeQoo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:117:0:b0:634:4788:28e1 with SMTP id
 23-20020a6b0117000000b00634478828e1mr6672947iob.72.1645819719051; Fri, 25 Feb
 2022 12:08:39 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:22 +0000
In-Reply-To: <20220225200823.2522321-1-oupton@google.com>
Message-Id: <20220225200823.2522321-6-oupton@google.com>
Mime-Version: 1.0
References: <20220225200823.2522321-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 5/6] selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX
 control MSR bits
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
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

Test that the default behavior of KVM is to ignore userspace MSR writes
and conditionally expose the "load IA32_PERF_GLOBAL_CTRL" bits in the
VMX control MSRs if the guest CPUID exposes a supporting vPMU.
Additionally, test that when the corresponding quirk is disabled,
userspace can still clear these bits regardless of what is exposed in
CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_control_msrs_test.c        | 145 ++++++++++++++++++
 3 files changed, 147 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..044aef3a8574 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -36,6 +36,7 @@
 /x86_64/userspace_io_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
+/x86_64/vmx_control_msrs_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 17c3f0749f05..2d5e1029ee2d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -68,6 +68,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_control_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
new file mode 100644
index 000000000000..ab598d9e7582
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
@@ -0,0 +1,145 @@
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
+#define VCPU_ID 0
+
+static void get_vmx_control_msr(struct kvm_vm *vm, uint32_t msr_index,
+				uint32_t *low, uint32_t *high)
+{
+	uint64_t val;
+
+	val = vcpu_get_msr(vm, VCPU_ID, msr_index);
+	*low = val;
+	*high = val >> 32;
+}
+
+static void set_vmx_control_msr(struct kvm_vm *vm, uint32_t msr_index,
+				uint32_t low, uint32_t high)
+{
+	uint64_t val = (((uint64_t) high) << 32) | low;
+
+	vcpu_set_msr(vm, VCPU_ID, msr_index, val);
+}
+
+static void test_vmx_control_msr(struct kvm_vm *vm, uint32_t msr_index, uint32_t set,
+				 uint32_t clear, uint32_t exp_set, uint32_t exp_clear)
+{
+	uint32_t low, high;
+
+	get_vmx_control_msr(vm, msr_index, &low, &high);
+
+	high &= ~clear;
+	high |= set;
+
+	set_vmx_control_msr(vm, msr_index, low, high);
+
+	get_vmx_control_msr(vm, msr_index, &low, &high);
+	ASSERT_EQ(high & exp_set, exp_set);
+	ASSERT_EQ(~high & exp_clear, exp_clear);
+}
+
+static void clear_performance_monitoring_leaf(struct kvm_cpuid2 *cpuid)
+{
+	struct kvm_cpuid_entry2 ent = {0};
+
+	ent.function = 0xa;
+	TEST_ASSERT(set_cpuid(cpuid, &ent),
+		    "failed to clear Architectual Performance Monitoring leaf (0xA)");
+}
+
+static void load_perf_global_ctrl_test(struct kvm_vm *vm)
+{
+	uint32_t entry_low, entry_high, exit_low, exit_high;
+	struct kvm_enable_cap cap = {0};
+	struct kvm_cpuid2 *cpuid;
+
+	get_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	if (!(entry_high & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) ||
+	    !(exit_high & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
+		print_skip("\"load IA32_PERF_GLOBAL_CTRL\" VM-{Entry,Exit} controls not supported");
+		return;
+	}
+
+	/*
+	 * Test that KVM will set these bits regardless of userspace if the
+	 * guest CPUID exposes a supporting vPMU.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+			     0);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+			     0);
+
+	/*
+	 * Hide vPMU in CPUID
+	 */
+	cpuid = _kvm_get_supported_cpuid();
+	clear_performance_monitoring_leaf(cpuid);
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	free(cpuid);
+
+	/*
+	 * Test that KVM will clear these bits if guest CPUID does not expose a
+	 * supporting vPMU.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0, 0, 0,
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0, 0, 0,
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+
+	/*
+	 * Re-enable vPMU in CPUID
+	 */
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	/*
+	 * Disable the quirk, giving userspace control of the VMX capability
+	 * MSRs.
+	 */
+	cap.cap = KVM_CAP_DISABLE_QUIRKS;
+	cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
+	vm_enable_cap(vm, &cap);
+
+	/*
+	 * Test that userspace can clear these bits, even if it exposes a vPMU
+	 * that supports IA32_PERF_GLOBAL_CTRL.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, 0,
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+			     0,
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, 0,
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+			     0,
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+
+	nested_vmx_check_supported();
+
+	/* No need to run a guest for these tests */
+	vm = vm_create_default(VCPU_ID, 0, NULL);
+
+	load_perf_global_ctrl_test(vm);
+
+	kvm_vm_free(vm);
+}
-- 
2.35.1.574.g5d30c73bfb-goog

