Return-Path: <kvm+bounces-38378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A16A38A77
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 18:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5679718895AC
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 17:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15574229B00;
	Mon, 17 Feb 2025 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NLV+YUPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA1A22576E
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739812796; cv=none; b=LFeEyHJLQAbUbMFBHA5EpEnHF+d5idIhBZ9VM8h+COpjOb18BH2qpV361Ex0/uqyDACGBrEfmB/S3F20p0P7SiVzjcFrKf1QsLuGmAKGtxhfqlFzVwJtlDXCKz6Vgwo9lsFX81d2ympvC6OTY7ifJdzBR6j3Sr8G1g67LixGFaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739812796; c=relaxed/simple;
	bh=EZc/3wqzD+d9sHzJ6/FXQziibcq54qe4tfdt/ilNIaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwBzAHzEfKmepg+h3UG588FWMMAmTeLStm5vJszfzwwOzdAMaSVF22JxRfQoFA7KmzRTm/MD8AVguoEJb+xSJENOtc0lBTeWbIPVuSoCShYrzBVgQbFOqSXJ5SZXbn0CVl6UIwuoCiWm+2S+NeN3eRO9g8i6Q6s/EqEXcFks7RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NLV+YUPS; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-439350f1a0bso27658255e9.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 09:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739812793; x=1740417593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iQ6iKHAl4GiTXceekAQxS3dDYx6wGvfJgfBKoYsDbfU=;
        b=NLV+YUPS6tEhi1J7OhT8zEZ6ZXD0HmsMEcYgF6oM1k1xp6VriV4aRvnU23eAPqw65K
         AO5e1chf3927UU9PRveKiQhp1TdbqMJy4n0ei55Oc7F+lDY9tf4M6UuBIuIgpgLgdT5y
         z4Zo6IsXy2TJT7T68VypAZGpvm0zmF+01N0AYSDf33yWypf24Z/Z66Xp3auJrjNBDb6D
         T/8ohYUTyk7W3YoUmWAfhHlLFMgEcErgt5c93dW9iHRo59RIZHGtnLu8D8+S8YMzd6/7
         QHSHphf+o2yj6P7gxHBD4/qB5aK19zW0u8BXt0+p/jFW4OzxQLUyS7Jb7azrQ18zwz+9
         k2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739812793; x=1740417593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iQ6iKHAl4GiTXceekAQxS3dDYx6wGvfJgfBKoYsDbfU=;
        b=mZdPSLzsGzhOQeR9WFEnfQ4ZQnoOZt+Yr2NgoTm202BryipP8NzoCoUpULKbMOI6DZ
         h7pKziMHS0MAMYMQzJTo35QRA14V9iMz1cYL90EIbxLI0y0E235o/sW1udvfN6BMBv9f
         K8ckuv0i0NJnkIQajFxbXnJIoh9/0YjPd9cxm5F7aV2iaBmIz8QB0nLQnbww5yCDfeDG
         ogD+jR21nw71dnJVsrWswUGEtpmpb4BKBtQEj5qBxbYidUBKI1tUXRega22IpizhaXkL
         l1Nkt5TCxWwk2jebfr0cwFwkuLeFyIkq/3wYqWld4bd3kYjUrfuvBzYzyo6L+Jhdqtiy
         gVPg==
X-Forwarded-Encrypted: i=1; AJvYcCWoKWLzUeBKjcg1l5IuFnn7TVRiFjbTA0EE3z7UElVeMDH2M7cPWn3Ug1A5z/4n7Zog+co=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzunu96UC7kED9mYzOZQOxGspFI4K7EhRXUx3lKVs00PvQcJjIH
	s6+Ojw6Ac1Wjfi7az9EuuDj5sb2Cg0MOUeigXxwmtM5uXRrAOlYdt8j/rOCmRCnQPfEamBL/0gA
	k/+8=
X-Gm-Gg: ASbGncsAcmy+JNAB6FGmI5K1jEgoJE/07cMY9U2Sd1MZ34F4HTLqI8VppzRjoF1+P77
	J8TB9oSC2RcwCWadEyqgwCLmRMT4iwwu5dfcUpepoLC1lFJPMmu/fMbOM8Y85Da/iiJNDWn9C4i
	ddvTtICcUDQxUsP9z+wPG4TZwd/cK8mqKF5C43KoZJAfzakUh3NKjtsh9Ml/Ph6k82r6rtF1qZO
	54lSVcxAWOorlIDjX1+Ccg7MwG6br2ots5kbzKqeahvH4guhyGQYcGiC/MT0bJAPw8tuT26Cy7x
	QJOPXZJbll3ajY6t8uBW/RX6IbDxFQ==
X-Google-Smtp-Source: AGHT+IEgo1pk8uQGUSG6ebpaxNPekQ6qVjpVo6fgVMW/kIFnegEFZYxMbxaDbrxa4QtPRDs+dN9QbQ==
X-Received: by 2002:a05:600c:3396:b0:439:8439:de7e with SMTP id 5b1f17b1804b1-4398439dfdamr42175065e9.15.1739812792683;
        Mon, 17 Feb 2025 09:19:52 -0800 (PST)
Received: from [192.168.1.121] ([176.167.144.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1b83a3sm157295295e9.33.2025.02.17.09.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 09:19:51 -0800 (PST)
Message-ID: <a8be34a4-c157-4a5f-99bc-50c87c1330b1@linaro.org>
Date: Mon, 17 Feb 2025 18:19:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/20] cpus: Restrict cpu_common_post_load() code to TCG
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-17-philmd@linaro.org>
 <e52485c5-122a-4a95-928f-08fcd17cd772@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <e52485c5-122a-4a95-928f-08fcd17cd772@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/1/25 22:16, Richard Henderson wrote:
> On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
>> CPU_INTERRUPT_EXIT was removed in commit 3098dba01c7
>> ("Use a dedicated function to request exit from execution
>> loop"), tlb_flush() and tb_flush() are related to TCG
>> accelerator.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   cpu-target.c | 33 +++++++++++++++++++--------------
>>   1 file changed, 19 insertions(+), 14 deletions(-)
>>
>> diff --git a/cpu-target.c b/cpu-target.c
>> index a2999e7c3c0..c05ef1ff096 100644
>> --- a/cpu-target.c
>> +++ b/cpu-target.c
>> @@ -45,22 +45,27 @@
>>   #ifndef CONFIG_USER_ONLY
>>   static int cpu_common_post_load(void *opaque, int version_id)
>>   {
>> -    CPUState *cpu = opaque;
>> +#ifdef CONFIG_TCG
>> +    if (tcg_enabled()) {
> 
> Why do you need both ifdef and tcg_enabled()?  I would have thought just 
> tcg_enabled().
> 
> Are there declarations that are (unnecessarily?) protected?

No, you are right, tcg_enabled() is sufficient, I don't remember why
I added the #ifdef.

Could I include your R-b tag without the #ifdef lines?

