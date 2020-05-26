Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BB1C1D6C
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 20:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgEASwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730074AbgEASwm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 14:52:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09906C061A0C
        for <kvm@vger.kernel.org>; Fri,  1 May 2020 11:52:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i13so13139188ybl.13
        for <kvm@vger.kernel.org>; Fri, 01 May 2020 11:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1OJhjIpUBl8ad63qNEszYk13rd+seOQrgj/fLGOHDLU=;
        b=ENp+jrNHDHEnFCUrs34p9XHzbIgaMGONWxhx86Fff6SGhFqcaF2zvmYIrZq1+dqm/v
         XQWdpdfP2jj0HIvvmoDooKXSxkL054VqBSEMYtbAP1T57Q/U/WTJw+ZKJPvvT/Fg94bH
         pn3yy/VEhb0ccDMs2kv7dYqS57a8kshinug/Nnl8NGxB9vD4NEkyzhoKnnA2IoGMrNmf
         zXL5m3fbw2BCKnnlSgvUKUDlmwpYm0y9m5BQBX/pLXrjqF2x+N7AbQZtZRSKQ1EYeB7v
         EMmJbQhq9ri/OV0aeAbzgm7BNjafSqvJ7z096/u5wDLpKr/fm6nvuE4qXBW8Or2Re7oW
         5VHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1OJhjIpUBl8ad63qNEszYk13rd+seOQrgj/fLGOHDLU=;
        b=FU+Fbbl1Av9bR5GJxdD9muHsxAv/LXUMPJD/JXPrfdKancTDfKX2e39EfLw0O8fUnV
         G2OYEWET+0T8ceyj/DcZ/UQETRKnRStxGIGwt86dt4NppDZgOkEbHMuRs/wI/fIjAUd3
         M6AlUsCEA5LGtl3S5dyZrGiCtedf/KgYsy7BhteulHjndJE4jT3UWRHhsrRC2qfZSXx5
         9TChzIoE+Mu2n/fd8v7AUhgz5WD1NFmPDDhNs06eUdAFx9LH2e/9CK/ADH7O/GNPBKZ2
         eMGgK0CabqHUEr4BvDhCiuoD9CUie6QKDPTcPUVfcRurn1HHOpUeDhhddOF/x3gNOpqP
         +U+w==
X-Gm-Message-State: AGi0PubG2wlG0abkp3oI6TiWoCZZkuEwoIJ7QW2MkqEtTUeLjhebxiUr
        6V8A/r3Lx+Qc61y3ujlRHQ8oWg1AMxGaqhXZGcK6v6dXzaM0hKDZKZOTgzieVIgh8PtloQE7n+c
        zNEbUggH/n9EhO5cKvJ+1+BR+OpEJOW01ryCfdazTqF/yV0Ylf17UR84ixA==
X-Google-Smtp-Source: APiQypILvf65C7JFDilAloSEwV+u5hcCkePgCHAcvWSsYxY1r3g7IFi/sMeBdsbjU7abQidDEo2NCB03KR8=
X-Received: by 2002:a25:bd50:: with SMTP id p16mr8254556ybm.436.1588359160988;
 Fri, 01 May 2020 11:52:40 -0700 (PDT)
Date:   Fri,  1 May 2020 11:51:47 -0700
In-Reply-To: <20200501185147.208192-1-yuanyu@google.com>
Message-Id: <20200501185147.208192-2-yuanyu@google.com>
Mime-Version: 1.0
References: <20200501185147.208192-1-yuanyu@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH RFC 1/1] KVM: x86: add KVM_HC_UCALL hypercall
From:   Forrest Yuan Yu <yuanyu@google.com>
To:     kvm@vger.kernel.org
Cc:     Forrest Yuan Yu <yuanyu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The purpose of this new hypercall is to exchange message between
guest and hypervisor. For example, a guest may want to ask hypervisor
to harden security by setting restricted access permission on guest
SLAT entry. In this case, the guest can use this hypercall to send
a message to the hypervisor which will do its job and send back
anything it wants the guest to know.

Signed-off-by: Forrest Yuan Yu <yuanyu@google.com>
---
 Documentation/virt/kvm/api.rst                |  15 +-
 Documentation/virt/kvm/cpuid.rst              |   3 +
 Documentation/virt/kvm/hypercalls.rst         |  14 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/include/uapi/asm/kvm_para.h          |   1 +
 arch/x86/kvm/x86.c                            |  39 +++-
 include/uapi/linux/kvm.h                      |   1 +
 include/uapi/linux/kvm_para.h                 |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/hypercall_ucall.c    | 195 ++++++++++++++++++
 11 files changed, 264 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hypercall_ucall.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..ae8958a7ad15 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4854,8 +4854,8 @@ to the byte array.
 
 .. note::
 
-      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR and
-      KVM_EXIT_EPR the corresponding
+      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_HYPERCALL, KVM_EXIT_OSI,
+      KVM_EXIT_PAPR and KVM_EXIT_EPR the corresponding
 
 operations are complete (and guest state is consistent) only after userspace
 has re-entered the kernel with KVM_RUN.  The kernel side will first finish
