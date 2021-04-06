Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94805355C55
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhDFTk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:40:56 -0400
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:17062
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233580AbhDFTkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:40:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSRq8ufvY5FLLF3OhLNODvrkjymq6zz0L+Ey47AAv6K698vxlQDSPYSZ9xK71cf13vI0rwQumrurYpatuuaFlAWHsZJxup/7Hb0h1C+U3/SOlG9CnBPYaprdf3BRWw53Bhosr33gLirNt6PZFBCTCrcL+a7gXa0QZv1AXEzf0djCvNGOdSrs0SEXkSHNrBL6esSprogpyeUenwJ6fUmqfCwWPrO7C5sa2oawGokC+ORoQo9EgB8xEgBMS1CzXG+A7KRIZwmtaS8EGb49wU4Oau2RTIWyH3mr+LMpJtQUZMLHKRdqm8MRyQikar0UQUYoH+YLrbZFXru+T/e/mTQ1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOJWN4xU4gR1K4Wp33Z1KyHP+Vcgdf0li6vbPshndkY=;
 b=jkQHiYlhTyyWMHlCojc7m9wAVa7f9HMtBaCDI+T5qNFbWdABlZDgCYREeikSjzxtoQpGLjYm/Vepq4NAy62sUEoiUjKrsMV2zliXNg1xruMM+OWg5qdZlKu1awaOVpxGIuZzFlEsikeUZO5ttZV/DRFopH9WS6E0Bz9dTIqzlWW/FwRn5ogtFr24303+msMk/i16prR+WsMx9ovb7UW0qn/SYezdsdhqJzFhgwqzWndjX/eE2tUTLv3US9QMYGEkqnsg1deg4mcM2f+G9bmWhif8JK/kLZHW1+/fb/TeUDREQhXsTEy/nMyh9bGDWTP6hm/ab2E1IbtyV/90O4PgdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOJWN4xU4gR1K4Wp33Z1KyHP+Vcgdf0li6vbPshndkY=;
 b=IAMZXDySMxdx0wfMx9g73tTh79GULDbd0/XOO50JycdpnG61Rf+JBgrE1fbayLbAh6EYViBInmnyzeK/+QxYHmqNxGVKspeBD6M8dhwsn+U8g9dXG8vR7ia8WR1tvyZGqIjeg2lwVuPg+fM/txSRGzcbNqZdxPFFL8lS7T+0GF3vVkjZMutlRYMUwzz15dx99WzdTNUemymtf82eGXLQwBlbfFEuAWQ1/2fPek0v719lmuBtboKSJnH+OkLDjUQyCPQEnFFXsck/lRxvWy5xBdrf7rmBSAP6ki6M2u/ibSEeNrc4roxTwEEWLPyY3MQ6Whq0KthAl6FPa8izJ5vt8Q==
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
 19:40:44 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 02/18] vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer
