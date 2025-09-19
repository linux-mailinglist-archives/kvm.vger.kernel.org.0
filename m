Return-Path: <kvm+bounces-58225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE4BB8B77B
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EEA31C273C7
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18F72D3EC7;
	Fri, 19 Sep 2025 22:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqQP/kpP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D76125BEF1
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758320852; cv=none; b=Z9kYm4xrp1irjyNe4dneqY44trbHf2UALIrvqLxvPr8B3SLCLeB3Wt1IkP1jw5bLHIibKFZMoXleZPZgUPvyryltyedeGfXPyTeVIdqbh7/AXME+4LEAkrOVyQJ5dyfA/yGzf2cR1cTjdmk/jFbKPWSafVT699viOu9+NpnauzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758320852; c=relaxed/simple;
	bh=iRQ8OAT4Wccv0jwiRU4Y03yMsi2yeVveN8n5ETpUfdE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eXo7/nUGHpOkV3aoPeGweELCgip5tO42YKJHpMfLQXuMrzH9jaFxhYY03KuJcy0emSDUtg9qWmhdlWfus5Nl7Jx+gRknWsephfFyyJAwU++QcUTFvdSvlq5O8Dm3WIPPapXBK/tbyUFoHPpTkg/duy7ZIXgNKhfMobgFO/55jnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqQP/kpP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758320849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7zBUG1B6Yjuv09cr614NdKH1148t7ceSZe3oMRHpm0=;
	b=eqQP/kpPXCWHyTozxFbc/uK9IRK7xbOC6XFPNKw/GEnFDbguyKTEGnomIDTMF8hrsKYv1b
	Zo7K3olRZ2VoM2+d5Wb0mDi14W6YPd91JVmufX07pTObwuy1gMMyXs4s9FGR1gOhJK4zmK
	6ZOdjuTDCWP3+bcBziFZ94ZyNUYPrsE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-ax0gLDZIMVqqOvbwyUuewg-1; Fri, 19 Sep 2025 18:27:27 -0400
X-MC-Unique: ax0gLDZIMVqqOvbwyUuewg-1
X-Mimecast-MFC-AGG-ID: ax0gLDZIMVqqOvbwyUuewg_1758320847
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-40b911746f0so6108635ab.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758320846; x=1758925646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7zBUG1B6Yjuv09cr614NdKH1148t7ceSZe3oMRHpm0=;
        b=ZyQkeQbWNKZkBqPdiT5zHhkOI+e+U506eVwk4Cbb5aGwakr1o1dj5NqYM2FIt7NuT1
         Z+xwiuKnRVvRfmP3NlQPSId+V1lmBbMISGpIthASzDtniECRm/MYNLPJbANXW2BON5VI
         RoCi9mjBb86EzG4aSk16qEHaelcBnBzNyWB9I1nMCVexG8x1fF+DLA3Ezg8jA1Rj0X8V
         /4RU0NjuENIPjOg2EW+wgfAug2gNnh8/4+BsazdmDvJ61iMjOTsKGsNjG1OnaSrvDQ1a
         DNrED6xlGpGpv/Nlk3plWs1RZjVtut5I7X/akAgszE79tSl9+U39opymYmEM9yD0BFSa
         F2VQ==
X-Gm-Message-State: AOJu0YyWumtVZn13JyFYsgyyLE3YdLocDhfE1WejDe4erny1Eumndxn7
	aph8XUg+UguqKNVJi+oWi5z9F1CZCZgEPtgwDM++66Fuamnwc3FUaCy9q+qt6BG17/zB09OPsqO
	sJjc33EdGBfCVnN/Vj1UwqBzRwOe5/OWtUCZO+sYbnDzlhp420yENgfjJEa/z2g==
