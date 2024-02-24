Return-Path: <kvm+bounces-9598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 161A08625BA
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 16:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 969051F2119D
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 15:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8A24C626;
	Sat, 24 Feb 2024 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tSsTR9Yg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41C74A9BF;
	Sat, 24 Feb 2024 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708787180; cv=fail; b=oVFVN1Mi0YVcs6O0myXwPLRFwxAeIkts9f540HufCtiItwzuj5UV0B3UFfBGGI8OUdUs0izztC5I3xTz5eeQbOGAs3I5GpEBN9cPf+0sizKIXluHv15mqGjP86BAqKUpmqW7edwaXQvGQjlpJGRk98Vv/A0+lM47LdPc/w3T2aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708787180; c=relaxed/simple;
	bh=SAFwc2gxk+qvcLKJksQMjk3z+Hx1gl+kqX2TcGblaxM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pNyH928lMj7sFUt+bmaAPC6eEmsZYfxkc5sMmLwLFCzggHlK4ogosKTnMk0y5M9VY8LkWJT0Ox7STVzbYVvQSLXI5HeslLzi+Rr6NgPHVInUoxN2fUmdvm1rH7//Hbx7vILtPJFb/KqvlP6i+ezTaYY0MJ8o9lJDI2GiuNAP2BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tSsTR9Yg; arc=fail smtp.client-ip=40.107.96.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGgjjOf24/2cHpqOuwbkHPeOLrgWSiUzfKnKDbs7BmhlUc7suBQY2LPnF5509SJIxCGw/yYsly1kewFecCnG4xFUyC2iqmi74ikcMNx8rL2JtiiKI12zrkFXxnI1XqHUXguCRadmb8LBOtnKLYaTDDlASNyX86Unb6Avy1PlwmTtrC7EsfcSxTkqnqsGCD0n4ALEV4tRZqS/M34EyuCkkhB3qKVO27mUYx7JIrfGTyvD6IJrHG2nlWxnC0fN0d4SbhzUWK9DgePQGpObSydGo4w0dA/wMiZlYXwi70c+qses2wOcQUwJj7Yekt/SYwzkQb97+OWUFHLm/jB7MXg8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUZDIzYliEDlkf7KLAlMPoVkGBFu7l2QbwRHkYMVkeU=;
 b=lzm1MkhfsNnnLt/9rCDyWRFq9WuBgkEsIyyZeGO4X7paPL1Lxq3nX2AhvLNk5s9+odEeGR+umhoLVldp4dTMfRlFvQmkuj9OcU0oEYau399hUfNSuVpbGzAP4sPdt5aZvm+6iYQS8+2SQa8WsLYLi7L+ZIFLwTmwJ1723K7HDCaNOnzj5UNv5mn/MccxVedytlRD90d6yEPHS/Dx48aMXiY/b01/4hHOrJQ0c592vjSP6GhtGRsBYNiXAKo+ey9sS14k98wx5isRSwiAnUqnnQHyUtmd9pklUCBCWxkmR+8YeLqY4T1688fvwvRQvfMZkh2XTgphemDq7f2u8Lo+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUZDIzYliEDlkf7KLAlMPoVkGBFu7l2QbwRHkYMVkeU=;
 b=tSsTR9YgA33hI8qhPsemnUL65Vx6oQcWh9EegAN18ZJxG6NIFDXbLojvPO7etL/fjezPf9b+5rzT0K85Wy4A/TL8t0JoWL3BF+3mipkl6zBbpt0fW4OfLL4bYoTUMMqOTDmc2sJjlY0M/sMliQ0XJGtqaO/5Lw7V16Eh8ymxUfBOx8BWOfyGSVvB2Wg6YTiO9M3r0TYTy/f0UHasK1W40fdh6Lb7qsnXROHo1aOWU1Q4xKGmTAfAFtYNflSirqrVseRcOdX06PzjXkRkwGFVuvT2ixRCu03mg0GT+enHeD94IITMiRW6bWhgQQvglpLimRqahHWE8vlNM9W+Kb2adQ==
