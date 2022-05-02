Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347F65175DA
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386684AbiEBRfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348252AbiEBRfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:14 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D125DE
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSCVC4XpYhophoCKZCu8hAkP0JjVWRhFy4BgmeCMpZDzzkKqhbVX3Xzo0/o5Rgl+YP2m2QKyRCAPmD/VSeABDZsgiX5exMU1ZRiITQc2REeHhjXDTgmrApXHvgKGfyxgMopLwdKAFc8Dc+1QFsiOFHYadQIES8mOaDPKqvGzpyR1ILrNEJ2BlW7ByrnKlHcGpA5hOwWhJWLETfwb/BMeA8ldGw90sL9qcaSv6YELx0ye89Jnd+HD/dUIMRXBCWoxSwiXDBHG9z3O4519+e78jby9vTmNjlaq2jTtzG3ODMG58HoTc/NJQAIc14DoyymKN9o0OZ8VEhtGvoA+/J5wEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBOcVwxEzw6azq3PAlPnF8zldZZAK5HVtoqM4LTZsrw=;
 b=Y7rBOKWHxTcQnVviWhw3lttJy+Q+7PlrP9TDW0m20bGw+EZsrB2I4PCFPB8rqOOHR8O9xusP3s7qDmWhEiH3l7kiauNwrlpPc+MuNhtimHKnAlVSVrcll019KWSPHRgI+pLZOn5i97U1ree9JfbYo7RfQeVKw2OVIOAyrtRZS6dj0Igh0Mx8cnDmz+IEyXoK46OG3uloCq27Qb+pg+QUpx4E5GccD3sJbNzBN01GXslKaFIum+W50B7bbzpvFZY499qsPdlM3l+mF92FIlOLpuMeHuc83Z9/+cKzw9+k3cW2hzplwYnkYxbprbE4KnmRKsDg2c+v/o9zsx41n7D0zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBOcVwxEzw6azq3PAlPnF8zldZZAK5HVtoqM4LTZsrw=;
 b=EAtjCoDVCETIP564cPeuohSrcX+Fl5YXqOlqvAgPGs3pDmFJdMj1uefpFPX8Lr9oF5eS7J+8DbJHTWKrpv4o7PVTFm8ALRzK7qf4knAztiuG+EDa33SUZJu782ltFOvRQCT1vwJznyI/wganzhoegcCrstI3ncKMKIMqQlBi1QZMuM9RVwnOt9f9/pDANAfn/vCXvl5n/dy5xjMpuKWnwcTf+PxPmsAorXq8HY+DDHDDM50wylQtZclUkKgQXfwIG9pwmDkd3Xw4zmVfEiicK1rNm5ikzQxOLEJKJ9WxQVG5vhDQMxXdqcw9/yXhWDwK8xqvx9f3Ldt7kPF8m8M/0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 4/7] vfio/mdev: Pass in a struct vfio_device * to vfio_dma_rw()
