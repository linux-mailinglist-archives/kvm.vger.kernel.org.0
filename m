Return-Path: <kvm+bounces-45106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FF5AA6078
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CD214A5F90
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E0C202C49;
	Thu,  1 May 2025 15:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DkduXKHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9091F130A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112024; cv=none; b=Ox+2a+B6goRJ2P3n2Ef+sXXBeRFFJ2rvtpb8KdQ2GBGKudpYSzuiujkm3tIXt1TNCz0Q+P81ixFfcSShoJAqU+y7wOK5BSeJJ7FqLTJy0UuKa+DzV2WHtpdzX2L+v+8gfIvpIeKhWAUwyRUfeVZViHbbP1rLp+QaI/ZghQePOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112024; c=relaxed/simple;
	bh=ceHRttH9t1MCC8OqEkzZ1cVFQpuiRE1AVoFaQmlIO8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EyR3L5f+p7+kGeLaFB+1cpitu8J8wegvE6nOPbHbsUXgqGQCY0dLPHHJwgKSnZPKLJqVqkeW2ivEdNHrAM2l93FUB0Om771/FUfIxNlx52L0Zy7pJzcQCixxBf0LGCMD7f4n+4jvqYbvRoSYutVBKPj3gz8PlvSRfXIQUIrlmyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DkduXKHs; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-301918a4e3bso1272688a91.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112022; x=1746716822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EcM9dPq3o3V6LdIXkIrMSQgYINVmv6Fp7cayUpv4944=;
        b=DkduXKHsg0+k/3dA3IqyLnOeQHinJHsn4MxU8samDY7BB6DErdBuIR4J7IQ/X3yVbg
         muS1sPxK3lKm3moxDPU9uhVObWauN+ls2E0YN/3PfKArSwv0DFmV3VweZm3xo/SPTJaa
         9sNuARur3X+Sl7sfFRI7Tj+G1n+TROhsbi+GlAC3TB3A6gQmZs77TBIo/VkQD6UXwWPv
         IuFzkhnmwyEjLwihj/Bdbz6YDROgqrccyP/a9GG6MwOj8LEgMHbw3LPw68CUe80hi6Ax
         GBC2yL7bEDRCzUFUVQQH1aLxwQmdwXYdYSWyMVrA6xrAVr4AaS9U4Wc+jxjmHcLx0M0u
         s31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112022; x=1746716822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EcM9dPq3o3V6LdIXkIrMSQgYINVmv6Fp7cayUpv4944=;
        b=oH02aPofucq9jusqjZlKMDNulgcMYRUShe/enHn/Mt1lRk2bFXIUHr6QwaztVgtisf
         udVxmUQs8MNFIFnVk4DVIcxqe+N+zc3UDAzAUYF3lY44RApARJ/Ul9LSIY/ZCEJerhxp
         jqIkl3jiCPwmfk/cm7hSDd+Uw91PVbCB6bsor7WMv1HmWYgeP97pZdCgBVR4EGIl1Tkk
         O26bPCGC0Zl8q5l1SaKswr7Dqo9OSc26BSkLR1njEq+6uJTCx+JiVQjHucfy/T+I7D3X
         Mm5QEDdgvK6m2RTorGelLUYRRWGIPU2AS5K1Cbjde1yD5jTGadGyYwhjHlIqeHIsQ0tc
         +3hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu9Vc5DGej39DDK+Na7ts8lUuWI1F9Tnel+i4EFV8Ac8YqP7zF9NHI8CbS6bU3vZoskiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc1MZgkccyEomNYYJeXJLIoW+MqiGjiFmG4HVFkH1vXSH65+tg
	/g/obIj8L4XLSbIeR9H/1V48YlOp/YSRKqQsmpnYQfGK9KdDPpWrXlIBHz/r9hE=
X-Gm-Gg: ASbGncv7S5UOUR6wXi7aockzMDN7jOTgIHKAPsF5ikylBFbJzVaSSD1YylEhV2a9IFe
	N5et9LDRzB1Qv4YXf7DbFhpwGGII5j3p5nbf+7RpgBDnjMOxvWqqcKQ7vPzyoAhA2pr9n+b6sF4
	eL/E0snKlD4wxl7vYBpjopd/QsPYwBLWDaVfrdRssqINA3/o9Gc+SmjlCrASdmWclnm1x70ATI1
	y6qCZW7JoGjx8t6K1QWqFwK3fr5oAFdDH3qLjtq8gbqUtqElnq202bDoe8lXVWiksHNW2lJHYOY
	v8zP7cMftpHWK3gmawFo4IMXrC9mdVkL7MxPRq6DsvNytyimwzG6C1Y4n6gvyZENmEF7rx4HWC3
	j90TqtgY=
X-Google-Smtp-Source: AGHT+IGfItdxKMWWB0HXsdQlHgzmrixhckbDJw1c4W1R8FB34LVv12qDqlJ5sWBZkHPXgPbYrkQiYQ==
X-Received: by 2002:a17:90b:2707:b0:2ef:2f49:7d7f with SMTP id 98e67ed59e1d1-30a41e6dcc0mr5736176a91.18.1746112022161;
        Thu, 01 May 2025 08:07:02 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a3480ea0dsm3690678a91.37.2025.05.01.08.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:07:01 -0700 (PDT)
Message-ID: <f631cd09-2b84-4327-8ef4-39aca5c8a599@linaro.org>
Date: Thu, 1 May 2025 08:07:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/33] target/arm/debug_helper: only include common
 helpers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-17-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-17-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Avoid pulling helper.h which contains TARGET_AARCH64.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/debug_helper.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
> index 473ee2af38e..357bc2141ae 100644
> --- a/target/arm/debug_helper.c
> +++ b/target/arm/debug_helper.c
> @@ -12,10 +12,12 @@
>   #include "cpu-features.h"
>   #include "cpregs.h"
>   #include "exec/exec-all.h"
> -#include "exec/helper-proto.h"
>   #include "exec/watchpoint.h"
>   #include "system/tcg.h"
>   
> +#define HELPER_H "tcg/helper.h"
> +#include "exec/helper-proto.h.inc"
> +
>   #ifdef CONFIG_TCG
>   /* Return the Exception Level targeted by debug exceptions. */
>   static int arm_debug_target_el(CPUARMState *env)

Oh, I see.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

