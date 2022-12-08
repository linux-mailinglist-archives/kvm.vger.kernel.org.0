Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BDE647740
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLHU0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiLHU0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC007E822;
        Thu,  8 Dec 2022 12:26:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNYE8w7OqBoyR+m8wYgUfeKvLp6o14+BvruW0qH17CnEdAjGk2zWesuAulaMyUiM9jkdWotEGKzG+Lf+INybA4w3UqM74Ya/D9Ztb/f/1kMjhwQpTxfFrOFZxFAjSZS99DAY236U7Y0IML7R7Ablz8ypY0Ran2uoeAqk34j5q1YZRCjntpq044J/qLZDiS3QkQ+/rN25IQxF76R16Q+nauXngP7vFa5NNteP2JlEURF9H3lMDxJzv3kTa2ZIBAH+bJmIWMxyhYL8sCc5AHFPMjImMJuVGaG3fQ0+EE9x14Eif3vLSiL38QEP9hxTtnFkopz76eXN2rPGPhhUMtPL5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omTI6TOnFBadJYpPmEgclxTrUD2dsheJKzz5Vmib0yo=;
 b=NKlO8shIJd5L/YsD4fCE09LlLV6ZG1YTdYrbM7s9mLOZx/f17sZF7kYPXw/io73gEIlru5lrgtm4sOmzHPaWs5SBk2LPKGvZWrKVu3VlnqUqtdwhAewp86yFuLZiUX0xmZFAF772yhw/ZbaFuH/oiHINjKBkgWRDo8OSLdFIrqsN1tyCaqG6/anGl5sG7gDBLtcG0Cd3+hCKYJkiKjtxfp6rcYLpK1OlkpJQeegru9xZUwXB9s+SK29q5sc0YwF7ztqImJeQCtBEfS7JZA1N6VhABpXDna9Z3qa1XX2gcpkDr08w7nBW5BaHyk8letfIaFlHIpzy82bZMYgIN7+toA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omTI6TOnFBadJYpPmEgclxTrUD2dsheJKzz5Vmib0yo=;
 b=GSnsD1umisuuQGWBJhdMWjLcAwOb/WyIRt6MNVh784E9c6NsFgOpvv8g+634Mx7EMb3iHWyJArdgilUYZG+CNoR0nYnzOnVv9+OxNxescoIRHDgL4dgbu/ompBIQkXH+zD5w29nFy4cRr0t6Xg3XS/MyD5y2p6EfDKtnXatecp6Txn5qEM1u+V1Qamk8Aqyi3Njn0i+i14OK3laqqgwErygh9DRr8Ll+xo1Tny51OtQdQ06fhxHcAFmuVsZ7B3oLP548hoeEgorgIfM5s6QZDwQdu7l5nv+oCtES4Yp/i9qqp5XhIh1eye8JI79/EV1Vy0Jv0NUhnfRVeE5gketoJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:42 +0000
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
Subject: [PATCH iommufd 3/9] vfio/type1: Convert to msi_device_has_secure_msi()
Date:   Thu,  8 Dec 2022 16:26:30 -0400
Message-Id: <3-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0051.prod.exchangelabs.com
 (2603:10b6:208:25::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 83dad2d1-e81e-412d-e343-08dad95a828d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KEO7URd870NapJ6ZUKdx54fUkAWnejnumJlwe55BEhgCtkTqW4E1yBdmIHQSKL76AtCHIvsf33ZEeilUq12GA2yoSWha6tZfpue/2dE92wYTZ4eQDx0Mty8v/q6mmCrofQzTPIM6akbJEOFY0DpmAz8GGzFpmznkOscf8/K46q/jbgYB+f387L2GmSv+MeFaXMmMmJE5V6dbo0YZq0kDJNdsrI3oakwnRtTSQlc/v3zHLh5NpBNENyJapqDG6azeNn8+/r/+SKzPTrIqiPPWHEKJvB/5SrVfo1CWTIr86Yj8LCaj8CHr2mZKUAPy6oFYGaugAhJT/fPR+YzUY3gZ4Zh6aw1l4Ub5fw5fYpqScDBgqVaO2BexBGNNX7j5C0CCat8nOLKTnZ2cxXqRwPG2Ub1L9McMgh/5MaBQYPjtHMyE7ArBYGIAG+fMtCPVFRJ+HnFNX5t8qHMBsqgCD8d7gnZPBEC+gpDPEAcc7ESISeDV0+HuQ94FE7DA5HtEoSzDQGLnebUpZpW9+Zz4TIa5VDkhzn5EcPuYVTFTPVeKuxNvfT7ECZ4h3hmjAp5tdd0pjFogaBBu/m9vixhjQzs8qDyopl+A/j5eD1w1rDqANO21uDwiLAX+LeaGyN3mlZWv9elqfK+Ltu5vgGmNS38ORvlbuSJiylKBAM7CQ5qAHjQIhx4JF/mAA2oK5fYy7cHkZQLKCWnZDPIoqXvTxRsBxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lpISRObjD91NR/JDeyBfV6omqOlIq6N3LGnGWVRF4Ff1qVIfsZGBs82qVH8l?=
 =?us-ascii?Q?qJJW0KBuFtoIXowBoarXOMtibUB+QSXH+Npqa6e9ZMgSfxxf6fE66l7M16aZ?=
 =?us-ascii?Q?MF5kYLEwl6K1Iq4qKuzjF/5/fnaw9dvZqiTaXM4TVrS+KbhAqGpdw5cy873F?=
 =?us-ascii?Q?daDzRn77XTBpkMfDigETCZqZcaIp+IAXEmGJGaT1kceKSJIeKA977UAZSpl0?=
 =?us-ascii?Q?/aG6Jq13uXm1qE6jrMXv0i9vjCrvH0adzFI0W5cESGUkw3M4pIG08LdncSk7?=
 =?us-ascii?Q?gLmvyyVYYDYa3kzX4w+RtPJMcTzJVtKclaTwiwb90X6l6gdCl02q7/g85KGP?=
 =?us-ascii?Q?eBp/0w5DeZ5d7OyhdpIqUHTxfzad7yAQf9jYyv/IBuTfGacI4zxvMD2+0TDM?=
 =?us-ascii?Q?c2/+q6vCzU5Cnn6gB/w7UY7XXKbr0/xq4ehBf8aw2ex+HnJGBq37SBE8mYVV?=
 =?us-ascii?Q?zgEyfJfGf2F12rr2OCwPQQ9/uuryKRvE4bA1jLf0gDOB7pq+fdr4vo3zq8qp?=
 =?us-ascii?Q?HIbfoK5J/zSoIjopAaAQyyg8+beaFgLWNqhFh2iSqqRbJEs7xJ1obvir808U?=
 =?us-ascii?Q?IZOwZ/oqiLprV5toUvgVD9G/2o/bLrj5Zu2yHVVvpC1zD0JxOOlkIgwq1NcR?=
 =?us-ascii?Q?iLShjVh8iEypZae6V4XxPsTdsz+BbAjGi1EytIMUK1GZ9vxEqgZeaqSFcP5i?=
 =?us-ascii?Q?/wGT+IHvB/MvhI0742/eADZmHojvmXdrzrzMeFUA15iyNK+DvbBKYoEQQ8UD?=
 =?us-ascii?Q?/z4fY3ovBGVuVISGS1BD5x5YT5qf+kElZ21J3q4uTMDFPf7EDHiRxiVng20P?=
 =?us-ascii?Q?eir1XXjZCzODR9ihNq8+LmCxhgU0kMOtj9rBO7f/0694lJBeb8L9+LwxEtc9?=
 =?us-ascii?Q?Zs+wADGioQf2dp7yuLZh//ydE53TebP5dXgIxhJesQqAuUortwrabCbCNEZS?=
 =?us-ascii?Q?gcbdRk28XdF0sODZl8jw0I4F9NozMOuvG72y/UCwhEBafQAL1d4ahp30rC3O?=
 =?us-ascii?Q?p4G1lSTAOVOU9C4/n1ux8X7knRccok6ftbcKWs13znxGpAb+pWk3FVH4QzVj?=
 =?us-ascii?Q?EgPxzmWd9CEYgvd/K5HLiEg0FAHnt8qSyT8oItb1OPogrn6aSrcuhf2vF5XH?=
 =?us-ascii?Q?VWwSrb20WwHcT+73Ey8/CQYy08g6GVgWFzr9Ku6IeiZF1SfPIbvOfzhZcaSY?=
 =?us-ascii?Q?Bd6XJXkhWRGdk/ljRNd2aeUd5LWw8S9kC41SC8DRxzSvAebXVS0ZQtDzGw6t?=
 =?us-ascii?Q?AuE2FZK/8qHt5WqbiQ3xkksUR9wGYZUxtnEH7kaWugaFkMt2NvHb+SE8I6Za?=
 =?us-ascii?Q?R96jSK8WQ2PHhbBVxSEsx5Ek4J2oKSENiZhO8T11xC77hnuhsTgadY/JcKd9?=
 =?us-ascii?Q?aEpb5GcwRpZfvcJyLloZuCw4LJ0u0RwVfbXSX2dkn4FCe17ZJYTInjj3FDLt?=
 =?us-ascii?Q?vjSVeVYVVt8dsJNBbD/zaxMQ72rw7JFKQKnmHi1aK6+5ZIEJnsidiWPRJszF?=
 =?us-ascii?Q?cSWkEoGxdGzgi0KpZehH9oPAgnMy12qI/nBM+XYcoCJ++HAmtq2iIsdU9+RV?=
 =?us-ascii?Q?3nSHQqBVmsDeP2czsGG50absGbLe31Iu2x6Bb+0Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83dad2d1-e81e-412d-e343-08dad95a828d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hedc6V1eeu1o/ZWlx0MKrZdyE/u6Pb8MUbz9ICRK4f4k0uEQLfbiN4mGAP/PYTQM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new API. VFIO can just slot this in the existing iteration over
every device in the group.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3025b4e643c135..a954b58d606766 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,7 +37,7 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
-#include <linux/irqdomain.h>
+#include <linux/msi.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -2164,6 +2164,8 @@ static int vfio_iommu_device_secure_msi(struct device *dev, void *data)
 {
 	bool *secure_msi = data;
 
+	if (msi_device_has_secure_msi(dev))
+		return 0;
 	*secure_msi &= device_iommu_capable(dev, IOMMU_CAP_INTR_REMAP);
 	return 0;
 }
@@ -2280,12 +2282,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
-	msi_remap = irq_domain_check_msi_remap();
-	if (!msi_remap) {
-		msi_remap = true;
-		iommu_group_for_each_dev(iommu_group, &msi_remap,
-					 vfio_iommu_device_secure_msi);
-	}
+	msi_remap = true;
+	iommu_group_for_each_dev(iommu_group, &msi_remap,
+				 vfio_iommu_device_secure_msi);
 
 	if (!allow_unsafe_interrupts && !msi_remap) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
-- 
2.38.1

