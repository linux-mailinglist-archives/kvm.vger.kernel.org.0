Return-Path: <kvm+bounces-28280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A22997176
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6A011C22B1B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B391E2316;
	Wed,  9 Oct 2024 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U/wQ7FC4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6411E2039;
	Wed,  9 Oct 2024 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491014; cv=fail; b=H0hTy75ui7Pty2MHEF9VMZ+gecozTwDEiAIwvKH3VSj7fDRe6AnGLHLZ2dEhA6eay4Jvvhf84wKqx671W4MmfQIk90VV6LkDY/mbUiLe8hbjnzeuZBgTLd0il3DgxQZdy1vn1wuv4OmoGuSB/3K1ddkq+Dp6DcoBBsgCNLwZCCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491014; c=relaxed/simple;
	bh=/dNsMUgLCXStd/1eTrKLB0hnuAZyLKP2B18hk7Hldog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sTFVU5VEQGawttewuwn3FE8v+mHO4/3yBUKdex9E4fD6jTyZQWqF2XDbLI65ugS7pOoPxpSvn0gV+HrK+ApqJCx5XsXOrjXByTlLLweVOkZpqUW5D8we97WDazS67NlH5Ui2cWBVZPHFIoW+LtKzfXaPPGVlLbGMCdS8XG1WydY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U/wQ7FC4; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ka6wwIphiA3Ys62J9UgRWyPAqWU3MpD7JKXVAjrZBMzORGaV3M1j8HfgtE5SwY+sanhbC2UW8JOKtuGqnzBELmgQrNt8ryiE9CSWbY3t41XawfHCDVwx7cnGITxU7DH/+DKIoKQcgukr928GDaAS0Ms07nvMQCtzncDxAfoOD0FaBBUv4WisC32/pXPQUevCYo+Ewa717r+izlQCJp9W8jJRI8oPB6CUPryuE/ElKbvcf66LEModRLjSWpfjiG0cLJ+ze/W6LRo7jQdIEy7NLWijVrHWA9OGWQRmLM6I9Ul74WW244YCB7gZO0jDXR63+1vzNYChXPTDGmHLbm8/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98Ksrj+miS0+Ca6vrt/OMLd71nk6UKW0sXWR7yptuXw=;
 b=Q3Zvr4IccUXcY7N+3AMNFaGi2qf3Mt2HgN8sb4xk4JgQ0S3uOHJoHWZ65sAad55EqSuv8J6BL6o2pOZmlGPQGFi7x4+ct/CGPoRxfhCTiDKo1cQmBmVSITSoazM01zTDdaXeCGtC/Xz/WwPDj3FVrgwdntQbpCdTL7CEAnUW4EiapnrpxW9JXfmtv6BU/b1w+hslc/lpcIyO6OUkL7J01WmeTYZi0WgAyC2BFcS+SHf3CN3ob6hak3D69WW61mFrHiJ8GAVN2v+eFNnlTXUvXl3ePYxP1UpiOxWqvaIaAe/O8J+ZinJMg/SS0CLPav3p6lNDNTWZe9Dxw2dbu0db+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98Ksrj+miS0+Ca6vrt/OMLd71nk6UKW0sXWR7yptuXw=;
 b=U/wQ7FC4cXPvEdRQhijiyS6FPoU0E7MC/kiIyIR18+iVZlaD5AjJriIvgoRf/wn282AF97MTYc9I+xF0nkBnFpJJqqkhPzknfZEbb+oW8KuLwyimKeWKdKtfdfgvPhL8uZcU4aC5vTViRr06GgOAUGirMjtgI52K+xkkMR7fBIyifpQofoF9U4SseUYgmQMXsG/8wRtbifxl1aVUfQ6Ui+oBcGIpdF1evllouUFSAKVK3WbYD1YjG576+I1B2nKN/IBr4+uDHfBiaJxhIlUiAYde0Tz8uSBxfll/HDUrDaY2Vm4uv3+6FcSCgoNtU6KQa82aSGMKNAavMXY5UYvtvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:21 +0000
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
Subject: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Date: Wed,  9 Oct 2024 13:23:15 -0300
Message-ID: <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0001.prod.exchangelabs.com
 (2603:10b6:207:18::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c64ad2d-be5a-4ee8-f850-08dce87eaeca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VdkkOrmGfwVfmnhDvvP7rBfFzp+VhgC+RjKVN10n2yN7t0qn2HHHAetHXqLT?=
 =?us-ascii?Q?BJCx0qacYa2p7yreh0c/iFfUh60fTME76/yCfyUSotqDaf2vPGd+Rm7gVH8Y?=
 =?us-ascii?Q?Qu+CuIekkHMXpDC4zXcwsg774mOvnWIwU8eL4PwCtxroLRrPeEzKckBMUInu?=
 =?us-ascii?Q?c4FNtluSk/jQ+cpAZ4CCP2uhM8ykUDafF8oyFcEhFU61T5DkIJKSfmGtVLRu?=
 =?us-ascii?Q?bTfncune4XF0ldNRNn5o4eDreBarJeMrHXpySWJsTHkv5N2LCCwas/ZEP//G?=
 =?us-ascii?Q?aL4trDEC8EnYL+axklnZxHFs9NnUf9DTncp17YFxisYD9f+7h1s4MoO0zsnY?=
 =?us-ascii?Q?eEjbRxGoBmEQiaVXvlXx/Lwh2MfJqbNYQbht4RdURetAmfr712daFxkLDJal?=
 =?us-ascii?Q?DFg/G0BDPAvi0LKCgTkxEueOHArxy6K4oHeAWLgpN1XpqKBvIvLHocaPtIET?=
 =?us-ascii?Q?2j4jRZKSMLarxORmUfRNOaeXQKWVbZ3b9DXahaPqk3Uuzc7dxSAQ74WcLH01?=
 =?us-ascii?Q?GhZrjJm9vgLThsE17sJ94BJAzNvLA6myru3sdvTWWk3mLHQoE31PgFCGSmfI?=
 =?us-ascii?Q?U7CLuX03njx/Aos8dUeyxJv8bAZAkq2G2p6NsaYqQV+Q2vxpR60sF1YZrnZQ?=
 =?us-ascii?Q?5jDGhtgFBuom0i+0EUH+MeWHUuTPEqAqJ1YbxtkWDZDWtjkFMAAfk7nSMlUQ?=
 =?us-ascii?Q?mpPGcqaoi9r6YvAc5M6zjIMVuu4q3x3HjJa2HRv/WQPr556TTvV7Vp4MuqVe?=
 =?us-ascii?Q?6L2rb99S6OvuzlpJJTV/opu6YmBMKWqtexOARbZzrpXmHb+X/g7GMqIrAE3I?=
 =?us-ascii?Q?JHn4Z1XBcsn3avttybQx8WSU9F9YIULNEeZ4uJhQrmURYBc/bY4MX+XnIuyy?=
 =?us-ascii?Q?pSf23eV4WdhWxVMCxj8GRLYjiVisV0WzAmXGo69e9C59XhO2+YY1zbGaRada?=
 =?us-ascii?Q?nVXnVbmMypDEdS8k1i9HJqztGWHJ63LVxT5DznvXcCqDek0cb5LIoA++tvMJ?=
 =?us-ascii?Q?L5o6qYXCLGQ9NI6HCJ2IQ7zrG4cqWQ/p/sG5BoZXyJ3tcWVvbDW2j0T7BChb?=
 =?us-ascii?Q?CArPwzZPEBkqp7uJtOdcxlqNgFG9K6ZB8WiyY7KBMqv9X576IRxhQQ97jjU2?=
 =?us-ascii?Q?qWTLo5We2f4jB+u0duIgfJYsSxwVhO0Y9gj0ysPLjhCW4+1nqMvQYLCy9+FE?=
 =?us-ascii?Q?oZMUwoy8TzusdqL0WNwuBTKIuQggfe5CCxTF2wsBpbwyh+1hXxlizKLLW/vz?=
 =?us-ascii?Q?FOY3CQol/qOjaJ/gWXJ5AXlzJA9AsJIwFETEVqtSy4RSliV0+rz4vVjXRCpD?=
 =?us-ascii?Q?TtSkwnA7M0nStPQsy0yBgtyn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ekv1FHkdWzsQq6b9CZx+ELZeTbejWoF5A+rH1w8Hf+Dhs2h6H0uFUIUL7bGh?=
 =?us-ascii?Q?xTfbNPGnP5UEun5GwN7HZ7iC7KOC1PoDshj9WOtAR3oj6zzPTWXVw95ZJBV1?=
 =?us-ascii?Q?SLqUoORu4sjfF+3GcvH24i0b25XtDaVinoahr8P2cCifJp2o4QSk+dzW7FX4?=
 =?us-ascii?Q?EEco+5EAoPGyQPBSVVmQuGjpR53A67KxFSjouBgnguRsKsOw3iPYw3EBUnkl?=
 =?us-ascii?Q?ZehVoyoGxYBNZTTZxuB2H0aNGKgG8NvGQfXruRKu5EOrgDythVx/tNQvuF5g?=
 =?us-ascii?Q?P1w/EbBUOr4rPBhXyO3g1TjyL2zCFKKUUcL5IOcUzggClVEz/eA5jAvzBypk?=
 =?us-ascii?Q?CBImncM7f20RcpfoJPrSvZusRYSSDefhuKeNmLskSQzEMpACYkE2ZWblGWxM?=
 =?us-ascii?Q?Lx2kpiEQ0Vrq7wO0QNrzI14IhoLKD/fX0/4Wym/aBtpibPZZpyKIgp7BRMdZ?=
 =?us-ascii?Q?uAGoYFoFCN+2p7vkMq536jEph1/pu1iUsQsHtcte04e+B48LJm5pTNYdrxaH?=
 =?us-ascii?Q?tPcojnvHEiozhQgulseh9z88uYOQcTb3cPl0wVniPSZeQKuqJkv+71Ih1nbA?=
 =?us-ascii?Q?2ntoEWBzGJT8iLs0SN/elJ7HnDgV4Ef0oSh7W9vTJILn+Je5DxyHLuTpPAel?=
 =?us-ascii?Q?e1swmkszFOcVwthGi16YPM0nyZdjrAexFZVyRAmwQP+NnABTs50Yl9D05X+6?=
 =?us-ascii?Q?+Fp5/zJ8V9iB6U22zlxK7PjCNok3yVhQkC/Tzn3brSBgI5tiX9hN3YzB5oQ+?=
 =?us-ascii?Q?sgqBna2G7A6dRZ5CNylemseaTXfgFe4f1fRZc6nkmFDXdbEevVlR4w5QE2oS?=
 =?us-ascii?Q?3dwwcNY41j07PVTEvHwgyYkr/szdedV7EL7LaZVDZMqmvnLqxppq2I2pCClE?=
 =?us-ascii?Q?zaejlXpHn9XGcJksIiKa3aXn+5s53K2ht5Ws5GCe5Y0G9cYbqkZOV1c5gv9d?=
 =?us-ascii?Q?qry6W2q3jd07on5mTutXvSEyPuXjt+hd/pVCQ2Oixzn54zlgQiaI74sHZCPv?=
 =?us-ascii?Q?6MbRDLHNQKy+mKrxwY9Kn4whaLbDK3n6uWFWy72MEsv8sm3X6uom/dhhEpxX?=
 =?us-ascii?Q?L+gDqq+pCvQKi430M8Nwh1rKHRqzkvETa7tGYw77UJhYbn5wwDqbQoh92YrM?=
 =?us-ascii?Q?HbkIXBm6KCsfS5/vAvMCXmElQu6ewPd0QU+wxCFl6oJuobtrpCaXlJ8zjt9p?=
 =?us-ascii?Q?ETd1ByVhe+WNw21uOp+lbGJmblyrt+4LP63lgygo0I5dLvW7PWdaiOUQWRRW?=
 =?us-ascii?Q?YUF63kWlNd3HF/oc0Pob72bRbDwi33u2nvth00bi2aZnS82NHo35fEvz3dqS?=
 =?us-ascii?Q?6Xbo3amZk3TUJkQY4VYdu1cy56y9h5ohHrAvmt7qk7HuwYoPiNcZtQFSqRAr?=
 =?us-ascii?Q?y/D4DhVhoJqKc1dGEzFpYRuQSeaSHkAkek0ReTKj4AWUbCpASzzfx3krk0NG?=
 =?us-ascii?Q?awiSbbAmzlRTJVspcRaudAejuo3lLkGbI2G068bG8KRiXxp6UP6VW6ltAspc?=
 =?us-ascii?Q?HwpuMI0GAFyG3hvZ5GzUXEuWSiII4fAuwjhddU6ZrrbZ4qFeoICag/6hv6Jd?=
 =?us-ascii?Q?EuGO7ttZm+Jtk3ScyhQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c64ad2d-be5a-4ee8-f850-08dce87eaeca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:17.7355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sJ1UY3SBdRpCS4getabSeHkZ0Mjdi5CZnZK2tlfUeY+lPMl05rOitlM8DVJQeBR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
works. When S2FWB is supported and enabled the IOPTE will force cachable
access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
access otherwise.

When using a single stage of translation, a simple S2 domain, it doesn't
change things for PCI devices as it is just a different encoding for the
existing mapping of the IOMMU protection flags to cachability attributes.
For non-PCI it also changes the combining rules when incoming transactions
have inconsistent attributes.

However, when used with a nested S1, FWB has the effect of preventing the
guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
bypass the cache. Consistent with KVM we wish to deny the guest the
ability to become incoherent with cached memory the hypervisor believes is
cachable so we don't have to flush it.

Allow NESTED domains to be created if the SMMU has S2FWB support and use
S2FWB for NESTING_PARENTS. This is an additional option to CANWBS.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  8 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 +++
 drivers/iommu/io-pgtable-arm.c                | 27 ++++++++++++++-----
 include/linux/io-pgtable.h                    |  2 ++
 5 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index a9aa7514e65ce4..44e1b9bef850d9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -169,7 +169,8 @@ arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
 	 * Must support some way to prevent the VM from bypassing the cache
 	 * because VFIO currently does not do any cache maintenance.
 	 */
-	if (!arm_smmu_master_canwbs(master))
+	if (!arm_smmu_master_canwbs(master) &&
+	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index eb401a4adfedc8..4e559e02514983 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1046,7 +1046,8 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 	/* S2 translates */
 	if (cfg & BIT(1)) {
 		used_bits[1] |=
-			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+			cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EATS |
+				    STRTAB_STE_1_SHCFG);
 		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
@@ -1654,6 +1655,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							  STRTAB_STE_1_SHCFG_INCOMING));
@@ -2472,6 +2475,9 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		pgtbl_cfg.oas = smmu->oas;
 		fmt = ARM_64_LPAE_S2;
 		finalise_stage_fn = arm_smmu_domain_finalise_s2;
