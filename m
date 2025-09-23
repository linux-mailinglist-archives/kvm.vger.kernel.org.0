Return-Path: <kvm+bounces-58585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F4CB96E77
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC4523B0D05
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1D6270551;
	Tue, 23 Sep 2025 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="lKyrQNJc"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F402264CB
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758647103; cv=none; b=heo9WgbUm2SjcoUgaZCbJ9TQkMdwiB/Vak8fR+dybHhD/DzI8LyHg+3rTB+sYmVC/gHqRl+7jkZYX7ol1vF0LCgAJJdwnQl7KRyQ4Kf9zIO62Buvbi6KHKcKTIqgAGyBkdQUpCw4JqFVi9YFCTSkAMlqMXSNl2i8bC0WEdY8FtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758647103; c=relaxed/simple;
	bh=nikcktD4X8XZYHIolmnKChTnQDclTMk/gm8XlTdhIsI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jjQqCxaLUalGtpU3dh4avQeDqc7AoeZYnFb2CPsbKluE1dewZCOXEOP65iW6IbNAzCc4K0pYymDofS6tIEmMs3tRTMU1WDYRsDYfJtoY2hEtNWZVMwzp226o+F53wO6F9tAkR631qj1aBCm0gcEqgKbtx5yMLtLKnrGXMXbC9pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=lKyrQNJc; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 9E9BD82889AD;
	Tue, 23 Sep 2025 12:05:00 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id d9e047lrAft2; Tue, 23 Sep 2025 12:04:59 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id BBAAB8288A28;
	Tue, 23 Sep 2025 12:04:59 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com BBAAB8288A28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758647099; bh=uiKso95qBPnK4Z1Hg7XgeEAffq/fOvfPfWhOzqHY6Kg=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=lKyrQNJcBmJXbSNSVoipCAlDcwkQL65ofdw9ZVFAwa6hC4S2SKbKiu2teeCob8o5P
	 BbwOq1+8q7aKmWetD66BpdM8KJ+ucy5ke+Q4C4kvE5Xv6/4Meu1ofu3btdALWI24fK
	 5T+cUwQgoj/TqaMNTu8CDwCufurPX4fPhO8ntSpo=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sHDU-96RXM5r; Tue, 23 Sep 2025 12:04:59 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 962B682889AD;
	Tue, 23 Sep 2025 12:04:59 -0500 (CDT)
Date: Tue, 23 Sep 2025 12:04:58 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Message-ID: <679370091.1744465.1758647098815.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <b1813fed-1dbe-40ad-a6e9-a5c86aea996c@redhat.com>
References: <1293210747.1743219.1758565305521.JavaMail.zimbra@raptorengineeringinc.com> <b1813fed-1dbe-40ad-a6e9-a5c86aea996c@redhat.com>
Subject: Re: [PATCH v3] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
 devices
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC140 (Linux)/8.5.0_GA_3042)
Thread-Topic: vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices
Thread-Index: GCGh9b79dXGiPSR4Qi5bHgbosGEqDQ==

Apologies, resent.

----- Original Message -----
> From: "C=C3=A9dric Le Goater" <clg@redhat.com>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>, "kvm" <kvm@vger.k=
ernel.org>
> Cc: "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>, "Alex Williamson" <al=
ex.williamson@redhat.com>
> Sent: Tuesday, September 23, 2025 12:02:12 PM
> Subject: Re: [PATCH v3] vfio/pci: Fix INTx handling on legacy non-PCI 2.3=
 devices

> On 9/22/25 20:21, Timothy Pearson wrote:
>> PCI devices prior to PCI 2.3 both use level interrupts and do not suppor=
t
>> interrupt masking, leading to a failure when passed through to a KVM gue=
st on
>> at least the ppc64 platform. This failure manifests as receiving and
>> acknowledging a single interrupt in the guest, while the device continue=
s to
>> assert the level interrupt indicating a need for further servicing.
>>=20
>> When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the fo=
llowing
>> sequence occurs:
>>=20
>>   * Level IRQ assertion on device
>>   * IRQ marked disabled in kernel
>>   * Host interrupt handler exits without clearing the interrupt on the d=
evice
>>   * Eventfd is delivered to userspace
>>   * Guest processes IRQ and clears device interrupt
>>   * Device de-asserts INTx, then re-asserts INTx while the interrupt is =
masked
>>   * Newly asserted interrupt acknowledged by kernel VMM without being ha=
ndled
>>   * Software mask removed by VFIO driver
>>   * Device INTx still asserted, host controller does not see new edge af=
ter EOI
>>=20
>> The behavior is now platform-dependent.  Some platforms (amd64) will con=
tinue
>> to spew IRQs for as long as the INTX line remains asserted, therefore th=
e IRQ
>> will be handled by the host as soon as the mask is dropped.  Others (ppc=
64) will
>> only send the one request, and if it is not handled no further interrupt=
s will
>> be sent.  The former behavior theoretically leaves the system vulnerable=
 to
>> interrupt storm, and the latter will result in the device stalling after
>> receiving exactly one interrupt in the guest.
>>=20
>> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices=
.
>=20
> Timothy,
>=20
> This changes lacks your SoB.
>=20
> Thanks,
>=20
> C.
>=20
>=20
>=20
>=20
>> ---
>>   drivers/vfio/pci/vfio_pci_intrs.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>=20
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c
>> b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 123298a4dc8f..61d29f6b3730 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -304,9 +304,14 @@ static int vfio_intx_enable(struct vfio_pci_core_de=
vice
>> *vdev,
>>  =20
>>   =09vdev->irq_type =3D VFIO_PCI_INTX_IRQ_INDEX;
>>  =20
>> +=09if (!vdev->pci_2_3)
>> +=09=09irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>> +
>>   =09ret =3D request_irq(pdev->irq, vfio_intx_handler,
>>   =09=09=09  irqflags, ctx->name, ctx);
>>   =09if (ret) {
>> +=09=09if (!vdev->pci_2_3)
>> +=09=09=09irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>>   =09=09vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
>>   =09=09kfree(name);
>>   =09=09vfio_irq_ctx_free(vdev, ctx, 0);
>> @@ -352,6 +357,8 @@ static void vfio_intx_disable(struct vfio_pci_core_d=
evice
>> *vdev)
>>   =09=09vfio_virqfd_disable(&ctx->unmask);
>>   =09=09vfio_virqfd_disable(&ctx->mask);
>>   =09=09free_irq(pdev->irq, ctx);
>> +=09=09if (!vdev->pci_2_3)
>> +=09=09=09irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>>   =09=09if (ctx->trigger)
>>   =09=09=09eventfd_ctx_put(ctx->trigger);
> >   =09=09kfree(ctx->name);

