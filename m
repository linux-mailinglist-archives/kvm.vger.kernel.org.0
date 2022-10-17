Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2974B60167C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiJQSis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiJQSio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:38:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6C072FD3
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGiXu/OQSQiR12Hd2558Segbyg9G5rF9kJK664WcvmmTQKXxeuKWV9ioRdFHkbsz/QKKxFBMErT2H8iPrs1neZrxR1o6TW82WFOyFHUFynRUhoy3Ah1eO3Y3ux+fjnz+ABomO5gm6Cnqx8b1kUqTmAiWE2GcmfWAPnqeAcUpyYwwzyB70tsiyGS3ZKuiyrHLu05OqAFPRHqj3Erw8Bl2RvgLMZRymMmzbv48ND0AG8dfPN9hdhO2Kyvm0oxri0gk/k9LGRv16d4d8olt+sBHa9dNlzeLnpaxjMhQy3mToRF4j2IxQ8Ew7B69q7nTySMNqPtXXUboK3BwI6HoHsaT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssUwQKateaRIOZY0rEuKN0gVaI/OrWKnhxHdl6RkhAc=;
 b=cJNVpfpUuGTzKnyelMEDcmPjTAVqLFnXywfsdux4XiBLmokqOncd6InnoLKGXtZfth4NnAXe8L2vYcaNrPjeb26jQBsfXaLcc01DUk0Tj6p0S6lmv1s+axhW2clMRdcq2D8VRgVAEwqniV2f0wNJWiyldCeCY3nxwgZ3LbayBuXX1Og+/4umViOdlP1CCDidz5nzuEUXA4kj1UHYklfr6lsbPiKD2X88GnxI5mxyyjPY/nLkaMf741u4NXPjT614wxXFZ5U955o3PQ/Wxbk3B/GgoWTE1lIKtt2GnzIQpKUJpLJ8xwuHdiazLWSe5YwgqUcNM5uepgw9mvk8mr0QTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssUwQKateaRIOZY0rEuKN0gVaI/OrWKnhxHdl6RkhAc=;
 b=c7fSm9YNiBtfvAygGJm7Z1nmXTo1q9twxUjegSMeeo4PDbmmR4zMPIdl2i8tuyqDshkraJIUpZX6dQbvUxChJ4HbO5APipgPjK85fd32l561ITP+HCCASdeQlRd/3shS+BkTXo/rGEozbfCo67MQ43fCegT8KDdM1ieJLPoKwozLrZCM68hJvu+GMFx7GgxmeYwiDFw7OhiCuU5rYjXPtKoSXtySV6CJwrpneXGaCylDT559Nggd7s+X3ONyf0fGsVFJgT+pS+q0AhWAkF9H512bGA+bHjCIwy6Af4hSWhwFATDCc/wh97Qd1xXK04DvuSDhW+j+B1nGhLphPUlHtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 18:38:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 18:38:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 4/5] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Date:   Mon, 17 Oct 2022 15:38:32 -0300
