Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD8642BCB
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiLEPbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiLEPan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:30:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE46D77
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:29:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3Gm1RXI+dBS/eisYzReBWlg6nZGhxLyr8vThClascR+/6HXSWjDjTgMNW3ofWAq9ku1L6KaPM8HXFmHbC+k3lXNALjyE1VJZp9zEKCBylIjmJegonwxr7aW6vG5o54Os8iezkSVVKx1QFXxGVqzjX9kCkWgmYHJmKODFhAoMWNvJCmoisZ/+9cXtobSk2jilBei/teVu/E6a0OEPHw8m0D5KEKY4vFemfh9Gr/JELS67GWPjhWybSh7SfK8Tt8+VsSINAFDRLiEVSyLflUlDPbOP4aaQ0V6lFy51H88oOg0brrprvYccuKUZGed75kaDFpAt/vfGlew4EuD+Baj2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=getKzrV833AtV5z8bZjZK1sH4qppWNJPwX0Wthw9mz0=;
 b=CwnTSrWAu7WSXXjqFDxI5dxqeJIXi7p90xHjTC0ukn+kcl5vDStVji6WZym9vkAqmAvcmXlgbmcKpUMsQGJ81WiBju8rIn/G1R/0lvmT0rSh3sLrLURoiRHFk+lOzDuy6zyfH3LO0gLeiLbHejgTHjPecgBof7AjnwgMLpS6r0xvxgKy316vodTNoSkvYkD4aJazA5C3gOhs3qn/vNe2I/i/crNc1yNZk9w87Qllnfrj7a2dXSY74b2/ih27kVNLwEIYYrO5HnhS4O9tBb3meIdanGkbiRsu1C07dgRtTi1lAn66EjOJQUaINS8ZC3yV4NiHbsiuYY0eE+Xclr1VBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=getKzrV833AtV5z8bZjZK1sH4qppWNJPwX0Wthw9mz0=;
 b=NjaJoVwannJEHLKDOj4rM5A4hxBIarAwFe+id7AnKxoojIRqMAILhh5guphx29xRarFrNqKa9TBU/yS6lamDw0MBGWuzDupEo6zXvTroBSSCji2ozlNVh348Nyx1NsQoycw/NtO8hh5S+rUK+kTPRBJO0CfVV8M9Bjn1wVTR6CfvRrqK2EJa6INaA18XyCi3iC3baEDZXDWIrxbcRMLyK+l1/YmfECX5ApmmwmzXl8lNCrAZEt2sbzjoBeSyzAHl0QiaZRHgijP30/PIVh1kwiPcAcXbxut0QnUBEjCxTrBp+/OeUG6g69XsktIrm9Rl+1jeXv06U5GeWrc/1qcVkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 5 Dec
 2022 15:29:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 15:29:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 1/5] vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
