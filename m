Return-Path: <kvm+bounces-22680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4965C94151A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 17:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03C26284F19
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569D31A2C0B;
	Tue, 30 Jul 2024 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTehNgBB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5266B19E7D1
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722352045; cv=none; b=s7YQJFPhLXElmvvVU9/0hBL1wcFP+QCze1TGXUQ3j41WmTOVw1H7ndC1bb+FGR7tdtx/biBsjFhKUKEz0ERBmY4U2ubTYTnu34v8AqvTmegPf5/1qSedSV+IpfErWuLfwhdHzrGrwrh3k4K3SannAm//kqy6ET3kd1DQ6ZT7cbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722352045; c=relaxed/simple;
	bh=62K2RbLh0WJqBpT8WDkhyO03yHqYE4DcGWLklbA0N4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZy4h5Wt5TQZTKimYvmI5O26x22anekpz6UX53uDjax3oX3ioiLxQ2sE+Eb0fUVjLhjx0my2YYZZwF05RwJBQtWMWuKfy/D4j+NBLCfXhSQQbQty4aPJ7yhOSIpgmQmWwzY3ooPq4+/5Rk7s2tGJ5TowPwlYK/qYpwDys6i8VPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hTehNgBB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722352042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ke8GKRqB2B+6FqIK+oRdAuIevXRCY/7RxOajgnb0gF4=;
	b=hTehNgBB2kpxCl/dpbO22bgeiUXNRoONDnlXUCcxKs7oJvPEoUci+H0VVZikB+9SrqHx11
	LtKBzDKBDClUpq7LH98ME2W9FyR+80GClLBDxfkkyQD+EqFcJrBASWH1FaLjHBFBiz1lbh
	4ITY9Nv2EDxhqP3qk7ZCwimEUuPAikc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-oIfL0V5GO7ibpxSsl1HYGg-1; Tue, 30 Jul 2024 11:07:17 -0400
X-MC-Unique: oIfL0V5GO7ibpxSsl1HYGg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-36873a449dfso1610408f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722352036; x=1722956836;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ke8GKRqB2B+6FqIK+oRdAuIevXRCY/7RxOajgnb0gF4=;
        b=tBB3fKtvh7Mk/D/DPcS2aukKj3uUX/Spww9d14RedmERy10O6bTZGf42ZkkgXCbYpx
         bY/DMjKpas+0tUQGF8AJ8h0HifqjQQ5keUzBn9kS/SAGMC6685dLOxQy2+bms3p/iFVV
         hHTHNdpSM/6tvLYbiFlfCT1PBdJTtTSLQPA8zyMHwIBKnZD25y3iKBUEdgF5bMEh4O2s
         uBacAfoxpn0Im2HWmGjkaPhesgdaQA6t1+XSSs9+2xyaWYOMakGFaUpyLWAduS0TvFkm
         Bb1h4vuDPUE51LzfOLARwZu+ZH0jtZP+rJAh0a6Kt/yXxFbYOb6W55MIwsY/MZ4aWBj8
         Fwrg==
X-Forwarded-Encrypted: i=1; AJvYcCWT+L0+MEUD+bPPHP7xsuOslBMUd7Go+n2DmskxMZxgTY1PslDzMDHfj47a9dOjYZmX8KnLqNV46bb2cTt7vDYKOriS
X-Gm-Message-State: AOJu0Yzof6W4pwM0yLxhI//elXfNKMZUK8F95xeLfWfR4o6W2GfQkD4J
	BtFMaKRWPvWWk0nt6INypPPvJ6lsjap9od7vi6MzNgDxyordPKV+EENl7Zk8C5xjKBIqFd5ZKuD
	HuIvQNelXKaweTrSBYHHPSRCY1EpZdbUGxWqGS9iyk0O62HUsQA==
X-Received: by 2002:adf:e3d1:0:b0:35f:fd7:6102 with SMTP id ffacd0b85a97d-36b8c8edd66mr1308666f8f.35.1722352036514;
        Tue, 30 Jul 2024 08:07:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBOtx3KIyHkoXcHB3B3oYrSLn3CftG9WjtV40vTkKL7hv1TsvqurIpgwbpj+2j2dGgVUdBFg==
X-Received: by 2002:adf:e3d1:0:b0:35f:fd7:6102 with SMTP id ffacd0b85a97d-36b8c8edd66mr1308605f8f.35.1722352036026;
        Tue, 30 Jul 2024 08:07:16 -0700 (PDT)
