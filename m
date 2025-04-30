Return-Path: <kvm+bounces-44920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F8CAA4EDE
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 487DC16C7F9
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755AD2609E7;
	Wed, 30 Apr 2025 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xBFYYI6N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08502609D4
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746023946; cv=none; b=uKo7VFEkSyKrZQaR5tDRG3gip1t0h92Myevmyz5LBAU3L5KlI+1PEpsv/LMgU21t6z8TJiMkKoYhPvt7pt1K4Fhn7E2PlQ51F064gtFlEvAi9oEozIIfXl8cjxfWCxzMgq3rMobx1ju7IkzM9zqnIArfwCe17kdcuUdt5l6j1Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746023946; c=relaxed/simple;
	bh=/ssMCf58JUv6ZVSIWHCtT0iw21V7bhFDbFNlUcvVEuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xgxl70fUtAPY7qCphBE5ccAeZIbH1391LFN+FD2YRbh++lk+4SNMNo6FSegxnIML+Sq7A0SsoytwYiGFSMu6eplrTQtYxfXHzRPVFY/D42S8E6xH34uNVcZZCOsZXFppwvwTdqyGWeHvmsclXL0VgF+6/z3QYJzpOXiu3h/T5rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xBFYYI6N; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7399838db7fso1242683b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746023944; x=1746628744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iziWfrMDATuxJ1oC+ojZYKc0BALl3/NiumthM8sV9aA=;
        b=xBFYYI6NWXyIT3UzHP9UuK6/cvu/QB8/H1Nua6yOHeQVBKUBbbL7z7ijLt2GH2aF7V
         D9HpRiA137UX4+K4j6MAFYbnbJqWzoPwbHZp+x7po7fi+IzbzooPvHlPuTHIH1MDpX1w
         SXm/lH8Xi739efrLhi5+qR5mZcn66AziNhprHUsTpVJt5y9/Fmbh5ZlPNd3988hckezy
         NK0TyLMkk9iGmsK+SRhdylog4RoUXu60xkLUYMeMhnqeWvdzlu1MPzwgjUYr4OURYTkI
         LqtYFGiLfoIjgGdoIUqdk+eUEi0XFCwRXrZcS74jQAAg/53Q3+EAzGrnsSmrcZlANYNH
         K90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746023944; x=1746628744;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iziWfrMDATuxJ1oC+ojZYKc0BALl3/NiumthM8sV9aA=;
        b=oIPQIMWTZHyGT3EYSfb1GBQD7EOQXx3a6oiD1PfilziRCIsK19cPZOacP5Ns4Q5BXq
         A8jAhMMoHDnpmvyxDVlPVDPK6o5D8zf79vcXOyYpNuTxY8XehnRGIyoC1sF8pd2ndUpN
         07Og6HOSXzyH9xb3SQewj9nyUbwliowGDv+L9HbRhbPpXGJn3fq5ErqARHGJwxQLrCZ5
         Qe7oQO0KHjkasqF40U5e045nrauv1cPgDvkcYpMOStnVdSb//ChkPU181gvcQOb0vUed
         AQm8G2gQ5RsUeSeWV0vLy/aM4NYPzcq9ebmYVTAIhZWbU5FlQIimJfks6gEOblUK8HS4
         MeRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlTQFLLso40PW8dJQATREQFbx66P/DMyenZrNndeXJj9Un/fJjVtadSJMRKNPJZ0wa8Yg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWHCuEh99DPOVN7TPWWQfSq2Qet3IVU1WfSno1ttU9ROuaYUSH
	HkKnpyNzKiGqK8yP4oHmW6NNh4hxC/exyJ8GNqn5HUwQvVfQWusP4RuA9n9re/4WaVAaYAbnGeV
	j
X-Gm-Gg: ASbGncvHPZcHcZf5vumNXFH807q9pqWia94+qwdsqeJ6ekmLqA4B+d42dxFBqMyoM+S
	SgQJ8TseFpIw8HFgt0HXcFFsZJ8r2LUTMfpST5xf8CF971vrUGmbzMigDbs9eo8wUMFPEFhNAYI
	+smuRH6Rh/H3wKOwmGDqvWMEWBew97d1HhXLJ/2pqC7yEwsNZvtVIDdVGJmr9+lhRO4o+xqeqAW
	qoCjDqCe+jzWDH2F/JonXh0EZ4EthkzyxgPff8Hd/ZQoVFGVjUCa5OliDtbDKXESlHxbajeXcDn
	B6oQIbx8d7VnIJlkhgtcWiooIHp86wcG+ZxtnFRqb2F4GdsUO/DYQQ==
X-Google-Smtp-Source: AGHT+IFcck6NA9HJOHtUow4q+rzz7NtoeM0eMYtAmia6Q8OUDHFTb0ZXMo62jznlQs8eQn2j8n6ExQ==
X-Received: by 2002:a05:6a00:1482:b0:740:6f6:7338 with SMTP id d2e1a72fcca58-74039a72143mr5121218b3a.3.1746023944135;
        Wed, 30 Apr 2025 07:39:04 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a60099sm1765126b3a.140.2025.04.30.07.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 07:39:03 -0700 (PDT)
Message-ID: <793e4cd8-b18d-4ee7-833a-8415cb79cc05@linaro.org>
Date: Wed, 30 Apr 2025 07:39:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/13] target/arm/cpu: compile file twice (user, system)
 only
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-13-pierrick.bouvier@linaro.org>
 <dbc62384-b05e-4f30-b82a-395a82812f65@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <dbc62384-b05e-4f30-b82a-395a82812f65@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/30/25 1:32 AM, Philippe Mathieu-Daudé wrote:
> On 29/4/25 07:00, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/meson.build | 8 +++++++-
>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/meson.build b/target/arm/meson.build
>> index c39ddc4427b..89e305eb56a 100644
>> --- a/target/arm/meson.build
>> +++ b/target/arm/meson.build
>> @@ -1,6 +1,6 @@
>>    arm_ss = ss.source_set()
>> +arm_common_ss = ss.source_set()
> 
> Unused AFAICT.
>

Yes, I was expecting some files to eventually be really common, but so 
far I didn't find some in target/arm.
Same comment goes for the patch 3 with associated target_common libraries.

I'm not sure if it's worth saving the lines (especially in main 
meson.build), compared to the "pain" for someone to have to write them 
later.

I don't mind removing this though, if you think it's too bad to leave 
this unused.

>>    arm_ss.add(files(
>> -  'cpu.c',
>>      'debug_helper.c',
>>      'gdbstub.c',
>>      'helper.c',
>> @@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
>>    )
>>    
>>    arm_system_ss = ss.source_set()
>> +arm_common_system_ss = ss.source_set()
>>    arm_system_ss.add(files(
>>      'arch_dump.c',
>>      'arm-powerctl.c',
>> @@ -30,6 +31,9 @@ arm_system_ss.add(files(
>>    ))
>>    
>>    arm_user_ss = ss.source_set()
>> +arm_user_ss.add(files('cpu.c'))
>> +
>> +arm_common_system_ss.add(files('cpu.c'), capstone)
>>    
>>    subdir('hvf')
>>    
>> @@ -42,3 +46,5 @@ endif
>>    target_arch += {'arm': arm_ss}
>>    target_system_arch += {'arm': arm_system_ss}
>>    target_user_arch += {'arm': arm_user_ss}
>> +target_common_arch += {'arm': arm_common_ss}
>> +target_common_system_arch += {'arm': arm_common_system_ss}
> 


