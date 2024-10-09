Return-Path: <kvm+bounces-28279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC75D997173
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96D6F281D25
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA641E22F0;
	Wed,  9 Oct 2024 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CZEs+Ejn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714311E1C39
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491013; cv=fail; b=iQaeuXJcc7f/xrDqtXw4QRvnJHZeIBG8LwL8ZubYL6TCX5YOdR/P367DM78hWmUSFKMorPYoGECmHjFXQxduMoSU/JpteYykK3dnn+ALaWgj3yGUd339F5twqJ3c080ArU84LOkfSEeLzY3nDfxumRFDl1kEOnnnzzsN74Tb63M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491013; c=relaxed/simple;
	bh=mKT1IJJeKHX4ypen5n7Whj6rhvt4w+VnV0D5xGA4VGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oofrV1e4Y6I68p5q8arbPMmNPf2V88gNMbSVVh4TddjTIeei4TTBIioqt7L3AG2Rodgy/7F8Vdw4LAwtOynDDqpy+rtpZAgQM63LvDLDxI+SzhK/L8pusZup2hT4+cv8Pi2AVAabnN7lKUpVC1He2sN8BeAD6yIVKjlNiLnhIUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CZEs+Ejn; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oafNadK+JKMH2PHZRruXAnelYgL+Jb2H+KM/VGsmePN/PqB3mNyLMBMomz+9fxJskU4g0gp1uwy3ShPLTNNR/InItzkZul+hr5ifGj03puvmOXw78Ccp7sZIah8Nlhpu6F5GEGnTw21rrWG645aQUstE1RsjA6fI+X7bhQ+l1uUv5qX1Te+kxvxCa7fX6EPhKv224vLxXGsfXS56xyOOixVgpCBn8eUTtUFAgxE3ar6jWTCittmjtu2szus1uZeRpKA+uvgke9eG1Zy0d3GZxgmNUii2HMd3X/GaiE5PWG3qVmj/edyfVKkLXzgQW/rsHZ+xpqGGNH23toMaz4Dr0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UM/OqRVKfdnk+8DUpdClNjxJr4a69tRo13nfkCjpyJA=;
 b=GNwBjgzblR5NeGsKgTjS7TgpLQ+rWBKcyzLfrSLwn7lWNFH4vaLHcyAclXzFX5QZnKAoQkiVLgThBZQgMLo6tgSlCdlq343wZLkuDMUK5bIg/Y+xhiXorMmn7p0H/DusdvSxjBGQdF4t/vl6T3Y8PKnKcoizWucZ5MUk3JSM2n5WDYlJ+Cxah/8iDTLYCj3O8WcPqaXMuz8Zi3/N1Wz4h1TX8ogX64xrQsumHVn0YHN29b1MlfI0VXwaAjseLdxAcQM2taersvBbrveJqdDv78YDeULjqxh59qsTxEnV+L9FAfApuM2ep7j/djLrJ/GYre7Py9nSaivqClKUfJW80g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UM/OqRVKfdnk+8DUpdClNjxJr4a69tRo13nfkCjpyJA=;
 b=CZEs+EjnQu+7dwxWbDCjVec05nOucftxscXNoyXH/Z7yzX0rIVP3+F0ZSd/DN3AEgCKfZqhZDNjQO1jnRiT5qDWp5UhAbM59/yerxYp+H0/bg+7PggdMPrexT2XEdywqM08uqAFbQZWG+VGet7wNF2oD74XiNIJt4YlyCFaC8xuzsZ1Oppq37zAmesD1E3URUo0hnONVp0vkvepHxV37KqaQm3kpkrOuMu+cfrO7fAIcjbCypq7HNx1qgJNf2Qe5FLMbRoqUfqsvMUJHhdiCr43I4f+F7bSzUSmuxjnZbCVlKi2+A78fdzdhGwsrrlaxj00rjPhtquIz2dJ49GBtiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8768.namprd12.prod.outlook.com (2603:10b6:8:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 3/9] ACPI/IORT: Support CANWBS memory access flag
