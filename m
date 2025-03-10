Return-Path: <kvm+bounces-40586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A708A58D09
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A2AB16A90F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8418221544;
	Mon, 10 Mar 2025 07:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjgpdbpM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBDE2153FE
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741592277; cv=none; b=Ov5FxkIC6uEGOCtBk5K2rzhDEm/Ze6Dcg8vhVQaktMszvFvxfCIVg0mRC/H27bbcSOf+e7lO++lHfV9IhRI3Z0S9HFrsbFXDuZnVj8eiwGiXxZeI4+CnfF0W5nCQdGQvgu0/WoTTKI9m8YozITi1di0MKFC3p7sZEvXp/YYvq3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741592277; c=relaxed/simple;
	bh=XZ4DtVzTSZT+/b2P+zYwdYxLCuJCGt7ZHCUVON760ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dOP26L6CmLQw1SjlLRoTD/lQcgbj2aK1+7r8JHYYeK8TZYmxJWs6aqiW5JXZlG8wMocyDONxttup/ilYp4+DNKFMOjxoNFEq+wZER8sNBmcjA93DbI6LXHrJj7ta92DGPoW3hdHx+oeaoOLubMY1njUgZ6fyKdKar6LBd9r2A0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EjgpdbpM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741592274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sMCwxi4oqEg2aDVfEhF+u35D/4iuGDnhOX5TVHZZxXU=;
	b=EjgpdbpMMIL2Gt81DcaosoUr/m8HNTOOR77rrnIaF3Gg71h5Dlyf9u2luWCKGWL8n9JPdm
	e195xdanIrpJdnDv+XyyK9WBU0JqYZltLlzW+iTCFaj9v/igekjVpdQqCGw42a01eiIfyV
	7yGmEVs9PXE2IvX3Glj2UvsUWF25qNY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77--VzjWQQsOty4wPRp-UjD7Q-1; Mon, 10 Mar 2025 03:37:53 -0400
X-MC-Unique: -VzjWQQsOty4wPRp-UjD7Q-1
X-Mimecast-MFC-AGG-ID: -VzjWQQsOty4wPRp-UjD7Q_1741592272
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ce245c5acso13898235e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741592272; x=1742197072;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMCwxi4oqEg2aDVfEhF+u35D/4iuGDnhOX5TVHZZxXU=;
        b=EltM6lmKj9quIRJIvOc5eyemamMWegj6IxOrEC01rOKfO1tuofTtDeIhUWlXWV/U7w
         yGm82itf0BijMUGHpB21Lsg+GsTLNbvi1H/57OOk5wOTre+DXO0YkaNNa+O/xNyQwWnG
         ndQwBQMFH0BF6nm+DjQMKhYXIudMx5j2RYCkjWYpMdPpdgk915y3ljItCYbkf0bivO0h
         ibEkDRRnY2gbvLWhgaG/dsMrw6R+vUYLHfPcV23qtzPsAgQCvPNLoRAhXnzqgzdDFI4i
         NKMWoKsOY2TwxDtc1k/24mKBoDX/QhsvMaI6NGKaYWEWvo2QObyYhda2B4RLdunpYHjB
         FKHw==
X-Forwarded-Encrypted: i=1; AJvYcCVuw0t91+xmqfhNWqZ3kxOF7Ml1mBoEy5DmrpAJ5g6b/Pg9tkD4IupCjgJqUz7C2drviJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx84mK8NdRoTj3djGbROLNDnzNZmZTw0gHgcnBsO5W3bnc/BFTO
	UPmxl45CTIMthb0yB/g6pSUApP9PPXywGLWJnpza3Hb0oX1R0H/h5O9n63QOI8frnDZQO+2zeXE
	08pEwktu+svK8kS6htV5xSL7aiD1+K71ImCknNW7nYBJbSeOoTQ==
X-Gm-Gg: ASbGnctnTWK9A5A6Ikjac6mwoAOQx5GVVL5T/jI3x+EJwFtF16o8BeIhmhVUjayuN6p
	0M3iyrWFpF0dojVgNa2oJ8LT5hj0JWHQBen+7qio+TbcF9YWgsejsPgBbA+eDzzi7+/nv4P5zfx
	wpw8PbArhcYPznQ4gqD4BDAdl3S5HX9+hhkg9m5AcCx6Fk5FMMeRhHjOs3mDZN3q65Yqjn3yxZT
	GZTRUUovTNhX55+5br8tZ1woPaYFpPX3//z8CEDAzLBS4d4Z/XVXoGG/0JoLLCqsHHuMH/lVj1C
	Ht8hbyUwJzy6Vci8pgSezk2LdhzVM1Wl5C5ZEWShAXc7K9xtBKkjRw==
X-Received: by 2002:a05:600c:444d:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-43cfe154379mr2716665e9.15.1741592272117;
        Mon, 10 Mar 2025 00:37:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0srL6ClQbw24aDHYv2dVWgkXh+JPH04ci+BWOkV8mVfq/7veXu6PGHViDtDsb+PYl3QA6tQ==
