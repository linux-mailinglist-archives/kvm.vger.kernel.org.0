Return-Path: <kvm+bounces-40612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4006BA59052
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 10:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E79E43AD76D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3432253FB;
	Mon, 10 Mar 2025 09:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/nD+Dx/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0621121D585
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 09:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600463; cv=none; b=Fo174vsRzv5mYNiv1P9MeiVpPd2aucANdDOGkzgcLvJ+GTMt+9FeZ0O68KybbZIp+VO8La36DGk38ZYdL3NP/cguIg0+/9AuyScVREGYBeqWEm4paZUGRP5mILP085I2OF32M5vWqabm0JCiumhBrtqbvOd9BwNzg3mZvA6RTGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600463; c=relaxed/simple;
	bh=yAtnu4q+UP9KYhg6IIsgBHTLGwgdb8KZ1KjyuYMs0h4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqQ1M6MwGoeG9MCz3gwu5lOSkaB5AfLjvpv2wX06ls434QyqbnuDO9Gw8fPFrAJpxIgJGhLxtNFKKgQQtg1ABuBSYWFumQIBXW6aPn45vEOoxKkc9vtZ037+b5FUijrbxDTPssAYcJOms8gVMQMHjP1T7s2HqXWOOzg2ZWDgHnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/nD+Dx/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741600458;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tR0W3AO0rtff4oh62slL6VIU1K2VGl5ZuTDMwGnr9WQ=;
	b=a/nD+Dx/IhpBLUVX5NRenDwpdc0yf6+HEA0RAJjPnX7Hvac1UpgBVxwI7nNPeZOsTXfxpQ
	5ZKF9c2P0Vmb5ieuXmKb7RYLIFTBb+dLPws3MdoIWYYzkCaDfwx40rPvwDlBKFPYUnaE29
	6G1wVJ6cm8dV4XKkoo6/rVY4BaZUtd4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-N_pM4DxmPyCuiuUgyBLXzQ-1; Mon, 10 Mar 2025 05:54:17 -0400
X-MC-Unique: N_pM4DxmPyCuiuUgyBLXzQ-1
X-Mimecast-MFC-AGG-ID: N_pM4DxmPyCuiuUgyBLXzQ_1741600456
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3913f97d115so560325f8f.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 02:54:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741600456; x=1742205256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tR0W3AO0rtff4oh62slL6VIU1K2VGl5ZuTDMwGnr9WQ=;
        b=U7vH8IA2t815ThGF99W/kP58EkF1LMKztSxm03bJuQb1Ey/KmlZAz6Pllz8HpLhz5Z
         wPoDBLm/lJV/Y2sSnGS6rtC6adR5A+ShzD2o5aA6+9LMz7EGrLDEzbjtBG5R92IEaGG9
         TJ4RFYIyclK4D8G8+n5AMM3riy/pfXiLIJHAanwXRTxJDdYP1nkGAIJJbiy8dxmVyEML
         B94WjRPiSlE4UCrCAuRC1rT3ExD1CZyNevRPAW49NRX8AljR218+VZ0gCcGRp0LUOxRo
         GlpU967Skjtjxmeqju3yGmKCsQxxodO+XLTH3n+kTEDKJK6nX9s5FVTCoFjb3ecc3D3y
         q1PQ==
X-Forwarded-Encrypted: i=1; AJvYcCViZy1M/iw3wFgicVTlRlQ3dzwkTnN1bUJF3dtoYt4MnXvEq+xRq0UAO5HBfj0WJC4ewgs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLJ2OmgOPpvZYOMhS9+LK8P8K9xraQl5gk3jdP2bNQ3s0C10rn
	xJJJOWOxea+RZQtAtgL4eEm89ImWKBMJ18wftTd3odD3KY29DwyJHycwXVov6Q9cDWh8b6+E87M
	cw+jBVJRonXl3Osmhw9pbrpWtoP2Mcb+RM07zkSVptFnGcP0j1A==
