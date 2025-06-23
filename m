Return-Path: <kvm+bounces-50285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8093FAE3840
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1B007A5139
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49EF202C2D;
	Mon, 23 Jun 2025 08:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kwc6EZSL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C01D4409
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750666836; cv=none; b=mBVttJYrgXvTddBLdKQipjbe2jY+DfO2Nv9FKK99P4DMXGeSK7HVHrM23567cDHxx018SfN3s0Lm6x+fFUHfciQndyDv2AbX1gpEW1FqU0R37Jr0CuWI2zjt6JfHPvTa+mDj/fgJOzxbuuJgD0DZtmPR54wVlDnUhQyGUaO7UH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750666836; c=relaxed/simple;
	bh=ybIQBuRKjztW0dg5lpn26Cr7A345Ra2hdS9hgESoka0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IKuhGvHVyqrjYYNuy4E7pmFsNar9M8dee9zuQuQF1e4hNhwexVXWpWbFmj5UJlWngkxvE6tRJaBq5nTPl8vIegr49ZDXDFSh27/8Uc3WzKtX0IVFPyleO7sYznte4fxHaJ3/msgzwQ8ryhtfpQZJ1biF/DKci0W6epPiW/dASlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kwc6EZSL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750666833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GBbPkcJ+cqTlKtkPkEOBLY6Eme/Qi2QlGOOm0lPBfy8=;
	b=Kwc6EZSLstVWJBktjFq1NWyXYoLOX0WiAk9r7IaQJSC9VX55asxGr+1uQEm+nBYeO2WWLo
	uz8zdpngNKlHpzDMUjori4kZpxUWYuvqaF3WdYLbHwj+eo08h4nvtUBWkwOYpyy/uVEUcx
	u9hwdTaK7cIIMVGvTEsXrAae69xGBY4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-IyrJzRPBO2Wtpe2UhEaHGg-1; Mon, 23 Jun 2025 04:20:31 -0400
X-MC-Unique: IyrJzRPBO2Wtpe2UhEaHGg-1
X-Mimecast-MFC-AGG-ID: IyrJzRPBO2Wtpe2UhEaHGg_1750666830
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a3696a0d3aso1654579f8f.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 01:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750666830; x=1751271630;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GBbPkcJ+cqTlKtkPkEOBLY6Eme/Qi2QlGOOm0lPBfy8=;
        b=mYmxV5PUwJTXvUewI88XCE8JHZkDCDkGcWiRs9VScqieGaPBZRwzF4If6fAT8aNys8
         7T7Zx31mclAL+vMH3WXFDBM01PDsioy+I32C3PX2kdrghB/vbudIp9ZsabS1RbIBr/VB
         8UCKMb/l2OIOgkzV4bn36JseUTwh7gbqaSsoI+cX277GixGhAnYz1JUCuaWwObImXH8/
         Fpm0btVlKS5R5ipxKc3UYvvdt+JCAljOmzE3LOAxm4FfWN1rDB0Bpb2fxdyNh1u+Zhey
         ze2ItjfFRD+7duYvU32TrY4wLuRYFoWp6g2eGMbN1yLfefQLBFTcUdjm4X7I2VRn0gEi
         4cRw==
X-Forwarded-Encrypted: i=1; AJvYcCX6HFo6WpVLKwl61ermRFid+DzUKBvaC4oSjXGseHXpS8j7y7UFvSWxoqulCQ7USYsvO0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlJQHtNjww3gpa/8iOzeAtLRFmegt7pnRiYa/sqYPLlbbqlOf6
	B+DGhHjJ9vkNE2JTyaX2BnYu8xaUZJMJZxO6G+sKbrgzqijLvk/zQ5Gb1eFBuBcW/W3ry21xHSf
	nlXWSjCP9qkC+73Cx81byzHKvWJ/8rMDRt7oZOL6IpM1IrBRNZptdlA==
