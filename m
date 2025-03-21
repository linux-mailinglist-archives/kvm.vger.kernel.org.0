Return-Path: <kvm+bounces-41711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56569A6C219
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F6517A3835
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D39A22E414;
	Fri, 21 Mar 2025 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LMfWL+pm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2961DB366
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580359; cv=none; b=BrxqOKsdjhbmB5semu7iukQtRbrpq+FWDm4zWnvpl33QZUoU0lSYawnpRELg9KUkUF9/dZkNzAikAmCRDnLlDfdO/GFxmDcPf5UaXmjkybjGm6VkMmR+Je2+6jnZKbjfwwNwJiJXyV1MbjD1kxCzwPgDdEYDH7oryzcef/021a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580359; c=relaxed/simple;
	bh=xQx4Jxt6NTaFuBHlEqX7kV1yjivLHOdmxDRk07ZH+Vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SP+RRKKSuLYQIeFsbboGGIAieqWD+/8d5FU+KmhPO4L4YKHRDaGZ+DqjkxOEZN1rOiqUJJpBdXts0TOK9iGpidtMey4hLOEF5ew9+QvUwNY2O5Zy0759JK4p1e05BU8PYNKljZ2LMZAYqpumTFuW/AjgGHYmZif2rnGyPno/88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LMfWL+pm; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff64550991so3185601a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580357; x=1743185157; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fcsRCqIlZYhLkJXmi9uJeXTy/LuuCnSzcHfkPDugb3c=;
        b=LMfWL+pm1l6UKF+Y9iexmdizqNzVObbsNyXDBnasDHk3hFh/O0j3t1uj0dR1r10qDL
         pldmWvYrWrI6Ir7DCDVMT+kqC3iHkV6oJv3Rp24WWYpmSo5ZCz8B82ZY3Uq6f90EjZyv
         7BR7wiMI0hWmQ0PTeqlDA61xlq2Xzqz8Ko/4OTNVFRgC8qVqQUzVayqZ6D68BE2O9X1E
         AIW2tuPkswf6c8oSZyrXVCgrRE2UWAtLZjEuJiAzv+cGMz+VW7wTK05V2aO5y/gWrb+6
         u9d6MvzIV8QgPixkGQ8oLylLfRBFreLY3igFkVdulPiIJtpX+CcCgPOxG+Io3bUoFjQL
         eagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580357; x=1743185157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcsRCqIlZYhLkJXmi9uJeXTy/LuuCnSzcHfkPDugb3c=;
        b=eKoo2E0/ZgcJlYTOlxFIwktdkEqoLbY3vtwISxDeAhBiQsLGiHk3/makFY5USA/TqE
         KAx1hogu/I3XyuMnSc0g/bEuz0zMkHomX0a74rwXpv15V/pLAdKdN2jjlgzcPhhAsoYf
         bbvMN7HUzv7z9xi8mOQkHB/7dokpYcSkugI4cI+MYVvLzYW716Jzh4pM5hdPFi50fAus
         p+t6JqF+aRtKDsZCDQ8wD4+2ATDex9RT8/snGNSYGmcchNi66wM6q4DC8Et+rEzU4MJ8
         uaM4SIFYM/7IAbyzVE/JsqAMDsLCqpr2na+hjEB2JtIMAgvCloqJnwSL5CVMrHqm3MPb
         T0XA==
X-Gm-Message-State: AOJu0YwTzx/JdUoD+xHSzxy/OzRfGAghALfzjcgEl10cWgVKNiftU94f
	XhrrUMc2fiiSHn8SAHC/AVqbVjcgFAIU0QTDUs6I4aqKEr55IuMjuGdD6EcjjGg=
X-Gm-Gg: ASbGncvopLS/Dl0YIlfroOOKztrm0TLp/LY39pkEN0CnQRMdZFrF81c7+UggkFrgGLy
	omyCN/ltIJVvPqvCnLq0sXTSoaqN4fxVSulEzY3hkHetqINGNy1Gg7jFAtt3cnc0oHoDbheqTMs
	8gehN7iLv0/ErBY6MxBmvf8RBa+P2w3npmiONJYuQRdlglZeSmNYJull0P6P9B9WquAT/SlgPt0
	v0v9W/bOqSEjTjg2erfy0vkpV4i3CHzOJ5wQ5PlAHuORh21FN8RxPnfMHlhrrV6lQr42sJ+h1rU
	2UossbWShZFn6X0IFBXtxXTvUP+cigxgCky0UiTprb++dX+kdRcA9GFw3DZitHh2H7KLnswBXhU
	03tPvYwD7HwcFn0bcgS0=
X-Google-Smtp-Source: AGHT+IEh0K4m79qZvi51zXutwZPPSNgntSySIgettNINaF9oH0PHmuS8xS7yjizBrcB/q8q2pSoCug==
X-Received: by 2002:a05:6a20:43a2:b0:1f5:77ed:40b9 with SMTP id adf61e73a8af0-1fe433195b5mr8209998637.40.1742580356943;
        Fri, 21 Mar 2025 11:05:56 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73905fd57d6sm2375807b3a.58.2025.03.21.11.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:05:56 -0700 (PDT)
Message-ID: <2e667bb0-7357-4caf-ab60-4e57aabdceeb@linaro.org>
Date: Fri, 21 Mar 2025 11:05:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> We introduce later a mechanism to skip cpu definitions inclusion, so we
> can detect it here, and call the correct runtime function instead.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/target_page.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/include/exec/target_page.h b/include/exec/target_page.h
> index 8e89e5cbe6f..aeddb25c743 100644
> --- a/include/exec/target_page.h
> +++ b/include/exec/target_page.h
> @@ -40,6 +40,9 @@ extern const TargetPageBits target_page;
>   #  define TARGET_PAGE_MASK   ((TARGET_PAGE_TYPE)target_page.mask)
>   # endif
>   # define TARGET_PAGE_SIZE    (-(int)TARGET_PAGE_MASK)
> +# ifndef TARGET_PAGE_BITS_MIN
> +#  define TARGET_PAGE_BITS_MIN qemu_target_page_bits_min()
> +# endif
>   #else
>   # define TARGET_PAGE_BITS_MIN TARGET_PAGE_BITS
>   # define TARGET_PAGE_SIZE    (1 << TARGET_PAGE_BITS)

Mmm, ok I guess.  Yesterday I would have suggested merging this with page-vary.h, but 
today I'm actively working on making TARGET_PAGE_BITS_MIN a global constant.


r~

