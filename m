Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8DA355C59
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhDFTk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:40:57 -0400
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:17062
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234185AbhDFTk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:40:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2pB7Jmali0pSRayHDMfJ778tZc1x6b0LjIHvzTlkkuCFKG2xZ16tF3Lb9eNKSk5OeyeuzuTuud588XdUBRsv5E518apsZff5WgTdxSTGtMs0swZSEupdVWwYMJWXNMRYJ1amNIZQslsJp9hE/I52fzVcHG32fhEmSw08YhIIOx9I1pgr2jhZU2Sm66M1XA7zCZlvaXMRGKRM/1eOAQsO4S0egWhYvh+1bF6vQQF/3gCTLwv4PkTo1R/9a0dZ1IiE5FnXSlYdwX/EKG+AZ8emEdvbKfIuHIDb556tL9WlrnTgCZwNW9Zm06qWQlVUYg8RyE/T0w3TFwFwyEIHcB94Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRKwuIDiB/9LGr712gfvhhC3/mHbTfvih7aqjvLh+bM=;
 b=Vi0Q/93dgJDy2+hp9qpDFopNl9vH+fEZBJQI/gBfhuJK65wO6UuxZEtp+Kt1Z3sRITsx12wlbsjDQKc3L6S+jv/3bPExQ6tyeFE9Tss9iuqT3WlxYmqMzMPG/LVavR+2U9byao/GYI6lUwUiia8wlDeSanKAOQ+2q2eIIki6zhk9MngzngI4qs6iVljQsGAAxy05qEx9v4CgL55v/CkCBY4hbjfS+QLqgTLLAiIXx1vVJAlHuucTfudyI/ecX1wUGH1mxvt1RHvLFt2eQxFZd3L9Xp7VWoP2TunxBz0uG0IG65vGsMKYRMmR7UkClKWoMp5nHcuPaJmj4jtiES7RNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRKwuIDiB/9LGr712gfvhhC3/mHbTfvih7aqjvLh+bM=;
 b=LgA5OokNvoKMOb/lci/6IcdwwlQfFWN9nF3UKbskGifWL1cCaTz2H31NxxTf6vj8VdkN9ul5WqttwCYNq/JSTCud6aU/cjJ/ml9GIPO8ZjToVZkHxf0N9dKCjLuOwTq8QnnSbaFVGfF7DLnjykEn05Wvg+qlsAAC5WSqSTB8BcIg44yYm/3jRj8jrMdczJtr2tC/LrCGMDmUCu471cS5hIBV6cyBpgrnizkf3iVMKW57rbc6sg7969F3o7nzPiXVTXMYtg9sAk6eD4v4zFyom9ZaE7SRXabxSAbKQreMwGrd3UrR/MXkm0+k7eDucZZH7Hhqo9lG+lU5GvXHPzCe7Q==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2859.namprd12.prod.outlook.com (2603:10b6:5:15d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:43 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 01/18] vfio/mdev: Fix missing static's on MDEV_TYPE_ATTR's