X-Received: by 2002:a05:600c:444d:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-43cfe154379mr2716335e9.15.1741592271730;
        Mon, 10 Mar 2025 00:37:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cfaf6892csm14788515e9.24.2025.03.10.00.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 00:37:50 -0700 (PDT)
Message-ID: <415339c1-8f83-4059-949e-63ef0c28b4b9@redhat.com>
Date: Mon, 10 Mar 2025 08:37:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/21] hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime
 using vfio_igd_builtin()
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
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-13-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250308230917.18907-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
> Convert the compile time check on the CONFIG_VFIO_IGD definition
> by a runtime one by calling vfio_igd_builtin(), which check
> whether VFIO_IGD is built in a qemu-system binary.
> 
> Add stubs to avoid when VFIO_IGD is not built in:

I thought we were trying to avoid stubs in QEMU build. Did that change ?


Thanks,

C.


> 
>    /usr/bin/ld: libqemu-x86_64-softmmu.a.p/hw_vfio_pci-quirks.c.o: in function `vfio_bar_quirk_setup':
>    /usr/bin/ld: ../hw/vfio/pci-quirks.c:1216: undefined reference to `vfio_probe_igd_bar0_quirk'
>    /usr/bin/ld: ../hw/vfio/pci-quirks.c:1217: undefined reference to `vfio_probe_igd_bar4_quirk'
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/vfio/pci-quirks.h |  6 ++++++
>   hw/vfio/igd-stubs.c  | 20 ++++++++++++++++++++
>   hw/vfio/pci-quirks.c |  9 ++++-----
>   hw/vfio/meson.build  |  3 +++
>   4 files changed, 33 insertions(+), 5 deletions(-)
>   create mode 100644 hw/vfio/igd-stubs.c
> 
> diff --git a/hw/vfio/pci-quirks.h b/hw/vfio/pci-quirks.h
> index fdaa81f00aa..dcdb1962600 100644
> --- a/hw/vfio/pci-quirks.h
> +++ b/hw/vfio/pci-quirks.h
> @@ -13,6 +13,7 @@
>   #define HW_VFIO_VFIO_PCI_QUIRKS_H
>   
>   #include "qemu/osdep.h"
> +#include "qom/object.h"
>   #include "exec/memop.h"
>   
>   /*
> @@ -71,4 +72,9 @@ extern const MemoryRegionOps vfio_generic_mirror_quirk;
>   
>   #define TYPE_VFIO_PCI_IGD_LPC_BRIDGE "vfio-pci-igd-lpc-bridge"
>   
> +static inline bool vfio_igd_builtin(void)
> +{
> +    return type_is_registered(TYPE_VFIO_PCI_IGD_LPC_BRIDGE);
> +}
> +
>   #endif /* HW_VFIO_VFIO_PCI_QUIRKS_H */
> diff --git a/hw/vfio/igd-stubs.c b/hw/vfio/igd-stubs.c
> new file mode 100644
> index 00000000000..5d4e88aeb1b
> --- /dev/null
> +++ b/hw/vfio/igd-stubs.c
> @@ -0,0 +1,20 @@
> +/*
> + * IGD device quirk stubs
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Copyright (C) Linaro, Ltd.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "pci.h"
> +
> +void vfio_probe_igd_bar0_quirk(VFIOPCIDevice *vdev, int nr)
> +{
> +    g_assert_not_reached();
> +}
> +
> +void vfio_probe_igd_bar4_quirk(VFIOPCIDevice *vdev, int nr)
> +{
> +    g_assert_not_reached();
> +}
> diff --git a/hw/vfio/pci-quirks.c b/hw/vfio/pci-quirks.c
> index c53591fe2ba..22cb35af8cc 100644
> --- a/hw/vfio/pci-quirks.c
> +++ b/hw/vfio/pci-quirks.c
> @@ -11,7 +11,6 @@
>    */
>   
>   #include "qemu/osdep.h"
> -#include CONFIG_DEVICES
>   #include "exec/memop.h"
>   #include "qemu/units.h"
>   #include "qemu/log.h"
> @@ -1213,10 +1212,10 @@ void vfio_bar_quirk_setup(VFIOPCIDevice *vdev, int nr)
>       vfio_probe_nvidia_bar5_quirk(vdev, nr);
>       vfio_probe_nvidia_bar0_quirk(vdev, nr);
>       vfio_probe_rtl8168_bar2_quirk(vdev, nr);
> -#ifdef CONFIG_VFIO_IGD
> -    vfio_probe_igd_bar0_quirk(vdev, nr);
> -    vfio_probe_igd_bar4_quirk(vdev, nr);
> -#endif
> +    if (vfio_igd_builtin()) {
> +        vfio_probe_igd_bar0_quirk(vdev, nr);
> +        vfio_probe_igd_bar4_quirk(vdev, nr);
> +    }
>   }
>   
>   void vfio_bar_quirk_exit(VFIOPCIDevice *vdev, int nr)
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index a8939c83865..6ab711d0539 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -17,6 +17,9 @@ specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
>   
>   system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
>   system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
> +system_ss.add(when: 'CONFIG_VFIO_IGD', if_false: files(
> +  'igd-stubs.c',
> +))
>   system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>     'helpers.c',
>     'container-base.c',


