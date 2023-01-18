Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4940B67257E
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjARRuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjARRue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:50:34 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A740D37B75
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:50:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0lnMcnESVDPtnBmtRmcCVvYDT5kAqHyuaycf5k8wpVeZXaRdSsx57uj6ukG6FwJOx2idtE53WIUa0NR/rlYUpvuqC5ZG5N3r9/7h0mFYXEB41mDrBQxdJWaHO5jy/uMISaXN5YrXUwNm8WZvr9HonxNpaXVoGerH2H5IF06DOYfh6IiRHZRC0mOiZ4rsKjdw62nGck3yhvoFU7IG1gU5o+02EhEny6ABjmYyq+yYN46P5h0mDwW8bpDFSv1pIMPwB+UrLBU3c/PyAlxUcYa5tAaOZa0samCCuy6OXuMpOFR9pLS9I0zOGGoJ938zV2qckIoyFfYdU5pq/MmqcW1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLnlldyBu8wjXSdYsCnDX/eDa42rqkpzzj4Pevaj2tg=;
 b=HDPIVtHCPqY5NTtPUDUBKW6FICTjfq40+sGWes7/hL73GH2E+021j0aRTAdgFwcovX7otlxUd8hChdUCKoA9A5uRsERORyN0k40bVmmmpIs0jZx/Bl+VcdMnut5VAxJ+/zDJK5fUwCAxKxgCI42Mm6WgTKIZcvte4MGjw0DmFBIAmtdhi39mFsceVGlyTUmvjqRxizOUbXuRn3fIGJDrV+dBd0vhppfDiDCgtTs3Ex0KAm4kzDTRdUjd8uhdkar8183REwCNB8hVblxgC9ctBpBixFSc5dyfeFol39w8bau21NctxAFd+ylTtGFmthtinTqDQ3CntEWk8D1bbqcxFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLnlldyBu8wjXSdYsCnDX/eDa42rqkpzzj4Pevaj2tg=;
 b=pMVUKkEkty+GiilXMuTW/t8bbpFtgjDJ3bl2XF0LlBBHAQcVZuTGCC0Uuq/eyYOsLGqiMJ2/Yz13bL4tvc7qwQ/mRNq149wxJldif6AJ8SO3mBiCESQ9/rNEyFHVtSqVbSvNzUmFVNyDiGxpgb2ApiLEp8RvmFAGau9ZFs9VlT1B6C0wu+4ZFlAfZ7JYp0N94yfzKHM2eGZ8hPT2Y60RFQmm8UG2YrxzE+y5FHyQVvDw7PNQOe3fAnrHVn1H2WCPqYFmnqJBgWmjF/WagfkDerEeTwm6qe9aXitaEn1v4Wxs5ygJJErBSrlP1RxCVWlThfSupPirar/e6g+qgsw8Ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 17:50:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 17:50:29 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3] vfio: Support VFIO_NOIOMMU with iommufd
