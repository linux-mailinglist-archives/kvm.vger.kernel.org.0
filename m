Return-Path: <kvm+bounces-60490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3356DBEFFA3
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 092A54EFFD8
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1262EB86E;
	Mon, 20 Oct 2025 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HLun3ULD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654732E5B05
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760949262; cv=none; b=ZTgBfSHG7bBxmIpooWaHD09ifGRsQGZMBK9XHXrLGROkCfS6SNRx0t9aRBW/pEvt56ZoMVUzdzHRkzsT6k1tmVCmH/2hrBdb5iTkOgtZuBt6QGEvPx5lQ6f64wTGAHuT+GJaIjUEIAVp35T6shO12MDhF61PokhQ6/BYroATrxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760949262; c=relaxed/simple;
	bh=l/AKbtlGs+rLu1RGd9vJL1pFBu2oKZk1Gdz6fooXr1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MIUSrxKoxia9QB9jTGiPPQe3C+TPJ74AXyBCjLdJLwACaByiZLAw5An4KjmPu9O17qCXtC4UxbMKH8BbWJy1Hnbo2ywQuwCEnjMzsKj1Z7u2ixksafoof4UEj7mhhAwIbHJ9kxOzA4XtX96PYc4sEdmbVxLNtvdS8BY52sU5+Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HLun3ULD; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46b303f7469so31288015e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 01:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760949259; x=1761554059; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QZOu69Wpkt3dDJ7X/UjOQfTO/q/0Y84qP/FVRQHU0gQ=;
        b=HLun3ULDnshB1o2tSGb7NhRM+R/zzRDkE2LOxMa/3d5APmSNMkldDjo5JNYlBhrAbj
         Gmh3mjYyGAYbGBplAl4GpkPwhf+mvNowdMruvRr66amyd07parZNYg8PYqhD7JTLT+7/
         ApSd6JEoNy+S5FaivKL69ZZvHNf9cetMNGcYhaNjb1UWTgBZX1uUOKMCk3bDaqA+61cO
         nRPcxNO7oPEl/rkEtwyv3EehRRfS/H/A4gjB6wHpt8RtTEvEbiRUHyK7p6st1civQu4T
         RfnPYylf62B3cmYoqf7+YhK175qeI0fVTUmkd43nOIOo6A8Og1I0koR81FOMSau/pGF1
         1IEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760949259; x=1761554059;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZOu69Wpkt3dDJ7X/UjOQfTO/q/0Y84qP/FVRQHU0gQ=;
        b=gmJIkTC/JZw9Id2DU9qVXIs8N3Y7Wt9sK1niLKdAYMJL2CQfl2qBw1mhViUBsTsqL4
         PSAVJwTtKW/DAHNA9xtnhjFod+KkFbCexDYldxZ9SrU2lKbvV4oI26Lm7e2MrKfWQ/Eo
         2m1v52HXgp+rQb/Yq9j61rx8IYUCalMc6FGpCl73TZKcIdmyzoZDP54UDEuvBo3NE6n+
         QBM2v0nfgK4Fdy9oN25EyBpRaC3eDS3SPLqAzPORGimqYv2lyzOjB7R2MNGnBb+6H0vz
         aodtFH1Os8Wdhv3I9hK9VnP80D62dhpC3KLdWlbvivvPex9DQp3YwaNqPX3SpEwnmNOt
         hc8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaz1kSH+WQ1Gizc/mmrQadRz9hF0FnpXWlDKKrP4tJS+8UqT8F1PCCHOaJ9ch3eq5hFeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcoYacoGtXIBQJxH6JU8DHygtqHdTHgOZHVdT1Q+7AEK8An8ON
	LsIEjFkFvEWfBM519RDsvAQQoVk3Jqq70Dl9Ez0AloooDxuM/QfPn+HFWtPCXpZu6hs=
X-Gm-Gg: ASbGncv3M+cE100VgZpnCJLPgmNO7ooIUdEAHmeWzZ+5ixH66yyp4vsvBIEWDK4u92w
	msGTpeoujmvjZfgy4MkBuIvixPYr2b+MSL/1bNV2MTTRaSn420UBzR2yJUno4Vpfawtj3XCnUey
	y0bpB/rLeEkAKmKe+6djm7Tg3OyBWOsD58fr9qH6cXhZIsbRGixpRjZ1ayRAAnchWca/2D97+3t
	Ns0JHrIMXhtM3FtcOy55oGxowiHqER6gaKsbt8r1nalUVJWOYiDPUJ66LoUaRF0VR/y8JBlq9q7
	JuagTxgssdKWO+sjHBi6lFZoAvhKmA6DrXayG61Qn17pnd5dhrU5TEiLjPxrzMEiuwH0tJbuO1I
	GZSs1EYNezVxPrbySGQhLgO+SArK1Nv5Q4bDnzpeBW+c/bOw69SgBrkjf5TgUhQMtctEeR+HzNj
	2Lel6mnVLTa7ULMQEbCEneEqsKyG+vZlmMdu1e1zGNGQtLTvP/zKkimg==
X-Google-Smtp-Source: AGHT+IGGsye8M5+dwNaN8vHqp+cAUAvPtJ8oi5JS9xfyqWbcRhTeKqxsvvtbikovqWp1apKaFsOGxA==
X-Received: by 2002:a05:600c:820b:b0:46e:1fc2:f9ac with SMTP id 5b1f17b1804b1-4711787dc76mr80589615e9.10.1760949258665;
        Mon, 20 Oct 2025 01:34:18 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710f2ab58bsm103955975e9.10.2025.10.20.01.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 01:34:17 -0700 (PDT)
Message-ID: <3139a9ae-c251-4544-b9a4-8818587e85e4@linaro.org>
Date: Mon, 20 Oct 2025 10:34:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into
 trace events
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-4-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-4-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:02, Bernhard Beschow wrote:
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/rtc/mc146818rtc.c | 14 +++-----------
>   hw/rtc/trace-events  |  4 ++++
>   2 files changed, 7 insertions(+), 11 deletions(-)


> diff --git a/hw/rtc/trace-events b/hw/rtc/trace-events
> index b9f2852d35..d2f36217cb 100644
> --- a/hw/rtc/trace-events
> +++ b/hw/rtc/trace-events
> @@ -32,6 +32,10 @@ m48txx_nvram_io_write(uint64_t addr, uint64_t value) "io write addr:0x%04" PRIx6
>   m48txx_nvram_mem_read(uint32_t addr, uint32_t value) "mem read addr:0x%04x value:0x%02x"
>   m48txx_nvram_mem_write(uint32_t addr, uint32_t value) "mem write addr:0x%04x value:0x%02x"
>   
> +# mc146818rtc.c
> +mc146818_rtc_ioport_read(uint8_t addr, uint8_t value) "[0x%02" PRIx8 "] -> 0x%02" PRIx8
> +mc146818_rtc_ioport_write(uint8_t addr, uint8_t value) "[0x%02" PRIx8 "] <- 0x%02" PRIx8

The block could be theorically mapped anywhere in the I/O ISA space,
so 'uint8_t addr' is a bit too restrictive here. Otherwise,

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> +
>   # goldfish_rtc.c
>   goldfish_rtc_read(uint64_t addr, uint64_t value) "addr 0x%02" PRIx64 " value 0x%08" PRIx64
>   goldfish_rtc_write(uint64_t addr, uint64_t value) "addr 0x%02" PRIx64 " value 0x%08" PRIx64


