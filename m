Return-Path: <kvm+bounces-40484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A6DA57C7E
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A86A188FC8D
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9FF31E51FB;
	Sat,  8 Mar 2025 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EoPIqfE2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA2382
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741456018; cv=none; b=kG/I1XfKzximUY4pu+Kg9biIV6IWp9N1JaiU6Lp1YYpeus03Dl+RxlEYScWu9fdScFnduyEh2FavQg4EkDylv9GRhksM0pZ7euQ7T6mT55f5T1lLb68Ni7NRVj+B9EQkziiMzKxdCO5gD3GkS79JG1uBTH3CVWO05UaSz9Qw+5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741456018; c=relaxed/simple;
	bh=orNi7udgNnSq6OteuSKH0sPpaJ4rju+hdgJiRNMfMwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MISUzQi08TdlJqKT5DGgl7HenHo0xy47/rMc+BgzRJxZWCyZDxtj1XKuMGs/yjsq6L8G6SUJLgFZhgRGT8kUzNE/fyouj6pmZgOYZBLed3d7G9QHSFBq2Lkj0DeQ5HVW3npcCC/6kReeaCy7yEk2m+b4X+sW5X8JMPsAub85Evw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EoPIqfE2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741456016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kplSIE8sz96ksijypwP97suDzWNUGToBxqP/OBlFt5U=;
	b=EoPIqfE23z6a8joBh9mNgjZanLunaopvWSNdfuIiaby2OwisfvRqFWIZBSnDQUWXblu9bU
	3uv8irGTU2tS65snQ6XFPFdp2ABJJ5rPDh12HN6gzSaMkfpR82kq89jDQrnP/yvu5PA/Om
	cehkRo2tXDE4J8q/ATHJv1ZS/2hUtaE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-pv1T1vuLNieWxwAWsoTM9A-1; Sat, 08 Mar 2025 12:46:54 -0500
X-MC-Unique: pv1T1vuLNieWxwAWsoTM9A-1
X-Mimecast-MFC-AGG-ID: pv1T1vuLNieWxwAWsoTM9A_1741456013
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3913f97d115so141991f8f.0
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741456013; x=1742060813;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kplSIE8sz96ksijypwP97suDzWNUGToBxqP/OBlFt5U=;
        b=fIJ+G7QAet8kMXaQxwJwoJBfhXinxUpft534rYYxpRWHGpXB6pvROgucV+Sp2APtoj
         tZKrynOjoZoqGVIFmnF0/SFaZFap19xz2xdp8RwyBeKp9HnNzxt/ewOJzw4kcjLICtw2
         Yc1pPGAjhJNnH2NzW6ifB3hHcls7C99zs2GsjGvRYV20tzpL/xf+mAMz6VEwg5MtYL7D
         ErEgIbCVSCNNcQxsqHvFVGm+yRgnO34SsukDYnoddpGeYMbWnkAQp5fmIqRqdrvCJatM
         A1Ckv8yHcJDJLcCk7IFETj6GnfHbMir0i9dVH5P61esQwctXgosdQyA+KBALXQqvJFTG
         oZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTN6wBIpQ5aHzBu0MNHwR+6djJ29C+Zc5Ccuhe+YB6G9WhfGCmEe7mC/Twd6zK6tnADh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkdAIhQzWsYk9AOQEkPgQcR5CR4TZ8x1hxzQIUkKA/Bmip+okC
	Jtu6BwHqaWp6+Oe2jTKCIuu1rd3zf9iobYnJOMyD9iP64PbMNdxwZIDbzP0XiW00C4PxgXeH9xH
	uA5JO9dDjOzDN/L+/fG171EN8RNPJ6k2ruG7zEM7hGwYI7nDzqg==
