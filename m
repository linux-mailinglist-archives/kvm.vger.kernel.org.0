Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2A063C93F
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiK2UaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbiK2U35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:57 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DC663B91
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdennzS66KamFgqIH2UrUvhcJyp/wNMiBLirQav6A7BRKGaVm5dCpsMnZEu8yN9CzwAO2G+hrCbZanAI/LxVyjUcULAuLZK8Rn0VDlXGi6QgzZmW96h+/9PgdDlpDNBqbjtc4b9ifZjJCqPwN/TZmqlyBWwhjtyxQ/+SIgCMMmWaCI4itIj6leh0lBRZKYzslZB1/jeX9vCWGzo8V3FDqSmo9p+xYQPbSkBf8bTDrn8Yl5MJOopzSDjOd1x1xOGnhbgd3xmIjGulVbw2qVTr3z5V5JlMi3OpLj0tdT4ZxAFhdn3f5PTWDgCwEEdr1L0ZGlkkmg1kZWuhZjZ9kYmGAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YidnoPVb9GZplIRvyhX6uRCkFtNXGCPe8GydSWCHYqw=;
 b=HIWIuE6NwNfoC0W1+m3jrdBS0DvCT1/yzdOg+Gn78sLPkGPkuUIJFTCXnLa0gq4Fk6t9dTBBqs91Kr/aO7xrFGJAOrwbSNIbsUdzYaoysI58QjnF5uy6lFi2rjPyk0HQELRDKZg62Cg5GKBEDS347yATrC+1v34YFab6duMI5vOgr3Bs/J8yrOjJ/kFRwjgwkZoIgdLLnaQmrSCsO4MK9z9xIZdE/v/45RC7rGON/NGYKNcBLjUbO48cVpXbbehLvXwpxuxvf8U/MwUqr7/R50nvL+b7uGeNU6HiJ5xN8uJ/tC//mP+NHeJserEb2Gj4mGH80NKXrkSwfcjPDnII1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YidnoPVb9GZplIRvyhX6uRCkFtNXGCPe8GydSWCHYqw=;
 b=GfVjLBkgItPcgqv5EssbdMr6hJdT4ethU51tTNZ6rzl2B00A9acwfA/1hXYhuopewR/P6JgpW77TAWSncEnXM4l5/EDZHwI+q6ApdGzoS3dfoCeMXEX39rXpe7kyrOZoS+blAZH5Ubpv1OklA1YWmrZsBM892r4wPL1dHhPcJEMCoyu5ykUb1ajXNV94Z+EYfDtmCttjvHiyuFTBkUZtWoAf3hUiK8KA5Y4brdyxCKzJ/cje7htLt4BAY66ohew/qSXi0sxNwDzU9WUgiQotHxP224gICo3GYKL3exibng9PyHenqF5xd/JNe6JruL16ZczVHNDd3gOX2UstNkzQpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 01/19] iommu: Add IOMMU_CAP_ENFORCE_CACHE_COHERENCY
