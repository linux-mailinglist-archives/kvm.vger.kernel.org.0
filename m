Return-Path: <kvm+bounces-40614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF990A59054
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 10:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BE0816B516
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A3D2253FF;
	Mon, 10 Mar 2025 09:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BoL2AzL8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A6421D585
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 09:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600471; cv=none; b=L9V6cQvqnDYoI3dJcMQYMVs4nmLl9Lyw6ZwlGz7rWfnnq9azKv8IpNUYoEjVv+0avbxUf0be3x5h5C6XliFmEqj4PIMNVO5q/1yKaFNF5IyiYOTzT2w4EndfIFewJSad2YxMptLSY7lQf0Xqq5IBVosnun4bQxIOc/x0CpfCLl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600471; c=relaxed/simple;
	bh=jbooJO87sRfjznSWL20YEh2eUQPri+yMDalb+BJ2D8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUPiB1cnpWizS1NqE3QuWB75lPEIYntUlRRAJNwpIXfJFkSozRtcUXmIeKo1lhIDOZa77rRCIoxs08Tmz2ZNhKjCqHJZWSNd3EvLDNOlsVBihgk6Z5vxVSxRsV44SuLhAZ9gA8uILuQV7ff+W+ikjAl+xl1pLFKRkCRiBnytwlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BoL2AzL8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741600469;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=knUqcaUFd6QoC5rFeKVCnBaBdtVopmXb8aUPjfInEHo=;
	b=BoL2AzL8cMctzD5ZtCSLi4ZIwpAN1eXRoqd85vSW7jngylA/5Njil4Rs/BcUmiKMKPWxZL
	tbAoNq7fJDt2spi5sjLH+Nm1P8o8+dLTwLUCsVAtExiH4vB3eZara+cX/h/WbaYxolMY3m
	KcXynJuLmRx0jcxXjfQB3lua2wsoxpk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-ohqGUodxO4-KI8OUnSHl5Q-1; Mon, 10 Mar 2025 05:54:27 -0400
X-MC-Unique: ohqGUodxO4-KI8OUnSHl5Q-1
X-Mimecast-MFC-AGG-ID: ohqGUodxO4-KI8OUnSHl5Q_1741600466
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so6728505e9.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 02:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741600466; x=1742205266;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=knUqcaUFd6QoC5rFeKVCnBaBdtVopmXb8aUPjfInEHo=;
        b=PTZ637MP274sMl7RH6n8hRMKZSnMOtFlP33quv59Ph2aOi+Y54cvzqw6bhedGRcA9g
         ETPy8u7f+P6nQljtKKs6lvHDh8yK6apaqdO58ZktuUDZhm0tXrUdc+lU0dIgPOhpe7wl
         svEDx80lE44ipBoA+JpmXURVEC9dGty5WaOD8MyhNQZraW3wcoaaVt7SlVRsaWZ33z3x
         IronjdlJq0LvTbxdUfenVuAUmZdGYSNTrK5E61PXRaUvh+/MeXOpANdIWNiMtvzJOES/
         //OgGFQZq4Zf1GZtWxbYmcJ1KSVrirMhANSe1QRGxNFKLj+Uiu/S2/ENm26Ib46SQuJE
         cHJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+ZNPjYS71FRp33tAy2RvBOwJF/bmmkFJBjD1MpqKj3vGLCe7il7pf+WeQAn7Jl0OMucA=@vger.kernel.org
X-Gm-Message-State: AOJu0YytN3vzin02HWbfLo8QGF5xgsVd97sGsOSa9ERO3n53ATTOUK44
	J//U99tzmRXYw9YCPxAu5xAlTv85xeZGds9x3fd307f3HmF8EouFYHEdNhFU4MWeEwTsWL7Q8Ok
	Wb+zx9fb4d00Gkr281pW/zocRjiEKQJsLI2BL8UA99Igjd9YY9w==
