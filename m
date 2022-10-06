Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9A25F663C
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiJFMkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 08:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJFMkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 08:40:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB0675384
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 05:40:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcZXOcRPPEZBQl3Y6s84gl32E5lUJZq7j2iQJHTYjwVHLDPISavy6gXpjTqYUONOP7F27/4zoVQ5LkR7xgQ1tfPthND7fulreLUUUAL3ci7r33BENhuBOQ6MU6rIi4edZ/ukRpwZdZBKFfQb3iSkr+TPNhVaSHuQe27YXBXazcV8coqA2PwdhBd7uCzRfO4W2RduZnaqK2FfnHcGQA3IAm/F3eeTPuESYQRsG2He3qA9vp6d1by1q/s/nSrDCMyebNbADF7PpkY9JBDuQej9COqT5G2ATcSkDz39AMrsWS750ExZ4IjP07fsSdstgNwI5E/edI2rUxmE2J6n9TR/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISc8AUbubynwV2ddyItE7H1+O9wrinso01691wkxBrw=;
 b=junun1xrb3FOZciVn0oH2RcAIjCcZmr/00qiSm5nXuOlhCcluexoJcflAPYXbIx3ROuiGKB9zGWMQUHHjB4cd6PdiCTMox8Z4P44st60aq5Ur6HdUjRYMJcG3n3+fJhzfiIjJpkkFFhUOUX5AVPsStZIVlZNIUnn9zuU7tQjTz3MlWhC1qch/nI5yvWnJpyToDdbLtr1MnmiRWSASIZwlwp1iPaGkCK0gVkzxzTYTZvBrOwtIcdz4v3XDUUTHxuKcoNtzVPeabEyev5bIpOeJCXkl6fZlrCvg2rXyBoe8ScBFlKZwkrBbXwPli7VB2c1izE0wb/Yfx0MDk7615P/zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISc8AUbubynwV2ddyItE7H1+O9wrinso01691wkxBrw=;
 b=W/Y7FrAs+tJBGDCyPtJtc2dZxa4p3Tt3XqCZrlGskwGiWSaUvbYhYdlUv+kAjAwUHKgl/9PgU79MOxFQSEa2SEZ/81Kd0Ay7XRa84udszAcDrcHLvz3WlbgyejS+h92a7/CEJkOGHeANnze7NOob9/+upZBlEZ42srR8m/0Ni7Jjb8lveeQO39holeBi+qJ1vmHw+LQ8QUP0k/0YxHFwh5QcCJpXQ1FppBurLMgbgVCT76grseJ63tcLuIFuaMXDCAr5mBy3U79wLjmEd70Bis3RWidp2LUGqDhT4WWnRG9j708OY3SZ9yVPvFA0a39MG9mx12AfIrGpHNNCefJmuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 12:40:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 12:40:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 2/3] vfio: Hold a reference to the iommu_group in kvm for SPAPR