X-Gm-Gg: ASbGnctn5rCYreaD11GV8WsN2dwrsiUAlll7uzSfOVUvZMm/a5frE1II12Z/FPU2xcl
	Z/VOddePvKO8/zaYEF+Irfd9JtjT7R0Q5qLrnMv7Wp+6tirVB/GQHOYwKs9Y3Jkaomw8FYXMLRz
	Sze51jkpp2qeKah+RPJ0gIha1HAH1BAdtmbRSi+IKTTGh88TUoPpX88pQlE/6PmzvEzlw+zDRUH
	txOWG1KH+8ikixXVhFBsSm3AmBtNLvQREaYD37YTMTKc+vBkXXj+G/j64HA5AeY3v9OD6HCXamL
	U1PwX0K5PYkjh4jW3pnEA8Do8fp6m5GgclDtXRo6zcHqVH9ZF/CpvSa96FzbaiE=
X-Received: by 2002:a05:6000:156f:b0:391:27f1:fbf3 with SMTP id ffacd0b85a97d-3913af3d5e7mr4701968f8f.27.1741600456234;
        Mon, 10 Mar 2025 02:54:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBwMz5OAHxD3v4jQKjBgjVWOLGr7PcCA4jbJyJk6K4hEfZpzb5fBnmL6u2Po0UZEfWnTksjg==
X-Received: by 2002:a05:6000:156f:b0:391:27f1:fbf3 with SMTP id ffacd0b85a97d-3913af3d5e7mr4701924f8f.27.1741600455800;
        Mon, 10 Mar 2025 02:54:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb7ae4sm13985560f8f.5.2025.03.10.02.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 02:54:14 -0700 (PDT)
Message-ID: <28c102c1-d157-4d22-a351-9fcc8f4260fd@redhat.com>
Date: Mon, 10 Mar 2025 10:54:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 09/21] hw/vfio/pci: Convert CONFIG_KVM check to runtime
 one
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-10-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Philippe,

On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> Use the runtime kvm_enabled() helper to check whether
> KVM is available or not.

Miss the "why" of this patch.

By the way I fail to remember/see where kvm_allowed is set.

I am also confused because we still have some code, like in
vfio/common.c which does both checks:
#ifdef CONFIG_KVM
        if (kvm_enabled()) {
            max_memslots = kvm_get_max_memslots();
        }
#endif


Thanks

Eric

>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> ---
>  hw/vfio/pci.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index fdbc15885d4..9872884ff8a 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -118,8 +118,13 @@ static void vfio_intx_eoi(VFIODevice *vbasedev)
>  
>  static bool vfio_intx_enable_kvm(VFIOPCIDevice *vdev, Error **errp)
>  {
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
>      if (vdev->no_kvm_intx || !kvm_irqfds_enabled() ||
>          vdev->intx.route.mode != PCI_INTX_ENABLED ||
> @@ -171,16 +176,13 @@ fail_irqfd:
>  fail:
>      qemu_set_fd_handler(irq_fd, vfio_intx_interrupt, NULL, vdev);
>      vfio_unmask_single_irqindex(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX);
> +
>      return false;
> -#else
> -    return true;
> -#endif
>  }
>  
>  static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
>  {
> -#ifdef CONFIG_KVM
> -    if (!vdev->intx.kvm_accel) {
> +    if (!kvm_enabled() || !vdev->intx.kvm_accel) {
>          return;
>      }
>  
> @@ -211,7 +213,6 @@ static void vfio_intx_disable_kvm(VFIOPCIDevice *vdev)
>      vfio_unmask_single_irqindex(&vdev->vbasedev, VFIO_PCI_INTX_IRQ_INDEX);
>  
>      trace_vfio_intx_disable_kvm(vdev->vbasedev.name);
> -#endif
>  }
>  
>  static void vfio_intx_update(VFIOPCIDevice *vdev, PCIINTxRoute *route)
> @@ -278,7 +279,6 @@ static bool vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
>      vdev->intx.pin = pin - 1; /* Pin A (1) -> irq[0] */
>      pci_config_set_interrupt_pin(vdev->pdev.config, pin);
>  
> -#ifdef CONFIG_KVM
>      /*
>       * Only conditional to avoid generating error messages on platforms
>       * where we won't actually use the result anyway.
> @@ -287,7 +287,6 @@ static bool vfio_intx_enable(VFIOPCIDevice *vdev, Error **errp)
>          vdev->intx.route = pci_device_route_intx_to_irq(&vdev->pdev,
>                                                          vdev->intx.pin);
>      }
> -#endif
>  
>      ret = event_notifier_init(&vdev->intx.interrupt, 0);
>      if (ret) {