Date:   Wed, 18 Jan 2023 13:50:28 -0400
Message-Id: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:208:134::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b1315c-644c-4ac8-d6b0-08daf97c7cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b6SeEFCmC78pV2IH9Y4ODYb5N/oCiu50sRlOyjxap5xqJefUj0tEjnpvDkuzYMGDWzT4hmt7liIZBNWxQRPi4Ag9qS7N1rSTKJ7Y4RxMMbyFWDNY9SX9D00W0OkIL3KVezdXgkR9eKQLop3HS93aqTu1JkBmiu0ZSOBaL/IUHxaXxXsr9+J6tjOHobTt+9pJCsts466DUR+Yffun/UaibAz/HSlydgIWJ5g4PCXtfMo9shNadRi3q2cwRwcIXVU9234cbtfsFvnZ8OQfjtV/yfK3cQZ5z/pmK/7ceeIUweVy95Wp8X3fpWAdbKNbnx0rIXbwrvjKdMnblgvgk/dGtmsc49ZBfMnqNG67ZNpCVzX4dXe9AGp/8amFYm/shq/+/H8t9eSGVVQkzfedvc/obJvsWM6T8onr22mKZ0iWPmdz6+SDwhboNCghZWUICFTkefzXvMGFA2oSFYZy3liRZ4+sz7UYlNWpli9hrDMu1s7pkJ51xmSB2MW28mTJNTN4C4zY/VQa/OMWehrVeSnMzP5bzlcMiWYxFoc1oQFsELcd37yrNMDJJTTV8KYBfHMCfhN3cEC0iYCtzU6T1nPJwCxonbeFuZivQDMzcp+tVWI6FbJ+qTp6UB90MwmPmA963IfSDA7vQPTdvQMvK9S2oagYL40uu/A1YFrwSPb6CcylVjuRiaF0N6Rn9gDo2yFZxaNZG7qeHGSdJkfnt+AbQpp/6THmXr4g3T/6lWxEQZkgwLc7Z4hdRsd9yu5/DFeQXzxq+e2ywYTTOfz+0Yal4xc9azLgeNLzLXeai53PIbHvUNn/IFV+tZzbRLBacZb+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(30864003)(966005)(8936002)(6486002)(478600001)(66556008)(36756003)(41300700001)(8676002)(66476007)(5660300002)(26005)(66946007)(2906002)(316002)(110136005)(86362001)(6512007)(38100700002)(186003)(6506007)(83380400001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15uD7kPB7O1Nu6yzeAM4KScyXDBVsRWaCTj2dvCHuy2ZzwTkhFayCqAi1tCI?=
 =?us-ascii?Q?VQpD8ctTG5gnit2LhHKRF4zuRgwzdixUIvLP94lodJ+faQK0bUk0KVw24/AA?=
 =?us-ascii?Q?dKSj/cWZhfdpIJ3svUGyBxE9ZhQXt/ESvFgj5hHXqIV1SG5LySUa4KbejifM?=
 =?us-ascii?Q?L9j7dsJmM/Z+q8qzP9/EnE+RuC1R3yiGJA2yui1WVqnpgVaKHnn4zOPG+Bq4?=
 =?us-ascii?Q?jkFJqrjzqB+psLSWoDfMKXJTEBU7PCzk0Vp/krfYLX+W9+rNYoWgzKBY9vun?=
 =?us-ascii?Q?/Xk70j2bDO4kX4gQ5d02z0KX5+DArkY59zSyJYgpJqgh1HwOsJCwVBbA+zpY?=
 =?us-ascii?Q?zRRh90asTE3Wc5SZwd0jADl4fvDQxitSENDldEsMCG92QzeAD7eQaaGT4kW3?=
 =?us-ascii?Q?K59Azl1qF8mISxtxMaGaiaEERYwRlcDIQfpcv73Grmh6egXHXxrqYlrftPD5?=
 =?us-ascii?Q?COEIgs1o+U5gy/jC1O6G5zkLuXB6r99F8jSrGKhX9JWPEg8UVk/2ftbUXCCI?=
 =?us-ascii?Q?ggbYf+T9M1GbvzAkGF/XqDS5PG/2o+eWkPAUjhnZJrzSXQfYhYLpmsWkS7Q2?=
 =?us-ascii?Q?XNh/1zkp+PUdAv0lPSP9cTTbMw7GEW8FCP/RXAQj+C+d5orHzdK3Y1CaO1hW?=
 =?us-ascii?Q?Unc4WMQoNbQHheIzaNZaJqcWSfW9/bXFlZj04gsBLO5eLNhiVfvq5URnDEPB?=
 =?us-ascii?Q?AriKj22imOJ9uKCEqhQLxBKYwfoitWMs/K6hmI00gbjGB/RUe0+26vHFEsdG?=
 =?us-ascii?Q?M6TzAGM7ulHEua3gURnCw9KEmnES9ZUOLRzBTdrbS8fOUgmAm9xw1w3yC0vh?=
 =?us-ascii?Q?G2YorsImeYK7wIBQo4cr1D+O+J8i44UvwJO3qcN7IWRlMNNGwKjz+taYJbqd?=
 =?us-ascii?Q?Xc382byztbtSygpCyZJ1tOH5UX3KwDLP0+q0gmZeAS2oUjP68xZNqX2cVNaS?=
 =?us-ascii?Q?tPjyv/bHI6oednH0kamv+ex+MAJ6vk/tXsAMebKGkkftcNsrrY03ZEq4ApY/?=
 =?us-ascii?Q?ywQI3J+DpwkbMzDe8kpOuehtyneiieLrJyBxHFt3z3ZexOif0rFqSe/eso22?=
 =?us-ascii?Q?TunCDyaK5ZdTo7Dfod6cCatvEbI34+TgS7+9fWjae0A5tQPFYYOpWAFCU92U?=
 =?us-ascii?Q?+B3k314ERDjF4KR3xA1SJZK7VWMT08rPZOYxQkDZz2lo2uaJxNzyoXhZ8TK+?=
 =?us-ascii?Q?/77lAfAG+LLyvW320NSgY1bkqbBOBtoeW302odXVUi4lN8+y+LFh3718WtSa?=
 =?us-ascii?Q?clwXOYXVpJ0PiUuxeveyihmKFi9BUoqyFovyPRmb+8Wu55zAhGhjU2Zx8Xcu?=
 =?us-ascii?Q?yLn+COf9tY3bqYR5FYffX6BpH9ILkCizzm4+iEsbZJhVdyPpockJBpIhr9Op?=
 =?us-ascii?Q?DCAXlpePID/hubCRDWS+/eRoTC/vrFRz46KzVQOJ+Cpe1XoD33Ck+L2KSvXV?=
 =?us-ascii?Q?cX2Xo8B+804+zjNw3XE/xqG2I9Va+C5Uy/o1nfNqeJfFKhC2SCbNz/4WvnMi?=
 =?us-ascii?Q?aXYHYWQX6uXxG+XR9Gmd7Y5olH5jklDY6WLron8+xY1gN0QeWoMFuoBoUkSm?=
 =?us-ascii?Q?P+YWhf3ms5N1X2DI0yn+nhzJcWfghInoCjSLuxjg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b1315c-644c-4ac8-d6b0-08daf97c7cec
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 17:50:29.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCrXRcCZ4YfXrrqSdkh3D4lXYyrWiQdqvFARm/Uwj7jrUfWYz/4AcVGNNu3R1ENq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig           |   2 +-
 drivers/iommu/iommufd/iommufd_private.h |   2 +
 drivers/iommu/iommufd/vfio_compat.c     | 105 +++++++++++++++++++-----
 drivers/vfio/Kconfig                    |   2 +-
 drivers/vfio/container.c                |   7 --
 drivers/vfio/group.c                    |   7 +-
 drivers/vfio/iommufd.c                  |  19 ++++-
 drivers/vfio/vfio.h                     |   8 +-
 drivers/vfio/vfio_main.c                |   7 ++
 include/linux/iommufd.h                 |  12 ++-
 10 files changed, 136 insertions(+), 35 deletions(-)

v3:
 - Missed kdoc
 - Incorrect indent
 - Consolidate duplicate code into vfio_device_is_noiommu()
v2: https://lore.kernel.org/r/0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com
 - Passes Alex's test
 - Fix a spelling error for s/CONFIG_VFIO_NO_IOMMU/CONFIG_VFIO_NOIOMMU/
 - Prevent type1 mode from being requested and prevent a compat IOAS from being
   auto created with an additional context global trap door flag
 - Make it so VFIO_CONTAINER=n still creates the module option and related machinery
 - Comment updates
v1: https://lore.kernel.org/all/0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com

Alex, if you are good with this can you ack it and I'll send you a PR. Yi will
need to rebase his series on top of it.

Thanks,
Jason

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
index 3ceca0e8311c39..29ef01820a9a0a 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -26,39 +26,84 @@ static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
 }
 
 /**
- * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
+ * iommufd_vfio_compat_ioas_get_id - Ensure a compat IOAS exists
+ * @ictx: Context to operate on
+ * @out_ioas_id: The IOAS ID of the compatability IOAS
+ *
+ * Return the ID of the current compatibility IOAS. The ID can be passed into
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
@@ -67,8 +112,13 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
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
@@ -235,6 +285,9 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_UNMAP_ALL:
 		return 1;
 
+	case VFIO_NOIOMMU_IOMMU:
+		return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
+
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
@@ -261,10 +314,24 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 
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
index 4f82a6fa7c6c7f..db4efbd560425f 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -18,6 +18,20 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (vfio_device_is_noiommu(vdev)) {
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
@@ -29,7 +43,7 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 	if (ret)
 		return ret;
 
-	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
+	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
 	if (ret)
 		goto err_unbind;
 	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
@@ -52,6 +66,9 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (vfio_device_is_noiommu(vdev))
+		return;
+
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
 }
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f8219a438bfbf5..9e94abcf8ee1a8 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -10,10 +10,10 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/module.h>
+#include <linux/vfio.h>
 
 struct iommufd_ctx;
 struct iommu_group;
-struct vfio_device;
 struct vfio_container;
 
 void vfio_device_put_registration(struct vfio_device *device);
@@ -88,6 +88,12 @@ bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
 
+static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
+{
+	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
+	       vdev->group->type == VFIO_NO_IOMMU;
+}
+
 #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
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

