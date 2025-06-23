Return-Path: <kvm+bounces-50282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF19AE3803
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E4373AC8D8
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EB6214801;
	Mon, 23 Jun 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gLAnU5vO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9C20B21F
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750666296; cv=none; b=WTMVVvkCu/ZC41wF67hmS3dSdAm0rbrIT0vN9jR9qI3RAnpVjRXRZWjfGC9ZFMIQ0LAia9lWGxLHhkkrt0mWNqqWUHUZhOJ8Kv7MFi3t0cBh+dFuFoTlgbeOakamLo4gT5dh5234y5NvPFhe+24ZZYljhPoZoY1d1dgx02oGtu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750666296; c=relaxed/simple;
	bh=aC8+uxDmWIrzSevxm/X2hVTLaOC6Eel/5GpTc4HwRvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r1AT/7gfZlIAu8TMhtMuLaXj6GwCOnxMZjb9YM5BqbZMLMXJgP9L1BJfpkeo4GAbrRCUAjGcDrnAeqaF0faLPJErRKvHJzatsaph/Nj9OtVRdvP11OJVROy5liAPhaAq/KQAQhk3WgV+5vjNNANMbUKqY2fDp3qrFuM9vGr1Jeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gLAnU5vO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750666293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+4kwDZoN4WuZV3NRgPforPSd1oPFe1fZw2u/4KSFCas=;
	b=gLAnU5vOUDfz8K+y8QB7zVpuP8qoNdJyXqaLQgCna+mQ0XhFmGvRKefBw4KUH5g90PcnCa
	zmS0oRC/FHPzQGtrKCjWQ449XjnYHMMBZYV1b+0g6kJ2NmmbP58bAKOOV3uj7HerVO1Gqf
	eB87w94GDrZOzTtPUtlRnVmstoxpgkQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-6kTx_oXgMjejgPP0RWNwFg-1; Mon, 23 Jun 2025 04:11:31 -0400
X-MC-Unique: 6kTx_oXgMjejgPP0RWNwFg-1
X-Mimecast-MFC-AGG-ID: 6kTx_oXgMjejgPP0RWNwFg_1750666290
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43eed325461so23335755e9.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 01:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750666290; x=1751271090;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+4kwDZoN4WuZV3NRgPforPSd1oPFe1fZw2u/4KSFCas=;
        b=vYIAak1lhkghMVmSz0iZd2D3T32DjREMpRlr7l1BBvrUjURhvrSxs/HwolSDaKkX/j
         ElXU0J7jThEZdFMzfLBl3QM/KLw8Zv3emcC64AYS0st1Tz1UlNLzFR1o5YSSH1nfFDHM
         OFunJ0SNrmg4DAYeZYu/W1GQWja3kWGNsh0MG5gO7vmEIYzvzRYqu27a2k6rxBO5271S
         eSZ7xxVKVPUhGGyXQuWGGpCMNmK2e2zOBQbdQn8lQS47lHUgVZF2JxwmO9cd412f884h
         FIWU8/a+fneSTW3Dl1XvARdDxq/dHZFuar72fJhy6o6BcR/T4V6JkxNnWn680SMWaULn
         Zcwg==
X-Forwarded-Encrypted: i=1; AJvYcCVSznoSeJKAAYcMYg8M9rfIw5XtR9eApYh8W0YW8VELFfExHIwVsUJJeMG9xbeHxLKhNsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSu6FyvjnBG6o3+/SbmK4q3Qvy5laNhtoEuO2NAgHFP12VW8aN
	bZ0K7k+Z2pIB2rwFHRp2mXDMxZ3CSGtTCfT1hmLV7PcpU6F2NZLGy+ne8P/x3Yp96A/2GRfOq2B
	DIE1vkLXvYA8GF26X74zV/vixuRVHB+LOW+InxmpE90Dax1a4BiGS4w==
X-Gm-Gg: ASbGncs5FZXzGTCWlUqB/7fFoVcd3hfQfuEOg2Mln3RxYepN/Tqq09sUy79RDkuF6PV
	wppqanzmYgXizl142XSLunR6Ms0KtgjkIpXmrVIXvAxThcFCPsRzcTHMEgbV4VUZ8276ejxB6Tw
	teFj3oCkWSxXpJ/bbxblZSlRCDtA346+boFwO8xwjBa/nCEJmrE7BV/yYb4czW0yy+cRPsHbAC0
	GZtbiwy87BqqaJToth9xNzitatGDoCL3JuqaADACOxEXEPIQiIY7seMY9pS5it1RxzJVTA4ZnKP
	IUROL/s/9XdRnHfoqP1KbnILWxFJj4rIzdx25AHCxWhmpu7z2N3B1VjXqqG7rFo=
X-Received: by 2002:a05:600c:8b16:b0:450:d07e:ee14 with SMTP id 5b1f17b1804b1-453659ec1abmr113476335e9.17.1750666290161;
        Mon, 23 Jun 2025 01:11:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHSYgSB4RkTnj610mYZpPuQtR08xMN75sCP8xsdfL+ouLLJm/LeU7UknZje+KpOoeMWPUthQ==
X-Received: by 2002:a05:600c:8b16:b0:450:d07e:ee14 with SMTP id 5b1f17b1804b1-453659ec1abmr113475855e9.17.1750666289717;
        Mon, 23 Jun 2025 01:11:29 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-166.pools.arcor-ip.net. [47.64.114.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45364708658sm103184065e9.39.2025.06.23.01.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 01:11:29 -0700 (PDT)
Message-ID: <497fc7b1-dfd2-49ad-938c-47fca1153590@redhat.com>
Date: Mon, 23 Jun 2025 10:11:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/26] tests/functional: Restrict nexted Aarch64 Xen
 test to TCG
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Radoslaw Biernacki <rad@semihalf.com>, Alexander Graf <agraf@csgraf.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Bernhard Beschow <shentey@gmail.com>,
 Cleber Rosa <crosa@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, Eric Auger <eric.auger@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, John Snow <jsnow@redhat.com>
References: <20250620130709.31073-1-philmd@linaro.org>
 <20250620130709.31073-24-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250620130709.31073-24-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
> On macOS this test fails:
> 
>    qemu-system-aarch64: mach-virt: HVF does not support providing Virtualization extensions to the guest CPU
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   tests/functional/test_aarch64_xen.py | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tests/functional/test_aarch64_xen.py b/tests/functional/test_aarch64_xen.py
> index 339904221b0..261d796540d 100755
> --- a/tests/functional/test_aarch64_xen.py
> +++ b/tests/functional/test_aarch64_xen.py
> @@ -33,6 +33,7 @@ def launch_xen(self, xen_path):
>           """
>           Launch Xen with a dom0 guest kernel
>           """
> +        self.require_accelerator("tcg") # virtualization=on

What about kvm (or xen) as accelerator? Would that work?

  Thomas


