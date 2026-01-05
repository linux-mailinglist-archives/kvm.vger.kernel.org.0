Return-Path: <kvm+bounces-67005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 566D3CF2163
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32DBB302B129
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10EB1BD9C9;
	Mon,  5 Jan 2026 06:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BqraA+27"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010007.outbound.protection.outlook.com [52.101.85.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F864502A
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595042; cv=fail; b=EWg+e2lH5OBeMxynnUZblG3bwMhL/IU8gfGCiTQltAqleEUNo1wV0fEmU5UShxFkpSQDA0LJRnbiv68wRCzwvPd99aWn1VbiGiGV04ajSKEGYmXd7uHwaNcvSJ+Y+IbkecF8GlX9u2BTJHDiPHU36zF8uSE6weIj4tLyvUcQ64E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595042; c=relaxed/simple;
	bh=ylrT2cfnjN+myvRUKyE/QqgFaHcWSYpPUSBO4LSEPoI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NU+GrAkLng9YF1SsZH6R2Mc4Ya5kcqcIb9nqUdtMMP2DtBqUjH1EWm/K1Lk/QQOmq8vhPZRHC5ZRkl4plpYfUa+9hPD4LpqEOBLPs4rUVkhwQ6sZ//Wg9tsjLpiUdhkPl2TjGKJDgiD4IsbL1E/L0qcs9Hyp6yrbUf47zDKyEyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BqraA+27; arc=fail smtp.client-ip=52.101.85.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w89M4VAXNKdgOg2dwN9RybPxFvzC9tJNn7nMkqZlM9MXWvfhCGE66m1zc7XbXR1kP/cM6pWSgr3dV/IQmKrSNr6PiOWlnZSFKs/TVt7aXsd2h70LK8TAgFnnNz7QZeOEy9i15zTwzg7vIlO3YuE+Ki7jt/L/OOWEeGbL3+I08BRTi/cmZVFpY4H24trLCoFN80qcPnBDiLuiNwGs9Qms2UdPoQACQjwtUZxtSwkAsYRTzkZmPLpEbS7R/ytJRCQ62qhyzNx5PPFOlpemjOqY3plk/PtkLWTI515y0wzJjKTv790IU4wS6S/Xnpx2FkXyv0RizTAQ77KCVRxUPpkG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ujBOvkceo0NgU8HiLHdMBfCzF1gcNHPF3yTdSusQmfs=;
 b=qZVi4rynrnk98xpKls2CqRN0yCZ05S7R5YBToSYyRe1QA5l5A25hx0mWG3QgjV6LaqDkWvv2ibsHxrI2sLuzBMguQ556RNXma2d6nvkF/D07UpVDs/tCYZlGgbB4OIIxtE84lZqnmu0QPpvg4QcFCiLlKCEJh7qe6KQrjUPRcGTYRohYTIqCeQYh9lHOH68zxGa///LMkTnHsK79PyoF2zm1IKO4+EFAG0Y9s2S1/6qhMUzheWuTQCN1x1RX1exLLNoxA70TB6JejhacdkAbCkUoWJeM9d1GnLz3L/jFKDOabzzxNiia3+i7Z/OToONFvjdKnQC2kwvSP0RA5YZNMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujBOvkceo0NgU8HiLHdMBfCzF1gcNHPF3yTdSusQmfs=;
 b=BqraA+27e+aCE7OzYZ7xq9LyUSnfrzJmhGuk/1+re2AzlrkVxs17s/nXaBlTBBDzI6PjZlV7hwlvnccxmK8XO7EowwDIjHe+Bte0rJ+ZFJM/38iyiFBhSp3GVYh/Oiav4kDbx0seubcagfp79nqoUrp+7JXbOxmE13PhcGAHa9U=
Received: from DM6PR02CA0118.namprd02.prod.outlook.com (2603:10b6:5:1b4::20)
 by CH3PR12MB8851.namprd12.prod.outlook.com (2603:10b6:610:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:37:17 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:5:1b4:cafe::68) by DM6PR02CA0118.outlook.office365.com
 (2603:10b6:5:1b4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:37:17 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:37:13 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 8/8] selftests: KVM: x86: Add SEV PML dirty logging test
