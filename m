Return-Path: <kvm+bounces-36627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0051A1CE75
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C35081887C98
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D15015B135;
	Sun, 26 Jan 2025 20:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dsjfAEcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24825A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737923897; cv=none; b=Q9V6/OKd9W8W8zQarKryNIIONXlKPgduaSQMaOqHwD8ekEGOkYS7eiEAXw+VxM/12Ed1oZzeHxYGy5jXeg8MQDicC9oseM6A2iKC0sgOnReTcuosVPpTqutvZZvyyaanaYDljYbKNI1QKcRDQkG87MNf2jSXIbfVH78FYvm4FWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737923897; c=relaxed/simple;
	bh=FLfJeIcrBtE8Og3KD764DRGKlWIbHtbNuttoV1o7IHc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GN7zGH5ktf6ba0yhoSDu/wRmhLGSSqdDV1K/3u4UVpoyKy1ZyIcX1CtCj2ZjjYhZ7DHVmYx1/8HwYxGFzulL5rZOHA7/rZ/jyU1CcyJ8A6MOKqBvKAduKcdXpPln6T2DGSCrmITA8CzqwLDioHV6UaOOI9Q8Fpq5GbPHTzx/5aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dsjfAEcM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2166651f752so72222315ad.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737923895; x=1738528695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HVPb45ZdRMqIKUAi6GudayI0aNfKV1cv8oTD0Mxltf8=;
        b=dsjfAEcMcdbZP1bawBNK45sBKc+qQwBWeX/NtpCfl8q0NgeFZT8Q77gh8ssMUNv+2L
         6kBOih+pBlsH3sEtKhFqRzx/JaEOIot0i3yFOHGxS4kI6MgowRkAYhXpShALyedCGlJ7
         gylg4YI+43yhLpcn3ROaHtfRblXXfIbjSDdrDXT3MfiegibscAQ5JDCpIjnAyxm7tjf+
         MGic1EAdXQ24x6guqX9dM/3B9uhjRV0UuAKxfc8QFNGpUlCvcvLOiXj0Y4PBORdzAsmY
         jDorixPsV4wJzMNpIP/Bp7gmoMgSwFkLs8XiLdaj+KUhwoMrrBKLkR32pj+mq7B6UEvK
         Ed4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737923895; x=1738528695;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HVPb45ZdRMqIKUAi6GudayI0aNfKV1cv8oTD0Mxltf8=;
        b=qmMQGZdWfGvNw/EPkLs4CMLwYnbYPc1lnT1+GMzsM8pMaiDw+p9auuNBawz+GL1J5u
         VV+XGL2Ldk8h+vZpObMTVECrhmtPMVWIqZHOJu6k6L4PlkQgeIRye0YNokbYweKhu3Vu
         NPJw5CmcAUCSL9uEz1647eeqo6hc9QHGc/qWDFzKjUN/jDLu+a6ckBcEOBsPxXpbFDqQ
         J2iJnr+jZyuh1bT6uAMcCVLSWZ+3DIfdIX9CvbcH1txWW46ukMQH11VTVpmwL7Jsg+yK
         Gx32beEKST3hEaMUS0C5YWfE9wa+n2ipQjvR9JItxVbWpI4ySyCAb5+ydWEFd9drmrX2
         4jPw==
X-Forwarded-Encrypted: i=1; AJvYcCX5VVPcxLTjuIADUSKFxh2vFkvXIZOV7uGXyZxbx/BVxAAaiQqkM64oG1pQmyan+iPQMWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSc2aBKup4Y9nawRfXWqi0UMqitfDkV9H8UonC59cYgTgw1aTs
	akBn5rRgY4KKdIpZtS30FdzSAM6vGTHZTAmy0+5rbYBBtt6m9HMOj72PBQBuHMA=
X-Gm-Gg: ASbGncvgepkQJdB+/52r5/JNw0J5HoFVgEZPifTulffcFbytt9AHQkt2N+/b4bcSd4Y
	TP6y0L9xfdJdykXR0RHd2Ab3JjALb1/vGpx5l46+VfyyLI59T5v4/NYh2OhBM5q5nMOkGQC/mrx
	IjwE7NF3/fPaAgPlby6RNV68uBdM/NUGh2XM0NoFQ1MsDxxuFM9CUPUkmlsRslWO9kq4iuP+abU
	dH5+xd/Qo0+aNXso8x0qJvx0BJ0F0tgVWjjQBX0/tBmlB8rWWsNvRXss94B4gRXTU2chCrb8GpA
	WrnD0ZswUSaE+7pOXNrE5sULA45uiCeveoXr0NAEuMS/DcA=
X-Google-Smtp-Source: AGHT+IFHGSYkE2gK8J+M4s6UHrhYt2yFRPQZ8hFQm3oPTcuYK/Fs6x7qFNLpzA/inMpx9KuBn36otA==
X-Received: by 2002:a17:903:41c3:b0:216:61d2:46b8 with SMTP id d9443c01a7336-21c3555eb72mr575490595ad.23.1737923894867;
        Sun, 26 Jan 2025 12:38:14 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9b8e0sm50214325ad.40.2025.01.26.12.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:38:14 -0800 (PST)
