Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0C2664D01
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 21:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjAJUHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 15:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjAJUHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 15:07:08 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003AEB86A
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 12:07:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncIo98CBmoIxyFi7h33VHBMDTjid0XP55kzmGzMrSqfWL7odS5Lyg661BG2qcDoK5x+5WzlxP4pndJ8ft2x+Ddk0AzcjVC3kqw7hfQ/AVmSA7GSxjcyd3w/qBjkiJ+DyJ7h8dB0zhkQPK7q2zyHTgi78zilZ530f3LgZ5KTztJP/iECtWyFg6fmj1bpDYWRZGaZLX7cewE+zwjsvV9hHDCYxC23mb8E//QkUgZTl1g8Q6u8XaVWHnDMWWzc/DlwmkhmMygoPLa2D3clGupQUJ4Z14m6eaG7IlbmKAe8ljzP+e416sT5Dtzz+4WvmACvvBzG4MuJ5rFf2FgQD3LmEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwF2WWtXLuiS+a5f7XHowLwx/7F2SbpSb2P5tKjtmP8=;
 b=jFg7fGOqGETVcC3EIEoYcSP1YoB2D/39FxNI2AYWju77QFS0/tG3MEXH/8BEzC7Ks5Kci9/8AEzs8LF/0wtev5hxdMKxUlDFyMo8xqWNVuVUZmuIqt5oY02nRir5jTn/ujoshuj33qYfWQI8A526Ye6P/0AqANEB7EzYVE/A4CGt5xwSWzUxomr4Y0hQaxl25qbvJ0l+g5QjjKCYOg5zh1Q9oVdJWJ0wbpisy5r3sJKUcxc7bIwEANbaH/+7gNvdYjA8LZlL2P7ynl+7zQhF/4islBc3rHKTTXGDGOTkmaIxCh8X5C4VTXimdshlc3aejWApu2gZLW6T1Qszgets5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwF2WWtXLuiS+a5f7XHowLwx/7F2SbpSb2P5tKjtmP8=;
 b=nDjuZSQd8RWMFBTDZzb8sfRzlQ5zgzZK5Kglz0Qz2AdcZfsPCKuTyDKwtEw8wJmX8C5g8HjCXrjTXk5osOx6TXRAq+zqGoA1GhI2uXmAtfB0jfRYzK5GOaULVvRO0P+FWVvh6MfTlcyJnq6aw1mDbzO2oeGyWVwk/s2lAqh5l9Ked5EuYSAmFgCRDoebDIP2m46Yrdk0y1FI9hjc7Lvf1baej1Emu0NEnn23V8Tw/D9SXu7VgtA1PtJBN+c/PVuxxDI4dIejuTx6vuUv+ZeMjl6Wad1qUr7I71TyPmr48uJEp5dWb05Koz5KHA7kUutePDZVnLmYmvdxPC870qO6BA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8597.namprd12.prod.outlook.com (2603:10b6:806:251::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 20:07:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 20:07:03 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Date:   Tue, 10 Jan 2023 16:07:02 -0400
Message-Id: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:23a::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8597:EE_
X-MS-Office365-Filtering-Correlation-Id: ee578e8e-2319-447a-e18c-08daf3463dd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9p8BWaEZa8L3rz/IlNmbWvFDYHvhckq9oLYRfx9PORWGzFaZdYdhyUpGPGBgSnM0SRpAUa2jtXX7F68vvGp8fkYx4NGyyM7E3FjO7/QonLWIuX8lCzjDbaT6Hy3GMmd07N+WtVsv/lqmSAVcr+bG8jdCwBVzuPd/5UtbtZuSgslLevFM7fJYgnYZoSXgcitsndTAOQaUMjnoW96cpmHcvsvVClBPxm2muDth7WIHtsHi0k+FKQ3yDM5/PqFvfqXWVVmgk7POKBgwE0Q0U/FsxVi/SiOffq+kCrnhXAQHC/yH1QjwTd4qv8czghPd0gb1dmjaPN25FCn5Aw6YHOYstjAYvNnXkp7dZbOQjkrEGwbLs8MQN3ZskZ+ZUcM5EV4y88k1pF+jX5FEWzI/X/ZagXB2IL7tm4jgJOVpFwbjttI8UyROU3b0IaaL7QcoIsrug1k8a9esTjC95tvFUEfl+eSFAkkvKtNLkx1YTMJ/fRK4r2Fqn/XCFrHbvRvzmo/6OInA0MTGZJBng5NgIscRTrSeHj/4AdPBqinmxFzetK6VR3tpIqw67nyq/TH+mz2oOIBJLbRCVlPLILUyi8gG71v6t54hsSIVjitoE2bR7MIcPgxk/h+I457fGpsPZGlKgUGNvAS+6N6tKEg78ye02xSmlU+UOjf3wpuo6DI4L582N2BqDb2lFpFEno4sMfhoQlWTfnHoL7YzdiGLGhu5VxL+IDLoRfC8wYBKEnbRza2/cbFMLzqek5BFNXTBH9IqA9fbTZW3BS6+cZZmAeOmdSSFS8TAHPVFGn1A3dsfW5v+7OPq2wTGzkugp5/7iTJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199015)(41300700001)(2616005)(110136005)(8676002)(66556008)(36756003)(316002)(66476007)(66946007)(86362001)(8936002)(38100700002)(5660300002)(83380400001)(30864003)(2906002)(6506007)(966005)(6486002)(26005)(186003)(478600001)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GNN91vgAXyRCNmKJVV/QrpT7Ao6tyFJaQx9P1Trwuw1y/Tj6KE2Is08Qw8zB?=
 =?us-ascii?Q?9jLZ66AbAmPEyjwmNKfSWWJlbDuIb7MCRbtjgzcdiLURHGXCxx+O94bmGy6E?=
 =?us-ascii?Q?ce1pNvtUcyHhbHThi12gE8ny5lgzTe+L7oY7KPGNliOD8niieGlgv3wdyinj?=
 =?us-ascii?Q?NTC5MaqAbOSQ9m5IOKSyRVwtLITM5rS1sVw7swsGSxazq5w+1IKLI4F1T87d?=
 =?us-ascii?Q?f17EI2M9p/4lZ9dts9i9Jy4hTqj4doDhjJs35c5Ep5zx8nNzHjSvpuPhYaYi?=
 =?us-ascii?Q?ji7C95XvGocj17LFEVaILshmgyU42z4isaHuzzeDTkTnS3tZ9TT06Hjk4LWr?=
 =?us-ascii?Q?4UK7hPa1yFvQwJg4LlcsW8yfknGfxOKsnh+d96fspdTsRdlPJD28awP3B2sz?=
 =?us-ascii?Q?/enoXygF4xUNBb/gfcLXEHEWSyxiqMNeyf+ToeUNpcaphOpYqZIRm7quWAHH?=
 =?us-ascii?Q?WLhjOhCh3YznSwDet4zaA8luEgjZNq2hq6qzZtkYuA7u1NEmPhHbBKBHDZEx?=
 =?us-ascii?Q?TcD3stuih9kkiu73yFHD69Nq4P+UkcsSJ08l7yDAi7Vv+RvPqoPQi5kw+Qt8?=
 =?us-ascii?Q?aPm6HjUNYiIMrOegcm3AWevDV/FNTuAlXQkxN4FRrmrAvQBzJNBRwuguaiCv?=
 =?us-ascii?Q?b3Nf6wgv4YX51ha+EDYM+u1bSRuGv1/kE7S+bmbaWccHABYYaEa1AbKuUYmW?=
 =?us-ascii?Q?09uvzip2TzMx1uSNniswKxuzRBu1emIH0dCF6BsqBiwZVEhsgtxOCR+l+4jI?=
 =?us-ascii?Q?3lak2mPnFgSn/agVZ7RINORZYTaKR0UCFb4IdSpW+K71GR5lLxJaXjkS/EtT?=
 =?us-ascii?Q?zRXriM6/QefCrKss9px1JK80ONk7OXSgoz3dvCF+3y8hZoLY/lzGyjFIs1xh?=
 =?us-ascii?Q?tEQkTCEueKyVMKvemY/VpVnEvHiMT/+S5rO+24vUm1/B5jlk5mc9r4F26cxg?=
 =?us-ascii?Q?m7TcEKAnjRXg5lTKr3R8FntehTltECtGDdm+EPPKc/XjXp2yMralDOv8lW9c?=
 =?us-ascii?Q?NrvRsT6k1mF23XSEgwwHkXmN6YJyPhs3dh6gKXmatzPdddhvm/Qr/3ErX3iT?=
 =?us-ascii?Q?zTDmbStaSRaBh7o4BJNWjsbAmOkUrxob1OcCvwCO/NY9oCDQ1nbXg0EdIdWI?=
 =?us-ascii?Q?ukYx4F272QcNQiNJIGLSrerSdWxItMWiKRAKgOKWw5auJNif1ZkjRpOVjJ3w?=
 =?us-ascii?Q?z7AHXfGodLSPTmZ0iGI9Lk05cbf2bz3EH8BPkvREzgL/J2Eue2j/0Thfwqbb?=
 =?us-ascii?Q?6vKe5arbbNNV62AdNDf4ibfJx0zYMRzfKaBvR3qtzyLxJ8dK+w/b3ARPatJq?=
 =?us-ascii?Q?p2AqO2NaD5oCcl9lXm1VXSctOXXSwuWtP0uZhUdbbdM9MZXHXvjRXOCzIP/A?=
 =?us-ascii?Q?fpxGBHmjT3KMFP9GGc6b5tX+b264ZrCrgBPXWhyibcuPviuElWoWDCxhKUeC?=
 =?us-ascii?Q?5VvyMynyNBgbpCbRrhmrPYS9vf9Mjxzj/CJvDjWatiE5PFteIkOe0MQ7IHbT?=
 =?us-ascii?Q?avvh4jM1blKCr/yUtjyeNFRFu3gsJnuuchM8FFO/3OArSIs5uewvlqCujTmG?=
 =?us-ascii?Q?i8TTVatvJNVNricJZKe9o44/TgTBQ4ScZ8iUswv0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee578e8e-2319-447a-e18c-08daf3463dd8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 20:07:03.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBkIlIrSpB12cG1K8P8qc5hZzWklg1TfoYCjDjdNP0hocm3tOvziAz8G3A7yZk9H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8597
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a small amount of emulation to vfio_compat to accept the SET_IOMMU to
VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working on a
no-iommu enabled device.

