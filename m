Return-Path: <kvm+bounces-45453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 164A2AA9C00
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EF1A17E0F2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE65F26A0EB;
	Mon,  5 May 2025 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hqyNWj4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAC386342
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471203; cv=none; b=fjkkm3ym/0ZVNPmhnRc+GCafk7Ra8f3YxNYKbu/OP+bZbxD2AVowLmRBOJMJuTWKbkHQ6r3896FgIZz3Hhtx+c4OFIF4zoQ256z/fmUBBgBWiHsfHjrNYLfgPGeGwZJS6IGIKSwgV+3qzJ1Mia+9hQg8Uyau67FRxcvGi/Z3hzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471203; c=relaxed/simple;
	bh=AkSrRkzNIDAjMR7CvbkoOtfFc1tYBJNsnUQEoRpqRxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oy0hmnrxzx2yJ++xYh+O9e+eUMH5BxDCHoxd7KkQOmK3EwImocYg4JMU9ZtmXr3/EcSIZx65Ik2ztXo8APwQz4uWALQ1yLQ9UlP8LeBsAgYsS1jCnQ7R4RIGzg9hA/CE3ExK2aGYwV3FjVEAtlo2RxQ5OdsqpJQB0MdPRZnHwkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hqyNWj4q; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b13e0471a2dso3571816a12.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746471200; x=1747076000; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WW2PugbCueDfTe7SCxeY/0K3L52JtpHstHxnpx2N9c8=;
        b=hqyNWj4qeoQRnDQYP/LPQAwy5QeKJC5TnS+0v489qPPWsWEoAqV1b4Vu49VFfSeDTp
         iausC2aAtNyJbgr8sQeZGAaG/tzaA9bvJi6juEHj2cIwiPgbAmBkIuoKvYWYKKhSDss1
         MKwHYrU2Zd19IdnnIij0E20OoS9BYZzxKhGEr2BYMRBRDl9R3vLiBwuKZuI8ECMx8N2n
         KLyG2wvICTl+TOOjEvNKV2JTgs2I6Hwea3/KmqXLgXa1sDeE7gAgjtOmQ9TIC+y5xYd6
         M34PjOTZMM1koujnyl7llcsdYXOIlZGzVbH5uuVRnTqWQcF1YV2ndv3JkAK10uZjxn0A
         iKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746471200; x=1747076000;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WW2PugbCueDfTe7SCxeY/0K3L52JtpHstHxnpx2N9c8=;
        b=p6TuMascrj25C11inBkRK2Howrgo5ARTsAJa6+nBy5bEmvPa9hNVYm4dljW6j/HNAn
         PYNlbSUdrSO6GSTgNoRvUDT/hRrArJBPWSdbVaRp7D+MTFMUQqcHl09JCwvkzyDTutpV
         Pz+UejP99EfTJcGsS5nfm/I9KkRS/ailyhJ7P34bP6MFFB3KmztM+cAWfnN4Nc+s1zWx
         ICblmvMMeyxaHHvz+nmqSJSXk9Z45jbKRTNmtiC7FuyvOJRGnjs2tIHEvfDiaSG8I03D
         g4d5JiyQbkEGDZyG9ZVs2uXR5gKThEb/pddGCLiU9EkZVKY2OEkxyk6hsfp4AyFWAUh3
         yKbA==
X-Forwarded-Encrypted: i=1; AJvYcCXUnHSEfaz69Ze3zQlnigYA4/XLigFa2ySq2DjAzjUd3S00q4SczRlweEQ/e8wpSpJj93w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7ro7iA9SKqqi837K1U9fzCPO4hev+WFEdyA/fO6PQLMmLTaIW
	4NWJlKk+OO6x4vgR2n7CdOonnA9DVyYfszkV8QockWJa5lETvIDWRePbUhtFO6U=
X-Gm-Gg: ASbGncuRElLNtisNl9LdTyhTVd8+uWCP4IIWHuqKeK/AGc8hgM4hmZEjmMGN81EmyG/
	fgmXdW8B0zyVfSZbHModYf/3fLqrLmQsqs5vuhcAsTMKyGOdyeFQzwrv9xR/H7Dut+/LPXFnsim
	YOjDGVdurbkw1zM+4hRgg8g7cnbHA+pP78gcyY8ePMVbsbmj47p6mLR7K+t40Cg04AB0X7PAqvm
	6Iib25IBuuUV2U5Xwvz2Y+JGerIrUnI5y0vZhZI88KfYN/jCl7/uRcEpklobiZ5Nhj0GoMA/4V3
	N3TvCEcJhBkiArmZl9ECIYq/RWYNvOL3qhm5G3mOPc+91hRq3MAzHw==
X-Google-Smtp-Source: AGHT+IHZVx9eBvMSyhsQT2CjKQPJmL9kB/iVWh/hm8ZsQ4A2jqzgMClBG9aBXB4nd+yyoHKnutlong==
X-Received: by 2002:a17:90a:e184:b0:309:ebe3:1ef9 with SMTP id 98e67ed59e1d1-30a6198d1e8mr14256650a91.12.1746471200600;
        Mon, 05 May 2025 11:53:20 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a3484bc23sm12038442a91.43.2025.05.05.11.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:53:20 -0700 (PDT)
Message-ID: <83038814-8527-44ec-b1c1-2d17362d08da@linaro.org>
Date: Mon, 5 May 2025 11:53:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 41/48] target/arm/tcg/crypto_helper: compile file twice
 (system, user)
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
 <79916f8d-2793-40a7-b769-ee109c52ef63@linaro.org>
 <f33fa744-1557-4c01-ba49-e64b4d3b6368@linaro.org>
 <c67c4a79-7855-4d15-8064-b2f448ac9a42@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <c67c4a79-7855-4d15-8064-b2f448ac9a42@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/5/25 11:51 AM, Richard Henderson wrote:
> On 5/5/25 11:47, Pierrick Bouvier wrote:
>> On 5/5/25 11:38 AM, Richard Henderson wrote:
>>> On 5/4/25 18:52, Pierrick Bouvier wrote:
>>>> --- a/target/arm/tcg/meson.build
>>>> +++ b/target/arm/tcg/meson.build
>>>> @@ -30,7 +30,6 @@ arm_ss.add(files(
>>>>       'translate-mve.c',
>>>>       'translate-neon.c',
>>>>       'translate-vfp.c',
>>>> -  'crypto_helper.c',
>>>>       'hflags.c',
>>>>       'iwmmxt_helper.c',
>>>>       'm_helper.c',
>>>> @@ -63,3 +62,10 @@ arm_system_ss.add(files(
>>>>     arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
>>>>     arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
>>>> +
>>>> +arm_common_system_ss.add(files(
>>>> +  'crypto_helper.c',
>>>> +))
>>>> +arm_user_ss.add(files(
>>>> +  'crypto_helper.c',
>>>> +))
>>>
>>> Could this use arm_common_ss?  I don't see anything that needs to be built user/system in
>>> this file...
>>>
>>
>> It needs vec_internal.h (clear_tail), which needs CPUARMState, which pulls cpu.h, which
>> uses CONFIG_USER_ONLY.
> 
> Ah, right.  I didn't see that coming.  :-)
>

I like the idea to have it built once though, since so far 
{arch}_common_ss was not used, and I was not even sure such a 
compilation unit exists.

>> I'll take a look to break this dependency, so it can be built only once, and for other
>> files as well.
> 
> Thanks.  Building twice is still an improvement, so for this set,
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> r~


