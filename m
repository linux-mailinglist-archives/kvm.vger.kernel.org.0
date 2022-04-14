Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE253501B3C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344218AbiDNSsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243073AbiDNSsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B684CDB4A9
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGh5hqDmYA1NsPq0s09MHDtWY5Cncu9058UFA38vjECviWSwwSsPcYMWe7zD4j0VUN4LoYDNZM6FxVb1wAJhlpnemC07OUr7D2gizfImyTyDsiNYhcKyDXmrHzD+urDFKY+k7wJh19fWazPTFl5luEABgwl5EhtJOS+LlDaF+LvyuvtBrXtI1nGfWlT6KTznzL57QL7J6dG0UgMHfvFmXTVSEMHXgl5lLsqmYwtp9XgwJp+qlLkjqq8uUSQZKhxQDuLGyLfimTaqBsJV1Ec6dX/2n0k1njI5buhGpbtwFA4zEoTrJw9eEnbeoX82wSI1UtvbPA9kwJrC6wetfJaKDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeB8zsfNocOWeq+KHtYMknWpSMIwC5gV9pKb5oElmAE=;
 b=lc7D1MO7har8Enp456300ZLS6Pt/SzjIY0bxqPWP8dujoHkCrJOCq+/jLYa+65lo8Ab547eZtnq4AdyGZj6k0e9giEAx6CeE3Dy4M8KxdhoXeX6M0b+Q1ibvxnzYpIarioXkcZnCmMdjLH7geJJHYCdN6RqhPVBDmRBtpxCLRY6XlNH4mvOsEOTScA5Nu5Nn3ht4f4ZM0piUIFWijgtQBC7fRhY18sf7oolzso4IBW4gbpnhqezHuUycaxzR83xsE/vaWjvSgNOs96ypht706UcwjKvlavyLRwhw7K1vUj1ZOFT5sZp/fGPStzjp13RAUVQzEudMHdV7Gk2rbg0IcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeB8zsfNocOWeq+KHtYMknWpSMIwC5gV9pKb5oElmAE=;
 b=j8+zeeT5UPui7kuEQsjEYRtrsgixvbSgYIHQNdATSmjiPQdQV/+bMko4QcXxR5QWti/4yTg6QGguLYzoKoOAV7pzg4Ck2jpJ9DpPDSuEgNt3K4hkOMEBkLkyTn1BIMQyX79wgbZrTxQh37EQHfK/h7pReJM+nrjE7NkVZYLGPRfGk2qjJhRNkpUywMrJRgp+lNnNivMkij5Gj5oj0ApPD12io+W8Nea6eBlHkTsIKmKcCXdaHS4bqudzmEGZyrMwlPMNCRKhwWcPppgSVQFxU5P7Vzpj7WXpBNNmgiW1Kfs53x4CZUUMxpp7AIdE/OtJgJbB1pRQkw4QFtcn3e6Hxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:11 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Date:   Thu, 14 Apr 2022 15:46:08 -0300
