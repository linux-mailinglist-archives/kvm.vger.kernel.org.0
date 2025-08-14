Return-Path: <kvm+bounces-54693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B246FB27075
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 22:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B82715E0A8A
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 20:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A2B274641;
	Thu, 14 Aug 2025 20:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLBGbjxA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE585272E42
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 20:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755205073; cv=none; b=OQkEVkcMDn/c14U5prxhdwLL1DRQn7TYJbyzvTz9pzN0YiN0KleSvyImX1Xbat8p986tP1puAMZSgK28OdhVx38wim9T4DS/iQprdRDsa/EUKhv3bskCunnPB/JyD4JZKLDmKY+Kd0eYrg6EFRrbsLHtej27AjgDA5AeoJ5/KD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755205073; c=relaxed/simple;
	bh=h3hOMQuTjT1pzbRT7BoWHNwcLd2epQhf+JDhueUBbjo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=stM2jZjZ70n78A26rS9GauyaIIW68mKzooFVCi+FwB78O2mtR28mGzmbk44ceRkfkpB9A7jbuTNWDTd1FdKI2HSPN6/FbJgIg9UE729NO7+T54sXf2BxUeYhfHicGNHm1tZtRMgrUvKQUCcOg9wdX3Lt4TeJy8QG0Kvlh8Up29Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLBGbjxA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755205070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fQ9W2UsTOcf4jWAFntUYepOTTgQSCF68b+8Vxa15s+g=;
	b=PLBGbjxAkAbUkuBkhhTKKoxnNULrk4hkuVfJtAAGBh/oG3A91eSUIXL1AhvWXyR/AX6ghW
	edwFa2ITUinCv7MzP0eNQ524lBUvRrzj9rgHqORKeS2CGhP8N55Vd1zK0CnnRcDtq36HeI
	Nzi4is03j/0K2h/ZvB7Qw2wih/Hpwtc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56--pgsd3_5PMing8W0S8rJig-1; Thu, 14 Aug 2025 16:57:48 -0400
X-MC-Unique: -pgsd3_5PMing8W0S8rJig-1
X-Mimecast-MFC-AGG-ID: -pgsd3_5PMing8W0S8rJig_1755205068
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e5700a5525so3239875ab.3
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 13:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755205067; x=1755809867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQ9W2UsTOcf4jWAFntUYepOTTgQSCF68b+8Vxa15s+g=;
        b=Rreb04NnxPisZgQ9KEK44IiBKU8vsGV++YHKyY+gM9DjoFzGCJwRm3BQZh3hZIHgc/
         puM5z8OgEFb0prKILNopk0omNcxxdlJNAc72s08A8eUjQ9l8o2zFb71Y60AK7RqYmrey
         ajALQ4CVzfBe3v2VArZLbu8XWxloXAGj0Cci5hlDDPUcpG2M6e1wjDydA6NxlvjZP+bU
         0GsJhac33thmw8cC72/zpWDxjmyshpZpOJ1VqMteSM23TScTT2RAsKeLU2foT9kqAMJc
         5t2UBb0gfj8hWJSJrOpTWyGWhriK3lgYsUtTtHuk2Teu8SWKveyG8FOWFddcTkNIJOgk
         Na/g==
X-Forwarded-Encrypted: i=1; AJvYcCWGWgBVE+xX+TMrQwItmLvaEDxh12nEDg7OTxCJiCa43PfWeW1rAmNv0YARl+/pW/2147g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIDPeI6ap2zYZkZZl4XHjnz0i3Ad7LQLhry/sFdBTzkmHHzgqG
	c+8hkotbLOiIUPDlxVn317GynFklKhujMGqKLp1ExKXxZsu2SaG9YrhWT1+7xs3TalcL+z7WZTs
	yoQeVToankh6/zf1EmE7jpcwqYj/Jh1xSbguK2lhi3qq+pyeslZlBuA==
X-Gm-Gg: ASbGncswwDneU5Xr+mRl+YYOd/ff41BvTJizdvo0qdZwc8es6pVmf9DispEa0vb6KBR
	/wk8iTUeZg37Uw00mngwU+CKVoQoJVjZE9lHGFgv9VhbkSc4lIq73mq4VdCYCe3CkT1We5h3HHF
	Ctu4/cjCMJ7bmkzjYwgm6SiKrTVaW0vmjUdQMZqJkYAMqpEB9vN5GUuSXWJ9FhvFSLEJiuxWOz2
	5wySbQ5xIX4LpPgTv8EhW+TBZn0b7EiWHWT1iLhvHaROAgR6ZIUJGca0BtFdVNkqZPZMM7+UdRe
	R8qtAWzFp604BZXhEG7aengPpII7puvC6RjEu0478SM=
