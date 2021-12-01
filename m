Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D024656D6
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 21:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244138AbhLAUG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 15:06:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230197AbhLAUGw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Dec 2021 15:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638389008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ag6o3qWiphpDzkPzIBfXt4euxxU79mdkDF5dIV66Mxw=;
        b=cO8Ym+4qdL1Y70qa2TT3KAp8TmfwtLtcBdAB1NJgCf7luryn4hWtFV+1Z+0FjReaayIkNF
        t27fBamp16EcsWD+iCz43dw/JWroqWqZd7Wev0i5a0/qWq81Alx7Gp4f5ngkDQ+zZGVJDo
        TviKYc2xZY4bi3/7XAu7rmxTjgZswx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-LNrPyZ2_MSmiOiK7Z9ieIg-1; Wed, 01 Dec 2021 15:03:26 -0500
X-MC-Unique: LNrPyZ2_MSmiOiK7Z9ieIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD95283DEAB;
        Wed,  1 Dec 2021 20:03:16 +0000 (UTC)
Received: from omen (unknown [10.2.17.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A5205DF2B;
        Wed,  1 Dec 2021 20:03:15 +0000 (UTC)
Date:   Wed, 1 Dec 2021 13:03:14 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211201130314.69ed679c@omen>
In-Reply-To: <20211201031407.GG4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Nov 2021 23:14:07 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 30, 2021 at 03:35:41PM -0700, Alex Williamson wrote:
> 
> > > From what HNS said the device driver would have to trap every MMIO to
> > > implement NDMA as it must prevent touches to the physical HW MMIO to
> > > maintain the NDMA state.
> > > 
> > > The issue is that the HW migration registers can stop processing the
> > > queue and thus enter NDMA but a MMIO touch can resume queue
> > > processing, so NDMA cannot be sustained.
> > > 
> > > Trapping every MMIO would have a huge negative performance impact.  So
> > > it doesn't make sense to do so for a device that is not intended to be
> > > used in any situation where NDMA is required.  
> > 
> > But migration is a cooperative activity with userspace.  If necessary
> > we can impose a requirement that mmap access to regions (other than the
> > migration region itself) are dropped when we're in the NDMA or !RUNNING
> > device_state.    
> 
> It is always NDMA|RUNNING, so we can't fully drop access to
> MMIO. Userspace would have to transfer from direct MMIO to
> trapping. With enough new kernel infrastructure and qemu support it
> could be done.

This is simply toggling whether the mmap MemoryRegion in QEMU is
enabled, when not enabled access falls through to the read/write access
functions.  We already have this functionality for unmasking INTx
interrupts when we don't have EOI support.
 
> Even so, we can't trap accesses through the IOMMU so such a scheme
> would still require removing IOMMU acess to the device. Given that the
> basic qemu mitigation for no NDMA support is to eliminate P2P cases by
> removing the IOMMU mappings this doesn't seem to advance anything and
> only creates complexity.

NDMA only requires that the device cease initiating DMA, so I suppose
you're suggesting that the MMIO of a device that doesn't expect to make
use of p2p DMA could be poked through DMA, which might cause the device
to initiate a DMA and potentially lose sync with mediation.  That would
be bad, but seems like a non-issue for hns.

> At least I'm not going to insist that hns do all kinds of work like
> this for a edge case they don't care about as a precondition to get a
> migration driver.

I wonder if we need a region flag to opt-out of IOMMU mappings for
devices that do not support p2p use cases.  If there were no IOMMU
mappings and mediation handled CPU driven MMIO accesses, then we'd have
a viable NDMA mode for hns.

> > There's no reason that mediation while in the NDMA state needs to
> > impose any performance penalty against the default RUNNING state.   
> 
> Eh? Mitigation of no NDMA support would have to mediate the MMIO on a
> a performance doorbell path, there is no escaping a performance
> hit. I'm not sure what you mean

Read it again, I'm suggesting that mediation during NDMA doesn't need
to carry over any performance penalty to the default run state.  We
don't care if mediation imposes a performance penalty while NDMA is set,
we're specifically attempting to quiesce the device.  The slower it
runs the better ;)

> > > > Some discussion of this requirement would be useful in the doc,
> > > > otherwise it seems easier to deprecate the v1 migration region
> > > > sub-type, and increment to a v2 where NDMA is a required feature.    
> > > 
> > > I can add some words a the bottom, but since NDMA is a completely
> > > transparent optional feature I don't see any reason to have v2.  
> > 
> > It's hardly transparent, aiui userspace is going to need to impose a
> > variety of loosely defined restrictions for devices without NDMA
> > support.  It would be far easier if we could declare NDMA support to be
> > a requirement.  
> 
> It would make userspace a bit simpler at the cost of excluding or
> complicating devices like hns for a use case they don't care about.
> 
> On the other hand, the simple solution in qemu is when there is no
> universal NDMA it simply doesn't include any MMIO ranges in the
> IOMMU.

That leads to mysterious performance penalties when a VM was previously
able to make use of (ex.) GPUDirect, but adds an hns device and suddenly
can no longer use p2p.  Or rejected hotplugs if a device has existing
NDMA capable devices, p2p might be active, but the new device does not
support NDMA.  This all makes it really complicated to get
deterministic behavior for devices.  I don't know how to make QEMU
behavior predictable and supportable in such an environment.

> > As I think Connie also had trouble with, combining device_state with
> > IOMMU migration features and VMM state, without any preceding context
> > and visual cues makes the section confusing.  I did gain context as I
> > read further though the doc, but I also had the advantage of being
> > rather familiar with the topic.  Maybe a table format would help to
> > segment the responsibilities?  
> 
> I moved the context to the bottom exactly because Connie said it was
> confusing at the start. :)
> 
> This is a RST document so I not keen to make huge formatting
> adventures for minimal readability gain.
> 
> I view this as something that probably needs to be read a few times,
> along with the code and header files for someone brand new to
> understand. I'm Ok with that, it is about consistent with kernel docs
> of this level.
> 
> What I would like is if userspace focused readers can get their
> important bits of information with less work.
> 
> > > It is exsisting behavior of qemu - which is why we documented it.  
> > 
> > QEMU resets devices as part of initializing the VM, but I don't see
> > that QEMU specifically resets a device in order to transition it to
> > the RESUMING device_state.   
> 
> We instrumented the kernel and monitored qemu, it showed up on the
> resume traces.

