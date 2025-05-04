Return-Path: <kvm+bounces-45341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C06AA87F2
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 819227A9330
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B631CAA6D;
	Sun,  4 May 2025 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o4akFd1y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038AA10E9
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375603; cv=none; b=HgVQdt0A3hGe1x6QpgIrpaZC+VQZaAq6cKDKYyqRghvbQDp30fIyRUOfETNjF29HGpcsSUkbmvDq3KTPts9Ul1vQyT8zTCnQ0D6eA6kKDRpDALijhIT00kPmARgNmzRu19qzYTnnUr8aDjx3CNmbPEhftehQnyLdlmcCe0LX8UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375603; c=relaxed/simple;
	bh=Gc8fOTnOlOg9NR4dDZOOJ4FspEYTsNHQlcIA/CJShek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kujz4SAxR1PpjPpFdabTrZqBcmsuOgL4n9UNz0Wg9PNCSKJr8f1Mlydu/vp1qhnYrf3YfWRdTcR0Z/CNbzYc/6qFwIVNpDYOgZtdyywnp0Isptu6I4+CfHCX4llwL5oOx7XRwWdXteXVBuaa5ziy33t6dh7x39ghZm6LYp41gnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o4akFd1y; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7394945d37eso2997593b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375601; x=1746980401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2Hc1aYlN3sH+w/KQ6W1vC/R4sisfIS2DRgT7jxOlPs=;
        b=o4akFd1yjYYab1nbfGeepCLibCRXCbjx/d9+AyCRK39q0BrJi6TETQWmnb2TZIwdUS
         FuOPK93BEXUlBlItHSUJUlkFlotZovShzm6PX3qqRa6fSfZxhxN9xAZN+gcvkFtErIF2
         iHiQ2Bn1GVtO14+JiXXjb26jzrrma3dWgVesAn8UfhbAJpQBueZGsGRECOSlH8Gma3LL
         WITOBEmZwiZFaibP35jy0+BYzO/vWhEL2f28z/J//iKJmotsCqI+4ghjOugXMQ0d+WKk
         RXaH91qoaHFPOLgvLU9M+Ja6bBdoUieEAXGvwxfmPMmFWQgrSZ/1Ql+KQEhMOtnMjPvr
         3erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375601; x=1746980401;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2Hc1aYlN3sH+w/KQ6W1vC/R4sisfIS2DRgT7jxOlPs=;
        b=r1Ve5UiHNnRJk/jy7GjFje+PhwO+DsBm3GEz3PWDWNjgKrCmteRE+5nv/CVLfOHp4D
         C06GJl/HPaojRhIjlJ/uB0fj1Ma/T5RgYeH1eT3ysDKy0hvFDCkeN3ROeHIAS8vnV099
         hnm21cuGg4DdlYjyE6rP3dBl/C9IpxPmaka100BcxW/5eu+ZdqpJ4mHTfGN3hnMzdwqY
         17Lh5L4t5wlocoWGXu31/Nb5u5v/JOdalFEdYPpeRIU4RkNH8ZvPnphVvZ3zDR3lpQuq
         dn3rWtnxdeSWiKGLwZkLxSK0Y3xJZsz0KN4ifkE9LF1Iodp+mh8lCjGkBhsA9Rl9OEJq
         PkBA==
X-Forwarded-Encrypted: i=1; AJvYcCVF6wb5vwRnBcd4UI6vQEzAJ+tR9PXiMjSJGkDdR40GCl3tgU4iI4Zt4cFmRd/OjvLydSM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn1C00ADGA99Dj+7tVI2Cq9pPWa2Nr5Ug5jH/XEBnQ/a3D1xrj
	0U8ahPkt92HLfCJke3wLnucRPO76zLydmw9sR7Nn0tLwQcDo3u0sY50WPUPOh+4=
X-Gm-Gg: ASbGncscTfJ/HqaGH6crmP376aVmCxrWHhdgLjKOBulTYTXfK1LQk42dekdd80MImuH
	Q4f8Rny1WXv17dtsS/lD6x+laNbMFEg5VKyucQkTk2eew0wS9pxAX6O7tbSWT5teg4eGf5pgnEn
	vA4iSJ+I3axNjflrJY+9A5odHlbx3FLt5d4/eyNveTg0eVtoVVy1qPVO5uZUUHvimsIPDWJBPiG
	fYrixGYX0wmbme8CnLXQwBZErt+3VAUSYy6aR+VF6S/lgjBUxKtYVb/1sdz8wrCc+Q/JxyRRqhH
	BDS3vIO1Su009EVsbr5IC7hDz1fuvI1RHuY8XEUOO9GRYC6fMGDNm77Sd5UQUsEcysjsjREpt3f
	npK+vY5g=
X-Google-Smtp-Source: AGHT+IHIBLfV45U1Fxt55q+aN+vYiuzFSgze79vYczsauOFmX5DbM62CozFoJkq+QpGbV7cyZ3DwKQ==
X-Received: by 2002:a05:6a20:9f4d:b0:1f5:7eb5:72dc with SMTP id adf61e73a8af0-20e96205abbmr6336314637.3.1746375601253;
        Sun, 04 May 2025 09:20:01 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3924dd2sm4005686a12.14.2025.05.04.09.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:20:00 -0700 (PDT)
Message-ID: <a1555cc8-901b-425d-bf02-030a86aedb83@linaro.org>
Date: Sun, 4 May 2025 09:19:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 36/40] target/arm/machine: reduce migration include to
 avoid target specific definitions
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-37-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-37-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/machine.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/machine.c b/target/arm/machine.c
> index 978249fb71b..f7956898fa1 100644
> --- a/target/arm/machine.c
> +++ b/target/arm/machine.c
> @@ -6,7 +6,8 @@
>   #include "kvm_arm.h"
>   #include "internals.h"
>   #include "cpu-features.h"
> -#include "migration/cpu.h"
> +#include "migration/qemu-file-types.h"
> +#include "migration/vmstate.h"
>   #include "target/arm/gtimer.h"
>   
>   static bool vfp_needed(void *opaque)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