Date:   Tue,  6 Apr 2021 16:40:24 -0300
Message-Id: <1-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0281.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0281.namprd13.prod.outlook.com (2603:10b6:208:2bc::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 19:40:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ3-001mWr-SG; Tue, 06 Apr 2021 16:40:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d000c5f-37f3-444d-1d92-08d8f933dd9d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2859:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB285999043B479196B49162A0C2769@DM6PR12MB2859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:213;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lf86X3ZS/gVWpOJJMzLJ/bdJ6R19Z8lwJOx4YBrVIhY5doZEmY3KonlBaQO9Ug82SHUH9uOXlCmis3pHA7/CZ+mtt6+Sgshj9APwD1CRQRqhsbkUy7BWDZ+ODVbY0sClRX6CiyZWr4KPas01erYrKwiUjWRvcQhL0dEXqv5xDQfnQVjr3wLTIqg41hhyGb1htGsMehnfbNRx7FleEeBvGOQWtAfaQZqs3Mo5lSDRxy+KufvVsUW8pywe6CTHdpX2rACXPilAhlc8kCnkQzrKtHUqNkqC8VdUcs0A20PMezne9fUCROLxUapcB5urEBPgW/WnIG+VcztJjGkdWsvvSNH4qZFjOUZP4rH7rNIDVYa5FNkgI1cQuBLeOhtAs3GtDsGAiSCIVvlGz0n34NZTpVKgYo/7npglP9VXcswNDZSYKE0kKGPuMdjBrN7h/UsdZ07aYYXansOmWCnj+77F6XqusYrvI+hjcBy/BqJZnzZrmTV5CDC/AWfUs0b+PLyw0aeeMXy4i3l43PPgEtrc8ZHBM5EloXAGu/XNmfJxFm1/53phabCteAl3xCZ1IG2USVF7CnforwhFfy/8wFh3sneG7Z+c9K9rZDlH1yIxjmh2O8LLPXJ9nH2qRqvifRGEYS5rBKH0YZ3q2eXUhgwKh++TLNhTqjmEd+dj/K5vCREkG8vYgQ3mln1/xUDugtzg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(54906003)(86362001)(2616005)(26005)(8936002)(38100700001)(6862004)(66476007)(37006003)(426003)(66946007)(5660300002)(316002)(36756003)(66556008)(6636002)(2906002)(6666004)(107886003)(83380400001)(186003)(478600001)(4326008)(8676002)(9746002)(9786002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SgTnkydsReckRq+A6YCNPdgOaBlF5ozA+LRA43Lnt0CBwxDlnj2L82splB0B?=
 =?us-ascii?Q?P/vhXD5Osbx+mjniJrfu9BZPPx1uSJDOHRp2dPsN4rpFiJ6Xc1WRtg1XqpPn?=
 =?us-ascii?Q?NHrB+MCHzPXMT9YbpwP0eg9MAar/MEvcVt73tHhAFSpk9s5qNvSQY8bMmYy6?=
 =?us-ascii?Q?vMC85ZEf/5MknTjMiPyMokIuROShvc/bAyOeKX6/NBaTqC/zOMncvv5Mtll8?=
 =?us-ascii?Q?ZtUVzFbNJpenuXJqIm0LBcVUeBZNN0g7AoiDiDFu+vfX9iCbRL+InnKEy2tr?=
 =?us-ascii?Q?gCiaFZdS4TzN416PNUTb6CJJMJJzeXvCoz4uhVQwyBbWM+7faigPVleZWzjR?=
 =?us-ascii?Q?DOkFDO9W7sXnRz28BOQ6zETTkV0xhRhJ2Mj9tBr3/Sss56bGpdNySzNq0UFP?=
 =?us-ascii?Q?CfSePBO993tUk7eINubsTS67OYm5c0JUNjUjElRPehTkT+ZvkgLKCWa1jo5S?=
 =?us-ascii?Q?QAFVwpaY0EbVkWfiQgMMQ/r0RF4R4TrZtsdrGe2cCcTNDel7gDQQT+oWub4z?=
 =?us-ascii?Q?JZDa83Zm1biURD04DW1YgCBwadlwE0+Bc0WgjNRZW/2h8W5CM6Y1azFcp1nh?=
 =?us-ascii?Q?i7RCbRi3xzrsJHUuBkWT36MVtfQl1gVWiuoIup1KsGJa9+57ADxZ8DvTmP0f?=
 =?us-ascii?Q?F9cPBMEJMv8ckwyQ+/iB1pbT92+/UjVAvBAQ1aze37hokvLSbGWsjerZxAYK?=
 =?us-ascii?Q?Wh2wLMgMPBhMsexHOPHtLVyPOta4KrEULSL8sc9l9EOvtke/A12R5b5VvvV7?=
 =?us-ascii?Q?6p/thCv03VN4wn50zW6qZYaZXVdLKGIE/zuwfzy/4op5gC2RnqykmvxJiT9S?=
 =?us-ascii?Q?Y2V3CwfQJ//aa58qZ2ttSuqNbYftiLYfBgut2ECIlnQld80e3VdmdaVufHLK?=
 =?us-ascii?Q?fxUSx9FvUUzP8UHa+ecB0Gr+ahfhuNs/xj69PjmjgbudQG0G/s9z4WH8zKrB?=
 =?us-ascii?Q?j8dUyjNy+v3AeP8CGjUUyxQ0+IQT8FMvYnud1viO99vv56OBrxDBQ53jea+C?=
 =?us-ascii?Q?xtTVXsS2tmsAdX3ssBRhAuphaozVRaTlM7P76z4x51wmaN62CdaRUprz9yuI?=
 =?us-ascii?Q?1KxLvxrJu7qfUBmP376Cj/ODrD+TiXN7aHG8/wJ+QE6mq9sMHwE8TrCKt1JL?=
 =?us-ascii?Q?BveEIZ4Uo2zbc4urhpKE1xtaa6XLxvkeV6hizcfJUDlltXjDWYxQ/DIxzfQq?=
 =?us-ascii?Q?d07U+qY0wpRG0HGY0E3wd+zUmvbawe71bGJZd+if/gKKklU9GSgJqT8L44Ed?=
 =?us-ascii?Q?0//1PLd51ZOpg29EKPYFD4CVrFsI+xTmBhsIbMTi9dcAwsOTezGDk2hb+UHD?=
 =?us-ascii?Q?QN52k5OBrcaJORpKhRvswq3/dfv2tBzFdGPDA8XwCKhxig=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d000c5f-37f3-444d-1d92-08d8f933dd9d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:43.2633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2I37RVnG7WQLnzLcEEtFKkCCPsERgX1+qDOE7nChPE4EpeGvUUbyB9tqo59c8HFM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2859
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These should always be prefixed with static, otherwise compilation
will fail on non-modular builds with

ld: samples/vfio-mdev/mbochs.o:(.data+0x2e0): multiple definition of `mdev_type_attr_name'; samples/vfio-mdev/mdpy.o:(.data+0x240): first defined here

Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mbochs.c | 10 +++++-----
 samples/vfio-mdev/mdpy.c   | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index e03068917273d4..365afbe2dea558 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1334,7 +1334,7 @@ static const struct attribute_group mdev_dev_group = {
 	.attrs = mdev_dev_attrs,
 };
 
-const struct attribute_group *mdev_dev_groups[] = {
+static const struct attribute_group *mdev_dev_groups[] = {
 	&mdev_dev_group,
 	NULL,
 };
@@ -1344,7 +1344,7 @@ name_show(struct kobject *kobj, struct device *dev, char *buf)
 {
 	return sprintf(buf, "%s\n", kobj->name);
 }
-MDEV_TYPE_ATTR_RO(name);
+static MDEV_TYPE_ATTR_RO(name);
 
 static ssize_t
 description_show(struct kobject *kobj, struct device *dev, char *buf)
@@ -1354,7 +1354,7 @@ description_show(struct kobject *kobj, struct device *dev, char *buf)
 	return sprintf(buf, "virtual display, %d MB video memory\n",
 		       type ? type->mbytes  : 0);
 }
-MDEV_TYPE_ATTR_RO(description);
+static MDEV_TYPE_ATTR_RO(description);
 
 static ssize_t
 available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
@@ -1364,14 +1364,14 @@ available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
 
 	return sprintf(buf, "%d\n", count);
 }
-MDEV_TYPE_ATTR_RO(available_instances);
+static MDEV_TYPE_ATTR_RO(available_instances);
 
 static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
 			       char *buf)
 {
 	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
 }
-MDEV_TYPE_ATTR_RO(device_api);
+static MDEV_TYPE_ATTR_RO(device_api);
 
 static struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 9894693f3be178..d4ec2b52ca49a1 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -658,7 +658,7 @@ static const struct attribute_group mdev_dev_group = {
 	.attrs = mdev_dev_attrs,
 };
 
-const struct attribute_group *mdev_dev_groups[] = {
+static const struct attribute_group *mdev_dev_groups[] = {
 	&mdev_dev_group,
 	NULL,
 };
@@ -668,7 +668,7 @@ name_show(struct kobject *kobj, struct device *dev, char *buf)
 {
 	return sprintf(buf, "%s\n", kobj->name);
 }
-MDEV_TYPE_ATTR_RO(name);
+static MDEV_TYPE_ATTR_RO(name);
 
 static ssize_t
 description_show(struct kobject *kobj, struct device *dev, char *buf)
@@ -679,21 +679,21 @@ description_show(struct kobject *kobj, struct device *dev, char *buf)
 		       type ? type->width  : 0,
 		       type ? type->height : 0);
 }
-MDEV_TYPE_ATTR_RO(description);
+static MDEV_TYPE_ATTR_RO(description);
 
 static ssize_t
 available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
 {
 	return sprintf(buf, "%d\n", max_devices - mdpy_count);
 }
-MDEV_TYPE_ATTR_RO(available_instances);
+static MDEV_TYPE_ATTR_RO(available_instances);
 
 static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
 			       char *buf)
 {
 	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
 }
-MDEV_TYPE_ATTR_RO(device_api);
+static MDEV_TYPE_ATTR_RO(device_api);
 
 static struct attribute *mdev_types_attrs[] = {
 	&mdev_type_attr_name.attr,
-- 
2.31.1

