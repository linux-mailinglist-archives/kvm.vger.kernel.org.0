Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7B3466F5
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhCWR4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:17 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:16865
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231265AbhCWRzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wwmh4dILIE/gqofpXAUD7x+MckWC8aDskKlNcCrvbbjzF9dgoSEaVtsh2wb6FtYR3hLNYB9rZVSiN6Ahd5dxdjSNzYC5X/ZUVIEL1/jcqjWohJ0fePMr4rm07rxmaNfDw84nMkPBRq7zDwC7zKqqxzP9RBjOshv9PzRaP9woJ9DCZY3bjYrDZgePdJzqw1GVNpQ1gl0IEYupapcjH5B343xD5MkKagt/Dc1KOoWFXwkNx5T/qI4+NIcGkKVJTMOVlk54M5AAQgdTbhnai58E7iMxKg36AezlwgBZgca1EFz0Sn5uSoitZefzczPtiUAHbWaCOPU369um0jVb3mInxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zWkoa+pW27gbbX1iiE5kbluK6tMuu5mXSd1YE/2nio=;
 b=FvPOdyXqSl+R4LJierkESPK+S/2R3sFQCUf9BNCGTBXQd2g1XC62UDCFz27EKSaGo7SD1aZbRnlLrh45OaSVZ09KM0xuhvtEtoNzXWMEmHbuUk9/ZhQaqW/p2ZRHPAB9BDP46Ky7oXgSvNmdkXaJvgWqbAiYXlrgXqfNtmaZ6+G16o75X2EAauUkrLqpkf2dXNAMhKBZ026IcztHTfU4Szps3Jih20lD4J/iwlKAd3XBWEkCF5pc73dqAil3V34u2s9PSIz8Jy1du0KVrARCoyHlEdp0uzh7Pvyc7pP4/NwHOnmcMEQmE5x7KhrhREd0IX0d97k4N8WWa8DgWqTCWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zWkoa+pW27gbbX1iiE5kbluK6tMuu5mXSd1YE/2nio=;
 b=j1tJx92/ep1MbBMN1sxFXz6Usj3h9Lu+fsOotbN/H1+yIYKosYSJhDQh+Gu+jmzEy/uxefUj/UZhRx+RlAjk3PT9WNitnn1wwtUnp01AYDTIAaqWcVw8nhtX20pKz1Ct9qRZA/7p4hGvRfKHQ8qjzqQnTyBEE1KXlvZG7X8akukXkB0n/ea89s/PkDcUrqFwWTdDzkHmWGMJA0IzlWCSaVPUoBMhXM01b29q9o4CvY3+AbwF3cSTURDFw6nlG6oVk/5D+DNeI5rDlwQX8aCzyoQ43/Ywubc7ZQv0D458HvbjUuTZ6A2zClD8DvO76XjSXCuJwUygkR/s8ALSRgfZAg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:41 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 05/18] vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer
