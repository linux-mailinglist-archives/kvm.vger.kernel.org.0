Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07109487A7E
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348281AbiAGQgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:36:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230115AbiAGQgQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 11:36:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641573375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cun0JDRu3u3ODu6kzvsjmIGMUsdWD/PRPhnibbXzPgs=;
        b=iS4N1PDxQ7GF0+6G8Q6HLRVa4XxPCRSoewJD7OZsvjR7++fucQCCgm1QsQk5pOzCyTPhDc
        GpF4zwYO1t+IDqywLx1GGDBKe9X6cFOc6ApFkaNmNzIIpBlpC0fD/KK2r9sQ4LQVCGIDKc
        noGgOqOVm8f7BURtF3cfQoue09arGj0=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-W1umBsKpOZCWU639fyKe7w-1; Fri, 07 Jan 2022 11:36:14 -0500
X-MC-Unique: W1umBsKpOZCWU639fyKe7w-1
Received: by mail-oo1-f69.google.com with SMTP id b26-20020a4ac29a000000b002dac1c5b232so3820021ooq.2
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 08:36:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cun0JDRu3u3ODu6kzvsjmIGMUsdWD/PRPhnibbXzPgs=;
        b=4T8AzMRjC1oa992Wn8L4hCxKc7DYB3KPcteU9ByeWgiCwSene/9thybr/o0H2R+Cf/
         RLkN7XgmdMx9IxGvPH7gDOW83o83yQPCLCI0Yk9OCXYwMg8L8RJo2pz+SrH47SKZfAPz
         cbN85j2fzbBVjWps0l5KRTdhchqJnacYwOl+53e8HTbTD4+77Db7lfusFA6gkHTI1nAa
         MDna4jdFXsIzLUKL02BAeEYUa2RIwT3Hzk5k5NuhtD5+O3rEUWN2w/1UUv2D2/kAKR87
         IayFGnyBizn7Azu//SiYPOXyDpyb4XgrV6tBQT/EGXX7LYqvmk4z/gC+5eRK3dp7SUjI
         PJnQ==
X-Gm-Message-State: AOAM532jr4gCyasAsNfc6P7q5fxl0+2KdeCTK8Hx9DOyftH/hC8fqqfG
        KLdNKELU846lwaKbxvBhcjRZlx8fBFN668pK6B2uHGUOK67/D2nlm0X5Jaf//DIJDgG2pDty6jZ
        Q+Zrh/4+BSZCc
X-Received: by 2002:a05:6830:1d78:: with SMTP id l24mr44499675oti.13.1641573373805;
        Fri, 07 Jan 2022 08:36:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxno3eB1gaxBNMa43a5j1kp38lbfxuPqbEYKMMF5c+INctlkOV8jk7m93OFr9raz7NAHc54zg==
X-Received: by 2002:a05:6830:1d78:: with SMTP id l24mr44499657oti.13.1641573373514;
        Fri, 07 Jan 2022 08:36:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i28sm954062otf.12.2022.01.07.08.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 08:36:13 -0800 (PST)
Date:   Fri, 7 Jan 2022 09:36:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Message-ID: <20220107093611.6cbc6166.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52769D49A29D1CD7A0C87C888C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
        <BN9PR11MB52769D49A29D1CD7A0C87C888C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jan 2022 08:03:57 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> Hi, Alex,
> 
> Thanks for cleaning up this part, which is very helpful! 
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, December 10, 2021 7:34 AM
> > 
> > + *
> > + *   The device_state field defines the following bitfield use:
> > + *
> > + *     - Bit 0 (RUNNING) [REQUIRED]:
> > + *        - Setting this bit indicates the device is fully operational, the
> > + *          device may generate interrupts, DMA, respond to MMIO, all vfio
> > + *          device regions are functional, and the device may advance its
> > + *          internal state.  The default device_state must indicate the device
> > + *          in exclusively the RUNNING state, with no other bits in this field
> > + *          set.
> > + *        - Clearing this bit (ie. !RUNNING) must stop the operation of the
> > + *          device.  The device must not generate interrupts, DMA, or advance
> > + *          its internal state.   
> 
> I'm curious about what it means for the mediated device. I suppose this 
> 'must not' clause is from user p.o.v i.e. no event delivered to the user, 
> no DMA to user memory and no user visible change on mdev state. Physically 
> the device resource backing the mdev may still generate interrupt/DMA 
> to the host according to the mediation policy.
> 
> Is this understanding correct?

Yes, one mediated device stopped running can't cause the backing
device to halt, it must continue performing activities for other child
devices as well as any host duties.  The user owned device should
effectively stop.

> > +*           The user should take steps to restrict access
> > + *          to vfio device regions other than the migration region while the
> > + *          device is !RUNNING or risk corruption of the device migration data
> > + *          stream.  The device and kernel migration driver must accept and
> > + *          respond to interaction to support external subsystems in the
> > + *          !RUNNING state, for example PCI MSI-X and PCI config space.  
> 
> and also respond to mmio access if some state is saved via reading mmio?

