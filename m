Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90366285D
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjAIOXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjAIOXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:23:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A6B7647
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 06:23:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DozSD9/PgYG2YK091Zl38uP2K895UN21YF6khJYF64RNkqs2SzOKuIjSxiO99db0WB1NIizg2SN2FkeXr6UWKfBs/JHaRaqztIuxBM8jqvJvJClvsOfM7HqO1QDCaWF+seL6cL0cYMt9k0C00dPbskEoLJdQIUWSMPEfYu9knUDpov+owQ8aRxY9jp0XV5z6caih1+sNiovwaqVUu2M6WxbJIbndWjRZwo6Ha8r+9LSNbx0qB53FxtcH9M7wU86yB3Sv4DPsnjkPvS0kK5oYIKAWl9xkBqUFx61UcVQNKOuQKXx5Y5+4MoOj98PzxAPWAHyDJLYtSrVf9XxiGsDLGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTs6oww2X0KgbSAwsUazAuJkbVwve7DTaOiC0Usn52M=;
 b=ephHBe5FuCaY4f2roAguH88IbomqMColer+G82WE/YtehZNR0bS9CbahIPpVrbr5nrHTf2XB1RsSuJjJABJcI87v9FBI4b/sdIPEpGhTqyjHjkZ4ngEN+DkCheCY1K86Ga5mHpq+Yjmaldl0A/pPE0hN0mC35TVNbcmLAhjnUSeJOQkCxB8NTZ9IjuJLjIFpckJdeThVFfCSXK3DYxBSEnOkd7vQBgXMIZNwxqjJ9Tgfbzk/0DOiBGcrgQ9vy1Lwjl2+3so2hLWD94ixepe4rYE4W79jkrPbshaf/2+t1azQBS+M6ivRIMvibArgv51u8HPKhNYrms5oO+OMp/46gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTs6oww2X0KgbSAwsUazAuJkbVwve7DTaOiC0Usn52M=;
 b=UOIAAvMtDUJAuSAp0QIV03lwvZ5b+B513lhT8cx4xo8JrC0CKhgKSXPtcsBigjIIEsAoc+uMKlfdqeQx1YtNKkusXoM29ltedo408TFr7iFEXPZMiUcFvKe3ywYQfiniTDCgdEGZIOQK1MdgxuBvDwC1/2IW6BH/KPWH3qGauO1s2K2qqlFjtFrF3eIG1O1Uiv6ZHfJEKC96LWCt1joANxcEYm7ufWAPiWIJ7Y+Qm9Ba1o0gh3SAw85b6hXncvTWe96iT27bWhmOJdCLtpwHCdPJNZgOlMRRP1N0dQeXze+IaONXWggMZIxr1Q1mX4UXLkhWnpa6L9SgUzWWywFAxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6210.namprd12.prod.outlook.com (2603:10b6:208:3e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 14:23:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 14:23:00 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH] vfio: Support VFIO_NOIOMMU with iommufd
