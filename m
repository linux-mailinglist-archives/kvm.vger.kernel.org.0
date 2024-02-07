Return-Path: <kvm+bounces-8279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83EC684D320
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 21:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBA141F23B7D
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 20:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE4B83CD3;
	Wed,  7 Feb 2024 20:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aRSqJxyS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3D31E51D;
	Wed,  7 Feb 2024 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707338846; cv=fail; b=Qo5UectR49CviEDWykHwD+SqE0rUUELTydr+/2BeLC2C5inwi1fp3gFJIf/NC57oqxVBYHHQ2qBXSQ4U9plz60gUePoWZ7QmMGOl/a01htK0M+1cqrtf211hytmNEzNOSXnJ+Yh92+mgB8JxWawYIz/tdnibxlRVmfADnE1OQBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707338846; c=relaxed/simple;
	bh=msnJTpZ8zS3ItYF7ScdvYcykoZKEs7dsODoewrnqW4A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SoO2Dinh1ZBStP4li0O1GCqgUWvovL+Up/Hu7wjim391oVZMVszyr33LbrcPBtsJMOEdAuSbfBf/EoiCLgMBMamFZzamUloENXH3ngDDx6w7lz7Ie6xEg7b7MK/uUfaDwf97IyoHkW39hMzsxft3Q+95Y2pXTOW8jL/rt8+PPaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aRSqJxyS; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDcvrD8mF/rATSgyi3sKYZPV5FFq6+4BZlSWrslaaqLJ22FLFRX3mdx5XrTALGAujMlr/2ArIPTBUgO3qyR0Q8k/p4gku/ydl3Wb9VaJN/Mt3R083F6gAUzv8ApVXeQo5LmznzgF3hB+tvnS5ENpywKJaLMcqe5zgcQK7XazdBQC6Fo/QMwrec3hUmayeHtEQZMkIDKIh7XKiAVHU8t4M8VLcPTFdHpFIEnzFSTGvB2k0+s4oD3tlB7aY9YOUedv9zXACtS00hhrA6Dy+iZxi8sk7qo5/8E+TgMPjT98jOPWcl2o2Q1RgoV0YvzoKNVxXiiTUoPkYJBzxFNmsPaHxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aot13UJCsTPx4X4X08wsEuhasploJqO5xwf6HdKOBfk=;
 b=NLRX/CsBLhv1OrEP9VV1JvWgaJHhg5BslC+CqPVDElwZi5iHpGkiq310GNqHTYONl5KS6mqlHbYSH629YZq3st/w/hufqjLMsmpMJMeWxOiPvrGkL+E6HtNTwa1WlunQw1yNAmy9kApVwjtEdvvTS1dIOtC5D+mQr3TESl4vcjCzEg8hRr4SYQYqqhL2G+25CWQm3JIZKDDW8Zp1q1DbsLHrLOFwqG+shN01Nq8TTyHTvvKRvZObopwQB97qhvsWo37SMcoypoLMR64sl6SzNRFYVMH6lVkGHiFLO2I5RskyP7coHhkRGxbR1P12hT+n9lv7jSz3Yiz/sX5ErZKUNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aot13UJCsTPx4X4X08wsEuhasploJqO5xwf6HdKOBfk=;
 b=aRSqJxySmxtGp8MK1jgy2fqhrH8WskastSH+2t1RkGHV5SETMM+vk3u4FmeAfOAoDQLegeobWTQ4M/zSb2+nftwkNHo37oJxkjEVwO4ifInmz0IRZE27oJUYAlh/7l3xvCB2EvCIMOU3GZBCU+B2Q1C0Tq1PQMEimH+6ikTYNzp6CGF4ejcUjFXmkMMnQD8uO4WVzT8ahs9K828ymtpHABlPYXR1smH6Nx4ykqcQGBWmgEFtzRTpII4kmLfaDy2N7Liu0vFiFhZQQt6CF/aAa9BOjQKWlR2AZZmt4+adyMMnAZXzkBljM3AHyBdR2mwVPkQkqYJNh81FhLAzX78O5g==
