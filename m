Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B3B501B34
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiDNSs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343506AbiDNSsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A19EDB4AF
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzb28QTmgBe3JHjHuqhIr9J4iHJmiUwrOuaYR7fzTRxRXJO28b2QksUnMCt4j9F1DByZnxfsNxZQSmipeB15VhcnjdDP8af4mvk69YiwOd0K+poKkYeiSZyb5sE9Q2YjVpbTNG8g50qfNy++jFHRaV8oY8H4lG9enLKQxNcU6kEA0cKvJ3eP6hDl+u62z0Mh1UBoeiP6ThUH+wdcAhVvC2PGZbO1usJtPyV60tDqz6sy4cU1AU18QN82DnQyBcan34ZyGpFASkBhXuLBVBUUN+hg0MQN8+ttx8IASA/FYbMXYnQJV4o+7JXzakjQdLyRv04bIuwQzV3hteL2WCm+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7HwqU4CVVpa1hZL/FSuZyYkP6DLD+qB3i4kl7jhiic=;
 b=DZmBE34vcWdk3YR5Z6qpeXOuduc2657PaXTAmWy/TxybVCl+53GkJE34WfzTxBjNO92ysq1xkQa63olU7D4jt4aLg4/5kBuFAgsfZVrFJrUsg2av6ZSOuw35U8iBpm4AXhB82w8JG1iULVXY9f/CAXiEic/xoLnDSZAIT16WhKyuWWTXzqAofUmHl2wAuUJdbiXk2IxIyhvOzN4Ss5FeDWqDYGBQx1WZWwLyFNv/PFGhmmRPlu+p0TNluq+mnMfhJrlGk46oNl8N2UryXL3zuBg8e05+OL7ijmZ4viKm105Nj9W0feSMeDyvp4Ibwh+SyERuOn+6MWGiK5PLSm9LhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7HwqU4CVVpa1hZL/FSuZyYkP6DLD+qB3i4kl7jhiic=;
 b=YPN45g/VHfMcrPudc/lpyq2K8Q0OYWjunwq4UqTjDjSQMIFRhEQI9d5pydehCJlmk5aFiyt1E2HdhA8KpKmdP7BnW+g40R/PNLwCv5sS9fUdZ9nglUDy+fKT2B7L5eqHD+qHvieFsQuxXmEQiC3eotWbaRPwu2ndYdmC1y7ZOhfbfnbBNzNmRX2Cwr7WVm0kIStEGoFo4x8/sV1A0RKeQ1ErL6HKbOnYJiNqEtle5aIl5IcRjbpdtQtWa+1T0F/OWwK18197t/lu4KUuOB/p6Ksc75BZZFioRSkX/ekkkM7rZ7sVQAOezf3sBGYravmJWpcG9ouwso7AwQEvGsQl7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 07/10] vfio: Move vfio_external_check_extension() to vfio_file_ops
