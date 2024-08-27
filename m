Return-Path: <kvm+bounces-25179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5806C961350
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87790B2141A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE4F1C93B7;
	Tue, 27 Aug 2024 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="krpv20TY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94131CCB48;
	Tue, 27 Aug 2024 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773915; cv=fail; b=BY8ys5rTOvBs4C2ElXTszdiA5LwZsvkgxMjGByBn0eLgwVGYe7LR0BvwiCUD7U4ThoyxB8DD3CN/hDh9o5nkPNuJuWIkhkDNnolV4QnNho1kNl6WHQgLjAF370bGVSzSD/mkErAaebpgqC4lO0EAEoSp+O36IVwiyTjVFjONpQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773915; c=relaxed/simple;
	bh=PgqlLHVNEHVJK8FgPcXuidLO0Gu34Zm0662Ty00a7gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xwq0sliIn2Gq947O/XD9Jo0j8qyVs3kFeMZviHo+Zybx82Xkp6iIrpNGjhfGT4Ot/xF4X5OB0bo3Mm3PfhMLy0FPT/nzXW+3epzFx4R6ivcYzE9x5z96UjLT3sMG7+uGci+gh7a8JEZhy/2onvXnfB4nBKQ/g35H7ZsW8rMw3PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=krpv20TY; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdN8AtcsDRm9X05APSN6UMkFwaZNQ4CfEhxjfHrEfKABIA8P7biHHHkWUCm4Jv1lHD+z+c/WmzqF0ACckOhtTcrgHduYmjJS6E/+ez1AGr4mO1GzUi+9sy9TpINzj5I309fNLiQKHqlR8+xN5ABA30MLiulhBo/s2NO6OCMbgtb1qn60THW8ZdqqAu7QlNfZuYBViGJBvc4bCrXsKHdjSUmrper691R6MnKY5+gfidkwA4EFcwacxiectSDeR3VVgboXawwGTcHASvOxXeOloFWNT8Ji7HGWRN5U1t7NXv4Ggif25phc+a7DlubDhdHx96oL0+yw26Fnqlu2Hl0Xyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlZdWUBCkn77WOndyIWSIfL6m4lunTUBOtnLJ7cERdE=;
 b=lFacRkAnCzVQoZa+AaF0lr91hHMnIo+ZxID07m1HORr/pEjXPec3vsr14bNWAeT97MiIzegudyBS6CjjO41tXIbDq29XQN5hfvvWNb3G13+qvPeC7bCyMgrBkeJfsIj2lH4FOYBqL7LaqatNHgfEyadk0y6nPUxWJa9LSDvTCzojZyoe0tY1Zl3tu08n3y49cK2Je5IdfQyVPIuyo4/ftHR7SGxJcxNI+LDVQfPjyHSc4ERzqUviep9ZCXtLEZZMOvEIISIIjPrUjunOZzLYS/1enx1IIFSienWXLAIb/INtNxlB2a4ARuGJlfz3EHTsRPGRGqMbDGhx7qTfERJ7fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlZdWUBCkn77WOndyIWSIfL6m4lunTUBOtnLJ7cERdE=;
 b=krpv20TY9YMXZFY6Xn+2WGG6DBsB8YcXEYu20fcRFg5MkQHH5r6QGQ5PfH6BRL+T604wm85y+wRAtQXCXHiELr2r5JscWPrv2NPcAH3xdP7SIWmIyYxjKr9XMu8pok7Fn2u8f53F3p2k45BReaeSBztsgRK7MdJ4fuFwXS32yXQkXWXHXF8mk/qqZPDNkuV5q99UWDhLSx8yicncyFvylAcMB5Bauw1iDdLaTLN57wH+JCz8dq6p/ZzStdMZbIsY2N5yFvpM+LohAkBmUmeqnNXos+T959iZVEy7Gn0zAuIEJz55+Mes42MxHUNjf+Pm1Abkdilh1unyFpezCLXlWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:42 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Date: Tue, 27 Aug 2024 12:51:38 -0300