Received: from BL0PR0102CA0019.prod.exchangelabs.com (2603:10b6:207:18::32) by
 SA1PR12MB8947.namprd12.prod.outlook.com (2603:10b6:806:386::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7270.14; Wed, 7 Feb 2024 20:47:21 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:207:18:cafe::c5) by BL0PR0102CA0019.outlook.office365.com
 (2603:10b6:207:18::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38 via Frontend
 Transport; Wed, 7 Feb 2024 20:47:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Wed, 7 Feb 2024 20:47:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:05 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 7 Feb 2024
 12:47:04 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 7 Feb 2024 12:46:54 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <ricarkol@google.com>,
	<linux-mm@kvack.org>, <lpieralisi@kernel.org>, <rananta@google.com>,
	<ryan.roberts@arm.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v6 0/4] kvm: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Thu, 8 Feb 2024 02:16:48 +0530
Message-ID: <20240207204652.22954-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|SA1PR12MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f4ab940-2ce6-40bb-5e3d-08dc281dfb11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DOqwwwQ1me5hWBnAJ/rUxVUHjcbSuYTUDA7BhdXLbov5zy/WlK6rth6GppDEX7whLzY22majp3O43uDcz8ArWaOnhLiC4GxoN1WAvm7dTA2znYzGGwCI3SAAoD5fUfye0SY6IqsVMm0hctuQpqWTITR2TJnijwg5uz6pLtOZ2vhc2CkJ5TWVdfLdkP4KF1Zxq6fOwbngAyl6ZpItINxVtvWdmXwTpphX15lue7KDG6cqHjo1eGtZoSpKIVDlwTLAJ2/rqscYx1VBMW6QM51JelKXUG2YnyuWqptkXlqwuQfXuZP9ME4I8weIJ6d/9BDrUOVyLvi5Dc5YZQ11XpVYQfmgG3LMEU8hKa00YYjGdX+8RTJ2UyZ16n2E3OcOc3oOj+tM5u3DH/1Y2ykb5ACUmaLeTeA8pSj/ltj8gA1KwSmvUEZOBfe/MeT3XzKL2S3M42gPMGZIs7AyTGKWeg91H++KwxzRRLJwpzestPYcBXYbaMJYrdZcxfghJmy3ibaWoWdbRSURHbAXL7ftxhXztLx+CGJ89+0dKUTJvjJW2NdXjEhePNAWEJoYXOW2rh54lgDkH9cutRsWcTQ5e/1wo2QPZxFOFACwPOupzVHsGkcXdUUiakZQAbetIu62NsqI2TY/9kMMaFGIsduA1tka1BvYVvlavO/obFNQQZzBM/rKRL58bdzs+mNM6g+DgwKG
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(230922051799003)(230273577357003)(186009)(82310400011)(64100799003)(451199024)(1800799012)(46966006)(40470700004)(36840700001)(70206006)(7636003)(5660300002)(82740400003)(2876002)(54906003)(356005)(7416002)(110136005)(41300700001)(2906002)(8676002)(8936002)(4326008)(336012)(426003)(26005)(70586007)(1076003)(316002)(83380400001)(2616005)(36756003)(966005)(86362001)(7696005)(478600001)(921011)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2024 20:47:20.9274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f4ab940-2ce6-40bb-5e3d-08dc281dfb11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8947

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

Applied over v6.8-rc2.

History
=======
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

v5 Link:
https://lore.kernel.org/all/20231221154002.32622-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Ankit Agrawal (4):
  kvm: arm64: introduce new flag for non-cacheable IO memory
  mm: introduce new flag to indicate wc safe
  kvm: arm64: set io memory s2 pte as normalnc for vfio pci device
  vfio: convey kvm that the vfio-pci device is wc safe

 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 18 ++++++++++++++----
 drivers/vfio/pci/vfio_pci_core.c     |  3 ++-
 include/linux/mm.h                   | 14 ++++++++++++++
 6 files changed, 52 insertions(+), 10 deletions(-)

-- 
2.34.1


