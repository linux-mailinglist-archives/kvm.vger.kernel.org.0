Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A57845A52F
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhKWOYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 09:24:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237636AbhKWOYV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 09:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637677273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KuvFmp/5U8I/2TdF6ezJ8NVh2weYFAUnMLY1NISKsxo=;
        b=iDBbtIW43t9W/EYIADN2tG/pxoRmGlfc708yKbz4qCBiTwB/3MuOhBOzYcDj4iOLQUxJTA
        1De7BbtL41HSA8/5dKhEeAOwh7rEk1e6QcIoSUcFDXP8Asr1SVzLinwdtZJO7NEj7BcamC
        cjfQK8vdz4dliFSOa3VA+ZCsH4FAiSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-kwhMnHvOMQGix8pG9kl1xg-1; Tue, 23 Nov 2021 09:21:10 -0500
X-MC-Unique: kwhMnHvOMQGix8pG9kl1xg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68C45A40C0;
        Tue, 23 Nov 2021 14:21:08 +0000 (UTC)
Received: from localhost (unknown [10.39.193.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE9245F4EA;
        Tue, 23 Nov 2021 14:21:07 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
In-Reply-To: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Tue, 23 Nov 2021 15:21:06 +0100
Message-ID: <87zgpvj6lp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> Provide some more complete documentation for the migration region's
> behavior, specifically focusing on the device_state bits and the whole
> system view from a VMM.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst | 208 +++++++++++++++++++++++++++++-
>  1 file changed, 207 insertions(+), 1 deletion(-)
>
> Alex/Cornelia, here is the first draft of the requested documentation I promised

Thanks, I'm taking a quick first look.

[As it's Thanksgiving week in the US, I don't think Alex will be reading
this right now.]

>
> We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
>
> Our thinking is that NDMA would be implemented like this:
>
>    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
>
> And a .add_capability ops will be used to signal to userspace driver support:
>
>    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6
>
> I've described DIRTY TRACKING as a seperate concept here. With the current
> uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
> change in direction this would be per-tracker control, but no semantic change.
>
> Upon some agreement we'll include this patch in the next iteration of the mlx5 driver
> along with the NDMA bits.
>
> Thanks,
> Jason
>
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f978255b..b28c6fb89ee92f 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -242,7 +242,213 @@ group and can access them as follows::
>  VFIO User API
>  -------------------------------------------------------------------------------
>  
> -Please see include/linux/vfio.h for complete API documentation.
> +Please see include/uapi/linux/vfio.h for complete API documentation.
> +
> +-------------------------------------------------------------------------------
> +
> +VFIO migration driver API
> +-------------------------------------------------------------------------------
> +
> +VFIO drivers that support migration implement a migration control register
> +called device_state in the struct vfio_device_migration_info which is in its
> +VFIO_REGION_TYPE_MIGRATION region.
> +
> +The device_state triggers device action both when bits are set/cleared and
> +continuous behavior for each bit.

I had trouble parsing this sentence, until I read further down... maybe
use something like the following:

The device_state controls both device action and continuous behaviour.
Setting/clearing a bit triggers device action, and each bit controls
continuous behaviour.

> For VMMs they can also control if the VCPUs in
> +a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
> +TRACKING). These two controls are not part of the device_state register, KVM
> +will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
> +container controls dirty tracking.

We usually try to keep kvm out of documentation for the vfio
interfaces; better frame that as an example?

> +
> +Along with the device_state the migration driver provides a data window which
> +allows streaming migration data into or out of the device.
> +
> +A lot of flexibility is provided to userspace in how it operates these bits. The
> +reference flow for saving device state in a live migration, with all features:

It may also vary depending on the device being migrated (a subchannel
passed via vfio-ccw will behave differently than a pci device.)

> +
> +  RUNNING, VCPU_RUNNING

Nit: everywhere else you used "VCPU RUNNING".

Also, can we separate device state bits as defined in vfio.h and VMM
state bits visually a bit :) better?

> +     Normal operating state
> +  RUNNING, DIRTY TRACKING, VCPU RUNNING
> +     Log DMAs
> +     Stream all memory

all memory accessed by the device?

