Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F74B36B48A
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhDZOM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:12:26 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:29313
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230250AbhDZOM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:12:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A13rXAJsUhRL5OE0w91H6GvgL2/qg0fbmCt8ehpDvS8mdv/YPkz0RkXrkd570S5Fpl1zBxotVy1kL7f+p3/XCggIPFhJyeEmTOm5BARQBmkJVA+djz4V+1ZTyq3dCoKa+w/tAkLx9o5tnKPmyPAQjAnbI945CGbaLd5+uFmXfSVj2pXcz+RZ2u6WHJ8qOOat0TBrpH6RZi3sgKhmHIclWQ/8UF1fLmq83tiH8r9cV3L9CEn1qbwvIZAq3FarF5GCydYSRUYZSJMja23sYQJL5BUZb8R1nrETK+NH3D97OQcgVd3qocG7B7Ksa3naDnU0OiXd6nUwz40ctJJItdtU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRiDd+VenLbwzdrhW3DmB6lEyitsHEXSGm7R+UDtirs=;
 b=m6U4C5NCcg5SNB9y5yR3dHlVOXyosNJ+7giW3GBbjeKhIoaybdV4c7lTx9t3GSyK1Z4qES/ujj7KbvppqnDVvg+gh0nkY2u9MspbBZwTTRejL6SYduqjNF2cGr3hEVuiJeTpYNaAi2w7r59rDE1eft3a/pbgO8cbCozW8PFtu4DRKw7xE6Due12H5YWjc5j7sEKghAHATCOCxeVFJzneHz3bp857quT8b3n/YFggITj1QIRfkYTMPNFUvvvOt483g2qBW3cgvGQE1mqSvpnUgPTmbwkN0gfn/P2TjT30XTCvuSmAn0Z6RHBS8biAHRDrHmXxRJguE/Ev2UOohL7ZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRiDd+VenLbwzdrhW3DmB6lEyitsHEXSGm7R+UDtirs=;
 b=fsOJdbJSQSj7Io+0VRuSGCG0gXJRYs2zwBfG5rn1sS/Xx1ReNVSbv1a3So7e48bTS1MLsryqP1H4khgcuNzXJZiilWpPLnCnlR5Lojk9p8JV8t5p1qD6MdNGpxHL8yfYfVAvtv7HkIrYcikbHXi8Qp/m6xlb4fSl43XBDzy7u2qcD5CcWbK14pdHuq6yZEJogL4diEQuyWOMa7m5KwWhFh+FuymtQq6LKQqjT4OZntaRdJTyG+MVnoU8BrnEc7nH9FH2DCRFLnMLyr+D0RX+CoaZX2cpuA1LFOz8lNhyirn0oOnEIqDyQX12bjpG8i9VQXkbn9elzIb84oQcGOuBAQ==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1882.namprd12.prod.outlook.com (2603:10b6:3:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 14:11:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 14:11:41 +0000
Date:   Mon, 26 Apr 2021 11:11:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/12] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210426141140.GU1370958@nvidia.com>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
 <2-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
 <20210426140257.GA15209@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426140257.GA15209@lst.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:236::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR05CA0048.namprd05.prod.outlook.com (2603:10b6:208:236::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Mon, 26 Apr 2021 14:11:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb1xc-00D4Jv-4i; Mon, 26 Apr 2021 11:11:40 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f25ad74-23a2-4c00-389a-08d908bd36ef
X-MS-TrafficTypeDiagnostic: DM5PR12MB1882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1882537E4990FDAC4F3903ADC2429@DM5PR12MB1882.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79i3gSqO8PJPW0I8Udca3mabr5VXBg+d7lS2QRfqLDFFn4WejmGHGQr3Xf+sMyWBOmq0InTdEQGE69DGlfL5WGKYKvcvSAQO3y5fBymex6hMUP3+vBhOeVDBb8VoaR61bqz9Jl2Ra923Nc8qjA8gRztO4hZoWXsC/BsUOhFDaH1IRZqFhvIXPVsjRB50J4u5p876gKBUz4oUnmxWIHKiRoZWm1zfBg5ApqRK62h1P33u0QRfX7VadV5SlHVS3OW2AAnHOUNujTEuu1yPvqPiY5Ka+6/61aLtv0QDsuwxJ1lzUctU6psayUJt7qi1c2fBXgu9L87t0fvRTMpJo0+TKg4gifFvsjjtDfQvrKR3kUaadarztDQHGuk7CMTqmYyqjB1WAIQdrpdKF/rHUOXXGew6fQTRKaBcVbi9onz/F3OywQdwPPBKZkHxcnYdO2rUt4M2E5QnuewNuuS5uCnUNF0y0Sof99hShXnWsgG0w6cJrdPdID+hsljKeeTsTgZegmylqrskHvbmiv8H0MrPv1IxbIbzC6NSJRAqzlw4LyY2dfKbCLGRckHFQw48UcIXiNwuSIamvf/d9ITHJ4qsC1uo8pS1pzw+nIT7lG8obv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(186003)(38100700002)(4326008)(2906002)(6916009)(54906003)(478600001)(107886003)(66556008)(66946007)(66476007)(33656002)(9746002)(9786002)(83380400001)(1076003)(8676002)(5660300002)(8936002)(86362001)(426003)(26005)(316002)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N14OU7lb8Ukc+mweXwC0jX9W8bvRCZQ1kO09YFbYd+q4CbLuuuO1rG2B3Wpa?=
 =?us-ascii?Q?404lYPTFRp6MoNk3KPTzs1yieB+98bBuoO+eDArHo+PQc+lYHICpJ4lzaaF6?=
 =?us-ascii?Q?8J7EBDiozKPXUT2Of/PACuH3nQca01BteCfGHogwqBMX+/fOv1JdF+8JDf/t?=
 =?us-ascii?Q?p51NBlQQEy5NnJnkIkkb1LCLENSdiRLbtArzL8HHx7YzHRJWK7HCFwQxQ/Jo?=
 =?us-ascii?Q?fuznXLLU42J9tS7yigbw7CNqJUlVbEdaxy8MV9XiQAWeD9ODftgd58LURdNo?=
 =?us-ascii?Q?efDLk/i96WS4RGqQ6kBsC7etN19bLNGjODSybg9sKeABCLrSO/UZNIcDu815?=
 =?us-ascii?Q?knEPfVCK8RsZwDYYNiKMKxS1XoJElcDqHDVglZ+Fm+Fa4pwiUIluXItgc9SK?=
 =?us-ascii?Q?E3Ya8+bM2FsA3i+SfXwvz1BKl0ovZoqRsGYIWMAHcXxCFGLgStizHrUuYMUQ?=
 =?us-ascii?Q?I4xqFUt3c00AkYhdDll+Wb3L55Cg0Ypge4txXwNIbpbsWqfDI+at4SDJVrab?=
 =?us-ascii?Q?ki7gPlilahTHBrWZO0S020YOpT7WeVUWO3o9B0eAnvG+/yE0Qz/x9E1w+mj7?=
 =?us-ascii?Q?c9lJVyLtMWHRtg9qZRPH3ia/XuvvnjPen60KbZglpyoejvgtbxKKHS7V/8TL?=
 =?us-ascii?Q?0GW+iOYYDMTC/hWBDegXnsOwGxb55Fetz6EQnLWpYyqjcMt5rr7K68Sn/rrX?=
 =?us-ascii?Q?kREmFAn/m2xttGCr5SZFo2+C8dLvvIOpUFP7fVjwVGK4lQlWDgmIQ+HYrR3a?=
 =?us-ascii?Q?/sT/Z4hZyLgvMuQtK/TMaQkW73P98poY4ap7cJaWfxOLrBb87FAAxM6v6Dmu?=
 =?us-ascii?Q?Npee8o/Lc01VuI9r1wmldAI3TlUn+h7zLJQjXpS7JlriCMcdbaUpBqM5MZWm?=
 =?us-ascii?Q?RolRFSpOriTFfw4ee1R9ghMhQoq13j2v2m4PmCAIMExVhi94etYhaVxsmKvq?=
 =?us-ascii?Q?Ru4YOU0DXa5wtYQCNpMvsjMiKlJwnTF6M7/aLcMRXwwzjdl+6uitY2PYjCrc?=
 =?us-ascii?Q?UeAg794Q3FZ7EAtPs87htEmEUomqcoX/b1QpwVlwoikCeOIeCwSXx/BBHd/g?=
 =?us-ascii?Q?aGN4UH/QZzOX97uuaNTkPm8Oi4fPulaiIYzOASsHBZpp3wgH4A1c36T9RyAs?=
 =?us-ascii?Q?tK44/K40WLyI6n5E5nXhCF7WqLbH0WyE84u14vkpm+MPaVzVO1R/EYKRJkfo?=
 =?us-ascii?Q?BxttGTY8vjpH/S3fifOokPlhAxqmd+arpGKCEyFpCKkXiMcFwY0gfM2IPP7S?=
 =?us-ascii?Q?XgpOk2ujEFF25nXlgd/Vb1VDrzWbLjGUuI1EsPXS1frgRZdc+4vmziEbfvqm?=
 =?us-ascii?Q?mNk3ygsQWWV9aTGxEy4JZtu5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f25ad74-23a2-4c00-389a-08d908bd36ef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 14:11:41.4763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6GEIP8g4SOBe2fd/Xew7gX6AtvKfl5c+PhbeK/AFWKr+dOoRPCoUa6WcxsQ8H4Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1882
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 04:02:57PM +0200, Christoph Hellwig wrote:
> On Fri, Apr 23, 2021 at 08:02:59PM -0300, Jason Gunthorpe wrote:
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
> > +		if (ret)
> > +			return ret;
> > +		mdev->probe_err = -EINVAL;
> > +	}
> > +	return 0;
> > +
> > +out_unlock:
> > +	device_unlock(&mdev->dev);
> > +	return ret;
> > +}
> 
> This looks strange to me, and I think by open coding
> device_attach we could do much better here, something like:

I look at this for a long time, it is strange.

> static int mdev_bind_driver(struct mdev_device *mdev)
> {
> 	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
> 	int ret = -EINVAL;
> 
> 	if (!drv)
> 		drv = &vfio_mdev_driver;
> 
> 	device_lock(&mdev->dev);
> 	if (WARN_ON_ONCE(device_is_bound(dev)))
> 		goto out_unlock;
> 	if (mdev->dev.p->dead)
> 	 	goto out_unlock;

'p' is private to the driver core so we can't touch it here

> 	mdev->dev.driver = &drv->driver;
> 	ret = device_bind_driver(&mdev->dev);

It is really counter intuitive but device_bind_driver() doesn't
actually call probe, or do a lot of other essential stuff.

As far as I can see the driver core has three different ways to bind
drivers:
 - The normal 'really_probe()' path with all the bells and whistles.
 - You can set dev.driver before calling device_add() and related
 - You can call device_bind_driver() 'somehow'.

The later two completely skip all the really_probe() stuff, so things
like devm and more become broken. They also don't call probe(), that
is up to the caller. They seem only usable in very niche special
cases, unfortunately.

Some callers open code the probe() but then they have ordering
problems with the sysfs and other little issues.

In this case 99% of the time the driver will already be bound here and
this routine does nothing - the only case I worried about about is
some kind of defered probe by default which calling device_attach()
will defeat.

Thanks,
Jason