@@ -5802,6 +5802,17 @@ If present, this capability can be enabled for a VM, meaning that KVM
 will allow the transition to secure guest mode.  Otherwise KVM will
 veto the transition.
 
+7.20 KVM_CAP_UCALL
+------------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports hypercall ucall. It being enabled
+means userspace is ready to receive a message sent by a guest using hypercall
+ucall. When it is not enabled, a hypercall ucall made by a guest will not cause
+control to be handed to userspace. Instead, kvm will return -KVM_ENOSYS without
+userspace participation.
+
 8. Other capabilities.
 ======================
 
diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index 01b081f6e7ea..ff313f6827bf 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,9 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
                                               before using paravirtualized
                                               sched yield.
 
+KVM_FEATURE_UCALL                 14          guest checks this feature bit
+                                              before calling hypercall ucall.
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index dbaf207e560d..ce3f30d5b2ee 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,17 @@ a0: destination APIC ID
 
 :Usage example: When sending a call-function IPI-many to vCPUs, yield if
 	        any of the IPI target vCPUs was preempted.
+
+8. KVM_HC_UCALL
+---------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: Hypercall used to exchange message between VM and hypervisor.
+
+a0: message type
+
+a1, a2, a3: dependent on message type
+
+:Usage example: A guest asks hypervisor to harden security by setting
+restricted access permission on guest SLAT entry.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..433e96c126a5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -979,6 +979,7 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool hypercall_ucall_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..9524434463f2 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_UCALL		14
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..388a4f89464d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3385,6 +3385,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_UCALL:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4895,6 +4896,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_UCALL:
+		kvm->arch.hypercall_ucall_enabled = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -7554,6 +7559,19 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
 		kvm_vcpu_yield_to(target);
 }
 
+static int complete_hypercall(struct kvm_vcpu *vcpu)
+{
+	u64 ret = vcpu->run->hypercall.ret;
+
+	if (!is_64_bit_mode(vcpu))
+		ret = (u32)ret;
+	kvm_rax_write(vcpu, ret);
+
+	++vcpu->stat.hypercalls;
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -7605,17 +7623,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_UCALL:
+		if (vcpu->kvm->arch.hypercall_ucall_enabled) {
+			vcpu->run->hypercall.nr = nr;
+			vcpu->run->hypercall.args[0] = a0;
+			vcpu->run->hypercall.args[1] = a1;
+			vcpu->run->hypercall.args[2] = a2;
+			vcpu->run->hypercall.args[3] = a3;
+			vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+			vcpu->arch.complete_userspace_io = complete_hypercall;
+			return 0; // message is going to userspace
+		}
+		ret = -KVM_ENOSYS;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
 	}
 out:
