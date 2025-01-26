Return-Path: <kvm+bounces-36626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDAF8A1CE72
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D31AC1887D8A
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F6615B135;
	Sun, 26 Jan 2025 20:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Na2Jtsf5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FAC25A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737923809; cv=none; b=fVp2DTHW73YELI+VpZyI9GlxcKXuNHdSN005Ccu2Vj2PSiaZlrXArF6uND6lsitd30WBssEjy6eXcc5l4+jmnI8InU+EfmCPC5y5NzhrMijvSJgkePcI7mkGSlRDJZWQVZY198OMN7TFVnz+gwiK01dtY6z5ixioY5lE1Dp3Bf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737923809; c=relaxed/simple;
	bh=o1SYVXJghWqI6UEL0iSb9vQaUGP9LDBy3OwDhbq3WNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t7vJaprnC+yXnPfQFVp+2KJpCoUSdz0Iz7vusagf4go0rSSoPYaqtLW00wXhNK4JbGYqOWmwoA4y9LQEDFCSqbaavIrpTatE+NXXXnsGTzBmy9e1uj6WSDeCgZBVuLCGKrWjwGb+hMKk/xOPp9KlwoFd57GO9M61PdfNSHsKtyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Na2Jtsf5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2164b662090so71678285ad.1
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737923807; x=1738528607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g2WeP5q4hv+K1Hr21O956YlU/gBG9YtJDHMFPAKuFc4=;
        b=Na2Jtsf5gTOxsaomDVOFaTR1mxEJ96mAnUx4fXqm2XbcZBZ5vAJ5hGoRNJipiy+Hqe
         vYUmaFqw+kdSOdiscvoek85ZTQ5wrf3bIa7fio25Axb6ceIBl8gdWXzDqe1SKxwenG9t
         KS2kRXxfNBZZ9Y2P6vb+6xqzukHR9qu57h5omedQMl5JOCwQAu7ycLKoM3Z9Mfwc2Mi5
         ke4oGl/LrWIMsG1oZNJ5rMAbqfF5CmihZb96LOqWRnzeCdDzhjzKC6fWcoAXVZHbvBWD
         SRxPr+LFZPI7xrOsNts8HxsK2AfJiP+iNV24bnpjT5XZkosTCzfpFTnivMjYKNKSoKLh
         r/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737923807; x=1738528607;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2WeP5q4hv+K1Hr21O956YlU/gBG9YtJDHMFPAKuFc4=;
        b=MI02mnY7AlOUhsV9yyTvUTx3x+Kn2pMw4Uk4cLNBLKMabo9XBnCrEGfXXIX4xgeQL5
         tjw4Fiy6QgrPc4n3py/73s/pahh0OySRQqtCcDa48jdh8eUK7ErxUoDUug4xd7k1CAAC
         v8Lcs6VwnlrWHv0WPD/m70Rh7kS/nA7hDmFPqH3vNg4oarYyl6am9MUfAWFWeaFSF9ML
         /MkiYCMM5JDp5VosgfrJGTilzLP10+gECZxd3/SvwlXBfYJFU/03FLL/uqZRqa+2KRfI
         VmsS09nWAaVZ9oMP0DPkD9EYFvXavJ0q+J+rPpLpTZd5rzCbEoTvtbjJRYhs4PpUVSA3
         ZYOA==
X-Forwarded-Encrypted: i=1; AJvYcCWMizG5ZGd5a93N1ZrVwLR1sFknm3ZUsB4ucwloh5Gn2TRbkkOQWiYUzpr29/7V6Oh+E7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEiWzhOS4IHgn0jRUrxlew6/5QPFHU9Ck8aSGzSBJ1bWDNh4o0
	3erA4QvM0A/YisMsI3mxJBykIy02SQnFsYvWjkvbsjJPQk9+8oxOlCTIl5DjsLw=
X-Gm-Gg: ASbGnctps0uUxj+/le0sMt84/IKird2OC22fl6NfmcuxnofIYaFIR2nknwXuiGaeBM3
	gtBVKx49QXi++/OKXKdD6179nw4Vxe5VxrA4MMvWdKBqpR7F3T9votZyEepBmva0RIVAzi8NAhB
	J//EEa74B9wXDhUMh5Aw2VB2FpO3ddLwSI2DbhOHBtc127ptPMlsSQZs1kk51k/lQMSdIxipxc4
	Ue9dIdhFxWu8jS/NN3FUG5KRBVFsDno0JuT6C177GVpURXEjgfXgbDu9QPnn9ZYff4tTAQOnn58
	s57C/Tp2uXehkXXnYvC7+DLcTvq9i6yaWCD55GgSNwJlNp0=
X-Google-Smtp-Source: AGHT+IG7QHEN6N12IEj7HpZ8+9ISOfMpvPDzHND+sb7CKsQVCW2Siz1JbFKV0CJ4CarsM9/PXCPftw==
X-Received: by 2002:a05:6a20:2447:b0:1e0:ce11:b0ce with SMTP id adf61e73a8af0-1eb215adabfmr66485176637.35.1737923807521;
        Sun, 26 Jan 2025 12:36:47 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b18b5sm5645530b3a.39.2025.01.26.12.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:36:47 -0800 (PST)
