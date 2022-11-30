Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E5E63CC4A
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiK3AK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiK3AK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:10:26 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA01303C8
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 16:10:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgoHtZbDAHqdeW+8aQR8/bzddq2cgIHbFUxtACCzD5Hs3HwrYMLll0US0POq7Xz1MysQYyke1wrMGmp0iBifohSbCC+Lzx6vr+5Ysp75q+sTlBikOgh/mvFkulLdyhpfjIONMhd44Mdj8tzKZi6OHClrwaWsdLASQNdVv2altbEiUrsKFlIeLitZuj5gxdQgSFCwthY9UHQK+9VPd0kCP7ky+DAxobwmt3pzJee1q+BWJJxRaWggUnc/qyIb77uxCZFNWozlObtCy3dmwuN0XlC0DDqNgocU3f5OnepUgfzqCrjJS/TBukgqCcKk/XY9FHJmGPeArVnIdixmfwhM3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiwe55+5XzojHHBu0bgH+CUW0f7/keT5MIZteY5G8YA=;
 b=BJpwOXFBgJQUOm2WFnViyAZuiP764GNLPNt3aK3/9Tnx8NBba50puv0SUYr/50naoK6CaNb2FamnXJtFR/3Yn8+D3lDEtRPL+PJjwjBoabLYaNLQvOm4I1IAmSn1AoC4xEP4oLNoDsPm3rVdQ5+5me6MG/neG744Z5IML8ZbpLyXHcgiZt/LeIL1Q4pbPliOaG4jOzXXCLxuwGTBxZtvEmQpP2l4H6lFSFQ99Zi/W+AmYirSvT1DUzkmx1V2F8iIKhIyNxMb/DkPfL7DRcTAgqaA+WW6EXL9gDvj7R3a0mXbdGJkrNNfrSVSDe9Zv/dT0/UVUWE5XeZH8XBpqG3ISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiwe55+5XzojHHBu0bgH+CUW0f7/keT5MIZteY5G8YA=;
 b=k/Q4ZCW8Ly228igcYii5uw6Fcas1rboHbGciaas3CUbvQ7R5FEt9cOUloKAyMpstZHNF39+iAGcpKTP7V2CjTKJnNDdD6qf5EZQfgu6AC/ApaJQ3+St30o8ibuPkMbQlPXH/X++Ll00MXm69vzYWNxh5leRTaIM43pnamB5iKqkb3LQw+0zM/IX6adrXmY3k4PRGbJptuukb9kPbQniIQ2fnnakuvGa7UYS2qt6d980a7XE5LQ1RzK/oG1N2TJeFYSPveGTqIrsO85SGoWa5BJNOTE+2B8S0kF9fU8Ti84CLeEX2JOfZpmM6VW2qsbp44+nBPZ/MKVlcN6NPoUgxXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:10:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:10:24 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 1/5] vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
