Return-Path: <kvm+bounces-41769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E941A6D0CD
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 639AD1893881
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E7A1922C4;
	Sun, 23 Mar 2025 19:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xwkmpuPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E3136E
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742758507; cv=none; b=KiT2p6yWWTM2PtbMdnO1KpIOTqulrzsRgUwwdkIH4SmT/BKpXzMHAHpjKyeQSTUHheGgKfZ0pI9XvP1IFLNzk1Kw3mzrPt1vkQPp8lLbMM5vuj1j4YOlVaqt4WQBKcqOoeAILvBKgWUY6WiCjNKmOqiTh8oShPHcPkSiHnMdOdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742758507; c=relaxed/simple;
	bh=9EYZ2b1ShV+/b6OaksHWrXsL6/HLJ4MMe5e6SzIK3+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ga/WSnoznGF0Kwugm/5pg7JisaIepMAusOUDy0Z7YBdcLvsd49s4BZCAsdtBpOOyyFHeigyfdLKmjZFrc+ZHqbyyXDab6xEY2PyEpX3W+ekYs9zybV3I9V6++fH8sCZnoNXStMU1cMoc53TtP/pwcms00+1rT1jPRyzuh6k6ZEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xwkmpuPa; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-227aaa82fafso10159475ad.2
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742758504; x=1743363304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6uFHprcikhpymWB55yCpTb6bdCmVjwgeavCcPBcr96U=;
        b=xwkmpuPaBae3IY+EHsudUAYunZ2mbWsPQ8oKbFWkR/rCdh8LvTWfE77xbr9Vnz91lT
         5qZ5l0/1F552NGlwAsUBiP/LdAih+Oi61FLMUq3ulgzmXiygq3su1ubz08y9xd/3QhZH
         +e3JqD9u6wY/YHQugJLVogR3B+ZhKkj4YLsWdvd0MxqGzPlN5SO44cXzCtm6XJCRmOpo
         7/JPhO+wQLcMCQHR6GjYfUq//LxDwiIy/yY7/Bkj5Vu8nMhdCfMIWryt+D8YvCxVkPtP
         9WhSo7dX1J0NVCE+sppc2jc8jqdROJrUGjZpg8Z1HnvjLZHBUmbP4XFYqzQSb+Ccc60L
         hDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742758504; x=1743363304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6uFHprcikhpymWB55yCpTb6bdCmVjwgeavCcPBcr96U=;
        b=rBJQBxt9J8BzjBHRYrZJ9qWrM70JDlNUJKqGXFBr450xtxpgImPfiE/ajISeV0JhAr
         jhKtFwvh6o3P9OsduAZ4qT9ZLFCJeufX3jMpYrmkC39d1RXij99Ft11d6pNlQyg7Ue3e
         AouweKcr4UGdLRODAqRvt+cdmVKvczyAxAq71G9EGDOkv5aoUMbpvGrqympct2UnJXkn
         kMhnqztxrSRTuLcnk7eMGW5G7PidJeRfuHhMR/9HNfrqGtqKBSyot9B7hgUyPx+t1kCb
         gSAOPOGH+zq7ItyLmUOLlMFpJD4g82uzzGycl13lbHa9MH/WPx+acrW4b0FutNcvkqWo
         rObA==
X-Gm-Message-State: AOJu0YzZikU6ywrWEboI0yCDHvVmAFLEu/yXZkxjaLA/NIkZIT0rZxOc
	m4iG6Hoxc8LVf1qqsM9nbEreE5Cl5uUdFVsCvKTENcALAlS32ktfqB9QaOihDS4=
X-Gm-Gg: ASbGncuZ78hthfxVVlzzLfqyDNz9/xbeT6OQ9ME0weCvLu1Npw0nGL0I2/W2ZylR/X0
	KbRm9YSLI8YcdZsR8GG4QzRZLxGeKqipSiX+9uglJNHqPXIYnrrMM8mi0tnEwRRKrT3ByAROx6r
	/epuNNM4x/nJUCvIb/iD7aRyQrhYPjLx65ZYHit5pHTQ2yQBZ3rMeM+FIy7FdrBa4GAlEcEv85c
	wlBa93n/dLQnwispeBvJJmqT9BvxJRHVZmbD+aLAtm+/OePqdCb167jtH/qeOhhmP3/46Zxql/F
	wPfoPl3saW3dpZU+/wTmOvM8WSS32kGA0fKuq4USfN5V2sbA0nMxEeTcMIMHHf4t0fbc1EpTSws
	aD7ygEo3q
X-Google-Smtp-Source: AGHT+IFgRup02ALEGV9Up4pGVIChVj4UQbwmHiBRpSmtL1xVI22i/KImHDNBG1uslaG2Cps0De1PoQ==
X-Received: by 2002:a05:6a21:3a90:b0:1f0:e3df:fe1 with SMTP id adf61e73a8af0-1fe42f09148mr16939001637.4.1742758504266;
        Sun, 23 Mar 2025 12:35:04 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a27de717sm5639598a12.12.2025.03.23.12.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:35:03 -0700 (PDT)
Message-ID: <4586fe00-2be3-4d99-b681-5463058f3922@linaro.org>
Date: Sun, 23 Mar 2025 12:35:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/30] accel/kvm: move KVM_HAVE_MCE_INJECTION define to
 kvm-all.c
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-19-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-19-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> This define is used only in accel/kvm/kvm-all.c, so we push directly the
> definition there. Add more visibility to kvm_arch_on_sigbus_vcpu() to
> allow removing this define from any header.
> 
> The architectures defining KVM_HAVE_MCE_INJECTION are i386, x86_64 and
> aarch64.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/system/kvm.h | 2 --
>   target/arm/cpu.h     | 4 ----
>   target/i386/cpu.h    | 2 --
>   accel/kvm/kvm-all.c  | 5 +++++
>   4 files changed, 5 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