Date: Mon, 5 Jan 2026 06:36:22 +0000
Message-ID: <20260105063622.894410-9-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|CH3PR12MB8851:EE_
X-MS-Office365-Filtering-Correlation-Id: fa67ff26-e384-43a9-23bc-08de4c24dece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?asX8+xiYXK9yfirRFurMcATFKsnrhfY/xQqkT9bysAWsBDI7ZrwBMwJ0yZhi?=
 =?us-ascii?Q?bYiggozSSyQ59fV3CWI/zmiGcngPNfGCNR69v1J7HyqkMyGy+JNRFFduNeEu?=
 =?us-ascii?Q?2au0Ydnh/wg/ZzrAfIBm4odIwZdcctMgJiyg6ZhsCngY4+BQ1O7CNkeJ4gnz?=
 =?us-ascii?Q?LmtofFVzFfYTfsqPMTAG8dye7g0Nylk9rIN+Gpj6Qj99NUdnKzZli/Rux2a3?=
 =?us-ascii?Q?ULfX1FmCBy/rFm/06QGifZSdRoGtyfiJ4kHcwwWOt31SObg9zn6G9+YNH0Tl?=
 =?us-ascii?Q?c8HSsX4Ie+IdTOQFTWKyJ32FAxrWciuc0AmAIp4ljpoWBd2K7iOlaeT/wCgm?=
 =?us-ascii?Q?TdtlcsbDEcxJFS1F4u0mSgHX6aktNcKu0v/t/xWhRbIVc9y4rSXIg4KT8JBG?=
 =?us-ascii?Q?YhjDy7vxexNV02AVQveNpdx1nFr6GtayKqfrTzm3PJz3S21TXK4JVjGR1Asr?=
 =?us-ascii?Q?CghcAaxhZeWr8gnvsWJkBfU4pUVXpy0HZQAenisk27JhqqajUZfBl2kLhm1A?=
 =?us-ascii?Q?CkVGCCv0dA3aGgbIaIseAgvRNkimNgC6KdK1jrna/Jp2HvdLlkiFtsy2qBnh?=
 =?us-ascii?Q?6bZAakMrl89o8DkA4RAJz0LWrnb/LeQW0J2xou+OR6BZjlzLhZ/Yy0fddEGe?=
 =?us-ascii?Q?ngIML+75uxRWd/zqgI72F4h1o70ZoI6vLgx4D73TpoKR8DBKa9iSSTOKT7Eh?=
 =?us-ascii?Q?KP/FHabL0qwoGOBODap0EfceP1ave4NAWvyIiBjVdXgZdVe5CUoNwjoK3g2+?=
 =?us-ascii?Q?nAueNihEJRsdNrm3vY+N3T7X4//rucjQODRXr9iNgMf8Q58gMT2ULZ5JOJTZ?=
 =?us-ascii?Q?6s6nAECM2Uz0sK/GEjZQ0TB5Y1jUX9CkcHijY7IcIoa0LZNdyPtvgW3+IH50?=
 =?us-ascii?Q?8kr7+aQU/VIt2OUO3C5w/H5NfYIkc0qcixcuw8mE1q3rSnoAWZkLiKMeKOZC?=
 =?us-ascii?Q?8yNDKxlHstkBIaukDhm4KzI2ZWU/UCgwrbnhFuAKG9/uc8+igofr0pzKrj5R?=
 =?us-ascii?Q?0ubZXmFZ8ARHcDGnUjWyNSQ5XN7+7ISoeU8DrwHLFBcAe65a2H2rvypkriSz?=
 =?us-ascii?Q?NaGZRAKrCe2bHOIWDfc5RU5+ZHtOb1Z8zf/DpPVQLXic6qcHfRy+GAKe9N66?=
 =?us-ascii?Q?gMla2ibs0rUJ7iNwntY4Ta22vWqMOeNUefnGcUF6E6kdhO7JUTc3pt1HL75q?=
 =?us-ascii?Q?pY2jm71peuQNs9ceeoHbzW0zYQoXpNDAn7MJdj9+bm+h+/nTzsBNETqapFjV?=
 =?us-ascii?Q?zll5tqdVr688+uuxsjDeoGexVcQxHz9VqZW5vB6Iuj/6aI+2HK6o9pGhiyC/?=
 =?us-ascii?Q?ie7vVvCRImie6Bcl//rzG9csGtqXlQKz4/03ab3zLfZdPVGi58FSysafiC+f?=
 =?us-ascii?Q?IRk5zliLq0iNpF21J/lWpvAOv55HaiyDDvTDjiLuNgBso0iK8vJyaUPCakND?=
 =?us-ascii?Q?W/I4kLM+6+tgCPsUB4MDskgxNmgOVD0pONM/paLMdLGsfB5IM2kG1J0uCNgn?=
 =?us-ascii?Q?L16nrpvP/Af5WCP0rbjERRLVk7MMgoiaowLOgtYPxFAkd5kPIpwLwKQ8dYXT?=
 =?us-ascii?Q?UnHDjp/6jCqBj0T7b/c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:37:17.2972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa67ff26-e384-43a9-23bc-08de4c24dece
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8851

Add a KVM selftest to verify Page Modification Logging (PML) functionality
with AMD SEV/SEV-ES/SEV-SNP guests. The test validates that
hardware-assisted dirty page tracking works correctly across different SEV
guest types.

