Return-Path: <kvm+bounces-58402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A362B92882
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BA3C7AF308
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450F03128B6;
	Mon, 22 Sep 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LLm0bEeF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4CB35959
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758564093; cv=none; b=bEdL3iZYERCJh04OwlBH1ce3L2esfxnfNbidMhSKRNLn6XDI1pQxPaCLTfQu7MW5CnW/OdWI3xgdE2lwmvGlaA1MSsPzrawZ8nlVrHpBgxzDazcdevGklWaZr1E4/939rqqDr2jb62x9JFDOT2H9oiw+ZAcyBA96w08pZfHRgUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758564093; c=relaxed/simple;
	bh=CWvEKzHgvZeIZRAK9ju9sjQdAcAFY/zU7V19uBX6g6A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lHE0RTwPKuvLhCM+XRT1OMpnXy6yGI61Z6T8X1Mx1SMbqKda+DB/cuAIo8RMhLCYb9eBVuvARe23L8SR8qiPzRa/Kkg1YRxaXkmXWTz+biMps6DKqR69FD/cKfFD9Vc9p0jw+Bvcd/j53sGNh083zRV/ttC3z67UkD3jILoeXSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LLm0bEeF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758564090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=460DG1Ic4Vy4ZRI7OvE4PwRA1Kutoztc9uoODBEFv+Y=;
	b=LLm0bEeFceGCSPWkwVVT2nTl68F4EZngtlmHECHttp/fDZkBbnq/EodVHvjbI/vhEtPS+l
	JdERSTfJkCKuqVwVi3isJmzuwSnH/pM9YZg2bw1q3Pgl43P2khX+u2Brgb3kKDsbnZtOH+
	dCzisWEhvGVmTrb8i7CjghbPXjtKOqQ=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-bcTOMllDPXizjUM1Wopq8A-1; Mon, 22 Sep 2025 14:01:28 -0400
X-MC-Unique: bcTOMllDPXizjUM1Wopq8A-1
X-Mimecast-MFC-AGG-ID: bcTOMllDPXizjUM1Wopq8A_1758564088
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-30cce8f09f3so1211731fac.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 11:01:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758564087; x=1759168887;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=460DG1Ic4Vy4ZRI7OvE4PwRA1Kutoztc9uoODBEFv+Y=;
        b=PdgGsudSofwgMh1OXf6h/fsrPX85v1tNyU8qy3zFjeN+gdao0/Bb5hzNbbgruhbPoJ
         AqLZiq51NBUGC0we4PBj1rZfu2KroAsvm+zEKAwie/XeT0INYP0uIUvnVnBlZBLGCVtt
         OJQ4mC11e+d3bjQGDWGc2KH52znqXoXk8jm1aXagL0/rQDvpVZ34Jb8cTi2vYp+cwyrE
         FUWMcaxguHI1M1lkMBeh3wEaLFA60fCO0taZeybBDJejrPeGFkgiaqC/xPZF/PlBHUjb
         XV9PmRjb3tmRj2gbbSuvWPiTM+BsAZnwRAKMVvzxsMAf3tC1iuuGbDhdC4QyxhAklrYo
         x9Bg==
X-Gm-Message-State: AOJu0YzbJhX2dK/c6NU7RKUWD9CQ4YZBzzzB+zUKn9od8d1KdZyqpH8R
	YvsXB53PDw0FBVVO1X0zzI33SoG1Wmb8j6AenYjV5NaFw9kWWU00Z1d0jCmUR9RPfsNeZk6+aQj
	YUFXTAzbKwLA3i+/TscEzsr1mmFSLr6s1x3Wxy09ekhVNkD1tsgR94QnZM6p1OQ==
X-Gm-Gg: ASbGncvISwigxP9uEAgcywHFV9IRKeap33c36V+WFwCEdAJ/jq/KzmrnuSMspSmQKKj
	NScnbD+AQ3XW6h9t51wpuAd9UgyPCpuzjFKleQc5j8lOTd3V7AxbalI3xSbbnGIxiMhfc05Os6n
	TlcPZbFnGb7rRriN8ZbO5cNazPYNlCCCYXlawUzhqoj0qwKLHcHm/HN2unVhRSJ/UR4XzkDGou0
	NeGNqJ2WB1l3a0B6WBDrMEsJ185ItS6a2p00S5MXCrYq3PESfIXLX5+9Jb6CujLAdkRaxhmk21Y
	kQhwyEn4XB7z3ijVY+HYmzcuZ9le2yJd8HeW4dw84MU=
