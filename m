Return-Path: <kvm+bounces-43562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF50A91B45
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 13:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C60883AE4A5
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF89424167C;
	Thu, 17 Apr 2025 11:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KHcoseQH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB23215061;
	Thu, 17 Apr 2025 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744890744; cv=fail; b=RQiAh3266TZnxlHhpfs2NWd6HeSmUkMOZAYLk9cEe8SiDsDOwBaHhmQBZxfyqR281bXkKlfxqsQFpr0dZhFxeHuNaUS27OR2iqN5v7qnTP896/POqSfG7j/ZJruCj3qjWo0t+GJBggcp+ZekeCs+e9caavuEerOX2X6gwISXD9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744890744; c=relaxed/simple;
	bh=7BvjIM8YTLzNad0Z6XUYgh15my305bb2uL3N3vFBQxU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nYSuECXaaFyFdIy8Dxzi7QQ2yA0JbpMFDiO3ywx1Sm3VJQ05KRBfqtjE/HchbqDW4yaNldguI+eS5EVrH6cUj7r45ltVLbXJUGPW3j11DZ72FDXFhjuZe3CWCD7RN6UrXLA/zYRfZA+bQc0gqvDwZbRbKwRPYzggbj4fNueArLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KHcoseQH; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gSghRZhL0VRAKVCa5YyPw0AxqLkq5slyywSMpArlsXBsx144G6QqoB7OgY5+yQgV1htxxKII5iXJbe+k1dghHmVPixz3lgxMEsYOGYbF7y6ZuET26h9rEWnuSGWR67B9GgOZXI7YtQZUSzF4izW18/6l/T0xBRSWy5/6uVDnugAjAYFDaRDrWeQInYVSMaOcz5H80oi1LimgpPfhZMwffExpfZkHLB9Z4JBuwNm1XqL+6JGsXctTbIeBGQclbJCCDc7YMtrr2ncZdmDbV8YR6UCZBBDjIKBadzQeb+qcS7k+mk3fyrHRs5Wyg982mEFfuNdMNTxjFEdVIUhUnPFKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86nrFg5IAsKA82WN6P7e0QjPJ0mjfBowiYZ1NiPOrfg=;
 b=CZB7hgxs1Lc99ZkpAh5YX3RFKkZtKtkEvKC0e2yAAMV0d4Dyh7MkpDEtLl4UekBzJxunO8GgYrsgGcei7GR18aCdtmPkauyHO1U24QPzWREcjbnPpYkS4tuOeEcYLJRgomYag3QU3LyIVSgQyXsDC0cDHFbOrhi5VJmoh33rxKiFL+mb/3h8EACMct1P88QpoWcA5OzKsRMpA3IGgPTB/l4AaI1zIryVKvk6DCRSlW/vX+EWcb/M4901DsiCxuZ1fkGoRZPFhGXtRIhHRyKxnt080QmWHulkCgvBRas68ktalhuRrVTwONCvCYlezrX1MRgvYbX8lmCs+s+gqy2H1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86nrFg5IAsKA82WN6P7e0QjPJ0mjfBowiYZ1NiPOrfg=;
 b=KHcoseQHeVcTTuIDhSh34KNErec3hBSAsVb9bctJua+HVw1LgqvP7I6VQyrafk5Egs4Mw4K7K5HvUc3d3xfbkXhPbgO5E9/UnYyXDtp6ruIyHessCucXKN9ZpaCAfzD21QyyZd2HDY080w2BK51eQYdWK3Cybeac+gLn2JtNlO8=