+		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
+		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
+			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b5dbf5acbfc4db..e394943c0b4bfe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -57,6 +57,7 @@ struct arm_smmu_device;
 #define IDR1_SIDSIZE			GENMASK(5, 0)
 
 #define ARM_SMMU_IDR3			0xc
+#define IDR3_FWB			(1 << 8)
 #define IDR3_RIL			(1 << 10)
 
 #define ARM_SMMU_IDR5			0x14
@@ -265,6 +266,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
 
 #define STRTAB_STE_1_S1STALLD		(1UL << 27)
+#define STRTAB_STE_1_S2FWB		(1UL << 25)
 
 #define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
 #define STRTAB_STE_1_EATS_ABT		0UL
@@ -739,6 +741,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
 #define ARM_SMMU_FEAT_HA		(1 << 21)
 #define ARM_SMMU_FEAT_HD		(1 << 22)
+#define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 0e67f1721a3d98..74f58c6ac30cbd 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -106,6 +106,18 @@
 #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
 #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
 #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
+/*
+ * For !FWB these code to:
+ *  1111 = Normal outer write back cachable / Inner Write Back Cachable
+ *         Permit S1 to override
+ *  0101 = Normal Non-cachable / Inner Non-cachable
+ *  0001 = Device / Device-nGnRE
+ * For S2FWB these code:
+ *  0110 Force Normal Write Back
+ *  0101 Normal* is forced Normal-NC, Device unchanged
+ *  0001 Force Device-nGnRE
+ */
+#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
 #define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
 #define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
 #define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
