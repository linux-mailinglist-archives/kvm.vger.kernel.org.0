Return-Path: <kvm+bounces-6363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2281782FCA2
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 23:25:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFDFB1F2C5DB
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 22:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6185120308;
	Tue, 16 Jan 2024 21:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dQdkxY48"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE04A200D2
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 21:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705440305; cv=none; b=RbB7/JZZ4GUtrUvPXDF3QrfnP/1RCDLkWbSogFfPWt1lQ8jza2KNzgDblcav8nE+4L4ZFNrquSn6BwlxIgn5VKNz8GPSLvATKybYqyBOVq5QSNDLOQU5T8tSRehM8Dn3TOUBDS7MSCE3oxYrPXG9TkEu9nv8q7DOmqMOde5JdF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705440305; c=relaxed/simple;
	bh=AVb5hw8D6pm03KLXXwnYRHlS+TwexVs8u4nvXbsceEQ=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:
	 To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=AVrKbpJN3hqhx36lod4ROaG8Fp7irgPzlm0z/2EuSlz9zfpvnAy9AFQOsdxSjSELDoM8Ccv/0a+3WDfrNDFJblgQOE7WgzVIQGro8pn1rHEX+7ftIwfG9zwwFbF450bt66IDRXFbvs7dcdIQpvDP0VhWQqptYZeQkoZY9kU/gJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dQdkxY48; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-555e07761acso12472318a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 13:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705440302; x=1706045102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZN3rSoSrU0V0ck0j3mERKVXOmSU7KwpwWf+gkqOG714=;
        b=dQdkxY48UVbNfMlf176N2PX1klfQwLjf4J9sP9dipBrb0SiETgUd49z7kQ0x3vlPzL
         iAnKB4hJv1fl5vzgOylAnJS18AHnjAibNo7iCWSGU5R7NYfHDUf2cvqdQ7zh1FAL9sPn
         WTj7uSJQjJbhB9s5UbKOnPO84fyAe/d+sMrnKfI81KAnGw9Ru1F15J9j1MGPk+ia8Y8K
         H7sSqRXaTeH7yQ84wqWo2NtIJCj8SsRuOuzl+n3qI+NBx1I5DejhNLQJmgQ+bKrWdsXA
         sP9U4UvwBH+ZBw/u+TWb0qtfz1m0JZvN5xkK7dLnlRxSJI+lzOEMzFQhyUksBel5EgYC
         KQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705440302; x=1706045102;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN3rSoSrU0V0ck0j3mERKVXOmSU7KwpwWf+gkqOG714=;
        b=Ia1euYZoKDyRhSzspP3PbnIha2D1ItHWUBqeAk5hOhirnEGQOsR95qkXWx7Tj6MmxY
         E+HCxoApNTNG/PBjVmiL4QkoWW15fSJI4i+NxoEQNX3mqMaKlpQbCc6qo5dSmjBjTje0
         pL6UJVaROAnCrQLgGziYrUbRtZf12VSMWDphltwTIqBaj6ByQFUB19zBke+C+oMy+54d
         rHQJIcGa750v61vwvepvPfss60hN8FhhpPyh/MN6hDEVVPMZMtem6TA0lf4aI69K2P8D
         hW7YQH3w4j6smqqeD3PrSRa2S+uCL8IZA5yLJrUqFQSIGaO1sLJ5IsV/5GD/rOp1akCs
         m0fQ==
X-Gm-Message-State: AOJu0YyZDUZKm8om59iTOt1aruNl5uo3HFDod7OKz2dQRMhuo1StZHGv
	Ml6PQPBjeihF3gYWsgsAagDnUoC5BLxrjg==
X-Google-Smtp-Source: AGHT+IEDlw9MPQzSdcVoslf9gA/QzgnvDUvpiGEyz2CDoV5J1bcF6E9Z/d+JqTkiMfdkBYk6eiF8aA==
X-Received: by 2002:aa7:c59a:0:b0:558:cd71:eed9 with SMTP id g26-20020aa7c59a000000b00558cd71eed9mr2680586edq.90.1705440301985;
        Tue, 16 Jan 2024 13:25:01 -0800 (PST)
Received: from [192.168.69.100] ([176.176.156.199])
        by smtp.gmail.com with ESMTPSA id ck4-20020a0564021c0400b00559cad6fc46sm282746edb.49.2024.01.16.13.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 13:25:01 -0800 (PST)
Message-ID: <b15f4eab-f4aa-4007-81b0-4a710af80a98@linaro.org>
Date: Tue, 16 Jan 2024 22:24:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel: Do not set CPUState::can_do_io in non-TCG accels
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>
Cc: Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, kvm@vger.kernel.org
References: <20231129205037.16849-1-philmd@linaro.org>
 <768e7409-62a7-441c-960d-dc99ab89c7d0@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <768e7409-62a7-441c-960d-dc99ab89c7d0@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/11/23 14:51, Richard Henderson wrote:
> On 11/29/23 14:50, Philippe Mathieu-Daudé wrote:
>> 'can_do_io' is specific to TCG. Having it set in non-TCG
>> code is confusing, so remove it from QTest / HVF / KVM.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   accel/dummy-cpus.c        | 1 -
>>   accel/hvf/hvf-accel-ops.c | 1 -
>>   accel/kvm/kvm-accel-ops.c | 1 -
>>   3 files changed, 3 deletions(-)
>>
>> diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
>> index b75c919ac3..1005ec6f56 100644
>> --- a/accel/dummy-cpus.c
>> +++ b/accel/dummy-cpus.c
>> @@ -27,7 +27,6 @@ static void *dummy_cpu_thread_fn(void *arg)
>>       qemu_mutex_lock_iothread();
>>       qemu_thread_get_self(cpu->thread);
>>       cpu->thread_id = qemu_get_thread_id();
>> -    cpu->neg.can_do_io = true;
>>       current_cpu = cpu;
> 
> I expect this is ok...
> 
> When I was moving this variable around just recently, 464dacf6, I 
> wondered about these other settings, and I wondered if they used to be 
> required for implementing some i/o on behalf of hw accel.  Something 
> that has now been factored out to e.g. kvm_handle_io, which now uses 
> address_space_rw directly.

It was added by mistake in commit 99df7dce8a ("cpu: Move can_do_io
field from CPU_COMMON to CPUState", 2013) to cpu_common_reset() and
commit 626cf8f4c6 ("icount: set can_do_io outside TB execution", 2014),
then moved in commits 57038a92bb ("cpus: extract out kvm-specific code
to accel/kvm"), b86f59c715 ("accel: replace struct CpusAccel with
AccelOpsClass") and the one you mentioned, 464dacf609 ("accel/tcg: Move
can_do_io to CPUNegativeOffsetState").

The culprit is 626cf8f4c6 I guess, so maybe:
Fixes: 626cf8f4c6 ("icount: set can_do_io outside TB execution")

> I see 3 reads of can_do_io: accel/tcg/{cputlb.c, icount-common.c} and 
> system/watchpoint.c.  The final one is nested within 
> replay_running_debug(), which implies icount and tcg.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Thanks!

