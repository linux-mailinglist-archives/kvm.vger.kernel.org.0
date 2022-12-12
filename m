Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D336B64A77E
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiLLSr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiLLSq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACFC1F5;
        Mon, 12 Dec 2022 10:46:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3mutYlF7PuPz3ZHYSOcT4Y6V9rOzwdcaTeZxpJL6IX3RkFbiydEqgotrvUgH0YMeQBYcSmyMJPf85Ei3C4lafO19BgvaFw5k0hokZVJlskQxj739aY/7TfeUGd1CwZj6h+hr0GSGDOlukXpqJNpi+tyxqTLVbGU34t81TG2GZ3PgmLIU1cBs4rgIfIeylq3a2lx1IQVBuRD9ToYq8Yv4mzHpMxEHgEptX914pwheQqsQhD7DfLulHwVaD6xRMKFIjlmYKdGnqk2gfBW+EMVyhSwE2Ek6vpKz7/Xh1sLhu3VcB6Wqi/swY7VEHMcvJWnnuXslariCeOTfIB83gDrEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0jooCb75wNfCNi604bcyXhI4HXZuXPWGtaTd4aZbkg=;
 b=at4fMnA7ZtGWOMDAYhinxwruCEPxuTjU21dHYQJa8Da9CfrJICyU+3VWx1juv+S9XRlOlqzxYoOa5GqvzTARf9nT/UDOeM7NIs61jHCw7rSfM8uYigvpba/gyhEgjVxG1gM3v22CUS3tGq4HcX8SldCFrVUC5WMtQakPOqATmLjmwLCWuJfGonDKAsaIR01ty6Cnv2LecKiyhAjq209SrgOeczIdi8+iBT42FSvNnDFX8h6QlEwjUvU0Lfn0F0+6qEiZiyitF7VohYvEolmUoUin53/7zTtfGKkTQQfjsfWumzQ+8DZf56z23lsq4eWPhYhn6TvWu66rBhjTk1GrqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0jooCb75wNfCNi604bcyXhI4HXZuXPWGtaTd4aZbkg=;
 b=uqyzXNL8HFA8fSwsrk7KGaQldGdKVbM/hU/LCmWk7/wxr/5Eymwh+K4YXAgPZOe29WZjOpwQlDOhETx28eBZb0n3z6e0xEodNfTTWB1O31OqiQox1rG3zTYocwBW84UXOyTqEL2qjY6SzXJmVQnhrUjC/W2nNqtLOGie+MG/aRSBRwrhQiEXblp1STiOlxvlrw9x7IAOl+3k8VlVZzSOkC0ekBuJwHAnjFLLtbrvWycoN1d2jGgsykHr64EkNK478T6/dQpW18KyhpkiIQIxY2IJSvMvBKe1bG7T30N9M9CgYexzXUBdLp2Etic/6QalTCXLRIKL9P1/GjNhGExuTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v2 3/9] vfio/type1: Convert to iommu_group_has_isolated_msi()