Received: from MW3PR06CA0028.namprd06.prod.outlook.com (2603:10b6:303:2a::33)
 by SN7PR12MB7452.namprd12.prod.outlook.com (2603:10b6:806:299::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Thu, 17 Apr
 2025 11:52:17 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:303:2a:cafe::c0) by MW3PR06CA0028.outlook.office365.com
 (2603:10b6:303:2a::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.34 via Frontend Transport; Thu,
 17 Apr 2025 11:52:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 11:52:17 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 17 Apr
 2025 06:52:13 -0500
From: Sairaj Kodilkar <sarunkod@amd.com>
To: <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <bhelgaas@google.com>, <will@kernel.org>, <joro@8bytes.org>,
	<robin.murphy@arm.com>, <iommu@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<sarunkod@amd.com>, <vasant.hegde@amd.com>, <suravee.suthikulpanit@amd.com>
Subject: [bug report] Potential DEADLOCK due to vfio_pci_mmap_huge_fault()
Date: Thu, 17 Apr 2025 17:22:00 +0530
Message-ID: <20250417115200.31275-1-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|SN7PR12MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: 60f32a41-3a95-41c8-e7c0-08dd7da64d71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7hRPYyyCBhmOAX0qVwkyPNZb0bKJRovbkEqXB4soQsBervnUIKRVSEUWKJGA?=
 =?us-ascii?Q?27RxIAzL6AwefzbPZJf3pwgxe1zwVXn55jEgKOYlDgrIinYzQLo1JHDWuyAu?=
 =?us-ascii?Q?xEEwbIZeb92IXaFZ83XFMgFlhflMIKxeKFtnklrCL9/ZzvWwvJBVogjUo+Mj?=
 =?us-ascii?Q?+AkDs0uMVbq+s9eaD2zQk0yK2h7lJfwKJToDZTcj7/7rj3FkN+9ZiVOTnSLa?=
 =?us-ascii?Q?fBBnussxQ+qOcK8PZRlFAI4GDkR4VsJBGTr3AOtmYpbDRakh3k/d4sJ19LEg?=
 =?us-ascii?Q?T6QRBtoOXW06JmttTPlfFlMi3TsX/YGbrJRSfapeWMEAw5ai6LIZ1we5tsUn?=
 =?us-ascii?Q?FTpwCWKG+nP9M2Uxky8U5n6l4hPtErrwAJCnyaRQZaqFKGik9ebQX32l74VO?=
 =?us-ascii?Q?lNulQfm7Twgfe1QYpVayPYlMD9t91eCuwbaEqiEP8iw/iKdB4KkThatJWi/r?=
 =?us-ascii?Q?crqtwLYTb0hT0kghVFmK4sJTWcwXlWrMSM9qDrEoYhGUNz/7hU6gnk1gZgUV?=
 =?us-ascii?Q?mlBQjaCF+T8+XChvkoIvaODQxcrroo7XepTTaB1Uia3IN222cyr9eeI5xsdH?=
 =?us-ascii?Q?/MSf7gOtaD6F2frXVcVGeYELtDiBFnUGaJVAYt7VvSWMYUVRhxDR3TdI87R0?=
 =?us-ascii?Q?tLBPzvPx5dA0o7VR/KfMtQFLPVjzf5K1Voh3ywkoJD6HeokrMXsq5SUBgryk?=
 =?us-ascii?Q?utUGlf6U+UlV9Y4ywGY7yr80quUJmApjzKLvEPF73ALZEfDP9V6kbkO3aBnV?=
 =?us-ascii?Q?Vkfykzlqqkb23PMhQ/SLcyVZpxweENMEYatmGFsy1WsuXZcFtEWxK0n3uv6A?=
 =?us-ascii?Q?SMzsMCPiO/4g6ygY4D/yZKwfk7CJZ28T499+VG51b+qXIF9oISy3ybtPzbyG?=
 =?us-ascii?Q?ekWSBvhmfrPDgQ80a7GJGF+cIIJ1a7QtB5hmpW8FbjE7zz3oa4HFNYsVnUGf?=
 =?us-ascii?Q?l/3tnMDOyfKVd9EnbTcB9/sLY00e5/SivfSCxgsrSDksa2RLdmEAXPhCLqE3?=
 =?us-ascii?Q?WAcldaiJ5CnIvqYvOiTUXAj1jYYi2DhSef9fwHUJcArcYFYZvMCPiGmyt+bx?=
 =?us-ascii?Q?GhpzN6WU0T6s/JyTc7Ppoim0yWwANzi/U+fcnb4iMUquyhl6bFDOVJB+4y2c?=
 =?us-ascii?Q?WTRQxpwn1tPyDO/FIJeO0ncmaaXxCNUIC8hL49S/f9PXg0qcz8Wc73k0j0H6?=
 =?us-ascii?Q?IUTtnAiGUa5CHpPTWXXABFSafRLc5nEGiFJL5l7cnNUsJAXDfIOGXWqiUQLP?=
 =?us-ascii?Q?84ubunnY+X3yJYhOmcGfmalHKN+dstzjQjjuOy3Buqlpf3RjodXA/9JObGa4?=
 =?us-ascii?Q?ThFrMj5XFiqksd+5aGe2AjCxtM7bRnhN9/cfrwbrtnp97jw3+PQK8w3mOJFL?=
 =?us-ascii?Q?Jm6wv5k/Geiwl5YBmlBMEV4d0UmJJiXN0veV3jQyN9sltC8mycejMD3yac+O?=
 =?us-ascii?Q?vaiHNYD4rsC4f75p5KcFpQP5UfTLz8u6XcpVjwe584OgTUSD2wXLN+B2i7LD?=
 =?us-ascii?Q?6QpKlRB7D//fiq2BZrkImZlB06o+slZnq5bp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 11:52:17.2269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f32a41-3a95-41c8-e7c0-08dd7da64d71
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7452

Hi everyone,
I am seeing following errors on the host when I run FIO tests inside the
guest on the latest upstream kernel. This causes guest to hang. Can anyone help with this ? 

I have done some cursory analysis of the trace and it seems the reason is
`vfio_pci_mmap_huge_fault`. I think following scenario is causing the
deadlock.

     CPU0                     CPU1                                    CPU2
(Trying do                      (Trying to perform                  (Receives fault
`vfio_pci_set_msi_trigger())     operation with sysfs               during vfio_pin_pages_remote())
                                 /sys/bus/pci/devices/<devid>) 
                            
===================================================================================================
(A) vdev->memory_lock
    (vfio_msi_enable())
                                (C) root->kernfs_rwsem
                                    (kernfs_fop_readdir())
(B) root->kernfs_rwsem
    (kernfs_add_one())
                                                                    (E) mm->mmap_lock
                                                                        (do_user_addr_fault())
                                (D) mm->mmap_lock
                                   (do_user_addr_fault())
                                                                    (F) vdev->memory_lock
                                                                        (vfio_pci_mmap_huge_fault())


Here, there is circular dependency of A->B->C->D->E->F->A.
Please let me know if anyone encountered this. I will be happy to help!
---------------------------------------------------------------------------------

[ 1457.982233] ======================================================
[ 1457.989494] WARNING: possible circular locking dependency detected
[ 1457.996764] 6.15.0-rc1-0af2f6be1b42-1744803490343 #1 Not tainted
[ 1458.003842] ------------------------------------------------------
[ 1458.011105] CPU 0/KVM/8259 is trying to acquire lock:
[ 1458.017107] ff27171d80a8e960 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_add_one+0x34/0x380
[ 1458.027027]
[ 1458.027027] but task is already holding lock:
[ 1458.034273] ff27171e19663918 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_memory_lock_and_enable+0x2c/0x90 [vfio_pci_core]
[ 1458.047221]
[ 1458.047221] which lock already depends on the new lock.
[ 1458.047221]
[ 1458.057506]
[ 1458.057506] the existing dependency chain (in reverse order) is:
[ 1458.066629]
[ 1458.066629] -> #2 (&vdev->memory_lock){++++}-{4:4}:
[ 1458.074509]        __lock_acquire+0x52e/0xbe0
[ 1458.079778]        lock_acquire+0xc7/0x2e0
[ 1458.084764]        down_read+0x35/0x270
[ 1458.089437]        vfio_pci_mmap_huge_fault+0xac/0x1c0 [vfio_pci_core]
[ 1458.097135]        __do_fault+0x30/0x180
[ 1458.101918]        do_shared_fault+0x2d/0x1b0
[ 1458.107189]        do_fault+0x41/0x390
[ 1458.111779]        __handle_mm_fault+0x2f6/0x730
[ 1458.117339]        handle_mm_fault+0xd8/0x2a0
[ 1458.122606]        fixup_user_fault+0x7f/0x1d0
[ 1458.127963]        vaddr_get_pfns+0x129/0x2b0 [vfio_iommu_type1]
[ 1458.135073]        vfio_pin_pages_remote+0xd4/0x430 [vfio_iommu_type1]
[ 1458.142771]        vfio_pin_map_dma+0xd4/0x350 [vfio_iommu_type1]
[ 1458.149979]        vfio_dma_do_map+0x2dd/0x450 [vfio_iommu_type1]
[ 1458.157183]        vfio_iommu_type1_ioctl+0x126/0x1c0 [vfio_iommu_type1]
[ 1458.165076]        __x64_sys_ioctl+0x94/0xc0
[ 1458.170250]        do_syscall_64+0x72/0x180
[ 1458.175320]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1458.181944]
[ 1458.181944] -> #1 (&mm->mmap_lock){++++}-{4:4}:
[ 1458.189446]        __lock_acquire+0x52e/0xbe0
[ 1458.194703]        lock_acquire+0xc7/0x2e0
[ 1458.199676]        down_read_killable+0x35/0x280
[ 1458.205229]        lock_mm_and_find_vma+0x96/0x280
[ 1458.210979]        do_user_addr_fault+0x1da/0x710
[ 1458.216638]        exc_page_fault+0x6d/0x200
[ 1458.221814]        asm_exc_page_fault+0x26/0x30
[ 1458.227274]        filldir64+0xee/0x170
[ 1458.231963]        kernfs_fop_readdir+0x102/0x2e0
[ 1458.237620]        iterate_dir+0xb1/0x2a0
[ 1458.242509]        __x64_sys_getdents64+0x88/0x130
[ 1458.248282]        do_syscall_64+0x72/0x180
[ 1458.253371]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1458.260006]
[ 1458.260006] -> #0 (&root->kernfs_rwsem){++++}-{4:4}:
[ 1458.268012]        check_prev_add+0xf1/0xca0
[ 1458.273187]        validate_chain+0x610/0x6f0
[ 1458.278452]        __lock_acquire+0x52e/0xbe0
[ 1458.283711]        lock_acquire+0xc7/0x2e0
[ 1458.288678]        down_write+0x32/0x1d0
[ 1458.293442]        kernfs_add_one+0x34/0x380
[ 1458.298588]        kernfs_create_dir_ns+0x5a/0x90
[ 1458.304214]        internal_create_group+0x11e/0x2f0
[ 1458.310131]        devm_device_add_group+0x4a/0x90
[ 1458.315860]        msi_setup_device_data+0x60/0x110
[ 1458.321679]        pci_setup_msi_context+0x19/0x60
[ 1458.327398]        __pci_enable_msix_range+0x19d/0x640
[ 1458.333513]        pci_alloc_irq_vectors_affinity+0xab/0x110
[ 1458.340211]        vfio_pci_set_msi_trigger+0x8c/0x230 [vfio_pci_core]
[ 1458.347883]        vfio_pci_core_ioctl+0x2a6/0x420 [vfio_pci_core]
[ 1458.355164]        vfio_device_fops_unl_ioctl+0x81/0x140 [vfio]
[ 1458.362155]        __x64_sys_ioctl+0x93/0xc0
[ 1458.367295]        do_syscall_64+0x72/0x180
[ 1458.372336]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1458.378932]
[ 1458.378932] other info that might help us debug this:
[ 1458.378932]
[ 1458.388965] Chain exists of:
[ 1458.388965]   &root->kernfs_rwsem --> &mm->mmap_lock --> &vdev->memory_lock
[ 1458.388965]
[ 1458.402717]  Possible unsafe locking scenario:
[ 1458.402717]
[ 1458.410064]        CPU0                    CPU1
[ 1458.415495]        ----                    ----
[ 1458.420939]   lock(&vdev->memory_lock);
[ 1458.425597]                                lock(&mm->mmap_lock);
[ 1458.432683]                                lock(&vdev->memory_lock);
[ 1458.440153]   lock(&root->kernfs_rwsem);
[ 1458.444905]
[ 1458.444905]  *** DEADLOCK ***
[ 1458.444905]
[ 1458.452589] 2 locks held by CPU 0/KVM/8259:
[ 1458.457627]  #0: ff27171e196636b8 (&vdev->igate){+.+.}-{4:4}, at: vfio_pci_core_ioctl+0x28a/0x420 [vfio_pci_core]
[ 1458.469499]  #1: ff27171e19663918 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_memory_lock_and_enable+0x2c/0x90 [vfio_pci_core]
[ 1458.483306]
[ 1458.483306] stack backtrace:
[ 1458.488927] CPU: 169 UID: 0 PID: 8259 Comm: CPU 0/KVM Not tainted 6.15.0-rc1-0af2f6be1b42-1744803490343 #1 PREEMPT(voluntary)
[ 1458.488933] Hardware name: AMD Corporation RUBY/RUBY, BIOS RRR100EB 12/05/2024
[ 1458.488936] Call Trace:
[ 1458.488940]  <TASK>
[ 1458.488944]  dump_stack_lvl+0x78/0xe0
[ 1458.488954]  print_circular_bug+0xd5/0xf0
[ 1458.488965]  check_noncircular+0x14c/0x170
[ 1458.488970]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.488976]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.488980]  ? find_held_lock+0x32/0x90
[ 1458.488986]  ? local_clock_noinstr+0xd/0xc0
[ 1458.489001]  check_prev_add+0xf1/0xca0
[ 1458.489006]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489015]  validate_chain+0x610/0x6f0
[ 1458.489027]  __lock_acquire+0x52e/0xbe0
[ 1458.489032]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489035]  ? __lock_release+0x15d/0x2a0
[ 1458.489046]  lock_acquire+0xc7/0x2e0
[ 1458.489051]  ? kernfs_add_one+0x34/0x380
[ 1458.489060]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489063]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489067]  ? __lock_release+0x15d/0x2a0
[ 1458.489080]  down_write+0x32/0x1d0
[ 1458.489085]  ? kernfs_add_one+0x34/0x380
[ 1458.489090]  kernfs_add_one+0x34/0x380
[ 1458.489100]  kernfs_create_dir_ns+0x5a/0x90
[ 1458.489107]  internal_create_group+0x11e/0x2f0
[ 1458.489118]  devm_device_add_group+0x4a/0x90
[ 1458.489128]  msi_setup_device_data+0x60/0x110
[ 1458.489136]  pci_setup_msi_context+0x19/0x60
[ 1458.489144]  __pci_enable_msix_range+0x19d/0x640
[ 1458.489150]  ? pci_conf1_read+0x4e/0xf0
[ 1458.489154]  ? find_held_lock+0x32/0x90
[ 1458.489162]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489165]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489172]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489176]  ? mark_held_locks+0x40/0x70
[ 1458.489182]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489191]  pci_alloc_irq_vectors_affinity+0xab/0x110
[ 1458.489206]  vfio_pci_set_msi_trigger+0x8c/0x230 [vfio_pci_core]
[ 1458.489222]  vfio_pci_core_ioctl+0x2a6/0x420 [vfio_pci_core]
[ 1458.489231]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1458.489241]  vfio_device_fops_unl_ioctl+0x81/0x140 [vfio]
[ 1458.489252]  __x64_sys_ioctl+0x94/0xc0
[ 1458.489262]  do_syscall_64+0x72/0x180
[ 1458.489269]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1458.489273] RIP: 0033:0x7f0898724ded
[ 1458.489279] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
[ 1458.489282] RSP: 002b:00007f08965622a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1458.489286] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0898724ded
[ 1458.489289] RDX: 00007f07800f6d00 RSI: 0000000000003b6e RDI: 000000000000001e
[ 1458.489291] RBP: 00007f08965622f0 R08: 00007f07800008e0 R09: 0000000000000001
[ 1458.489293] R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
[ 1458.489295] R13: fffffffffffffb28 R14: 0000000000000007 R15: 00007ffd0ef83ae0
[ 1458.489315]  </TASK>

