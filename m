Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2BF355C5F
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbhDFTlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:00 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:54032
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235032AbhDFTk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfbPpJiat9bST4GziGqhtwNdaFel3xtWs04OhQ2BlNPaWRmF1KQvWvTuoIWd5h+0THupJIIMJrRqbpVBTBRIGPp0ayralr18pfp7g/28WOMoBSNTIAbUBx4QsNK0dwclMWwjQXseszv4itVZ16P/kaf9wFko2gyZ1w1QncnT9pQJH/sRhHGU6F0dS2lQqOxx0S+UkaV1MWukHDn00xRJ1mg4ffR3QGznXjNfRlwO9ZpUo51whypq7/Qs8jlTWB3tmwbuvXcpYF6vWnz9LcFDzUCzfPMj8j7J8IbkU5Fp3bL2UPkTuCktv1sprjlK/gP9DYMbdUHhypSMJYyO9jHUEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSRdrvt55b4sprMaz3bT72yodWqW13fHhTN3k5Mj700=;
 b=WkeQ72kSepRJP+WBFoZETwihhTuSfzak7A178B/p8ybxkLee1l0Lzm/3ewelymIj0JciYy2VJhbg0wypJWVeEdOSomgPrsBtdJvWIIOAY7sUKpD7QX4w0GZG/ZccbTedHHFRMw20oBQB3InUeBsYhgnKF7FNLMKN5iVEGOHaE48GGbGJN7wpPtow8Wxe0elwYprB10ry3G9EIdUgse8D0bLT6ZZNJaokzz0yZEQIMLq3otKn1OYMULE/STs7WIMdVcDEtpQaRFbBjPCOZljOABcG1L77GbI2J0XA2uAbOKn9hoNMmNo9aL4+4NhKrzNCKMAN7UNpaSbFx4e5H9TW6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSRdrvt55b4sprMaz3bT72yodWqW13fHhTN3k5Mj700=;
 b=rBMK04FATIgoAsWjseAOGg/S9qVBR9k720cVdpeN7ZX50O75Y82HkiC6ceytybItBtt6B3V1OWsOTiNrE9MSmCjBE6LYDXo5WEt68aaDg8zsX9apGU9oQBMopACwWwcAPkKUvTlG+rgHgW+NpYuOtx5xw1s/c+ghtX8+lBB+1/f3F4EA4oEjsG1Qq9+TpYwXzfUBLr1UTIkFahG/e0qC8VKF4PgbM8u3YDAzqwd7HWMcSgU6VClB6yB0/XW8IJUS38OZ4ePHtRq2mz/opaNqRpaZa0gyd6BF7HxM+8TkTJqdVeHwTEVKdK/8Pc5G8RVtwW6yelpjsU+ZsvKDipIJYQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3515.namprd12.prod.outlook.com (2603:10b6:5:15f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 19:40:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:47 +0000
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
Subject: [PATCH v2 09/18] vfio/mdev: Add missing error handling to dev_set_name()
Date:   Tue,  6 Apr 2021 16:40:32 -0300
Message-Id: <9-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR12CA0035.namprd12.prod.outlook.com
 (2603:10b6:208:a8::48) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR12CA0035.namprd12.prod.outlook.com (2603:10b6:208:a8::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Tue, 6 Apr 2021 19:40:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXO-6S; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26a95afb-d2f6-4646-333c-08d8f933de5c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB351556B86BDCAFBDA0CED876C2769@DM6PR12MB3515.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KlUZlGdd3f73OXZ9nddGmK7UqoSGz/CBjjxf5K9PkBNsdEszrJ3Bgwo5JU7SqnYHxye8Mrqt/TDpa8WtPPTYpdLs+7uZKNsiWWBnA3/jv+KgeOJY82W/rbOFGrELxpoGssE/fYe8DMXeqENwFsKJJYcAyrzeaL8y9o9cqRlY+YTf67U0UvNqfc2QWEnLPHnGbskGRT7nL+2P6xMYkhoV6uBOfucXOwf5wljLsNik9mCT9VCgvJx/YFYYMGnlUYr8Vvtm6dRyvrubytv1JZpqONvyKtYVe9MhdkNEQeUp7lWn+Nx1VLbt6KyThI9Q7x/+GSE78z3rI8whzrjfOuMfBqNIpYl4bzSKnXjtZyVcMVPgoHunT6/+9hm93qKEsJE/QUoxDuthI2QDdQn4IrtlWy/uGERGAdyr7eggAMjPmCuDshDhoA8nOUhV0owWZcllLeSNhks1o3w1mTOaWI2ARzTWR1jxpu1o0CgdRdZ8XMVdSJxxgpkK450j6oMnMTuaP2rrSQ/JfRtOZQrXZz9BIRSMdTzgEXHqu1DJM84adwrjBy6WhvnsoSRSxIIiAB0oNdK9a0cdSpQC+Drpo50+IjiUF/pra7oLKAX/9vLNRi+uHQsvjJnYIdz9MGJuZTw3IAa0ZtIzNnM+Tsacag+tQHVJnBvstnTEWct5srCAj+M1jTiIlOBP8HS/DtbTOTHd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(6916009)(9786002)(54906003)(6666004)(316002)(83380400001)(86362001)(8676002)(26005)(426003)(186003)(66476007)(66946007)(2616005)(38100700001)(66556008)(107886003)(5660300002)(4326008)(9746002)(2906002)(478600001)(8936002)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vz1sSPvxDKJ9iUijrVYYDjK+lZnZd/7u+BjvtXQoVpd7aRqSnQKct7y2q98c?=
 =?us-ascii?Q?qhu/KkVbsePiYsH1lb1mM3c7la8ImKyKumxeEsHYzNcIGrqWnJumegMj26m4?=
 =?us-ascii?Q?CXENTk01+YvDHBn4gjY4Jaz+8twtVLkwbcBmV556rndmTUUN7l/1YSNSmY9m?=
 =?us-ascii?Q?xmP3ejKjiOEjVkKTfXO6lr/ncIfwq9g+499C6NCry68MGy2ZYTe1NI95gkt4?=
 =?us-ascii?Q?5q5heI+560TEqIjBWYfnAlMy2BYaiGiL3k7+pMbmYssHLFbcAm/Q1N0tWFdM?=
 =?us-ascii?Q?wn7crRwfv1ooJWVX+72ro576taIhHCKP0BvfnW/JU6n5uUA2cXiAvqy1yyqt?=
 =?us-ascii?Q?kM65E9efapN3DR9VvXroQTDY9FjDVBCpwH58kE9HV8HG3HUu2YOgNkZTZVP6?=
 =?us-ascii?Q?OAuiHdZ/57m9kfsyAKl5MHWebWRfmODmyHghcmhF/MDBiJMWzYV3vkZjdFP7?=
 =?us-ascii?Q?OU0ZXWxitYUW9KS3xsmb0pBJO3EozcqiKjajoqyF5Ysd+PXXHePTSsz2lN+m?=
 =?us-ascii?Q?DqGqqtHPZIxybG/Y/KQmdvqMWZTfrwegGOpapqKx2dyNVPHGxz+IA1InX/pm?=
 =?us-ascii?Q?3NF2SohafJlVGMniETsfpYy/7RJ2dM0mYBo5TOoaSov7faDP3WaIoNGO+cx2?=
 =?us-ascii?Q?rsS9DutK0dnT1+I0BCsqO+QRAsrtIdTxRmjMVexzySN2KV1hT+wju60u35M4?=
 =?us-ascii?Q?sHs2SFFxT2LgQqPtCRYHzMojI3m3Qy3OFHIidSQ9qZOFwFKqFUSutv7eCepn?=
 =?us-ascii?Q?HKzPr2vtaYLMUtfk2LGWQ0HmEF/i/q3X7hD5uDb7BqAPl6bhMEAvGZfTPdCA?=
 =?us-ascii?Q?ISzWuZN4QVS3mv5WlkIYcdXkyIQII3jGSg0y8POffL6PHTZyV8Wuo8OP9xD3?=
 =?us-ascii?Q?X8kOj+aiCIpTgfnXznmE0hlI4r6ujSys3AO9EadHeUs/9hEDvC0kjboppZ4N?=
 =?us-ascii?Q?LJJCITTYpEOO0ID/nb0xP7fToNxfUDCWBd9vIxVX6DHLB1gaqyzOqG5YQ/5V?=
 =?us-ascii?Q?QuePYNR9p0Qhm86kzNQZqGEWUIAzV9meaRDldG3ZihoxuhxADaXCArUf4cp9?=
 =?us-ascii?Q?YI+4ALI5Y1lRuGvHaVzSeOl09JczSid6mHmg+zm9zGWNLZRzkqUbVk2ZOAOd?=
 =?us-ascii?Q?cHjfpaMl0DxpQUNq9STfc2MeX7hTaKwHMS+8SZIwZMvHhCyL3aAAKlZfakr7?=
 =?us-ascii?Q?aB2gNsjGLIQ6GZ1oJX9HOlgx2vILasxhJztbo0X3wQX3rm3zh+QgpuzaXl3i?=
 =?us-ascii?Q?NUKKHhwPZHmq/bEocVEB/W6L/7rO2HqsgaIR72E+hkdABQI6i4O+0t6lddST?=
 =?us-ascii?Q?rThIztLlsvOHRC45ZLWvM2SzL2RpRLpAhUF9YSR55qcIuQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a95afb-d2f6-4646-333c-08d8f933de5c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:44.3477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NOH6pqMxqIh0m2pY7+gUC5x1Lvujvfub89N+AFG+0GwUJ9wieQPji3f2I15gk5i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3515
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can fail, and seems to be a popular target for syzkaller error
injection. Check the error return and unwind with put_device().

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index f7559835b0610f..4caedb3d4fbf32 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -258,7 +258,9 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	list_add(&mdev->next, &mdev_list);
 	mutex_unlock(&mdev_list_lock);
 
-	dev_set_name(&mdev->dev, "%pUl", uuid);
+	ret = dev_set_name(&mdev->dev, "%pUl", uuid);
+	if (ret)
+		goto out_put_device;
 
 	/* Check if parent unregistration has started */
 	if (!down_read_trylock(&parent->unreg_sem)) {
-- 
2.31.1

