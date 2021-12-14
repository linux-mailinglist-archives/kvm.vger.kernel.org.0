Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E214A4747F9
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 17:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhLNQ1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 11:27:12 -0500
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:2817
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236172AbhLNQ06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 11:26:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUMj4rcYZgJ8fJmM3lvw46KVPqGSX2b6kvGx/MirkYr4YWAGYbqF/CwuGt1L2y5TEl4zs2sABwUNY5iU4lZVBnYgclXa+Iu72m540hJtMoZ1Jhmq0yn5jckTYiNqYRpy6k2W7EPUoXsr9a6XGknboikiNgGujLmZoj+9qe8ElYHI+On7WSDDynSEUiLTRynY15I2qCgdPxXYggZKcj82SyhkbEYx9iW9KRGB670UtzuGMP9Zvm/r5jv+h1zJ0SI2ktRoh5amcZ2n+1olGzLJ+0OU/9NwwgOUXehtzKWB1+CLKpDDQatbC0TI5ghicX2SEnqmtmHoQpfAKzU0N1xn5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2Hq9A6B5EQftt1+XjDrxF6qRvXncCu9Zo/zZ0XSh14=;
 b=btRq+bJ5Xrk/uuXfcRqFKSTTBGAUK886I2Lr2F2xWw1JIKsmpW+pt0gpSDa+EM4NnaFot6UGKvYBhbilqeslvjJgA1OAVU4pUs518VffG3KuhviGJEbyPkph7zklNPdxL1rBp/sPIdsBVCgvGbCZ+cicyAzcbcD4p6HUnfYSV0DH+FPJl87CxtChZDApmC9LrnNh7tQDSRiAhOS2zG4keKjTXmQLGCTdJ1EjtXKVJQTN9jhXKNnQeOf6ZPEr7q2zibwAY5QWbowdRxDjavw+Tj8piv0bnblsyvmlEMmyzY/KWXLmLPPp8Pu5qYkrmuS+lh5jutHAUTD31qT1HREVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2Hq9A6B5EQftt1+XjDrxF6qRvXncCu9Zo/zZ0XSh14=;
 b=BLGUPQL6ea+BEwKBvfipAT7va3ku+DEnWDWd56aEyCoiRI9oQiAn+t2aB9EQsrTGgGW4FYM/xpS5sqKHOd/8K/LxEPly6nrhneQRGjYUfGZBRTPSW23984G6Fa8i5Aw9FX+ybveM85Nxa1ucvyOv1nyXI+21f7fb3xXhOCd5BfY3tjludtXGbEtWQ4//yBZVJ75QQ7RX5DYxSKtc04r9DXMIO88HPiHGoM1QM0KmYU/oKt7YCZFMiewEay/chCGudc2y44PGpkwSw0g7j4CQZWVdt6oVa5yqLyeJ1h8c2BAOQ58NKW4QWrAVBEyH9sot6bnmyhudDzH0uYmJkgzBBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 16:26:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 16:26:56 +0000