Date:   Mon,  5 Dec 2022 11:29:16 -0400
Message-Id: <1-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b2aef7c-d917-4440-57a9-08dad6d57cba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vTjsYOlfRjBMdM+59R5TxLbdGT7KlQFS8mqgTu8qbxYO63wu/Fk/rr+Yi+uXK25nl/jiC2W+5ObcCjiF3eCmcma7UbZcLu95PeQ0+mbX3e3qOKG4/+eJOj6xppQ/Cf09/C81kbQSJIVHaDDKCTTpNWU30h3aN6nfdVXXqiioGrGSQExShXsOWSLN+fdOrVv+3/eDo4vGHfAojkGwsJhHZbR8so+R9g6jpdUc7eOo/boi021Z1fHaIlQcQ7d5iouegvYu19w/7srBSOw3QYN46nevhW7qKrI3EsX3PVWH38dhsXYqrWBmwKtGNgN8XAGsAlB+NxIRZ31ZM13BpSWBePs1ot+5snMLMfRZzPWVNiQ8HYRpGtRkoRnftb0TIA/EsNgMC6XUNRRuUQiH+qYq9pxrqmlA8WrkX6S9bVbcqGpqbLNykK6tpgx+DpOz37GxEFZYCpT/zn28LBZcuIpua1mCM370slN9YFIzN9FoAYl+X9Gl46Qw7fc3jncbdT/mkOiNQzK4+WjNM5bRNceVYT8pl+AOs8OJ411x8Dnz2PJxiUAxNySqo3iSdztWvD5XjXEv1VHv43BTOIwfu/UQJQfSxZM63MGLDvueODlPpGM7RejTust6S5QjRMTph+KeLDK1PVffippwL6+iCJu4MZWHjXkh9HLig0aIYZqQ5ejWLrDhF4tEdRXgvDjjydWl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(66476007)(36756003)(38100700002)(2906002)(41300700001)(4326008)(5660300002)(8936002)(83380400001)(86362001)(478600001)(6666004)(66556008)(2616005)(8676002)(54906003)(110136005)(186003)(316002)(6506007)(6486002)(66946007)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DHDf20BAiIeBFOjHGkt1Ql6wkMKpRBi6nuT8yZnG/dvKqZ37nimwiy0ustQ?=
 =?us-ascii?Q?rECk6bQbnvBoXRUw461fp26r6iuhnP1TymFUl8glzp8be0T6CAKC4fZ+uqSy?=
 =?us-ascii?Q?U/w6ZM+TiibSch63GuWSaIVTF1U8DJtQiUSLKkbRNKp/eTQNFHAJARswodlD?=
 =?us-ascii?Q?ROlStuugBfHzwa8Ka2w7McJi74ThDQF813OM87HUaNrBFXduZkIcuzzCdEZQ?=
 =?us-ascii?Q?3CbLGLGgHFpiQb4kaAvs53T1SnW8xthveznRKFc9vbYX7oFmleNpuSq7pIto?=
 =?us-ascii?Q?oIvKtI05EpTkmJ/GO+dwScU0r//YSczJ2Jp2Le9pqdX9pMhTsWEB+Ngq9VY7?=
 =?us-ascii?Q?2OuNk2jeGAkaX2lWeaKRL9DKCq/n+8FGjiBnTtVVhOaDG/p8GbYTa4f2tCo0?=
 =?us-ascii?Q?6R/Vpais5Vyhs/j02OzEbJYZsr+drJ6pkhhqhPT/AYOPa2DomYlCWzPE1gGd?=
 =?us-ascii?Q?PWfiOiXb/hSvgXh8255Ym1wC+9iz1fvIRfkj8ZLGEhSF3Nhm/1kXiTjPYNls?=
 =?us-ascii?Q?E6+QpAFB/tv7GMkcE52tOPlwD2dZI9t3MO8fD7fPkzRJAstXvlJdDcpI0qDd?=
 =?us-ascii?Q?0GAWTSGnazWwzX86n91jIRQFoPfkVuMPpIlSQ9VPgbSvt5PSIN/XcoGpj1m1?=
 =?us-ascii?Q?TgEKN4y/GkNqF1t6hu8tS4uQ88jJJvITnrlh1wf4v2itq/rpincgZIo4skf9?=
 =?us-ascii?Q?GazWKZIV7zwZDzckIpycJCBCvAOuOjoE7ApR+aPVxliMz2We+dPZIh+tshJD?=
 =?us-ascii?Q?v+hinBj/+NApmRmZXjDqnmj5lnCGyrLvVw5y9nXVhY+VYKJXBT3e/tOqivfD?=
 =?us-ascii?Q?F5qyZatuKf6U3eREId9Y8yxt+YLmS2HcuKb3VVJsKocgIaWZNa78nsyZ47ZK?=
 =?us-ascii?Q?L/tF2Vs4vq3cd86AeRLICWdmAKsF+2nmMMOY2uSDiykFmQpaQo/vHeA5/uID?=
 =?us-ascii?Q?b3Om9VFW6hO5dFO9tZnwHOCFuujdlx695b3cdVveK88Vn+RkxhgqsQF/biUt?=
 =?us-ascii?Q?MDKL+a7RuvH5cnS0mYkWcFpVzhDka8tvvE80XtADIsmq3KA8vEFZsSeKnshA?=
 =?us-ascii?Q?GVmUlbRD1avJ2tQSHbTDCFBqhcGr0H6F253CAzcFwBCbAwC/7qFhmeU0q3wX?=
 =?us-ascii?Q?W+rxRCGpkgmu1yOkYcNSdCMYvGB+fDi0U9BEO2R9KFFyVpM7ZjDaGbkal9zY?=
 =?us-ascii?Q?WIp7xJjmmXUPqkFpOf1x6aoU9uNvPDpDmVjwAgwe10OivzwwX51mt8ef4w4A?=
 =?us-ascii?Q?jzpL4GNQqmW/X3A/0fMxh46Sx3sXR3eX/H92XFO5XDiyvCO1XSkALi/r4xBX?=
 =?us-ascii?Q?mfXGWNttcUyOeLDcf4YViACNzLp7x3zSsGQuohUUCKSnfpx1Xs1mn8wpo2jL?=
 =?us-ascii?Q?6VvvtYh6X9RXxKU8xlBOePMHKj6Rg/kljJq/WFL+uhLzjzyi1lrWfH4EiKIX?=
 =?us-ascii?Q?IAFyBWCwtVbrY0XKF6ABAq/AXjhAuM0kvoin3tanxbzOI435lidEkKSwiBf5?=
 =?us-ascii?Q?O4GRuPFNLXanG+9ltCbab/LYzfIWN31zO8jYa7TZy3ulZlByrv71+IFV6ktN?=
 =?us-ascii?Q?xpZwiIkZWBrvOUFnX6ve21TG4347vgGBafkFlyIT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b2aef7c-d917-4440-57a9-08dad6d57cba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:29:23.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBmJcjQRM/4UAtl5hbE9PlAb0xy/vwAjgikiNRtWUKOjYZM09CqRWgZrTmrIkQkR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