Date: Wed,  9 Oct 2024 13:23:09 -0300
Message-ID: <3-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db388dd-a400-4854-1759-08dce87eaf03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dBxavTGZEWWFhTt4fZj2U/UHSUU6eCVXM/1ejZwV3E91sxl3brY074ibb+R6?=
 =?us-ascii?Q?QcbeyWQs85d0seX49nEiY7rvh6bzCFSqnHVqMqeBVbNpu9xmFNcntRleNSZH?=
 =?us-ascii?Q?hUnixG9h9lDRlG2aLv1MTNyYR81v7G/Qa5hOv0b7pBLrPhqBsPDz97yd7YrX?=
 =?us-ascii?Q?dyxw0i1Ax/fejz7U/EdH34I09G8lgkaeUM9wf5dcrUXAOikmOMb3um/wFM0P?=
 =?us-ascii?Q?FHaaWrKXsPo/RqqcCBiaXzRAiWil2OPG8x0FVxXh703g/jINBC1TYrX36gex?=
 =?us-ascii?Q?/N6a/Cg2ZGi2SWa89QF7+B7hhVee8B0Kt72mNYUx7o+2B2j+W9z5ZVTdx+qW?=
 =?us-ascii?Q?ZDmZu3vubem6TJ7/+5z0DsWXTpfLvC9PbnRS/UDy+hdvDokkGScCppoV0qWD?=
 =?us-ascii?Q?T+29IACglXBwDUHtnJJiA9AWVbPp9s4y916XMNCpnKlO3q9ti7ZpmD520M30?=
 =?us-ascii?Q?3bAaue8ypNj0QcsxnjEIbWCJVJndP0XLb0QubVpeniMR1hpxse4ib86amHif?=
 =?us-ascii?Q?JBMkQI6XN+0vWKLGiz5W1iFigB1EFibyiCvn7kPbwQObiLF7BDe+qj236Vza?=
 =?us-ascii?Q?M3NbcuYazEvQ275kPuc9VkiMFT8CPTpm0eQ3veK5SgX0zcqiW9uHAanziG17?=
 =?us-ascii?Q?6aHJge4uYwYpVXfxOCKq7/C8ajpMCa3gat6t90hzW4ptoeLbTnNTXb0WWmbI?=
 =?us-ascii?Q?ErzHFelaz79yj3HPILAhxEtkt8onwKKBHpIfW2P1cP7UgTrJKGMDioYYaqCD?=
 =?us-ascii?Q?0jBa9kK2NCPrhOBtO7AzCXkpV5jrxEuuMa+DhEFo9QFGpgUthsqmRyWnmklW?=
 =?us-ascii?Q?579RyW+lknmR6AQ5C7GVLpM9GBEXACsgF3f8NmaNBCMxPtpBSH48/bBENHyh?=
 =?us-ascii?Q?ms9+Z3g33R9LBgZoYPYBRXu7fF5BbTIOQLcB9tRP63kntoELQokRQ4LBcxm3?=
 =?us-ascii?Q?v3k+9aF/WCGPg2ruFFW8rsC/5QW8RZ2XSL4YaIjeg6+/TjyQsOhjYGd3D4fh?=
 =?us-ascii?Q?2BQFukr/NeN+p4JyPmz521wrLejEy3RjfVyhqE1RBKfrZarf6x1eYCWeQetW?=
 =?us-ascii?Q?b6+DJr/BJWnlyel7fqgTXyrspToYiDeS8LF0a7dWFeBkz7g8hPhf5xNY1h59?=
 =?us-ascii?Q?F/nw8hF1FZnEjrk2yqgIzz49rg1u2XimrJrimOct4WeuPTamXIcehnrb5L+D?=
 =?us-ascii?Q?qoG/uhBPwWl7E0b6YqrVbOPKnIWZGEluzcTEMSkMYn4QlTRarZBiybe29+lT?=
 =?us-ascii?Q?bkJJEDfTdKS8FCSIuf7XyNd4wfsCI0+PXqItoKZTOekV0X9rSO2qXocCbadu?=
 =?us-ascii?Q?fXkTQgFtCkE7c5oyOVXJi9jJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4U74cZbjo6IzMCGq+vawh7UpTp/bCJR8bO3d5AV06Wvo/JeF1Zs/kJkZlR+?=
 =?us-ascii?Q?vhyOBXriYxXTNMlPCi+jXhe+knSjQtinMUFg22xwDOk4fMNkjelYULyaqpcO?=
 =?us-ascii?Q?hQSEW5gzFL6bQBZxVlYzCPd8LvIhp4DwKV6GZbx75UwObgiuenOJO0xAyAys?=
 =?us-ascii?Q?IFuqb4H6w9py5K0IYbZuLyIrzcn5IHJoE1OqF2qsud8c07MpBkiYjaj4+Zc9?=
 =?us-ascii?Q?LTX7F9vUKPVLlLmc9bVTFdVIhmmF86W1zqFtu5A2htapOqipRVbUebHJTXni?=
 =?us-ascii?Q?+xYM68ABe1Np3kShpgRq+u312vXnZiaSwL3ztjuyouYs7YCMB6bpukfI2dNc?=
 =?us-ascii?Q?b82ydKlElwvzu0duWeDmsBqPQe+KNRCPl5xpjy+Wz3xlVrUpIGeg5BU3S8tn?=
 =?us-ascii?Q?u1hDlF2ihZbwokWsq18JgG8aieL6BUdtWapc8vsjaUc5qELYBCpy9EAc/bHe?=
 =?us-ascii?Q?zKWs1YTF/ZrwDVHW0Hl1rTmjN9uDVDWK9AEeTeGrGaZ2R1/AbcHmHtH2mIIX?=
 =?us-ascii?Q?cYPilakWTagsJeAk0fKHAnU6cx/IdOe/+p1rMCMKSTT3Oxqq7ngvfu5AiQWU?=
 =?us-ascii?Q?fLiM1tl5BM8nh716AuxYPl2FSy7YOo0nGXOMo2phUKBd0bhqqIwne4GQ7EW5?=
 =?us-ascii?Q?Dw7Mi21KMVIP3Ejl5tt12Hh8dcYCrx2ZeATgBkxpZ5c3Ze+L7vLRk0ItrxWt?=
 =?us-ascii?Q?Wwzd1lotXJ1S7xGwclrNzp9deIXmfKWWglZo63TouRGlFZnUlIEBP52h5kVh?=
 =?us-ascii?Q?AOVRqcHdXuh0Y4D1h9tPce5nzcTbhuKM9tW8NMCZkPLLpScVT21XcjnKYHYZ?=
 =?us-ascii?Q?aYhaADprRj8YeaAftCwQeNM7nGdxeizyVgSfz6q7V/YxONDpZro0Rjo8ETVi?=
 =?us-ascii?Q?vadldB6ytnHJQBSaS8dQAtcznhyDtH+lUOdSFto6N9w71shxrNFle2n2h+kC?=
 =?us-ascii?Q?C4cvh7RSH9vHeGHgzaS32YncAdmM706QK56Z/01wwnFrCGdCJqMw3SBgZ6aX?=
 =?us-ascii?Q?xm+oJKf+04JclX7vWUy+LuKzBvuJoEV8dSlInPwskwFFN0bfbtbD6GidZcNj?=
 =?us-ascii?Q?iEY7pfYEOTlw9AQt/Jsk7cNEhYz67AldosvG074QDrbfYTpbZYygGCKwb2pF?=
 =?us-ascii?Q?L2XnlXLYvwdViMKzzqY7e8HqmTr/3Gh9ZhiX1sm3MsulUUqjhK1EfwkdxPyg?=
 =?us-ascii?Q?hSrPcpW4gjZSXLW2MbK8F3REyJoay2GX1+apDJOKvhvcuPC2vk25AOlvoUHi?=
 =?us-ascii?Q?KT8+SOWT1WNSFXHXZyZi1rkRxnvV0WIXVMUzSaarGTlAQ/xfMP+F1vww8v6t?=
 =?us-ascii?Q?zerdiyF8kPnsv4dwxhW+IBnjH7xsqXbepDFNSwLDGFD61M2yw+Ac+UAnKtNn?=
 =?us-ascii?Q?4p6z6/BMEmoCX0iGUUmEeb84KVx9McqTbUn5ASqPlAIsPgpBiY8hpAPEXhvV?=
 =?us-ascii?Q?QFqu+kmHXyJIqrY1oR3/2jy8Ntz3xTTLNb+DZoQ9K11y7C4jVS5XOxjDL3vP?=
 =?us-ascii?Q?xdXgx5a1nFVlXWeZIvsYxu5llbFKfvm4RowSTYky8YCpzySccVS6r6VNFxhj?=
 =?us-ascii?Q?1rlWin6j4b7+J0qfUPo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db388dd-a400-4854-1759-08dce87eaf03
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:18.1061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eB2IyEUduoIUHdtfy3J0sDL2eSaI5aNSEjtUPpS5nj7c1lmLZ5B8yocMfZCZt+87
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8768

