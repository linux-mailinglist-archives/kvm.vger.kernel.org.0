Return-Path: <kvm+bounces-25177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D4696134C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 448B31F21926
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE7C1CDFA7;
	Tue, 27 Aug 2024 15:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MpSylOTx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2048.outbound.protection.outlook.com [40.107.96.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DEE1CCB28;
	Tue, 27 Aug 2024 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773913; cv=fail; b=jgVcGdpOBR3IaZpgyTEKmh237L9hslFVs8/xh/9HJ01/OlUNh6v2g30XQPnQ2LRgzZTTioIgu+BUf9habdNQntU1AuDIWIBQFYMcxHhY0EqFwM6SajvriQ2yAR36ergom+kgH7wfXRb1HWigPmMFXZgsuMDTXO9fMMAv+pzd8qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773913; c=relaxed/simple;
	bh=5noAFabF0IKrb4pvhNpD3/eTe7kM5BT4EGJhRdcl7aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IHd2klpEBgFTjK5ppGkZHob3fKtkV7iClGdO2oWafdj/Cqq30K7a+KIGJQUzO4i9Smqvv39i05c8ExgDB43hR8MzKHHcKrEj67V3yVq3j5Pq/4mF9pDQqlAhYpEsNcuNPFosvXmZdXrDWfyuXk/9NRjY7vZsEetmWjdmWcCWnAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MpSylOTx; arc=fail smtp.client-ip=40.107.96.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EpPIqFhZPkNw86Wo6A+4UssQ0h9NCFG/H5vvA24BCcdsh85ZYrRDMd+OesYnSJDNOxBwaWVAVC8sckMGq0JTW2gsKnyQBAXjB7GjtLZ+J00eMlK/ZOssKIqqJU8U+q7Qp5HFrzoJFKnNzYy4PBjHozZznovTA88CScJtdAtQv28/n1onR0HjqoBdBT5GjtrjNcb8lbyJ/Lq1st4jA801RqXxzcK9SUBFWfmn8pVhYzeanuPDcEk7RztnmSDhebBbV9L++5bApqHv8c8vlS8HYlRNTpfKuLc1bnNvCHAMp6X9RfNX6ysgvB2WaIrJYdTrRUA7C3RmdAxzzdrBO9+5cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiXx3NnphBzoqdte6K0mFD90uWB2VU1T0YNUeosSIbo=;
 b=kIcaHEtqkRRRaOBC4Dpd3sZv6IhY4K7ChJt65Ar6NNDyYjF0LdkfgXbGOl35ESlllhWADphRAKqmlTpCA5h7H+D6crQZrap2Oq1ca9mvDQK82SCmMQcN/hNG/5VCI5RQGe6s9XU5tQgIxQi4eZN/STs9Sas7jN7adt8c9RycakvO1M1JN5fL3/bP3cerQx7vc/7Xzophex64W6DjR9xzF/lAXVZtDM9J2kwz2xOIYlb2mJCf7IJ+jOaz2Y7uGXdmsxxpwQ1aO4qPuy/Uss/l++9+UJxwRpzgL3IDZj9+g3+5JMoG9yVLGBCepUQtC032oSztCcwC1HCF+/YZwgXnTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiXx3NnphBzoqdte6K0mFD90uWB2VU1T0YNUeosSIbo=;
 b=MpSylOTx+UiZst6Mhb5cuUGvrYoYN2If6747YQljkqGkhTS/1o0G3sheFiPpESxbyKNek4xK8L+RisxsWJJ3Z1ztCO3beNIDr3rgYFBhCFnkU3j6tNLP88NzoQasm6syMKKi1AhsMOxfscPm0h4nlIJIsyp3NwE1PsWbu5IXCavukT/UlhFR0vuODU6Q8AJgL9GfJBy5kMJlf5ZXGlJO1HiZ+3br8urG6lRkLPihd9Xl/6Zcp7P7CPL8I9IW3/Y3qHZzk8wk04v9wTzbqxGtJ1hQRWQwi4FzmxOi8XuFoTHfTbz3M2Vi+gmv+45fVMedCr7b+vSpFU/UTsZA/62klA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB6658.namprd12.prod.outlook.com (2603:10b6:510:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:46 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:46 +0000
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
Subject: [PATCH v2 1/8] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Date: Tue, 27 Aug 2024 12:51:31 -0300
Message-ID: <1-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::33) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f628d6-40e5-45d8-2464-08dcc6b024bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b96QOBPHUdK5m3oArrmmdO0TCIqetOVW21WvbAWZY3VOX+MzEWjia3nHnZif?=
 =?us-ascii?Q?LfVf+B9UlAILEZ5NdgBf05KHaRi4lwnYufcMDhG/DTf5i7QJdET1x3t2LRgQ?=
 =?us-ascii?Q?3vuFsCx4eEh94WiYglz9oQT+yhwxJRE3k/uQrmhsEKDvTOaZADeu9A7R/NeG?=
 =?us-ascii?Q?Rrj1CNCURWyNtb3JIM+3WNYfnFqulVAU3/EsxKMiAmuEapPSFA6aCosLGciK?=
 =?us-ascii?Q?svNNN1UiemaqO+7i0AURyDEn8ACR4tO/DgWqTM0reL3UprqLvcHvxEeK3rd5?=
 =?us-ascii?Q?nU8p8RqX0hwTZU+6y9FdSf3rFBQi9N2fwcwXyjAWSTAg3+R6uSLK89oSZ8K+?=
 =?us-ascii?Q?csaNl9pYkSWO4FHzxhhEGTrNZrmPES54z7cfaZ7QigySrEWOzi05Xd8ByGfv?=
 =?us-ascii?Q?rVJljHnWmn7/Au+ISXKtXa5FGf9N+ietu6oWM/rlRj1HjkLhY/akisC1cMLa?=
 =?us-ascii?Q?etjYk9Yx0n1EHXvWxbZ71K4CT5pHFtF+9HJI4tBJ240ZgXiKqucuMmIdQKYX?=
 =?us-ascii?Q?5IPbIRJJLo/ggCeJEiZyzL6qDdBOsHAjjHOrMzeqpklja9gxmtUhkb6CMVlr?=
 =?us-ascii?Q?0oBxlW8JwZLhul8d/qmnVTZ6TrYRQ0cR8r8p2aNyURc7mrB9/nlqLUB0KU/R?=
 =?us-ascii?Q?Krifs30Oya6XjnXH7DXsiNKz4QvDr34asWyo4S7lbl4R9SSWJeVjZgXHc+Bf?=
 =?us-ascii?Q?aZXerGHs0TTj3leqTXR5VHPrdk1XdGWdgVHuE1/+Pr55C3ArMKE0iAqvpN26?=
 =?us-ascii?Q?5jYDsaf7RbX2p6VfotEXvZj1e8HAlQPo2Zd7a+Dxj+rzXsAbnVVgYX9tYnQK?=
 =?us-ascii?Q?I86+8lTKfp9XPlEoDCtEPfjpBDGaIsP0iLbdqJ37iWMMrduMhFe80PN4aV2q?=
 =?us-ascii?Q?sUv82ogQcmhWURZPgNqLtRs7QxO9Z+mEpvmN97iWg1/9hZy+Zn26zBmexybD?=
 =?us-ascii?Q?WkIWwzWeSuvjGURE/Age9GUX6066XqhADrFChg3GGlrpzawomM1hYnKGP3of?=
 =?us-ascii?Q?BvNm45g651NuHLzhCvMvIqe0x2kn2eeJ4NSnzf5037wM8PWS2XZGBuVb5azk?=
 =?us-ascii?Q?ecKB0yKP1AjPE/kxXrs7zOJqu0V047OvFob50ZuyLrAW61Idht4P2ohGTu2j?=
 =?us-ascii?Q?4ozNa58wgB4KA9pwh94ax7WTDFa9KJzhHZup6jYdl8t4Y6BWfr33fkUvvzAB?=
 =?us-ascii?Q?cCOt+u3PnDsg1TI67vxCQrGcpwp8yGHI8LKNaLlKgnjwrsBtwzNKJrzlNr7R?=
 =?us-ascii?Q?pAxV8nTBbweUUAxsGTLAKUj5fwVQVl4ZkKZLfUtCEMHCJeTFuiDQyVRitl2T?=
 =?us-ascii?Q?TThq4acJ6DYvSbkZfh8z++SEU4GAcGDtvrGsyqZo6n8T2sC59OtE8EN7SP72?=
 =?us-ascii?Q?+xoaiwSdbjATIMXFWc0bgsTFt1BWy+l3L7SsEa96tnO0feHNDQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6S+0cW6i/jSiQShscNyeZztzSuP0sd/UCB5Qb6pZe3Bhesi8LbaFuL72SGrQ?=
 =?us-ascii?Q?YLRGE7SL83KIjs0uw0zp6i0tYUrkH2eIh9ujxyOgctmWtpYDs3R1Grc/n6WM?=
 =?us-ascii?Q?PzRyHAs88viwLjY2Z4wWumTkIXr0cyT/G5haVCmOPdHyHo6RX6/PPhtJ9BHo?=
 =?us-ascii?Q?ufPZ+CQhLwTN4RLr0exiVoGlw45zhV+l5zu8+RV4HOZod5/Khe1FKzryN0IK?=
 =?us-ascii?Q?7XeNqpFt2oOsaBalemnmlzDqGDFzSKSkYRHsHz4ntwd6zKvN6vKOUff3q1sK?=
 =?us-ascii?Q?EAuUhPJvCc7ADJwnauV1S1OV5UV6tBp0QP/oig4TVtT7rpFNxuhK5l37cY7f?=
 =?us-ascii?Q?c1pE32mCSUZXIZXD+vJMJYHybNB3NRiq10wpb7vCv7CRuLD977RkhD3SMoYZ?=
 =?us-ascii?Q?54B7pKCFSPHYGk2Evc7ECEUkT47FOdiVA1yvPhNdX6aLMZXtqc4QNRbUKMgI?=
 =?us-ascii?Q?7UQVjh8Tk/pmLyR0SXi1Dv5/0KdTpaT0yZAhoaWAgK5LflSx0nxylrXZEM5H?=
 =?us-ascii?Q?n0qzZuwDmiWA8Liq1SvZ652kU2VEg/r20iLvy+y4KUXp6tQubyzjSav4FYMK?=
 =?us-ascii?Q?3D6GLzVlFwpXLJzWpoHK17PhzV7bD24NR/nOcHDjfKe9BpdrUV0r2yg0OTkf?=
 =?us-ascii?Q?6WdaSIGxwUNkiFmcwlJRm4Wlv+w5zMweGrHD2DXX53WJCidgNgmbsdzw9/45?=
 =?us-ascii?Q?euTai/f5QhzuDxSw8FtPP4bQKhNhF3c6WsXc+S7Hscgvaa+GVzcJNCUEcTHW?=
 =?us-ascii?Q?ycuEcUy5IBW66FziHDETwYI2X9Tl7vLS18X+JbHBTMD2YxGDo2HP2gxxke5B?=
 =?us-ascii?Q?ojTb0JXAlq9rq84QfbrbIZw9/x5Zh00YBrDLML1YROPB5QvAxtfd/PAhv6yq?=
 =?us-ascii?Q?ecNVGxBgWSsnMuQlCThHcfr/d4GNoEBNqhCukZQRcVVR4zH/i9Al873hZTkC?=
 =?us-ascii?Q?8ya0zfOSN+BCXEIPUXT6idJVKDluxcTJh1ceTOcNiM/wPqITFKxvGm/WVU5B?=
 =?us-ascii?Q?I/QNu7RrjeZnVjsJBJlkpsIxAt1WHbe8X/SNMGPPyy5f5Ah38wt9OAS7BU7n?=
 =?us-ascii?Q?5fXr6WvE2Brvpv+Eo9Gc8K97yL5XKk/dJ/n7ZgfRBxu9FFMu9JEumSm6MOsB?=
 =?us-ascii?Q?63fBKwcLSHy7zz3PBZr804hdcdO3h4DFcbSvvKYNJ940CfW3BVI7XiV8iCU0?=
 =?us-ascii?Q?ZGwr5Lr7TbUZRBlfIPv8NujwPqIACq4W3VnCSfmJ36sbS0EJGjctV/Q/IKDR?=
 =?us-ascii?Q?i/a3ppyyum31PqKHw0JfJsziTfYI4PMyEn92+imFeyFbqKDcfyZrAORPSMSO?=
 =?us-ascii?Q?mxRnMTHKlhaEiv9t8G6vaudfyGK18U+TKI/opyD/hP70w2HOYu0LuIFllEX/?=
 =?us-ascii?Q?zHCJKuGpFZcWnN2pCGTgf4+hOPMvc0FG6ihYNtUBrLXZ4//n/o1B7UtX0AmQ?=
 =?us-ascii?Q?Q0f8ztOK+5/4NLTcO8g+68TFcos2QAKpnsN8+2L8Lh3IvVCTlUZj0uC905rg?=
 =?us-ascii?Q?lj+KILzG6q+s7M/ftqT+PmBFEEcvbmAuU7PfkrVnaRBnyoKJOW8mfFcDEff4?=
 =?us-ascii?Q?6bu0zSFmrMyVoYpsQL7WBJh0wjZtVTEaRJH3pGNM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f628d6-40e5-45d8-2464-08dcc6b024bc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:41.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFOL/61FrsISvprOz3eYLLw72RoRquCA8QnBNPC96JeCWClExOSRqw/W9Bv6Jkrt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6658

This control causes the ARM SMMU drivers to choose a stage 2
implementation for the IO pagetable (vs the stage 1 usual default),
however this choice has no significant visible impact to the VFIO
user. Further qemu never implemented this and no other userspace user is
known.

The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
SMMU translation services to the guest operating system" however the rest
of the API to set the guest table pointer for the stage 1 and manage
invalidation was never completed, or at least never upstreamed, rendering
this part useless dead code.

Upstream has now settled on iommufd as the uAPI for controlling nested
translation. Choosing the stage 2 implementation should be done by through
the IOMMU_HWPT_ALLOC_NEST_PARENT flag during domain allocation.

Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
enable_nesting iommu_domain_op.

Just in-case there is some userspace using this continue to treat
requesting it as a NOP, but do not advertise support any more.

Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
 drivers/iommu/iommu.c                       | 10 ----------
 drivers/iommu/iommufd/vfio_compat.c         |  7 +------
 drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
 include/linux/iommu.h                       |  3 ---
 include/uapi/linux/vfio.h                   |  2 +-
 7 files changed, 3 insertions(+), 63 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e5db5325f7eaed..531125f231b662 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3331,21 +3331,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_of_xlate(struct device *dev,
 			     const struct of_phandle_args *args)
 {
@@ -3467,7 +3452,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free_paging,
 	}
 };
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 723273440c2118..38dad1fd53b80a 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1558,21 +1558,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
@@ -1656,7 +1641,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 		.free			= arm_smmu_domain_free,
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ed6c5cb60c5aee..9da63d57a53cd7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2723,16 +2723,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_enable_nesting(struct iommu_domain *domain)
-{
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
-	if (!domain->ops->enable_nesting)
-		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
-}
-EXPORT_SYMBOL_GPL(iommu_enable_nesting);
-
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index a3ad5f0b6c59dd..514aacd6400949 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -291,12 +291,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
-	/*
-	 * This is obsolete, and to be removed from VFIO. It was an incomplete
-	 * idea that got merged.
-	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
-	 */
-	case VFIO_TYPE1_NESTING_IOMMU:
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 		return 0;
 
 	/*
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0960699e75543e..13cf6851cc2718 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -72,7 +72,6 @@ struct vfio_iommu {
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
 	bool			v2;
-	bool			nesting;
 	bool			dirty_page_tracking;
 	struct list_head	emulated_iommu_groups;
 };
@@ -2199,12 +2198,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free_domain;
 	}
 
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
-	}
-
 	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
@@ -2545,9 +2538,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 		break;
-	case VFIO_TYPE1_NESTING_IOMMU:
-		iommu->nesting = true;
-		fallthrough;
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
@@ -2642,7 +2633,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
-	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_UPDATE_VADDR:
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 4d47f2c3331185..15d7657509f662 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -635,7 +635,6 @@ struct iommu_ops {
  * @enforce_cache_coherency: Prevent any kind of DMA from bypassing IOMMU_CACHE,
  *                           including no-snoop TLPs on PCIe or other platform
  *                           specific mechanisms.
- * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
  */
@@ -663,7 +662,6 @@ struct iommu_domain_ops {
 				    dma_addr_t iova);
 
 	bool (*enforce_cache_coherency)(struct iommu_domain *domain);
-	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -846,7 +844,6 @@ extern void iommu_group_put(struct iommu_group *group);
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2b68e6cdf1902f..c8dbf8219c4fcb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -35,7 +35,7 @@
 #define VFIO_EEH			5
 
 /* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
+#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 #define VFIO_SPAPR_TCE_v2_IOMMU		7
 
-- 
2.46.0


