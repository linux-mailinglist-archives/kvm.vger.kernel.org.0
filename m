Return-Path: <kvm+bounces-11506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B23F9877B62
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D694F1C20D90
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 07:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296BE10A0A;
	Mon, 11 Mar 2024 07:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="is2LK21v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC89101F7
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710142576; cv=none; b=A8ph+0GYokNCQdV/HPrjYwgNIubRmqJPMb51beJU8pKY5+N4+X43hcBw0lz7vv0McUi6JjyD8FFZmJDJ9/qcKbszbxEHdFbTMi3DKYRGp8qnhLEj+ujWPzzeOx5uHPO9wWksRpOKX87i5z+DNYVo9MmiMKwTULFt/wS/C1udo/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710142576; c=relaxed/simple;
	bh=ZwyyBrLsPrfkeRO/qCdBrDIYZKyn6HgHwL7Via+LdtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jymeHOzY8Lxn7cUeRkORW2kpyV5yEquzr3lQ88U22COf90j/o3rH74GnjJqmkC7TzWA1YI7wztN2aO50jAa6bpI8TKRPYHj73+o/VeGxyX9uRQ/pu7o5rBYeRoOMXi411Te2p/RR6LkemiNWhOrrG7qq1gm53RdhpgEHPvyj7m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=is2LK21v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710142573;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZMHRbz3Q3TluA+ZN/XoJw1oDrEBRi2FsoIFf5g/d00=;
	b=is2LK21vztTg97y6HTqez09H41YulqSIqbYcPDwxFReK3V6pGWUTJDsDJOWemYMBKucYNi
	H2DbLf8PSvkLo35q45fqK6GeltZ89/4PieeteGUPkWT8dM+nADV64TE8TXZEdDrkP0qR7K
	fBAnSlVyf+C6JrhxYZk0sV7OdQQFXBA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-mu1wQSolPdC7HLrusw5ybA-1; Mon, 11 Mar 2024 03:36:11 -0400
X-MC-Unique: mu1wQSolPdC7HLrusw5ybA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33e78c1b314so1422142f8f.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 00:36:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710142569; x=1710747369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZMHRbz3Q3TluA+ZN/XoJw1oDrEBRi2FsoIFf5g/d00=;
        b=q0UDkW1rsqXe6EX2uHPRFGlZ+MuiE60qbOEKocfPpHRZytgAgXybpF5UqDedrBPvUE
         P757nejCV53nvojvViCHo6bJ6ht28Ix+09d3Efi4dd99HoRnFBfHEej7WtUcYZtwYvhS
         2btzYQUPVhvbPRPfwHa9xVxPTDsaKog9Lq3fTnYzY8XqVg0Trzm6pAZxg4WjUywIFyXc
         0c0J8ymaOj3iw+tiuBDLAwmP8LMsZUH1HWCz0KUffmLXq6zmQRt4KlJzn3i4pVOLZSoa
         j7850GPJOb2XAcwhJzZGdH/s/UBF2zcYOdykDfWjWpJy2++yYDLtl2DyvURz8tSislII
         Y9HA==
X-Gm-Message-State: AOJu0YwXrPk/TnDKDfMZnC2JyjrY96VhARg5R+dJB0gi8PrTJp0jwPYZ
	H3q8rbIjQDdCfahQm+m8zrbbjbevwadySoCJ2xoOG/cf20E8fm2xGds9hgTBVE0cyfiOEAxAdNP
	9eEJuCuSMWvNrGhNAZAd9S53VNSIjmv1bpLmir1D5dBTlgNlLNRU39/bMoQ==
X-Received: by 2002:adf:ee8c:0:b0:33e:7333:41e with SMTP id b12-20020adfee8c000000b0033e7333041emr4260959wro.11.1710142569384;
        Mon, 11 Mar 2024 00:36:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGnA+80vIVXmpFSNsV1K8rSwSHZO4dOGQ2TWjNGaeV7iBJ6lgek7BanByJKwojSGMFqJv4fA==
X-Received: by 2002:adf:ee8c:0:b0:33e:7333:41e with SMTP id b12-20020adfee8c000000b0033e7333041emr4260942wro.11.1710142569014;
        Mon, 11 Mar 2024 00:36:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q11-20020adff94b000000b0033e95bf4796sm2121880wrr.27.2024.03.11.00.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 00:36:08 -0700 (PDT)
Message-ID: <d57f0df4-b155-4805-9121-53a9a1c23cee@redhat.com>
Date: Mon, 11 Mar 2024 08:36:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/7] vfio/pci: Disable auto-enable of exclusive INTx
 IRQ
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, clg@redhat.com, reinette.chatre@intel.com,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com, stable@vger.kernel.org
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-2-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240308230557.805580-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Alex,

On 3/9/24 00:05, Alex Williamson wrote:
> Currently for devices requiring masking at the irqchip for INTx, ie.
> devices without DisINTx support, the IRQ is enabled in request_irq()
> and subsequently disabled as necessary to align with the masked status
> flag.  This presents a window where the interrupt could fire between
> these events, resulting in the IRQ incrementing the disable depth twice.
> This would be unrecoverable for a user since the masked flag prevents
> nested enables through vfio.
>
> Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
> is never auto-enabled, then unmask as required.
> Cc: stable@vger.kernel.org
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 237beac83809..136101179fcb 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -296,8 +296,15 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
>  
>  	ctx->trigger = trigger;
>  
> +	/*
> +	 * Devices without DisINTx support require an exclusive interrupt,
> +	 * IRQ masking is performed at the IRQ chip.  The masked status is
> +	 * protected by vdev->irqlock. Setup the IRQ without auto-enable and
> +	 * unmask as necessary below under lock.  DisINTx is unmodified by
> +	 * the IRQ configuration and may therefore use auto-enable.
If I remember correctly the main reason why the

vdev->pci_2_3 path is left unchanged is due to the fact the irq may not be exclusive
and setting IRQF_NO_AUTOEN could be wrong in that case. May be worth to
precise in the commit msg or here? Besides Reviewed-by: Eric Auger
<eric.auger@redhat.com> Eric   

> +	 */
>  	if (!vdev->pci_2_3)
> -		irqflags = 0;
> +		irqflags = IRQF_NO_AUTOEN;
>  
>  	ret = request_irq(pdev->irq, vfio_intx_handler,
>  			  irqflags, ctx->name, vdev);
> @@ -308,13 +315,9 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
>  		return ret;
>  	}
>  
> -	/*
> -	 * INTx disable will stick across the new irq setup,
> -	 * disable_irq won't.
> -	 */
>  	spin_lock_irqsave(&vdev->irqlock, flags);
> -	if (!vdev->pci_2_3 && ctx->masked)
> -		disable_irq_nosync(pdev->irq);
> +	if (!vdev->pci_2_3 && !ctx->masked)
> +		enable_irq(pdev->irq);
>  	spin_unlock_irqrestore(&vdev->irqlock, flags);
>  
>  	return 0;


