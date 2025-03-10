Return-Path: <kvm+bounces-40588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1EDA58D0B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 814D3188D0AD
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E125221543;
	Mon, 10 Mar 2025 07:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y2h2aAPo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F4E1CAA70
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741592315; cv=none; b=q/uQ+/+M+k78hNcQaoEMrKKHDZBG2YiXOtYgMJJNUDEBrI5PVcPTG+EKqrGW2KheIAp+NznfvZRAyRJ4vw3uyrpRk1diUHWSrDw6hUpNC/shJPz3wQaXQW0UJmDYz+OMj2cZ0zda+FcbSXpU6NR8gP5AEHOXCvFMXqSAdgA9dCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741592315; c=relaxed/simple;
	bh=bFQhGbgFVuB6JSoOrXMIMFIAlmoiAyT2wqLAjD9ZV6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YZuEwFaCd7qAN2hJssvuqdR2MfZ2EejnK4rKr0ciYQYNTmwT6A00UB6nyLVRJD/6dwyXtaFuwmpPPPWFeQ4v0m12VtjjEHW+3T0lQd3/hwYIj8EooO76+DuuHjjwP3+0SGMAAaQdrhw7Zk5K1yXFoi3a6hE24R40oer2WRY+Oa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y2h2aAPo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741592313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GVlHPqi6khAgp4NROThPCeWZ+Jjizn4nCkjDIbu+9os=;
	b=Y2h2aAPoCGy8VcIMBY7z6ENCfQuBmtRVU7lV65/8wwsjXgNmIX3EZtBcEW43IidAJkTdE7
	3u2VUG7TbowUuRN/wpNJWbZ1kbPb7s9NSGGjd9rZ3ypk3jWxgHJJjWMrY/4k8BxErC7fvW
	IeZpwE1D3Dq5YXirV85W2O2tyYMzESE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-4U-JlZ6cNfGWCqwwqAmjWA-1; Mon, 10 Mar 2025 03:38:31 -0400
X-MC-Unique: 4U-JlZ6cNfGWCqwwqAmjWA-1
X-Mimecast-MFC-AGG-ID: 4U-JlZ6cNfGWCqwwqAmjWA_1741592310
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so4093045e9.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741592310; x=1742197110;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVlHPqi6khAgp4NROThPCeWZ+Jjizn4nCkjDIbu+9os=;
        b=VKpC1kXHDKGuFQEo+8W2JghDjufPDxl68/Dzs+/HfbaYEF9tsgIGqb7UTiEY6TGC5c
         74JeOytbbsIiaW7Aw18hlXdwPLIPKrwCz8DSP7tVM8Q2AyRUqYK4AhKmPxpZ25+MEGOq
         LPZRZBSLxKRIjZygQIeaxweUcKGUreSwygSqbfhWpHnn9051wnj0FANf5aRmb9F5+7p4
         ENYC79n7YxhYF9bJLkKmybO55dRczfE6cMw73rValMIOJqadLLzC8yr9pQtVv1y1TuEA
         +r3nTMooy4uAHtgEGa/ESyRQsVIMb0m+kYJ7IwGduk1mp5GWd1TrFlc3CagFKl2wh8E/
         UgsA==
X-Forwarded-Encrypted: i=1; AJvYcCX2+lKkwpxMx2tR7BEFM9vMjbAVvmUU6YS16MOHgwUhwWoVjUnbYR5apfFHV9wZ6qz5YN4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1e0e0QtEyrrzQbeJePblBzd10sYa76b/CZV40giuVukRyn6Rb
	ks2VNgxAb2Ng6hOcI5VRcWzgKBWsBIGDdPb2jovI6TB2W0xXH2B0uLxQkySbCY+If7RvzZ3xG7r
	ksf73GqpWbCxqrj/co0tqczBtQuYCznKS1EjpUiP3ZV2bQCN7cg==