X-Gm-Gg: ASbGncshcrG01bHcXFe7+BdYBZPelDXlGAvMi0IAcJ978ECKa+pGhyA3PhvdWCm8RVO
	5bN1hqO7t4qLLTTQTiDb5Fkx68VD0h1MFgkG0RGUIoYIvYdYN5EJ3Fmej/ZzTd5CuiSIGG091Ym
	IFRpO7IiAslluWlFubeeKowstRw3Zp6ksDntzJZCkoFmvr46aKaoyVGtPvcFh9DMuW6m5F2IrJZ
	slm3QM8uofD/zO7LHSdUlcS35G1pkgK7++GBp2q5mf2EfyCRjipV5nhSA5GjxIhKbBZAnToAeUb
	mcE4muCBuWDVkPzmpapXycW1AXptzIDF3zIoy2PboNzKe8Dx7ZboV43Chu62fv0=
X-Received: by 2002:a05:600c:3baa:b0:43c:e7a7:aea0 with SMTP id 5b1f17b1804b1-43ce7a7b0a6mr31777985e9.26.1741600466347;
        Mon, 10 Mar 2025 02:54:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeOhaEVjxlboWMIMPA3Ze452+5QA5jZVNgwyGxbj5odwB+nFwSMjdsqE16kkqGB+0ELecQzQ==
X-Received: by 2002:a05:600c:3baa:b0:43c:e7a7:aea0 with SMTP id 5b1f17b1804b1-43ce7a7b0a6mr31777715e9.26.1741600465895;
        Mon, 10 Mar 2025 02:54:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb7ae4sm13985560f8f.5.2025.03.10.02.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 02:54:24 -0700 (PDT)
Message-ID: <4b864eac-04e3-4d03-a3a0-ee75f9072963@redhat.com>
Date: Mon, 10 Mar 2025 10:54:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 11/21] hw/vfio/igd: Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE
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
 <20250308230917.18907-12-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> Define TYPE_VFIO_PCI_IGD_LPC_BRIDGE once to help
> following where the QOM type is used in the code.
> We'll use it once more in the next commit.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/vfio/pci-quirks.h | 2 ++
>  hw/vfio/igd.c        | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/hw/vfio/pci-quirks.h b/hw/vfio/pci-quirks.h
> index d1532e379b1..fdaa81f00aa 100644
> --- a/hw/vfio/pci-quirks.h
> +++ b/hw/vfio/pci-quirks.h
> @@ -69,4 +69,6 @@ typedef struct VFIOConfigMirrorQuirk {
>  
>  extern const MemoryRegionOps vfio_generic_mirror_quirk;
>  
> +#define TYPE_VFIO_PCI_IGD_LPC_BRIDGE "vfio-pci-igd-lpc-bridge"
> +
>  #endif /* HW_VFIO_VFIO_PCI_QUIRKS_H */
> diff --git a/hw/vfio/igd.c b/hw/vfio/igd.c
> index b1a237edd66..1fd3c4ef1d0 100644
> --- a/hw/vfio/igd.c
> +++ b/hw/vfio/igd.c
> @@ -262,7 +262,7 @@ static void vfio_pci_igd_lpc_bridge_class_init(ObjectClass *klass, void *data)
>  }
>  
>  static const TypeInfo vfio_pci_igd_lpc_bridge_info = {
> -    .name = "vfio-pci-igd-lpc-bridge",
> +    .name = TYPE_VFIO_PCI_IGD_LPC_BRIDGE,
>      .parent = TYPE_PCI_DEVICE,
>      .class_init = vfio_pci_igd_lpc_bridge_class_init,
>      .interfaces = (InterfaceInfo[]) {
> @@ -524,7 +524,7 @@ void vfio_probe_igd_bar4_quirk(VFIOPCIDevice *vdev, int nr)
>      lpc_bridge = pci_find_device(pci_device_root_bus(&vdev->pdev),
>                                   0, PCI_DEVFN(0x1f, 0));
>      if (lpc_bridge && !object_dynamic_cast(OBJECT(lpc_bridge),
> -                                           "vfio-pci-igd-lpc-bridge")) {
> +                                           TYPE_VFIO_PCI_IGD_LPC_BRIDGE)) {
>          error_report("IGD device %s cannot support legacy mode due to existing "
>                       "devices at address 1f.0", vdev->vbasedev.name);
>          return;


