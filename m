Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212A562CC3F
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiKPVHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiKPVGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5076A744
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kF9WGsQSCyYdPElTzjbphoDtCkjHzrgLXJI+r1+/IUBEDCzDgUkLyN2f6bi9VN2mIIfQ7qgKpGmJbRvvpBWCX1HyW6U5bESLmwZS/H0fXF8CiDZkYXiqBQ5ohuIL6t1uyG9RLI6iIKVy3RfHgjKJBzZCTnDvi8vMY96upXrzY99mvaURN4YwVxZeBsOrjzAFT9qraBSaBTvhF0V4dyrXO4yq4FdWqqRqBR4U+ca/EaDHVI/Y351CPNRRsEXBCwkPnjmprawOFw2TMNV0X+HLLQiasGR9z0QQ+pjyjncpigPCx58zBpFefEB3fQoVzyrzusQM55SZPKvHsAwcxPku3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuOJp0y/pX4J6NdcD55qYyvhaU9hnXmXl26EmXpZi7w=;
 b=lRw74gNL1Z+zuYaHn7k82dDYySyfIGKzcqAtngsDZd0TRnYa+svr3U7USX+d/CofT0xjnncQpxWXpjtomQA0+O15YNRhr4loatSmOVg5APSzQvT4FhPy8LAOf9TmhsWvo0D/fHg8KtSDwV3no5gbm2SEPz5uU5jwo+ulY1bUYMI1UjWOiRhJ5Y/on8Icsrv5jKYqq2fmQx4g0xgACcJg3vkBqXgUNf5MwvqZVXd1dTMmc8mj29FXeV9NGrkhw2Tv6U/CPfaeQ3QHXKpTlXlOdk1+r5wsWRohztMXE5cXzPHxhbIX0TBUWr1N7HvtMoLg9MTLiE1Cl+u9k7FPf4IQmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuOJp0y/pX4J6NdcD55qYyvhaU9hnXmXl26EmXpZi7w=;
 b=aiM1nZ060Ymi/QifwGbpmYwamGeMOkSMd8y59AlLHKY8RPQYm5RknQmJXUJWWsSjMG90FAhwTQ+jzBZiSuFHOjSWzhDuLYRWdTZ+M8mUypheH7Cnw3NzEzoNZpmH0IdsrI7Ewhgyu7mAq6FnH0tCMERfN0XmESHqSA6rOEavJMyjpbkRd2kWFH039zigkMPw6bHj4pnR4HzHiMnQwsWekeeB8MjWcQkN3EnbiRt9RM/6OH/R5WM5zNmIOgOkB3jxujN6xOrSp+H/S2q8LgeScLWJreIB+VZir6FkTU42yjvJyY5s9g5diNyrIB5lJrluHe5p6703gBUO2Ah5VeXNNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v3 08/11] vfio-iommufd: Support iommufd for emulated VFIO devices
