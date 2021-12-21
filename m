Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7841847BED5
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 12:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbhLULZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 06:25:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58221 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237074AbhLULZ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 06:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640085925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=diN0iTqbk/YpDLUk2CRhIggtfhVmy63BxwqSpz9zNkI=;
        b=fvYafcStOFZnAyQlb39qLPxWnD97QzrdvkFqkqArKcZSdJTpeA3/C2jFnNcWamjYJXPATx
        kmRt4pOQBLOfbyl8KBLzHbZBGhWLcTV8POFIS8niekselHpky/4F5CaBrKShecoH+/N4L4
        YJVwiOZA6stzGxYFnEKxg+EESBu3X0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-w5ZqWWAtMbOZ0Ae_Z9NhzA-1; Tue, 21 Dec 2021 06:25:22 -0500
X-MC-Unique: w5ZqWWAtMbOZ0Ae_Z9NhzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ABF410168C0;
        Tue, 21 Dec 2021 11:25:20 +0000 (UTC)
Received: from localhost (unknown [10.39.193.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0710378DA0;
        Tue, 21 Dec 2021 11:24:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     jgg@nvidia.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
In-Reply-To: <20211220154930.071527e3.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <87v8zjp46l.fsf@redhat.com>
 <20211220154930.071527e3.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 21 Dec 2021 12:24:50 +0100
Message-ID: <87mtku2oal.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 20 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 20 Dec 2021 18:38:26 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Thu, Dec 09 2021, Alex Williamson <alex.williamson@redhat.com> wrote:
>> 
>> > A new NDMA state is being proposed to support a quiescent state for
>> > contexts containing multiple devices with peer-to-peer DMA support.
>> > Formally define it.  
>> 
>> [I'm wondering if we would want to use NDMA in other cases as well. Just
>> thinking out loud below.]
>> 
>> >
>> > Clarify various aspects of the migration region data fields and
>> > protocol.  Remove QEMU related terminology and flows from the uAPI;
>> > these will be provided in Documentation/ so as not to confuse the
>> > device_state bitfield with a finite state machine with restricted
>> > state transitions.
>> >
>> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> > ---
>> >  include/uapi/linux/vfio.h |  405 ++++++++++++++++++++++++---------------------
>> >  1 file changed, 214 insertions(+), 191 deletions(-)
>> >
>> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> > index ef33ea002b0b..1fdbc928f886 100644
>> > --- a/include/uapi/linux/vfio.h
>> > +++ b/include/uapi/linux/vfio.h  
>> 
>> (...)
>> 
>> > + *   The device_state field defines the following bitfield use:
>> > + *
>> > + *     - Bit 0 (RUNNING) [REQUIRED]:
>> > + *        - Setting this bit indicates the device is fully operational, the
>> > + *          device may generate interrupts, DMA, respond to MMIO, all vfio
>> > + *          device regions are functional, and the device may advance its
>> > + *          internal state.  The default device_state must indicate the device
>> > + *          in exclusively the RUNNING state, with no other bits in this field
>> > + *          set.
>> > + *        - Clearing this bit (ie. !RUNNING) must stop the operation of the
>> > + *          device.  The device must not generate interrupts, DMA, or advance
>> > + *          its internal state.  The user should take steps to restrict access
>> > + *          to vfio device regions other than the migration region while the
>> > + *          device is !RUNNING or risk corruption of the device migration data
>> > + *          stream.  The device and kernel migration driver must accept and
>> > + *          respond to interaction to support external subsystems in the
>> > + *          !RUNNING state, for example PCI MSI-X and PCI config space.
>> > + *          Failure by the user to restrict device access while !RUNNING must
>> > + *          not result in error conditions outside the user context (ex.
>> > + *          host system faults).  
>> 
>> If I consider ccw, this would mean that user space would need to stop
>> writing to the regions that initiate start/halt/... when RUNNING is
>> cleared (makes sense) and that the subchannel must be idle or even
>> disabled (so that it does not become status pending). The question is,
>> does it make sense to stop new requests and wait for the subchannel to
>> become idle during the !RUNNING transition (or even forcefully kill
>> outstanding I/O), or...
>> 
>
>> > + *     - Bit 3 (NDMA) [OPTIONAL]:
>> > + *        The NDMA or "No DMA" state is intended to be a quiescent state for
>> > + *        the device for the purposes of managing multiple devices within a
>> > + *        user context where peer-to-peer DMA between devices may be active.
>> > + *        Support for the NDMA bit is indicated through the presence of the
>> > + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
>> > + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
>> > + *        region.
>> > + *        - Setting this bit must prevent the device from initiating any
>> > + *          new DMA or interrupt transactions.  The migration driver must
>> > + *          complete any such outstanding operations prior to completing
>> > + *          the transition to the NDMA state.  The NDMA device_state
>> > + *          essentially represents a sub-set of the !RUNNING state for the
>> > + *          purpose of quiescing the device, therefore the NDMA device_state
>> > + *          bit is superfluous in combinations including !RUNNING.
>> > + *        - Clearing this bit (ie. !NDMA) negates the device operational
>> > + *          restrictions required by the NDMA state.  
>> 
>> ...should we use NDMA as the "stop new requests" state, but allow
>> running channel programs to conclude? I'm not entirely sure whether
>> that's in the spirit of NDMA (subchannels are independent of each
>> other), but it would be kind of "quiescing" already.
>> 
>> (We should probably clarify things like that in the Documentation/
>> file.)
>
> This bumps into the discussion in my other thread with Jason, we need
> to refine what NDMA means.  Based on my reply there and our previous
> discussion that QEMU could exclude p2p mappings to support VMs with
> multiple devices that don't support NDMA, I think that NDMA is only
> quiescing p2p traffic (if so, maybe should be NOP2P).  So this use of
> it seems out of scope to me.

Ok, makes sense. If the scope of this flag is indeed to be supposed
quite narrow, it might make sense to rename it.

>
> Userspace necessarily needs to stop vCPUs before stopping devices,
> which should mean that there are no new requests when a ccw device is
> transitioning to !RUNNING.  Therefore I'd expect that the transition to
> any !RUNNING state would wait from completion of running channel
> programs.

Indeed, it should not be any problem to do this for !RUNNING, I had just
been wondering about possible alternative implementations.

