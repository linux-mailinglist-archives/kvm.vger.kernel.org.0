Return-Path: <kvm+bounces-40605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE434A58DF0
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002203ACCFB
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8556C223711;
	Mon, 10 Mar 2025 08:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="byGpox+d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A8513C690
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594839; cv=none; b=J69VOFVN2sIetaio6uCwhNrFDvudzFg079UDpT+o4AZGpjoQ67K/J89MkOnMCYjZdX97SDz3YU4u3fJ374hh8qqqGAjUp6JcRmS6tvyJeqmnlcy7Gymg3cXxjqSwj19Iv7NEMLUdqmJZARMNiCi+vkzglzJOV+nBg+h4O0t1NMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594839; c=relaxed/simple;
	bh=hSuip1P5EcWNJSJSVFT1tdSSAp8yABjwkuJFHuNrHB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB4xQ40PtH7JoOQllZbNaJ4V5AfL0HJzpD39+0TOPaiGnMbwaUQKWeH3R/5YyNCWCjEjMKjBJs5QUI5WS3N3qb9dXATCKidn3ni1q40E5FJzzkeLpstctkZSseyPU8OxrmebFknjOGItNYBgAiXU2Nb8IWFhYSknQ//oY5dcbhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=byGpox+d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741594836;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UCM9dXn15rLwLcvlKZl6PXYwnCCp9W+9SEavEczkTNc=;
	b=byGpox+dHcGKOrJazYOb1d3MsJBYhqfHiSei1KuKRQqEGaL8bkKaBwTIC/oIvSLTxz3e7j
	j0eBz5rcbp83zncH8ito+4C0QuwituHTRJM7jy+x3EsoEg1y6DiXiB0+qRY2rSlDMUaS4j
	3yZo5T++8LnNgdxbDmNCBQIs8gX+r/w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-dgkpyVDDNQymM7ICWbcrEQ-1; Mon, 10 Mar 2025 04:20:35 -0400
X-MC-Unique: dgkpyVDDNQymM7ICWbcrEQ-1
X-Mimecast-MFC-AGG-ID: dgkpyVDDNQymM7ICWbcrEQ_1741594834
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cf446681cso3698485e9.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741594834; x=1742199634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCM9dXn15rLwLcvlKZl6PXYwnCCp9W+9SEavEczkTNc=;
        b=BYaP0gFHuB93xS9N0zFw3CstO/kYCyViqYaU5ywznUVbwkGDDI70gHSr4IUlMlqbhi
         jjogHajfof7mQX9SPzkYWrL4HWCnsFojVR3jskAwZ+PShv/KE1zq4ypqPSDEypHyeI4F
         IRxJX7C42dV9gK5m4slbenmxeyi/r4umR5YuMPTvMfpPbxEduZi+5igGySx1Maxf3f8L
         W5MneEuQgoGJGBzRsLbgp+EAkdbrQRX5/49DCOWXHH+dpIAGpk9ftTwiAt8bYoHMJcDa
         7i4iTRYKHMNG52g+JS9u+4NWmb7AxExxaj7Mn/vYItUsoJvzwddMyqp7D2UfIp81AZNb
         +ZXA==
X-Forwarded-Encrypted: i=1; AJvYcCViGHlSCR/xlTC70KSwhY3dxI/Fy9FbchBYaYcrEOvl84Xu/nQCTdMnXUe4uw7MB+5TsWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzOlBTzWwhdY64DqiiqDPPKqMQZySwU39E/FkU8MqDZFNj/dDd
	5b4qUWzqSrbk3TQVsKZ3VK2FtvbXIuotC4tZRAryMjUHIcuDjP58QcWv4hAeQ434tSBO/5Ir6Sv
	gjROPadzKVhzx0kKIeHsl90qI2vgvtdhZFW26RANcM6J1fYmpXQ==
X-Gm-Gg: ASbGncubjamanFLw6TZ2i0PaC4XorlFW7LAgAysyJc3QFyuZi7A68vtShWVhc2HolOa
	lusfDdsjVLENW6SRPUTcIyHdHzCmLy123I1jOJ5WA0IFg1vERiTqoGAsJarlmZmkT9z7ZnbiFAE
	h8JOp5/M0E4FayDncDo+6RIsIapY6qCK9E2YU9AZBsXelkrFtYOaJuY7U6GMY5PTAVdCyrSZHzJ
	sHdI4QgqJjEjPUY44UopD7esl9Sf4nzWqy1wpyjc7BufrLTtFe+2lyCPOA2rK2vJiDEiXilk+FE
	PUt1Xx1BotqK3/5pvmUKQQCDLQHXxS4qHs0ASDo3a+bRbu4nPj+D7aPSZZ2MbZ8=
X-Received: by 2002:a05:600c:1c9d:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43c601d19cbmr82007935e9.30.1741594834150;
        Mon, 10 Mar 2025 01:20:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWoK4EAIS0nSnutdbr8yrKOmHxyHj64VreYaZSyts7twzU5fEMveCdB0GYj6APXBpf4tzW2g==
X-Received: by 2002:a05:600c:1c9d:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43c601d19cbmr82007575e9.30.1741594833763;
        Mon, 10 Mar 2025 01:20:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cfac24345sm17644355e9.22.2025.03.10.01.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:20:32 -0700 (PDT)
Message-ID: <1af5a147-f5ff-48c1-a2d7-ee4d98c12da4@redhat.com>
Date: Mon, 10 Mar 2025 09:20:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 04/21] hw/vfio: Compile more objects once
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
 <20250308230917.18907-5-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> These files depend on the VFIO symbol in their Kconfig
> definition. They don't rely on target specific definitions,
> move them to system_ss[] to build them once.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/vfio/meson.build | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 8e376cfcbf8..784eae4b559 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -14,13 +14,13 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
>  ))
>  vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
>  vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
> -vfio_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
> -vfio_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
>  vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
>  vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
>  
>  specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
>  
> +system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
> +system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
>  system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>    'helpers.c',
>    'container-base.c',