X-Received: by 2002:a05:6602:1656:b0:881:87de:a332 with SMTP id ca18e2360f4ac-884296b9cf8mr513334239f.4.1755205067554;
        Thu, 14 Aug 2025 13:57:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeKejHpvsGmlpVI/X3yeDsu+UEU6gOL+uJN/zroDTAqxWdDg05KrgjOz0Kj21AjySc0aikqg==
X-Received: by 2002:a05:6602:1656:b0:881:87de:a332 with SMTP id ca18e2360f4ac-884296b9cf8mr513331739f.4.1755205067007;
        Thu, 14 Aug 2025 13:57:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f19ab690sm523077939f.24.2025.08.14.13.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 13:57:44 -0700 (PDT)
Date: Thu, 14 Aug 2025 14:57:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>, Bjorn Helgaas
 <helgaas@kernel.org>, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mjrosato@linux.ibm.com
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific
 function reset for zPCI
Message-ID: <20250814145743.204ca19a.alex.williamson@redhat.com>
In-Reply-To: <350a9bd5-c2a9-4206-98fd-8a7913d36112@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
	<20250813170821.1115-6-alifm@linux.ibm.com>
	<20250813143034.36f8c3a4.alex.williamson@redhat.com>
	<7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
	<20250813165631.7c22ef0f.alex.williamson@redhat.com>
	<5c76f6cfb535828f6586a67bd3409981663d14d8.camel@linux.ibm.com>
	<350a9bd5-c2a9-4206-98fd-8a7913d36112@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Aug 2025 09:33:47 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 8/14/2025 6:12 AM, Niklas Schnelle wrote:
