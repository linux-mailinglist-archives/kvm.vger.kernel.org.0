Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0497B67F27E
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjA0Xyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjA0Xyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:54:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B848B043;
        Fri, 27 Jan 2023 15:54:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL+vWRN+xOTYRgOwzcRS/vg3nscrBiT8VD1tapRdshlA5rZRW/ZHwDT3dDBZfcHElMqnRomD+jEOfZPN5DitbZAxwyTwuMqNjP3TYFCoDzXds74wpUUiEA1i7ldHLlbJk2ua+BPQCc400QsOhhpfjVP7ARrvAEwOPNdZ/SGU8iJwx/+HtBz8T/sgpL5Wfy5AZn3OjILS9v7d6QirGtqtvdqPTNAU5c6scKiNMXmKf1+tApEn9lIei+70e00RBd3ZGNGMUvfggNP/Svfws8LwU4Z+srJQdHUzVOdvx656LoksolwbGfGtA6BOf3jQ2sf/oPqVoojBjbzLxtbORsPmTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzuFQTUWtdSZhAu0f4ik4flo4LL9FPYeFSXUDbavn+8=;
 b=byqv9MX8sAbDQ54ml+k/3X62k16FYeFh5lORJDNRFeZGqtPVyiqeVf0UPYFxLphLvVP2zVEjTn30NanGHq3xVgdSxaMs+xLdrf2AjgNhx5op2JnkGo4z4K48/S+QNqM3CJAbKW6dADiPVpzAdppPhHrv5UlSpZXGv/Wi9tzq5kR4WEEyzRs9kXcLwuqnsZSve6IApzEXkERBpKHClD9XqCuFPMqaBWjCJ+AHHpDepKbYdM+C+WiNHOlwbotxZlCmiokRGGZOwAC2TYPdSS0aJ3A0HkL0tyhBMROgF7V0mmA2erKGHdssSDDwtdZ8Bw0aFjpCoYbS4gfJZF4FM/H/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzuFQTUWtdSZhAu0f4ik4flo4LL9FPYeFSXUDbavn+8=;
 b=eG5d6Cffe5dOAtKUltzjM2HjuCMSRTouev+4HDi3W5pjv11XkeVNXk6r8TowJrVcC37T0oyfi31M8kUEWnX+tCG1xu1n1+IuBRXcTIDkpuU4FNY+76w0uIK/Lq9nC/lNFzq5jWum7AAFtt1JPCnYbi3XlOmoCXZKuXaP/MDoY+KbhqLUm4IlC3MV5NgRN7hqnQmiyf5aZd4IYwx9H2x3zG2hfSOe8fWBF8iGDvOgGJNaWerwAOjRBqpLH4DdwYB42fJrb0SmdbyIc7FyGDvq3Smh1+y8EcQcLtsOUPmDeuHQ/KxZK5VsSke/DVT23rRD6qKtLfw9FyoBxL8y4YOaJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7770.namprd12.prod.outlook.com (2603:10b6:8:138::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 23:54:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.021; Fri, 27 Jan 2023
 23:54:05 +0000
Date:   Fri, 27 Jan 2023 19:54:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
        joro@8bytes.org, will@kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        yong.wu@mediatek.com, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, alex.williamson@redhat.com,
        cohuck@redhat.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Message-ID: <Y9RkG2dejdXptUTB@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
 <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com>
X-ClientProxiedBy: BL0PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:2d::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b9884b2-55d1-4d3b-9c16-08db00c1c57b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4npsE5Grig1BPculNcm20TX+iyiPlPw55M2T77Fsa/sBaDEjYgYZAZATFdL/bX2dowU65z7ZeaJyZFuc1h/THF8eWpUcmBc7PFs6/v3DAYQOnIIJf+5skVuBgin1HBgHWtgcTy6qa9j2V8oTRxd5TZHLuK/7ZPnUNgAfp3DvaxY187Rp6ku0g385KgWQc13A8+7gAmAzfkwhwozuUJeZuNE3FPsKw7NqqVq7XISbM2f0EFZNCtg10mOxits8LucWc2Moec9KWQg3Xt8LudL2dHFgM8QpRtMtwqr2HREtumwhHl8W+lHLJH+WJVFaMNM+WM/pR7pKsXfgmQMlm44mboUnJ51tULTfsWSLPxxlXHtvbseTjanJaPiZE54GYxmC0k0zzGvMamyCmHClt9Ut2LKkslcgKd+1XYlAgiHejvJVCQ49MCAiPffN8eavvXROrWM5hOcSGaioMEBW/oGZjwNWEeALNl8G6dpvRsX2ZLwxy5MQWrzrALosh65Azv4a80hJr0lqrzjEP3hLAxpuJNW0cEj9niEILltQybr+i3r9pitWELQwFPwh85L20mkelwpG8WZ0OtkU6Z72YWsLlfVSCNcfCvaSybc1m0yUmru6PHn6/T5Yu/RNhkMlF6T2FUXKbvBAPR8vIQ3VjUuNSdAKyBdaAIW5kXIoPxIbYF/PBohUr6Y71JzHGgy/6HcmgQrGzId4WFNvEiUcNzWESzGSvX7EQWAEsB7xsFlD2M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199018)(6486002)(186003)(26005)(478600001)(6512007)(966005)(2616005)(83380400001)(316002)(41300700001)(8676002)(38100700002)(6506007)(8936002)(4326008)(86362001)(5660300002)(66946007)(30864003)(66556008)(66476007)(7416002)(6916009)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?md89QhdynuW4QGDRC75zcdp+1sqltjv2O0wm9T/IacARIj1XLn23Dgymf7sK?=
 =?us-ascii?Q?k1tf8AfS+BpdIKlQyukEvRiHXVbIQep5DzKG9iR3HSU9uUWmBytZek/wCMR2?=
 =?us-ascii?Q?SAlgUExZFkiLUDw9tuYuLWPSfsfseqsj3+hl/nHBiJjfGv+Xe1x1TN9Yu8es?=
 =?us-ascii?Q?8LSu3J7LTp+iz67ChHdkrq6+uNef6Tx8ZQpoV/3N1LBJBvz+ReCIzemc+CXD?=
 =?us-ascii?Q?d897TRz7BPinQDzRrEuyEcsavXJ6EAuv3e2saZCB9s2Sgs4RHGXDeJsLxw9J?=
 =?us-ascii?Q?0uviq69cRYT8u+FqqE9ZO/d7HGgHxpQSkpZdIp5J6LRNNLizgR3yDWRhaVCC?=
 =?us-ascii?Q?dr26QREwvSv2aURcGFeiMlbOAH0J7F4XyuQRFswMalH1Q1JvWpIQqJR3jdoB?=
 =?us-ascii?Q?OTlJHYuswG+0MKJEFDSfRaFalLPwQZJOkSTVMebFHZHiWx7ftBBSO4TiY5p6?=
 =?us-ascii?Q?DI4RxkkTqdeBYj1PtOa/p/MVgRLzXiMtTQbcJDijQrdV/rNBr8vZ5QuSTFZq?=
 =?us-ascii?Q?SOg+6D9pvsXeA7RZAwl1gD+53EKGluYPgaXqW2p8JqniUFIxvrFEWYGJJwkW?=
 =?us-ascii?Q?hwTTj2XQFUoRhD+sQ3oHtJ9Dkr2aVdCcN+8tKStu8C4Q/etD72iBK0dP9Vly?=
 =?us-ascii?Q?nE37GHbvi0mi8/RcgISQQJIt8foMMUXioATyVqSwfV0Dswa683h+EVi/r/B0?=
 =?us-ascii?Q?lCeYlNDM2KVr3ko4gjiWdnN5HBUvOk0eifq90uzCi+wCQcs2Mu7WeH44LhfQ?=
 =?us-ascii?Q?xoa5+VGcw53ZTx3S480268gjkfab0sKDaqvCW0IFLi/w809CWV3MIUjef9wK?=
 =?us-ascii?Q?0IjoqbXyp1EZbzWtXrq1KuUR4KOO9jZ/NTA1GtpSq84cvMgGyFf4oTkLDrfZ?=
 =?us-ascii?Q?v0Q9bVSHV1rDWqzCF0b0KtZ5qQ16zGM8hKeU4nwfpExGUZ2M5EMSnbD70eIh?=
 =?us-ascii?Q?gUYYyUXBjEq0uuGRg66aL7e/8/PieDt56xcOxO//ZPv8DfNQ56VaUbNyJNjU?=
 =?us-ascii?Q?Ps1Ul5OqNRgADRqjAfMWSRE5vyweaN2+v73xIwDRtxGeQQLeY9cO8DK84Tgf?=
 =?us-ascii?Q?DrFoUWsLNYG28z1YxigjqBN3jIrijUboAGcZFtKMIu9WUVobKys2CzIfCp1S?=
 =?us-ascii?Q?HP0KtrDZ2qLjLM596d6V+ys9VMpxd+EFbrOK5gLE6iveoCOyuhwsiFsHDW1u?=
 =?us-ascii?Q?6I89aIfbxEsr/ijpM78lBk61uGiwJAtS8JD7kn6YR5iGhpEfRdCwxsExbzeK?=
 =?us-ascii?Q?kPLAoFpt9fD34LJR5424dTI1kS6gdy/8PtMo1sqkdJJSL5FEDr6MsSRDTlfC?=
 =?us-ascii?Q?bQhc1COABQhwanoyq1+J+IoCveP4LWbAoUP06I4PreCEsElJ7ZhI8XI2c5rT?=
 =?us-ascii?Q?HnEtqgskD2LADTt+bKjCQq4yWYT9S+deCJ/g6+I00VHqEAaBO33PCP2hres1?=
 =?us-ascii?Q?gqEs+Pd4vIyQm4JTv6ekrGojIOd8Lsix1D3SC4vwEqG3Hr7OIvw5Rk9X0rYp?=
 =?us-ascii?Q?2EPgE1wP5wSx3ggCwIij/x2FN2roMZdJHR6H8Gh5UDfqB4syNoV0BcySW7hl?=
 =?us-ascii?Q?g95rSpl07KbkRjSK4Kw9+m212z09SsVk2kWeXa02?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9884b2-55d1-4d3b-9c16-08db00c1c57b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 23:54:04.8082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oCd4jnlnJwW0mpb6pMLkZuUdgyf7C97Ym4he0dWtoI2fggkds1wGfUU6qLOQmm+j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7770
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 09:58:46PM +0000, Robin Murphy wrote:

