Return-Path: <kvm+bounces-51116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC81AEEA43
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31A7F42248A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1E8292912;
	Mon, 30 Jun 2025 22:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SyAa4t7j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF42EA73B;
	Mon, 30 Jun 2025 22:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322529; cv=fail; b=glM0P+nuc6rzPQDfFjcO/Hd1g9AZtLtTsWYrL+RYCmTDyCMWQPw2NJ/Nm9245ouxCmYIfZu4BauZt5ViKky4hNcCLAvStVM4z23QbotuNUc0fdmiSXEYxz+UlzoL9Z6umxyxi4jNnwWu8BbS8k8yVAKUAGkqfHMJ8+JOiIArbIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322529; c=relaxed/simple;
	bh=0O4MeUdhTZmvrgAxWubTC1e7I9UA5J9xvaOenN1a6Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DkhFTn7+WKM79R9psV6rEFcQK3zB0R2Vs0jYVaFxTBiBuA1jwK/PVWs3wbfzYbRd7W0mvKN56G0tklEOY9PcMmXb0snkeZ6HoPYBpepepfR7XTwXlbqPJ374ZTsWrhY2/0yZUkvIIQ7eLxNR4Lmj6NpYhl7l7DjAwd6upYhwKxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SyAa4t7j; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pao5Za/Ro0xPpkkWCfn0obRiMMVpHKyYobDQCImsjFUndf1K1WZKK4lRtpv1HgmZ5fx95RWpHy2MqAiBzs0rJS3auPYzlKbaD9hQCwSyDHF9DQkP07+gFFzCLA9JkaSTNQ4JCfw/kSlui21ToQB58H8v4hKtdQCyeHldAMsdDtlqdnQz9mIrAbwCcOJholyY2rB2eehTm3EDF68XML9y+bD2iYNQ1OC75QxHz0Z2i39GQbK1JZA088FaFdDdW+2hPQhMGglrbVReIrvQdHd3oxDpMUpDNQCAW9ZRFNq7agheyGV7NfhC5rv2qqfDMw850q7OMISj68tPuQf45O/pNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWOQR1KAZ1/jC7c/+bIkkj2Fqn/8oFEowWnCRuhu7q8=;
 b=CjX0Y8hSX3KIu8h6AXb882Xlt1GZSvkf7yHlBXyOu21JhE0ivDLGYkSZdTesCbPPi91H/jYExjwBa6SR5iSgQz7bdDAahQ4FSSDm2Ku1P1M2/ppxG1tZbGGko6oNey3rZI5cSuxTIxJnU/4XckyntMFDL+rhJSH2+SlV8iTXtOhS9hcKPrAtOySzqwlYfiuY0XzZm+tfrL+BA6z0kKtEGc85a/EkDsAT2IVxS6Gfp9bOgPJjUkHw4qHyL/cwVNY3Cy3z3MsRPafBoM09/NXa3VdwFaVtQJR/zt6TPTqA6AU1X1ySWcYt+lZg9i7Z5ObSwHtmP5ETrpO/vrnW7V+yZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWOQR1KAZ1/jC7c/+bIkkj2Fqn/8oFEowWnCRuhu7q8=;
 b=SyAa4t7jkgn4mN9M5ceoWRASa3VARumJ6DDmwzTEZ7oKKDkBenDhdM4BQuVxuUWcrsIoDppbP/PKjXMUWH06JQWPEujzZjYgc1aFjAICiqLT7HKKUj4qVraB11pIf1pLPF5Tspjy0GKTvqaGvzSLdq+tPEjgoIpbzZa6XEj3UcvNZe56h3Zg8PH2gWW/sbVCivixsQ97Ce3llV5nfdHGy04D+Mn5EbYSAmRCasWzhG4gvUeyaOmt4oAL08w5YkHPooMm4Zecg1cvCnKRjd5eb3dcPqXyHmZjqWA7HrTyXzJY91rHo36sWCDWlrQKLLaJh/9ImXj38Y+5Bhbv+DP+GQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BN7PPF48E601ED5.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ce) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 30 Jun
 2025 22:28:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH 00/11] Fix incorrect iommu_groups with PCIe switches
