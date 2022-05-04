Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A89351AD98
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245566AbiEDTS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiEDTS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F001488AA
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBsr6CpXr0qPxwqCAMIW0ldWfeG//t66qDM/fb5Ugx9jsnbiikTpBbAwUVuB9V6cZuzun0iZ3iDBGOKfHs+j46K6i3dzumkVY/ipfPr+6mSqY/09neAWCyuqplbdzC8Fdedaqxux7AFm73WBNPcIM54ZLGzmxdaI1nYZNeRfIhGVucV/R0eMH54lZXpFlhE5UKMU0/7sahiuTPYh8Y6yMoCCUN6/VS/NBMAsgDuTsq/0yrUnJt9Np4X8zPeovWax6CQIjIIt1q7q+FMCezilFZv4PjUZCW3Hf6reAOB1XtBjAQCDlmlwwJJI6semUb+QIZhZBIS6BQxSJEET+vqupg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYJtD0ucNDDkRk4xI2n2g+3F8GX6MRgcFKodlSJkXYA=;
 b=klDcc+WbLs63INFmxqzZPs0RB4OuIkohwvq5lrUgUnKf7OIUAwr5UNKG+VQowctXHjNcy2mVM/WNqEaMdlnlXbLSjc8jP8QjXZuTbFWwEEQtlXoTLUgmftMkhC0RhLIB9M6ez14Cv3Tf2T1ebY0HL/C/PkgNtJ8rr10DojrBnMhKtOlVC6/22Xus9mbmOzb8qy29Zsc/75PTW8x7wDG5sC8QcQy24EYO8befskmceeN3uHOjd63U8FnnZ/QJAYL5M59Jez2rvaL9OkKdJo/2MD9ZMeWkfOdVR3m1L8zBO5DTKVbGXKw7aoQLZ68ZsOnbwBRMBjmmB9e0jUdbj91SBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYJtD0ucNDDkRk4xI2n2g+3F8GX6MRgcFKodlSJkXYA=;
 b=PQLIWRYcVmfBw+TVB0YWD8yPkhtGR/b0DZx3Pd3Xa4tm0zGFnmrE4C+8bAmbxL/ViIt+yutLWkzB4wg3uUjxbAsXk2lZwdmurrvUyLLOlCRu6UPfjQ9RmKQENcfy6X4IiMpRVB1YDP7WhZGU4hShnj9j9YGAaoZYHbx/XdYEL/keg3vXfEDc+3EA7ibUWBZYWjOSIxkS7xuiX6mpypDhgR+UjatUkojV+Uz1NgwboIat3i51QD5q8pxvPes9I0YQRSU9azF9bL2HDQ9P1W9LWrCC93p2UdkhYdxat7IEJ6uhLrs2eFTZs0ecu1ejml9w8nTRDydfsbjELYazKF2Rzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:47 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 1/8] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
