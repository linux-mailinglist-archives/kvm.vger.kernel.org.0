Return-Path: <kvm+bounces-36801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EC3A2133F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:53:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16BAA7A3E93
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECDC1E008E;
	Tue, 28 Jan 2025 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nXQ/kJdn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCBC199EAF
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097595; cv=none; b=jWwDg42oujxa6+TnDeHZKl8pcfAjd7vHNcxEkQMhoRNYfZxJnRzTb2j71o5xmLK3FjMKVVL7t3+l1EYEN7hI6lTxHF4DLvrba7VQdHwbIht4N+ltgttzN4/xIjqRttPwVuprl3tSpVv2U736OWuvsMc1r0Pg8F6tp7rVfvBi6Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097595; c=relaxed/simple;
	bh=PWnUDVBfDfX2sG3oPo/FA5iKmLEbHMLaYzW+DlBiCHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+LKI8HGrvL/+MwfIvfxVPm0ZpSNU99bVL77uBd+u0tSxMHUe7IB32avV3rCmblgEhu3c1HUF3IOorXUaXT0YTT8GY8+QBKcw/d169po2Ll0AiE3PQiysvj7o45M6tPIQ+s/zUWQBc06iaqraaIl+8PE3dkF5hWq0xKpdLZggwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nXQ/kJdn; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso8582973a91.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097593; x=1738702393; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=URo8FEmDFzB6A///SxC3rjAeGZIUOBN9+BRHaomH+z8=;
        b=nXQ/kJdnSSK7W/snQ9+wJAWYruAemMI6x3/6VcPbDOPrKqT4hWroVFW5JIKnMNy+Sh
         Cz2bW7j/mnidodsmIbhGq/bMS7OLoTJrAmNo8PY9YYcUmDh9ws4DSDMVtofEy8d8hQBF
         xZuYi9LMSVPBSL2Be0HTNjPfoPqD2a4WxVRbXj7/96nB8ZNSUNBlqYHWieiDtKM9T2Mk
         Lu8cMhMLyer58t4+PZKf7XuOOzFj01adcnojnUtGkMvJZjJlYweFZQ3QF/hbo+X04Tpz
         nSfSknL1GsSO89LHphnyZkQG0Q+ny57+lWtInLZhtZBVMjZJ5mmugRPVjCLHd+2pjGV8
         DN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097593; x=1738702393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=URo8FEmDFzB6A///SxC3rjAeGZIUOBN9+BRHaomH+z8=;
        b=NDOMQQLKyUb7QoZjLvQHmEzQVIJ3qrw7tQuoot0shws1BsKnmvnKqS8Zj8JaPBctzG
         cDaZLvdZzsz7KkatAX8PVOOsXKrRpcwEFauPZaMuMt9HxXd2W3E5MBoG5fxKR7ra1BMq
         6g+MInuNEr5Rb4i4SA9A01dJ99m5M5Z0t/2loDYpvWaU61KXgTd2syMoDxL82QpevLFz
         OKRbdylSPegE9DAIPRWJmDHfJmSm2VvyJheks3y45kIPB6+EseLymXoX5xe/ozBLtMmq
         tsUnuQpKqchRFR62/lQCIeHnfXJnKPBiSRXCFjAgkoYN5Kxmhv9MbWGeNrr4TSLWtlrY
         TOAg==
X-Forwarded-Encrypted: i=1; AJvYcCVrAd/2U+25zT0MAEnxpEuTfUxnQFJIaEEtrs4GsyDSNttKoYT7trFV+5iun1JWLx4PPXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRm0R8Z8GJk7KRB/LXLCYCY9Ai1RNFguCSPsm/kqflSPO6Ijn/
	azM5qHHRr9ii1dAjZUm1JcSOVupIE7xA9tX6a/iysJOl0JzSyqCQgKvFUSIbM08=
X-Gm-Gg: ASbGncvK+49I8Fl5HNbKJf4//0IS47NQL5xWhtedtje8Yoc5QYH2DvqduJzP4HlC3lH
	3Iilz1ZEMsCGu1MAdNz4CnXnjZN9mLdUA5bt4IBJyM7jtaW3TvazvRmoF07sfJjWKKw2yuuOlm+
	Qm7juzXOzh7EcdeDyauUwMMKVskHTWe7ztc8wcTAVDNVvQPlYjwij4NKr09XyWxIUlXIVuJ7Of0
	CIUrVEt5UTusErVENcmxrAXqPANhORq7NYKY9V1wr5M5/lJewDr5Z4F/HM87Xod5vY/6TgLlPxW
	gofMpp4D6+kO0YG4ZS8ahE0c1c9uQKUE8MvRyQ1yw6+g4xNSLdnchYUiFw==
X-Google-Smtp-Source: AGHT+IGbCkwFcnvbvgjiI0FpzcUxshvLULe2uXuxSWfByzQcwn839F54/2Qol24ldyXXBsV6F8SoBA==
X-Received: by 2002:a17:90b:4d06:b0:2ee:ab29:1a57 with SMTP id 98e67ed59e1d1-2f83abb3553mr703945a91.2.1738097593044;
        Tue, 28 Jan 2025 12:53:13 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f830a3d74esm589772a91.2.2025.01.28.12.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:53:12 -0800 (PST)
Message-ID: <e57a850a-0f1d-426c-ad35-54ea6106f5a0@linaro.org>
Date: Tue, 28 Jan 2025 12:53:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] cpus: Add DeviceClass::[un]wire() stubs
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-6-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/core/cpu-common.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
> index cb79566cc51..9ee44a00277 100644
> --- a/hw/core/cpu-common.c
> +++ b/hw/core/cpu-common.c
> @@ -219,6 +219,14 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
>       /* NOTE: latest generic point where the cpu is fully realized */
>   }
>   
> +static void cpu_common_wire(DeviceState *dev)
> +{
> +}
> +
> +static void cpu_common_unwire(DeviceState *dev)
> +{
> +}
> +
>   static void cpu_common_unrealizefn(DeviceState *dev)
>   {
>       CPUState *cpu = CPU(dev);
> @@ -311,6 +319,8 @@ static void cpu_common_class_init(ObjectClass *klass, void *data)
>       k->gdb_write_register = cpu_common_gdb_write_register;
>       set_bit(DEVICE_CATEGORY_CPU, dc->categories);
>       dc->realize = cpu_common_realizefn;
> +    dc->wire = cpu_common_wire;
> +    dc->unwire = cpu_common_unwire;
>       dc->unrealize = cpu_common_unrealizefn;
>       rc->phases.hold = cpu_common_reset_hold;
>       cpu_class_init_props(dc);

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

But doesn't need to be split from patch 6.


r~