The device must not generate a host fault, ex. PCIe UR, but the idea
here is that the device stops and preventing further access is the
user's responsibility.  Failure to stop those accesses may result in
corrupting the migration data.

> > + *          Failure by the user to restrict device access while !RUNNING must
> > + *          not result in error conditions outside the user context (ex.
> > + *          host system faults).
> > + *     - Bit 1 (SAVING) [REQUIRED]:
> > + *        - Setting this bit enables and initializes the migration region data
> > + *          window and associated fields within vfio_device_migration_info for
> > + *          capturing the migration data stream for the device.  The migration
> > + *          driver may perform actions such as enabling dirty logging of device
> > + *          state with this bit.  The SAVING bit is mutually exclusive with the
> > + *          RESUMING bit defined below.
> > + *        - Clearing this bit (ie. !SAVING) de-initializes the migration region
> > + *          data window and indicates the completion or termination of the
> > + *          migration data stream for the device.
> > + *     - Bit 2 (RESUMING) [REQUIRED]:
> > + *        - Setting this bit enables and initializes the migration region data
> > + *          window and associated fields within vfio_device_migration_info for
> > + *          restoring the device from a migration data stream captured from a
> > + *          SAVING session with a compatible device.  The migration driver may
> > + *          perform internal device resets as necessary to reinitialize the
> > + *          internal device state for the incoming migration data.
> > + *        - Clearing this bit (ie. !RESUMING) de-initializes the migration
> > + *          region data window and indicates the end of a resuming session for
> > + *          the device.  The kernel migration driver should complete the
> > + *          incorporation of data written to the migration data window into the
> > + *          device internal state and perform final validity and consistency
> > + *          checking of the new device state.  If the user provided data is
> > + *          found to be incomplete, inconsistent, or otherwise invalid, the
> > + *          migration driver must indicate a write(2) error and follow the
> > + *          previously described protocol to return either the previous state
> > + *          or an error state.
> > + *     - Bit 3 (NDMA) [OPTIONAL]:
> > + *        The NDMA or "No DMA" state is intended to be a quiescent state for
> > + *        the device for the purposes of managing multiple devices within a
> > + *        user context where peer-to-peer DMA between devices may be active.  
> 
> As discussed with Jason in another thread, this is also required for vPRI
> when stopping DMA involves completing (instead of preempting) in-fly
> requests then any vPRI for those requests must be completed when vcpu 
> is running. This cannot be done in !RUNNING which is typically transitioned 
> to after stopping vcpu.
> 
> It is also useful when the time of stopping device DMA is unbound (even
> without vPRI). Having a failure path when vcpu is running avoids breaking 
> SLA (if only capturing it after stopping vcpu). This further requires certain
> interface for the user to specify a timeout value for entering NDMA, though
> unclear to me what it will be now.
> 
> > + *        Support for the NDMA bit is indicated through the presence of the
> > + *        VFIO_REGION_INFO_CAP_MIG_NDMA capability as reported by
> > + *        VFIO_DEVICE_GET_REGION_INFO for the associated device migration
> > + *        region.
> > + *        - Setting this bit must prevent the device from initiating any
> > + *          new DMA or interrupt transactions.  The migration driver must  
> 
> Why also disabling interrupt? vcpu is still running at this point thus interrupt
> could be triggered for many reasons other than DMA...

It's my understanding that the vCPU would be halted for the NDMA use
case, we can't very well have vCPUs demanding requests to devices that
are prevented from completing them.  The NDMA phase is intended to
support completion of outstanding requests without concurrently
accepting new requests, AIUI.

Further conversations in this thread allow for interrupts and deduce
that the primary requirement of NDMA is to restrict P2P DMA, which can
be approximated as all non-MSI DMA.

> > + *          complete any such outstanding operations prior to completing
> > + *          the transition to the NDMA state.  The NDMA device_state
> > + *          essentially represents a sub-set of the !RUNNING state for the
> > + *          purpose of quiescing the device, therefore the NDMA device_state
> > + *          bit is superfluous in combinations including !RUNNING.  
> 
> 'superfluous' means doing so will get a failure, or just not recommended?

Superfluous meaning redundant.  It's allowed, but DMA is already
restricted when !RUNNING, so setting NDMA when !RUNNING is meaningless.
 
> > + *        - Clearing this bit (ie. !NDMA) negates the device operational
> > + *          restrictions required by the NDMA state.
> > + *     - Bits [31:4]:
> > + *        Reserved for future use, users should use read-modify-write
> > + *        operations to the device_state field for manipulation of the above
> > + *        defined bits for optimal compatibility.
> > + *  

FWIW, I'm expecting to see an alternative uAPI propose using a FSM
machine in the near future, so while this clarifies what I believe is
the intention of the existing uAPI, it might be deprecated before we
bother to commit such clarifications.  Thanks,

Alex

