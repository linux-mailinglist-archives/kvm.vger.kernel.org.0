Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B52F5A876A
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 22:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiHaUQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 16:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiHaUQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 16:16:15 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C04EEF29
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 13:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC6cveTi8FeAgM3TgIBk29Es9x+X07jqy/E1grU8kZ+IsBaJxtIyPBLBq7NuXMc4TalzXbNWXznr5ZHCQERLKwJR7NlstpsxkfdsPaZ84aL6c1jFQ1LPN2Sk/7WSOvYZqtzGDyo6HLuSGmtfK3CIZzMHj2k1w5z3S4McwMh7PbyJo9nT5SUQRgV2Cbpng8EET9+oPWPP2N0xKBCEhxzBHvtwNRmJ766HLzji+G1duAut2b0egTyOOBLjaxDiZuoNN95eZPrT+pwaFZpVRbynRnez3nP6/Bi3m9+w4K1cW+pBG8Q2WqNcoWRoCVuUU4+RQINIDVoHXvWueuC7d/ZXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43hIONZo9MUVaehPd96715Nqngi48XPak0yVu3PYuQA=;
 b=Ocwy4Ei8b6oi5fy9Qo9YcMmwvDRxHAAikQCJab+5ao2TF8oo4qL1KwTIMga04mI8DkSc0qG9KTsS5hpR5lOZnzjiqNlY/t7bqhdZ31oLS+jWcqFnHtknrhJn4T4Ekdx/iGx2b+zghzgU6/6lb4oqEEzyDrlSYr0SgrygpwXiZLGI3brustsOOjr+hGUZTRyxCTTXGiOrGOId4EfgR6y/WtuC+N0dIfSJACWSy+xe0g4V78eDDn67CWRFj/ZRYcqNqAq+8BZV65KVQ9sxnMmeCepsXoBJ/U86pOg62VlqDqIS420+Wg7MWqkBAooX2XRa2cxzKc+kspAbU0Q99CbBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43hIONZo9MUVaehPd96715Nqngi48XPak0yVu3PYuQA=;
 b=MJqsVN5NcY6gaLSWYXkNTvMgs9uQZnKGqK3VEQliPMkfnzemypvi7Ayazvi9sm3DYfQD4v6E6IHakmKucNsW+p34A5LcTutFwtt5GpB6g7TjOqXw2fFiVJrvUS5oO43t8agsPS0KwKRwJDk7kwvmuWZRZfLKcaNOScY85z2KG9H89yjcmPCWT4UcZwRcVjJUqkAgCk8E1tsPEu/85WWq5rTMWtGLJLWuK1fA49+muy0KiDX6Bu0yZ2uo+mPxh8G0UXui11GQRLBpDYwVTN481p9v8ObTiYPwk7dlMB8YahW9iLu1C6Ltsk4R0hun9CgD+KDtfHc6F+uEXsdfNmniUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ1PR12MB6316.namprd12.prod.outlook.com (2603:10b6:a03:455::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 20:16:06 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 20:16:06 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 1/8] vfio-pci: Fix vfio_pci_ioeventfd() to return int
