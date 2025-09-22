Return-Path: <kvm+bounces-58384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 913ABB921B9
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44B712A0D53
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287993101D5;
	Mon, 22 Sep 2025 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S6EMTbdx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587EE215198
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758556916; cv=none; b=s3B/l8OlZiDjRm97vmItYQfuh1cq9/LouScxOqjqoUSMjBiACfR5+cpKxkBTxQlde/i6c3axkzlgIPqXGQA9YA3LUyz98UVam+YMiibE9lu8bL8VGzkYp8eMvP+cKNpMD4Cv+3/aMwgq4bctSQ+1bLAFliNpTyXHLUAOu4PcUaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758556916; c=relaxed/simple;
	bh=dbrx303xGZ+J6SAdooOoiFUdZdYM2rvjAOHr+JeOSac=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayx0dEg4WimfCQC1XK7fpvY40wF5ZiWN7vjXXhb2RWGhNN+r3uj0sJVnFR70Bci+frq7pcehe5gRQoSiOophkQ3O7alz4J6ge1GHQ1fYLLxdqYJtJaIue5siIpukV5GSmQkl5J4TlakGBl6YGVAIUF9HsZQOMwLQ1rImjk6SZb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S6EMTbdx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758556912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tXNIluJ/Y0q23mzmIzZIg9/Tv+rjRchaEvz0cHtgPjw=;
	b=S6EMTbdxm75GhKEHW5qxmK2xBaAEHoO/wwKAOy3Ec/8gj6CJ/uG7Oc+bifift4VIJhUEyo
	malS32megac6D+UxnZubcjctNBwE7E2E/YNHTN4NbYJkOtXoKe2UpgX/SwKeK16nkR9KqK
	97bYLndXujDT/+Oh9aZAdxPADyeuKAg=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-wyk0nISsPWW1WtFl35IVJA-1; Mon, 22 Sep 2025 12:01:50 -0400
X-MC-Unique: wyk0nISsPWW1WtFl35IVJA-1
X-Mimecast-MFC-AGG-ID: wyk0nISsPWW1WtFl35IVJA_1758556910
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-336ee188712so1410469fac.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758556910; x=1759161710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXNIluJ/Y0q23mzmIzZIg9/Tv+rjRchaEvz0cHtgPjw=;
        b=W1ADMC59dFepZJOf7p6Y+PQMoNvcTDPfq+gLB9dmWFKHStqlKBNWpxmoAgEBGnIPFU
         8UDHV9paOdi730hhTBp/ULZC4hhpEnGOxFrZNG1R9R7kYPk1U/CXqA+BHL2TsRkyXwZR
         A3NhOSOgvjnqyPxV2hUHcrL9CO3CVt8lDP8B+DeZ0mHWfcRSF717q/gz0l9JGiK2D6yM
         CoHBvxS3Fk7VR26vy0agaCiCLW+hGumhvOO9+FPSH68lwHu09qrWW4uQD309HeyfdDHw
         eV/Uebd4OlFtmNt0fRy9ohPRsObf8ukp/MaOE0qBzrZYRgkbYvJ8RoqAoL6QsavbQc33
         6P+g==
X-Gm-Message-State: AOJu0Ywc7j29h5XmvYUbmOrs+khBpCFFHs/3nY8jzuDiC+g+AJFScGAq
	4Kr8ctEiiF8q5ZxpDf7YMeJJEaN852XDbe+3SOmHgSZ++ODSHwGsD+oJLE++ohb/zVhOoyexMcs
	QzNSa8Rpd7ofdt8LUrzb3ykHSwFpqDqO7yWXfhPCEnzGb7IhICF8kjw==
X-Gm-Gg: ASbGnctvhABtle60ER1wDVUfGYvsm7ITgsLAT5ztAqEgwiVUe+uzlqavCRAA1Nb+PtE
	AXPOv93H746/juF+J++CmtnlGg3qqRVtAoYwbEnGiUEm40noHy8cvqJiWuys2cOB/I33NksnMB4
	gKjtBgVBSoOhIIV0MlpPk9lp2XYgYfO3NzprbaTtsWsVBmyYpTjmIK2a7+nLxBGUVus2hOXuWX8
	pw5u3jNbLBkP3hUrgcQR05DRoddKhYAcKR5qf/kRp8aB0PWwQB5xaoQ7ueuIkUcbXtzronoUVyg
	RM+MYZ8p7Ha4LUsW7edMlr4+/6k08+GrsbAQ+evlU0A=
X-Received: by 2002:a05:6871:2987:b0:331:ebe7:f673 with SMTP id 586e51a60fabf-33bb49655aamr3564716fac.9.1758556908229;
        Mon, 22 Sep 2025 09:01:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGz5/rWt2sNidlRW6kyh8a7NA1uRncwrteUD3AJv60SOcvoVzWhVpJzASNVa+IT+VYZbfD6A==
X-Received: by 2002:a05:6871:2987:b0:331:ebe7:f673 with SMTP id 586e51a60fabf-33bb49655aamr3564695fac.9.1758556907521;
        Mon, 22 Sep 2025 09:01:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-336e411fcb8sm7901202fac.8.2025.09.22.09.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 09:01:46 -0700 (PDT)
