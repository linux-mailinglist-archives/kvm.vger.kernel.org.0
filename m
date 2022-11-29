Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CFE63C94C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiK2Uab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbiK2UaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:10 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D21663C6
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:30:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQr+md0QTKjZTGUznpLh2ntaVWAUjNOmyiVbqKPXas6EHnsrIfjj2C+3sKjFrF321Kxw9yrtnxB2telS/JUXC5LpFw2nxvFsZFrtGHJeuAyMmP/zcNXl7m7UVTwGviD2oFKdH12SiYXkyT1+ihScBSzvCaTzmQIz5L20k4UMNL7O00n5RqKc5ATNhXCDKdhLasZJOyI5v7vXnZ6uL3m/SJv58DrfeptDRFLcjAQeS+zGpldhNKkClU6wlIJY8gC45Gshd5FNoHlD/j/soSAANuFhXTkur8ylimaFmVZdP//puX7SYSsCCdUZMVF2bjvwDO2tTmDisRSbMNJZ8kneuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KSWUkrVmsAjWKUgklFLvCAa9hRRb3TmCaqN0+iLdob0=;
 b=asrl0A5upqyO1MrP5HktAo1CizsHexcFxa8WlpnzDJs215+e2uOdi8NSIGwBn5bhLObiAyzvZM1Vsj6bci8JRREzGrJMqqTwkEbZBPoOd7W1wu6c8HeT4wJ8rR6hbvBnoX6Nf+hLPZO98OxVUumlAEi7cjJKZiOZft/+sG06e3ak8tYKmAzxfqt8bPi6zcqPbMfBo+wlQtc0VJ5eagnO0ojGcc9s6YfJSFo+iMn0LKbeIVjh+6gzaTzi72xISETE1UfJINzrySCg8mfOnhmmXKBtrLOlvC1EYtniWik6lS9x6+AqmJB6X6JyGuIjkyX6cmgPgxDuMHzH679/d1CAmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSWUkrVmsAjWKUgklFLvCAa9hRRb3TmCaqN0+iLdob0=;
 b=Gq2qR3JSpWclR0RE4xBgKXYAnK1qPcqbYnZCYur4k0MUYSli3hZWrMGF8j3uz/3PIQpbHzGe6JkPe2cPXP02cqhl9fKXQT+yBcVfRJsFRisjum/xOdw014qZg4FZkQGHBvKoSC9JonJ6ljSke/LGP/GQv6tANa1MnDPgqSTfP3KTyXBlJ90G7l7+j4/7W18ukETNhTaHHfd6ehXeFeGiiPpdVCIUiCnHQD/6MKRwv56tkNBmyEx0f+9PpZvZnAN+Yt49VUyKE6rX2Hi51ga+mp6U069yq5xpNcrJCnwnWKLeHmunNWpOcw3yj2T8oQBojGEBtRZgpcnSPWGb8Vi2gQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:55 +0000
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
Subject: [PATCH v6 14/19] iommufd: Add kAPI toward external drivers for kernel access
Date:   Tue, 29 Nov 2022 16:29:37 -0400
Message-Id: <14-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: b042dfcc-1daf-47d1-44df-08dad24875fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9gYE2q2apmMlDgwNXHdEP9HTQj8GP88u2HChbTy7GivtcXC3ju+G/t5ZkipSR0qhFB53dwDvF5mUcjQNFIo7blgyj28xVFk6z94Z/rpX2rpyzgfnMd61231NqOi/mB95xAS3+hDaJ+fAYrpUkSB7rQ4advs3CVEX0rl6Dlpo4ohutF445dPalhaMoJM5sDU+BiR0DbkWdCCM4Bv4yaxary/pginih3iOrngal85NnPrf70zy5kxmFXW8IjyQLRGXorAMaS+d+hLsh85wJ6vT/XXFDvWyf5/fc8jqOMsB1HBDXsid8mULNdDp2P4zzqoGpcsMoY8yvmev8XWp3j5xIxCuykPbQqkHNbG1bmoqH3Esqd6NlFYOf0wVtX/z+PXTVgvCSoPPu9PHl7UFI/vXKUIqdQDnbNF9b+MrbtpIvr3FlGkjFTPV5n9kL6LygEQ9JA5SL9uJ6k5Ia3Z6XAfcbJ1S9YKJZSfucidaIZIbj2EmWi3RT8tdAsrfTgwPXgo4YVJVLSZ99ZSDDdGHq6vsHqRTBfWghPw+tDQ0wpR8kl0kY5y/GOT9MEcbgrZCg09y6l1wtDIrF6VfZtmIcUL0Yj/IaWKJNPeD3Nvmbd1QFWdTA9jVIdLv+urx8nngXJt5i86dgQUYP+nQrDX2AcvOFYUyTElQV66Kc3IDjYZThO2lJMmqIoOdY9kAHCKzlpMz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(30864003)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nHmjHA20SWUEi5i+UO9N9/4Tj37ZuRpABe2bkoXH+qzUC9oDdmb8SmyWzIGS?=
 =?us-ascii?Q?z6LXBM2YIfgCnaB6nD2c33U/++hCbDxuykhZH2amEXfkbiY32GjJtLnL5G6C?=
 =?us-ascii?Q?R5+I8e9Kc5SrbTs4/TCOMu+IsY6L85FjOkLKh3dlAb9D3rxKrWkPeaERDtbt?=
 =?us-ascii?Q?swHpAH1OB0M7ydooew2Q2Knox3sLiEZ5CsNsXAob7+Bqamgk8tHRwdLeO0GY?=
 =?us-ascii?Q?zBXqKvM9NAGH8xxqIcSqm3PXTh4qMZMTuxBf5S4zT/lNSLp6rxOKvNEgs+uU?=
 =?us-ascii?Q?K1FhhMKTAEhVTbVzwjLjhln4stE4I8gwuwQa/gkwxveJFmfUEJ5vSlMWpC/y?=
 =?us-ascii?Q?3WJ7+wM0WruRbBzqNEXJ+rrlZL77RM558PhH5f9iZnAG/wZ7bsLeMUm1CM+e?=
 =?us-ascii?Q?2NKvlts4ZDKAarNyXtjJB6syVaqUJhA+X/TxE6H1kGWVEvZivw1W5X3M3Vnk?=
 =?us-ascii?Q?DsG6sXMA8JCFU/YDilparGBaqulTfTjdBog6+sKVDpOmcNxVG9+QqwinkuW2?=
 =?us-ascii?Q?SKe8prdBYAS0tu7kWpsZaEThxsF8TVQtwWAh7ojSvgADy2L1VAWAxiaVg6W7?=
 =?us-ascii?Q?lf3jLmWe4RdJjJS1ShUBUhyZ4/QvY/WzIzvjv4yDTWjqUz5IjCH2KeAMf5Q9?=
 =?us-ascii?Q?DE3q1m1x2rDdI/DH0uYTnc6YW3FRxl5dlvCJ4+hl4gzpmSAsdSrYSAZPuTnh?=
 =?us-ascii?Q?HM18dIDDAdlWYdqBA0AlqdrxTw/MSloj+yNbKnioO/GaxYAiaG1nkrW+JU/I?=
 =?us-ascii?Q?oEI7oI1vO5J6pIbs6cgnJ9xpT+Xd7rHMHHE1LbMG6F31mGAG32qwRS8P+N2Q?=
 =?us-ascii?Q?C0oMtPqVEXJf2pXt7XVv/350EffkzLhyXHI4+DeeS+6g7Vm+EpVOzPL7138K?=
 =?us-ascii?Q?4W/lny/+vujbyIbuiDG58VoTMc0JcpLxnB1QarK99wVyigYi1hMAm6mOrzJx?=
 =?us-ascii?Q?maPduQpSqM2VDMTtR1mTUQaSJQpNrfJRjOXzIkAGYlvszuzIWHzwUYVGOQPl?=
 =?us-ascii?Q?LS2Yhi3bEwCRFxGwAvuC13KtpBDH3lbmr70b2bBF+bbx0ZAVZoVsTrptzdtR?=
 =?us-ascii?Q?VltA4EwdXr7j8jBQw+SwXdsdfZtA5FJpo4RACv86mbf2rVc6w9Y0pj1FvosB?=
 =?us-ascii?Q?gKPw0rZ6/m+9vS5gLPg+z6pRLFlrzuc+QDCKqW9GPMwqSXm344kXT0rq3QGT?=
 =?us-ascii?Q?/ijc4t1zH+waQ7kRPVr7005THvKqO2vR/icJQtOTLyYrVpEzXmsSe4C+SqQ+?=
 =?us-ascii?Q?bjCS6ApM0kIgNiFGbo/xTDRtnx7uqtw8alzYRbEKpA1hCu3QpWbV9ym/85WL?=
 =?us-ascii?Q?BnqjO6xTc/b6HkxrA2mhS505FcxF7iLFxVh5YsTolS3ep891DKg8+62iase+?=
 =?us-ascii?Q?jJ4AeEgSBStl+vivJ9t6J38WORBKUkUJZbmeBmazjiytgonV5GVDh2dMOhZV?=
 =?us-ascii?Q?SrqkdWdoSrYTCKfXchmta4hBziASsvR9pI/HM4uDBKAB17V9sNxgeoeXtkpe?=
 =?us-ascii?Q?ITecgDV4ieRMLTrZsrqCgFU4C4+otd7UUeGSncV1Ag6e8ix0Kt80nJl1/0rs?=
 =?us-ascii?Q?IODCwsDigNarxwh5BQ4I32AijwJJo56UWdWh7kko?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b042dfcc-1daf-47d1-44df-08dad24875fe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:49.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeZN8JUOnU3hH1q0VoOzZofvyCcMI60UF80egOCifpN9nlkz5kaCufaso1tVI/5T
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

