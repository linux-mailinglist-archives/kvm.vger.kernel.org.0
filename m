Return-Path: <kvm+bounces-41436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1C5A67C30
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EBD617FB3C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74556212D62;
	Tue, 18 Mar 2025 18:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZYA3as+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933801DE4F8
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742323488; cv=none; b=Gd8aLMrWGLC69tyo7gJJMLQHnFV4H4mm0eEFF0RvVldchROxaHlw23nTLIpMdmUA0CguoRPf9oY5X1ISvCC5X57E08tVVden77pST+kn3w4oeZX4zLeQj4yrV6SOLzh2Oc0RhIDSim10fblC07s8doWbdMmoH3zfltkhgvQZp1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742323488; c=relaxed/simple;
	bh=8WOMcjspCEZFRTakkeGnnFsIIKqkzE4wKkMSz2kMPVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wi7ASxqLCO29gzzQcf8anhtPvk4PG6RayFV2+40h1CMoTFnLjW5MTZ8UV5JugEY1koKT0fYfGX4e6P3x2MNGrilamCPdvH+cMEKPBkjeqhDP8d+d16fGvMpMPJJzsaqx7XMpFhKxQ6pb3oMl5Hgh49k6FbCxjW2saT5j1ERd4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dZYA3as+; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-390e3b3d3f4so3671884f8f.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742323485; x=1742928285; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/74e6taWSnZdXHpVWs74ehYusOf6mHllaULzT1w5Bx8=;
        b=dZYA3as+IAufFI0xgUw5VnKumWtF0LlbbC1npRfzfpj5CS2QDG/kulz57qiDF9ySYR
         TUsF4RhSskEmazVtviUL27M+gl9a5P/FsjLfz9f1OmajuQgAwV/1A6I0uvmtdPJZKqwf
         X/knCgSeBC5Kx0x5SEvdaSWa0yYUdg0eZLkPrAMV9XMzXCQGu6BP8auE9Ax0TiBcOusH
         PDavjx+7EN/7HvOgjP6taVQgySQ8Fv9cXLwXWC8pjXm1OsM5ZF+IEvs7QRXfCmEQmpu9
         UOiLzdhx05jY29+WBEGXOWYqIIZhNh3ZRb6WcbuHdf4d+sZwyrrWI9T8wz+Jzf2+Mr9N
         peUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742323485; x=1742928285;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/74e6taWSnZdXHpVWs74ehYusOf6mHllaULzT1w5Bx8=;
        b=VWybCFF+27I6ujlxJjtX/hGiEnN+TKaU4ltFXi0pB0PJIwexepqAEMDaNhZ8VikvzD
         ghneFSp9VOzCNSI+R+BHHENVlAk5NUOdSS8jR8FMRSGYCTQ/M0vBhRyFM8hia1ik75jX
         24DQK7VWIgJ0E8iw88X2nlFDLrNrMAxrjXZbieuZQZB93rPuBcIvJHv83369LQt2UAff
         BGNccNgU2qwVe/DdDsCOein1/HB3+JXBHXXANjF0qe1pKY1ZzSttBIzMhL3hY3JlzApH
         8SOiy3eZco0VII3esvge5mUsJedJg66ffIE/bZYLyk3q9l4IcZgzhfjKaVUX4leKjQLq
         h5OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLjLw8zY/uzjA1cd/EA2ufHylG66iHQuSnhKLu/HgxfTveFCF3Mv0JC9H9jdSWcklizyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWNYQBNHC0uq/6huNNYOzvM3QLWTG8jKZUl9JSlcBExUj3eEyt
	eTy3smKXzGmQjZbQ0AuvLsmMgfgoCPrrMG+KSKyEg/8Mbnxi5J6XYA4zC1aC2tw=
