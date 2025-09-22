Return-Path: <kvm+bounces-58405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB86AB92978
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E82C2A5EA7
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6203F319845;
	Mon, 22 Sep 2025 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b="g7vKlOry"
X-Original-To: kvm@vger.kernel.org
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEF4313D57
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.155.224.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758565528; cv=none; b=jC/0aBRGXSfdwO9We9eaIet0FHYPH7+JugsCAin8WDpYWlhP/INFiMMZ4tTo3DsmdMb4wHr9m6M8wsZAEVY88gJjqVsV+mBap/rCS5F5DVygiCQrup27RGtnbCXcUmTcHhOwd38IRd/nqkbfKYAqrpaSbEiKl5onZ2G2MlVmBFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758565528; c=relaxed/simple;
	bh=ADf48PJCkrT1/0D6pJlc8jS/Owzd2vpzrObgjpGk53Y=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=CcnSw3kayRJBw+j8vJpzsTyqFJDaSlq93g6F+6EsqWgV2gBxWEBq1/sz3g3JGWju7Nm4kmqg2V8OggTDwC5mKnQCnHsCn1k+X7Y3DxarRbroTIlxOStunj0p+e9R373+SK5vyyuVpmgzHgHBGbpcSyo8zOw2OUH3FhhDa7ouvQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com; spf=pass smtp.mailfrom=raptorengineering.com; dkim=pass (1024-bit key) header.d=raptorengineering.com header.i=@raptorengineering.com header.b=g7vKlOry; arc=none smtp.client-ip=23.155.224.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raptorengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raptorengineering.com
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id BB86F8286733;
	Mon, 22 Sep 2025 13:25:25 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id RW7qn8Qu-UfY; Mon, 22 Sep 2025 13:25:24 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 4E704828523D;
	Mon, 22 Sep 2025 13:25:24 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 4E704828523D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
	t=1758565524; bh=Q7vgWe5BTDEEAyuzPVJfdErl8MnSgGfYZINpvEI+SX4=;
	h=Date:From:To:Message-ID:MIME-Version;
	b=g7vKlOryczzx4kd3zxcGfsTXa4MNDoiKOhECli0xibDTxoS3Mc5DBt8xh2t9k4OHl
	 xuuah1Z2/V6fEUzMRP1i+pejSzMCE0duGzDpp3fxUm6OKzLeMENkDX9LACM6AyVSQD
	 4IM+JOzaZHpWTcWrwTMun2uYQdO+AjFAP9sLvjOU=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
	by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id E--5ZLiGBrti; Mon, 22 Sep 2025 13:25:24 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
	by mail.rptsys.com (Postfix) with ESMTP id 1BBAB828522F;
	Mon, 22 Sep 2025 13:25:24 -0500 (CDT)
Date: Mon, 22 Sep 2025 13:25:23 -0500 (CDT)
From: Timothy Pearson <tpearson@raptorengineering.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <2033705829.1743233.1758565523937.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <20250922120122.4e9942e8.alex.williamson@redhat.com>
References: <912864077.1743059.1758561514856.JavaMail.zimbra@raptorengineeringinc.com> <20250922120122.4e9942e8.alex.williamson@redhat.com>
Subject: Re: [PATCH v2] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
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
Thread-Topic: vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices
Thread-Index: VbGU3DB6cMFkhoYO5wHCtZsM+k2MIg==



----- Original Message -----
> From: "Alex Williamson" <alex.williamson@redhat.com>
> To: "Timothy Pearson" <tpearson@raptorengineering.com>
> Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> Sent: Monday, September 22, 2025 1:01:22 PM
> Subject: Re: [PATCH v2] vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices

> On Mon, 22 Sep 2025 12:18:34 -0500 (CDT)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
> 
>> PCI devices prior to PCI 2.3 both use level interrupts and do not support
>> interrupt masking, leading to a failure when passed through to a KVM guest on
>> at least the ppc64 platform. This failure manifests as receiving and
>> acknowledging a single interrupt in the guest, while the device continues to
>> assert the level interrupt indicating a need for further servicing.
>> 
>> When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the following
>> sequence occurs:
>> 
>>  * Level IRQ assertion on device
>>  * IRQ marked disabled in kernel
>>  * Host interrupt handler exits without clearing the interrupt on the device
>>  * Eventfd is delivered to userspace
>>  * Host interrupt controller sees still-active INTX, reasserts IRQ
>>  * Host kernel ignores disabled IRQ
>>  * Guest processes IRQ and clears device interrupt
>>  * Software mask removed by VFIO driver
> 
> This isn't the sequence that was previously identified as the issue.
> An interrupt controller that reasserts the IRQ when it remains active
> is not susceptible to the issue, and is what I think we generally
> expect on x86.  I understand that we believe this issue manifests
> exactly because the interrupt controller does not reassert an interrupt
> that remains active.  I think the sequence is:
> 
> * device asserts INTx
> * vfio_intx_handler() calls disable_irq_nosync() to mark IRQ disabled
> * interrupt delivered to userspace via eventfd
> * userspace driver/VM services interrupt
> * device de-asserts INTx
> * device re-asserts INTx
> * interrupt received while IRQ disabled is masked at controller
> * VMM performs EOI via unmask ioctl, enable_irq() clears disable and
>   unmasks IRQ
> * interrupt controller does not reassert interrupt to the host
> 
> The fix then, aiui, is that disabling the unlazy mode masks the
> interrupt at disable_irq_nosync(), the same sequence of de-asserting
> and re-asserting the interrupt occurs at the controller, but since the
> controller was masked at the new rising edge, it will send the
> interrupt when umasked.

That is correct.  Technically we're dealing with two different ways to hang the controller, but this one is the most likely; both fundamentally boil down to not receiving a new INTx falling edge (INTx is active low) after the interrupt is unmasked.  I've updated the description to match.

>> The behavior is now platform-dependent.  Some platforms (amd64) will continue
>> to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
>> will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
>> only send the one request, and if it is not handled no further interrupts will
>> be sent.  The former behavior theoretically leaves the system vulnerable to
>> interrupt storm, and the latter will result in the device stalling after
>> receiving exactly one interrupt in the guest.
>> 
>> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.
>> ---
>>  drivers/vfio/pci/vfio_pci_intrs.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c
>> b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 123298a4dc8f..d8637b53d051 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -304,6 +304,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device
>> *vdev,
>>  
>>  	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
>>  
>> +	if (!vdev->pci_2_3)
>> +		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>> +
>>  	ret = request_irq(pdev->irq, vfio_intx_handler,
>>  			  irqflags, ctx->name, ctx);
>>  	if (ret) {
> 
> This branch is an example of where we're not clearing the flag on
> error.  Thanks,

Whoops!  That's what I get for not looking closely and grepping for free_irq()!

V3 sent.