-	if (!op_64_bit)
-		ret = (u32)ret;
-	kvm_rax_write(vcpu, ret);
-
-	++vcpu->stat.hypercalls;
-	return kvm_skip_emulated_instruction(vcpu);
+	vcpu->run->hypercall.ret = ret;
+	return complete_hypercall(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..c1fcac311c76 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_UCALL 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..4e5ad8dec801 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_UCALL			12
 
 /*
  * hypercalls use architecture specific
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index a9b2b48947ff..c796c8efaa23 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -18,6 +18,7 @@
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
 /x86_64/xss_msr_test
+/x86_64/hypercall_ucall
 /clear_dirty_log_test
 /demand_paging_test
 /dirty_log_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 712a2ddd2a27..b3aeec375644 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -33,6 +33,7 @@ TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += steal_time
+TEST_GEN_PROGS_x86_64 += x86_64/hypercall_ucall
 
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/x86_64/hypercall_ucall.c b/tools/testing/selftests/kvm/x86_64/hypercall_ucall.c
new file mode 100644
index 000000000000..132b6d1c98e2
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hypercall_ucall.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hypercall KVM_HC_UCALL test
+ *
+ * Copyright (C) 2020, Google LLC.
+ *
+ * Author:
+ *   Forrest Yuan Yu <yuanyu@google.com>
+ */
+
+#include <stdio.h>
+#include "linux/kernel.h"
+#include "linux/kvm_para.h"
+#include "linux/overflow.h"
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID		5
+#define HYPERCALL_RET	0xBEEF
+#define HYPERCALL_ARG0	1000
+#define HYPERCALL_ARG1	1001
+#define HYPERCALL_ARG2	1002
+#define HYPERCALL_ARG3	1003
+
+static inline bool is_feature_ucall_enabled(void)
+{
+	u32 eax, ebx, ecx, edx;
+
+	asm volatile("cpuid"
+		     : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
+		     : "a"(KVM_CPUID_FEATURES), "c"(0));
+
+	return eax & (1 << KVM_FEATURE_UCALL);
+}
+
+static inline void guest_info_to_host(u16 info)
+{
+	asm volatile("in %%dx, %%ax" : : "d" (info));
+}
+
+static inline long hypercall_ucall(void)
+{
+	long ret;
+
+	asm volatile("vmcall"
+		     : "=a"(ret)
+		     : "a"(KVM_HC_UCALL), "b"(HYPERCALL_ARG0),
+		     "c"(HYPERCALL_ARG1), "d"(HYPERCALL_ARG2),
+		     "S"(HYPERCALL_ARG3)
+		     : "memory");
+
+	return ret;
+}
+
+void guest_code(void)
+{
+	long ret;
+
+	/* invoke ucall without it having been enabled */
+	ret = hypercall_ucall();
+	guest_info_to_host(ret);
+
+	/* check feature ucall the first time, host will see 0 */
+	guest_info_to_host(is_feature_ucall_enabled() ? 1 : 0);
+
+	/*
+	 * check feature ucall the second time, host will see 1 because
+	 * by now userspace should have enabled feature ucall
+	 */
+	guest_info_to_host(is_feature_ucall_enabled() ? 1 : 0);
+
+	/*
+	 * the following demonstrate the right way to make a hypercall ucall:
+	 * check the existence of the feature then do ucall
+	 */
+	if (is_feature_ucall_enabled()) {
+		/*
+		 * now that ucall is enabled, kvm will hand control to userspace
+		 * which will set the return value and finish it
+		 */
+		ret = hypercall_ucall();
+		/*
+		 * now we have received the return value set by userspace, send
+		 * it back to userspace for double check
+		 */
+		guest_info_to_host(ret);
+	} else {
+		/* this should not happen */
+		guest_info_to_host(-1);
+	}
+}
+
+void assert_guest_info(struct kvm_vm *vm, u16 expected, char *interpretation)
+{
+	struct kvm_run *state = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(
+		state->exit_reason == KVM_EXIT_IO,
+		"Got exit_reason other than KVM_EXIT_IO: %u (%s).\n",
+		state->exit_reason, exit_reason_str(state->exit_reason));
+
+	TEST_ASSERT(
+		state->io.port == expected,
+		"Test failed: expecting %s 0x%x but got 0x%x.\n",
+		interpretation, expected, state->io.port);
+}
+
+static void set_ucall_enabled(struct kvm_vm *vm, bool enable)
+{
+	struct kvm_enable_cap cap = {};
+
+	cap.cap = KVM_CAP_UCALL;
+	cap.flags = 0;
+	cap.args[0] = (int)enable;
+	vm_enable_cap(vm, &cap);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_run *state;
+	int hypercall_args[] = {
+		HYPERCALL_ARG0, HYPERCALL_ARG1, HYPERCALL_ARG2, HYPERCALL_ARG3
+	};
+	int arg_nr = ARRAY_SIZE(hypercall_args);
+	int i;
+	int expected_ucall_bit;
+	struct kvm_cpuid_entry2 *entry;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	/*
+	 * run VM which will do hypercall ucall, however, since the feature
+	 * has not been enabled, the hypercall will do nothing and return
+	 * -KVM_EOPNOTSUPP, which means an innocent userspace won't break even
+	 * if the guest tries to invoke this hypercall
+	 */
+	vcpu_run(vm, VCPU_ID);
+	assert_guest_info(vm, -KVM_EOPNOTSUPP, "hypercall return value");
+
+	/*
+	 * continue to run VM which will check feature ucall, which of course
+	 * hasn't been enabled yet
+	 */
+	expected_ucall_bit = 0;
+	vcpu_run(vm, VCPU_ID);
+	assert_guest_info(vm, expected_ucall_bit, "ucall bit");
+
+	TEST_ASSERT(kvm_check_cap(KVM_CAP_UCALL), "CAP UCALL exists.");
+
+	set_ucall_enabled(vm, true);
+
+	/* enable feature ucall and let VM run to check it again */
+	entry = kvm_get_supported_cpuid_index(KVM_CPUID_FEATURES, 0);
+	entry->eax |= 1 << KVM_FEATURE_UCALL;
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	expected_ucall_bit = 1;
+	vcpu_run(vm, VCPU_ID);
+	assert_guest_info(vm, expected_ucall_bit, "ucall bit");
+
+	/*
+	 * continue to run VM which will do hypercall ucall, which this time
+	 * will give control to userspace because userspace is supposed to
+	 * finish it
+	 */
+	vcpu_run(vm, VCPU_ID);
+	state = vcpu_state(vm, VCPU_ID);
+	TEST_ASSERT(
+		state->exit_reason == KVM_EXIT_HYPERCALL,
+		"Got exit_reason other than KVM_EXIT_HYPERCALL: %u (%s).\n",
+		state->exit_reason, exit_reason_str(state->exit_reason));
+	for (i = 0; i < arg_nr; i++) {
+		TEST_ASSERT(
+			state->hypercall.args[i] == hypercall_args[i],
+			"Got unexpected hypercall argument [%d]: %lld.\n",
+			i, state->hypercall.args[i]);
+	}
+
+	/* userspace finishes it with HYPERCALL_RET */
+	state->hypercall.ret = (u16)HYPERCALL_RET;
+
+	/*
+	 * continue VM which will see the finished ucall with a return value.
+	 * verify the value guest sees is the one we set from userspace just now
+	 */
+	vcpu_run(vm, VCPU_ID);
+	assert_guest_info(vm, HYPERCALL_RET, "hypercall return value");
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.26.2.526.g744177e7f7-goog