X-Gm-Gg: ASbGncu5rewc+OfhWfxdbfMp6K/u4Ja74PZoNZ4ZBwoZMLkyZPnSNTrpiWlinBXsoyh
	6/QmLC/KPL43eKiTpZ29YQ8hphed/w2Zx9UVYbU6CfINIF22WMlR/B2TRTnG30szk3SyPmTm3/t
	odbUIKBA4dlJAX0iOmcJ55NLYW1uk5Gtv1JCZX7GrApaCujIocqHWM+DDO8Sb9QFDNeTJrAC2jg
	s4kwDDuhxsHtFOIZ8yx3zcuEWYv3Qnx4GSYB4woCJXXuWYn1TGNSM2wysyjvvcufW0ezCG2nn91
	fKc6cbmElAoyy+iuQrlhWu9IS4OiUVyPG7vQz7Z4019YWoPO7xenmeywkczt0fR7w9UDloBEMpu
	mRgywcTcS2QMnWMa3lqU2UKk=
X-Google-Smtp-Source: AGHT+IFkVGOmrvcSxc0T/uu8x/A0usu2Brk5uUuQYT3z4kvfwm+YufQaBC7XAgOvjeShp7rhcc8jAQ==
X-Received: by 2002:a5d:598d:0:b0:391:1139:2653 with SMTP id ffacd0b85a97d-3996b4a1e1dmr2951613f8f.52.1742323484762;
        Tue, 18 Mar 2025 11:44:44 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318aa1sm19381585f8f.64.2025.03.18.11.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 11:44:44 -0700 (PDT)
Message-ID: <45ded580-5593-469e-bffd-01fab1962b5a@linaro.org>
Date: Tue, 18 Mar 2025 19:44:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32
 emulation
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org>
 <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
 <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/3/25 18:50, Peter Maydell wrote:
> On Tue, 18 Mar 2025 at 17:42, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> On 18/3/25 05:51, Pierrick Bouvier wrote:
>>> Directly condition associated calls in target/arm/helper.c for now.
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    target/arm/cpu.h    | 8 --------
>>>    target/arm/helper.c | 6 ++++++
>>>    2 files changed, 6 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>>> index 51b6428cfec..9205cbdec43 100644
>>> --- a/target/arm/cpu.h
>>> +++ b/target/arm/cpu.h
>>> @@ -1222,7 +1222,6 @@ int arm_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
>>>     */
>>>    void arm_emulate_firmware_reset(CPUState *cpustate, int target_el);
>>>
>>> -#ifdef TARGET_AARCH64
>>>    int aarch64_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
>>>    int aarch64_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
>>>    void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq);
>>> @@ -1254,13 +1253,6 @@ static inline uint64_t *sve_bswap64(uint64_t *dst, uint64_t *src, int nr)
>>>    #endif
>>>    }
>>>
>>> -#else
>>> -static inline void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq) { }
>>> -static inline void aarch64_sve_change_el(CPUARMState *env, int o,
>>> -                                         int n, bool a)
>>> -{ }
>>> -#endif
>>> -
>>>    void aarch64_sync_32_to_64(CPUARMState *env);
>>>    void aarch64_sync_64_to_32(CPUARMState *env);
>>>
>>> diff --git a/target/arm/helper.c b/target/arm/helper.c
>>> index b46b2bffcf3..774e1ee0245 100644
>>> --- a/target/arm/helper.c
>>> +++ b/target/arm/helper.c
>>> @@ -6562,7 +6562,9 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
>>>         */
>>>        new_len = sve_vqm1_for_el(env, cur_el);
>>>        if (new_len < old_len) {
>>> +#ifdef TARGET_AARCH64
>>
>> What about using runtime check instead?
>>
>>    if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64) && new_len < old_len) {
>>
> 
> That would be a dead check: it is not possible to get here
> unless ARM_FEATURE_AARCH64 is set.

So checks in callees such:

-- >8 --
diff --git a/target/arm/helper.c b/target/arm/helper.c
index bb445e30cd1..8377eb0e710 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -11547,5 +11547,7 @@ void aarch64_sve_narrow_vq(CPUARMState *env, 
unsigned vq)
      uint64_t pmask;
+    ARMCPU *cpu = env_archcpu(env);

+    assert(cpu_isar_feature(aa64_sve, cpu));
      assert(vq >= 1 && vq <= ARM_MAX_VQ);
-    assert(vq <= env_archcpu(env)->sve_max_vq);
+    assert(vq <= cpu->sve_max_vq);

---

