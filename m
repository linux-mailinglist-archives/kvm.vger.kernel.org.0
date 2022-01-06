Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C89B486BCC
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 22:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244188AbiAFVVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 16:21:03 -0500
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:21761
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244185AbiAFVVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 16:21:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXJFAU2ZYSZu7ssRpMsX0e2i/lAI4egcr9oTmrxk+AFJT/KbBgQGaWvDj3ifoMUMwF2StEGAAkXtl3KbFfh34BXqvMfMvYPRrtjh7kUgYmNhZbNUcB2tESu4q6rG/Hh02WncYS8LxpGcQINHBpgi85aY4P/gj7cALD/4awgj4wlK640RIfvX+h5963V5XM//azUY+u5EbUNB5AtAHLF7RD4fYqHAe0hIavKCLqq0achZVzNeRvfMrP/QMHlFXALK2d/4iLGC9ffzlgR0y6n466qwuE34NhbpKer6yE2qUCxam9YYnwt8qjC7hiw8y01uu6Yz12NZGvjN0lMIeAPsxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97eMsWkj6EHKgiFYzNU9q80LwZWaaE7sdUwz/kjpLBw=;
 b=WTJFOUbHyQr9HA5r38OWcFzxALa63QEG6Tv+TPihc7ZnApir4yIO3czo3kM6mD0oXKG7DMmlfIDhMWDryr2UsNzKAxiiicZKlGhN4YfYDNvlugPv3Z60uosC/45f07PRB+s9L9MCSpBehmsFu1Sihq0W71aiP2RQo8Dgj/5TYo1PfHJtM8+ji9ZU1QUICdY8TkxsIAitUjKHiaC3JCyTLHGjU8u31INY0n4WDwOlLt3/fbRoLeQhyA6pg3VnJx60q7i1UtkIH/ranA4m79LN57nP02i1fo1uNImhaO//fiIamAsVC2qkGMh2kVKA00J+/jydYHCfNbKjGnup9MA5lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97eMsWkj6EHKgiFYzNU9q80LwZWaaE7sdUwz/kjpLBw=;
 b=cRcpGJzZf3siMri2GvgSfE70OlQlWU+HHRHvIeQaimpP5xRflap2EH+/ecSZF6A5Ldw9lGN+qzTI/AOBfDbpqqLu8shS0X5o136eNXqQudA8KoKhtyNBiEV+5yWdsQFPFWezZ4uEo1T6Se36DfYluWhZTRYIJTneL8Oea7MTQhysUyN+ATSZxmHB1l/qOAmJ9W8YSGg1J72IrDYmB5OAEOjCWVXJXFlz/ruKtxLO/Kwhs1jZ2WlmdVSz7Nw8KTDFZLbkHLBgpfGi2FySHW6hoZ4VGCazZoPdAQcE+YVmV1UB4zHQKfyBeF3fqyqTCAROVfm6f+2A519w/xhWEn3N4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 21:21:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 21:21:00 +0000
