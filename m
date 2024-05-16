Return-Path: <kvm+bounces-17542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A218D8C7A58
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 18:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59DBE2818B3
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 16:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81FA15099D;
	Thu, 16 May 2024 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Du/DW3FM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A4514D6FA
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715876961; cv=none; b=CPMRDUyJ55gDVt9OEtcF3TDmAczFkUlt2HyXEeUDu3W8uGVeleUOF9BSgBXC60+b1ztFZyT9bACP+rBRCjPAuHYWxscrV6+XQkq6PwRNLMVTXI+epjyj5Pkj6eFwNBsQuyVMCYGXXbkE+Lg4KGdc+MMwN/g3awF0BHUfarFJGkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715876961; c=relaxed/simple;
	bh=AkaGh5Z7+vXwmPwgd+w3K474/wVP6Nf3EHvCkDUAT64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHE7DuUJ8uCJAM9uHHJjbSN+2z5r6/qcFx7gT51T8htCzvXUR5hwbPEHB2HYqEyMs3LremyV/tLUoqD8+EMjCJvpYbY/pzkQ26z9X156U7nxnGjq0F6EEnbIDm4UxTl18amBmJnFHrQ3UdICOnOvEJXLMnQma5Nt84amgn32LLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Du/DW3FM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715876958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vhi2RJebXZNQWiSz2qczyw3x7Kdto7QGyk0fWFzRDpI=;
	b=Du/DW3FM1EW6qSxrRSAVWXAlHfRPh1pi66fEVbo88Lts28SANc5HHQj67i3L3ztMYl6KEF
	WB6HvlqKlACWuWNxGNKR3lTiXdRlWK8qIclFnrhD4idwd7MjeVOktpVCaf6NxPPmFjJRAA
	HBTYQUVLXfN6X0Yi2nLVwecm5qZ0lKk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-mEB4cd2mNL2T1LwghuiQlQ-1; Thu, 16 May 2024 12:29:15 -0400
X-MC-Unique: mEB4cd2mNL2T1LwghuiQlQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-792c707ca4aso617852785a.1
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 09:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715876955; x=1716481755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vhi2RJebXZNQWiSz2qczyw3x7Kdto7QGyk0fWFzRDpI=;
        b=vjq5CofwpHtM9JOK0Y6cfW0p5PtCTGqzDb8eNhNI/pPiO9kkV1s8/Iacg5v6PrSvQO
         PcwQwKm5dgHDe0QiVp5WyY0fr4rCYwuqpCrmmXrfI+lN1fNaGEnzebG+iSj2pVSG3ZU9
         HfdO+gCzbhOdUQzD6ocR+AW15g1erJ2vEg+VJ0bbB6/77y5GhLBnDKUMMX7cc7yBLn2G
         vn1ysnBdAEPG4DmLqH0FvItblfWIMQ3bt3U0EfIHaHFl0Ubv94htalxav8MQzAgBnF/A
         4Yp/QugODoGbqE/x+DxjKkdX+uy8O5FYRzrJpOiIu4PVarJzdprMom43zgEcXfyRJBTr
         IBJw==
X-Forwarded-Encrypted: i=1; AJvYcCUY2sPA/Hk5ABs2LIfB7gM2nepY4tyg8iLK9aZnwkAIfYCTo8jrxzXXHvufoZi5hWHQXhZk8SEIEp3SutJWJoj6bhYS
X-Gm-Message-State: AOJu0YxCIBlWk9lX4UDBR8XjOxv7+gfXE7p3GOlQRmwKM2fFK+o6n7Ci
	9dyXYnp479vnjTUUm/l+ddIOznA8eye9BqPseK8SZO12og39rzztw20U5jyknqw94Wi8tiELlHM
	3L8VzKQxD2xYh22gUpgfJwg7Uf/KW6U2hrbW3DqDlCbeOZxUZ+g==
X-Received: by 2002:a05:620a:4494:b0:790:a8ca:c69d with SMTP id af79cd13be357-792c75ab7fcmr2526636385a.33.1715876954893;
        Thu, 16 May 2024 09:29:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxxbFo30AOLf/XW3onhYPuk8WsaWNhKlGTyPoHxcar8qPt81UX8pYbNbNzK//5+vE1eH0aEA==
X-Received: by 2002:a05:620a:4494:b0:790:a8ca:c69d with SMTP id af79cd13be357-792c75ab7fcmr2526633285a.33.1715876954547;
        Thu, 16 May 2024 09:29:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792e564e4dbsm407930385a.82.2024.05.16.09.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 09:29:14 -0700 (PDT)
Message-ID: <97c8641e-8839-4711-947c-692a62af93f3@redhat.com>
Date: Thu, 16 May 2024 18:29:11 +0200
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



Applied to vfio-next.

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


