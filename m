Return-Path: <kvm+bounces-34068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0539F6AFA
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D0A37A2279
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8141E1F37C9;
	Wed, 18 Dec 2024 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N8fFVxge"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D0F4690
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538943; cv=none; b=ujURUW22xp7lOpPS+bXnsvIfVm7Xi84FJGBfcT36NcIleXqPPn2GcbmpOCuOlYdeKHfUDZuAuIb+et59z0VaaRSh168zMeGDaGVXeZMjPfM0Vn6xf+si5FHTL+7fWVvww8LyLNQYBAbBsfjSDz0qi6fLNXZYtoq0jSHO0848l4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538943; c=relaxed/simple;
	bh=+nRIYLUx18Ckri8uJLJpopqFBHt1t36pFVSdfNkPfpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EV2uHdlC3Vd8/JcodERbfrQZ8SyE9TInKak5FfxsAh8p5B7qXQsDot+qYdixGKBZ96URyflcAv/DsN39zqqlzSORgglIbIa/TOvPyhi1Wxc/K3uqhyMDN9WX5doJa6eAS/szIUqZ83Qes1tNjOfh5VObNkzmNMfk3X5/piJIuW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N8fFVxge; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43618283d48so48554675e9.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734538939; x=1735143739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DBGqBoFFTtrTgjei5JE6lR139nQig/betbm5L9Jguls=;
        b=N8fFVxgeQmxwPy7VnJPgESZ0gk0TUxN/dh//2eGLms11lhVMxlgZ72hfDUvnMqkIUZ
         NNLXSY1LxKTk6o2uixWnKOoRKMzj2VJi21qtjAcdvA6X1sSSFc1P1OXy5IksdqiNuKGP
         7B97JVuyWEHGInEmarlGerroyt7MI6+ZwaiziP74KVJHioAzeVIsPQ6Poc9CoiTpXO5E
         Zn7bWsJwX0p7bV9GejbnNlsA3FGZaGLb7n5ohP/qKXb4/QlXTKY1VL+tbcl1iWeg8jL4
         WLzq8LoZl+1Zsqaqnr0NhwpDG4/yZw2g2iSjqs06ffGpC2dW3QqxhzT3ydVlM0bwoutZ
         B7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734538939; x=1735143739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DBGqBoFFTtrTgjei5JE6lR139nQig/betbm5L9Jguls=;
        b=hJlRG/C3QlKfcEQnpLIiIoACzkTWskaHzGOz6p+JBXSprutGniCQQBrTMaQOHLsvNr
         btDVBGe89LOrLkEOVj7z1GbJfNp5RabR2K7vQ+jOV1hh2+PMGtorqh+zWNe1jhQuript
         xqx97PBQLlm4gpNtAlukMkzBFJ0GWjimSijJ4+/OzsY1IGWp7HDAl+/CGLPyVkpBV32Z
         9Le7UqL6LCHgLwHwO55htHtyJoTsMY6y1PP5kaQMV5EO+dINR76vT69sBJJxgBOyXosa
         83UyJQRY7ZSDJp99cF5GgtV9mZ9FA/UQo0rREZp+rekUoB4bA6BqLCEE1wTs9CHsAG/r
         07zw==
X-Forwarded-Encrypted: i=1; AJvYcCVSEnI2B6Grj6Ih9nKIyswmiRbOgxlwlOxiP5+T5Vp2Txx0QRBPWlM7P5H0k9nqaZWxzms=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIZK4ITzwyTF0ZRZ0zquAzZguTh4q1+uaecolpoSCzmPvWSWSl
	NBfXrI61AoCy68DTCUV4gjqC+77GY7j807RLrN0gj8z3d4/b2kteBty0EFXL484=
X-Gm-Gg: ASbGncsmcWl9h1pzPsvnGS4WWWT4HNTmrwVLYiXbFLwA0U3GP1ZF8u8ztRXp6kuXffB
	yySS9p5WEqVdlpDyq7SkcvSrMD7AAvbfpEWeB2bLloyYvfDamtyiw06igc113XrUijx2zxHxize
	n8kJW9sBRJhvDpe3JmLhfNRae5uPIKIgBjSVU/D0HVrYxn0ZNlCgufQSXOq2julTvB+qUtpYO7X
	tpWfxuOZ/Uq1KVVcXxA9Wi61nIbkCeFQjRsqjlO6A7YsAXmlSeaQOUBqNW58igeOgojH3JI
X-Google-Smtp-Source: AGHT+IGdFMvwZNNIwVpThNbKf0YkrO9/XNDycyE19O9fkL4PvUz6c2Tkd/A2lNWHlCWOeP2NEK6MgQ==
X-Received: by 2002:a05:600c:2e49:b0:434:fbda:1f36 with SMTP id 5b1f17b1804b1-436553ec834mr26884775e9.20.1734538939077;
        Wed, 18 Dec 2024 08:22:19 -0800 (PST)
