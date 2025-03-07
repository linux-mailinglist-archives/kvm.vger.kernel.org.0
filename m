Return-Path: <kvm+bounces-40460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B96A574A8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 464227A6F35
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48ACC257437;
	Fri,  7 Mar 2025 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A9+UCkeR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7056F7E9
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741385176; cv=none; b=PQlAelU8ioTpDTWEgLbUnAE27faKwb776P1nqm8vYoqGkusnOmBz0jZOTph84zCFzoTqCQ5BPSgi3y9+sPbcX+Dro6XozOU0pxmb+y/zHWZwROD5vyaaA3fjpF6S8YdspDYH/vdLb8Kd22uGlhNm1/rwFf5q8yrJL8D9WvZhXro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741385176; c=relaxed/simple;
	bh=jnj/oH7synqEu1wZ89p6C9MtdW5abL6/9wJ0sHQP9+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSx1h7BpVSdz+zF4OZIV+VcyaT6p1kne8FwAlF3FbcBH8R+otWRTcTLuJ2clyE3PpzfdmMW/oLRN0BaUsl+l8PopNWCfRBBcXfpHaNUlFL2r0lwo8aiXDeOWZfMdWKthxtS9U0rA1fnwd4eVZWKtgpzEUW8KGBl/UDhkw+K97wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A9+UCkeR; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-390ec449556so2820881f8f.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 14:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741385173; x=1741989973; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J+E+5MNTzmNhs6MH91U6sTaUkbdxX1RykL7+d9oBnXU=;
        b=A9+UCkeRPkOyPh39SwNtfe/5KG35VWyjWzPQ4ss+S8+4nw2+CmfkFLZ9PcXlSpnR+/
         2ag5LooAjFkS07KW9lJkTCC3NXkN/EQ6buQNabLz7ltaFEDPLgduAIbY1KOUO9tDSmwQ
         GjzZ7gl4GZJoecsY/f+xdTKI3O+pwv9BnCZZu5UBmr5g6q4F8UX8htF+B0QZfWOZ39DI
         KhIwnR963wT4d7ZjECaI6KLrN5YEGU5btAi+Ztp9q1M+Yeh6SkRc/Oikql0w76qHKBYu
         xs776TpmiX7zJxkPMIwPfc8FmC9MekIg97EMbG3byCpUaghSHwByVlMw4AWFo21fiMlO
         CX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741385173; x=1741989973;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+E+5MNTzmNhs6MH91U6sTaUkbdxX1RykL7+d9oBnXU=;
        b=hHiW0Nc5OlsJIqnF96QhmeINNVBlj/Wr0I8h/UEvjKVVu6FbLWJ6HljXKXRUJuMWNS
         SslZocy7RpTuCdVj5sOkrZl4jwqnea7avuREY4eB4NaeqHukHBcgqt30IbHZFOETr+oH
         kR87F67Qs9K5fjgmF49TX3w/piu3lEI+TFF75IFtmCUNJ8gsqGcNU2Clp3VhD846Lc69
         KJMqzjltTHTdyg0gghKzQbFHtvVlVGFHbFRlUv5KvQrDrL93B+YVW6gym+/0Z+JE2+xZ
         +8L5go0J8naiToJg7KQA4ujH0vA6GhPJI5/GL/2ncUHtahXeW+Ul9/DXyszWyheKLrSB
         DLtA==
X-Forwarded-Encrypted: i=1; AJvYcCXBDnG1KKiAefshmZiPaE8XaRAG5qXwxsts5ew1MiOLDCGMGatIU5rBjxcsv2pYc9Z/ol0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyouKSYKztrxxSMARKD/7KQNik7Si6jFx8YtsE6ziCNHtRSGsWc
	UAiFC+x/SU83wUk1hhaN3yf6Ee9C5rRj2rot4OhsvFGwD2CmGX+roQ3CTQGfdrs=
X-Gm-Gg: ASbGncurifim9MBXF4wQxK+SBf6k6cR72hSHd/flCmjm0p9rlJdVAdP9JRhgjEQhss1
	YoiFAR37Th/KzzPeg95WcF3YTfmEfwx/SFTmAsEp/0LVs+MpHK5Di6x44OeLplL2hZCaX+VY/3F
	ifh2O7TfeoMH5Enu7oezXRjwjj+5ywf02ir0K85SDa9GrNtv5w54Y/nfoQR0FQBjvOwEbv7c/Yy
	kRxofCMPw+G3U9KFuebY5B7ZPdSbmIJWOlYLw7rQbMU9gkHl0HsDcvpikojwd0vcHV4je3AWhqa
	Q69UaqaCL/10g8ripqhdNmWOsJZQ0pPmjYJjT3TVqjL0rwjv74SYO92iRmGpfYlkqJv8YiIRzIE
	Qi5DubnyBEko/
X-Google-Smtp-Source: AGHT+IFDossi/1p4SEuqIz1YxM/T8A6eeUCGfHQgGZUcm+3bvisxJU4T73PWVu7xZcVUj0qkKVGP3w==
X-Received: by 2002:a05:6000:2c5:b0:391:2f2f:828 with SMTP id ffacd0b85a97d-39132d664a7mr3463240f8f.29.1741385172711;
        Fri, 07 Mar 2025 14:06:12 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01d81csm6691181f8f.58.2025.03.07.14.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 14:06:11 -0800 (PST)
Message-ID: <fb8f0700-2676-4e7a-8857-ca10f5060b37@linaro.org>
Date: Fri, 7 Mar 2025 23:06:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 22:56, Pierrick Bouvier wrote:
> Work towards having a single binary, by removing duplicated object files.
> 
> hw/hyperv/hyperv.c was excluded at this time, because it depends on target
> dependent symbols:
> - from system/kvm.h
>      - kvm_check_extension
>      - kvm_vm_ioctl

Bug, these should be declared outside of COMPILING_PER_TARGET.

> - from exec/cpu-all.h | memory_ldst_phys.h.inc
>      - ldq_phys

Yeah, not an easy one.