Received: from [192.168.1.18] (lfbn-tou-1-3-122.w86-201.abo.wanadoo.fr. [86.201.10.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36861b54sm14789956f8f.95.2024.07.30.08.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 08:07:15 -0700 (PDT)
Message-ID: <3e82436c-9bc7-4dfa-a048-fc1de6793c72@redhat.com>
Date: Tue, 30 Jul 2024 17:07:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/18] qapi/common: Drop temporary 'prefix'
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com, andrew@codeconstruct.com.au,
 andrew@daynix.com, arei.gonglei@huawei.com, berrange@redhat.com,
 berto@igalia.com, borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
 den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
 farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
 idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
 jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com, kwolf@redhat.com,
 leetroy@gmail.com, marcandre.lureau@redhat.com, marcel.apfelbaum@gmail.com,
 michael.roth@amd.com, mst@redhat.com, mtosatti@redhat.com,
 nsg@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
 peter.maydell@linaro.org, peterx@redhat.com, philmd@linaro.org,
 pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
 stefanha@redhat.com, steven_lee@aspeedtech.com, thuth@redhat.com,
 vsementsov@yandex-team.ru, wangyanan55@huawei.com,
 yuri.benditovich@daynix.com, zhao1.liu@intel.com, qemu-block@nongnu.org,
 qemu-arm@nongnu.org, qemu-s390x@nongnu.org, kvm@vger.kernel.org
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-5-armbru@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20240730081032.1246748-5-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/30/24 10:10, Markus Armbruster wrote:
> Recent commit "qapi: Smarter camel_to_upper() to reduce need for
> 'prefix'" added a temporary 'prefix' to delay changing the generated
> code.
> 
> Revert it.  This improves OffAutoPCIBAR's generated enumeration
> constant prefix from OFF_AUTOPCIBAR_OFF to OFF_AUTO_PCIBAR_OFF.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   qapi/common.json |  1 -
>   hw/vfio/pci.c    | 10 +++++-----
>   2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/qapi/common.json b/qapi/common.json
> index 25726d3113..7558ce5430 100644
> --- a/qapi/common.json
> +++ b/qapi/common.json
> @@ -92,7 +92,6 @@
>   # Since: 2.12
>   ##
>   { 'enum': 'OffAutoPCIBAR',
> -  'prefix': 'OFF_AUTOPCIBAR',   # TODO drop
>     'data': [ 'off', 'auto', 'bar0', 'bar1', 'bar2', 'bar3', 'bar4', 'bar5' ] }
>   
>   ##
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index 2407720c35..0a99e55247 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -1452,7 +1452,7 @@ static bool vfio_pci_relocate_msix(VFIOPCIDevice *vdev, Error **errp)
>       int target_bar = -1;
>       size_t msix_sz;
>   
> -    if (!vdev->msix || vdev->msix_relo == OFF_AUTOPCIBAR_OFF) {
> +    if (!vdev->msix || vdev->msix_relo == OFF_AUTO_PCIBAR_OFF) {
>           return true;
>       }
>   
> @@ -1464,7 +1464,7 @@ static bool vfio_pci_relocate_msix(VFIOPCIDevice *vdev, Error **errp)
>       /* PCI BARs must be a power of 2 */
>       msix_sz = pow2ceil(msix_sz);
>   
> -    if (vdev->msix_relo == OFF_AUTOPCIBAR_AUTO) {
> +    if (vdev->msix_relo == OFF_AUTO_PCIBAR_AUTO) {
>           /*
>            * TODO: Lookup table for known devices.
>            *
> @@ -1479,7 +1479,7 @@ static bool vfio_pci_relocate_msix(VFIOPCIDevice *vdev, Error **errp)
>               return false;
>           }
>       } else {
> -        target_bar = (int)(vdev->msix_relo - OFF_AUTOPCIBAR_BAR0);
> +        target_bar = (int)(vdev->msix_relo - OFF_AUTO_PCIBAR_BAR0);
>       }
>   
>       /* I/O port BARs cannot host MSI-X structures */
> @@ -1624,7 +1624,7 @@ static bool vfio_msix_early_setup(VFIOPCIDevice *vdev, Error **errp)
>           } else if (vfio_pci_is(vdev, PCI_VENDOR_ID_BAIDU,
>                                  PCI_DEVICE_ID_KUNLUN_VF)) {
>               msix->pba_offset = 0xb400;
> -        } else if (vdev->msix_relo == OFF_AUTOPCIBAR_OFF) {
> +        } else if (vdev->msix_relo == OFF_AUTO_PCIBAR_OFF) {
>               error_setg(errp, "hardware reports invalid configuration, "
>                          "MSIX PBA outside of specified BAR");
>               g_free(msix);
> @@ -3403,7 +3403,7 @@ static Property vfio_pci_dev_properties[] = {
>                                      nv_gpudirect_clique,
>                                      qdev_prop_nv_gpudirect_clique, uint8_t),
>       DEFINE_PROP_OFF_AUTO_PCIBAR("x-msix-relocation", VFIOPCIDevice, msix_relo,
> -                                OFF_AUTOPCIBAR_OFF),
> +                                OFF_AUTO_PCIBAR_OFF),
>   #ifdef CONFIG_IOMMUFD
>       DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
>                        TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),


