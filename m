Return-Path: <kvm+bounces-12267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B73880E0E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 316A21F2434B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FBB38DE8;
	Wed, 20 Mar 2024 08:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ugODw2v1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD49F747F
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710925060; cv=fail; b=Gce2XacdibNfCDI5fptrncbZ/J9Cp2cskquAhnyCL+e/3Fn3Epvvwce4kUEAurYowsbizQYLlKlXrA3jPivYdi37TRvqham9DTJ77CtOQwBsQlqjTxsjcng9hIqdNPfAl+0zpYMAPN9iel5qrnh4Pmj84At67rCUpa/vahiF7vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710925060; c=relaxed/simple;
	bh=vIgAeyeBjI2azD7g2QOnnEDu0508QUr29U56a7cvXKo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYOXtsMrbn0q2eSuKFdJpyMtWvcZKGf8v2XxZya18VdtdS1y+t8aVaLiJKqUkre67cFbcz/K2QfM1ozOgD5+GZppJs4qirSYM9yegnI2SVHH93vf8NEF6gDIxieG2zzx58Xg4OJflZa+iqm5+SgsemwQJaB/g6A7z5PF5xQn0eY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ugODw2v1; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gY671L3qKzRm8TL7+AwwH5/RmzSr2GMjYrAZJiY2YIOkSjyeMCRn3juAS91tmJQ8Gyztk1emLvuXgBGJ8P9CM4SGoZJplVLprXUTznFO7fI/isBfQWwiPE5/PrlWNz+mPjZziDAGWlVwbt0cYTvERWaqi69j0jxqjmccYeeVfv1ZcZZ+jxk7F+NWk66GddT56svrTu5yxRf10QRm0ijN5+lYBLnGVw59EZqwffofeKTY3TH/AAzEWE/EyVMJfm5sYA+Vv0d/ba5tvG06Ekgxa5PH5rN6pH6HJcdGQerGmzUK6/01PStwEwRV3cswgii20qNiDhw2A69FzMb67ieCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fN67WG8ZcQxLNNP+yKcr0fqs8Rqg6oQGwkEMqqug9o4=;
 b=nyLUbyuSUKqlIKzh4/e1hmpl3KGZ7Ims8ioTu+fTmStLoiVss99dCxmxdnys/GSzvHJWQ+OASk67Rk6aChBm+8k+yGJHeqGDIyiebcojk66zLeB8YbfD2T+iUlSAptUfLJN3HhGrAuMcdoo2IMOjyJ59aezl+ox4Rr1yJiWBNmg8Hws9+WzIjBwMfD5YxHXZc6vJ2wALBCuflGC/0P0dmS+5Ouo0kP7M5uHcVv2YfCtL+JUHlitGPfIjuqSflGW4qHfchypfqQ8ju247ORtaW+V2yiNiJVr2KwIIQdCvWXLMeCvOzEaFSFNm1xaTtjfXm5BUONWeLAIQErD4CJ9uaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fN67WG8ZcQxLNNP+yKcr0fqs8Rqg6oQGwkEMqqug9o4=;
 b=ugODw2v1haDasc2xNc9qQFlI3ibluF4GTHCS/6kmVLT8KRZvPbyZ8jjTuFhhS28wa1Km+l6ofd03/N2/5lDbZQ+khF4m/edydq0MMR6NPfGSlJ7lM8zuXcOkuNKocl3EoPuqs8jVa329waAVi6CO+ZqvnZf5U+cwQmAV+AqawF4=
Received: from BYAPR07CA0005.namprd07.prod.outlook.com (2603:10b6:a02:bc::18)
 by PH7PR12MB6443.namprd12.prod.outlook.com (2603:10b6:510:1f9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:57:34 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::be) by BYAPR07CA0005.outlook.office365.com
 (2603:10b6:a02:bc::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:57:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:57:33 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 06/49] RAMBlock: Add support of KVM private guest memfd
Date: Wed, 20 Mar 2024 03:39:02 -0500
Message-ID: <20240320083945.991426-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|PH7PR12MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: a616c3df-a313-4e71-7833-08dc48bbc899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TRljJLKJI+Fn7HLG/hrSDyp2wQmEtxnDxsUu/pcEx8blLA2OYlM8ULyZHW6GOO71h+cB6uTUbaQtkFSt8hEAedNUQhMdv2Rdp59VHKeyk4WKc8gcsuto9uM1xXuHyQ4oe3NVeK36PAYGVnLhtsgdKw9XTB3HEHJKwetscV/6Krmufm1FfOys9QJaAN0YhM5R8gKAwa5foKeBHARYBydwfxB+zsD5dVlamOAYewUTLA+20M/fQFjLFcvcLn81gqi5UuBaRTMTM3GoQZC0ymcLjdzMidqWtpuU9WRcMohCxXSaWiTG2JW+Odf9aYYb7dw/WHPzJQOJ5slhlwbvgSoJdcUwXi6tVWaae6K6gRdeMfzj0mrxzRWKr71RvwifzYXcJFIpzlYE1SCzojCSSiBQHcVp/mcB7tOI0ep9+hlA58dM2qlIj160/rr5hGA4XurUJYloeZywhfTlHl4ez79la/0XCFPJwqZb6LwXWiIbrousVI2EV8AoDk0/2oKeBG/LqKQwKPRpujFhH8G66SMp4xJGQ6v7C6GOjPRjMNeekXweAS9Cqy2abyhDMYw06UnDI1p2RlFJzDfUa/m3o2MN575nBZzguMMFe0jvM5cdsJmou/Vqw4mHFYxrnKWttrE82ZoqP0OknsnbeNeWiBdgdaf04gDG4ORnfDh7vWypXj1/zS6zTp90BPlk9OYxiHmfxBEy7MuUg3MnxqlGggqXgJBAzFQhBSkSS5J6q7XHTDEjQ0aR/mt8/6M3ohQBc4sS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:57:33.9790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a616c3df-a313-4e71-7833-08dc48bbc899
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6443