Date:   Wed, 16 Nov 2022 17:05:33 -0400
Message-Id: <8-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: e46df7fa-7d4c-4a86-44f8-08dac8165007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eflvSA8u8bLFv3sVofVoPMgkAOtPDGVyGFCOyN2cmLAIRZP5NOM3QuV7hccW5AdBxAmp8mjFVwd60gxB3YH3SC9k0iv80Jdfs8cgxmNDgpGGPBH0AN12sqcLKO55+8qUmJd/k9dUGovzt2A3ykrUW/Y+oqSyhzleK7qjAY9khBFl38jTn/Y1a4iO+bq3wT3oUlDKXbWu9dtwv0P0b5ZwFzUIH7yMlJblBdNpwqfHR9BGwfvoaO1WKbTyHofHRLNcg+tplKrLPK8s7/5kZqKwlJAwbTI+kBkE8vciDL76wyfczHAxN0T3YDAHnHvCzaTLQBbneFA7KfY3f1IBmwHHDX5LJZ5LrqGWWmU+ZvMjVq2HR+OAjuvgnvRPEJ49zcH53O3wDfDLT94cUfi0YWDrCUPDV3R92dx74DtPVIn8QaPNAXAXp8lNBUrz3yyFAIBGCC0UciCI/+xserSDUcqaML8c2Q3btFvXgYGwBYKzQu0Zyquo7rPx3E4IUQ4pTREgw1TeKtgDWhorZF58oR0JKxygLRKqfzqJgGr6cieY7KSmF5mRQDJcsbN8uHgwPm3USWOMYVaQGlhwV8UeDcDt1ESmJ1U4tncauuymFvfl9qCiE6eUQYqnNDaCZqafprosg8AME3VVYw9InOux7dHmh3Cxhkg9L26F0YmoNu8XQWyHolrrK+fifQg7r/FVGMb18/fe4C1/KI1cYliE/UI46190xouyJw6JuPpwDJK0v/++XchtUv+zrl+oxf1AbUP/aRQTpEs4KSObqtpvq0Q9Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(30864003)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tj8BqADLKrHdcqmYnA9hjnkFkccN0aHpcu5IOf0JyfqSVyOhszVEbtmQkBaP?=
 =?us-ascii?Q?aeGkZLlgg4Ycu1bAMmlSbLiDsym30cHP4JZg4JrxGJxvF0ImUtANhAVoGQRD?=
 =?us-ascii?Q?zvh/Hi318KUUM6e5nOcisOZrLih2NKkn/NEGI57ATUN3wj62xXbfKncB1AK8?=
 =?us-ascii?Q?58NZz4mvQdHSTW3UdSzY8QH2LJMUt5MmJpuasnLiCEUMEEZFmbJ8Xfw1Yvs+?=
 =?us-ascii?Q?K30sDhGpcPHEC/HnDxpwxAJG4Dn2kM4NrlpOw2cTP2JAmx4nHHe1Ev8mmJh+?=
 =?us-ascii?Q?rULcATOHI+jx/9x4sP8K7XJbuALIwlb1O1HGEQ76+utwdpODNd23TB7WhCJZ?=
 =?us-ascii?Q?jsHyXqxvrVmcCnmoJVCBOVHxPKqkVn2ExpCY+E93tJpmD0mA4TW7SawuBDi/?=
 =?us-ascii?Q?OB7PGiBuQ22cAD9T+BvTxTodkc49QlWWWCjR2qlbgxXmF6UPrRRVaRrGX05o?=
 =?us-ascii?Q?NvdKXkQQGE1/Wmw+H/Jj9XCp8jG4P9wVyfuUQYBzH4na9/pPW+sg2OpV2+A4?=
 =?us-ascii?Q?wuHZmxWIZBlwgEXLfm0nZ0vWQk8/ZjXUdVfSogKjSUd2Cot8gTxeivif6o3Y?=
 =?us-ascii?Q?0Gy2Q+OLQDmaXTs0+DdRWdvYYrvOOmmL4S/n+/sf59d48TAzBEsm6Ta27u3A?=
 =?us-ascii?Q?zWCdtxOsOb8EZg380bsOFkQyNrbirZOr1pf7xKvPRaSicJBPuv3TbLHpJjmw?=
 =?us-ascii?Q?d2I5Jw6ozgHtMQxig2R+x4k+8qY7ND37KHjHq+q667TbXdgwdrLz41bfo2M1?=
 =?us-ascii?Q?8dFi9CxzCiFvp7VADY1+NqInuEKObNaObN3/S+sYyYXU1p+JT+8zpdZiEzbI?=
 =?us-ascii?Q?ikeTQacNZ8qLWAoQN71eEn4wiW5fUYyFxGihNbvgfOOOy9csL6Vmzrz7Vki1?=
 =?us-ascii?Q?fqxmvY6G9huJp73u++utl9f5CnRNZrfvmYqJpiltMPhbTLnNqljm7QPPOagg?=
 =?us-ascii?Q?b6kORwcK1HoJiabMNQlBP9ufqxOpFgNPm3ap23mPm5umYOY5Nd3gNRzur/Eb?=
 =?us-ascii?Q?I11XEidOYmfuobavWNhPjQ6aONMFWy4ZBgx69LskMCsSkLD3sOJujoMjULwh?=
 =?us-ascii?Q?r4qwUTkHXI/lBUY/c59mqfPjdFTNLbWdSwQKmPCcIXwDqSkA0wbjRQ55hgsm?=
 =?us-ascii?Q?AoXHG1j0fyT8q9UlAXSynDe8e/kaD6rDmf4ot1rFePzloX70EQAgxEAnke1C?=
 =?us-ascii?Q?6ZcSHCmiOqR9Vx9U8q8ZCwG4f34eMMzvmZp+EcChUac6JWzvti5zKnOp0qSy?=
 =?us-ascii?Q?f8U0qsm3KBbKhabdt3k3ameCutOWVMbDzxYeQlZQOWRfuK72L9kbiC7a8srK?=
 =?us-ascii?Q?RDVxoag6wCAxNJsbzex+pXtYNrrZKuvzjeM6ocrfczX+BU+acqWLVcWXTWd4?=
 =?us-ascii?Q?octutQGzot8g7qfq/46NWnQ+JWKUNzYJfjb0uB1rOxj16dTcahZwsKeuStzP?=
 =?us-ascii?Q?HvrRWy/bopUWWJeGXBotDv7UYEhTFRcJJ8F8YA1S1ki0LLwA3mRBh+8CUeW5?=
 =?us-ascii?Q?YlKooLFBxzKUD2Dv5b32nAIwTR4qTI/jQIy9NW1Wx1gk2d0VN5LwUSwM9zDq?=
 =?us-ascii?Q?9n2lIPFyyKVymQP7qmo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46df7fa-7d4c-4a86-44f8-08dac8165007
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.5857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7akU2U2GsVwiUWgTWMjoarDAu0SjbLDEbRKwebs7Wmbv6s5uARs0l6wsIBD25ni
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
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

