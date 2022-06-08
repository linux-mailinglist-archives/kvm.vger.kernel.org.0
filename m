Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDA543F67
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 00:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbiFHWph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 18:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiFHWp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 18:45:29 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD63250693
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 15:45:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r1-20020a17090a0ac100b001e0ab5fc247so11268334pje.8
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 15:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=L6CG/ucwyzRbxPhEP+xskpq5cumPIfOGi6WfytIM0VI=;
        b=EVrWDujSzZhYWScj6uvyk/wsH9irmGTL6WNySzq7huYNhDGk2RcPTI6RmAp+SHuBd9
         tUjiNPGzPKbB+WvXlCxogt0M9Mbw8kwAjdR95DKE6qPdhzNa57z58+zWAHhnOziOHbn+
         Zwqth5TBzimqdtVbE+W+DNFJBcTLFJwYtJL9p9msqFQXjrg3eZpLkpoTUjqIPhJ7VNGq
         DFg32qozGkUujV/IdgRsor4H2O5y+mDXrza/czdxLHnhX8QYnZAzv4xOtaVLGnzjbKVj
         XPpl+91Ds74ar752Cg7+9B0m+II28CnWOtVSf2z2RonRixRyR5jeyNV9/TI2siqPjny+
         cSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=L6CG/ucwyzRbxPhEP+xskpq5cumPIfOGi6WfytIM0VI=;
        b=qzD5TVmOulBFjEbcUSVpVtGuwsObxDFvGcV7UdKDReOGqoM6hrfFup9pmz6/nxzqys
         3a9iigo4VS20u3iS3bfwTPBqV90gEqbegjy9+ea4/M4/pytW2MVjCijMdfyWFE2KV1CE
         QzqAo57aeCd12XbSk+FVlFGMXPwFfGNk1u07QavquKscOFEUK3sziwabx8lkqOLaL7du
         BJuVySUZi4R+bu9NV35P38GjA49zR8chPc6nkCZfsYj97XagW8ufl8/Bqd2WMjiwIAzQ
         aDzrjXT9WjfsYa7XToJs8LhkKte8dHNgQhu30uZ1L+CydhLewr7GjHB6BAJo1difsFzR
         ZwNA==
X-Gm-Message-State: AOAM531GB/24nUUBgFFyeMaUgTiEf62NwZXH+35bViE/FEZ7U6XbB4Ql
        5feWlaFC85KvGWvJA/u2b+IaUqJnPYc=
X-Google-Smtp-Source: ABdhPJx9WF++0c78k3640NdFplCX1fFdbExMr6dWv7IOPQRs+W4YuRh0MTHB9N/9ITqnrqr6Dd0MjFHwpsI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5a48:b0:1e3:4180:a218 with SMTP id
 m8-20020a17090a5a4800b001e34180a218mr262148pji.182.1654728327551; Wed, 08 Jun
 2022 15:45:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 22:45:16 +0000
In-Reply-To: <20220608224516.3788274-1-seanjc@google.com>
Message-Id: <20220608224516.3788274-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220608224516.3788274-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 5/5] KVM: selftests: Add MONITOR/MWAIT quirk test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Add a test to verify the "MONITOR/MWAIT never fault" quirk, and as a
bonus, also verify the related "MISC_ENABLES ignores ENABLE_MWAIT" quirk.

If the "never fault" quirk is enabled, MONITOR/MWAIT should always be
emulated as NOPs, even if they're reported as disabled in guest CPUID.
Use the MISC_ENABLES quirk to coerce KVM into toggling the MWAIT CPUID
enable, as KVM now disallows manually toggling CPUID bits after running
the vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/monitor_mwait_test.c | 127 ++++++++++++++++++
 3 files changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0ab0e255d292..1a56522f009c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -27,6 +27,7 @@
 /x86_64/hyperv_svm_test
 /x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
+/x86_64/monitor_mwait_test
 /x86_64/platform_info_test
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 9a256c1f1bdf..bbbfdeb7ee9b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
+TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
new file mode 100644
index 000000000000..b9af8e29721e
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+
+enum monitor_mwait_testcases {
+	MWAIT_QUIRK_DISABLED = BIT(0),
+	MISC_ENABLES_QUIRK_DISABLED = BIT(1),
+	MWAIT_DISABLED = BIT(2),
+};
+
+static void guest_monitor_wait(int testcase)
+{
+	/*
+	 * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD,
+	 * in all other scenarios KVM should emulate them as nops.
+	 */
+	bool fault_wanted = (testcase & MWAIT_QUIRK_DISABLED) &&
+			    (testcase & MWAIT_DISABLED);
+	u8 vector;
+
+	GUEST_SYNC(testcase);
+
+	vector = kvm_asm_safe("monitor");
+	if (fault_wanted)
+		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
+	else
+		GUEST_ASSERT_2(!vector, testcase, vector);
+
+	vector = kvm_asm_safe("monitor");
+	if (fault_wanted)
+		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
+	else
+		GUEST_ASSERT_2(!vector, testcase, vector);
+}
+
+static void guest_code(void)
+{
+	guest_monitor_wait(MWAIT_DISABLED);
+
+	guest_monitor_wait(MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
+
+	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_DISABLED);
+	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED);
+
+	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
+	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	uint64_t disabled_quirks;
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int testcase;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
+
+	run = vcpu->run;
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	while (1) {
+		vcpu_run(vcpu);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Unexpected exit reason: %u (%s),\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			testcase = uc.args[1];
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld, testcase = %lx, vector = %ld",
+				  (const char *)uc.args[0], __FILE__,
+				  uc.args[1], uc.args[2], uc.args[3]);
+			goto done;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+			goto done;
+		}
+
+		disabled_quirks = 0;
+		if (testcase & MWAIT_QUIRK_DISABLED)
+			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_FAULTS;
+		if (testcase & MISC_ENABLES_QUIRK_DISABLED)
+			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
+
+		/*
+		 * If the MISC_ENABLES quirk (KVM neglects to update CPUID to
+		 * enable/disable MWAIT) is disabled, toggle the ENABLE_MWAIT
+		 * bit in MISC_ENABLES accordingly.  If the quirk is enabled,
+		 * the only valid configuration is MWAIT disabled, as CPUID
+		 * can't be manually changed after running the vCPU.
+		 */
+		if (!(testcase & MISC_ENABLES_QUIRK_DISABLED)) {
+			TEST_ASSERT(testcase & MWAIT_DISABLED,
+				    "Can't toggle CPUID features after running vCPU");
+			continue;
+		}
+
+		vcpu_set_msr(vcpu, MSR_IA32_MISC_ENABLE,
+			     (testcase & MWAIT_DISABLED) ? 0 : MSR_IA32_MISC_ENABLE_MWAIT);
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.36.1.255.ge46751e96f-goog

