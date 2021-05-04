Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8019B372991
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 13:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEDLb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 07:31:28 -0400
Received: from mail-dm6nam12on2084.outbound.protection.outlook.com ([40.107.243.84]:61055
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229903AbhEDLb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 07:31:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqRTLY4B0qqdDfJOHFPpEEeiG7K/vgYHSgIORhrHb4vCECmUasuqp5l7igTpjelkZ3s48FjfQhPaGEswwVGJSajE5gyMEny67xYRxgVrvyJjQ6PXT7YZLG0MTXmoVuc4nGByUDP4n6JCU6LyxYJ++yjyooRNiGR/ohBFXOSAwOVH7cZj33kjAJc9s1p59hZ+/wq6R4Rj89gjqr/VNhOsIeJo8mqa8juKVUw//EHZ2OkVS/vvRjoEIt2qSFDMwUREl9C9s6B/BB9PdATCH+MfZcR3t7Dju76J545WBTF1KjBWUmgiBYeZBHW3RrvXmLDA5cdGr3Wh0l/7OVgttYT3/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpkB78vBqm5dsh/fEJyN+LN+qPJgv3kwdP7CFFcUmIo=;
 b=fk/JAJs7Oavrxo/y05ws0ejO14MLACKpZSx6iTX4gGgNMt/4EthL6B3Rt9FhY/n7qDjelKDEu0tON3K08vtH/vgpG/EbqYVwO0zTaII9nQBUSqYgzKd6cj4E2RBDXXSel5HBwrp36BtAEAVC2yFUWECkwT4NQQqA+I5yBsDRAIFm0ZlNYwq0+21fxJwS9zxEzN1G2CSxK3ej0SnF9lGgs6igCMds9DKrYk+RE9bAAGUfkia4HcJGd8tMi249Wq66wBVnwHz3khv9oBVdR3RO5ya29MzNQQmQVSiIuwCeJ/XmVl01gVxa3HKE52whEWfrU51C0dIGEINch4/sy35hkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpkB78vBqm5dsh/fEJyN+LN+qPJgv3kwdP7CFFcUmIo=;
 b=DUiuwKA99nHqa3mBmHmFEPvgn3cJiNVfttavONNxcrbH6DpawYQV70H/xATgSRYswThnMls2y7VyhfRH/4Roj50l9AwWeiArC/omy7ACOc3sZQzPlZO7IFPQm8MCSLQowWKwvFvbrg90vyTQ32kQJehyYGZycZPLbFb3lFEWAtS+Fzl4h9sBu2UNQEH722x0wAJ8wDWy6+KvfoPT/bOa3TnUElVSSxyRXwCNQvsAElpodypShEDMDRwJFL/hyWywzY/HLXmtQQO62N2CjZZZnlnkQPrVm/8G0YMmnimWZD7JXCVaviigPngzZOU9q5evT3DVtas+uy6E2flD27h7vA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Tue, 4 May
 2021 11:30:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 11:30:31 +0000
Date:   Tue, 4 May 2021 08:30:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210504113029.GQ1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de>
 <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de>
 <20210428140005.GS1370958@nvidia.com>
 <20210504093636.GA24834@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504093636.GA24834@lst.de>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0060.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.37 via Frontend Transport; Tue, 4 May 2021 11:30:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ldtG1-000MSn-IX; Tue, 04 May 2021 08:30:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00605d95-7c7a-4722-4dc5-08d90ef00663
X-MS-TrafficTypeDiagnostic: DM6PR12MB4299:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4299FCEB402BAC6BEE2BA64BC25A9@DM6PR12MB4299.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwailTkTzF9mTDV6Mo2MYiC9fLGnK+e29EpVHopc+OfIBCVZjkt6jOUUGnMcUIP3WgYpJ2qLnNoezb7YhHJjMsSKRM2mFPpl06U44IVey4YnQXOPAh+u/IO/3J+U92E9dBTWWLoA+NEu+RIowSca3lbi05G97mDGOVMC9Yy7bqbGo+cV4qiy0nznLfw+c0z71w3uRoOe3YnSdSKEv8z9qM4EjeltOVU3Bv71LCXcabxpYEfEIOEZcppTVekxJSjhus/ObOegPg/O6hA7aS/cZPhBFRYtkOfAwG5RBbWUg+9e830W2+G1+PUt357ZWetW1w1X0tXGn+LT4fB7iHdxoYsE/KMqCUA/S57p80F4q6Umq/HUV4VTmfqivXBZEpGvkK0Nzps/3Q2bNJV49ixiJRwewYL7LlxTXtNbKLathKRJ1ndFmiLyv3CxABOel6jtjWEUvc2cbn3xGOufp+gfrR/zMdYghXZi/heoZJQQ93DxM7Ol/hgOgY5C9utGc15lCxGnBWjd7VkVL7SPz73nbS4l3IOm14JF4XJviOiv/2mMr02qFpMRkiewAEujsbxXXA6mFGnGTjuJB/jV7lZLVzXasT3ESysJmS2GN2uS0ps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(38100700002)(5660300002)(26005)(2906002)(316002)(107886003)(9746002)(1076003)(6916009)(186003)(54906003)(2616005)(66946007)(4326008)(33656002)(9786002)(8676002)(66476007)(36756003)(66556008)(478600001)(83380400001)(86362001)(426003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iQ5cbXEyzKjb8+GIQzArcMnuxSHrwIDTxanMPyH0+vcA2TF8ma050Hv/C588?=
 =?us-ascii?Q?SZjpW3V+WvIv+n3Xmrfg8xnCNK6Z3z6z3a3cq3BMiDT1W86Tz5OxY1ER/68q?=
 =?us-ascii?Q?G5gQvRrJuzQ0lWHbn0A2LGT1ID6r1Yw8DxZZR1kR0wUhkcOBX06iqSIOvp9V?=
 =?us-ascii?Q?Q9XujpEWTvzuSCUrmnexAGbJ2lZ03xUHQiue+xcEu5fsK7C3fTV3Q8+Awbpm?=
 =?us-ascii?Q?Irc6l8frZkrz3DLpX6yknAV666nIMEe/aBilHSWwgKI7y1cof3woQkwRwy0f?=
 =?us-ascii?Q?VM+zR3piV8dua+w7/6JZcTGtaHMB2d/rwsOY5/kayWyEFPeJIrTAssgXgXVI?=
 =?us-ascii?Q?ocT1nUtBve0A0Af6iEZw491TAxKct4PA9DvTylYFVtQFuistTT9xVShYRP3Q?=
 =?us-ascii?Q?GolkKcQu5xU2oN72GuFwFMXSUx6OafiJQ2yPRmLIinA5V7oCKeb1ur61zo6q?=
 =?us-ascii?Q?1cOeb4FDo7BXHjPL40I8JwlP6v2dIAZc10WMN5OPH0D8z2/luiGqm8E2HIWk?=
 =?us-ascii?Q?z5IrOLtfutNNu351RQ2FhC1rO+Opm9T2s4Y86PXJr88gR05Y1t3dvqsgaY/1?=
 =?us-ascii?Q?IGEEGY0hXr7EKVUJJw84bgXMPF0H6W4zLGwFqNWUOXTNf71b1xWPBeaLPu7v?=
 =?us-ascii?Q?Vy6TjKSEhhWAfa6F3v/APOG7Z64DOzR/vrYXA+CMEB4PLZAts2naaQ4wJSmC?=
 =?us-ascii?Q?iR/q2P3wGDkINt3w4r8LrY9LasXki2F5jAj9ieKZW+qaqcC5IpAmUIZyampx?=
 =?us-ascii?Q?U2Rw+yfEebJj72H6n/V8wrOHpNww1ZAeSxUoTh/UTyBN3uR2w7TJk7u07+NY?=
 =?us-ascii?Q?3dIgb3kDqVebWTb6DWl3cSnzl9kVr7brYZQH6tiBVEkoxauArQSrvxSObukz?=
 =?us-ascii?Q?TgOlitcTH/oMX1hkWL2kw2llThOt0ekOUUbKsPSjMkIERc8GPhgLrqoEYcGz?=
 =?us-ascii?Q?KcGb/aeHLyuhrr/DSLIJx8du0kwtaEhQqhUwrbrWyrQeppTTsXB0ofUsr5Ro?=
 =?us-ascii?Q?GndYrwzJv+Gb3kGkDi5IfJkq/7zroiJBKRmmCWuk7Yi7k9XxwEGcN06JjcpY?=
 =?us-ascii?Q?JkhL/D+Y/gjD6/UMZMkdPviqvsWLGeT60piej5lEfO7AVJeFM/gY+qaqUqKW?=
 =?us-ascii?Q?LSynQpvGtmk+cPkX+Kaq7VKex3hqdBbq0eF9ZJyikR4HJ2JAWArO4mkycQQG?=
 =?us-ascii?Q?Is9gNhpwHWfEkFzKpAsUeBplIyUkPPqdL03Z4QdwwXWiJIJYHHbD/jPaFTZf?=
 =?us-ascii?Q?wowRsgGxjJgZcarB4z1v6wcKsXjKq51c+mBojz1xJjO3ALbZss74wUTYRbXF?=
 =?us-ascii?Q?5MDpEFnlYlwjQYv1+FiRN72e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00605d95-7c7a-4722-4dc5-08d90ef00663
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 11:30:31.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7gM2+vsYLvSEpY4upLsSBDImex3Q39eBVZugkPPP7j/sfWZdy2BWIe06K/noZry
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021 at 11:36:36AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 28, 2021 at 11:00:05AM -0300, Jason Gunthorpe wrote:
> > I thought about doing it like that, it is generally a good idea,
> > however, if I add new API surface to the driver core I really want to
> > get rid of device_bind_driver(), or at least most of its users.
> > 
> > I'm pretty sure Greg will ask for it too.
> > 
> > So, I need a way to sequence that which doesn't mean I have to shelf
> > the mdev stuff for ages while I try to get acks from lots of places.
> > 
> > Leave this alone and fix it after? Export device_driver_attach() and
> > say to try and fix the rest after?
> 
> Maybe.  Or convert one or two samples.

The conversions are easy I just can't test them or completely tell if
they are correct..
 
> > I think this will still need the ugly errno capture though..
> 
> Why?

Several of the mdev drivers are checking some predicate during their
new probe function, like total # of devices. So if userspace exceeds
that then the old behavior was to fail the sysfs create operation. eg:


static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
{
	if (private->state == VFIO_CCW_STATE_NOT_OPER)
		return -ENODEV;

	if (atomic_dec_if_positive(&private->avail) < 0)
		return -EPERM;

Without the errno capture this doesn't work anymore and things end
succeeding to create a device and but failing to attach a driver.

It could be changed to loose the errno and just return with some
generic -EINVAL if no driver bound, but that seems pretty ugly too.

Returning the probe error from some device_driver_attach() also make
some sense, but revising the code to do that is a big touch and this
is so strange I don't know if it is worth it.

Jason