Add KVM guest_memfd support to RAMBlock so both normal hva based memory
and kvm guest memfd based private memory can be associated in one RAMBlock.

Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM ioctl to
create private guest_memfd during RAMBlock setup.

Allocating a new RAM_GUEST_MEMFD flag to instruct the setup of guest memfd
is more flexible and extensible than simply relying on the VM type because
in the future we may have the case that not all the memory of a VM need
guest memfd. As a benefit, it also avoid getting MachineState in memory
subsystem.

Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
confidential guests, such as TDX VM. How and when to set it for memory
backends will be implemented in the following patches.

Introduce memory_region_has_guest_memfd() to query if the MemoryRegion has
KVM guest_memfd allocated.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
Changes in v5:
- Use assert(new_block->guest_memfd < 0) instead of condition check;
- Collect Reviewed-by tag from David;

Changes in v4:
- Add clarification of RAM_GUEST_MEMFD in commit message; (David Hildenbrand)
- refine the return value and error message; (Daniel P. Berrangé)
- remove flags in ram_block_add(); (David Hildenbrand)

Changes in v3:
- rename gmem to guest_memfd;
- close(guest_memfd) when RAMBlock is released; (Daniel P. Berrangé)
- Suqash the patch that introduces memory_region_has_guest_memfd().

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c     | 25 +++++++++++++++++++++++++
 accel/stubs/kvm-stub.c  |  5 +++++
 include/exec/memory.h   | 20 +++++++++++++++++---
 include/exec/ram_addr.h |  2 +-
 include/exec/ramblock.h |  1 +
 include/sysemu/kvm.h    |  2 ++
 system/memory.c         |  5 +++++
 system/physmem.c        | 24 +++++++++++++++++++++---
 8 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a05dea2313..132ab65df5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -91,6 +91,7 @@ bool kvm_msi_use_devid;
 static bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
+static bool kvm_guest_memfd_supported;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -2395,6 +2396,8 @@ static int kvm_init(MachineState *ms)
     }
     s->as = g_new0(struct KVMAs, s->nr_as);
 
+    kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
+
     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
@@ -4099,3 +4102,25 @@ void kvm_mark_guest_state_protected(void)
 {
     kvm_state->guest_state_protected = true;
 }
+
+int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
+{
+    int fd;
+    struct kvm_create_guest_memfd guest_memfd = {
+        .size = size,
+        .flags = flags,
+    };
+
+    if (!kvm_guest_memfd_supported) {
+        error_setg(errp, "KVM doesn't support guest memfd\n");
+        return -1;
+    }
+
+    fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
+    if (fd < 0) {
+        error_setg_errno(errp, errno, "Error creating kvm guest memfd");
+        return -1;
+    }
+
+    return fd;
+}
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index ca38172884..8e0eb22e61 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -129,3 +129,8 @@ bool kvm_hwpoisoned_mem(void)
 {
     return false;
 }
