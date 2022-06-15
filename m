Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038E254BF2C
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbiFOBSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244004AbiFOBRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD71186C4;
        Tue, 14 Jun 2022 18:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpdCPWxLw+Rx2XeuvoD7pY0c+VUhTSPSTTEkN6Ip9LlMHrAk2NQICc1XcOVFBnuIKRQ0EXds/7yrg0mF3UPWe5C9UqGXbioN/9sJWqYKqQ4HGTCFxR4qbal602PYTz/oFd5pCnpbQXGXTBuz+RaI/NLE1dZB7xDrP6AMogoKDOb1nNUysxAhAl5CMHH82N7Bk2p3wP3JED+gVwmgEJr+WODludgEFdP2hZKt5cP9wACzju7exu4SMKzOpt7Q4mp3jlNdk3fXimiUphlzW4XTMKrzJzLFfeej3KGA3Nop4jwJp5nuRgZjJ2eQ+til7TYGJaA+2Zsznlvh3g5uVl5oWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YgO2osWC8XTZczE4S5VSh8NkUm635zDBZziOwh1CC70=;
 b=jvwkjr5QefA56JpttbZmVuS1VlHlkWb1GtH8rUMqj/7PWFKcAWR8M5AsT4fQwSp1uuWP5ZYrTLdnVn6ZiCDpH65oF7ji0aUWHhgXcIRPQL7FpL3eahuJBjTF3h9kOaJqmmcyGEOmMDgsDADWwST3qRBPxctFOSFt7DFEK4OsPpP/oeO8VtEXDlrLpT0dLFqt+B8OtUR1p/niiJ6ogqLk2ULegeXu/jUVCDGMsoH7U/WRiRfGDkwtJcPvcRhrhXjv4xQ7s1TNbYqwQtg9F0MfxSAI0e78jZdf7FkVNEtVaAeVmXTfIEypJ/QixuDVs8g6ChDjy64pjBWN6Alp4KU+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgO2osWC8XTZczE4S5VSh8NkUm635zDBZziOwh1CC70=;
 b=niQd/92JOM2nFEqVItB0ufThACKcGis4bqmMPWTzDurS3Gl3Nh2IL/ohoGpOFpXQ3y9LX5NP1/IcIlUH8ojsF4lHVOSQ4z/pn+fSwD0D3asmANOk5lyLyAdy0s6tbzuzlbyiUZXpASSD1/aHVUQyzD+sB5FDkRhV39eDK2TySM5FHo6xXktEYE8fNomH59lnCiWk+7rrcWIxiddpBTBji5J3Y6W+IXje/zHJNGi3yagYkJg+W4y/NHGHi0S5HnQ8fkstaS8mG6E9rb43rYubn1mmSIwWZlxiVHmNun8IkW+tsnHNi0FXFSNCbCDQ0Rnh2+zp+UWwJ8YtVaimPtKETQ==
Received: from DM3PR11CA0007.namprd11.prod.outlook.com (2603:10b6:0:54::17) by
 DM6PR12MB4545.namprd12.prod.outlook.com (2603:10b6:5:2a3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.12; Wed, 15 Jun 2022 01:17:28 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::ad) by DM3PR11CA0007.outlook.office365.com
 (2603:10b6:0:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:26 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:25 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 7/7] KVM: selftests: Add tests for VM and vCPU cap KVM_CAP_X86_DISABLE_EXITS
Date:   Tue, 14 Jun 2022 18:16:22 -0700
Message-ID: <20220615011622.136646-8-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615011622.136646-1-kechenl@nvidia.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9916ea44-6b51-4326-8427-08da4e6cd000
X-MS-TrafficTypeDiagnostic: DM6PR12MB4545:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB45456DBEFC748A691EB073BDCAAD9@DM6PR12MB4545.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MDhi29E9cNZQ6xXNxPqFbVE/iWvnL3U7w1+AoL3r3WRsf3OeI/l2/lCPfRqf5oJsQoEGAx6CqlQm6PD1nK7+VcaAKi/5UA+PqdzuWCjzCGOP0Sy49GziCAvZp3MvWYqS4S4vNBmhikzhKTz2qQpUWAypZZVHvs3TG+wCZSn06tmVw08+J87EXydNsoKbqaWgQwob9Kd9mSN9ZX8fAz+erAKADpCPQiCqJ6DN8bQqwfL/CgG1hn3c6nAFBebz2e52dnq4h+ze38hhyNs9j+/hi6rhETmPfUkpLiKyHl79jadEbw31RCAo32S3Tx7E06r8gEN6rG4d+jceB8Lfmuw9SyuXG5TQyF/rD2fTl/7o5uqDnyiKMh0+YJhCidtp0+5Z5oYrKTViiCEh/W8722Tq5vIhXtUQv5H+kWFC9oHC/GoZuh2OOZPya3VYbnLCJbK+B4d/q2Y9lfi9tGbfYuUZYsmP0oSztgAcZEOBy19SJ048bBGXTM7n/kV8mn67HV7SzJe5R072myKgEZNX7TDp3w2UylIY/WXcq+X6m6Qqhb8j7kt5j4MkafIWVdlC/IVuvxt5CimVR0b8QrWu0dQQOev6t1+r2CnPeOKJesguSwPnJqVC2G+94izdkcUCUMnugm1WfsA00x6rH3HgzngEfG8Mr9BQeW2+kUh0OhK1SSudqPDaow5ob0INAl491mcyJfYDcBHo9jADWC76drMXQw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(26005)(316002)(508600001)(54906003)(110136005)(2616005)(86362001)(82310400005)(7696005)(6666004)(356005)(81166007)(36860700001)(40460700003)(16526019)(186003)(336012)(47076005)(426003)(83380400001)(1076003)(70586007)(70206006)(36756003)(4326008)(8676002)(8936002)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:27.8069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9916ea44-6b51-4326-8427-08da4e6cd000
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4545
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
in VM and vCPU scope both works as expected.

Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 147 ++++++++++++++++++
 4 files changed, 150 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 4509a3a7eeae..2b50170db9b2 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/cpuid_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