Message-ID: <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c8b1d6-025c-4c95-a653-08dcc6b023e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6rVAzpnN/pQb2SymQqgPrF457P9vQCquKzLF+/gR95OX3qoKER0pcblKH00X?=
 =?us-ascii?Q?LF5oDATPwjyu27YmyQDiqVKoK+2DesQ2N8QIu5tqFbVyqPrv7YYPyNxz+9JZ?=
 =?us-ascii?Q?xpGXF4bHJckBrzAAzU/nsE6RgKvYyUkIL/nYkdjUTdk85RbGBp7q0Se4LG2j?=
 =?us-ascii?Q?pLxgDAmKBW6kvYGulPU8jPjN1n09KlOxMAqkAc12zfxSb5MOO9ld3WccjIQe?=
 =?us-ascii?Q?O06hriVRcBb99FszXWZ8f0Ygp/xNl5oIgYuIWXfWSUy1Wa9wbNeDB/SnoerK?=
 =?us-ascii?Q?D9ffARQvm8H5oKOsnp+3Jrzcgxya7OAyddb55DW4o0AuaGM4RdXFzEHhSAZw?=
 =?us-ascii?Q?cpeToEfYTBcPEwfvY2fBH6TyusDlybUIMLpZcJ7RWLGr3j7wV5z4Wuw+2rr+?=
 =?us-ascii?Q?dy88dSVW+eFy8zIKcekYrx3q9PhTqoq4kXxVkTxvqlsrPpeVxBNkiul66rWm?=
 =?us-ascii?Q?ruYDewkAGwIpNw+KAKOYUsm/NmUdL1wlV+bspAiCDEEbw5oXaeRGnZ0isr4n?=
 =?us-ascii?Q?9C+medxzQlsScf2lUgWmdPcWBRrdzWmFSSP9v/05ZmLljTOVzfXDm0u8Zzk8?=
 =?us-ascii?Q?ZCB0A41gBDL9kDfEzSFwkk87joXZNqw78xSiUoop3ltpofBsnmfrDRXCX6Wi?=
 =?us-ascii?Q?1tJ+jmSbM8uzChQSM5c0Ug2SeUr7Lg1PwRnUQgQ+2kTMACcrYeQ6BVhcXryT?=
 =?us-ascii?Q?yiz00+lZXTI8rI06nWsZm8e5wTNytDRP6uNtqwB4navBVJtJdUIbuKA2jSIG?=
 =?us-ascii?Q?o/LcSTX8+w1tzxHLbTe20AcB/Kd049eXmd0y1KuWPq/ZXQBHBDCNV6RXHAwb?=
 =?us-ascii?Q?pDpLPi0uXorAXDm70f7x+7adlrFudQ66pmxYfGbdI2L5AsEj5r1ZJh5HcST6?=
 =?us-ascii?Q?VUm8O22LPV9MQb+DOeB46AC6jflir5sygVgqS6b2Rj40PwRmRbYtWC/wNFtS?=
 =?us-ascii?Q?1KZLbb2viEeYUBfisL/h18AwnPwQeRT0Fq+Jb/Qkr4eOkEdXhLGCUvGi9QFY?=
 =?us-ascii?Q?xMhu8x37026EWtYLYVnmFQ+v4vwZ0YujuJGlQrA5iV/yfZ0sWAovbeVyspPj?=
 =?us-ascii?Q?eBG8ci+xUVE6mQSum1GM/fGQYGMuzv4KTJsFgbxjCy+34LJkGHd9Mld0JKL5?=
 =?us-ascii?Q?MJlHTj/ZLaJ6bnF7LwzrWYoowoI5CYgwD4SiSprThhBIWu4gXY/nNrZXYeuk?=
 =?us-ascii?Q?uXdgLRVQ3iUsl1tdpTWArNfbyy5viCOMfDOeOL8evN6LVDPPidOJVi0483x6?=
 =?us-ascii?Q?k9D9OQf8OWum90E8fAkU/MzRjyMCrkEI4Yen6tMULbnTgyxQjziA2TPCmTo6?=
 =?us-ascii?Q?+tOzqEYZYQFDtYrdyngjkQBixCcjCze8WitM19+PSO+H4Qwm6E1UUZVYt0/B?=
 =?us-ascii?Q?F+1pMu7GWEKExF4PNHmFl6tUlTr/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ylBqYfAEv4lDm5op0wGAAJIhZ2Ml2QMzr5v6GVKniJrQ3qxaylihfQggzJuc?=
 =?us-ascii?Q?bw490u4kpeHijYGbbpa4YYJMdionsBFU8xIuNs5ZSao7sN25wScueOIPXyRK?=
 =?us-ascii?Q?BERGqzCHtqLKangbUN5NZXVFMzghMooI7UTp/I6WO4YQR+k7d3ZBZhcikFGc?=
 =?us-ascii?Q?diNkfdkFEpZ/hnkwDQ2NA4/BIdzilmt3RcVGhNkCXCT1G6YbijgO9M6AtUh8?=
 =?us-ascii?Q?V303I3Qvw61Oo/C7oTq18Ir+7F9bxr/FJ/jR66dXrPkVf4bTxCChwL/NoSWr?=
 =?us-ascii?Q?Jhu6gfmAvHQwdZ3CBtbcr/GmM6s2AGBOHhh8VsXShzwfP71+JaLgQFQlLi9n?=
 =?us-ascii?Q?dYdTwdA6pVEGcADk5RWBReWmWuhSpknk9OtS6uYklwxLuNJbd6CU46B7LCvs?=
 =?us-ascii?Q?6wZ1txrCmjTEzU+wV3kYkLpgsiUjosxsSYrQfiarVgES2pH9x/V8L5oyg7uA?=
 =?us-ascii?Q?vQWJcNnHlxngp7cA0hOA36mnxRDNFg6zDHNkEIrfwB+LUWzfH2kxsBRPIx37?=
 =?us-ascii?Q?k1GALZ6CfsebpdBd2zPHGLaGspiA2icH1gzxPak+nx0M2QeKvYCMTBuodi52?=
 =?us-ascii?Q?FGGPgj9qbxXg6POFTybKmifceixzilVGbYerF25yWcutAsvbtBuTMtqJHXKg?=
 =?us-ascii?Q?w8L0mRUnvWgpTbOZdC8sVec0LKqduKlaw7jBz4YJSjoxTQP3pl+tCgMoSZtm?=
 =?us-ascii?Q?WuOURwMiEMfs7Xii5ltbfQvbXFuNw6zFnaETDHQE2JHEy2lYV0pp609Ox3fr?=
 =?us-ascii?Q?jPk25tc02Sh9C1PD9o5Et5igNRI4cctm6gsKwRTv5veqZQPNAoFdNe15yffu?=
 =?us-ascii?Q?J/iYADNAgiJMsgoiBXIz9VncoNcMdWzw1pgheLHmCIT3ZKoFwo4J25+FeUQk?=
 =?us-ascii?Q?tVku8ZSIEepKowoFbfU/1s7sAT9Fuas8A4CfYSv+PO1tBhLbD/b5ThUkw6xw?=
 =?us-ascii?Q?9fSJAJSUPyaeydP6WnGHITjLhLddmlF5kqY6QjHBMa75n5cu8b01qqF6VjwT?=
 =?us-ascii?Q?P8pNngOblkYItrC3U6815D/C5wWqijCGYMkzLlwWZZqGdP86KvUkqKZRC6oC?=
 =?us-ascii?Q?rkC51pfnWpbeNKXp8xE29WMy08NCYFbOm/qFm5e24pa0v48pW+7tNSSjm7qt?=
 =?us-ascii?Q?k6fSvRqjm+J3fdEsgilmcWMGQzGb8eDFX5AafUe6/vXJ8OuELp1KvrHVU0uT?=
 =?us-ascii?Q?MaUdF7uKhlr/MvpoMh8A6Fk5CnNM9/xv7iGa3WYXc61yctN4db4FQsTfsAg3?=
 =?us-ascii?Q?8W5RUtFXvdG3zbZxMjyLjC9IhpgBMlVLt3I7j/NGt1zPcg+QCu1uKXbl6m6Z?=
 =?us-ascii?Q?wOsxyt2ejZF0Viri28GoEFLCAp+uT5qOLPvO/090kmo1m9lNKtSLUcYy4Pp4?=
 =?us-ascii?Q?ED5KEuRThqNtv93bwc8CnA5SMwZONssRAcOi9xZvndMyeeM54jeZyaMUhAHc?=
 =?us-ascii?Q?WVybCH6Br4V250PdknVop8Yg0Dp1fLm9nfBupPX6LiZzRA89SH3ksrmqmVJ4?=
 =?us-ascii?Q?2W2y2mBIhxMoQtSkbyYJ+VTd4ouf4PmeeepIFgTc2WHxC2gFVxr4+jASW0DB?=
 =?us-ascii?Q?LOf+HLS4mDQKHpsQXa8z1l435FjX+dRLAiyNgXW6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c8b1d6-025c-4c95-a653-08dcc6b023e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:40.2017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9x3ObFE5O/tpS9vmmiX+N9Ln2QcIb4YkP2QK36Qvlj0Cbt3MiaqaYquwUjXw+Yu5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
