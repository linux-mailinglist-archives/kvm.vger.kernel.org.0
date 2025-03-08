Return-Path: <kvm+bounces-40482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A406A57C7A
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A8677A5BC7
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E2C1DE4E7;
	Sat,  8 Mar 2025 17:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wuyd7gJY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F493382
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741455946; cv=none; b=nfQp8GawMVKJYpIxJMd5BbeOrk7Bl+9wZIVZ1tU9cPfj/tzddEzdmQRYUrMWC7Cleg46j/c5C/CWtEcOduCs1SAF8sE9jmFed9tzTLpqyY3Uh6hrAPjdy8fxQ6oQiHYODb6vUC/LLwnEkcCZadoaguVGkYvxeqlUilwAva8YnG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741455946; c=relaxed/simple;
	bh=S2m0kT8om8f0aBnmOFK5HAj13PJfPvzKd5oNzIX+AVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rAwrAPEQZ8U108qC/6xRxcb0xyXJmaKaINOeulIgLd8J96SeLotlOnNQcpYIOjZK7DAacwHNBh6IwLvf1ABO+gFspixdGlnCHsQynxe5D43gYv2d6Sahoq7qS2SUEzvBvi3ySGdi53PN0l9mvjNAT8BPNmvbiSciHw4o4AJM03E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wuyd7gJY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741455943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OiSEtxsMXim8Bv5CT+c99VIk1OLmzMKlbF+t7ML2M4Q=;
	b=Wuyd7gJYRS3DVQe0bXNJbIFYGJJ3ey+Om8/R9vjVIJe+N4LGI7UHL5xx3Qcdyi/VdRyL/h
	5dQpmpjyo4yvBpjAO6MPax4NAVMJ/XO7DmayuXXAgNBVx7BCCTJHXq9oSJ9Z5RhR0yzfbl
	TjQVVM9wIAO+j5cTB/5n5AZTbh5mzz8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-lbL2tPGWOxe5yyAE3vDisQ-1; Sat, 08 Mar 2025 12:45:42 -0500
X-MC-Unique: lbL2tPGWOxe5yyAE3vDisQ-1
X-Mimecast-MFC-AGG-ID: lbL2tPGWOxe5yyAE3vDisQ_1741455941
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43bcb061704so11806575e9.0
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:45:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741455941; x=1742060741;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiSEtxsMXim8Bv5CT+c99VIk1OLmzMKlbF+t7ML2M4Q=;
        b=XsPI5/JAsPuCX+Tkl9ieDpV3epWcW+oGocW+IHdQL/yhtEinQ5xpBbVG//VlSKg9dH
         kIYxpWC/c+l2uqScxwEQRCSNFOe7XjbpuOiil3xxGD42WLRMEWAQ4DhDexYyIgZkoAdh
         0j+FCYOIfDwP+W11UMgUStGJ0dvrDiKAyfL83ZtcrvnzqZLMF+9ucki+2RvFP59PF4Lv
         UVBFHmA9Gf2ARs9R/1sKDoeW93BFef0IHglhPJc8efmv+xyU5nxCN+/VwMjYV2w5gHba
         3mIpsEVvS0nQRdM/U5pOmVhC2EPg8/1qZorp6O3+j+F3IOw9IXwJLeflIuR3OdMRx9B0
         J0Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWM14AAcV+jGVZuO5erXYBgBPCBwPQJntCPz2j87CThLAa8WUKPja5AkOO9ojNYIEx8B2w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv16V5tB9t4OCDJ5QdxM8SHW1a6xAL4dqgToxFRJP+d9XQJpB+
	brhRPK2EjSxP2WnU/afbQM7ftHkbexTW4qCVuawImyooUuhRI1ZxkrbW7Wt71nrCJAyjHvtZQeE
	ZctbrqjFui15GbdIflNrQorG+fFCozn+VgcbrMes/gGWx7Kvniw==
X-Gm-Gg: ASbGncuYDvqlNNxnoVodfSXXJfEYmgNLD843T0usqHyuEINy3XL7Q3vCHPGPk0HEdqT
	ZmRr+XVpaM/z0EMvWgTfWSEdmm+hXXTFwGhDjqL0CdiS5D+RMjMf5tV7PNAX5S3SZwxWzZoLbft
	g5z+2cZLUeWJpAQyvMMWqdMqdGRTlO2CRrV0rb0Zai6r90b5aeUtOVBo9J/9MtbEnOwyvh0RPBg
	A6dSLBFBtw5BCKJh06vUZIxC35Q2i1anJxhFEJrPFkhhdmvwkBjOG7FuCJW3zN5Nb78wTT0kOZW
	yLXgAhh+yfxdvl5ohTRSwGsCgZBGk/HgVBThtIcAcBtb1xLpt26amw==
X-Received: by 2002:a05:600c:1c28:b0:43b:cd0a:970f with SMTP id 5b1f17b1804b1-43c5a5e9848mr45574755e9.3.1741455940968;
        Sat, 08 Mar 2025 09:45:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkbGyOJXk9qQT5agdoLRjf2IRXYK3n/XuLHUU+2F/UHAEJfpWT7nZRVhoi0OVhBCVGc0aDBQ==
X-Received: by 2002:a05:600c:1c28:b0:43b:cd0a:970f with SMTP id 5b1f17b1804b1-43c5a5e9848mr45574495e9.3.1741455940549;
        Sat, 08 Mar 2025 09:45:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c836sm119300235e9.37.2025.03.08.09.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:45:40 -0800 (PST)
Message-ID: <a887ae47-8b4b-48dd-b556-bbc1b601afdb@redhat.com>
Date: Sat, 8 Mar 2025 18:45:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/14] hw/vfio: Compile iommufd.c once
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
 <20250307180337.14811-6-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> Removing unused "exec/ram_addr.h" header allow to compile
> iommufd.c once for all targets.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/iommufd.c   | 1 -
>   hw/vfio/meson.build | 6 +++---
>   2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
> index df61edffc08..42c8412bbf5 100644
> --- a/hw/vfio/iommufd.c
> +++ b/hw/vfio/iommufd.c
> @@ -25,7 +25,6 @@
>   #include "qemu/cutils.h"
>   #include "qemu/chardev_open.h"
>   #include "pci.h"
> -#include "exec/ram_addr.h"
>   
>   static int iommufd_cdev_map(const VFIOContainerBase *bcontainer, hwaddr iova,
>                               ram_addr_t size, void *vaddr, bool readonly)
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 2972c6ff8de..fea6dbe88cd 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -4,9 +4,6 @@ vfio_ss.add(files(
>     'container.c',
>   ))
>   vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
> -vfio_ss.add(when: 'CONFIG_IOMMUFD', if_true: files(
> -  'iommufd.c',
> -))
>   vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
>     'display.c',
>     'pci-quirks.c',
> @@ -28,3 +25,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>     'migration-multifd.c',
>     'cpr.c',
>   ))
> +system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
> +  'iommufd.c',
> +))


