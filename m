Return-Path: <kvm+bounces-40746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A21B4A5B9BE
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E2923AA71A
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62861221F2A;
	Tue, 11 Mar 2025 07:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hBpk4GEj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65911AB52D
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 07:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741678005; cv=none; b=CpIu21nAHhTMddVwUqATo3OSLB03E+LKA3gIr/g2G6gdjXukWjacbho53oPuluPqarl13+aEYa0ENpS+g5xQoF3W5lJVyqnp3SJEmwHu7vHa1qx++hvFPbdWcQA5sd40wcwR751prMK37bBu4C3XUZlSlNfKyp9D20K79LqE7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741678005; c=relaxed/simple;
	bh=vnRxFtivCdGSLAiMeydvN1bY7FNUilG7gOrkpvb3mO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDdoVfq2R0wjnITVzFqRjI7VbRh0Gyu6bBlNdj8+Ie24AkTTzoBdxNBiYXyOgdmQOMPZqZ5SAWkBztP+ux10NMLyopUoEFwAWCZTidp4uz0RHL0S+6mwqFfIU/Jw++xO+Fy6i246mIcq21kclnuw8ZHKs5IFg8A7sM0FDJgKXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hBpk4GEj; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so17955395e9.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 00:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741678002; x=1742282802; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ixQm0MWjxG3W9XU5tOCfvUKz5fda/FdNvvBHZqMnUSI=;
        b=hBpk4GEjg9aAVb2weWN87QZdbqQxVTkHOjMA+WjZKV3kU5V9GUcjSEYUOCUAyVOEn3
         zs84pK+jojhEAD4hlMQTBmkep5lBAizdVrk+c6UknRu5UUr2y5h3fJdqR8uJLHHaHttN
         DIohxJZ0vE6APRTgUKKAj48wZlbshEvJitc6Z1LT/GKLm+Cll8WT0Kn/o8hnS8NhsDcF
         pQfX8us1LsRLB+VxYClMZMrc83H1nYOXJWkiScdCuILkyh+abzTht/IALnvpzBoCh+LZ
         Xrm0ROp4IVLGytDJazf33CpDu5eVRLqZw0g6/+vWNX3QovTO4ajhsjOaAUgTQVKRA78A
         cGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741678002; x=1742282802;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ixQm0MWjxG3W9XU5tOCfvUKz5fda/FdNvvBHZqMnUSI=;
        b=GyJ08DW760jK0dcTOCwgdewCEKps6yjs+yzTiPjJ8NLwauAKLdEvNFFJE2svsdFH+7
         b+qItJ/OvBlmJJOVXZSsz/gZLPBlnHPdPEryN9lWU0G9spEZr5RHUIp0KbDlqX4zPg2I
         3xHUAXdyF/QevR+4N3lMXR3mlq/VtQUQe/BpU5K9tnI+ii09ymBS5iYdQkB3JWCxvnnU
         c5pntzlQ8+gON3iY4NLSzfmH5Hr0povTOts/9J9yEeszQ2N7+KRAqe5C9q7BpMEdrSb5
         +VsbnRmNuNb3OVnS7eIJLlqB8T8l67JGAir14UQjXSdpox3S5/636Jo4JcPOy9RS7SNR
         HT7g==
X-Forwarded-Encrypted: i=1; AJvYcCVgNgepMVr839sLNeT0/ATvSykECbe4Law3nTydiaBMdETlhVTi0SUuH3udEz5wUX4W6xE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywGaLYzkY3qkO6CYBqHppmkllAY2hEMvROTXHxL73kQF1VH+UC
	Y7Q0ZD2H/wcRScUhb9WV4YhH6RpHgColQu2rnrFvgPxwfMe12GAfOhQc1Yf9vqg=
X-Gm-Gg: ASbGncv4GLaROuHTBg+yV/b1GzEAnWA3FTmazbnY4acBWGtBOG+KqrL6aOzp+v8MXrA
	2kM68CtdfieRjYgft2KXkTwVjxvUaaDykfX+Iocurt2gSowMtNDnxmSnyYfxVSgL/I0y+rNIOZy
	WgWMhVBWyJG2kbSZXJA4Vjp4Yenbf4K8h3FT8SpKEGWaXja2V+bZgQ2zlZ9NS9t+PX+dOjuwKv4
	HRSqL4r8TGJELy9QWLeGPJX5Sci6IZQ/XA/YLQ0dD0XrGbAILjMw7SjfH4J4pv2IkbzR/t+I4Br
	FdJ2zvwuClte7SwiU+CQAmCxRKWNssp1U849VNHkYEBGRIJwdjgmyRhitZRyoSnhHPqIOe/6Ljb
	qYNZ/jY/U5MNQ
X-Google-Smtp-Source: AGHT+IHkbKwZ85r50y8SupgnjoEiG0z2vsuYpmQ1kXDuNtR/J+NTZlfd2MeQZu55SLcc8fFLvUwdtQ==
X-Received: by 2002:a05:600c:4f16:b0:43c:fd72:f039 with SMTP id 5b1f17b1804b1-43cfd72f2ccmr76596325e9.11.1741678002154;
        Tue, 11 Mar 2025 00:26:42 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d025869e7sm19373395e9.7.2025.03.11.00.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 00:26:41 -0700 (PDT)
Message-ID: <9f92a783-3826-4a06-9944-0e0ec5faccc9@linaro.org>
Date: Tue, 11 Mar 2025 08:26:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/16] exec/memory-internal: remove dependency on cpu.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-9-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250311040838.3937136-9-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/25 05:08, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

Missing the "why" justification we couldn't do that before.

> ---
>   include/exec/memory-internal.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/include/exec/memory-internal.h b/include/exec/memory-internal.h
> index 100c1237ac2..b729f3b25ad 100644
> --- a/include/exec/memory-internal.h
> +++ b/include/exec/memory-internal.h
> @@ -20,8 +20,6 @@
>   #ifndef MEMORY_INTERNAL_H
>   #define MEMORY_INTERNAL_H
>   
> -#include "cpu.h"
> -
>   #ifndef CONFIG_USER_ONLY
>   static inline AddressSpaceDispatch *flatview_to_dispatch(FlatView *fv)
>   {