as the parent and a user provided STE fragment that defines the CD table
and related data with addresses translated by the S2 iommu_domain.

The kernel only permits userspace to control certain allowed bits of the
STE that are safe for user/guest control.

IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
translation, but there is no way of knowing which S1 entries refer to a
range of S2.

For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
flush all ASIDs from the VMID after flushing the S2 on any change to the
S2.

Similarly we have to flush the entire ATC if the S2 is changed.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 217 +++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  20 ++
 include/uapi/linux/iommufd.h                |  20 ++
 3 files changed, 250 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8db3db6328f8b7..a21dce1f25cb95 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	case CMDQ_OP_TLBI_NH_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_S12_VMALL:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		break;
@@ -1640,6 +1641,59 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
 
+static void arm_smmu_make_nested_cd_table_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	arm_smmu_make_s2_domain_ste(target, master, nested_domain->s2_parent,
+				    ats_enabled);
+
+	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
+				      FIELD_PREP(STRTAB_STE_0_CFG,
+						 STRTAB_STE_0_CFG_NESTED)) |
+			  (nested_domain->ste[0] & ~STRTAB_STE_0_CFG);
+	target->data[1] |= nested_domain->ste[1];
+}
+
+/*
+ * Create a physical STE from the virtual STE that userspace provided when it
+ * created the nested domain. Using the vSTE userspace can request:
+ * - Non-valid STE
+ * - Abort STE
+ * - Bypass STE (install the S2, no CD table)
+ * - CD table STE (install the S2 and the userspace CD table)
+ */
+static void arm_smmu_make_nested_domain_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	/*
+	 * Userspace can request a non-valid STE through the nesting interface.
+	 * We relay that into an abort physical STE with the intention that
+	 * C_BAD_STE for this SID can be generated to userspace.
+	 */
+	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
+		arm_smmu_make_abort_ste(target);
+		return;
+	}
+
+	switch (FIELD_GET(STRTAB_STE_0_CFG,
+			  le64_to_cpu(nested_domain->ste[0]))) {
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
+						  ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_BYPASS:
+		arm_smmu_make_s2_domain_ste(
+			target, master, nested_domain->s2_parent, ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_ABORT:
+	default:
+		arm_smmu_make_abort_ste(target);
+		break;
+	}
+}
+
 /*
  * This can safely directly manipulate the STE memory without a sync sequence
  * because the STE table has not been installed in the SMMU yet.
@@ -2065,7 +2119,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 		if (!master->ats_enabled)
 			continue;
 
-		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
+		if (master_domain->nest_parent) {
+			/*
+			 * If a S2 used as a nesting parent is changed we have
+			 * no option but to completely flush the ATC.
+			 */
+			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+		} else {
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+		}
 
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
@@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	}
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
+	    smmu_domain->nest_parent) {
+		/*
+		 * When the S2 domain changes all the nested S1 ASIDs have to be
+		 * flushed too.
+		 */
+		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
+	}
+
 	/*
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
@@ -2604,8 +2677,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master,
-			    ioasid_t ssid)
+			    struct arm_smmu_master *master, ioasid_t ssid,
+			    bool nest_parent)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2614,7 +2687,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
 		if (master_domain->master == master &&
-		    master_domain->ssid == ssid)
+		    master_domain->ssid == ssid &&
+		    master_domain->nest_parent == nest_parent)
 			return master_domain;
 	}
 	return NULL;
@@ -2634,6 +2708,9 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
 	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return container_of(domain, struct arm_smmu_nested_domain,
+				    domain)->s2_parent;
 	return NULL;
 }
 
@@ -2649,7 +2726,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
+	master_domain = arm_smmu_find_master_domain(
+		smmu_domain, master, ssid, domain->type == IOMMU_DOMAIN_NESTED);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2664,6 +2742,7 @@ struct arm_smmu_attach_state {
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
 	bool cd_needs_ats;
+	bool disable_ats;
 	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
@@ -2716,7 +2795,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * enabled if we have arm_smmu_domain, those always have page
 		 * tables.
 		 */