> Please just add IOMMU_CAP_IOMMUFD to represent whatever the nebulous
> requirements of IOMMUFD actually are (frankly it's no less informative than
> calling domains "broken"), handle that in the drivers you care about
> and

I don't want to tie this to iommufd, that isn't the point.

We clearly have drivers that don't implement the iommu kernel API
properly, because their only use is between the iommu driver and some
other same-SOC driver.

As a user of the iommu API iommufd and VFIO want to avoid these
drivers.

We have that acknowledgment already via the IOMMU_DOMAIN_DMA stuff
protecting the dma_iommu.c from those same drivers.

So, how about this below instead. Imagine it is followed by something along
the lines of my other sketch:

https://lore.kernel.org/linux-iommu/Y4%2FLsZKmR3iWFphU@nvidia.com/

And we completely delete IOMMU_DOMAIN_DMA/_FQ and get dma-iommu.c
mostly out of driver code.

iommufd/vfio would refuse to work with drivers that don't indicate
they support dma_iommu.c, that is good enough.

We'd eventually rename IOMMU_DOMAIN_UNMANAGED to IOMMU_DOMAIN_MAPPING.

Subject: [PATCH] iommu: Remove IOMMU_DOMAIN_DMA from drivers

The IOMMU_DOMAIN_DMA is exactly the same driver functionality as
IOMMU_DOMAIN_UNMANAGED, except it also implies that dma_iommu.c should
be able to use this driver.

