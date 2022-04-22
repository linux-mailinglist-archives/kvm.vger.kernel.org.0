Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA3950B9E2
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 16:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448544AbiDVOTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 10:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448530AbiDVOTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 10:19:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A274B5AED0;
        Fri, 22 Apr 2022 07:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650637001; x=1682173001;
  h=from:to:cc:subject:date:message-id;
  bh=RqQTZ9rQaDwBAdZS5QETujxpLislpihWCdAyP9oPqZc=;
  b=WXZArPrRv+AMsb4CYy2OlDXa5ukdZMlk2V8f4zY/YFUgwRZtzqMbLIjk
   S1LxeYrZijwQVPt8YyPG5sYXzkA5NclyOzYAakbFxJhA0KrQ6T9uyguAB
   v7Fcx3agb32VPAatMy1t5F0GzPtuRo3425eS5fgtE4dZeosgb2XzLwg7B
   jXsaMaBiRbUjFLqW8pUutqDzhec2F43jpLNVkWskbwD275+VcUkXLsKBs
   KwNr68drR7nYm9Lme1l3nVTUzt8lpOCeAltDLYKOsFI6zQKjieaPgpyqm
   LksHg7WXzaz/hebkmfT+L3vkIU8kqGFI2t5s4OW2+e/dsuP2dfKAbdquS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245258580"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="245258580"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 07:16:41 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="556396437"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 07:16:35 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH] kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test
Date:   Fri, 22 Apr 2022 21:44:56 +0800
Message-Id: <20220422134456.26655-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Basic test coverage of KVM_CAP_MAX_VCPU_ID cap.

This capability can be enabled before vCPU creation and only allowed
to set once. if assigned vcpu id is beyond KVM_CAP_MAX_VCPU_ID
capability, vCPU creation will fail.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
This patch appends the test case to verify the KVM_CAP_MAX_VCPU_ID cap
enabling mechanism introduced in IPI virtualization enabling patch.
https://lore.kernel.org/lkml/20220419153155.11504-1-guang.zeng@intel.com/
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/max_vcpuid_cap_test.c          | 60 +++++++++++++++++++
 3 files changed, 62 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d1e8f5237469..b860dcfee920 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -22,6 +22,7 @@
 /x86_64/hyperv_cpuid
 /x86_64/hyperv_features
 /x86_64/hyperv_svm_test
+/x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
 /x86_64/mmu_role_test
 /x86_64/platform_info_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 21c2dbd21a81..e92dc78de4d0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
+TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
new file mode 100644
index 000000000000..3fc84efa7460
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * maximum APIC ID capability tests
+ *
+ * Copyright (C) 2022, Intel, Inc.
+ *
+ * Tests for getting/setting maximum APIC ID capability
+ */
+
+#include "kvm_util.h"
+#include "../lib/kvm_util_internal.h"
+
+#define MAX_VCPU_ID	2
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_enable_cap cap = { 0 };
+	int ret;
+
+	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+
+	/* Get KVM_CAP_MAX_VCPU_ID cap supported in KVM */
+	ret = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
+
+	/* Try to set KVM_CAP_MAX_VCPU_ID beyond KVM cap */
+	cap.cap = KVM_CAP_MAX_VCPU_ID;
+	cap.args[0] = ret + 1;
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret < 0,
+		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID"
+		    "beyond KVM cap!\n");
+
+	/* Set KVM_CAP_MAX_VCPU_ID */
+	cap.cap = KVM_CAP_MAX_VCPU_ID;
+	cap.args[0] = MAX_VCPU_ID;
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret == 0,
+		    "Unexpected failure to enable KVM_CAP_MAX_VCPU_ID!\n");
+
+	/* Check current KVM_CAP_MAX_VCPU_ID value */
+	ret = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
+	TEST_ASSERT(ret == MAX_VCPU_ID,
+		    "Unexpected failure to set KVM_CAP_MAX_VCPU_ID as %d\n",
+		    MAX_VCPU_ID);
+
+	/* Try to set KVM_CAP_MAX_VCPU_ID again */
+	cap.args[0] = MAX_VCPU_ID + 1;
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret < 0,
+		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID again\n");
+
+	/* Create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap*/
+	ret = ioctl(vm->fd, KVM_CREATE_VCPU, MAX_VCPU_ID);
+	TEST_ASSERT(ret < 0,
+		    "Unexpected success in creating a vCPU with VCPU ID out of range\n");
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.27.0

