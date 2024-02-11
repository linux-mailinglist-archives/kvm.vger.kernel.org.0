Return-Path: <kvm+bounces-8514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 215B3850AB2
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 18:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 023C1B20E98
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 17:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B219A5CDFD;
	Sun, 11 Feb 2024 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jDyyCa3e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9A15B5C8;
	Sun, 11 Feb 2024 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707673652; cv=fail; b=d8Y08oTzli3cETQ4DQ8yqhckE2zmXXmjCOfM5Vn4q/LUxVJRz7RGCVnrSM1B0qfnvC0LJVY6tl99ftQexgujycHWH2byFhReDiQUsKHdL7/4K2BIuo0B+y7EJpp2HSYX9LAGmItSlaoKG24G+pumDr9ou+Bo6eJHepAAwSwapvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707673652; c=relaxed/simple;
	bh=NbkIpdAs6j24EK+X6X+/UJwHxYdPAR4ARoGbRyBl9fo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UoyfgQWyljv6l5x+P0f+S2a/WE8cbAeBF3BB2RMb6z9MlEYDJBgiu6d/brDdRu3TXaneaIUlo5mVZJ6Ck/nuyRZ6m+6XJs3w/ei31JjigOkk5KIqchdhTdl8vCgtLT58F6uokbVBcYmYnqxvI9gX1lYxidHRZQ9PL2B6/M28u38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jDyyCa3e; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkRxADkZDwqo1+xPQOBX3UFlrRvnBomQG8owwqwyLkCyFrQzXnNZt6LFfFHy0w27jsAYkksazlgzaOg8WiN6TujIKCOkwC18qFkOi6zTcLrAifRWhDslIlaMm9GqiFpTdwhkRn5siFpQFQajjpWRHWSnjT1KbB9iYbFft5y9649ePloFbVa3muoHm4QSzeZ1/nlj2988SUU7gGKT/mb9SF9Xkv4/pfQSC8+HP6yV9w2kK5TRXWxPFEFflMdd01sVxXAzRwsfbP8jyGo7u/0qBZKRx3+sPgbr2VR3gYkG+aU0rV1pjbhl2OEG2MwFiwY6qO5nT6+0MDVpQgYSsThGSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdtTdLsbyXcnVxp0s3Ht0s2Pbye1RL+I/5RuQ+dkVKY=;
 b=brWNLOauBtLfwumnfkVceQ/dlWo7uVIMM2VX1MdsuZ2P2UUFmB18yGyeG4DPxHRpEX2nV0AANDm4QpnzLx9xbZvz6FZt2pntdjt4e/Dge6tQixoYFxKftWjblfr65D6HaNMlRQ1wW4JqZFAfANs8y/SF1B0/mLx4dr4/tC63nnJvLV8dSSER5ReqGXgAvHIBQSOpD+uP11EQ07PFH5zfw+HEQkBnVxEY0FpzamJ+FDyLkdrPBgeqB5MI81jZpXJqgzFVBUajzPak1Zl38hWhbmr+osXM3RdsHCf24sxChZFKJaOOU6SSWca4ARqiSV1YaUJULSW/ihHrIuYl5XH8ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdtTdLsbyXcnVxp0s3Ht0s2Pbye1RL+I/5RuQ+dkVKY=;
 b=jDyyCa3ezM15bFOT+FbBao3fBLPlz09lmNT3SPIhVCZSytb4jOYcUqpNTX8FVa02yiOkzGSEABjGCHcoF0qJf3w5TlAZlPeZK/XDSOQk5prmrb1jJfURexS7xlbwEpuGh4vJqsnPA3kaTSSiotVWnwiOcqPHvwE7cCU1NsBTkxqHt+WNT7QsKtT1wEp4b+HScQrXVbTm+oz2VJSMYugWKkWS5tIYRB6TPYdwaYmi8nbTtH7xzOhFFZkBPoxrSZL49XYA28AeeOLwRLjP42Wmbu0iUYFzL7Y9OmWtzKyQf3Fl0m3Vdnc6kIZRlx8mcxFcG0/DTBWDZjo5svBU1fF7cw==
Received: from DM6PR03CA0056.namprd03.prod.outlook.com (2603:10b6:5:100::33)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.18; Sun, 11 Feb
 2024 17:47:26 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:5:100:cafe::9c) by DM6PR03CA0056.outlook.office365.com
 (2603:10b6:5:100::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.37 via Frontend
 Transport; Sun, 11 Feb 2024 17:47:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Sun, 11 Feb 2024 17:47:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 11 Feb
 2024 09:47:18 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Sun, 11 Feb 2024 09:47:17 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sun, 11 Feb 2024 09:47:07 -0800
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
Subject: [PATCH v7 0/4] kvm: arm64: allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Sun, 11 Feb 2024 23:17:01 +0530
Message-ID: <20240211174705.31992-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e7f7f4-570d-47f8-9d40-08dc2b29822d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	L/IvJvM3dG6uJokmSd+0BXysE6pZlijNspFqG7ixztH+Skgh0s71pYsHnKZpkmfcktkAX9E6RcxxP2EN+w6qX72NoRCzI9vIjXa2QyDNJmCg3M6DM8lXJnlzVPid95xMk9xYRi704o6P3ophhfCH5ugjZNQc5OoSJzSg8c6BjSCsp0b9FGltJHPCAGHGRjnCVt+sYlwE3DDCxfel/10fVuVam2cXBM+0yIC227ip+XJ3zF8Tyk7wCblA/izDCgDYPSXFGGnQh70YPlgK34DiqRzqd2+lFiJ/9HuMdqcutLQBDJNTcGU4St13iWtLcSJjjpPzD+oJOaJ/csElkULrb7GVlpqA4Hez9n2STr38PcZJPRitXYJ1BiJQ+eWOs7+k/WRnakx9sC75HFpUnOg2FynQxIB2Uzpypvl2lNSz7o8INVlJ/3NGOQpKxfCRoFDA49Ga/yIlMAF9Lp8nEQpPj8cbcBizt5miU75C+PXtaJ/RwdJIX+tY89OaDMsLyvDZUWLWgq3fuCzXawU0wfTIfSlCvm2qGFS8VWcBtC2umALWzWNmNkdT5DCKvNeyAABtXdcatI2OWs7WqFRIAPW2qtDvF/YT3lnbbhvikKWk2O9b45/4ySRy/LU2vO2LHa5qlTdmVg13mQMfhjWS1ir2M+RmhCjThM1dTyTBPayyC3RAo7/UttdS+Gf1NEfCV7T0
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(230273577357003)(64100799003)(1800799012)(451199024)(186009)(82310400011)(46966006)(36840700001)(40470700004)(5660300002)(54906003)(316002)(7416002)(7406005)(110136005)(41300700001)(2876002)(2906002)(83380400001)(426003)(2616005)(921011)(1076003)(26005)(356005)(7636003)(86362001)(336012)(36756003)(82740400003)(70206006)(4326008)(70586007)(8936002)(8676002)(478600001)(7696005)(6666004)(966005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2024 17:47:25.6198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e7f7f4-570d-47f8-9d40-08dc2b29822d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395

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

v6 Link:
https://lore.kernel.org/all/20240207204652.22954-1-ankita@nvidia.com/

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
 drivers/vfio/pci/vfio_pci_core.c     |  6 +++++-
 include/linux/mm.h                   | 14 ++++++++++++++
 6 files changed, 52 insertions(+), 10 deletions(-)

-- 
2.34.1