Date:   Wed,  4 May 2022 16:14:39 -0300
Message-Id: <1-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:207:3c::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d385d836-5835-447c-34f3-08da2e025aab
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1419112132DEE93F147C3B40C2C39@DM5PR12MB1419.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6S3Cbx61wZwMZ38ihYdgBQ1lj5XxTrEIgs5/pwLj5QBR7vovvf6EOaHgUnMPfLLvf4tzcdFRQZsprKRpzCcc/Rm30NhSgbJ0Cf/9ADOsIBAuK4tF1JqJJPUhfR2Pip1UqW7ds5eEmTOlLeYpF7yRu5LWlxJTig63lAQWnz9fFpDHKS9BqhHcelSge6PBVpFOnXeEO7XixnztkC0631QpgLPX7F4lwwbTaFzFD/c4M3z1AbYddjZV4OdEMPn1eYnaNsHzXtWzq9WlbIBm4qDF1tdQD1bb/uikT/rWznYoF8A7NeDmHI7zjOIBZlom3n/FWcQIbEnaJwNK0OGJUoqgfA+EZV64QKtznDZSPLCHinzNyxCexnoou+LlWtOomg68YBBhfmJ3dw76ULuCigtHPGgwc/joKy3VEUnExQD2f0VFQF92lbIg8o2Zi0Y9WZ8z4pQ7Xabf3oL/g3L4gfnEmgY3Zb6CKXP5lU7AB4xSmG7u7pvFH5YLU8g7tK/QWR9I08tdMgX8swGaAn5erTgXt883vMs3IKBLvP/7Gjue2b3R7zf7PVe2rmez9DSHgTzOUhCQa7I7kaVSdoB8SLqYYmCY0H10nPQfnVlfUU78hUSWLMz39mTNX/g9PTwCkBY/V1yeH0QlqCEB9JcKfKuSDs35rXrErDNDaGvm85Np4esD5t1NcqM5ViRN8wLYNq0bA6fhV/vuUgVPLtVKdBSv2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(110136005)(54906003)(5660300002)(6512007)(86362001)(508600001)(316002)(2906002)(2616005)(6486002)(83380400001)(36756003)(6666004)(186003)(26005)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tWoRXUrZEJLkBWpVBFOcqaVLcm3VuJE/BQrdjPO5mktjwgjhHYy3NuH6b1TO?=
 =?us-ascii?Q?A6Z7K3gH9jBwjMCAeTTRoYgUBbzmIwXS7xTk//G+XsVMoKqcHnwOS2Vf6xY4?=
 =?us-ascii?Q?3AzULcK6D3/scVwtCBP1RZTSj8GZTuvrVtyvbTGFdb5cQSUGLK7HaxlEQZTO?=
 =?us-ascii?Q?efkwc07f3sKK30lGofXZ2hHXeRJaKqrG59djH3IFDulXXBxSn+dzGb2xS6Oj?=
 =?us-ascii?Q?rig+GXVWa1W/omtK9H9ulXdlJ/U4hyjPHYAI3lbwVm4eyaw0n8FtNUChmnyZ?=
 =?us-ascii?Q?fdcVetL9qyY+ppVoxLXG1jCZfhPPt+r7mYAOispTJyYq/zGR6SEJ8BJ9j12/?=
 =?us-ascii?Q?hvymMkaqArabcOrSR9M9UyG88CvXUb40K10GwVx1O1xFYAsYV0QJaTA+TQTs?=
 =?us-ascii?Q?VM/U4dLtKqkwim6i+mNnA2yTYzabpBKorYiAXlg5/xH9mYUBbLnvfOZ353kX?=
 =?us-ascii?Q?+ETNSYxvAdZ6mlq7BOZB3mYfJWjhiCTDIboAc32nhgoKcDbfoVjv11dkdbMN?=
 =?us-ascii?Q?ODYBkeH35SiYLigvi9R62A1Z2arF0j9P2D6eHSpCnXTMcdCbzVoZS7kGB80P?=
 =?us-ascii?Q?arNoTCIh2NF9tmPQJ4qjtApsnU6Ptw42rf7+99hn1ckhdtp72ILiqiqDQSHv?=
 =?us-ascii?Q?SstSNetzw0VtD0iqYePusKHFALrRmfdnp71BkYyebTHxPdEDYjHrVY2SxgeB?=
 =?us-ascii?Q?spOI3wXnH+6QPcR3jPQZGIdAeVtec9QTnhmU3z+Srq4wK/HxcIuYKnAUkJC/?=
 =?us-ascii?Q?DkLAXhrP+mdhLsYWJO8afTdmz1LjfVYlLQQofTwk4zWBfMW7vWGITwMbVYsK?=
 =?us-ascii?Q?Pwr4uF1EAD1WiyxYlO2ka8B0cxl2vYhB1pwC6HTE4AV9XDZOHr3Tr2dZSei3?=
 =?us-ascii?Q?TUY/ksTCy0FXGpIfdtdjSsucB/VZxe3YTzIgoEdfPN4PMMlOeC/XFuuNek/k?=
 =?us-ascii?Q?fu9HnkzongZI3cNqTahx5Dn21m3PG9WZDJzrj19nATpeJfweb5CTPTcqVCM1?=
 =?us-ascii?Q?aTBC8s/MufITf9vmrMK0zZSrIMfPUHildYPe4vDORPn7Q+YAssLvGg/5ZDyg?=
 =?us-ascii?Q?HGJqoVpa8u+b2MVicvNF+7TaVGXFGQJoXgGejjWNJDOW8etw52jF8gonvHgy?=
 =?us-ascii?Q?rGwiQoCzvsBwcTnloHRSRYvxsgUyC7WWOsbGPqrk0qtgkslhCqbDSNMvjcRv?=
 =?us-ascii?Q?xnc18lBRJLY1SlhODAQ4IwRVv34I+qaYAo3tRn7E2qbIxWmyc0N0XlzQXmZ2?=
 =?us-ascii?Q?LyTZj9DTBGW8pzpPS/SFC2LTtaQd9EmPxxAPyZO4AAWGND2J4jbJyxTvqnoC?=
 =?us-ascii?Q?SWfl6YK9RU3ugSF+yk0OrWnDoagufUGr4xJiFZsoxOFXk+c2XUn6E0bCJDuc?=
 =?us-ascii?Q?3rm2ye2IrIDl2Eg+Do2om1xVNTLu+TAtx6DG5EpMBAMPJ1+WriqEPVJudJi0?=
 =?us-ascii?Q?Ieypk+qfIS6CjMxOJZUrIv4cV6YxP/+/F7EDxNERdCZWdjG74SzH22jSWIYX?=
 =?us-ascii?Q?SGNO356wvCYp4X5CikwTro4fLMqi/L2ijgRnabx4o1csaj59H4lTrSATDINz?=
 =?us-ascii?Q?fZNdONUK/EfFX+AwKHQBNGo9mQMyz/NAAKuOyxETbG+6a4E7wH4a8+5fIfaR?=
 =?us-ascii?Q?k+Q2DC6gBsm1szaWm15fROTbfjMQazo56Sch4cTt/ZvP3TJ/RiX7KpdPVCfr?=
 =?us-ascii?Q?dZ2UAp6pAB19XejVDaF8ntyjWrdFIF4Qg0WV+dWvTr/qxcVkGcpjeKMxwho3?=
 =?us-ascii?Q?thvYv76X7A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d385d836-5835-447c-34f3-08da2e025aab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:47.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/Oq9QC3bQgvWEtPxMBdUp6JzYrEzC55KufHGdvj4rFdWOntvQckRXp/jO+DUwiz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make it easier to read and change in following patches.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 virt/kvm/vfio.c | 275 ++++++++++++++++++++++++++----------------------
 1 file changed, 149 insertions(+), 126 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50221c2d2..512b3ca00f3f3b 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -181,149 +181,171 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_unlock(&kv->lock);
 }
 
