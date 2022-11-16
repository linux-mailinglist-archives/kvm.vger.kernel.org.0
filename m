Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D843862CC46
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbiKPVHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbiKPVGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED165CD24
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=co2tmOFWvPkOFpcIQnbw0QGwo+hKV8mGMk4qaK2KvV41ozMqRwxjaQPdXbbNUPJkjcCskcC+k8mTYq+pexf83hl0WSCLx3JoDsCH0KVhVHe8Ds4P/n6nStyVcYtHKiRIkca1p4zeVVzL0oNdP8HJbhn+06FIrR0TIZ7FFbaMe23GsA8z6ZAwkSsYGrufOo7dFELtJ9FnW/Ugh/CRglL1GrHZgT6X8kCMB17aXD7ccGIJ1/rcqyBQPx42/j6b15Im4qRzZZ+f9dzPTGj4MqvnewhxSeVtodrQ9VMc7HiUtQl6vu0BL6KveQoyY/1R514Md7La3zwR60KpLfEmBDlEWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ug7PoCpkPcpM4o7oIOKfKy6cpR+edUDW5eRIHpq48j0=;
 b=F43iuMSfikYmlgAcoMrbOpYUAEHuqK4Ts2SR3Wu/qnu/DQbCYRgIojq2cLO20qtq+Cd8qlcWn1Jcq1J8i5zTPIgZ60p0wVoz/25Jx3rFkAmtPH18zpaRazLegBtyy79XK584kfAxOkonl5Am+VxqF1581HxghFyyMfgPFySEL8ffjJBUJzPrjUYB4rVtfPrFpSIWdHohAC9Ewh0lAu6zKmU99jJTFm9bZwafFmZtbSaEe/69ixyf9WHB1tx9hAIl/K1QwROaxAPfQlzbgD7s2Dpze0iz8v8Wq08nHm5GhSewDwpJzVSiDJziSCa+pCTyElKypSJdrYYKv0gBlgmj6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ug7PoCpkPcpM4o7oIOKfKy6cpR+edUDW5eRIHpq48j0=;
 b=qVHG0L4EElgDwPOM4xqcWpWVEn6SxJbi+SJTbUKIjRqnI2/CkVFITwNFoBWThzF5mklPLt7Bw96llR6XYmYMEHCsPDhd7YCOsJjwauPkj5Gi//7ONKs3RvK3eIvN7Xx+1SobqcGj/eQyqpUZSO5DM6ZrgXdOx5iZKd0u6swKglG/AgJeubPn2I6ddHlMKJQot2AJQaGRiMe57qXlDnghrTnemQQEGN7R7BphEQXZWvBWLOS5vcNQguOqka0avGW5Puwvh/qWIlKVfrVs1bdom4GyCyT6WzPaCjBAHM5JI2YU9oc1XmeuuPQJ74XhLkdh3tKQJ5hyo2kTQLCFxFOh8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:39 +0000
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
Subject: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts to vfio_main.c
Date:   Wed, 16 Nov 2022 17:05:29 -0400
Message-Id: <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0003.prod.exchangelabs.com (2603:10b6:208:71::16)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 266151d6-7caf-49a4-241b-08dac8164fc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skqVT7QIo/u0Wcd3dD2xhiJMagLXZ0AobSh0K8zJu+FoANxekepDUTC2Jbc+kDT3NbSXElZa5mn7dDq2TsOhdp9xmaYJ1F/GLon2kCXlDjbrXqEHRyi2dNJwX2B4HrbpbQz3rGWzAOusrZ4Epex0X9AjJBG5oN74Xwm0CG+geeH35GoaqIJHvkkl3BgrU8zPBDI8eqLgtPDDBaWyj3rIc7IX74+jt1sBtp1NWl4KuhjQDtYHpiSLOQ/vZnC5DM8RhhKh18Wn+Xs1Scefr1zXhOLpA8zXRy9NbGb932SYuiqU/XSef5gf7QdD2HAPzX0FrG35OkIp68TJyIcuFHvKPKQaqe78bIQiwKHtSIo1tD7bPCjjKMJokL1bzyFjQC28T8645ixKhsUQGFuhqhPRMgKqlQN9xfcAPXlfevxS6k15X2oNirj7fwv2oJ/K91Jzr/7uuwokvg6IZmS6RLZu8UctDcb5ewK5uB/UJew5WTRj66Guqt8a/krsMkURBM3JmtU1HfNABOfQzMBIbuX0y53N5skQALQEkdcWedjTJRfMOyspUI+eqrs7w76FVSHz96RoBTDcUM2oezQ/YPhBDKlHvFgAsnXbMO+Hcclft2OvuUxiMhm7R3CsXUNSKWJyYTvNTrTquBnddhpo5+OOPotOvYRnJeneG1chGiGADDtYCkENg2xsQd6eB0e8BFuoFU7PcZ7UhQMkH5S8kHQctp5TZdaTp34QL2s0m69/4L3rMJ9bGsxTBJoYGOd7gnxT4ihiE4M2PCwzObOKzsU06g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yqWm/++DicbtGhqB+UgTgtgOHJ4cih86qvyQGkZIxg7ooJOAg1qdDO7VVkxn?=
 =?us-ascii?Q?UlUxgvKByxTi92KQnI+h0+UGbeGOu3L6AIKP06JBvc9UadvsCUAagezJClYt?=
 =?us-ascii?Q?YEXCZSXzSHWaaotjGXuXNr9rlS0q5sTS/T6xAiVtEgLK7OBCJ02lT4GAxTOu?=
 =?us-ascii?Q?SztSeCpsiEIuodSqJFdf2MuEYHCLeR1gtyMZBkwQDRiRq1qhquZZb1MCnswy?=
 =?us-ascii?Q?hz6KuFBEgCqL/IOSeIMXZgwkm4Se3/hZqjn87ENaD+xXvxsUkY5RatSfULP2?=
 =?us-ascii?Q?S5UzwFWAEBhYmlhSonivs3zStsWl6yNlDgv7nHrykWEzvexIaK7HS+ctBd7i?=
 =?us-ascii?Q?O3fz2erNm5rK+W5kEgsInL6YFuV0O9ZIVNFCmpexbG6bEPsoJOn2t2iCg8Lj?=
 =?us-ascii?Q?g80CBXAnjT+bTxXoA8++hO4DPbHRJY3u5aAyWZOwHg/XD+pROKT4Lpsc5rTA?=
 =?us-ascii?Q?xjYNUoceYv5AwSStqu648CLVzcJrfLeMJO7Q6mAeGQrDwDv2rfGLCf/Vf5fx?=
 =?us-ascii?Q?8mJ1VICLnsPXjTS40aSMX5VGHfbSLlWi7P8L+MrqSkwt59ZewXxwolj1Jjai?=
 =?us-ascii?Q?dST4bnzhWN5G2JfU8Qnkp600bTZLWjQ9tE0V2UKx1oFPYRp5DqeRsR+IjPI6?=
 =?us-ascii?Q?VqtQAybuAkYdubreWdDVRUmR6evaDS4aK8DHEUaribxONlMEqKe2WQPOgex6?=
 =?us-ascii?Q?qzFwFva1xOTRTWtt1TJzyJxIa8hhIsv6+6lcyrbUXm7ZfXjBHp/6aFnoQgxM?=
 =?us-ascii?Q?rXCveHxuyXpj267zhgZUfzRMkYeOjf3uQbZ9meC8nA8+a8n+IDFuh+q+ZQib?=
 =?us-ascii?Q?qWPVzWrGZuvtYHRVbysTeOy7o7XXO2Bnaf3DsG7RqZKaq/rVz/b8HuBifLbi?=
 =?us-ascii?Q?aDqtrKXUGZU0vFlWIm+V2GgtIcWLm8q35fGjnRR3KPNyWYCLNOy4nC5JnUF/?=
 =?us-ascii?Q?c6KKTfqtYqAsWQCqawvHJCF9Wc4/WEDkaMDaAFkD7CW0EjugrKbUsTCoyqcV?=
 =?us-ascii?Q?CtuEOftKP1s4DQXWCHa9iNHN6c2z0sl2GzMckt5Q7+VK1yvAfvtdgMUpIMrl?=
 =?us-ascii?Q?36kRLVvyqzNRqS52jzE7BCABomRbu8bJcpKQczTIOeeUQn713/TCH1RcxVbf?=
 =?us-ascii?Q?OBk/zEdU40PHb7DMUKueFqm58GUP2iJDhYWKdpeVzXbyNEg/ODBR/c1hQcYz?=
 =?us-ascii?Q?B45fCqZDxlcgn6YWWctvCOWC+uhmXs0YKTB29LS+ljk++OZILSmYXhQOKOkV?=
 =?us-ascii?Q?Bm2qrlteH+uaZ3bzrxlov3YpstleopJk92VonF6lBfP01LohMAqzrZkaJhhc?=
 =?us-ascii?Q?sdh5fXGteOyz6NqOynMjEmg0ML8E7XYViHf1ENTGm/Jleyo72nLY9Puhg2pW?=
 =?us-ascii?Q?DQpN1qx8IiQf8QslkC7CNzhAFcTXbh/obkXJaFaeR4iwgQ6fji3qIDc+Gl3v?=
 =?us-ascii?Q?FfVTT81ZNiuAWS+4w0V7tFSJ7tjKrKg3m/UaPcoU9hvAyrIUOosYQQhvIUFO?=
 =?us-ascii?Q?zFLokY+hebbhsoKqJO3Zx9PzvfYBRLpxu9pMZF6k21jU8BV6ipPZlAtwnIxH?=
 =?us-ascii?Q?mIexzhm1Jl76smXnSg0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 266151d6-7caf-49a4-241b-08dac8164fc2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:38.0867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cN/TueHe+TcSDcUj/gLkPnnXaGENBpKedHrt9j2wllKeB5ObNteYDdozfImjMZKH
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