> +  SAVING | RUNNING, DIRTY TRACKING, VCPU RUNNING
> +     Log internal device changes (pre-copy)
> +     Stream device state through the migration window
> +
> +     While in this state repeat as desired:
> +	Atomic Read and Clear DMA Dirty log
> +	Stream dirty memory
> +  SAVING | NDMA | RUNNING, VCPU RUNNING
> +     vIOMMU grace state
> +     Complete all in progress IO page faults, idle the vIOMMU
> +  SAVING | NDMA | RUNNING
> +     Peer to Peer DMA grace state
> +     Final snapshot of DMA dirty log (atomic not required)
> +  SAVING
> +     Stream final device state through the migration window
> +     Copy final dirty data
> +  0
> +     Device is halted
> +
> +and the reference flow for resuming:
> +
> +  RUNNING
> +     Issue VFIO_DEVICE_RESET to clear the internal device state
> +  0
> +     Device is halted
> +  RESUMING
> +     Push in migration data. Data captured during pre-copy should be
> +     prepended to data captured during SAVING.
> +  NDMA | RUNNING
> +     Peer to Peer DMA grace state
> +  RUNNING, VCPU RUNNING
> +     Normal operating state
> +
> +If the VMM has multiple VFIO devices undergoing migration then the grace states
> +act as cross device synchronization points. The VMM must bring all devices to
> +the grace state before advancing past it.
> +
> +To support these operations the migration driver is required to implement
> +specific behaviors around the device_state.
> +
> +Actions on Set/Clear:
> + - SAVING | RUNNING
> +   The device clears the data window and begins streaming 'pre copy' migration
> +   data through the window. Device that cannot log internal state changes return
> +   a 0 length migration stream.

Hm. This and the following are "combination states", i.e. not what I'd
expect if I read about setting/clearing bits. What you describe is what
happens if the device has RUNNING set and additionally SAVING is set,
isn't it? What happens if we set SAVING while !RUNNING? The action below
looks like what is happening when RUNNING is cleared while SAVING is set.

> +
> + - SAVING | !RUNNING
> +   The device captures its internal state and begins streaming migration data
> +   through the migration window
> +
> + - RESUMING
> +   The data window is opened and can receive the migration data.
> +
> + - !RESUMING
> +   All the data transferred into the data window is loaded into the device's
> +   internal state. The migration driver can rely on userspace issuing a
> +   VFIO_DEVICE_RESET prior to starting RESUMING.

Can we also fail migration? I.e. clearing RESUMING without setting RUNNING.

> +
> + - DIRTY TRACKING
> +   On set clear the DMA log and start logging
> +
> +   On clear freeze the DMA log and allow userspace to read it. Userspace must
> +   take care to ensure that DMA is suspended before clearing DIRTY TRACKING, for
> +   instance by using NDMA.
> +
> +   DMA logs should be readable with an "atomic test and clear" to allow
> +   continuous non-disruptive sampling of the log.

I'm not sure whether including DIRTY TRACKING with the bits in
device_state could lead to confusion...

> +
> +Continuous Actions:
> +  - NDMA
> +    The device is not allowed to issue new DMA operations.

Doesn't that make it an action trigger as well? I.e. when NDMA is set, a
blocker for DMA operations is in place?

> +    Before NDMA returns all in progress DMAs must be completed.

What does that mean? That the operation setting NDMA in device_state
returns? This would effectively make setting NDMA a trigger to actually
stop doing any DMA.

> +
> +  - !RUNNING
> +    The device should not change its internal state. Implies NDMA. Any internal
> +    state logging can stop.

So we have:
- !RUNNING -- no DMA, regardless whether NDMA is set
- RUNNING|NDMA -- the device can change its internal state, but not do
  DMA

!RUNNING|!NDMA would basically be a valid state if a device is stopped
before RESUMING, but not for outbound migration?

> +
> +  - SAVING | !RUNNING
> +    RESUMING | !RUNNING
> +    The device may assume there are no incoming MMIO operations.
> +
> +  - RUNNING
> +    The device can alter its internal state and must respond to incoming MMIO.
> +
> +  - SAVING | RUNNING
> +    The device is logging changes to the internal state.
> +
> +  - !VCPU RUNNING
> +    The CPU must not generate dirty pages or issue MMIO operations to devices.
> +
> +  - DIRTY TRACKING
> +    DMAs are logged
> +
> +  - ERROR
> +    The behavior of the device is undefined. The device must be recovered by
> +    issuing VFIO_DEVICE_RESET.
> +

I'm wondering whether it would be better to distinguish between
individual bit meanings vs composite states than set/clear actions vs
continuous actions. This could give us a good overview about what a
device can/should do while in a certain state and what flipping a
certain bit implies.

<I still need to read through the rest of the document>

