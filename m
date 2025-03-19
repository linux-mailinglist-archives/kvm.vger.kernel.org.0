Return-Path: <kvm+bounces-41477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0360FA6856C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 08:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D82917564E
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 07:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5A6211711;
	Wed, 19 Mar 2025 07:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZbcOX+P3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83C910E0
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 07:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742367841; cv=none; b=Z3vspIjEMuqxLnFe6rNST/mC+qcWedeUv/ALtxmT9EMO6mv6vKb8HlisvXJ6NhVenIZSFrPyyCqyVNLNQZnXAiuDhzpSbA/NQXkrVTn+pZRTjV2Qd0sO1JnxRwQF941/sacuo4L1fmB35zG8mSQabEjMid+yb46srmMtdsJQ7Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742367841; c=relaxed/simple;
	bh=hO+Z2StPlMZ0VFGcpdtU+ukb6hiUDrkrDHBibuMtABg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZO+B4tsZB2R6SOtCgUwspmO4dIKHXmENHVfzNjc9TvfeCQF3VLmcZ9qX+dHcWYyPW0aw5UYKqI4vRTrrmV8J1St7IRCwBY6shfVPC9fvFnLSwyHJs+Mi8iU/fmcqrTbEYqpX7gIUxw4slcGVLdTSAhx3JK2mRx+dOK2VquWH/Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZbcOX+P3; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3996af42857so215838f8f.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 00:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742367838; x=1742972638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7fzQMjdihmdHdTMPhZwn9J/dZihgq/4Rbt5LNPXzbk8=;
        b=ZbcOX+P3rUudw/u/NBK65CTNjWALzSgnHgiy7RSjRj+36kbWdMmV2/EUDmq+5t74rC
         KUd4IJMyNcMg+9WVrqQTF8CbbiS6XWcyDJe9UYlUrdo6lh9favk1Ab77T7CQrk61ijAH
         lHLyLtt2dbB7bdv5rIwMwlDQZKRkQ3x/QnieJQUrZg8lddHDCDF/r0soAliiLizXYVf5
         1yU+iLneGaMJEKmJW5xfaIgVBFPHH3UcZ7RQudi2R0zDPrrY350Q8p6wdAMQLh3ZZwi/
         a/49AIbfgWe7CkvFRsW1JjaSJ6AU35XeVNawg06AeVNZ7J0PvU5Qr8odCame8v8x04D8
         qOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742367838; x=1742972638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fzQMjdihmdHdTMPhZwn9J/dZihgq/4Rbt5LNPXzbk8=;
        b=DVkBZEwgFEV1ddk1K0hQ5YYocc2fojqHp7/pXPd122mDS7uXhe3J8NeTUh9o6es6aM
         8KNawm+lh9O4C6Ta3bZMA7360PUW0v2VtvpB3BEknS28pYLH1OsNQ5gDtr+2/MUEWhjF
         YxYs0ATst7z4jeL34PVdh1VkMhPsILKBA4+d5Nfb1T8f+20oplamrU400WNdluvjOsvK
         UkKv10nm0xmqITAYY5zVaFSgb9cqhPGF+cyWxyu0Q2KKzs25aA7tSIPzJDr+b83wjnud
         /vv4IVqlyupN2BcgrRfY3QVASec7ODw1gLEp1aKNKT26BgmvjVJQoam+Zd2k0HWuCbqb
         o4pg==
X-Forwarded-Encrypted: i=1; AJvYcCXyh2njH45QOzjDRQZ05Hcj2IZRD4jij+Wnrss8kfMuY6NfMzDb1QyW9eq/g7rRd/BBtoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw58k2e5riCQgQiOUfDQuMAJO4SIGaVExntdLz7SMnO6EJyZS1M
	RISIktV9ro35KtoO0Rwl4m9Rz4uxT9IIzRsJ7TSmG1yhLUAe7hyDdTAPHurwVA0=
