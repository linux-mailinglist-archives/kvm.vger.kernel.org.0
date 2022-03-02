Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E8C4C99A6
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 01:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiCBAES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 19:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiCBAEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 19:04:16 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6026622526;
        Tue,  1 Mar 2022 16:03:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePo1AWRJiwym7Rha3n8qYJekP3paKsttQ7yvKxPdUOPbLkWN8Oy2cMj5LkEWKE/nD6Hckq8EXGnXfQM5LqrsY2xtiFDTTUqIrdsbN041Mn65ez1Pij+mB5sWVFWzw+/OVVBveskzJIWYWHcPeszwUc+13fK2D47GmoEUhWMCDiIfzjjRl1Oc8eHo0jmnIDkh77LlNI7FpmP4AUyCdKDOrDQCmMfzAg8uDYZ90WYYE9Tsfoe73KGdet3XtTVcmz6ntiHbXiVWjwAM/pYfITUaIIWwhSWMFHkK61/+KqN8STgMOlhW8y/+jDR5hV4Q2QvUYNu9b8mJIYE+XwxVwVY5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5w/clpq6woHujYgclfg02Wz6VJp/gIXTCkTkhncMHjE=;
 b=ODgrSRwO1MpjdwZSHsi1RAeIq0kArAIkQm/3zo4mucUmTELyKiDgmpGBqtHPkBN6tnwAqBQjMVMHBi7ppO3CQWkYL3KsQjbyKWlKfvxpsutY3+I6t/IFHg3b9DtkEVnhMBZSl6dhjrUgdMWVkSBFBVooAArHa3wjYwXhbJHzTINAuBp4T25URk4KP1g9PuQ6qxzf1N3fVk+ul8xhIM4NWGVylMMZNLxOgLaqwlulyHwlDvMBrh7OdCxvIC0ZgfpdrFShiSMYsEnvGB9P6xy1h697bN/NXWHiVE0fg9IUHoohJVbbU0YhaR5zCI5ShGF9jjholFbER2I/6PaJy5aTLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w/clpq6woHujYgclfg02Wz6VJp/gIXTCkTkhncMHjE=;
 b=sDab82fzLl4wPhLBczUPmB7BGXR/29cLwe/grtc+gt5t2TsWoQL1itdWIPuFCXFyYHIyt7yzVzhiKgV9cpu5DHA4EpBlR7bKUg6+CUyMmjdFGhrSNPZI59x6V+2SfD75MWLXp8YwmaXiBIU5Dn+k4r2VbAcD2cpHvWid15sJRVhFh3tGHZZiAirqR0jhQnc8GuVMLccim2wVQ070FBCFkHedbVCfsxn7Su7Uv3/sjXfjfDvxyBvlTdF/OHOpeWWkFyzlS/vkVfNApDF+6LqiKZsr5PC9JLTYukILXL/Cp0B9fbnob7taegwKomKv/rggUlMkAAOzEdWXvF8IiUyhGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4764.namprd12.prod.outlook.com (2603:10b6:5:31::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 00:03:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 00:03:31 +0000
Date:   Tue, 1 Mar 2022 20:03:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220302000329.GZ219866@nvidia.com>
References: <20220228180520.GO219866@nvidia.com>
 <20220228131614.27ad37dc.alex.williamson@redhat.com>
 <20220228202919.GP219866@nvidia.com>
 <20220228142034.024e7be6.alex.williamson@redhat.com>
 <20220228234709.GV219866@nvidia.com>
 <20220228214110.4deb551f.alex.williamson@redhat.com>
 <20220301131528.GW219866@nvidia.com>
 <20220301123047.1171c730.alex.williamson@redhat.com>
 <20220301203938.GY219866@nvidia.com>
 <20220301154431.42b27278.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301154431.42b27278.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad82aa1-5d90-4361-cd1c-08d9fbe015f1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4764:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB47645DA5F363296C3807E33FC2039@DM6PR12MB4764.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIRpkhNVz+EQ7V61IP6RO34pB1T83uaBaSkGc+3JxQWN5kPSH065SLAmxl6kU8JefACEk2bwZztT1aRnYUDI6YGjStu//8WZ7khH+BmQbQx5Xyrz0Crq0SoxDGyaYmJq5nvifZiTj2SLXAc9XrvoCgKKMr9gOcXiExsgP3rWO4Qewoh1ufcW5r+d1PSdpEtiLtEaOjfIj8ShOEn/Jh0K4pGm4EARe1Gl6ILwURzlyizJboMspEQ1p4jOGthdgIWpVSM9VR0JKSwrc/jwg9wNMc7u19oJDmiofoPXR9daHJCigSyZDY3OJdPh8cQvROV/hDdG3rSKsU70qL1zMq1pdcERW83yz+lAtvN8j4Fs7fE5wsBsguPabRAz9lRL77i7TNkcvsxyvoxy425M2p83jU4yM5XxXSN/T/05DImzfqebnd6SAIye5aibevwcA/xgq5Y9RTu8GaL9N11qu5329segsNMJV4TM9wRaq72EhM0+U9HFg5YqXkny3CdTjJvNuCyp2CxNZse7gAojH3Q6NtS46qlBcOn1URiHWv1iI1F8ybrO4v/ZK212irUqjevgbolfkmgS/SPRYRSG6OvkivBgpjFLMTwQpRpGT+dYLmjN0IG8pWQFVMddlSm7YsNZsyunUBkxwWcIWzcpku4z2dWnIA4AdilNgqdkMHzZKc7uWky0dgvZYVypKZyLdkAs5eejDPABaOGidNSSw403eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(6506007)(36756003)(6512007)(83380400001)(508600001)(6916009)(54906003)(86362001)(1076003)(6486002)(38100700002)(316002)(8936002)(2616005)(5660300002)(2906002)(33656002)(26005)(186003)(66476007)(66946007)(66556008)(7416002)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L3rJwlucqZRjM1+ZQa0GgUT+kc/YXfuk5g0n3Hq4wv6VElHt6zMUrmi96Ytz?=
 =?us-ascii?Q?OB7DKWwY508J0nmh3PBfE3e4TJjpJWTi5ACgSF3TszGl4t1PyvdM9+FVHjhq?=
 =?us-ascii?Q?9rrNz/rtod3IwJy1L8yjfM9nyDvokeWYYR5wpUEvLKr3xEyavvLgHHRJOr7j?=
 =?us-ascii?Q?zd1HykCfPVKmLAdbjik35hhz6TJyi+auv4xRURkFv5CgcTHYh6/uUON9KUQu?=
 =?us-ascii?Q?gUyFOXd0dInO6kb2v7FTuf5fZoi00gTM1GtEV+sJu7V4dWTzmiLnSFefReOZ?=
 =?us-ascii?Q?x/H2EQWbSZ/tm3zC4v/PzkAB/wzat/rlX3E36rKEY/6Tb75cBlahoRL+9XFI?=
 =?us-ascii?Q?PocXzeSbv55R9M9hGbK2PzjOwohGqpSonGGUABqASg3/6y1uvS/cECKDOrIj?=
 =?us-ascii?Q?robDyWeA/tzaKCD3NHhBnnDe6vB4ihsd+Frg03PKBCBbduNXYSDmgM5nWkS6?=
 =?us-ascii?Q?O7ILKGlZvxBwtNokNiKm9ayLgpEyXay//jNO5Gi0jEv/pmBTcEYl04P2cgir?=
 =?us-ascii?Q?PAwXFsOtI9SVVBzW0x+WgY/hpQgUQzktpDHxPraC5s97tTjTgJcS+ChvnMFN?=
 =?us-ascii?Q?rxDsF5w5Kj5DG2WTnJ8hVdIoGF10OFiyvkAP1nw9lml8ny4vRy7hshdKwTZX?=
 =?us-ascii?Q?vaO5sBshK7gEbSwbcoEd+7sEFuuKE5L/BbUWtQSyWcTZQBzpJTzJ+EDAsw2h?=
 =?us-ascii?Q?q0U8aL9tiH6n/elqsJPazkC+Hsa1eG9M5ftRdf+VkZl/wxZYOPWDxkjV5SjK?=
 =?us-ascii?Q?RTMTvOls3fYKxqmdepZI+oGZV0CpCHNov2eKYN24G0ObpkVu33U5dO06336S?=
 =?us-ascii?Q?vDkeRWPWOorYETm+tsZVlAlXRydB2Lz5O/qXdnOG4RIYOP1Nnq37Q1cqDUg2?=
 =?us-ascii?Q?31GeF927zbp+gBJV3Kd8yPA2B2DDtt6zwYdcPJefBCa3y4OLSkS2WH4RDT+t?=
 =?us-ascii?Q?iO1dTTcVugACNWsXDWYlPc0aZ55MaHuSEaopZdkjddz6UoXJoxlyzVyJdXeb?=
 =?us-ascii?Q?TwEKfLSWhKe5kZ4FVyaQO4ME1zXx8VWa96CxiHXb4Oy4xqfxr7xb1LLnzUjI?=
 =?us-ascii?Q?Zj9YYEwKwshDX0yWW33e3WQIDg39OovcGqVfO49LOzr2n+UtAyW6+StOF2Wn?=
 =?us-ascii?Q?CmpPawvoxQ7eCvtYqdWDb26WI1ad+OWRVFzScH3Rq7DOcqDVtkSMY+6MHcfO?=
 =?us-ascii?Q?qibkQ0GFd/4hvoPuFKcemBcQR/JoMB5YnNINtEcDnWuL9dGqhdRQldPztAez?=
 =?us-ascii?Q?Tc48RYtsuXlT+Q4ccO0qlzpvwZOTV0uVdt+CJQOElUDL6BXY7ZSkQRlnNrB2?=
 =?us-ascii?Q?q4ASk5HQLJtwb6xDKn6Njjriw8pKdYRgb7PVH/ZsoefV8YHs0a50wLPLAMgn?=
 =?us-ascii?Q?FtAyfSVYRRxJEJX/wjNQLv4KW3RZ5F+ysEiOnClt4OSyYcnJUrlAEC9H4zSw?=
 =?us-ascii?Q?KfBhaIDkzy6OjDfVV/k2PffmVuF3vZ9aaYN1aTJ3uoxy6vZUJqYHjqQV7OIx?=
 =?us-ascii?Q?wBuMoa4Sntsvvgj+RGxe77wBo+xsIyCD07RnhrvcEGzpo7CZLqudXoA3G46/?=
 =?us-ascii?Q?6BhsLvrp9VRhGI31A98=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad82aa1-5d90-4361-cd1c-08d9fbe015f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 00:03:31.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2FdwuQ8voJdwL4968qpFFhFA7/t8sc95uCMxFjvz85MeBu893sxDAPerQjjcCN+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4764
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 03:44:31PM -0700, Alex Williamson wrote:
> On Tue, 1 Mar 2022 16:39:38 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Mar 01, 2022 at 12:30:47PM -0700, Alex Williamson wrote:
> > > Wouldn't it make more sense if initial-bytes started at QM_MATCH_SIZE
> > > and dirty-bytes was always sizeof(vf_data) - QM_MATCH_SIZE?  ie. QEMU
> > > would know that it has sizeof(vf_data) - QM_MATCH_SIZE remaining even
> > > while it's getting ENOMSG after reading QM_MATCH_SIZE bytes of data.  
> > 
> > The purpose of this ioctl is to help userspace guess when moving on to
> > STOP_COPY is a good idea ie when the device has done almost all the
> > work it is going to be able to do in PRE_COPY. ENOMSG is a similar
> > indicator.
> > 
> > I expect all devices to have some additional STOP_COPY trailer_data in
> > addition to their PRE_COPY initial_data and dirty_data
> > 
> > There is a choice to make if we report the trailer_data during
> > PRE_COPY or not. As this is all estimates, it doesn't matter unless
> > the trailer_data is very big.
> > 
> > Having all devices trend toward a 0 dirty_bytes to say they are are
> > done all the pre-copy they can do makes sense from an API
> > perspective. If one device trends toward 10MB due to a big
> > trailer_data and one trends toward 0 bytes, how will qemu consistently
> > decide when best to trigger STOP_COPY? It makes the API less useful.
> >
> > So, I would not include trailer_data in the dirty_bytes.
> 
> That assumes that it's possible to keep up with the device dirty
> rate.

It keeps options open so we have this choice someday.

We already see that implementations are using vCPU throttling as part
of their migration strategy, and we are seriously looking at DMA
throttling. It is not a big leap to imagine that
internal-state-dirtying throttling will happne someday.

With throttling iterations would ratchet up the throttle until they
reach an absolute small amount of dirty then cut over to STOP_COPY

> It seems like a better approach for userspace would be to look at how
> dirty_bytes is trending.  

It may be biw, but this approach doesn't care if the trailing_bytes
are included or not, so lets leave them out and preserve the other
operating model.

> If we exclude STOP_COPY trailing data from the VFIO_DEVICE_MIG_PRECOPY
> ioctl, it seems even more of a disconnect that when we enter the
> STOP_COPY state, suddenly we start getting new data out of a PRECOPY
> ioctl.

Why? That amounts can go up at any time, how does it matter if it goes
up after STOP_COPY or instantly before?

> BTW, "VFIO_DEVICE" should be reserved for ioctls and data structures
> relative to the device FD, appending it with _MIG is too subtle for me.
> This is also a GET operation for INFO, so I'd think for consistency
> with the existing vfio uAPI we'd name this something like
> VFIO_MIG_GET_PRECOPY_INFO where the structure might be named
> vfio_precopy_info.

Sure

> So if we don't think this is the right approach for STOP_COPY, then why
> are we pushing that it has any purpose outside of PRECOPY or might be
> implemented by a non-PRECOPY driver for use in STOP_COPY?

It is just simpler and more consistent to implement the math under
this ioctl in all cases then to try and artificially restrict it.

But I don't have a use case for it, so lets block it if you prefer.

Shameerali will you make these adjustments to the PRE_COPY patch?

Thanks,
Jason