Message-ID: <36f6337f-f076-44df-bbb0-29290a010b1a@linaro.org>
Date: Sun, 26 Jan 2025 12:38:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/20] accel/tcg: Rename 'hw/core/tcg-cpu-ops.h' ->
 'accel/tcg/cpu-ops.h'
From: Richard Henderson <richard.henderson@linaro.org>
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
 <d81542e9-bebf-4f5f-a911-8ab7b6180d4e@linaro.org>
Content-Language: en-US
In-Reply-To: <d81542e9-bebf-4f5f-a911-8ab7b6180d4e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/26/25 12:36, Richard Henderson wrote:
> On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
>> TCGCPUOps structure makes more sense in the accelerator context
>> rather than hardware emulation. Move it under the accel/tcg/ scope.
>>
>> Mechanical change doing:
>>
>>   $  sed -i -e 's,hw/core/tcg-cpu-ops.h,accel/tcg/cpu-ops.h,g' \
>>     $(git grep -l hw/core/tcg-cpu-ops.h)
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   MAINTAINERS                                            | 2 +-
>>   include/{hw/core/tcg-cpu-ops.h => accel/tcg/cpu-ops.h} | 0
>>   accel/tcg/cpu-exec.c                                   | 4 ++--
>>   accel/tcg/cputlb.c                                     | 2 +-
>>   accel/tcg/translate-all.c                              | 2 +-
>>   accel/tcg/user-exec.c                                  | 2 +-
>>   accel/tcg/watchpoint.c                                 | 2 +-
>>   bsd-user/signal.c                                      | 2 +-
>>   hw/mips/jazz.c                                         | 2 +-
>>   linux-user/signal.c                                    | 2 +-
>>   system/physmem.c                                       | 2 +-
>>   target/alpha/cpu.c                                     | 2 +-
>>   target/arm/cpu.c                                       | 2 +-
>>   target/arm/tcg/cpu-v7m.c                               | 2 +-
>>   target/arm/tcg/cpu32.c                                 | 2 +-
>>   target/arm/tcg/mte_helper.c                            | 2 +-
>>   target/arm/tcg/sve_helper.c                            | 2 +-
>>   target/avr/cpu.c                                       | 2 +-
>>   target/avr/helper.c                                    | 2 +-
>>   target/hexagon/cpu.c                                   | 2 +-
>>   target/hppa/cpu.c                                      | 2 +-
>>   target/i386/tcg/tcg-cpu.c                              | 2 +-
>>   target/loongarch/cpu.c                                 | 2 +-
>>   target/m68k/cpu.c                                      | 2 +-
>>   target/microblaze/cpu.c                                | 2 +-
>>   target/mips/cpu.c                                      | 2 +-
>>   target/openrisc/cpu.c                                  | 2 +-
>>   target/ppc/cpu_init.c                                  | 2 +-
>>   target/riscv/tcg/tcg-cpu.c                             | 2 +-
>>   target/rx/cpu.c                                        | 2 +-
>>   target/s390x/cpu.c                                     | 2 +-
>>   target/s390x/tcg/mem_helper.c                          | 2 +-
>>   target/sh4/cpu.c                                       | 2 +-
>>   target/sparc/cpu.c                                     | 2 +-
>>   target/tricore/cpu.c                                   | 2 +-
>>   target/xtensa/cpu.c                                    | 2 +-
>>   36 files changed, 36 insertions(+), 36 deletions(-)
>>   rename include/{hw/core/tcg-cpu-ops.h => accel/tcg/cpu-ops.h} (100%)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7be3d8f431a..fa46d077d30 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -175,7 +175,7 @@ F: include/exec/helper-info.c.inc
>>   F: include/exec/page-protection.h
>>   F: include/system/cpus.h
>>   F: include/system/tcg.h
>> -F: include/hw/core/tcg-cpu-ops.h
>> +F: include/accel/tcg/cpu-ops.h
>>   F: host/include/*/host/cpuinfo.h
>>   F: util/cpuinfo-*.c
>>   F: include/tcg/
>> diff --git a/include/hw/core/tcg-cpu-ops.h b/include/accel/tcg/cpu-ops.h
>> similarity index 100%
>> rename from include/hw/core/tcg-cpu-ops.h
>> rename to include/accel/tcg/cpu-ops.h
>> diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
>> index be2ba199d3d..8ee76e14b0d 100644
>> --- a/accel/tcg/cpu-exec.c
>> +++ b/accel/tcg/cpu-exec.c
>> @@ -22,7 +22,7 @@
>>   #include "qapi/error.h"
>>   #include "qapi/type-helpers.h"
>>   #include "hw/core/cpu.h"
>> -#include "hw/core/tcg-cpu-ops.h"
>> +#include "accel/tcg/cpu-ops.h"
>>   #include "trace.h"
>>   #include "disas/disas.h"
>>   #include "exec/cpu-common.h"
>> @@ -39,7 +39,7 @@
>>   #include "exec/replay-core.h"
>>   #include "system/tcg.h"
>>   #include "exec/helper-proto-common.h"
>> -#include "tb-jmp-cache.h"
>> +//#include "tb-jmp-cache.h"
> 
> What's this?

Aside from this,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

