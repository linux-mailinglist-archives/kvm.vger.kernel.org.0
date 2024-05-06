Return-Path: <kvm+bounces-16723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 258B28BCE3A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 14:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5FD91F22428
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB97533CC4;
	Mon,  6 May 2024 12:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILt0GtOA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4BD29A9
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714999311; cv=none; b=OlfIBiOt6OB2rnIwnuULoUd+0j27VlkEEBhHkveD6BqRvBueUYLpx1WfW73jPCcg/6WCPeHhXAjKErJI/Dhf5hPctPG8qOmPE84i2F6r2FYkK5E62ocBNmIyAOUtNMX425byMKoSb7QcpFV3rkfHK2qc52NeYU0Ppai6gkwpkmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714999311; c=relaxed/simple;
	bh=O3AwQVF1ogPa3hcLIUrJQe0Afoj5x2ELN6a12YMwmEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rHcmRp432120b6iDgyyu7CuAYsGEwomWmiBwlf4a/KSGhFJHVBGxKUQXjRxwzvvgeMVlYp7PZZfOIB3TIprgrsyvndROBY8IXoMFSEDThcQkhZv81YD+HfaMOrVZh6FcY0l4KPGzqkoUjY4Y1uVS4b6WTjp40hJaVdBItICXLAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILt0GtOA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714999308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bhNc3Aa7e3LhDxiHG5xCZbBmsJSMShBeUonH/I6KaCE=;
	b=ILt0GtOA+wIARS31hXkdM70ZI51gy76PBwqD35sxHYcV6HucPcqdlhsqRR26/bkX6KBhbS
	YYt/dpr3vV2rILNhFiWopZ5FJVT5gcl+ZcyyGVTEFPPGV0l42PKvd3kRvPJgDiE5H3cbti
	1i0oVs6fVKp6QsaUerL3baeqmhGBXqY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-IfSGQsMwMwOGoPDTmQGN-g-1; Mon, 06 May 2024 08:41:46 -0400
X-MC-Unique: IfSGQsMwMwOGoPDTmQGN-g-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34d8ccf34f8so1526679f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 05:41:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714999306; x=1715604106;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhNc3Aa7e3LhDxiHG5xCZbBmsJSMShBeUonH/I6KaCE=;
        b=HRHbP8MP7o6tgLR2MG2Cebq2KZH4NRIuCsGFVU7t3Nk2htXaiW+8nZ7fdXp724KV4J
         Z7HQ1r1Z/5/Nf8/gtemjWfdKk1XvckIHD+m1SeC4lxR8crETh2lZNi+EkKHiCUqtudcq
         A8vuMQByg1gcmtNcQHEy6nXTwhyBODXQqe7ZnEEfC0V+V8R9kN/X2w3iF2VEn6uqhRO7
         ePvsyLYDb//Pgc+sHEaU/3QgNrf3Zma3TxclWRZwIXv3+uIdmH1qlxt4TKn8HO/XTfoC
         jnV4IjDA0D1bA2D2c+rT+8cRwCoWeXAdpGo98R+dWeK5QgLKfBtHAj+T1ulYL+KxyJJU
         h1dw==
X-Forwarded-Encrypted: i=1; AJvYcCUBe2kyckKWOoTFTlS/TmWH7UoXjUaB+8mSARbwt2L8CT1b9Bycjr3yvb/GUAWhF5/uOPdWhJ+VAXyXB5DrJozWB21Z
X-Gm-Message-State: AOJu0YwET33oUq+O+/lHXleaTz3DZVchnb9atyxK/7OF8QmWgHfacC++
	yF2Ijd155Jx2tIQlrXdCGtoa4nOWPHy4L+c4aJSPIUtTeoBHnKGh1TBMW551aCTAB0UjhIYdPvV
	cRIomq0N/cST/L9gpjM7IMBeHXAuWExATJo5tt4StVgE2IZQCLA==
X-Received: by 2002:a05:6000:dd1:b0:34d:a35c:cf89 with SMTP id dw17-20020a0560000dd100b0034da35ccf89mr6676021wrb.18.1714999305834;
        Mon, 06 May 2024 05:41:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEFbKlSmtS/JQLzy6y8f2QcGvEqjUMPw2T+t1DxoRrki46Q4CrXPumFszJ479sgGJGcJvXTQ==
X-Received: by 2002:a05:6000:dd1:b0:34d:a35c:cf89 with SMTP id dw17-20020a0560000dd100b0034da35ccf89mr6676000wrb.18.1714999305305;
        Mon, 06 May 2024 05:41:45 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0? ([2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0])
        by smtp.gmail.com with ESMTPSA id h18-20020a056000001200b0034c78001f6asm10589938wrx.109.2024.05.06.05.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 05:41:44 -0700 (PDT)
Message-ID: <76a741bc-a7b8-4c8a-bc7f-7648bc421cb9@redhat.com>
Date: Mon, 6 May 2024 14:41:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] vfio/pci: migration: Skip config space check for
 Vendor Specific Information in VSC during restore/load