Message-ID: <d81542e9-bebf-4f5f-a911-8ab7b6180d4e@linaro.org>
Date: Sun, 26 Jan 2025 12:36:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/20] accel/tcg: Rename 'hw/core/tcg-cpu-ops.h' ->
 'accel/tcg/cpu-ops.h'
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-11-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> TCGCPUOps structure makes more sense in the accelerator context
> rather than hardware emulation. Move it under the accel/tcg/ scope.
> 
> Mechanical change doing:
> 
>   $  sed -i -e 's,hw/core/tcg-cpu-ops.h,accel/tcg/cpu-ops.h,g' \
>     $(git grep -l hw/core/tcg-cpu-ops.h)
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   MAINTAINERS                                            | 2 +-
>   include/{hw/core/tcg-cpu-ops.h => accel/tcg/cpu-ops.h} | 0
>   accel/tcg/cpu-exec.c                                   | 4 ++--
>   accel/tcg/cputlb.c                                     | 2 +-
>   accel/tcg/translate-all.c                              | 2 +-
>   accel/tcg/user-exec.c                                  | 2 +-
>   accel/tcg/watchpoint.c                                 | 2 +-
>   bsd-user/signal.c                                      | 2 +-
>   hw/mips/jazz.c                                         | 2 +-
>   linux-user/signal.c                                    | 2 +-
>   system/physmem.c                                       | 2 +-
>   target/alpha/cpu.c                                     | 2 +-
>   target/arm/cpu.c                                       | 2 +-
>   target/arm/tcg/cpu-v7m.c                               | 2 +-
>   target/arm/tcg/cpu32.c                                 | 2 +-
>   target/arm/tcg/mte_helper.c                            | 2 +-
>   target/arm/tcg/sve_helper.c                            | 2 +-
>   target/avr/cpu.c                                       | 2 +-
>   target/avr/helper.c                                    | 2 +-
>   target/hexagon/cpu.c                                   | 2 +-
>   target/hppa/cpu.c                                      | 2 +-
>   target/i386/tcg/tcg-cpu.c                              | 2 +-
>   target/loongarch/cpu.c                                 | 2 +-
>   target/m68k/cpu.c                                      | 2 +-
>   target/microblaze/cpu.c                                | 2 +-
>   target/mips/cpu.c                                      | 2 +-
>   target/openrisc/cpu.c                                  | 2 +-
>   target/ppc/cpu_init.c                                  | 2 +-
>   target/riscv/tcg/tcg-cpu.c                             | 2 +-
>   target/rx/cpu.c                                        | 2 +-
>   target/s390x/cpu.c                                     | 2 +-
>   target/s390x/tcg/mem_helper.c                          | 2 +-
>   target/sh4/cpu.c                                       | 2 +-
>   target/sparc/cpu.c                                     | 2 +-
>   target/tricore/cpu.c                                   | 2 +-
>   target/xtensa/cpu.c                                    | 2 +-
>   36 files changed, 36 insertions(+), 36 deletions(-)
>   rename include/{hw/core/tcg-cpu-ops.h => accel/tcg/cpu-ops.h} (100%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7be3d8f431a..fa46d077d30 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -175,7 +175,7 @@ F: include/exec/helper-info.c.inc
>   F: include/exec/page-protection.h
>   F: include/system/cpus.h
>   F: include/system/tcg.h
> -F: include/hw/core/tcg-cpu-ops.h
> +F: include/accel/tcg/cpu-ops.h
>   F: host/include/*/host/cpuinfo.h
>   F: util/cpuinfo-*.c
>   F: include/tcg/
> diff --git a/include/hw/core/tcg-cpu-ops.h b/include/accel/tcg/cpu-ops.h
> similarity index 100%
> rename from include/hw/core/tcg-cpu-ops.h
> rename to include/accel/tcg/cpu-ops.h
> diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
> index be2ba199d3d..8ee76e14b0d 100644
> --- a/accel/tcg/cpu-exec.c
> +++ b/accel/tcg/cpu-exec.c
> @@ -22,7 +22,7 @@
>   #include "qapi/error.h"
>   #include "qapi/type-helpers.h"
>   #include "hw/core/cpu.h"
> -#include "hw/core/tcg-cpu-ops.h"
> +#include "accel/tcg/cpu-ops.h"
>   #include "trace.h"
>   #include "disas/disas.h"
>   #include "exec/cpu-common.h"
> @@ -39,7 +39,7 @@
>   #include "exec/replay-core.h"
>   #include "system/tcg.h"
>   #include "exec/helper-proto-common.h"
> -#include "tb-jmp-cache.h"
> +//#include "tb-jmp-cache.h"

What's this?


r~