Date:   Tue, 29 Nov 2022 16:29:24 -0400
Message-Id: <1-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: e8eeda37-5665-43d8-d9d1-08dad248758b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9XHHizf4kXYouYJBzhcexvlSvarfF0iFs6n6R/M3a52szQO07ppw+yJaGhAC+MsOPokWR5Ttk5VNsAZbN90WE7SdrCUVh0oHCcicklCLg6LC0dOY/RHr9NG9WVj+kuha0+SLu2vXy/Gtm4bGlu9ppkUiT9RI5W6QBB76ryxURb2qa9scblUgepmGAAznX6AUkcX0WDAMr+KIKszuDcLahsRuxS0Id4kx6W92ZNSx+dnqgzQ+P8l4Y4ElQncSBAMPllLTvyc5IAG4omTN0/tRennR2XG91EPTX0lbMywIxQem+8O4LL7GckYg1mLIUc+kLyOUmHkMPGrcHrcmbQFg3C83jjLn0h1FN6ugUXjfg20H8A93URCQsnpDez8crVI8XlSnPwu+ula54X7ALaUlZyuAcvvDfHK750wMAET5/TIOI0dDeWzBr9mZc5H0j4wAWpLL99DVscF7IB7R3ua0ReJpnTD3fT/3WeJXCOniRREd89evsvPvdVxIvfHvbAkIG2ayHd1rfY7IK22csgjBTpZpsVqBoO3oYUMdFoXG0zvXVwlLNY1SVXhEdagQ0v3ZKzD/48ao6Ra3eoxUsLknplpOa4VtpmMdTZJEXoXtyPh0lYVw6SjMpagbGaRM7AeEIiY5e+vXAo0K82J7EuWr7RXKCNlZEmSkzE8QIfy0tCKp/qHMSw+64MOOz3hM/Xxp9MeQ9dZatcGzG2ek/MXJVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AN3dBAR+4dkElX7Wz8xEjFR339niJXEQmESR4KwkPkIEWLpSiFZayYjZuw9I?=
 =?us-ascii?Q?kV4E9hLxXWg+fen1NANk+GrZdYaz0JcT+I52Anz1LL7w0jKxUp54wcpNEyXN?=
 =?us-ascii?Q?pX3AJLI4XXKF5shi04XwhnzuT7CS7IZVcpRQ1PmhR0ce41O0kjVw/pnKSbmN?=
 =?us-ascii?Q?SenJI0LrBdJ4IpDztzEnusJRvF5ts1DD3BmmxqQWRMfhLRJY0xjzunxWoebS?=
 =?us-ascii?Q?y0uTJD7eTab/R97GimDbWGy30KThQLKu93BUBuhH2U/b7z4XcU8tdcOhcKu8?=
 =?us-ascii?Q?J+qJp8s1tOxeeN+hK1tKf7YfPpejGEKTy/v091AaaqwFtZ3djB9keTTxc6ii?=
 =?us-ascii?Q?gZsJJryFHNC/rkNJfYlsdkdIdMhg+rMsj7dq/RPZRCEwn704cALsKTQeN1/f?=
 =?us-ascii?Q?ZJYrJCSAghys6JZU2lKPg9VTFKsRb3kAOc4VMtk+kPAWu3/1bLCFx+I3Attj?=
 =?us-ascii?Q?mTHh5REfRp0Og5T5HDP8t1Ayx72MAvpP10fZv8K+u1VglhUjtmlidGpncmeH?=
 =?us-ascii?Q?Wmk+G21zdkcRp86Oo+qj6OmCES6V8OqQunhnYyXDwtevnboCtCHppkOn8747?=
 =?us-ascii?Q?w9HfHGUpFurzYK5I5YXDMLu0ZsH9e7YUOv5moi4aXVGI/IVJ+/0SVdzOPQzL?=
 =?us-ascii?Q?/gJ8WAxFJ8JxRckZmMABTWZZkFxbqP4J7h82KTEUGBZ69vOnW2qKT9rmq1l8?=
 =?us-ascii?Q?K7ZGU4NblIr9R70cM+a+6gS86LwSGTORPMyogCkGl4gQwhIblNcJz1lgZQLc?=
 =?us-ascii?Q?1BL5NNnEhyj1IOfPjL7htuDH+CIGP3HBbgezEUUzWrsx0lnhfy3HQ8/ifK+0?=
 =?us-ascii?Q?KbsP203OzhKiWd9uPNhdYRkhfIaqGM8jM7S8xTqG0U71zcIUTfttELNNiJlo?=
 =?us-ascii?Q?bAjMa3aRmsVyXhcGppqbBrUx2ZMUNmE5z/Ku++WrBUxiTi26rnqwDhRM3J3D?=
 =?us-ascii?Q?pER8BBd0lQ++QzACYmI89IhZvVlmQMLi/9oKSHdubXAJDOJcd7kuNH9MXV1w?=
 =?us-ascii?Q?RgvG4bvXbYIZIwt/QtPTSMWqIprzgxnfrBwfy6N4vxh04Sc/RrngOo98XYz+?=
 =?us-ascii?Q?ugPndQn2stuILhyGMm0pStipLBliSXnT2mqQc3/N7YxkNkvgUJoQii0JfOD8?=
 =?us-ascii?Q?3G99x+aSBa/978cADZ80Ij/g+8dDlZw52+/jd4SmxfhmdIwbmUoQVnHuuMK8?=
 =?us-ascii?Q?/BMf0Nl848QlT6Q2/VJOlwQUAV+kCTGnGyBoBC8Ih8kiRWuC7gUL5cJRXaW2?=
 =?us-ascii?Q?kLhVvm0foVhWvjmTZKsB0CkTu16wB2DJIWb1rNNRb5Abwqvmo1jHU0/oaHr1?=
 =?us-ascii?Q?2GzXfaHFi9nHcGwuw/gUpBRihEPwVy880xaIvlo2qZ5y+J+lNaVh6fr9XlWf?=
 =?us-ascii?Q?RCh8CLTyT7NRHw3crSFI2QVblAgUmPxTH5N3bZVkl8mTysJJAVp6NftSdY+u?=
 =?us-ascii?Q?eam4SmW748aFuiUyz1wbapgA25SrUZ+2xf9/sNpXaaEsmqj/vo6gFwlfXQ2L?=
 =?us-ascii?Q?B07mzCpqYpwCk9eBqdp/bjFgH5zv0oR4Plk5xk4PNeUL/b2V05skKvl300ny?=
 =?us-ascii?Q?/pv1BiFszc4v0sQnjVlguZNfI8hYmCICuj8hSXnb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8eeda37-5665-43d8-d9d1-08dad248758b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:47.9955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XusojNr6aFZnWKBlhHbLHUNy6YF0l4JSCh0poUSC9co5dJ89PujH19AT2obqIZpw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This queries if a domain linked to a device should expect to support