Message-Id: <4-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: aab6a85b-5da0-4548-0655-08dab06eccea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEHsxUGp+3JtlgEiiQO8WXHngyVI703JgoIYDQGVWr8BOwJSfxsvqN277xepedJhpJv9e6ztDHKqXhuTAaOXZw1Z7gyNRwRrcNDpdS7AbNUewlJ2wuE09DqBRByfdCVIxFn5IpILf62J3mCiPhwdexw5HY3/0qeMFAZcWyHZN3FOcKfi6PtOCIhMX6HjPQZTGuyqp9S2+wuK83wuqXaHRdxD22ClUdtBC5htTM45jeVWT7n7qMI0ssiyR2UwbMZJSMBV5lYMeUTeRDszBeLfc6iwTugJll3GFl2SEOX2ryYG8GoLBdXN+38z6q6UZwFP+VOlybyVoS14OGYHixiRC4CJTmsbpL7HyXH7Je0QwnlAnFEJyqK0oifONhUN6by3KqwxPBhBgDc1IHkuE8khVM3Mx7PAL9UrBY7sLTN+YZyjO8xTI7muu18/QNobzdKrTd5z+PXdNTOIeRR+ovv3pP2ojIav7oGA534OBQ7DxeNiAfL1SCpqjjLa/wlINpljjG5CFjMuwdpxBFGAPbQvJqqZEHvgeebflwLIWffcTcdrQ10JT+RxAA/k11eMp9Z4Q2Qi+4qZ++2TNF89XxmTpz7/gFXBkdgHQ42FB7TsarY1E2+PljicEO6W/zFP6PWj9d3pkykl91yygj0Wr8ZLEMv4shZ33T32JccVjLVKpPMMJkK1UX70tOca+eKslNFyPpQEhayeYFGeWBWqWCSIAKmo2it08lxoiTnHB0HGqd7CPMVy3mdySDhNxMVTGtiH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(316002)(110136005)(186003)(36756003)(2616005)(6506007)(2906002)(8936002)(26005)(86362001)(41300700001)(83380400001)(6512007)(6666004)(66946007)(66556008)(66476007)(5660300002)(8676002)(6486002)(478600001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ykJofLIfG9Ta9phZgS7A2e3pzVbMb28LxEiGbkhRyStZUHf5WCUnldpKv+Ge?=
 =?us-ascii?Q?3hIihO5+LACs28mvxDVv/HgEJNvoIk0bCFfc1BStdi1ZZAmDUFfiAt6e313o?=
 =?us-ascii?Q?E//ZRa1VqKcKxK8JHLV7G8Q9cufqzvGmlgMMyzQA9fqonyxoeJXgZUxLdoHc?=
 =?us-ascii?Q?UwmJ4bl73DLuITThJxrmusfgyMWXXpyT3CRwORoiMDQZWXvQ6Po+GD1zf1hT?=
 =?us-ascii?Q?xLIviF6YDw7qbPszOCYhuOhgzjaBeKdEUznIJpkgbDTIxK3y49RO9J3/e1US?=
 =?us-ascii?Q?uF2ZrXB7jASogizKofP5I92F0QqwRJ6Ci2/F54ZRXhZB40EdWN3P4GUG2Jiw?=
 =?us-ascii?Q?KGSbJE8Gcc4UNmXIMPITXotlMg5Gp/Q4hPYB3VdgiUbT9nCJ7VHhp5HiOQne?=
 =?us-ascii?Q?hevMHoj3j/DsiE4zM8AI2y0qnZkFa4k24nXrSz0+oXlgM01U8OgBmStHRQwk?=
 =?us-ascii?Q?RUz6svbUdNNh0LGfKdtU+ZInSDOenq2Iwzda4lJDYmF0LfvNaLTvPtr560Fc?=
 =?us-ascii?Q?qYwf7uN0Y728WVndyrWGdD1tw54+8kNMxhLXPaQ/6cINr6heO4bGkiPOwoXH?=
 =?us-ascii?Q?5L8v1GcXvmus64V9E9IM9KYxYBjvRaRw4RKeV076bVKPSjoWsHG/rcfzsUsm?=
 =?us-ascii?Q?4Sdb1aVj515vqSupC5JUHKRKKOwI8X7EEWLBHyKQiyfeZV/HkiZxNXMF+LgR?=
 =?us-ascii?Q?NfIYK5kypz/5aY3maRUUvRVjSWkNZ0xgUFCIWnnI9qaaHC9VahCzRy2Hoc5A?=
 =?us-ascii?Q?6RSmikIUEUsBZMSosgMIN3rvnY1kL4La/qkOHLj0Q5vggcE9yQytijFqEz44?=
 =?us-ascii?Q?ybsdNWYQnKyt7ebYLTDxu1gvQzwUUZdkzrPQZIsK6GBdsBLoNu2GsjCRBYsm?=
 =?us-ascii?Q?30kTMxgZfzbPB7c/proE/xnaoBz+o9srwTp8cTUcRbZdUd+AqPOfwhxq2MbG?=
 =?us-ascii?Q?xDvnMe7MjGHSx12Zy4CHB69ikrroneYW4hfraOGyK9KXayRjin41kzP8y4gq?=
 =?us-ascii?Q?dragbAutkMD1mheISG9unbu8qmRy1CHo+74SJwK9c1Zge4c5e8vSzIoY/zoM?=
 =?us-ascii?Q?Pl6exqOgCATRNYReK7p1HIu1+Kdaz7zI82vM5oj+9japX4eleKITS2quVo7n?=
 =?us-ascii?Q?LCvC8IPlodrDWcPjIwOOW5XqbU1CdORCb5O42IjouE+J+iMwVcVB24eJyXM4?=
 =?us-ascii?Q?SIXwFy9UcyRNsZ6p+lz0UoWrJGU9iN5qYnCuLJIhzXFmSL3FfN9e/S7Fo4kb?=
 =?us-ascii?Q?DRZprETkj24B2Lb/llJLAbIitPxqRYJ9hYr8Ywhz1Y120LPIYSV9TmX54b7G?=
 =?us-ascii?Q?BT7NV0yl0RCBktt3XUKh5ntRbRu0zHCYbpdESc/IcCx5KubCN1+c1cJZqGyH?=
 =?us-ascii?Q?WGX9yYvjlqU267x9I8LvgnewUdFWzn1+O10WKr7HBqKNQo6ky6VEvp+tGdcf?=
 =?us-ascii?Q?gJyz39RJB/VY0aur5yMUx/icOQoYbk2Un+q0r3QdWGOgEtXqvEnljm0ZmTRg?=
 =?us-ascii?Q?xtgolQ07iOqjlYlHVyMRuMdwQxmUog6mE73XDZAnNfuR5+1v+FP6+sFRPlZV?=
 =?us-ascii?Q?rpVpEcna8WJR2uiw1DM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab6a85b-5da0-4548-0655-08dab06eccea
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 18:38:35.8532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlcfKbFvdjGg2FjpuzvFmYsydgTgGDkZH+5qY3A4Hv3l/PVlPlfYI/+yo+WDlqbj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
the one remaining place that needs it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig             | 5 -----
 drivers/vfio/pci/vfio_pci_core.c | 6 +++---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 86c381ceb9a1e9..d25b91adfd64cd 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -20,11 +20,6 @@ config VFIO_IOMMU_SPAPR_TCE
 	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
-config VFIO_SPAPR_EEH
-	tristate
-	depends on EEH && VFIO_IOMMU_SPAPR_TCE
-	default VFIO
-
 config VFIO_VIRQFD
 	tristate
 	select EVENTFD
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c8b8a7a03eae7e..6fe6b27475b75a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,7 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)
 #include <asm/eeh.h>
 #endif
 
@@ -689,7 +689,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->sriov_pf_core_dev->vf_token->users--;
 		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
 	}
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)
 	eeh_dev_release(vdev->pdev);
 #endif
 	vfio_pci_core_disable(vdev);
@@ -710,7 +710,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)
 	eeh_dev_open(vdev->pdev);
 #endif
 
-- 
2.38.0

