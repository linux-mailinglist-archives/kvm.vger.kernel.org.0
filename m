Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B9D63CC4D
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiK3AKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiK3AK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:10:29 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3943610EC
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 16:10:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw7Bqj8YodSgs+rRtObXYchabvQdQIHcPHYAUSAiH7BkXPZ650bKBoXwr1x+1IFJOI0QVkgbn/cUDeubJtkMvNuLsbeudXssUc35lGEWiBrg+pSpna2RIXv8yINJM+/Xyte3BBAhD9JFSaaCpIhxNkO+nvd8/zFO/8/R2i3l5bLeqG1TRTA9fOUK3OOlVw53sYpibKZtlPpomAJ7IHU8FtFAHNE1v884mh0MFAhejLMr68mtnbzhkYsf1rxEkomjZzeK8PQiAzbr1EYJRMdGuRbgjnLSgwLvkSzLx2/xuv3HO2/bOmjotarFmCu0F8L0N1gEadG+N6Dp05XKdv9XAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAuKs7WuMxQ5r9KAnAiSSSSqB4FCpvhHtYqUIiDdXE4=;
 b=ekLAEwLgUQszoHm6KXLIQnMFU/iHduMv+PK2Iqkbolq2Oqhdkb7+ts3DFyKlwLdrs0I7bqvQxZUMhW+WwPKclVbCY90S2ETvwl2lEFCtp313rzyhV2ynL7kZMHz5yFuVyjjOM8Mrasv1luRG739m1kLJ8y7knCD40YBOLe/xwOrGVW6rPIo5ql0RWdyt+nhspadV/DvOA5dyiFo7q6ALImC0W8503F54nCeob7f9+8PZZt+UJ5dbc+ZYeBClrdWE6XNosxponcg3aNESW5LkQwv0Smxmjh3uHT8g7M5AR7NkZ0occqW4VE0tvyTGY70KXI80R0K3E8nCrH4kKdheVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAuKs7WuMxQ5r9KAnAiSSSSqB4FCpvhHtYqUIiDdXE4=;
 b=CcG2XK61szimSai77j9XBmOgSv5CrGAu+dTIjk/ITvoUNFJcLnAXFbt9wzCC+cwMy+KH+8vDkVy+jDJTgkYwtwye5uLXt3Cuwr68oS1WSilqhubL9vlMQlALFUg43/a7yeMzQ8xMbZLyko1IwdDe3TCYcJ3foP7Z0Sj2Zm2Wa6AnUuKpz1sf2u0+k1L93B8pmQiIbvVygqjjuF2D7K9L4RYtcMspgFJQUXNrFYYUPWDcZlJkgbQjKMc1GeMsH34dEzPmtZVOrkeZeM16U1Owtla+qYBCxY8JEhigsIR1XyGv4BgbCecsUp4AucxYeQtwGhiWzZzOuGLtJ6I5olfZZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:10:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:10:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 4/5] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Date:   Tue, 29 Nov 2022 20:10:21 -0400
