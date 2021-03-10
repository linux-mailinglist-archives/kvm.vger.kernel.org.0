Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF27833486D
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 21:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhCJUAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 15:00:15 -0500
Received: from mail-dm6nam08on2084.outbound.protection.outlook.com ([40.107.102.84]:13664
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230462AbhCJT7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 14:59:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPJC5C94Eh7vX+bLfk8vPug5rg4AdLxPiU1J+NN4tYGP4NX9ab68v04p8j5m29iyAYNXTxZLlMbQ3Gl5Iux0tpceHINcTE9UtjDqMdIaHnALKaQrVsXivSTvVsadWfZCLUK74OQkn47Bwd9TdRkYDGR3MZjcDRrcqHKfO/ohTmHByvL572+W+ORL/s27yt0PpWGUHqgq8qdb345A6nWaA4zq6MYLx4qGXCmMCSz3CK+R1x4tG+eT2tyGioDTpcvg12+A0r9TkRdXoNGmMpBTWsLLTDcXBuEeI87TXk7kYFJWNv2j1Gsv6EbQ3ZDXxwM1jM6/pioE0t2SzRmcZ8lI6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OppxuqQOA+gibYX7crtcdTJEuJQeJ450QW6OUq3Z/FA=;
 b=i6u7b7IdhIgfANUKIiuc/d1uHNcE1ucEYaeNR91yMa1Goqt8KW+DDxFq9erCXywkxLzSIi9rSC/LVWctyE488wBKY0hDgT7ZTpYGw5elKSrS4wab83BjlmxrX3CS4hKNlJEshuSNKgKgZsL1lhJaLO+NfWbW7KPAFuOreWxFRkywsKGLU+Yrb7NqI5JuG2CWjn0mRb8ohkkhK8XzKTkoSfYd6/9SzBMF19V5JCuVH87zpP/Bh3Gp0K3rPoGymdo3bXGxHPMNfHhRFosFkp1QfVWPxmooyxR+r2s1u0+SxfKJelSDcbfxKJfw8HK4vcSY0PUUn4xlMyA8/FZi9RzliA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OppxuqQOA+gibYX7crtcdTJEuJQeJ450QW6OUq3Z/FA=;
 b=AMh8NZyvtwFffdfDgI3sx3Z5vVWJQfSleeug9K9BJLhLTqvIg0iy7d51kkrcPEQra35WORG236T6wV1kSsTj3/3gDCOM0cZDOZq8mFGoHk6qd8qz7Pa7M+91vWIHqPYVsLSngPIcryDOpSn21CnYrQGz6P1QhtQVMUnjCY8gMkP0PupcFTdl6JXFKN1E4oNU/534hGYpb1WqvdwW4tkMEtwx/v5pie/9cCUxin2MgwGYcBw4YygVfz+R6QB4avaWAhwNbNiDtMzDFToTL5f+5fBrkR9SUVD4PVq/Qf29DOa93ATlCn6kZ4gdmpfD8d7KYxOHehNP1+Xsl+UQ1aR6ow==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3593.namprd12.prod.outlook.com (2603:10b6:5:11c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 19:59:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 19:59:43 +0000
Date:   Wed, 10 Mar 2021 15:59:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data() with
 container_of
Message-ID: <20210310195941.GE2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <20210310073634.GH2659@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310073634.GH2659@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:208:fc::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR02CA0030.namprd02.prod.outlook.com (2603:10b6:208:fc::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 19:59:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lK4zd-00AvDd-BL; Wed, 10 Mar 2021 15:59:41 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1f93a7b-794b-45fc-5f31-08d8e3ff0bc9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3593:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3593D646268EDBED3D93B7ACC2919@DM6PR12MB3593.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Cc565BPkJH4nMb7soyR40/LnsEhU2QS63u5oycxrwqXQ9A3bM8ughTSIIlVYFZ+ZNV4kFRnVJwOyaysE1FVBKLYdlmi2S8vop4FOIP0C/6LTj9VmQxjC6l9fvHq6wDZRuGx5pTuZM6KNcrVv1zKy+6hS/DIQ+3t5Wn/s/Gui86Q/EJd7JjROj3wmV3w5doeB/0FaxsWrXS/tD+oiKsBbUjoLGkNnofkrghFCY1LC/b7L690DJIWamTPcSjjwy4jJSSjcC0yAFKex8153c8gLyhRuazIG4hAiwoQHOQ8jyNVW2T52rSJ0l3dT0WRKYzadNeAp4gl0icngAR8bTvXWn+rQQ7+Kb3ZipBeK03SdZ3vl+weEq7koDF6cCAxXHyVSAxLAS3D4AO4XbigtgXeAKaFokdbUcBMNiHz66HOKnVgS6rcNRo/bcNjdoFzSpmOwXtpyJ9kQmxhmZQnlmWQ64g0GWGtEQAZiZGnxXD1FZ9ax1+zny7GHqtvcKbGs0sKRUYUgTo5HJUTUCubtG9WKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(4326008)(186003)(426003)(107886003)(86362001)(6916009)(1076003)(83380400001)(8936002)(26005)(33656002)(36756003)(66556008)(8676002)(66476007)(2616005)(54906003)(478600001)(9786002)(5660300002)(316002)(9746002)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pSukkHYf99FB18mF1l8/1Y2/zo/aa9vX7jNw+/jbuoSH/3tQO2148oTZm3Iq?=
 =?us-ascii?Q?LpR9+3Vh8sehduNPYcDjfJDX6a81pSkz4k7j6bW8rRRIxawbjrZxajTEkRGJ?=
 =?us-ascii?Q?t9l9XQUi1/lypChbnNjq6iK4RetFKfce0eWB2n2MAWE8GkCIIe15dkMY+bN4?=
 =?us-ascii?Q?OBQnVtQYWEMHJVeZZmSpPoq5sTP/AhW7Gn8gpqfzJb9y/NM9nTOHQdigLQt7?=
 =?us-ascii?Q?z7G6PZBdFlD8wjtmnzE4EkzfDU67upBkQZbf+2tTYzrzw04DRkjHQ6K+0b6Y?=
 =?us-ascii?Q?FnaQUnNy5699fyjgm89J00Pv3jbDrR8kGu3lU2sghBpnhujxwREUaDcNX8w9?=
 =?us-ascii?Q?xF883eQP6hwEWxS8WXhNvoD36y2Ua+CFstfc41J2HJL0VPrTl+2B19RTs0Lc?=
 =?us-ascii?Q?WhdzLGzsg2j8wb3X74V3mkz0102KK/0nrmT3SzkV5eGSNeM2jQtwBmvZj027?=
 =?us-ascii?Q?Qimt2f/B3EA6AlnhjNYVXsBNtQ+FdY+gPr8XC8APGHW21fWgqT6yuGUardb6?=
 =?us-ascii?Q?QSF/zBzYTmbYtYMg6IdVFgSt8bzvpZR2V6TLDl1MlJ4O63Lni1QmiOmfNgKE?=
 =?us-ascii?Q?ptJqM8A8KynPjdCMCdkfi2F4p8m7+SnNjVJZm1CFHftMcXiEAaSmn0BVh/Oa?=
 =?us-ascii?Q?9t1fqb19I3+LqrAOyRc3ysOI+js05jw+eZCBUhZsWEY7Wh13akp/ZlFXfO3U?=
 =?us-ascii?Q?AjwljWt9rDr6y7FZJ4CPN90Z2fW1JtTmffkF63S0v7IJrdKNDpnjGNiWR6Ku?=
 =?us-ascii?Q?77thOK1fl2jWWRw6qbeer8OuqMpHQwnpPrwmiE0pUT4wbd0x6mDczOSHjFBf?=
 =?us-ascii?Q?6ApdknBb1wWfAZmU9LY6muzpqz8w7SLJTwomMBCTyvdQRacwRWnlfu9MV31p?=
 =?us-ascii?Q?blQ6SFe6tBmunDAUGrmWBBlpRYCVzLy/2t4Mc9FDy2Y9fOuaOvgmZikysVbO?=
 =?us-ascii?Q?xDLvyDniwxekT6f55cS90+wjTcWRbGuQePZiFVJyJoIuCCY6DH6GNe6hZSCl?=
 =?us-ascii?Q?gVZsaiLPS3mmil+wr5CDHYKQiyrs9o53t3Xp1fh2H0Wkhsg5U6HzG4JgMClJ?=
 =?us-ascii?Q?n966i4GKCfrWywhTJ8rVPksBFiiulPQaUYMcOO7wIMylv1RME7nJZYK5PyVf?=
 =?us-ascii?Q?6O20dRYsK4nVbQMWMop7wx4wvLLj6y6TzTkHdI8nbnmtVLXziEOLzycwTLtl?=
 =?us-ascii?Q?TiBn1gF5EdO2rgzlBP0I0F5Md9DujSCmq7pn6Ml+/MO0wY7JMAFVSDoz+9gh?=
 =?us-ascii?Q?xojEXmVsFS0JjxyvXrt5WFYabT2sP97Pp+8WzSAESLjJYzO8HysWfcB/dAsZ?=
 =?us-ascii?Q?6Xz2f1fpEAgRmDYI+DM/g6KEPN346yFmMM4a5zQFn9wvLw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f93a7b-794b-45fc-5f31-08d8e3ff0bc9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 19:59:42.8936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MVfcALfup2x+iAdc3+4c9eu9Z61HVAHRcj5eYtRxAE3fr47lKNxg128gTW1XReHi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3593
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:36:34AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 09, 2021 at 05:38:51PM -0400, Jason Gunthorpe wrote:
> > This tidies a few confused places that think they can have a refcount on
> > the vfio_device but the device_data could be NULL, that isn't possible by
> > design.
> > 
> > Most of the change falls out when struct vfio_devices is updated to just
> > store the struct vfio_pci_device itself. This wasn't possible before
> > because there was no easy way to get from the 'struct vfio_pci_device' to
> > the 'struct vfio_device' to put back the refcount.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/pci/vfio_pci.c | 45 ++++++++++++-------------------------
> >  1 file changed, 14 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index af5696a96a76e0..4b0d60f7602e40 100644
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -534,7 +534,7 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
> >  		return NULL;
> >  	}
> >  
> > -	return vfio_device_data(*pf_dev);
> > +	return container_of(*pf_dev, struct vfio_pci_device, vdev);
> 
> I think it would be useful to just return the vfio_device and let
> the caller do the container_of() here, maybe as a followup.

The callers seem to need the vfio_pci_device *?

In a later series this function gets transformed into this:

	device_lock(&physfn->dev);
	vdev = vfio_pci_get_drvdata(physfn);
	if (!vdev) {
		device_unlock(&physfn->dev);
		return NULL;
	}
	vfio_device_get(&vdev->vdev);
	device_unlock(&physfn->dev);

There is no container_of here because the drvdata now points at the
struct vfio_pci_device

Jason