Date: Mon, 30 Jun 2025 19:28:30 -0300
Message-ID: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BN7PPF48E601ED5:EE_
X-MS-Office365-Filtering-Correlation-Id: 0501694c-2175-42ed-60cc-08ddb82578d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YAKe6N1+G1Ut20AWHGkzJk1UH4cvQHMEE2ru83kfX+qc1B6u3x/EZMiEUC4J?=
 =?us-ascii?Q?yaOKDLrbKFju0Z+R8/802rlGbpBorsxmggo16tvRLJBgXfuUMte750580+Ob?=
 =?us-ascii?Q?TYPflFHoYFG96RDi63wTBC8sY280KhU4rt8MJgMrSn9QsazAgoZ3x19qH9qs?=
 =?us-ascii?Q?KZ+gKsr3eyq1PZrLGNBF42i91LHzgQN5VxNqsQa9hXqR/25+6s5QsRIBB6pH?=
 =?us-ascii?Q?UO28cZtNjlqiPiNETAUrruxYaKLqtKMFiONoZFh66k2kDnoOroxjalNyCGJd?=
 =?us-ascii?Q?B8MX/b0NyI2tCDCGuGgZbo1dKbBwmci7sLyOhBBv3HIwd3PUoqzWqE4bwk3U?=
 =?us-ascii?Q?q2D3AxoBsP4TxKzJSw3j8eZIjMQST1mSe5c2hY4p0ZrYbTXkN7BKzfn7Su2F?=
 =?us-ascii?Q?+ThgzXXGHiIX1aXofLw6len/AaSRU5Cw/E7h9kBMIWTK0ulUItrAvEvpvCuV?=
 =?us-ascii?Q?ud5El4JTCIxazdnee/xikxP0GEV7pjKWBSiIeWMR8TFIw4LJr/JCbvE4jAAS?=
 =?us-ascii?Q?bVxtiecUnvLlLE1gJTwRcT4QQcjZk1y6Gt42Xgmnph/kAUHuf/9Lw8UotTw1?=
 =?us-ascii?Q?y4A1b1Evn2ikjheiWV49PByOBvkN/Oejmy5ffPpjeSv3fno0Nb2pZvMFzst4?=
 =?us-ascii?Q?Z5xyP4Va5sHf/hmQ+Heg5zlIZve8q0pzJi8d8TTto3eNi0yb/wc2pVVSJAWv?=
 =?us-ascii?Q?b4AWkz8PjjetggmkZa7NvGh2pxC7ZGzomgQRI2lQ27N1ekQXXa0rjvutdvR6?=
 =?us-ascii?Q?PHS/isHivSz6C1+1x5TwR/+N3EoiU8QngPEWKegBGqEwqu9Vz/SmWdqQujas?=
 =?us-ascii?Q?up3ayXcXSKzNoiyS1T2uDhlFbs8+Jrf5v+lw9kehYLphmWSnwCIinWOgqzsd?=
 =?us-ascii?Q?g91OLSAadQbdsALiJ6FVrDMBW3bz3SnK0Jo+M8Fsv9pxEqwk5G3/PtfbmEnJ?=
 =?us-ascii?Q?GqNGYEJHM/BilyLvYlynEpW+7xF1Jmmhxqh/8wdF2CfVs2Jxh7KgKW60xdEz?=
 =?us-ascii?Q?fxwFXouchL1dIornvPer+VoScpmmBJOOOMJ8qFJbm7wNHhlkOYzmMlYzXHc2?=
 =?us-ascii?Q?XPVZXwr8wWIATSCorxfFH7OF7fhnEUsEx3Nysu6eo/ohw/u698vfN3d+dlFF?=
 =?us-ascii?Q?lu27cVIYgumw3q1RaOZxm0JzX5sQRWtMf3zisWiH3TsNl/Mju90mRwVZOb6F?=
 =?us-ascii?Q?GliCeizp8hoyY9AiTIW2GLWBoc+d+U0un7/tduVKfNNb6pAznnYgU887qv+l?=
 =?us-ascii?Q?X3UNE5Lg6A4k6gDjWHtDIb91L3WHbXZYXA2hR2hgdW1Mi8Ii+jU7k7fxdmzG?=
 =?us-ascii?Q?LY/q8vL1kOpMLcRuFz0ngtYwMZCxWAtNzmkJ4tdKN4cOOm01gKF4gzE8q+9C?=
 =?us-ascii?Q?5azkVd6qwPsquk0k9fL1bM5fAQAyv2YU/C8SxHslnuAJNduoWAynCQeEO738?=
 =?us-ascii?Q?ztYIrXSmtsE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fWcI6hpijbVOkcpzKgM7yqw+lBvFAQAcHRHXZGDOEz6t4eyYC+ppOEuXbfBt?=
 =?us-ascii?Q?CjItG3XCjO14dXeiML6Ur01wXsJ1v/dsDDqL/gPHU8LxxD/ghvjTnmJ3XS/R?=
 =?us-ascii?Q?30YzJerQwEurfQzE2v9GKsb/X6M7Z3zBhvC4GKJugtvAj5nyat5JlnL3jPrq?=
 =?us-ascii?Q?j4vGF4fd9Geed5gw5C8jYQTtAiOMEkz+IQHSZfESLbLaW1b5GwvcilCLSH4q?=
 =?us-ascii?Q?2c+e4xo/6/pUII5nRvy69FvW4Od8fm6bU4nHx3Iuf1SPQu/XE/HUppSBVYDM?=
 =?us-ascii?Q?yY54UlgxZ8bfkyIQaclYYOR+b3xGU5x/zIYYohBkyE6RzF3hjHk02w9NzddT?=
 =?us-ascii?Q?sOsIZjC8e7wi+k/deSnaPr6N6oZN3xJc4//x80kUIZzgHT8mU/yU7mEZI9qu?=
 =?us-ascii?Q?Y+dpm7MruEvkV4hT9S5QWzxKFrigpIXmQMR8YWezZzyDO1cFbCf28Rb1EqMN?=
 =?us-ascii?Q?JwT4xNblmfYEMp/yTuAdLl98J8ldXDNZcy76FuWo2Qid/CxHMQr95zFGKhj+?=
 =?us-ascii?Q?mG+M3TDaNgqgKIzyziPJsFfZX13Pu7rsHuqfilZW9dBX9HveAEhUtQIupVnF?=
 =?us-ascii?Q?H15zAu8gq+/TnX71U14gt8XYcO7eEpP50MtUz7jgGd3oOQw+ZSYLI3FvX+Kp?=
 =?us-ascii?Q?T0ItkvAs2+UpcZrs1ZGXhPZxTwprEvloxdGR6yqkIUonjRZkkhguc5dYcn+F?=
 =?us-ascii?Q?6QQ4Cwqd7H/DbRDtgStWX6SH9aSu+KdK/0/wIltSmQZc5tiD5UZXRQ6wbFS/?=
 =?us-ascii?Q?fwbxVuXH5l8vV33C/mTkmO6uKsuXL9snuMkg7O/AQrT9/TMtpgSAhvjUPTQC?=
 =?us-ascii?Q?rMzlbsn3dpcmGqyhUCfDbY5aENZTL7pwqOiRYxNNnP+MVaZ0G5qsEQqspS9u?=
 =?us-ascii?Q?KTHZzCNk8kiTX+FPrD6zTpyHPzTYqsU/gpAAb7sBs1hu0pA8Z/pqi4d1PbGJ?=
 =?us-ascii?Q?qWFzPbAYgSA55DEeuJZ0RchmT9bYL8sxS0vErZWy3FEcoaYrnWlLe7eG30XM?=
 =?us-ascii?Q?X0v6O7w+BnRpf+VtMwwNSKMM1PwuUXFkHPppTDfbWwvCNxRslj/VGiHafRBj?=
 =?us-ascii?Q?u4yJLyxfoljL8Pmpk0qfJb6OtuPsWrAnKaf/NEm25Y7hDTmy2YYaTP7u70AZ?=
 =?us-ascii?Q?L6Hng+kjpQ55AlZuPLfbjK6Hw4rvhPqr19b/71hQ+fqQ0YxuScMZWXS81QJg?=
 =?us-ascii?Q?lPb6sRWSZoxlY5BlvAEt0hq0vvzheewRScy8GaiBeECqNS8Lc8OYTxeotg7t?=
 =?us-ascii?Q?CcWhnBksZoN+L9w16RMJ4EQtud0jyuo29MxMV61fzHtQwToy3rHB6XQsjiyp?=
 =?us-ascii?Q?Mwy+6KpRGIhrgjE8YI/ynASOHnULKj2VuBP0Ydt/9lTBrAqjfwhb28QdidHx?=
 =?us-ascii?Q?MNd+HBwvIN/t25iWykipDoEwfCnvA+DziDbrteHO5eawOXP89zTrnqLJ5Y0L?=
 =?us-ascii?Q?8OBcAV2r/8s56fXeT8kSZjorSqyPpfXiN75Nji5iu7MaQfGemIYF9Hg8KbpZ?=
 =?us-ascii?Q?tKeS/LTUepQkkkbcfPrBGwucdALBBRgIvNsbFe+9fGCxmOlyWWnATQfd1PQU?=
 =?us-ascii?Q?GBIwhmRmmOvt04AZrldaaM+ZUVb37yrhfjtWnJUY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0501694c-2175-42ed-60cc-08ddb82578d2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:44.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27KvXhinmqpwrSPjFr9nSKcotlniwJDBfzJgqh2O1G6isrdXI23ZlR6+kvg1yvfl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF48E601ED5