Received: from CH2PR19CA0011.namprd19.prod.outlook.com (2603:10b6:610:4d::21)
 by DS0PR12MB7678.namprd12.prod.outlook.com (2603:10b6:8:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Sat, 24 Feb
 2024 15:06:12 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::70) by CH2PR19CA0011.outlook.office365.com
 (2603:10b6:610:4d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.48 via Frontend
 Transport; Sat, 24 Feb 2024 15:06:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sat, 24 Feb 2024 15:06:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sat, 24 Feb
 2024 07:06:02 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sat, 24 Feb
 2024 07:06:00 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sat, 24 Feb 2024 07:05:49 -0800
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
Subject: [PATCH v9 0/4] KVM: arm64: Allow the VM to select DEVICE_* and NORMAL_NC for IO memory
Date: Sat, 24 Feb 2024 20:35:42 +0530
Message-ID: <20240224150546.368-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DS0PR12MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b8585ce-199d-4d54-838f-08dc354a23fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ktApkWdr0NlyvDIrtx6nokZHwdbcm8ERQF4MS21EeZynfmfRI1GDbnOWa3teX3388pJZ8ENP/VjXEDHlD9T0lu6IQnIL0V/+AQ9jzXlIK2oyLWL98vAOCmTf7Bsxivd5iLALVrELUNalpSczNgzSJ/Qpq+oNdZTlU4Ve9Yyma1iwAxET02HF5U8/hC3LbTg5VQkBSQHIe5DhHhmZPN1qsZapRS3e1hi5/qK8ubDTg1D7xQAyQLVpg2iAJcVBslelHT3awCLEcwoAdYueLg5dfybeReKFNxLJo8s2zlXs0l+7/5yjz6/OOe7g3DoonoW2hjReJRb+bgEd0qg0H5KYGjVUTOdUIoHHhIO2/8zh4MzwwuzjRjg6i3bHt/RO+rGdmuXWvDn+U+5Y3BnDdR3nhbsx3Gi7sVjX8LQz7r9bAm2njTNow90Gi7k0A8Qz2uhN588z6db+Malhtq4uh5JAkvZgwdsupZSH5audOVIdKdUR2h42zx/shx5oABuy09Fqj7T5BK+VmaJP+fIx7m6UdQ8l5ymQUU5Z0H+HDmxYnRPf2pT1e6JNREWIstPs52Z9Sfhgg6NM6I/mT+qJIICE7C8r3nkVePtppg4+tzFpIgVijl6JOLaOtlkZEhTu2yxFCgzONnAakhcDedEpVp5Y4DAf23AFbyQy96aYhTSAlCYrwrHfVdf+6maE6kVA8CMdf3BTgYtQYS0DIy0khMS0+Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(230273577357003)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 15:06:12.4427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8585ce-199d-4d54-838f-08dc354a23fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7678

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
v8 -> v9
- Collected Reviewed-by and Acked-by.
- Updated the commit messages in 2/4 and 4/4 to passive voice and fix
  spelling error.
- Updated subjects to align with convention of using capitalized first
  letter.
- Added links in 1/4 on the previous conversation for tracking purpose.

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

v8 Link:
https://lore.kernel.org/all/20240220072926.6466-1-ankita@nvidia.com/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (4):
  KVM: arm64: Introduce new flag for non-cacheable IO memory
  mm: Introduce new flag to indicate wc safe
  KVM: arm64: Set io memory s2 pte as normalnc for vfio pci device
  vfio: Convey kvm that the vfio-pci device is wc safe

 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 14 ++++++++++----
 drivers/vfio/pci/vfio_pci_core.c     | 19 ++++++++++++++++++-
 include/linux/mm.h                   | 14 ++++++++++++++
 6 files changed, 65 insertions(+), 10 deletions(-)

-- 
2.34.1