Move the enable_unsafe_noiommu_mode module out of container.c into
vfio_main.c so that it is always available even if VFIO_CONTAINER=n.

This passes Alex's mini-test:

https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig           |   2 +-
 drivers/iommu/iommufd/iommufd_private.h |   2 +
 drivers/iommu/iommufd/vfio_compat.c     | 104 +++++++++++++++++++-----
 drivers/vfio/Kconfig                    |   2 +-
 drivers/vfio/container.c                |   7 --
 drivers/vfio/group.c                    |   7 +-
 drivers/vfio/iommufd.c                  |  21 ++++-
 drivers/vfio/vfio_main.c                |   7 ++
 include/linux/iommufd.h                 |  12 ++-
 9 files changed, 130 insertions(+), 34 deletions(-)

v2:
 - Passes Alex's test
 - Fix a spelling error for s/CONFIG_VFIO_NO_IOMMU/CONFIG_VFIO_NOIOMMU/
 - Prevent type1 mode from being requested and prevent a compat IOAS from being
   auto created with an additional context global trap door flag
 - Make it so VFIO_CONTAINER=n still creates the module option and related machinery
 - Comment updates
v1: https://lore.kernel.org/all/0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com


diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 8306616b6d8198..ada693ea51a78e 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -23,7 +23,7 @@ config IOMMUFD_VFIO_CONTAINER
 	  removed.
 
 	  IOMMUFD VFIO container emulation is known to lack certain features