Message-Id: <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8d9dbc7-1c21-4577-3337-08da1e470b50
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5350C67CFD2E125DF9B24FDCC2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLIhzwZ4KvaXkGd+Wc2XeKH8G+nr7SMoioCjW5MNj/NJt6/GjpWdloM7aNcZVZfZx+pUiUV6Q0HD/3NauwK4Vfschc+u/jJlF73UwEhHWp7qCw92L/i5rZAyA0ei2VIe7eiNsT2x1c9koymXwVOHJWuzzTMHz81RhaA/DxqUR36X7jRrkUph1AHmXobZCuso5ptyZksuRQ34+FMz8hARyv2ZOY2I+xw8s8COxx/NeqGmsSr0jXidnBUU33tU4i7UljAFoSVfCWcxvc45g6WurUPYuXWRZkgtaDtzV+TWfiCP//dE2kj0mNl2H/pjJL5pWDj5Stjp+g8ZC/PYFHTkkwnTwyDkUw7cul5z4B0bKswkdT0qxx0BhcM70IODQlRW/j80hJXLffoO5QHrMKNIaMtZTsrXqH7PypY2gjVPXmDDWtdLy/Zw0RnJ/pcJi7sNfF59pqzclVORRlJAGbrCWz1ur4gRIoa7453/+K5rbJOlEkwbESka1TEptz+a5u9XYMn2BXRbLTBIOagtfzvLjtNI3yXPW7/7IziYfoy2gud4TKlGSc/u2GrT0Nph2TbP8kDz4A2DekfhB44Wr0fDwsyyCsfbpnDt7Espc/pJ46mdsC0f5P20FEIsJeRTe9ZCV5VmC5EJRpfFDMOXCn8NqA2x8SeI8+e6ctZmpNneyJfQz3fHxKe9Op8WFijhq2SkR25ljFppwMM/hj/DkfJx5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n6NucSvzO+JdJOyQV9OJOAurb57VHD5qhknIQc9fumTFBpUUz9qz6ZlLpbYP?=
 =?us-ascii?Q?g4n37np+1ifBu3JPRA+7Hv0mzI7nJwDS2uVmKm1IJeglG4JtEPubRmYOnMYl?=
 =?us-ascii?Q?NTyO+vQ03JlE1tLhEvdIro5ITajKpUdtN2Y6XODXrvp4ka1CCO62MD45Ks5t?=
 =?us-ascii?Q?G/EGGRB4KIxejrZ9aZeE78pt65ClS+jjJ4K5o7Ad81X3F2tW0qiS2tWKgeA0?=
 =?us-ascii?Q?sJXoS7SDGc3ppgU1T0BuoP/gBEpzqSuBYKlFOCOfszG0GQgqQYJfBkjf2GFH?=
 =?us-ascii?Q?Hz7WrbTeHdpWNbVzhcrTiSEz+11H/dlasezdGSfI3dt0kndvAP/cF60CnJcn?=
 =?us-ascii?Q?oaJa777uECz/Gt+8yd5/WNats5d8qRRh19rD5acJW5JJZ9w1ZQ8BEhQgZBZq?=
 =?us-ascii?Q?CzMV77Z6ioeHxLhKVbKJcT5mTxWf/HBLG8SbJ6s1t4vUOGvHpeX5sQFW3p/b?=
 =?us-ascii?Q?TolOXVrPJa3C5g8ywx2Quva2qfDy9MCLMON8QmE49bZr9rKD4OUAKEEikQB6?=
 =?us-ascii?Q?3KFacDMAvGh1zrTHHDDTUjWNBZuPdNg1sTIN+DrEHlNjbTcAXJu8fgaYQix2?=
 =?us-ascii?Q?jRiTkLx/7Mf5N0M8idXgK/g6jhn2UR1wtMQ6a0Pq2BkBt63Hg4WtgWlcb64n?=
 =?us-ascii?Q?ajkIMkEWXWA86wKoRrGcyLM36uJhelV94ysfwlkQZxE+yWzQYagB27xmKcYJ?=
 =?us-ascii?Q?+Z3rqZuUUUNGZ7uQi+s6HZG5/sfNAqHFwvgYCbKZD+LfoJHiuoI4YuwnBnzB?=
 =?us-ascii?Q?PkGNN/VpXiyZnpa2hxXIBF0qyaba50Hih2poAF+zNTyxDNIOBmEeYKbO5VW5?=
 =?us-ascii?Q?jm5UqqLHjDx4wyCJPUiozCpSYYqu6/3jNYqWBtRTGulhPtyqy8esPxNIzOW8?=
 =?us-ascii?Q?0YzlsQmlRzvBMFQNqSk8qwEWt2x0DC80UaYXAcJYq8K///iiw/eyIWyl6/h1?=
 =?us-ascii?Q?p0uj6ldrVp3jrTsIj39IRw0P+eXfTcYkuEuwD6/sePj61hVP3/TklPwdLPXi?=
 =?us-ascii?Q?T4hueKsfbmqDa4AzPjeUDmxLAclkJXoxDf0tjYBNcBgwVRlw06VJxmJwNUyY?=
 =?us-ascii?Q?ETntPH6lUNQmoAleqDYWUnms4Tf0ykxwlx36p3bnTBLQXJ5A5H95PMbJU8Wh?=
 =?us-ascii?Q?OOPe3ve0FHekTs1LQeVwIs/oHgd8+6+AThbfQDE+DucBuQzVAggvZPd4HSp6?=
 =?us-ascii?Q?V70WEcZXzlxH1XMgc4xfp9fWeWafZENBTS/eOsvgk6nIwOhg+f5giSu8//16?=
 =?us-ascii?Q?ij1+soZCzHKhMaxHWRfb2INMmMwu9UtACclKvZQNcRbd6XUmq23ACCQwQ3fx?=
 =?us-ascii?Q?uQAFCLMzddbkVf+y2WktBQUNC9jkHJ9N7bKzkBY5o/EcCW7/xkzR9A3vjXJE?=
 =?us-ascii?Q?35xQz8bgB4PNj9WcN5dvn0V3pDqMsCF1pZYjvV3XerB2tANk4wZ7DXTUALz4?=
 =?us-ascii?Q?8ICvEgq5t6KhFXyE6KKon5ak1fVEJHpot9MQw7h3PuSgesHHEO1EpD2WgKcQ?=
 =?us-ascii?Q?I16W93F5qEgXBqgtHVD9v0wGp1/5LiXOlewQ+peSpdeUFe/PHGlOyV7kRvFb?=
 =?us-ascii?Q?aa+iGUrcuZjSux/2WbXwKhqdZ+CjHXQdCxrE3a3aLL9CMdHrlIMAqi7kFEEQ?=
 =?us-ascii?Q?wObR0GjIaIDLOJ18LHAHRUCvqA7HlQgZDmdOtEfclj6oI1cr39wgnhHc1Yd6?=
 =?us-ascii?Q?urtbFeCRo2GxDUGbzfrVDB1a29HKu9OpyrjTHXQEGwQqZw9V9TH5Tp9OKdXW?=
 =?us-ascii?Q?g5Rqv3AkgA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d9dbc7-1c21-4577-3337-08da1e470b50
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:10.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVKsOe0RJa3IHMd4oCdlrn1WBeJlWekoRsPkqYTCTB6k2y/AClTUNQ544KaF9Xko
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

