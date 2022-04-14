Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0775A501B39
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbiDNSsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240994AbiDNSsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B446EDB498
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghbqc4WS7XYsjIhNtO+5MdoSNdeL2u76LhKt6LQLPBxeEpqoitJQsd9zf+op8QRwnJAg3LCN8RIZH7d1nY6qVbgjay5i8UV4vFZB/XNpPXhOJRhic5rpdaE8e1RsKtdpXa2SEbH/7MQkrD6ql8HKKBGQt0CBKCzUUswA/xBRMC356asZEnSt7SB4k0zUWvM2cJnQ4ilCa4M7osewUDK3IDJB7aA58TzudmxXBf/cT3N15Yg0VBljuVQZT40P3WepvCXs0v/fYzUkcdS7qxs5tr8pFTjdDmCL3X1nuo44XuQJvDjBgSkSZD7wYDhOkY/s3OqwuIhrIg4rznlZ0NwUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THEAxfMrOGSEQREsGwAGlsIQ4YJwVl9+3C4Ycni3wg4=;
 b=FWklssiV5fnIv/hhA+wWoPqBT4jci6uIPico6A7xSQYaCfgEDs5IZYB+lVp/6RM4LE58QmD0k4AaSJ2HH8VhBjHR9O0AZxDm0GbqbJwrMpcKZ9ceuJ9XgDbqmOzWe3tEZ0+wKQTpekUKusVVzvQvoSvqoKSonalIxhM/r0q6cWd+m4fScvtkuuZOED1bzAejbB6c9gHEYBHi/bMbgHZeI70DpMStgHOuRqBxYElxGAiny9J0h74D9oc+G92XLJ1I5dT13T6ytC49yIQVCVUNfTPsNWan5jh7lIHkXRtOTncFKFkfVXJw2syaHFZs3S6DynohXm75OFw1Bgu0vk3aHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THEAxfMrOGSEQREsGwAGlsIQ4YJwVl9+3C4Ycni3wg4=;
 b=U8G+sYe3PhnzmDIkZatgrMW/2laYczsNxfhTPgyy680oDv9xuloA6GoTgEokm6Ede8zvqE0sEW23bGgsgOJVSGCOnnOnBWtwj8Qy09Z2DIl5xbJ0hy6YUdMiVBx3A2nWBs/nicKLegjMaSHvgYCgzFhqttkt/5OZnlAOh9015G8M3i19r1oAUXzdwYwaW+6zDl0n7eltlWyCoeIXbQP9MJJtUlrhCzixMqcK8EfG6ftavyl4DSUIsaOfE/yE4GGpDG2MINK9aNAt/TVuzjDXlL3RDEGFqVAiBBL30EhOehG8hFIS5rosBxBl/N3ftW8kyphuVI1M5WK2sq43iJHO9Q==
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
Subject: [PATCH 10/10] vfio/pci: Use the struct file as the handle not the vfio_group
Date:   Thu, 14 Apr 2022 15:46:09 -0300
Message-Id: <10-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0408.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7891a50-4679-493f-5d28-08da1e470b38
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB535080D6F14E54AE30F7E6A5C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHS/PqMNYPqWqgmTFbaxJqKGRLLJLEbd7uSHSkuq8RFQbVlTHiSpESNSfftg3fP0l1J9MjtbP9D6Mo8fIDJIv/+hNU8c5bPB6NPocrJ9s47JX+EongZ29sLWiziintovxDwRuyt70ot/2Cgrc8G/i2o54ggSMjH4iNVpnCAqqHm1PXpXCP1vyQ7cOznb59jO7JK7O0sp1KUMaM6Lhk1eubUjr1Hk07EaZ9dtWARIFbgstrA5We4sff+4oEMsqu/h2A5rdJHrDkkvFUh6zZGkO2XezqaZj+AqhabCXyWp3Tn7bQbKE//KrXUtpJZoHf34gyKCNRAFeVTLy85ZBzIcBCl+jvUMewYrafQpUt2p94efn1facUlpu5sLc442MqavUFi80+zBYPis70U2uswJ33MUDfMHYZfVyACO1lmyQdY054ZDdA+hyHCqzDDoC798VsoSMdrefuVg4uPdfGla05SPtUMaa96mcfG4fcuhOzxN/dzUGGtmcUOk1EBYdGnJgsvOi6+A9FYNpL7+1PSMgtDwH1Z+h4aRFFMUaFNtu47irdwq+M/lwHUSGIoTSh/uy5HyuNHOkwMNLeQ+7jWz7JWhnlXW/qE7Ldw+WZ6SRlmtJuBw/xnWvt1D98a3WeG/wyYx/Eayu/cB7T5sHUOULA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(36756003)(2906002)(508600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rIgatBKH8IHx32rHsaufjKOc0DSJrijnVz1yWpounbxDSdlybrQyAuZ8zdw4?=
 =?us-ascii?Q?hXWrrPavfaZIsRT2sBNEeLSLMpAsCm4VutELnIkxmC9g4B72wsItywwjpQxe?=
 =?us-ascii?Q?q9xZverH7v0vrjXWHr5VOB8RX7b0FZFyFQZN5FJ88tgYROrMOeeehqsjKdTq?=
 =?us-ascii?Q?XHM0Ci3SyVpp4NiUlNxa1um+zdlFYjB5zoQRC3wjH2knNMN0EDSP2yfJ3ZxX?=
 =?us-ascii?Q?QwC9/5vzVD+h9h9yvw0CT0ZPbIgSpAdVur5Pt5ncpwE42y9yrti7V3ZJ/wuF?=
 =?us-ascii?Q?dIhv2x4101LCTGyp+hkLGCdlsK8WwjOwfUVnycsav26lsn4QAHI/G0XVH9cK?=
 =?us-ascii?Q?Q5EIRZvIJzEir4Sif7uba8R02vgv3l2U+c1wSDSPfQpbFvOVVO3yaMbzSV6l?=
 =?us-ascii?Q?JK9JT3kvBWyg/w3U1NP+/1VwAzzy+TdH8ee29DsgTYArFaBcQgt6Vzggfngj?=
 =?us-ascii?Q?bQ/4zsT5gLaPjdIcqaCdG4p8ayMTWAhrkLROvfs7xQ04Y+mEB8NkGgItilBN?=
 =?us-ascii?Q?rfX4tKw2IE7XgAah7FMk6BtH+MvqY0si1nVNt57/z8sIE99O0yioCwfCjpZJ?=
 =?us-ascii?Q?gkZvJ22UPiA/ysfyr/oM9pUzlmwwX2+mzCf+41xD9GCEAPUPB1u8HQTsS4nh?=
 =?us-ascii?Q?5asv0dkiGZVo9iR49KmrF5URtTw8lHUtL3pV6ivt2U5jwQ47RnHJVFtsYD6A?=
 =?us-ascii?Q?FwhmQ6kM+Nj20eaDNkkWOAXsHhbdmjUW5oIzOb1h0ak61jHS/r+61ynvafrC?=
 =?us-ascii?Q?RsbIA5WTX+JSk5u6Iq3uwWEt8Jc4uvUHmJ7P033s/prfl0xByj2zwbt82YOJ?=
 =?us-ascii?Q?sWtVPOCDyVgcQmdxEELbBmI/6U9kjq77O9a1E8U0BV3IuI6TFNLE/UW3rn3R?=
 =?us-ascii?Q?dDuBhtkp0eOzElQ+1AfJDVlPQFNRXGfJ4YRtI1gxJeqB2eZdRSst3AeVhzGt?=
 =?us-ascii?Q?KU9QVW+qwacXDwjSX0GN14nrso3w+SeV5/JckF8uWKdsJMpNNgLQT763jaXm?=
 =?us-ascii?Q?mTVqRBTnwsMMTegI6rQfr9Ea1d2lSclVw5XZBkN3mM3SthXL1Nk5btSqunYM?=
 =?us-ascii?Q?TFDZntPED1w+NX5lvwHnK1SYRGE4dhwr87HpaV4kSbp6Hx4RRaTKuugqkRDu?=
 =?us-ascii?Q?1sc0iM1jo8C8Sa7PqM1/11vxhmsXVlMqGQUG4BRjgOcQzvGjQtuC9K2v+mB5?=
 =?us-ascii?Q?458P71MHtT7mWxIDxV2zK0YRGrTDJgNIlZZ2XYZvGvSjBi8uMr0Sh5IB6Gep?=
 =?us-ascii?Q?mTbqxkvXG8tJS59vOIyqgt3KaedU4QsvDGOH6yrPHKEoB7xaxMUxR2Dvly6R?=
 =?us-ascii?Q?kmO7f5QQ7pr+NxgvGXkwsWPYvQ3KTW2fwqngTSee8/dck+a0ug2tFtb/CtVN?=
 =?us-ascii?Q?bfTWyNSd34vbYq0akWVZ87i4ukGVMTQ6fhnJTFwaIAck4zYEruRYaNbxa3oA?=
 =?us-ascii?Q?Brh2kwDLMyLu1X29tXP8lel3lBDA1XwyQlWRmp3SMnajyXhP7bw/4FP5vTat?=
 =?us-ascii?Q?m5dnvqlqncZDmjCsFBU6YmY+jbAxg4kmTMMLlcUearPYSbqh5LnQ3y1zjOss?=
 =?us-ascii?Q?FqZoN98XE2SCCAw5DMDOWWlLb73khF6KU7bxKhTtF2O5nBOTCymIb8h9EIAr?=
 =?us-ascii?Q?g+9hqBYcyy7bpGQkUmHPueQqqmbvkVOv8yEX372+uZGrhIfsE5LZ1to+8/Ii?=
 =?us-ascii?Q?rFH+MUX6SBZMzSybsjgw7NUOx4WJY4quOm9mIrIw53q6//+/YKnAq4uzAj94?=
 =?us-ascii?Q?gGcIN99G6A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7891a50-4679-493f-5d28-08da1e470b38
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:10.7819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdY9/QOqTNCWTV+mLKwKAmHfe6STHbeICQEo3OtLOcyTh8zZlIZmtYALtzNGbimY
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

