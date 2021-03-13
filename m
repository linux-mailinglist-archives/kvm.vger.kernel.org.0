Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A58339A91
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCMA43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:29 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229968AbhCMA4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCedcAimrAvrHdLtSvCZXSUap9q8+HbZCM2coerKDexokifvQRTAtorjIAGlavzLTHcc6/ClNziujzb8HJeMZRfJ409M4QxWDmSDY6PsykU/bXgVy0p9Cf0xtqyMZ65qplsHzKTW9S33YnDL3c5lRaDZ7lBfxSepBysBzoFPMkpIwgFY/RMxzPx/yTz57VbkTOMgPCoi7Z4KZPzOqKdaHVpFiEpqpvrqNK+G0qfD15sJyfe+RYGzsSyVKxQSEqjm4T5Gm1g4IHl5t9AHBpGHyP4fjG6xIRtgOsO6dEVGSvyBAAAb374ibi8J5yZ3AcF4BMMH10haS9s58Bfo5XK58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFDMldiKKN1KfYi4zZ5BY279M7dvQOOT6wffdMdWF1I=;
 b=Mi/if8TQHcUd7SHctiqGDdtEXEJYbixClIEkn2bbW9ZdXojoJKVX3xYjA5auZIKLxezvyQYovBo1Yf73rp2WDhTcw3ZVhFN8LJ/fAfPsovIz6Gfex/LrrtPsN0xkQJ6FPEJf7kXQuQBfmrwcP9osF2UiJQHcA5QGEtYu5foe2x4KbUKPqvMMemkNQTTM+E+goCp2dFB7BZ8y4pDAsdmasE4F0AEfNbTfnH9t1TTXJBdZUIIT16uqDhHOygYVixCuJGLqyjWi1WweqlOd+Pb1+EKiwuIWMP761GGqu+B+2/ox6O5HUGBT5cOEIX/HSqm9XS1BIlVl9AIrmv/VB+5jGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFDMldiKKN1KfYi4zZ5BY279M7dvQOOT6wffdMdWF1I=;
 b=h6uEpnei2EzVqi3SlWiEu99xptm+0cdYNgZ4d7MJiybO6O3oLyevZcLtmcg8CJrGpuuDqSQb31KMeGwYi975ogufh4VJJJWJcqWSbL46DFCrTO8NpgJr9m5S7GfKZMj4WJUYZdFUlzLkZgr21+HDdPKAj4+IRx0nXnyIyI8DR2oahymjqsM4u+F9OCLr7rEzu+RCxsxYLr6aA/NpGkElvIkgEp556nFKxEB4fBzWT+r1+3hXIFR+5DCr9k2tTMfd/hYh07ErCUHMxKMfg5TvEnSaJQLxk4EhQhjqLW+p9KnFKnM+LLxF0A21Lm1BmL3ZZi+d3FTJSH2VH6jcz2VUeQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:09 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 05/14] vfio/fsl-mc: Re-order vfio_fsl_mc_probe()