From: Nicolin Chen <nicolinc@nvidia.com>

The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memory
Access Flag field in the Memory Access Properties table, mainly for a PCI
Root Complex.

This CANWBS defines the coherency of memory accesses to be not marked IOWB
cacheable/shareable. Its value further implies the coherency impact from a
pair of mismatched memory attributes (e.g. in a nested translation case):
  0x0: Use of mismatched memory attributes for accesses made by this
       device may lead to a loss of coherency.
  0x1: Coherency of accesses made by this device to locations in
       Conventional memory are ensured as follows, even if the memory
       attributes for the accesses presented by the device or provided by
       the SMMU are different from Inner and Outer Write-back cacheable,
       Shareable.

Note that the loss of coherency on a CANWBS-unsupported HW typically could
occur to an SMMU that doesn't implement the S2FWB feature where additional
cache flush operations would be required to prevent that from happening.

Add a new ACPI_IORT_MF_CANWBS flag and set IOMMU_FWSPEC_PCI_RC_CANWBS upon
the presence of this new flag.

CANWBS and S2FWB are similar features, in that they both guarantee the VM
can not violate coherency, however S2FWB can be bypassed by PCI No Snoop
TLPs, while CANWBS cannot. Thus CANWBS meets the requirements to set
IOMMU_CAP_ENFORCE_CACHE_COHERENCY.