Kernel access is the mode that VFIO "mdevs" use. In this case there is no
struct device and no IOMMU connection. iommufd acts as a record keeper for
accesses and returns the actual struct pages back to the caller to use
however they need. eg with kmap or the DMA API.

Each caller must create a struct iommufd_access with
iommufd_access_create(), similar to how iommufd_device_bind() works. Using
this struct the caller can access blocks of IOVA using
iommufd_access_pin_pages() or iommufd_access_rw().

Callers must provide a callback that immediately unpins any IOVA being
used within a range. This happens if userspace unmaps the IOVA under the
pin.

The implementation forwards the access requests directly to the iopt
infrastructure that manages the iopt_pages_access.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c          | 316 ++++++++++++++++++++++++
 drivers/iommu/iommufd/io_pagetable.c    |   8 +-
 drivers/iommu/iommufd/iommufd_private.h |  10 +
 drivers/iommu/iommufd/main.c            |   3 +
 include/linux/iommufd.h                 |  43 +++-
 5 files changed, 377 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 67cd00b4d92650..06b6894b77062c 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -6,6 +6,7 @@
 #include <linux/iommu.h>
 #include <linux/irqdomain.h>
 
+#include "io_pagetable.h"
 #include "iommufd_private.h"
 
 static bool allow_unsafe_interrupts;
