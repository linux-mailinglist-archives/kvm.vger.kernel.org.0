Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B3562CC3C
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiKPVHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbiKPVGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910D968285
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/HXJbmIXcrIkaLo2Ke2xwoI58JyU3q3zMZ1p/Hcna6HDnV8ke3fJzrewaXZVMqgBw2Gq8QpgCVUXFLUD5Rwfz+2WGi5hSZ8ARVEBlg2lkcLIdXVy1OyKiftqYW1zq+VabsUIot/PuWyu71IYGdNOOwB9l0E3fGgE7dB+FgdUp2y7O8mYGfkO9nVlnBPFrI3nfEFZpPTdFMZiBgsXRdDYSR2m6krANmfLJc7Dv9mQ/NbFsr7CNHj6GEq13vtqN0u8OsgYowhkSb816YvFlbStS338jr636A1xSed+ql/Sc24xj5Co9ynwGP3ttUcQ0ZkzC8ZmxFyxY/H8w2dv00S+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkTxMEZWF2Hz/NOkvHt0Nsf9Qb7h9Sv0fsfv/Eitz/0=;
 b=ZgyD5rfYkdaA4z2EIuTdEtsiFeWJjOAWn3v+NbaLAnstu4O69PThz/KroYy63Qf0Mcjp2Y/tkdkzCo0ZdXVgLHaImLlelxQzqaAi2lToORM5R2SvyuHrVBhQxy7zXc4YCWHYS1yzLIMysVbCEtVpmUUN7RF2M/lzaeUi+3vRylD2AZBzxo2vXctji7s8Qtc/gUmqr+sGG/j0Zp3XenMNLBe0mZxhyZnBXTxrsM82sbGN8dZzPpKZMRiTjq7gbSXCvms7IX4O0Y7MgAj6cpUnAlaMpnv644/dUxuBcJUwp3OD6jdksJqbvvwmyikJjILhzhuoSlsA07KvSveS4xP4Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkTxMEZWF2Hz/NOkvHt0Nsf9Qb7h9Sv0fsfv/Eitz/0=;
 b=Ds4QExNhJX4IylagxY6mQQOaDaY/22d5T0KFA7gTpZwtw6dfSM1ZNU7gyTABA64qjL2OP+24o9OSkiD7oTPiNBxFuljjmfpmKpRDpCHd1T2CgZ77MvI/ugQ8lZOxGNMYonXbqohsg20qzybwUwbmsBudwidBMcRlje/kvI1EG/+ZWqCUEymntIEZArmDQNVO+ZIaTD+yFUF10/oepwGYoDV0xjEjmjo/WlSc990LL/ZO9208Q8XiBON96XZBS+rIViBqPCiaYAK9VKS2WZT91J0Gweqqn+vO06ipsx0mfVWMjSDF/svfzeyjHSP+I6NLaubPpsv5Uc9A4k+WiuuNmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v3 09/11] vfio: Move container related MODULE_ALIAS statements into container.c