> > On Wed, 2025-08-13 at 16:56 -0600, Alex Williamson wrote:  
> >> On Wed, 13 Aug 2025 14:52:24 -0700
> >> Farhan Ali <alifm@linux.ibm.com> wrote:
> >>  
> >>> On 8/13/2025 1:30 PM, Alex Williamson wrote:  
> >>>> On Wed, 13 Aug 2025 10:08:19 -0700
> >>>> Farhan Ali <alifm@linux.ibm.com> wrote:
> >>>>     
> >>>>> For zPCI devices we should drive a platform specific function reset
> >>>>> as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI device
> >>>>> in error state.
> >>>>>
> >>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >>>>> ---
> >>>>>    arch/s390/pci/pci.c              |  1 +
> >>>>>    drivers/vfio/pci/vfio_pci_core.c |  4 ++++
> >>>>>    drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
> >>>>>    drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++++++++++++
> >>>>>    4 files changed, 49 insertions(+)  
> > --- snip ---  
> >>>>>    
> >>>>> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
> >>>>> +{
> >>>>> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> >>>>> +	int rc = -EIO;
> >>>>> +
> >>>>> +	if (!zdev)
> >>>>> +		return -ENODEV;
> >>>>> +
> >>>>> +	/*
> >>>>> +	 * If we can't get the zdev->state_lock the device state is
> >>>>> +	 * currently undergoing a transition and we bail out - just
> >>>>> +	 * the same as if the device's state is not configured at all.
> >>>>> +	 */
> >>>>> +	if (!mutex_trylock(&zdev->state_lock))
> >>>>> +		return rc;
> >>>>> +
> >>>>> +	/* We can reset only if the function is configured */
> >>>>> +	if (zdev->state != ZPCI_FN_STATE_CONFIGURED)
> >>>>> +		goto out;
> >>>>> +
> >>>>> +	rc = zpci_hot_reset_device(zdev);
> >>>>> +	if (rc != 0)
> >>>>> +		goto out;
> >>>>> +
> >>>>> +	if (!vdev->pci_saved_state) {
> >>>>> +		pci_err(vdev->pdev, "No saved available for the device");
> >>>>> +		rc = -EIO;
> >>>>> +		goto out;
> >>>>> +	}
> >>>>> +
> >>>>> +	pci_dev_lock(vdev->pdev);
> >>>>> +	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
> >>>>> +	pci_restore_state(vdev->pdev);
> >>>>> +	pci_dev_unlock(vdev->pdev);
> >>>>> +out:
> >>>>> +	mutex_unlock(&zdev->state_lock);
> >>>>> +	return rc;
> >>>>> +}  
> >>>> This looks like it should be a device or arch specific reset
> >>>> implemented in drivers/pci, not vfio.  Thanks,
> >>>>
> >>>> Alex  
> >>> Are you suggesting to move this to an arch specific function? One thing
> >>> we need to do after the zpci_hot_reset_device, is to correctly restore
> >>> the config space of the device. And for vfio-pci bound devices we want
> >>> to restore the state of the device to when it was initially opened.  
> >> We generally rely on the abstraction of pci_reset_function() to select
> >> the correct type of reset for a function scope reset.  We've gone to
> >> quite a bit of effort to implement all device specific resets and
> >> quirks in the PCI core to be re-used across the kernel.
> >>
> >> Calling zpci_hot_reset_device() directly seems contradictory to those
> >> efforts.  Should pci_reset_function() call this universally on s390x
> >> rather than providing access to FLR/PM/SBR reset?
> >>  
> > I agree with you Alex. Still trying to figure out what's needed for
> > this. We already do zpci_hot_reset_device() in reset_slot() from the
> > s390_pci_hpc.c hotplug slot driver and that does get called via
> > pci_reset_hotplug_slot() and pci_reset_function(). There are a few
> > problems though that meant it didn't work for Farhan but I agree maybe
> > we can fix them for the general case. For one pci_reset_function()
> > via DEVICE_RESET first tries FLR but that won't work with the device in
> > the error state and MMIO blocked. Sadly __pci_reset_function_locked()
> > then concludes that other resets also won't work. So that's something
> > we might want to improve in general, for example maybe we need
> > something more like pci_dev_acpi_reset() with higher priority than FLR.  
> 
> Yeah I did think of adding something like s390x CLP reset as part of the 
> reset methods. AFAIU the s390x CLP reset is similar to ACPI _RST. But 
> that would introduce s390x specific code in pci core common code.
> 
> >
> > Now for pci_reset_hotplug_slot() via VFIO_DEVICE_PCI_HOT_RESET I'm not
> > sure why that won't work as is. @Farhan do you know?  
> 
> VFIO_DEVICE_PCI_HOT_RESET would have been sufficient interface for 
> majority of PCI devices on s390x as that would drive a bus reset. It was 
> sufficient as most devices were single bus devices. But in the latest 
> generation of machines (z17) we expose true SR-IOV and an OS can have 
> access to both PF and VFs and so these are on the same bus and can have 
> different ownership based on what is bound to vfio-pci.
> 
> My thinking for extending VFIO_DEVICE_RESET is because AFAIU its a per 
> function reset mechanism, which maps well with what our architecture 
> provides. On s390x we can drive a per function reset (via firmware) 
> through the CLP instruction driven by the zpci_hot_reset_device(). And 
> doing it as vfio zpci specific function would confine the s390x logic.
> 
> >>   Why is it
> >> universally correct here given the ioctl previously made use of
> >> standard reset mechanisms?
> >>
> >> The DEVICE_RESET ioctl is simply an in-place reset of the device,
> >> without restoring the original device state.  So we're also subtly
> >> changing that behavior here, presumably because we're targeting the
> >> specific error recovery case.  Have you considered how this might
> >> break non-error-recovery use cases?
> >>
> >> I wonder if we want a different reset mechanism for this use case
> >> rather than these subtle semantic changes.  
> > I think an alternative to that, which Farhan actually had in the
> > previous internal version, is to implement
> > pci_error_handlers::reset_done() and do the pci_load_saved_state()
> > there. That would only affect the error recovery case leaving other
> > cases alone.
> >
> >
> > Thanks,
> > Niklas  
> 
> The reason I abandoned reset_done() callback idea is because its not 
> sufficient to recover the device correctly. Today before driving a reset 
> we save the state of the device. When a device is in error state, any 
> pci load/store (on s390x they are actual instructions :)) to config 
> space would return an error value (0xffffffff). We don't have any checks 
> in pci_save_state to prevent storing error values. And after a reset 
> when we try to restore the config space (pci_dev_restore) we try to 
> write the error value and this can be problematic. By the time the 
> reset_done() callback is invoked, its already too late.

It's too late because we've re-written the error value back to config
space and as a result the device is broken?  What if
pci_restore_state() were a little smarter to detect that it has bad
read data from pci_save_state() and only restores state based on kernel
data?  Would that leave the device in a functional state that
reset_done() could restore the original saved state and push it out to
the device?

> @Alex,
> I am open to ideas/suggestions on this. Do we think we need a separate 
> VFIO ioctl to drive this or a new reset mechanism as Niklas suggested?

Unfortunately I was short sighted on VFIO_DEVICE_RESET and it's the one
ioctl that doesn't have any flags, so it's not very extensible.

Can we do more of the above, ie. enlighten the FLR/PM reset callbacks to
return -ENOTTY if the device is in an error state and config space is
returning -1 such that we fall through to a slot reset that doesn't
care how broken the device is and you auto-magically get the zpci
function you want?  Follow-up with pushing the original state in
reset_done()?  Thanks,

Alex


