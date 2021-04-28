Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7AC36D95A
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhD1OPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:15:36 -0400
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:1984
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229588AbhD1OPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 10:15:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/Li7czjmi4Bgofi+UVqnzMYimUw1OVg8p3kpqx5Q5DncOOr3SPcyLI6SupN1f3S8Xrp0m8ZvEx1cs6FruorzB/cq3/blQ6FxeNKyBi95iGb0230FIgDAYLs8xtQ/i5JFP0OdAiOUzyPeeI4CmCbM3HEcPDFfHOzvIk91dnmYmDe0cR64RB9bjPlwnw/EzDKeRtUROa1tfwQr6y3kRB+si+Fw+Fb1nLPxYpnPHjM/y1WNP20iNqsA18urzGnKpE3BuyhepqgiBSyJCAA/Ap7B9QCWurKTr7hJHYDEaiVZXHw0LhNbQbJlBI/VaYX0s218r/CPcl68T+eZnhDrzcTaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCsBcpHGspe89j8feDDigotPIJS0fgUnCxlFIVDCKL0=;
 b=ErbfIBC0fbv1b3i7Vo9RjYua9xlH5qU4FgxfBPCDwrUrIf8MQ3mT9YbzBgnnhmj+cN2Bvg4AAmCQd2hn74CoT1m5s7Ypnpobd9cENqk726Eb3FVRfO88s5BV8ozKEapULmEFrKA4N9mu9gJIQpN/DgUD5oN0x3PAdsiKd8MczAMec989q8i27RE02+bFooWgiVtLRTvdEfyGEUZeYjN1e36g6wmT3kLnvXeEQx256WU/vg1TguzOOBCui6LO5s51dVps0XhCiUHBiixEvtqRNgwAHuPoC2mENKpe3l8auhXyTXK8or66s+cZzpEkR0vvXQIzCgl7LWsnEuqif5JEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCsBcpHGspe89j8feDDigotPIJS0fgUnCxlFIVDCKL0=;
 b=bfYrmlHYWU6exTTgDx90FU7Erxs/CdsGQfkmAhTfUQZItDQ1nJaq2h17C9V1RFg5Dpu3bDPXZhlM+d95lYxkfb9G0iuzW/HsIcZXlj18/RzKJF/Esm2m+cmBViHc8igjxAmE6WAUaMRZ8blrqcK/7NypCrjCPTxiwcfayO21hAG1Enlp2tRb+r3MaTdp0XMq27oMo/8ADhYLb3FNS1RXPu+JOBZ7dAKooZeVsRmMA6MwqcHqNs7j1ID9wdJOD9j34FOEGlxUiG0oXJxvwX5iErPeDWhgbrgNYQ1JfmQbWm3614bAn8PRSWli+qz6HU2+XuTudhkrg1PPw/a7yODbwA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1660.namprd12.prod.outlook.com (2603:10b6:4:9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.25; Wed, 28 Apr 2021 14:14:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 14:14:48 +0000
Date:   Wed, 28 Apr 2021 11:14:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210428141446.GT1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <YIkENzc+9XAFPcer@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIkENzc+9XAFPcer@unreal>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:610:32::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR07CA0004.namprd07.prod.outlook.com (2603:10b6:610:32::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Wed, 28 Apr 2021 14:14:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbkxj-00E1mR-0H; Wed, 28 Apr 2021 11:14:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32c75bfc-1a48-43d8-4b0d-08d90a4ffb45
X-MS-TrafficTypeDiagnostic: DM5PR12MB1660:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1660B6CA779D75E89FDE32CDC2409@DM5PR12MB1660.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VeaODWfliOhkTOxGCxr4by7fBV8rCAKnJOZRaDs4nSxaduC5/AIksKj3EuAlieM6LFl9fY8PaOTmQTfg5gpT9G0WYiGusd2hkiNJfXS6EUxu4vMSmWty+M6oVcg3BX4MnOiTphQ1/Z1SQ1CNR/zpCn/DBfA16F0I7M2CuYEPx0LXzgm3lmGCxpZ21nxdJIkRFC5Gcae/2dPViA3+bIo0l5k+VFg5tP784JaBi4zqAs/WTp8A/nvHuR6MRqdTOrujwRiWmew8kfxucCZHcjk3Q4+3HnR0osQVTL3G8JqnYhLivrKSYn9Ntub1xBDYA7C/RHMgXqLgP1JPehQxKcVkiR09/CHtFgGIASoUiWXLk7oVJbZqcRFOZe0bSwTkzpnH84K8MHllzKerbdV/ICzZyGIf8IgONwMWlKLz1c5UvVUF4/oKqFih99uyC2rlfx5Fo+abGAXaXS0alBdSdcW/yWEeq92LorormJPaYMdM4zX7ROtvFg3x1y1JFKJscIJ6bMCawQFuJP9ry4Bp+91j3YfKB11PuKsBAkurRwfLgdrcGEWGsgrGp9axB5Lu6gI4wqZ6rA+4Kj1Bi0saBe/laKcktT+rTv5dZwxYRBVaVWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(4326008)(426003)(2616005)(316002)(107886003)(2906002)(8676002)(9746002)(86362001)(6916009)(9786002)(8936002)(38100700002)(54906003)(66946007)(1076003)(33656002)(186003)(66476007)(66556008)(26005)(5660300002)(36756003)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B0nShDfzTw4wS1uOi8f57DVnvGR941uGA8H4/tjzaiPn5148LFRUbBMsywcp?=
 =?us-ascii?Q?2qfAiWnDsibWRcGf/C1vilxq4wtuEg2vQ3IRrH5heWYWx5ZQO54H3WBvyD6Q?=
 =?us-ascii?Q?Ln6dgd9yEbBHcvLjKo9Gs3z53JUjuyx5f0bF4k4REoNzKYadW1C72yg4CU8c?=
 =?us-ascii?Q?1SVn2Hoks25HE0D796DBA0sOmMfXpp2clBi4BgA0datR0kYr1/zf45LWQ9Od?=
 =?us-ascii?Q?vco5/bHMlFkzbVN45qANauA2BcwOVYq+8Cb/iT4CWJzWjmA6SMKdgJ4Htl8j?=
 =?us-ascii?Q?dNysA8Qu0kiDYFgdIxzX4xGmnb5a8+gq126w2uudf+W6OAMllEWRpllgc/x+?=
 =?us-ascii?Q?+cfuwvg/xYiLgSGk2G/aShWApBJTube36L4fMBg82oGdyhVHgNqpAPZtgoKx?=
 =?us-ascii?Q?L/KKlbkjbdyhkWGp+lNEaCqE9mg4G83Q/Gjx14NrfxwnClOCgKWYFheNniId?=
 =?us-ascii?Q?5FzOyXK6whzlUiyePWiVQ/eOoDnaFjUt+GVd/QY3NHKsvxiaEr4FeJmUvvsO?=
 =?us-ascii?Q?iR+yM6q6QWnxhZDTiJbHLxgcgD2wGu+H321DK1UlDj7bq7cVeV5SAY2WhJRQ?=
 =?us-ascii?Q?RBfR9c8yENqAgs5+JWvw5LLHqyIHxCwWtNdyBLbtDn1He6N5bvjxx7jA3rLn?=
 =?us-ascii?Q?FJ9JFgms6N5TKxsgfyS0+/5TERjUkOuaBOAHnqGOmoWDcIKKqEfUWmh6zP4K?=
 =?us-ascii?Q?mENb0lcwoApzoCaQXWPw3n/c8kAsaj8RpWRZopxHOf82CXtqQBz8VqWQC1tI?=
 =?us-ascii?Q?pkfcfl8c5SvPnOINWs4qxX4Xc1MfmU7APvkx1OaGRimtZTo+KhhKKLrejnWU?=
 =?us-ascii?Q?OuDt+s9yQgZszuYs/rEBrI4dku4G0QhLIw3TDpo3hSNU9+BlQEzhFynTqloe?=
 =?us-ascii?Q?Zwfx3O61L2f4hBmh0bf7tL6Aa3I4Nve8+i9FIQphOhjqxHDPm0hD7iyNuowF?=
 =?us-ascii?Q?iCUykODEEuSgczJxK+jooOrNtbjSfKUGvQlvG3YI68R5zL2JVhygygaVKgez?=
 =?us-ascii?Q?oEW9oIbCDcNsAa1Ndil44+q05gnUMeyhQ+NNI2A1o9emX/+REp0/FAnSQZkF?=
 =?us-ascii?Q?OkiiWcMglvywtPQPm0B+Wxv+1mjie4KiizCViBYhxQ+7D9bZgKkmGaFDQuLH?=
 =?us-ascii?Q?O5aoSsfzQkgMh9c5VX2lKaTEf/ikztqzC+K2qLKsxPbq7ISnwBi5qVgzeeP9?=
 =?us-ascii?Q?iQmMi1YjTEmGdVE5hJiD0ldFHk7pjFD8TZoM7fcJDf3DrugwZ/UjFncuAIX5?=
 =?us-ascii?Q?6MnlJn2aYpLxEKQ11wRa8pV3mvYEBjPMMPGdA+0KnMh+hVHfwbmIVsZ5wZsc?=
 =?us-ascii?Q?IuA0AltMH0PJqund0If6l636?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c75bfc-1a48-43d8-4b0d-08d90a4ffb45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 14:14:48.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1roswa/PNrFEq665LwNAFH95+PDeRzatd9cHxWjiMwKf5i1StWGVvh4ftfSUnp69
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1660
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 09:44:07AM +0300, Leon Romanovsky wrote:
> On Mon, Apr 26, 2021 at 05:00:04PM -0300, Jason Gunthorpe wrote:
> > This allows a mdev driver to opt out of using vfio_mdev.c, instead the
> > driver will provide a 'struct mdev_driver' and register directly with the
> > driver core.
> > 
> > Much of mdev_parent_ops becomes unused in this mode:
> > - create()/remove() are done via the mdev_driver probe()/remove()
> > - mdev_attr_groups becomes mdev_driver driver.dev_groups
> > - Wrapper function callbacks are replaced with the same ones from
> >   struct vfio_device_ops
> > 
> > Following patches convert all the drivers.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/mdev/mdev_core.c   | 64 ++++++++++++++++++++++++++++-----
> >  drivers/vfio/mdev/mdev_driver.c | 17 ++++++++-
> >  include/linux/mdev.h            |  3 ++
> >  3 files changed, 75 insertions(+), 9 deletions(-)
> 
> <...>
> 
> > +/*
> > + * mdev drivers can refuse to bind during probe(), in this case we want to fail
> > + * the creation of the mdev all the way back to sysfs. This is a weird model
> > + * that doesn't fit in the driver core well, nor does it seem to appear any
> > + * place else in the kernel, so use a simple hack.
> > + */
> > +static int mdev_bind_driver(struct mdev_device *mdev)
> > +{
> > +	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
> > +	int ret;
> > +
> > +	if (!drv)
> > +		drv = &vfio_mdev_driver;
> > +
> > +	while (1) {
> > +		device_lock(&mdev->dev);
> > +		if (mdev->dev.driver == &drv->driver) {
> > +			ret = 0;
> > +			goto out_unlock;
> > +		}
> > +		if (mdev->probe_err) {
> > +			ret = mdev->probe_err;
> > +			goto out_unlock;
> > +		}
> > +		device_unlock(&mdev->dev);
> > +		ret = device_attach(&mdev->dev);
> 
> The sequence above looks sketchy:
> 1. lock
> 2. check for driver
> 3. unlock
> 4. device_attach - it takes internally same lock as in step 1.
> 
> Why don't you rely on internal to device_attach() driver check?

This is locking both probe_err and the check that the right driver is
bound. device_attach() doesn't tell you the same information

Jason
