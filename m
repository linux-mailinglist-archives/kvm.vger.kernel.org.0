Return-Path: <kvm+bounces-41417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD84A67B35
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E18FE3BEE28
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7390C2116F4;
	Tue, 18 Mar 2025 17:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NR/trxNj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51C721129C
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742319761; cv=none; b=FVQMyMdJMd889IRVGojDeCnY7JXLY9ChO/2wCkZxxlV/emcZacVmf+vMjbEarKjkikrLcBPM+gSdQ/folcoY2BPtyp+CXTrh387vUs+wZxPyseRulbayGZQsoB+aSOo0Op9A75B50LUBbbjXoj5kvC3BSCwwjv9lkx6eLmjZ8AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742319761; c=relaxed/simple;
	bh=e7H2rTlg7EsT45u+6vx9fQXGua6kYfYyLqILh3T4vwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CB+rbb41tmdVmTg996UMKIxD+3lqK9YFTVvDQuAXLKOe1zSflb89JJuLr7STgeqjrae72uyV9AyYIc9qesbOAwOuqD4+QnUQQMwoVDPKJWF4LxFkWk440AwK04bPK9qZUGmFgWoT4TPveKlrfqxhN5H/3RwQt+0PWqR4iJfg9oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NR/trxNj; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cef035a3bso26581355e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742319754; x=1742924554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=17SVMOF/Nhdsp+4dVpqTL9OX4gq5t4F3wmy4D//jp7U=;
        b=NR/trxNjsCScaTaTKkfJrTpz32rjQTTQNhwrha6iFBnQhRdH/AI/kiQecABs9fGZGh
         tLmFaBdguLONnO1PDJgpt/sUgFH6WG8jcvLY7HTP0g57n5CSYVfKtD1eERS1HajeQoMB
         XUP74ACGGVmE9+sVn+jqy24TgiJMB43JKX88osoqQkEMMYJxIIu2Q1VoqS0ymU7IPx4h
         uqFVXfKTI5Z/4pq1CN5x+vBrCucCViaL4c6emm9MR0rgrZIkJDlcQbEQl5tHFEHP4DVk
         l5W4GS7yxSeUPJxxllNZtNhbdwWn6nguhviKMsdgGpT8yilsbKPPRjMqyqlqsit18EEK
         5gzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742319754; x=1742924554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17SVMOF/Nhdsp+4dVpqTL9OX4gq5t4F3wmy4D//jp7U=;
        b=Sng+y0dyBwD835ULHERR/z7782JMiat5jrD5y3eG6N4Yn8erQRAmw/x/+Lbf8Mmzxn
         uf2GYiKAZLXtOk6sQOM5mJjP5J1cihocT3IMccO7/s20qB1ft+yf0H9cgFBlJU/ZTsLf
         OyOu1lh7YDzuDbfPApVKlwr+5/xiTlb4YauqyJQyDGWlocjGQ567NereM+5+z3fYzJEC
         bFKXUnwgdImrgsnsyp7PEs8ALP6Ht7Ap4seXUpmL461AgIYl+/9La50ZPbyYN9/Oobdg
         Dcoo4WcFBrlfbXMguI5+EU1QRyAlA4SYkgJTT8a9V05CF3iqMaA4WTzBMh95oJwjQAhM
         Mnhg==
X-Forwarded-Encrypted: i=1; AJvYcCXD6Fs1uu5TA7Tzsv4wK5otulwwbv/an9MXw2c97/LOGCd1peJvtpb3qMBYkiE3rmZGhPY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+S10tMFUb1d4lil0EfyVH+ZtiIkWxPtWp59UhaKZR2IDQjAtP
	vYTnKRVssYqSuucXM5EMP7M97NDVkf8sguYG9q8a9FkOAVtNlc0JkJC7xeWmfrs=
X-Gm-Gg: ASbGncvPWXlEmcZ7XotSECQ8ajzwCzEDGG+dbtNIMoTpISgX9GZU7uGBfgBbFlrSYDi
	T4kJ6oR6VqI/awT5ou4avKiqWwKAwp3JeJSrfXbXni47zj57y3hW+pgq2UBY0QRwvkfwSV9l3Y/
	WEa/LjYSAw2jeV+dRA0O3meZOcyeoIxvzRWXjmLxSIr1bnQh8ntHa4EFGCW9/eHlgMywoGGCxfM
	3GMZdrmvy57CCEZw+QwybZeGvXpmKY96LBLRnW4/KbxHW+3IOPxZvwRSlv7syGKcreYW9R2Yu4D
	zNUwTIkzVAttO/1p0Ou9ip7KwesxXfr3Y09K99Tu1C9svrzoD3GxaX62qDDrLuEd68uSZrAXlut
	RzcEA+8g3yhFH
X-Google-Smtp-Source: AGHT+IHNhODWTF+JiipsrlWDdQ9MdXQw/X10v5jVQIbHnGx/mcJwin8Hy3ZzvMzwWdXdLV4Tkjm9qw==
X-Received: by 2002:a5d:6da2:0:b0:390:f394:6271 with SMTP id ffacd0b85a97d-39720966395mr18326969f8f.43.1742319753993;
        Tue, 18 Mar 2025 10:42:33 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb40cdafsm18871927f8f.62.2025.03.18.10.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 10:42:33 -0700 (PDT)
Message-ID: <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
Date: Tue, 18 Mar 2025 18:42:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32
 emulation
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250318045125.759259-12-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/3/25 05:51, Pierrick Bouvier wrote:
> Directly condition associated calls in target/arm/helper.c for now.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h    | 8 --------
>   target/arm/helper.c | 6 ++++++
>   2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 51b6428cfec..9205cbdec43 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1222,7 +1222,6 @@ int arm_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
>    */
>   void arm_emulate_firmware_reset(CPUState *cpustate, int target_el);
>   
> -#ifdef TARGET_AARCH64
>   int aarch64_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
>   int aarch64_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
>   void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq);
> @@ -1254,13 +1253,6 @@ static inline uint64_t *sve_bswap64(uint64_t *dst, uint64_t *src, int nr)
>   #endif
>   }
>   
> -#else
> -static inline void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq) { }
> -static inline void aarch64_sve_change_el(CPUARMState *env, int o,
> -                                         int n, bool a)
> -{ }
> -#endif
> -
>   void aarch64_sync_32_to_64(CPUARMState *env);
>   void aarch64_sync_64_to_32(CPUARMState *env);
>   
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index b46b2bffcf3..774e1ee0245 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -6562,7 +6562,9 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
>        */
>       new_len = sve_vqm1_for_el(env, cur_el);
>       if (new_len < old_len) {
> +#ifdef TARGET_AARCH64

What about using runtime check instead?

  if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64) && new_len < old_len) {

>           aarch64_sve_narrow_vq(env, new_len + 1);
> +#endif
>       }
>   }


