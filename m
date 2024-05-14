Return-Path: <kvm+bounces-17373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C518C4EF8
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 12:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AB1F1C21111
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 10:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A67130E45;
	Tue, 14 May 2024 09:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="iWMQ5of0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB112F59E
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715679801; cv=none; b=kZ1D0/IzI0YjodQNTFIJGqktdL3Ip9OXnuHorkLvacRpoKa5SSEm6L1PTpbU2djg2jqxPn7JDay4cp3Q5BedcjUL7GYhztF9OZWUXaYAyaPQcBkRxlj8TSYopFx91QWytgNsFPQAR1sbJEs500CaoAmJFldAad+wyeI2+50OPis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715679801; c=relaxed/simple;
	bh=GNuSE3s2r9EbP9ocQpFNdq2tZtq7uo/Tjsb9ccdwGJY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXnTdxWbwcsgBHx7xArle/wQI1uXzEWK/ZTdakR797qwGxZzqMlQsPGsq1c3xOWRE5UGX6OBFOKZFAZlv/LZbIVgB3F38vbpv3N6N9zHcc1n8y05hO3pBeJoTBbRzIHIbFsUWQCkaiVQlMpKlHpbtCA+nyT+EMFMAUGcZBn6Xts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=iWMQ5of0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-34ca50999cdso277076f8f.2
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 02:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715679796; x=1716284596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEietWmYD6kKU/pV6wujRo1uhNo/bfHaQjmoZVTM8+A=;
        b=iWMQ5of0/ggMHzemNXGUGyT0aEwb8+6FgtXh5FkV01Su/b2T8pycIpxmyLrnpo6ds8
         VLiglOgv+TFRb/7+BRusIGNNEaWMXZ5ezwpknsmQ/lMuTkLdXCRiSWo60xVRKm+toslz
         LTKi83IDni+xqjly7SCgd9ij3Z9FJzNGw/x+ZL+st2uQYWtvfYRYB7o1eFjnQyWJNFFJ
         T8ZeBybw01vSgI7sDMfLF6uNcZAYnmpCAKCDwWgmNNEq4XFDLQfmsdCFLU0e4mEnuED7
         YO/gYBWt0qXdOjS8eVCPDuHJYFgS936FcpCkBUAhUXm0dzJg74swQ/sl4iYEbJ4BFBVk
         Gsrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715679796; x=1716284596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEietWmYD6kKU/pV6wujRo1uhNo/bfHaQjmoZVTM8+A=;
        b=SZyLiVBxsum4d0WjV/K0vX2cbXRNI2LKT/jz5Oehhv4VVSzDHB/FTsgsVrBYN3d0qs
         IZo5HrV4xBeIE+xy1c62UdM2sDMY5QCbz72S2aH/SbHxIgWtpRc3Zuua4FAIb08KJC5z
         lbNehtpHFGlV2NtM+nyonFMkXSIrJ2GcWTHOyRSCdZyGW84LQDGfMyl/QMHACky6Stg6
         RzytsF2uBuzy938P5ILgPpp3QUHfEqnzL0bgsDxORNojzgoPQz/QFwqwGiF816rG/w5R
         UQ+Hkm5bXbmCu24QxFgOJfmpQpA7m0suHPjRyaYoHH4Ygu+ghAhtl/k8TOlK9yHMXkM8
         kBPA==
X-Forwarded-Encrypted: i=1; AJvYcCUHKGqQnaRelVagTSdGCTIuvCz01LrFDBc3i8Xa4DQFm4noS/5gyQi1jE49H2GVts6/G42KiydmsJpjE61NUTOQfK/B
X-Gm-Message-State: AOJu0Yzuo8AFs0JxTPF34r7zSkh3+SfPxvNrSA77Jv5r9DMJf4wzBEAF
	YZO/OAy/zjDltUJ+yE97Z4LTvdFDCji31KYfCjbqlNfQsXpCfS0xzjzi9kM1Ck0=
