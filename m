Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F146A0A5
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 17:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387505AbhLFQIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 11:08:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355947AbhLFQGk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 11:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638806590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=02KFbQkcvarDRNu3NjO4Zr3Tz4ybPNYjJAuDB4XSJ38=;
        b=glf3QPC6HcoCyn6d3HQJjjduuuQlvVGwG8vcHQVW6OBXEyNGuKbDcjgeVSlcztSk0oQDMg
        VFw58rpj1ZKTj+03ufycEXP174fFuxXu0HKsINqtnwl1LtenQh9rIh8NQSfKCxbpYVO5c8
        E8V3D3dKMOfihrapa2bGxqKQBZ4h9P8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-yvQJioNhMX-1cSUx6IT8Bw-1; Mon, 06 Dec 2021 11:03:09 -0500
X-MC-Unique: yvQJioNhMX-1cSUx6IT8Bw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC40880292C;
        Mon,  6 Dec 2021 16:03:02 +0000 (UTC)
Received: from localhost (unknown [10.39.193.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 107C260C13;
        Mon,  6 Dec 2021 16:03:01 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
In-Reply-To: <20211203110619.1835e584.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com> <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 06 Dec 2021 17:03:00 +0100
Message-ID: <87zgpdu3ez.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 03 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 1 Dec 2021 19:25:02 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Wed, Dec 01, 2021 at 01:03:14PM -0700, Alex Williamson wrote:
>> > On Tue, 30 Nov 2021 23:14:07 -0400
>> > Jason Gunthorpe <jgg@nvidia.com> wrote:
>> >   
>> > > On Tue, Nov 30, 2021 at 03:35:41PM -0700, Alex Williamson wrote:

>> OTOH "supportable" qemu could certainly make the default choice to
>> require devices for simplicity.
>
> I get a bit lost every time I try to sketch out how QEMU would
> implement it.  Forgive the stream of consciousness and rhetorical
> discussion below...
>
>  - Does it make sense that a device itself can opt-out of p2p mappings?
>    This is simply an MMIO access from another device rather than from
>    the CPU.  Vendors cannot preclude this use case on bare metal,
>    should they be able to in a VM?  We create heterogeneous p2p maps,
>    device A can access device B, but device B maybe can't access device
>    A.  Seems troublesome.
>
>  - If we can't have a per-device policy, then we'd need a per VM
>    policy, likely some way to opt-out of all p2p mappings for vfio
>    devices.  We need to support hotplug of devices though, so is it a
>    per VM policy or is it a per device policy which needs to be
>    consistent among all attached devices?  Perhaps a
>    "enable_p2p=on/off" option on the vfio-pci device, default [on] to
>    match current behavior.  For any case of this option being set to
>    non-default, all devices would need to set it to the same value,
>    non-compliant devices rejected.
>
>  - We could possibly allow migration=on,enable_p2p=on for a non-NDMA
>    device, but the rules change if additional devices are added, they
>    need to be rejected or migration support implicitly disappears.  That
>    seems hard to document, non-deterministic as far as a user is
>    concerned. So maybe for a non-NDMA device we'd require
>    enable_p2p=off in order to set migration=on.  That means we could
>    never enable migration on non-NDMA devices by default, which
>    probably means we also cannot enable it by default on NDMA devices
>    or we get user confusion/inconsistency.
>
>  - Can a user know which devices will require enable_p2p=off in order
>    to set migration=on?  "Read the error log" is a poor user experience
>    and difficult hurdle for libvirt.
>
> So in order to create a predictable QEMU experience in the face of
> optional NDMA per device, I think we preclude being able to enable
> migration support for any vfio device by default and we have an
> exercise to determine how a user or management tool could easily
> determine NDMA compatibility :-\

Hm, maybe we can take a page out of the confidential guest support book
and control this like we do for the virtio iommu flag?

I'm not sure whether there is a pressing need to support p2p for
non-NDMA devices?

> There's a fine line between writing an inter-operable driver and
> writing a driver for the current QEMU implementation.  Obviously we want
> to support the current QEMU implementation, but we want an interface
> that can accommodate how that implementation might evolve.  Once we
> start telling driver authors to expect specific flows rather than
> looking at the operation of each bit, then our implementations become
> more fragile, less versatile relative to the user.

What is actually on the table regarding the current QEMU implementation?
The interface is still marked as experimental, so we have some room for
changes, but we probably don't want to throw everything away.

>
>> > > > Userspace can attempt RESUMING -> RUNNING regardless of what we specify,
>> > > > so a driver needs to be prepared for such an attempted state change
>> > > > either way.  So what's the advantage to telling a driver author that
>> > > > they can expect a given behavior?    
>> > > 
>> > > The above didn't tell a driver author to expect a certain behavior, it
>> > > tells userspace what to do.  
>> > 
>> >   "The migration driver can rely on user-space issuing a
>> >    VFIO_DEVICE_RESET prior to starting RESUMING."  
>> 
>> I trimmed too much, the original text you quoted was
>> 
>> "To abort a RESUMING issue a VFIO_DEVICE_RESET."
>> 
>> Which I still think is fine.
>
> If we're writing a specification, that's really a MAY statement,
> userspace MAY issue a reset to abort the RESUMING process and return
> the device to RUNNING.  They MAY also write the device_state directly,
> which MAY return an error depending on various factors such as whether
> data has been written to the migration state and whether that data is
> complete.  If a failed transitions results in an ERROR device_state,
> the user MUST issue a reset in order to return it to a RUNNING state
> without closing the interface.

Are we actually writing a specification? If yes, we need to be more
clear on what is mandatory (MUST), advised (SHOULD), or allowed
(MAY). If I look at the current proposal, I'm not sure into which
category some of the statements fall.

>
> A recommendation to use reset to skip over potential error conditions
> when the goal is simply a new, clean RUNNING state irrespective of data
> written to the migration region, is fine.  But drivers shouldn't be
> written with only that expectation, just like they shouldn't expect a
> reset precondition to entering RESUMING.
>  
>> > Tracing that shows a reset preceding entering RESUMING doesn't suggest
>> > to me that QEMU is performing a reset for the specific purpose of
>> > entering RESUMING.  Correlation != causation.  
>> 
>> Kernel doesn't care why qemu did it - it was done. Intent doesn't
>> matter :)
>
> This is exactly the sort of "designed for QEMU implementation"
> inter-operability that I want to avoid.  It doesn't take much of a
> crystal ball to guess that gratuitous and redundant device resets slow
> VM instantiation and are a likely target for optimization.

Which brings me back to my question above: Are we wedded to all details
of the current QEMU implementation? Should we consider some of them more
as a MAY? Can we change QEMU to do things differently, given the
experimental nature of the support?