enforce_cache_coherency() so iommufd can negotiate the rules for when a
domain should be shared or not.

For iommufd a device that declares IOMMU_CAP_ENFORCE_CACHE_COHERENCY will
not be attached to a domain that does not support it.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c   |  2 ++
 drivers/iommu/intel/iommu.c | 16 +++++++++++-----
 include/linux/iommu.h       |  5 +++++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 45299eb7e8e306..240c535e317cc7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2278,6 +2278,8 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 		return false;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
 		return amdr_ivrs_remap_support;
+	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
+		return true;
 	default:
 		break;
 	}
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f298e51d5aa67a..157c9727411076 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4450,14 +4450,20 @@ static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 
 static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 {
-	if (cap == IOMMU_CAP_CACHE_COHERENCY)
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	if (cap == IOMMU_CAP_INTR_REMAP)
+	case IOMMU_CAP_INTR_REMAP:
 		return irq_remapping_enabled == 1;
-	if (cap == IOMMU_CAP_PRE_BOOT_PROTECTION)
+	case IOMMU_CAP_PRE_BOOT_PROTECTION:
 		return dmar_platform_optin();
-
-	return false;
+	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
+		return ecap_sc_support(info->iommu->ecap);
+	default:
+		return false;
+	}
 }
 
 static struct iommu_device *intel_iommu_probe_device(struct device *dev)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 68d7d304cdb761..a09fd32d8cc273 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -124,6 +124,11 @@ enum iommu_cap {
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 	IOMMU_CAP_PRE_BOOT_PROTECTION,	/* Firmware says it used the IOMMU for
 					   DMA protection and we should too */
+	/*
+	 * Per-device flag indicating if enforce_cache_coherency() will work on
+	 * this device.
+	 */
+	IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
 };
 
 /* These are the possible reserved region types */
-- 
2.38.1