+/x86_64/disable_exits_test
 /x86_64/evmcs_test
 /x86_64/emulator_error_test
 /x86_64/fix_hypercall_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 22423c871ed6..de11d1f95700 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -115,6 +115,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
+TEST_GEN_PROGS_x86_64 += x86_64/disable_exits_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index a25aabd8f5e7..d8cad1cff578 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -17,6 +17,7 @@
 #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
 
 #define SVM_EXIT_MSR		0x07c
+#define SVM_EXIT_HLT		0x078
 #define SVM_EXIT_VMMCALL	0x081
 
 struct svm_test_data {
diff --git a/tools/testing/selftests/kvm/x86_64/disable_exits_test.c b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
new file mode 100644
index 000000000000..8ca427357ed0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test per-VM and per-vCPU disable exits cap
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "svm_util.h"
+#include "vmx.h"
+#include "processor.h"
+
+#define VCPU_ID_1 0
+#define VCPU_ID_2 1
+
+static void guest_code_exits(void) {
+	asm volatile("sti; hlt; cli");
+}
+
+/* Set debug control for trapped instruction exiting to userspace */
+static void vcpu_set_debug_exit_userspace(struct kvm_vm *vm, int vcpuid,
+		struct kvm_guest_debug *debug) {
+	memset(debug, 0, sizeof(*debug));
+	debug->control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_EXIT_USERSPACE;
+	vcpu_set_guest_debug(vm, VCPU_ID_1, debug);
+}
+
+static void test_vm_cap_disable_exits(void) {
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_DISABLE_EXITS,
+		.args[0] = KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE,
+	};
+	struct kvm_guest_debug debug;
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+
+	/* Create VM */
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	/* Test Case #1
+	 * Default without disabling HLT exits in VM scope
+	 */
+	vm_vcpu_add_default(vm, VCPU_ID_1, (void *)guest_code_exits);
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_1, &debug);
+	run = vcpu_state(vm, VCPU_ID_1);
+	vcpu_run(vm, VCPU_ID_1);
+	/* Exit reason should be HLT */
+	if (is_amd_cpu())
+		TEST_ASSERT(run->hw.hardware_exit_reason == SVM_EXIT_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+	else
+		TEST_ASSERT(run->hw.hardware_exit_reason == EXIT_REASON_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+
+	/* Test Case #2
+	 * Disabling HLT exits in VM scope
+	 */
+	vm_vcpu_add_default(vm, VCPU_ID_2, (void *)guest_code_exits);
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_2, &debug);
+	run = vcpu_state(vm, VCPU_ID_2);
+	/* Set VM scoped cap arg
+	 * KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE
+	 * after vCPUs creation so requiring override flag
+	 */
+	TEST_ASSERT(!vm_enable_cap(vm, &cap), "Failed to set KVM_CAP_X86_DISABLE_EXITS");
+	vcpu_run(vm, VCPU_ID_2);
+	/* Exit reason should not be HLT, would finish the guest
+	 * running and exit (e.g. SVM_EXIT_SHUTDOWN)
+	 */
+	if (is_amd_cpu())
+		TEST_ASSERT(run->hw.hardware_exit_reason != SVM_EXIT_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+	else
+		TEST_ASSERT(run->hw.hardware_exit_reason != EXIT_REASON_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+
+	kvm_vm_free(vm);
+}
+
+static void test_vcpu_cap_disable_exits(void) {
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_DISABLE_EXITS,
+		.args[0] = KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE,
+	};
+	struct kvm_guest_debug debug;
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+
+	/* Create VM */
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm_vcpu_add_default(vm, VCPU_ID_1, (void *)guest_code_exits);
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_1, &debug);
+	vm_vcpu_add_default(vm, VCPU_ID_2, (void *)guest_code_exits);
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_2, &debug);
+	/* Set vCPU 2 scoped cap arg
+	 * KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE
+	 */
+	TEST_ASSERT(!vcpu_enable_cap(vm, VCPU_ID_2, &cap), "Failed to set KVM_CAP_X86_DISABLE_EXITS");
+
+	/* Test Case #3
+	 * Default without disabling HLT exits in this vCPU 1
+	 */
+	run = vcpu_state(vm, VCPU_ID_1);
+	vcpu_run(vm, VCPU_ID_1);
+	/* Exit reason should be HLT */
+	if (is_amd_cpu())
+		TEST_ASSERT(run->hw.hardware_exit_reason == SVM_EXIT_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+	else
+		TEST_ASSERT(run->hw.hardware_exit_reason == EXIT_REASON_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+
+	/* Test Case #4
+	 * Disabling HLT exits in vCPU 2
+	 */
+	run = vcpu_state(vm, VCPU_ID_2);
+	vcpu_run(vm, VCPU_ID_2);
+	/* Exit reason should not be HLT, would finish the guest
+	 * running and exit (e.g. SVM_EXIT_SHUTDOWN)
+	 */
+	if (is_amd_cpu())
+		TEST_ASSERT(run->hw.hardware_exit_reason != SVM_EXIT_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+	else
+		TEST_ASSERT(run->hw.hardware_exit_reason != EXIT_REASON_HLT,
+			"Got exit_reason other than HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	test_vm_cap_disable_exits();
+	test_vcpu_cap_disable_exits();
+	return 0;
+}
-- 
2.32.0