Date:   Mon,  9 Jan 2023 10:22:59 -0400
Message-Id: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:c0::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6210:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a05d7c3-4432-4892-09e3-08daf24d02f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LjIfg7IYqgfdFVdQb4JkqqwOCqBYw9WMoHaU3rZK8krFdqqqblWP49DwnBRdnHsrZj8BWBauMiUNpFNenTs/GtEKxH7DJHqavY8D12rec9DjZjo+0j1C+HDpxgVJp24ba3j+s+0iuuw0gkzmgjoCTBjObnj2PoIgB/SHChQ04lhIAOkVqORqmLll7gFot4ORq6zE7PJZ9fgymWECwHR9sxE/gR0f/nEaFeDpvIXe3fCJ2d5jBjzNorUyczgpUWhX+djMEMbqOu41mpUFqqjp8nENSRPtaj3glOJgdQgGCJGjZpUw8dfRnWy4dDYbW6TWUlX0kp4Zsqi+1a7i2FvEQsjfaV/1Dsmt6Gfq+KxAAaEbgdfQuCwiLdjmSBa8Gu5eBmELZbQU9g8wWfKWfV4182l4wbbcFOamvG6x8yU6tz16huwuVgVYt62IQQ1m70myv2ywcF5+FTW+ayNrROo946woGiKAkGXtCAvmEUMukOCqj9Y9mnngwf2Ye6rVnIlnv+l9UdbJMa4dD4QOcB3HhIutBg7nDuQ7fxHDxE+t/4eLGjC9Snvru4Snrcb0VNqMiNF589Cz7A4grOUbuaixfTxzOVMvPlzreeSSl9ikxQ8uohn7mptBus9fQiwe+vNxkiRurrsAyDgFiNhOyZ6v+PDZRjz1RPlr6GCiJgjRWyYUI4ikhXoWawHOAs9dac3t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(2906002)(6506007)(478600001)(186003)(26005)(6512007)(6486002)(110136005)(2616005)(36756003)(8676002)(66556008)(66476007)(66946007)(316002)(41300700001)(8936002)(5660300002)(38100700002)(83380400001)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jyJIJmqlB+hWL70sjz9GL8rcpeCoo8pBgzfy/x0h7eTYMgwpJQ55HkYO7KcP?=
 =?us-ascii?Q?fo6k9/Baebn1LBbCWVDvSGZ4phkmcJ197qDKPeADpuTRVDnUBSSPZLXknXTU?=
 =?us-ascii?Q?wiVdmHTOW8njZU37kaoRcvCBvpk5YkWea5PvFhWULtHtvrs9sQG6ytb/H+9I?=
 =?us-ascii?Q?SCcDg3eKLbdmf53oZMii4+2ITkY19A0WyBev3mmqOSwgqliRxj6jOd9ANa5O?=
 =?us-ascii?Q?YsO10UW2qOEJfC3GnccyGsk7+5rv9RhgdFM9wVlxSv2eb2cijWF/F+Z//H5l?=
 =?us-ascii?Q?lKPf3mm2uF8Eq/Ffl8c3JUGpNAD77kv6a6bpu12pOulm0+RaP0oa6LJRlwNJ?=
 =?us-ascii?Q?yEA3ytWgMYRxITXsTbef20jgGE8ErH1iq0e7L7dI3T+0VJ3S/+pIVZ2411Yp?=
 =?us-ascii?Q?GQX/GEs6VsR1AZYajrNQIhCWWEAFFCNcrtAV0ve2V3eqWtVkQmLxJad88YXC?=
 =?us-ascii?Q?u9H9BU+uzz3DEp1VM5Pd/TfH5x2N+pZpraBeN3XnXNPD+ByFftF+gihSlgN+?=
 =?us-ascii?Q?tC6HG2+3CtiCTG/Pi9uf3DWzaGKxejwGh6Nh20zj81idwff8vDKyJ7QZ0pAf?=
 =?us-ascii?Q?aMDvLv7XMQYrBzAQ/qh/93ijSoxz+6FWp2KQvBa8q1+Td/QSWFO0XuOF7UEe?=
 =?us-ascii?Q?DXFt5DdlEWSE5dGzAm5Si6mJ8orxOI2JH3Pza8uu6Jagr5+sH6u2FyHe9kdr?=
 =?us-ascii?Q?VTR4zhZiOfceQfB793GIWIs4Oewg2CxZSt7KVQ15nVYjFsOnHYdtS55dMjyZ?=
 =?us-ascii?Q?i3Ypq1wuQLgUf89pNlgJ8Te7UY0hYxtqrh2X8PKxRgo/EoBGGsWoo+oALb52?=
 =?us-ascii?Q?5879KNMr8QdH9fb0/XmWHpQAUGYuFJEkGBYO2ryWnfMyQz8moNx60wWqG8UO?=
 =?us-ascii?Q?r3iykA88+O8a+4Q57hvUuL7FCb1bLPxUullsteHBjQHO9iCyLBrhgzw9oaq7?=
 =?us-ascii?Q?iKS8qouW7AblIE5C2U2Qfv9b5EuCc1VzPS0dNr0BZQXWAOR3kn/qQuZS6AMG?=
 =?us-ascii?Q?UVkJoClU/pVfSRq1ME3BFYmoiBI8biEwK0FGNHpgTVFxsW4Sfu0HaWuwrqjy?=
 =?us-ascii?Q?+2DCCRz1dq1W1vRVbsHizg7GMOwsHEqz2CKtSC5JGXG7z2/eTtNzcgIKxONV?=
 =?us-ascii?Q?tg3URYy7xtzCLZr2alug7IOVLCjq+4KbFrcU3okEJajMo2rQZDI7Ct9334yg?=
 =?us-ascii?Q?UXtDQel3WqmjehhHUBhelpwKqq5/iTgEGsvOr8AIgkFZuKsT4nNxMck1wkw5?=
 =?us-ascii?Q?X1aQNxl1CzDIiCIzEk6hkpKyBvxtM5MtCo4jzKYEtWXIcFM7ZI6JFJ4fOJfr?=
 =?us-ascii?Q?9VKjVFp4okNfFkdlFQZxVogJWAgIs8nd3GMowVPM0MKnR0gsUs9wTEp88eAV?=
 =?us-ascii?Q?AErE7z5f162bSLalg9EaKk96qUQjInt2aphEpGVJNOBT31gGyr/cogKAj7Va?=
 =?us-ascii?Q?mlMKLC2H/y+caRxeusrzQ2BuqcDDFlZZmte+xBo9mFYMY89PP7FWOaxc5Dyv?=
 =?us-ascii?Q?d9k6OJT/zb2J64OEdtzmWxEZw9YpkBxavDuYQFiqzTRXxdV2KN+Xzp7yk+BM?=
 =?us-ascii?Q?HcVIMxi8IBoqUgkshbgGMiPfdVp7iYfZjji2J7/q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a05d7c3-4432-4892-09e3-08daf24d02f6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 14:23:00.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKy8bke9mSXw9JfNXHNZ048XkZGmM6vrloNWWbJyedKrjpNHFWtD3WmywIXJNQkf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6210
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a small amount of emulation to vfio_compat to accept the SET_IOMMU
to VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working
on a no-iommu enabled device.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig       |  2 +-
 drivers/iommu/iommufd/vfio_compat.c | 46 ++++++++++++++++++++++++-----
 drivers/vfio/group.c                | 13 ++++----
 drivers/vfio/iommufd.c              | 21 ++++++++++++-
 include/linux/iommufd.h             |  6 ++--
 5 files changed, 70 insertions(+), 18 deletions(-)

