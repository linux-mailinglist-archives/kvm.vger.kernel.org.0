Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E69601678
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiJQSip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiJQSil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:38:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C572B4E
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:38:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByJr3HSljoQuizPBCcJPxhLpwrg87B/h2lqUgRaDpljRDhv4ydEDlXqpd0YllwINkDfP6FeT/2cuWpHDOFDIxTzOryEEuM2WOMJUcZF1P/kn/xCtUR7csi4LRo2vGZkRuPw2F8TkiSJaoJW3Oes5qP1VFha1ovQFJdQF/dXAWUE+bIVvHqI3qgJANHh6K/7zlxAHkXvYOsIxCRsAl2U5V6RblCofRr5+YQU3vGuuIN+cuBwDGB4xmCksWbcqDVMHkZcWor1ObkkEB1mujq2rl0movYQVXZQa0btsmUU9XjC8NUA2k9BA6n1YEql5hAtjfHVwLl3r7PtQhpR3lu2f3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfHsPSYnmz3e+lf6pEPiH2QlwvBho+C+pQWIXK0M5iQ=;
 b=abySBY00LH0hwuMX4jHi71zAh1F3VleUIM/2YmgA6U43wL/3uV8sg6LYY0wm2L1EvfJKZlrmfyBeZDVwPcVFfjv7S/09kDyW9N6N9KCgXcVKRChPP17dFXLA8HbQ2Wd9LCi/VbRtQFfpyxpw13tHs+CkMP/PdDkTRzzj1zrt43R5jviNAcac11z1ExunIYo8+4f6Z/KsvMXqfDyIwwmM9zw7a3r6sOIPIDpV9MY0LKQQ+hQRafoV8HHhq2umKCpI9FJAjkAklpPOUs2FEc1Pz4jWR1rcS+JTE9eOwv3790zbkfgPX9OtOFp8iuu2Hnq/eg0aTM9WadMggrD6M9Y3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfHsPSYnmz3e+lf6pEPiH2QlwvBho+C+pQWIXK0M5iQ=;
 b=gwLaiMpMJve0+IlEuV1nwGdFQVqEwX+a+nZqq0JsrdoIflqtgOn6Hgnj5tC0in5YyrMSk+yshWKxJoFRhhD/UJOULn+Lc1MqR4lefvf1L1XUVhOPveMbqIxNLYA0ZkX6iGDrbxomLL3houd2VoiKaWXIbT6d8NtIEnrXu2N4vjtohJJqWAO2v+Ke5NuQ0AecwDmkdTm2i/Yw1W2hv17Xhavdl4kIYUNi2XybPmv61UaYTOvz7Hyuvs40N/WhWD0lLqMWSC5eH4Ww/qzeC8Cg19vEk+bGd7Yh9VH+9CCr7YAvmtuQf/MkRH9Q2+HZMPD5Ei4EZkGEXwmlL3+OJTObGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:38:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 18:38:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 2/5] vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