X-Received: by 2002:a05:6870:b629:b0:315:9799:3034 with SMTP id 586e51a60fabf-33bb25f83c2mr4002020fac.4.1758564086769;
        Mon, 22 Sep 2025 11:01:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYnIMKXh5y99WxhdDkDbr916ivwJuVlh0A+q2C84lnCRCzbEmhjL5pCZQH6SAgTllCOi6PJQ==
X-Received: by 2002:a05:6870:b629:b0:315:9799:3034 with SMTP id 586e51a60fabf-33bb25f83c2mr4001999fac.4.1758564086216;
        Mon, 22 Sep 2025 11:01:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-625d881f9b9sm4159648eaf.1.2025.09.22.11.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 11:01:25 -0700 (PDT)
Date: Mon, 22 Sep 2025 12:01:22 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
 devices
Message-ID: <20250922120122.4e9942e8.alex.williamson@redhat.com>
In-Reply-To: <912864077.1743059.1758561514856.JavaMail.zimbra@raptorengineeringinc.com>
References: <912864077.1743059.1758561514856.JavaMail.zimbra@raptorengineeringinc.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 12:18:34 -0500 (CDT)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> PCI devices prior to PCI 2.3 both use level interrupts and do not support
> interrupt masking, leading to a failure when passed through to a KVM guest on
> at least the ppc64 platform. This failure manifests as receiving and
> acknowledging a single interrupt in the guest, while the device continues to
> assert the level interrupt indicating a need for further servicing.
> 
> When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the following
> sequence occurs:
> 
>  * Level IRQ assertion on device
>  * IRQ marked disabled in kernel
>  * Host interrupt handler exits without clearing the interrupt on the device
>  * Eventfd is delivered to userspace
>  * Host interrupt controller sees still-active INTX, reasserts IRQ
>  * Host kernel ignores disabled IRQ
>  * Guest processes IRQ and clears device interrupt
>  * Software mask removed by VFIO driver

This isn't the sequence that was previously identified as the issue.
An interrupt controller that reasserts the IRQ when it remains active
is not susceptible to the issue, and is what I think we generally
expect on x86.  I understand that we believe this issue manifests
exactly because the interrupt controller does not reassert an interrupt
that remains active.  I think the sequence is:

 * device asserts INTx
 * vfio_intx_handler() calls disable_irq_nosync() to mark IRQ disabled
 * interrupt delivered to userspace via eventfd
 * userspace driver/VM services interrupt
 * device de-asserts INTx
 * device re-asserts INTx
 * interrupt received while IRQ disabled is masked at controller
 * VMM performs EOI via unmask ioctl, enable_irq() clears disable and
   unmasks IRQ
 * interrupt controller does not reassert interrupt to the host

The fix then, aiui, is that disabling the unlazy mode masks the
interrupt at disable_irq_nosync(), the same sequence of de-asserting
and re-asserting the interrupt occurs at the controller, but since the
controller was masked at the new rising edge, it will send the
interrupt when umasked.

> The behavior is now platform-dependent.  Some platforms (amd64) will continue
> to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
> will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
> only send the one request, and if it is not handled no further interrupts will
> be sent.  The former behavior theoretically leaves the system vulnerable to
> interrupt storm, and the latter will result in the device stalling after
> receiving exactly one interrupt in the guest.
> 
> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 123298a4dc8f..d8637b53d051 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -304,6 +304,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
>  
>  	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
>  
> +	if (!vdev->pci_2_3)
> +		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
> +
>  	ret = request_irq(pdev->irq, vfio_intx_handler,
>  			  irqflags, ctx->name, ctx);
>  	if (ret) {

This branch is an example of where we're not clearing the flag on
error.  Thanks,

Alex

> @@ -352,6 +355,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
>  		vfio_virqfd_disable(&ctx->unmask);
>  		vfio_virqfd_disable(&ctx->mask);
>  		free_irq(pdev->irq, ctx);
> +		if (!vdev->pci_2_3)
> +			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>  		if (ctx->trigger)
>  			eventfd_ctx_put(ctx->trigger);
>  		kfree(ctx->name);


