Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658C24A7B69
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 00:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347987AbiBBXEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 18:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347986AbiBBXEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 18:04:41 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D5C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 15:04:41 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u11-20020a25ab0b000000b0061a3e951dceso2220074ybi.15
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 15:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ejQLzg8dmIkiJsTDZcpXvbSKYJlme1FMhZeCiq2tclg=;
        b=SiRC7KLbKfwTmWiuMBBhW6t0U2G3XPsU1ckRjbW3eq89zqDbrYOfYbX1kgZ/F8qn81
         1BR5o73yfDvLl7tPMHM8o/Q7064AbTqHG/Ig3bMeozhdnUcFzHP9jFB88XojBwV64VPT
         ggb+R7F+czJhzcii9fH1Xu1odW+wJUVqA4EvpR0x8RfE/WV+mTNsE3pygNbD+/R+eiwc
         e6Njx2Aok/dZhPyP3T9JmMQjp4e9RKEpQxXX7TBjnvpJQuJPfPcSigTPdE8Mxg8aHe64
         wulkHBAvnanbCGebG28jgPBClQS6WIGwFtLiCsD72e1ej1Gl/baLYHtXmpFkkbLvOVyG
         iM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ejQLzg8dmIkiJsTDZcpXvbSKYJlme1FMhZeCiq2tclg=;
        b=dYsGQG6G31sRXNbh4ch9lN7WQFZ3Tg6R/ARLLyrzrkBy3xtr3HTk0lT6tn/G9PBAfl
         2Fn+FZgUcAYZ7h5xg/Zffh31u15snPQWFH5gxoildxW5o52jwrLCtF+GkKESdDODDmfQ
         YKU7YIf06odEKnQQ+3tgbUlbCLzSh//jw4YHbHJzOPhcRC++2WRT35bnCJoJEL9AvEzI
         NT93I8yphZtVgyv7LpsbjrX/agZLZ5rc5OqHcereZzWiWMcdY66wBongohfKdyzy++M0
         ZuJhgvxFzLOIoHVLn2idXjFs87nQtM308IlGYn1sxTuSsPFTujRiwkb2F6Cw94J36C2j
         ZSYA==
X-Gm-Message-State: AOAM531xEftkz1KJUiDpwrfRD/YWrq+q12Ub9edLL838SjkKRVZz8/rb
        GdyItXCUOys6x3x5crhTnbZYFCnHtK6NbO+Fby60tu/bX4gqIjvTbmEbEMGCc9V2wUs4djvt9Ke
        LypVCxb4ww4xhjpLdI3Dk8fBF9Sf9ehJ5xSeb4b3JWXJWq2Q0Tv3hCmoOUw==
X-Google-Smtp-Source: ABdhPJy6RzLduitRp5i0w6lKYPZzRchTW1eZ7NbrZPkXGFB7j4d0qOaKBFOyZtbCfvZPRomRBo45eIxQGgo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8004:: with SMTP id m4mr41894248ybk.268.1643843080736;
 Wed, 02 Feb 2022 15:04:40 -0800 (PST)
Date:   Wed,  2 Feb 2022 23:04:32 +0000
In-Reply-To: <20220202230433.2468479-1-oupton@google.com>
Message-Id: <20220202230433.2468479-4-oupton@google.com>
Mime-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 3/4] selftests: KVM: Add test for "load IA32_PERF_GLOBAL_CTRL" invariance
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

Assert that clearing the "load IA32_PERF_GLOBAL_CTRL" VM-{Entry,Exit}
capability bits is preserved across KVM_SET_CPUID2.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/vmx_capability_msrs_test.c     | 82 +++++++++++++++++++
 3 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..d1e6757aed2f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -36,6 +36,7 @@
 /x86_64/userspace_io_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
+/x86_64/vmx_capability_msrs_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..083c437a852f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -68,6 +68,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_capability_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c b/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c
new file mode 100644
index 000000000000..8a1a545e658b
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_capability_msrs_test.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VMX capability MSRs test
+ *
+ * Copyright (C) 2022 Google LLC
+ *
+ * Regression tests to check that updates to guest CPUID do not affect the
+ * values of VMX capability MSRs.
+ */
+
+#include "kvm_util.h"
+#include "vmx.h"
+
+#define VCPU_ID 0
+
+static void get_vmx_capability_msr(struct kvm_vm *vm, uint32_t msr_index,
+				   uint32_t *low, uint32_t *high)
+{
+	uint64_t val;
+
+	val = vcpu_get_msr(vm, VCPU_ID, msr_index);
+	*low = val;
+	*high = val >> 32;
+}
+
+static void set_vmx_capability_msr(struct kvm_vm *vm, uint32_t msr_index,
+				   uint32_t low, uint32_t high)
+{
+	uint64_t val = (((uint64_t) high) << 32) | low;
+
+	vcpu_set_msr(vm, VCPU_ID, msr_index, val);
+}
+
+/*
+ * Test to assert that clearing the "load IA32_PERF_GLOBAL_CTRL" VM-{Entry,Exit}
+ * control capability bits is preserved across a KVM_SET_CPUID2.
+ */
+static void load_perf_global_ctrl_test(struct kvm_vm *vm)
+{
+	uint32_t entry_low, entry_high, exit_low, exit_high;
+	struct kvm_cpuid2 *cpuid;
+
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	if (!(entry_high & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) ||
+	    !(exit_high & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
+		print_skip("\"load IA32_PERF_GLOBAL_CTRL\" VM-{Entry,Exit} control not supported");
+		return;
+	}
+
+	entry_high &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+	exit_high &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+
+	set_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, entry_low, entry_high);
+	set_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, exit_low, exit_high);
+
+	cpuid = kvm_get_supported_cpuid();
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS, &entry_low, &entry_high);
+	get_vmx_capability_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS, &exit_low, &exit_high);
+
+	TEST_ASSERT(!(entry_high & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL),
+		    "\"load IA32_PERF_GLOBAL_CTRL\" VM-Entry bit set");
+	TEST_ASSERT(!(exit_high & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL),
+		    "\"load IA32_PERF_GLOBAL_CTRL\" VM-Exit bit set");
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
2.35.0.rc2.247.g8bbb082509-goog