Date:   Thu, 14 Apr 2022 15:46:06 -0300
Message-Id: <7-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cfafcfe-607d-4d1b-e49d-08da1e470c4c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5350214D40A68116E9B31D07C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LlZm2sRbYS44pnBYfupwqTNmCIjorWcJq+Q6CuWDG7udfO0CmDxSyTdPCcHMnnGU7HKa/gFgwPwoGgl++OAQNTt5pSgmCscxYFrsY6Os+kwhmSuZqTbSzWxOZV4XmCzr89iM/6Bt3pk8gUe4n8h9M/fPhUc9EjMqYxoUS0Ub978uIEwXUtgTTlQqHj9gHG2+ZwSl4xgUBHZZ/1DBNXjm2UhYknMapf2GV4o6SjhsM6mdzpYMIKRFDDzA+qol8fDjlNQ9wqW/sXeA+0BnkwoGGtwpE+nLRMCwbbFicJJC94lAoul55rHIONtSwWoL+uumloN7uNP8qcEOd85N4iyMK/wJFKEh4hUvJWJJWRTMjkPxLe24AkOm5mWeV/AY8aMeOUuVrn/uzTVahMS7wnYnTBnqHyAItO4dCL28AJGn5nuREZH6E4pBbVyEJd9ZoWxN9xpgE3nfG9u9TiqEs4dnHnZrkgx7wPK5FCkNIaz3Lwtb04M4k/cEkBDbpoLog97xMHnPoo8juulSJCVKFIaDC1AA+8KI+cqKjXWXORJdwdKsnWOeIkRD3Owq6GdPUp5SanwaImW6ubIzLibTN8nXlKfICkeWkXxoM+7VGoMKMuPDDzNpVb1nG6VJRze42K6WrcZyft+crtxNGj5vO//SpkgD5L3WCMTD4PP4lhC3/E089+m+0aIO0QE8HMu0g6O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3QwU6r4NDdBLl0WaBoLuTwtMtrjXoQ69kUftn7Ndr8eGLGSV6X+2B0CPItDm?=
 =?us-ascii?Q?/tLJt6ybmHJGRMcm6Gh73af4Nu+Hl8UeXHlXZdFGw03LBQyH+6c52UYf8cw+?=
 =?us-ascii?Q?ePXfDjjXqmgMprKaTORnLqoy6HulQ2ZoFJxqKrk+ZInH7g010HNL4XH+J4tT?=
 =?us-ascii?Q?/WdtDz1wOo+kK52yCnvbCVY+hSgkWj7FbWbQoaBOXuZvSGx8O88zOGSICBqW?=
 =?us-ascii?Q?gI4QFYFcSsAnSVXyfRehwLhOZIPY+UWt0F3di9MwFn5F9IQgvLO93sopUfpw?=
 =?us-ascii?Q?2MxRC+FYzL6JjlWJTcNqsdu8fjcJXMS+XYX4/EGA4376rNnNdy1vMbPCE5j3?=
 =?us-ascii?Q?PO4D2Les2mt3iJ5H8q2Ek04cM61bs/DcXrKfyZLy6NwxHXsRpG7EkDVkHyRp?=
 =?us-ascii?Q?omRLTOXt3733YPs154NZxb5yL1OB9/2CO8gxRkU7gxLuhKIVMu4d4ZthOmiz?=
 =?us-ascii?Q?w57gcyj4k6QP/Rlo0gTY+2UjxLbZWAR0Eh52hJ5UVS0mTnQFN+1iCAuWAE7j?=
 =?us-ascii?Q?AGE6ljZflSjhWbxUzZvnXgg0sOSO0wRTQ5jK1WjwIi3DTvpDFepV1hBKB7EA?=
 =?us-ascii?Q?HBKi1i5i8Vz6GDIol+l7QS0tHDCeSWBXIFRwAc3O2e6up3yIJm9PIAAX41z/?=
 =?us-ascii?Q?XYcjGOZQCluX3cBXxjHpR0eeewRbrQIlnmmPZoA/P8+2IWns2QLbZwX8XkXA?=
 =?us-ascii?Q?N/13gM2Rc99DWMYAJHot9ATxTx5PAznbtpYETnAzxIYuDBr0t0Y8lsce4Ll2?=
 =?us-ascii?Q?po97SvLGta46qzXYi78ZBa0dCBIEi3951lt9Nm96anxao0S1ZEwdbfiurOKY?=
 =?us-ascii?Q?yEcpU+Aq6qhl47T9ylmNaS8B1gHjRR+6szqP1q4DW5EDh9Q4fZR0mXBNf1Ge?=
 =?us-ascii?Q?eP2IQsa+3qpzjWguEaj3ckFizpMfl5arFgS2z2oBHoRR9Fpr6EmGAVhdKAK4?=
 =?us-ascii?Q?NSHb0AbQnAaIuxT7OR2aWN5XodwY0SdzSwXtIAj8/+L0sMS15As1l4AjeH6C?=
 =?us-ascii?Q?eZngpNKfWiqBpISnsZrIfj6T0tEsrXD5LXDfKKYPGxPptzpWuujLNShMQU+c?=
 =?us-ascii?Q?9vjr2lbgoB9co7xEtGSCVgBJvx+iPPWEUwsUCcsOATz0A6c11KDFxFwxpNNC?=
 =?us-ascii?Q?WKp2g5sDrRA5zLplVO/1OGRIWzekPV1Hg82J7m6S0RGJvDxLwOnJJvA9q54G?=
 =?us-ascii?Q?QrH6z3vI+KpekqCRchs+kdlF9RdGw6aOFVyA78C92DRV+c+mLZFXfCDI0xCR?=
 =?us-ascii?Q?Ul884iD0CV0UKbgqlPP8KvIS80/DcXzaAvFb0rJ8elsZueT2bGDoopqYyRdr?=
 =?us-ascii?Q?k9B3GtSXCrRrDKDrOB7CbC4XR7I9PaqFobx2+CcgkDPyGiPj9nbzjrzoAi2t?=
 =?us-ascii?Q?OWqLCt8c++i3rXLjVfh1T8IADj1rvjeQ8j3TIwHuzKiNFMwqT3ERzZrkKDXo?=
 =?us-ascii?Q?GQYIIlYi1TeYGbu3YYN2xLOSCnP7V5iq76+dcBzZYj6Ub23eW9kjEkQLMtV8?=
 =?us-ascii?Q?98CFEOc+mfx/oEs+4Sd96x0wIixhQ85ebPUDVH2vcUJgyP2vW2ieTXwZzGyg?=
 =?us-ascii?Q?ZdWQxHkhp7g60slWbXWqlSMy7fQ5TPqqjgbs+4DkAX6jmqe8vVmjIDC0RG1o?=
 =?us-ascii?Q?7E/dhLbcRjJwSgvMlINvRHbHqM32WoVE9uT5Q51KTV+WLk5HQmM2mFmJkP7x?=
 =?us-ascii?Q?FWvaAMpgQQG1dWUEmYLQu5KP+r/asZn/jOX4tcjC2YVd0hP+3Q/c31sgdsZp?=
 =?us-ascii?Q?HAyWiAT+Rg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfafcfe-607d-4d1b-e49d-08da1e470c4c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:12.5785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMtgOLAwCZ7Zzotrz2ohW4s8wagSQxMLF37bB+2IEo9STKXvhagYS1SCI29E6F20
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

