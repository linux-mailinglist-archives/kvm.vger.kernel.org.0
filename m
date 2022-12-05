Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C53642BC7
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiLEPbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiLEPan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:30:43 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B873ED5D
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:29:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=No14Ekk5EcKsiY0OkKQm77r/37kJNzJ+MpTUoRbV5OI28+yjF9ssLgr5lXHYfdKs4mjIklySV9CqnrkVgUzmOPDCVjiOSYcW/RFzSqvmYyJoGxGqlkugt+wEw3sNQUkJKEW+MSnINRTQ7m0r0V3zlcAe3XIy/Ven97FryWbyl9cSHOWkQcpsSE3s73cs3xXBEghsJBuMYHDJCHjyXt1K3q6i5268po6K31hGD85vrxgdrYEyg0MBfdQanJHuuersnGZsv1a6W2mZpCReIPikPOUn+LkiRW38HLVaZHm70Ry6GAnSWD/Dq2b20NvgpY4ECxNo1fs9h/6AKll9edpvcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UKev9sh0TOQ5fudaYrogAWNvmFTTJ5C0XVZewMdTXw=;
 b=dnqV0IYnBz0xVvCtjte0FkqnoMbLefYbSc1Zbxk+DQSRnVWNk5MnkfR6XBXYuZj9Hm9FhL8viPgf/wmTPAGM1Y7zcp/mFiBGHk8BoCiA1t9jksKiNLxyOcknLmhdvb+ClbMLtWQXISjDuYo3avWQ3RyoxEv/1XcReEl8ELbWrNpFT27NEE/Y+aHfEsfPKyPGU6MnIUUlnWblMmgrjjOPukic6+Y2+Dc8PMsFEKFxLd5JDanHplSEbU8kvGK6svRcf+XBbK/C3+hwTanL/LGd4i3OTBw/73yLH82aqLXMT3T1xO4SBmPU8DFFQyA+IZreQA/QaK4ZncilHRzXvvr4JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UKev9sh0TOQ5fudaYrogAWNvmFTTJ5C0XVZewMdTXw=;
 b=PUltZbUU5hse5g0nShuKxwT/Be1KoEA+CS6cTH6b8bZn4uqcoZMdeMDPyFFUm+xmqO5diq1s9v/IdSPcy3JT8jO7svKI58zxxsRX1dpPVnu1NPybMzB5d/9v6QFnB0DjsbhorqXf7rDW6npffxh9Tknp3jW77bPYrMihEgtSbfZ0+2P1w1AbCl0/NN4KRECsRGsXIdHSB+FAOcDLqmXM+i/Gvi1NuGJnOKWxuztGAcNJhkfw0qrkEmFZ3c+59J7zA/3XbTDggzc2kUyg1YmGnyH7T9plz13pEhkQ3G5XGQJd8a6HKcHvS7fg9a/8sZ+fMr2+LhvYLiOfD552mWhbTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5955.namprd12.prod.outlook.com (2603:10b6:208:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
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
Subject: [PATCH v5 4/5] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Date:   Mon,  5 Dec 2022 11:29:19 -0400
Message-Id: <4-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a214ff6-cff2-4115-6f64-08dad6d57c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZrHX94yNBiAsbs0HvioU44u8o8FxCz0PkZkxfzpGaeYCwN0dfz3UoZPi8snN28NONxQaFK+ut3PkJ6HVTRNomxlc3/rRctoVvN9sWgfs2YJArT0WisYDy2sGNdNcjBwBanAiQUGnSwmdorAlol1Xo3mL9JM9ui4LobPfxEKtvIYDCraHAHIFX8DBgDL6OgeJvRx1ieMWdKFpdAgLX2xjZto9yOcf0Oy45iLedMUgxWvFZUgMxlN+hyLOC2yj4mz/BuKbxqeTrXYFNKmwKVsh2sArv0sTCCQYEWeHEaghCFmldRpEDnVHfdsQuuk/uPHJ+cLnLRDaO+BWJ4B//dRz9FOzmatY0JqOCfax/fOWOUEHztl/oh5uJm6Q/wbomcvNOTySIeRTwBe3b2l+uLUNiHC6omyOiSg+lGfLD922HI9djyIUgdMRnGGGtrz2PM8pOpay4a3cnCTIfB5FWluLpXoWjvbDvnS6vTWgzIyOl2KWF+5Al46U1rRkFiuUPQmHkMolSLA7oy8wlC69ICRQk9DlZPh4XIVZHFUvMY9l53dcpwAv0j+kxBxpWZlUis+rzQ/JhZPcQVNgU+PxxqBeeZML8D/FnZ9qh9+oGmK6K3DluSiaTjJzS0+jSFvyxF5OR38QSkjFodk/KcN/EA/MhkugGK1ZrbBLzwQ2JSRL/JANki2wFItw/W7KwKxIVT2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199015)(6506007)(83380400001)(2906002)(2616005)(316002)(66476007)(4326008)(8676002)(66556008)(66946007)(8936002)(41300700001)(6512007)(86362001)(36756003)(5660300002)(54906003)(186003)(110136005)(478600001)(6486002)(6666004)(26005)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YwnjXV0BSUwJ4p6fG319KzIzAO2xRijGBtf5O2C0wHHrJ1CMRq68RwCGTCBv?=
 =?us-ascii?Q?00r2UO866zn1NO2dP2xiLsKfAsZFCVHEd5K8+4bwHse6cNoWDqd0KeK6apC6?=
 =?us-ascii?Q?RDK9+BbIg4QElHIeszr8eItoskGx6qtvXmWMTXABQFE9aB4Fy8pYBf2JCvtK?=
 =?us-ascii?Q?pE5EU3/sxCcYDA1rwhr9+NXOGItUlGgod2VpOnQXo26a7fjC2FkqIFJf0jzI?=
 =?us-ascii?Q?MtYk8zi7J1LchgTz/HLGvQJYSh71+qAWQhqVuUZvsEkLuSIyueomPoiTEhe/?=
 =?us-ascii?Q?UfVlpZcEitw3csGb/BequFkA6h8H/QltHQEpOWAOEaiXBodzuE/gtd8X+vce?=
 =?us-ascii?Q?61z9YtSdtJaqH1eOq1afwG7XWRlAAuArNw/XmFrKMedduDn22xRq1Y3O8LYv?=
 =?us-ascii?Q?L4SMWQMKoJoyrJ8LMX3iGAute5tVMvA9XsSncs2SkTTqQjDrIaFUSo5o1qzJ?=
 =?us-ascii?Q?rPuZj5wLkK7p7z4LdOjfvGet919lxH5uySfRdeTCMCcZTRDrMNEVJAO5OFDN?=
 =?us-ascii?Q?5DYntZsLV0b6ds2Ae11LJTjRTuoi9yGXydniaKiOsETLSB29UCSJozTBkeJr?=
 =?us-ascii?Q?XbJXC8CDlIcVabzFA53lb4B4nfflMrMPd016GnSKPegXB/xaOZPm1j00q57F?=
 =?us-ascii?Q?inUC553Rc2Zj0g0nwDjdFtQ8eCMy+WsHLbRxAUZrU9qslClTm9edXME0YGFA?=
 =?us-ascii?Q?NWZoXqcfkKNb9hVq85UBpjsoD+jjXZt9w7yJaYbv/48+spnrb0bIQ79KpJgz?=
 =?us-ascii?Q?mBDfIJlR/apKoQeLYncPv4lrXfqJw31vBSn8ZdG+Q2OBU8ZSJyuOcJJtbC0j?=
 =?us-ascii?Q?/hmRF20X/w2LWd2NvOwSFZFT7rRt3lq82cXWn56ZeXgsNGfqaHclZ+qqHucv?=
 =?us-ascii?Q?b4Ih+XSHyrFMlR5PwJzAYFHZntCCFQuFU6Ol4rNO0OB7ahBMf8okVv9TCV1/?=
 =?us-ascii?Q?55bT6etjrxUpEmU1AFclkgMH5Jo2VkufL+Vq7Vd3qKczCkKO3Mbuz45N1KyA?=
 =?us-ascii?Q?6SRX7llKQtaQzSHHgEFwEboy2N9vyFrd3tAWs52XBM0exjnOALpJ13iJZt7y?=
 =?us-ascii?Q?OOumgflhimfipXqqdbOXpZcxmTlT3chCSRy6ep71YUcmjjGK27t3XdTLLIX9?=
 =?us-ascii?Q?9bhhQvB8fOEK51cE+yZELZ1fUy2KPxVbHh3HHci0n3MbHyiqmoxjVCItx6gH?=
 =?us-ascii?Q?g5hVqhuzvRxa6rn7x9eUyuSKjbE88e6zBFFWcVFBI6B6JUjYygmW1314C/bP?=
 =?us-ascii?Q?yNt485LGakfyQq643EMhatAABgj1RJgkHoptIubz1AdSSVH3RCphozne3uEC?=
 =?us-ascii?Q?yEJOp3kA8fqwintBBsGuQ6WeNsuCCzXCGFwn+LEO5ROFLyweUqZQ5G0oHSTo?=
 =?us-ascii?Q?MAAHmivTrHQgokEGPrSY2v7V1+d0pJQZ8U7HysHk6J1dJo2/XLfamK0njgly?=
 =?us-ascii?Q?T/qmbJRPXaGMj7fqj6TC3fNaFtH/6mSKdEkjlZqS0K16FLa4a28hMwizSiEL?=
 =?us-ascii?Q?ghndMlzB6AZxlrtwJK7M8LF5WfL1kDD1DXHwRv8i2UO3feFpTVrtLbuAlkKK?=
 =?us-ascii?Q?GtQAZUHiilRuRH7EvnsEZ+CmSD+mBwFSlr84iPdW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a214ff6-cff2-4115-6f64-08dad6d57c8f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:29:23.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIHEpMk2+MRbUY6Wcm/DEspHrxZGKCq5M/ZvehWdNkWnmdGDnMwgaHWaXa+iDl3t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5955
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
the few places that need it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
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
index c8b8a7a03eae7e..b0c83e1fce6eb6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,7 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
 
@@ -689,7 +689,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->sriov_pf_core_dev->vf_token->users--;
 		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
 	}
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH)
 	eeh_dev_release(vdev->pdev);
 #endif
 	vfio_pci_core_disable(vdev);
@@ -710,7 +710,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH)
 	eeh_dev_open(vdev->pdev);
 #endif
 
-- 
2.38.1