-static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
-	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
 	struct fd f;
-	int32_t fd;
 	int ret;
 
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	if (IS_ERR(vfio_group))
+		return PTR_ERR(vfio_group);
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group == vfio_group) {
+			ret = -EEXIST;
+			goto err_unlock;
+		}
+	}
+
+	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
+	if (!kvg) {
+		ret = -ENOMEM;
+		goto err_unlock;
+	}
+
+	list_add_tail(&kvg->node, &kv->group_list);
+	kvg->vfio_group = vfio_group;
+
+	kvm_arch_start_assignment(dev->kvm);
+
+	mutex_unlock(&kv->lock);
+
+	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
+	kvm_vfio_update_coherency(dev);
+
+	return 0;
+err_unlock:
+	mutex_unlock(&kv->lock);
+	kvm_vfio_group_put_external_user(vfio_group);
+	return ret;
+}
+
+static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_group *kvg;
+	struct fd f;
+	int ret;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
+							f.file))
+			continue;
+
+		list_del(&kvg->node);
+		kvm_arch_end_assignment(dev->kvm);
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg->vfio_group);
+#endif
+		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		kfree(kvg);
+		ret = 0;
+		break;
+	}
+
+	mutex_unlock(&kv->lock);
+
+	fdput(f);
+
+	kvm_vfio_update_coherency(dev);
+
+	return ret;
+}
+
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
+					void __user *arg)
+{
+	struct kvm_vfio_spapr_tce param;
+	struct kvm_vfio *kv = dev->private;
+	struct vfio_group *vfio_group;
+	struct kvm_vfio_group *kvg;
+	struct fd f;
+	struct iommu_group *grp;
+	int ret;
+
+	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
+		return -EFAULT;
+
+	f = fdget(param.groupfd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	if (IS_ERR(vfio_group))
+		return PTR_ERR(vfio_group);
+
+	grp = kvm_vfio_group_get_iommu_group(vfio_group);
+	if (WARN_ON_ONCE(!grp)) {
+		ret = -EIO;
+		goto err_put_external;
+	}
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group != vfio_group)
+			continue;
+
+		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
+						       grp);
+		break;
+	}
+
+	mutex_unlock(&kv->lock);
+
+	iommu_group_put(grp);
+err_put_external:
+	kvm_vfio_group_put_external_user(vfio_group);
+	return ret;
+}
+#endif
+
+static int kvm_vfio_set_group(struct kvm_device *dev, long attr,
+			      void __user *arg)
+{
+	int32_t __user *argp = arg;
+	int32_t fd;
+
 	switch (attr) {
 	case KVM_DEV_VFIO_GROUP_ADD:
 		if (get_user(fd, argp))
 			return -EFAULT;
-
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
-
-		vfio_group = kvm_vfio_group_get_external_user(f.file);
-		fdput(f);
-
-		if (IS_ERR(vfio_group))
-			return PTR_ERR(vfio_group);
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (kvg->vfio_group == vfio_group) {
-				mutex_unlock(&kv->lock);
-				kvm_vfio_group_put_external_user(vfio_group);
-				return -EEXIST;
-			}
-		}
-
-		kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
-		if (!kvg) {
-			mutex_unlock(&kv->lock);
-			kvm_vfio_group_put_external_user(vfio_group);
-			return -ENOMEM;
-		}
-
-		list_add_tail(&kvg->node, &kv->group_list);
-		kvg->vfio_group = vfio_group;
-
-		kvm_arch_start_assignment(dev->kvm);
-
-		mutex_unlock(&kv->lock);
-
-		kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
-
-		kvm_vfio_update_coherency(dev);
-
-		return 0;
+		return kvm_vfio_group_add(dev, fd);
 
 	case KVM_DEV_VFIO_GROUP_DEL:
 		if (get_user(fd, argp))
 			return -EFAULT;
+		return kvm_vfio_group_del(dev, fd);
 
-		f = fdget(fd);
-		if (!f.file)
-			return -EBADF;
-
-		ret = -ENOENT;
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (!kvm_vfio_external_group_match_file(kvg->vfio_group,
-								f.file))
-				continue;
-
-			list_del(&kvg->node);
-			kvm_arch_end_assignment(dev->kvm);
 #ifdef CONFIG_SPAPR_TCE_IOMMU
-			kvm_spapr_tce_release_vfio_group(dev->kvm,
-							 kvg->vfio_group);
+	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE:
+		return kvm_vfio_group_set_spapr_tce(dev, arg);
 #endif
-			kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
-			kvm_vfio_group_put_external_user(kvg->vfio_group);
-			kfree(kvg);
-			ret = 0;
-			break;
-		}
-
-		mutex_unlock(&kv->lock);
-
-		fdput(f);
-
-		kvm_vfio_update_coherency(dev);
-
-		return ret;
-
-#ifdef CONFIG_SPAPR_TCE_IOMMU
-	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: {
-		struct kvm_vfio_spapr_tce param;
-		struct kvm_vfio *kv = dev->private;
-		struct vfio_group *vfio_group;
-		struct kvm_vfio_group *kvg;
-		struct fd f;
-		struct iommu_group *grp;
-
-		if (copy_from_user(&param, (void __user *)arg,
-				sizeof(struct kvm_vfio_spapr_tce)))
-			return -EFAULT;
-
-		f = fdget(param.groupfd);
-		if (!f.file)
-			return -EBADF;
-
-		vfio_group = kvm_vfio_group_get_external_user(f.file);
-		fdput(f);
-
-		if (IS_ERR(vfio_group))
-			return PTR_ERR(vfio_group);
-
-		grp = kvm_vfio_group_get_iommu_group(vfio_group);
-		if (WARN_ON_ONCE(!grp)) {
-			kvm_vfio_group_put_external_user(vfio_group);
-			return -EIO;
-		}
-
-		ret = -ENOENT;
-
-		mutex_lock(&kv->lock);
-
-		list_for_each_entry(kvg, &kv->group_list, node) {
-			if (kvg->vfio_group != vfio_group)
-				continue;
-
-			ret = kvm_spapr_tce_attach_iommu_group(dev->kvm,
-					param.tablefd, grp);
-			break;
-		}
-
-		mutex_unlock(&kv->lock);
-
-		iommu_group_put(grp);
-		kvm_vfio_group_put_external_user(vfio_group);
-
-		return ret;
-	}
-#endif /* CONFIG_SPAPR_TCE_IOMMU */
 	}
 
 	return -ENXIO;
@@ -334,7 +356,8 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_VFIO_GROUP:
-		return kvm_vfio_set_group(dev, attr->attr, attr->addr);
+		return kvm_vfio_set_group(dev, attr->attr,
+					  u64_to_user_ptr(attr->addr));
 	}
 
 	return -ENXIO;
-- 
2.36.0