Architecturally ARM has expected that VFIO would disable No Snoop through
PCI Config space, if this is done then the two would have the same
protections.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/acpi/arm64/iort.c | 13 +++++++++++++
 include/linux/iommu.h     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 4c745a26226b27..1f7e4c691d9ee3 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1218,6 +1218,17 @@ static bool iort_pci_rc_supports_ats(struct acpi_iort_node *node)
 	return pci_rc->ats_attribute & ACPI_IORT_ATS_SUPPORTED;
 }
 
+static bool iort_pci_rc_supports_canwbs(struct acpi_iort_node *node)
+{
+	struct acpi_iort_memory_access *memory_access;
+	struct acpi_iort_root_complex *pci_rc;
+
+	pci_rc = (struct acpi_iort_root_complex *)node->node_data;
+	memory_access =
+		(struct acpi_iort_memory_access *)&pci_rc->memory_properties;
+	return memory_access->memory_flags & ACPI_IORT_MF_CANWBS;
+}
+
 static int iort_iommu_xlate(struct device *dev, struct acpi_iort_node *node,
 			    u32 streamid)
 {
@@ -1335,6 +1346,8 @@ int iort_iommu_configure_id(struct device *dev, const u32 *id_in)
 		fwspec = dev_iommu_fwspec_get(dev);
 		if (fwspec && iort_pci_rc_supports_ats(node))
 			fwspec->flags |= IOMMU_FWSPEC_PCI_RC_ATS;
+		if (fwspec && iort_pci_rc_supports_canwbs(node))
+			fwspec->flags |= IOMMU_FWSPEC_PCI_RC_CANWBS;
 	} else {
 		node = iort_scan_node(ACPI_IORT_NODE_NAMED_COMPONENT,
 				      iort_match_node_callback, dev);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c88d18d2c9280d..4ad9b9ec6c9b27 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -991,6 +991,8 @@ struct iommu_fwspec {
 
 /* ATS is supported */
 #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
+/* CANWBS is supported */
+#define IOMMU_FWSPEC_PCI_RC_CANWBS		(1 << 1)
 
 /*
  * An iommu attach handle represents a relationship between an iommu domain
-- 
2.46.2