X-Google-Smtp-Source: AGHT+IHsscONJjXt03GkOV8zZbc6kOxoRUClFHpAMSKc94NJeP6QWGgAaazEO2tWqCS4ba0q1uyBGQ==
X-Received: by 2002:a05:600c:1c11:b0:41f:9c43:574f with SMTP id 5b1f17b1804b1-41feac59cffmr88723965e9.3.1715679796443;
        Tue, 14 May 2024 02:43:16 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:1660:5f6e:2f9c:91b9? ([2a01:e0a:999:a3a0:1660:5f6e:2f9c:91b9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41faedf5dcesm76566455e9.0.2024.05.14.02.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 02:43:15 -0700 (PDT)
Message-ID: <c8e4c44d-8125-417e-8c61-a1f6d438815e@rivosinc.com>
Date: Tue, 14 May 2024 11:43:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/7] riscv: kvm: add SBI FWFT support for
 SBI_FWFT_DOUBLE_TRAP_ENABLE
To: Deepak Gupta <debug@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-7-cleger@rivosinc.com>
 <ZixSFLZYZaf8BKHP@debug.ba.rivosinc.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <ZixSFLZYZaf8BKHP@debug.ba.rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 27/04/2024 03:17, Deepak Gupta wrote:
> On Thu, Apr 18, 2024 at 04:26:45PM +0200, Clément Léger wrote:
>> Add support in KVM SBI FWFT extension to allow VS-mode to request double
>> trap enabling. Double traps can then be generated by VS-mode, allowing
>> M-mode to redirect them to S-mode.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>> arch/riscv/include/asm/csr.h               |  1 +
>> arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
>> arch/riscv/kvm/vcpu_sbi_fwft.c             | 41 ++++++++++++++++++++++
>> 3 files changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>> index 905cdf894a57..ee1b73655bec 100644
>> --- a/arch/riscv/include/asm/csr.h
>> +++ b/arch/riscv/include/asm/csr.h
>> @@ -196,6 +196,7 @@
>> /* xENVCFG flags */
>> #define ENVCFG_STCE            (_AC(1, ULL) << 63)
>> #define ENVCFG_PBMTE            (_AC(1, ULL) << 62)
>> +#define ENVCFG_DTE            (_AC(1, ULL) << 59)
>> #define ENVCFG_CBZE            (_AC(1, UL) << 7)
>> #define ENVCFG_CBCFE            (_AC(1, UL) << 6)
>> #define ENVCFG_CBIE_SHIFT        4
>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>> b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>> index 7dc1b80c7e6c..a9e20d655126 100644
>> --- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>> @@ -11,7 +11,7 @@
>>
>> #include <asm/sbi.h>
>>
>> -#define KVM_SBI_FWFT_FEATURE_COUNT    1
>> +#define KVM_SBI_FWFT_FEATURE_COUNT    2
>>
>> struct kvm_sbi_fwft_config;
>> struct kvm_vcpu;
>> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c
>> b/arch/riscv/kvm/vcpu_sbi_fwft.c
>> index b9b7f8fa6d22..9e8e397eb02f 100644
>> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
>> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>> @@ -9,10 +9,19 @@
>> #include <linux/errno.h>
>> #include <linux/err.h>
>> #include <linux/kvm_host.h>
>> +#include <linux/riscv_dbltrp.h>
>> #include <asm/sbi.h>
>> #include <asm/kvm_vcpu_sbi.h>
>> #include <asm/kvm_vcpu_sbi_fwft.h>
>>
>> +#ifdef CONFIG_32BIT
>> +# define CSR_HENVCFG_DBLTRP    CSR_HENVCFGH
>> +# define DBLTRP_DTE    (ENVCFG_DTE >> 32)
>> +#else
>> +# define CSR_HENVCFG_DBLTRP    CSR_HENVCFG
>> +# define DBLTRP_DTE    ENVCFG_DTE
>> +#endif
>> +
>> #define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL <<
>> EXC_STORE_MISALIGNED)
>>
>> static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
>> @@ -36,6 +45,33 @@ static int
>> kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>>     return SBI_SUCCESS;
>> }
>>
>> +static int kvm_sbi_fwft_set_double_trap(struct kvm_vcpu *vcpu,
>> +                    struct kvm_sbi_fwft_config *conf,
>> +                    unsigned long value)
>> +{
>> +    if (!riscv_double_trap_enabled())
>> +        return SBI_ERR_NOT_SUPPORTED;
> 
> Why its required to check whether host has enabled double trap for itself ?
> It's orthogonal to guest asking hypervisor to enable double trap.

Hi Deepak,

Indeed, as you saw, henvcfg.DTE needs menvcfg.DTE to be enabled in order
to be usable.

> 
> Probably you need a check here whether underlying FW supports handling
> double
> trap.
> 
> Am I missing something here?
> 
>> +
>> +    if (value)
>> +        csr_set(CSR_HENVCFG_DBLTRP, DBLTRP_DTE);
>> +    else
>> +        csr_clear(CSR_HENVCFG_DBLTRP, DBLTRP_DTE);
> 
> I think vcpu->arch.cfg has `henvcfg` field. Can we reflect it there as
> well so that current
> `henvcfg` copy in vcpu arch specifci config is consistent? Otherwise
> it'll be lost when vCPU
> is scheduled out and later scheduled back in (on vcpu load)

henvcfg is restored when loading the vpcu (kvm_arch_vcpu_load()) and
saved when the CPU is put (kvm_arch_vcpu_put()). But I just saw that
this change is included in the next patch. Should have been this one ,
I'll fix that.


> 
> Furthermore, lets not do feature specific alias names for CSR.
> 
> Instead let's keep consistent 64bit image of henvcfg in vcpu->arch.cfg.
> 
> And whenever it's time to pick up the setting, pick up logic either
> perform the writes in
> henvcfg. And if required it'll perform henvcfgh too (as
> `kvm_arch_vcpu_load` already does)

I don't have a strong opinion on that point so if you think it really is
better, I'll switch to that.

Thanks,

Clément

> 
>> +
>> +    return SBI_SUCCESS;
>> +}
>> +
>> +static int kvm_sbi_fwft_get_double_trap(struct kvm_vcpu *vcpu,
>> +                    struct kvm_sbi_fwft_config *conf,
>> +                    unsigned long *value)
>> +{
>> +    if (!riscv_double_trap_enabled())
>> +        return SBI_ERR_NOT_SUPPORTED;
>> +
>> +    *value = (csr_read(CSR_HENVCFG_DBLTRP) & DBLTRP_DTE) != 0;
>> +
>> +    return SBI_SUCCESS;
>> +}
>> +
>> static struct kvm_sbi_fwft_config *
>> kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t
>> feature)
>> {
>> @@ -111,6 +147,11 @@ static const struct kvm_sbi_fwft_feature
>> features[] = {
>>         .id = SBI_FWFT_MISALIGNED_DELEG,
>>         .set = kvm_sbi_fwft_set_misaligned_delegation,
>>         .get = kvm_sbi_fwft_get_misaligned_delegation,
>> +    },
>> +    {
>> +        .id = SBI_FWFT_DOUBLE_TRAP_ENABLE,
>> +        .set = kvm_sbi_fwft_set_double_trap,
>> +        .get = kvm_sbi_fwft_get_double_trap,
>>     }
>> };
>>
>> -- 
>> 2.43.0
>>
>>

