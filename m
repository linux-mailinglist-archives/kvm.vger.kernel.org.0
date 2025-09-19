Return-Path: <kvm+bounces-58177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 096A2B8B016
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB598166310
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418FC2765D0;
	Fri, 19 Sep 2025 18:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIB9OBQ0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB71426AA98
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 18:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308177; cv=none; b=k2s97vR4A7G0+sNtqFQcNJ5jVHAEaOft1bTDhiOvEgr5dchvvVcuEOHopPbtd2edyOzCZTSRuDgyOccGXXjQGFDvhwjQ4uWpHsjo8am94TUJ+Yft/CkjXz5BIPRjSX7LC4ee0yyguXaf040u1JJC4+hiW7YZsYPHRne9h4y0ETE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308177; c=relaxed/simple;
	bh=NMGs53ZmxWLAUCYOcr0I463+j+D0J4KWS6lwxbrHf8c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdGEaiuyV9ZXrI9wdZGfk2gepHPNS8AXd9PK/G5NZl/5BXYuRB/buxhfkmBoOxflOh9pAecsmKmpw1yEDxQtzcAYw+1IuwZfzttG3fcmkyxsO1CIoECjRFXrJU1Lnd6wS6XAnkSNBTioCOpyOz5yKaHuw89pP0Eyad4yrIl+yMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIB9OBQ0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758308175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVj38TV6NFlRJUveEKKnf4vw+DN0Kar28r+mnlIexw0=;
	b=dIB9OBQ07EX3BPwIKmZZ9XeRFtE8UKDtLyKd3THchO5RdGdM1VnGqEGj2bqRPp/xJmIwA/
	DheWlEhHDdkHpB1I/a0TnQVrbaLlTWeBIiMNZW0oZuI8YeIxVteEWkkj9oVI0szV7bDIKa
	+A1siXp15900XaGjzpDybvJpUQ1L9h8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-2dbEiSfUPrOZzVcnnirBNw-1; Fri, 19 Sep 2025 14:56:07 -0400
X-MC-Unique: 2dbEiSfUPrOZzVcnnirBNw-1
X-Mimecast-MFC-AGG-ID: 2dbEiSfUPrOZzVcnnirBNw_1758308166
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4248bfd20faso40205ab.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 11:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758308166; x=1758912966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVj38TV6NFlRJUveEKKnf4vw+DN0Kar28r+mnlIexw0=;
        b=VCznSlbVXv+ZSYLr/mm3Z97CMpQYJNiCwX1oEztXZnbbt/W5s4i16yLDSbLrqiEuXj
         6QLXkV37CZ6RBZC1jLdA5XOKo/N0tr0+DHVcNl8IJ1315U/celMUT5MmqZc4QnQ+PxTs
         Nxefc3DlZGB4m601I5lH/9fRHJ9FuQ8t5oKlWNQm3upfxBSRmTsOdLgD3EnQa/+sJx4L
         xWgI4k3y71ziJl78elvmVNoD/4Fb429TcUATsa3NPLRgQlowZmRQmnqCs0TpfGdMhugF
         kCiOaD88Wo+p9mWWqwWF2zcVNuelE1h4MxewWJ7Fo4bekP0aHyUUw4lYItJvf54PlkvV
         hnzg==
X-Gm-Message-State: AOJu0YwR+92kC5bAc0jooOj9p5fAlzId0CFzTT55VJNkkJjDMgEAhtz2
	G0IuO2Hq0hxDTsoCV6WjahvTCJbHCGKde2YSs6l/1Hun9PAQj2dJwiiNrNADabVwFS85hGpNUgU
	73Pc+LnmywvGNaHbpWiayRkaiYGiaT+n14mCx2kTlth9e1EN9p8GmnA==
X-Gm-Gg: ASbGncuW0TOf2T5bNtINdqFbKPDxrOoq5z1rogRjMJx4FKwDtLfKkcbR7FSr+1nNdUY
	TWTaCvhM9Cxfn+VgI0wO+wpOS8DiBKPpYIDMwnpGwHe9mt++69b6TKKHWIAywblIVJkxvPydB8L
	MbXjt/IzE/kIqNT8URVrBWsT/wklqkRQHqHu2s+3/zD9Ql7HskTogU+nZjOUc+c8LVvFYCtlMOf
	b7pf+pAxC4NdRd0NCGto5Kurgeq5VhuvsXwYm3hWVeFf/KbM8dHLTBd5Ayed02yG4p07KPB5pWG
	oi0xVsHj72apTiHuO5sZDXn8XBqYC6fueoyJi+Ab/1A=
