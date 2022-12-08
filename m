Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BCE647739
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLHU0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiLHU0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:43 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7267A7E822;
        Thu,  8 Dec 2022 12:26:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDy7sYIGdHwQIqaWppp+I6+rjhgIkkWj3fpsTes3TV41/O82ZutdVKpOiQD8NRVnz0Pk6Vm8D0ae7HY1QzdDpgply7KU8ZMMMjGjSZINZlPSS5nOgUcPj7xu1XzGZbIJedbboRMoA14ViFsKrBJ6V9d0UhJKr71OpDu/v+9MUpY0TWHlwMXsVZQMMYuVT7mKxGuA4obyiebiugTibpNBRiDpk84UwcsSX+ynDJ95qJBUeGw62fR4asqeX+Q5n31v1bkTz9JjqNghQXcRRAABkNWYAAByAdG1oblVTYmA25NF8Ckdrv9P+un3P/iZcd1vY3pBGiMr6IKO0O9O08+Mcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXqmnuSsu7GZSFVKHyVfR3w93jiBnlllVvlYTagL80g=;
 b=NpiyUfiz6/kPsO/b7SnOYYr2/vqjqGI+x6NrdEpDuW5gmQY2F/aKIxVddDwVoG5z7Wogj57RrOKA3m49rSj0pUiS6HfXFf6t3lSClzp+KFx9jEczFyxm1Kl4+cN7N7hG0oFX+0sYNXZqDYsQlzZ9TZHM4f6FFyb6VlEfUeyGVzx9XVkRJZjuvcJ0dktXKRWu4ybqX/skCZMcxbqPTY58gOKRkaQbKhySdR7xdMeC7xDFcP/RKvEWrQpelLsQU0YTPXQNwvYI4VoZ6HAbHLYcF8BMj4sQW6uhb1weIF/HcoIQeJ78QBa1NkHYlhAjnyy+tPE1m4yDELa40t8Gpbdzlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXqmnuSsu7GZSFVKHyVfR3w93jiBnlllVvlYTagL80g=;
 b=ddsAiQ5eIO/3nttaXy3ZQhsiGJcK9zuYYIHuXzTDemCV3ihqWogqYQIjdN0gYo0vICPmxTWmCxpHvB2zTuNpjEc0cRF/I9lgK7zwEp/6Be4fz/gPBCvfc63Jr0K7L67WG+lXpjyawCXT+hwSM22Vz6hVhkqPnjQa1PHIJvNWOKQqK6pCadKDSphvSHnv2/IljQHbxGTXBP0VglAVPLCheoY5fDgXPElh9B9x6krj78NPE7h8nHIZvMZ59rqLna+Z7M1FRet1mdU133ROe7YQ5J0MKbVQnTJ6bPYyX9KyAlridPgL9RIiMXrzN0v/kAWlVJ+L14iRvyzMmBhVpZPKaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:39 +0000
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
Subject: [PATCH iommufd 9/9] iommu: Remove IOMMU_CAP_INTR_REMAP
Date:   Thu,  8 Dec 2022 16:26:36 -0400
Message-Id: <9-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:208:15e::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: aa912f98-3aa6-4226-c610-08dad95a81fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDTfeM9/AWs9EANz1jP4nTt8FkRCXpkD8FmckaaSNO1OVY2uOdWuxg+EztrOgZgTWt1sIEVS/bqkhaVGaTIzhtNxks9AIxFloEXU33cpyuhFapJ4JzKjLCvajBtBHxReDPZVK8ohh/JcdeE+Q2vNgY+ia45d9a03fllaqM8RieiFUhcXasFWwsDFG7qQagN+vtc0BYnDt7Osp74naxlLFma10R/Ipg8xC60gSUEeBaC7VxzsH6YZ3kOsN16N2jFMKTO3zABImeIjvBjjPRh3nwobGSsYBLaAZJH4e97C46LMfaDHo3K8gpRJJ5S4tG/KZaXBueC8vuevhEUAu/8RWwY/ISwHslDxAOS2KrwRneaFrFwf8UJAwfS5aFLsV3Y9qByZGoTIN9Xe6Js6lTn8fA7NtlQsQx3LElCcSmB6RqLwqhXQ+YQs28f7vuWSQhZ/QseReNXnKSaxdIXMFhQsf4ZduaL2BkxjUo5t35/cN1HFspSFo7i8mnhJGyYy7mcGt0uikfKFnkOICTIP9AFCcCd0w/RnALn9g2xTKhZCLQ71nKGldkzRz9DhdjPupZ1FWyxb7l2BW07M9e5JFQ/RkURjlYZNyZDt/Gnr/6WzCLnRO9L6CT1us6oywAMZKQcfh5RxKkpEhEU2oXXzMeAKKS5i0+DZeiINtcGIaO80KIXII9bH7n1YuVzTEJRfXBtxVtlNmDNll5iUB1E2qqGf5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IuZK2KKybgqkhWDXpp0FuuLOljN5m6l/abFyICJQp4KFxI2qiPtelIoYrTK2?=
 =?us-ascii?Q?tQNLfYVIXQ+zG0StxMIn0T7eWxu4LJJBzJnCBasLGJBZeiaxLMk0+8dsYhfw?=
 =?us-ascii?Q?KlXPEOH9yW3jyXWEDPXWvLyF0MvsKbjxzjpIYnmW3PtPXlq5gImAEPNtzfcK?=
 =?us-ascii?Q?AyqsVx1KsF6nJHlbkEN7cEd5rlNRvYR+mpxvVgl3pidr/uKH9+Ekh5Cmdkz6?=
 =?us-ascii?Q?MUMT9m4OBe+Bn+RdFKhX0TicX2BC7Qr8FRBnUbX+okLoPIf0sFg10sY1Rrql?=
 =?us-ascii?Q?J6v4QBq5UZjEiMBcaaWhwrK2P/28aOp9iFOicvnjU0BPf47PTNkDWkJR5ESe?=
 =?us-ascii?Q?kLFfmmc5eyoubuNp7hvebtI4LnSEKOj5GpS1wSlGceUl2u2N4cz1JepMNT5j?=
 =?us-ascii?Q?Huyjg4AWH+Zh4avaO/F2lVhRk+Obkh0pw4ZYH1rEeNy8DYV+Hz91lf4+bQag?=
 =?us-ascii?Q?Rk57/q/J8TTLZEHqRGXh8zG4WlLMENADpZ+ngcP82Axf2SA5yAcckxQ+bzUG?=
 =?us-ascii?Q?PaMlLVEOGFmuWcfpYlW52kHcpCs0hjvenoIb3ZZB+jvjM3z1qBDCfib/Xb0x?=
 =?us-ascii?Q?0lKK55UDq5+b4i5i4AVmwxgDbNB07zagBg0ixhIxqWmePqKwN3Uye4WMpL6L?=
 =?us-ascii?Q?709Kl5FqtXrEI1mvbyIEwEdes+Tg+H+MOZtLA+Rpij2VGjVTHhYyZB2S/7A0?=
 =?us-ascii?Q?HD4MlBGR70Px6XnLI8ZCQ0q7l8kvVFsxjDMlWhPYL9MFEX7+QFG5tM5UL4hy?=
 =?us-ascii?Q?riIEZpywYCsokLjlXff3ERb3EBwsg4mqHWsZo1tsMeEFDqrN1V4ZDF19HycP?=
 =?us-ascii?Q?Bv19tHZTTfn9qddI8aud0PHVyOwqPcAf0I+TaAIBnkY/CvqG7P2zwF7/B1YX?=
 =?us-ascii?Q?0NDbVF0rBRl9McrKSgnyfc1bwn4xQzdh4GuT8HdWez0IgiV6cqGeldZRmeYa?=
 =?us-ascii?Q?HrYgSW/C6udMExLxxtE8zJTv9V5kkNOoaLhAzqtZw3DOLB/0nfD4T1o9vUXn?=
 =?us-ascii?Q?wcBF6KWcoRYFCfYAnbfm90qKclcGQKe+bijrEg8Ff7ld+YMacjBVST/WEvgY?=
 =?us-ascii?Q?Q0ayGqPF+ysbRXtkOM5lPWbJyYEHBao2O6bhn5/1HjsMYb7HO6pcJutvH+bS?=
 =?us-ascii?Q?wOlreTNj5gUR/8AX4PJG9KFPklTJDcaEeFQDLqNnX1XuHne1qqabjFjFIcMp?=
 =?us-ascii?Q?6/LgYxAb7z8K1cIPV85w6xZkEHa0FrgsytQ0I+sAx6hJUdG6GegTrHhKEO7C?=
 =?us-ascii?Q?j2/IX7DxIw2DiOVqecli7HWh/bC2KUdJQnJ7+jtjLvMe7SgRLWXM/rogPxCk?=
 =?us-ascii?Q?dWoe7zZTNFxtjmAQTfzPfKLYfyPWRPrbqlXiR6dGDIN4JCNf879B+B873epv?=
 =?us-ascii?Q?7WA4CilQG8TQ8J77jVTLpyiPYHqvtCU5tSY2stuvKw0f/w4D6SqcZOuDfiZ3?=
 =?us-ascii?Q?GYvoE0owiakx/SWe2BKGBSnmPd3GC4lQsIvNnPfRPBz6nTNKrSbcok1rnjFV?=
 =?us-ascii?Q?f3P2tAaBGjNy5j2V+F0RvtRoOwKX3tVTgjEcdlC7PDanVinOb9ac6/q7/nst?=
 =?us-ascii?Q?mz/7lmoXkDTbVH83Hx/rNFxpyDQZ7wKXYM9uQieK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa912f98-3aa6-4226-c610-08dad95a81fc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.0269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ST/Okfb0rBcYsf27SVeQgb5NA8+rS1MZufAiCkamVaggInVVtd/5yUyBB3/s+TQ
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

No iommu driver implements this any more, get rid of it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c  | 3 +--
 drivers/vfio/vfio_iommu_type1.c | 4 +---
 include/linux/iommu.h           | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 13ad737d50b18c..76a658bf9baa9c 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -169,8 +169,7 @@ static int iommufd_device_setup_msi(struct iommufd_device *idev,
 	 * operation from the device (eg a simple DMA) cannot trigger an
 	 * interrupt outside this iommufd context.
 	 */
-	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP) &&
-	    !msi_device_has_secure_msi(idev->dev)) {
+	if (!msi_device_has_secure_msi(idev->dev)) {
 		if (!allow_unsafe_interrupts)
 			return -EPERM;
 
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a954b58d606766..380297334842cf 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2164,9 +2164,7 @@ static int vfio_iommu_device_secure_msi(struct device *dev, void *data)
 {
 	bool *secure_msi = data;
 
-	if (msi_device_has_secure_msi(dev))
-		return 0;
-	*secure_msi &= device_iommu_capable(dev, IOMMU_CAP_INTR_REMAP);
+	*secure_msi &= msi_device_has_secure_msi(dev);
 	return 0;
 }
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1690c334e51631..0075b110d17998 100644
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
2.38.1

