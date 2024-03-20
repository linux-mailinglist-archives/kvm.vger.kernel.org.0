Return-Path: <kvm+bounces-12268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2304F880E1C
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE8E2284F51
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A793FB94;
	Wed, 20 Mar 2024 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gsauBePy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F193CF65
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710925079; cv=fail; b=Aftl0MVZa3yjuwYpvO5ybqa88RnsFEeZCBXQ0Ea56Ric96wRiTcYRP5TXDcYstTRX76KoYlfRvnRyCpEVzxveqeaYpmDhOtNqrlR6277MonIDycUPHuLJU67qVo9gPO1fkUPZiOyH4bQyNLfYlxBeJxpcEf3j0luoSSUiTB14Jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710925079; c=relaxed/simple;
	bh=gphDwyVFjnBmP4TEN10xCHoK7fKYDJ3uBh5l5rYex64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=modVM87IZrL65IEgy5QgmYaAkcg3ZTW3/yCpb3plkjrnl6Qe3IiLoVmfDeR93N3lKfi640fkBUa/ufMlmAVIRd+Uly5aAS/Eqx6gG2g2JHv9XX3AL3QfwVRK5kx3S1vonblUchFFgg7DQm1vzmNmfHHYkio0kHbtj2S00swQRS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gsauBePy; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPnRA/tFE+2CWt/uDAbomN70SFdn3xIviy4ZkKcmCiiSwocOwnVklidWHuAEVk8h+FGj1oTeP/7pyedbPB9nlBMi6XlzfHEFvKvaEsDWiNSaWeo6DDhrTvAj+squX4RutvFCy3FJ+RisM50aUTmYwKYCGqfzusDe1fU9MmoK7cJiiLOar2bA5YcYbp9NqsvfxonP+3Q4Vc0voXgsrJQQcxMeJyZEdRNV9UCluipLNtyc+oWbvyxSlyNMqTi3VWdY77WFP9GPkpSKfTZBKhb0EWirq9gtW7TEfzNjH+uKFY8ELCi470nfqs6h/MnWAVQBpzZKDXb9I26qB3bg4ELz5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXrSi7n4QUdmX4kfC5CFibSP4rf6lZBrf1DZTp6Qlz4=;
 b=iTu0s7N4+oOLKlgUGn7ouB0qBhIX39JD/hXvZIPN3E17lGNz4man/wXHE9U6bqGS2eq4IkwnLN03hCmYYpGaWbQImXJuWckl0wD1MFaig2+HzvNLzP7Cyu1+xFF+aJyrudzicsZdnd1rFjp3bRDvkfTeWFwI5cyeIK7FVjrMOB8fHbhhM0objSKkFm9DJ5lB/u5RUXuso0XN477N0uCqZnON2g6KbSssS5uduD/xxZS8o6FlWX3dEKkuqCAlyFmzYZILN/lKeI11tllbDBFISvxHwz+uSXqMUDCpChYvUwI/B2VAzmHYN1Z2I/ru9wXduLiXmBlqfMn8qRbUP3WpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXrSi7n4QUdmX4kfC5CFibSP4rf6lZBrf1DZTp6Qlz4=;
 b=gsauBePy2sU+kPZAhvKNmG77oMrr0MnsgMo5h+SRqUS/lRr2rqP9Padi1kfWSjIs+RvmFbhCAX6yuHNjO0DaExk6ECfNsnh308RJsDYE0vK/OVNtrCC+tuEHrCOyQ3ihkFgKDikhsrElt6LpBv2NZ8Jghz1R+X1MUsne/3HPruA=