Date:   Wed, 16 Nov 2022 17:05:34 -0400
Message-Id: <9-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0022.namprd19.prod.outlook.com
 (2603:10b6:208:178::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: b610b593-fefa-4ed9-8359-08dac8164fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0xD2qVwMGINwAHz50eVxEmifZxs0T6cD51o7+t3SNrb7ja91TgtUJAQ7k8ybevnuSnR+5RILp1H09RamWIw8lyCT2f0KQlNYujOXWkDw4QQnAwcZ4C8AjpISZVbhpkaaL739VYY7qVWXvfbhgOj/XwoHf45Wi0ZIkvvVTAjPIW6C+4yHgqWmYS5Y3k2XIk7h6nCC98xBlXU3z2rTEjyEXqpRS6aQCRcZFxDDDc/7u/0NTOy1VQ2uc4cK+dgZ+QgFcn/LFcDAIChxMyM+6ccYtIJ/lJ9kDMY9acmDOkCr2N3mkbBvfFgGGvWtXgC0aZELkDyxNd/FETHDhvnAzvL7mlNjLL+k1RvcC2uNUrLCXZguoJidN+TLpNoMeklPDd2yLJd+Z9l5Fp4u3kWPKOgXyz7wT/OttRUKtZXSsn4maj1lIsU/Pvmz6p8NS4jy5ECohAWpKZqpF0q8Saqjt/qSnX1Z8hakf+WxYLin4+afPFuRfuUnv+zJlqUw3ZkCb1nI3d/E0uYpFtUet7vcis8iNJ+vMFkTlU/eHieCdf5vBMcbeyI99DiN9mz5eaY4/YQS4sZTomoLg38Hg724B8QIQERELv60ntr113jk4GViCNXlUgr9FOHmLhWh01u70nMKi1pjxH8iSTaVnrAV421O3xn9Z8JSPQSrn02kEh53bWDmzBG4jrPtpdZ03SmqctJ+HnWy/NB6UNCNIdPpkaRbUyE9vZL437TK7zmOv/otg9MDLYfWcHcr1oLk4ALzE+GQ3G5hwGb/mRksOLawGsyvqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DOnajwEsYF007Wtp6N3i2wGHBeMuozEXna6wyGZdIxPz79MzR4Fcn0bAqJDk?=
 =?us-ascii?Q?d0+OJ5we55v9BPCYkBwf3eBMigbzSmajiTnpIaVqQPVwHSbGI1iDbNbbEThq?=
 =?us-ascii?Q?BaGGp/oUxgH83BK2BeDmv+bd2/7F2swKg0AKAIQsH2kwmb+CR6ZMVkJfQ2Zy?=
 =?us-ascii?Q?n34ipB1ORNc+43aGbeCkrgXWfSiJtdVEx/r2gXOMsKaMPGswyz/P0io6lF0b?=
 =?us-ascii?Q?bDfxCtqtZZ8dgM9AfoCoGvtctJAHJiBHhnadzHxUN9GlFy72qI2231F9+/Xo?=
 =?us-ascii?Q?13Q01rlt3gWXzIsEIR3hd/N3Oe+L1Qj0Rlbge03XxYK1eMe4dr2bY4JlmqTj?=
 =?us-ascii?Q?lRxtN+o3FkMCNvJQ078VYLqwFTQ5SA9rIxEo0/0FtOo3VGqz0JAKr9Ov7c+P?=
 =?us-ascii?Q?7HHlWnI4Cf0P+Pt5iJteGSmKSSP1vXD8u9aQZZ55/U6a/NELqDiFxWkGQws8?=
 =?us-ascii?Q?0LYULF3PWNXC8ZTjdOXcdLbpGpyWhYYQ9unOd8wsyZDaWnzvRmzs2sr71wVZ?=
 =?us-ascii?Q?A8S44RLyQ134PUgrD7Zlt1+qOcUKtLS1lwn7oQG0bks7AoBl9n1/1Sf3GheP?=
 =?us-ascii?Q?85bE9zn5X24STQSLBQqJbU67lOtVe3Biifw1UPRaKURTg/EpPj/DIXCZkP0V?=
 =?us-ascii?Q?F2rDcMJjPBZpGb8C8RYWcSvDJYVYqtMOnZHNMHvnb+E8ReXWUkj/8dh9hB4q?=
 =?us-ascii?Q?syW2Yipfku5SDYdL+t6yeD6UtFSIk/zlCMY1a4SM8o1XlyK6kLkbTlnFc3/6?=
 =?us-ascii?Q?0BB2y3m4Ibr8sIse0eEJETt09botfTf+R4FsXsI8BjS4TLomdRZCufJMMuyW?=
 =?us-ascii?Q?cdmSHK65pwKK2u124HJPGwVIima48X+VybWBgYr+Lw9ddjBFX4NNtob3dLmy?=
 =?us-ascii?Q?pPYUxwlf7bMTiS8ypEpLkAT71FV5jB0RYjs8YLB2YyWEYGbb+zzgwr/6gJqZ?=
 =?us-ascii?Q?Z6X5vu1izk5gcHnbRqnGZud0+g7LEynNxTanrczj/TrT2spD//5MgykByjLT?=
 =?us-ascii?Q?8SuO8xMJzHwgKs0sLs4+M5M/fDTrryOK1SI7uNa2Jx4z69FP1OnjJHxPwr4u?=
 =?us-ascii?Q?2rs0kYOnJgH4kYOrLFJsDiAb3ySLfJi8zic4/67XSQPxqCmaK2NoHywQC7nt?=
 =?us-ascii?Q?k6t5d+NKZCSJcroL8LW3QlskyNKzpIUZ7H6KHjAMFf7unnL4k+pgb6vmjNdl?=
 =?us-ascii?Q?wnT8u9QSktJ9R43kIiktx4GeQ/Wop0kcwr2d/kux9E0FKwRX19QQc+Ai5lVg?=
 =?us-ascii?Q?2Kth2NO529VnURZm4lrv+IDDPQaKdGJWJ6/NrP9tCzdkmJcxCSdoT5U8TpyY?=
 =?us-ascii?Q?bD9uL0gDs4GzVti93A9O0JPOZ5RNtb3rnqapp3UeV91CyZFFniceiAjsHCWz?=
 =?us-ascii?Q?Tmr4Kta9yjLKM3ewc5jGyj+RFdWjXg/WOvaWgJpbSFVK8CEn7U3aln4Ewysn?=
 =?us-ascii?Q?iyY7WFAYEgPcpXSJWxW//cL4bAjTnlMAB0f/i8JK+Axd6w4H9z+6rSKiz3bG?=
 =?us-ascii?Q?OcEYzv7qSR2vIVCdwhSCQAJS/RA/tqjq5eU2EHJvAT+R450TSBoaYtyzeEPo?=
 =?us-ascii?Q?tfsi0ZpfWG+uvi1MogU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b610b593-fefa-4ed9-8359-08dac8164fe3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.3211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZx08Bz/3xlfFmK54073wAl+lQ1higftIKiLFFa9M3T2qqm9vQjiz7u7FIL9NIsQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The miscdev is in container.c, so should these related MODULE_ALIAS
statements. This is necessary for the next patch to be able to fully
disable /dev/vfio/vfio.

Fixes: cdc71fe4ecbf ("vfio: Move container code into drivers/vfio/container.c")
Reported-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c | 3 +++
 drivers/vfio/vfio_main.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 7f3961fd4b5aac..6b362d97d68220 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -608,3 +608,6 @@ void vfio_container_cleanup(void)
 	misc_deregister(&vfio_dev);
 	mutex_destroy(&vfio.iommu_drivers_lock);
 }
+
+MODULE_ALIAS_MISCDEV(VFIO_MINOR);
+MODULE_ALIAS("devname:vfio/vfio");
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6195d7ad5b5479..f3c48b8c45627d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -2074,6 +2074,4 @@ MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_ALIAS_MISCDEV(VFIO_MINOR);
-MODULE_ALIAS("devname:vfio/vfio");
 MODULE_SOFTDEP("post: vfio_iommu_type1 vfio_iommu_spapr_tce");
-- 
2.38.1

