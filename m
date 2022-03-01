Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E234C83B3
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiCAGE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiCAGEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:53 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AB060D8C
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:12 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id t19-20020a6b5f13000000b0064041171126so10001039iob.10
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Y2gSRLlIKfwt3PQVIyDoXWHcSD0YLnemOsWtBee5UcE=;
        b=O2171eiQcwgZrQdczAyEjwekP2a1oVK9UaDdJVfFrhnbKRN6EioIpb/4zBdDu+ggMt
         NWnYdo0lWT1+JMqj4d70p2Kd7k7GKrW1VcD1EL+s3+W5j0/EXtr3BVpgbq8yCcg14dQs
         ezfQtREnfgyDy+OuDbmr3tNuQNgpKStG7nNt870UmE6IRwKPSyoeW4ueHIsaLCD1C5gt
         Yooyb66XN11dRqz1aWasc95GN2LutdR8Nws8rg9kt7jsK9s3ykyVJOi7aisbOamUCmOF
         Q0KUJAxHFNakmqTug4qk6QqB/VMgYcvcddbHqjlaC5zl6TFo+EVUJebpBficaKKPymqq
         Upqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y2gSRLlIKfwt3PQVIyDoXWHcSD0YLnemOsWtBee5UcE=;
        b=asWwR+ScZ05JXdOdyE46Gz4AxoSgTiLGzBL0cFMWaKu4UJB7Yu5j3uAg41SDZ05us6
         HhEFAdEmUwiwZsSz/Vwyin82gSuQ2Yvzd/EMZoHRDMDYKHdWJ0JYMCFMFvlDh/YHqX+Z
         eGuXhyatnVzAY3hDMv15W8dfObutqk36LthJGL4UGlJcWo1raQMb78pdxqBkZp8M+gEI
         kjmi7vobr6t3KsvH+qTtpDleo56eMS9NbrNs0r/IonRT7Gumxq06BWZS+BCoyz1l3aie
         ctkK/HnLBetCddJPxseNhbxUgjOW3eS5/MuW6MNUpUt1SSbxP0DCGxoVSSaWL1M4Lkvh
         1vog==
X-Gm-Message-State: AOAM531oSi5sGFxeRY4jQpmoJH38WM4yq9wacz5L3r5+y9Sh2ji9x2rB
        ni3wo9Mhdj/b2myzJGKxgFBl3ofehbUNq/XBGME1fytg4+joxKdGpP/oFswvgKKxD+WgYesWVGo
        EUtCHQ4ywkqRgZR8gqmW9G3Yt0YUDFS3f22a6CJcjlovYN+7DYxZ6Ia4g/Q==
X-Google-Smtp-Source: ABdhPJytl9V64tirtkgvEMVF0jOJofhG4nX1Vn+7CNatEitq0Vqa/Xaony2JLwHzUAK8/ew4Q3O6WUbeCj8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1baf:b0:2c2:46eb:a074 with SMTP id
 n15-20020a056e021baf00b002c246eba074mr20346548ili.263.1646114652231; Mon, 28
 Feb 2022 22:04:12 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:50 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-8-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 7/8] selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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
 .../kvm/x86_64/vmx_control_msrs_test.c        | 160 ++++++++++++++++++
 3 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 052ddfe4b23a..38edeace1432 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -38,6 +38,7 @@
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
 /x86_64/vmx_close_while_nested_test
+/x86_64/vmx_control_msrs_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_exception_with_invalid_guest_state
 /x86_64/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f7fa5655e535..a1f0c5885b6d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -70,6 +70,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_control_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
new file mode 100644
index 000000000000..4ab780483e15
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
@@ -0,0 +1,160 @@
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
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+			     0,						/* set */
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	/* exp_set */
+			     0);					/* exp_clear */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			     0,						/* set */
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,	/* exp_set */
+			     0);					/* exp_clear */
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
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+			     0,						/* set */
+			     0,						/* clear */
+			     0,						/* exp_set */
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);	/* exp_clear */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			     0,						/* set */
+			     0,						/* clear */
+			     0,						/* exp_set */
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);	/* exp_clear */
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
+	cap.cap = KVM_CAP_DISABLE_QUIRKS2;
+	cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
+	vm_enable_cap(vm, &cap);
+
+	/*
+	 * Test that userspace can clear these bits, even if it exposes a vPMU
+	 * that supports IA32_PERF_GLOBAL_CTRL.
+	 */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+			     0,						/* set */
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
+			     0,						/* exp_set */
+			     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);	/* exp_clear */
+	test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			     0,						/* set */
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,	/* clear */
+			     0,						/* exp_set */
+			     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);	/* exp_clear */
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+
+	if (!kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2)) {
+		print_skip("KVM_CAP_DISABLE_QUIRKS2 not supported");
+		exit(KSFT_SKIP);
+	}
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

