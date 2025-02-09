Return-Path: <kvm+bounces-37663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA08A2DF96
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 18:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B65A5164E6B
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 17:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5701E0DB5;
	Sun,  9 Feb 2025 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RG8OdrnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C691DFE00
	for <kvm@vger.kernel.org>; Sun,  9 Feb 2025 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739123320; cv=none; b=cCiWaKM4CPwHYTo43P0RV9HnD4uaaxDwN7Y5z48F3kGRoTTYw0s6CBOEQVFIhpVUUYPeR5Xyma7WQCrKoOY+BB/XzqUpB4xTi2xBwjMtWWjxyrrUYqqU8879YWa8OAWVn1p2Ggeo5fA8ZJg032ypfb35wKqy/mBC5xyRvoBIoZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739123320; c=relaxed/simple;
	bh=l91+mvCak/nBr6+8hY5mpT8OkINcUCTgVN9pT4tRgDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=au1w8qLxIX3Vb+bOm9NAuSRj0m1X9n8rEr9LEvd725aREDUFHXqWab5/6h/1IBgr9nxkYOs1C4IzwTL8FBVdVmgXrbrXxsfq7PANrs5rAh7coRjFSCT3GC2dh3XQ6oIM9YJCoRBWNlFICakflVfNroUoVx3PMDRFl1Gz0zBY2vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RG8OdrnX; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-438a39e659cso23902065e9.2
        for <kvm@vger.kernel.org>; Sun, 09 Feb 2025 09:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739123316; x=1739728116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MfUfwyyOf6ikTKqC5ppl2P595P0uuLiq/UPwbIU/2wE=;
        b=RG8OdrnXVRrcZRsNK92q0C6sNgBE52ASY0oMa1ywAiqtx+jU7ruhhZxh8JcyPHrAWM
         hL6I4qzM31WtagzYJVSIp00PFttJ9YYT35fabi1Zecz0tstpt9zHZ6lu3w045PXxDxDX
         lClASlobCfkkKRoYuTvwsKWgU7yf8grR4krNe4/6mdxhP42yIY0T0uQZbS49ujGphOeD
         J+aZllh5JKa6mg0ySNWcay9bezm3HPklaO9cBGza3F/+KcbQan+o4DJzaXQGX1awpvUR
         0d//+PQQ4yKyNdxQEH2YFE3u8G2ocy2iG/d8zBLDp/EwJy1T/FAJZqotnWXSy1NwGjWF
         +H+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739123316; x=1739728116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MfUfwyyOf6ikTKqC5ppl2P595P0uuLiq/UPwbIU/2wE=;
        b=hFF/RRnMN1OY57BH3Ve/kAWOMrkyGDk/QWk8cZNQqr2IMW/syEaKjLD+VdrTJ98gwl
         1IRfHGhenyx4myFrihMxGAKC1Cp+ve8K25k305I0B47xhSFKgWUl7ViZW1Tn34cWG7SO
         rnHepYrhbc6fsxN695wBWO9eRkvYdYa41Mz65ii6Nhh8//uodJID5/qcY8dI0LcI/C6Q
         k7AJceKWvMQ1sHOtb0NtPGxeqHmbDfEVRXQCHTRIANGKTDU4LtJG6IOMm1nwlIUsKa38
         FX1YqWe/fYvqAj9ZmpxwO2aAkKxVIUx1CCggPin57VD0vLxIUtWwl4leFqrMOwjE1k3k
         wepg==
X-Forwarded-Encrypted: i=1; AJvYcCUBM23WhNKzPmnNvtUdgadZ9jIKDbRUJCcDmJe3THTuKILGRWXwa2rt1Tx9NqhaLFEai3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSLdZqparRfstWgiSzQAjfggysVtKt6u/yWVR+UNbNgGcVRIgE
	lhPAUoAQvKvgdK9H3SaWiD01ZKIVKYfRrAzCeheLh9SACe2gtT6YwxvnjBCBkMeFi47WPPNyRfA
	hm5M=
