Return-Path: <kvm+bounces-51509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46337AF7EC5
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 772391CA5128
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CD628BA9A;
	Thu,  3 Jul 2025 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EsiiU/SV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1513F2F0E27
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751563273; cv=none; b=ioDTLDaHKEiPhhVJhZGeDLJUtBa5rKbyYhu3hS6SrfEk3ZJOg4fv215BIwSILsYqZI/rqs+zI5+Hei3B5u1wvJQq3TSx3BzZYpqHNfxy+0KRLgnK0m4pRhn5f1VHUtDxhkE2FWbBnZUgsyH6bJXqZJCAT8/yz6971IAXxr9NCBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751563273; c=relaxed/simple;
	bh=s/9QLBO8F9DttLtacjnPON+TVkQXfJWV2o4U0mOX720=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OS6655vTZyttCLHSUCh7++IB45B1iL/49iwq2kwUPBCPhvXzYs4UuFelOVvUhbCH860QfPZsN4LRtRZRY96cCAdBzmlFmPY7eak+YU22RkyYcIO2v3c/AoCkBIt7JIrWacqauXXntPuIQQ4iQwCB7mk2NRTm00662sB/XdQprD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EsiiU/SV; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2ef8df09ce9so110769fac.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751563270; x=1752168070; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NqrAfLoSpXy32SZjGkLSj0+5pbZu4fxfsJ4Y6XSk3jc=;
        b=EsiiU/SVIts5kYb2l688W1+Z4G9EMr8Xa/p7bRGfiaQ+d77k7deOyXXVODIo6ierFU
         KMPhhgSxPo0mfakYjtd5rHPm+litOObnkFIUfLIUBg524rmU5cAo52Z6iS5owCJ85pmL
         F349gJAhWVmXLUTAeAixMo5MNG8uOHArwG44C4xmDWvFXAXdI8j6zRBXvI6Y3hjhZho/
         9wFBQheN8nJWs0xdyXForFfryMAX67ZbGzjbzdB7zjq7rJMIg6hy3hQVeYQW4D4X5Dxp
         AdaPaJykd/vDapF0Vj28cEgqK+P8R7HNqJL2Aya3CFKXZz245bT2qZG1/Js1H5uiOAvk
         Djhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751563270; x=1752168070;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NqrAfLoSpXy32SZjGkLSj0+5pbZu4fxfsJ4Y6XSk3jc=;
        b=KOp91Td/GeAvodHLgoKC2mDuNHfMo6YuVxfWzxawNMaNcE7pP0LC/n7yCJiq01NARs
         cAVJkKiP0Ld8OA5ZVv7QaTjD60ahXU+zIeFZAU0NjRLWUsLjK1Np9xlxpjmAyYoUhcNR
         kdAzk8Gm0RTawq7sEKgOk4Ew70PGYbz7erl8Vi9I0PIJU4GGLHC6N0wXzhuQBiOng6ma
         AlaFBQlgHVi2o9AkcE7gaA97LWTqElMKkHihMu/U7lllzy/ybdnvyRXy3i2Vi8dX7tgc
         lzhi9fFFO4sjueS90It+E2Gr7xj50sxs6kdPH6I8Uef6ManOn00S7q8+hhJZoq1RIloQ
         Zvqw==
X-Forwarded-Encrypted: i=1; AJvYcCUKie+lFju0ZJYWocosO2tU2UOoQewiaVxwZVIgC0K2G8Z+Y8hl14cCKgPw2wMpAfN9D00=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZvsDpqV8lcJ9Pq8HExjC11l0/aeLtnpXlrRAdRwWUW+lp6alW
	khUCZ/f4iZa/Yf/rZIbFRL8ujzrG5Oo2oH5epR3X/gilkeF82CbiX1+dqcNK6gS9HfLkw7duVuM
	dDBJAyLw=
X-Gm-Gg: ASbGncsLpXLfviMlEU/mtl/BsSPoTf6BbHVhjcAJVCcRRf1PR6HwqNn6HU3+/chtHH5
	Beimi48xKcWRJEeiMjCFno4ylkRItJ5YX286ffm5lHmnYv1MHYYG23BaLQPcrrgpl6NoyQqK0Ud
	ifjaNlByl1mbHVJtd6PeWiaGivgJo1ew9JFEYS2fx3FwWhOekIAnBqtlMjn8hIlmCfY9bLv9zqS
	mUnIeD9um9vXeRIbIV990md4iEeYLJauI4n3u+bjPsgbEyLDDCf5YCxP3lCCykZgu8A8lX3EZmr
	3m5yjcrg9PtPpYNY7ZYRgiIkecghS7UUMAFSZlKUo4XeKzYCxFhScKyHtzIMu3BDz1CTGjzN9qd
	u
X-Google-Smtp-Source: AGHT+IHVZ7jMsIA9AwgqIo9DR90LBVuf615gjC3zVyIg0CTl3+dcwQRj3+3jhUsv+YqHMjpEXeChDA==
X-Received: by 2002:a05:6870:6f12:b0:2e9:fd62:9061 with SMTP id 586e51a60fabf-2f5a8c83c06mr6205946fac.32.1751563267853;
        Thu, 03 Jul 2025 10:21:07 -0700 (PDT)
Received: from [10.25.6.71] ([187.210.107.185])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2f790209b9fsm4002fac.37.2025.07.03.10.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 10:21:07 -0700 (PDT)
Message-ID: <613a2591-d26e-4698-bbc6-38f5719c59b7@linaro.org>
Date: Thu, 3 Jul 2025 11:21:02 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 61/69] accel: Expose and register
 generic_handle_interrupt()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, Cameron Esfahani <dirty@apple.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, xen-devel@lists.xenproject.org
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-62-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250703105540.67664-62-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 04:55, Philippe Mathieu-Daudé wrote:
> In order to dispatch overAccelOpsClass::handle_interrupt(),
> we need it always defined, not calling a hidden handler under
> the hood. MakeAccelOpsClass::handle_interrupt() mandatory.
> Expose generic_handle_interrupt() prototype and register it
> for each accelerator.
> 
> Suggested-by: Richard Henderson<richard.henderson@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> Reviewed-by: Zhao Liu<zhao1.liu@intel.com>
> ---
>   include/system/accel-ops.h        | 3 +++
>   accel/hvf/hvf-accel-ops.c         | 1 +
>   accel/kvm/kvm-accel-ops.c         | 1 +
>   accel/qtest/qtest.c               | 1 +
>   accel/xen/xen-all.c               | 1 +
>   system/cpus.c                     | 9 +++------
>   target/i386/nvmm/nvmm-accel-ops.c | 1 +
>   target/i386/whpx/whpx-accel-ops.c | 1 +
>   8 files changed, 12 insertions(+), 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

