Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4B647734
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiLHU0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiLHU0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:41 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66F07E82B;
        Thu,  8 Dec 2022 12:26:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfKRmxj2Qptq/FkLQlqd87DQH90RXY078NNH6f03BkKqeOD57lglHPURObeOlszRvA5oKJeVqWAdxbM3Nhkls3w5K5/9yRnVJMo9ln1qNVDq1esTjNu7UbmhNBRDrbjIqbHdQ08PrgYU/hdLkm5J6M/rZP9txyFYByQzXDIKmKMub0HYZaaTmyP6oqdWTPIFmyzf7cpNWW7UYRKl/VlfGQONj3qTKlLSm1q5Q6e0PvAGsYna/qHstN6nn02+d2Xy9MPUbfh/jFuygEDeiQ1ZNHSKJxIO+bGGn9zPX6CZ+1qeqFsEGfZpF3E4Bjk/6bxofR1nb0/oVq5M0XJUyLIuYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2SOl6aUd9d8UrrJwdUHbj6+FxqAlMf1+zsUj22N2pk=;
 b=UQUkSmT39djK7tJ2Cjz55+EEQssWfK3gTjpb/gZQ40R1LhaWfggBGJ2CpQ/p9wC+qgNvkMx1vnTgPsohmzKtkXDVJB3LHywtftlWRcwjWHillBHU6WmFzFIzIDc1U96adK2Vi8wd+GpOy9+akAaFn7ThzDT4nZ3roiJJ+nvCVZFQvZEhkUvKa5c2VKgJ5rSivlPj7y2wMgw/rXuo3kUvUn2RTjDEe5+UqqBEVmn4ne3yB+fOev6yxM4QIKGeHzGpc5YuIG05m8cappMzrSW0WTbPC0d9Ayl4T279CZiGoNKB5hupK24WBQuSoUTlZTH/nKVG1z36BIAduml3FMkmJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2SOl6aUd9d8UrrJwdUHbj6+FxqAlMf1+zsUj22N2pk=;
 b=o+ji7AUD/QXq9hQra9j66Xmo9wll9kP30TBPMJZyjSO+AIRiET+jWg8xcibGkTRziDsm1durPKucTEDT2agLYr+EdEqnYKpWC72BmYYS68YimUFneANyDYMar0Vm9mYREl8lSzOXvE86t8EgLGLk+zTtJJJLAM6k6DktjIWXMWUoQZ5fK0iAG5J36qGEUUanfDZaecPL6J9XH7OPdJ4efsHQLEuqvVfNf3xBQY3nFuibQ6jgbYwX5CoEz3IqoMuo20NsyRyZ25ANuK9fb4TPOQbzlzVzysKdt1CwvF1LS7Xt4BHLE6KJFfnZ5A26o2zfaIugywY6neX4Dp0z5mfJpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:38 +0000
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
Subject: [PATCH iommufd 2/9] vfio/type1: Check that every device supports IOMMU_CAP_INTR_REMAP
Date:   Thu,  8 Dec 2022 16:26:29 -0400
Message-Id: <2-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 50233802-5897-4d52-2857-08dad95a81ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I4JLfiQ86rGTi1ryPyL/9lctyVw8CgOsQpScUEEvoSHwzhUc/b+HPTEeRc8NmjPB5m5F98mYExDY8U/XckfWD6r6AUOOyPaMwm06YugUknZUg2n+0hKVVUug7ORe+L9v4kcjRzbjG3OhdiRjuDVPmTzBwjndLu1qlUSMSpNrC869h5Q0eg/k4DCsfeaZ+Q4fQTkssKB5J4Le9Sm9oaG9BfeuqJbZLw1Qoi2GRS4ylEGaKYF9Kg4fbU8wUi3mGMyBIPvY4Wn7ybcZwRH/IuU0F0PEFMbqSy6aUSjL9Omg/me6MC5m3nZ7U0uLBJEmxm6DXu+mCc+nmG4Wmxyk2QIZjpCYayQXuK/mMMXxf+60WpKGzV+dZ0v1foqxnMBuWl598MoSyZMh1kpYr5RGoXMz4QZmo9R2r/4GmN7RG4GLITrU9KzdPhX/l+yy8MM7r/9hF4OvcUXngxbcg7fjh3eoSPZ3KQGO76YAnqGkwSXINiXNj4rscvLnsvJsKALULHAvohrefWOeUkoMQyjYzQQ4UjkHlc3NSUsR1ujzhxKJfIIS1Fl/E7NG/y3p0KEwtIs+UcCgTeXnNjv0xIuvwM3cFvvKLJiyuWV30+usB1/iuoYo/aWU5sHOGFr7rqWjK73ZEpmbjR/aUDC0rDsVwtyewMhQBij8kmqBgPq3NR/8yjWBSrwhrWNWrlAaCPtGQzXHCSBuHJLF/z+0FNyz5pB48w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ZXu5dkNEz4bqv6JIE+YTtpN3P9lkJSTN2ubeZ13GxSK8LXNp5HlVlYUupsR?=
 =?us-ascii?Q?H7d2Pcp181l8hbtDasgbFckgE0japZVoQTpVGFjivIarB4QUL5z+1iiYKv6F?=
 =?us-ascii?Q?3wkY88pwTM3VeasvpqGMDhHLBO6QsrqgKVZaT93kGSzpm6s8wj8aD9+lyPfT?=
 =?us-ascii?Q?3AANqT0A0kGRcVpNB8cNcbTvW4PBGrK+HDPieXZEUnZ3xaCc4dlpLbRmjQM7?=
 =?us-ascii?Q?MCEtZMQNULNJUw4rqdYcrWRC0sA7Hw/MXm31hLF3aPJ+oavRYKOlHq2g6eAe?=
 =?us-ascii?Q?l2aWHpXEORYe+EcvoyY5eqTjiW+oAOdZJ+jjqUADsOBzvIGK2potHSGquZ+a?=
 =?us-ascii?Q?0+AcSKAyac8hBwRECUiH4yVQieE+72u9+YorUkHYalmWiemluwX5nGUj4ruh?=
 =?us-ascii?Q?GxEt7ouPvrV08dUIU4baW4tVpokB0smN2g6Vqhz0133RkUqebZDwK99eY1PW?=
 =?us-ascii?Q?JZLTuUR13GAGh9F9yRtPLfVHteBn7tVJ73Ymxdi3DivXvITUWq9yURCiT/I3?=
 =?us-ascii?Q?/vvchyIXQ9yxIDhq283IXwEf/dt2+poYkyHJh93IPITOkT0uZnbCIlxxphUd?=
 =?us-ascii?Q?6R3VSp08nbsOn/oa6yr9w0aC9TL39RwPygD12/t1NOmAJ4Nhy7W6mHGdOOHd?=
 =?us-ascii?Q?f9Ba/sHKYZh5EismpPmZjyRvGQMhNY+F9YJB2Fw1E4NDNrgPI1ytvAryf3BV?=
 =?us-ascii?Q?MBTaH421Y+c46O3DvNjN7OFi1qqObAxoDYojOSWJmMSIgv1axuU0Vw5LsKzA?=
 =?us-ascii?Q?Xy9/cBAptm4ENJ06BwVhCiOxSi2zNoS03iTqHmKnGfs9Et4ZyfYVuaVoVRhR?=
 =?us-ascii?Q?5amkzmHpasXBQgyim0MaXMn0v+0ngXJ+2aSIh5L6KWvIHwLJouqKX76t+RKn?=
 =?us-ascii?Q?C8qnK0xSLTQz3jbiZYPN+GnqSsJ8DPOMqoupymxbVnaxm/tTvY8flzVpELLo?=
 =?us-ascii?Q?0j1r+lTZIzlvXXMogVd/YPNQYyc+LxS2P6EBN6d2wrOrQH9ZiJM3ZfWXg284?=
 =?us-ascii?Q?Le/0fKhf8VvTGiQf8aN73FDO6ctpbBp3xzI0/WLvJNf4U2Hi6YlGU6tyUQdd?=
 =?us-ascii?Q?Fv1LyVJ3cXKPSt4+6+2B5MfjcOR23tNu1uf5UcxNsX6EExi7MMLwdmFj9Ue8?=
 =?us-ascii?Q?YQK2Z1hNdkzNUXDroI3qHcZzAzpGICSOHuoucCKNQUVEHj+A8hLi2jAchJRP?=
 =?us-ascii?Q?ivyyE+MuTUgZ9OvAWjHIQFrLAdxd2Ns9Qi49QvEU7FXUQT5tM6Q/Y9TYChuS?=
 =?us-ascii?Q?97AGOhcfxjC535pi+KRfxeOmXKkDL6tgql2M+iMLMm6NPG+d1dHj31L58PSA?=
 =?us-ascii?Q?Ot+ACSmRsp0dybLlNLy0LJWTEHv+K4Hkq4VpY5NmUC9KGMK5N30YoFOCvlCj?=
 =?us-ascii?Q?a9RJJdHKmk3b8I13GkBAQZvCkx4KlOv3VJMMpI10SHrv4uimKlSohCB5DbqX?=
 =?us-ascii?Q?jQLNytwY33Ps+S+p9RBowDUPHMhRzXb/UAKZq8MaKN1RO/V7QsQimG6/VANR?=
 =?us-ascii?Q?c1vbnGlDbicrcjwDh/926k7ScohTc+fc5b+RFpsbJpBqxUbqo16AYqLizzx5?=
 =?us-ascii?Q?rf1+V/CREboD2RJUe3Mn9rXnHaA99VYZnL9s9AJ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50233802-5897-4d52-2857-08dad95a81ff
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/ozVdE8hbTP+56t0pm81t6KDgwWL3dE+PBsf01eFsJRCG8dz7dO2b3idHR/Zi4j
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