-		state->ats_enabled = arm_smmu_ats_supported(master);
+		state->ats_enabled = !state->disable_ats &&
+				     arm_smmu_ats_supported(master);
 	}
 
 	if (smmu_domain) {
@@ -2725,6 +2805,8 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			return -ENOMEM;
 		master_domain->master = master;
 		master_domain->ssid = state->ssid;
+		master_domain->nest_parent = new_domain->type ==
+					       IOMMU_DOMAIN_NESTED;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -3097,6 +3179,122 @@ static struct iommu_domain arm_smmu_blocked_domain = {
 	.ops = &arm_smmu_blocked_ops,
 };
 
+static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct arm_smmu_nested_domain *nested_domain =
+		container_of(domain, struct arm_smmu_nested_domain, domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
+		/* Currently invalidation of ATC is not supported */
+		.disable_ats = true,
+	};
+	struct arm_smmu_ste ste;
+	int ret;
+
+	if (arm_smmu_ssids_in_use(&master->cd_table) ||
+	    nested_domain->s2_parent->smmu != master->smmu)
+		return -EINVAL;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
+
+	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					state.ats_enabled);
+	arm_smmu_install_ste_for_dev(master, &ste);
+	arm_smmu_attach_commit(&state);
+	mutex_unlock(&arm_smmu_asid_lock);
+	return 0;
+}
+
+static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
+{
+	kfree(container_of(domain, struct arm_smmu_nested_domain, domain));
+}
+
+static const struct iommu_domain_ops arm_smmu_nested_ops = {
+	.attach_dev = arm_smmu_attach_dev_nested,
+	.free = arm_smmu_domain_nested_free,
+};
+
+static struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	struct arm_smmu_nested_domain *nested_domain;
+	struct arm_smmu_domain *smmu_parent;
+	struct iommu_hwpt_arm_smmuv3 arg;
+	unsigned int eats;
+	unsigned int cfg;
+	int ret;
+
+	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance.
+	 */
+	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
+	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	ret = iommu_copy_struct_from_user(&arg, user_data,
+					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_TRANS_S1))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
+		return ERR_PTR(-EINVAL);
+
+	smmu_parent = to_smmu_domain(parent);
+	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||
+	    smmu_parent->smmu != master->smmu)
+		return ERR_PTR(-EINVAL);
+
+	/* EIO is reserved for invalid STE data. */
+	if ((arg.ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
+	    (arg.ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
+		return ERR_PTR(-EIO);
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg.ste[0]));
+	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
+	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		return ERR_PTR(-EIO);
+
+	eats = FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(arg.ste[1]));
+	if (eats != STRTAB_STE_1_EATS_ABT)
+		return ERR_PTR(-EIO);
+
+	if (cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		eats = STRTAB_STE_1_EATS_ABT;
+
+	nested_domain = kzalloc(sizeof(*nested_domain), GFP_KERNEL_ACCOUNT);
+	if (!nested_domain)
+		return ERR_PTR(-ENOMEM);
+
+	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
+	nested_domain->domain.ops = &arm_smmu_nested_ops;
+	nested_domain->s2_parent = smmu_parent;
+	nested_domain->ste[0] = arg.ste[0];
+	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
+
+	return &nested_domain->domain;
+}
+
 static struct iommu_domain *
 arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   struct iommu_domain *parent,
