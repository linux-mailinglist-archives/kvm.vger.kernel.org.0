Return-Path: <kvm+bounces-58194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFEDEB8B43E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABA613BE80D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6832D249A;
	Fri, 19 Sep 2025 21:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="MoaeAmhN"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A02A2C3271
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315614; cv=none; b=DQf9mh3ia1sCm9W7lCB5LLz5Htcq/M4ghsEx3B6kWH30VslCN7J2uRe21nt4YtIY2TdKzj5I1YtbD/wrLl4zQvLHp153jWeCRiMLb2heTbP3tN6CSc6N9kpWhwmVd+b7+vhTSfC51iIMsLrT5VZJ6nsl8JrS9cYWXq1Rq8q+oqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315614; c=relaxed/simple;
	bh=S/LewrZywn5JaTNfcnMJolSBCRnPwKmjMa+HAzBKt6I=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=SdeTBVtypTGjYRxMBLRunnR1fRCwyGY4NEdQ53vP4h9IwPB6OE7kYCtPhApa/lLm4RDuFLHPv6G7z+1RzQVnl/LyRULljEwDwBgXfUXQrft/fuahlqExPPX9iFmGOwejxaHCzDsFTEyYkefBAFuP+KLUcHyAhQ+Vphm1MAwrDJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=MoaeAmhN; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id AF5C8828714A;
	Fri, 19 Sep 2025 15:51:18 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id QHH2yBbQIVaw; Fri, 19 Sep 2025 15:51:17 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 8DA678288F6A;
	Fri, 19 Sep 2025 15:51:17 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 8DA678288F6A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758315077; bh=Gc77UcBgWkXlNenZURxXa+SxFMRRrdOmq7jj68ZJ9ig=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=MoaeAmhNFYTvdJ+9unq3RPamDcVdz7w3Tx1qtoJxn32PB2fiQy6SwlO12xMGtt+DQ
	 gNdMtnMSwoQ3jiLm4yuixi7XMJUAIaxhIZ8x6phYPXnf4949IUF2YnOKRZTJUdskat
	 zjTTMcdfaHbLax9hRYAUz7GJk8+JA/AIbp5wWciw=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id onzFADtA1JP4; Fri, 19 Sep 2025 15:51:17 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 649C4828714A;
	Fri, 19 Sep 2025 15:51:17 -0500 (CDT)
Date: Fri, 19 Sep 2025 15:51:14 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <1916735949.1739694.1758315074669.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <20250919125603.08f600ac.alex.williamson@redhat.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com> <20250919125603.08f600ac.alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC139 (Linux)/8.5.0_GA_3042)
Thread-Topic: vfio/pci: Fix INTx handling on legacy DisINTx- PCI devices
Thread-Index: 2P1bgvmiDKemaC8qsDYFtmyXEtEWZA==



----- Original Message -----
> From: "Alex Williamson" <alex.williamson@redhat.com>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>
> Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlab=
s.org>
> Sent: Friday, September 19, 2025 1:56:03 PM
> Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI d=
evices

> On Tue, 9 Sep 2025 15:48:46 -0500 (CDT)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
>=20
>> PCI devices prior to PCI 2.3 both use level interrupts and do not suppor=
t
>> interrupt masking, leading to a failure when passed through to a KVM gue=
st on
>> at least the ppc64 platform, which does not utilize the resample IRQFD. =
This
>> failure manifests as receiving and acknowledging a single interrupt in t=
he guest
>> while leaving the host physical device VFIO IRQ pending.
>>=20
>> Level interrupts in general require special handling due to their inhere=
ntly
>> asynchronous nature; both the host and guest interrupt controller need t=
o
>> remain in synchronization in order to coordinate mask and unmask operati=
ons.
>> When lazy IRQ masking is used on DisINTx- hardware, the following sequen=
ce
>> occurs:
>>
>>  * Level IRQ assertion on host
>>  * IRQ trigger within host interrupt controller, routed to VFIO driver
>>  * Host EOI with hardware level IRQ still asserted
>>  * Software mask of interrupt source by VFIO driver
>>  * Generation of event and IRQ trigger in KVM guest interrupt controller
>>  * Level IRQ deassertion on host
>>  * Guest EOI
>>  * Guest IRQ level deassertion
>>  * Removal of software mask by VFIO driver
>>=20
>> Note that no actual state change occurs within the host interrupt contro=
ller,
>> unlike what would happen with either DisINTx+ hardware or message interr=
upts.
>> The host EOI is not fired with the hardware level IRQ deasserted, and th=
e
>> level interrupt is not re-armed within the host interrupt controller, le=
ading
>> to an unrecoverable stall of the device.
>>=20
>> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices=
.
>=20
> I'm not really following here.  It's claimed above that no actual state
> change occurs within the host interrupt controller, but that's exactly
> what disable_irq_nosync() intends to do, mask the interrupt line at the
> controller.

