Return-Path: <kvm+bounces-50284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59A0AE383D
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD7E53A610A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862CE22068B;
	Mon, 23 Jun 2025 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipMCCf/U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D342921A433
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750666782; cv=none; b=bLuXuPXuTo6MLDe5asOFJWGcCwh7Tyayr29KFpBHsTzpmAjGPp3+Lv/Tx/FBPC23vKdf6RhLtFx5ZRHCpjWEOoYCfQ/t48b5mMHJCU7+PMIvQ78hNBQK1tJU3KEakUrO/PgIeMXNeheWalTpAboA7KTmTXwgZfwC9hW9f2dAVm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750666782; c=relaxed/simple;
	bh=F4mN+nOKDFEOMtWFMcy7HYbhJO+5/16vs8WGUs0b9yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rfa7RBpgTTJN3TwhQtwY4eEHn84OVZclNDqPZJulkJS88h7g9tM9Zj6xQ0v39GQKs6zxfyhWKJc17tS5NjoQQnP2BNFbXBI9kXz2BEHLCmmee3yR7WSnz/8DEgaC3LSdfrVgr8M+pTPfuZKpIk62qZcmMEGesRqz6WfQQIBbqoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipMCCf/U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750666776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8XX5DDD8hC5pLsDuzu/Mi8zN3wXHrIluVW5N+ZopIaA=;
	b=ipMCCf/UkEn5Tv88kKq+lamfUSLquOC6fyHINy4f2Bl1wsWwQM+4uTQYvJjsgWn+GtlVMn
	7fLsD58UgUHlj5ZHsKRoAK1xyGEQWOct6QYGzSTk7dz4NQGq4GG4FtCzhFQZvRyd3kmAna
	V2a3xt7VqDC3zUTtmjXWB0bhjkkoiXo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-IRpsMSLcMiS24LMOHsleXw-1; Mon, 23 Jun 2025 04:19:34 -0400
X-MC-Unique: IRpsMSLcMiS24LMOHsleXw-1
X-Mimecast-MFC-AGG-ID: IRpsMSLcMiS24LMOHsleXw_1750666773
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f65a705dso2131386f8f.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 01:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750666773; x=1751271573;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8XX5DDD8hC5pLsDuzu/Mi8zN3wXHrIluVW5N+ZopIaA=;
        b=ThNSFWH3ltruLUMfSoa/iLVp63tKDb879dJrgPKPuRiDutn1L+78nKZz+nzNXxKoFw
         Jbkzg8M2x5f/6TUCa+obHeW9DANJmKaJmARETC6mvm4gpyf7dmXD2kKkBcxRguM/y975
         HyCixr+g8bhV4s7MS8RZVRC64pGAq+1qgIjQ3cKnDjKUNVwTHTgSkLd5I8g9HtVvJyni
         bck4CyxNIdxHJSinkatNq0dpsULV3wnfo0x4niNY3G4ppz5sfJzpMtv+eE2/cV6po+hN
         RPs5TzcPRyK2zFy+2Jtto784/0Y0nQ5DkIlSUaRe/u+SRwV8OPcS+ChdZFM2iwyZPhZ8
         i5RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOilkogtTlLkz6PXKET/TS+7GBwp+SFhimzlh/suLhymI+qTjhLjaDhOSgkjrWsZYz/Vo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtkSEFxhef7asTFZ7QLVfPMlRKrjP7hT6TrQtQk77QW7mITGSZ
	FxKA5aieJhY9c/H9phHIA9kNBOM7/KpznU+3a5tkEcsdFoP6FNoEbrkovwig3l7c5LwC9pq+nno
	QEVPA3+2L4Lpi6Ffu+ZPAXcywsec660qM5aUr/p0ojyPd73upUXd/7g==
X-Gm-Gg: ASbGncviDQvdhEIAvO5kmRgsFLz21L8UQZTq/ledtvLSRT2qRaYIUQQCuYqjXoH4O6s
	N0uN0m5veshf8EanvrXNFhkLuCBrpdJroeUpRdQekDDQScuYadiP+p/XznhTSbpn0kyU6LzYL9q
	sIkt4b6TzUU3MRWgsKRA4tQ2iC1VAaWSh+pYgzZZWsWrXwTc/fQWDQndhveWj7yopzHFFC20EzU
	lrTc5q4inQkOP15Ph10wVSCMf7VSTiyFFs1kC3VTYDg/K23rT/MtrruGPdL8DHCWW21F77kNnHM
	Xh6IekG7PkWbPZOvp380SDw1NJq5qQS9ecEtyOnEUsrN0rNv9De9mYqhTxbh8Hc=
X-Received: by 2002:a05:6000:178f:b0:3a4:f038:af76 with SMTP id ffacd0b85a97d-3a6d1331ef9mr10090466f8f.53.1750666773234;
        Mon, 23 Jun 2025 01:19:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHB3OnZIUN6Z1pfd2Ko5M98DIFDS9f+w2C6Oai+OOVuvFK9Bb/v2T9UJg150rrspCRwaQVMtw==
X-Received: by 2002:a05:6000:178f:b0:3a4:f038:af76 with SMTP id ffacd0b85a97d-3a6d1331ef9mr10090434f8f.53.1750666772820;
        Mon, 23 Jun 2025 01:19:32 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-166.pools.arcor-ip.net. [47.64.114.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f1d902sm8609481f8f.43.2025.06.23.01.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 01:19:32 -0700 (PDT)
Message-ID: <3896c4a8-8b25-45e0-978c-1539648ab4cc@redhat.com>
Date: Mon, 23 Jun 2025 10:19:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/26] tests/functional: Require TCG to run Aarch64
 imx8mp-evk test
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
 <20250620130709.31073-25-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250620130709.31073-25-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
> The imx8mp-evk machine is only built when TCG is available.

The rationale here sounds wrong. If the machine is only built with TCG, then 
the set_machine() should be good enough to check whether it's available.
So I'd rather say:

"The imx8mp-evk machine can only run with the TCG accelerator".

With that update:
Reviewed-by: Thomas Huth <thuth@redhat.com>


> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   tests/functional/test_aarch64_imx8mp_evk.py | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tests/functional/test_aarch64_imx8mp_evk.py b/tests/functional/test_aarch64_imx8mp_evk.py
> index 638bf9e1310..99ddcdef835 100755
> --- a/tests/functional/test_aarch64_imx8mp_evk.py
> +++ b/tests/functional/test_aarch64_imx8mp_evk.py
> @@ -49,6 +49,7 @@ def setUp(self):
>                        self.DTB_OFFSET, self.DTB_SIZE)
>   
>       def test_aarch64_imx8mp_evk_usdhc(self):
> +        self.require_accelerator("tcg")
>           self.set_machine('imx8mp-evk')
>           self.vm.set_console(console_index=1)
>           self.vm.add_args('-m', '2G',