Received: from [192.168.1.117] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656afc179sm24856065e9.3.2024.12.18.08.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 08:22:18 -0800 (PST)
Message-ID: <098c063d-ce67-4f2e-aa25-6eac7db9b170@linaro.org>
Date: Wed, 18 Dec 2024 17:22:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Eric Farman <farman@linux.ibm.com>,
 kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
 David Hildenbrand <david@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-ppc@nongnu.org, Zhao Liu <zhao1.liu@intel.com>, qemu-s390x@nongnu.org,
 Yanan Wang <wangyanan55@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-3-philmd@linaro.org> <Z2L1o7xesp5EcRuW@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <Z2L1o7xesp5EcRuW@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/12/24 17:17, Daniel P. Berrangé wrote:
> On Wed, Dec 18, 2024 at 04:59:13PM +0100, Philippe Mathieu-Daudé wrote:
>> "system/confidential-guest-support.h" is not needed,
>> remove it. Reorder #ifdef'ry to reduce declarations
>> exposed on user emulation.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/i386/sev.h  | 29 ++++++++++++++++-------------
>>   hw/i386/pc_sysfw.c |  2 +-
>>   2 files changed, 17 insertions(+), 14 deletions(-)
>>
>> diff --git a/target/i386/sev.h b/target/i386/sev.h
>> index 2664c0b1b6c..373669eaace 100644
>> --- a/target/i386/sev.h
>> +++ b/target/i386/sev.h
>> @@ -18,7 +18,17 @@
>>   #include CONFIG_DEVICES /* CONFIG_SEV */
>>   #endif
>>   
>> -#include "system/confidential-guest-support.h"
>> +#if !defined(CONFIG_SEV) || defined(CONFIG_USER_ONLY)
>> +#define sev_enabled() 0
>> +#define sev_es_enabled() 0
>> +#define sev_snp_enabled() 0
>> +#else
>> +bool sev_enabled(void);
>> +bool sev_es_enabled(void);
>> +bool sev_snp_enabled(void);
>> +#endif
>> +
>> +#if !defined(CONFIG_USER_ONLY)
> 
> I'm surprised any of this header file is relevant to
> user mode. If something is mistakely calling sev_ functions
> from user mode compiled code, I'd be inclined to fix the
> caller such that its #include ".../sev.h" can be wrapped
> by !CONFIG_USER_ONLY

I forgot to mention and just replied in another post:

   The motivation is to reduce system-specific definitions
   exposed to user-mode in target/i386/cpu.c, like hwaddr &co,
   but I'm not there yet and have too many local patches so
   starting to send what's ready.

WRT SEV what is bugging me is in cpu_x86_cpuid():

target/i386/cpu.c-7137-    case 0x8000001F:
target/i386/cpu.c-7138-        *eax = *ebx = *ecx = *edx = 0;
target/i386/cpu.c:7139:        if (sev_enabled()) {
target/i386/cpu.c-7140-            *eax = 0x2;
target/i386/cpu.c-7141-            *eax |= sev_es_enabled() ? 0x8 : 0;
target/i386/cpu.c-7142-            *eax |= sev_snp_enabled() ? 0x10 : 0;
target/i386/cpu.c-7143-            *ebx = sev_get_cbit_position() & 
0x3f; /* EBX[5:0] */
target/i386/cpu.c-7144-            *ebx |= (sev_get_reduced_phys_bits() 
& 0x3f) << 6; /* EBX[11:6] */
target/i386/cpu.c-7145-        }
target/i386/cpu.c-7146-        break;

but maybe I can use #ifdef'ry around CONFIG_USER_ONLY like
with SGX:

     case 0x12:
#ifndef CONFIG_USER_ONLY
         if (count > 1) {
             uint64_t epc_addr, epc_size;

             if (sgx_epc_get_section(count - 2, &epc_addr, &epc_size)) {
                 *eax = *ebx = *ecx = *edx = 0;
                 break;
             }
             ...
#endif
         break;

> 
>>   
>>   #define TYPE_SEV_COMMON "sev-common"
>>   #define TYPE_SEV_GUEST "sev-guest"
>> @@ -45,18 +55,6 @@ typedef struct SevKernelLoaderContext {
>>       size_t cmdline_size;
>>   } SevKernelLoaderContext;
>>   
>> -#ifdef CONFIG_SEV
>> -bool sev_enabled(void);
>> -bool sev_es_enabled(void);
>> -bool sev_snp_enabled(void);
>> -#else
>> -#define sev_enabled() 0
>> -#define sev_es_enabled() 0
>> -#define sev_snp_enabled() 0
>> -#endif
>> -
>> -uint32_t sev_get_cbit_position(void);
>> -uint32_t sev_get_reduced_phys_bits(void);
>>   bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
>>   
>>   int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp);