Exactly, it's part of the standard VM initialization sequence, not
specific to the device entering the RESUMING state.

> > > Either qemu shouldn't do it as devices must fully self-reset, or we
> > > should have it part of the canonical flow and devices may as well
> > > expect it. It is useful because post VFIO_DEVICE_RESET all DMA is
> > > quiet, no outstanding PRIs exist, etc etc.  
> > 
> > It's valid for QEMU to reset the device any time it wants, saying that
> > it cannot perform a reset before transitioning to the RESUMING state is
> > absurd.  Userspace can do redundant things for their own convenience.  
> 
> I didn't say cannot, I said it shouldn't.

Redundant perhaps, but not dis-recommended other than for overhead.

> Since qemu is the only implementation it would be easy for drivers to
> rely on the implicit reset it seems to do, it seems an important point
> that should be written either way.
> 
> I don't have a particular requirement to have the reset, but it does
> seem like a good idea. If you feel strongly, then let's say the
> opposite that the driver must enter RESUME with no preconditions,
> doing an internal reset if required.

It seems cleaner to me than unnecessarily requiring userspace to pass
through an ioctl in order to get to the next device_state.

> > We don't currently specify any precondition for a device to enter the
> > RESUMING state.  The driver can of course nak the state change with an
> > errno, or hard nak it with an errno and ERROR device_state, which would
> > require userspace to make use of VFIO_DEVICE_RESET.  
> 
> I don't think we should be relying on every driver doing something
> totally differnt on the standard path. That is only going to hurt
> interoperability.

I agree, the above is the exception path, devices should typically
allow a transition to RESUMING with no precondition, which is why I
suggest an internal reset as necessary.

> > > > As with the previous flows, it seems like there's a ton of implicit
> > > > knowledge here.  Why are we documenting these here rather than in the
> > > > uAPI header?    
> > > 
> > > Because this is 300 lines already and is too complicated/long to
> > > properly live in a uapi header.  
> > 
> > Minimally we need to resolve that this document must be consistent with
> > the uAPI.  I'm not sure that's entirely the case in this draft.  
> 
> Can you point to something please? I can't work with "I'm not sure"

The reset behavior that I'm trying to clarify above is the primary
offender, but "I'm not sure" I understand the bit prioritization enough
to know that there isn't something there as well.  I'm also not sure if
the "end of stream" phrasing below matches the uAPI.

> IMO the header file doesn't really say much and can be read in a way
> that is consistent with this more specific document.

But if this document is suggesting the mlx5/QEMU interpretation is the
only valid interpretations for driver authors, those clarifications
should be pushed back into the uAPI header.

> > >  - qemu doesn't support P2P cases due to the NDMA topic  
> > 
> > Or rather QEMU does support p2p cases regardless of the NDMA topic.  
> 
> I mean support in a way that is actually usable as without NDMA it
> corrupts the VM when it migrates it.