Emulated VFIO devices are calling vfio_register_emulated_iommu_dev() and
consist of all the mdev drivers.

Like the physical drivers, support for iommufd is provided by the driver
supplying the correct standard ops. Provide ops from the core that
duplicate what vfio_register_emulated_iommu_dev() does.

Emulated drivers are where it is more likely to see variation in the
iommfd support ops. For instance IDXD will probably need to setup both a
iommfd_device context linked to a PASID and an iommufd_access context to
support all their mdev operations.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c  |   3 +
 drivers/s390/cio/vfio_ccw_ops.c   |   3 +
 drivers/s390/crypto/vfio_ap_ops.c |   3 +
 drivers/vfio/container.c          | 110 +++++----------------------
 drivers/vfio/iommufd.c            |  58 ++++++++++++++
 drivers/vfio/vfio.h               |  10 ++-
 drivers/vfio/vfio_main.c          | 122 +++++++++++++++++++++++++++++-
 include/linux/vfio.h              |  14 ++++
 8 files changed, 229 insertions(+), 94 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 7a45e5360caf2d..579b230a0f58d9 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1474,6 +1474,9 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
 	.mmap		= intel_vgpu_mmap,
 	.ioctl		= intel_vgpu_ioctl,
 	.dma_unmap	= intel_vgpu_dma_unmap,
+	.bind_iommufd	= vfio_iommufd_emulated_bind,
+	.unbind_iommufd = vfio_iommufd_emulated_unbind,
+	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 };
 
 static int intel_vgpu_probe(struct mdev_device *mdev)
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 6ae4d012d80084..560453d99c24fc 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -588,6 +588,9 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
 	.ioctl = vfio_ccw_mdev_ioctl,
 	.request = vfio_ccw_mdev_request,
 	.dma_unmap = vfio_ccw_dma_unmap,
+	.bind_iommufd = vfio_iommufd_emulated_bind,
+	.unbind_iommufd = vfio_iommufd_emulated_unbind,
+	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
 };
 
 struct mdev_driver vfio_ccw_mdev_driver = {
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0b4cc8c597ae67..bb7776d207924f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1789,6 +1789,9 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 	.close_device = vfio_ap_mdev_close_device,
 	.ioctl = vfio_ap_mdev_ioctl,
 	.dma_unmap = vfio_ap_mdev_dma_unmap,
+	.bind_iommufd = vfio_iommufd_emulated_bind,
+	.unbind_iommufd = vfio_iommufd_emulated_unbind,
+	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
 };
 
 static struct mdev_driver vfio_ap_matrix_driver = {
diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 8772dad6808539..7f3961fd4b5aac 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -540,113 +540,41 @@ void vfio_group_unuse_container(struct vfio_group *group)
 	fput(group->opened_file);
 }
 
