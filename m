Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77379463E46
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhK3TCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 14:02:36 -0500
Received: from mail-bn8nam08on2041.outbound.protection.outlook.com ([40.107.100.41]:38308
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232390AbhK3TCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 14:02:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWBto/prredhOwByNe5P1zPLrAdbZCj8njzKrNSwEAlpqfu5HxtVIwWTKr4qajqzqMMuVUUh2MT9GIHr/p8egx5mDCYomEma/tjcwdpYCM6ngH6oj9rkFugoRpABQaNNZGW5OAwD+5OqQAPLHu+qwE4T18PEtE5pUvWexOtSof5Pfs6URSvbvUd90IVHhs+zez5ifKWAC8UhgsgunPCTOGUPzobxYIVr6dprRmxFfh1Cz50QLDbjeN5QnoO0kgCmHToJ3TP1lWFB5O35z821dHy00mFAciH5lrVgXNi/aES3doUoNMj3MKJ+Ee8cVMLvjcCAqfP3G8bS8lrDQLH5cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRbl5eDKw7EzzKCTBSknxRjZB8kUDTyBjvcVO1URnUg=;
 b=b9orhvt5VRyhL3Rcp5jCh7f1QcGqkoJSxSXyQqJ4GV4Cw6U8ezozsyWMET3bwD9lox3vFqCkz91HM2K+jQDdC6J0c30bDFOdHnmQvHpW7v7O7Y3WckHLAB0jTqjrE3pkc0BvjcuEzwZx3qocwJKqp4SIJAHtcFBWYSbFGjiESOt93F81KPROL90PHPCRB9sAfefuZAaEKM04cPviEA5irMAyiuYxBOdSVaRerxeRLbDiD9OJrVZEbSpiqDxn+Iopbeno5tXBk2BXBMmqf6HjEXJTxXnZPQsqfsGDTs4myQR4AhwH6Z+egxzU0pP/8vKP/D0QkJEcyjgP7bjmzxL5Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRbl5eDKw7EzzKCTBSknxRjZB8kUDTyBjvcVO1URnUg=;
 b=XN5gI8B6SFidK5oMZXjveI2CcTUtXwkoZhjVLhDkBEeqmHQjgh5cBMQbXXY+usitZ9MIZh0k1ESEjeMXQZ0EAQvMnzlhdm7NEHnzB5UvxBaEF9c8LRj3zKXgZEQmQX361A2ATYzG6GzlWtWJRbiZSVn+iAxA/eV+Li1R/76CKan8703BGB0WWsBcac3hbXl1Qx9fFGBe9T4M/5uvXEul+aGATzRmc/BsI8ztfuely8JrB5DtrVcgAd5GxORVzBimLHonKIw6r+Z+54xKlb784jknUomm2KEmiF3SlGWDPYAfe2QCbk5icWLlL6hqsuKmUv9zf/2M0jFGzLpzdzIR5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 18:59:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 18:59:12 +0000
Date:   Tue, 30 Nov 2021 14:59:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211130185910.GD4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130102611.71394253.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR20CA0033.namprd20.prod.outlook.com
 (2603:10b6:208:e8::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0033.namprd20.prod.outlook.com (2603:10b6:208:e8::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Tue, 30 Nov 2021 18:59:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ms8LO-005WUJ-JJ; Tue, 30 Nov 2021 14:59:10 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5e98315-48e7-42bd-10c8-08d9b4337f06
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5111DC1E1B39EF5EA555DB7CC2679@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0vbE/X+8yA2kfIo/sK0tufNpEyzwTZroG5O1bqi2yty6kO88bbiR3wRJxjAWOq7ZUqRQbjT2gq2KZZ9L+N1lOSTAHgMHhN/IsJMQjGGhtzET2VrWN4inhFQlQQkyMmW7cUhJEn6//OwYrSwcQc4XRraglpyegxmy9NFFDtilDR3z6PhQyVBHuLXO/3zKqme6IxX9Ok/Qnh4USFaAmbzSSgONiXVrDAm0iJVhvgLXb3VT3FUnT4aWwV25Z2dWqPTYEX9LWgS4psZJtq1RaufLfbBm519eFzXKLFZnbsupeBp2ldqKLxHfA70NAYoap8wGXgS5ITfeOD01rSyQ9rKcacP5w+irArqGMLVkDUiBD9UFKvdvHCo4xcyEPytR8dSHzDv8pAu8VLlMIExuh3u4HmCVnpZbjX0lbeKDiJqnkiVE5Ckl/0NeOozeyoSzQoRMDvIop/4y14+wxcglUBNP4jj2zZ4NANLHybS79QBn2Z3Hx2C2YVoKYcu45kqvLnqER/f57cpRr36nM+dZ4+JQelE4LvCaMNZiHGRS02Gx4TPZLwYyIpDJlWuYLElt3w9ZnLTwb1cg4OT3JikJIfaKdaU/FkMdWpErm8oQsUNq5os+DAe7u0UyZp/d2jjmzr0z/j8Zg0eDXOJyLYzV9qAMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(54906003)(5660300002)(316002)(2616005)(30864003)(6916009)(4326008)(36756003)(66946007)(8676002)(86362001)(66476007)(33656002)(8936002)(9746002)(508600001)(107886003)(1076003)(9786002)(426003)(2906002)(66556008)(26005)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GVq8xuOdlgKbvv/NarXub8OlrsU7A7Mspkt7yyPMam2gh5L+s4Wec8vItix4?=
 =?us-ascii?Q?dsyxamP1R83q2eNSQcHnnNIKs5RQgNzaMSOfoUrdVCn+EODiwuFHMzzvrdGB?=
 =?us-ascii?Q?TmWRV323Bm5AZQNokyWsBx5RDUamFSn0vV5bm/pUW0cDVl2evCbwgVzmW3kS?=
 =?us-ascii?Q?r73MXnIMSPdpma0OH6c6h9J7GFdCNPYr2ycJ3+B2q3dVkTWN5iSrLCW4fZyS?=
 =?us-ascii?Q?3+EFuXDCl7PddIuTUx24bFa1QhZujCO7srOFOZL6MFu0tFBrlTpn3Fy2OG+a?=
 =?us-ascii?Q?oCLQr7xJLHM0IJpqeYTQyHwRNLZhpCKcm06L7oLNwgvgMYlBmjEcwsimy21v?=
 =?us-ascii?Q?8Dv2j1XsIpy3ly38zzkA1D4fKYio57QVEpB2EeLROhyLfmOdD9qHggxMU1R6?=
 =?us-ascii?Q?yOM6wHXITwuoxTkjDmRa1SusyiLsbJ1PW4Ov1QxNH3XuebwfvQhi3lv2Jt7q?=
 =?us-ascii?Q?Sd1Ly3+tyQQtcXFFSnGqLT+qTaYjqIKZpEpDH934ndPwDQPgMHtx2BVaHSmU?=
 =?us-ascii?Q?DyIJMKHj55CsW9Nk89Et3GyXfnPOc0J7cwzR8k+aYTuwIQEXFxaezxMQH6N5?=
 =?us-ascii?Q?IjF1dnW8CQlnblfetkJ5VQzDBdzXHipWzyQpe8DLHXAPu24uYUc5aef4c+FM?=
 =?us-ascii?Q?/cFVsu5SrQ6t4rFTIQkJVYQ63jSe/t3CFca0KhNO4i7+gPSLArYm4xvC30+h?=
 =?us-ascii?Q?HWcAn5/b9gH4LuOKRwb5QbcmZnmW3o06y0cjWAmversg7QMXsXGQhx+CWfgk?=
 =?us-ascii?Q?myDAZ6P3ugdiN6rY4JAV4oYlzwKbE74ph7/M+cuC79IUPx94BV/e7wjcaNYU?=
 =?us-ascii?Q?Yr8wFSghzCRgwfXKbLpx0cLcDV3KEtnCjHZsE2Mt9AVWiiAzbmzcvdjGdczN?=
 =?us-ascii?Q?piA4Rq5pGOXT3Rk2lx3KqIL7j8bmehysNdxDWSP7XEpYn68mUVKk8j3kcOgN?=
 =?us-ascii?Q?OhddQAQ0OKuTB2RFDhGX0OF1VvEDNjs7tqPDL1WO39ZLRpmuOrRVSMcuP3jP?=
 =?us-ascii?Q?affXNpbt/o9TbA65Le+kdG6CjfPXsM8lWdFeyTrLJ7ETR99GXguXVyA+Dby+?=
 =?us-ascii?Q?MXuwlRzdJmEsg+QoeCTbZpcd4NwxD01cMp+UBppmGexPSMZmD7vlq5qDMfby?=
 =?us-ascii?Q?NNsbd6wsk5WDgVPIBhU3ozG35zDPzU0BH+PW1i1WbCfYCKOQCZqxRHxDfCFy?=
 =?us-ascii?Q?u3tlV/LL5UursetwH1f1NbkpVOcedNQ1D8DeX/2bpUOaVpAbKUgFnzMMQVgh?=
 =?us-ascii?Q?p0lI9cSfxP87Cpkdi08C8lBTATSvcgeyE8fzUsnGoaLPtOExc3JoLYU8Gyjq?=
 =?us-ascii?Q?h61MiN2o/XWo06lEh2JqDQz+c4Fkj1Jy/Kx/Saf17x+NQqvHHSJFZrcCd5RP?=
 =?us-ascii?Q?ZqkzsUqsxEe0WYoM8qac5GIKZLFU8TA3c5jrvPGiOVQUsDqJeL5u9pVjdAeR?=
 =?us-ascii?Q?wJdw+BrvKN0wclRJ7j/O3ZCilyusf1KGNq5gDQYS76Y+sxTHDtUYJYoVlnoA?=
 =?us-ascii?Q?9DQYutlnBlP3tG1MuqxzKlNiElUO8CuNxZXTPdUj1M8enDKLzNWRa9SwZZCE?=
 =?us-ascii?Q?GLGuRLu5RVIV9dx+iR8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e98315-48e7-42bd-10c8-08d9b4337f06
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 18:59:11.9252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVSEwqZGwJD0HRCYsURiTPIvqJBsxQuaLdOMG+3ms99i+whJcr4QO/Q8Kmna1pZA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 10:26:11AM -0700, Alex Williamson wrote:
> On Mon, 29 Nov 2021 10:45:52 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Provide some more complete documentation for the migration regions
> > behavior, specifically focusing on the device_state bits and the whole
> > system view from a VMM.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  Documentation/driver-api/vfio.rst | 277 +++++++++++++++++++++++++++++-
> >  1 file changed, 276 insertions(+), 1 deletion(-)
> > 
> > Alex/Cornelia, here is the second draft of the requested documentation I promised
> > 
> > We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
> > 
> > Our thinking is that NDMA would be implemented like this:
> > 
> >    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
> > 
> > And a .add_capability ops will be used to signal to userspace driver support:
> > 
> >    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6
> 
> So based on this and the discussion later in the doc, NDMA is an
> optional device feature, is this specifically to support HNS? 

Yes. It is not trivial to implement NDMA in a device, we already have
HNS as a public existing example that cannot do it, so it is a
permanent optional feature.

> IIRC, this is a simple queue based device, but is it the fact that
> the queue lives in non-device memory that makes it such that the
> driver cannot mediate queue entries and simply add them to the to
> migration stream?

From what HNS said the device driver would have to trap every MMIO to
implement NDMA as it must prevent touches to the physical HW MMIO to
maintain the NDMA state.

The issue is that the HW migration registers can stop processing the
queue and thus enter NDMA but a MMIO touch can resume queue
processing, so NDMA cannot be sustained.

Trapping every MMIO would have a huge negative performance impact.  So
it doesn't make sense to do so for a device that is not intended to be
used in any situation where NDMA is required.

> Some discussion of this requirement would be useful in the doc,
> otherwise it seems easier to deprecate the v1 migration region
> sub-type, and increment to a v2 where NDMA is a required feature.

I can add some words a the bottom, but since NDMA is a completely
transparent optional feature I don't see any reason to have v2.

> There are so many implicit concepts here, I'm not sure I'm making a
> correct interpretation, let alone someone coming to this document for
> understanding.

That isn't really helpful feedback..

The above is something like a summary to give context to the below
which provides a lot of detail to each step.

If you read the above/below together and find stuff is lacking, then
please point to it and let's add it

> > +If the VMM has multiple VFIO devices undergoing migration then the grace
> > +states act as cross device synchronization points. The VMM must bring all
> > +devices to the grace state before advancing past it.
> > +
> > +The above reference flows are built around specific requirements on the
> > +migration driver for its implementation of the migration_state input.
> 
> I can't glean any meaning from this sentence.  "device_state" here and
> throughout?  We don't have a "migration_state".

Yes, migration_state is a spello for device_state, I'll fix them all

> > + !RESUMING
> > +   All the data transferred into the data window is loaded into the device's
> > +   internal state. The migration driver can rely on user-space issuing a
> > +   VFIO_DEVICE_RESET prior to starting RESUMING.
> 
> We can't really rely on userspace to do anything, nor has this sequence
> been part of the specified protocol.

It is exsisting behavior of qemu - which is why we documented it.

Either qemu shouldn't do it as devices must fully self-reset, or we
should have it part of the canonical flow and devices may as well
expect it. It is useful because post VFIO_DEVICE_RESET all DMA is
quiet, no outstanding PRIs exist, etc etc.

> As with the previous flows, it seems like there's a ton of implicit
> knowledge here.  Why are we documenting these here rather than in the
> uAPI header?

Because this is 300 lines already and is too complicated/long to
properly live in a uapi header.

>  I'm having a difficult time trying to understand what are
> proposals to modify the uAPI and what are interpretations of the
> existing protocol.

As far as we know this describes what current qemu does in the success
path with a single VFIO device. ie we think mlx5 conforms to this spec
and we see it works as-is with qemu, up to qemu's limitations:

 - qemu has no support for errors or error recovery, it just calls
   abort()
 - qemu does not stress the device_state and only does a few
   transition patterns
 - qemu doesn't support P2P cases due to the NDMA topic
 - simple devices like HNS will work, but not robustly in the face of
   a hostile VM and multiple VFIO devices.

> > +   To abort a RESUMING issue a VFIO_DEVICE_RESET.
>
> Any use of VFIO_DEVICE_RESET should return the device to the default
> state, but a user is free to try to use device_state to transition
> from RESUMING to any other state.  

Userspace can attempt all transitions, of course. 

However, notice this spec doesn't specify what happens on non-success
RESUMING->RUNNING. So, I'm calling that undefined behavior.

As you say:

> The driver can choose to fail that transition and even make use of
> the error device_state, but there's no expectation that a

Thus, the above advice. To reliably abort RESUMING use DEVICE_RESET,
do not use ->RUNNING.

> > +Continuous actions are in effect when migration_state bit groups are active:
> > +
> > + RUNNING | NDMA
> > +   The device is not allowed to issue new DMA operations.
> > +
> > +   Whenever the kernel returns with a migration_state of NDMA there can be no
> > +   in progress DMAs.
> > +
> 
> There are certainly event triggered actions based on setting NDMA as
> well, ex. completion of outstanding DMA.

I'm leaving it implied that there is always some work required to
begin/end these continuous behaviors

> > + !RUNNING
> > +   The device should not change its internal state. Further implies the NDMA
> > +   behavior above.
> 
> Does this also imply other device regions cannot be accessed as has
> previously been suggested?  Which?

This question is discussed/answered below

> > + - SAVING | RUNNING
> > + - NDMA
> > + - !RUNNING
> > + - SAVING | !RUNNING
> > + - RESUMING
> > + - !RESUMING
> > + - RUNNING
> > + - !NDMA
> 
> Lots of deduction left to the reader...

Do you have an alternative language? This is quite complicated, I
advise people to refer to mlx5's implementation.

> > +  As Peer to Peer DMA is a MMIO touch like any other, it is important that
> > +  userspace suspend these accesses before entering any device_state where MMIO
> > +  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
> > +  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
> > +  device does not support NDMA and rely on that to guarantee quiet MMIO.
> 
> Seems that would have its own set of consequences.

Sure, userspace has to make choices here.

> > +  Device that do not support NDMA cannot be configured to generate page faults
> > +  that require the VCPU to complete.
> 
> So the VMM is required to hide features like PRI based on NDMA support?

Yep, looks like.

> > +- pre-copy allows the device to implement a dirty log for its internal state.
> > +  During the SAVING | RUNNING state the data window should present the device
> > +  state being logged and during SAVING | !RUNNING the data window should present
> > +  the unlogged device state as well as the changes from the internal dirty log.
> 
> This is getting a bit close to specifying an implementation.

Bit close, but not too close :) I think it is clarifying to
describe the general working of pre-copy - at least people here raised
questions about what it is doing.

Overall it must work in this basic way, and devices have freedom about
what internal state they can/will log. There is just a clear division
that every internal state in the first step is either immutable or
logged, and that the second step is a delta over the first.

> > +- Migration control registers inside the same iommu_group as the VFIO device.
> 
> Not a complete sentence, is this meant as a topic header?

Sure
 
> > +  This immediately raises a security concern as user-space can use Peer to Peer
> > +  DMA to manipulate these migration control registers concurrently with
> > +  any kernel actions.
> > +
> 
> We haven't defined "migration control registers" beyond device_state,
> which is software defined "register".  What physical registers that are
> subject to p2p DMA is this actually referring to?

Here this is talking about the device's physical HW control registers.

> > +TDB - discoverable feature flag for NDMA
> 
> Is the goal to release mlx5 support without the NDMA feature and add it
> later?  

Yishai has a patch already to add NDMA to mlx5, it will come in the
next iteration once we can agree on this document. qemu will follow
sometime later.

Below are the changes I made

Thanks,
Jason

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index d9be47570f878c..69d77fb7e5a321 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -315,14 +315,14 @@ states act as cross device synchronization points. The VMM must bring all
 devices to the grace state before advancing past it.
 
 The above reference flows are built around specific requirements on the
-migration driver for its implementation of the migration_state input.
+migration driver for its implementation of the device_state input.
 
-The migration_state cannot change asynchronously, upon writing the
-migration_state the driver will either keep the current state and return
+The device_state cannot change asynchronously, upon writing the
+device_state the driver will either keep the current state and return
 failure, return failure and go to ERROR, or succeed and go to the new state.
 
-Event triggered actions happen when user-space requests a new migration_state
-that differs from the current migration_state. Actions happen on a bit group
+Event triggered actions happen when user-space requests a new device_state
+that differs from the current device_state. Actions happen on a bit group
 basis:
 
  SAVING | RUNNING
@@ -351,12 +351,12 @@ basis:
 
    If the migration data is invalid then the ERROR state must be set.
 
-Continuous actions are in effect when migration_state bit groups are active:
+Continuous actions are in effect when device_state bit groups are active:
 
  RUNNING | NDMA
    The device is not allowed to issue new DMA operations.
 
-   Whenever the kernel returns with a migration_state of NDMA there can be no
+   Whenever the kernel returns with a device_state of NDMA there can be no
    in progress DMAs.
 
  !RUNNING
@@ -384,7 +384,7 @@ Continuous actions are in effect when migration_state bit groups are active:
    during ERROR to avoid corrupting other devices or a VM during a failed
    migration.
 
-When multiple bits change in the migration_state they may describe multiple
+When multiple bits change in the device_state they may describe multiple
 event triggered actions, and multiple changes to continuous actions.  The
 migration driver must process them in a priority order:
 
@@ -399,9 +399,9 @@ migration driver must process them in a priority order:
 
 In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
 device back to device_state RUNNING. When a migration driver executes this
-ioctl it should discard the data window and set migration_state to RUNNING as
+ioctl it should discard the data window and set device_state to RUNNING as
 part of resetting the device to a clean state. This must happen even if the
-migration_state has errored. A freshly opened device FD should always be in
+device_state has errored. A freshly opened device FD should always be in
 the RUNNING state.
 
 The migration driver has limitations on what device state it can affect. Any
@@ -476,14 +476,23 @@ implementing migration:
   are pushed down to the next step in the sequence and various behaviors that
   rely on NDMA cannot be used.
 
-- Migration control registers inside the same iommu_group as the VFIO device.
-  This immediately raises a security concern as user-space can use Peer to Peer
-  DMA to manipulate these migration control registers concurrently with
+  NDMA is made optional to support simple HW implementations that either just
+  cannot do NDMA, or cannot do NDMA without a performance cost. NDMA is only
+  necessary for special features like P2P and PRI, so devices can omit it in
+  exchange for limitations on the guest.
+
+- Devices that have their HW migration control MMIO registers inside the same
+  iommu_group as the VFIO device have some special considerations. In this
+  case a driver will be operating HW registers from kernel space that are also
+  subjected to userspace controlled DMA due to the iommu_group.
+
+  This immediately raises a security concern as user-space can use Peer to
+  Peer DMA to manipulate these migration control registers concurrently with
   any kernel actions.
 
   A device driver operating such a device must ensure that kernel integrity
   cannot be broken by hostile user space operating the migration MMIO
-  registers via peer to peer, at any point in the sequence. Notably the kernel
+  registers via peer to peer, at any point in the sequence. Further the kernel
   cannot use DMA to transfer any migration data.
 
   However, as discussed above in the "Device Peer to Peer DMA" section, it can