This needs a testing confirmation with dpdk to go forward, thanks

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
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index 3ceca0e8311c39..6c8e5dc1c221f4 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -26,16 +26,35 @@ static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
 }
 
 /**
- * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
+ * iommufd_vfio_compat_ioas_get_id - Ensure a comat IOAS exists
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
+ * iommufd_vfio_compat_ioas_create_id - Return the IOAS ID that vfio should use
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
+int iommufd_vfio_compat_ioas_create_id(struct iommufd_ctx *ictx)
 {
 	struct iommufd_ioas *ioas = NULL;
 	struct iommufd_ioas *out_ioas;
@@ -53,7 +72,6 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
 	}
 	xa_unlock(&ictx->objects);
 
-	*out_ioas_id = out_ioas->obj.id;
 	if (out_ioas != ioas) {
 		iommufd_put_object(&out_ioas->obj);
 		iommufd_object_abort(ictx, &ioas->obj);
@@ -68,7 +86,7 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
 	iommufd_object_finalize(ictx, &ioas->obj);
 	return 0;
 }
-EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_id, IOMMUFD_VFIO);
+EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_create_id, IOMMUFD_VFIO);
 
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
 {
@@ -235,6 +253,9 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_UNMAP_ALL:
 		return 1;
 
+	case VFIO_NOIOMMU_IOMMU:
+	return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
+
 	case VFIO_DMA_CC_IOMMU:
 		return iommufd_vfio_cc_iommu(ictx);
 
@@ -264,6 +285,17 @@ static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
 	struct iommufd_ioas *ioas = NULL;
 	int rc = 0;
 
+	/*
+	 * Emulation for NOIMMU is imperfect in that VFIO blocks almost all
+	 * other ioctls. We let them keep working but they mostly fail since no
+	 * IOAS should exist.
+	 */
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) && type == VFIO_NOIOMMU_IOMMU) {
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		return 0;
+	}
+
 	if (type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU)
 		return -EINVAL;
 
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e03..0f2a483a1f3bdb 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -133,12 +133,13 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 
 	iommufd = iommufd_ctx_from_file(f.file);
 	if (!IS_ERR(iommufd)) {
-		u32 ioas_id;
-
-		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
-		if (ret) {
-			iommufd_ctx_put(group->iommufd);
-			goto out_unlock;
+		if (!IS_ENABLED(CONFIG_VFIO_NO_IOMMU) ||
+		    group->type != VFIO_NO_IOMMU) {
+			ret = iommufd_vfio_compat_ioas_create_id(iommufd);
+			if (ret) {
+				iommufd_ctx_put(group->iommufd);
+				goto out_unlock;
+			}
 		}
 
 		group->iommufd = iommufd;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 4f82a6fa7c6c7f..da50feb24b6e1d 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -18,6 +18,21 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	if (IS_ENABLED(CONFIG_VFIO_NO_IOMMU) &&
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
 
+	if (IS_ENABLED(CONFIG_VFIO_NO_IOMMU) &&
+	    vdev->group->type == VFIO_NO_IOMMU)
+		return;
+
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
 }
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 650d45629647a7..9d1afd417215d0 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -57,7 +57,8 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
 				unsigned long iova, unsigned long length);
 int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 		      void *data, size_t len, unsigned int flags);
-int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
+int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
+int iommufd_vfio_compat_ioas_create_id(struct iommufd_ctx *ictx);
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 {
@@ -89,8 +90,7 @@ static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long
 	return -EOPNOTSUPP;
 }
 
-static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
-					      u32 *out_ioas_id)
+static inline int iommufd_vfio_compat_ioas_create_id(struct iommufd_ctx *ictx)
 {
 	return -EOPNOTSUPP;
 }

base-commit: 88603b6dc419445847923fcb7fe5080067a30f98
-- 
2.39.0