X-Gm-Gg: ASbGncuzPdFyWRPbW+beacQajt0Njm5syVGwQvtb8q8fWHrhJ0RoyH2X8xHWFRFpGYC
	trOL6lmqf5trPH1XqPn9aNntuJOc3lJFGraLLzJ2igTbJvaYvqF0YnUwSJQk7uj/IgAQZ6p8Z/M
	dSHV9o2yj6PPY3yMfapwQYNE6r9RadlKtNSP9L731SBq9usFupy/y6+yzoMdQy7vyAUn5RlIUeH
	o/WGk5HA5O7ZVz5z9zLmwW07ckaz8PHlcZpOShInldTARxcG5uhxxBANxuBqDGg05b1ze4HB/Ib
	SMUcSPzJbXEq0HGE/Xw5uWiMgOoOOcq9sy2zmefsUvpAaC7iyobqLg==
X-Received: by 2002:a05:6000:18af:b0:391:3b1b:f3b7 with SMTP id ffacd0b85a97d-3913b1bf54amr3942337f8f.28.1741592310075;
        Mon, 10 Mar 2025 00:38:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiahtuiON9qB1ZPT4rXfJHltu8gWbLn4mRq/nAUaKEk5h5U+ZW+r1nn9PUl4zpjFgM9R7lmA==
X-Received: by 2002:a05:6000:18af:b0:391:3b1b:f3b7 with SMTP id ffacd0b85a97d-3913b1bf54amr3942313f8f.28.1741592309669;
        Mon, 10 Mar 2025 00:38:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cf86b1d80sm25719405e9.9.2025.03.10.00.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 00:38:29 -0700 (PDT)
Message-ID: <1446fd11-c5fe-44b6-afad-3483bea22325@redhat.com>
Date: Mon, 10 Mar 2025 08:38:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/21] hw/vfio/igd: Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE
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
 <20250308230917.18907-12-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250308230917.18907-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
> Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE once to help
> following where the QOM type is used in the code.
> We'll use it once more in the next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/pci-quirks.h | 2 ++
>   hw/vfio/igd.c        | 4 ++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/vfio/pci-quirks.h b/hw/vfio/pci-quirks.h
> index d1532e379b1..fdaa81f00aa 100644
> --- a/hw/vfio/pci-quirks.h
> +++ b/hw/vfio/pci-quirks.h
> @@ -69,4 +69,6 @@ typedef struct VFIOConfigMirrorQuirk {
>   
>   extern const MemoryRegionOps vfio_generic_mirror_quirk;
>   
> +#define TYPE_VFIO_PCI_IGD_LPC_BRIDGE "vfio-pci-igd-lpc-bridge"
> +
>   #endif /* HW_VFIO_VFIO_PCI_QUIRKS_H */
> diff --git a/hw/vfio/igd.c b/hw/vfio/igd.c
> index b1a237edd66..1fd3c4ef1d0 100644
> --- a/hw/vfio/igd.c
> +++ b/hw/vfio/igd.c
> @@ -262,7 +262,7 @@ static void vfio_pci_igd_lpc_bridge_class_init(ObjectClass *klass, void *data)
>   }
>   
>   static const TypeInfo vfio_pci_igd_lpc_bridge_info = {
> -    .name = "vfio-pci-igd-lpc-bridge",
> +    .name = TYPE_VFIO_PCI_IGD_LPC_BRIDGE,
>       .parent = TYPE_PCI_DEVICE,
>       .class_init = vfio_pci_igd_lpc_bridge_class_init,
>       .interfaces = (InterfaceInfo[]) {
> @@ -524,7 +524,7 @@ void vfio_probe_igd_bar4_quirk(VFIOPCIDevice *vdev, int nr)
>       lpc_bridge = pci_find_device(pci_device_root_bus(&vdev->pdev),
>                                    0, PCI_DEVFN(0x1f, 0));
>       if (lpc_bridge && !object_dynamic_cast(OBJECT(lpc_bridge),
> -                                           "vfio-pci-igd-lpc-bridge")) {
> +                                           TYPE_VFIO_PCI_IGD_LPC_BRIDGE)) {
>           error_report("IGD device %s cannot support legacy mode due to existing "
>                        "devices at address 1f.0", vdev->vbasedev.name);
>           return;