around an arch function. Just call them directly. This eliminates some
weird exported symbols that don't need to exist.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++--
 drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
 include/linux/vfio.h             | 11 -----------
 3 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index badc9d828cac20..c8b8a7a03eae7e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,6 +27,9 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#include <asm/eeh.h>
+#endif
 
 #include "vfio_pci_priv.h"
 
@@ -686,7 +689,9 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->sriov_pf_core_dev->vf_token->users--;
 		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
 	}
-	vfio_spapr_pci_eeh_release(vdev->pdev);
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+	eeh_dev_release(vdev->pdev);
+#endif
 	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
@@ -705,7 +710,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
-	vfio_spapr_pci_eeh_open(vdev->pdev);
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+	eeh_dev_open(vdev->pdev);
+#endif
 
 	if (vdev->sriov_pf_core_dev) {
 		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index 67f55ac1d459cc..c9d102aafbcd11 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -15,19 +15,6 @@
 #define DRIVER_AUTHOR	"Gavin Shan, IBM Corporation"
 #define DRIVER_DESC	"VFIO IOMMU SPAPR EEH"
 
-/* We might build address mapping here for "fast" path later */
-void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
-{
-	eeh_dev_open(pdev);
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_open);
-
-void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
-{
-	eeh_dev_release(pdev);
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_release);
-
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 				unsigned int cmd, unsigned long arg)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd1a..e8a5a9cdb9067f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -231,21 +231,10 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
 				       int num_irqs, int max_irq_type,
 				       size_t *data_size);
 
-struct pci_dev;
 #if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
-void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
-void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group, unsigned int cmd,
 				unsigned long arg);
 #else
-static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
-{
-}
-
-static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
-{
-}
-
 static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 					      unsigned int cmd,
 					      unsigned long arg)
-- 
2.38.1

