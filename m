Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752E6553FC2
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 02:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355651AbiFVAzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 20:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355521AbiFVAzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 20:55:09 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6487F3121F;
        Tue, 21 Jun 2022 17:55:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DItf89OdARekr+axdNaqbJCYdsLKGDFfjCSKHdQdf8f+2e0422hAyv3xGkR8ax5RKEPX5bVrfvVnQFRyyW+JO1BKCtT7QaOnjmhoVbRXrMdKGrOdPlyEG1Nx/Bu7aSi627chlGz1yHZ2VW1m/oHzZXn28NIZ2CB/1aqneTXGUrM1oKRHqVN7Wq2wvtDLpeeJ23VIDP6J1gC15w7BzBr0ynfic+SSjLDTDcrQ4Fj9XVthf+4D7zuMWZYVjVG4xurgHQuUOtiHFjPmcjg46ay01wK6+nW4Gge8CHaQtmemg7OSzZoKwZsXMNm73yD0K5+MSUR1lst9DgEwzRNotJQxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6sM/iRwF74JFgrOO0JWhCmP5hQ8DNSTpvZcZ8gt6u4=;
 b=mFtGCchzJRnidZsxP5tl6LPWMeVkk5/4i29bk4dV7X3MqVqCHl5gLzY9+SqWTXqOEE2/fNrreNpE37CYUDdlTr863jZ5HV5uZQYBUAEIYQ/wADXbr7Xt6hTXryEXWTKtsv8hd77ThPnT5k18I6m9UZxw5zNpEYeoLAx94RrLKEWUlM8x3Y00Is9fEU6Nvy0RC0b9WSOCasnNR+LtOI/TgXvGMLBiiD3YM2t6aRxXO1UDieQcNFIVcV2Aj61tjSXpy+nAaG5N9tCs2qlWYfYvEcOol8eMXmrjv1xQ4woz2pIWGn1XaOwqy50GHm94NEG/GamU+TICN0J5/+ExUx9bxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6sM/iRwF74JFgrOO0JWhCmP5hQ8DNSTpvZcZ8gt6u4=;
 b=Jybnq8PzNJ8OXoNCylngpIXHWcCuxZ5x/Aga0Fegy3qbTquB8rdlpm6JcIKD7li1+LMSb5fWNWEFx3yyNBy0RN+UWygpr6/gXSBSFCkTnAJl6tzow1xJ711y3y0n/kTzwgj0016zxC6sGC5X7dne1mszNtZKypS1+5qYJHUkiuAfpSQ8VTzefnohJR+sCCcS1MkZt6k068uJAKmqJgUxgDWiqRRExs1lwlprb4gxboH3/bGwB0BUFm8kQ2VRfXdhNy+z1/t13IqRsU6UkVqUteeyZ3bETtAbHOsb1ep7tCA1Z9YUprUoQ8K/2xFIzlAulMvV7tm/cjWzIUplXqKKCg==
Received: from BN6PR16CA0008.namprd16.prod.outlook.com (2603:10b6:404:f5::18)
 by BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Wed, 22 Jun
 2022 00:55:04 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::7f) by BN6PR16CA0008.outlook.office365.com
 (2603:10b6:404:f5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Wed, 22 Jun 2022 00:55:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Wed, 22 Jun 2022 00:55:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:55:03 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:55:02 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 7/7] KVM: selftests: Add tests for VM and vCPU cap KVM_CAP_X86_DISABLE_EXITS
Date:   Tue, 21 Jun 2022 17:49:24 -0700
Message-ID: <20220622004924.155191-8-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622004924.155191-1-kechenl@nvidia.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbe318e8-ddcc-40ae-8a6d-08da53e9d804
X-MS-TrafficTypeDiagnostic: BY5PR12MB4903:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4903F931CAFAEFD22BECF622CAB29@BY5PR12MB4903.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VWzlnUNc3fZnO3sbaRkjAklTHYOEJd38ODbX98gLquszMmBz5y027v0PdduUhrf506Pul6roFlFrCRhIFTGomc2dnullkR95fkUBVs6zAFIhHdxu447muZZVrMlHP2fhqsarxYgbVHNrwvJogAgR9HP703sDo4MEXNyYh6gF07kVR48Y+EtN3vVVdp+9AhoSCyazMtV7DhXkb6NGaVktWMu2unx0OxTWL9SuPBOsjFkr32++FphdPZlSbPF6kvfMV7dmT4/VDWizNIVmqsn+t0m3Pfg3VXZuqWJf4rEfRuF6/BkYSKcyS6fygissyqx4/hNzpul5dLgjesAHSClQVpqDznY3xCvF5WbrSmFopAOLt2aoyGZ/SwECSgmyg2fmgNg2ppHteyeG8P7EFXQDY4jUONfNJWW1sfnaC3memuz5TL/W1F8ggpBdmttfxS7wbuY28o4hAoUe1xAjTneyehAGvbMl3jQz0b0/2Ex/o+aSvAwex8i1KPJdPMuwAAUlbLfdaup18lzaRboS5zaz/gS8hGk6HCt84EULP3Wvx4GVr+m9rf2lKPGN+iswSFCvFdUo9CfFv+LfBb0ziw8aXpv1XS3npnxIlVqiM8hKrGLlD4KKDVEZWZsBHcP4Qu3U1B8pw/np3ZWWQHn1oTR2uY6NqvDjknwoh1flyxCphPFQAqIo8rhWP1rmilH/PluGqIrixFQjI4SGOYENL4IfuMmMInTtvFXLiJN66LdBFuI/ZUG+mxBFQfWtakNyGaWk
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(346002)(40470700004)(36840700001)(46966006)(82740400003)(41300700001)(336012)(1076003)(4326008)(36860700001)(110136005)(316002)(2616005)(70586007)(426003)(356005)(8676002)(40460700003)(82310400005)(83380400001)(16526019)(40480700001)(36756003)(186003)(47076005)(86362001)(70206006)(26005)(81166007)(6666004)(8936002)(478600001)(54906003)(5660300002)(7696005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:55:04.1133
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe318e8-ddcc-40ae-8a6d-08da53e9d804
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
in VM and vCPU scope both works as expected.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 145 ++++++++++++++++++
 4 files changed, 148 insertions(+)
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
index 000000000000..2811b07e8885
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
@@ -0,0 +1,145 @@
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
+static void vcpu_set_debug_exit_userspace(struct kvm_vm *vm, int vcpu_id) {
+	struct kvm_guest_debug debug;
+	memset(&debug, 0, sizeof(debug));
+	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_EXIT_USERSPACE;
+	vcpu_set_guest_debug(vm, vcpu_id, &debug);
+}
+
+static void test_vm_cap_disable_exits(void) {
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_DISABLE_EXITS,
+		.args[0] = KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE,
+	};
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
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_1);
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
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_2);
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
+			"Got exit_reason as HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+	else
+		TEST_ASSERT(run->hw.hardware_exit_reason != EXIT_REASON_HLT,
+			"Got exit_reason as HLT: 0x%llx\n",
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
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+
+	/* Create VM */
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm_vcpu_add_default(vm, VCPU_ID_1, (void *)guest_code_exits);
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_1);
+	vm_vcpu_add_default(vm, VCPU_ID_2, (void *)guest_code_exits);
+	vcpu_set_debug_exit_userspace(vm, VCPU_ID_2);
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
+			"Got exit_reason as HLT: 0x%llx\n",
+			run->hw.hardware_exit_reason);
+	else
+		TEST_ASSERT(run->hw.hardware_exit_reason != EXIT_REASON_HLT,
+			"Got exit_reason as HLT: 0x%llx\n",
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

