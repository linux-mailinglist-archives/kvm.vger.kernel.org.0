Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7F48494F
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiADU2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:28:41 -0500
Received: from mail-dm3nam07on2083.outbound.protection.outlook.com ([40.107.95.83]:63527
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232255AbiADU2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 15:28:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxU6RywVI7zZ1wiHFGJci8b8HYz9P/Gm2hnygkHwk4XskDur9CT3DO/fpSMbC6E0ZMgvfXPNvYD3b4m1TZ/rIJLgHtz50SpopyZyXzOhDTJYo8fdubeoQvi+asc76jRqrIRauOxPJtbag6QjnOL/s/tLxuKwvesA391zzzbxYtO9Zyp9Tccw/YuWWxQFMuZKnf22Mw1WpD39o+0TX88I2cN4xxdjjXLf5Q6ak6rdXHaj46aa2VwYTZ/Du1MhDZ+46tIJUgPIa/lw+RPHO8rlOLMU+yv8n1ykV173AnZBsx+HFEb7nrod0/P+zBzmnZuZMk3r94lw1eTpiq6oWIROgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7y+NsW3jh4cXlm2wfsWoYCuWSoQvUTSE09wGg9CO/G4=;
 b=LfGdgnhuRFmH013nCYoEd6Yd4Dfh7XEMYldIZe5RHiUzsfKNO1np0/X19aTw69o3SDV/plm4uQw6cdKoind8I6zm5BDtLPF9CVK4tVECF9Ili5R+/hlf0neW0xHPrknFGFXm5aHJPCUKqo3lx+VFAv6xIzFe2IRqLVlgpGn4rnKG0XntZXb2ejlxhxF/qi0mVTnvDWemLWhmQU1NK/WUw81N7V77yxI+Q+qY5hOmbv1B4VDrzqRRc5ElnXzqXXHjkHEtKz9hkDl8tgFQIDI3gnFM4UX3KVz6LjfrvQevquvJgJ3Z9j/r90t/KYoUjBlu2Ygw1c2X/+i1bPKUI9I0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7y+NsW3jh4cXlm2wfsWoYCuWSoQvUTSE09wGg9CO/G4=;
 b=paPV7/AIPr7nrdw+J+XXz6Eas83P8FWmbgRHkT3/8rLwS/d6CpPpbGTPuNPiOMz6DXrKgpjwG7dQyqzdEjPBloA10u/tdM/luqHZ4+YAy5Ok1Q4DlQFss9RY7OeCynSedpeDa+RhoeYJq15wRSR8fseE/ZI84QXNmRj7OR6ShlnpgwZFHQCodecyUI0/2kkjXyIpTFjk/ze6jKX1rytCBqzU4laQhdF8v/u/e6OnSyWej+668JnyNc5QHXe7eMJ8WnmPAwmnQbSK9xvOSiLTJdRsUH6msZ9DGvcyaETNvf++96jR+EPNbAsOD+dvf5w2rtagsslX/V6sF0TWPqJ6Cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 20:28:37 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 20:28:37 +0000
Date:   Tue, 4 Jan 2022 16:28:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220104202834.GM2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <20211220152623.50d753ec.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220152623.50d753ec.alex.williamson@redhat.com>
X-ClientProxiedBy: BYAPR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:a03:54::45) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9380aaee-c1bf-4e7d-9cfc-08d9cfc0c954
X-MS-TrafficTypeDiagnostic: DM4PR12MB5279:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB527967BBFE36284308988B4BC24A9@DM4PR12MB5279.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSMgb+2hNBTx3Pi612K90jwnovkARX46v2KCmAI3FU/xKVr0DSnH847qoT1Hhi/Lm8ziLUVdpgcr60jE2FVAXvKQHv7iq89wNaMl8b491+wdBcp5ebmDcL1E1SsKU9sxqbaCLawT9neD1rzeSRQzHnXccMVYscGRoWtO58w9i1DiocsFsBwXGBVB42/O77Rwm46We+0F0egaNXLkB6Q3fWm7US8LstuJq0IsaPVGS2VKJ5roM9RtGCv27Tt3EWxRdypYnYmAMDXVsE+sjvReo/TIayu+Butj4XcLxMsTb8gipXeFIqPOr2r5WW1AlIZyh5iEoUlyzEXmQybu+VjURzrYKPc/QBqEcAgA4hI4JqTkukqWPysiLRZTIhzpZGUx19ICUlHAPhMUdxy9B0KNj/+LWEqGR6nj5F+se4eu2KkzV0uM8jNEqLmhbXOA4ZZaxQCwkQY97PrVqEMakwmZKwljKVM1I3PI3ay70S/+FXxzdKhXbYxSh1+xR0vDoWI+oIWZ8eA8dvWN7Sn/ExSO+YjFjptwXv3F/Ui4UgH6WEtTJIp3w4uwrze+XwXJm3/aoHrbsNW+cVHvg/C0ClmirGnseqx2pxn4HDCutjGWkIjhcmeVnrYsqJj0RxzvK+DEyLKXrAWT9ku+KGUMXjuXaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(15650500001)(86362001)(83380400001)(36756003)(6486002)(6666004)(6506007)(1076003)(2616005)(508600001)(316002)(26005)(6916009)(33656002)(186003)(8676002)(2906002)(8936002)(6512007)(4326008)(66476007)(66556008)(66946007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9pjnF+SUa72M926Z3IbH7RHnXV6chgS9O1ii4ouh3vwzEeykLRtL1EiUsht?=
 =?us-ascii?Q?Kbpv6E9bktgB9oNbu04UfeZBEOrt3Ely5fozZ81WKeDqGHjb9WaXnuIWA9Td?=
 =?us-ascii?Q?eI4WixCG9MdyiRRBdacQQjbAfxlokQs3Af0bK8u3WxSWyg2qnL8dSPlfAFeq?=
 =?us-ascii?Q?Tk4vgFpP7GMw94KeGyJrPZzWKW4k9t/otgZnVM+9wuvchwIKKoPwxn1G2ok1?=
 =?us-ascii?Q?PHEC4uVGA/5XTzi+We8hOBh20tJtZLqyu4bCU8EZ47ZniAzKfnl7PkP0B3mH?=
 =?us-ascii?Q?XhC6cHWOruiVs91L0Fle3h9fD9ROMhiJe3LSb72+8+EpG+ZF4eNm2+gGOyef?=
 =?us-ascii?Q?3/JvPXwvuwFdNmwrXXz09IkSFCzjasVPdyt0IGSR2fJ205w/17TeMYKVUZrO?=
 =?us-ascii?Q?vvo8/dtpDSyN3P7ifOvH1oUeCY7bHk3bMlYcKmUmEkscqm120I9wMsysM7Df?=
 =?us-ascii?Q?TsLFVQAoavK7dt4TPzpGurg3onMig7/4nQOvhUCgMFL1QcrjB0zMez1Gk4Bh?=
 =?us-ascii?Q?DsSvLb4ilEMOts2AMw/6SKuooA61WqbsN5e++pn0C/gQL0acwZmCmrsSa7Iu?=
 =?us-ascii?Q?+XpS0+kO5eJDXtLNz1yz2A0iVisgvWGRoVuMCf7GCeA1DpZxtpM0tlhrLhrD?=
 =?us-ascii?Q?GdMuJT37vIHFBmeTuBSONAK7vzAP6uJMRNWK5XWACHlhLP8GWcCCVmq06B6S?=
 =?us-ascii?Q?qbAKdc3AqKRfwbpIeXGi3p3sS2cUZavQthW/he8zN2Ij9fjdTlY+jmvoC8LR?=
 =?us-ascii?Q?+jd4Q6ynPbQqzIql27jFCwi8UBV1JtyF/MW7+SIhL54DXFwqi21+8o3/fULm?=
 =?us-ascii?Q?pX4HbiLSbaboRC1WjS6iawlYtwFQA8wfODFgpUq5j9KUXUX8YSL9iTNV8YBA?=
 =?us-ascii?Q?glubm23wQ6jgJ5Wkztbbq0LWmnqGG/5A6FLJk0JKM0387MxP+4ViY6ERh/H2?=
 =?us-ascii?Q?NhSHPoYwD0VM+89EFd74nQXp97IA4wdKRZ++XUpNwe3IBDFlX8imzTuIdcjN?=
 =?us-ascii?Q?tDUAwi7HUdbEBofyta7Cxao3twldTzBS2ZUrxOdP5dGpBG1zvMpttx+DlKDx?=
 =?us-ascii?Q?ljYy+isZapoUFbGuAeCBpD8QZgt4tBOqjYO4TvZj3F2oPDNfgONAWs8nSNrL?=
 =?us-ascii?Q?2rHj6jMSFqzVOx0KOlM31P2wmvYGi4jo57Afbw3qzlMu8aWtZMJHIs1cbYps?=
 =?us-ascii?Q?s9mNl05EWi+ry8QlQ5cMuyNi3de8/PB90Aql9HG00+XGz8bxnzUkLwiKNDZf?=
 =?us-ascii?Q?cjCGLH/tPEMldIT3cGZ8XyAenEst70BRkMt70tUYU8NIGCVkeTBc+PjT0Wz/?=
 =?us-ascii?Q?rMNzoDxJ+xiumRam4MJQpUYM5DZS4VYq0u5mQPGw889q6GGowJxvgguLRj8y?=
 =?us-ascii?Q?AKxyYblk6XwPjtLruY3ktrS69O7hakXB5aBJcypf99MnNZLHkXzU/hKqaRXT?=
 =?us-ascii?Q?9t7Tg6pNNPRiIGhEbBc7zd8WuuHHTWNE051YQK5HLzFaCpfSXceIbXiJ/Ibe?=
 =?us-ascii?Q?ZEpKQ+fzoR4iMD+4gcTIOWXLgdCzPPypL84ZT1Xtern7a9DEkw9khXouxCxu?=
 =?us-ascii?Q?+F/7Z2klOUwID6m46rI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9380aaee-c1bf-4e7d-9cfc-08d9cfc0c954
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 20:28:37.1677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hosJfDlXcEhaa9jyp6VOMU9APXZpqUPOc8Z1QPznD5eJ8Sr99gedFHul/4LIAJJ6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 20, 2021 at 03:26:23PM -0700, Alex Williamson wrote:

> > It also raises the question that it seems not well defined what the
> > sequence:
> > 
> > SAVING -> SAVING | RUNNING
> > 
> > Even does to the migration window?
> > 
> > Nor can I imagine what mlx5 could do beyond fail this or corrupt the
> > migration..
> 
> I think this comes down to the robustness of the migration driver.  The
> migration data window and control of how userspace is to interact with
> it is essentially meant to allow the migration driver to implement its
> own transport protocol.  In the case of mlx5 where it expects only to
> apply the received migration data on the RESUMING -> RUNNING
> transition, a "short" data segment might be reserved for providing
> sequencing information.  Each time the device enters SAVING | !RUNNING
> the driver might begin by presenting a new sequence header.  On the
> target, a new sequence header would cause any previously received
> migration data to be discarded.  A similar header would also be
> suggested to validate the migration data stream is appropriate for the
> target device.

Honestly, I have no interest in implementing something so complicated
for what should be a simple operation. We have no use case for this,
no desire to test it, it is just pure kernel cruft and complexity to
do this kind of extra work.

I think it is very telling that we are, what, 10 weeks into this now,
we have seen two HW drivers posted, and NOTHING implements like you
are imagining here. I doubt the closed drivers do any better.

Let's not make up busy work that can't be strongly justified! 

That is substantially what I see as wrong with this whole line of
thinking that the device_state must be independent bits, not a
constrained FSM.

We are actively failing, again and again, to tell if drivers are
implementing this mulit-bit vision correctly, or even specify properly
how it should work in an implementable way.

> > IMHO, we should be simplifing this before it becomes permanent API,
> > not trying to force it to work.
> 
> I agree, this is our opportunity to simplify before we're committed,
> but I don't see how we can throw out perfectly valid transitions like
> SAVING -> SAVING | RUNNING just because the driver hasn't accounted for
> managing data in the data stream.

Don't see? What do you mean? We showed how to do this exactly in the
v1.

We define the meaning of device_state to be actual FSM and write out
the allowed FSM arcs and then properly describe them.

This is what everyone else though this was already.

AFAICT you are the only person to view this as a bunch of bits. It is
why the original header file comment gave names to each of the states
and roughtly sketches out legal state transition arcs with the odd
ascii art.

So I want to stop trying to make the bunch of bits idea work. Let's
make it a FSM, let's define exactly the legal arcs, and then define
the behaviors in each FSM state. It is easy to understand and we have
a hope to get inter-operable implementations.

All the driver postings so far are demonstrating they don't get
oddball transition arcs correct, and we are clearly not able to find
these things during review.

And now you are asking for alot of extra work and complications in the
driver to support arcs that will never be used - that is really too
far, sorry.

> > Most of things I brought up in this post are resolved by the forced
> > FSM.
> 
> Until userspace tries to do something different than exactly what it
> does today, and then what?

It can't. We define the API to be exactly the permited arcs and no
others. That is what simplify means.

If we need to add new FSM arcs and new states later then their support
can be exposed via a cap flag.

This is much better than trying to define all arcs as legal, only
testing/using a small subset and hoping the somehow in the future this
results in extensible interoperability.

> > Another view is that staying in a useless state is also pointless and
> > we may as well return ERROR anyhow. Eg if exiting RESUMING failed
> > there is no other action to take besides RESET, so why didn't we
> > return ERROR to tell this directly to userspace?
> 
> And then the last packet arrives, gets written to the device that's
> still in RESUMING, and now can transition to RUNNING.

Huh? If the device indicated error during RESUMING userspace should
probably stop shoving packets into it or it will possibly corrupt the
migration stream.

> But I think we're really only after that p2p behavior and we've
> discussed that disabling p2p mappings in the VM would be a sufficient
> condition to support multiple devices without NDMA support.  I think
> that means DMA to memory is fine and DMA related to MSI is fine... but
> how does a device know which DMA is memory and which DMA is another
> device?

The device doesn't know if a particular DMA is P2P or not. This is why
the device action is called 'NO DMA'.

MSI is fine to be left unspecified because we currently virtualize all
the MSI register writes and it is impossible for a hostile guest to
corrupt them to point the address to anything but the interrupt
controller. If a MSI triggers or not in NDMA doesn't practically
matter.

It only starts to matter someday if we get the world Thomas is
thinking about where the guest can directly program the MSI registers.

> > Even if it did work reliably, the requirement is userspace must issue
> > RESET to exit ERROR and if we say the driver has to issue reset to
> > enter ERROR we are just doing a pointless double RESET.
> 
> Please read what I wrote:
> 
>     This variant is specifically chosen due to the !RUNNING state of
>     the device as the migration driver should do everything possible,
>     including an internal reset of the device, to ensure that the
>     device is fully stopped in this state.
> 
> That does not say that a driver must issue a reset to enter the ERROR
> state.  

Huh? "everything possible including an internal reset" sure sounds
like a device must issue a reset in some cases. If we keep with your
idea to rarely use ERROR then I think all the mlx5 cases that would
hit it are already so messed up that RESET will be mandatory.

> I don't have a problem if the reset is redundant to one the user needs
> to do anyway, I'd rather see any externally visible operation of the
> device stopped ASAP.  

Why? It was doing all those things before it had an error, why
should it suddenly stop now? What is this extra work helping?

Remember if we choose to return an error code instead of ERROR the
device is still running as it was, I don't see an benifit to making
ERROR different here.

ERROR just means the device has to be reset, we don't need the device
to stop doing what it was doing.

> The new and old state NDMA-like properties is also irrelevant, if a
> device enters an ERROR state moving from RUNNING -> SAVING | RUNNING
> it shouldn't continue manipulating memory and generating interrupts
> in the background.

I prefer a model where the device is allowed to keep doing whatever it
was doing before it hit the error. You are pushing for a model where
upon error we must force the device to stop.

For this view it is why the old state matters, if it was previously
allowed to DMA then it continues to be allowed to do DMA, etc.

> > The mlx5 v1 with the FSM didn't have alot of these problems we are
> > discussing. It didn't have precedence issues, it didn't have problems
> > executing odd combinations it can't support, it worked and was simple
> > to understand.
> 
> And an audit of that driver during review found that it grossly failed
> to meet the spirit of a "should" requirement.

That isn't how I see things.. The v1 driver implemented the uAPI we
all thought existed, was the FSM based uAPI the original patch authors
intended, and implemented only the FSM arcs discussed in the header
file comment.

Your idea that this is not a FSM seems to be unique here. I think
we've explored it to a reasonable conclusion to find it isn't working
out. Let's stop please.

Yishai can prepare a version with the FSM design back in including
NDMA and we can look at it.

> > In which case, why not formally specify the FSM now and avoid a driver
> > pushing a defacto spec?
> 
> It really only takes one driver implementing something like SAVING ->
> SAVING | RUNNING and QEMU taking advantage of it as a supported
> transition per the uAPI for mlx5 to be left out of the feature that
> might provide.

The uAPI spec is irrelavent, qemu can't just suddenly start doing
things that don't work on supported drivers.

What we've seen many times in the kernel is that uapis that don't have
driver interoperability don't succeed.

Jason