Date: Mon, 22 Sep 2025 10:01:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Message-ID: <20250922100143.1397e28b.alex.williamson@redhat.com>
In-Reply-To: <537354829.1740670.1758396303861.JavaMail.zimbra@raptorengineeringinc.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com>
	<20250919125603.08f600ac.alex.williamson@redhat.com>
	<1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com>
	<20250919162721.7a38d3e2.alex.williamson@redhat.com>
	<537354829.1740670.1758396303861.JavaMail.zimbra@raptorengineeringinc.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 20 Sep 2025 14:25:03 -0500 (CDT)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> ----- Original Message -----
> > From: "Alex Williamson" <alex.williamson@redhat.com>
> > To: "Timothy Pearson" <tpearson@raptorengineering.com>
> > Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> > Sent: Friday, September 19, 2025 5:27:21 PM
> > Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices  
> 
> > On Fri, 19 Sep 2025 15:51:14 -0500 (CDT)
> > Timothy Pearson <tpearson@raptorengineering.com> wrote:
> >   
> >> ----- Original Message -----  
> >> > From: "Alex Williamson" <alex.williamson@redhat.com>
> >> > To: "Timothy Pearson" <tpearson@raptorengineering.com>
> >> > Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> >> > Sent: Friday, September 19, 2025 1:56:03 PM
> >> > Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices  
> >>   
> >> > On Tue, 9 Sep 2025 15:48:46 -0500 (CDT)
> >> > Timothy Pearson <tpearson@raptorengineering.com> wrote:
> >> >     
> >> >> PCI devices prior to PCI 2.3 both use level interrupts and do not support
> >> >> interrupt masking, leading to a failure when passed through to a KVM guest on
> >> >> at least the ppc64 platform, which does not utilize the resample IRQFD. This
> >> >> failure manifests as receiving and acknowledging a single interrupt in the guest
> >> >> while leaving the host physical device VFIO IRQ pending.
> >> >> 
> >> >> Level interrupts in general require special handling due to their inherently
> >> >> asynchronous nature; both the host and guest interrupt controller need to
> >> >> remain in synchronization in order to coordinate mask and unmask operations.
> >> >> When lazy IRQ masking is used on DisINTx- hardware, the following sequence
> >> >> occurs:
> >> >>
> >> >>  * Level IRQ assertion on host
> >> >>  * IRQ trigger within host interrupt controller, routed to VFIO driver
> >> >>  * Host EOI with hardware level IRQ still asserted
> >> >>  * Software mask of interrupt source by VFIO driver
> >> >>  * Generation of event and IRQ trigger in KVM guest interrupt controller
> >> >>  * Level IRQ deassertion on host
> >> >>  * Guest EOI
> >> >>  * Guest IRQ level deassertion
> >> >>  * Removal of software mask by VFIO driver
> >> >> 
> >> >> Note that no actual state change occurs within the host interrupt controller,
> >> >> unlike what would happen with either DisINTx+ hardware or message interrupts.
> >> >> The host EOI is not fired with the hardware level IRQ deasserted, and the
> >> >> level interrupt is not re-armed within the host interrupt controller, leading
> >> >> to an unrecoverable stall of the device.
> >> >> 
> >> >> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.  
> >> > 
> >> > I'm not really following here.  It's claimed above that no actual state
> >> > change occurs within the host interrupt controller, but that's exactly
> >> > what disable_irq_nosync() intends to do, mask the interrupt line at the
> >> > controller.  
> >> 
> >> While it seems that way on the surface (and this tripped me up
> >> originally), the actual call chain is:
> >> 
> >> disable_irq_nosync()
> >> __disable_irq_nosync()
> >> __disable_irq()
> >> irq_disable()
> >> 
> >> Inside void irq_disable(), __irq_disable() is gated on
> >> irq_settings_disable_unlazy().  The lazy disable is intended to *not*
> >> touch the interrupt controller itself, instead lazy mode masks the
> >> interrupt at the device level (DisINT+ registers).  If the IRQ is set
> >> up to run in lazy mode, the interrupt is not disabled at the actual
> >> interrupt controller by disable_irq_nosync().  
> > 
> > What chip handler are you using?  The comment above irq_disable
> > reiterates the behavior, yes if the chip doesn't support irq_disable it
> > marks the interrupt masked but leaves the hardware unmasked.  It does
> > not describe using DisINTx to mask the device, which would be at a
> > different level from the chip.  In this case __irq_disable() just calls
> > irq_state_set_disabled().  Only with the change proposed here would we
> > also call mask_irq().  
> 
> This is all tested on a POWER XIVE controller, so arch/powerpc/sysdev/xive (CONFIG_PPC_XIVE_NATIVE=y)
> 
> >> > The lazy optimization that's being proposed here should
> >> > only change the behavior such that the interrupt is masked at the
> >> > call to disable_irq_nosync() rather than at a subsequent
> >> > re-assertion of the interrupt.  In any case, enable_irq() should
> >> > mark the line enabled and reenable the controller if necessary.  
> >> 
> >> If the interrupt was not disabled at the controller, then reenabling
> >> a level interrupt is not guaranteed to actually do anything (although
> >> it *might*).  The hardware in the interrupt controller will still
> >> "see" an active level assert for which it fired an interrupt without
> >> a prior acknowledge (or disable/enable cycle) from software, and can
> >> then decide to not re-raise the IRQ on a platform-specific basis.
> >> 
> >> The key here is that the interrupt controllers differ somewhat in
> >> behavior across various architectures.  On POWER, the controller will
> >> only raise the external processor interrupt once for each level
> >> interrupt when that interrupt changes state to asserted, and will
> >> only re-raise the external processor interrupt once an acknowledge
> >> for that interrupt has been sent to the interrupt controller hardware
> >> while the level interrupt is deasserted.  As a result, if the
> >> interrupt handler executes (acknowledging the interrupt), but does
> >> not first clear the interrupt on the device itself, the interrupt
> >> controller will never re-raise that interrupt -- from its
> >> perspective, it has issued another IRQ (because the device level
> >> interrupt was left asserted) and the associated handler has never
> >> completed.  Disabling the interrupt causes the controller to reassert
> >> the interrupt if the level interrupt is still asserted when the
> >> interrupt is reenabled at the controller level.  
> > 
> > This sounds a lot more like the problem than the previous description.  
> 
> Apologies for that.  There's a lot of moving parts here and I guess I muddled it all up in the first description.
> 
> > Is the actual scenario something like the irq is marked disabled, the
> > eventfd is delivered to userspace, userspace handles the device, the
> > interrupt is de-asserted at the device, but then the device re-asserts
> > the interrupt before the unmask ioctl, causing the interrupt chip to
> > mask the interrupt, then enable_irq() from the unmask ioctl doesn't
> > reassert the interrupt?  
> 
> That is exactly it, yes.  This particular scenario only occurs on old
> pre-PCI 2.3 devices that advertise DisINT- ; newer devices that
> advertise DisINT+ don't trip the fault since the host interrupt
> handler sets the device interrupt mask (thus deasserting the IRQ at
> the interrupt controller) before exiting.
> 
> >> On other platforms the external processor interrupt itself is
> >> disabled until the interrupt handler has finished, and the
> >> controller doesn't auto-mask the level interrupts at the hardware
> >> level; instead, it will happily re-assert the processor interrupt
> >> if the interrupt was not cleared at the device level after IRQ
> >> acknowledge. I suspect on those platforms this bug may be masked
> >> at the expense of a bunch of "spurious" / unwanted interrupts if
> >> the interrupt handler hasn't acked the interrupt at the device
> >> level; as long as the guest interrupt handler is able to somewhat
> >> rapidly clear the device interrupt, performance won't be impacted
> >> too much by the extra interrupt load, further hiding the bug on
> >> these platforms.  
> > 
> > It seems this is the trade off the lazy handling makes
> > intentionally, we risk some spurious interrupts while the line is
> > disabled to avoid poking the hardware.  So long as we're not
> > triggering the spurious interrupt handler to permanently disabling
> > the interrupt line, this is a valid choice.  
> 
> At least for some platforms, yes, though it's not exactly clear in
> the documentation that this is intentional or that the side effect
> exists at all.
> 
> > That's also a consideration for this patch, we're slowing down all
> > non-PCI2.3 INTx handling for the behavior of this platform.  Is
> > there some behavior of the interrupt controller we can query to
> > know which path to use?  Can this issue be seen with the irqfd INTx
> > handling disabled on other architectures?  Do we actually care
> > whether we're making old INTx devices slower?  Thanks,  
> 
> I honestly don't know.  In reality, we're talking about amd64 and
> ppc64el as the only two platforms that I know of that both support
> VFIO and such old PCIe INTX pre-2.3 devices, and their respective
> interrupt controller handling in a spurious INTX IRQ context is very
> different from one another.
> 
> Personally, I'd argue that such old devices were intended to work
> with much slower host systems, therefore the slowdown probably
> doesn't matter vs. being more correct in terms of interrupt handling.
>  In terms of general kernel design, my understanding has always been
> is that best practice is to always mask, disable, or clear a level
> interrupt before exiting the associated IRQ handler, and the current
> design seems to violate that rule.  In that context, I'd personally
> want to see an argument as to why echewing this traditional IRQ
> handler design is beneficial enough to justify making the VFIO driver
> dependent on platform-specific behavior.

Yep, I kind of agree.  The unlazy flag seems to provide the more
intended behavior.  It moves the irq chip masking into the fast path,
whereas it would have been asynchronous on a subsequent interrupt
previously, but the impact is only to ancient devices operating in INTx
mode, so as long as we can verify those still work on both ppc and x86,
I don't think it's worth complicating the code to make setting the
unlazy flag conditional on anything other than the device support.

Care to send out a new version documenting the actual sequence fixed by
this change and updating the code based on this thread?  Note that we
can test non-pci2.3 mode for any device/driver that supports INTx using
the nointxmask=1 option for vfio-pci and booting a linux guest with
pci=nomsi.  Thanks,

Alex