Date:   Tue, 23 Mar 2021 14:55:22 -0300
Message-Id: <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL0PR0102CA0036.prod.exchangelabs.com
 (2603:10b6:207:18::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL0PR0102CA0036.prod.exchangelabs.com (2603:10b6:207:18::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 17:55:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgh-Cq; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76454c62-caed-4124-5652-08d8ee24de0c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4299:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB429961DD83C3C3B70A929079C2649@DM6PR12MB4299.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+IYBBYhevqf9OgPMcuL6teeCixYXZrhFmBb0+Vx8mGYWFidgNA5U6apiQYSGtN7o3YsNch+WwpuC0KOAZabPL4xj2Clx2/EEzSHnuuBZAW9upA63EpX8+BDBBedvyx5gwWfUAHGDReNkWUApxXaEcl9C4JNArdFTpvsCWwD+k6x4SbL9/kYKn+jsdIaMBDWk7iGtkaNCC4ikJjiBO88GRH7xcLoF8xEQDGLg0cN8+dYi1/+5Bj3ZKzmDO6oERE99HJ/h3SJxNtACW8Qg9EPs6pAFSwlnv+O1wr9hGsGgB8E+odcRw3iLKyX10P7B+DXU8ZrXsWzCYMmAkvFtr8iE8rGPTaeJvnMTmD0vUV/HZdgW/KKWkBt2Jo6DBjvpewphW7PYWq98czG7EuRPv7qsm0nnknzwvtP3EGRiF3472jYVIcF5YBgP7dJUJROJBYTyeNRRokMbEcnFe8F2zTFvzYNwJJzbfweacmCz/DwAN41x+CyKd21G65rU7H0lfQplvSmh7XtaNSwq/t5uvfr36kYdhO2QN0jU+TY3Buwqlbghl+GXg1hh35Cmm/AqvnYKBpov1FSVtSg9G8DJJhi8gltvanKWbb7pHP8GR0YL4M55HzpKb7M03V1tnIw1+WzRxRi3yimw2k4apoeFkoeikWyc1/wPLEjj7NOzbSiLRM5ioefNUvuWzm1oKgITsXS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(83380400001)(86362001)(66476007)(66946007)(316002)(4326008)(54906003)(426003)(186003)(478600001)(107886003)(66556008)(2616005)(26005)(2906002)(9786002)(9746002)(38100700001)(5660300002)(8936002)(36756003)(6666004)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I87vg6UyLmFkdXb8mh/drqe876zy+yHTNeNnn43awaaRa6b3/4K9GGuykORc?=
 =?us-ascii?Q?oO0xyJGCiKph7DLSpgOjCeZ/TS5GvyUtHeBsk5/gUGR8LvgL7XM3Tb0zOXPk?=
 =?us-ascii?Q?dpmf144wTIhRjqY9fqmnaXjbyvILVSLXi1Hm58GfPj0vSKsBIuzTTbdHaFoq?=
 =?us-ascii?Q?jNwNLPrlNneNv0ZPRQ257R0whOVPhjznfQrvTdVvKnw4IEOPvSdG83IBb/m7?=
 =?us-ascii?Q?RhI+iXdd2mQUy4P6eGHkWgJ4BSPIMNKMnYXaNnCsFDjK9a7djOigOdjUASfS?=
 =?us-ascii?Q?NgZX1IgxLqeVLK63EtMxEmlr8+VUn2mQtOLP1i+FZvyoVjSD+3OSs985DCLA?=
 =?us-ascii?Q?tGjx0JWqRtcQY9dbjrjlvWm5wG0QAZb5rhhMqau9GGp9y2XT0U/x6sSZRAIp?=
 =?us-ascii?Q?m5oXQ4JtcmIGoPvAXN0m2fDJYBX065iA3Kwsyc752ySR7Q7KKi+tFa61TzMp?=
 =?us-ascii?Q?PzDO4LMcM/cQkN13hBC5ISNJKD5B6RcmpWt8bHXaEpe2LRo9onH1OtE4M/ji?=
 =?us-ascii?Q?N20kyil1RJ2UfodrtL5x0Zzl2TtlRFfUUBUu5bGxeBIOKlzz8mgfsUV6mN02?=
 =?us-ascii?Q?E0s96zZ586kwCzBsgUvXd/h0jqxbKoKF3R8I2gmebMXBulnspWlXJODNz8Dg?=
 =?us-ascii?Q?t+jigMYqcFgHq4w4XkKE9sgysywRDG2iU6UcKvMGQJX+klzg4F9cqDlC0x/L?=
 =?us-ascii?Q?46Vzb9Gb4IBtryMQasJPnIK9BMcLaKg0PB0QpWAQoSO3g55sZ0TvgWP5D9dn?=
 =?us-ascii?Q?T8c6BiNZPaHLxR71gH4zeg03WdrwP4uOz5meJdD/YYjqyD2SiDJrN33DP0Om?=
 =?us-ascii?Q?/hHCUCpy8dKrd/za8yIKR10EWmgeD6a7Xgw+ukTSNJhZSuWZo4Ty7ALEfIMk?=
 =?us-ascii?Q?DIK5LRbbdFnv0VMfGBsXDcVI8SgvYh9RIR53M7mpSzQnOvwvWQP98PmHF8yu?=
 =?us-ascii?Q?iankvXOdwCRf3g3mb1qiIhk8/+EGHoGXOg4NTJWISndSnW3JjXguAB7S5e9R?=
 =?us-ascii?Q?pTY9I9I7WtNgiNr+FdQthkO5JUBRmbz+FKsNwHWlvpSNu0XZ9/zCRf1QNBiC?=
 =?us-ascii?Q?cKAWs/7mH0EiwgIH9Q8DjIiAIKMiJExN6QcErIbUOpct0Iv37FI5wgbOsvZb?=
 =?us-ascii?Q?E9HzHReUIzSasYtiAHMgXl7PwN1JvM1uOCsnrkaaODFFsI/MEFBWBoKKwj7S?=
 =?us-ascii?Q?Nemw/wr2QRw1J5FS2+E1AC6745g36byhRKQQMKdZXGhXRHrbC6ah58BfsH3M?=
 =?us-ascii?Q?C29Fcw0y1UiGiI1Jm+uxIv/s4uCeawB4Ix9vBmzrRHxla4gMDgCfrQHQbniG?=
 =?us-ascii?Q?53TmTAJUs7SMyT7Q99LQpBH3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76454c62-caed-4124-5652-08d8ee24de0c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:38.9286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FZ+/hfIqLOhKiYCA2CvLSka1YBewIfEoqb3IW2RoAIXnrpjQWTAlw3vu0XSj6KF9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a small race where the parent is NULL even though the kobj has
already been made visible in sysfs.

For instance the attribute_group is made visible in sysfs_create_files()
and the mdev_type_attr_show() does:

    ret = attr->show(kobj, type->parent->dev, buf);

Which will crash on NULL parent. Move the parent setup to before the type
pointer leaves the stack frame.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 321b4d13ead7b8..5219cdd6dbbc49 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -105,6 +105,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 		return ERR_PTR(-ENOMEM);
 
 	type->kobj.kset = parent->mdev_types_kset;
+	type->parent = parent;
 
 	ret = kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
 				   "%s-%s", dev_driver_string(parent->dev),
@@ -132,7 +133,6 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
 	}
 
 	type->group = group;
-	type->parent = parent;
 	return type;
 
 attrs_failed:
-- 
2.31.0