@@ -417,3 +418,318 @@ void iommufd_device_detach(struct iommufd_device *idev)
 	refcount_dec(&idev->obj.users);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_detach, IOMMUFD);
+
+void iommufd_access_destroy_object(struct iommufd_object *obj)
+{
+	struct iommufd_access *access =
+		container_of(obj, struct iommufd_access, obj);
+
+	iopt_remove_access(&access->ioas->iopt, access);
+	iommufd_ctx_put(access->ictx);
+	refcount_dec(&access->ioas->obj.users);
+}
+
+/**
+ * iommufd_access_create - Create an iommufd_access
+ * @ictx: iommufd file descriptor
+ * @ioas_id: ID for a IOMMUFD_OBJ_IOAS
+ * @ops: Driver's ops to associate with the access
+ * @data: Opaque data to pass into ops functions
+ *
+ * An iommufd_access allows a driver to read/write to the IOAS without using
+ * DMA. The underlying CPU memory can be accessed using the
+ * iommufd_access_pin_pages() or iommufd_access_rw() functions.
+ *
+ * The provided ops are required to use iommufd_access_pin_pages().
+ */
+struct iommufd_access *
+iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
+		      const struct iommufd_access_ops *ops, void *data)
+{
+	struct iommufd_access *access;
+	struct iommufd_object *obj;
+	int rc;
+
+	/*
+	 * There is no uAPI for the access object, but to keep things symmetric
+	 * use the object infrastructure anyhow.
+	 */
+	access = iommufd_object_alloc(ictx, access, IOMMUFD_OBJ_ACCESS);
+	if (IS_ERR(access))
+		return access;
+
+	access->data = data;
+	access->ops = ops;
+
+	obj = iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
+	if (IS_ERR(obj)) {
+		rc = PTR_ERR(obj);
+		goto out_abort;
+	}
+	access->ioas = container_of(obj, struct iommufd_ioas, obj);
+	iommufd_ref_to_users(obj);
+
+	if (ops->needs_pin_pages)
+		access->iova_alignment = PAGE_SIZE;
+	else
+		access->iova_alignment = 1;
+	rc = iopt_add_access(&access->ioas->iopt, access);
+	if (rc)
+		goto out_put_ioas;
+
+	/* The calling driver is a user until iommufd_access_destroy() */
+	refcount_inc(&access->obj.users);
+	access->ictx = ictx;
+	iommufd_ctx_get(ictx);
+	iommufd_object_finalize(ictx, &access->obj);
+	return access;
+out_put_ioas:
+	refcount_dec(&access->ioas->obj.users);
+out_abort:
+	iommufd_object_abort(ictx, &access->obj);
+	return ERR_PTR(rc);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_create, IOMMUFD);
+
+/**
+ * iommufd_access_destroy - Destroy an iommufd_access
+ * @access: The access to destroy
+ *
+ * The caller must stop using the access before destroying it.
+ */
+void iommufd_access_destroy(struct iommufd_access *access)
+{
+	bool was_destroyed;
+
+	was_destroyed = iommufd_object_destroy_user(access->ictx, &access->obj);
+	WARN_ON(!was_destroyed);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
+
+/**
+ * iommufd_access_notify_unmap - Notify users of an iopt to stop using it
+ * @iopt: iopt to work on
+ * @iova: Starting iova in the iopt
+ * @length: Number of bytes
+ *
+ * After this function returns there should be no users attached to the pages
+ * linked to this iopt that intersect with iova,length. Anyone that has attached
+ * a user through iopt_access_pages() needs to detach it through
+ * iommufd_access_unpin_pages() before this function returns.
+ *
+ * iommufd_access_destroy() will wait for any outstanding unmap callback to
+ * complete. Once iommufd_access_destroy() no unmap ops are running or will
+ * run in the future. Due to this a driver must not create locking that prevents
+ * unmap to complete while iommufd_access_destroy() is running.
+ */
+void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
+				 unsigned long length)
+{
+	struct iommufd_ioas *ioas =
+		container_of(iopt, struct iommufd_ioas, iopt);
+	struct iommufd_access *access;
+	unsigned long index;
+
+	xa_lock(&ioas->iopt.access_list);
+	xa_for_each(&ioas->iopt.access_list, index, access) {
+		if (!iommufd_lock_obj(&access->obj))
+			continue;
+		xa_unlock(&ioas->iopt.access_list);
+
+		access->ops->unmap(access->data, iova, length);
+
+		iommufd_put_object(&access->obj);
+		xa_lock(&ioas->iopt.access_list);
+	}
+	xa_unlock(&ioas->iopt.access_list);
+}
+
+/**
+ * iommufd_access_unpin_pages() - Undo iommufd_access_pin_pages
+ * @access: IOAS access to act on
+ * @iova: Starting IOVA
+ * @length: Number of bytes to access
+ *
+ * Return the struct page's. The caller must stop accessing them before calling
+ * this. The iova/length must exactly match the one provided to access_pages.
+ */
+void iommufd_access_unpin_pages(struct iommufd_access *access,
+				unsigned long iova, unsigned long length)
+{
+	struct io_pagetable *iopt = &access->ioas->iopt;
+	struct iopt_area_contig_iter iter;
+	unsigned long last_iova;
+	struct iopt_area *area;
+
+	if (WARN_ON(!length) ||
+	    WARN_ON(check_add_overflow(iova, length - 1, &last_iova)))
+		return;
+
+	down_read(&iopt->iova_rwsem);
+	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova)
+		iopt_area_remove_access(
+			area, iopt_area_iova_to_index(area, iter.cur_iova),
+			iopt_area_iova_to_index(
+				area,
+				min(last_iova, iopt_area_last_iova(area))));
+	up_read(&iopt->iova_rwsem);
+	WARN_ON(!iopt_area_contig_done(&iter));
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_unpin_pages, IOMMUFD);
+
+static bool iopt_area_contig_is_aligned(struct iopt_area_contig_iter *iter)
+{
+	if (iopt_area_start_byte(iter->area, iter->cur_iova) % PAGE_SIZE)
+		return false;
+
+	if (!iopt_area_contig_done(iter) &&
+	    (iopt_area_start_byte(iter->area, iopt_area_last_iova(iter->area)) %
+	     PAGE_SIZE) != (PAGE_SIZE - 1))
+		return false;
+	return true;
+}
+
+static bool check_area_prot(struct iopt_area *area, unsigned int flags)
+{
+	if (flags & IOMMUFD_ACCESS_RW_WRITE)
+		return area->iommu_prot & IOMMU_WRITE;
+	return area->iommu_prot & IOMMU_READ;
+}
+
+/**
+ * iommufd_access_pin_pages() - Return a list of pages under the iova
+ * @access: IOAS access to act on
+ * @iova: Starting IOVA
+ * @length: Number of bytes to access
+ * @out_pages: Output page list
+ * @flags: IOPMMUFD_ACCESS_RW_* flags
+ *
+ * Reads @length bytes starting at iova and returns the struct page * pointers.
+ * These can be kmap'd by the caller for CPU access.
+ *
+ * The caller must perform iommufd_access_unpin_pages() when done to balance
+ * this.
+ *
+ * This API always requires a page aligned iova. This happens naturally if the
+ * ioas alignment is >= PAGE_SIZE and the iova is PAGE_SIZE aligned. However
+ * smaller alignments have corner cases where this API can fail on otherwise
+ * aligned iova.
+ */
+int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
+			     unsigned long length, struct page **out_pages,
+			     unsigned int flags)
+{
+	struct io_pagetable *iopt = &access->ioas->iopt;
+	struct iopt_area_contig_iter iter;
+	unsigned long last_iova;
+	struct iopt_area *area;
+	int rc;
+
+	if (!length)
+		return -EINVAL;
+	if (check_add_overflow(iova, length - 1, &last_iova))
+		return -EOVERFLOW;
+
+	down_read(&iopt->iova_rwsem);
+	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
+		unsigned long last = min(last_iova, iopt_area_last_iova(area));
+		unsigned long last_index = iopt_area_iova_to_index(area, last);
+		unsigned long index =
+			iopt_area_iova_to_index(area, iter.cur_iova);
+
+		if (area->prevent_access ||
+		    !iopt_area_contig_is_aligned(&iter)) {
+			rc = -EINVAL;
+			goto err_remove;
+		}
+
+		if (!check_area_prot(area, flags)) {
+			rc = -EPERM;
+			goto err_remove;
+		}
+
+		rc = iopt_area_add_access(area, index, last_index, out_pages,
+					  flags);
+		if (rc)
+			goto err_remove;
+		out_pages += last_index - index + 1;
+	}
+	if (!iopt_area_contig_done(&iter)) {
+		rc = -ENOENT;
+		goto err_remove;
+	}
+
+	up_read(&iopt->iova_rwsem);
+	return 0;
+
+err_remove:
+	if (iova < iter.cur_iova) {
+		last_iova = iter.cur_iova - 1;
+		iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova)
+			iopt_area_remove_access(
+				area,
+				iopt_area_iova_to_index(area, iter.cur_iova),
+				iopt_area_iova_to_index(
+					area, min(last_iova,
+						  iopt_area_last_iova(area))));
+	}
+	up_read(&iopt->iova_rwsem);
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_pin_pages, IOMMUFD);
+
+/**
+ * iommufd_access_rw - Read or write data under the iova
+ * @access: IOAS access to act on
+ * @iova: Starting IOVA
+ * @data: Kernel buffer to copy to/from
+ * @length: Number of bytes to access
+ * @flags: IOMMUFD_ACCESS_RW_* flags
+ *
+ * Copy kernel to/from data into the range given by IOVA/length. If flags
+ * indicates IOMMUFD_ACCESS_RW_KTHREAD then a large copy can be optimized
+ * by changing it into copy_to/from_user().
+ */
+int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
+		      void *data, size_t length, unsigned int flags)
+{
+	struct io_pagetable *iopt = &access->ioas->iopt;
+	struct iopt_area_contig_iter iter;
+	struct iopt_area *area;
+	unsigned long last_iova;
+	int rc;
+
+	if (!length)
+		return -EINVAL;
+	if (check_add_overflow(iova, length - 1, &last_iova))
+		return -EOVERFLOW;
+
+	down_read(&iopt->iova_rwsem);
+	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
+		unsigned long last = min(last_iova, iopt_area_last_iova(area));
+		unsigned long bytes = (last - iter.cur_iova) + 1;
+
+		if (area->prevent_access) {
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (!check_area_prot(area, flags)) {
+			rc = -EPERM;
+			goto err_out;
+		}
+
+		rc = iopt_pages_rw_access(
+			area->pages, iopt_area_start_byte(area, iter.cur_iova),
+			data, bytes, flags);
+		if (rc)
+			goto err_out;
+		data += bytes;
+	}
+	if (!iopt_area_contig_done(&iter))
+		rc = -ENOENT;
+err_out:
+	up_read(&iopt->iova_rwsem);
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_access_rw, IOMMUFD);
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 756d347948f0ec..4f4a9d9aac570e 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -458,6 +458,7 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 	 * is NULL. This prevents domain attach/detatch from running
 	 * concurrently with cleaning up the area.
 	 */
