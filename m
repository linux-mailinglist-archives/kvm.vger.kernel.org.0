Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876EC62CC42
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiKPVHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiKPVGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:49 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2B76A742
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+SSgb2MI6OxD4X87xyy5vb5X+bHaO+4OdRjK/ZoLpZHxXfi8grhzucmziIAi3wakaJBImN29mUZhhgwbEoJttd/UVrUx8uyW71WbioAgBQzbWGchnarkr8yYKsluqOAxEAgTehcLzCyg2/wtqiyfgwl5PnEVNoxh7pHa8dQcZOZSGGIS9VafTrcVZD0ukVjTSpR5bUwBSKKi98bHokNvdpyRMwY04mw+L0UakyZUIDih/kR/8zDHkpQajHHeqmYsp3XaeJsPG4SdesxJEWitJ8mSFB4q11rcJUHBjhZetHs6wu8luWVcfFpWZ5pVoNVLSkfJXxz+oAV+xQtqwlFRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6o+CnCyJp98qOc57tj1WKsWwpgAWvJ5o4Yjl00Hy/o=;
 b=WgWQzZoYp9s1ORU9V1GM9cx/OQr61a9Lp4GWVTKrqOEQQ430w7traC2q+ZtLKz2ZFXUgy+KE+vnXy4OmAiEV77LHKRcpUrIEsUucaWa/dPxy+QB4cCvnntDJr/31dSyj/TYh/W4lzbgiILExX2ykidQcPAwbKgC5YpNbshDi9bC8h7csE7DlDEWOCzW6hAQDeEt4fbppgdnN7Pe3NSNZ9v5lYEdjlPCUcwQnOTG2DG8v8f4o80AD05zP5lrdfVr2chX8ehxhr8AE0r01bKxHnHeAl9JjAiKE3t6SD/Lt1wGleoOEhOviBA0dQ3xZdZqlcjgkgQH7eFLNdMq1OPA4Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6o+CnCyJp98qOc57tj1WKsWwpgAWvJ5o4Yjl00Hy/o=;
 b=tdNh39ZzEvXwTzzZTIAszxbFqAVSObH//Mr42ZhAxFDKpvqJda2ICt12AcUGNTWXIy+XmytjsHYDkX1shZ25D7oFlxvryO76NFnXvzyPeKCXxou55rllL8CvBPrGLllVMoxm/n+QwMGW46HtYBIDUMjpSbfaaV+0A8zIri8k92QnGOHSd8MiXGf2EbHdu+35JRHx44gZbizF0VCf5UZ4+5ZUcspnkeE6eBo0u3PpTC+EHbi53eMnCldOkfq6IoBcMP65B+htGdb3Gu8EevMXV7ASlE6OiXqR1DUH+mUvgf/kadu2A6/ExoLWwzbCtIyBHgs7AlkNGVRBd9quRKEnKw==
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
Subject: [PATCH v3 11/11] iommufd: Allow iommufd to supply /dev/vfio/vfio
Date:   Wed, 16 Nov 2022 17:05:36 -0400
Message-Id: <11-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0015.namprd20.prod.outlook.com
 (2603:10b6:208:e8::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef02632-d489-42a1-6e8c-08dac8164fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fulbDuHTnLPPdMDXLQyVjHnA6FgZwdIjn91E+66ujVpTXK4yCvqPgTza77QHh8JcXMO4AEj0qs3N4pvAvQltwTpiUoni56R8T/e8qGUKaCuNldOUrTM2sCJgHKzmf6NQz12+k3WtXXazO8JkVmxqAEXvy/cOOcieOz/Bn8zjxYFznCfGParDG1yLOVpnusHsvyf/Jp9GSScWJ8p+/WFpdirRZiKDTm6uDbIMGkSrXJyBWjBQKxiqkZHhObz6zlcF2BXSBumyx+8O2G8MmpD/0Ishx32NcU47oBqjRT/F3qWHQfAWhpodEdZ38OzaQ5eeojbYVnuJ6z4eEbDK1BdjDOARkQVgV1/EztZZAIvipN0xwmdEcq97/KcuCgPp0Xm35tSHr5uBnin9d3+CFGi5sMWmOrB8jKkDkZIeZlzFAFf0G63c0I06y5hs/RLIuMFnMvtnh5Yc1KFheMxRXy09/Eh/5mvkhpPetWNpEp+cMlXSyvBLAW+Sow1ATKQaRISlsJfy9ejqRF7+bVP8M2+i07Dqs2/kZKMIXrX0eaG4M8PZu+SMqKJJYdVrTPVg2+Da5WM9y0Eo4LlJ7Zu6H6vaKexMsxqho6ATjtRJ/t3B0nsLp1HqNshgiRYJbastnDfyLh/RAbFPAvZ18sRPLDPLyhNmo1zi1ML+QqtKjPfI+wEOxeNwiqnthKedwmbGEwnv/YqqXVeFwCy7Mvitr8F1md00TRtlMNDOi2iJijSxs3/aVpVNk5soS2z19LA+Yjqo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OjQWzDQSD5lUtG+VJJW+ZgBfjc4ugKiDGDD2gjH3KZNfwPTFuKIG//NGCiqI?=
 =?us-ascii?Q?bnXqnUd3T6QHXAzZj0aY8D1ZspndzZ8qhWdEJkphVocsxScR34QYuUb6wtAz?=
 =?us-ascii?Q?xXbPR6PYs/a7QkiVYzae91tup3HR5mWcYaqzkRBKMqPgmwQnZ0NL9curo0ws?=
 =?us-ascii?Q?HJgvB5i7OQPC4OyvKtBfdZoiH0XH4Dz1HhhpKpI5jYlt9XecsdgHhh2Bz9e/?=
 =?us-ascii?Q?RmMnlZfGD4cbIJ0heUJUSraigLCxRWcJ2UDUSCmLyWnykJ7x4cJuovM483EA?=
 =?us-ascii?Q?wNo/TcS0jPaSlHk+sPkTL/rATllXVW2UJVY5/l3kiapXxdQIRskAJ8KvFPTy?=
 =?us-ascii?Q?ZPNVVsQ5Yi/9w4gxVQ+b6NRr/9HpkRFftn18akZ/d2rZB24yDhRlaNubxiLB?=
 =?us-ascii?Q?+7ByyhtzZT56g4whHbVAUaVzPwvtz0LPi3tBRbv/rGuw5f3acWHAosLlRoMP?=
 =?us-ascii?Q?hqM1JLec2VqtzMHps6oAcjshZeAeHuxqtsf0NOCiLrmrtOfzcwR/nmkwi8JN?=
 =?us-ascii?Q?xgqPsXwbZof8KU2NZTzYuZdGTaMAX89k+GgagasYd8cUGHLnpIioVH+LPPZi?=
 =?us-ascii?Q?7LZIrzAVesMjBIsJpeNg/j4+/eQnb5H4sp2yQvJUoB7WJJzRZVLwaTjIo4oU?=
 =?us-ascii?Q?DkOav9my41UN+yZx3hYxAXgCUeRcmqiIjxMOHWjn+TN7PNUSa8wcgQXm+df+?=
 =?us-ascii?Q?yComwq20Ww7BdGpKlxSnOJbfgrGY//zNXM/4gnyGyqnn+CYir2mdNbAQzPmF?=
 =?us-ascii?Q?lzpZu96eq5UmuIEgio0pkWbu/xoPSdmKGiYzCuZAhWK3FLa+1H2pshxePDIR?=
 =?us-ascii?Q?Q33uQMs/I+O7/M3IlyanGB2f6EEGWBd4NMHEbXQxQO4ww3Z1EI+nskkqwlzr?=
 =?us-ascii?Q?puSGVI0vBZyzPy1IhuthRxlhXkXvU05/FI6jm6jmeiJti9YJLxyFvGHIRzT2?=
 =?us-ascii?Q?2SbhCUwCmE35DHey6EzLtsU3ahMfX6cz+1XsZfZZV2h944djekBOhgwKpDgT?=
 =?us-ascii?Q?/wLQ+zSkWNpAU4UTtoBJrTfCGexlKBHdm97gVx5JfkkNpRhYInaJNtiDKcz2?=
 =?us-ascii?Q?Ieig48F/Cc+A8AglPIFTy2/kMKzPIHTj+C2J0fKTEp/p5xFHDclonpVpKbGB?=
 =?us-ascii?Q?4f0jAeS57pSAhWOdxxU46i93XoDlAOAC5qivVj5XHQW53M696Ph3xgXLqZA+?=
 =?us-ascii?Q?GXAJuE1927XOhKCodweImhlbTTbKHs+1/EolFe7ngr/MCQDYfSp3E/nNi3Dc?=
 =?us-ascii?Q?DoykQX1QfCQmNQWFig5ELtrgawgTJO3vnDblCtMB07bJSBrkIdWm2LHW39ni?=
 =?us-ascii?Q?pR9/EXL4TTTUilyo+g/ralOWl9niWgJVqnxReHOFtm/n62skL/EZHeXhIapQ?=
 =?us-ascii?Q?lThhNMkOA3Ymi8UjqilnHz9EBisKRyRKbfBeiEia9X6PTR9mz+lNsqGtBTtp?=
 =?us-ascii?Q?l51pNE3XgrM/VzaSSw0OqPAQRYcyml6qCGYJyosZ9pI7COv7BvWG9FiJ10h3?=
 =?us-ascii?Q?WPfagR/mJeCmkmf19ItZbejo6dL63kqLqGlRUVvBcAq9nmW+r8Yvt9W6nuh9?=
 =?us-ascii?Q?159cPV3FHXY4lXnpINI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef02632-d489-42a1-6e8c-08dac8164fef
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.3835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ScedFBieUdAc1GrNKS9USWhdxyVzw+0vBifeA/+rSTGQVOFrUyEhtjB1jk4UgR6
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

If the VFIO container is compiled out, give a kconfig option for iommufd
to provide the miscdev node with the same name and permissions as vfio
uses.

The compatibility node supports the same ioctls as VFIO and automatically
enables the VFIO compatible pinned page accounting mode.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Kconfig | 12 ++++++++++++
 drivers/iommu/iommufd/main.c  | 36 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 399a2edeaef6de..f387f803dc6f7f 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -12,6 +12,18 @@ config IOMMUFD
 	  If you don't know what to do here, say N.
 
 if IOMMUFD
+config IOMMUFD_VFIO_CONTAINER
+	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
+	depends on VFIO && !VFIO_CONTAINER
+	default VFIO && !VFIO_CONTAINER
+	help
+	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
+	  IOMMUFD providing compatibility emulation to give the same ioctls.
+	  It provides an option to build a kernel with legacy VFIO components
+	  removed.
+
+	  Unless testing IOMMUFD say N here.
+
 config IOMMUFD_TEST
 	bool "IOMMU Userspace API Test support"
 	depends on RUNTIME_TESTING_MENU
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index ab3fa05f38505d..1eeb326f74f005 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -18,6 +18,7 @@
 #include <uapi/linux/iommufd.h>
 #include <linux/iommufd.h>
 
+#include "io_pagetable.h"
 #include "iommufd_private.h"
 #include "iommufd_test.h"
 
@@ -25,6 +26,7 @@ struct iommufd_object_ops {
 	void (*destroy)(struct iommufd_object *obj);
 };
 static const struct iommufd_object_ops iommufd_object_ops[];
+static struct miscdevice vfio_misc_dev;
 
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 					     size_t size,
@@ -170,6 +172,16 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
 	if (!ictx)
 		return -ENOMEM;
 
+	/*
+	 * For compatibility with VFIO when /dev/vfio/vfio is opened we default
+	 * to the same rlimit accounting as vfio uses.
+	 */
+	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER) &&
+	    filp->private_data == &vfio_misc_dev) {
+		ictx->account_mode = IOPT_PAGES_ACCOUNT_MM;
+		pr_info_once("IOMMUFD is providing /dev/vfio/vfio, not VFIO.\n");
+	}
+
 	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	ictx->file = filp;
 	filp->private_data = ictx;