The series patches have extensive descriptions as to the problem and
solution, but in short a PCIe topology like:

                               -- DSP 02:00.0 -> End Point A
 Root 00:00.0 -> USP 01:00.0 --|
                               -- DSP 02:03.0 -> End Point B

Will generate unique single device groups for every device even if ACS is
not enabled on the two DSP ports. This is a serious failure for the VFIO
security model.

This entire series goes further and makes some additional improvements to
the ACS validation found while studying this problem. The groups around a
PCIe to PCI bridge are shrunk to not include the PCIe bridge.

The last patches implement "ACS Enhanced" on top of it. Due to how ACS
Enhanced was defined as a non-backward compatible feature it is important
to get SW support out there.

Due to potential VFIO complaints this should go to a linux-next tree to
give it some more exposure.

This has been tested on a system here with 5 different PCIe switches from
two vendors, a PCIe-PCI bridge, and a complex set of ACS flags.

This is on github: https://github.com/jgunthorpe/linux/commits/pcie_switch_groups

Jason Gunthorpe (11):
  PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
  PCI: Add pci_bus_isolation()
  iommu: Compute iommu_groups properly for PCIe switches
  iommu: Organize iommu_group by member size
  PCI: Add pci_reachable_set()
  iommu: Use pci_reachable_set() in pci_device_group()
  iommu: Validate that pci_for_each_dma_alias() matches the groups
  PCI: Add the ACS Enhanced Capability definitions
  PCI: Enable ACS Enhanced bits for enable_acs and config_acs
  PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
  PCI: Check ACS Extended flags for pci_bus_isolated()

 drivers/iommu/iommu.c         | 439 ++++++++++++++++++++++------------
 drivers/pci/ats.c             |   4 +-
 drivers/pci/pci.c             |  73 +++++-
 drivers/pci/search.c          | 250 +++++++++++++++++++
 include/linux/pci.h           |  43 ++++
 include/uapi/linux/pci_regs.h |  18 ++
 6 files changed, 661 insertions(+), 166 deletions(-)


base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
-- 
2.43.0