Focus the new op into is_enforced_coherent() which only checks the
enforced DMA coherency property of the file.

Make the new op self contained by properly refcounting the container
before touching it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 27 ++++++++++++++++++++++++---
 include/linux/vfio.h |  3 +--
 virt/kvm/vfio.c      | 18 +-----------------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index eb65b4c80ece64..c08093fb6d28d5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2003,14 +2003,35 @@ static struct iommu_group *vfio_file_iommu_group(struct file *filep)
 	return group->iommu_group;
 }
 
-long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
+/**
+ * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
+ *        is always CPU cache coherent
+ * @filep: VFIO file
+ *
+ * Enforced coherent means that the IOMMU ignores things like the PCIe no-snoop
+ * bit in DMA transactions. A return of false indicates that the user has
+ * rights to access additional instructions such as wbinvd on x86.
+ */
+static bool vfio_file_enforced_coherent(struct file *filep)
 {
-	return vfio_ioctl_check_extension(group->container, arg);
+	struct vfio_group *group = filep->private_data;
+	bool ret;
+
+	/*
+	 * Since the coherency state is determined only once a container is
+	 * attached the user must do so before they can prove they have
+	 * permission.
+	 */
+	if (vfio_group_add_container_user(group))
+		return true;
+	ret = vfio_ioctl_check_extension(group->container, VFIO_DMA_CC_IOMMU);
+	vfio_group_try_dissolve_container(group);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(vfio_external_check_extension);
 
 static const struct vfio_file_ops vfio_file_group_ops = {
 	.get_iommu_group = vfio_file_iommu_group,
+	.is_enforced_coherent = vfio_file_enforced_coherent,
 };
 
 /**
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index d09a1856d4e5ea..b1583eb80f12e6 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -140,13 +140,12 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  */
 struct vfio_file_ops {
 	struct iommu_group *(*get_iommu_group)(struct file *filep);
+	bool (*is_enforced_coherent)(struct file *filep);
 };
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
-extern long vfio_external_check_extension(struct vfio_group *group,
-					  unsigned long arg);
 const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 955cabc0683b29..f5ef78192a97ab 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -86,22 +86,6 @@ static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 	symbol_put(vfio_group_set_kvm);
 }
 
-static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
-{
-	long (*fn)(struct vfio_group *, unsigned long);
-	long ret;
-
-	fn = symbol_get(vfio_external_check_extension);
-	if (!fn)
-		return false;
-
-	ret = fn(vfio_group, VFIO_DMA_CC_IOMMU);
-
-	symbol_put(vfio_external_check_extension);
-
-	return ret > 0;
-}
-
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -128,7 +112,7 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (!kvm_vfio_group_is_coherent(kvg->vfio_group)) {
+		if (!kvg->ops->is_enforced_coherent(kvg->filp)) {
 			noncoherent = true;
 			break;
 		}
-- 
2.35.1