Date:   Thu, 6 Jan 2022 17:20:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220106212057.GM2328285@nvidia.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <20211220152623.50d753ec.alex.williamson@redhat.com>
 <20220104202834.GM2328285@nvidia.com>
 <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f78bbbe0-bcdf-442c-a3bd-08d9d15a6fab
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51581EBCD613F206180A2464C24C9@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5dGdw/fRpK5dbJfpIfZRaHTDuQK4ytJyMTHfSoy+DI7DOU6vpkgdtw/r/XRzXiGR8kIjKhzWecOaq2VxS8FzQbYnnm4et6sjAc4I4AuBTywJDWkcGYZvtIgbSXnY0ZtI5kFqQnO4iPVTJcl5KfbRcHfM0utMJFuPe1SMi32PiU/EJe5dmjQxYESzjCrnywXppT3XMj9pUSxPB5Pzx/FIY3ObnQbj90zbNpdJQgA705sYRkipt7FAhA//LyZmK+Nm/dbz5WhJ86hglIo4oDYUyod8r9X12+BP9nF+DqVjFaHptndpYLOa7MkcZq1WJdfOjQWLcAUMma75+0JBAs3qaZkeTEOwkOK9IMMS1gOD2fvbtenQt7iNNDSWZw5EfjrwO1rfkCp/Vv2ddRe/EqVeCjjyN2BKq+CAviIYtLq8TvGKHAsSYc1NYPhiD28vzoh6ilAuJLt8hB/v2nfpPDfA3WbQjC6dZYwZmrx18zt7wP0CuNjMAQiziEjCoyE2Ng6rS48Wq25FxntJjLuj4LnJM57zmnPriDP8gStr+Abt7tKbcfBBpUqjcSyaljzB9ZhZXUvzYWHs0NalI3Lj01EcvkgiXwnqq8XnMSmj75PY0WusaKYOkLIbumpB80Z3GsNa7U42y4M17CoheUWIvHMLiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(316002)(38100700002)(6512007)(8936002)(2616005)(8676002)(66476007)(66556008)(186003)(4326008)(5660300002)(33656002)(66946007)(86362001)(6486002)(36756003)(2906002)(15650500001)(26005)(30864003)(6666004)(1076003)(83380400001)(6916009)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nFerKEjNKVF7gzDmvHRkPmkL17ZNI2/mcLt6ur/Xf6KRsPqydA6hPRKANqEM?=
 =?us-ascii?Q?VHhGSbffIo3PKn2RRY8zSmgbVVjfB4d+eDwzMwpk+J/vGCflBYR9VturwWcA?=
 =?us-ascii?Q?rpR7jI7mCdRt1ruhspTY5GmHk/o6IFyjflipRRV/AILrt5BACJ1vd2OCPg3k?=
 =?us-ascii?Q?jW5a/hWXJNFa/CqOSJFwGt6utfgb62ikIYVCg2n/H8vaEdJgIxXGWhykCvuk?=
 =?us-ascii?Q?NgCFQElEHIJIadrzxM3PK5nGz9ODxdJwJ9RGhRxWzFCXuNkEJq0T+sxMWz29?=
 =?us-ascii?Q?ARhPkt2hXCH77bs3ifMLjkacLCJxUMK/QesBRW2S/C0G+oYF2LApe4PJcP87?=
 =?us-ascii?Q?dm19F6HZfOWkoBy32aen/CXOR0V6Q1fNOcEUEpUr4khURXNv1C76ARHhUkxG?=
 =?us-ascii?Q?wTXvd9UDjxGw1W0dd7kzDzthAxcNL2KhEvOvDt/u+ay8rhTUuc4eM/Jv9Zfu?=
 =?us-ascii?Q?fXEfCR1/jPy6QWEQH+az1qKrZc1RDb8o9pDbRJHBN5hOZTbgN94EN0QdeR+g?=
 =?us-ascii?Q?ZLP5ofe+q7vasYgJNfIu/Oe0+W7g2Cjo6dSFwwCyY2idI5NASBgKvBHNi2Tv?=
 =?us-ascii?Q?j5F8Mz5I80BRQrPQkPbbrPfj0PI2GoqDLd0fi5PjC6WdOWxYLR+T7ANh72zG?=
 =?us-ascii?Q?zBeyTAfB4HUcvkPuOxVHW3LZecf7HzXR9uRT1ff1LL1irMeQfaMGMYlq4KcU?=
 =?us-ascii?Q?QBmir8xtRgc6ZERb/36V90RxJX5UNtc1DM7fDRJpijI3h/mJYO6GIzmdxQSW?=
 =?us-ascii?Q?wYytadjfKr3umNDrThv32WhUu676EA4sndv4/icEm0LY2UG8vlv4DCkZdCft?=
 =?us-ascii?Q?iY2JQ2rpAN01JGp/yGR8oI/0hrxrMoGmfDfRdhJjvhpSYdoDdqfzl4UP1CI3?=
 =?us-ascii?Q?2JB59yxy8M7zLthJBCvcZwnc8RxYf/AMbanv/1YTimTUpZvPIEMoZXaBC16s?=
 =?us-ascii?Q?pgUexWuzDK3npgsAWYoBBGu1gEpagpgFq6jVikRrvWlYwtBcwCHTVqHHtDYa?=
 =?us-ascii?Q?m6pGoBt5c5Wwb5M9Kx9ezq9gvMGM1lc6hoqHvF0DXi/YPe+mg20GH4Gvkw/S?=
 =?us-ascii?Q?F4tG2rbOJBWODavssapDpf1sinXgTh89dftODFfhCPxyHjjPCLoGYn9ujXUa?=
 =?us-ascii?Q?iizvGB01chVWIa5DMofu7XUdEIkrOu+Mrtx5P9k1mJmg5E3UfLDJZIXyfcrB?=
 =?us-ascii?Q?9SNbXrJb1YDGfTM+SfbEaISVEDzwZMqrzyJ9h9b/y9rhiwiXINiU2kSNFpJ1?=
 =?us-ascii?Q?55n+bywM934WjxjcrVFOa5iW431d/h+qTvCdA6kgz2IvsElP+Haq04YRrqtO?=
 =?us-ascii?Q?sAKHxisFoSLeQQ/cSecq0xFMVVEcaeyyZSKH7qV6TWM8AOKJMkFMEdLdK8fh?=
 =?us-ascii?Q?Y4S4Xl2EyPVhJ5BHoaaAxZixj8zq/dcdBg5/ePwltX7GN6SRkshVo/1HJ0IF?=
 =?us-ascii?Q?OzAUdO5LZEb53Rj3rYk2PEaYkVNz5g7H7yuFfSCA+W/PSd5t62nTWgUBRYOi?=
 =?us-ascii?Q?5/ePwbe7KBHsy52hdiAlqFz8DoqLw5bmBcrDpwCSSBb3ckO2werPAj518OhV?=
 =?us-ascii?Q?uPI4YHZDd4mz5/HdC3Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78bbbe0-bcdf-442c-a3bd-08d9d15a6fab
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 21:21:00.5935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bedi/Jc9lXTL6KhYkTO73SELqAgzuK42zjAKs8TW/2/oyWHQ/jLFgDr1J9eAnxce
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 11:17:18AM -0700, Alex Williamson wrote:

> > Honestly, I have no interest in implementing something so complicated
> > for what should be a simple operation. We have no use case for this,
> > no desire to test it, it is just pure kernel cruft and complexity to
> > do this kind of extra work.
> 
> Migration is not a simple operation, we have a device with a host
> kernel driver exporting and importing device state through userspace.
> It's a playground for potential exploit vectors.  I assume this also
> means that you're not performing any sort of validation that the
> incoming data is from a compatible device or providing any versioning
> accommodations in the data stream, all features that would generally be
> considered best practices.

Our architecture has FW code performing all validation and versioning.

The driver is a dumb pipe and works on a simple snapshot basis.

The snapshot basis is the same approach the huawei driver and the 3
other drivers we have in internal development use.

The idea of forcing every snapshot style driver into some complicated
streaming scheme is bad, IMHO. We should be having code sharing here,
see below please.
 
> It's the uAPI as I understand it.  If you want a new uAPI, propose
> one.

Oh. I thought that was effectively what we are doing. So let's be
clear about it.

We are proposing a 'new API'. It will be binary and backwards
compatible with current qemu.

> > It can't. We define the API to be exactly the permited arcs and no
> > others. That is what simplify means.
> 
> IOW, define the uAPI based on what happens to be the current QEMU
> implementation and limitations.  That's exactly what we were trying to
> avoid in the uAPI design.

I don't like the characterization. Selecting only the arcs that are
useful, and well defined just happens to overlap with most of the
the arcs that qemu uses exactly because qemu is using the useful
subset.

The stuff beyond that is possibly veering into over-engineering. It
was OK when it looked like those behaviors would fall out naturally,
eg via precedence/etc, but now that we fully understand that
implementing the unused part has a real implementation cost, it is not
appealing.

> > If we need to add new FSM arcs and new states later then their support
> > can be exposed via a cap flag.
> > 
> > This is much better than trying to define all arcs as legal, only
> > testing/using a small subset and hoping the somehow in the future this
> > results in extensible interoperability.
> 
> A proposal of which states transitions you want to keep would be useful
> here.

Yishai is working it out currently in code, but you can go back to the
v1 to see where we started from on this thinking.

It looks like we end up with about 8 possible valid FSM states out of
the 16 combinatins of bits and your analysis looks about about right
on the arcs, but NDMA will be included.

We were also thinking to retain STOP. SAVING -> STOP could possibly
serve as the abort path to avoid a double action, and some of the use
cases you ID'd below are achievable if STOP remains.

> We have 20 possible transitions.  I've marked those available via the
> "odd ascii art" diagram as (a), that's 7 transitions.  We could
> essentially remove the NULL state as unreachable as there seems little
> value in the 2 transitions marked (a)* if we look only at migration,
> that would bring us down to 5 of 12 possible transitions.  We need to
> give userspace an abort path though, so we minimally need the 2
> transitions marked (b) (7/12).