Date:   Thu,  6 Oct 2022 09:40:37 -0300
Message-Id: <2-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
In-Reply-To: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0052.prod.exchangelabs.com (2603:10b6:208:23f::21)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 121f33fd-22d8-423a-2166-08daa797f942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77COYPb+50i2WiDRyLFf0TVC9REznm5H76FWeBdHO5kVEZuMqhK88lXOfCZBsEAJZlEXBoR/cDRzTaTNGKXp9BFjIpIltLr+aLdLYoHZEwn/3Qa08VY7H317v6rYIvbI/x4l063b8+Q8qWJEP8KqosGo5wBsoAWg559yJ57YN+AV8fphqKJSD7AJV4OFdFfIvVfJtyqXobPfD+8SBJgMDrjq+PRqXl28w7rWsIKePAjJY98Qqo3vQcOS62Vl4XsGlZ+Qc3Uskko7gbTdZ7k3YxZ7wpWLrt2LppSvUd/UMwVdBn4fCeBGh8NY5AtRHhHUjCmJTN4jsKCNj5j/017ddOddPMUNXU+Avs+DdiUE6J1/MbzdkrV0fUXnH0SxHaqN597a0oHFZJpYnWWBFL9vzYER0s55giOOdm1M0yssbd+vGx7UGtwJ9Q4gbgLUkuhFd+3HjJr5KEOwWJjOK+jNa/yJfg3C30queXt8Rjj45s1rMjgpnY/TZ75Cnc1/97E9+6gVnRs49vQz8eelqGmU6+GpKOUQi1YIt6RM/Ad30hzwMBoSbsyajIiVIvFfvd4zSPpzEeVTkZaRTDUomJc/9jLobpItnVdjwPKSrvEQuBpwVjNnl4Rtxi9nVqixFp3wm0L25KOIdgnhPCs4cgrDaLOb9wcE/uJ9g0o6iSC70/olRGaARq35S6B6aCLsV9jscjcnvM2p67Q0UZ/VHxvA+siktOzEHytOdOF7sfit0V76xjnYTU8Scs/VsxOILtBS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199015)(2616005)(2906002)(38100700002)(54906003)(66556008)(66476007)(4326008)(110136005)(8676002)(316002)(8936002)(41300700001)(186003)(83380400001)(66946007)(6512007)(7416002)(26005)(6506007)(86362001)(5660300002)(6666004)(6486002)(36756003)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OvOMPoPd3zHNaGlaXn2zLX9HpJpoJDSdKRkXkhimLqhmKxi9nTy0tp9CKBFP?=
 =?us-ascii?Q?puJf/9+3zSqiX8DpfwTJ6K+BAWRfoYVdHZpst6yQI+IyrIpABj6XZJnhniCA?=
 =?us-ascii?Q?K1cdixCQi0lH6rsGWAOK4nTd9K69/om0B75TsGjY3Vp9CyQgjAy7+AZsHXwz?=
 =?us-ascii?Q?a3RB1sO0uHxOLlBu4OnNO56vFwWBEPGuDKrJHxm0PTejEXmZ0TTkQMWimlD7?=
 =?us-ascii?Q?qOkbLBrUEkt2WgckdC2thGfmjVt0Y+5YASMtFUQP9id7egXyQ3N7I6tqiBob?=
 =?us-ascii?Q?M/oEKc6nB43lb0QKY2DXMQjBAzf9WX4Ir70qDxvSdH6oKDd7De0xpDWScEL3?=
 =?us-ascii?Q?ecghUhOYPKRljBIFbWg2cK616AU4Sav93eyt52VnAZgnFYmkxd41HDDhoDLU?=
 =?us-ascii?Q?E9SBCI3tyHR1yWEpGP4278G/a0Y4AmSRA2nRr6iiIv0GZD+zUogCUNw/Kmr7?=
 =?us-ascii?Q?ISRoQUQ//b2ES/pW0eB59sZmdraLYVr8vcWfsk+uCVqzFgHtoiTF7NN5YuVC?=
 =?us-ascii?Q?sUHe5N5ls0zkaOZWosb6JI+VZ7pdxk+eXvecz+ctGAyrkTH7LkBz+Bc76E29?=
 =?us-ascii?Q?z+b7w9CXeYbLhToQgdqae/M9OPCAchmi5a1KZT4LB3otjTNt8ftCNFePIyOD?=
 =?us-ascii?Q?3ObvCvTqfQdjLniZYYAxBBtAsma5BSyf7sCiTZups61+nX0wBd3egAD27Eso?=
 =?us-ascii?Q?2Z3gYEcJmwvZ/dHyusj56rWeTJNvhdsdhQ5awG2DiNywBkGatnZ4v3NNm6cC?=
 =?us-ascii?Q?xxNaZsUBHam0UqXi3R+mD7DrxpS3noo2eY4ptP0VdLE2WSTYhNclQWGYgPCn?=
 =?us-ascii?Q?oRMiHEUNgU6J9qy9sYYxWTc79keK3gDYoumC8u7cKhi9X0ddFFgzQwtMo1PZ?=
 =?us-ascii?Q?GIQDa10U3GzTvtaoaswcj9nD0PSnorWwk6glhL9lPYX99QKvuYoxniNjpba3?=
 =?us-ascii?Q?OA+xTUOM8KUG8J5ZzzVMj/agOA7xGEMfQY7D933jeRcMxbi9L75ZKG+5fl5X?=
 =?us-ascii?Q?CiqFbMkXSBa/VMGLA13BIqlKsmiX0Zr5ARnPmMT4wKl6e/ObtMZkrnClq5wU?=
 =?us-ascii?Q?vckH82+7tVVBzIxJpWcgu9T52wU8+Kl/Na9KN5DdBEE1RXQaEQrW8I9mquek?=
 =?us-ascii?Q?GVnwXHA++xIHUHDWfnPzeVUJ9KuBhNnhnHZVsLyLFCKrSCxLJqMT2zLLNy52?=
 =?us-ascii?Q?tVjqCeJCQ1JK6HtAgf/Oc3RxpZ9gP39c3gqNYSyWjUxb8k47U+dImLWa8KhT?=
 =?us-ascii?Q?miA5A5t9X1QJqBGd32mDcOVz5JeTj2187ENNJ61ieaegIItg/zYHMFSLXpcl?=
 =?us-ascii?Q?yfcbKeMZuM2DCipAgKu4Ij0xhPUwNBxhIQ7rDWdOQbBhjll9HQ/deEEBr9Hy?=
 =?us-ascii?Q?aeis5XJWKU7tsrODB4k31mcEfJl03mPcTO4R9lZuhguQp01piwr5YUpyjn2q?=
 =?us-ascii?Q?x9NXvur4AHQV8yGdF7WuFpCIKQO+yGzIj0xzgNVlzCVC/UKXV10HAAx3LdoQ?=
 =?us-ascii?Q?tFF0bMIqesWB3fXl1arWgmA2TeeeA1Cw7dqRK8xMRxNzYuk4TWtDZ3fF8fzv?=
 =?us-ascii?Q?y7NvQ1c1wYu1mVU/Z9E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121f33fd-22d8-423a-2166-08daa797f942
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 12:40:39.0888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kKqaJcIcS4h90Vn9ou+5J3eG5HzkgW0LPhEJZYUL4nWE9IBfdRkehiiIJxHBl+4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPAPR exists completely outside the normal iommu driver framework, the
groups it creates are fake and are only created to enable VFIO's uAPI.

