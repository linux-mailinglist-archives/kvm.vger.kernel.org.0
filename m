Return-Path: <kvm+bounces-40608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C97A58E08
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5B09188D9E2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145FC22257D;
	Mon, 10 Mar 2025 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WbljNxSj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0622153D6
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594994; cv=none; b=RmsBgNPPNzdMieHrJVBJv4OCfZ78aKeq9vMSPZL12NrA7lkoIeNCnUcH1AHNlTi3/NbxGZ9XWoDZQHUxFwJFSSc4JWWkVsVC2rQsqM+S9n9r2ufyXFupx/LhoDVgj7mand6e1h9NoKdvvKS8LocFqGJQ0vCG/Q9OvCZI6qo8F4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594994; c=relaxed/simple;
	bh=jN6gquOD5S9QxqRbmvP4TRcu7XTN40hgbD5wOCO54Ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxKF5YRL+7OMSs2hnCL+VPamCduziaEwei5kr2F+G6GL2qAhYptub+e+iAYXl4u/tRInKfcYWsKJhwkx+l2oObX26U//oDv7HcSZmO5lqSTxC8Tnq7J2ybMuaw/e7XOaKXcmIt1kEb6DCkYoBmvNqvV16eN2gpoX11dduGVFeNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WbljNxSj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741594991;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m83jpOl/EWHljK2jRZk5Ena/wZkPmU1eHW5FSSTGYDw=;
	b=WbljNxSjUT8tx/YX5lwjkh+Y6D+nlaEa5qtJf3Orj3Xgu0qh0a9jvZHLJJnaLNviM1iYMi
	E6J/ILf1tNkPQxCDfUCa2m2WiDSgxXohMjsbtMxPSv2hk+XejfknM7Mj5wUxzDa+Esk2KN
	zXHGlguU2+PAczdn5cW1q/8ZeaMT5wk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-uFoROjKIOoaltY9bakBAjw-1; Mon, 10 Mar 2025 04:23:10 -0400
X-MC-Unique: uFoROjKIOoaltY9bakBAjw-1
X-Mimecast-MFC-AGG-ID: uFoROjKIOoaltY9bakBAjw_1741594989
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43bd92233acso31689935e9.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741594989; x=1742199789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m83jpOl/EWHljK2jRZk5Ena/wZkPmU1eHW5FSSTGYDw=;
        b=cAhNhumuG7NQiB+yeSNVrKw/zem2ens2UtXQc4pUrJ1oYmjGnSn0QK7QR5W+vlLoRd
         zfexwT5z6rBdYA2V7liFpNUJueJXJjtXSWe+g5qyL0/6YiZcaXAWGAnl89i6sMiNWJyj
         8cILyXUx3L9Stp6NOTcqoPCsh7Btgc7MyIdJ61IRL2ypAI8czJbvmM23LE1NIKZ/LcCB
         +Sl+QrpAJ/GgPnUtEQk8upCKJTdyW1iIA38XUf7REqzQvM/Z44+tLNcj7/ww0YW8FE5F
         Ggcat3IA1Gp5h6m7wchkBT17rgNEPt9WL1FZbkgXpNmGNbjhscuSdgQ6TdXIMb0PRPlK
         IX+g==
X-Forwarded-Encrypted: i=1; AJvYcCU5lJKyP4ON/tr6Xtl934JEFIrasAMkVA9VKTj6j1Nx2y7giJY8XcpZkE77AVK/O7tcakM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNBNwgFv5tfPeOIFlgqm+u4gZayClIXF04YShdud40aCH8FXiZ
	d4yZM3EQc3/+nK6Ay/Rpuef4LLB26Rz0INLbnqQxNTBjp4/WRg5P+dF/PXsTzVIKVehZcUR8x2G
	2n5wJbutcs6bT/TZoqUxr4L9VLEAXUkPTn/lH5ATtdQZrjnQE+A==
X-Gm-Gg: ASbGncvd2fHZo22awYUmeRWte58qmdf3c7LAxXF76vh9JrNYedMKz0y84rvV7tC0Mft
	hX7bpZv+1Wq+34aLE5OIneR80xUfem2pK82ApPpDLuvuJI9SXQUGRb9J6D6BtmGITovl23f3cfh
	A6z5G5tPFHYRIOo29AxEmYbMviwWbh1Br2BhuDl44lbxsXHZnEMnW4kyV3S72B36OElJlEO5Nuz
	zIZoHFpZTt9JtvCrpXD4PgwhuBIvXn/Kh8NauR9IQvd1UNPTMF6Nd+17uWVduOmJstyaKAVyLxs
	VuQ1S/Jcxcy8Z3/xVzU1dnw47cTFvEy/Zf9lHYrUpSbyf60sXh3JZAHl8Rx/XZk=
X-Received: by 2002:a05:600c:5103:b0:439:a0a3:a15 with SMTP id 5b1f17b1804b1-43c601cf53amr103539125e9.14.1741594988959;
        Mon, 10 Mar 2025 01:23:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPYuDPxYvwsEdUAyUty/LvN9lj+wxRwyT8RvxMe+vpY6KYM+aaGBrQ+ugbdV06I0XimUBZxQ==
X-Received: by 2002:a05:600c:5103:b0:439:a0a3:a15 with SMTP id 5b1f17b1804b1-43c601cf53amr103538705e9.14.1741594988461;
        Mon, 10 Mar 2025 01:23:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e3250sm14213927f8f.61.2025.03.10.01.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:23:07 -0700 (PDT)
Message-ID: <446a5657-9926-43f6-9592-adce2399e5a9@redhat.com>
Date: Mon, 10 Mar 2025 09:23:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 05/21] hw/vfio: Compile iommufd.c once
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
 <20250308230917.18907-6-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> Removing unused "exec/ram_addr.h" header allow to compile
> iommufd.c once for all targets.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/vfio/iommufd.c   | 1 -
>  hw/vfio/meson.build | 6 +++---
>  2 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
> index df61edffc08..42c8412bbf5 100644
> --- a/hw/vfio/iommufd.c
> +++ b/hw/vfio/iommufd.c
> @@ -25,7 +25,6 @@
>  #include "qemu/cutils.h"
>  #include "qemu/chardev_open.h"
>  #include "pci.h"
> -#include "exec/ram_addr.h"
>  
>  static int iommufd_cdev_map(const VFIOContainerBase *bcontainer, hwaddr iova,
>                              ram_addr_t size, void *vaddr, bool readonly)
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 784eae4b559..5c9ec7e8971 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -4,9 +4,6 @@ vfio_ss.add(files(
>    'container.c',
>  ))
>  vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
> -vfio_ss.add(when: 'CONFIG_IOMMUFD', if_true: files(
> -  'iommufd.c',
> -))
>  vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
>    'display.c',
>    'pci-quirks.c',
> @@ -28,3 +25,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>    'migration-multifd.c',
>    'cpr.c',
>  ))
> +system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
> +  'iommufd.c',
> +))