-/*
- * Pin contiguous user pages and return their associated host pages for local
- * domain only.
- * @device [in]  : device
- * @iova [in]    : starting IOVA of user pages to be pinned.
- * @npage [in]   : count of pages to be pinned.  This count should not
- *		   be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
- * @prot [in]    : protection flags
- * @pages[out]   : array of host pages
- * Return error or number of pages pinned.
- *
- * A driver may only call this function if the vfio_device was created
- * by vfio_register_emulated_iommu_dev().
- */
-int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
-		   int npage, int prot, struct page **pages)
+int vfio_container_pin_pages(struct vfio_container *container,
+			     struct iommu_group *iommu_group, dma_addr_t iova,
+			     int npage, int prot, struct page **pages)
 {
-	struct vfio_container *container;
-	struct vfio_group *group = device->group;
-	struct vfio_iommu_driver *driver;
-	int ret;
-
-	if (!pages || !npage || !vfio_assert_device_open(device))
-		return -EINVAL;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-	/* group->container cannot change while a vfio device is open */
-	container = group->container;
-	driver = container->iommu_driver;
-	if (likely(driver && driver->ops->pin_pages))
-		ret = driver->ops->pin_pages(container->iommu_data,
-					     group->iommu_group, iova,
-					     npage, prot, pages);
-	else
-		ret = -ENOTTY;
-
-	return ret;
+	if (unlikely(!driver || !driver->ops->pin_pages))
+		return -ENOTTY;
+	return driver->ops->pin_pages(container->iommu_data, iommu_group, iova,
+				      npage, prot, pages);
 }
-EXPORT_SYMBOL(vfio_pin_pages);
 
-/*
- * Unpin contiguous host pages for local domain only.
- * @device [in]  : device
- * @iova [in]    : starting address of user pages to be unpinned.
- * @npage [in]   : count of pages to be unpinned.  This count should not
- *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
- */
-void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
+void vfio_container_unpin_pages(struct vfio_container *container,
+				dma_addr_t iova, int npage)
 {
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-
 	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
 		return;
 
-	if (WARN_ON(!vfio_assert_device_open(device)))
-		return;
-
-	/* group->container cannot change while a vfio device is open */
-	container = device->group->container;
-	driver = container->iommu_driver;
-
-	driver->ops->unpin_pages(container->iommu_data, iova, npage);
+	container->iommu_driver->ops->unpin_pages(container->iommu_data, iova,
+						  npage);
 }
-EXPORT_SYMBOL(vfio_unpin_pages);
 
-/*
- * This interface allows the CPUs to perform some sort of virtual DMA on
- * behalf of the device.
- *
- * CPUs read/write from/into a range of IOVAs pointing to user space memory
- * into/from a kernel buffer.
- *
- * As the read/write of user space memory is conducted via the CPUs and is
- * not a real device DMA, it is not necessary to pin the user space memory.
- *
- * @device [in]		: VFIO device
- * @iova [in]		: base IOVA of a user space buffer
- * @data [in]		: pointer to kernel buffer
- * @len [in]		: kernel buffer length
- * @write		: indicate read or write
- * Return error code on failure or 0 on success.
- */
-int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
-		size_t len, bool write)
+int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
+			  void *data, size_t len, bool write)
 {
-	struct vfio_container *container;
-	struct vfio_iommu_driver *driver;
-	int ret = 0;
-
-	if (!data || len <= 0 || !vfio_assert_device_open(device))
-		return -EINVAL;
-
-	/* group->container cannot change while a vfio device is open */
-	container = device->group->container;
-	driver = container->iommu_driver;
+	struct vfio_iommu_driver *driver = container->iommu_driver;
 
-	if (likely(driver && driver->ops->dma_rw))
-		ret = driver->ops->dma_rw(container->iommu_data,
-					  iova, data, len, write);
-	else
-		ret = -ENOTTY;
-	return ret;
+	if (unlikely(!driver || !driver->ops->dma_rw))
+		return -ENOTTY;
+	return driver->ops->dma_rw(container->iommu_data, iova, data, len,
+				   write);
 }
