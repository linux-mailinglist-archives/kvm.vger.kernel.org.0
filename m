Return-Path: <kvm+bounces-54773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB2EB27915
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 08:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28516560978
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 06:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5B929D288;
	Fri, 15 Aug 2025 06:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UEMilvep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B2A1F869E
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755239050; cv=none; b=sTp5OKFZ/eEFTHJy/sLRv0eA0+sMpZWQFYCJs+RGSeHYR8/0wyj2QWgl8LAPH9hHggowCORxBB6zX8CfY6Yg5dPmUtEySyVqNLcfl40eKtDsCCmnewB0TEweFjnAheFtHMK6FnbDshBkjIPCpWfayP5ayxFMTXAH+qcjBH1+tZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755239050; c=relaxed/simple;
	bh=ScKVvsig6WgIPKh/CI6bcuHaRGgNEJcl0bsnQfUd2Gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDIL5dw6Gqmum17ptW6+BarotDKz7MlLdfiE8gOYDJnqX9bR4Xr86a3OCjqHD5PImEigicNqKF3qoG+sZTG1GHVx9rQ9pv2I2S4OPniuSsP5+UPrfcu0jPDD3FNLKnUCPHvYKuyuk9mosohs2ONJdIyTsmNNHqewbZF0mMhowdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UEMilvep; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32326e5a623so1572090a91.3
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755239048; x=1755843848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FskWgedQMwIjQLSn2I4gWdMD5wPPB5Uw2SpTiRgRz/Y=;
        b=UEMilvepyP8eVKaXDgMFh0B1eBP95DL1ll3bMJ6rQA+yJiN4/L6Xt/0QPaDSu2iWb8
         QTk8uz8Q+IVYyOZa67B/55xzOoQ5xP2DqduUI/Htjlwlivl8plMQHiuoW9gKPjKsvycy
         xOUYCt3qE48Qq5Y0Iih3kB9wOE4pjp1XKnLAPp+PN5aZuDn2C/SZWr/isJjprjs50HiZ
         30UBGjJDcfMX980CtmDneeP8tjiZAZul3h3nR9Ah9I52qseqkcTBa6nCTL2NRR1V/1Qu
         z/H2jzXTNabB81z8O+kkZFKsnb6x5r3YjJ5fjDEjt2B1r8YMIOqmYQa0bBGP5dtCq+MH
         xBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755239048; x=1755843848;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FskWgedQMwIjQLSn2I4gWdMD5wPPB5Uw2SpTiRgRz/Y=;
        b=sVCQ6iBGLIa6Uhbc3a4GU3N/0jBd2X8MbUca2HbW6I495sxylT8gh7GDAcTYvB8yfD
         0H7QsCWOH41SZJWC85icCMwTRLuwmpNujVxowZNA0PL7i3/bFGvHsatEcUo0C5M2yMbz
         EBcbilb0BIcy6iQ9JH4rkvrSp52iyIDJO0I7sN+Lsi6zlzhnqhLsVpXv1hsv2cVY2f8C
         ASDJAwYvsylq39ivK6W4SfcpfeSxssuTr1TeggU4gCDU7c2feYDdymIq2p2TA5xyRx4W
         sfAwtOVKofSVMb+AG2yK5RqDz1iNo4DzSzKXvywmESIgQFf8HU20eiji3LtANxZ1qUve
         KiQw==
X-Gm-Message-State: AOJu0Yxqc/p1h7rINmZ3zC3h0m8fH6HCmfzTzixx+DbpKFM/NI7qPBmH
	C5SqmabB5A4ykhfqzGJPAGtFMSSescqN289G2RMD2mOpzupqVs53t6XURpRpUIWBeYY=
X-Gm-Gg: ASbGncsx4qRlOGbzedx1XkGauM5Sh3ZncuIbyBjIT8kp0SjZSTX1YMCFq3vLHh9694D
	7mySMaxutHundIHUg2+RO1nijOam08mAX77C0QxtN7B376aUxPboAHj/Bugblgk+KQbTybVg3gC
	c/9pEYYL/qe7IZnLyiStoUc3hyGYKbI2WQvjrMvjEGOl7/s4qn8Wl7loYoCccVcAL3ap20S9SV+
	hgnFr947UTnZ8KrLNu94UgZM1JTnW+g413MSLkms1YAjcjHwIggSPioJDRs1UGREGFJK9QOrlRq
	NPpw941Gj2ZNikl5c66EqKT9unav4VO7ElCJ/DWdg1xSzBqUUDqEkFmNfMjUoDDI4gyvT4fqYPv
	WSbZiy2D8EfWiI8SdMbNpxPQSmzYWM3GGD/OclQI=
X-Google-Smtp-Source: AGHT+IHVFl4Kj2QNdtIdOlLMy7ekNRtlzsuwoey+jMec9PqBBBCK98thjJibLHmmJPKg7NxVmELe6A==
X-Received: by 2002:a17:902:c94a:b0:240:9a45:26e6 with SMTP id d9443c01a7336-2446d6e8a61mr14127065ad.10.1755239048290;
        Thu, 14 Aug 2025 23:24:08 -0700 (PDT)
Received: from [192.168.4.112] ([206.83.105.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446ca9e000sm6904455ad.27.2025.08.14.23.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 23:24:07 -0700 (PDT)
Message-ID: <ee8abdcb-de14-4ff5-b454-b60a454c4740@linaro.org>
Date: Fri, 15 Aug 2025 16:24:01 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/kvm-all: declare kvm_park_vcpu static and make it
 local to kvm-all.c
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20250815053021.31427-1-anisinha@redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20250815053021.31427-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 15:30, Ani Sinha wrote:
> kvm_park_vcpu() is only used in kvm-all.c. Declare it static, remove it from
> common header file and make it local to kvm-all.c
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>   accel/kvm/kvm-all.c  | 3 ++-
>   include/system/kvm.h | 8 --------
>   2 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 890d5ea9f8..41cf606ca8 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -141,6 +141,7 @@ static QemuMutex kml_slots_lock;
>   #define kvm_slots_unlock()  qemu_mutex_unlock(&kml_slots_lock)
>   
>   static void kvm_slot_init_dirty_bitmap(KVMSlot *mem);
> +static void kvm_park_vcpu(CPUState *cpu);
>   

No need for this, since the definition precedes all uses.
You can also unexport kvm_unpark_vcpu.


r~

