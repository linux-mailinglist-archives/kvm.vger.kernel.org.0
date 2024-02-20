Return-Path: <kvm+bounces-9132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6595A85B3FE
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BE00283C5B
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 07:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A994C5A7A0;
	Tue, 20 Feb 2024 07:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ohYVfK3p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA35A4E5;
	Tue, 20 Feb 2024 07:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708414198; cv=fail; b=fUHj6bQNWc7h8rwHHxvHnRSBn0PfsEzWtlLtiL70ApAiIDdDCxc/MbJShwzuDrxnbMgfGCsgnUssqbf9jM1Sv+PIyfguiE7iDJq7KDsOLUS+hhdC/wrDTvEVAjtj6OJ2eNCL8Yyo8Z6FHWjqyOPmypeOle4F8HzDZZKEoc1KQsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708414198; c=relaxed/simple;
	bh=3dC4cWIJJTuWnhsrNdYAKPadE5HXY3nHmIJp1X/N3no=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dhdnzPYy5cgNMJovK4SKM9h6jBpMS0DMdUkXyqi3t4zS2VZVjewuk9pa3VtlG7vCn7EycYr066pmc0oxh4AoXjZhpgVgocyAQYKrve4Moh16Y5wMKO3bbiDv50ipLNQWIUKZQpz3/Csv4VyZDA4IqoAC7ep/aFTL+qgvAjdVdJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ohYVfK3p; arc=fail smtp.client-ip=40.107.102.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRjSCs89nQkYsTjji8i8eMjJL6tm5dDIff0qKUU3aG5ckRbJoTUWF6u1so1FUwZdUl+w14NysVPUvXGUEKCwwycV1+J6gyIQGK+25x1AwKyW4JDh2y3YHzae8D0kp/kq+kQ3qdCwFPWsUIW7JfSR7QTI2SszJD9RCkZHztmvuwm9aIVLW65Z9qM0JSycdmXYfrx0ncVi6KDeMRJPPE1jb6axCakS8tGPpZs4UFmgKx1PNSEVumBxBVdVsA3v5fIUCk0vcFAxNC7nlp5yCtr+D8mpVTV9UzNKDrGMzEJeolBLLnR4t1+kp9n0a4CNQNBOgWB1nd0De+3IVG2NrkwaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLg9l0N1ZhXakgNXLBabKwRi9c/pB2sSLQt11etlN3Y=;
 b=RFoY/6lrbOnRHo2drSXM1cp+YG2jUbRbpwja5qFaufCEdqqp8KQKgC9zYir3a4sTY+OIT7AQMFl0SvxlCYaEUE9vtOfMYtAUtdhXT5S0mi4f/zFsQ4ZS11LxiMhNFpP7KM13TuFkeAp+SDDxY+MVttH9Wx2hucVYHFR/T1zWI2CcKcNY4y3jim0XN6cVo0H9UifV0d21xc80yGnCTx2uLcINz1SdXm1SuWbvURwUZM8bRoPE51FTdic37LXB6L29ZXQJzNl6w5yOSEkLNFktO889zfptIArAe8x/1lAVSGZEYgfWSQG4NwURGSQe7oxTh+8fEPxXiAhPRrYJMhmRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLg9l0N1ZhXakgNXLBabKwRi9c/pB2sSLQt11etlN3Y=;
 b=ohYVfK3perfQybKNmFA5/qpEX5Tv9H2A5jvEs3Nkg7P+V2YNXP4HyPjVY+knxEMPbzu8fAms7jzIl5Etfzi15glFQauNbu1jVXVkYhjYKJCOhpoipdWiZMjSHq+WY021rPtmZR090Tv5xIrELwJYAdJyAPV2hW4dK5ndEB/P+R4mKmLPn26149rS9EJb/qLTuhNxcFDHwqcO5BEbLAj2s9zGu/1W8HkGEngwRcoWRfaz2JJDJAZlPbWgH/KbFhNTIab6nQVZ+DJ3obJ0qLvObNQmB6EwPcApwMZ1VD8nC8LUFSNf4HSn2voxoE7prG91Oc1MZF/xsj4lKTj3ypUw/g==
Received: from DM6PR06CA0056.namprd06.prod.outlook.com (2603:10b6:5:54::33) by
 CH2PR12MB4327.namprd12.prod.outlook.com (2603:10b6:610:7d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.20; Tue, 20 Feb 2024 07:29:54 +0000
Received: from DS1PEPF00017094.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::9d) by DM6PR06CA0056.outlook.office365.com
 (2603:10b6:5:54::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39 via Frontend
 Transport; Tue, 20 Feb 2024 07:29:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF00017094.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 07:29:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 19 Feb
 2024 23:29:42 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 19 Feb
 2024 23:29:41 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 19 Feb 2024 23:29:28 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
	<ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
	<rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
	<linus.walleij@linaro.org>, <bhe@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 0/4] kvm: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Tue, 20 Feb 2024 12:59:22 +0530
