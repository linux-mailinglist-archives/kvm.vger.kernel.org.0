Return-Path: <kvm+bounces-3930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A22E80A998
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D1628127F
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACF63064B;
	Fri,  8 Dec 2023 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MQMIU1b8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2514B1706;
	Fri,  8 Dec 2023 08:47:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGKrStg87hG3gZEY9KiurhTHGlr9D5v+BDlD/rw71eKWGSVIYroq9eUcIe3nXXxAkF2B711GnXk9UvDOUznRMU45CWwDcCsUXdjwFc5kR5CeG0FLfYOLt2HxHqk+I0KUZoqn6qanpPAtriy/8LEb9so3xJRRX2ZQmKtamdVbGEv7VyecuBqIU5MHzwgPXVIb1wcD30OiucV18DEEAgJ2bWcqmWFrAY3A9vhRDi504LIyji2Px4pX8OtFG3u5rOFbGGrZVSVSeWrUBe+chcwlAoM6KbIG3gp9+RbJjd6+SD47iKG2iBxXE3fBv63HsySw62zX2FbitdgOd7GXCQ5qOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDAETqIT1QZuxUI1naVEoL1E4vFjYgwwL8LN8vBao4M=;
 b=WnU/nXho2pOrqJMubJYIxW7sUi7zZoKQDhXZ6yibSVYrTk2c1uSPK+KEogg+8JN1oKJvZRRWylVaGoH66TT7gcdU58Qi7VAgI0CKHz8XGYMeexMBSUEodX5Hak5OrGcHlhZtV6mribhW3ggFXU/Fsh/MujkXh/89xS9DoVYo/RHAXPueK3BLXi97s/nTqZBVbpCOpDKDD0KZbSzGAxS1QYzrWFCpR9H86xtAxSCP32a4r4wmG89zk+M/p3ysf4XZNuQprrEC9Q2cMOZuFQJoVZ0cBZjse8FfMlNyGI2fpO2XKqJ5ew8pRg8sDLOdPj1m7aJ0zQZU6xD7P82OSVkY9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDAETqIT1QZuxUI1naVEoL1E4vFjYgwwL8LN8vBao4M=;
 b=MQMIU1b8s7vKk/GdQ+PbAU4dy9r3RuHEU3gAVZkwIAGNxVjyL0inCPTgeI80WTlpA+PBigOe5XZkn7e3QDrcaizX1n29kz3pA2uSdrYmVbwHk8AdRV4ComsMZjVUkX5YiHhOx15xTPOcmvryiVTejdj9wwqDJWr1ZvWkiPWwgq2nx+NkJjTZn8Gliavd093OhJdWR8cdkH2kwZge07F2uUhkaYS7WCMCpCL6FmDv2+W0VB+rFj3BNNn5NfooKbZXS6WGw7vADrnZEfHYvFVw64IsFCrEZws7F74iV6/tGuHLyqpgpEr/T/veS1xEOPeeQxwl0mM0383NtGO5ZjqdXg==
Received: from CH0PR03CA0213.namprd03.prod.outlook.com (2603:10b6:610:e7::8)
 by PH7PR12MB7019.namprd12.prod.outlook.com (2603:10b6:510:1b9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 16:47:39 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:610:e7:cafe::8d) by CH0PR03CA0213.outlook.office365.com
 (2603:10b6:610:e7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28 via Frontend
 Transport; Fri, 8 Dec 2023 16:47:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Fri, 8 Dec 2023 16:47:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 8 Dec 2023
 08:47:19 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 8 Dec 2023
 08:47:18 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Fri, 8 Dec 2023 08:47:11 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <gshan@redhat.com>, <linux-mm@kvack.org>,
	<lpieralisi@kernel.org>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<mochs@nvidia.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 0/2]  kvm: arm64: allow vm to select DEVICE_* and
Date: Fri, 8 Dec 2023 22:17:07 +0530
Message-ID: <20231208164709.23101-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|PH7PR12MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: 5796d7c9-ce5a-4e8f-dab7-08dbf80d6315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YS+wnwnCXtHSNB9nOhwQVauJ3q+5C/WH7fIBTE/0JfEGmJw5amRsoiQ8JYZcRLmzperIr29EZNExGjOBZmlAuWedlZx7RgktEIyV6n09iDwVg6lTQ3Subiy8Axvet5kQHVmAnlwl6gjOKo7Q/kU8ni/r/DLc7W+aSi7yimbULS49plpvI1h+vpLUYRPzf1dJ/lzX02bKgjeR6VgRvoMJHUU/ITbVEKfGOJVyAmuffLuoe1o7Z/gFZDoukdCpEL1f4BgJtmLQAdr6Js2g+OYv8DfmzNEe0bWw8Z1oA4SC86ydERNnEkRpM3ayHSUGkahNg1FlkBU8pcOgkxpLHEDq27TYf93c/g/ET9FIaG153Dt8unYWeuLjENKQm12gdAvjRm7t4ESKQzuzRK2PGgWieIbJJU0EozSbbSp3UAtVhRAAFrQBhJkHwmWeHy2zQ2yhJAvPYqxtRFy7j+EeptGHb74E5yl7o6NUcLXz9tGHQIxdMy+YLooE23obp7oqF8PWB8EV3GyGAvZKFra2Aq+SDY9bsLo43zx4iWD01WmkLlO6jv8CmhDM4LTFIEh++Rw/cKQXrlSAepWo9EdaHfZIdBoC2tRJ55/u2KhL9b0ty4RuIuM2Cr+MqX6BWSU/qeDMUUrgBptJXe1S+XbYvofVAifa7AkNW4SnJuVTIy6wPII3g0h3DLTn9bBB+1jasGYz2pawW8OofnJaq0XGejyWyzmHKcJDcJuB44YWGHThMTZOCNXKiqHvAfbHJ37qpcML64AOjQX6ECdQ1jRkNiDiMuEpL2xYlVXuXRIjI1OmNE14FYPAzE2hwfA3nB69BaUiGceGYoYGLH/cybWdPb3tgOyOf5cdDlbdXzL++esbQBMYtuDI1PFhLbu0cGtMj6Io8hPu85ZRwsiqASVrbmVa6w1wmqBPCKgCZpmZeSNPAs8=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(230273577357003)(230173577357003)(451199024)(64100799003)(186009)(1800799012)(82310400011)(46966006)(36840700001)(40470700004)(26005)(4326008)(2616005)(40460700003)(1076003)(921008)(356005)(41300700001)(82740400003)(86362001)(7636003)(2876002)(36756003)(2906002)(47076005)(36860700001)(336012)(83380400001)(426003)(5660300002)(7416002)(966005)(110136005)(316002)(478600001)(6666004)(7696005)(40480700001)(70586007)(70206006)(54906003)(8676002)(8936002)(21314003)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 16:47:38.2447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5796d7c9-ce5a-4e8f-dab7-08dbf80d6315
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7019