Date:   Mon, 17 Oct 2022 15:38:30 -0300
Message-Id: <2-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0435.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: 533056b6-da66-447d-7d65-08dab06ecce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0uq5D8Yd5uLQq5wbjqc07h0p8LvsNqukk16Y0PPwTgY1DqfKOXr/fKuB3vistP8p3/0ISMpGE+4gM32FZwUe1U5QHwRycxz0bNJMeR2VuX1PYUUyiu3sd5Mh2E1aI0NXcEf5pTuZKrmzw48/7m1gNgfAkWF3d/WXDZwcDO+nivmo1zuf3nwdYiGS6Ek7SEMCyfJF0CMIW+0pQxNzRDDKKlxWmHMEz8AE7Af4a3ASEH4OgxxzqoUIwx1Q/MaAJwAdQKpznz5uLdWtgQmCqhE3Mh92rzaV/HrCULqHCIJBRVMCE42cK1PZxPEGXQ29XfIxNcSGIycHbvd94I5bPrds7L+J/ySz32TBkzGJQQlkUFTZ8BiR0Ff9ucuUOSAby7Qk6VsEYYBV2PwZQ4weRENOUjIdkR4hdpW7d3F2OCu/owfG7p+kzUzjAsIZarmMhy5Pd5mVosqpJ7k+MpK2vpP9YtuoXpE6dOpphoHac93aOryQldxIwsqHFvZndaLvLHypi6rJsH8jFPHCOTGs1YYc3q9cCbJL5TLkxRAgFQVll1PGWZWO/BP0KT0egWMK3Lq+VK0xmmDWd21rBlIxE7poqbhscm2mVHm6ikbnZRoNsWw/tXfXflwWxg+Ym3uJa4uZvlyZrIGxGVVxhXBSFu790uKXzQ5zPpNCKb88gtRDXRAy6Qi60Yojy8RgZSbOE/mn9ivMzWYb/ePxBUel24cZ/pZnncZcABeK7LjNzRsoJ6OHDMu0rmyiktZeSTRPfWF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(316002)(110136005)(186003)(36756003)(2616005)(6506007)(2906002)(8936002)(26005)(86362001)(41300700001)(83380400001)(6512007)(6666004)(66946007)(66556008)(66476007)(5660300002)(8676002)(6486002)(478600001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x4DsRJ0SRp/+qI6R2kCdYyUjXvhrmGfha65vsbfMdP56BZ9J0AicCSryiQTg?=
 =?us-ascii?Q?neJxB8T9xj06s/V0a3WfDvpHhjMsr2wrPwO0PNKhKYp4ePruRW70THjElyl1?=
 =?us-ascii?Q?DV0Bl7tvkLcddi/XGGgwxjP3ux282VKxfoBdVLc+AsSg5ST9p2i60QRUKJs4?=
 =?us-ascii?Q?QpxutEnGDP//w/cC2zqI7GJpDe1my0pzKASPZfHF1YH7EYXfloH3FOtgUql8?=
 =?us-ascii?Q?c8r9gqg2VF4lg2adh8o94CMB2DzRIpRPIYHJXXOIDNGuCRnAymqJMspRA32j?=
 =?us-ascii?Q?zyMNUUuIyef7NYy520DbhMrJ0yqeX836k2aUvtY0Q6PzsnPKjp541CHC9MDI?=
 =?us-ascii?Q?2/J2zd9kJsHbM34/wF62JmbsNSkt8P74Z9jKpRf7phzvgx2hCOpGV0HtXwzs?=
 =?us-ascii?Q?HjfNaHIPkCpT/gGovUPVfT3sbw6dKY2fiLJNXfws4QDEOyKIEwWCwgLKLGf9?=
 =?us-ascii?Q?e9LwShzkuMZp/oJJEyMu6mRZQB+c7wRJPVDiLmjwgcyxKMoxqXbmNZC65/2D?=
 =?us-ascii?Q?39WasBgIRd8TV+vVPGTxN8wDmFabD8gK/+ZNMvJdsBXdYuVa+NsMM5tcZdQ2?=
 =?us-ascii?Q?Ews9hQFPwZoxKtEpM4hZniidZh+uCVVBHyUA8LJLWqWTCw4Kh17gF8Bojy9l?=
 =?us-ascii?Q?tNxlxTmdfnMG/yTF/eczzKdbBVvHQ39l6pfwAa0gtsE/pCgVKV8stagkOZJc?=
 =?us-ascii?Q?qGt8jbDE6P0zeGxdPKWQeafUji9Uf2zp6zQDg50obQi8CVE673DAV7wm23rB?=
 =?us-ascii?Q?LjBk4A0i8j0xaMFVv1Knq889riXhYwP2Xy5MKBMq6kWB1MAFPNi1r8pgZA7L?=
 =?us-ascii?Q?RcuY109WXsHgkDGpWKyVcKu1MvMkfuuVTycf32yUJOuPyfWp947kQjylpf+z?=
 =?us-ascii?Q?mQJCfmDGeLfnOgtUBYif879ezADpFnRezu3Fu2OD7YyVnRHQNalvrs9R0wfJ?=
 =?us-ascii?Q?tVBV+ZF00lqJWfMjW0RCAHmd4fE9brJLT8LUmDFYf1OFNmC92CKRz/DFlZ/P?=
 =?us-ascii?Q?3TjC/NehWCJI2B/ot/g4bUsjksqAk+9XxWDN6Js5tXQ9HgeapKLZ49aTQkym?=
 =?us-ascii?Q?TxfzLqSzEr8sSY51+qzKTd3ny/8GTt6nForMTYEy1NCN/oqCuKPFhBUusNoH?=
 =?us-ascii?Q?qELB5++fUVNqN9vzL/sT2SzI5wbHWhMzFkXM2HSXSdlsuN8nx2FpItgRr7Ad?=
 =?us-ascii?Q?ilbxzcSDE1wPPtc5NezXrsrqM3R93QubSxf+R+fdK69oV24R1bCBW/kUMvey?=
 =?us-ascii?Q?nUugsaT4tkLj0LnolfyAO7DOqjTyt8RIDDzgwpWbZlQzMFWBC+73H8PhnVCp?=
 =?us-ascii?Q?AIUXTWl/GT2jv1CloV31OL7g6ou9tCs19+fu2PWulFOQ8iXPCG/cjoEceyzX?=
 =?us-ascii?Q?U6jXGW1Jag3BN34JDXrXHY28kvxEcHduft1tJiqqbUD+XxpXIJsJxyPRyeCk?=
 =?us-ascii?Q?A2wGcRkrzHsQ/lGhAQbjdGwd6FYDphaBIEnwwpbtjDCrLeGPxdxePAvfgRNu?=
 =?us-ascii?Q?QymZKivH5TKiwxHOyit10cM4WRRiruuxqBZaL4RmRUJa4iZJqQkCVqGZELRr?=
 =?us-ascii?Q?4HbfGAD01YviqloI40s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533056b6-da66-447d-7d65-08dab06ecce0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 18:38:35.7907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExxIw7eaQLCE6FSEwIZyl1Z6OMcDxpx9qYjOJCLa2wCTD9u3d8vpKvdIWoHUGENC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PPC64 kconfig is a bit of a rats nest, but it turns out that if
CONFIG_SPAPR_TCE_IOMMU is on then EEH must be too:

config SPAPR_TCE_IOMMU
	bool "sPAPR TCE IOMMU Support"
	depends on PPC_POWERNV || PPC_PSERIES
	select IOMMU_API
	help
	  Enables bits of IOMMU API required by VFIO. The iommu_ops
	  is not implemented as it is not necessary for VFIO.

config PPC_POWERNV
	select FORCE_PCI

config PPC_PSERIES
	select FORCE_PCI

config EEH
	bool
	depends on (PPC_POWERNV || PPC_PSERIES) && PCI
	default y

So, just open code the call to eeh_enabled() into tce_iommu_ioctl().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++------
 drivers/vfio/vfio_spapr_eeh.c       |  6 ------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 169f07ac162d9c..73cec2beae70b1 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -785,14 +785,12 @@ static long tce_iommu_ioctl(void *iommu_data,
 		switch (arg) {
 		case VFIO_SPAPR_TCE_IOMMU:
 		case VFIO_SPAPR_TCE_v2_IOMMU:
-			ret = 1;
-			break;
+			return 1;
+		case VFIO_EEH:
+			return eeh_enabled();
 		default:
-			ret = vfio_spapr_iommu_eeh_ioctl(NULL, cmd, arg);
-			break;
+			return 0;
 		}
-
-		return (ret < 0) ? 0 : ret;
 	}
 
 	/*
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index c9d102aafbcd11..221b1b637e18b0 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -24,12 +24,6 @@ long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	long ret = -EINVAL;
 
 	switch (cmd) {
-	case VFIO_CHECK_EXTENSION:
-		if (arg == VFIO_EEH)
-			ret = eeh_enabled() ? 1 : 0;
-		else
-			ret = 0;
-		break;
 	case VFIO_EEH_PE_OP:
 		pe = eeh_iommu_group_to_pe(group);
 		if (!pe)
-- 
2.38.0

