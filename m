Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963FF65F49F
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbjAETgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbjAETfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:13 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8C117890;
        Thu,  5 Jan 2023 11:34:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgInahvDA/g74xa0Qw2Af6Ul78WPJGeBPqY28CehO7PwVn2oqGn9/dPNHIJhhCFiawakVeDycauXO8ajPIJS//7caVUCKb+aIRUKXYuu4QHMsY3y8xP2zXtve/C2MkTK0JJBkM2IKjxxtg4hH06Mh4fZy3jreFLYWBeLTfo3OvaytFkQhBBZcVm8WXfyVkXSxopcvGLn1lU1NPXokfX63JkQuYBJJ+41tGBzscNm5o9AUrwpjfbmebYNvCGx4nZH0731Kbx/6SM73NRh1FrZyv9XU4LXdAbHI1Ae2x/j2N4Un7niYRi5SaGBPqFIfRn+dtTNWh6QXq1kTvMApq/E/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZ+ZVwve1nnZe95+ZC0zjQXYD+Q1A6RwLMLYEtdXT+c=;
 b=BYq2ZfMGkyiV0zqrthA4R+pC/bw0PROV0vDcHDRc5HuLMgfgPaQVTDhAwxX9fg3O5Q1JN14RaJTm0xrKenDk2hCctZeH33A+BAlAHCboRaXMvrICfp4LyDK7aS52b6sVBhT2hauA8298cQKPRdC36v28NmnqnThM625tf8xv8mTHa99twPA/NP5c1HIoAathQUtwocDsgHxb/aYmNN49lyRlmTk3M6gubvP1XhFG7lg+iwSjca08mvWpKgKHiMH6C0Io4G9rMM4E/er3WazfKRtikY0aW0f9ci24zfISvMhtLmsx6tolK1jk1hyzMYalvPcYCiycEAoMrYGa7QlwIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ+ZVwve1nnZe95+ZC0zjQXYD+Q1A6RwLMLYEtdXT+c=;
 b=SjD36juiujqYyp9LUqsRn2LgneuonInJf2yreXuiQV23lD5rWRUEd41Ey29lbfWkM54EHtNMPVFAfPkZ/ggrzxwi4CYaukPUHk5FwGsVRlO9cntYvO6H67pIXYntjUdwIui4oMF0uZdfZmEQfyUwh0xYmUnjiO2P4xFDdfKsMoPhoYPEjPJDsN/+/rN5CBfvdryID376zJAB7mCw2EuKUg6+lhXqQglqC0KptR+F/2ROGsz3aope+6diuPqnXJZeT+iDXY4H5cRHeqqz1Ecvxfta6z/R3HnFSKm6dYL7d9Gvgc2CKB74Zh3v2O+CO/X4GT2lwt+hyVkoJ73tKc/JWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:34:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:34:01 +0000
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
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
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 9/9] iommu: Remove IOMMU_CAP_INTR_REMAP
Date:   Thu,  5 Jan 2023 15:33:57 -0400
Message-Id: <9-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:208:fc::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: cda4bbc9-9b68-421f-d3fb-08daef53cb24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vT2QNUgdNar6WYvaRfIE+RiPgoPfrJ8h2YiJy3ualIAdQag5XLoKdZN5Q1NXYaVlK9kDOZu8f9dJc9COw94qnGEYGWTwlVute+gr6wYWjs3zL9N1pVm2FTEPBbwCUnPKJTdczUkipfmZR8CziAtxyCiCZH1WK7GObV9Cld29/VaeaKbQQBEu9PptPyUnor41MCSLxpZMBWIfzGW0QcOEx30Wi+t/4TpYAGM8wUiQbMQBqbOBCkWTAzAHy6sht8FDIzeUmNKI/5e6X8scMj4F582kw7WB7s8UZSZOqAvzygCObNPRYUVz8onpiwD9vmdFjKc0fPLQnD4gZKt8PfcWQf2zIovDXgG2ipPiCNvRRdMpdFWWrN++N9uw1PMCGX6uR4Vf9w2e7KeDdixl9wW12aa6No8XezjNyv/6Eg0kB+6J56xkWxkrFyWNhhMpsYd+jMTarcR0E63c19d0CWzbvkm+FgWHfBkUiY1rGGBReO/4DdKl8aL3zxZ99ifU3718iun+YNEiB6QN6Px23VuGoT7JDplKx79Afc+KcyfxZWfrhzUCJsGQONb/hrzueyqhks3+aFJBbr/4tjJGZAMc1j36F6ofKCo+NXeqEK63jZEkgKJdewWqVfl7ajMUWt8Xv5rMVTAt3+C/9QRwkNQtHyWr1OppIdM7TDCIq/mN1tJBIiPY7Pzx/t+umEuXSxlpzijb4JbmKPFWKiNfh1YKaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(66556008)(7416002)(41300700001)(4326008)(66946007)(5660300002)(66476007)(8936002)(8676002)(110136005)(54906003)(2906002)(316002)(6506007)(478600001)(6512007)(6666004)(26005)(186003)(6486002)(86362001)(2616005)(83380400001)(38100700002)(921005)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QsgrkMXry//xfSjSbJOB5rTyEZw68wxNTXUEGxLgE9fAPspPFKZTEx1hJeAV?=
 =?us-ascii?Q?FqSHwt3GVly045DOXcjbSEN+J222NQ/r0QG37DkGsUuScTKpvnbsoQiA2xes?=
 =?us-ascii?Q?yZUVWEJLxuUXAuE/jR+v1jsDQ/8HU8vjYBxHvyM1U9orjRLjqT8xHzgE/qyp?=
 =?us-ascii?Q?E3DOdziLBjl6cFGvININL1nYSJpJxZjQarmMGaYWz1XQPMpyDwB/2Za5xRsJ?=
 =?us-ascii?Q?hAGx3mubQh25N2e4uhnFKwWPT09u7SxHN55/CwSSocxw7SvjE1Vvhy5bom9p?=
 =?us-ascii?Q?ZxAM2uoOSx/RPD2l1Fp7YDAIlGzFJuAiX7RrvT0MXiRGGGno1Bw62Wnj0K31?=
 =?us-ascii?Q?znfth83Ca56q6idPHAvY7RQVFxtNHxnxh58cpL6lVVntiJBklwVYfCd4uYpn?=
 =?us-ascii?Q?Va2uzzYZAN/25Da9I1zJcpSQFT37uzDABrw/GSohOo9Ht1zdHvb91WrTbyzc?=
 =?us-ascii?Q?SzEvOU4xb32zNljE2gLAl9U64RTNXCGxHRMIQVHk/DB5pR8NFqzTDxcTC6YC?=
 =?us-ascii?Q?zAbdJnd1YRC5XLO5rOrfinyDGgXdvJg0qX/mM0ASmKJ5RqD7mUSHoxE6O7zC?=
 =?us-ascii?Q?ie6FN5DDLCgXGPh0PyamcNDhubDgIZUj27hGZoBATYiqcZZy4IjEyfNWxfqZ?=
 =?us-ascii?Q?WW+V8gIfm+2WmIxgVwZBjYbBTxX3w5njIZOTesN0lnL6gAbUtCs9b6HW67zj?=
 =?us-ascii?Q?oVIO79cckGZJTgvIJuY1Izb2Y7ie/MAXJ1qZV96ZPpDEAM95r57YGFVXrg9u?=
 =?us-ascii?Q?6Elo6UGpjbJ42+20LCvL3xvl5UJ8tkelIZskXT+sBnXy7w1HgYriuahQVji9?=
 =?us-ascii?Q?HDe1jXWhgTV1cOVgFMERNzi0c0vBLfPU/5TeYj5FNo6hCxe7ASI5kyDix5xp?=
 =?us-ascii?Q?vTOv8pY5/YADW4uOezvFnR0ETZPFcx9MeALgx3yATni/X1/lfkhhE8SKt06R?=
 =?us-ascii?Q?XoXoYMBf1QhjYvGauv1MoBvwUliglxEljGN31bTT6QgTjHOm6Yd/tVwpYkCX?=
 =?us-ascii?Q?m9JZFr208e6GPu7/IYqqx9NY6KKmloSf+whdZ88AUzkbDWbxl2p4MS2JeGaR?=
 =?us-ascii?Q?reBH4ITl98aOlIZr1ZDs/31+4umc/JT0CURqLGXxTf+cDjFAqAUTt6iGZBWJ?=
 =?us-ascii?Q?U5nXHHNTDC0pFrBek0JR7KJQ7XJDD4ocOa7lUGiR3/gGJXaHO6ZIL9uODKPl?=
 =?us-ascii?Q?b7oOdXNCw4X0hQiy/VqZjsOJblqihuu7YP9ToUysbjPFIBmBdm4N5FHuMXWW?=
 =?us-ascii?Q?GtDfjeI53dzRINZAvz6Z81q7Y5KpGx/9nbcN6IkwfsOSVVQbnHBunpkNvIw9?=
 =?us-ascii?Q?rgWRPwT3MAA2y3PgRpMu2xUpZrFjjXbUkWl+Ehzd1WDlAx3Kv/rCBqIfEm07?=
 =?us-ascii?Q?Osb76WIwr4Ove2YegmnEaDQX3ZJnwSH+nwitzcuT7JRBxwI9xDcHtM597G7H?=
 =?us-ascii?Q?V+y1qMZq6PEGFV9FH4dirtRzBGdrByBJffrmKKadoVNvjMa0KPFHC2rMh9HU?=
 =?us-ascii?Q?UU7RQ86JrEa88JY4VJJ9GzPVsE89PkTidUgarFE/LKdrAqoJM1+Y030mIJE9?=
 =?us-ascii?Q?SzZn6QGTvPUpWenEDr31LZYDujZ7B/ButC4FrXqN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda4bbc9-9b68-421f-d3fb-08daef53cb24
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:59.7577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmVgf2tKUSiECJFMcJW83dOlwiwBMMtAb99LjF9wI+3lV+S8HCX0IGoasK8cRLoE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No iommu driver implements this any more, get rid of it.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 4 +---
 include/linux/iommu.h | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7f744904e02f4d..834e6ecf3e5197 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1915,9 +1915,7 @@ bool iommu_group_has_isolated_msi(struct iommu_group *group)
 
 	mutex_lock(&group->mutex);
 	list_for_each_entry(group_dev, &group->devices, list)
-		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
-		       device_iommu_capable(group_dev->dev,
-					    IOMMU_CAP_INTR_REMAP);
+		ret &= msi_device_has_isolated_msi(group_dev->dev);
 	mutex_unlock(&group->mutex);
 	return ret;
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9b7a9fa5ad28d3..933cc57bfc4818 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -120,7 +120,6 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
 
 enum iommu_cap {
 	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU_CACHE is supported */
-	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
 	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
 	IOMMU_CAP_PRE_BOOT_PROTECTION,	/* Firmware says it used the IOMMU for
 					   DMA protection and we should too */
-- 
2.39.0