X-Gm-Gg: ASbGncvMIkb8KZvwPjZY3oHn1auueLvStGAqovLW1JWy5vRW9ZTBbyk82OdLUXs2N3T
	0UAVIEJt44LOYWlEK/c2Bo3O/wsSj9QXqEhiNWPacdHEcUG/n0bS9QRY7T+REceWPP6QGFfpIbp
	6ZvqwONuDaf5GStJjxki4mW7yqkPxk5D8vr8YZM4Zh54mnfv8kB9MMJ8CrFSCI7tI5BnB8ElI75
	VRfbyYJ8Wk8ypT2RUkjenI0TXGVVfKSb1VcbHsiIKIclZI1TdqjPHS1mIFUyeK+7MkzWB1k7IOc
	OqH2r0hPqvE2TZ7kylW114Y7TDGkx2Iantpgd8lecZO6CAXgy8W063ZTBAY3uR9lpoCMkEsDu3b
	lmNV40fbGxU0z
X-Google-Smtp-Source: AGHT+IGZ1OYYU+hacx0hWCwMirBGV2FRtf+/lifMq6+bgxTMfGuPKE3k3/xaTQ/8RTztiUkGX9yLLg==
X-Received: by 2002:a5d:5f93:0:b0:390:ec6e:43ea with SMTP id ffacd0b85a97d-3996bb51f57mr5507704f8f.15.1742367837893;
        Wed, 19 Mar 2025 00:03:57 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c888167bsm20067597f8f.45.2025.03.19.00.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 00:03:57 -0700 (PDT)
Message-ID: <52c8b6dc-048c-49d2-b535-4855b9f3d26b@linaro.org>
Date: Wed, 19 Mar 2025 08:03:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] target/arm/cpu: define ARM_MAX_VQ once for aarch32
 and aarch64
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-10-pierrick.bouvier@linaro.org>
 <a88f54cb-73be-4947-b3be-aa12b120f07e@linaro.org>
 <52000c3d-827f-4e21-afa3-f191c6636b9d@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <52000c3d-827f-4e21-afa3-f191c6636b9d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/3/25 23:02, Pierrick Bouvier wrote:
> On 3/18/25 11:50, Philippe Mathieu-Daudé wrote:
>> On 18/3/25 05:51, Pierrick Bouvier wrote:
>>> This will affect zregs field for aarch32.
>>> This field is used for MVE and SVE implementations. MVE implementation
>>> is clipping index value to 0 or 1 for zregs[*].d[],
>>> so we should not touch the rest of data in this case anyway.
>>
>> We should describe why it is safe for migration.
>>
>> I.e. vmstate_za depends on za_needed() -> SME, not included in 32-bit
>> cpus, etc.
>>
>> Should we update target/arm/machine.c in this same patch, or a
>> preliminary one?
>>
> 
> vmstate_za definition and inclusion in vmstate_arm_cpu is under #ifdef 
> TARGET_AARCH64. In this case (TARGET_AARCH64), ARM_MAX_VQ was already 
> defined as 16, so there should not be any change.

I'm not saying this is invalid, I'm trying to say we need to document
why it is safe.

> Other values depending on ARM_MAX_VQ, for migration, are as well under 
> TARGET_AARCH64 ifdefs (vmstate_zreg_hi_reg, vmstate_preg_reg, 
> vmstate_vreg).
> 
> And for vmstate_vfp, which is present for aarch32 as well, the size of 
> data under each register is specifically set to 2.
> VMSTATE_UINT64_SUB_ARRAY(env.vfp.zregs[0].d, ARMCPU, 0, 2)
> 
> So even if storage has more space, it should not impact any usage of it.
> 
> Even though this change is trivial, I didn't do it blindly to "make it 
> compile" and I checked the various usages of ARM_MAX_VQ and zregs, and I 
> didn't see anything that seems to be a problem.

You did the analysis once, let's add it in the commit description so
other developers looking at this commit won't have to do it again.

> 
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    target/arm/cpu.h | 6 +-----
>>>    1 file changed, 1 insertion(+), 5 deletions(-)
>>>
>>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>>> index 27a0d4550f2..00f78d64bd8 100644
>>> --- a/target/arm/cpu.h
>>> +++ b/target/arm/cpu.h
>>> @@ -169,11 +169,7 @@ typedef struct ARMGenericTimer {
>>>     * Align the data for use with TCG host vector operations.
>>>     */
>>> -#ifdef TARGET_AARCH64
>>> -# define ARM_MAX_VQ    16
>>> -#else
>>> -# define ARM_MAX_VQ    1
>>> -#endif
>>> +#define ARM_MAX_VQ    16
>>>    typedef struct ARMVectorReg {
>>>        uint64_t d[2 * ARM_MAX_VQ] QEMU_ALIGNED(16);
>>
> 