Test methodology:
- Create SEV guest with additional memory slot for dirty logging
- Guest continuously writes to random pages within the test memory region
- Host periodically retrieves dirty log bitmap via KVM_GET_DIRTY_LOG
- Verify dirty pages match actual guest writes

Introduce vm_sev_create_with_one_vcpu_extramem() to allow specifying extra
memory pages during VM creation.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/include/x86/sev.h |   4 +
 tools/testing/selftests/kvm/lib/x86/sev.c     |  18 +-
 .../testing/selftests/kvm/x86/sev_pml_test.c  | 203 ++++++++++++++++++
 4 files changed, 223 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/sev_pml_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..746c79713c8d 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -134,6 +134,7 @@ TEST_GEN_PROGS_x86 += x86/xen_vmcall_test
 TEST_GEN_PROGS_x86 += x86/sev_init2_tests
 TEST_GEN_PROGS_x86 += x86/sev_migrate_tests
 TEST_GEN_PROGS_x86 += x86/sev_smoke_test
+TEST_GEN_PROGS_x86 += x86/sev_pml_test
 TEST_GEN_PROGS_x86 += x86/amx_test
 TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 008b4169f5e2..b06583b91447 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -53,8 +53,12 @@ void snp_vm_launch_start(struct kvm_vm *vm, uint64_t policy);
 void snp_vm_launch_update(struct kvm_vm *vm);
 void snp_vm_launch_finish(struct kvm_vm *vm);
 
+struct kvm_vm *_vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
+					   struct kvm_vcpu **cpu, uint64_t npages);
 struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
 					   struct kvm_vcpu **cpu);
+struct kvm_vm *vm_sev_create_with_one_vcpu_extramem(uint32_t type, void *guest_code,
+					   struct kvm_vcpu **cpu, uint64_t npages);
 void vm_sev_launch(struct kvm_vm *vm, uint64_t policy, uint8_t *measurement);
 
 kvm_static_assert(SEV_RET_SUCCESS == 0);
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index c3a9838f4806..20d67d01c997 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -158,8 +158,8 @@ void snp_vm_launch_finish(struct kvm_vm *vm)
 	vm_sev_ioctl(vm, KVM_SEV_SNP_LAUNCH_FINISH, &launch_finish);
 }
 
-struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
-					   struct kvm_vcpu **cpu)
+struct kvm_vm *_vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
+					   struct kvm_vcpu **cpu, uint64_t npages)
 {
 	struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
@@ -168,12 +168,24 @@ struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
 	struct kvm_vm *vm;
 	struct kvm_vcpu *cpus[1];
 
-	vm = __vm_create_with_vcpus(shape, 1, 0, guest_code, cpus);
+	vm = __vm_create_with_vcpus(shape, 1, npages, guest_code, cpus);
 	*cpu = cpus[0];
 
 	return vm;
 }
 
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t type, void *guest_code,
+					   struct kvm_vcpu **cpu)
+{
+	return _vm_sev_create_with_one_vcpu(type, guest_code, cpu, 0);
+}
+
+struct kvm_vm *vm_sev_create_with_one_vcpu_extramem(uint32_t type, void *guest_code,
+						    struct kvm_vcpu **cpu, uint64_t npages)
+{
+	return _vm_sev_create_with_one_vcpu(type, guest_code, cpu, npages);
+}
+
 void vm_sev_launch(struct kvm_vm *vm, uint64_t policy, uint8_t *measurement)
 {
 	if (is_sev_snp_vm(vm)) {
diff --git a/tools/testing/selftests/kvm/x86/sev_pml_test.c b/tools/testing/selftests/kvm/x86/sev_pml_test.c
new file mode 100644
index 000000000000..b1114f5a67f8
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/sev_pml_test.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/bitmap.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "sev.h"
+
+#define GUEST_NR_PAGES (1024)
+#define DEFAULT_GUEST_TEST_MEM 0xC0000000
+#define TEST_MEM_SLOT_INDEX 1
+
+/*
+ * Guest/Host shared variables.
+ */
+static uint64_t guest_page_size;
+static uint64_t guest_num_pages;
+
+/* Points to the test VM memory region on which we track dirty logs */
+static void *host_test_mem;
+
+/* Host variables */
+static pthread_t vcpu_thread;
+static bool vcpu_thread_done;
+
+/*
+ * Guest physical memory offset of the testing memory slot.
+ * This will be set to the topmost valid physical address minus
+ * the test memory size.
+ */
+static uint64_t guest_test_phys_mem;
+
+/*
+ * Guest virtual memory offset of the testing memory slot.
+ * Must not conflict with identity mapped test code.
+ */
+static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
+
+/*
+ * Continuously write to the first 8 bytes of a random pages within
+ * the testing memory region.
+ */
+static void guest_pml_code(void)
+{
+	uint64_t addr;
+	int write = 0;
+
+	while (write++ != (guest_num_pages * 10)) {
+		addr = guest_test_virt_mem;
+		addr += (guest_random_u64(&guest_rng) % guest_num_pages) * guest_page_size;
+
+		vcpu_arch_put_guest(*(uint64_t *)addr, 0xAA);
+	}
+}
+
+static void guest_pml_sev_code(void)
+{
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+
+	guest_pml_code();
+
+	GUEST_DONE();
+}
+
+static void guest_pml_sev_es_code(void)
+{
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ES_ENABLED);
+
+	guest_pml_code();
+
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_TERM_REQ);
+	vmgexit();
+}
+
+static void guest_pml_sev_snp_code(void)
+{
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ES_ENABLED);
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_SNP_ENABLED);
+
+	guest_pml_code();
+
+	wrmsr(MSR_AMD64_SEV_ES_GHCB, GHCB_MSR_TERM_REQ);
+	vmgexit();
+}
+
+static unsigned long *bmap;
+static void *vcpu_worker(void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vcpu->vm;
+	while (1) {
+		/* Let the guest dirty the random pages */
+		vcpu_run(vcpu);
+
+		if (is_sev_es_vm(vm)) {
+			TEST_ASSERT(vcpu->run->exit_reason == KVM_EXIT_SYSTEM_EVENT,
+				    "Wanted SYSTEM_EVENT, got %s",
+				    exit_reason_str(vcpu->run->exit_reason));
+			TEST_ASSERT_EQ(vcpu->run->system_event.type, KVM_SYSTEM_EVENT_SEV_TERM);
+			TEST_ASSERT_EQ(vcpu->run->system_event.ndata, 1);
+			TEST_ASSERT_EQ(vcpu->run->system_event.data[0], GHCB_MSR_TERM_REQ);
+			break;
+		}
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			continue;
+		case UCALL_DONE:
+			goto exit_done;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected exit: %s", exit_reason_str(vcpu->run->exit_reason));
+		}
+	}
+
+exit_done:
+	WRITE_ONCE(vcpu_thread_done, true);
+	return NULL;
+}
+
+static void vm_dirty_log_verify(void)
+{
+	uint64_t page, nr_dirty_pages = 0, nr_clean_pages = 0;
+
+	for (page = 0; page < guest_num_pages; page++) {
+		uint64_t val = *(uint64_t *)(host_test_mem + page * guest_page_size);
+		bool bmap_dirty = __test_and_clear_bit(page, bmap);
+
+		if (bmap_dirty && val == 0xAA)
+			nr_dirty_pages++;
+		else
+			nr_clean_pages++;
+	}
+	pr_debug("Dirty pages %ld clean pages %ld\n", nr_dirty_pages, nr_clean_pages);
+}
+
+void test_pml(void *guest_code, uint32_t type, uint64_t policy)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_sev_create_with_one_vcpu_extramem(type, guest_code, &vcpu, 2 * GUEST_NR_PAGES);
+
+	guest_page_size = vm->page_size;
+	guest_num_pages = GUEST_NR_PAGES;
+	guest_test_phys_mem = (vm->max_gfn - guest_num_pages) * guest_page_size;
+
+	bmap = bitmap_zalloc(guest_num_pages);
+
+	/* Add an extra memory slot for testing dirty logging */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				guest_test_phys_mem,
+				TEST_MEM_SLOT_INDEX,
+				guest_num_pages,
+				KVM_MEM_LOG_DIRTY_PAGES);
+
+	/* Do mapping for the dirty track memory slot */
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
+	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+
+	/* Export the shared variables to the guest */
+	sync_global_to_guest(vm, guest_page_size);
+	sync_global_to_guest(vm, guest_test_virt_mem);
+	sync_global_to_guest(vm, guest_num_pages);
+
+	WRITE_ONCE(vcpu_thread_done, false);
+	vm_sev_launch(vm, policy, NULL);
+
+	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
+	while (!READ_ONCE(vcpu_thread_done)) {
+		usleep(1000);
+		kvm_vm_get_dirty_log(vcpu->vm, TEST_MEM_SLOT_INDEX, bmap);
+	}
+	pthread_join(vcpu_thread, NULL);
+
+	vm_dirty_log_verify();
+	free(bmap);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(get_kvm_amd_param_bool("pml"));
+
+	if (kvm_cpu_has(X86_FEATURE_SEV))
+		test_pml(guest_pml_sev_code, KVM_X86_SEV_VM, SEV_POLICY_NO_DBG);
+
+	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
+		test_pml(guest_pml_sev_es_code, KVM_X86_SEV_ES_VM,
+			 SEV_POLICY_ES | SEV_POLICY_NO_DBG);
+
+	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+		test_pml(guest_pml_sev_snp_code, KVM_X86_SNP_VM,
+			 snp_default_policy() | SNP_POLICY_DBG);
+
+	return 0;
+}
-- 
2.48.1


