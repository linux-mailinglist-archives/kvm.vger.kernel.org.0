Return-Path: <kvm+bounces-51343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E94DAF63F4
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3CC11C44943
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9ED9287250;
	Wed,  2 Jul 2025 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iVIpgT1S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D13A230268
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751491618; cv=none; b=s6WymAnL+fypKWSOTQJdN6CsfuUEDJy0EbRBZS1GYexfVAS+6veXVYBFDB+6dd5yhhKarRM1dZn3kd0EmLaZs4Ge66JzY4pDExyD++QMMJtueUDMg66cEM2jScYFoePehFQ/kd0lL9ihrti+qBEpOTH8//4YXqufWlW5rOohIWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751491618; c=relaxed/simple;
	bh=kUmPF8TxC9tkvtwQkD7Yj7OwVbPKllNiQZiqUvowUBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ce2pMwFieY2sCAXHyFko5IqhwZ37gxR8Qt7lQnFzwcOo/NXjRGPgwxFv51YrSTpNNV6scTCQptsx9oSXohAXIqpi0G5DsOPhHiqv3pyDzHT3MRku3EymgGxLq1C24MtJnkKE1Eb0+Ebe8W9R1yctOFLvjwhC6iyjqmJv0ac5vdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iVIpgT1S; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b2fca9dc5f8so7099520a12.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 14:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751491616; x=1752096416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VnT9NdXE3ybydcEe8oSYwUjLjEOXETYq80rC4G+1H7Q=;
        b=iVIpgT1SFnVgO3uiEVrkrIka32qTQJVWedShFUjeeIcxnIFeNsDgtgwfBXAq/zWy03
         stPJALbkjjGSs88PjPm0CYSBHuzR6Bd4tzIo4yTpPKAtvGraeFHirGS+YR+8gheZdltY
         RGXLhFc+cEVCXqHqDixmtyzLBFYm9ogrbDgpSOHAks0U5ZrsY0cUj/Ss91jWqTgjmzj1
         Wp6k069gCpTkMxuzLmYptR0kzR26R2XO3K1aKSeff11PrvBv6VAowBG2TvIwxfCnLStF
         544tRwrmk0A6BvQkgLdA88Y6Dn2KH8ZGnyt7PtN02a6eOfIDl75VhcdE2Uy0w6PLfnVm
         3fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751491616; x=1752096416;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VnT9NdXE3ybydcEe8oSYwUjLjEOXETYq80rC4G+1H7Q=;
        b=CZU388dTfTfjb3fJ1njHzALmXOAEtOXNfI8FKJgi4A66mubWNiNid4LsYyvKsLhQ+V
         GUgbHQaOAuRO8CJl/fYlwutGtOzFGUtkrWj0OyIN7e4f65zwm4nihqR/NWvfPK3QQ23s
         uwTlpTE7lUF0P0pOJ4HzQuh+YanfJmRbKkSZaAEDhsy40i8HmBgDWdzyFlr+4uSaAwb4
         DLTgzKm6Fja5nBhxnQVV3foczUnLvGARc4IXbL5p4XRehohXB1L6Q5uga9yDf+6w4Cv4
         X1Ej1ZrZ2B6M25E+OsxDISZtOOVuEq8Fd2Eje0mr9SoNUjnqU5XJmIJpIQ1ONyCclwIW
         u9dQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5yeDRZc2/8RbKdeFuRFIhknZVn7UIzLrXRYrNnEWARu4oC2LGCJOzgvKPdyG6ngfaHew=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrIeLXxmDSkWWfqQEOgMUHWVe6CsNr1KFrwK+WvB0YP9KfIQw/
	UV32quyCh9/cI1cJtdSXyxEufp5zEnDBQpuUX3X8xdckZljyMWlbVG+6J0/j4FNfr20=
X-Gm-Gg: ASbGncvWvbgU/w30JG4mXcnsLw+h7CbbmNftwrJB+LIxlHWecPYe23YqCgnPg43ir+f
	UH987MlmLoGZVNU0cahh+nE/1WONK7Y3k3KZQjkg+N1L8KNG0Q/bdkEWmbxMTlxFVGjOxRDHQaj
	Tsa8Uo5KrFkzOxCdm4x5RkIpIG8GX9ePGnnV0LI/IzX4Z+24txoaVfyfETYQoZqsCW/Y9pI7RA8
	km1skEsT5hhgBef28730qKhMdZ0sJHfhA+2lfC/H4ToVJJclDH5cRto1zFFOOHdzRigvIWItt7I
	vgUoiie7cVhSyRTkAUf+2nUqKuXtxJTC0wfi2VU3zgfdDzJr0Ovmews6W2sKIV0XJGI2ZvQhwVY
	=
X-Google-Smtp-Source: AGHT+IFcgjPigidp2JUObKIfrGnW+CVetFfi2zv1TnmMkn0UzMtONPXdsIJh8GiugT0++pMmG1OYrA==
X-Received: by 2002:a17:90b:1848:b0:313:db0b:75d8 with SMTP id 98e67ed59e1d1-31a9d64e448mr1002562a91.32.1751491615640;
        Wed, 02 Jul 2025 14:26:55 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a9ccf8711sm570443a91.27.2025.07.02.14.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 14:26:55 -0700 (PDT)
Message-ID: <5348f155-5644-497d-b9f9-89924d961cff@linaro.org>
Date: Wed, 2 Jul 2025 14:26:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 57/65] accel: Always register
 AccelOpsClass::kick_vcpu_thread() handler
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-58-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250702185332.43650-58-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 11:53 AM, Philippe Mathieu-Daudé wrote:
> In order to dispatch over AccelOpsClass::kick_vcpu_thread(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::kick_vcpu_thread() mandatory.
> Register the default cpus_kick_thread() for each accelerator.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/accel-ops.h | 1 +
>   accel/kvm/kvm-accel-ops.c  | 1 +
>   accel/qtest/qtest.c        | 1 +
>   accel/xen/xen-all.c        | 1 +
>   system/cpus.c              | 7 ++-----
>   5 files changed, 6 insertions(+), 5 deletions(-)

Sounds good.

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Unrelated, but I noticed that hvf_kick_vcpu_thread uses hv_vcpus_exit 
[1] on x86 and hv_vcpu_interrupt [2] on arm64.
I'm not even sure what's the difference when reading the Apple doc, 
except that exit existed before interrupt.
[1] https://developer.apple.com/documentation/hypervisor/hv_vcpus_exit(_:_:)
[2] 
https://developer.apple.com/documentation/hypervisor/hv_vcpu_interrupt(_:_:)

It might be worth moving x86 to use interrupt also, in a future series.

Regards,
Pierrick