Date:   Mon, 12 Dec 2022 14:45:57 -0400
Message-Id: <3-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:208:d4::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: bafd718c-6ddf-4f01-5165-08dadc712086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJTQSWXJww7Xr8pxzFa7EwVJfm2zGzITxoqMyo82Tqk1MqIyTQ2Ve4WPscJJKA6bUrW1Eg5QQ13i1zQrU6zprzb7ezcvAWSuNpxdpripK8Be0YmnmjNu6HGtTMIu1mxQ7BTzj9RdKi6bW2GfsmWQmbhyrdo1BaR3vKvSde8UcOVVAfmfonKosp9x3Uvqotb1vsYXr3LU6AAXZADIxucHVMt80c0a6BRMQprPPlyQ+E7uRatn3D0XA/rzV+1E4HW6ojwkFo4cYqIGhG3KjHtdBIBUdcEKJ8i9EYJAYwdN/G80QovxUZKokM8X5ftQgkAzIWDvKzfnyhWcC278RjKkVuJ/CGdAGXDnlp5tOIxYMuh7HZn2+Mk3lGGYeulX0ojFOwRFaDpd1JJatMCan9oneceZXWM2+xBQ1e+0n+FD6KiU87rIMmDJq/CKQ6xocR/nyMN+r3yELkDOg/18OTAiPPXXPDBsIgdn7ERYjRZSCUOYEroDRbzxO06XRqJIZBKM3eaFdedOlLUCM6mgTLsMru80amUs5QZThOucYNjv+2Q3y+9lXj8PkjnbN+TwATzQ1PYmCVZYQBCaAR0Qbf4L+9ckshAxxtu2MTcAb5a5lkXCXuD+LrFTKU+tMu2bvF7H5G9Q/IOu+SI4Z8z/GFe5VewU6A9acqdVw2fz9MLxJJAhrLQCtuNrlGNqzLrYXZ/UYuwihQEvFJUJf62KBYRSFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(451199015)(921005)(2906002)(38100700002)(41300700001)(4326008)(26005)(36756003)(86362001)(6506007)(6666004)(66946007)(54906003)(8936002)(7416002)(316002)(110136005)(5660300002)(66556008)(66476007)(478600001)(6486002)(6512007)(186003)(8676002)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jDFwu5nlQX2Y1ZwMPyQKnuVDuRjyY1yB5hbbsg5VujtftogL+eibA5SgO8v9?=
 =?us-ascii?Q?eWjvYOmMVlFQJs8GsJ5L7u+61NeZ4vUgNNe2DbL+a5s13hfptyOgNr2gvn5X?=
 =?us-ascii?Q?Vc4E/SYbNQQdoAvFjIJHf1b4a1Iwv3lvvW6uIKUcanS2fZr1cIAfmwuYGooh?=
 =?us-ascii?Q?vBP5cdcogi0LWgPuaBCSt1VZF0K5Ru5VL19wuL9rH6bxFlHOoLd2fumQj3Nk?=
 =?us-ascii?Q?H3gSmiZ/1jGLuWCAKfmCCPKuOp1nZbRyEunN9mTLEi5HMQDz6riOxBz08CEK?=
 =?us-ascii?Q?4F7hV1KVxyop4zqjdtXn9yGKWXivQDXHx96VYn8S9kW8JCgI8XOAMktsGrOd?=
 =?us-ascii?Q?jmwSfVRmskt+sFoWODMwLaw23bLNHcWwEysmlp+akfqvGcoXbayZ4f/5bjUM?=
 =?us-ascii?Q?MDAGpsfLIktE2k7VwZNxuPZ9uvDz+erK2P/sPQkZUcRXY8D8/4TngKY1y3Jy?=
 =?us-ascii?Q?O2/RTVBYC6teRLfKYWXb0TM+PNNVYU6hrswLrArb6TstRy8JWu5jxq9Adukc?=
 =?us-ascii?Q?DDZocS9i6Eh10afUA14eQIuLB/8XGdbl6/5VdotH3zi2q9vwpZr/9kP6ROub?=
 =?us-ascii?Q?wTB+Ofg5CNbRvGT29bkkq4a+tooQh8hRgKp1trnWhxaL7wrqaiPrrbVvW3uF?=
 =?us-ascii?Q?5ZMFCxy83ewH71xRDXbck1JFjixe03JrZ3Rq4uhRo77jSg3bsMd8Ohd5/nZ6?=
 =?us-ascii?Q?UfKqa3f5UqScJyJRvU1x3CIQRcyzpCtENN0qg9lP0ol4WHBMbvhjzPuyc1Pw?=
 =?us-ascii?Q?GVFpmHFPoTku5CLzwR53AdwHh8ha7mRFTaQ1mG9c9L58Cr6ms7WcsEY0z1Da?=
 =?us-ascii?Q?zq3guw/T6akMg21guoe2X/9AMC33Mxbnli+CXDnk1ZwmqltnKMq+qeAgyI8O?=
 =?us-ascii?Q?e+99WYIGEthm/hjdcgz6NH84HlwQrT72gTotnXqIedwS44PaHQbeSfXoCF+O?=
 =?us-ascii?Q?ZUJV9001+W1ai1p3NWvq3j3/Q7w3siSP/NE1KqC1Dr17FdZZbpf37GhJbq3A?=
 =?us-ascii?Q?5fqkRsRrJRKFhepsTx9ktkeK+iOovoum4QscUpXWuRz2kWPP/N09HUAcJPIM?=
 =?us-ascii?Q?XynGpj5ssNxX0eRIw4NC8IMjzoJ9wF7EgkT3DcuJey8AikEq1hQA4yNTYuuZ?=
 =?us-ascii?Q?mPNrL181a31B7XHzGlz0GaWCO6O+PfazeMfcHDVQUn/z0InFBWmKrXR60RNL?=
 =?us-ascii?Q?epe1qYKCsT6/R+2OgRVUSMmwsB9gG3HYAruXETYM9Dah6sJWaPdl5RbwFLR6?=
 =?us-ascii?Q?WRLbaom/sCHhdYGMlouMg6GOw7mx96iuE9M7F4UfjpAZBXJE/ROmgysTb1Yi?=
 =?us-ascii?Q?Omrcsgxum+JFf3xXb33Llg6PNvrrFwzgrD28QeykHI4dHRc+ZG3pUqx3ojs2?=
 =?us-ascii?Q?C4+bxC0nGY8rnukGXWLjbjkifPWccEuKlbHltipZzDN4r9/CXtsEFh3G65cf?=
 =?us-ascii?Q?zALO0sbPUs5sKLf54OJPh7ajf84wFTybUCKG+fycrMz5JJ8E+r4o8JEuDC5V?=
 =?us-ascii?Q?Zy1+0oHrF61RVnEGv078QLEW8qcFQ11o3iDDsz2L6+eP6zgxDiit3yCofjLT?=
 =?us-ascii?Q?NoRo9X9wylv69+Ovv0nTW8McKvBWjgt5oGhq4j4T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafd718c-6ddf-4f01-5165-08dadc712086
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:06.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYBky8jDhTTMjl+gbqicSfCtZHFQ6tk6kcNQQYXdcKAnBmxPYC42FM2xtp7EaTKT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trivially use the new API.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00d4..393b27a3bd87ee 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,7 +37,6 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
-#include <linux/irqdomain.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -2160,12 +2159,6 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
-/* Redundantly walks non-present capabilities to simplify caller */
-static int vfio_iommu_device_capable(struct device *dev, void *data)
-{
-	return device_iommu_capable(dev, (enum iommu_cap)data);
-}
-
 static int vfio_iommu_domain_alloc(struct device *dev, void *data)
 {
 	struct iommu_domain **domain = data;
@@ -2180,7 +2173,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_iommu_group *group;
 	struct vfio_domain *domain, *d;
-	bool resv_msi, msi_remap;
+	bool resv_msi;
 	phys_addr_t resv_msi_base = 0;
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
@@ -2278,11 +2271,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
-	msi_remap = irq_domain_check_msi_remap() ||
-		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
-					     vfio_iommu_device_capable);
-
-	if (!allow_unsafe_interrupts && !msi_remap) {
+	if (!allow_unsafe_interrupts &&
+	    !iommu_group_has_isolated_msi(iommu_group)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
-- 
2.38.1