-	  of the native VFIO container, such as no-IOMMU support, peer-to-peer
+	  of the native VFIO container, such as peer-to-peer
 	  DMA mapping, PPC IOMMU support, as well as other potentially
 	  undiscovered gaps.  This option is currently intended for the
 	  purpose of testing IOMMUFD with unmodified userspace supporting VFIO
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 222e86591f8ac9..9d7f71510ca1bc 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -18,6 +18,8 @@ struct iommufd_ctx {
 	struct xarray objects;
 
 	u8 account_mode;
+	/* Compatibility with VFIO no iommu */
+	u8 no_iommu_mode;
 	struct iommufd_ioas *vfio_ioas;
 };
 
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index 3ceca0e8311c39..2c9db251a351e6 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -26,39 +26,83 @@ static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
 }
 
 /**
- * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
+ * iommufd_vfio_compat_ioas_get_id - Ensure a compat IOAS exists
+ * @ictx: Context to operate on
+ *
+ * Return the ID of the current compatibility ioas. The ID can be passed into
+ * other functions that take an ioas_id.
+ */
+int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
+{
+	struct iommufd_ioas *ioas;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	*out_ioas_id = ioas->obj.id;
+	iommufd_put_object(&ioas->obj);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_get_id, IOMMUFD_VFIO);
+
+/**
+ * iommufd_vfio_compat_set_no_iommu - Called when a no-iommu device is attached
+ * @ictx: Context to operate on
+ *
+ * This allows selecting the VFIO_NOIOMMU_IOMMU and blocks normal types.
+ */
+int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx)
+{
+	int ret;
+
+	xa_lock(&ictx->objects);
+	if (!ictx->vfio_ioas) {
+		ictx->no_iommu_mode = 1;
+		ret = 0;
+	} else {
+		ret = -EINVAL;
+	}
+	xa_unlock(&ictx->objects);
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_set_no_iommu, IOMMUFD_VFIO);
+
+/**
+ * iommufd_vfio_compat_ioas_create - Ensure the compat IOAS is created
  * @ictx: Context to operate on
- * @out_ioas_id: The ioas_id the caller should use
  *
  * The compatibility IOAS is the IOAS that the vfio compatibility ioctls operate
  * on since they do not have an IOAS ID input in their ABI. Only attaching a
- * group should cause a default creation of the internal ioas, this returns the
- * existing ioas if it has already been assigned somehow.
+ * group should cause a default creation of the internal ioas, this does nothing
+ * if an existing ioas has already been assigned somehow.
  */