@@ -3108,9 +3306,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
+	if (parent)
+		return arm_smmu_domain_alloc_nesting(dev, flags, parent,
+						     user_data);
+
 	if (flags & ~PAGING_FLAGS)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent || user_data)
+	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -3123,6 +3325,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			goto err_free;
 		}
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+		smmu_domain->nest_parent = true;
 	}
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4b05c81b181a82..b563cfedf22e91 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -240,6 +240,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -291,6 +292,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 
 #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
 
+/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
+#define STRTAB_STE_0_NESTING_ALLOWED                                         \
+	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
+		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
+#define STRTAB_STE_1_NESTING_ALLOWED                            \
+	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
+		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
+		    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_EATS)
+
 /*
  * Context descriptors.
  *
@@ -508,6 +518,7 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
+		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
@@ -790,10 +801,18 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
+	bool				nest_parent : 1;
 
 	struct mmu_notifier		mmu_notifier;
 };
 
+struct arm_smmu_nested_domain {
+	struct iommu_domain domain;
+	struct arm_smmu_domain *s2_parent;
+
+	__le64 ste[2];
+};
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
@@ -830,6 +849,7 @@ struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
 	ioasid_t ssid;
+	u8 nest_parent;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 83b6e1cd338d8f..76e9ad6c9403af 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -394,14 +394,34 @@ struct iommu_hwpt_vtd_s1 {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
+ *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
+ *
+ * @ste: The first two double words of the user space Stream Table Entry for
+ *       a user stage-1 Context Descriptor Table. Must be little-endian.
+ *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
+ *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
+ *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
+ *
+ * -EIO will be returned if @ste is not legal or contains any non-allowed field.
+ * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
+ * nested domain will translate the same as the nesting parent.
+ */
+struct iommu_hwpt_arm_smmuv3 {
+	__aligned_le64 ste[2];
+};
+
 /**
  * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
  * @IOMMU_HWPT_DATA_NONE: no data
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
+ * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
  */
 enum iommu_hwpt_data_type {
 	IOMMU_HWPT_DATA_NONE = 0,
 	IOMMU_HWPT_DATA_VTD_S1 = 1,
+	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.46.0