X-Gm-Gg: ASbGnctiK2+C/DwrN6remWfEk/iYPgzCxnhBV7gLZEps7w4nTH01AKpMSjKsXWoDEOk
	BBP39oPA+tR7P5eItZnFfITYSslesRS0+B7O8tf6HiG1kHV4oiPNp2+472ZRUE9PbITVCn3+8kJ
	gGOT6ZxQKOrjoPam3Svxm8ooNqg+jWo2Ir95a+vCr21urVCsCK1jGaBzOAFMZrjvrtCwrGPtxNv
	zt1HdCQVW0rKwQBRJLVxc5+pBIMYY6EauLdg21NtsRtNmewa2mj63WGik1lmzqkJWVKSXwDPtiX
	rjQkfWv4zUrhj5YcIjlRVaZAFsJz5kBkxgtWuozhmSXrzQ0E6bM1ZvKY/ZI=
X-Google-Smtp-Source: AGHT+IGd/XDb34EkKfmSFZhWJPhrnA7A7SmQh2tvM08VpfMHBBzMH15Yi4MnSVh5ay2LnzkfnAYyag==
X-Received: by 2002:a05:600c:895:b0:439:331b:e34d with SMTP id 5b1f17b1804b1-439331be5aemr46083675e9.5.1739123316433;
        Sun, 09 Feb 2025 09:48:36 -0800 (PST)
Received: from [192.168.69.198] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394376118esm10137065e9.40.2025.02.09.09.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2025 09:48:35 -0800 (PST)
Message-ID: <62ad5a5b-9860-42dc-a4f3-37f504f3ded6@linaro.org>
Date: Sun, 9 Feb 2025 18:48:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] target/loongarch: fix vcpu reset command word issue
To: Xianglai Li <lixianglai@loongson.cn>, qemu-devel@nongnu.org,
 kvm-devel <kvm@vger.kernel.org>
Cc: Bibo Mao <Maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>
References: <20250208075023.5647-1-lixianglai@loongson.cn>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250208075023.5647-1-lixianglai@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 8/2/25 08:50, Xianglai Li wrote:
> When the KVM_REG_LOONGARCH_VCPU_RESET command word
> is sent to the kernel through the kvm_set_one_reg interface,
> the parameter source needs to be a legal address,
> otherwise the kernel will return an error and the command word
> will fail to be sent.
> 
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Bibo Mao <Maobibo@loongson.cn>
> Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
> Cc: Song Gao <gaosong@loongson.cn>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> 
> CHANGE:
> V2<-V1:
>    1.Sets the initial value of the variable and
>    adds a function return value judgment and prints a log
> 
>   target/loongarch/kvm/kvm.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
> index a3f55155b0..3f499e60ab 100644
> --- a/target/loongarch/kvm/kvm.c
> +++ b/target/loongarch/kvm/kvm.c
> @@ -581,9 +581,14 @@ static int kvm_loongarch_get_lbt(CPUState *cs)
>   void kvm_arch_reset_vcpu(CPUState *cs)
>   {
>       CPULoongArchState *env = cpu_env(cs);
> +    int ret = 0;
> +    uint64_t unused = 0;
>   
>       env->mp_state = KVM_MP_STATE_RUNNABLE;
> -    kvm_set_one_reg(cs, KVM_REG_LOONGARCH_VCPU_RESET, 0);
> +    ret = kvm_set_one_reg(cs, KVM_REG_LOONGARCH_VCPU_RESET, &unused);
> +    if (ret) {
> +        error_report("Failed to set KVM_REG_LOONGARCH_VCPU_RESET");

If this call fails, I'd not rely on the state of the VM. What about:

if (ret < 0) {
     error_report("Failed to set KVM_REG_LOONGARCH_VCPU_RESET: %s",
                  strerror(errno));
     exit(EXIT_FAILURE);
}

?

> +    }
>   }
>   
>   static int kvm_loongarch_get_mpstate(CPUState *cs)


