Return-Path: <kvm+bounces-58898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27372BA4F94
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 21:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415A21C24836
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 19:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B7E27FB26;
	Fri, 26 Sep 2025 19:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="byf/DLVc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A8B27B500
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758915346; cv=none; b=tf+rV9LXPOb7o2SLuKXsfWnL/9XaSY3OWIvmqiGEa+k0EorBOub9ifNNVvw2rzz8+6h47TQfa4/OT7C5+PDiAI//eTpQP6VBPISGa/v1fwOGT8HpHyO7Mdovq9WztSNF0G5TD6nU7YeeYc/xP8P1avAjCIkTxhIP0ErTvX9+vGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758915346; c=relaxed/simple;
	bh=OeQn25mM0+thVpB1zWjDniwOQT5Nf6ZDwe+5aII4WR8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPluiazD3XV+2MgOajRTYRx7qAf27jqkcWucnF6sQwKZCWtcF+SE88bH2lZQzNrotPrLl5fOKf5gHzEf1LVDjomqcsr18Q9tt/0k865G2dAg+lJd0R+Hm2KvIIh/ufUQFhRN+RKWOX+DVS6eV0S8BfMQ9DrKEbTZS0igNb+DFmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=byf/DLVc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758915342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oY1hglVyTWd1KeCI5NfVNHgyGT0tzUUrNBNxvpJcPL4=;
	b=byf/DLVcS/2zN7nocOWs3HwtnesNyK0M+YgIvu9PYvGA1oZW9YIP5gFIZh5REd3XKLwY/f
	g+oUtAXAV0/PDEgpMefMkQjUaX0B3tJ6F1Jflze0KMGEXjEsO8KCwbZIEZQSSdIcBWYz1O
	C48FFY0mlFvv/fH7kqdWctii5i6IN1M=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-tSimgQ-kMKipusJhzjq1-A-1; Fri, 26 Sep 2025 15:35:39 -0400
X-MC-Unique: tSimgQ-kMKipusJhzjq1-A-1
X-Mimecast-MFC-AGG-ID: tSimgQ-kMKipusJhzjq1-A_1758915339
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4248bfd20faso7682775ab.2
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 12:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758915338; x=1759520138;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oY1hglVyTWd1KeCI5NfVNHgyGT0tzUUrNBNxvpJcPL4=;
        b=ANEIafNJGoDdhLn91Hb6a9/Sp1+nJDVC0E+54TxkCaUlA6yn/gl+LPpzh1dWMkpakB
         2AWIfpMHJ5xoHmDjDijX6zF3qtPr2KaCKC+lskClVpztTMF8rLBKDYT1l9LkzDr+agnc
         rxIbHdP1w/SGlX/zOzncvl3+s+BUJTRpBqnQzRRso9jTDCk3t18egrsvMIZD/rEdn+ZD
         1sBZ5X26hO/54jh3uEWR1WicQ25Hd+DilHb5BNi6G1phragVK7YbA518bHbvADvAr7Q9
         GZUaOFHv5r1CCi1fT0GV8ifo2cbyuFJf4+ZtGrolh9Bn3w+JUlAHGplk7V4sWD2kMbZ8
         ub1g==
X-Gm-Message-State: AOJu0YzJWWsBsFr/IKBIuwtRHQsk5rWUVMJRWgNy7jGIsaB3jWvd5Ym6
	FYb0yGBDIXrEtzrl7YlWmHbez6k+mGycln/DKXhO9dXRfHO8vHMMHHp4munzKwMkKiJUN2yCM0E
	WVdOWXu0m6vFFudcfwVAZ66ixn5VUgR4J2gtO8oQjdK+TN9D6Q94M7A==