X-Gm-Gg: ASbGncscab1EO6RECrGVROvHdtbLrWQ8hNbfpG+IGuKn738IoihUst7hQbV7i7YVmEm
	Wcclga2198wR902iZGGA5iLFUaAo8hjzg19dGZdfA3TgBvkOErsUMuGX/VPoCbLUWQ/gOk2xs4A
	IputkUJnsQUxs20fUmGwhUJEgHlMknvjVMEMA5tmszRxo7rkLnWMm80eLzPwVo5V7/92HqrW3eK
	7+K88ogevexzKDyrbFdX5UvAItopBHQbYFPS2WqPu22/pTREHp180+rLGQSqi+q/Cirt9CIR9sv
	bKUr5KtImZlYZUmzeVetd5PkHhEBRvIzoxUGRmS5zaY=
X-Received: by 2002:a05:6602:14cb:b0:894:6ff:6e9c with SMTP id ca18e2360f4ac-8add2201482mr326049039f.2.1758320846085;
        Fri, 19 Sep 2025 15:27:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtDrsXG22gNdOlTCT+B9j0NR/HkZuw2s4Yo+7xf+eh3MKB+/pJmRKobcMjuP7PoFW+Ahwupw==
X-Received: by 2002:a05:6602:14cb:b0:894:6ff:6e9c with SMTP id ca18e2360f4ac-8add2201482mr326047839f.2.1758320845689;
        Fri, 19 Sep 2025 15:27:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d58fc4ef4sm2641196173.83.2025.09.19.15.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 15:27:25 -0700 (PDT)
Date: Fri, 19 Sep 2025 16:27:21 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Message-ID: <20250919162721.7a38d3e2.alex.williamson@redhat.com>
In-Reply-To: <1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com>
	<20250919125603.08f600ac.alex.williamson@redhat.com>
	<1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Sep 2025 15:51:14 -0500 (CDT)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> ----- Original Message -----
> > From: "Alex Williamson" <alex.williamson@redhat.com>
> > To: "Timothy Pearson" <tpearson@raptorengineering.com>
> > Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> > Sent: Friday, September 19, 2025 1:56:03 PM
> > Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices  
> 
> > On Tue, 9 Sep 2025 15:48:46 -0500 (CDT)
> > Timothy Pearson <tpearson@raptorengineering.com> wrote:
> >   
> >> PCI devices prior to PCI 2.3 both use level interrupts and do not support
> >> interrupt masking, leading to a failure when passed through to a KVM guest on
> >> at least the ppc64 platform, which does not utilize the resample IRQFD. This
> >> failure manifests as receiving and acknowledging a single interrupt in the guest
> >> while leaving the host physical device VFIO IRQ pending.
> >> 
> >> Level interrupts in general require special handling due to their inherently
> >> asynchronous nature; both the host and guest interrupt controller need to
> >> remain in synchronization in order to coordinate mask and unmask operations.
> >> When lazy IRQ masking is used on DisINTx- hardware, the following sequence
> >> occurs:
> >>
> >>  * Level IRQ assertion on host
> >>  * IRQ trigger within host interrupt controller, routed to VFIO driver
> >>  * Host EOI with hardware level IRQ still asserted
> >>  * Software mask of interrupt source by VFIO driver
> >>  * Generation of event and IRQ trigger in KVM guest interrupt controller
> >>  * Level IRQ deassertion on host
> >>  * Guest EOI
> >>  * Guest IRQ level deassertion
> >>  * Removal of software mask by VFIO driver
> >> 
> >> Note that no actual state change occurs within the host interrupt controller,
> >> unlike what would happen with either DisINTx+ hardware or message interrupts.
> >> The host EOI is not fired with the hardware level IRQ deasserted, and the
> >> level interrupt is not re-armed within the host interrupt controller, leading
> >> to an unrecoverable stall of the device.
> >> 
> >> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.  
> > 
> > I'm not really following here.  It's claimed above that no actual state
> > change occurs within the host interrupt controller, but that's exactly
> > what disable_irq_nosync() intends to do, mask the interrupt line at the
> > controller.  
> 
> While it seems that way on the surface (and this tripped me up
> originally), the actual call chain is:
> 
> disable_irq_nosync()
> __disable_irq_nosync()
> __disable_irq()
> irq_disable()
> 
> Inside void irq_disable(), __irq_disable() is gated on
> irq_settings_disable_unlazy().  The lazy disable is intended to *not*
> touch the interrupt controller itself, instead lazy mode masks the
> interrupt at the device level (DisINT+ registers).  If the IRQ is set
> up to run in lazy mode, the interrupt is not disabled at the actual
> interrupt controller by disable_irq_nosync().

