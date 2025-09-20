Return-Path: <kvm+bounces-58316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD25B8CF2B
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 21:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3518E7AB9C6
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 19:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8761A23D7E8;
	Sat, 20 Sep 2025 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="QdkjWUwW"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24B23BCE4
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 19:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758396313; cv=none; b=aEZsoKQM2myP72KMNGqI/IhOLGwVSSjQddrCc+BrVjlM1xLWGijBCz+GsgKjAEpvVGNQLTx0X0qfhM/N8OG6+oVwXsDjQaPMoSMAhxtuj9o1J+ajAM96OWpniKZwitOmpKzixN/jz8Nc9IDEOTZ1yN/0+LCuyP7tjL/kasMPfXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758396313; c=relaxed/simple;
	bh=0YWNOQRBMViS7uLmGrjQpWEwekYg+hfitbFvrfUIkPc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=BuvSY7mAbJFg+0K3lCI+XA8AtwN2US7FImTSzzC9NkFduxwB3JYi9SujYZFtu/3xHzsipsmOT1EURa1US9tj95ovrLIM1LOP+VCdSvLRfvHs9bLQxqlKaQClBasid7U0/r8P2GiP4eEi6fIp7C1GhNm3rW+pVLUMTcRqQ/MRbp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=QdkjWUwW; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 4AE348288EBC;
	Sat, 20 Sep 2025 14:25:08 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id wyspLYXRvEcA; Sat, 20 Sep 2025 14:25:06 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id CEE0B82890CD;
	Sat, 20 Sep 2025 14:25:06 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com CEE0B82890CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758396306; bh=b3Bp4dgSxf+ggJrh+8ZMDr/Oak84SJTTedtmVi2EJcc=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=QdkjWUwWPLJc2VBKlYBEML/bsf/9s3qIYip6dp7+axTjoHW7LG/XzSok2izb6op0O
	 MKh4QM7JNN4QoLU5D4xpf1joju4/iLfq6yuQAcnjkx27WAcheQ/96yQwzabcMklTzP
	 gO47GWJWZ6LKRreJwKmyNsn2pdHnWKx63xqC1RKU=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5TbUiFUoo-Rx; Sat, 20 Sep 2025 14:25:06 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 96C358288EBC;
	Sat, 20 Sep 2025 14:25:06 -0500 (CDT)
Date: Sat, 20 Sep 2025 14:25:03 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <537354829.1740670.1758396303861.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <20250919162721.7a38d3e2.alex.williamson@redhat.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com> <20250919125603.08f600ac.alex.williamson@redhat.com> <1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com> <20250919162721.7a38d3e2.alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC139 (Linux)/8.5.0_GA_3042)
Thread-Topic: vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices
Thread-Index: bFl5NHP7oMjKNztE0jpOEeSgapuGrw==



----- Original Message -----
> From: "Alex Williamson" <alex.williamson@redhat.com>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>
> Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> Sent: Friday, September 19, 2025 5:27:21 PM
> Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices

> On Fri, 19 Sep 2025 15:51:14 -0500 (CDT)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
> 
>> ----- Original Message -----
>> > From: "Alex Williamson" <alex.williamson@redhat.com>
>> > To: "Timothy Pearson" <tpearson@raptorengineering.com>
>> > Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
>> > Sent: Friday, September 19, 2025 1:56:03 PM
>> > Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices
>> 
>> > On Tue, 9 Sep 2025 15:48:46 -0500 (CDT)
>> > Timothy Pearson <tpearson@raptorengineering.com> wrote:
>> >   
>> >> PCI devices prior to PCI 2.3 both use level interrupts and do not support
>> >> interrupt masking, leading to a failure when passed through to a KVM guest on
>> >> at least the ppc64 platform, which does not utilize the resample IRQFD. This
>> >> failure manifests as receiving and acknowledging a single interrupt in the guest
>> >> while leaving the host physical device VFIO IRQ pending.
>> >> 
>> >> Level interrupts in general require special handling due to their inherently
>> >> asynchronous nature; both the host and guest interrupt controller need to
>> >> remain in synchronization in order to coordinate mask and unmask operations.
>> >> When lazy IRQ masking is used on DisINTx- hardware, the following sequence
>> >> occurs:
>> >>
>> >>  * Level IRQ assertion on host
>> >>  * IRQ trigger within host interrupt controller, routed to VFIO driver
>> >>  * Host EOI with hardware level IRQ still asserted
>> >>  * Software mask of interrupt source by VFIO driver
>> >>  * Generation of event and IRQ trigger in KVM guest interrupt controller
>> >>  * Level IRQ deassertion on host
>> >>  * Guest EOI
>> >>  * Guest IRQ level deassertion
>> >>  * Removal of software mask by VFIO driver
>> >> 
>> >> Note that no actual state change occurs within the host interrupt controller,
>> >> unlike what would happen with either DisINTx+ hardware or message interrupts.
>> >> The host EOI is not fired with the hardware level IRQ deasserted, and the
>> >> level interrupt is not re-armed within the host interrupt controller, leading
>> >> to an unrecoverable stall of the device.
>> >> 
>> >> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.
>> > 
>> > I'm not really following here.  It's claimed above that no actual state
>> > change occurs within the host interrupt controller, but that's exactly
>> > what disable_irq_nosync() intends to do, mask the interrupt line at the
>> > controller.
>> 
>> While it seems that way on the surface (and this tripped me up
>> originally), the actual call chain is:
>> 
>> disable_irq_nosync()
>> __disable_irq_nosync()
>> __disable_irq()
>> irq_disable()
>> 
>> Inside void irq_disable(), __irq_disable() is gated on
>> irq_settings_disable_unlazy().  The lazy disable is intended to *not*
>> touch the interrupt controller itself, instead lazy mode masks the
>> interrupt at the device level (DisINT+ registers).  If the IRQ is set
>> up to run in lazy mode, the interrupt is not disabled at the actual
>> interrupt controller by disable_irq_nosync().
> 
> What chip handler are you using?  The comment above irq_disable
> reiterates the behavior, yes if the chip doesn't support irq_disable it
> marks the interrupt masked but leaves the hardware unmasked.  It does
> not describe using DisINTx to mask the device, which would be at a
> different level from the chip.  In this case __irq_disable() just calls
> irq_state_set_disabled().  Only with the change proposed here would we
> also call mask_irq().