I think we're in agreement, I'm just pointing out that QEMU currently
has no NDMA support nor does anything to prevent p2p with non-NDMA
devices.

> > >  - simple devices like HNS will work, but not robustly in the face of
> > >    a hostile VM and multiple VFIO devices.  
> > 
> > So what's the goal here, are we trying to make the one currently
> > implemented and unsupported userspace be the gold standard to which
> > drivers should base their implementation?    
> 
> I have no idea anymore. You asked for docs and complete picture as a
> percondition for merging a driver. Here it is.
> 
> What do you want?

Looking through past conversations, I definitely asked that we figure
out how NDMA is going to work.  Are you thinking of a different request
from me?

The restriction implied by lack of NDMA support are pretty significant.
Maybe a given device like hns doesn't care because they don't intend to
support p2p, but they should care if it means we can't hot-add their
device to a VM in the presences of devices that can support p2p and if
cold plugging their device into an existing configuration implies loss
of functionality or performance elsewhere.

I'd tend to expect though that we'd incorporate NDMA documentation into
the uAPI with a formal proposal for discovery and outline a number of
those usage implications.

> > We've tried to define a specification that's more flexible than a
> > single implementation and by these standards we seem to be flipping
> > that implementation back into the specification.  
> 
> What specification!?! All we have is a couple lines in a header file
> that is no where near detailed enough for multi-driver
> interoperability with userspace. You have no idea how much effort has
> been expended to get this far based on the few breadcrumbs that were
> left, and we have access to the team that made the only other
> implementation!
> 
> *flexible* is not a specification.

There are approximately 220 lines of the uAPI header file dealing
specifically with the migration region.  A bit more than a couple.

We've tried to define it by looking at the device requirements to
support migration rather than tailor it specifically to the current QEMU
implementation of migration.  Attempting to undo that generality by
suggesting only current usage patterns are relevant is therefore going
to generate friction.

> > Userspace can attempt RESUMING -> RUNNING regardless of what we specify,
> > so a driver needs to be prepared for such an attempted state change
> > either way.  So what's the advantage to telling a driver author that
> > they can expect a given behavior?  
> 
> The above didn't tell a driver author to expect a certain behavior, it
> tells userspace what to do.

  "The migration driver can rely on user-space issuing a
   VFIO_DEVICE_RESET prior to starting RESUMING."

> > It doesn't make much sense to me to glue two separate userspace
> > operations together to say these must be done in this sequence, back to
> > back.  If we want the device to be reset in order to enter RESUMING, the
> > driver should simply reset the device as necessary during the state
> > transition.  The outward effect to the user is to specify that device
> > internal state may not be retained on transition from RUNNING ->
> > RESUMING.  
> 
> Maybe, and I'm happy if you want to specify this instead. It just
> doesn't match what we observe qemu to be doing.

Tracing that shows a reset preceding entering RESUMING doesn't suggest
to me that QEMU is performing a reset for the specific purpose of
entering RESUMING.  Correlation != causation.

> > > Do you have an alternative language? This is quite complicated, I
> > > advise people to refer to mlx5's implementation.  
> > 
> > I agree with Connie on this, if the reader of the documentation needs
> > to look at a specific driver implementation to understand the
> > reasoning, the documentation has failed.    
> 
> Lets agree on some objective here, this is not trying to be fully
> comprehensive, or fully standalone. It is intended to drive agreement,
> be informative to userspace, and be supplemental to the actual code.
> 
> > If it can be worked out by looking at the device_state write
> > function of the mlx5 driver, then surely a sentence or two for each
> > priority item can be added here.  
> 
> Please give me a suggestion then, because I don't know what will help
> here?

I'm trying... thus the suggesting just below

> > Part of the problem is that the nomenclature is unclear, we're listing
> > bit combinations, but not the changed bit(s) and we need to infer the
> > state.  
> 
> Each line lists the new state, the changed bits are thus any bits that
> make up the new state.
> 
> If you look at how mlx5 is constructed each if has a 'did it change'
> test followed by 'what state is it in now'
> 
> So the document is read as listing the order the driver enters the new
> states. I clarified it as ""must process the new device_state bits in
> a priority order""

The order I see in the v5 mlx5 post is:

if RUNNING 1->0
  quiesce + freeze
if RUNNING or SAVING change && state == !RUNNING | SAVING
  save device state
if RESUMING 0->1
  reset device state
if RESUMING 1->0
  load device state
if RUNNING 0->1
  unfreeze + unquiesce

