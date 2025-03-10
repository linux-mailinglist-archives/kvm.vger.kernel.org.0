Return-Path: <kvm+bounces-40598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F494A58DE9
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30B0188D8D9
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8D72222A4;
	Mon, 10 Mar 2025 08:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ec92ZRaZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69635965
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594802; cv=none; b=bdfoqqBjd2laVNGgQwFN7HTEMQDXdPh1ZHQZ5eeXRssOQFywy6CxO6AuaLihLpfoHK1aSE1OUM9UMpeiLOlg2KXF/EVPQIWJfdTQsCh8Tbh3Em7fNhChBhuSIxEdkY77Y/7NSzy4Stev83QWruMkRyUXPYRZUdbjbZmIRawcYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594802; c=relaxed/simple;
	bh=1qCIX0TQ5VXGwGb6MIvIi3xBni/hWIDm52W5XN2ckVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGb06/xUqNHnIMPFvR74Ma4q+YFpZMbewDzTMQNaO+WSeLq84RDZSz0/gG+sui8VcOHokj5IDim5xfdkDrSjug9YahEZxwOOeP2j9rv9ex+NmEp6XGflvgqt7fl/iRVa/Ke+d2kMPPIi9vVbR7dY8kb9HgGBTZ84xC9dMNs4EGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ec92ZRaZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741594799;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N8dh/VhidLhRnAZYmemneE028i0H2G6UoHb9BsguyTc=;
	b=ec92ZRaZi1ObHosgvfCMLU9A0S3fx1N1DnUdspubrbeE3rlszKHdbpMh2X1g6RDfMqDzt3
	VWmC8Nzqd/In2rPn4eFMuAvYU3/7/2/4OIwxQ4pBOgJfjOfOX+wyEekxYxLDLdCBmeRvbd
	7W5mk1jAs7DKF3z2MM4Nly0vICu7j0M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486--TPRPUtwNZ2CO42miQ0gzQ-1; Mon, 10 Mar 2025 04:19:58 -0400
X-MC-Unique: -TPRPUtwNZ2CO42miQ0gzQ-1
X-Mimecast-MFC-AGG-ID: -TPRPUtwNZ2CO42miQ0gzQ_1741594797
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912539665cso2172630f8f.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741594797; x=1742199597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N8dh/VhidLhRnAZYmemneE028i0H2G6UoHb9BsguyTc=;
        b=UICr0PgtEg0q0rgE5E96U3Q35mtcAVN+p2PpBrGFfAlbcm/ziUYwhOEYj3jsywYG3V
         ttlYXGIf4xhKBsKbvTkk4hfTsE828aU96KMx4WrcY5sJSWmehVR20nRSuoMTsGNGS4iX
         3+ej9I5MHmx6cQppGFvy3pRHSOROZ/vgOzZ54y0lq92aooWsvkAoq7sn4ZeiQgL2VUrE
         KenPeH6RqjaTkj2HlhvhC/vJ5RxPoRn7d/u9hmi+Wc5EXCKlTVLEgV2Kg9RlHDwlNYex
         tE+iRs9h/L+hRH7fH1vIaUmGrOgAN6DNEPibQXYQ3iuu/c6JxM1vhDY2ddCFB1v762ct
         GshA==
X-Forwarded-Encrypted: i=1; AJvYcCUvzifiaA86jVNIZ5XOjWj+wRUQypRopI39Vv2/XUqXErFJgP75Fn2SygaUwN6VEJKNE4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ2x1QFx26UHroCRKZo6D+uUcO+XK71NuUot5m56Ds9K5K2NoF
	eEg9p8TVWIF4nOTsDcCXeE1lBI3HBuf6eaPQZsmCIZwo8EOvLLrlcfNDUkWI/i83P5ln+DEnvyE
	Yzmk5Jx+CVQd9CRAc53tuR8jPjhGcW4U7yVgNVNa2D9GsYK7WIQ==
X-Gm-Gg: ASbGncvBjhC2fN13uUrPKXM1cOBDTEvEV6moZP2cwlxLUPmkBPRjhDoBSCqC7f5mYBv
	xWpwMWv9ht2jw/s+VG/5STLYkcIW0tNbfvFHEkCNFry8BMhIyt82lbgSLn7/JsLauiNDxt+1rGL
	4++H+dz3TEzkz2G/GHA1KyFxL/Js1moEOf6RJ4/2ZdCbJjBMPGTDQMQejwQJdIz+FI2D4E7T+Ym
	1rVCm89sQrabKVNvhj8cUXNBhgR97UAVGtmzrLrsjp4B9EOJiJ8RySLGy7WlXgH+eM/Y40CgF/k
	sjgAPjKEO5MWAz+czIBZPO32wRuKE3//8x1g5bOaHvU5WQ+PQ2zBugZtpqQgSrU=
X-Received: by 2002:a05:6000:18a9:b0:391:bc8:564a with SMTP id ffacd0b85a97d-3913af2dcb5mr5699513f8f.22.1741594797255;
        Mon, 10 Mar 2025 01:19:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJQwUb1052QL6wDZkevtHZEP40DWReuAaQITFm7+tPcB4MO94B9hab5aIHRUEbMoZhyRFO3g==
X-Received: by 2002:a05:6000:18a9:b0:391:bc8:564a with SMTP id ffacd0b85a97d-3913af2dcb5mr5699488f8f.22.1741594796855;
        Mon, 10 Mar 2025 01:19:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd9470e2sm136236215e9.33.2025.03.10.01.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:19:55 -0700 (PDT)
Message-ID: <a7ccab3e-af5b-44d0-a7d0-bfc0e218d532@redhat.com>
Date: Mon, 10 Mar 2025 09:19:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 03/21] hw/vfio: Compile some common objects once
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
 <20250308230917.18907-4-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:08 AM, Philippe Mathieu-Daudé wrote:
> Some files don't rely on any target-specific knowledge
> and can be compiled once:
>
>  - helpers.c
>  - container-base.c
>  - migration.c (removing unnecessary "exec/ram_addr.h")
>  - migration-multifd.c
>  - cpr.c
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/vfio/migration.c |  1 -
>  hw/vfio/meson.build | 13 ++++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
> index 416643ddd69..fbff46cfc35 100644
> --- a/hw/vfio/migration.c
> +++ b/hw/vfio/migration.c
> @@ -27,7 +27,6 @@
>  #include "qapi/error.h"
>  #include "qapi/qapi-events-vfio.h"
>  #include "exec/ramlist.h"
> -#include "exec/ram_addr.h"
>  #include "pci.h"
>  #include "trace.h"
>  #include "hw/hw.h"
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 260d65febd6..8e376cfcbf8 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -1,12 +1,7 @@
>  vfio_ss = ss.source_set()
>  vfio_ss.add(files(
> -  'helpers.c',
>    'common.c',
> -  'container-base.c',
>    'container.c',
> -  'migration.c',
> -  'migration-multifd.c',
> -  'cpr.c',
>  ))
>  vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
>  vfio_ss.add(when: 'CONFIG_IOMMUFD', if_true: files(
> @@ -25,3 +20,11 @@ vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
>  vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
>  
>  specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
> +
> +system_ss.add(when: 'CONFIG_VFIO', if_true: files(
> +  'helpers.c',
> +  'container-base.c',
> +  'migration.c',
> +  'migration-multifd.c',
> +  'cpr.c',
> +))


