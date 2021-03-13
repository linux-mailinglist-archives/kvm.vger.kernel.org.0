Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9050D339A8F
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhCMA42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:28 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231392AbhCMA4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPKlTNquvLPyTr6soZsQ49l5h1iFZ0+zqCgS6lR/CcOVvFKc5EU8KrXZ1WMNPNaUljO+AEaSNRNcBN3O7IxuCk+aWdjjE4HLbapN/qLRU75hXRP3BDw8iqhwLhJc25IChMx8AM4aZjGvz+dUffnZEChr0h3ChQHB/zimxfiQWgnsexFmQoUizWqNwlHwcdGPy6JqFB6m+FSeNF84pPaoGA6q5tNjdh/s+fPNiB7LUeyWsb8yVGcI+/NM+vqMnB58CEoxum0WxOtwk82oFWutXRIjQwR2u0QuU6avAo/QTQ4WMFLXiMrLUh/PxlNYZo/RayQdm9uo5k6ZhkbnGAgR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kq5MI6b9VsXsCqUmpGxv/WkQTzaKh0okG76QDxbkoco=;
 b=cCIaCAQGsyouWSXdO91DDqIh5w0IjEyXjJGL85VyPGNzrMLGCTW57pSvsnj71tNklDut1wCMgZJO/HFv7yEg1hLe460QDq/nMUxOsIFOqHjzNMfkAQtFkB30iDF1QvSf7U1ksmpqu45NYrKtBwVh/CdFO+0+i7knrGo3q+u171Vg0hWw7KVhN4krd3sagyCQoVWpPnAuosf9JKHWGvXNphyUc4kHAk7DggW6rNCPqYPlW36TC1chzNGPlzA9i3Gppx3WGlfIjD9vOL/p3eI0LU7jluBdRZiE0lzMbPyhxgevUV2XFGnm2ZcPlGZdgc/qYHJjP8p2xC1ixduLcFJI0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kq5MI6b9VsXsCqUmpGxv/WkQTzaKh0okG76QDxbkoco=;
 b=WVSk6mw3bH6JJE9bL2SwaIAtFywrapkk04fff2ev5wckHtHzt+lrH/oY4/2xt9+vhCk0xFIyBwKdQ5LugyduCdYuxUHJslMWiT7fqFavd7uxYUP+XmdUnKFB6xVO64sZ7NB0HRam0DFe7g5xQkGRE48v3jiVVtXC5CPbcMzNIcDTeJ/5xrUC/mz0qng/xqgigDUllXs05OOrPXlwqDEteBPwRQCKZTFhFXIE1VV5hg8wURoV4o2VejPim4+3cf5XcAD64QfdvtzcMU19GbkhQKq318r6JdduJBVhpIBHQfTtocpydL7+OmrQchxAB8h7aVfviilNfZv6XUdsm792mw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 11/14] vfio/mdev: Make to_mdev_device() into a static inline