So maybe part of my confusion stems from the fact that the mlx5 driver
doesn't support pre-copy, which by the provided list is the highest
priority.  But what actually makes that the highest priority?  Any
combination of SAVING and RESUMING is invalid, so we can eliminate
those.  We obviously can't have RUNNING and !RUNNING, so we can
eliminate all cases of !RUNNING, so we can shorten the list relativeto
prioritizing SAVING|RUNNING to:

 - SAVING | RUNNING
 - NDMA
 - !RESUMING
 - RUNNING
 - !NDMA

It seems like a transition from RESUMING -> SAVING | RUNNING is valid
and RESUMING(1->0) triggers the device state to be loaded from the
migration area, but SAVING(0->1) clears the data window, so I think
this priority scheme means a non-intuitive thing just happened.  SAVING
| RUNNING would need to be processed after !RESUMING, but maybe before
RUNNING itself.

NDMA only requires that the device cease initiating DMA before the call
returns and it only has meaning if RUNNING, so I'm not sure why setting
NDMA is given any priority.  I guess maybe we're trying
(unnecessarily?) to preempt any DMA that might occur as a result of
setting RUNNING (so why is it above cases including !RUNNING?)?

Obviously presenting a priority scheme without a discussion of the
associativity of the states and a barely sketched out nomenclature is
really not inviting an actual understanding how this is reasoned (imo).

> > flips in the presence of an existing state.  I'm not able to obviously
> > map the listing above to the latest posted version of the mlx5 driver.  
> 
> One of the things we've done is align mlx5 more clearly to this. For
> instance it no longer has a mixture of state and old state in the if
> statements, it always tests the new state so the tests logically
> follow what is written here
> 
> Stripping away the excess the expressions now look like this:
> 
>  !(state & VFIO_DEVICE_STATE_RUNNING)
>  ((state & (VFIO_DEVICE_STATE_RUNNING | VFIO_DEVICE_STATE_SAVING)) == VFIO_DEVICE_STATE_SAVING))
>  (state & VFIO_DEVICE_STATE_RESUMING)
> 
> Which mirror what is written here.

I'm feeling like there's a bit of a chicken and egg problem here to
decide if this is sufficiently clear documentation before a new posting
of the mlx5 driver where the mlx5 driver is the authoritative source
for the reasoning of the priority scheme documented here (and doesn't
make use of pre-copy).

> > > > > +  As Peer to Peer DMA is a MMIO touch like any other, it is important that
> > > > > +  userspace suspend these accesses before entering any device_state where MMIO
> > > > > +  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
> > > > > +  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
> > > > > +  device does not support NDMA and rely on that to guarantee quiet MMIO.    
> > > > 
> > > > Seems that would have its own set of consequences.    
> > > 
> > > Sure, userspace has to make choices here.  
> > 
> > It seems a bit loaded to suggest an alternative choice if it's not
> > practical or equivalent.  Maybe it's largely the phrasing, I read
> > "remove MMIO mappings" as to drop them dynamically, when I think we've
> > discussed that userspace might actually preclude these mappings for
> > non-NDMA devices such that p2p DMA cannot exist, ever.  
> 
> I mean the latter. How about "never install MMIO mappings" ?

Yup.

> > > Overall it must work in this basic way, and devices have freedom about
> > > what internal state they can/will log. There is just a clear division
> > > that every internal state in the first step is either immutable or
> > > logged, and that the second step is a delta over the first.  
> > 
> > I agree that it's a reasonable approach, though as I read the proposed
> > text, there's no mention of immutable state and no reason a driver
> > would implement a dirty log for immutable state, therefore we seem to
> > be suggesting such data for the stop-and-copy phase when it would
> > actually be preferable to include it in pre-copy.  
> 
> I'd say that is a detail we don't need to discuss/define, it has no
> user space visible consequence.

The migration data stream is entirely opaque to userspace, so what's
the benefit to userspace to suggest anything about the content in each
phase?  This is presented in a userspace edge concerns section, but the
description is much more relevant to a driver author.

> > I think the fact that a user is not required to run the pre-copy
> > phase until completion is also noteworthy.  
> 
> This text doesn't try to detail how the migration window works, that
> is a different large task. The intention is that the migration window
> must be fully drained to be successful.

Clarification, the *!RUNNING* migration window must be fully drained.

> I added this for some clarity ""The entire migration data, up to each
> end of stream must be transported from the saving to resuming side.""

Per the uAPI regarding pre-copy:

  "The user must not be required to consume all migration data before
  the device transitions to a new state, including the stop-and-copy
  state."

If "end of stream" suggests the driver defined end of the data stream
for pre-copy rather than simply the end of the user accumulated data
stream, that conflicts with the uAPI.  Thanks,

Alex