+again:
 	down_read(&iopt->domains_rwsem);
 	down_write(&iopt->iova_rwsem);
 	while ((area = iopt_area_iter_first(iopt, start, last))) {
@@ -486,8 +487,11 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 			area->prevent_access = true;
 			up_write(&iopt->iova_rwsem);
 			up_read(&iopt->domains_rwsem);
-			/* Later patch calls back to drivers to unmap */
-			return -EBUSY;
+			iommufd_access_notify_unmap(iopt, area_first,
+						    iopt_area_length(area));
+			if (WARN_ON(READ_ONCE(area->num_accesses)))
+				return -EDEADLOCK;
+			goto again;
 		}
 
 		pages = area->pages;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 72a0c805be2335..40302cc0da3603 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -65,6 +65,8 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length, unsigned long *unmapped);
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
 
+void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
+				 unsigned long length);
 int iopt_table_add_domain(struct io_pagetable *iopt,
 			  struct iommu_domain *domain);
 void iopt_table_remove_domain(struct io_pagetable *iopt,
@@ -106,6 +108,7 @@ enum iommufd_object_type {
 	IOMMUFD_OBJ_DEVICE,
 	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
+	IOMMUFD_OBJ_ACCESS,
 };
 
 /* Base struct for all objects with a userspace ID handle. */
@@ -246,6 +249,11 @@ void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
 void iommufd_device_destroy(struct iommufd_object *obj);
 
 struct iommufd_access {
+	struct iommufd_object obj;
+	struct iommufd_ctx *ictx;
+	struct iommufd_ioas *ioas;
+	const struct iommufd_access_ops *ops;
+	void *data;
 	unsigned long iova_alignment;
 	u32 iopt_access_list_id;
 };
@@ -253,4 +261,6 @@ struct iommufd_access {
 int iopt_add_access(struct io_pagetable *iopt, struct iommufd_access *access);
 void iopt_remove_access(struct io_pagetable *iopt,
 			struct iommufd_access *access);
+void iommufd_access_destroy_object(struct iommufd_object *obj);
+
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index fe98912bab0e02..4153f6a2025559 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -357,6 +357,9 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_put, IOMMUFD);
 
 static const struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_ACCESS] = {
+		.destroy = iommufd_access_destroy_object,
+	},
 	[IOMMUFD_OBJ_DEVICE] = {
 		.destroy = iommufd_device_destroy,
 	},
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 185dff3eb32f16..46c481a26d791d 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -9,10 +9,12 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/device.h>
 
