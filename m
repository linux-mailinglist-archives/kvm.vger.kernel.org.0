Return-Path: <kvm+bounces-23457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 273C0949C73
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:42:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1F99282E6F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4EB917A588;
	Tue,  6 Aug 2024 23:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r5p4OlWa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C5179201;
	Tue,  6 Aug 2024 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987698; cv=fail; b=uc9fBwrWSgp488eicxu+vcvYcM4oYfkLEoFzX0UlScX7MFfguHtDH8BDGi4m1eDxWFPKmByXlD1w/4ChpvGtJ+v5YvgKJjIi+40abWHPpBjsK3I9+XVN5JaKO2E9Rnxo/UOvhXvzhu3GgLvc78dCifDkn3nA1AJx8REegG1hV50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987698; c=relaxed/simple;
	bh=0d9uZkgbdQVjBy1SxqKQCesWboPdjCu32/SD9ehWXNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WzqhWLmjq1v6fgmUP63X386NGCZ94B67Ih90Y1HDasF41NC6m2dTNhLzvyCU23wwT0rZJqioWHsCXFBHEvmbqoHY4XHdPvAe2QhFEUdeVUVJZBlLsXb2lk4OQ1Qs7M4obNeoYaeCwiyYwkQRf/RFOk7wVMNvC62rCdccTlOvnjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r5p4OlWa; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KQjthcM/JhRJ5oIgzb+vRaKtTzvpxy9kLhyevK5KqScfvPDhhCDiczd4JnNzz6JmaIWb3ZYjPtsK9qJeuq5SExpWWMYw948nS5QCdIALnSgGSPuC1I/1/jZVIIJyfucYlnXlbIslaNq0TUOpVICLEZspmIsSjAlnMUQuTbrfUHZIQEsf9wcjC5/xCudSCjBhSclKbz1m5SSOvWqWGawsw+kwDSjdx7tnFLlgjZr0H7qV3fAQ1N2N32pLVn1yrshq2FO9bxdeAFMDQWwtDPd+VHOysRawEyqG9Ql8Ej8OP6rxZUj3TgolTPoEHR+Uow+QZ/KWBcr9WN3NP34XdyykZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOSPp3mKTqEcr4jZdc9I3lgbRYxHrlJiJCYECRK7t78=;
 b=DmyLroBVzNRYY1GNsrSX0J8qveyD5GV31siIWIe02cgy5D24e7yBxCY4lGl4rdnOCL7NLfGGHKp0/Hr9s0JnoN+Um5Mbj0RSz0EOs13ard9djR9E29faDMIiJvL/v6p217jPx5QXMVCk03xG/gV8wagjO2wWM8j4/T98/qOA1IcWhE065JzzkP5wcVnmNoL8VGoWuetGYqt2OEeR32bHyMTFITJiZZxyUV7g2ZX1RJopiwpmIE5H/Wmj7rm2fOeETxj46iEb1HktAtXJ2DGFZJyGdi/EsJnQVUCgt+Y4HxNOg3TSJUQgVUbbFWkxshlONbCyxUz2bcrBoma6TmvwrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOSPp3mKTqEcr4jZdc9I3lgbRYxHrlJiJCYECRK7t78=;
 b=r5p4OlWa0hisvvB6VeZbUscDHFEZOcezdXiu2qF2NBr2SLYAv7umBmlixpmsX61Xk0jjaZ/zlVh9f0FfBW0koR/ssbMnqx3L4l8yYIG1m9DpsWZRyDDv0xjtEZrNavaIqL0t48YgHF5pUxazEra/pVf3HuTZVQQy4dB1AQB72BnLURpAMHlqyzstGoRms349lwr7eRxOhzkgmR/4hhguGfowgY9JHcmPs2fkAL6v8jv2fJvTK0Q2zohL81yng8u3lXUnDb7QA2kzoVW/BpyZ79faeLsBb0HKgBVO3JAlIgB212smCVIjVJkBYSgaJLdWPc5EyDmN3Ryy+d3GmzkmOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
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
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH 6/8] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
Date: Tue,  6 Aug 2024 20:41:19 -0300
Message-ID: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN7PR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:408:34::43) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 895b3b7a-9661-45de-6b38-08dcb6714948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+bfqhu0Ru+DKW2L7uLiKkn/LfVtDT81Ctfo1cy1Nd2H3vX1wLDxCK4o8yMTd?=
 =?us-ascii?Q?qwYhdiL2/ueyWitIQ75kwcperPNh40veOxXC4fgz5dlHPtF8sFgl2XVusJNv?=
 =?us-ascii?Q?dRTQ4LgFJu3+pNPyCFdgLshyZQn74J+w/KQrTiHU9m22vCQkVpuccf9NxwzY?=
 =?us-ascii?Q?she4GtuFnuJLq2FJALVvGXaIBn0B6WwJCeOZNJyoD5Mw5XoTvFJtyz4qnjV5?=
 =?us-ascii?Q?S+uHqRG4zx5mI8rYiFhtvxAZGjZhy980sEsUmhcObgL77exn8Z1fvBToJzLD?=
 =?us-ascii?Q?TFYbeZntecyCdAN5sLVUliqGcP7s5/F1Byu6IUGIrptTpkBNKf9nqM2/8Irc?=
 =?us-ascii?Q?C9XbuZhU5l3dKeymWA6aU8YtCROJadsCK6k5j681SVWdkxIm6p6vCV+7GHwv?=
 =?us-ascii?Q?pncITmwjY0sysy5xRbrElCXX3SNqtK2BVn0i8H5+Gc/ZGZZcpDmlK4F/Du+z?=
 =?us-ascii?Q?9IZEHcmuopNJcy7g8XG9jicVcLGPVrLCs7Sohkv7iYRZC3d/g8LKFi44/rVh?=
 =?us-ascii?Q?I6YZa77DB3BV2JB7wm7/H7Xt5OpZApsFe8l0nxR/KVQ8mRXuKcK+D06Y/8aM?=
 =?us-ascii?Q?cVbbaiRXVvYsEEhmJ8Q2pa/szuw1poHCxAO79cO61PfMobgS6yrSNcwDG0DK?=
 =?us-ascii?Q?Nk+4a5vcQrElurPPpQLnmIKEkMvBgzuE+QEfJeU77FNv/uzZdSFM/rjuwz12?=
 =?us-ascii?Q?PIiqX5OKgDy9Abc2SC5jNlwS5zseYtTruAY5viPc8wvrI/bYplq9dEsh/YfU?=
 =?us-ascii?Q?AqvZw92LzanWRmewgnFpOZHnAtVVnDjBX1n0zlaBUsTXD3uHIEGpZxOWI5x/?=
 =?us-ascii?Q?chgB9D3XsRJ/gk3LXStfeACXJmUyhNjIlJ4zGkVEqL60HnOiOGuWQ2RP3fNm?=
 =?us-ascii?Q?NUrMO+gNT4dORZ+l1LVFAHLiMr/iF39GA8kXyTw9uh9bKXHzimyMFr6gJMGP?=
 =?us-ascii?Q?BgigacgK5eG968Cgrm1CnDQECEEgP9EfAKmU6qUmXr6ITfsyDtnKN+kDLmBQ?=
 =?us-ascii?Q?qNO3Ui9h1NXisDu1OnP81i2TsG37GukhIQtKV7HuokFXu9fwgTnh2VgQ1KRD?=
 =?us-ascii?Q?CC72FuCodTG4ZTFBbieRnZE8TcbhcZiCvP1+6gByoT2QhGy7shv9jEayMzZr?=
 =?us-ascii?Q?7Wr2ftAG/n5mrnpyGiMNI4hd+WYtKUNPFXdMtaeDO301Z1ff+12wTLcLa2BX?=
 =?us-ascii?Q?6DXLMVBWtVR5/rUaqfLTnv/y1ExuFf6yrsNzs0mImA3iNfcVMwq9uT1Mz4Lp?=
 =?us-ascii?Q?1XyAkrBjRKmRWwEoTUGda97J56RH1/3lBjzuf0JV94NIHOHEeyfJORgcYkHY?=
 =?us-ascii?Q?roAkTCiF9/pA8pNrAqcaK94nW04IlTYKnfa8M3gcPWB+nsgR3ALDiJf0MB5t?=
 =?us-ascii?Q?t5p35G2VhZtxcz/psLP2sksaYM3+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tscg6Yvnz9wXcTMkQuIcubgAY8AywkhtCmOp5VTjx/r92PDXmyLT3Dg7377A?=
 =?us-ascii?Q?ijqkoNrZeKt3IkCKlyeCAyxId1d4KQweCgPupJZcfhFXw1UrzgC3KPaUP3kQ?=
 =?us-ascii?Q?jdAxDaxjV18s5H0tkerM99x/jgiQwhP0Woai+hzPbs2n+hgsr16/2K6t1nBt?=
 =?us-ascii?Q?7OZq6i9QLUUukwly8rP6B/fzT1jl0gjOLNFoddJRtXMx6O4lD/YaDUo+bNPh?=
 =?us-ascii?Q?dmPW7Qcduq9xsTVBCeP/BvymqX/ZHOxCKmDQt6+mBk6oEo/PGmvgmlYRpcS/?=
 =?us-ascii?Q?vCHI9AGw/AirwZ21xp+16gJ/ezq47WhR4eduboftup2YJsmzgOlgRiZS00l5?=
 =?us-ascii?Q?swdrYyMFp3FFdeyTQLX+aSMqPw2Yxn0R/ee1eRxSSgxuthI18oJoxXGzXojE?=
 =?us-ascii?Q?tgyuD6PEFD7zNiXVxVwx+WEJJcrNQDCHfNuSysY7+XbQP3Z6SZ1E/xf7kvOS?=
 =?us-ascii?Q?83IJK7/iK7eEXyjBSojyGjBhhRLehtQp/uETWoNAfjVXmbr0PicBrK5/ZCvo?=
 =?us-ascii?Q?zBPlHV24EbGWdkpRPr/G2kkAoy1xyt2e/ykag0bfshvst5szsp4ooEIkEk1J?=
 =?us-ascii?Q?yzWAnbogSBN7iY6BRlTuq2BNjgGEksFSEyz+wr4MQas90+MHM9m1/ub3FIdT?=
 =?us-ascii?Q?Y/Boeg24hR8OJctktODskebZMzNvTkIG5wmDXIyd4QfeJcVzXLq2lWk2w/w7?=
 =?us-ascii?Q?uLudpk2Ph3+CQYNrVeO/z0eXQ4nv4nac/DAHtn0MSGdSctwmAMLfDVktZcOW?=
 =?us-ascii?Q?nq6o3X8YKimV0iiurX5O00skPCaLHGYbm4PWkFsHo8GRaHYPrgu+3w1j96iI?=
 =?us-ascii?Q?YwIy4apJ6hPox5fjPLuko0XrIbe2HT6bZTeh1TJLEhjd83pGTPOt0GSOUX1S?=
 =?us-ascii?Q?gKNyZaHT224XXhWChJgPXnsoZ/gyGN7u5duMRHwcMNPWKDFPOtdVBOtwAhRv?=
 =?us-ascii?Q?Onx5ub7GGZOqGXJrFfARUtGGc4z2fLvk9otWmR2TWwI/z2yBX554K+Ep1JiZ?=
 =?us-ascii?Q?o9gswSKqY6U9/KkPxH9WOBoX1rxXwcCAn94/NyBOCoU0PpTbFbsfacFhZ60G?=
 =?us-ascii?Q?UcPaD1sIaBT4YJddJDfa3NDxflx4Uw2KaZoNGEuSby77n3c8J/OKP2UckAv4?=
 =?us-ascii?Q?i5isivXI0ZdYISfa4RCa1XeBiGrZ3xmvkVmuiZzXl7EzDC3rFohc+ocN+V1f?=
 =?us-ascii?Q?HZFXxVQvfQjhENnHyK5N1HhuBgncW7CAS0W4s67VINnpJbgv3BgtSna4AC4g?=
 =?us-ascii?Q?9l4+nRnufVB4QtGc0h5fcvA7FwuPM5n83Vzhrfyg10inx4eYbetlDbhr9sba?=
 =?us-ascii?Q?JmQE1SAPuriJYhQ13f1SWaGieng6OaD7fy9z3wq6qznp7d8jUbAZNQ4xOxLX?=
 =?us-ascii?Q?Vfp6/6NASKcadotJoqnaq07xsYPp7KS9DZ98v5GFwFXgCD6QKLRxmJ8Hq9cD?=
 =?us-ascii?Q?Yv7YBU1RhFAz9kfBnKzWsiKme+I00XW41LXwZc5uv597OypUPheYLhnZ5zS4?=
 =?us-ascii?Q?XkfBjAMmH7iOinY5jsnzNUy6+AL+uJ70jF+rI7i9YLXqf6A+QCkfKfihoLAy?=
 =?us-ascii?Q?rdRu79giCIO5jLJTl+Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895b3b7a-9661-45de-6b38-08dcb6714948
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:25.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jf4mLIfxqtuRGTpG9gIGgzBPwuaZQit+rBx5h8uQddgIVb7qj0BzeFx/uFm88Ax0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

For SMMUv3 the parent must be a S2 domain, which can be composed
into a IOMMU_DOMAIN_NESTED.

In future the S2 parent will also need a VMID linked to the VIOMMU and
even to KVM.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6bbe4aa7b9511c..5faaccef707ef1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+				 IOMMU_HWPT_ALLOC_NEST_PARENT;
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
@@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	if (!smmu_domain)
 		return ERR_PTR(-ENOMEM);
 
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
+		if (!(master->smmu->features & ARM_SMMU_FEAT_TRANS_S2)) {
+			ret = -EOPNOTSUPP;
+			goto err_free;
+		}
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+	}
+
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
-- 
2.46.0