Message-Id: <4-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0049.prod.exchangelabs.com (2603:10b6:208:23f::18)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: e472ac7b-fec2-494c-8d7b-08dad267470e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J1l9hjsVWAZGbCEozeSx9Jp1qcTmSKOJxC+PoxS7yn1lmaaJt5Mgmq/vNk0CKAXFiATfqfG8TnAwsL/oMlgxHHa+gK55/uqN2PBUeXvxGvA2/opeq6lfeNL7hCCYh8fmqOv7MJ6BsCwl6jzFJKE82y19BDDrbA861ImX5CanhQbXypxrDZrxvPSBiun/vXSVRrqR+S+3YkD6kFr5opmkD9umE+BDULiyOTV35V4V9/acF633W3x7tQSw/wWilLVE00+VxHb4H8y5LYjdzFwthJkX7GTddhiwsxOiOaZym0I79FINNNyOTyVDAy1GPySfZJfhxbkUi8qmHG5bvvGHroC1cC/59ZyVGxW4IHnGwqjvBnAXsf1DWSEXlLtRE8LKz3pqZ7xJHYCUC+Nr3FAXAUOJ1WPjuW/VERjymiBQH8d3Do5nlxOlgOXAFeC7Qy96zUnMocc/Chb7Jj0pybQgsIs89cFQpe5HmrNgLvoBwj3fQQGveqT6vcVaeJMGGUATqfI91MW9oP+ifQBbp9CaRrZCXbPh8u63PiGa2mTDIPQJTIzVgP3kpVD7Mr3TAw0M+6uoXf+SQaExaYez2WPKaiP6ZLixB0DGHuRrnWK+we0alGEpKBKgbJTMI/3A9gjOdGF+YNwMelX3H345auoYqI/2bfGIW3H/AUmpwfEZQq4uZXFHa67s2HbUDY+kDWKl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(6506007)(110136005)(2616005)(316002)(54906003)(6512007)(478600001)(26005)(6486002)(36756003)(186003)(38100700002)(86362001)(6666004)(83380400001)(66946007)(4326008)(8676002)(5660300002)(66556008)(8936002)(66476007)(41300700001)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OCeTA39xrPzhk5FDL8jFFMDq/wfb7HABH/eR2IFy25cOnDl9106bOqMkm1UX?=
 =?us-ascii?Q?Y882A4Zy08yuXAsyNjJT66cFioT5Bqk0JaYnpmrAFGGnfPriGeFumODoYBr1?=
 =?us-ascii?Q?aPzHbuan//JUg1I/iIEItPulmgZyjl5J+ahOWWWMv197vHCXAVsnjQkxp+rP?=
 =?us-ascii?Q?GoeFShVcyQZci6nORpsMj4/NDK0LpYq+Acpn6P7Y7t+XfVF5+iSjCV1HxfZ1?=
 =?us-ascii?Q?tsVk3BgLhpSd2O6GNu+280ewLNrQZaz8qxUPt3KascDobP2eCNcigDKqkzug?=
 =?us-ascii?Q?AkJhag1zj0FwrmNIDg1agKWrOh3H02OCHWnS/yxv8V0IvZ7sfiK2qJc2hnUD?=
 =?us-ascii?Q?CFwdW2oG7feGxFl/Hi9IyCtCGs5Q4pmHmT9M/jR1cUzuQiq2ql1ngS2mTb+V?=
 =?us-ascii?Q?7rq4yTyBo2RHhOLgkvfN5uK7gVVFf5TUTcTqExgWc4ncaJkIrGkoKv4kk/JA?=
 =?us-ascii?Q?XHQn7fNlrpUmId7DME46z3xA4WneY1RiHggI8o44E2nBo2ZxoWhDoylbH0y/?=
 =?us-ascii?Q?shWoFdLoawKqgva0Z6g72bfdgkLA7xy/abt8Gm//Crza4sT1Zj15Mi/OuKcU?=
 =?us-ascii?Q?ZetYMxos1Aayn9AEha8AOIMCJ1vDad7pWEZG/WcavLdiuuI4AQLi+uG8OhZp?=
 =?us-ascii?Q?0tO6ELa6NbRB1KxNVFfbOws1lDYKmA4qQaIzAk+BrTlanDcvo1j26TI5PKZt?=
 =?us-ascii?Q?340+07uAGiawAxyq3a8fqA3We5aYne+4QnANIsttcR7Sns0rCI+ZHbNzJjeZ?=
 =?us-ascii?Q?s/Pad4OPbnVwAhfkFW/1RSjgtOhHG1HQWbwxHc2Yj7dcVFXtbMepoN49aycw?=
 =?us-ascii?Q?5YBvBOSxN7pL/P95hdV/vzXa3WQI+Zp9OeFi/iGpcFXhiEl4XCIuIST7bFcU?=
 =?us-ascii?Q?ued1h/Y5iO42rP/0JpQZfSDtE+8TKGGnxVOrOQgAOl11UVKd3BwrdXtCbnLA?=
 =?us-ascii?Q?bqMbJ+TVUe7HNuseoSCmCipnxChxpqmtETBUvTewhActXc3YMPPdw6nkViue?=
 =?us-ascii?Q?eS0JaIzzzWPadQzbGeXFn8TQiM5wSoXR8BTNaBlEOlZN76JycsHjOAfwVet6?=
 =?us-ascii?Q?OR1WJa/yym85e7YArcpolEnjOlE82OdrAais9NHRG1MCJa+UUPkZuzYNa7/A?=
 =?us-ascii?Q?6VD/KU/NENQvUud0mT4NmJpT+EQRUeBFOdL0wCkJNbGzeYDDEWFj1K54iQoz?=
 =?us-ascii?Q?Y1/PGfDcCCwZXOlcIVRonzJNehCRzk9p9bI9ygadIaJc1OgMExMzesosUvYG?=
 =?us-ascii?Q?8r4BRPVf8ctRAC2XH1r/ot3r1zUPLp2M6Fvvc/YbWd1BGlhK0B88qky0VlQ7?=
 =?us-ascii?Q?tHiCDp1oXY/xQtXG0KIgIrZXVIkqRCHolWZE/KAXrSrP51SDPZNOQgQufHu2?=
 =?us-ascii?Q?E2Wubh+lpv3ZvW78FEM9b3MVY9KiSbYMCuHZdk3jHyTK8MgqfO5nIOcxSh0p?=
 =?us-ascii?Q?az9vFE3g62hLm737/RzoLCRMCQPo6R7PP3cE2lBkpETGCM5nw5jcc1twpMiI?=
 =?us-ascii?Q?SJbKwkJNQuZeGj3/wAHi2d4vhFwELCfI7HaZ5Boav6Il35CfJZYY0jXcp8dl?=
 =?us-ascii?Q?SU4iJJAN0ejocTf9TEM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e472ac7b-fec2-494c-8d7b-08dad267470e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:10:24.3040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dGeRRZlNi2xFh0RcAE/mixlgxcpmvKQCBpPh090FHmKwEVBdVuU+czhL7Ng/ELR
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

We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
the few places that needs it.

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

