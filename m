Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8E517E27
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 09:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiECHQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 03:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiECHQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 03:16:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617D931DF2;
        Tue,  3 May 2022 00:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651561986; x=1683097986;
  h=from:to:cc:subject:date:message-id;
  bh=2CV86QC3Dw6WLOp/M+dDMYXWwCmN0sjD5K0oCUyw3DI=;
  b=HRxISd6OLsEb6nQO72Lh5Ex8LZA3LJb9hc1JZtRDS/8vCuOHlgKFAAhi
   713AI+phH7rTU3FzC/RvPXR0GUkG5TGoDurWbn0g45hvLiGylW2YNr5X/
   Ev9BA8VYGDrqzAWo/WQNHgR57cWLr4aU4hSv57w1aMW5/lxh36t97WSdV
   hmZUpopq/e7/iCJV0Meyg72Z+GtNsp0wBtZnF8AEGKiut+9Gq/DfFUGbD
   r+5yKargyaZyBFixDK7v1guwPqFUtRhdKhk7lmrxX8+T5T4LBG+DlJNOG
   q37kXP1ozeRXOoFVcFvB5Dx4pRcgU3AZKvBtQuXc1hnAdHHzNCs3kx/Xw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="327959061"
X-IronPort-AV: E=Sophos;i="5.91,194,1647327600"; 
   d="scan'208";a="327959061"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 00:12:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,194,1647327600"; 
   d="scan'208";a="562107283"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 00:12:28 -0700
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
Subject: [PATCH v2] kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test
Date:   Tue,  3 May 2022 14:40:37 +0800
Message-Id: <20220503064037.10822-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/max_vcpuid_cap_test.c          | 59 +++++++++++++++++++
 3 files changed, 61 insertions(+)
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
index 000000000000..2e3d1d236ef0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -0,0 +1,59 @@
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
+	/* Check failure if set KVM_CAP_MAX_VCPU_ID beyond KVM cap */
+	cap.cap = KVM_CAP_MAX_VCPU_ID;
+	cap.args[0] = ret + 1;
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret < 0,
+		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID"
+		    "beyond KVM cap!\n");
+
+	/* Check success if set KVM_CAP_MAX_VCPU_ID */
+	cap.args[0] = MAX_VCPU_ID;
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret == 0,
+		    "Unexpected failure to enable KVM_CAP_MAX_VCPU_ID!\n");
+
+	/* Check success if set KVM_CAP_MAX_VCPU_ID same value */
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret == 0,
+		    "Unexpected failure to set KVM_CAP_MAX_VCPU_ID same value\n");
+
+	/* Check failure if set KVM_CAP_MAX_VCPU_ID different value again */
+	cap.args[0] = MAX_VCPU_ID + 1;
+	ret = ioctl(vm->fd, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(ret < 0,
+		    "Unexpected success to enable KVM_CAP_MAX_VCPU_ID with"
+		    "different value again\n");
+
+	/* Check failure if create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap*/
+	ret = ioctl(vm->fd, KVM_CREATE_VCPU, MAX_VCPU_ID);
+	TEST_ASSERT(ret < 0,
+		    "Unexpected success in creating a vCPU with VCPU ID out of range\n");
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.27.0

