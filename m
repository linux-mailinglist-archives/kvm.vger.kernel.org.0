Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3A934D7B2
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 21:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhC2TAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 15:00:32 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:64065
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230213AbhC2TAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 15:00:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDdCdOS0hyIWce3n0qtOCpgBnETSTuPiN+2D6q+LOtZDNgp0G8aP9MvOJCN+1i5aykjQAYMQjFdFIvE9yaP6w8bseBWTV9aro7uqMgmoetko5GpqfALFKXJm3h9RwzNYm/Z+vnzmZo9f9rp0b9YGBgrfr7D07ppgJzcD+4fpFzEMmYzNjDna823iPOViWFTUjQjHzqAibCjoMAz1fIHY9eMF1BLWPJf/kwbz+G9qtb5SquVq9lFh/EfNJVDnEtibx2wocakoaPCRhKbptF9FJcbhqXk2G5jOvGFXF54KA0QPxQG+0qW5w1DAy3sT/fntKWTAEI0dQvgKTVvZ54fPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2n4EqVM+o4w5sAzXWAFiZ9Qolguc7yofag5xD+fTdU=;
 b=oTi/YvAqplYN+f+Z3RKhSCQr1N4EmbGEo+VTZe/jVBIydCLRU32S4jp7qaJoWoYRDO/bljloSL6X0P+l7rwyfxDL6tEoEf3gUcHykbgnfBdCS1havAmu+lBCzeGY21xSojENPugBIKRmqeE/LRpspYlV5LCVAhvY1sYVncT6bZC94AftAaa3LrC9Ib16WyxeE7kxqpKeUOKMzazV/Frz6MoxS6Ja7mcteCQLBE493Ki8q0/FvPUQ15pqWOIxZI4Ns/9Vo0oJnS40KE4YQKxOQuFZ+FQG3qcsshXv+XD+6x02ZERp6v1GRdnmeYIoFMCZUsFvsrp7SlDLRmEHNdqtZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2n4EqVM+o4w5sAzXWAFiZ9Qolguc7yofag5xD+fTdU=;
 b=h6LsqN6sFXUDGC32rALrkK6nZzeMR/06c4V2v6jCz8Y1JhZoahh2zwFrnqRVsRy7d+1D8W89AKwC0AaoCAruybeKT+amBgkUG0ExGA1ErdNdqp346jdTAk9bFkaJkHvlqDp+a9m5ov1bo11Kc++8A6ZViDRRDVCgGvpVIuXTQ8cwJVSEVhIxRyulB8C8iPVnzsfcZhpqSe9Z6hOwVaTLyOPwyghZpuMbzdRiQC1foG6hc4E2mu2fPKZs7cI7BT1jd0pvI6YdagxWLTpVbHV/Lqz6/CeZRZZQFCTuprCR/Ti6OYs8rjqNez6FHL0VZmZErcTyQ/+lXXITTroGMbTSOg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2859.namprd12.prod.outlook.com (2603:10b6:5:15d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Mon, 29 Mar
 2021 19:00:18 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 19:00:18 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>
Subject: [PATCH rc vfio] vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends
Date:   Mon, 29 Mar 2021 16:00:16 -0300
Message-Id: <0-v1-83dba9768fc3+419-vfio_nvlink2_kconfig_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR15CA0027.namprd15.prod.outlook.com
 (2603:10b6:610:51::37) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR15CA0027.namprd15.prod.outlook.com (2603:10b6:610:51::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 19:00:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lQx7Y-005byQ-CU; Mon, 29 Mar 2021 16:00:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a5eb1a3-3d85-4eb3-8bd7-08d8f2e4e4b4
X-MS-TrafficTypeDiagnostic: DM6PR12MB2859:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2859D4F55D0D7E3103FB431FC27E9@DM6PR12MB2859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRvJMr6V9v2AFh2iMcJND+FCeEfFCTS/J4PSQTbon4yYrY9zV2HyvcpX1XzB6OzThBEbwjrjYYBdIkn0quD2m2I0Cc6jUjRKFLnjOl+RF1XpbotTh4lqgWBJWsdHs1uuVa+ybA/Zu3WgdXvv9XGSky9UMHTHm5vET6dtWPj/yBV/XN0cibP15QJZ0RhvSmMUzHz9b841LrD70WuBWMWqCAo8XY7Qyozk6liVivLxKBpeS+LFaGwyPzutARWAAqnNgUH1X6rdT/NrVkVryl6DzFbAPlLWF4cXknjRvbJF1u0aGnVe8cAV6zOwjV3//T0XJVsC3aOJcqYoF34eyosbrAIo8nalrMjLNHVy+RxOGpjhTW3/wZ282y0iHAjWMm5Zjh1tRbnP5rnsG6QRGOod6r9P45m//zXypUf8FBpLRrPGVhjYF/4xgWpMFCzH1IV/FQFHmjXMmKyFIoxNUUmm303meutjAYRdYxiYY1PwNr4l5G8VXJ774ZTMwdD7aW6tofgTCVYvDVu4V7MLkBIMmhJB6dcJySu83ESQ1G0gpLr1ojgXeFOKqZoP+tuApdHjaB+l2XbkletJyML+bUgZxGOXUbMcC0pGTNzm8/jJWn6mQnQVbRNfatCO4I1WTkT11EWjgMNf3whA1ycewOzA/ANc+CcuM3dM8H2QBAz07gr/i1JUiPtndTlIXP6RxvWR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(26005)(4326008)(66476007)(186003)(9746002)(5660300002)(426003)(110136005)(9786002)(8676002)(38100700001)(2616005)(66556008)(83380400001)(86362001)(8936002)(36756003)(2906002)(66946007)(316002)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?naJfLXEDOrca0MZw4kMvlQKI1BL3QW4zaLeZqYFsKGxVIeSHfN1z4/iZI7mW?=
 =?us-ascii?Q?X0QrJUXbwkcgN5ASgmeqRTn0/mx8iDDhfge3SjOahOU6WnwOLQ9iRTehAAiZ?=
 =?us-ascii?Q?FXcs7RhzM1b+M3LtSf1dGk+9n008XsS6jDyiMrx+Q1/ZuHruhJZZrNwjasxd?=
 =?us-ascii?Q?r9xai/DxFXLgxhFwArQpdRH2rM6PHT+jvuQjWTJDBnisCPAMFJUAmaUSeUjE?=
 =?us-ascii?Q?8JJQDHi+X1AyLqVMQSbke6fV7GFpfRvjtCXL2w9IUhh482F0EOIdFSFOneBy?=
 =?us-ascii?Q?zQAbzTkelUagFrL+2r9ifo2yXbZNINinhM7xja7WjT0hNCLxqEOx/NFuDHOf?=
 =?us-ascii?Q?6QEZtGVIi2rGeXt4gnuPExZ+vKBYEViA20g/FGh8eiGoTmLuiqXjfWHZFcQX?=
 =?us-ascii?Q?2GxQciEHF5EdxfDoTzp3CBquwD+dU4Sprv+4gM8rlmu0/TAp0PuVVIf4RJ/W?=
 =?us-ascii?Q?aJfrs2sfUzQ2odeO1eWIRMAqyvJvNVT0FYjiNlyqLLzkoKmjdLAS5TNGiYK/?=
 =?us-ascii?Q?jpTbkqsjCkJDkgBk6iZijThPQWtGp3C2X3Kc1cY1Jlmd5aeicH6bMpcDTR1J?=
 =?us-ascii?Q?BF9vmGqyb246tvOyC1yD3zM7GgLOLw7mOAcvge8fYoI5PWlk1Nh884dqCLRr?=
 =?us-ascii?Q?ssk+Mm3nzK/bG0cugAig82+f2AqDYMDrkgtX2MVarPdx80xGQLh6t8tv5Y69?=
 =?us-ascii?Q?U1Xs5nt8UtrlcaP1GWMi5oDgbPKWMrX7Aqy9tkToevE3ba8linz5exQAeFiV?=
 =?us-ascii?Q?WEMIrj8cHZXuy8UCCEkkH5QpDYA4LnHO4GPYgds80g2coikGWNwUGOd5OS0t?=
 =?us-ascii?Q?hvP15OSLOV4YXRI07npXl3v6jutxijU7InVKuFzsy6SxsD8nE/gbnnYhzxTw?=
 =?us-ascii?Q?RoC0lRYZRHY5ExLYMNxGnXvbiqys7Rt1Z/1z5Cpj/NCmU/bW2y/RnkREZ4G5?=
 =?us-ascii?Q?Gfbp7sms7CleEW+YkD4QM1qunnrQOsNwoiSZKMH1bEeVOcfxoUvtqJ2gHiRC?=
 =?us-ascii?Q?uumtZ5ICim8OvsriMIawFyonwO7WSez7Rq8I0sXyyD3wgoT5DEua8UNJBr6d?=
 =?us-ascii?Q?OLl8+Drl0RJUheOU+Iq/s1cLWaYdW+KTAClGld+yE4uZSOpU2IhwSth3CSqP?=
 =?us-ascii?Q?KPseqKJUja9JZot3rEoNUw/DlaYs24zqXkHFkGW+4QK0bWye7qg4wmQYvVU2?=
 =?us-ascii?Q?szgzWCLaJsZZBSHxRt5mpsmocvrw3WTq8QFU89bNRl3+ExKe5FXCPR1ecI4z?=
 =?us-ascii?Q?43uif3wMT1B9LGKmaxv7IxUsRsPSampftS5WFnZiLP+pEylbu3bup0fMFLCE?=
 =?us-ascii?Q?e7+iSR7D4fL74zUHl7eXWYnx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5eb1a3-3d85-4eb3-8bd7-08d8f2e4e4b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 19:00:17.9726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQWmT7dTA5QD3OD/eZ6GfxiHygQLpdcgyLGhDXi7r8Ewuo+a82iIZfZaATmHJjgJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2859
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compiling the nvlink stuff relies on the SPAPR_TCE_IOMMU otherwise there
are compile errors:

 drivers/vfio/pci/vfio_pci_nvlink2.c:101:10: error: implicit declaration of function 'mm_iommu_put' [-Werror,-Wimplicit-function-declaration]
                            ret = mm_iommu_put(data->mm, data->mem);

As PPC only defines these functions when the config is set.

Previously this wasn't a problem by chance as SPAPR_TCE_IOMMU was the only
IOMMU that could have satisfied IOMMU_API on POWERNV.

Fixes: 179209fa1270 ("vfio: IOMMU_API should be selected")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Example .config builds OK after this.

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index ac3c1dd3edeff1..4abddbebd4b236 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -42,6 +42,6 @@ config VFIO_PCI_IGD
 
 config VFIO_PCI_NVLINK2
 	def_bool y
-	depends on VFIO_PCI && PPC_POWERNV
+	depends on VFIO_PCI && PPC_POWERNV && SPAPR_TCE_IOMMU
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
-- 
2.31.0