X-Gm-Gg: ASbGnctJKyauvIDRrVWvrnkVZd2dP1rvHR82Ni+z8WpiNmSx5xZ98qJqQLFswtHC+5h
	dbSYlHgSweD8HckxMNdngMmatnpVS5aQVmhR8t00ETOUZsxPWAL2JG5+5u2lZzPg8pFcjAvcQ65
	ObBtP/qu41lyO4mYUXZkCA7BJhZzXznQzZTsnHEpeJY+k7Tz5VgWCtfoRJiZLEMTgwLUEZODO4D
	HQEZR9jyYC29el0Yx4fEoGXYXdvvV1tGtV0DsBuptLieI/IDgd5caFq2NWOK6jwwluooXEA2i+8
	lg+gnbvzwemkvcI3t+3lcL5g8h9AuEwDsSspqBseSm/i2ruGtwdVBefTgW90+K4=
X-Received: by 2002:a05:6000:4605:b0:3a4:f6b7:8b07 with SMTP id ffacd0b85a97d-3a6d12e39famr8683852f8f.48.1750666830074;
        Mon, 23 Jun 2025 01:20:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/Uj5nWePqNYKo9LSNAcTJLy/FnRdV1bFqZ8no0/cHAlOiRtvPb7HGQmp5kR7f9BItTqveRw==
X-Received: by 2002:a05:6000:4605:b0:3a4:f6b7:8b07 with SMTP id ffacd0b85a97d-3a6d12e39famr8683830f8f.48.1750666829696;
        Mon, 23 Jun 2025 01:20:29 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-166.pools.arcor-ip.net. [47.64.114.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453647f29bdsm101598745e9.18.2025.06.23.01.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 01:20:29 -0700 (PDT)
Message-ID: <5ce9667b-3e88-4882-9e70-f5511f9cbe07@redhat.com>
Date: Mon, 23 Jun 2025 10:20:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/26] tests/functional: Add hvf_available() helper
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
 <20250620130709.31073-26-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250620130709.31073-26-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   python/qemu/utils/__init__.py          | 2 +-
>   python/qemu/utils/accel.py             | 8 ++++++++
>   tests/functional/qemu_test/testcase.py | 6 ++++--
>   3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/python/qemu/utils/__init__.py b/python/qemu/utils/__init__.py
> index 017cfdcda75..d2fe5db223c 100644
> --- a/python/qemu/utils/__init__.py
> +++ b/python/qemu/utils/__init__.py
> @@ -23,7 +23,7 @@
>   from typing import Optional
>   
>   # pylint: disable=import-error
> -from .accel import kvm_available, list_accel, tcg_available
> +from .accel import hvf_available, kvm_available, list_accel, tcg_available
>   
>   
>   __all__ = (
> diff --git a/python/qemu/utils/accel.py b/python/qemu/utils/accel.py
> index 386ff640ca8..376d1e30005 100644
> --- a/python/qemu/utils/accel.py
> +++ b/python/qemu/utils/accel.py
> @@ -82,3 +82,11 @@ def tcg_available(qemu_bin: str) -> bool:
>       @param qemu_bin (str): path to the QEMU binary
>       """
>       return 'tcg' in list_accel(qemu_bin)
> +
> +def hvf_available(qemu_bin: str) -> bool:
> +    """
> +    Check if HVF is available.
> +
> +    @param qemu_bin (str): path to the QEMU binary
> +    """
> +    return 'hvf' in list_accel(qemu_bin)
> diff --git a/tests/functional/qemu_test/testcase.py b/tests/functional/qemu_test/testcase.py
> index 50c401b8c3c..2082c6fce43 100644
> --- a/tests/functional/qemu_test/testcase.py
> +++ b/tests/functional/qemu_test/testcase.py
> @@ -23,7 +23,7 @@
>   import uuid
>   
>   from qemu.machine import QEMUMachine
> -from qemu.utils import kvm_available, tcg_available
> +from qemu.utils import hvf_available, kvm_available, tcg_available
>   
>   from .archive import archive_extract
>   from .asset import Asset
> @@ -317,7 +317,9 @@ def require_accelerator(self, accelerator):
>           :type accelerator: str
>           """
>           checker = {'tcg': tcg_available,
> -                   'kvm': kvm_available}.get(accelerator)
> +                   'kvm': kvm_available,
> +                   'hvf': hvf_available,
> +                  }.get(accelerator)
>           if checker is None:
>               self.skipTest("Don't know how to check for the presence "
>                             "of accelerator %s" % accelerator)

Reviewed-by: Thomas Huth <thuth@redhat.com>