+struct device;
 struct iommufd_device;
+struct page;
 struct iommufd_ctx;
+struct iommufd_access;
 struct file;
 
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
@@ -22,6 +24,11 @@ void iommufd_device_unbind(struct iommufd_device *idev);
 int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
+struct iommufd_access_ops {
+	u8 needs_pin_pages : 1;
+	void (*unmap)(void *data, unsigned long iova, unsigned long length);
+};
+
 enum {
 	IOMMUFD_ACCESS_RW_READ = 0,
 	IOMMUFD_ACCESS_RW_WRITE = 1 << 0,
@@ -29,11 +36,24 @@ enum {
 	IOMMUFD_ACCESS_RW_KTHREAD = 1 << 1,
 };
 
+struct iommufd_access *
+iommufd_access_create(struct iommufd_ctx *ictx, u32 ioas_id,
+		      const struct iommufd_access_ops *ops, void *data);
+void iommufd_access_destroy(struct iommufd_access *access);
+
 void iommufd_ctx_get(struct iommufd_ctx *ictx);
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
+
+int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
+			     unsigned long length, struct page **out_pages,
+			     unsigned int flags);
+void iommufd_access_unpin_pages(struct iommufd_access *access,
+				unsigned long iova, unsigned long length);
+int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
+		      void *data, size_t len, unsigned int flags);
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 {
@@ -43,5 +63,26 @@ static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
 {
 }
+
+static inline int iommufd_access_pin_pages(struct iommufd_access *access,
+					   unsigned long iova,
+					   unsigned long length,
+					   struct page **out_pages,
+					   unsigned int flags)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommufd_access_unpin_pages(struct iommufd_access *access,
+					      unsigned long iova,
+					      unsigned long length)
+{
+}
+
+static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
+		      void *data, size_t len, unsigned int flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IOMMUFD */
 #endif
-- 
2.38.1