This is all tested on a POWER XIVE controller, so arch/powerpc/sysdev/xive (CONFIG_PPC_XIVE_NATIVE=y)

>> > The lazy optimization that's being proposed here should
>> > only change the behavior such that the interrupt is masked at the
>> > call to disable_irq_nosync() rather than at a subsequent
>> > re-assertion of the interrupt.  In any case, enable_irq() should
>> > mark the line enabled and reenable the controller if necessary.
>> 
>> If the interrupt was not disabled at the controller, then reenabling
>> a level interrupt is not guaranteed to actually do anything (although
>> it *might*).  The hardware in the interrupt controller will still
>> "see" an active level assert for which it fired an interrupt without
>> a prior acknowledge (or disable/enable cycle) from software, and can
>> then decide to not re-raise the IRQ on a platform-specific basis.
>> 
>> The key here is that the interrupt controllers differ somewhat in
>> behavior across various architectures.  On POWER, the controller will
>> only raise the external processor interrupt once for each level
>> interrupt when that interrupt changes state to asserted, and will
>> only re-raise the external processor interrupt once an acknowledge
>> for that interrupt has been sent to the interrupt controller hardware
>> while the level interrupt is deasserted.  As a result, if the
>> interrupt handler executes (acknowledging the interrupt), but does
>> not first clear the interrupt on the device itself, the interrupt
>> controller will never re-raise that interrupt -- from its
>> perspective, it has issued another IRQ (because the device level
>> interrupt was left asserted) and the associated handler has never
>> completed.  Disabling the interrupt causes the controller to reassert
>> the interrupt if the level interrupt is still asserted when the
>> interrupt is reenabled at the controller level.
> 
> This sounds a lot more like the problem than the previous description.

Apologies for that.  There's a lot of moving parts here and I guess I muddled it all up in the first description.

> Is the actual scenario something like the irq is marked disabled, the
> eventfd is delivered to userspace, userspace handles the device, the
> interrupt is de-asserted at the device, but then the device re-asserts
> the interrupt before the unmask ioctl, causing the interrupt chip to
> mask the interrupt, then enable_irq() from the unmask ioctl doesn't
> reassert the interrupt?

That is exactly it, yes.  This particular scenario only occurs on old pre-PCI 2.3 devices that advertise DisINT- ; newer devices that advertise DisINT+ don't trip the fault since the host interrupt handler sets the device interrupt mask (thus deasserting the IRQ at the interrupt controller) before exiting.

>> On other platforms the external processor interrupt itself is
>> disabled until the interrupt handler has finished, and the controller
>> doesn't auto-mask the level interrupts at the hardware level;
>> instead, it will happily re-assert the processor interrupt if the
>> interrupt was not cleared at the device level after IRQ acknowledge.
>> I suspect on those platforms this bug may be masked at the expense of
>> a bunch of "spurious" / unwanted interrupts if the interrupt handler
>> hasn't acked the interrupt at the device level; as long as the guest
>> interrupt handler is able to somewhat rapidly clear the device
>> interrupt, performance won't be impacted too much by the extra
>> interrupt load, further hiding the bug on these platforms.
> 
> It seems this is the trade off the lazy handling makes intentionally,
> we risk some spurious interrupts while the line is disabled to avoid
> poking the hardware.  So long as we're not triggering the spurious
> interrupt handler to permanently disabling the interrupt line, this is a
> valid choice.

At least for some platforms, yes, though it's not exactly clear in the documentation that this is intentional or that the side effect exists at all.

> That's also a consideration for this patch, we're slowing down all
> non-PCI2.3 INTx handling for the behavior of this platform.  Is there
> some behavior of the interrupt controller we can query to know which
> path to use?  Can this issue be seen with the irqfd INTx handling
> disabled on other architectures?  Do we actually care whether we're
> making old INTx devices slower?  Thanks,

I honestly don't know.  In reality, we're talking about amd64 and ppc64el as the only two platforms that I know of that both support VFIO and such old PCIe INTX pre-2.3 devices, and their respective interrupt controller handling in a spurious INTX IRQ context is very different from one another.

Personally, I'd argue that such old devices were intended to work with much slower host systems, therefore the slowdown probably doesn't matter vs. being more correct in terms of interrupt handling.  In terms of general kernel design, my understanding has always been is that best practice is to always mask, disable, or clear a level interrupt before exiting the associated IRQ handler, and the current design seems to violate that rule.  In that context, I'd personally want to see an argument as to why echewing this traditional IRQ handler design is beneficial enough to justify making the VFIO driver dependent on platform-specific behavior.