To: Vinayak Kale <vkale@nvidia.com>, qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com, mst@redhat.com, marcel.apfelbaum@gmail.com,
 avihaih@nvidia.com, acurrid@nvidia.com, cjia@nvidia.com, zhiw@nvidia.com,
 targupta@nvidia.com, kvm@vger.kernel.org
References: <20240503145142.2806030-1-vkale@nvidia.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20240503145142.2806030-1-vkale@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/3/24 16:51, Vinayak Kale wrote:
> In case of migration, during restore operation, qemu checks config space of the
> pci device with the config space in the migration stream captured during save
> operation. In case of config space data mismatch, restore operation is failed.
> 
> config space check is done in function get_pci_config_device(). By default VSC
> (vendor-specific-capability) in config space is checked.
> 
> Due to qemu's config space check for VSC, live migration is broken across NVIDIA
> vGPU devices in situation where source and destination host driver is different.
> In this situation, Vendor Specific Information in VSC varies on the destination
> to ensure vGPU feature capabilities exposed to the guest driver are compatible
> with destination host.
> 
> If a vfio-pci device is migration capable and vfio-pci vendor driver is OK with
> volatile Vendor Specific Info in VSC then qemu should exempt config space check
> for Vendor Specific Info. It is vendor driver's responsibility to ensure that
> VSC is consistent across migration. Here consistency could mean that VSC format
> should be same on source and destination, however actual Vendor Specific Info
> may not be byte-to-byte identical.
> 
> This patch skips the check for Vendor Specific Information in VSC for VFIO-PCI
> device by clearing pdev->cmask[] offsets. Config space check is still enforced
> for 3 byte VSC header. If cmask[] is not set for an offset, then qemu skips
> config space check for that offset.
> 
> VSC check is skipped for machine types >= 9.1. The check would be enforced on
> older machine types (<= 9.0).
> 
> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cédric Le Goater <clg@redhat.com>

LGTM,

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
> Version History
> v3->v4:
>      - VSC check is skipped for machine types >= 9.1. The check would be enforced
>        on older machine types (<= 9.0).
> v2->v3:
>      - Config space check skipped only for Vendor Specific Info in VSC, check is
>        still enforced for 3 byte VSC header.
>      - Updated commit description with live migration failure scenario.
> v1->v2:
>      - Limited scope of change to vfio-pci devices instead of all pci devices.
> 
>   hw/core/machine.c |  1 +
>   hw/vfio/pci.c     | 26 ++++++++++++++++++++++++++
>   hw/vfio/pci.h     |  1 +
>   3 files changed, 28 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 4ff60911e7..fc3eb5115f 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -35,6 +35,7 @@
>   
>   GlobalProperty hw_compat_9_0[] = {
>       {"arm-cpu", "backcompat-cntfrq", "true" },
> +    {"vfio-pci", "skip-vsc-check", "false" },
>   };
>   const size_t hw_compat_9_0_len = G_N_ELEMENTS(hw_compat_9_0);
>   
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index 64780d1b79..2ece9407cc 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2134,6 +2134,28 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
>       }
>   }
>   
> +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
> +                                        uint8_t size, Error **errp)
> +{
> +    PCIDevice *pdev = &vdev->pdev;
> +
> +    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
> +    if (pos < 0) {
> +        return pos;
> +    }
> +
> +    /*
> +     * Exempt config space check for Vendor Specific Information during
> +     * restore/load.
> +     * Config space check is still enforced for 3 byte VSC header.
> +     */
> +    if (vdev->skip_vsc_check && size > 3) {
> +        memset(pdev->cmask + pos + 3, 0, size - 3);
> +    }
> +
> +    return pos;
> +}
> +
>   static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>   {
>       ERRP_GUARD();
> @@ -2202,6 +2224,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>           vfio_check_af_flr(vdev, pos);
>           ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>           break;
> +    case PCI_CAP_ID_VNDR:
> +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
> +        break;
>       default:
>           ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>           break;
> @@ -3390,6 +3415,7 @@ static Property vfio_pci_dev_properties[] = {
>       DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
>                        TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
>   #endif
> +    DEFINE_PROP_BOOL("skip-vsc-check", VFIOPCIDevice, skip_vsc_check, true),
>       DEFINE_PROP_END_OF_LIST(),
>   };
>   
> diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
> index 6e64a2654e..92cd62d115 100644
> --- a/hw/vfio/pci.h
> +++ b/hw/vfio/pci.h
> @@ -177,6 +177,7 @@ struct VFIOPCIDevice {
>       OnOffAuto ramfb_migrate;
>       bool defer_kvm_irq_routing;
>       bool clear_parent_atomics_on_exit;
> +    bool skip_vsc_check;
>       VFIODisplay *dpy;
>       Notifier irqchip_change_notifier;
>   };