> So now we can discuss the remaining 5 transitions:
> 
> {SAVING} -> {RESUMING}
> 	If not supported, user can achieve this via:
> 		{SAVING}->{RUNNING}->{RESUMING}
> 		{SAVING}-RESET->{RUNNING}->{RESUMING}

This can be:

SAVING -> STOP -> RESUMING

> 	It would likely be dis-recommended to return a device to
> 	{RUNNING} for this use case, so the latter would be preferred.

Yes, I would drop this, there is no advantage compared to manually
going to STOP, or through RESET.

> {SAVING} -> {RUNNING|SAVING}
> 	If not supported, user can achieve this via:
> 		{SAVING}->{RUNNING}->{RUNNING|SAVING}
> 
> 	Potential use case: downtime exceeded, avoid full migration
> 	restart (likely not achieved with the alternative flow).

I'm sympathetic to your use case, but this is not natural, or useful
for the snapshot/non-precopy style drivers to implement. Without
support for PRECOPY there is no functional advantage to return to
RUNNING|SAVING.

It is much better if qemu signals the far side to abort the migration,
move the local device to RUNNING and the far device through RESET ->
RESUMING to start all over again. This becomes common code for all the
snapshot drivers to rely on so we don't have to implement this
recovery logic with tricks in each driver inside the migration stream.

Shared code is better.

If someone does think this usecase is important they can add a cap
flag and implement this arc along with the qemu support/etc for that
driver. To be meaningful it would have to be along with a device that
implements PRECOPY with dirty tracking, and a streaming post copy.

So I would discard this arc, at least from the mandatory set.

> {RESUMING} -> {SAVING}
> 	If not supported:
> 		{RESUMING}->{RUNNING}->{SAVING}
> 		{RESUMING}-RESET->{RUNNING}->{SAVING}

The simplified version would be:

    RESUMING -> STOP -> SAVING

> 	Potential use case: validate migration data in = data out (also
> 	cannot be achieved with alternative flow, as device passes
> 	through RUNNING)

No sure mlx5 will guarantee idempotent migration data. It looks like
the Huawei device will be able to do this, and some of the other
simplish device types we are working on could possibly too.

So I'd drop this, STOP is good enough.

> {RESUMING} -> {RUNNING|SAVING}
> 	If not supported:
> 		{RESUMING}->{RUNNING}->{RUNNING|SAVING}
> 
> 	Potential use case: live ping-pong migration (alternative flow
> 	is likely sufficient)

STOP can be used here too, I would drop this since it is redundant.

> {RUNNING|SAVING} -> {RESUMING}
> 	If not supported:
> 		{RUNNING|SAVING}->{RUNNING}->{RESUMING}
> 		{RUNNING|SAVING}-RESET->{RUNNING}->{RESUMING}
> 	(again former is likely dis-recommended)
> 
> 	Potential use case: ???

Yep, discard.

> So what's the proposal?  Do we ditch all of these?  Some of these?  

Yes, all of them.

Including the NDMA states we add 2 new FSM states and 7 new arcs,
IIRC:

   SAVING | RUNNING -> SAVING | RUNNING | NDMA
   SAVING | RUNNING | NDMA -> SAVING
   SAVING | RUNNING | NDMA -> RUNNING
   SAVING | RUNNING | NDMA -> STOP

and

   RESUMING -> RUNNING | NDMA
   RUNNING | NDMA -> RUNNING
   RUNNING | NDMA -> STOP

> drivers follow the previously provided pseudo algorithm with the
> requirement that they cannot pass through an invalid state, we need to
> formally address whether the NULL state is invalid or just not
> reachable by the user.

What is a NULL state?