As a first step to removing IOMMU_DOMAIN_DMA remove all references to
it from the drivers. Two simple ops flags are enough to indicate if
the driver is compatible with dma_iommu.c and if the driver will allow
the FQ mode to be selected. When dma-iommu.c needs an a domain it will
request an IOMMU_DOMAIN_UNMANAGED.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/apple-dart.c                  |  3 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  4 +--
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 11 ++++----
 drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  3 ++-
 drivers/iommu/exynos-iommu.c                |  3 ++-
 drivers/iommu/intel/iommu.c                 |  3 +--
 drivers/iommu/iommu.c                       | 29 ++++++++++++++++-----
 drivers/iommu/ipmmu-vmsa.c                  |  3 ++-
 drivers/iommu/mtk_iommu.c                   |  3 ++-
 drivers/iommu/rockchip-iommu.c              |  3 ++-
 drivers/iommu/sprd-iommu.c                  |  3 ++-
 drivers/iommu/sun50i-iommu.c                |  4 +--
 drivers/iommu/virtio-iommu.c                |  2 +-
 include/linux/iommu.h                       |  2 ++
 14 files changed, 50 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 4f4a323be0d0ff..0eb3eb857d7e9e 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -580,7 +580,7 @@ static struct iommu_domain *apple_dart_domain_alloc(unsigned int type)
 {
 	struct apple_dart_domain *dart_domain;
 
-	if (type != IOMMU_DOMAIN_DMA && type != IOMMU_DOMAIN_UNMANAGED &&
+	if (type != IOMMU_DOMAIN_UNMANAGED &&
 	    type != IOMMU_DOMAIN_IDENTITY && type != IOMMU_DOMAIN_BLOCKED)
 		return NULL;
 
@@ -769,6 +769,7 @@ static void apple_dart_get_resv_regions(struct device *dev,
 }
 
 static const struct iommu_ops apple_dart_iommu_ops = {
+	.use_dma_iommu = true,
 	.domain_alloc = apple_dart_domain_alloc,
 	.probe_device = apple_dart_probe_device,
 	.release_device = apple_dart_release_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ab160198edd6b1..2253c5598092d0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2013,8 +2013,6 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return arm_smmu_sva_domain_alloc();
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_DMA_FQ &&
 	    type != IOMMU_DOMAIN_IDENTITY)
 		return NULL;
 
@@ -2844,6 +2842,8 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 }
 
 static struct iommu_ops arm_smmu_ops = {
+	.use_dma_iommu		= true,
+	.allow_dma_fq		= true,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 719fbca1fe52a0..7bb160bdc4b594 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -855,11 +855,9 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
 	struct arm_smmu_domain *smmu_domain;
 
-	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_IDENTITY) {
-		if (using_legacy_binding ||
-		    (type != IOMMU_DOMAIN_DMA && type != IOMMU_DOMAIN_DMA_FQ))
-			return NULL;
-	}
+	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_IDENTITY)
+		return NULL;
+
 	/*
 	 * Allocate the domain and initialise some of its data structures.
 	 * We can't really do anything meaningful until we've added a
@@ -1555,6 +1553,8 @@ static int arm_smmu_def_domain_type(struct device *dev)
 }
 
 static struct iommu_ops arm_smmu_ops = {
+	.use_dma_iommu		= true,
+	.allow_dma_fq		= true,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
@@ -1982,6 +1982,7 @@ static int arm_smmu_device_dt_probe(struct arm_smmu_device *smmu,
 				  IS_ENABLED(CONFIG_ARM_SMMU_LEGACY_DT_BINDINGS) ? "DMA API" : "SMMU");
 		}
 		using_legacy_binding = true;
+		arm_smmu_ops.use_dma_iommu = false;
 	} else if (!legacy_binding && !using_legacy_binding) {
 		using_generic_binding = true;
 	} else {
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 270c3d9128bab8..babd20108f6a17 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -323,7 +323,7 @@ static struct iommu_domain *qcom_iommu_domain_alloc(unsigned type)
 {
 	struct qcom_iommu_domain *qcom_domain;
 
-	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_DMA)
+	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 	/*
 	 * Allocate the domain and initialise some of its data structures.
@@ -575,6 +575,7 @@ static int qcom_iommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 }
 
 static const struct iommu_ops qcom_iommu_ops = {
+	.use_dma_iommu  = true,
 	.capable	= qcom_iommu_capable,
 	.domain_alloc	= qcom_iommu_domain_alloc,
 	.probe_device	= qcom_iommu_probe_device,
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index b0cde22119875e..824350551e5933 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -825,7 +825,7 @@ static struct iommu_domain *exynos_iommu_domain_alloc(unsigned type)
 	/* Check if correct PTE offsets are initialized */
 	BUG_ON(PG_ENT_SHIFT < 0 || !dma_dev);
 
