Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED08D509060
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381776AbiDTT0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381767AbiDTT0I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:08 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FB846145
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsLaz5Jd+4nbahhaz37Uyi9K/9tOiAHN57x58S4FwQrQhW82eDmI52SXTxf45ZdJcSstfqemPSLZIOCnBa3RrVgPkZNA+kZnHJSfoAFhkOowj2BkQ4Qo20REwvq0aAAY3HiiW7ghOiSsjwZMdMJgbG3CiHQKzi83eeM7DqBcXw2tU7IwuuMbvQi1Q05F/ByswAdK41RbqRzXftCrVbsrcUROdqY5knewdXcCPgbkvVHznMLAhYxXI5WugJkQyw9BgDnwqVCgk0XYsjdGlRV9tRcG1PU7vS49S7m4nHhYj0i+4QTQvoFm4Dy2rnH3dJl/8NqAiad2XIioFDDTBgfaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zn1b/fLCtFnyGYgnpenaucag+dFyfPTCA0mVoJxvcn8=;
 b=EiGyzHGPk44P8Ae9TVzhrPsfQgds7+I78MdNf1lSP+MCmzGKuGKY0x4PxXWnEWU6VryBMrI2eokQdw+rMVpUHeXQl4p/qI2vZJxu6idhz6KQ2+H3Q2z5T4lepf0I/s9RVSji6CdcPXUSreQMI3sr9ckBasax6DWV6yz8EFuw08uWvLQVPoDP5VVmYlM9O3nsVps1SIOsH4fWYCPiE8Usf+OeJBsM/42JO7UcVdItiRsl1US7RHMjPptKO8ACRBNW5EMmerBPGPtsHCv0jQ1SVNTZYDvhxtfmiCoX7rEkxTHYzUIAxs9gP3VB6h3IfM+WQ6HGSbNiJN2cVBJv2PrZcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zn1b/fLCtFnyGYgnpenaucag+dFyfPTCA0mVoJxvcn8=;
 b=DZlOFGDjVGXNN3fD2e2+aD+UC1oJevw69d9bERvFX+uvUeGD2x3aBAy1/7NNPqiEDLHAlyzWjsJ2VuesdzuZOSIgoOapCBrytltbIcIxRlWL+ZjZ0+aS2GT8DyQLv7AE5UfTEpigvUunBw/fjXiOtniVipBUeX+ISPvvclK8FqVXK/8P4hLN8Fn+VV137VlvR2Nxa/uD8ekt7Hd2S9eYyx7acZ9bd6GBZNmWCGsvjBQ1h1ZhzUUfWy+CFlyH7hqlHZ/gE6Bh+JXd/BFBpjfclGTGiTx6k6MV+Ovdagehmx9FNwuYBE6yoMudpnKsr+T43tUOu0GweZWNW8ATINIE5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB4679.namprd12.prod.outlook.com (2603:10b6:4:a2::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 19:23:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:19 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 2/8] kvm/vfio: Store the struct file in the kvm_vfio_group
