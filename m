Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370B63466F2
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhCWR4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:12 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:2016
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231189AbhCWRzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAOf+1oGSRelp7WIo7pnputZ90iY0QGLXpcAs/Sb8iZFpa4eG0/W6z1uQfsPnMXnz9zg8vFZbwZy0A66z6Szce49CaN1CluEGcJJCPXY1nXkFepUfITKb1zhuoWjnN3WZuJnS35lX0cV7vV/lWPbXKPdTQb5bfNHyNanmXTx52uZtid1GyHeewG+hj0+45K+QMkVGt5OtrC6eHJAji6T5D3CLfpVFylE/9VzhYxKtwq5IENpnLu/j5AOWwdCTVaV9Tc+ni7sCVDRufd7qDSKaHcS1UrVw48vL5sbAQRW6xVKisZPOo60jGX//xCdbDcB0RincfQl8zUMG0BoxlVMWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/HAznt68F6rbDQYGOO9tCbMJ1b8NHhHjawE7ou1i1U=;
 b=CUIKaTcCFWcJh9IsM9UFoebH0PvCmbZDM+lmMFTF6asrxpz+Sjy1l5p1tRDOX04OwEP9TwBHLqrd3VuKggtEpRMMPHQFDUHdWGswZWWSFCw7rknUhQIeArDo1Zb5l/JQTRVulC8I1Y2JZ5YxZRqAtBxx96az2NHA7nBZZgcyq55moQT01AJsHTxtDJfbKVWsOS0+weX7ImiZYsc1K0DexbwpC5F2lzC+GAAmn18V+FzhhSOIgQ20PMBppjDbgULdzMRFksT4CGI+NgHFiYH2ZWi9q4yzNMr0C23dprjBAS/jYiP111jVC+06mpkzo5cVOL06Ru3gCW80h85yQGz74w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/HAznt68F6rbDQYGOO9tCbMJ1b8NHhHjawE7ou1i1U=;
 b=A5F0+ZAuS+cDjIlzXXjEJH/sFy+2gY2odHdvpqwK5C+R1X7nb+pqnz2TbBneB9lz7Ry5IXMzw9FOl4Ru/Yjdint67GXqgVn5dd4emEQq/DrtzEvZSkuj5v5tiGSnukPAIcuhR/n6sEvyWPwPSXheSOSIwKW48TbvRPp2yycLXAEOKpVlex7Rhv5Modwm0BhX1tBy9xtMtMyPB8BvFzZm4dpO52EkgrHOB0f7iGGMrqgJJUxswfWVqttGy2gW6+KQlBfmzE+Rg+wkOgL8z17VJvfPNCHzYpJAA3zW49zCKBehaOSGpi3klYpowxl6EA0Zvd82irVUcoCMnABtVHs+Fw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 23 Mar
 2021 17:55:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:38 +0000
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
Subject: [PATCH 01/18] vfio/mdev: Fix missing static's on MDEV_TYPE_ATTR's
Date:   Tue, 23 Mar 2021 14:55:18 -0300
Message-Id: <1-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL0PR0102CA0012.prod.exchangelabs.com
 (2603:10b6:207:18::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL0PR0102CA0012.prod.exchangelabs.com (2603:10b6:207:18::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:55:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgQ-5W; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1afceb6a-6a7c-459f-de89-08d8ee24dd17
X-MS-TrafficTypeDiagnostic: DM6PR12MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44837B157042989AD45CF181C2649@DM6PR12MB4483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:213;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KepQ0snNw0jlpS+gT3NzUfpbMYHvJBeEfFUVNLsB/cGmhj9q25S/i7xdyLGzg1odGmDswEtZx9JOyIZSe661FmDNzecK2ahBZuoO54RCdLZp4sDIDFMdbftfqmubi/G11+h2hntzsgQ0HUHxVY38g5Y8rIlbJzJxlPLasf7T41Qn1rlnlLjwuouOZmXtFHNgYXvBcY7WdMBWwaWSomnQ3AIrSQz2xvqlTAAbW6Tks3y+N/qN8eiwJu7QGEUN/4MHln7PLWvyO0pxBt0yayoNtOpLDvspm0iSdyEZRutz2Cl5YW0ROrR2EKzV5Dnnk8+YtxFo4Jp5cUJ47e4BlrQUUt3IGg9lvMkuLsxoOyVvV73W+N3jPKxyRcgcI6sOdJzLo4HovescAflVWxY+vN0azAAFuDfHgX2in6vi353Ds8i2QXlYoH/ew5MnNS/ZwaK+Wj5kLpcH7L0P4YXgiyD2EvU908XpUonDXfGxalmbiVKOw5XtqadBNWJePsZFsnK6hooNovjz7oIbeFVwD9nEGua7TmSB9aQLG+kOD5HdpD9W45EFGNqAmGGdDQbmMUw5O0JpdfYyTtj13zaNTl0SEV1NqO+Al2MWUYOzoKepKl1L1hvokEzSQGIzhy0WO+goZzMGWbcG6yszPVfvpdRK7a0c+feooyHMVAJz9lypGhkV6FWS0mRcdffPN0a3EtUD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(186003)(26005)(36756003)(37006003)(5660300002)(38100700001)(66946007)(4326008)(66476007)(6666004)(2906002)(66556008)(54906003)(6636002)(478600001)(86362001)(316002)(8936002)(426003)(9746002)(6862004)(9786002)(107886003)(8676002)(2616005)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nnOPZuHZ8jAf5Ds+zjNvWAlcGMh7HMAgpmgSDtR87fE6+SPvMpE8zQ//EsZX?=
 =?us-ascii?Q?gw5GyZV1NxSWMvbmpfiAertzhQ5LNLDh69YHLfgC4BMcRBYJkHakbCqCRENm?=
 =?us-ascii?Q?7gBGcEpJoEIGquvEm2Ex06wRbwoOdPEEYQ+1Se9+bph9EPKNej3DzIKbs/nm?=
 =?us-ascii?Q?rgB6Jw6U+kl8jVaPL46SOs2Frdez6YW5Yo1gELii0x2VY+gySc0kk/IQ/iop?=
 =?us-ascii?Q?nJZt/oQH+bp1uIJOy0J5Rp2C2isADZBoLWvBD2OMcrbv5K1oFymhekTxLVft?=
 =?us-ascii?Q?lsO6xlRZde9UymV4lEyRPiiZ0wI9axvM5WbNEzXhmtfWsdbJJG1UduuCSU0D?=
 =?us-ascii?Q?YGCsEi/TVaozUyWKZ9S08lmNVCpa+whALQI1ka50sVa/v8BlwxtMIUsdr/hj?=
 =?us-ascii?Q?fICZu8VOJnRWORFyLF2Uk2OI9rcX/F5C0pKbNKW0xMk+aYFrCRBKEBs6ZQO+?=
 =?us-ascii?Q?KBIEl1IrhGGbcpK71MWwSf9ZWoN3okkv4Zj1vcWap26Cs6Xm7DcL9bVVsz1A?=
 =?us-ascii?Q?d0byzrtwD5JxMjl8x+aXdtlGaDqFNAvMiJ0pD7JzT0Gj8gbDMe3y2xjvfdcq?=
 =?us-ascii?Q?wee9kGoip19hrj8gA8mDuGO+ptAGJNaQnL71mfcepXURM/iyQGVBu2oD3hm6?=
 =?us-ascii?Q?1g2yMjQHVYAEurMOzbvM2+Nb4oI3XsFX+Gzh2OjDPKje5stkw/xoi1TTBNUg?=
 =?us-ascii?Q?OI8wrctdYXRNQP3jilgX/ltiCHqn5lhx859K0tt7uzg95pGpggL+cEGdCF5H?=
 =?us-ascii?Q?u4SYzRpon+A98vK4UpUT3e0ZFeFnfHQq2sRHIHcbonRolJHyw0FVNp2oY4KI?=
 =?us-ascii?Q?Czwzlzax1X7v8/C06dpfNbHHXxZTVRvjYhKL4ogbe3gaaRrieAlvHOwdKtVe?=
 =?us-ascii?Q?fUyx7ssAGIuGcPZIJjOjQoiKGiBG89oCHi3DEJt2MdLq7HhIxamFZcZtKj53?=
 =?us-ascii?Q?1WumvZl/cRQbKvqTjf/xq4tc8xi/FeKCW3h6N/mjMBeOPQrY6/crq5GuZkAA?=
 =?us-ascii?Q?NDJbt4A4eM0Wsq+o9sJEKJFg2Pl9lHb1LkEm8AcNZGg5FTPZdWkshUxfYT0/?=
 =?us-ascii?Q?7thSehaVawLAkCWlWk3pPooQev4Nxi6FAJQ09pUf4EApTT44p+3R5pF8Hbjw?=
 =?us-ascii?Q?WBn7g5u58/h6EDlz0IjBwT+h/sL24iTfjPXKF6sW+RiVPagykQHrd7+Y/Cry?=
 =?us-ascii?Q?KOX0vmHLgPHkHFiBytnbZ4uyNGSCiAA85HSTGe8j88+S5XWmBU237wQbbRAF?=
 =?us-ascii?Q?oXo7MYGKku7QcHUSQC9bu7XvDZB9el/5vLJteOPWCAXEmWjKDIp456uHzF/L?=
 =?us-ascii?Q?IYrnimMKtT/GPPIlHniISQvN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afceb6a-6a7c-459f-de89-08d8ee24dd17
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:37.0976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfsNatRpr2oLcF4ky/N4/TvregiI6OJp3AVGzE6YGdbGCeA2HaBk66PPzpARXSk+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
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
2.31.0

