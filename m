Return-Path: <kvm+bounces-38383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97176A38C5E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D463D17113A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D7823716C;
	Mon, 17 Feb 2025 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="whmQExen"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD19224AE4
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 19:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739820524; cv=none; b=hrwGgm9XSPCAju64rtWA4FGcLR/XBJ2UADfd+nowsLmG4j7+V+766QJNfWkgeIkxUQAnVaHZzDvs0RJanRqOnI7guen6yzyQNPn34RGCCxkXxsYJgAtgAS5Dvgo3dIe5lnwmG0cFAz20gdt3rnihX0D2B/sVQjS4c/WJRcC4SiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739820524; c=relaxed/simple;
	bh=klHUVRc3O0NQSirtRo0jmBhjiT7Ts/IRSy4Ui5YcglM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLzBcVsqC5MO5w2ru2RNBQiZy0L2083Ik1+5Hj+Bwi9yO0FQ+uV/mS+Tz1vmxIUDANZK3AwZmNalYimw/3XxT8fYZJdss4JTSP8JCYm3JPkzdGhYb4+bczfi4Y8wJwaLX6hPH3cVIpqxhbtzC4pEr2uSwIOoTAP9Utl10HO5s6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=whmQExen; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2210d92292eso55068155ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 11:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739820522; x=1740425322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VEJ/B3GBCyQg1NZ8srPFvpNFWpxr50mPaKhI69Ppxgo=;
        b=whmQExenPnwH4S2raaVrkBq6Ca/1n88gGbM+dPqeZGh7saZVzqHxej0xMi8MTdpgni
         sv7D1k8QFKWL4G+MqwRdqn/hz3G9YZhlC3PksksJsiiC+YIj3Hp6i1/oNBba8Wbqk89G
         2lKNgV5kglDh6lAzSfgvp2IbgDeig5ZAVM573phiT7tF4oPMGAT2j6dNesN9HoeP/6LS
         XFXFv33ReERwWuUyleHNyyJ8qLAr0tFrxD9vnOgzeFRR4/BFaKAlrzepEOn6IYaHFIl5
         M5KUv+Eu/p7SNlbHP4N/Apo+9uHC3DZTA1zSMVW3t8lSBQywpvfpiKT+aJuT1ZWAH0IJ
         wdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739820522; x=1740425322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEJ/B3GBCyQg1NZ8srPFvpNFWpxr50mPaKhI69Ppxgo=;
        b=Oeoz0MANLZMhFlp2LBlB7ZvzPziKqckDxoNFXQUP3JOV3uRfXUr5ez/k/Emizp9QCm
         6R7gCwLE1OE/N2GKlDdcuG6Zw/rfi0S7Uyb9NNekz50C91+M2RvjQoit9hzS3rZu+tTr
         PnlXULex20lHpuXjUkF/0e7hOIlgRKVReSXmkPbx1Y6qHAgbr78ZXJjDHTCLHSS0fqIz
         dakoEFAvrVkA5z+3d3Jb7/jDYGj+agbQMP2Xchc5a+DKTOahf2qtCBDXsB+srP1afgo3
         OyD5r0vLUIWTXi+1fmN+lv4EVRyFy6LVM4yh2xwS0DjLTSkOX0K4X5AId41Th8ZEM/Dn
         CQjA==
X-Forwarded-Encrypted: i=1; AJvYcCVtSB36cs01ElL44it7XfqntH8PcV7J9196yz3Cd0z0LI/cq6e5sQ1DpCd1I+gEy3CAIMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxRUJp0jN14av+6ZrDPpzRj6NQnSIHrx4ETcKwxINDrFmqrb/J
	FzwLjbygphpj8ftDvv4cIWDkm1nVJZY7kgYvwXGjCqHJ2AO4ddCouSaMrlSI5lU=
X-Gm-Gg: ASbGncs+XhAZCSPxwk1EdyVpQI56WpC0ErRpoqZYfpUoiCj9/BBoeFdgcQ1WNJIQlhd
	p2My26c/ccJzNnyueBc/ekofUm8F32AOWw260W638eHnZxcUg+8gX3c5GJgTCEgKey6qmI3bKqn
	HIAbrdcNungeXRQ5WGz5ottYjAP4uBwRZQq6A02KVZI6R2snEnaVmQQvxuFwD5DGr4lEOn4q2RI
	bf9TGeWUety8MjkR7CYgkOFlZRX2VQ+lVLgumjrsciHe7hYO3hgN9+2jrVxtQUP+HrgL2LVD2dY
	kepO0ma88qFMt2ktXU9WicjVCS640OuVgmFSj6m0y2xPkF5VzbKHB/U=
X-Google-Smtp-Source: AGHT+IFw9x3ddCLNhBbl16dPCQzotblc4ykNeeWquQsvMRT1NjsLlII2PlFLuCRaJQswwJsL3MPGMA==
X-Received: by 2002:a05:6a00:2e08:b0:730:74f8:25c1 with SMTP id d2e1a72fcca58-732618c0351mr14386201b3a.15.1739820521870;
        Mon, 17 Feb 2025 11:28:41 -0800 (PST)
Received: from [192.168.0.4] (71-212-39-66.tukw.qwest.net. [71.212.39.66])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242568a0dsm8436448b3a.43.2025.02.17.11.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 11:28:41 -0800 (PST)
Message-ID: <3cf6d45b-0d0e-4669-954f-a545f3ec1a37@linaro.org>
Date: Mon, 17 Feb 2025 11:28:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/20] cpus: Restrict cpu_common_post_load() code to TCG
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-17-philmd@linaro.org>
 <e52485c5-122a-4a95-928f-08fcd17cd772@linaro.org>
 <a8be34a4-c157-4a5f-99bc-50c87c1330b1@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <a8be34a4-c157-4a5f-99bc-50c87c1330b1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/17/25 09:19, Philippe Mathieu-Daudé wrote:
> On 26/1/25 22:16, Richard Henderson wrote:
>> On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
>>> CPU_INTERRUPT_EXIT was removed in commit 3098dba01c7
>>> ("Use a dedicated function to request exit from execution
>>> loop"), tlb_flush() and tb_flush() are related to TCG
>>> accelerator.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   cpu-target.c | 33 +++++++++++++++++++--------------
>>>   1 file changed, 19 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/cpu-target.c b/cpu-target.c
>>> index a2999e7c3c0..c05ef1ff096 100644
>>> --- a/cpu-target.c
>>> +++ b/cpu-target.c
>>> @@ -45,22 +45,27 @@
>>>   #ifndef CONFIG_USER_ONLY
>>>   static int cpu_common_post_load(void *opaque, int version_id)
>>>   {
>>> -    CPUState *cpu = opaque;
>>> +#ifdef CONFIG_TCG
>>> +    if (tcg_enabled()) {
>>
>> Why do you need both ifdef and tcg_enabled()?  I would have thought just tcg_enabled().
>>
>> Are there declarations that are (unnecessarily?) protected?
> 
> No, you are right, tcg_enabled() is sufficient, I don't remember why
> I added the #ifdef.
> 
> Could I include your R-b tag without the #ifdef lines?

Yes.
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