+
+int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
+{
+    return -ENOSYS;
+}
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 8626a355b3..679a847685 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -243,6 +243,9 @@ typedef struct IOMMUTLBEvent {
 /* RAM FD is opened read-only */
 #define RAM_READONLY_FD (1 << 11)
 
+/* RAM can be private that has kvm guest memfd backend */
+#define RAM_GUEST_MEMFD   (1 << 12)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -1307,7 +1310,8 @@ bool memory_region_init_ram_nomigrate(MemoryRegion *mr,
  * @name: Region name, becomes part of RAMBlock name used in migration stream
  *        must be unique within any device
  * @size: size of the region.
- * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_NORESERVE.
+ * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_NORESERVE,
+ *             RAM_GUEST_MEMFD.
  * @errp: pointer to Error*, to store an error if it happens.
  *
  * Note that this function does not do anything to cause the data in the
@@ -1369,7 +1373,7 @@ bool memory_region_init_resizeable_ram(MemoryRegion *mr,
  *         (getpagesize()) will be used.
  * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
  *             RAM_NORESERVE, RAM_PROTECTED, RAM_NAMED_FILE, RAM_READONLY,
- *             RAM_READONLY_FD
+ *             RAM_READONLY_FD, RAM_GUEST_MEMFD
  * @path: the path in which to allocate the RAM.
  * @offset: offset within the file referenced by path
  * @errp: pointer to Error*, to store an error if it happens.
@@ -1399,7 +1403,7 @@ bool memory_region_init_ram_from_file(MemoryRegion *mr,
  * @size: size of the region.
  * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
  *             RAM_NORESERVE, RAM_PROTECTED, RAM_NAMED_FILE, RAM_READONLY,
- *             RAM_READONLY_FD
+ *             RAM_READONLY_FD, RAM_GUEST_MEMFD
  * @fd: the fd to mmap.
  * @offset: offset within the file referenced by fd
  * @errp: pointer to Error*, to store an error if it happens.
@@ -1722,6 +1726,16 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
  */
 bool memory_region_is_protected(MemoryRegion *mr);
 
+/**
+ * memory_region_has_guest_memfd: check whether a memory region has guest_memfd
+ *     associated
+ *
+ * Returns %true if a memory region's ram_block has valid guest_memfd assigned.
+ *
+ * @mr: the memory region being queried
+ */
+bool memory_region_has_guest_memfd(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 90676093f5..4ebd9ded5e 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -109,7 +109,7 @@ long qemu_maxrampagesize(void);
  *  @mr: the memory region where the ram block is
  *  @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
  *              RAM_NORESERVE, RAM_PROTECTED, RAM_NAMED_FILE, RAM_READONLY,
- *              RAM_READONLY_FD
+ *              RAM_READONLY_FD, RAM_GUEST_MEMFD
  *  @mem_path or @fd: specify the backing file or device
  *  @offset: Offset into target file
  *  @errp: pointer to Error*, to store an error if it happens
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 848915ea5b..459c8917de 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -41,6 +41,7 @@ struct RAMBlock {
     QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
     int fd;
     uint64_t fd_offset;
+    int guest_memfd;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 54f4d83a37..b4913281e2 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -536,4 +536,6 @@ void kvm_mark_guest_state_protected(void);
  * reported for the VM.
  */
 bool kvm_hwpoisoned_mem(void);
+
+int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
 #endif
diff --git a/system/memory.c b/system/memory.c
index a229a79988..c756950c0c 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -1850,6 +1850,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
     return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
 }
 
+bool memory_region_has_guest_memfd(MemoryRegion *mr)
+{
+    return mr->ram_block && mr->ram_block->guest_memfd >= 0;
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
diff --git a/system/physmem.c b/system/physmem.c
index 6cfb7a80ab..3a4a3f10d5 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1842,6 +1842,17 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         }
     }
 
+    if (kvm_enabled() && (new_block->flags & RAM_GUEST_MEMFD)) {
+        assert(new_block->guest_memfd < 0);
+
+        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
+                                                        0, errp);
+        if (new_block->guest_memfd < 0) {
+            qemu_mutex_unlock_ramlist();
+            return;
+        }
+    }
+
     new_ram_size = MAX(old_ram_size,
               (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS);
     if (new_ram_size > old_ram_size) {
@@ -1904,7 +1915,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
     /* Just support these ram flags by now. */
     assert((ram_flags & ~(RAM_SHARED | RAM_PMEM | RAM_NORESERVE |
                           RAM_PROTECTED | RAM_NAMED_FILE | RAM_READONLY |
-                          RAM_READONLY_FD)) == 0);
+                          RAM_READONLY_FD | RAM_GUEST_MEMFD)) == 0);
 
     if (xen_enabled()) {
         error_setg(errp, "-mem-path not supported with Xen");
@@ -1941,6 +1952,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
     new_block->used_length = size;
     new_block->max_length = size;
     new_block->flags = ram_flags;
+    new_block->guest_memfd = -1;
     new_block->host = file_ram_alloc(new_block, size, fd, !file_size, offset,
                                      errp);
     if (!new_block->host) {
@@ -2020,7 +2032,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     int align;
 
     assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_PREALLOC |
-                          RAM_NORESERVE)) == 0);
+                          RAM_NORESERVE| RAM_GUEST_MEMFD)) == 0);
     assert(!host ^ (ram_flags & RAM_PREALLOC));
 
     align = qemu_real_host_page_size();
@@ -2035,6 +2047,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     new_block->max_length = max_size;
     assert(max_size >= size);
     new_block->fd = -1;
+    new_block->guest_memfd = -1;
     new_block->page_size = qemu_real_host_page_size();
     new_block->host = host;
     new_block->flags = ram_flags;
@@ -2057,7 +2070,7 @@ RAMBlock *qemu_ram_alloc_from_ptr(ram_addr_t size, void *host,
 RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
                          MemoryRegion *mr, Error **errp)
 {
-    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE)) == 0);
+    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE | RAM_GUEST_MEMFD)) == 0);
     return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
 }
 
@@ -2085,6 +2098,11 @@ static void reclaim_ramblock(RAMBlock *block)
     } else {
         qemu_anon_ram_free(block->host, block->max_length);
     }
+
+    if (block->guest_memfd >= 0) {
+        close(block->guest_memfd);
+    }
+
     g_free(block);
 }
 
-- 
2.25.1


