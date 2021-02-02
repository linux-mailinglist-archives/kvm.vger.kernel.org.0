Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579AF30CFA7
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbhBBXIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:08:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234260AbhBBXIJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 18:08:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612307201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0KSfjQfYosjGVs5adfqb0CwrgYcOVqj1G3Vu5zh9QTE=;
        b=jTi3ltbltdUUR/hfK04mWPdTV+zxxlemFARiiFBbumyUB+pJ7dSXDb3OfL0VEl7GYCQO0+
        oWCc8bzStBkH2j+dUldaXaIAU7Q6CTDTssZ7xxGGEI5e9MInDDqqc7pA3u1ERDMRlohDrJ
        gTnT0y+uqignGNqlus5qNf9JYipK5tY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-qKnM_v3VPwW3XA0-7iisaA-1; Tue, 02 Feb 2021 18:06:40 -0500
X-MC-Unique: qKnM_v3VPwW3XA0-7iisaA-1
Received: by mail-wm1-f71.google.com with SMTP id o18so1187152wmq.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 15:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0KSfjQfYosjGVs5adfqb0CwrgYcOVqj1G3Vu5zh9QTE=;
        b=elHtqBHsuaLPKxRXQgcnLHakAcXrJFD2tl7M4FkTDDGjusHzMYdfn3MMKRF9U3lJhI
         ERhA2qEvgOrVdb4UjFOys6ev/2gjdk9dILpo5dzqejjj8A5O9oVIIsVyWNNLGkBIXaNx
         FWxLMQNZtvAL5QVTWHYdhbMLuR3y8+5ylmLIjhSixX7pj+HIaNaUzAnChpnn08bbAxul
         WDGfc2DNzG+Yq8ZLc922jXcuBXlLeff6bXvveQS1TW/oBlxJyc6bhnF3Amq6KdKNh1gM
         NgmIOldy7FSTZVqP1X9BYaufie7DOjuSeoDrP8ZWIKBYMB2GsJf7eEWmdpP+ySSN7Q8E
         6KPw==
X-Gm-Message-State: AOAM5311JONz7BP2PBnt6Tbp9ZiOPWaKpbHB87oWIGZACsBdS9biNrcy
        CYwvD0rmBkSaK+epG3dp925PDQ7wbXjV1n2mAcMI5NWc1Na+Zfy37KIbW07jbgj8VEiLz8n1muj
        NrPGdRQZYr8jn
X-Received: by 2002:a1c:b7d6:: with SMTP id h205mr254045wmf.78.1612307199145;
        Tue, 02 Feb 2021 15:06:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCjhwg0fCg5LR20GcufnnWICqfC8Sio35oifdTza+f/QUYfxnR+2PgVDu9q1RaLrDdl3XMgA==
X-Received: by 2002:a1c:b7d6:: with SMTP id h205mr254028wmf.78.1612307198961;
        Tue, 02 Feb 2021 15:06:38 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id 35sm56258wrn.42.2021.02.02.15.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:06:38 -0800 (PST)
Date:   Tue, 2 Feb 2021 18:06:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com,
        pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, frankja@linux.ibm.com,
        jun.nakajima@intel.com, andi.kleen@intel.com,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 12/13] confidential guest support: Alter virtio
 default properties for protected guests
Message-ID: <20210202180328-mutt-send-email-mst@kernel.org>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-13-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202041315.196530-13-david@gibson.dropbear.id.au>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 03:13:14PM +1100, David Gibson wrote:
> The default behaviour for virtio devices is not to use the platforms normal
> DMA paths, but instead to use the fact that it's running in a hypervisor
> to directly access guest memory.  That doesn't work if the guest's memory
> is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> 
> So, if a confidential guest mechanism is enabled, then apply the
> iommu_platform=on option so it will go through normal DMA mechanisms.
> Those will presumably have some way of marking memory as shared with
> the hypervisor or hardware so that DMA will work.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Greg Kurz <groug@kaod.org>


> ---
>  hw/core/machine.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 94194ab82d..497949899b 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -33,6 +33,8 @@
>  #include "migration/global_state.h"
>  #include "migration/vmstate.h"
>  #include "exec/confidential-guest-support.h"
> +#include "hw/virtio/virtio.h"
> +#include "hw/virtio/virtio-pci.h"
>  
>  GlobalProperty hw_compat_5_2[] = {};
>  const size_t hw_compat_5_2_len = G_N_ELEMENTS(hw_compat_5_2);
> @@ -1196,6 +1198,17 @@ void machine_run_board_init(MachineState *machine)
>           * areas.
>           */
>          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> +
> +        /*
> +         * Virtio devices can't count on directly accessing guest
> +         * memory, so they need iommu_platform=on to use normal DMA
> +         * mechanisms.  That requires also disabling legacy virtio
> +         * support for those virtio pci devices which allow it.
> +         */
> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy",
> +                                   "on", true);
> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform",
> +                                   "on", false);

So overriding a boolean property always poses a problem:
if user does set iommu_platform=off we are ignoring this
silently.

Can we change iommu_platform to on/off/auto? Then we can
change how does auto behave.

Bonus points for adding "access_platform" and making it
a synonym of platform_iommu.

>      }
>  
>      machine_class->init(machine);
> -- 
> 2.29.2