Date:   Tue,  6 Apr 2021 16:40:25 -0300
Message-Id: <2-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:208:134::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:208:134::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 19:40:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ3-001mWw-Tc; Tue, 06 Apr 2021 16:40:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca04e93c-c053-4ed8-9ee3-08d8f933dda9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2859:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2859924D6310079496B7D2DBC2769@DM6PR12MB2859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWcKZaDywqUMQJs3qgdKJyGyfA/In3pqnErG1vmRnP49RVszkDMpK7LxQndxavP6GDvUhlw8f1QdKmqDaow4GKIgEUI8pHthXUfU+OfsB2N1/x+5LRPSvLL0nXTUSmCLA2OXpjTRnvY2Yr1PgX0Do1xqKVXvmNhzyUneUt0uZBYAcitzhejBaJ9M7/smLxqYtQOpdM0p033kFXorv+XKIHg/OM8xguuXHqW+1PWkJn3tsIGzehtHEoBLvzVvwMFS7AurzkokaIqOH9PVcGxzHTo6U6SCJRevwzBX+DNEfUC02sYWKLc0OJJPAW6yLQljVoTyxmI2XNRYBbm3lboftS8zDWeUFvLwIvHNt6yEYkoZndSTRoRRNrxkRa6ovRMtAfHAv1GJb4xMDbgy4LCFf0VD31xUMFzHuqehYwxa1siIufpbmHlJaddTwARteiyJsz/1xg1VJDRyhdgKKFFTvEVYjkrSqhecFnPHY7WX8Gc2CbYntzXSYuC4wOJsu8SO6+jZbqaYRAtAyyXsV318qj0fZf0eAi1xBa2IryiqGonrh8go8cLLGvTHtlnZWREihBocW0ZNo0DVOT0DcUhsRrJ8I9qVFAcny3B2zJPpXH0HQyxDhe8r2hMafBMsQ1cYcFpe18XjH++cQ8tLbMPr9LMynEthAkipMBQpdlk51zLAUKu4+1yBMJL6rEwvD2V/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(54906003)(86362001)(6916009)(2616005)(26005)(8936002)(38100700001)(66476007)(426003)(66946007)(5660300002)(316002)(36756003)(66556008)(2906002)(6666004)(107886003)(83380400001)(186003)(478600001)(4326008)(8676002)(9746002)(9786002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PHuY36xmkiTovtL2g3Z84ups4GO9UH0ugnbX//Cyz+g5Tr0F/HlPV0qd9+VB?=
 =?us-ascii?Q?9EoPEiDGEYmqJTaT2/VuaJr4VTFQSkVZgthp1wE73/ltJzM2c1iZL2W38rdC?=
 =?us-ascii?Q?JRFtRw2aVYZSovF1NhM39kW2JQukFRvw7xJ9ZWB62BguG2/khxLLu8l4QlZT?=
 =?us-ascii?Q?hoXO9PUzI4K9yKHNfIPmT6UGTqCrlbowVCWugjpqneXKlb05UOobUYbrB6YU?=
 =?us-ascii?Q?b30qu1pizvgqKtm6HsHBzDnLlKyHRxPS3IOVpBcgODqtabnxfJ3Kfy9S9Itp?=
 =?us-ascii?Q?8jBIdtd0c2/fE4UAv9QIIaBx73ZMisc9OUOMYIaizHyqtUfgozlZiuZRfbId?=
 =?us-ascii?Q?Nf6M0qnJY8xuTJmy0qe2UmvVMvq9Q3YMEY21ab+TInb0bDNAuLx9Z5Vp6ONG?=
 =?us-ascii?Q?e8saRCBwKqkUbQrtacngp9ABjP6BAN23g3i+AXiUozWx79jlJiDS5TDcdvDM?=
 =?us-ascii?Q?mgucWKaG/39MMs3/uuUDy7r1I9XB28GXb+xOtooriI/kCIV0N/Gr6aicfJot?=
 =?us-ascii?Q?PIhvgK6IzcLynXm3VAfgkn3p/yZpZ+XzdpTQLEc//24rzW9zvz4uKqAtjop1?=
 =?us-ascii?Q?zcJ4XpN3kI3w+6UMr1z+Qf6d2Y0nAAsnzv2KjcgkCN30Kx8HF/swtyH72/61?=
 =?us-ascii?Q?vbk4zTzBRE5TY5ELNYvyjxCtzjnVstuqfo8J/oUGDyKVIAPUKRs0//+tPNVK?=
 =?us-ascii?Q?L3vS/PHkmZgIiBxHEO4kC9ECvj/hyfLG+ywh9HII0tqk9CV0D1IR+zNSl42N?=
 =?us-ascii?Q?a5CRE4p5mmM63oUERL3fWTGapbHDNewvln3H8p6eI/wXREDHQcOKAISXsq4V?=
 =?us-ascii?Q?kkFlAucKN93dRfAz/0RMPvkqeAt/L2Hcf04UAwYMU7jgyWAEwSgwDBtXf581?=
 =?us-ascii?Q?+lniL+CeKWssJfBDCAyOL/c/eJi/VkT+4k8a0AjV5P97Vn0u+l+UD7oHcIUf?=
 =?us-ascii?Q?ZCy7HSoU+uykHzsi43mqzI6bLwD69cfiNzlfrDe+vDTNsD93tQuvHjWQbqBD?=
 =?us-ascii?Q?9X88v+VwrOVDiNBt41ccxazk10ihPI/dWEZdNeGQF3BUxhkHKpL9eGcdER7p?=
 =?us-ascii?Q?FTmc2CO/HtDqgtiag6A9bk/omfr3Ow15mdNGDnSgX6wXUbcQ9F4PxfRFX1XY?=
 =?us-ascii?Q?9sljjsw7I0gezekm/6lVqv3tkfglcrVlvqGMKlrTcFUMiS+a+q1YahMPcgUE?=
 =?us-ascii?Q?sLR4fgnVSgpUdbMBWmhcJIg7vXXZ30bZ2nVP0FprupVp1tK/g3HoFYI/fMFE?=
 =?us-ascii?Q?SRvHvsxlK0cLLRk0+5U+X1cTY/PeBTVaKrUdR1Wmq72uLiF7So6kDmZmXcoY?=
 =?us-ascii?Q?wc0bxLbKhIPA3yd4tLl1UfiCQeX/EWVt26KzSQg1wj+Rvg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca04e93c-c053-4ed8-9ee3-08d8f933dda9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:43.4712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HS/0YhJGv4ysAj/xd79sLN1JZmcVdcPolAncNhg79FMsE1q875XRSuTozHq3I0Zc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2859
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 917fd84c1c6f24..367ff5412a3879 100644
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
2.31.1

