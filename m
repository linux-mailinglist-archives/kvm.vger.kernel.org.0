Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3D46C133
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 18:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbhLGRD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 12:03:57 -0500
Received: from mail-dm3nam07on2086.outbound.protection.outlook.com ([40.107.95.86]:41123
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235096AbhLGRD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 12:03:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTDc3rUpT04N7CFoQ9Emd1WeJ7nRmczeLDsJ+NfMxIQZTgiMIQ8kOCnhEOBD3DESqZTmXaTAHxISdgz4lcT+GNYIuuL3992KL+ajn58TcB8M/nMideW2lXXbGthTkdpyM4j2pPrmpRjqJgwQPfrkC9gv+OesOaD2BT/rey0K6ROHSQRmTKMyzTuMJL9tvPQwfw17CAjcgcKobfXrduK9rZT/ixC4qtc7zAYmLGIZJqbbtiw/714PJV/YsvFmH43fmmlNpmz/m+SxtCQoBzrsojqqQzT5vgNtbg4DJGlnRGQ1+8cTfwR8AM09rBGh2CRZIqpXa4HKspGeejIVKYGTGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqG25OmCN2dwHNt8YfmUlwJWWA+N+n+6xpGVR4UNLqg=;
 b=AHtnQj5TvJ8NInLsD+aOlYFgCXTgBT3NkJ7DDqsywyhyBYlwQVMv3ViMxSrUbcLHattK8JvPbvJRHuAXJULNXZkJ6num5+qqI2t0XiO4Uoz5RJ9ZOw6hMVNaQuXap6+OM7X7synrsxvsVN51Idi4FfJT0X83vaZyQQPhsPT3dHbRZpgAxGjyEYxRgyAelbInUGS8M8xZelcQxo5wJOyM9SBjd1YqCaX/ABqMLQji+rx4mIt6Qesb3tOAmXOZeK36W7f6yQmMDp1+GA0Tw0lclXmYLw7gXhMvkM8A+3wZUX8LAWmqOwyVi+I2duazLQntS/HwxPy76n/CyZBol5HWiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqG25OmCN2dwHNt8YfmUlwJWWA+N+n+6xpGVR4UNLqg=;
 b=iANGNScgO/OhF4fRqTvaaqy3+Wk8tLvxSovzDJHAZv0tQA1jaXpeIzkFkRa1T4K3/rrGiIFsyTx0Rmkkxsb5rLtx54RlBsddekF6EL4brVhiaJwYn0Y3nZy3TgwBz4cXHdj49NMezYGgm5KZhkxU/zDzH+eVpl22go7m6e6bNwhATWPLHzC+0LtKNkC2V+NFO0DC5ZuoqNuAKqAN5bZZ6x1R9HtL7jsfmtyZFotQXblO+deDvLIH+YJP6GK7VumLQm2VgBDnFFG+o17fYgrJH0EONXvYSzoaqBBXj2ncGm7d0/7/UDjv/M9ngZiBu0xV7GTS8Ol50LzbJuT8myPhXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5032.namprd12.prod.outlook.com (2603:10b6:208:30a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 17:00:24 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:00:24 +0000
Date:   Tue, 7 Dec 2021 13:00:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211207170023.GG6385@nvidia.com>
References: <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com>
 <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com>
 <20211206191933.GM4670@nvidia.com>
 <87o85su0kv.fsf@redhat.com>
 <20211207155145.GD6385@nvidia.com>
 <87ilw0tm1m.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilw0tm1m.fsf@redhat.com>
X-ClientProxiedBy: BL0PR02CA0105.namprd02.prod.outlook.com
 (2603:10b6:208:51::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0105.namprd02.prod.outlook.com (2603:10b6:208:51::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 17:00:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mudpH-0005Ml-If; Tue, 07 Dec 2021 13:00:23 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e9f6182-8947-43eb-ce56-08d9b9a30fc7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5032:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB503249BF9C53CCE4EAD3D3EEC26E9@BL1PR12MB5032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uanE4vfU/1isE8CsIbDKlqXeZ3n/jxXQKhCOX1E5yiuaD6ftU5VDuLE84sbyf+uPz1Q2q8jq96TLX7dMOvaIxyvvHOwG559Wr8PF+USojI4HOdAXcEU0FbsaN+vZWEZRwr2n5ClvzwQhg+YCv8xBEKzl96FC+6Y+Hoixi13lmeTEEkLuiHmgmAURoWMxvZem03sfVxBVyO91NNoQfx/WMd2Gxm/F/MI0qr4FgKZEEKRAPLCTDxJf+w0WHW+iazwtTyS4RJnqgrysjX2iXi8FWW2HMjNtJ2MNPSnjDYcxXU8y03SjaceetJozxuWYe0kQ3fI+wQHIakaBRZcDSTXYt0TXgF6UOZUOexZkOWM8SvX3XggsLSZN8KSFPxXfoM0STt7SU24c3LCFZweBR3rtNPFFKzhPog0C/pqAEJjCRJfWw3zYgCQ1i3ieDRTKFub4YzgEnZNBOg49ObTrPr6V9BrDcI7Y9eLi67Yv78FHX1wPaQ0E2a+YDHr8ldhFPUQ39p6YJPHLP+ysVLIqBfEGI//51KvGyEO1JMYXqyVHWSrT30i31uIK2MBpEAtOBK1JUPFyd7cDVG3QUQJLhtM9WmXKL7yMI5X6i/KYc08rPoIktsJveFIQVwSbI54eL1DpdYJvELi2/NFj0Vn4YYq+KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(508600001)(316002)(426003)(9786002)(9746002)(8936002)(26005)(36756003)(86362001)(38100700002)(66946007)(4326008)(2616005)(5660300002)(8676002)(2906002)(6916009)(186003)(33656002)(54906003)(66556008)(107886003)(66476007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jDV3bY9amHiB2r/nLZxj2bjmwhVMvNy1z2w5dqFBIRAP3apv98j1pyNDtqMH?=
 =?us-ascii?Q?FI7sQPRgkDtStrpNk9W+KK7+BFJSNiW2GcUxFGjfctB6vYbRygvtUjQB9/m4?=
 =?us-ascii?Q?EttboZnqO0HZtnyy8K+mc9npHWxgWaR+7knTkeJKpJmsKEXBERSRo7SxAL6x?=
 =?us-ascii?Q?x/gkgcY0NLe1bXPCRmgwCkDaVE0k6j/QMYxghxR6pYlWTYx4IvGazFLkUnrU?=
 =?us-ascii?Q?cI3jGzLv8Vuo+O87gxtZtJkGrmO7J6rUVzLyhQdUmnCr+HI4WcJL3Befdk3j?=
 =?us-ascii?Q?86rO2VvFGzkWHVylxgZ4uY3aq3BK2DxhvrheUWlAf7qpi88krMpCqiclSbaF?=
 =?us-ascii?Q?8XpjJmIDVZVU7CPPxLGnw8Y2RUsvmjIUDzrp76jNJtfJDGsc6qucO/OVnqvx?=
 =?us-ascii?Q?ktqCgcneOTZKkCIKP6p3aNn2+EpeetqKdTV1I943kLgoEy+ybUYf1Ecl8JjK?=
 =?us-ascii?Q?yg24etxHvRae2qpDVBhgp8UB+rjUOu+qVW8M6/CnTeuyOWdtVAKLZ55Dmsrt?=
 =?us-ascii?Q?v3tDnKbkJaU7ltA4jeudN6nPeCbdydXV5eqLpPUhj50iBP+kKZm7qYAOQzHw?=
 =?us-ascii?Q?4BjIdzE6QcZNTOlCsJEzIoDcfPpGYrXTIMvIT6ppXPDDgiP7h20hIdRazdzS?=
 =?us-ascii?Q?g27SVxMEc/Jv00GW7J2TZZZmU5g9zz+CWCIkqm8P0mPgzyJ+Xyo1xXAEPXXn?=
 =?us-ascii?Q?Dpv2jlLDdx+SCqVCuYoRR3cGruQ5cVL7BILmqYECMOaEKZfbqDucG0WFnDWp?=
 =?us-ascii?Q?Y6yvuId3GFPwlEm00bRN9Q3pVgdazCbz1N0qRfmzys9s6Gyt5/GMA55ug50H?=
 =?us-ascii?Q?XYT0bbwWa+Xb03NfwWxjnz0FTlxoxUQSY9Kn6HyBZRQIWRzzzRjpQXQNUeIv?=
 =?us-ascii?Q?aWn7qbJ/qHZ1owqLKSh3kKdYJ986PtlYqAqI8Y+SDNGgHShAjHoVQvyLTLhS?=
 =?us-ascii?Q?4JdJwD0CvvoE1sQ3EkfsU4Z55/IL6dBQLsa0qe7pUcIN9xC91e0k9WJNud68?=
 =?us-ascii?Q?ynwHBr1E05MJJ2KlToZL898ZVitCBmzMjfjRJ0IK22pPCjR6Yizgw5GA3I8/?=
 =?us-ascii?Q?NyM7LmVss3p8Jwhni8vRRSD/ogZc7yNjmUKzA64OLpEV3ztb9ptL/BJ1+Btl?=
 =?us-ascii?Q?zIsKuvWm4gPypHvUGtrF6UL/QxQvkdr7RnUbC3dv/6wx7fEvMy1CwC6jBqAx?=
 =?us-ascii?Q?B3nszEzgm6RbY7rWQlUhM0oVDEcK0X0lGGI4NvYV3K8HvdkJHlDa2iIRspUW?=
 =?us-ascii?Q?fuz8p1yMu92PRlAzbzA4CD1OwpwWHEjxkX2HIDCJ7U3DrOnJ84P0pYO26E6V?=
 =?us-ascii?Q?sfgD/OP/de/MRwPUU5+1jmUOla08ngOHfcWpMXaCB4fGX3v8Xvh1VeJiNvGM?=
 =?us-ascii?Q?7h0HOwHjhwOOgMpRPU8f7Z7ySYHWHtvkUJv4PMH2j5XzrDCuZzXCVbs/Fw3q?=
 =?us-ascii?Q?UziTk4J0I71/MaxQsJxNTXEv8UEdwmLeakLCrNDno9UQPLud2A0UiS/VCbD9?=
 =?us-ascii?Q?xpdFAZTz6jgOb2G8hU12uZFkcW7IhUupQUz+kQZifua+VG3JagGkg1g35IZp?=
 =?us-ascii?Q?RWbun4VmDNf8urAhcYQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9f6182-8947-43eb-ce56-08d9b9a30fc7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:00:24.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kPSUFR66ETpebvoWcwQGj5/fH+byTtI9X2sQ6edYBOvvzI5iJPSrpEwzqsfNeWdL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 05:30:29PM +0100, Cornelia Huck wrote:
> On Tue, Dec 07 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Dec 07, 2021 at 12:16:32PM +0100, Cornelia Huck wrote:
> >> On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >> 
> >> > On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:
> >> >
> >> >> We're discussing a complex topic here, and we really don't want to
> >> >> perpetuate an unclear uAPI. This is where my push for more precise
> >> >> statements is coming from.
> >> >
> >> > I appreciate that, and I think we've made a big effort toward that
> >> > direction.
> >> >
> >> > Can we have some crisp feedback which statements need SHOULD/MUST/MUST
> >> > NOT and come to something?
> >> 
> >> I'm not sure what I should actually comment on, some general remarks:
> >
> > You should comment on the paragraphs that prevent you from adding a
> > reviewed-by.
> 
> On which copy? There have been updates, and I haven't found a conchise
> email to reply to.

I'll send a v3

> >> - If we consider a possible vfio-ccw implementation that will quiesce
> >>   the device and not rely on tracking I/O, we need to make the parts
> >>   that talk about tracking non-mandatory.
> >
> > I'm not sure what you mean by 'tracking I/O'?
> 
> MMIO.

If there is no MMIO there is nothing to worry about, right?

S390 should define its own rules around quieting whatever non-MMIO
control path exists between the VM and the mdev.
 
> > The precedence follows the reference flow so that any conflicts
> > resolve along the path that already has defined behaviors.
> 
> Well, yes. I'm just wondering where bit groups are coming in
> then. That's where I'm confused (by the discussion).

Bit groups are things like "SAVING | RUNNING". Bit SAVING does not
have any meaning on its own, it is always qualified by running.

> >> 6 weeks is already blazingly fast in any vfio migration discussion. /s
> >
> > We've invested a lot of engineer months in this project, it is
> > disrespectful to all of this effort to leave us hanging with no clear
> > path forward and no actionable review comments after so much
> > time. This is another kernel cycle lost.
> 
> Well... it's not only you who are spending time on this. I'm trying to
> follow the discussion, which is not easy, and try to come up with
> feedback, which is not easy, either. This is using up a huge chunk of my
> time. Compared with the long and tedious discussions that led to the
> initial code being merged, we're really going very fast. 

Well, yes, we are serious about getting this merged and we are fully
committed to upstream quality and good design. 

In the end we all agree - we are only working through all the edges
and special cases that always existed here but were never fully
discussed.

> And expecting people to drop everything and make a definite desicion
> quickly when there are still open questions on a complex topic does
> not strike me as particularly respectful, either.

I don't even know what is the list open questions anymore! As far as I
know everything in the etherpad is addressed by the documentation I
prepared.

> >> Remember that we have other things to do as well, not all of which will
> >> be visible to you.
> >
> > As do we all, but your name is in the maintainer file, and that comes
> > with some responsibility.
> 
> It, however, does not mean that someone listed in MAINTAINERS must
> immediately deal with anything that is thrown at them to the detriment
> of everything else. 

I don't see this as immediately at all, please don't take it as such a
demand.

We posted v1 in September, it is now Decemeber, we want to know what
we need to do to get this merged. I've asked several times now, and
I'm not seeing a clear answer :(

My suggestion is we agree on the document I wrote as a general
understanding what we are doing (not so much a spec) and we proceed.

We now have a lot of experience with physical device migration here, I
think it is reasonable to extend some trust that we are implementing
something that is reasonable as a uAPI.

> [There is a reason why I have dropped out of some maintainership entries
> recently, the asymmetry of people requiring feedback and merging and
> people actually giving feedback and merging seems to have gotten worse
> over the last years. I can certainly delist myself as a vfio reviewer as
> well, and while that would certainly help my wellbeing, I'm not sure
> whether that is what you want.]

No, I do not want that, and am not suggesting that.

Regards,
Jason
