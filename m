Return-Path: <kvm+bounces-40413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD994A571B6
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25CBC1896373
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92082250BF2;
	Fri,  7 Mar 2025 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p+HF2Jj4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F9B46426
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375799; cv=none; b=loK2mhOzn70rR/aV9SQU82/3C4lmAg9rli5qEdaHVfslKpbN+jl0saQeVSROoTdqXKrZMePnUZdGB6p1/EJFFQ5IveN89nWliTr1uSM4vWD1+lPoB2lmZHhqfkjys+KggMMxH+5r7XOttiK8c6FJ6ul8pvOWw6kslhm87/91hmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375799; c=relaxed/simple;
	bh=rTGxHDyPfUSAubmxV/ticSrlc46EfjnyxoYvlaYZZJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DlUU035Xssdz7MXoIxFUKdF1J12fIrHkGoaw8oJb/i91TfQOZU0+yI1cr2cc3BInVEIKeHzCY6IBlF+wIJSX1NEG8HROnTc97lOidcal3PWciwbYbdpWZX9rPAb/dbk32GjU6dOA/Em9VYQQIDLy+O/hL2my+IprhAONNINhfro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p+HF2Jj4; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22185cddbffso64172975ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375797; x=1741980597; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L5bueJID/4l6Ds0Sf3lpumCyuJZvom5Q0Q7U+dAAY/4=;
        b=p+HF2Jj4rFyQt5JLDdVGPN6/tXRDyb2FdqyYDjo1Genhg1zpnNUcaI2htZmzl6AFpZ
         S8lbRxKxDgB60M2U7tulwTbxTMgneIVhl0QY91MhYPbtubUssWArvOBN7LRPh3E+Y5de
         2cl1TJozQNszn1mpjhUimVTMPatWPQKUV6vi2iYbInEIKP6nfj8gXMJL37t0ibMZqQdH
         dQPabze+rWzlFKM3IMPH5zYdwR3xQbK7ORaSUpTDrXz6qBAisdLfIn9++V3hG8ozZHfy
         8QIhwddVdzxUBlvjVrDuSoWQpiezAqZVoIFcrhJcZfjkK2dPVgin2YItO6UdHKX0MHe7
         jYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375797; x=1741980597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L5bueJID/4l6Ds0Sf3lpumCyuJZvom5Q0Q7U+dAAY/4=;
        b=Yz6G8cdoY8+BlMCVs0wJncKIO1N35wkAMqsgdic7tW/KWD52GqsdIie8MGaRrl281P
         MlrSIXHWDUfS0A+J8/DftMsKTkkFvCTI7vHLgoY5M+02SjcmnU+xMUvS9rKtn2ku4VKU
         LfM1RgcCxEiGbb+RXymlKfjUUcoms1LKvRsEfa6zlUptP2Z81KDRL6a3AcfyoIpthnSO
         97nR+qKnGm0hfA3QxCaYQqhyIS5VVmNknV003ahRlW+DdqtzHqRudvjvw2z04atvHW6z
         1xl891gPNyhhXBjBLWbGo4pWVp4T+x3xULA3euvANK9Put8p8mI+tOPEPcLvJfba0u+o
         300A==
X-Forwarded-Encrypted: i=1; AJvYcCXBqXnGgdBZAV5PXAOOsP4+WpI9CEqSHo5vcD7T604f37AXn3hCg2uGgbcpmaIwU16PCYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5eZT8H1E+AaeyDx0JSJG0q3WtFVMeayXlpxtpsMB/zyHKhx1Z
	KYk8pI9fhLbERxcjtG2596eyFLXPm3T8LKhfdSCVuxJigG7Uq+b8JdIWcTGtJ8o=
X-Gm-Gg: ASbGnctyE5ZXa0W/R/Y5TVoALwRLZs/FPg4uu5eGFR8ClWNtGpy/7EgzMlA+S/To1MW
	JE4H3b4FnhYwor0aEoW3pGUD/HS+2dGbQE7MDRoGkL2fW22RPAl6zx+wsWYh9QGgR6DxmEYAPCY
	BuIMw7hKS13sya/DvFXBlh6ftgP/kbCqygXHE6hNgi8Ztg5FEGgFoSo5Lnq8mawGa8oOkrg5r7N
	uEHbuasIzCb8CZsDGk9AxpXPHSgfX06oss1CpmGC5wMEsQYMzpobUEVfQPrno+RzG4yPaJxQUB1
	0ULr4zpVV4fRvSg7i+9HlykRSN+0ObuW+9ftcwUM6cXFV/6MLA8VpXf8Do0Opqvp/tjYtX8hzEf
	snU8gfgG3
X-Google-Smtp-Source: AGHT+IGwIx6bMaisOgOHQqkHd+6ZpmpTUh5UEbMm+YdbJluy1j1/WibBOMneY+ahgwgxFzxR7elRgQ==
X-Received: by 2002:a05:6a00:2283:b0:736:4c3d:2cba with SMTP id d2e1a72fcca58-736bc0a2222mr1398969b3a.9.1741375797625;
        Fri, 07 Mar 2025 11:29:57 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736984f718bsm3646533b3a.85.2025.03.07.11.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:29:57 -0800 (PST)
Message-ID: <4a94d56a-e508-452f-a6f1-99133221171a@linaro.org>
Date: Fri, 7 Mar 2025 11:29:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] hw/hyperv/hyperv.h: header cleanup
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:09, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/hw/hyperv/hyperv.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
> index d717b4e13d4..63a8b65278f 100644
> --- a/include/hw/hyperv/hyperv.h
> +++ b/include/hw/hyperv/hyperv.h
> @@ -10,7 +10,8 @@
>   #ifndef HW_HYPERV_HYPERV_H
>   #define HW_HYPERV_HYPERV_H
>   
> -#include "cpu-qom.h"
> +#include "exec/hwaddr.h"
> +#include "hw/core/cpu.h"

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