Message-ID: <20240220072926.6466-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|CH2PR12MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: 025274fa-3c38-40f8-8fc5-08dc31e5bb40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F3v6yGOOPcDfjGC+Hg3AA88EduvG4M2Pmw0iJSFVGkULg0NJUmZHSlzFm+jannt5Pq4kiRilpKetdMwmvWxNTzHWuhKwl2i0V3lMOQ/xrKt4UbzKh47Fhaoac0930lmcBswYeeshmOqgbLQfn4detwsJKUpq6p1L/0M1OekbwE8488wO66jK5CTaXnT0Bn6mQqZQviIbOH3BowxXlhOLypJJIhXEB9DDYgfR2xAi7h4xpIg3xExuXB7jpFdcKVoH3ai6z02vFjg1bQ20Diu6lidBQFBlnNLY5iDXCZO8g3eNhil2r12mBxfgkz/ugKbMrVNbu1RxskuQx4OnACh6E7SqpkghZeBOYmJEOaEQDFBp6YjexeFRe5i0g+caTpx7g0GKI2byQKFrG+L/yn9i55KV9oxWDPpImUqdWZUe6poxn3DoJMTUpHKnILtuVQ2lGlxaChlsW4rw0KkKW7XFkB489I15r+p3vdBVuMIpeLwBz1cv2oVdGmixyNC0JIRdiBk5nWzEFgMJKZnVrcRxYje/zxt/M5QpWt0thzzqZwKMhw+947GrSNVelA8fV3cZpG9pJHhnlOP6FFRlOo6Pg7FqFfruMXJjXpF1hmbYwLRgqd1BhcS7WDUczvG6mUAgCblmT5PDeMZSgyMdaXxvsTBdVX3kqGVHRLIzi2HmD3//E5D8FIEQ8yDLBhsmYHgEKqGTtQBO7TPkoTIKElu1Ow==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(230273577357003)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 07:29:53.6735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 025274fa-3c38-40f8-8fc5-08dc31e5bb40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017094.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4327

From: Ankit Agrawal <ankita@nvidia.com>

Currently, KVM for ARM64 maps at stage 2 memory that is considered device
with DEVICE_nGnRE memory attributes; this setting overrides (per
ARM architecture [1]) any device MMIO mapping present at stage 1,
resulting in a set-up whereby a guest operating system cannot
determine device MMIO mapping memory attributes on its own but
it is always overridden by the KVM stage 2 default.

This set-up does not allow guest operating systems to select device
memory attributes independently from KVM stage-2 mappings
(refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
which turns out to be an issue in that guest operating systems
(e.g. Linux) may request to map devices MMIO regions with memory
attributes that guarantee better performance (e.g. gathering
attribute - that for some devices can generate larger PCIe memory
writes TLPs) and specific operations (e.g. unaligned transactions)
such as the NormalNC memory type.

The default device stage 2 mapping was chosen in KVM for ARM64 since
it was considered safer (i.e. it would not allow guests to trigger
uncontained failures ultimately crashing the machine) but this
turned out to be asynchronous (SError) defeating the purpose.

For these reasons, relax the KVM stage 2 device memory attributes
from DEVICE_nGnRE to Normal-NC.

Generalizing to other devices may be problematic, however. E.g.
GICv2 VCPU interface, which is effectively a shared peripheral, can
allow a guest to affect another guest's interrupt distribution. Hence
limit the change to VFIO PCI as caution. This is achieved by
making the VFIO PCI core module set a flag that is tested by KVM
to activate the code. This could be extended to other devices in
the future once that is deemed safe.

[1] section D8.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf

Applied over v6.8-rc5.

History
=======
v7 -> v8
- Changed commit message of patches 2/4 and 4/4 to include detailed
  description of the VM_ALLOW_ANY_UNCACHED flag posted by Jason in
  the commit message.
- Added more detailed comment in the vfio_pci_core about
  VM_ALLOW_ANY_UNCACHED flag.
- Rebased to v6.8-rc5.

v6 -> v7
- Changed VM_VFIO_ALLOW_WC to VM_ALLOW_ANY_UNCACHED based on suggestion
  from Alex Williamson.
- Refactored stage2_set_prot_attr() based on Will's suggestion to
  reorganize the switch cases. Also updated the case to return -EINVAL
  when both KVM_PGTABLE_PROT_DEVICE and KVM_PGTABLE_PROT_NORMAL_NC set.
- Fixed nits pointed by Oliver and Catalin.

v5 -> v6
- Rebased to v6.8-rc2

v4 -> v5
- Moved the cover letter description text to patch 1/4.
- Cleaned up stage2_set_prot_attr() based on Marc Zyngier suggestions.
- Moved the mm header file changes to a separate patch.
- Rebased to v6.7-rc3.

v3 -> v4
- Moved the vfio-pci change to use the VM_VFIO_ALLOW_WC into
  separate patch.
- Added check to warn on the case NORMAL_NC and DEVICE are
  set simultaneously.
- Fixed miscellaneous nitpicks suggested in v3.

v2 -> v3
- Added a new patch (and converted to patch series) suggested by
  Catalin Marinas to ensure the code changes are restricted to
  VFIO PCI devices.
- Introduced VM_VFIO_ALLOW_WC flag for VFIO PCI to communicate
  with VMM.
- Reverted GIC mapping to DEVICE.

v1 -> v2
- Updated commit log to the one posted by
  Lorenzo Pieralisi <lpieralisi@kernel.org> (Thanks!)
- Added new flag to represent the NORMAL_NC setting. Updated
  stage2_set_prot_attr() to handle new flag.

v7 Link:
https://lore.kernel.org/all/20240211174705.31992-1-ankita@nvidia.com/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (4):
  kvm: arm64: introduce new flag for non-cacheable IO memory
  mm: introduce new flag to indicate wc safe
  kvm: arm64: set io memory s2 pte as normalnc for vfio pci device
  vfio: convey kvm that the vfio-pci device is wc safe

 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 14 ++++++++++----
 drivers/vfio/pci/vfio_pci_core.c     | 18 +++++++++++++++++-
 include/linux/mm.h                   | 14 ++++++++++++++
 6 files changed, 64 insertions(+), 10 deletions(-)

-- 
2.34.1


