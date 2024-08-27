Return-Path: <kvm+bounces-25176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE25961349
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09821C22E99
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A141C93AF;
	Tue, 27 Aug 2024 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XyzU+9an"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF1F1C93B9;
	Tue, 27 Aug 2024 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773910; cv=fail; b=Knil/LGbEMYIaRqSROAfRksWT14OMxcEH323t5CtV/cncQlIfKrLOZJER3x3RzTcLsBaC88mCRUcYNneoWZgBvOR3KrL8EuCQDZK4rhkfn7vbdbezQPB6fPHhnO+xqowZrieNTP8NGg8ZkymkIzVFZzzZ2lFbTSSPZN7GRY8ovs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773910; c=relaxed/simple;
	bh=s81VWsIQUGInizR8x5zdjFTg3gs7mmvs5w60jynCcL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gbQp3CoKkirmfts+qQ1APrN7KGCNmFn/IK14YisC9svBg33B/ASMrtSXQ7bPhz2vVqptZJDsRsgQKOGS8ceJXJF2TIJgVcNO3ZG8bbEpbKgoO4B08OAouChR9QcudMzltb7uxHTeE6DZETGXuNbCNDCjOxJ/O0Jfn/O9Z8VZyzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XyzU+9an; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jC0C4sUwpsZZeoAZ1xMmGOsmgfo7RvKX2eRtMfr25HZeSWx3DIGvxBs4WHj1ZbSl5WUbQBkjktTddAkAiz0K0HLdSsYOndub77UGkrejsd6LpDvQIf5VJKAoRtto7CwQqgEgU/MckH/xXwyLPwWTuqlyZHgD/otePuVZ6DxYOP2RbmZUhrvDziJuebMNInpTUbQQV+FRCBJ4R6q6ghZ02QHZeYZ/lzudl6lO0Xm8vM0rgrrCa5Jn4bdt5OSB1OgyXG/8HOB22yDmm34LQqi8pohHKsSbSFYFP6X8Osky9uVkVyYB9kpbYKFNKK3uYSxeuNxucQHbZACGuPG80Mh6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQsBYTfbTzgP5tc+uQ6gXvXO4gbMNJkCJzT1F8PXnvg=;
 b=JwTYNRCU+rT+7/XTdd3zLfUMWtMQpbDQkm61lORlQQQXAIF2YfFydBKu7AT1CGkkAGQKarviH3zEQS5KMkkzRwvzTMVcFDs1jJNHZfQCCvAfH+itrwGAEqt+Nuv5FpjE8xjqN98oVwWKIYTM91lgBM13HhW91JURgPSDQ2mMgRi0lCJi3zWtogzd66SiyYQminYyuERAGXFT3k3yQ/ip/ha3PP+CpMc+Wa8PFMZuPyybDVRiVVoW5KgHms8CTRFsok5UUXOWt6n8bQHjosZ0z2x0tQPacBjpNhaIB4BOJmsAGYNHHtr7/QBhdu3ZFiMJ3kQV9X2rAfPKRsLLqOZfQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQsBYTfbTzgP5tc+uQ6gXvXO4gbMNJkCJzT1F8PXnvg=;
 b=XyzU+9anBbYRFnvAlM4U5S4P11Q69yUAzaJyHA9magQMScPlsFRczHAzXJox8IIO3plvB1+mwdYxxZlLkZzzP1i9kHpojB0mpyp2q+/E/wbrypRAIR50ZQiDQ/0pBaCvlO8iru+fi7qXIWRtt7hTkztJEX0jCCogr83GhUH7zonbNNlK7+8E60zDFPqKfKJurqN+OFsOC0fkEZYxDXnSgLxs2Ys17kqZhy4G1mZ11GxX06jHGt3yBux424cX17B5OH+1RcPejL2XuOcu0XoUlU5KaFA4w1X/yanB+tgGuxltvUY+qerYqDbkSz+VHNT+TZWWjXM7SrsLGZOZb9x7DQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:41 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:41 +0000
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
Subject: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
Date: Tue, 27 Aug 2024 12:51:37 -0300
Message-ID: <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0888.namprd03.prod.outlook.com
 (2603:10b6:408:13c::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 09329889-9003-47f7-446f-08dcc6b023e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wtAQ6Z+JN+1bCd3bfriAbp9sltZiyeNmfnA/rUQb3Bw5lsU9S2mliDgFIVFv?=
 =?us-ascii?Q?gOTaQIf56GX2dVsEFVDtdBCnAu0dUQgYqVtvR7Vq9EvYD6IO1AiVQs8qpcS4?=
 =?us-ascii?Q?86LUHJTLLtSDNI7Ch+/PjZifUrGUH9vC+OLAzV7y9Ha6YhJEemBhKYnjSbai?=
 =?us-ascii?Q?EwO+ySCnJy+niog5Bga4tVXGzUalAmkAx38RPWNDPMpxzTipRvxt9Ihv5QZf?=
 =?us-ascii?Q?Ez+VJI3Elkq49K7GEGgiQB336kyV9XL8jB7z6hHqezXzi3DVTusK7WZAV/Ur?=
 =?us-ascii?Q?hq7r5WSMoABl4HHvX9Vh96NWOWPa4chXYrC4Fp68ySy53W4kJjR03Wxd9rOX?=
 =?us-ascii?Q?RzIU6t2mh0Txv+3OlRteZzALJoe0y9Ot0ryucGSYikAuMURho7on9toeODx5?=
 =?us-ascii?Q?iiCGMhHND65emOyJmLcMUgzDdIMcs5yk5jfiqjwPt3K9CG52rUlOtRlWG3jp?=
 =?us-ascii?Q?UAaz7AmYORt1c6ymXF69AtsA2k93r5Ckf6jIH4upsL5ue160IPsM3r4e/vjJ?=
 =?us-ascii?Q?8Q476KHjUDNdd/AbgAGnAgh1X6cJWH3hWWXEBesOpyoPJOKHjDaxRDyek2XT?=
 =?us-ascii?Q?xKsZe+ZCgOW3z0D2t3ImYrY4Ub0e/3XLH8XcFZZnbeAscRKjGrqmT6DII+Ii?=
 =?us-ascii?Q?LT5+V08/PNk+NBFDQ8CrdNXEu53Cl/rLXrAaxtZx2KAE31+HtG9tCXUrP7pu?=
 =?us-ascii?Q?8s6Udoja+oaDo/0SZZCIcKk9as2z8Fmo3gEcXpRUKG9NsZ+sz/A0jYYmUvuh?=
 =?us-ascii?Q?EdkpaGG3onvglPBRock5UXjcBzHMhWGZxJYul8w0USygjrk7ZAKio3UQqi1+?=
 =?us-ascii?Q?r30h62zrM1QNNqKHXxXFxR58eVshu4RPI9xvQtAeqSPLUWE0WsTHTzTqhjFi?=
 =?us-ascii?Q?e+gNO4iVLhmPTNkCL2+T/sg6KA66n8OMs0wKxMCvt+jmG+RVwXcsAiU+EVe0?=
 =?us-ascii?Q?WHLT7TzFBRGYdPkbRvhELb0nP/D77R9eIWjzBReaCAemdxQOywfKqdOD0K/a?=
 =?us-ascii?Q?cUEiJ/UtMxGBOnu0107ynMyNiEYCGVuVHYUvJRTb8Gofu3XN9GGS87YH9SO8?=
 =?us-ascii?Q?aYA8s6uKhXBMNPObXltFwp+6zJ9Tlg6BjFMId8YbxLk293jFC6UCCsLCqOOq?=
 =?us-ascii?Q?mIOGKOLNeqyLkNm1dR5sjeIst1F31WEgyBk+RAgU/hMi7U3MuGX8EtpZsV2i?=
 =?us-ascii?Q?PXboJfBWwcu8q42WGwaANzoV+fc4+u1ewBf1zxHiB3Qqdib7T8ZIwxTGPZJg?=
 =?us-ascii?Q?MqIeKL/6naO/2hmW1WekWnVWWt5ziTOGfuUdzcYLOhW14UyIPNE2vxLJwe7T?=
 =?us-ascii?Q?s8ar/8ID6NTtQ+aGMUn2q6P06y4WMisOtGj6NTQnd7ljtD73xRiheiD2LrRQ?=
 =?us-ascii?Q?Vq9JsB8L+H1+XBAm8LwE13jzq0s3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IRlHOA2E8slUl27ginqIgFBAcDsW7Y6Pkw4WLWVBTd0fI7ksRqcAGiYDjGdY?=
 =?us-ascii?Q?Fhxzc5V8UXwqSwUGel78OzmAKHdOiM3rkNU3YRbIYD91LgrrJ157FpCmzrWa?=
 =?us-ascii?Q?FCXHzQIWBtuYLeZ5JymQE4YR1tznuCFXTxHJ9vx+JmWf6CZYAPPP2DarYrrv?=
 =?us-ascii?Q?AXkSM3Dailu84YQeYRjec1TgjWl1H6gFbEZwR55nMTJNbIldCOUgfMfbBxBK?=
 =?us-ascii?Q?i09iTuZ7lZjvdlKauIoIkxZQEQGaI4YWdQT0oO3lEEbzFAzG4moQVEqelaSu?=
 =?us-ascii?Q?86Nzs4KoyVilx5fmfw3grnbLCIC2wgDVheFClNM8Gwwk1lojcOCEq9At3JhN?=
 =?us-ascii?Q?Y0WDcUCVbKMIfekGUlI5iXPgRQnfRXsyPm6o+9SapbyXopIRbrA7lmGBblqD?=
 =?us-ascii?Q?RvSw2NZmnQDvzt6N3Sr/13PBN3GG5BkKmk8c4x4a6yT4O8AiPgeTLEkVLpk9?=
 =?us-ascii?Q?Q65Zj8PuFfpjw4Gb0Dg9FU+uMd4R90DVSvC4Ze7CqG3rrP5WmdEvd/x2GoIc?=
 =?us-ascii?Q?LXFS0V3gjfasvTISDRGG6eDU3TpTBWykiiYvViTeSk04Umj0sWt9J1U1g3Gx?=
 =?us-ascii?Q?UxBCwKYOIuu5ElCRXQp1Z+GbuumcAmlBWDEboXDj2b0ItRMGhzDOimy1FRQH?=
 =?us-ascii?Q?lXdT7dn/FUn+RVY9U7c5+bFaDYX2Zn2Grr2xisWVD8o9kPbWoTdrNMUwJfDy?=
 =?us-ascii?Q?e6gEI0M5E+utmh2jMNrAjh1mkYD0GuFec79l/nKs5MEEry4feW1iCludQfwR?=
 =?us-ascii?Q?70DdSYwLBjpQdTSvh3qy03NllPntKOaCIUalsxyj41l7j/BBEO1zHT5k/fH5?=
 =?us-ascii?Q?Q+QlebkB727Og6FAH6qyV5tyEieCyYZZN+1SZ8sKUE7S1XOi+39AnqE/Oqqe?=
 =?us-ascii?Q?+EdaCLqhU5ClLHgxNYnSNdSGUtPpwzB/+X1jJ0cy5lbOiN16iPinH38pCt2D?=
 =?us-ascii?Q?bftacCFbFCSdqkRnbeVq88GlvpqqzGz7st1ffz7Uv/ADahjdNO5uwJRNC2O5?=
 =?us-ascii?Q?C8nUU7pofAy5RTnGA0+EFAk4nXPp0DqvgaMgWW71fovMOtlhLKOXY/NRRwkq?=
 =?us-ascii?Q?rDz54kB+LpsvyVgy97lmW3/atCXdjfJ98AohRdQXg5pLRxEucSM2zj6fUtb0?=
 =?us-ascii?Q?c7LxdIJff0gGZTSIT4bX6jW/Vvj3SrbvwPLpRhT+Gd0t6WMxFiXfxWUHjHUc?=
 =?us-ascii?Q?CyM1Ks/9DRvuvEO1TSGo6o48ivaWebikaRysbsrNIetw3dsqH3+exYDtchgT?=
 =?us-ascii?Q?mtJ54V2r0L6HvwMfCPotrn7TcCUlW8HukNOs6Fkdz/bXnQJJfydSpWnhQrAl?=
 =?us-ascii?Q?lRgkYndjgu8PiYUXKOWgIW46SODUlMPNk9j6Y8wIRqJd84wMntwYshumZOIG?=
 =?us-ascii?Q?z+NWwncKJXYpLb1Yb7LS7ZA/YG5Do1SbqbQ7I6PzA8ELLqGWlib7ILNEMm1x?=
 =?us-ascii?Q?UkCWCVAishnJjGeDHSmHoW32m8Sl1sCrkLJaVJdu5YLhTxN23/5RgkWuWv0f?=
 =?us-ascii?Q?p95gy8kx3SuWV6C57kvavlQt0SeB6tbbH2CUD0pKiS5Fs2QXPiEO8xc5Li9V?=
 =?us-ascii?Q?HAghOJpDI37hw9xeznBjFwg1szeoVqX1qF1jFOfn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09329889-9003-47f7-446f-08dcc6b023e8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:39.9955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwGPE53k12quGEwp1q3/7xUicXbySrJQMq7eaplN1HmQsDWBep/q8kHyJwf/QwJ7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

For SMMUv3 the parent must be a S2 domain, which can be composed
into a IOMMU_DOMAIN_NESTED.

In future the S2 parent will also need a VMID linked to the VIOMMU and
even to KVM.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ec2fcdd4523a26..8db3db6328f8b7 100644
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
+		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
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