Date:   Fri, 12 Mar 2021 20:55:57 -0400
Message-Id: <5-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:208:32e::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0128.namprd03.prod.outlook.com (2603:10b6:208:32e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZa-00EMB1-Uj; Fri, 12 Mar 2021 20:56:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98e2b08a-d270-4171-a5a4-08d8e5bac98d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB294091B0938CEB440873354AC26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFATLS17T+uBwEGeW1hmvLFEMr9Yx1dQgZvuN8FMj4BPV5ftyiscwOiGEdjoeQOqKxl3OS1QbaMKfRYcFoUP3WNTQw2XIQ5SNBGfDJFGiWPn0/rvuphoDVg/4TlwepaLozk6iQHaK70S02QXD5ExzoogjZNbXUpArKq+FH7FhkuxYE/JdMEr4rJnf3T+A/RaeSSS29kupOud+AAdcUg3uigZDRN8GasGv499ZwWhZirF4vxZnpRtv72QUqVsNc/IE0qYUt3p0klD31Gk2/ii2GkLIyq6+bCRdf0wPtHtM/9q9FdAvmizF0HhXMxC9zEnL0d5vgRMCKKcf7mG0KdtY7gzafZ3MRkzDU+PX0jbNPuAd1c4ADcoPUFBWda+0US9kVaMGpe610YZlrngwe/ChSufGauPllxC3VCshGqzdUXKAZWLW4gvqSnoYv6FswimkmVBC/vb7m83Al59Zp5V3MEhyacm9ubC2fuFaUTcPEVvn3cUFnsrP/5oNK/MCeEkrNyRvGx1jbpiJtXD5MZI6TT8e4Ec4d4Rp4W1FukmM0y5OO79/c+yA1FFZDCthQKfY7PWvN8Y+Icd7MyWzT5fNqt/KwG1Ga6Ge9VbqNCHzIWS10yqNMscelzHEaaFwNIc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(7416002)(2616005)(4216001)(169823001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KxrWufcwxeA1NXZB/5J/cIAR4Q4YIYdV304PGNiGIa1cXg2eElcA18pN5jLA?=
 =?us-ascii?Q?zA2awTu+auZtv/MUJxhdenYRza7d2NQh4c8k+ptYUhPtwBhzMhfJ1yGnpILz?=
 =?us-ascii?Q?8KMWQWBv/F1Nq1+41yPg50t3oK4bogwUl6RuXDxedHPrfj5iBsBEZuj/Gyhq?=
 =?us-ascii?Q?CQlSbisLwD78vHCQVyNqZQ7FklewR+k5LiwaFC80i91yViEmFCMOKo8KLXy/?=
 =?us-ascii?Q?DPEMGskHVIEPeYXT14JQzs4iNMeg4pmkg7++N5S7EceajO6mb+TwAj956bOu?=
 =?us-ascii?Q?UBqjMSj9WRo7/2jYmFcGqN6vOYeUfm5iLm/FCOWDScRBjVm/pWA/pRQueZ+a?=
 =?us-ascii?Q?9/xXD/H1kJ1KDyKUyNvOWDsHiLynJmE5HLtPIgKcsOfPn5HVTc+MFdQq5KPJ?=
 =?us-ascii?Q?qTROg1BujEiESTn4HJzFeWMXJMW9rWRyFaWbDNAkeT3tO6YJbmN6w4ogADwJ?=
 =?us-ascii?Q?vXjb2X9vhYXJDiX7x85vl5cpqPpmPkGrPWRbmp7bEMY3qgl7kAXMKl0L6BJh?=
 =?us-ascii?Q?a6LCF+DrTgll8X+j3Bm/W2a2OnlC9vDWgcGlGwntb5+D4CUOR2puQtpFOghM?=
 =?us-ascii?Q?JzMo4erNpX0c6DhyA/INMT2AsXXxWMcyVzryUEYYNQpl5AqLnYW3PfoLpk+B?=
 =?us-ascii?Q?nCKCdQjPurbm2PLROHyeySKeJHEBJ+sBVTfIRpwd5o68z5O/k6pJxaKvLuaG?=
 =?us-ascii?Q?O0qZRQsKGJo7n+f/DUgR5RKI6xM7ik8RtmUiWqltPNX3PXma6weKcRJ08vJr?=
 =?us-ascii?Q?cbE3YGinSXQHE55jvpvz4ZBTVT0beApBFa20LMfnFqdI4u9p0UYGfZ0L3Xzx?=
 =?us-ascii?Q?hXKNMampR3+4mvKFUkVIUVqdejs2YI/qIRBf0au8cQ7BwhbkEptPvAfVt4J+?=
 =?us-ascii?Q?fYncEhRQhaG1gDoxspoXf1geJk/0m35qx/mkvFs2ik+rGDk3zHT42cISOQcQ?=
 =?us-ascii?Q?+AmVyAx+3k87gL/Rsuy1XmofEdcdr3Z9vEfdOGUeGUUqmzzJX9SNyd5b90JH?=
 =?us-ascii?Q?3oZJMmlIS/rYy4QFlojcP89Q4sTEfHnEx87chzjnJBLIxb+stfOY/VQdMJOx?=
 =?us-ascii?Q?g2pILZb2mrM+ueIX6Afhe/C5Pd1FcqvWMCyeySuyXpGGiKh+RuPGm3EyoH07?=
 =?us-ascii?Q?KRa3FOQ8JMnZ6TSZIo7XI0X14s4yDT3po+/c0AkPJg5QE9YXhBkkHxje/EiW?=
 =?us-ascii?Q?RdYxgxJfH2zvXGPx4jh3ZpwXoIbbauvgR8P2XJjxxrPWNtSkRCtmRaXXAJGv?=
 =?us-ascii?Q?V8e4PWGBssYV83Oqgt308bbkUliZeK8j/9wf1Yv1HU1PWgM2M2wKmaAc7Rrb?=
 =?us-ascii?Q?KYgoSTSbUkRRULec5X99gcpnaq72gfSvIOtM4Fx8LMYzgw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e2b08a-d270-4171-a5a4-08d8e5bac98d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:08.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Tu2zir4uaJRDUced0VpC4M/9/K4STcgW3M5mdeHtd1PXcm+a+Kw0qbKN/Kd9+ML
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_add_group_dev() must be called only after all of the private data in
vdev is fully setup and ready, otherwise there could be races with user
space instantiating a device file descriptor and starting to call ops.

For instance vfio_fsl_mc_reflck_attach() sets vdev->reflck and
vfio_fsl_mc_open(), called by fops open, unconditionally derefs it, which
will crash if things get out of order.

This driver started life with the right sequence, but three commits added
stuff after vfio_add_group_dev().

Fixes: 2e0d29561f59 ("vfio/fsl-mc: Add irq infrastructure for fsl-mc devices")
Fixes: f2ba7e8c947b ("vfio/fsl-mc: Added lock support in preparation for interrupt handling")
Fixes: 704f5082d845 ("vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 43 ++++++++++++++++---------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f27e25112c4037..881849723b4dfb 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -582,11 +582,21 @@ static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
 	dprc_cleanup(mc_dev);
 out_nc_unreg:
 	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
-	vdev->nb.notifier_call = NULL;
-
 	return ret;
 }
 
+static void vfio_fsl_uninit_device(struct vfio_fsl_mc_device *vdev)
+{
+	struct fsl_mc_device *mc_dev = vdev->mc_dev;
+
+	if (!is_fsl_mc_bus_dprc(mc_dev))
+		return;
+
+	dprc_remove_devices(mc_dev, NULL, 0);
+	dprc_cleanup(mc_dev);
+	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
+}
+
 static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 {
 	struct iommu_group *group;
@@ -607,29 +617,27 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	}
 
 	vdev->mc_dev = mc_dev;
-
-	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
-	if (ret) {
-		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
-		goto out_group_put;
-	}
+	mutex_init(&vdev->igate);
 
 	ret = vfio_fsl_mc_reflck_attach(vdev);
 	if (ret)
-		goto out_group_dev;
+		goto out_group_put;
 
 	ret = vfio_fsl_mc_init_device(vdev);
 	if (ret)
 		goto out_reflck;
 
-	mutex_init(&vdev->igate);
-
+	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	if (ret) {
+		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
+		goto out_device;
+	}
 	return 0;
 
+out_device:
+	vfio_fsl_uninit_device(vdev);
 out_reflck:
 	vfio_fsl_mc_reflck_put(vdev->reflck);
-out_group_dev:
-	vfio_del_group_dev(dev);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -646,16 +654,9 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 
 	mutex_destroy(&vdev->igate);
 
+	vfio_fsl_uninit_device(vdev);
 	vfio_fsl_mc_reflck_put(vdev->reflck);
 
-	if (is_fsl_mc_bus_dprc(mc_dev)) {
-		dprc_remove_devices(mc_dev, NULL, 0);
-		dprc_cleanup(mc_dev);
-	}
-
-	if (vdev->nb.notifier_call)
-		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
-
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
 
 	return 0;
-- 
2.30.2

