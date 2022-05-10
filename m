Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4962F5221D4
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 18:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347737AbiEJQ7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347735AbiEJQ7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 12:59:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B04127E696
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 09:55:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtALVHWC5ywPRqa1YnJtJnmVdophGP7QdNnew4zgg9itYJVTPpVrSeKuOFvzfZK8O7tcoZjntTX2m/rJXSoK3piv30dzRSdlOVd2hIXzEuMD0TU8+K5Qj+C8B4W4/mq9wi42HCwmg4YtTnkyR6oU4LaBR/4/gKbMG6HnqbexZH7cQC9sP4/+CO1P2+vEynDwLupMcITDx3AjCBBheVtyB2IOX4KtH2hZ5DVgG33dDn9n582mQyH5/XM5uYGPUS8uU30S6//HEQR/etHOTH+T0T8duxHGZLN6QYeKP7aRInVbMgDAh2gCA0HIzSvv8ShNmNiFfM/Bk4WNWMvIqie/0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2f24T0uixFS4K6ZPxYlcxUTvVdaTOa4aUDdlEdo0L7w=;
 b=KVAYDB/Yo+qDd98y+CsQ2HaTGU7CdDNMZoI6KZkcxTF+hynN+/VT8AW3kOgPAIl8LfQnEWlgnxie4RZ+nqQ0FkeiEwrNsUu4aj5n5wnUUf1vwSTCnktMBIYXt+hUKmnL97d6BllgvjhC9mXI+y9seWuLk1RTfNGXGgmsk02KMuSgnBoc6cR+LzusMOVQ3NQJYEZ286VAnNNQbs82jAwe0bIszXtSy7wihtg37fXxQ9/jsEhe2uke58UyfP7pDItkQl56pxzjRkrn6MEkc7W2aHGWQgmf33uqH/JEDu3hMHflHNxv7bMTf3f+8HKDsI8dAIYUxeqCEDPmN43rfmwZyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f24T0uixFS4K6ZPxYlcxUTvVdaTOa4aUDdlEdo0L7w=;
 b=OHMF0RmieyQLssS7AB/EaVTX9/cw4nUxSNo0bATFYQRQGc9jLsVfC6AffeRD8dXUff3ro9GWRSVwtqNN89LUQZC4RTWaU0TRdE0xAunGeMEP6gdKKYHoO/DNgdFcl0wzwDGk6eOZJy1B9L9SXHaM/y/IsULEg0kUuTPBmTOQIcGgTfrEl1MDT3EyDmE2cioKpJ2ml0uVgMQY2pBm5SFrQZgOWt8LQYQsO2joZ9V9y7oFZCBIp6huR0mjuMIqqPYWZeOcCyZ3k1JRN7dQ3KVo6yWK9r0sNnl1cEDkkSkO76Ej1r75LfiPBZua/UL5hBVF2wDxU2oI1IKfCtq3ykjERg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB2851.namprd12.prod.outlook.com (2603:10b6:408:9f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 16:55:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:55:29 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Nicolin Chen <nicolinc@nvidia.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Date:   Tue, 10 May 2022 13:55:24 -0300
Message-Id: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:207:17::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf80abf0-89a6-4956-c41e-08da32a5e19f
X-MS-TrafficTypeDiagnostic: BN8PR12MB2851:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB2851F5346393D0F22B453F4CC2C99@BN8PR12MB2851.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a6xrzYLSNknZpaeHMsyWYcNEQPK4/SL6fAwuQEm2BEhnHGf46TvDdSPRph1tSALUlzZEk7FbW4IznreYhu7NT4gw0or8JJOqi3+N/6T0aAkHsbrZ5b7QFEJjTaT9CKcQaZ2Cduw16CTZm/BnUTt8qIZ187eGb8AbDPDbHEPxQhiV+Ln2n8CbVulggoUmk55xDGmeTt5mkM6NP9zGkEvJiEEJb1WDKqz4Z1sk1kshps7k8f78DQMtwPXOfdxBqPdCH70MdFce8eGISSY9M0SZm+dD4kh2HTCuT38at17kW8Q5FFiK346qkxcIHBT4kAnHd4LEQ4Y2nHnH16KAkbEJuWREUehsmudclQyIJ4CJD3Z/z/mfWQB/RwUwM6FBkLPSl4PWZyLAfJRzGoatAxzS6aQ0HXT8pVeZLUZxuPdKlX3iYKT0rzsso//Y1yQhRBjYuQ7C3pIN45GP+fFZdMf0bHpl2RoKu71rDUFpwKMLr22rt105WsMtLRmRAQ/KwE2/XLtr0b7OV+8/d/M3Whe+eK4lk65FN0vKAZ73UcdTsTdR4FiwxCTyr/TF5jUXyoRf6D68OsLuUS6yZz3IFYczsR4ZwDAJV0FDRzhVDIeNH0H/kxVfTOQB0Uzi9w2OQ8zOhIpi1AvnttgOYroQunMKkvPgti3qyYjKqv3kwhjYEkaaZ97AJ13x9Qth7aapZZHjG9sAOzPH8jmATuD7E4laOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(4326008)(316002)(86362001)(66476007)(66946007)(2616005)(186003)(26005)(6666004)(8936002)(8676002)(6512007)(5660300002)(83380400001)(6486002)(38100700002)(508600001)(2906002)(110136005)(36756003)(54906003)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJicLOo+slQjbreQWp5+1FwI++cABdXynGB+MglMy82shT+C9VDb1gELLnCJ?=
 =?us-ascii?Q?u9WCIrK2iOkHeVdu4eVyd5mnm491h/IJO2wOb4rV6q0jqGJ7SWDFypgmhqqp?=
 =?us-ascii?Q?GYPaApx4veU4lfmJhTRjv9DcZblEOZxTwh+OtlC8iLn/V/vG19DIhd3dHth0?=
 =?us-ascii?Q?AitCinsi/CnvyaU+yYhIoSJFdXW7LsOUW2h0ic8hrVZ+8UNSw0UsAJZj4ho5?=
 =?us-ascii?Q?dvrpSP9YXmtxBjOg+p2elTvSPNwKzW3/BTuheTBpKVMpI1htSvNgmUp8IGrZ?=
 =?us-ascii?Q?UOFrdP8jc7oXEGYStYTk0hF4Uv8EiUIhZR/UdXSO+B6HuEuTzV3jodwy6kv5?=
 =?us-ascii?Q?uEFFQ6lVFSyHve1kxLMgzDy13ZxtB53gRuCihhQbB829M9E89/1uEzYfvyGH?=
 =?us-ascii?Q?K21dACqaNQnm1zOTP84Bf6MmFOVd+jSSdxJA5PFiVBK15X1H6ghPNAD0VUGi?=
 =?us-ascii?Q?O9BRrset8T89+Zx8mntWqm/HESkPnblUNtE0aIo8LQv1Z8MHjbWyOVQ3PdtC?=
 =?us-ascii?Q?SeNUDvwsC2ATJaroH9A78ni2C4Y1OiOytDEKm19GZVRA177NmvIk50IDpGAG?=
 =?us-ascii?Q?86iPtn3aMPic30Wiw6zIA8bEfZkA0Cxv98FncB9Za+EYk8SMkJocGJ5HqFhg?=
 =?us-ascii?Q?4qY/1I3toRwtUOKfWdEXC47NCfqB5a+7b9cnfkzPlhZ98oCDef04Ze4TXg5D?=
 =?us-ascii?Q?8uMyHT/IMBnM9iycvbF5xhc6fikoiz4V+F2bET0ywhBO2a6kgFUPMWzW7e+b?=
 =?us-ascii?Q?gyIYWLohF+CxByBgm4l/lkXluCaznkWbn4QF1Xx9r3Ec1TuEYeXFwGG9HgOC?=
 =?us-ascii?Q?t3hH1qGTb09yvXmQb3fGmPYlKaW7ms2GHIkpJDpZyttNiO1LF7TM25NqrB7Q?=
 =?us-ascii?Q?0Ufiod8s5aUpGD2E6usMyHsjFmZl4pucly5cMCVwbCaVIevKM+cZAM0OhBUn?=
 =?us-ascii?Q?gES7nlqmsCh7ygcHVL38wtwz7Neei+xkdRyXaTMBtzG1jKI+qY0cuIdk13E0?=
 =?us-ascii?Q?jKxCcv1/rSLxRiYjxBWYCQzMJvVZ8sHT4APnYedGNrxti+8tJYzLO6e6bky0?=
 =?us-ascii?Q?bnDcY0FlUsnHLpMWbeYU7R3UhR4N7YcyzfYrsQgh9aDZ5g6BzU/SkKGQvOdI?=
 =?us-ascii?Q?hux5T+EEF+AkHpf/F4GppG+Guc76bY2NgGojBi+42q97r+peB9OnUYJAy2kI?=
 =?us-ascii?Q?3VEip+ltf0r90o0Wj7nP7MbRUPNnDt97tJFfjMNjso4pL3JHzxJfBcCQLs9r?=
 =?us-ascii?Q?iBvmSs+S/ZO6OL5huzw9FniBn7pOUO6bov75iKUdC//NS7RkF1wLduLyMufi?=
 =?us-ascii?Q?kdh9M6KUuuB3DiLz8XNT2F0R36cH+9TA6pjb0hiaDCj62i2kUdYLPAc4tTxB?=
 =?us-ascii?Q?np/84Aqnv37t72biJz9ZL0h5186aepyEuSnsATdQjhk7pR0NFUGvmT3VS8qG?=
 =?us-ascii?Q?8WS/smC8i1Wu0ISOh4cYBn6fY1YV5G412AXYF6yREkxgFwgUdC6Vh9A88k4V?=
 =?us-ascii?Q?mZCyRXq4EC0ceohm2vmxqVJThl3gOVsrqhp7XMoSEYmSYwSRRwRUwy6LMNKt?=
 =?us-ascii?Q?ro2RvTE/gONBLbffsguW1NSN/vk4rm9EBKSRkbO93zt7VnSkDoOvIfNDdwhI?=
 =?us-ascii?Q?wDq3u7RYI2RxT0rm+t+2naZVA1LpeCqGmlzp2xBffTlQ8+A/3pqsjNGOiKPk?=
 =?us-ascii?Q?lhxek/aXKYVp6Yc2bjgW9u9O7XLyjR6oYrIMhTgnh/EWcuCWKNOXvbL1qFc2?=
 =?us-ascii?Q?N7j3dpqQIg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf80abf0-89a6-4956-c41e-08da32a5e19f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:55:26.4089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mb3UEYTShIJyIzSl+X07xL9OSSCMKi5OeoR/+RTmGpecc2MthsOV5a8FzxGZH0M5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2851
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This control causes the ARM SMMU drivers to choose a stage 2
implementation for the IO pagetable (vs the stage 1 usual default),
however this choice has no visible impact to the VFIO user. Further qemu
never implemented this and no other userspace user is known.

The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
SMMU translation services to the guest operating system" however the rest
of the API to set the guest table pointer for the stage 1 was never
completed, or at least never upstreamed, rendering this part useless dead
code.

Since the current patches to enable nested translation, aka userspace page
tables, rely on iommufd and will not use the enable_nesting()
iommu_domain_op, remove this infrastructure. However, don't cut too deep
into the SMMU drivers for now expecting the iommufd work to pick it up -
we still need to create S2 IO page tables.

Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
enable_nesting iommu_domain_op.

Just in-case there is some userspace using this continue to treat
requesting it as a NOP, but do not advertise support any more.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ----------------
 drivers/iommu/arm/arm-smmu/arm-smmu.c       | 16 ----------------
 drivers/iommu/iommu.c                       | 10 ----------
 drivers/vfio/vfio_iommu_type1.c             | 12 +-----------
 include/linux/iommu.h                       |  3 ---
 include/uapi/linux/vfio.h                   |  2 +-
 6 files changed, 2 insertions(+), 57 deletions(-)

It would probably make sense for this to go through the VFIO tree with Robin's
ack for the SMMU changes.

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 627a3ed5ee8fd1..b901e8973bb4ea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2724,21 +2724,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
 {
 	return iommu_fwspec_add_ids(dev, args->args, 1);
@@ -2865,7 +2850,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.free			= arm_smmu_domain_free,
 	}
 };
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 568cce590ccc13..239e6f6585b48d 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1507,21 +1507,6 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
-static int arm_smmu_enable_nesting(struct iommu_domain *domain)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	int ret = 0;
-
-	mutex_lock(&smmu_domain->init_mutex);
-	if (smmu_domain->smmu)
-		ret = -EPERM;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_NESTED;
-	mutex_unlock(&smmu_domain->init_mutex);
-
-	return ret;
-}
-
 static int arm_smmu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks)
 {
@@ -1600,7 +1585,6 @@ static struct iommu_ops arm_smmu_ops = {
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
-		.enable_nesting		= arm_smmu_enable_nesting,
 		.set_pgtable_quirks	= arm_smmu_set_pgtable_quirks,
 		.free			= arm_smmu_domain_free,
 	}
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 857d4c2fd1a206..f33c0d569a5d03 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2561,16 +2561,6 @@ static int __init iommu_init(void)
 }
 core_initcall(iommu_init);
 