Date:   Mon,  2 May 2022 14:31:34 -0300
Message-Id: <4-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:207:3d::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8dad3b3-42f2-4dd7-9866-08da2c619d60
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5458F600278A900D8259E84BC2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECFykogh1A9Ulpe7tkyQ/oXtbgEBSCXgL9uTZyqJX9qEseM7NF/4e2iYty8hQKt8KUIJ7wdq5egKnaEWAEDiXwf2hvApVaz261HkcNxJj9jYzCfJnzZNlYe/Qzs/K0hZHMPYxEMQJR9IhRn97j4mHpZvBJ5k+3ViKkrGHrZbOu4zzt2hOjbvsm3xIYwZtGDoV3/oczelTmj3qFNE77qD7rujNbAjOcOePm1hG3s8f1Qrcx7fbQRwRgKXtS+OEBpvXLV3ZybBZspNP4UXzYlMbi4okJ4tjPwpmYm6X6zD8xxhcKIQc0zWFOFAM+7sVq++zi4/UaDebcncelzr4Q3Oj1DXugsE3EDcUCNef8OisL4OowXTDwPReIO6ZtNCH+xrwcEQcI/4a8JDuap/ON50ySn2T3atdxs8oefFpdGHob9Rh6oeCWGdy7RAP2OIBMdSo/5aKdKMNUBZQ+Lw//EdSJYxZShbgFFAHg7m4l8KpdwtqzsT1DpHEiE+F6cUpaN6MmrX/0PCD0IdiO4wirCzmY2mEh71YSC6JCDjFlA2d7AEdLqTi4X70lb1Z6uqLfyGSwc01zskOre3rzRopAdL3nnlU4lPowef7UTe1mImYTfw2Y8fk9WLpWQlENLrZkpJclYNlS6P6c9QvkEwCJOdLBIHibcYjrV3d6BP2VqnjO+yktdtEiZgUtmD6a9Ny6z/tjxqrSgECVRjcGgRCbeXo28W8HgJnFF+4cBw8EDIGng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kc9Ey3OgfBvQUhvzHx0rQL4A2fiRyYV2Pjt5bhssVqSv5Z93BMTxFg4jmHFG?=
 =?us-ascii?Q?x14XD6HIuqjTeLwzHr9XXIEfKpVuxBDUXqaQhBY1vHbalhXbM6eZcY3jl9a4?=
 =?us-ascii?Q?m9tzfcztfX4dI6T+Lqla0YevGorpfqUfR4SNlcmiVldsE3zG/lpPl3kMDW5R?=
 =?us-ascii?Q?uxau+f4jyY53iFztps5vWCkWuOfE1FoN0pXm3bPLTkNHc3O9sILJ34Jt03og?=
 =?us-ascii?Q?er+0H7ynPLXetfSxVGNJ5e6z14pbhWojhGzaqUBeGxkgxNful2jFl2aycq+J?=
 =?us-ascii?Q?y/MnxVSfRvSykbgBi32iZnxm4FB6oASQ+27GV/NYhkDbKEi2Z0NbqO62EWcb?=
 =?us-ascii?Q?670Krtfbx6UDDhK5ph5V51lmoaw0wOK26sJEQooSIAgQ/MdlTKRc71tLTdh5?=
 =?us-ascii?Q?1B754GqS6FfQQifyDzww6hmAeplWnl6TaeOOhooBebmTRqbzoWMFQhxFsEOg?=
 =?us-ascii?Q?IwDZEDo0rNwl53XD+JAFCEp/qehDXeeOWSw92RdqxIGW3Bw8TGi6gOaJJeCT?=
 =?us-ascii?Q?dfPNQXEF0LbOxCW6BinYZwIgUoXoYFlkZvQzrcw2uSy8wdcaoainCK7c/ita?=
 =?us-ascii?Q?mvFduLhFE6M/mZNfPF03WCL2jkihzBF7JkxivKdhhG7eyX8JAEIiuRNb+NMQ?=
 =?us-ascii?Q?m2bRYlLecyfEO+NOQQoopyQJjjnozbrJhwDAQXEDOh4Iv34o7iuUpAutmT6g?=
 =?us-ascii?Q?GXGHsoBRNEsHxbRjaPOCya42V3aOTNOV8K1NtDOyoREaXAzFJPsF0CkA3RTg?=
 =?us-ascii?Q?mJ4g2sIP60csOc7NgCT43kQMog61lt2IYwsBMU+rRKWPTdkssLUT/e9LcMmE?=
 =?us-ascii?Q?2i6Sy+SDAE+dp/mRoC+NVJk4pLLEPCD7u+PP/V/8Hh+sqGfu7sIyeQ9clP/i?=
 =?us-ascii?Q?xCbyTK+xKqtUkML1GY40jHIcow+e4HCWjmiL5BzooyssC4EsIoDNmPWRw2sg?=
 =?us-ascii?Q?8y1VmL3a/luk36/8s5m1hbaxRPwF6/0g9jTz3gpRTxaRj9SnFAwvzazBjGjn?=
 =?us-ascii?Q?54nO7zVz9VZ+UFaqYJqB6xqJAoYM34pVekazGzE9WZA+Xoo0n2SZhJfnbc5U?=
 =?us-ascii?Q?GdewZPslUYPWbSpJ4S5D9V15zBlp6PbAPptpMXj4WLKrXe9bJ6oGPAB+gRYd?=
 =?us-ascii?Q?9CfvmBFPoUgQ6GPzT+yXP/u7kG3V2MqNCZ4rlc3asxewECJZdZNGnqQBL8ys?=
 =?us-ascii?Q?nyW2u74kfPew7CIz4UBtjA0dW4MsOg2J98o3XYrM94nS0fs+3/5QMbTRM98L?=
 =?us-ascii?Q?vCxrcJ27/WcKlylucJjNP1SqJsUewkQy/qvehZCp10d+yuWxldefiktNKfuo?=
 =?us-ascii?Q?2J5S6MzhPTItamKzXaJh3yGaJSz0pC09YIpP8LXsK0veeMvJb+7dIILkPRz5?=
 =?us-ascii?Q?gH/prl5PFy+ZHnh4xNYJC9S6l3ssCRnJRnTYz8maKf8DyA+5yOWMT87ppZDQ?=
 =?us-ascii?Q?Og7GkyLQIEHTKDOQvCYzoDYK0T+QNMpatbPqPtbbOp/xAG39kCIoUrrUkzdC?=
 =?us-ascii?Q?Ofdvi8kDVppvGFJfnlUTxFygDaI3jmTkvhTzFNS5T2mbuL+BO+d7OONP/YyA?=
 =?us-ascii?Q?IfVSBavQeh+wt11+e+v1v1JuAXNeDrdNcNS4inh5+WB+zNL/+hojLciucH3K?=
 =?us-ascii?Q?3iqwfSt2f2VhVVI8a3bkFJZZRQpPuPLJMDczC5bLNdkOfxQ80U2gnvi2lml7?=
 =?us-ascii?Q?JcaUzL5z5QXCOIQEp4fQuoA445FHqApJxL+tOgHNLMlECi2m52xBMS6lCb+6?=
 =?us-ascii?Q?0E2w/AJ5GA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8dad3b3-42f2-4dd7-9866-08da2c619d60
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:39.1389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTux7DOrjIn9N3fe9g9+VkCBLRvF2mv79xk7LkVmUbp5JDloVAe3+Er/j+tsKmE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every caller has a readily available vfio_device pointer, use that instead
of passing in a generic struct device. Change vfio_dma_rw() to take in the
struct vfio_device and move the container users that would have been held
by vfio_group_get_external_user_from_dev() to vfio_dma_rw() directly, like
vfio_pin/unpin_pages().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h |  4 ++--
 drivers/vfio/vfio.c            | 24 +++++++++++-------------
 include/linux/vfio.h           |  2 +-
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 03ecffc2ba56a9..5a28ee965b7f3e 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -732,7 +732,7 @@ static inline int intel_gvt_read_gpa(struct intel_vgpu *vgpu, unsigned long gpa,
 {
 	if (!vgpu->attached)
 		return -ESRCH;
-	return vfio_dma_rw(vgpu->vfio_group, gpa, buf, len, false);
+	return vfio_dma_rw(&vgpu->vfio_device, gpa, buf, len, false);
 }
 
 /**
@@ -750,7 +750,7 @@ static inline int intel_gvt_write_gpa(struct intel_vgpu *vgpu,
 {
 	if (!vgpu->attached)
 		return -ESRCH;
-	return vfio_dma_rw(vgpu->vfio_group, gpa, buf, len, true);
+	return vfio_dma_rw(&vgpu->vfio_device, gpa, buf, len, true);
 }
 
 void intel_gvt_debugfs_remove_vgpu(struct intel_vgpu *vgpu);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index dc5d40b07e2381..7960a153879ba5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2108,32 +2108,28 @@ EXPORT_SYMBOL(vfio_group_unpin_pages);
  * As the read/write of user space memory is conducted via the CPUs and is
  * not a real device DMA, it is not necessary to pin the user space memory.
  *
- * The caller needs to call vfio_group_get_external_user() or
- * vfio_group_get_external_user_from_dev() prior to calling this interface,
- * so as to prevent the VFIO group from disposal in the middle of the call.
- * But it can keep the reference to the VFIO group for several calls into
- * this interface.
- * After finishing using of the VFIO group, the caller needs to release the
- * VFIO group by calling vfio_group_put_external_user().
- *
- * @group [in]		: VFIO group
+ * @vdev [in]		: VFIO device
  * @user_iova [in]	: base IOVA of a user space buffer
  * @data [in]		: pointer to kernel buffer
  * @len [in]		: kernel buffer length
  * @write		: indicate read or write
  * Return error code on failure or 0 on success.
  */
-int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
-		void *data, size_t len, bool write)
+int vfio_dma_rw(struct vfio_device *vdev, dma_addr_t user_iova, void *data,
+		size_t len, bool write)
 {
 	struct vfio_container *container;
 	struct vfio_iommu_driver *driver;
 	int ret = 0;
 
-	if (!group || !data || len <= 0)
+	if (!data || len <= 0)
 		return -EINVAL;
 
-	container = group->container;
+	ret = vfio_group_add_container_user(vdev->group);
+	if (ret)
+		return ret;
+
+	container = vdev->group->container;
 	driver = container->iommu_driver;
 
 	if (likely(driver && driver->ops->dma_rw))
@@ -2142,6 +2138,8 @@ int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
 	else
 		ret = -ENOTTY;
 
+	vfio_group_try_dissolve_container(vdev->group);
+
 	return ret;
 }
 EXPORT_SYMBOL(vfio_dma_rw);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 8f2a09801a660b..91d46e532ca104 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -161,7 +161,7 @@ extern int vfio_group_pin_pages(struct vfio_group *group,
 extern int vfio_group_unpin_pages(struct vfio_group *group,
 				  unsigned long *user_iova_pfn, int npage);
 
-extern int vfio_dma_rw(struct vfio_group *group, dma_addr_t user_iova,
+extern int vfio_dma_rw(struct vfio_device *vdev, dma_addr_t user_iova,
 		       void *data, size_t len, bool write);
 
 extern struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group);
-- 
2.36.0