While it seems that way on the surface (and this tripped me up originally),=
 the actual call chain is:

disable_irq_nosync()
__disable_irq_nosync()
__disable_irq()
irq_disable()

Inside void irq_disable(), __irq_disable() is gated on irq_settings_disable=
_unlazy().  The lazy disable is intended to *not* touch the interrupt contr=
oller itself, instead lazy mode masks the interrupt at the device level (Di=
sINT+ registers).  If the IRQ is set up to run in lazy mode, the interrupt =
is not disabled at the actual interrupt controller by disable_irq_nosync().

> The lazy optimization that's being proposed here should
> only change the behavior such that the interrupt is masked at the call
> to disable_irq_nosync() rather than at a subsequent re-assertion of the
> interrupt.  In any case, enable_irq() should mark the line enabled and
> reenable the controller if necessary.

If the interrupt was not disabled at the controller, then reenabling a leve=
l interrupt is not guaranteed to actually do anything (although it *might*)=
.  The hardware in the interrupt controller will still "see" an active leve=
l assert for which it fired an interrupt without a prior acknowledge (or di=
sable/enable cycle) from software, and can then decide to not re-raise the =
IRQ on a platform-specific basis.

The key here is that the interrupt controllers differ somewhat in behavior =
across various architectures.  On POWER, the controller will only raise the=
 external processor interrupt once for each level interrupt when that inter=
rupt changes state to asserted, and will only re-raise the external process=
or interrupt once an acknowledge for that interrupt has been sent to the in=
terrupt controller hardware while the level interrupt is deasserted.  As a =
result, if the interrupt handler executes (acknowledging the interrupt), bu=
t does not first clear the interrupt on the device itself, the interrupt co=
ntroller will never re-raise that interrupt -- from its perspective, it has=
 issued another IRQ (because the device level interrupt was left asserted) =
and the associated handler has never completed.  Disabling the interrupt ca=
uses the controller to reassert the interrupt if the level interrupt is sti=
ll asserted when the interrupt is reenabled at the controller level.

On other platforms the external processor interrupt itself is disabled unti=
l the interrupt handler has finished, and the controller doesn't auto-mask =
the level interrupts at the hardware level; instead, it will happily re-ass=
ert the processor interrupt if the interrupt was not cleared at the device =
level after IRQ acknowledge.  I suspect on those platforms this bug may be =
masked at the expense of a bunch of "spurious" / unwanted interrupts if the=
 interrupt handler hasn't acked the interrupt at the device level; as long =
as the guest interrupt handler is able to somewhat rapidly clear the device=
 interrupt, performance won't be impacted too much by the extra interrupt l=
oad, further hiding the bug on these platforms.

Again, this is also a specific and unusual case of an old level-driven inte=
rrupt device that doesn't support interrupt masking at the device level (i.=
e. the device is DisINT-), in combination with the VFIO driver.  Under that=
 *specific* use case, the VFIO driver purposefully acnowledges the interrup=
t without first clearing the interrupt on the device, which then exposes th=
e platform-specific differences in interrupt controller behavior.

> Also, contrary to above, when a device supports DisINT+ we're not
> manipulating the host controller.  We're able to mask the interrupt at
> the device.  MSI is edge triggered, we don't mask it, so it's not
> relevant to this discussion afaict.

That's correct -- I don't recall saying the opposite. ;)  If I did, I apolo=
gize.

> There may be good reason to disable the lazy masking behavior as you're
> proposing, but I'm not able to glean it from this discussion of the
> issue.

Does this help clarify anything?