-int iommu_enable_nesting(struct iommu_domain *domain)
-{
-	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
-		return -EINVAL;
-	if (!domain->ops->enable_nesting)
-		return -EINVAL;
-	return domain->ops->enable_nesting(domain);
-}
-EXPORT_SYMBOL_GPL(iommu_enable_nesting);
-
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirk)
 {
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9394aa9444c10c..ff669723b0488f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -74,7 +74,6 @@ struct vfio_iommu {
 	uint64_t		num_non_pinned_groups;
 	wait_queue_head_t	vaddr_wait;
 	bool			v2;
-	bool			nesting;
 	bool			dirty_page_tracking;
 	bool			container_open;
 	struct list_head	emulated_iommu_groups;
@@ -2207,12 +2206,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (!domain->domain)
 		goto out_free_domain;
 
-	if (iommu->nesting) {
-		ret = iommu_enable_nesting(domain->domain);
-		if (ret)
-			goto out_domain;
-	}
-
 	ret = iommu_attach_group(domain->domain, group->iommu_group);
 	if (ret)
 		goto out_domain;
@@ -2546,9 +2539,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 		break;
-	case VFIO_TYPE1_NESTING_IOMMU:
-		iommu->nesting = true;
-		fallthrough;
+	case __VFIO_RESERVED_TYPE1_NESTING_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
@@ -2634,7 +2625,6 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	switch (arg) {
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
-	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 	case VFIO_UPDATE_VADDR:
 		return 1;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9208eca4b0d1ac..51cb4d3eb0d391 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -272,7 +272,6 @@ struct iommu_ops {
  * @iotlb_sync: Flush all queued ranges from the hardware TLBs and empty flush
  *            queue
  * @iova_to_phys: translate iova to physical address
- * @enable_nesting: Enable nesting
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
  */
@@ -300,7 +299,6 @@ struct iommu_domain_ops {
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    dma_addr_t iova);
 
-	int (*enable_nesting)(struct iommu_domain *domain);
 	int (*set_pgtable_quirks)(struct iommu_domain *domain,
 				  unsigned long quirks);
 
@@ -496,7 +494,6 @@ extern int iommu_page_response(struct device *dev,
 extern int iommu_group_id(struct iommu_group *group);
 extern struct iommu_domain *iommu_group_default_domain(struct iommu_group *);
 
-int iommu_enable_nesting(struct iommu_domain *domain);
 int iommu_set_pgtable_quirks(struct iommu_domain *domain,
 		unsigned long quirks);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index fea86061b44e65..6e0640f0a4cad7 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -35,7 +35,7 @@
 #define VFIO_EEH			5
 
 /* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
+#define __VFIO_RESERVED_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 #define VFIO_SPAPR_TCE_v2_IOMMU		7
 

base-commit: c5eb0a61238dd6faf37f58c9ce61c9980aaffd7a
-- 
2.36.0