Received: from SJ0PR05CA0128.namprd05.prod.outlook.com (2603:10b6:a03:33d::13)
 by SJ1PR12MB6121.namprd12.prod.outlook.com (2603:10b6:a03:45c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:57:55 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::cf) by SJ0PR05CA0128.outlook.office365.com
 (2603:10b6:a03:33d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 08:57:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:57:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:57:54 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest memfd via MachineState
Date: Wed, 20 Mar 2024 03:39:03 -0500
Message-ID: <20240320083945.991426-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|SJ1PR12MB6121:EE_
X-MS-Office365-Filtering-Correlation-Id: f3696f69-5a2e-4aed-b7a2-08dc48bbd528
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2rCvsHQOGWi8udxrmbRKgPNYHfHz4N1uh9m4UYQ35wqh1Fw7oA7yEnoECW4EwlR/Flxrz4UtdKgN92gUWDrsrz/Xi6zMOufhgIMbvJu4kD9xPAVEKP8hgb5SA12FV+NP5lZZa3ahnS51udG7BEnTECSuwJX/pDlKdCAiTtOz3vJusfn5JC//2gML0xvsiog/fFz5ivIcrJVafyY5kpF0bQYVZEOgtVJfQfqv+56fIdQs7OloLZmTe9GxqsLtyVQvTiJo39qzdoY2vQzroy0BmgNCckbOmP5Y2t0TDd8vQ+7N+f4pjcG42lLoc9fAkG1XtOi+BlJ+igtS1NKJ/z1lO/P25CSih1ufMEZ/PwA+CxYy+K77X+1mr6KYek5k8746BHP4tN79T+fip+TNt28KLqA7KwiDeuFvgp4mm42ty86UtRLF7nTDNWI9jdFjELb5333WxiCZdKnSu6giwYaxhTBcnj9lkgOZS1JYV6vsG0UYYsAJMSD7Euh6Hvdz8UMmQYOEQe9ArwjYm/vf/h9dC2nyYutoYEAwwkj8CRmvlGCZ6YccC1j7zM7q2PYkeBI2T4YWKb1mVQTsVcRylY6vFNyNOtTISlvU8z/yHwD5ouqZIvTo+hOgKOr+qRLiL2477chMTP3DkxnM5cFIf+X/5LFLDLSnCVTX0iECQlxIRVOQlx37aMANyPiJi9akGWfVYUSiXoz4g40P6mJsf7BEopja2+Xb7N5ea2lkbxAQNJFR11OnQW5xDkFzhZT26ONB
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:57:54.9723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3696f69-5a2e-4aed-b7a2-08dc48bbd528
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6121

From: Xiaoyao Li <xiaoyao.li@intel.com>

Add a new member "guest_memfd" to memory backends. When it's set
to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
guest_memfd will be allocated during RAMBlock allocation.

Memory backend's @guest_memfd is wired with @require_guest_memfd
field of MachineState. It avoid looking up the machine in phymem.c.

MachineState::require_guest_memfd is supposed to be set by any VMs
that requires KVM guest memfd as private memory, e.g., TDX VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
Changes in v4:
 - rename "require_guest_memfd" to "guest_memfd" in struct
   HostMemoryBackend;	(David Hildenbrand)
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 backends/hostmem-file.c  | 1 +
 backends/hostmem-memfd.c | 1 +
 backends/hostmem-ram.c   | 1 +
 backends/hostmem.c       | 1 +
 hw/core/machine.c        | 5 +++++
 include/hw/boards.h      | 2 ++
 include/sysemu/hostmem.h | 1 +
 7 files changed, 12 insertions(+)

diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
index ac3e433cbd..3c69db7946 100644
--- a/backends/hostmem-file.c
+++ b/backends/hostmem-file.c
@@ -85,6 +85,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
     ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
     ram_flags |= RAM_NAMED_FILE;
     return memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
index 3923ea9364..745ead0034 100644
--- a/backends/hostmem-memfd.c
+++ b/backends/hostmem-memfd.c
@@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     return memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
                                           backend->size, ram_flags, fd, 0, errp);
 }
diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
index d121249f0f..f7d81af783 100644
--- a/backends/hostmem-ram.c
+++ b/backends/hostmem-ram.c
@@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     return memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend),
                                                   name, backend->size,
                                                   ram_flags, errp);
diff --git a/backends/hostmem.c b/backends/hostmem.c
index 81a72ce40b..eb9682b4a8 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -277,6 +277,7 @@ static void host_memory_backend_init(Object *obj)
     /* TODO: convert access to globals to compat properties */
     backend->merge = machine_mem_merge(machine);
     backend->dump = machine_dump_guest_core(machine);
+    backend->guest_memfd = machine_require_guest_memfd(machine);
     backend->reserve = true;
     backend->prealloc_threads = machine->smp.cpus;
 }
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 37ede0e7d4..73ce9da835 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1198,6 +1198,11 @@ bool machine_mem_merge(MachineState *machine)
     return machine->mem_merge;
 }
 
+bool machine_require_guest_memfd(MachineState *machine)
+{
+    return machine->require_guest_memfd;
+}
+
 static char *cpu_slot_to_string(const CPUArchId *cpu)
 {
     GString *s = g_string_new(NULL);
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 8b8f6d5c00..44c2a4e1ec 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -36,6 +36,7 @@ bool machine_usb(MachineState *machine);
 int machine_phandle_start(MachineState *machine);
 bool machine_dump_guest_core(MachineState *machine);
 bool machine_mem_merge(MachineState *machine);
+bool machine_require_guest_memfd(MachineState *machine);
 HotpluggableCPUList *machine_query_hotpluggable_cpus(MachineState *machine);
 void machine_set_cpu_numa_node(MachineState *machine,
                                const CpuInstanceProperties *props,
@@ -370,6 +371,7 @@ struct MachineState {
     char *dt_compatible;
     bool dump_guest_core;
     bool mem_merge;
+    bool require_guest_memfd;
     bool usb;
     bool usb_disabled;
     char *firmware;
diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
index 0e411aaa29..04b884bf42 100644
--- a/include/sysemu/hostmem.h
+++ b/include/sysemu/hostmem.h
@@ -74,6 +74,7 @@ struct HostMemoryBackend {
     uint64_t size;
     bool merge, dump, use_canonical_path;
     bool prealloc, is_mapped, share, reserve;
+    bool guest_memfd;
     uint32_t prealloc_threads;
     ThreadContext *prealloc_context;
     DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
-- 
2.25.1