Date:   Wed, 31 Aug 2022 17:15:56 -0300
Message-Id: <1-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0383.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::28) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b0aebff-61de-48b7-2bed-08da8b8da204
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6316:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXbS+YppRU6CZJQZFx195cYUA4PQ9hOzFueXIeeQWz4PO1y5n5SC37nR8fkxyTxQBTNrB6mfR2DVXiQIfeIxeOn4G2vSYQud6KDn+F1fQ/9oApWZAOmXDBc2zqYjtwp1H5zvyzAEWgczWhgo+i4WP7R/3Lk1qQHQ/j0E/1EliYUoMUcy/zumTwmjyjipRbcrl6x7xg8yvK0lWxQvUiXAPnC4n2APs0fMq4qjkFzUE70RMBdTC1QS2yyZfn70+GpPkNjbRctpMwI00FLEwBZDW3fcBMKgTbB3ad59Y73rltP2+Giyo2OXSUL+0pxnktV+Ud/drUT4A5XYLn1+g6nSSs1yfv3RtyHlbdExA1rJt69d6Dk93nCpqM+UfujhP1vaDv44RwdDHi8WaCCeCFkis6xMpe9UrKK74vTLjgkBysP6l5x7fn7Gb+3FxyfLz5ymQ4458aQ9ooehqcijirJsac03cB87dIt5T78j+//U0svGzS54QH7fXU+VmgiqzFb/A9o4xUcQPw3IZUVYYxi9ui5yh+OIs2qsZfcW+/fOF0HCwse5nyHtuuZUaBV5bSDJTeBu3ZdGpaUcpqBBXM+bRhavQ4hgBcgO5EeVg6piXRJEsPyMiIZ8kSB8hu6/r2lroHWVM9Li1ySet9jCaGd+FY9GooZ48OacmoUSPliZNk/9FprIhjyMMJSUpv0LmAMRAEgZSkxGgVpP54ae07s7EtZ+b8Gp4dw1/j7jHnTkD2dUYluX41XVwigUU6JF8m/X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(186003)(5660300002)(110136005)(478600001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(6486002)(86362001)(36756003)(8936002)(41300700001)(2616005)(6666004)(38100700002)(2906002)(6506007)(83380400001)(6512007)(26005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JQWr3kcXQM0rVkMC/suT1TyR4zH6SCf+VNbRy+yCQRN8D2gJucAlOsLO8Rak?=
 =?us-ascii?Q?Nb0PmqQNHsArqs3FgLv91aZkqtWllN4aiMAym/wHqwkraaH0lxVLD/XpWi3N?=
 =?us-ascii?Q?lvAHNpf0cyHf9muZCC0OJbOeHMiKN0gGeMaTTeKy4uy7hBkZGO9IPAHWy2/Q?=
 =?us-ascii?Q?A98MDPSlCLE7PK8Lm/9tkJIu89BZS5kzoTrHVpwea8cwYlIY0GZtPt6ErS/x?=
 =?us-ascii?Q?REEynaxQD509prkVq8v1SdjAHXMrOUCri9W7epkiNqk0rqXft4yEgCOqLcHT?=
 =?us-ascii?Q?tQIbvFlCY72gn84lLk+G4Eh1shpF9kXGNkGLbNeu+AKFthazPcer0A1w6jxU?=
 =?us-ascii?Q?ATUQ9t/FEc+DxHNruWNAPYqh7Gm1kOgPFDGblDf4obMQDe3rYO0ntC7nNUHY?=
 =?us-ascii?Q?ab+BBJIjegxwQuPy6jRueaX3e6nFDjASPU/EdUNDdv1GKlCygbQnLnWAH8eF?=
 =?us-ascii?Q?kKTCWX93KdbnGLzImbxX4xPZv3BLFj6haYNuGHudcIUQxCscSWlKclaBZuqy?=
 =?us-ascii?Q?KC7hnbsSVOf/CyIvb1VWC3I01fifECv3Fy0YmcMzg/uwKuRIqLMR+7RFrMyL?=
 =?us-ascii?Q?XTR+zUNPOFU88ZC76dAljZ60v1fzAGgxu8Ur0InwSy5RbQYqLnk8jfGa/w72?=
 =?us-ascii?Q?FvjdKB1j8z3ZiR7WDlIesW2YvoteZgLb2BUZasWtSi9LqmytnPh5fHqDNzkW?=
 =?us-ascii?Q?NCtgtsrmsB36N+SsqCNHW2Bopr9aM6VWk8vwNv3Lklk7RB//mlRA1M+ayIEP?=
 =?us-ascii?Q?oZVP6fC1uDKPE569UlDqWN4MwGS3C0wbI13wE4xNkZPQwupzN850arOyESBi?=
 =?us-ascii?Q?01twRl2jsOLwE4jlgXr89RoM7PIEmQnO/3dTNwgt9/F4puI9iBpQTjpAynCX?=
 =?us-ascii?Q?nIqEukpt0M9FVli8K0717CWBngKRAkBzr5rLDzZvWXBtgksUec2FxYGGC4c0?=
 =?us-ascii?Q?L9wq3je1SjunkhJ7Y6Cz+7hAtplOZqOoLrymiqCbJOzu+x6bMp8YuB1Q4gRY?=
 =?us-ascii?Q?MGMUcYZPh6dfvOV4X9qUQ/pJQrApclSkd53s4ZY5/Sr/m0mPF65oRDXcSeFU?=
 =?us-ascii?Q?T34NVJDierH9fciQlgo5gra9fBVPPOJuvab7NVvhAkYPA7BrUtEZdFle4KRV?=
 =?us-ascii?Q?6H0fGVVRXixrWT5rtTR5ieHl08nICrG8SvfiPXuEZwrRmDOu3UeS0OamYBho?=
 =?us-ascii?Q?oNQVwS3vEaEu9M4UDi+T0v/Hgx8IASfsn9znhCqPnBQwkei7/dYDx2sH1RxD?=
 =?us-ascii?Q?dTSRL/RahmCwnwH6lVVYLnmJ8uZOdHvkNRJry1pGsojbPj7PSu9dkDk2oQr4?=
 =?us-ascii?Q?rRfGKf0/sNhgxsXQyCR9YuCSR0G2lh3R6lv7PEAf2Q4qpe0BmPvilOy5PTW0?=
 =?us-ascii?Q?qRhbQK2GTgrtmg+g+QohUOjx4e7g2aW5a7NOlTP0YcEalj1Bjp9ycdB0HkTY?=
 =?us-ascii?Q?R2GoVHzdz05chiqDiVr2J0SqR4dpTr8fRbmIFDLkvisdUu/KoRQRQgPlws0s?=
 =?us-ascii?Q?62odVpgxgKn3SuDNahJgdCLPOtMM38YRQ4HkIfK6WIT/XXetHQIJxAC99lra?=
 =?us-ascii?Q?I3XpeYrpbVZ9m4/XLaN2uY25rd5rBdxjyN6gJzfV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0aebff-61de-48b7-2bed-08da8b8da204
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 20:16:05.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWpav4EqHAWnT0V5D4FnMYayaBqlyGEFQvwj22DizWJ3DUxl3aVtTtJ6cn4pfDv9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This only returns 0 or -ERRNO, it should return int like all the other
ioctl dispatch functions.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_priv.h | 4 ++--
 drivers/vfio/pci/vfio_pci_rdwr.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 4830fb01a1caa2..58b8d34c162cd6 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -48,8 +48,8 @@ static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
 }
 #endif
 
-long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
-			uint64_t data, int count, int fd);
+int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
+		       uint64_t data, int count, int fd);
 
 int vfio_pci_init_perm_bits(void);
 void vfio_pci_uninit_perm_bits(void);
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index d5e9883c1eee10..e352a033b4aef7 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -412,8 +412,8 @@ static void vfio_pci_ioeventfd_thread(void *opaque, void *unused)
 	vfio_pci_ioeventfd_do_write(ioeventfd, ioeventfd->test_mem);
 }
 
-long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
-			uint64_t data, int count, int fd)
+int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
+		       uint64_t data, int count, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	loff_t pos = offset & VFIO_PCI_OFFSET_MASK;
-- 
2.37.2

