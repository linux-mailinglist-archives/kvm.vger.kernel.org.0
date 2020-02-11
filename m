Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFD158A1B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 07:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgBKGxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 01:53:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:28362 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgBKGxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 01:53:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 22:53:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,427,1574150400"; 
   d="scan'208";a="405848684"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 10 Feb 2020 22:53:08 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        aaronlewis@google.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 2/2] KVM: tests: Selftest for xsave CPUID enumeration
Date:   Tue, 11 Feb 2020 14:57:06 +0800
Message-Id: <20200211065706.3462-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200211065706.3462-1-weijiang.yang@intel.com>
References: <20200211065706.3462-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test CPUID(EAX=DH, ECX=i, i>=0) enumeration and supervisor
XSAVE bits support in MSR IA32_XSS.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/xsave_cpuid_test.c   | 81 +++++++++++++++++++
 2 files changed, 82 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xsave_cpuid_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 3138a916574a..fc458dc949d2 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
+TEST_GEN_PROGS_x86_64 += x86_64/xsave_cpuid_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/x86_64/xsave_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xsave_cpuid_test.c
new file mode 100644
index 000000000000..262a624c8f51
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xsave_cpuid_test.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This selftest is based on xss_msr_test.c, but the test approach conflicts
+ * with that of the original test app, so make it a seperate test app.
+ *
+ * It tests for XSAVE(S) based CPUID leaves enumeration and supported bits
+ * in MSR_IA32_XSS.
+ *
+ * Since currently MSR_IA32_XSS isn't supported in kernel and KVM, need to
+ * inject the sample data and mask via KVM before kick off this app, otherwise,
+ * no supervisor XSAVE leaves and bits will be enumerated.
+ */
+
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+#define VCPU_ID	      1
+#define MSR_BITS      64
+
+#define X86_FEATURE_XSAVES	(1<<3)
+
+int enum_xsave_cpuid(struct kvm_vm *vm)
+{
+	struct kvm_cpuid2 *cpuid;
+	struct kvm_cpuid_entry2 *entry2 = NULL;
+	int i;
+
+	cpuid = kvm_get_supported_cpuid();
+	if (cpuid)
+		vcpu_set_cpuid(vm, VCPU_ID, cpuid);
+	for (i = 0; i < cpuid->nent; i++) {
+		entry2 = &cpuid->entries[i];
+		if (entry2->function == 0xd) {
+			printf("cpuid.[d.%d]: eax = 0x%08x, ebx = 0x%08x, ecx = 0x%08x, edx = 0x%08x\n", entry2->index ,entry2->eax, entry2->ebx, entry2->ecx, entry2->edx);
+		}
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *entry;
+	bool xss_supported = false;
+	struct kvm_vm *vm;
+	uint64_t enabled_bits = 0;
+	int i, r;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, 0);
+
+	if (kvm_get_cpuid_max_basic() >= 0xd) {
+		entry = kvm_get_supported_cpuid_index(0xd, 1);
+		xss_supported = entry && !!(entry->eax & X86_FEATURE_XSAVES);
+	}
+	if (!xss_supported) {
+		printf("IA32_XSS is not supported by the vCPU.\n");
+		return -1;
+	}
+
+	enum_xsave_cpuid(vm);
+
+	/*
+	 * Below loop is to test which bit is supported on current system.
+	 * Before run this selftest, host MSR_IA32_XSS is set to 0x3900 and KVM
+	 * XSS mask is set to the same value, otherwise, it cannot enumerate
+	 * valid bit in MSR_IA32_XSS.
+	 */
+	for (i = 0; i < MSR_BITS; ++i) {
+		r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1ull << i);
+		if (r == 1) {
+			enabled_bits |= 1ull << i;
+			printf("bit[%d] in MSR_IA32_XSS is supported\n", i);
+		}
+	}
+	printf("Supported bit mask in MSR_IA32_XSS is : 0x%lx\n", enabled_bits);
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.17.2