X-Gm-Gg: ASbGnctU7ALe2WwNDcR4cXsdyug1ZCargBaqRExrUoq2Z9ZS2San6mQdt3xgnw0rNOv
	WyPJVNxKzUs4spw+pljALaT152g6ivJk107lsR6RABQv/EVbK9wbh8kAcZZzGmgP7NJa0WGyS2L
	pxLdsA2+KTbu5WbOvYlyZegNOA8YU/kFuz/tmumrnSSvJ+aImE9ujMxkrhQP2YOUTpzHRKcTQBi
	9IMAb1RtGiEdn1gWq8dv9Ej8S2lX8mLUw7X7JSF6Fw+rwkSMitllyxhaSxVbPw90czsrhhxGlw7
	JrUpvBpiCuSv/kQgSgJfdhwS34ZzO2a83PGl0CuKwgqmhVQfiEzGvQ==
X-Received: by 2002:a05:6000:1f84:b0:390:ec6e:43ea with SMTP id ffacd0b85a97d-3913af060e0mr2540741f8f.15.1741456013521;
        Sat, 08 Mar 2025 09:46:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHACTi5CC9SIWwc1JtKrQyMJgYyvTWI5vSTqG9Fd4mfmKIqRA/AQ7YM1vpgtBxVRDpfYzX5cw==
X-Received: by 2002:a05:6000:1f84:b0:390:ec6e:43ea with SMTP id ffacd0b85a97d-3913af060e0mr2540721f8f.15.1741456013168;
        Sat, 08 Mar 2025 09:46:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cec8e1596sm15897565e9.31.2025.03.08.09.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:46:52 -0800 (PST)
Message-ID: <ead04114-e666-4cd4-bb9b-2676e7becce2@redhat.com>
Date: Sat, 8 Mar 2025 18:46:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/14] hw/vfio/pci: Convert CONFIG_KVM check to runtime
 one
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
 Jason Herne <jjherne@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-10-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> Use the runtime kvm_enabled() helper to check whether
> KVM is available or not.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/pci.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index fdbc15885d4..9872884ff8a 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -118,8 +118,13 @@ static void vfio_intx_eoi(VFIODevice *vbasedev)
>   
>   static bool vfio_intx_enable_kvm(VFIOPCIDevice *vdev, Error **errp)
>   {
> -#ifdef CONFIG_KVM
> -    int irq_fd = event_notifier_get_fd(&vdev->intx.interrupt);
> +    int irq_fd;
> +
> +    if (!kvm_enabled()) {
> +        return true;
> +    }
> +
> +    irq_fd = event_notifier_get_fd(&vdev->intx.interrupt);
>   
>       if (vdev->no_kvm_intx || !kvm_irqfds_enabled() ||
>           vdev->intx.route.mode != PCI_INTX_ENABLED ||
> @@ -171,16 +176,13 @@ fail_irqfd:
>   fail:
>       qemu_set_fd_handler(irq_fd, vfio_intx_interrupt, NULL, vdev);
>       vfio_unmask_single_irqindex(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX);
> +
>       return false;
> -#else
> -    return true;
> -#endif
>   }
>   
>   static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
>   {
> -#ifdef CONFIG_KVM
> -    if (!vdev->intx.kvm_accel) {
> +    if (!kvm_enabled() || !vdev->intx.kvm_accel) {
>           return;
>       }
>   
> @@ -211,7 +213,6 @@ static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
>       vfio_unmask_single_irqindex(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX);
>   
>       trace_vfio_intx_disable_kvm(vdev->vbasedev.name);
> -#endif
>   }
>   
>   static void vfio_intx_update(VFIOPCIDevice *vdev, PCIINTxRoute *route)
> @@ -278,7 +279,6 @@ static bool vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
>       vdev->intx.pin = pin - 1; /* Pin A (1) -> irq[0] */
>       pci_config_set_interrupt_pin(vdev->pdev.config, pin);
>   
> -#ifdef CONFIG_KVM
>       /*
>        * Only conditional to avoid generating error messages on platforms
>        * where we won't actually use the result anyway.
> @@ -287,7 +287,6 @@ static bool vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
>           vdev->intx.route = pci_device_route_intx_to_irq(&vdev->pdev,
>                                                           vdev->intx.pin);
>       }
> -#endif
>   
>       ret = event_notifier_init(&vdev->intx.interrupt, 0);
>       if (ret) {