VFIO PCI does a security check as part of hot reset to prove that the user
has permission to manipulate all the devices that will be impacted by the
reset.

Use a new API vfio_file_has_dev() to perform this security check against
the struct file directly and remove the vfio_group from VFIO PCI.

Since VFIO PCI was the last user of vfio_group_get_external_user() remove
it as well.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 43 +++++++++++-----------
 drivers/vfio/vfio.c              | 63 +++++++++-----------------------
 include/linux/vfio.h             |  2 +-
 3 files changed, 41 insertions(+), 67 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b7bb16f92ac628..ea584934683848 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -577,7 +577,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 
 struct vfio_pci_group_info {
 	int count;
-	struct vfio_group **groups;
+	struct file **files;
 };
 
 static bool vfio_pci_dev_below_slot(struct pci_dev *pdev, struct pci_slot *slot)
@@ -1039,10 +1039,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 	} else if (cmd == VFIO_DEVICE_PCI_HOT_RESET) {
 		struct vfio_pci_hot_reset hdr;
 		int32_t *group_fds;
-		struct vfio_group **groups;
+		struct file **files;
 		struct vfio_pci_group_info info;
 		bool slot = false;
-		int group_idx, count = 0, ret = 0;
+		int file_idx, count = 0, ret = 0;
 
 		minsz = offsetofend(struct vfio_pci_hot_reset, count);
 
@@ -1075,17 +1075,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return -EINVAL;
 
 		group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-		groups = kcalloc(hdr.count, sizeof(*groups), GFP_KERNEL);
-		if (!group_fds || !groups) {
+		files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+		if (!group_fds || !files) {
 			kfree(group_fds);
-			kfree(groups);
+			kfree(files);
 			return -ENOMEM;
 		}
 
 		if (copy_from_user(group_fds, (void __user *)(arg + minsz),
 				   hdr.count * sizeof(*group_fds))) {
 			kfree(group_fds);
-			kfree(groups);
+			kfree(files);
 			return -EFAULT;
 		}
 
@@ -1094,22 +1094,23 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		 * user interface and store the group and iommu ID.  This
 		 * ensures the group is held across the reset.
 		 */
-		for (group_idx = 0; group_idx < hdr.count; group_idx++) {
-			struct vfio_group *group;
-			struct fd f = fdget(group_fds[group_idx]);
-			if (!f.file) {
+		for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+			struct file *file = fget(group_fds[file_idx]);
+			const struct vfio_file_ops *ops;
+
+			if (!file) {
 				ret = -EBADF;
 				break;
 			}
 
-			group = vfio_group_get_external_user(f.file);
-			fdput(f);
-			if (IS_ERR(group)) {
-				ret = PTR_ERR(group);
+			ops = vfio_file_get_ops(file);
+			if (IS_ERR(ops)) {
+				fput(file);
+				ret = PTR_ERR(ops);
 				break;
 			}
 
-			groups[group_idx] = group;
+			files[file_idx] = file;
 		}
 
 		kfree(group_fds);
@@ -1119,15 +1120,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			goto hot_reset_release;
 
 		info.count = hdr.count;
-		info.groups = groups;
+		info.files = files;
 
 		ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
 
 hot_reset_release:
-		for (group_idx--; group_idx >= 0; group_idx--)
-			vfio_group_put_external_user(groups[group_idx]);
+		for (file_idx--; file_idx >= 0; file_idx--)
+			fput(files[file_idx]);
 
-		kfree(groups);
+		kfree(files);
 		return ret;
 	} else if (cmd == VFIO_DEVICE_IOEVENTFD) {
 		struct vfio_device_ioeventfd ioeventfd;
@@ -1964,7 +1965,7 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 	unsigned int i;
 
 	for (i = 0; i < groups->count; i++)
-		if (groups->groups[i] == vdev->vdev.group)
+		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
 	return false;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2eb63d9dded8fb..69772105ec43e8 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1899,51 +1899,6 @@ static const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
-/*
- * External user API, exported by symbols to be linked dynamically.
- *
- * The protocol includes:
- *  1. do normal VFIO init operation:
- *	- opening a new container;
- *	- attaching group(s) to it;
- *	- setting an IOMMU driver for a container.
- * When IOMMU is set for a container, all groups in it are
- * considered ready to use by an external user.
- *
- * 2. User space passes a group fd to an external user.
- * The external user calls vfio_group_get_external_user()
- * to verify that:
- *	- the group is initialized;
- *	- IOMMU is set for it.
- * If both checks passed, vfio_group_get_external_user()
- * increments the container user counter to prevent
- * the VFIO group from disposal before KVM exits.
- *
- * 3. When the external KVM finishes, it calls
- * vfio_group_put_external_user() to release the VFIO group.
- * This call decrements the container user counter.
- */
-struct vfio_group *vfio_group_get_external_user(struct file *filep)
-{
-	struct vfio_group *group = filep->private_data;
-	int ret;
-
-	if (filep->f_op != &vfio_group_fops)
-		return ERR_PTR(-EINVAL);
-
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return ERR_PTR(ret);
-
-	/*
-	 * Since the caller holds the fget on the file group->users must be >= 1
-	 */
-	vfio_group_get(group);
-
-	return group;
-}
-EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
-
 /*
  * External user API, exported by symbols to be linked dynamically.
  * The external user passes in a device pointer
@@ -2068,6 +2023,24 @@ const struct vfio_file_ops *vfio_file_get_ops(struct file *filep)
 }
 EXPORT_SYMBOL_GPL(vfio_file_get_ops);
 
+/**
+ * vfio_file_has_dev - True if the VFIO file is a handle for device
+ * @filep: VFIO file to check
+ * @device: Device that must be part of the file
+ *
+ * Returns true if given file has permission to manipulate the given device.
+ */
+bool vfio_file_has_dev(struct file *filep, struct vfio_device *device)
+{
+	struct vfio_group *group = filep->private_data;
+
+	if (filep->f_op != &vfio_group_fops)
+		return false;
+
+	return group == device->group;
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index bc6e47f3f26560..ea254283fa0522 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -145,11 +145,11 @@ struct vfio_file_ops {
 	bool (*is_enforced_coherent)(struct file *filep);
 	void (*set_kvm)(struct file *filep, struct kvm *kvm);
 };
-extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
 const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
+bool vfio_file_has_dev(struct file *filep, struct vfio_device *device);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.35.1