Thus, it does not need to follow the iommu core rule that the iommu_group
will only be touched while a driver is attached.

Carry a group reference into KVM and have KVM directly manage the lifetime
of this object independently of VFIO. This means KVM no longer relies on
the vfio group file being valid to maintain the group reference.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c |  6 ++++--
 virt/kvm/vfio.c          | 25 ++++++++++++++-----------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7866849be56ef6..233349867fb36a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1552,8 +1552,9 @@ static const struct file_operations vfio_device_fops = {
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
  * @file: VFIO group file
  *
- * The returned iommu_group is valid as long as a ref is held on the file.
- * This function is deprecated, only the SPAPR path in kvm should call it.
+ * The returned iommu_group is valid as long as a ref is held on the file. This
+ * returns a reference on the group. This function is deprecated, only the SPAPR
+ * path in kvm should call it.
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
@@ -1564,6 +1565,7 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
 
 	if (file->f_op != &vfio_group_fops)
 		return NULL;
+	iommu_group_ref_get(group->iommu_group);
 	return group->iommu_group;
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 54aec3b0559c70..495ceabffe88bb 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -24,6 +24,9 @@
 struct kvm_vfio_group {
 	struct list_head node;
 	struct file *file;
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	struct iommu_group *iommu_group;
+#endif
 };
 
 struct kvm_vfio {
@@ -97,12 +100,12 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
-	struct iommu_group *grp = kvm_vfio_file_iommu_group(kvg->file);
-
-	if (WARN_ON_ONCE(!grp))
+	if (WARN_ON_ONCE(!kvg->iommu_group))
 		return;
 
-	kvm_spapr_tce_release_iommu_group(kvm, grp);
+	kvm_spapr_tce_release_iommu_group(kvm, kvg->iommu_group);
+	iommu_group_put(kvg->iommu_group);
+	kvg->iommu_group = NULL;
 }
 #endif
 
@@ -252,19 +255,19 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		struct iommu_group *grp;
-
 		if (kvg->file != f.file)
 			continue;
 
-		grp = kvm_vfio_file_iommu_group(kvg->file);
-		if (WARN_ON_ONCE(!grp)) {
-			ret = -EIO;
-			goto err_fdput;
+		if (!kvg->iommu_group) {
+			kvg->iommu_group = kvm_vfio_file_iommu_group(kvg->file);
+			if (WARN_ON_ONCE(!kvg->iommu_group)) {
+				ret = -EIO;
+				goto err_fdput;
+			}
 		}
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
-						       grp);
+						       kvg->iommu_group);
 		break;
 	}
 
-- 
2.37.3