X-Gm-Gg: ASbGnctPVCs9JQlyOZ2JQPNLgXU2aCmUAnINdn79esAWMpsprZKQzcpw0001+anxH2i
	4eEZ1WWBbcF7o8FgV2Kyyiu2IpAhJlMGaaE5/CxlIKiFWkQGSBGvsz2LQEfxeevMLbgUMlAdP6b
	6BlwimfMS2qiuB+Skxa9Jwq1TesPgW658L9ZV1OVjp3hdk9VEBZBstl8F9OFKJW/BNVa2Sr5b76
	XDp3P35kNSWS9d7vLiBukGYtdDmO+3HBH6mQuo8cajaqnn/RWKuC18WpcjuZ034Ovntq5Pz9Jp1
	6M6kJvLsODjREhFCpyuS3I/OgWePCPWu3y1oqDYA+50=
X-Received: by 2002:a05:6602:15c9:b0:893:6203:3724 with SMTP id ca18e2360f4ac-9013213d540mr426976539f.0.1758915338397;
        Fri, 26 Sep 2025 12:35:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGR2DnZA3GXqQrAUC6ZcTCJTXIWsAJfpwgJcYcU5jtBTsOVnpzauFMrgUuqFC0eBpZO46rZjA==
X-Received: by 2002:a05:6602:15c9:b0:893:6203:3724 with SMTP id ca18e2360f4ac-9013213d540mr426974539f.0.1758915337866;
        Fri, 26 Sep 2025 12:35:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-904100c3cfcsm206353739f.23.2025.09.26.12.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 12:35:37 -0700 (PDT)
Date: Fri, 26 Sep 2025 13:35:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: kvm <kvm@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v4] vfio/pci: Fix INTx handling on legacy non-PCI 2.3
 devices
Message-ID: <20250926133534.0d8084f5.alex.williamson@redhat.com>
In-Reply-To: <333803015.1744464.1758647073336.JavaMail.zimbra@raptorengineeringinc.com>
References: <333803015.1744464.1758647073336.JavaMail.zimbra@raptorengineeringinc.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Sep 2025 12:04:33 -0500 (CDT)
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
>  * Guest processes IRQ and clears device interrupt
>  * Device de-asserts INTx, then re-asserts INTx while the interrupt is masked
>  * Newly asserted interrupt acknowledged by kernel VMM without being handled
>  * Software mask removed by VFIO driver
>  * Device INTx still asserted, host controller does not see new edge after EOI
> 
> The behavior is now platform-dependent.  Some platforms (amd64) will continue
> to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
> will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
> only send the one request, and if it is not handled no further interrupts will
> be sent.  The former behavior theoretically leaves the system vulnerable to
> interrupt storm, and the latter will result in the device stalling after
> receiving exactly one interrupt in the guest.
> 
> Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.
> 
> Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 123298a4dc8f..61d29f6b3730 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -304,9 +304,14 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
>  
>  	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
>  
> +	if (!vdev->pci_2_3)
> +		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
> +
>  	ret = request_irq(pdev->irq, vfio_intx_handler,
>  			  irqflags, ctx->name, ctx);
>  	if (ret) {
> +		if (!vdev->pci_2_3)
> +			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>  		vdev->irq_type = VFIO_PCI_NUM_IRQS;
>  		kfree(name);
>  		vfio_irq_ctx_free(vdev, ctx, 0);
> @@ -352,6 +357,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
>  		vfio_virqfd_disable(&ctx->unmask);
>  		vfio_virqfd_disable(&ctx->mask);
>  		free_irq(pdev->irq, ctx);
> +		if (!vdev->pci_2_3)
> +			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
>  		if (ctx->trigger)
>  			eventfd_ctx_put(ctx->trigger);
>  		kfree(ctx->name);

As expected, I don't note any functional issues with this on x86.  I
didn't do a full statistical analysis, but I suspect this might
slightly reduce the mean interrupt rate (netperf TCP_RR) and increase
the standard deviation, but not sufficiently worrisome for a niche use
case like this.

Applied to vfio next branch for v6.18.  Thanks,

Alex