Date:   Tue, 14 Dec 2021 12:26:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20211214162654.GJ6385@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213134038.39bb0618.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aca6dec-b2d1-4580-df89-08d9bf1e8b64
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362962484A1A9012D344D69C2759@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKXBji44gx9m2r3yec61j9T0JiEQrYS1Es1vjexxcJLBV52MK7gnM6/pSIyDCN6lKS0tJ3GumlOV8+F1vbplOhdyohC3/drqUogzlYzLSR13oZJUrFLpnPHskGCGP11Ca2QNydDd5aJRsNEoolK5i5ajPa9BqYsZ58rIYGyqn7sW7FjzZoyyUgASdxCJshdAtMtunE+3IuCABRSK9RnnB29QG3RFwntJROGhXDjXCF8rDoEfqPFgvPJ4scq5uHRRr/ROVt5L5zI8Igv4ZLp9hOvXdZuL3AA27P5MoEc2x+TbqCNs8paa1ocWYLjUg6gbar1AkVJxW5JzuLbEKz6tjtR8Ai1LBV7NoE/yknNy+6e0HjEXNPNxlJQnuRotUPk5aGvj5EThx6msThNz6NuEWs0OGqyrF/6b+b2hZWqlK36IuEiynNZy3ES5GC7vJFhArcR/bcGOPCglQgGwfTnDrVJtVlJFJJr7Nv9yMRQMzEQPpeCsLamw07uKKwoQ36qle1dxDFnU4GYT1Nz3McpNW9qZCnysDm9UrHjwVzyKp5YSRSvDO3Md5fyCuaLvej9NbgmFpZVCOqblo3Wbfjw+QZrhRwh50DHHOcn8DwfElRUNHgPTRilysiHQKQlD19T1OFgSZNcFxSDQZDsfjJVojw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(8936002)(8676002)(1076003)(4326008)(26005)(30864003)(186003)(508600001)(6506007)(66946007)(66556008)(15650500001)(316002)(66476007)(6512007)(6916009)(2906002)(83380400001)(2616005)(86362001)(38100700002)(36756003)(33656002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HsubDI6r2Xzuxjr5m0BWdW/vwrrXTaEGGuhPvrYy9G43kzDTfJIVZ6EBJvht?=
 =?us-ascii?Q?bRJ4RQ8N7qqkDBekwMXE0H7RiTGwSoEhyxAUfPHacBdLosAHjQ07rccQCBS7?=
 =?us-ascii?Q?r5wRMpa94j0n/XlHhJ1UAv2vKlwQSILJtq2A5r5WZNbcOZhXSOTpF8tg0Ntw?=
 =?us-ascii?Q?owO5158Y/Dgt7yEDcHDRDC888M8VLz3Mu8DntmIr9kgZZ6mmm3otI7aWXiut?=
 =?us-ascii?Q?3WQXE1GnG08rnWkwOuAxUHhQYjIlXulVe8S/CyU1YJZtyVIzFuJIyNbTH5sw?=
 =?us-ascii?Q?n43nBsDeg9uzEr1lK+cIauwxvZcUWVseSjSH7WMI7ExVN0zD8BGluu3Y1YLe?=
 =?us-ascii?Q?HpB7NuGo+RdWIjearVh29GQcevZUPa3q4p/bQmGpHIYRBCghK7h9fo+6YGjS?=
 =?us-ascii?Q?zM8lXd/8M0k/mt/HjuZiexLYbVFa90jJ7crhrSOhfcmsox78UrDfdoDrJUsG?=
 =?us-ascii?Q?WXhE6x3P0azmEm4z+2klwFKFUmF5hKfKRqNc6907uQRyCz78qA8z+j1bX0H9?=
 =?us-ascii?Q?uDpzAGKe+0HqYB5ILm10NyaDc5OV+Bc3eemdn+2e4itq+5kyDCXbOHBubXZK?=
 =?us-ascii?Q?cxN5Wreb+UARmumJMJOt0B7ZAttnvT8hKx2vpV3L6OeicSDGcgX+desLrarC?=
 =?us-ascii?Q?5QDdz+EXFxVQS2joMHOGy9LuwmTGAMN8owI/iCD1Av280RDpwH9TxR7bvrGP?=
 =?us-ascii?Q?58I00us3O679/aggAwsOWxjbmEHi6yRQwJ5gDm1cUa38h7xSEQjBl+vkHgHQ?=
 =?us-ascii?Q?Q5vIdpFtCNd3rJA9QS9uJ0InmTWfm9imquhJPomxZOgTb7VSrPVSL3R6Rvqp?=
 =?us-ascii?Q?EjOyXQkOTuuZRcic3a+IRGfjU3czLdQoCM5cH1v8BMDI9dcdCFCVBgCamwsS?=
 =?us-ascii?Q?t76lllMT0xKaWFbVoA6B4D/BR3z8zXYuuoMWytPPtgEzGTSPvulbqqYl+Uik?=
 =?us-ascii?Q?x54xALCDEwWeAAdrTrliF8f9CDQCGR9IxiUClPbsBn5siMkMK4c3lf0HE/nR?=
 =?us-ascii?Q?UzU9Zj8kyQHz5Q1XVnhubblM3RG7zYWlzcb32L02eH9TLHxEyrtSkTTvauBQ?=
 =?us-ascii?Q?F16AtfqxR25q0vsR1Gp6IpwP/NU773G8tBdCkuWhnrNRFrT7854wFqWClfOt?=
 =?us-ascii?Q?i6/UkuSKLd2jx1W0dk4s9oy3fz5keVsH/UKabZ1HzWuz7olrTVzfwRFr+yww?=
 =?us-ascii?Q?EhSPu3hhPSYZ44fV65kyq58QZp97q1sv6/PNwK7NEAaAsNaTo1C0rExpqmf8?=
 =?us-ascii?Q?7YZkoPxmxVRR9gNc8OpfZOL8h3BhffVkMYfgJX+W5gV9hN1/PaZW/seS3atS?=
 =?us-ascii?Q?xFD2YEjuexkzUm0RERRJi5roSDQ6S9o1/e1ywWwrjGIxdP3XPkP6ftpPhALq?=
 =?us-ascii?Q?NscF/26CrbjbwlAc4BTZHZXEAvLItmQf7XArWilyznC+vBjPsocFBS+Z6C9L?=
 =?us-ascii?Q?hSnqdFjFT22s9gsWlSAHzZjzG8fXSSE5ZliJHb662Uqe0L6N3TCKNaJSOPZ5?=
 =?us-ascii?Q?vR1Tpai6KuYtVdDNmCY9Jn22Sy/4s33BeePEzoUAlmCxmP6e4XcHFSEbvUdv?=
 =?us-ascii?Q?u6L9XZ6rUllKx6lLGIc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aca6dec-b2d1-4580-df89-08d9bf1e8b64
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 16:26:56.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFH2z23VBlDHXFzzPd/Pw+g7dXHUvebZ7D7imu7vLCjEvX75FahjAShrWc4wNR82
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 01:40:38PM -0700, Alex Williamson wrote:

> We do specify that a migration driver has discretion in using the error
> state for failed transitions, so there are options to simplify error
> handling.

This could be OK if we can agree ERROR has undefined behavior.

> I think the basis of your priority scheme comes from that.  Ordering
> of the remaining items is more subtle though, for instance
> 0 -> SAVING | RUNNING can be broken down as:
> 
>   0 -> SAVING
>   SAVING -> SAVING | RUNNING 
> 
>   vs
> 
>   0 -> RUNNING
>   RUNNING -> SAVING | RUNNING
>
> I'd give preference to enabling logging before running and I believe
> that holds for transition (e) -> (d) as well.

IMHO, any resolution to an arbitary choice should pick an order that
follows the reference flow because we know those are useful sequences
to have today.

Generally we have no use for the sequence SAVING -> SAVING | RUNNING,
while RUNNING -> SAVING | RUNNING is part of the standard flow.

It also raises the question that it seems not well defined what the
sequence:

SAVING -> SAVING | RUNNING

Even does to the migration window?

Nor can I imagine what mlx5 could do beyond fail this or corrupt the
migration..

If we keep the "should implement transitions" language below then I
expect mlx5 to fail this, and then we have a conflict where mlx5
cannot implement these precedence rules.

This is the kind of precedence resolution I was trying to avoid.

As far as I can see the requirements are broadly:
 - Do not transit through an invalid state
 - Do not loose NDMA during the transit, eg NDMA | SAVING | RUNNING -> 0
   should not have a race where a DMA can leak out
 - Do not do transit through things like SAVING -> SAVING | RUNNING,
   and I'm not confident I have a good list of these

> And I think that also addresses the claim that we're doomed to untested
> and complicated error code handling, we unwind by simply swapping the
> args to our set state function and enter the ERROR state should that
> recursive call fail.

I had the same thought the day after I wrote this, it seems workable.

I remain concerned however that we still can't seem to reach to a
working precedence after all this time. This is a very bad sign. 

Even if we work something out adding a new state someday is
terrifying. What if we can't work out any precedence that is
compatible with todays and supports the new state?

IMHO, we should be simplifing this before it becomes permanent API,
not trying to force it to work.

> If we put it in the user's hands and prescribe only single bit flips,
> they don't really have device knowledge to optimize further than this
> like a migration driver might be able to do.

If so this argues we should go back to the enforced FSM that the v1
mlx5 posting had and forget about device_state as a bunch of bits.

Most of things I brought up in this post are resolved by the forced
FSM.

Yes, we give up some flexability, but I think the quest for
flexability is a little misguided. If the drivers don't consistently
implement the flexability then it is just cruft we cannot make use of
from userspace.

eg what practical use is SAVING -> SAVING | RUNNING if today's mlx5
implementation silently corrupts the migration stream? That instantly
makes that a no-go for userspace from an interoperability perspective
and we've accomplished nothing by allowing for it.

Please think about it, it looks like an easy resolution to all this
discussion to simply specify a fixed FSM and be done with it.

> > I thought we could tackled this when you first suggested it (eg copy
> > the mlx5 logic and be OK), but now I'm very skeptical. The idea that
> > every driver can do this right in all the corner cases doesn't seem
> > reasonable given we've made so many errors here already just in mlx5.
> > 
> > > + *     - Bit 1 (SAVING) [REQUIRED]:
> > > + *        - Setting this bit enables and initializes the migration region data  
> > 
> > I would use the word clear instead of initialize - the point of this
> > is to throw away any data that may be left over in the window from any
> > prior actions.
> 
> "Clear" to me suggests that there's some sort of internal shared buffer
> implementation that needs to be wiped between different modes.  I chose
> "initialize" because I think it offers more independence to the
> implementation.

The data window is expressed as a shared buffer in this API, there is
only one data_offset/size and data window for everything.

I think it is fine to rely on that for the description, and like all
abstractions an implementation can do whatever so long as externally
it looks like this shared buffer API.

The requirement here is that anything that pre-existed in the data
window from any prior operation is cleaned and the data window starts
empty before any data related to this SAVING is transfered.

> > > + *          window and associated fields within vfio_device_migration_info for
> > > + *          capturing the migration data stream for the device.  The migration
> > > + *          driver may perform actions such as enabling dirty logging of device
> > > + *          state with this bit.  The SAVING bit is mutually exclusive with the
> > > + *          RESUMING bit defined below.
> > > + *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
> > > + *          data window and indicates the completion or termination of the
> > > + *          migration data stream for the device.  
> > 
> > I don't know what "de-initialized" means as something a device should
> > do? IMHO there is no need to talk about the migration window here,
> > SAVING says initialize/clear - and data_offset/etc say their values
> > are undefined outside SAVING/RUNNING. That is enough.
> 
> If "initializing" the migration data region puts in place handlers for
> pending_bytes and friends, "de-initializing" would undo that operation.
> Perhaps I should use "deactivates"?

And if you don't use "initializing" we don't need to talk about
"de-initializating".

Reading the data window outside SAVING is undefined behavior it seems,
so nothing needs to be said.

> > > + *     - Bit 2 (RESUMING) [REQUIRED]:
> > > + *        - Setting this bit enables and initializes the migration region data
> > > + *          window and associated fields within vfio_device_migration_info for
> > > + *          restoring the device from a migration data stream captured from a
> > > + *          SAVING session with a compatible device.  The migration driver may
> > > + *          perform internal device resets as necessary to reinitialize the
> > > + *          internal device state for the incoming migration data.
> > > + *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
> > > + *          region data window and indicates the end of a resuming session for
> > > + *          the device.  The kernel migration driver should complete the
> > > + *          incorporation of data written to the migration data window into the
> > > + *          device internal state and perform final validity and consistency
> > > + *          checking of the new device state.  If the user provided data is
> > > + *          found to be incomplete, inconsistent, or otherwise invalid, the
> > > + *          migration driver must indicate a write(2) error and follow the
> > > + *          previously described protocol to return either the previous state
> > > + *          or an error state.  
> > 
> > Prefer this is just 'go to an error state' to avoid unnecessary
> > implementation differences.
> 
> Then it becomes a special case versus other device_state changes and
> we're forcing what you've described as an undefined state into the
> protocol.

Lets look at what recovery actions something the VMM would need to
take along the reference flow:

RUNNING -> SAVING | RUNNING
  If this fails and we are still in RUNNING and can continue

 -> SAVING | RUNNING | NDMA
 -> SAVING
  If these fail we need to go to RUNNING
  -> RUNNING
    If this fails we need to RESET

 -> 0
  Migration succeeded? Failure here should RESET

RUNNING -> RESUMING
  If this fails and we are still in RUNNING continue
 -> NDMA | RUNNING
  If this fails RESET
 -> RUNNING
  If this fails RESET, VM could be corrupted.

One view is that what the device does is irrelevant as qemu should
simply unconditionally reset in these case.

Another view is that staying in a useless state is also pointless and
we may as well return ERROR anyhow. Eg if exiting RESUMING failed
there is no other action to take besides RESET, so why didn't we
return ERROR to tell this directly to userspace?

Both are reasonable views, which is why I wrote "prefer".

> > > + *     - Bit 3 (NDMA) [OPTIONAL]:
> > > + *        The NDMA or "No DMA" state is intended to be a quiescent state for
> > > + *        the device for the purposes of managing multiple devices within a
> > > + *        user context where peer-to-peer DMA between devices may be active.
> > > + *        Support for the NDMA bit is indicated through the presence of the
> > > + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> > > + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
> > > + *        region.
> > > + *        - Setting this bit must prevent the device from initiating any
> > > + *          new DMA or interrupt transactions.  The migration driver must  
> > 
> > I'm not sure about interrupts.
> 
> In the common case an interrupt is a DMA write, so the name, if not
> intention of this state gets a bit shaky if interrupts are allowed.

Interrupts have their own masking protocol. For instance a device like
the huawei one is halting DMA by manipulating the queue registers, it
may still generate interrupts.

Yes, MSI is a MemWr, but I've never heard anyone call it a DMA - there
is no memory access here since the TLP is routed to the interrupt
controller.

This is why I'm not sure. A hostile VM certainly can corrupt the MSI,
even today and thus turn it into a DMA. As we talked before this may
be OK, but is security risky that it allows the guest to impact the
hypervisor.

Overall it seems like this is more trouble for a device like huawei's
if they want to implement NDMA using the trapping or something. Given
your right concern that NDMA should be implemented as widely as
possible making it more difficult that stricly necessary is perhaps
not good.

Other peope should comment here.

> > > + *          complete any such outstanding operations prior to completing
> > > + *          the transition to the NDMA state.  The NDMA device_state  
> > 
> > Reading this as you wrote it and I suddenly have a doubt about the PRI
> > use case. Is it reasonable that the kernel driver will block on NDMA
> > waiting for another userspace thread to resolve any outstanding PRIs?
> > 
> > Can that allow userspace to deadlock the kernel or device? Is there an
> > alterative?
> 
> I'd hope we could avoid deadlock in the kernel, but it seems trickier
> for userspace to be waiting on a write(2) operation to the device while
> also handling page request events for that same device.  Is this
> something more like a pending transaction bit where userspace asks the
> device to go quiescent and polls for that to occur?

Hum. I'm still looking into this question, but some further thoughts.

PRI doesn't do DMA, it just transfers a physical address into the PCI
device's cache that can be later used with DMA.

PRI also doesn't imply the vPRI Intel is talking about.

For PRI controlled by the hypervisor, it is completely reasonable that
NDMA returns synchronously after the PRI and the DMA that triggered it
completes. The VMM would have to understand this and ensure it doesn't
block the kernel's fault path while going to NDMA eg with userfaultfd
or something else crazy.

The other reasonable option is that NDMA cancels the DMA that
triggered the PRI and simply doesn't care how the PRI is completed
after NDMA returns.

The later is interesting because it is a possible better path to solve
the vPRI problem Intel brought up. Waiting for the VCPU is just asking
for a DOS, if NDMA can cancel the DMAs we can then just directly fail
the open PRI in the hypervisor and we don't need to care about the
VCPU. Some mess to fixup in the vIOMMU protocol on resume, but the
resume'd device simply issues a new DMA with an empty ATS cache and
does a new PRI.

It is uncertain enough that qemu should not support vPRI with
migration until we define protocol(s) and a cap flag to say the device
supports it.

> > > + *   All combinations for the above defined device_state bits are considered
> > > + *   valid with the following exceptions:
> > > + *     - RESUMING and SAVING are mutually exclusive, all combinations of
> > > + *       (RESUMING | SAVING) are invalid.  Furthermore the specific combination
> > > + *       (!NDMA | RESUMING | SAVING | !RUNNING) is reserved to indicate the
> > > + *       device error state VFIO_DEVICE_STATE_ERROR.  This variant is
> > > + *       specifically chosen due to the !RUNNING state of the device as the
> > > + *       migration driver should do everything possible, including an internal
> > > + *       reset of the device, to ensure that the device is fully stopped in
> > > + *       this state.    
> > 
> > Prefer we don't specify this. ERROR is undefined behavior and
> > userspace should reset. Any path that leads along to ERROR already
> > includes possiblities for wild DMAs and what not, so there is nothing
> > to be gained by this other than causing a lot of driver complexity,
> > IMHO.
> 
> This seems contrary to your push for consistent, interoperable
> behavior.

Formal "undefined behavior" can be a useful part of a spec, especially
if the spec is 'when you see ERROR you must do RESET', we don't really
need to constrain the device further to continue to have
interoperability.

> What's the benefit to actually leaving the state undefined or the
> drawback to preemptively resetting a device if the migration driver
> cannot determine if the device is quiesced, 

RESET puts the device back to RUNNING, so RESET alone does not remedy
the problem.

RESET followed by !RUNNING can fail, meaning the best mlx5 can do is
"SHOULD", in which case lets omit the RESET since userspace can't rely
on it.

Even if it did work reliably, the requirement is userspace must issue
RESET to exit ERROR and if we say the driver has to issue reset to
enter ERROR we are just doing a pointless double RESET.

> would need to reset the device to enter a new state anyway?  I added
> this because language in your doc suggested the error state was far
> more undefined that I understood it to be, ie. !RUNNING.

Yes it was like that, because the implementation of this strict
requirement is not nice.

Perhaps a middle ground can work:

  For device_state ERROR the device SHOULD have the device
  !RUNNING. If the ERROR arose due to a device_state change and
  if the new and old states have NDMA behavior then the device MUST
  maintain NDMA behavior while processing the device_state and
  continuing while in ERROR. Userspace MUST reset the device to
  recover from ERROR, therefore devices SHOULD NOT do a redundant
  internal reset

> > > + *   Migration drivers should attempt to support any transition between valid  
> > 
> > should? must, I think.
> 
> I think that "must" terminology is a bit contrary to the fact that we
> have a defined error state that can be used at the discretion of the
> migration driver.  To me, "should" tells the migration drivers that they
> ought to make an attempt to support all transitions, but userspace
> needs to be be prepared that they might not work.  

IMHO this is not inter-operable. At a minimum we should expect that a
driver implements a set of standard transitions, or it has to
implement all of them.

Otherwise what is the point?

If you go back to the mlx5 v1 version it did effectively this. It
enforced a FSM and only allowed some transitions. That meets the
language here with "should" but you didn't like it, and I agreed with
you then.

This is when the trouble stated :)

The mlx5 v1 with the FSM didn't have alot of these problems we are
discussing. It didn't have precedence issues, it didn't have problems
executing odd combinations it can't support, it worked and was simple
to understand.

So, if we say should here, then I vote mlx5 goes back to enforcing
its FSM and that becomes the LCD that userspace must implement to.

In which case, why not formally specify the FSM now and avoid a driver
pushing a defacto spec?

If we say MUST here then we need to figure out a precedence and 
say that some transitions are undefined behavior, like SAVING ->
SAVING|RUNNING.

> Maybe it's too subtle, but that's why I phrased it as "no data is
> currently available" and went on to specify the implications in the
> !RUNNING state.  "Currently", suggesting that in the RUNNING state the
> value is essentially volatile.

It is subtle enough to clarify that polling may see more data in
future in that case.

Thanks,
Jason