-EXPORT_SYMBOL(vfio_dma_rw);
 
 int __init vfio_container_init(void)
 {
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 6d6452072b8dba..dad8935d71f7f0 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -101,3 +101,61 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
+
+/*
+ * The emulated standard ops mean that vfio_device is going to use the
+ * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
+ * ops set should call vfio_register_emulated_iommu_dev().
+ */
+
+static void vfio_emulated_unmap(void *data, unsigned long iova,
+				unsigned long length)
+{
+	struct vfio_device *vdev = data;
+
+	vdev->ops->dma_unmap(vdev, iova, length);
+}
+
+static const struct iommufd_access_ops vfio_user_ops = {
+	.needs_pin_pages = 1,
+	.unmap = vfio_emulated_unmap,
+};
+
+int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
+			       struct iommufd_ctx *ictx, u32 *out_device_id)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	vdev->iommufd_ictx = ictx;
+	iommufd_ctx_get(ictx);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_bind);
+
+void vfio_iommufd_emulated_unbind(struct vfio_device *vdev)
+{
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	if (vdev->iommufd_access) {
+		iommufd_access_destroy(vdev->iommufd_access);
+		vdev->iommufd_access = NULL;
+	}
+	iommufd_ctx_put(vdev->iommufd_ictx);
+	vdev->iommufd_ictx = NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_unbind);
+
+int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
+{
+	struct iommufd_access *user;
+
+	lockdep_assert_held(&vdev->dev_set->lock);
+
+	user = iommufd_access_create(vdev->iommufd_ictx, *pt_id, &vfio_user_ops,
+				     vdev);
+	if (IS_ERR(user))
+		return PTR_ERR(user);
+	vdev->iommufd_access = user;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 809f2e8523968e..d57a08afb5cf5c 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -111,8 +111,6 @@ struct vfio_iommu_driver {
 int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 
-bool vfio_assert_device_open(struct vfio_device *device);
-
 struct vfio_container *vfio_container_from_file(struct file *filep);
 int vfio_group_use_container(struct vfio_group *group);
 void vfio_group_unuse_container(struct vfio_group *group);
@@ -121,6 +119,14 @@ int vfio_container_attach_group(struct vfio_container *container,
 void vfio_group_detach_container(struct vfio_group *group);
 void vfio_device_container_register(struct vfio_device *device);
 void vfio_device_container_unregister(struct vfio_device *device);
+int vfio_container_pin_pages(struct vfio_container *container,
+			     struct iommu_group *iommu_group, dma_addr_t iova,
+			     int npage, int prot, struct page **pages);
+void vfio_container_unpin_pages(struct vfio_container *container,
+				dma_addr_t iova, int npage);
+int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
+			  void *data, size_t len, bool write);
+
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index e76ffa3ecebfb0..6195d7ad5b5479 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -771,7 +771,7 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 static const struct file_operations vfio_device_fops;
 
 /* true if the vfio_device has open_device() called but not close_device() */
-bool vfio_assert_device_open(struct vfio_device *device)
+static bool vfio_assert_device_open(struct vfio_device *device)
 {
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
@@ -1877,6 +1877,126 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
 }
 EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
 
+/*
+ * Pin contiguous user pages and return their associated host pages for local
+ * domain only.
+ * @device [in]  : device
+ * @iova [in]    : starting IOVA of user pages to be pinned.
+ * @npage [in]   : count of pages to be pinned.  This count should not
+ *		   be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ * @prot [in]    : protection flags
+ * @pages[out]   : array of host pages
+ * Return error or number of pages pinned.
+ *
+ * A driver may only call this function if the vfio_device was created
+ * by vfio_register_emulated_iommu_dev() due to vfio_container_pin_pages().
+ */
+int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
+		   int npage, int prot, struct page **pages)
+{
+	/* group->container cannot change while a vfio device is open */
+	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
+		return -EINVAL;
+	if (device->group->container)
+		return vfio_container_pin_pages(device->group->container,
+						device->group->iommu_group,
+						iova, npage, prot, pages);
+	if (device->iommufd_access) {
+		int ret;
+
+		if (iova > ULONG_MAX)
+			return -EINVAL;
+		/*
+		 * VFIO ignores the sub page offset, npages is from the start of
+		 * a PAGE_SIZE chunk of IOVA. The caller is expected to recover
+		 * the sub page offset by doing:
+		 *     pages[0] + (iova % PAGE_SIZE)
+		 */
+		ret = iommufd_access_pin_pages(
+			device->iommufd_access, ALIGN_DOWN(iova, PAGE_SIZE),
+			npage * PAGE_SIZE, pages,
+			(prot & IOMMU_WRITE) ? IOMMUFD_ACCESS_RW_WRITE : 0);
+		if (ret)
+			return ret;
+		return npage;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vfio_pin_pages);
+
+/*
+ * Unpin contiguous host pages for local domain only.
+ * @device [in]  : device
+ * @iova [in]    : starting address of user pages to be unpinned.
+ * @npage [in]   : count of pages to be unpinned.  This count should not
+ *                 be greater than VFIO_PIN_PAGES_MAX_ENTRIES.
+ */
+void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
+{
+	if (WARN_ON(!vfio_assert_device_open(device)))
+		return;
+
+	if (device->group->container) {
+		vfio_container_unpin_pages(device->group->container, iova,
+					   npage);
+		return;
+	}
+	if (device->iommufd_access) {
+		if (WARN_ON(iova > ULONG_MAX))
+			return;
+		iommufd_access_unpin_pages(device->iommufd_access,
+					   ALIGN_DOWN(iova, PAGE_SIZE),
+					   npage * PAGE_SIZE);
+		return;
+	}
+}
+EXPORT_SYMBOL(vfio_unpin_pages);
+
+/*
+ * This interface allows the CPUs to perform some sort of virtual DMA on
+ * behalf of the device.
+ *
+ * CPUs read/write from/into a range of IOVAs pointing to user space memory
+ * into/from a kernel buffer.
+ *
+ * As the read/write of user space memory is conducted via the CPUs and is
+ * not a real device DMA, it is not necessary to pin the user space memory.
+ *
+ * @device [in]		: VFIO device
+ * @iova [in]		: base IOVA of a user space buffer
+ * @data [in]		: pointer to kernel buffer
+ * @len [in]		: kernel buffer length
+ * @write		: indicate read or write
+ * Return error code on failure or 0 on success.
+ */
+int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
+		size_t len, bool write)
+{
+	if (!data || len <= 0 || !vfio_assert_device_open(device))
+		return -EINVAL;
+
+	if (device->group->container)
+		return vfio_container_dma_rw(device->group->container, iova,
+					     data, len, write);
+
+	if (device->iommufd_access) {
+		unsigned int flags = 0;
+
+		if (iova > ULONG_MAX)
+			return -EINVAL;
+
+		/* VFIO historically tries to auto-detect a kthread */
+		if (!current->mm)
+			flags |= IOMMUFD_ACCESS_RW_KTHREAD;
+		if (write)
+			flags |= IOMMUFD_ACCESS_RW_WRITE;
+		return iommufd_access_rw(device->iommufd_access, iova, data,
+					 len, flags);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vfio_dma_rw);
+
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a7fc4d747dc226..d5f84f98c0fa8f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -19,6 +19,7 @@
 struct kvm;
 struct iommufd_ctx;
 struct iommufd_device;
+struct iommufd_access;
 
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
@@ -56,8 +57,10 @@ struct vfio_device {
 	struct completion comp;
 	struct list_head group_next;
 	struct list_head iommu_entry;
+	struct iommufd_access *iommufd_access;
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
+	struct iommufd_ctx *iommufd_ictx;
 	bool iommufd_attached;
 #endif
 };
@@ -111,6 +114,10 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 			       struct iommufd_ctx *ictx, u32 *out_device_id);
 void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
+int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
+			       struct iommufd_ctx *ictx, u32 *out_device_id);
+void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
+int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 #else
 #define vfio_iommufd_physical_bind                                      \
 	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
@@ -119,6 +126,13 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
 	((void (*)(struct vfio_device *vdev)) NULL)
 #define vfio_iommufd_physical_attach_ioas \
 	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
+#define vfio_iommufd_emulated_bind                                      \
+	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
+		  u32 *out_device_id)) NULL)
+#define vfio_iommufd_emulated_unbind \
+	((void (*)(struct vfio_device *vdev)) NULL)
+#define vfio_iommufd_emulated_attach_ioas \
+	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
 #endif
 
 /**
-- 
2.38.1