We have defined (from memory, forgive me I don't have access to
Yishai's latest code at the moment) 8 formal FSM states:

 RUNNING
 PRECOPY
 PRECOPY_NDMA
 STOP_COPY
 STOP
 RESUMING
 RESUMING_NDMA
 ERROR (perhaps MUST_RESET)

Which matches the state labels already given in the header comment.

Mapped onto the 4 device_state bits in an 'ABI compatible with current
qemu' way as the current header comment describes.

Then the list of allowed arcs between them close to what you have
suggested.

IMHO this substantially conforms to what is written down in the header
comment. Consistently using the state labels in code and documentation
then eliminating the named bits will conclude the change in
specification from bits to a FSM.

Yishai, we should also recast the cap discovery as some ioctl to query
directly if the driver supports an arc. Eg we can discover if NDMA is
supported by querying support for PRECOPY -> PRECOPY_NDMA, and if your
timeout use case is supported by querying support for STOP_COPY ->
PRECOPY.

Any future new states/arcs will cleanly fit into this discovery
scheme.

> > Huh? If the device indicated error during RESUMING userspace should
> > probably stop shoving packets into it or it will possibly corrupt the
> > migration stream.
> 
> If a {RESUMING}->{RUNNING} transition fails and the device remains in
> {RESUMING}, it should be valid for userspace to push data to it.  

IMHO this is not useful. If the userspace did RESUMING -> RUNNING then
that is 'end of stream' and continuning to push data is
nonsensical. It is one of the cases where design wise it is much
clearer to just say any exit from RESUMING either succeeds or
userspace needs to reset the device, eg ERROR.

Again, my perspective here is multi-device interoperability and I just
don't think we can rely on a consistent device behavior in such a
strange corner case.

> The vector table is directly accessible via the region mmap.  It
> previously was not, but that becomes a problem with 64k page sizes, and
> even some poorly designed devices on 4k systems when they don't honor
> the PCI spec recommended alignments.  

Yes, I forgot about that.

> But I think that's beside the point, if the user has vectors pointed
> at memory or other devices, they've rather already broken their
> contract for using the device.

Yes, so long as it doesn't allow to compromise the hypervisor
integrity.
 
> But I think you've identified two classes of DMA, MSI and everything
> else.  The device can assume that an MSI is special and not included in
> NDMA, but it can't know whether other arbitrary DMAs are p2p or memory.
> If we define that the minimum requirement for multi-device migration is
> to quiesce p2p DMA, ex. by not allowing it at all, then NDMA is
> actually significantly more restrictive while it's enabled.

You are right, but in any practical physical device NDMA will be
implemented by halting all DMAs, not just p2p ones.

I don't mind what we label this, so long as we understand that halting
all DMA is a valid device implementation.

Actually, having reflected on this now, one of the things on my list
to fix in iommufd, is that mdevs can get access to P2P pages at all.

This is currently buggy as-is because they cannot DMA map these
things, touch them with the CPU and kmap, or do, really, anything with
them.

So we should be blocking mdev's from accessing P2P, and in that case a
mdev driver can quite rightly say it doesn't support P2P at all and
safely NOP NDMA if NDMA is defined to only impact P2P transactions.

Perhaps that answers the question for the S390 drivers as well.

> Should a device in the ERROR state continue operation or be in a
> quiesced state?  It seems obvious to me that since the ERROR state is
> essentially undefined, the device should cease operations and be
> quiesced by the driver.  If the device is continuing to operate in the
> previous state, why would the driver place the device in the ERROR
> state?  It should have returned an errno and left the device in the
> previous state.

What we found while implementing is the use of ERROR arises when the
driver has been forced to do multiple actions and is unable to fully
unwind the state. So the device_state is not fully the original state
or fully the target state. Thus it is ERROR.

The additional requirement that the driver do another action to
quiesce the device only introduces the possiblity for triple failure.

Since it doesn't bring any value to userspace, I prefer we not define
things in this complicated way.

> > I prefer a model where the device is allowed to keep doing whatever it
> > was doing before it hit the error. You are pushing for a model where
> > upon error we must force the device to stop.
> 
> If the device continues operating in the previous mode then it
> shouldn't enter the ERROR state, it should return errno and re-reading
> device_state should indicate it's in the previous state.

Continues operating in the new/previous state is an 'upper bound' on
what it is allowed to do. For instance if we are going from RUNNING ->
SAVING mlx5 must transit through 'RUNNING|NDMA' as part of its
internal design.

If it then fails it can't continue to pretend it is RUNNING when it is
doing RUNNING|NDMA and a double failure means we can't restore
RUNNING.

Allowing ERROR to continue any behavior allowed by RUNNING allows the
device to be left in RUNNING|NDMA and eliminates the possiblity of
triple failure in a transition to 'STOP'.

Indeed we can simplify the driver by removing failure recoveries for
cases that have a double fault and simply go to ERROR. This is not so
viable if ERROR itself requires an action to enter it as we get back
to having to deal with double and triple faults.

Yishai said he should have something to look at next week. We'll take
a stab at rewording the docs you provided to reflect a FSM approach
too.

Jason