@@ -395,6 +407,15 @@ static struct miscdevice iommu_misc_dev = {
 	.mode = 0660,
 };
 
+
+static struct miscdevice vfio_misc_dev = {
+	.minor = VFIO_MINOR,
+	.name = "vfio",
+	.fops = &iommufd_fops,
+	.nodename = "vfio/vfio",
+	.mode = 0666,
+};
+
 static int __init iommufd_init(void)
 {
 	int ret;
@@ -402,18 +423,33 @@ static int __init iommufd_init(void)
 	ret = misc_register(&iommu_misc_dev);
 	if (ret)
 		return ret;
+
+	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER)) {
+		ret = misc_register(&vfio_misc_dev);
+		if (ret)
+			goto err_misc;
+	}
 	iommufd_test_init();
 	return 0;
+err_misc:
+	misc_deregister(&iommu_misc_dev);
+	return ret;
 }
 
 static void __exit iommufd_exit(void)
 {
 	iommufd_test_exit();
+	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
+		misc_deregister(&vfio_misc_dev);
 	misc_deregister(&iommu_misc_dev);
 }
 
 module_init(iommufd_init);
 module_exit(iommufd_exit);
 
+#if IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER)
+MODULE_ALIAS_MISCDEV(VFIO_MINOR);
+MODULE_ALIAS("devname:vfio/vfio");
+#endif
 MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
 MODULE_LICENSE("GPL");
-- 
2.38.1