iommu_group_for_each_dev() exits the loop at the first callback that
returns 1 - thus returning 1 fails to check the rest of the devices in the
group.

msi_remap (aka secure MSI) requires that all the devices in the group
support it, not just any one. This is only a theoretical problem as no
current drivers will have different secure MSI properties within a group.

Make vfio_iommu_device_secure_msi() reduce AND across all the devices.

Fixes: eed20c782aea ("vfio/type1: Simplify bus_type determination")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00d4..3025b4e643c135 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2160,10 +2160,12 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
-/* Redundantly walks non-present capabilities to simplify caller */
-static int vfio_iommu_device_capable(struct device *dev, void *data)
+static int vfio_iommu_device_secure_msi(struct device *dev, void *data)
 {
-	return device_iommu_capable(dev, (enum iommu_cap)data);
+	bool *secure_msi = data;
+
+	*secure_msi &= device_iommu_capable(dev, IOMMU_CAP_INTR_REMAP);
+	return 0;
 }
 
 static int vfio_iommu_domain_alloc(struct device *dev, void *data)
@@ -2278,9 +2280,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
-	msi_remap = irq_domain_check_msi_remap() ||
-		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
-					     vfio_iommu_device_capable);
+	msi_remap = irq_domain_check_msi_remap();
+	if (!msi_remap) {
+		msi_remap = true;
+		iommu_group_for_each_dev(iommu_group, &msi_remap,
+					 vfio_iommu_device_secure_msi);
+	}
 
 	if (!allow_unsafe_interrupts && !msi_remap) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
-- 
2.38.1