From: Ankit Agrawal <ankita@nvidia.com>

Currently, KVM for ARM64 maps at stage 2 memory that is considered device
(i.e. it is not RAM) with DEVICE_nGnRE memory attributes; this setting
overrides (as per the ARM architecture [1]) any device MMIO mapping
present at stage 1, resulting in a set-up whereby a guest operating
system cannot determine device MMIO mapping memory attributes on its
own but it is always overridden by the KVM stage 2 default.

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

Failures containability is a property of the platform and is independent
from the memory type used for MMIO device memory mappings.

Actually, DEVICE_nGnRE memory type is even more problematic than
Normal-NC memory type in terms of faults containability in that e.g.
aborts triggered on DEVICE_nGnRE loads cannot be made, architecturally,
synchronous (i.e. that would imply that the processor should issue at
most 1 load transaction at a time - it cannot pipeline them - otherwise
the synchronous abort semantics would break the no-speculation attribute
attached to DEVICE_XXX memory).

This means that regardless of the combined stage1+stage2 mappings a
platform is safe if and only if device transactions cannot trigger
uncontained failures and that in turn relies on platform capabilities
and the device type being assigned (i.e. PCIe AER/DPC error containment
and RAS architecture[3]); therefore the default KVM device stage 2
memory attributes play no role in making device assignment safer
for a given platform (if the platform design adheres to design
guidelines outlined in [3]) and therefore can be relaxed.

For all these reasons, relax the KVM stage 2 device memory attributes
from DEVICE_nGnRE to Normal-NC.

The NormalNC was chosen over a different Normal memory type default
at stage-2 (e.g. Normal Write-through) to avoid cache allocation/snooping.

Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
trigger any issue on guest device reclaim use cases either (i.e. device
MMIO unmap followed by a device reset) at least for PCIe devices, in that
in PCIe a device reset is architected and carried out through PCI config
space transactions that are naturally ordered with respect to MMIO
transactions according to the PCI ordering rules.

Having Normal-NC S2 default puts guests in control (thanks to
stage1+stage2 combined memory attributes rules [1]) of device MMIO
regions memory mappings, according to the rules described in [1]
and summarized here ([(S1) - stage1], [(S2) - stage 2]):

S1           |  S2           | Result
NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>

It is worth noting that currently, to map devices MMIO space to user
space in a device pass-through use case the VFIO framework applies memory
attributes derived from pgprot_noncached() settings applied to VMAs, which
result in device-nGnRnE memory attributes for the stage-1 VMM mappings.

This means that a userspace mapping for device MMIO space carried
out with the current VFIO framework and a guest OS mapping for the same
MMIO space may result in a mismatched alias as described in [2].

Defaulting KVM device stage-2 mappings to Normal-NC attributes does not
change anything in this respect, in that the mismatched aliases would
only affect (refer to [2] for a detailed explanation) ordering between
the userspace and GuestOS mappings resulting stream of transactions
(i.e. it does not cause loss of property for either stream of
transactions on its own), which is harmless given that the userspace
and GuestOS access to the device is carried out through independent
transactions streams.

Generalizing to other devices may be problematic. E.g. GICv2 VCPU
interface, which is effectively a shared peripheral, can allow a
guest to affect another guest's interrupt distribution. Hence
limit the change to VFIO PCI as caution. This is achieved by
making the VFIO PCI core module set a flag that is tested by KVM
to activate the code. This could be extended to other devices in
the future once that is deemed safe.

[1] section D8.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
[3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf

Applied over next-20231201

History
=======
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

v2 Link:
https://lore.kernel.org/all/20231205033015.10044-1-ankita@nvidia.com/

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Ankit Agrawal <ankita@nvidia.com>

Ankit Agrawal (2):
  kvm: arm64: introduce new flag for non-cacheable IO memory
  kvm: arm64: set io memory s2 pte as normalnc for vfio pci devices

 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/include/asm/memory.h      |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 14 ++++++++++++--
 arch/arm64/kvm/mmu.c                 | 16 +++++++++++++---
 drivers/vfio/pci/vfio_pci_core.c     |  3 ++-
 include/linux/mm.h                   |  7 +++++++
 6 files changed, 38 insertions(+), 6 deletions(-)

-- 
2.17.1