-int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
+int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx)
 {
 	struct iommufd_ioas *ioas = NULL;
-	struct iommufd_ioas *out_ioas;
+	int ret;
 
 	ioas = iommufd_ioas_alloc(ictx);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 
 	xa_lock(&ictx->objects);
-	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj))
-		out_ioas = ictx->vfio_ioas;
-	else {
-		out_ioas = ioas;
-		ictx->vfio_ioas = ioas;
+	/*
+	 * VFIO won't allow attaching a container to both iommu and no iommu
+	 * operation
+	 */
+	if (ictx->no_iommu_mode) {
+		ret = -EINVAL;
+		goto out_abort;
 	}
-	xa_unlock(&ictx->objects);
 
-	*out_ioas_id = out_ioas->obj.id;
-	if (out_ioas != ioas) {
-		iommufd_put_object(&out_ioas->obj);
-		iommufd_object_abort(ictx, &ioas->obj);
-		return 0;
+	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj)) {
+		ret = 0;
+		iommufd_put_object(&ictx->vfio_ioas->obj);
+		goto out_abort;
 	}
+	ictx->vfio_ioas = ioas;
+	xa_unlock(&ictx->objects);
+
 	/*
 	 * An automatically created compat IOAS is treated as a userspace
 	 * created object. Userspace can learn the ID via IOMMU_VFIO_IOAS_GET,
@@ -67,8 +111,13 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
 	 */
 	iommufd_object_finalize(ictx, &ioas->obj);
 	return 0;
+
+out_abort:
+	xa_unlock(&ictx->objects);
+	iommufd_object_abort(ictx, &ioas->obj);
+	return ret;
 }
-EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_id, IOMMUFD_VFIO);
+EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_create, IOMMUFD_VFIO);
 
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
 {
@@ -235,6 +284,9 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_UNMAP_ALL:
 		return 1;
 
+	case VFIO_NOIOMMU_IOMMU:
+	return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
+
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
@@ -261,10 +313,24 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 
 static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
 {
+	bool no_iommu_mode = READ_ONCE(ictx->no_iommu_mode);
 	struct iommufd_ioas *ioas = NULL;
 	int rc = 0;
 
-	if (type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU)
+	/*
+	 * Emulation for NOIOMMU is imperfect in that VFIO blocks almost all
+	 * other ioctls. We let them keep working but they mostly fail since no
+	 * IOAS should exist.
+	 */
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) && type == VFIO_NOIOMMU_IOMMU &&
+	    no_iommu_mode) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		return 0;
+	}
+
+	if ((type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU) ||
+	    no_iommu_mode)
 		return -EINVAL;
 
 	/* VFIO fails the set_iommu if there is no group */
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index a8f54462946742..89e06c981e435d 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -32,6 +32,7 @@ config VFIO_IOMMU_SPAPR_TCE
 	tristate
 	depends on SPAPR_TCE_IOMMU
 	default VFIO
+endif
 
 config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
@@ -46,7 +47,6 @@ config VFIO_NOIOMMU
 	  this mode since there is no IOMMU to provide DMA translation.
 
 	  If you don't know what to do here, say N.
-endif
 
 config VFIO_VIRQFD
 	bool
diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index b7a9560ab25e48..89f10becf96255 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -29,13 +29,6 @@ static struct vfio {
 	struct mutex			iommu_drivers_lock;
 } vfio;
 
-#ifdef CONFIG_VFIO_NOIOMMU
-bool vfio_noiommu __read_mostly;
-module_param_named(enable_unsafe_noiommu_mode,
-		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
-#endif
-
 static void *vfio_noiommu_open(unsigned long arg)
 {
 	if (arg != VFIO_NOIOMMU_IOMMU)
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e03..e166ad7ce6e755 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -133,9 +133,12 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
 	iommufd = iommufd_ctx_from_file(f.file);
 	if (!IS_ERR(iommufd)) {
-		u32 ioas_id;
+		if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+		    group->type == VFIO_NO_IOMMU)
+			ret = iommufd_vfio_compat_set_no_iommu(iommufd);
+		else
+			ret = iommufd_vfio_compat_ioas_create(iommufd);
 
-		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
 		if (ret) {
 			iommufd_ctx_put(group->iommufd);
 			goto out_unlock;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 4f82a6fa7c6c7f..79a781a4e74c09 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -18,6 +18,21 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+	    vdev->group->type == VFIO_NO_IOMMU) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+
+		/*
+		 * Require no compat ioas to be assigned to proceed. The basic
+		 * statement is that the user cannot have done something that
+		 * implies they expected translation to exist
+		 */
+		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
+			return -EPERM;
+		return 0;
+	}
+
 	/*
 	 * If the driver doesn't provide this op then it means the device does
 	 * not do DMA at all. So nothing to do.
@@ -29,7 +44,7 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	if (ret)
 		return ret;
 
-	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
+	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
 	if (ret)
 		goto err_unbind;
 	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
@@ -52,6 +67,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+	    vdev->group->type == VFIO_NO_IOMMU)
+		return;
+
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17b5..90541fc949888c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -45,6 +45,13 @@ static struct vfio {
 	struct ida			device_ida;
 } vfio;
 
+#ifdef CONFIG_VFIO_NOIOMMU
+bool vfio_noiommu __read_mostly;
+module_param_named(enable_unsafe_noiommu_mode,
+		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
+#endif
+
 static DEFINE_XARRAY(vfio_device_set_xa);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id)
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 650d45629647a7..c0b5b3ac34f1e0 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -57,7 +57,9 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
 				unsigned long iova, unsigned long length);
 int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 		      void *data, size_t len, unsigned int flags);
-int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
+int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
+int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx);
+int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx);
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 {
@@ -89,8 +91,12 @@ static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long
 	return -EOPNOTSUPP;
 }
 
-static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
-					      u32 *out_ioas_id)
+static inline int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx)
 {
 	return -EOPNOTSUPP;
 }

base-commit: b7bfaa761d760e72a969d116517eaa12e404c262
-- 
2.39.0

