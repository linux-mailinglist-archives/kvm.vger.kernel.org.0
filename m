Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E73747B23E
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 18:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbhLTRip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 12:38:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237749AbhLTRim (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 12:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640021922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FTqh4/MwPrq1Z+d4aqOZ1nMLxXrSCTWu4CIR9IAv3Oc=;
        b=RErAWo/Z43FqOTHk5OrvB3Hi/PCaM6HJBsJI6sFGqs/u5L4nSbDrDQu3N8+x8qPjYCbQKc
        62ApTNjQznsFfFmJHMonCkaOYMbM9yv/HRcvQxlqEAChqJY/dj0o1jY473ZisN4K55dT9z
        pEpIij9E0ctN8lCe+4m8AuInygNFwds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-MHjPnU2POSC5_ERuldINFQ-1; Mon, 20 Dec 2021 12:38:38 -0500
X-MC-Unique: MHjPnU2POSC5_ERuldINFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8538792500;
        Mon, 20 Dec 2021 17:38:37 +0000 (UTC)
Received: from localhost (unknown [10.39.193.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15A0F5BE3B;
        Mon, 20 Dec 2021 17:38:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        alex.williamson@redhat.com
Cc:     jgg@nvidia.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
In-Reply-To: <163909282574.728533.7460416142511440919.stgit@omen>
Organization: Red Hat GmbH
References: <163909282574.728533.7460416142511440919.stgit@omen>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 20 Dec 2021 18:38:26 +0100
Message-ID: <87v8zjp46l.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> A new NDMA state is being proposed to support a quiescent state for
> contexts containing multiple devices with peer-to-peer DMA support.
> Formally define it.

[I'm wondering if we would want to use NDMA in other cases as well. Just
thinking out loud below.]

>
> Clarify various aspects of the migration region data fields and
> protocol.  Remove QEMU related terminology and flows from the uAPI;
> these will be provided in Documentation/ so as not to confuse the
> device_state bitfield with a finite state machine with restricted
> state transitions.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  include/uapi/linux/vfio.h |  405 ++++++++++++++++++++++++---------------------
>  1 file changed, 214 insertions(+), 191 deletions(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..1fdbc928f886 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h

(...)

> + *   The device_state field defines the following bitfield use:
> + *
> + *     - Bit 0 (RUNNING) [REQUIRED]:
> + *        - Setting this bit indicates the device is fully operational, the
> + *          device may generate interrupts, DMA, respond to MMIO, all vfio
> + *          device regions are functional, and the device may advance its
> + *          internal state.  The default device_state must indicate the device
> + *          in exclusively the RUNNING state, with no other bits in this field
> + *          set.
> + *        - Clearing this bit (ie. !RUNNING) must stop the operation of the
> + *          device.  The device must not generate interrupts, DMA, or advance
> + *          its internal state.  The user should take steps to restrict access
> + *          to vfio device regions other than the migration region while the
> + *          device is !RUNNING or risk corruption of the device migration data
> + *          stream.  The device and kernel migration driver must accept and
> + *          respond to interaction to support external subsystems in the
> + *          !RUNNING state, for example PCI MSI-X and PCI config space.
> + *          Failure by the user to restrict device access while !RUNNING must
> + *          not result in error conditions outside the user context (ex.
> + *          host system faults).

If I consider ccw, this would mean that user space would need to stop
writing to the regions that initiate start/halt/... when RUNNING is
cleared (makes sense) and that the subchannel must be idle or even
disabled (so that it does not become status pending). The question is,
does it make sense to stop new requests and wait for the subchannel to
become idle during the !RUNNING transition (or even forcefully kill
outstanding I/O), or...

> + *     - Bit 1 (SAVING) [REQUIRED]:
> + *        - Setting this bit enables and initializes the migration region data
> + *          window and associated fields within vfio_device_migration_info for
> + *          capturing the migration data stream for the device.  The migration
> + *          driver may perform actions such as enabling dirty logging of device
> + *          state with this bit.  The SAVING bit is mutually exclusive with the
> + *          RESUMING bit defined below.
> + *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
> + *          data window and indicates the completion or termination of the
> + *          migration data stream for the device.
> + *     - Bit 2 (RESUMING) [REQUIRED]:
> + *        - Setting this bit enables and initializes the migration region data
> + *          window and associated fields within vfio_device_migration_info for
> + *          restoring the device from a migration data stream captured from a
> + *          SAVING session with a compatible device.  The migration driver may
> + *          perform internal device resets as necessary to reinitialize the
> + *          internal device state for the incoming migration data.
> + *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
> + *          region data window and indicates the end of a resuming session for
> + *          the device.  The kernel migration driver should complete the
> + *          incorporation of data written to the migration data window into the
> + *          device internal state and perform final validity and consistency
> + *          checking of the new device state.  If the user provided data is
> + *          found to be incomplete, inconsistent, or otherwise invalid, the
> + *          migration driver must indicate a write(2) error and follow the
> + *          previously described protocol to return either the previous state
> + *          or an error state.
> + *     - Bit 3 (NDMA) [OPTIONAL]:
> + *        The NDMA or "No DMA" state is intended to be a quiescent state for
> + *        the device for the purposes of managing multiple devices within a
> + *        user context where peer-to-peer DMA between devices may be active.
> + *        Support for the NDMA bit is indicated through the presence of the
> + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
> + *        region.
> + *        - Setting this bit must prevent the device from initiating any
> + *          new DMA or interrupt transactions.  The migration driver must
> + *          complete any such outstanding operations prior to completing
> + *          the transition to the NDMA state.  The NDMA device_state
> + *          essentially represents a sub-set of the !RUNNING state for the
> + *          purpose of quiescing the device, therefore the NDMA device_state
> + *          bit is superfluous in combinations including !RUNNING.
> + *        - Clearing this bit (ie. !NDMA) negates the device operational
> + *          restrictions required by the NDMA state.

...should we use NDMA as the "stop new requests" state, but allow
running channel programs to conclude? I'm not entirely sure whether
that's in the spirit of NDMA (subchannels are independent of each
other), but it would be kind of "quiescing" already.

(We should probably clarify things like that in the Documentation/
file.)