What chip handler are you using?  The comment above irq_disable
reiterates the behavior, yes if the chip doesn't support irq_disable it
marks the interrupt masked but leaves the hardware unmasked.  It does
not describe using DisINTx to mask the device, which would be at a
different level from the chip.  In this case __irq_disable() just calls
irq_state_set_disabled().  Only with the change proposed here would we
also call mask_irq().
 
> > The lazy optimization that's being proposed here should
> > only change the behavior such that the interrupt is masked at the
> > call to disable_irq_nosync() rather than at a subsequent
> > re-assertion of the interrupt.  In any case, enable_irq() should
> > mark the line enabled and reenable the controller if necessary.  
> 
> If the interrupt was not disabled at the controller, then reenabling
> a level interrupt is not guaranteed to actually do anything (although
> it *might*).  The hardware in the interrupt controller will still
> "see" an active level assert for which it fired an interrupt without
> a prior acknowledge (or disable/enable cycle) from software, and can
> then decide to not re-raise the IRQ on a platform-specific basis.
> 
> The key here is that the interrupt controllers differ somewhat in
> behavior across various architectures.  On POWER, the controller will
> only raise the external processor interrupt once for each level
> interrupt when that interrupt changes state to asserted, and will
> only re-raise the external processor interrupt once an acknowledge
> for that interrupt has been sent to the interrupt controller hardware
> while the level interrupt is deasserted.  As a result, if the
> interrupt handler executes (acknowledging the interrupt), but does
> not first clear the interrupt on the device itself, the interrupt
> controller will never re-raise that interrupt -- from its
> perspective, it has issued another IRQ (because the device level
> interrupt was left asserted) and the associated handler has never
> completed.  Disabling the interrupt causes the controller to reassert
> the interrupt if the level interrupt is still asserted when the
> interrupt is reenabled at the controller level.

This sounds a lot more like the problem than the previous description.
Is the actual scenario something like the irq is marked disabled, the
eventfd is delivered to userspace, userspace handles the device, the
interrupt is de-asserted at the device, but then the device re-asserts
the interrupt before the unmask ioctl, causing the interrupt chip to
mask the interrupt, then enable_irq() from the unmask ioctl doesn't
reassert the interrupt?

> On other platforms the external processor interrupt itself is
> disabled until the interrupt handler has finished, and the controller
> doesn't auto-mask the level interrupts at the hardware level;
> instead, it will happily re-assert the processor interrupt if the
> interrupt was not cleared at the device level after IRQ acknowledge.
> I suspect on those platforms this bug may be masked at the expense of
> a bunch of "spurious" / unwanted interrupts if the interrupt handler
> hasn't acked the interrupt at the device level; as long as the guest
> interrupt handler is able to somewhat rapidly clear the device
> interrupt, performance won't be impacted too much by the extra
> interrupt load, further hiding the bug on these platforms.

It seems this is the trade off the lazy handling makes intentionally,
we risk some spurious interrupts while the line is disabled to avoid
poking the hardware.  So long as we're not triggering the spurious
interrupt handler to permanently disabling the interrupt line, this is a
valid choice.

That's also a consideration for this patch, we're slowing down all
non-PCI2.3 INTx handling for the behavior of this platform.  Is there
some behavior of the interrupt controller we can query to know which
path to use?  Can this issue be seen with the irqfd INTx handling
disabled on other architectures?  Do we actually care whether we're
making old INTx devices slower?  Thanks,

Alex


