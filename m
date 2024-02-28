Return-Path: <kvm+bounces-10303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1375C86B88D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 20:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673FD1F28729
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D14D5E083;
	Wed, 28 Feb 2024 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FgLl9HOw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2078.outbound.protection.outlook.com [40.107.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1925E076;
	Wed, 28 Feb 2024 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149700; cv=fail; b=aWP8oYMcSgUNCSkFC447szWNpCeGaRbBPqxSgL9FEtGbITmwWvdRy3AqfgrcJ+pP7KLpoQUuZXKGNUWJY21MNtbzfgr3tqW+7H+YUO+k/zkAGiNlbKR7YkDng6xEah/kkAXR+I0jS95pd7TaHWiUV3bg0YkgoJ08xj40Uew9Jow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149700; c=relaxed/simple;
	bh=C/LV4UovrYehbhl96r/tZW0vTgiRUm8kwwDekJsRTJY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UbOE8D1NKvRLYSxWF1NisYIuICOqJa7T29xVogaTwRZXxc9dVn+xyFQHfirAFGt0KP58ywj4Rp0Dqdu6iKYkWHnFfxekHycE5EPHEMfOnw09lhG7IvgzAR5jEwEdQRE/ukXHcQmKoFb4R/uLdFfkx3i5N+ZTMeSakXytOasxwtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FgLl9HOw; arc=fail smtp.client-ip=40.107.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HO4tFUvbe9+n0vfxlJw+ZnOBUvX7tZsW8ios/dz7j3OXJ/TZoX9agtqquBoIP4IHAbLEg0jus8tdtvw44RMtREYl523wBVgnloAudLGhTIeYRtZSnIIlshWqi8UsrR/YQS0L0nwCxzz+ZXgnw4IRA1BAmDwaxriVemXmdm9xGQ1jB1Ju5ngeZZ5XA3VG5p5W1zUP0bRnTJS4T5fI/L75F3UvQVAdgUeIwz0g9ofDHTj2c6h47+PwF+QW8vdOiMFABAN3Zse5SVJM75VIMihSJ9SlVS9JozruOK9zj6PRILb+gpsHocGBx+DricbqgfaUwzmUaH9s5ckQs4i5Wajy2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFFZSQxdR+oOlDZW3COv6S7ijSSswwKipJ6Tph8QseY=;
 b=kGS+npt4N0fYuoV6nch2wHEtrc98x4Jw4jrDcdK6sjHEA3U2BXdOxCkJNtL49f6k5bp1J7+cjCiMU2l/qntrgRny/q9PaCenveaHzfChm7XgEITYOBqBXvJHkcQNXhYgbKOkpMV8BL3J7SE0YorQgrcX6W3qR7dRaG9OQxDppino9hXrH3xM3nbQX3lZK6GnDvz8o+EaN+Q4FpxJhg7VoQ/oeCECH5Cdc9rjhpAffKVLDHwvdYz3qM7ImH83D/sca9T1akzVJ/4YjXPErpPmI+jGs9+Uho/587ir92V+GtEbuAe5Ap/2E0JjlEO9P7yw6hNcFyrKKz732+FQe03F7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFFZSQxdR+oOlDZW3COv6S7ijSSswwKipJ6Tph8QseY=;
 b=FgLl9HOw3rmGqjgnJIGuxl04tkpLCbNx0qGMTxaUgoGvx8XQ+j74hvR+KYABdi3TW4ic1PwznCGBMK8gLsulxrWoDdw0KfR/MYhOKoHXM6j6gWPg2aLPXIeKvCz2w1s4WCXTZGcTshiciv98W/Uj8kCm9QEopSRIqNVHGnf0mBS/WGgDGE3wNrbipJSRhD06sdcmCPmrKZ8gLb/bHCXOyILCU91etJ9Aed6GSBvnwQWiqMo0eBk61D2FjjunFnLQhPp+Q3tNICVm0LjwIeHuXUJmkxi068qSVLEj4uxgrq64s462ogKl9DTxHNZj2HcOUI+Ivf4UhiiiYskeNPT9Vw==
Received: from SJ0PR03CA0382.namprd03.prod.outlook.com (2603:10b6:a03:3a1::27)
 by IA0PR12MB8225.namprd12.prod.outlook.com (2603:10b6:208:408::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.37; Wed, 28 Feb
 2024 19:48:14 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::d0) by SJ0PR03CA0382.outlook.office365.com
 (2603:10b6:a03:3a1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.28 via Frontend
 Transport; Wed, 28 Feb 2024 19:48:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Wed, 28 Feb 2024 19:48:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 28 Feb
 2024 11:48:01 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Wed, 28 Feb 2024 11:48:01 -0800
Received: from localhost.nvc.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 28 Feb 2024 11:48:01 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<rrameshbabu@nvidia.com>, <zhiw@nvidia.com>, <anuaggarwal@nvidia.com>,
	<mochs@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] vfio/nvgrace-gpu: Convey kvm that the device is wc safe
Date: Wed, 28 Feb 2024 19:48:01 +0000
Message-ID: <20240228194801.2299-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|IA0PR12MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: c116ad6b-b969-421b-1e19-08dc38963336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+JOCD3KYsLJo1ddm7SFyrZIC5kONHMWPhDpXJVRW/u2KLFZJnZuyiOLoru8PlSkUhQ+28Wu0hdTHg5IgswJtkL60XPwMf0E3m4DcRY/Ed/75ApOQtAtUZAnBEvlq5/VW++iRIfjVjBJarglNaW1zz6/GFACh8LeLQQYe8Q34kYWTPghdXETNdovwFQPHBcWUp3Y4b+EEqOZxzN9gB0/cVbTqa9O+S1Xd02zGj488fopT8lcS0uUeVM6hpbnILjIUwBR1oApg6ci68yF/al7pLKFGOklDlBBiOnALxjLwwAoW8tWPiDoSajlY3RxX5S5HU9B+9+81tt1FxsEULJGPdlqGb6OboqeTZCBj3bra8Vt2cqhi8iHUbHxXt76+mXaE+S9Yidee0R2kI+WSpbkl66zkU4FWQJND+d7ilMSfz5kleD0KiYtJjBtJ3QALytmu8t6/CAvdmYcErXC/aNoDuPYz3/PoCHz7lN9DTKTcykVR8xohJmNxz1EFWbZq5qD+6Ptsw73idbl1FgZSnq+mgB7N7y3Ah1dD4x1JmQ1L8ppQWqzrxdVDJ0sJhovyMCNU1dOb/GgRbso9KGDnQLhSoVhqZmO0en8UgnidE8UmoKWCH6qCDIyjCca5LNVoz+ANkVQQ5Ng5jIhrsK1i1M+GaMZR2JU2YvIUaFOBZ/nXwZgRymDasuCnBnt2IlQPInlqMhjpUaodhg1UirR7F0hBoMyzrA8JqMUIe06CivBC0SkexHVZO1Ug48F675U2n3kvQOIUAu63yds7z/aJo+d4bNrIeVYXtP4YNAGqpKYqLqc=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 19:48:13.4264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c116ad6b-b969-421b-1e19-08dc38963336
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8225

From: Ankit Agrawal <ankita@nvidia.com>

The NVIDIA Grace Hopper GPUs have device memory that is supposed to be
used as a regular RAM. It is accessible through CPU-GPU chip-to-chip
cache coherent interconnect and is present in the system physical
address space. The device memory is split into two regions - termed
as usemem and resmem - in the system physical address space,
with each region mapped and exposed to the VM as a separate fake
device BAR [1].

Owing to a hardware defect for Multi-Instance GPU (MIG) feature [2],
there is a requirement - as a workaround - for the resmem BAR to
display uncached memory characteristics. Based on [3], on system with
FWB enabled such as Grace Hopper, the requisite properties
(uncached, unaligned access) can be achieved through a VM mapping (S1)
of NORMAL_NC and host mapping (S2) of MT_S2_FWB_NORMAL_NC.

KVM currently maps the MMIO region in S2 as MT_S2_FWB_DEVICE_nGnRE by
default. The fake device BARs thus displays DEVICE_nGnRE behavior in the
VM.

The following table summarizes the behavior for the various S1 and S2
mapping combinations for systems with FWB enabled [3].
S1           |  S2           | Result
NORMAL_WB    |  NORMAL_NC    | NORMAL_NC
NORMAL_WT    |  NORMAL_NC    | NORMAL_NC
NORMAL_NC    |  NORMAL_NC    | NORMAL_NC
NORMAL_WB    |  DEVICE_nGnRE | DEVICE_nGnRE
NORMAL_WT    |  DEVICE_nGnRE | DEVICE_nGnRE
NORMAL_NC    |  DEVICE_nGnRE | DEVICE_nGnRE

Recently a change was added that modifies this default behavior and
make KVM map MMIO as MT_S2_FWB_NORMAL_NC when a VMA flag
VM_ALLOW_ANY_UNCACHED is set. Setting S2 as MT_S2_FWB_NORMAL_NC
provides the desired behavior (uncached, unaligned access) for resmem.

Such setting is extended to the usemem as a middle-of-the-road
setting to take it closer to the desired final system memory
characteristics (cached, unaligned). This will eventually be
fixed with the ongoing proposal [4].

To use VM_ALLOW_ANY_UNCACHED flag, the platform must guarantee that
no action taken on the MMIO mapping can trigger an uncontained
failure. The Grace Hopper satisfies this requirement. So set
the VM_ALLOW_ANY_UNCACHED flag in the VMA.

Applied over next-20240227.
base-commit: 22ba90670a51

Link: https://lore.kernel.org/all/20240220115055.23546-4-ankita@nvidia.com/ [1]
Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [2]
Link: https://developer.arm.com/documentation/ddi0487/latest/ section D8.5.5 [3]
Link: https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/ [4]

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Vikram Sethi <vsethi@nvidia.com>
Cc: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 25814006352d..5539c9057212 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -181,6 +181,24 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 
 	vma->vm_pgoff = start_pfn;
 
+	/*
+	 * The VM_ALLOW_ANY_UNCACHED VMA flag is implemented for ARM64,
+	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
+	 * rather than DEVICE_nGnRE, which allows guest mappings
+	 * supporting write-combining attributes (WC). This also
+	 * unlocks memory-like operations such as unaligned accesses.
+	 * This setting suits the fake BARs as they are expected to
+	 * demonstrate such properties within the guest.
+	 *
+	 * ARM does not architecturally guarantee this is safe, and indeed
+	 * some MMIO regions like the GICv2 VCPU interface can trigger
+	 * uncontained faults if Normal-NC is used. The nvgrace-gpu
+	 * however is safe in that the platform guarantees that no
+	 * action taken on the MMIO mapping can trigger an uncontained
+	 * failure. Hence VM_ALLOW_ANY_UNCACHED is set in the VMA flags.
+	 */
+	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED);
+
 	return 0;
 }
 
-- 
2.34.1


