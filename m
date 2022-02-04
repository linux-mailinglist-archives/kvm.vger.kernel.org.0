Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BB14AA15C
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 21:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239409AbiBDUrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 15:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbiBDUrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 15:47:15 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79806C06173D
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 12:47:15 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id 20-20020a056e020cb400b002b93016fbccso4896254ilg.4
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mYdQuuQjNg3olGZ4TYpyId10vffH51o4bIKR3rvAWAU=;
        b=f6Eaua2Lr1p4KNKFksZp3uwcpeu2EpH6Q78D1FVfxabRWvngaq42+NlCqv7okP2v8C
         vQMeTjSGz6C7NyUbrPZk7MwbtyZs1ipw4k2vQqiMkE5uR5HQrrdwdzJOtdnejdlshtuC
         6kr+7hkeeVgZiMMEGJzkAJPunrfnhdcZ9dBPx2PaFA/3zD86s2TDn3HzXKHyOpDVRvIh
         DWZtqxjvB2/3dWVY2KTRXxWtTBLg//c70AXr6QjIoqt8krAotiJ0324h1HEaD82fkg1a
         LNjt5vwh9SiSWbx6TrVic7KpRYAVS/W0ytRv2xVlG6sNzHRHI9kU11U7ZD+EPWkQ3pNP
         CQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mYdQuuQjNg3olGZ4TYpyId10vffH51o4bIKR3rvAWAU=;
        b=F7LjWprcDp1+O92PaYSaG5U71Bz9DAaNUxuVj/lpJqICFUptNJnfGEwJbh+7hAUlCQ
         vjBJCUaA1nMHWZIC7jn4fiICFrva2x9LwaoaESpQFwPM5ODzQn4R23qRsGRALiOaSleB
         xAeSkJiVQCr+kF5YyPfSHbQWunLDcJ1MyL2RGgILwcFulvVQaFdFrOcnzrF3egiCnypN
         0vNmCTsQJA2iRshWCEozYlLoXW/mEzvf8LOJHOeeU5cXEJRomLDFW6t9EWrDv9alpKHG
         RJQ1AC+y7polmFkOqKUdX6yDleqavF1qcW/0oU0sRzmIzyg38sywKni5wlctQgbyAspN
         6CnQ==
X-Gm-Message-State: AOAM533FHRgBJZnHUKnfVjWIIUeNfLHOjci6bFUGVtoTUxW8/a4hsshJ
        wnmTqUWxnWZzHXZeUpkNfBvfHHV3Q+65KNfpcDd9F0Y84YMe/42mq7fcA1H58kTxn47cYFWre4X
        v+fu3oGuZFD1KLGOJVn2xPguMDzBv10f/2CqttH4XptFG1Het3MS/xjt73w==
X-Google-Smtp-Source: ABdhPJy2YZi6zlt/xR8dve7osJIsGH7Itr7DSWsQElsnFqEBKuqjkKZJ8ZcLyUKcNOtCEZKqyGhol9kQnss=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2c44:: with SMTP id
 x4mr396033iov.111.1644007634835; Fri, 04 Feb 2022 12:47:14 -0800 (PST)
Date:   Fri,  4 Feb 2022 20:47:03 +0000
In-Reply-To: <20220204204705.3538240-1-oupton@google.com>
Message-Id: <20220204204705.3538240-6-oupton@google.com>
Mime-Version: 1.0
References: <20220204204705.3538240-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v2 5/7] selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX
 control MSR bits
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../kvm/x86_64/vmx_control_msrs_test.c        | 113 ++++++++++++++++++
 3 files changed, 115 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..044aef3a8574 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -36,6 +36,7 @@
 /x86_64/userspace_io_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
+/x86_64/vmx_control_msrs_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..88b99d9de373 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -68,6 +68,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_control_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
new file mode 100644
index 000000000000..ac5fdeb50eee
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_control_msrs_test.c
@@ -0,0 +1,113 @@
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
+static void load_perf_global_ctrl_test(struct kvm_vm *vm)
+{
+	uint32_t entry_low, entry_high, exit_low, exit_high;
+	struct kvm_enable_cap cap = {0};
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
2.35.0.263.gb82422642f-goog