@@ -458,12 +470,16 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
 	 */
 	if (data->iop.fmt == ARM_64_LPAE_S2 ||
 	    data->iop.fmt == ARM_32_LPAE_S2) {
-		if (prot & IOMMU_MMIO)
+		if (prot & IOMMU_MMIO) {
 			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
-		else if (prot & IOMMU_CACHE)
-			pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
-		else
+		} else if (prot & IOMMU_CACHE) {
+			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
+			else
+				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
+		} else {
 			pte |= ARM_LPAE_PTE_MEMATTR_NC;
+		}
 	} else {
 		if (prot & IOMMU_MMIO)
 			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
@@ -1035,8 +1051,7 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	struct arm_lpae_io_pgtable *data;
 	typeof(&cfg->arm_lpae_s2_cfg.vtcr) vtcr = &cfg->arm_lpae_s2_cfg.vtcr;
 
-	/* The NS quirk doesn't apply at stage 2 */
-	if (cfg->quirks)
+	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_S2FWB))
 		return NULL;
 
 	data = arm_lpae_alloc_pgtable(cfg);
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index b1ecfc3cd5bcc0..ce86b09ae80f18 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -87,6 +87,7 @@ struct io_pgtable_cfg {
 	 *	attributes set in the TCR for a non-coherent page-table walker.
 	 *
 	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking in stage 1 pagetable.
+	 * IO_PGTABLE_QUIRK_ARM_S2FWB: Use the FWB format for the MemAttrs bits
 	 */
 	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
 	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
@@ -95,6 +96,7 @@ struct io_pgtable_cfg {
 	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
 	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
 	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
+	#define IO_PGTABLE_QUIRK_ARM_S2FWB		BIT(8)
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
-- 
2.46.2