X-Received: by 2002:a92:c24a:0:b0:419:de32:2d01 with SMTP id e9e14a558f8ab-42481989234mr25313785ab.4.1758308166445;
        Fri, 19 Sep 2025 11:56:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeRMlVVwJSn2J+eoiOVihrmI8BY3L8aB3kwLEGCqd+cR5IVXI2iK+bf/xhrrP0TTZWi378yA==
X-Received: by 2002:a92:c24a:0:b0:419:de32:2d01 with SMTP id e9e14a558f8ab-42481989234mr25313645ab.4.1758308165944;
        Fri, 19 Sep 2025 11:56:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d539906dfsm2442600173.56.2025.09.19.11.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 11:56:05 -0700 (PDT)
Date: Fri, 19 Sep 2025 12:56:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] vfio/pci: Fix INTx handling on legacy DisINTx- PCI
 devices
Message-ID: <20250919125603.08f600ac.alex.williamson@redhat.com>
In-Reply-To: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com>
References: <663798478.1707537.1757450926706.JavaMail.zimbra@raptorengineeringinc.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 Sep 2025 15:48:46 -0500 (CDT)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> PCI devices prior to PCI 2.3 both use level interrupts and do not support
> interrupt masking, leading to a failure when passed through to a KVM guest on
> at least the ppc64 platform, which does not utilize the resample IRQFD. This
> failure manifests as receiving and acknowledging a single interrupt in the guest
> while leaving the host physical device VFIO IRQ pending.
> 
> Level interrupts in general require special handling due to their inherently
> asynchronous nature; both the host and guest interrupt controller need to
> remain in synchronization in order to coordinate mask and unmask operations.
> When lazy IRQ masking is used on DisINTx- hardware, the following sequence
> occurs:
>
>  * Level IRQ assertion on host
>  * IRQ trigger within host interrupt controller, routed to VFIO driver
>  * Host EOI with hardware level IRQ still asserted
>  * Software mask of interrupt source by VFIO driver
>  * Generation of event and IRQ trigger in KVM guest interrupt controller
>  * Level IRQ deassertion on host
>  * Guest EOI
>  * Guest IRQ level deassertion
>  * Removal of software mask by VFIO driver
> 
> Note that no actual state change occurs within the host interrupt controller,
> unlike what would happen with either DisINTx+ hardware or message interrupts.
> The host EOI is not fired with the hardware level IRQ deasserted, and the
> level interrupt is not re-armed within the host interrupt controller, leading
> to an unrecoverable stall of the device.
> 
> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.

I'm not really following here.  It's claimed above that no actual state
change occurs within the host interrupt controller, but that's exactly
what disable_irq_nosync() intends to do, mask the interrupt line at the
controller.  The lazy optimization that's being proposed here should
only change the behavior such that the interrupt is masked at the call
to disable_irq_nosync() rather than at a subsequent re-assertion of the
interrupt.  In any case, enable_irq() should mark the line enabled and
reenable the controller if necessary.

Also, contrary to above, when a device supports DisINT+ we're not
manipulating the host controller.  We're able to mask the interrupt at
the device.  MSI is edge triggered, we don't mask it, so it's not
relevant to this discussion afaict.

There may be good reason to disable the lazy masking behavior as you're
proposing, but I'm not able to glean it from this discussion of the
issue.

> 
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 123298a4dc8f..011169ca7a34 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -304,6 +304,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
>  
>  	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
>  
> +	if (is_intx(vdev) && !vdev->pci_2_3)

We just set irq_type, which is what is_intx() tests, how could it be
anything other?  Thanks,

Alex

> +		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
> +
>  	ret = request_irq(pdev->irq, vfio_intx_handler,
>  			  irqflags, ctx->name, ctx);
>  	if (ret) {
> @@ -351,6 +354,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
>  	if (ctx) {
>  		vfio_virqfd_disable(&ctx->unmask);
>  		vfio_virqfd_disable(&ctx->mask);
> +		if (!vdev->pci_2_3)
> +			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>  		free_irq(pdev->irq, ctx);
>  		if (ctx->trigger)
>  			eventfd_ctx_put(ctx->trigger);