Date:   Tue, 29 Nov 2022 20:10:18 -0400
Message-Id: <1-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d471e06-55e5-448c-e0db-08dad26746de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6WS0aj0LGYqIdZOpYVoKg6UCmMyuj5Bzfvmz2viOeHYC0A+HbPgLSqoR2rLoz+/2ylmwRONNUFAGJi9kBU4EjafvZiUlAm3vnoqQpxA7xu6rhUr28nh4c2B/6S4NKaiL3JqYSBJ8ywiWduSFCEa6Bj7nlf3eVwArGogACrxfI5KxDY9cfTLOJOn9EpeH37DlKf+Wva6O13TaB+Im+jAevhMgmEl+4OQx+hLL3VpLG/DSM2ZsOxh+C+XPb+mHjU1PvvNHgaOE3xE7OvJE+y8IFtbhX4FBW7MgD8oSthxwO8WYJmoGvacWR5pXPeQQgSnQYf8OmLabxFl7JcjA4JwIYhunt/tG1CkkggCkYAC0WiJmzHE4LVDgG04raCsgNBHcNgdZUsJuEzJpqMqhQDdo5+L5jpDO5yCW9nWdJONUWf7lYTo2ttCbyjQdYNivL/Fb5hVKlHvVG4b6F0OMZIYocgXwP93RsN/adi/hiZZXTjRwPm4tp8WtNuk5mEIVsgHjUq5/iEucfo1Ds2/Z+o8wlEzTQOlttpjY1xPUtC+FhSSWEPTeLFN8BEzb7YoKiO6Yq9xSfCs2AYVdP872L7ZmapgaPD+ml1zzyvLyhk3ZNq9gDmcYMqBfDW87bBhC3YLRFmIC60DvIk1BB9CQLgAX58zmAuei+RKmnVbWx4q3hlK8itghQsFczEktttC3NKqx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(6506007)(110136005)(2616005)(316002)(54906003)(6512007)(478600001)(26005)(6486002)(36756003)(186003)(38100700002)(86362001)(6666004)(83380400001)(66946007)(4326008)(8676002)(5660300002)(66556008)(8936002)(66476007)(41300700001)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cZL2ItBLtQ+glO2tBK4JUTo43p/JBvdXgbTfxGZhkDHlkuhtFAeKqh/rC76m?=
 =?us-ascii?Q?YjDRrEFbbaiHOXpT0gHQGA+Xornj//SegvdiCGjaRYh3fCFNbZDRTJxo0mHP?=
 =?us-ascii?Q?twTv3FIMhlsDO5V/f8aQInZLooK4txvWXUgEhslAnG3I8k9SdKjeuXdvzEHv?=
 =?us-ascii?Q?wZcUJQ4CjzkX5UQq9XGTnbnzESLxlUzIudKdjjII4wCz0FKbe9AjkBVTGszb?=
 =?us-ascii?Q?Br7ooDj2CsdbM9zgxYjndT37LdGtxRYFGjHo7W2J/HyLJ7HOdcuNRdB1gIh+?=
 =?us-ascii?Q?4itoZHdE6FK0XQOnoYzx12BqU3jdrxBCeV7N8QAwiBt+9ODjqqQAC+6oMpI7?=
 =?us-ascii?Q?Dyr2ycUi7i9MRW1T243L49LTkfytW3um6tEu1GWuPzTree/67DeW6PRWKfS/?=
 =?us-ascii?Q?ekia3EZwtT0oiyUtW2N1Ccq2ceZMCbllMRgJcJI4chxO/QFXYzLnCFNbiQKz?=
 =?us-ascii?Q?Ev94a38dVNE0R6UrWpBS97RXJ/WdAG68U4W2zTkqdGZjtqoQ/AGm6hxx8xRQ?=
 =?us-ascii?Q?7xvtGxDWBuyGWLXW58i90ku1Rlcl8swuifYHAVgog0+XW7KnJeBuF6LiECxw?=
 =?us-ascii?Q?glGLFYpzIHmuimv89LDxJ5aZOktMRz45x2ocA9KE47aIYPcuj6sfbA3IslIj?=
 =?us-ascii?Q?bt78TXfcgOLTBkSt67wkomva87RHnhcQGWoREZwihiqY3YsJNUbPPN/F3sRs?=
 =?us-ascii?Q?2FE1oWYjUN4IKfIcR3O3z1ROGCI515N+4wP8eoHxFepxeMIpTDZ3IXefpA7w?=
 =?us-ascii?Q?5if00BtkM8EZWtC9AKaw1K2l+AChbdAmiOdttIup6r205/C49izVLruTa2Rb?=
 =?us-ascii?Q?FynwD56KqZliYEqif3UALqqfE/UnX+fKZT0PNYGCpqUzcr3rvK+Jj9Q9+5Lk?=
 =?us-ascii?Q?QOH/5dezMtHr3K3GSGH25pEnPX+/21Cm2xAJ8VjnuIjpjAsjRqmEGl+UrkD7?=
 =?us-ascii?Q?GN48XFVJcnbmy2Ou1Kx34RVqxU+4GcFuVErRp4FKPfBnV+rx1k+YEqBhwqES?=
 =?us-ascii?Q?MiE+yIMEiNN2vsaxj2YlZebsMM19IGk5NZoZI5xr45YDZv9rr+oIjeDSzJot?=
 =?us-ascii?Q?LZQWxmTuwE03EZsE+mPsmhEJG4yu1i/1qEH0XMAV4uXde0AFE/yR13qiwEG0?=
 =?us-ascii?Q?d37UxAiJRhYWLoXd/MAKTRDqfEwVlVzacG4ORICFWgzXrXHU07QLnpaLRnnz?=
 =?us-ascii?Q?4QDlcOHSWTNf7g1InuMOWg9yVH/PTQ3CI4RMopm1rCyIj8jUCuyiYTYugt4c?=
 =?us-ascii?Q?eyV/IqMdlot1UFFEY10KsSiKNtcQaSDkGXwnlqBkVEC7HlNKW2cGjDj5eHmL?=
 =?us-ascii?Q?i+t2yVvLrS/Vi40FnsWWrDxMRZKhXYrEsIkxHmSYh4VC8IDtnRgzpl36Votd?=
 =?us-ascii?Q?J7KVFtmFVSR3qhksx6QUJ4ecNazKlkDJ1l8ujjTHY3hW8RakFX9T+uvK0w8N?=
 =?us-ascii?Q?LEnLa0oPzUVGRxuSdpepqRxHx+wAxnAISSXOFsWGHtvaGPrROHEcIoCgl+Tl?=
 =?us-ascii?Q?rii8auTSAGugki64WPBd80QAiPXsRONpMlm4wivtBKZYQ5oUodebCfj03+Uw?=
 =?us-ascii?Q?+EefOPDKwxvsYte1JSY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d471e06-55e5-448c-e0db-08dad26746de
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:10:24.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdqnqsMGSEd33w+yAtnSZYaERkd6zMVt8F90r4V7vc5I/1IkpWldp+WeQiPCNkWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411
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
around an arch function. Just call them directly and move them into
vfio_pci_priv.h. This eliminates some weird exported symbols that don't
need to exist.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++--
 drivers/vfio/pci/vfio_pci_priv.h |  1 -
 drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
 include/linux/vfio.h             | 11 -----------
 4 files changed, 9 insertions(+), 27 deletions(-)

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
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16c1..13c0858eb5df28 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -100,5 +100,4 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
-
 #endif
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