Date:   Wed, 20 Apr 2022 16:23:11 -0300
Message-Id: <2-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40f24c1d-3103-4707-8128-08da230339a7
X-MS-TrafficTypeDiagnostic: DM5PR12MB4679:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB4679BAD1375F89186F91D0B4C2F59@DM5PR12MB4679.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKUlQSt3U+3qfVwcLDrW/5ACZwesbxaAGmJLWMrGCzbKZZAxRb3OMxbO+on+sOrOOk2m1bmDQtjPOXHqJUcxZQyJCd9wn5oPJYZfrQjYwty/YM/9bSSLXbSRVnyHpv+BotuaulPAaHbRSaCjupkWhSAtfQyOGEeOBmczN+1YzQ3hCPCMG1LhvlKz0FMSC0AySPTV3PBIISMKtakl0Cgw5TwzFLlTRlSLN+LjF6jFseO4TQAJURjZZamV2bdke9G1y0A3X51JGm/9ug7zCsKDTYX0E5MuIhR60MX6t+AsGyC5EYMwI8OAkm1CzViY+bi/a06Pf8pFXwt9Ne7K8CTqMWb0Jo1I0buSMRNXRfYXHUtCpdSznbtcEcspifbZYtQJDHn0WZlxthQ+8erN+hopblKnqe5hYTgIXAzDZwjsHT/dIo9wV8EG6WfztD4++FHg6gSHxxSMpkfC2WqvtIIvyAQw7w6HzPguWP4ENHRP4TvdRZ2iLs7aq681adw7IkLF6iwjG1P32HhN36a1dcwHfDUqQHi+9EsdswlvWQFVu4l6gksdI/oO6V0xUNGIDY9fKiTyRERZBIxaM799SBvvTRQ3Uk34eFk1ga0ZMcMviyv1V325YLMPBUacCPOFvR2oVLJzj6mzgN1YarxKTEAQovRM01wBqfI0XJoT05IzWeCkPiIWB4DZyFlDy00b/CBc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(86362001)(5660300002)(83380400001)(6486002)(36756003)(4326008)(2616005)(186003)(8676002)(8936002)(2906002)(66556008)(6506007)(66476007)(6512007)(6666004)(26005)(38100700002)(110136005)(54906003)(66946007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mN8tJmay41JaOXvEikzfioRfS9v+UgtPmU+xW15+QQBZwWw6vnqy+t7OcEGo?=
 =?us-ascii?Q?qi+5zt+ixChQNESChRck6bfRaow8wgbl35RnxZRKQJFZ0B2Nw0PAmx9jqFWj?=
 =?us-ascii?Q?JDii3MVdK2VuJStS2a4pwF7eDUb4jCSxOblb42zhjNkdDgfHCuy0c8lm6jPx?=
 =?us-ascii?Q?JCUM6pxZn7ez+BbjD5ZPkeyp7lw6jtUGh4bGv6nomeYewFmRbSwCED/A4YKE?=
 =?us-ascii?Q?aJqPN55b5ApiNQTiNsT6hEMG5UQFCDFWp0TmK0pz6oG1lZPLvQfajEWbpEFG?=
 =?us-ascii?Q?h68syetz3deSumFBZlCJsRzRsg1ylmk0EdrNrk7eWe1ETlhYg2LEnZsuoAlp?=
 =?us-ascii?Q?DRTOF+iy5ZuizE6Vk5hPURoqPt9armq3ieCbrbLdrHQjNgdUrxg5+OMxVPYf?=
 =?us-ascii?Q?sm/RcJ4L5fBiuSDfw1u6aQ8H7woJFyNk7ZtUQBgsYF+3JXZxkqj2q6Md0yGe?=
 =?us-ascii?Q?/2ZbV+oLx6FEwCNnyoQJX3A0KfzpLC7qPLXqWntMaJQWjFZ7PVAk81NUpZPB?=
 =?us-ascii?Q?0xxE+Wq+jhyoQ+FXtGSG7kbZFJg86dHNcXzOOj+NoW85L0adcXnXel6xcz0q?=
 =?us-ascii?Q?dySZ4PxwV8z49TQS7zboQKk17iWGmgSpUnFF+ZIUMqCTikKnMSTF+JZp2add?=
 =?us-ascii?Q?A9JLBXnjQ1bMJr52bGQVdsw9Jot//+nhh0wQpCz8/5Kol9r1OtHj2xUtoU4P?=
 =?us-ascii?Q?voyUtuFoYx0E1J+lptwbCrI1omXrLsONmNLZJMQ+HzwpDcfsdRupxP7VWFhv?=
 =?us-ascii?Q?sNGMkcfNG/t4qcNshULdeTZn7hV5p3tDccY66DUsf7z/NUtTzvGp3OfsYP2r?=
 =?us-ascii?Q?09m0+QNVwAPoN55Pwle+7YEjrtOQyt1oS7yobR0s4B02gn9BxYGd02vhMe+z?=
 =?us-ascii?Q?N537dJ7lMHzlr7Q8hrRqWxYWmySpnHjEYajImHuQDFdJwJEmz784HjOVa/W5?=
 =?us-ascii?Q?Z0nb7UDGbHd/tNNkHV6LQRvJH3dp38bfBpJ0c0+JpyI1TxmOiBFG8vI9/g2b?=
 =?us-ascii?Q?KdrFsu0aJdHTJNAwqkF5fDRbtM9V6erHGDD31b4BYsBAllGromsqTRWVkG5k?=
 =?us-ascii?Q?BjnIz8PFhBr8KVemjWBPAPQGIMSubvmLua2otMuX1dLHrgWerufdDVKnqC70?=
 =?us-ascii?Q?9V187C58SZbSzRiq93ZXCtRbK8ov16bJcKf+6QBMNzA++HVxHtwTI1rntxYk?=
 =?us-ascii?Q?CoptW8ns+9hGFlcFT5ZanVh9LQVPsXoCjQBuUzCMubRLMVbD+HM6Xx36UEIg?=
 =?us-ascii?Q?1lxay1ygH6kIpLAXFtzKGVREJ87jjKfhqwNdHTfcKcMJqD+nmTAFB2DqAdqd?=
 =?us-ascii?Q?1AoxUNl+7i61eLXzjEQscjzb1d1RTKf0rR54AZne4zujMBOZ7clgkvgku6Uu?=
 =?us-ascii?Q?HunWwKtJA1Dj/wjNRb3sk/XBhsNdVk5TmMtLdSMurSAIGagB7Wt6X+m3pikn?=
 =?us-ascii?Q?PoaPwNU3FPEinL3KgFJvpBFhjqTDarlnTNrD9iVnpz8tNZh0GUj1RDy3rGLQ?=
 =?us-ascii?Q?Wv9lkGaGquK5dkZFly+fsIhzYxvRnnhLGD/xzr+eRWP12ffgrv/Zjc2QyBcL?=
 =?us-ascii?Q?yEQ2i9/RJ7A5itirM4nFNJ2nXhmOR9zlF0g4gjCqkUx6QQTyVx/TZljd4CUP?=
 =?us-ascii?Q?RGEKHtgXaLWQjL6vfclkqgEYSrvYCc+QR05C+eMVEU2M8teQ08Pd6x1LwQjF?=
 =?us-ascii?Q?bhj2yoLOUXcMYCPISgguiqJf+iEyLBBsvtntTA9bpfsrCYemel7Fg8SulUQx?=
 =?us-ascii?Q?NM5Onl74lQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f24c1d-3103-4707-8128-08da230339a7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:18.6905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KPGB95eVjrj+yyrxqYvJLT9lNzWTN1P8L/HVKg1LZ1rYj33Gt/hL02TF68jrGUpK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4679
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Following patches will change the APIs to use the struct file as the handle
instead of the vfio_group, so hang on to a reference to it with the same
duration of as the vfio_group.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 59 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index a1167ab7a2246f..07ee54a62b560d 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -23,6 +23,7 @@
 
 struct kvm_vfio_group {
 	struct list_head node;
+	struct file *file;
 	struct vfio_group *vfio_group;
 };
 
@@ -186,23 +187,17 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
-	struct fd f;
+	struct file *filp;
 	int ret;
 
-	f = fdget(fd);
-	if (!f.file)
+	filp = fget(fd);
+	if (!filp)
 		return -EBADF;
 
-	vfio_group = kvm_vfio_group_get_external_user(f.file);
-	fdput(f);
-
-	if (IS_ERR(vfio_group))
-		return PTR_ERR(vfio_group);
-
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->vfio_group == vfio_group) {
+		if (kvg->file == filp) {
 			ret = -EEXIST;
 			goto err_unlock;
 		}
@@ -214,6 +209,13 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_unlock;
 	}
 