Date:   Fri, 12 Mar 2021 20:56:03 -0400
Message-Id: <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:207:3c::44) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:207:3c::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Sat, 13 Mar 2021 00:56:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBP-6Y; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f755b11e-9683-4a07-4abb-08d8e5bac98a
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29406790A83AAB0552710BCDC26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MawNuEoxY1euwK/ZXb0v7T0Z00IkOyjj+EbfbnYyiJs16QIPMjc1ygjitadktnPL7m9NJTG8nJOf2xk+glLD5sUUVtYs06a/K10iWQkweLnSjbi9YY383B5limgMeeg0y0og6XfJrZrDyA1GoVPDpIAk4b1iU25MOJ3S7O/hHLBJfTApOQZIAlIbaGM7wOw8AqoogpcrpU/3DZ2+B88aLKTFvF2mcRpGlfeZU8O9KsvScocNVUyniW8Lliqcpa9HpS/5mx+bb3UKsFBl+gYN3ZxxksWuJTHx+uUW3bBO2MwdEr4Fxo0OO4SngwlZD7yh0kPwByjrMo6XqrBIBj4SSgb51zrUhoY9849D2IpgS//57rWMwr2AzBjeTTUD7GM331kCf94hmyRdMRiijZwkh0UmeOtLGBJs0cz/E77ud4Lb4YfOVE8413Mee/5lEOh4tjTdplmC0H+FTRVWORTlMsCdOrjApormSM71NAx7roxuNfBNo/6tgBpHccrfHpFEi7sbSogroNiZdgjL0aciM1k2tJPtjoO5nApD9L6S2hm054YRUSJgdJFjBJ00F3mu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(4744005)(36756003)(316002)(110136005)(83380400001)(66946007)(6636002)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rquMVKlnKJ449viIrtI33LAwHyPgGpLnucILZHYeBWnf2SBGXvHEmq9tBZj8?=
 =?us-ascii?Q?dB8LQUo37KSd/WpEAoC7QPwFmYrmmw7NVRtDFUbpxpMfedxlkEBaQKBpX16D?=
 =?us-ascii?Q?DOP8tBRvfcfyOjTfp/gXpV7srGK3HrPAuq6ahsEW8NCXuN21npkuMWuaf3Ta?=
 =?us-ascii?Q?qJvGW3tBLQ6ZgGtdQpJrwHxwutMT5UgbOUh8uUCbymQFJgqlYdgC3wj6OAAq?=
 =?us-ascii?Q?2+FgTW9UVC59AENun6z9HLhiPmbf5xotjnc3eH4bZpdSZ3VdULa1Ayaoy+VC?=
 =?us-ascii?Q?B3LYDMrSfzxTPw6nylyiMIWs/aha8CL2e04fun5v7oAZWEN4J7shahs7ZM5+?=
 =?us-ascii?Q?+v0rKGJUzHPDsp+Un7s1zIbXe373OiV/pX2omZuafhCUAtWNwP6hURfqStIX?=
 =?us-ascii?Q?ZzJFPh6F5WfHq94y9lbeW7WyMnzORjjf5dGjuyVMuiTY4jxG8IG4d876JEuj?=
 =?us-ascii?Q?+2Z3d+9Smqb9lo1bax0ijxT3h+PuEjn4yL52M3ItJdu53azePs1Daf+/4ZRb?=
 =?us-ascii?Q?o6QwzkRNaHKM4U1OePF5CA488LkWIL12aHI9ESqDfWfoiQcIPF176PhhzO5j?=
 =?us-ascii?Q?pyIhW0oAyQgyoe/m5DGOVrFeoVDqHOkEiThjMupfscUEe6/bzyt2ug6SFWgX?=
 =?us-ascii?Q?mU7zaJfaiI8yBYwQchooa1R1uAIs6rnPk2DibxwNDR/Ojpfk9TeCdwHF56l9?=
 =?us-ascii?Q?MKmwDFHPrEVQEdldqT7zaUv3Ldsk9DH5b1SCkqCxxynq4+EbETJk8I5lITar?=
 =?us-ascii?Q?tya9/++rcuaXTM2oJ9Qra8lBiYD3lQ655jt0Do+7kb8yxFnT/5/O6NlK+JM5?=
 =?us-ascii?Q?jtsjXUUuxdMpD2CbHw+2Lfccgv0a6OFvcLpAp7KgOdfxu2TNjlqtb6yLoy0H?=
 =?us-ascii?Q?JH7PePT+z+EttKaD7srIYf4bjlDBHDNEeh1sJQ/HuyV5/xEjSfmEfF/PyAxM?=
 =?us-ascii?Q?XK/l9A7cTZlVTcq1IoNrt/CIQduFbnDlwAiTnSCWKxHo8NlQww7MFvB90M0n?=
 =?us-ascii?Q?TWNn37SQgbZLb2rZAhyHy6OIwIlhnaVGwqB/DVOH1fbFzH+ASjnPItgs/lMw?=
 =?us-ascii?Q?KxTec8dYtnG0URS9NUltz9pJE28nrUDc7+KCZOX1P5BS2hGZexEzDKX01c7u?=
 =?us-ascii?Q?JSfHvmHFvntIFBw/XK3XdiSlfXsS0qDkks203E2u1iBsM3dwOF83O9tb4xrY?=
 =?us-ascii?Q?YPlcyrcqfDP3JFZzKxMnXi0ISqIc2EF3Wr77rCwvAP9+gkp5MeDHl7OLgFKj?=
 =?us-ascii?Q?WReuBpo6GVO2RS500nzeoV6xonLwAeI3IbsBhHEAdZwLwb61ioiy7S9W6FGB?=
 =?us-ascii?Q?C01Sb5wMcWMeuApUEQpcOa55qS4qLcYeCwoulKCQe1/F5w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f755b11e-9683-4a07-4abb-08d8e5bac98a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:08.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZ9AGUbIxeHXWMH+rqiNECzj8yzmLzu7c2rVwH/r0gejayO7tY1DnggYAtbbL4dO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The macro wrongly uses 'dev' as both the macro argument and the member
name, which means it fails compilation if any caller uses a word other
than 'dev' as the single argument. Fix this defect by making it into
proper static inline, which is more clear and typesafe anyhow.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_private.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 7d922950caaf3c..74c2e541146999 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -35,7 +35,10 @@ struct mdev_device {
 	bool active;
 };
 
-#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
+static inline struct mdev_device *to_mdev_device(struct device *dev)
+{
+	return container_of(dev, struct mdev_device, dev);
+}
 #define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
 
 struct mdev_type {
-- 
2.30.2

