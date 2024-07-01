Return-Path: <kvm+bounces-20794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2193091DEE7
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 230CA1C2036D
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEAA149E0E;
	Mon,  1 Jul 2024 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Nd5XGEq4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E7664C6
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 12:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719836224; cv=none; b=jC4pD3cn7OxO50EutinSD8pVLnQLbGVu11rx5Igh/bqmDCf7lupToHIQJ127C7Nnvc1RgZcA5IhjhJANKsNcGavxt8PbjOo7bH/CVuwfPAw4ZVnSsT7aBDBbKAZMPXY6i/slMZmcYaJBW8v/Tub8Nc9wihZj8aN24dDpTMpHO6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719836224; c=relaxed/simple;
	bh=mlpc/MmsSxLNa0mBNnbF7c6HRSCV7pC0wvyPY7J7MHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tSJMh3VctpZ7UB12XnZCSJ8NRoKTi7nkau9WGVeO8rCnw7EjolxDg4NfwCKZ3BiVp/r5oTDSAJ//yJBisxl4upIEoRMY1Hzz5/w9L+/Fo7rPQYnhDNgr/4uL02gl+sIADakPlZRMQP2lnnyv4Bbq8vpn+rBU8oTLDJE5MkLsPDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Nd5XGEq4; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fab50496f0so15089785ad.2
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2024 05:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1719836222; x=1720441022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q9hUVzu2906VBKOyZdqa94VDDPFMg/0uYuzuiJ9d+vg=;
        b=Nd5XGEq4dgrMsLkl+s+54UNIYsY2dREcJY1qpkFDULMZmtVgpH3N9z0lreYtJL9yb4
         ZHLnIrjSb0Ab2HiAhN4eHM3PTy545bDmH+jZenoN1WDUG0WOg3hqepYm1jp4fdYagbxc
         mFwKGmxiS0Rsp6yu4K5eLeMz5w3JtAQAMwl0Js0y+rXCtTr0nZu2uqHJ+fFE2TIaJoRf
         NBYMtq0eF4XJ0cuHc/dhAbMn3uoIT0O/r7MXh0DmjmWuq1nfEP3x1TF3WRUo70hHgWEG
         26dKT5aa99hDBnwQQ4Jl9CCGMdS0VisM/rHvqtvITs9h8xWvvyuqaTw0/FpaUiBh1hoS
         p1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719836222; x=1720441022;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q9hUVzu2906VBKOyZdqa94VDDPFMg/0uYuzuiJ9d+vg=;
        b=pXFwzz9nwTYaTI4gC7uahtABiEM6Kfv8aU+KIyxcbOOPBTfDimGs4TbqCa9K3YH1NM
         /pEksAHf4Wj9aO3DF9BlPgq9t0fmgESb3peLO35Zn1anZucTgUK6o69ljcy5/E0knCqn
         BZa8eb1/IQ2K6NLA2ndwClaJC3pqs6R0apC6c3zo7yx6wZ+wfFnVvdKZyCDFnN4WQRUG
         KjOZZoKuVhJpHUPoxLk9DbMWgwxlHyCLRenKnBQPvPzSq4mIQb2SG7Wi+t8tf/lX8DXc
         Jl0tnw2FlB40dUzgxuaJkv4SIEbRWXdrd08DblYab/FWIWgahEqDB+vlAjFosRxqWKkY
         RtIA==
X-Forwarded-Encrypted: i=1; AJvYcCWSE2HDqZ4E+2Pz83pBQKTjKQeyb3WCvAW7n0MPJ9tkQacBweZqZuSzMaFFqet7JjbbAgB/vYivCE67jHuz0+MjmkYo
X-Gm-Message-State: AOJu0Yy+MqoE3Xs2sfcC+bAavowiLQTFDXxWJhQGCkWrUSK2FZ4PIJTg
	cDL+CO3QBkH2S0UkCcSE2u73m16aqoClDB93zsBT4E8wo8y1SLXqbHpt62Gtbs4=
X-Google-Smtp-Source: AGHT+IHSe6tUFVB9YqxIhqtRaeznFbomrPOiudIFmafdzWMK3YD0v4mheXDvr99RxdYzrHOZeZP8HQ==
X-Received: by 2002:a17:902:f542:b0:1f6:ed89:6bca with SMTP id d9443c01a7336-1fadbcb2019mr29959495ad.39.1719836221855;
        Mon, 01 Jul 2024 05:17:01 -0700 (PDT)
Received: from [157.82.204.135] ([157.82.204.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac15695b4sm63354995ad.225.2024.07.01.05.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 05:17:01 -0700 (PDT)
Message-ID: <1b5608aa-5cd5-48b1-bc7c-e356afdc9865@daynix.com>
Date: Mon, 1 Jul 2024 21:16:58 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] target/arm: Always add pmu property
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
 <20240629-pmu-v1-2-7269123b88a4@daynix.com>
 <CAFEAcA8FQLQF69XZmbooBThA=LeeRPDZq+WYGUCS7cEBiQ+Bsg@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA8FQLQF69XZmbooBThA=LeeRPDZq+WYGUCS7cEBiQ+Bsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/07/01 20:54, Peter Maydell wrote:
> On Sat, 29 Jun 2024 at 13:51, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> kvm-steal-time and sve properties are added for KVM even if the
>> corresponding features are not available. Always add pmu property too.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   target/arm/cpu.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 35fa281f1b98..0da72c12a5bd 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1770,9 +1770,10 @@ void arm_cpu_post_init(Object *obj)
>>
>>       if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>>           cpu->has_pmu = true;
>> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>>       }
>>
>> +    object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> 
> This will allow the user to set the ARM_FEATURE_PMU feature
> bit on TCG CPUs where that doesn't make sense. If we want to
> make the property visible on all CPUs, we need to make it
> be an error to set it when it's not valid to set it (probably
> by adding some TCG/hvf equivalent to the "raise an error
> in arm_set_pmu()" code branch we already have for KVM).

Doesn't TCG support PMU though?
Certainly hvf needs some care on the other hand.

Regards,
Akihiko Odaki