+	vfio_group = kvm_vfio_group_get_external_user(filp);
+	if (IS_ERR(vfio_group)) {
+		ret = PTR_ERR(vfio_group);
+		goto err_free;
+	}
+
+	kvg->file = filp;
 	list_add_tail(&kvg->node, &kv->group_list);
 	kvg->vfio_group = vfio_group;
 
@@ -225,9 +227,11 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
+err_free:
+	kfree(kvg);
 err_unlock:
 	mutex_unlock(&kv->lock);
-	kvm_vfio_group_put_external_user(vfio_group);
+	fput(filp);
 	return ret;
 }
 
@@ -258,6 +262,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		fput(kvg->file);
 		kfree(kvg);
 		ret = 0;
 		break;
@@ -278,10 +283,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 {
 	struct kvm_vfio_spapr_tce param;
 	struct kvm_vfio *kv = dev->private;
-	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
 	struct fd f;
-	struct iommu_group *grp;
 	int ret;
 
 	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
@@ -291,36 +294,31 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	if (!f.file)
 		return -EBADF;
 
-	vfio_group = kvm_vfio_group_get_external_user(f.file);
-	fdput(f);
-
-	if (IS_ERR(vfio_group))
-		return PTR_ERR(vfio_group);
-
-	grp = kvm_vfio_group_get_iommu_group(vfio_group);
-	if (WARN_ON_ONCE(!grp)) {
-		ret = -EIO;
-		goto err_put_external;
-	}
-
 	ret = -ENOENT;
 
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->vfio_group != vfio_group)
+		struct iommu_group *grp;
+
+		if (kvg->file != f.file)
 			continue;
 
+		grp = kvm_vfio_group_get_iommu_group(kvg->vfio_group);
+		if (WARN_ON_ONCE(!grp)) {
+			ret = -EIO;
+			goto err_fdput;
+		}
+
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
 						       grp);
+		iommu_group_put(grp);
 		break;
 	}
 
 	mutex_unlock(&kv->lock);
-
-	iommu_group_put(grp);
-err_put_external:
-	kvm_vfio_group_put_external_user(vfio_group);
+err_fdput:
+	fdput(f);
 	return ret;
 }
 #endif
@@ -392,6 +390,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 #endif
 		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		fput(kvg->file);
 		list_del(&kvg->node);
 		kfree(kvg);
 		kvm_arch_end_assignment(dev->kvm);
-- 
2.36.0