-	if (type != IOMMU_DOMAIN_DMA && type != IOMMU_DOMAIN_UNMANAGED)
+	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
@@ -1396,6 +1396,7 @@ static int exynos_iommu_of_xlate(struct device *dev,
 }
 
 static const struct iommu_ops exynos_iommu_ops = {
+	.use_dma_iommu = true,
 	.domain_alloc = exynos_iommu_domain_alloc,
 	.device_group = generic_device_group,
 	.probe_device = exynos_iommu_probe_device,
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd533c..bb34d3f641f17b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4165,8 +4165,6 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 	switch (type) {
 	case IOMMU_DOMAIN_BLOCKED:
 		return &blocking_domain;
-	case IOMMU_DOMAIN_DMA:
-	case IOMMU_DOMAIN_DMA_FQ:
 	case IOMMU_DOMAIN_UNMANAGED:
 		dmar_domain = alloc_domain(type);
 		if (!dmar_domain) {
@@ -4761,6 +4759,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 }
 
 const struct iommu_ops intel_iommu_ops = {
+	.use_dma_iommu		= true,
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.probe_device		= intel_iommu_probe_device,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index de91dd88705bd3..877ef0a58b07f4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1618,17 +1618,32 @@ static int iommu_group_alloc_default_domain(struct bus_type *bus,
 {
 	struct iommu_domain *dom;
 
-	dom = __iommu_domain_alloc(bus, type);
-	if (!dom && type != IOMMU_DOMAIN_DMA) {
-		dom = __iommu_domain_alloc(bus, IOMMU_DOMAIN_DMA);
-		if (dom)
+	/*
+	 * Keep the DMA domain type out of the drivers, eventually it will go
+	 * away completely.
+	 */
+	if (type == IOMMU_DOMAIN_IDENTITY) {
+		dom = __iommu_domain_alloc(bus, IOMMU_DOMAIN_IDENTITY);
+		if (!dom)
+			return -ENOMEM;
+	} else if (type == IOMMU_DOMAIN_DMA_FQ || type == IOMMU_DOMAIN_DMA) {
+		if (!bus->iommu_ops->use_dma_iommu)
+			return -EINVAL;
+
+		dom = __iommu_domain_alloc(bus, IOMMU_DOMAIN_UNMANAGED);
+		if (!dom)
+			return -ENOMEM;
+		if (type == IOMMU_DOMAIN_DMA_FQ &&
+		    !bus->iommu_ops->allow_dma_fq) {
 			pr_warn("Failed to allocate default IOMMU domain of type %u for group %s - Falling back to IOMMU_DOMAIN_DMA",
 				type, group->name);
+			type = IOMMU_DOMAIN_DMA;
+		}
+		dom->type = type;
+	} else {
+		return -EINVAL;
 	}
 
-	if (!dom)
-		return -ENOMEM;
-
 	group->default_domain = dom;
 	if (!group->domain)
 		group->domain = dom;
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index a003bd5fc65c13..a22df69f7f4775 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -571,7 +571,7 @@ static struct iommu_domain *ipmmu_domain_alloc(unsigned type)
 {
 	struct ipmmu_vmsa_domain *domain;
 
-	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_DMA)
+	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
@@ -866,6 +866,7 @@ static struct iommu_group *ipmmu_find_group(struct device *dev)
 }
 
 static const struct iommu_ops ipmmu_ops = {
+	.use_dma_iommu = true,
 	.domain_alloc = ipmmu_domain_alloc,
 	.probe_device = ipmmu_probe_device,
 	.release_device = ipmmu_release_device,
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 2badd6acfb23d6..e27cb428bd9583 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -636,7 +636,7 @@ static struct iommu_domain *mtk_iommu_domain_alloc(unsigned type)
 {
 	struct mtk_iommu_domain *dom;
 
-	if (type != IOMMU_DOMAIN_DMA && type != IOMMU_DOMAIN_UNMANAGED)
+	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
 	dom = kzalloc(sizeof(*dom), GFP_KERNEL);
@@ -936,6 +936,7 @@ static void mtk_iommu_get_resv_regions(struct device *dev,
 }
 
 static const struct iommu_ops mtk_iommu_ops = {
+	.use_dma_iommu  = true,
 	.domain_alloc	= mtk_iommu_domain_alloc,
 	.probe_device	= mtk_iommu_probe_device,
 	.release_device	= mtk_iommu_release_device,
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index a68eadd64f38db..fa3ec38e5244db 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -1061,7 +1061,7 @@ static struct iommu_domain *rk_iommu_domain_alloc(unsigned type)
 {
 	struct rk_iommu_domain *rk_domain;
 
-	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_DMA)
+	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
 	if (!dma_dev)
@@ -1184,6 +1184,7 @@ static int rk_iommu_of_xlate(struct device *dev,
 }
 
 static const struct iommu_ops rk_iommu_ops = {
+	.use_dma_iommu = true,
 	.domain_alloc = rk_iommu_domain_alloc,
 	.probe_device = rk_iommu_probe_device,
 	.release_device = rk_iommu_release_device,
diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index 219bfa11f7f48f..fbff1831c16e78 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -136,7 +136,7 @@ static struct iommu_domain *sprd_iommu_domain_alloc(unsigned int domain_type)
 {
 	struct sprd_iommu_domain *dom;
 
-	if (domain_type != IOMMU_DOMAIN_DMA && domain_type != IOMMU_DOMAIN_UNMANAGED)
+	if (domain_type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
 	dom = kzalloc(sizeof(*dom), GFP_KERNEL);
@@ -406,6 +406,7 @@ static int sprd_iommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 
 
 static const struct iommu_ops sprd_iommu_ops = {
+	.use_dma_iommu  = true,
 	.domain_alloc	= sprd_iommu_domain_alloc,
 	.probe_device	= sprd_iommu_probe_device,
 	.device_group	= sprd_iommu_device_group,
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 5b585eace3d46f..de2a033f65197a 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -671,8 +671,7 @@ static struct iommu_domain *sun50i_iommu_domain_alloc(unsigned type)
 {
 	struct sun50i_iommu_domain *sun50i_domain;
 
-	if (type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_UNMANAGED)
+	if (type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
 	sun50i_domain = kzalloc(sizeof(*sun50i_domain), GFP_KERNEL);
@@ -827,6 +826,7 @@ static int sun50i_iommu_of_xlate(struct device *dev,
 }
 
 static const struct iommu_ops sun50i_iommu_ops = {
+	.use_dma_iommu  = true,
 	.pgsize_bitmap	= SZ_4K,
 	.device_group	= sun50i_iommu_device_group,
 	.domain_alloc	= sun50i_iommu_domain_alloc,
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 5b8fe9bfa9a5b9..8afa21a9c0b9d6 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -642,7 +642,6 @@ static struct iommu_domain *viommu_domain_alloc(unsigned type)
 	struct viommu_domain *vdomain;
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
 	    type != IOMMU_DOMAIN_IDENTITY)
 		return NULL;
 
@@ -1018,6 +1017,7 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
 }
 
 static struct iommu_ops viommu_ops = {
+	.use_dma_iommu		= true,
 	.capable		= viommu_capable,
 	.domain_alloc		= viommu_domain_alloc,
 	.probe_device		= viommu_probe_device,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 46e1347bfa2286..954db8e77491c7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -277,6 +277,8 @@ struct iommu_ops {
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
+	u8 use_dma_iommu : 1;
+	u8 allow_dma_fq : 1;
 	struct module *owner;
 };
 
-- 
2.39.0