None of the VFIO APIs take in the vfio_group anymore, so we can remove it
completely.

This has a subtle side effect on the enforced coherency tracking. The
vfio_group_get_external_user() was holding on to the container_users which
would prevent the iommu_domain and thus the enforced coherency value from
changing while the group is registered with kvm.

It changes the security proof slightly into 'user must hold a group FD
that has a device that cannot enforce DMA coherence'. As opening the group
FD, not attaching the container, is the privileged operation this doesn't
change the security properties much.

On the flip side it paves the way to changing the iommu_domain/container
attached to a group at runtime which is something that will be required to
support nested translation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9baf04c5b0cc3d..39834a0653d83a 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -35,7 +35,6 @@ struct kvm_vfio_group {
 	struct list_head node;
 	struct file *filp;
 	const struct vfio_file_ops *ops;
-	struct vfio_group *vfio_group;
 };
 
 struct kvm_vfio {
@@ -44,35 +43,6 @@ struct kvm_vfio {
 	bool noncoherent;
 };
 
-static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
-{
-	struct vfio_group *vfio_group;
-	struct vfio_group *(*fn)(struct file *);
-
-	fn = symbol_get(vfio_group_get_external_user);
-	if (!fn)
-		return ERR_PTR(-EINVAL);
-
-	vfio_group = fn(filep);
-
-	symbol_put(vfio_group_get_external_user);
-
-	return vfio_group;
-}
-
-static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
-{
-	void (*fn)(struct vfio_group *);
-
-	fn = symbol_get(vfio_group_put_external_user);
-	if (!fn)
-		return;
-
-	fn(vfio_group);
-
-	symbol_put(vfio_group_put_external_user);
-}
-
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -121,7 +91,6 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
 	const struct vfio_file_ops *(*fn)(struct file *filep);
 	struct kvm_vfio *kv = dev->private;
-	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
 	struct file *filp;
 	int ret;
@@ -157,15 +126,8 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_free;
 	}
 
-	vfio_group = kvm_vfio_group_get_external_user(filp);
-	if (IS_ERR(vfio_group)) {
-		ret = PTR_ERR(vfio_group);
-		goto err_free;
-	}
-
 	kvg->filp = filp;
 	list_add_tail(&kvg->node, &kv->group_list);
-	kvg->vfio_group = vfio_group;
 
 	kvm_arch_start_assignment(dev->kvm);
 
@@ -206,7 +168,6 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		kvm_arch_end_assignment(dev->kvm);
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 		kvg->ops->set_kvm(kvg->filp, NULL);
-		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->filp);
 		kfree(kvg);
 		ret = 0;
@@ -322,7 +283,6 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 		kvg->ops->set_kvm(kvg->filp, NULL);
-		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->filp);
 		list_del(&kvg->node);
 		kfree(kvg);
-- 
2.35.1