This legacy module knob has become uAPI, when set on the vfio_iommu_type1
it disables some security protections in the iommu drivers. Move the
storage for this knob to vfio_main.c so that iommufd can access it too.

The may need enhancing as we learn more about how necessary
allow_unsafe_interrupts is in the current state of the world. If vfio
container is disabled then this option will not be available to the user.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.h             | 2 ++
 drivers/vfio/vfio_iommu_type1.c | 5 ++---
 drivers/vfio/vfio_main.c        | 3 +++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f95f4925b83bbd..54e5a8e0834ccb 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -130,4 +130,6 @@ extern bool vfio_noiommu __read_mostly;
 enum { vfio_noiommu = false };
 #endif
 
+extern bool vfio_allow_unsafe_interrupts;
+
 #endif
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00d4..186e33a006d314 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -44,9 +44,8 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
 
-static bool allow_unsafe_interrupts;
 module_param_named(allow_unsafe_interrupts,
-		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
+		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(allow_unsafe_interrupts,
 		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
 
@@ -2282,7 +2281,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
 					     vfio_iommu_device_capable);
 
-	if (!allow_unsafe_interrupts && !msi_remap) {
+	if (!vfio_allow_unsafe_interrupts && !msi_remap) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8c2dcb481ae10b..e1fec1db6a3c93 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -51,6 +51,9 @@ static struct vfio {
 	struct ida			device_ida;
 } vfio;
 
+bool vfio_allow_unsafe_interrupts;
+EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
+
 static DEFINE_XARRAY(vfio_device_set_xa);
 static const struct file_operations vfio_group_fops;
 
-- 
2.38.1

