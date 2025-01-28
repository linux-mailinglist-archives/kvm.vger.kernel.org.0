Return-Path: <kvm+bounces-36798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7EFA212D4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AB3418858FF
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533391DDC03;
	Tue, 28 Jan 2025 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KHO/1xqi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D586B158A09
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738094706; cv=none; b=BcabSjgZCXnOXRMA+axzr11TWSVdc8fMDTTqQYvk4rGHzmxhHsa9sHPwymGz+VaYcMs4JN8LX89zBY6VJ/mRKo2JQ8XUvB7W1GEBoxnea1afv0FeVXQkkeUrl0bvfF9DMkvQ4F+wNdgBPHhQREZHGBSfYRQnB/RdXtNYLzrLOj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738094706; c=relaxed/simple;
	bh=N0foq3eVLbUiKFb9xKUw8V2PCOXSyuTkoqAE5yLdwK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cD1sQGh6zEfv07pdq1wv19BjyfqLEhovhv4sUjB1eUhWCpUOia03VuiWbCxsAZ4EYzZq/3gqWL/vAaim08xKu/wlSSecMjpZLsjEmkgZ3axV3UGkSpESIkathu9TSjMUAmOIsW3jZCRGEExGjvVTWwkggw+pBOunNOeF2doq13o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KHO/1xqi; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2162c0f6a39so595105ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738094704; x=1738699504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrMURijWdUs+plJn0+O/g599W4J/6E9e0YB54gRpbcU=;
        b=KHO/1xqibBFEjkyUOJNDzROf7Ym3TMRbCDghR91fmYUAl77yIQl4+yGUHv3Tpqov87
         C0G8VkrI8s0ag1BxnzKOt3ZSdtEukRSEfOHU3EacBwqqAhfJP0Nou6sqUZHcRV8FFvJg
         P4wFmhhBbiPAEGbu/98jQ/ddq7vVU5AI3mvFhdcrTYJ6aOip3hxCrZKt3M7iU9R07mTc
         RvlEH4ufmqHTql+yDaFxvQgsoLmpZrq0Ltn9+x9jzLwBWqUKDyYaKsRaMsmZy/AXsPWs
         hUlommWuO0i84kinZXaWyIIDGunmpqlhYIXI72zC+hrOE7LZc0nn8RPif9b/NnwyeI8N
         /p8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738094704; x=1738699504;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrMURijWdUs+plJn0+O/g599W4J/6E9e0YB54gRpbcU=;
        b=Vyk5y31TgltOJtujmLyYLHZAN2NvOZ4ROQ4gt2gfZYQ5jufhWwYNK5Uqppp2uBkOi9
         PlJXrVj9Uv6V0SgadlI/OE6PRdwfWZ7YXF0KJbS5uelu39K11Ztpoi5vG0lxy1OV29Bh
         sHCDw+8cWNA1ZzzMKmv7SeJSDb1yCdbSWYmzPMIB1ZQFBDf0pggGvMbz08c3MA0nRUl1
         sYH5Kg6RvOIZTFPb+/SsWcFpQg5Y13/+HG9x/1LuvBUtxy7VsMWnSp2FGLeh0S14nctB
         7xIttjAzmfBtN365Tcf858hsjlQ2dL87SQw5/BluRl1QWaHehTOm8ICu0RtOeBP/r9iA
         yCPw==
X-Forwarded-Encrypted: i=1; AJvYcCVwpA1sBmQFEDjlo7c4lZEQ0P1fz77u09yqGOAIeCDo1ifaW0YKepYSgKSf3Ga5YA9HyFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCo9lRXINA8fxWTU9sxHkw4kr8sYwpEVx2RSSQeCmbLqvhSO/v
	rH0Az4MJN17IrWP+KuvZtTrDYfZtG3BLBMDCuSnD73EcmXeef8o17BxSRY9+FuU=
X-Gm-Gg: ASbGnct1o4lUwKNesAz6WrNN2c8c/p+kkEzpXr3u0NkILWb34DNHheNWjKY/lvOge37
	gGOiQRtrZ9OP+yoQjtbl0oDqYrJmsj6o/JGoZujzs5ECpF8bfDSEPOoPfgUy2hEi187XoaHgHnl
	Dnslb2bRL6FJWEqNDNz71qKOk2NQ7MHpFBhqCrqDpacEUopUEmXNh25uxuwKJ77bLGo91IVzhMt
	QY0QyAoE1U+pnnCBfTeg2CTLdurSZd2Tn0BQYxDV4htTtn6y3cIXPoDvGuuReVnLn2cmiKjHRjJ
	7fSIVfcxr1DNS27837vaYqFqUCRvrGxrhJ8Qu3iV1rQ9Yedf29uW0uRGTw==
X-Google-Smtp-Source: AGHT+IHd+NTlTxV6KMD27jhD57XSGRNJVXHIytl1bnq1Y790GKKq3cS/lQCgRGc2ZhYqUnxxhOI2eg==
X-Received: by 2002:a05:6a21:1394:b0:1e0:cc01:43da with SMTP id adf61e73a8af0-1ed7a332a6amr964283637.0.1738094703032;
        Tue, 28 Jan 2025 12:05:03 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a69fbfasm9923136b3a.16.2025.01.28.12.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:05:02 -0800 (PST)
Message-ID: <0d743a68-aa29-4a0f-b24d-69ff4725ee22@linaro.org>
Date: Tue, 28 Jan 2025 12:05:01 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/9] accel/tcg: Invalidate TB jump cache with global
 vCPU queue locked
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-3-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> Invalidate TB with global vCPU queue locked.
> 
> See commit 4731f89b3b9 ("cpu: free cpu->tb_jmp_cache with RCU"):
> 
>      Fixes the appended use-after-free. The root cause is that
>      during tb invalidation we use CPU_FOREACH, and therefore
>      to safely free a vCPU we must wait for an RCU grace period
>      to elapse.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/tcg/tb-maint.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/accel/tcg/tb-maint.c b/accel/tcg/tb-maint.c
> index 3f1bebf6ab5..64471af439d 100644
> --- a/accel/tcg/tb-maint.c
> +++ b/accel/tcg/tb-maint.c
> @@ -891,6 +891,8 @@ static void tb_jmp_cache_inval_tb(TranslationBlock *tb)
>       } else {
>           uint32_t h = tb_jmp_cache_hash_func(tb->pc);
>   
> +        QEMU_LOCK_GUARD(&qemu_cpu_list_lock);
> +
>           CPU_FOREACH(cpu) {
>               CPUJumpCache *jc = cpu->tb_jmp_cache;
>   

I can see how maybe this can appear to fix the bug, because one can't remove cpus at all 
while the lock is held.  But if the description is accurate that this is RCU related, then 
the proper locking is with rcu_read_lock/rcu_read_unlock.


r~

