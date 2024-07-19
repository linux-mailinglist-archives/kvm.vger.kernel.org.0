Return-Path: <kvm+bounces-21919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87145937478
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 09:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD13EB22009
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 07:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1255914C;
	Fri, 19 Jul 2024 07:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="iGSkpY48"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FCE52F70
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 07:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721374692; cv=none; b=lvtuk/YGLTQg6HNvndN/s2kb2swoCxyyHhFKgjWx4y4ZZ7eOUEd/axxGSnurwZYkbqL6k/UOkV8O7eYz3/yqyGVQ86N5RbyQCNxy30ODXJLTPp/sA0BlxjObqTwktMqMVizxL+AqaG3Ev+VUAYSwWnrtrldjVYJ8zQBIA9rByhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721374692; c=relaxed/simple;
	bh=fIgEVj98jncjXCb102DxgJHKQQ7Dc24+S9FdtafqhnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NvFEXVKE7puZJUx7PWrRXBkJEezfmyLyXjeEpoPOhhOCG0wg4DRyntcM9+1m7j5iTF63rVZ0spRE8wPzJsShjTuCf3aQt4yBFN2BdYXhs6zW0Ejyi1Jxs7TnSaRzoQSDzZImAgZmYBNbgkfNny8cukBwyZkR0g9FJO3wMwE1EkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=iGSkpY48; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42671c659e4so973975e9.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 00:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1721374687; x=1721979487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jwgXEqFoIQ8Qnw3vnSPZZVOe2UVdpjRinxoXuv0AT+s=;
        b=iGSkpY48rh31HtFry0CXs632MUf+Fu44iON9J5heLpNVKQcN231Iv1n/cLy8VK8sNX
         0MfYiOoegOwH4hoKLoy4Vzf6u0kf3JXEzF6ahfZINMDfMokyfU+u6MbarSg6/2MJdpV+
         bWf68AQXoUFO8QLeNrqG1K4fr3+fQ2IkPX3C84JAkq22vZasfQd2ROXSQdxAondWNi4U
         +9Wz2zNL/0RaylOCljFX/WB+zalRxsV2AVwGEZ7ju5kv4Xith6u/h+gicDqu6mmeUx7Y
         Gm02kE3NgrxjmwI29bh3Y99byYsW9OFHwt78WfC5R5BNStvWRnYl7Deg8/IhHh/GxnbT
         FZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721374687; x=1721979487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwgXEqFoIQ8Qnw3vnSPZZVOe2UVdpjRinxoXuv0AT+s=;
        b=o01dyYIWgy9qD1zl1Fu3kvL4ss1hLTiKidjTln+Eig6bwd0hNB0dGMYWlKomsjUAle
         fPUU0tf89YmyRacYyovrtNqRLi2b7y2LLLw952dNu4tzN0ywnCdeskIBMzCPPpZ56z6T
         If0TjP/XTY3tJQVG5zzFCHoHf+XW+cH8ojo4MTb4ZtUyrP0fk5lHh5ngEnfEBFii0npG
         nK9so0X4ScpPBKoqovykNpx/J0p5WIaAxlk/XJSKwdOf8eaDUHwMcFm/w8JaoFmkx7xp
         zH6AnlMNGf+b79qNW5lnvh35d9+VLzmAhPLekjRHwplDyayGz8A2w9ip/z71U9MtzOyL
         QOyw==
X-Forwarded-Encrypted: i=1; AJvYcCUKiCex/Z3dInU7s3AUOcxcpmVjek/jLakgv4Obral1J60powbfIvlBlVz1nmN2SPHQgdU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWlImA06LlQEmDl1T9GAKeKJF4jqoP/0/x+kUSc+rMvxlT7gCE
	0ZfHc0HVbBDElN4LDNIkmIiCI6ZuXkbuKCczcK2ZXdRzNq0qFSkJHN92x4EryAQz+IjdK5hlZBz
	ljaE=
X-Google-Smtp-Source: AGHT+IEZptXdeMHbUpkxHv4M1h0uA22gKqUctjYLtu3zi6c+9V9bfZiObnfgruMuoet83T2afxZhsg==
X-Received: by 2002:a05:600c:3c9f:b0:425:7ac6:96f9 with SMTP id 5b1f17b1804b1-427d5b80f8fmr5754795e9.0.1721374686645;
        Fri, 19 Jul 2024 00:38:06 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427d6906c77sm14275665e9.23.2024.07.19.00.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 00:38:06 -0700 (PDT)
Message-ID: <2f1c7dff-168e-4ad0-b426-cfe99fc33fd0@rivosinc.com>
Date: Fri, 19 Jul 2024 09:38:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/4] RISC-V: Add Svade and Svadu Extensions Support
To: Alexandre Ghiti <alex@ghiti.fr>, Yong-Xuan Wang
 <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com,
 Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 Conor Dooley <conor.dooley@microchip.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Atish Patra <atishp@rivosinc.com>, Samuel Ortiz <sameo@rivosinc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Samuel Holland <samuel.holland@sifive.com>, Evan Green <evan@rivosinc.com>,
 Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Leonardo Bras <leobras@redhat.com>,
 Charlie Jenkins <charlie@rivosinc.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jisheng Zhang <jszhang@kernel.org>
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-2-yongxuan.wang@sifive.com>
 <6ad0c386-6777-4467-bab4-8fba149f3bfe@ghiti.fr>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <6ad0c386-6777-4467-bab4-8fba149f3bfe@ghiti.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



Hi Yong-Xuan,


On 18/07/2024 18:43, Alexandre Ghiti wrote:
> Hi Yong-Xuan,
> 
> On 12/07/2024 10:38, Yong-Xuan Wang wrote:
>> Svade and Svadu extensions represent two schemes for managing the PTE A/D
>> bits. When the PTE A/D bits need to be set, Svade extension intdicates
>> that a related page fault will be raised. In contrast, the Svadu
>> extension
>> supports hardware updating of PTE A/D bits. Since the Svade extension is
>> mandatory and the Svadu extension is optional in RVA23 profile, by
>> default
>> the M-mode firmware will enable the Svadu extension in the menvcfg CSR
>> when only Svadu is present in DT.
>>
>> This patch detects Svade and Svadu extensions from DT and adds
>> arch_has_hw_pte_young() to enable optimization in MGLRU and
>> __wp_page_copy_user() when we have the PTE A/D bits hardware updating
>> support.
>>
>> Co-developed-by: Jinyu Tang <tjytimi@163.com>
>> Signed-off-by: Jinyu Tang <tjytimi@163.com>
>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> ---
>>   arch/riscv/Kconfig               |  1 +
>>   arch/riscv/include/asm/csr.h     |  1 +
>>   arch/riscv/include/asm/hwcap.h   |  2 ++
>>   arch/riscv/include/asm/pgtable.h | 13 ++++++++++++-
>>   arch/riscv/kernel/cpufeature.c   | 32 ++++++++++++++++++++++++++++++++
>>   5 files changed, 48 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index 0525ee2d63c7..3d705e28ff85 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -36,6 +36,7 @@ config RISCV
>>       select ARCH_HAS_PMEM_API
>>       select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>>       select ARCH_HAS_PTE_SPECIAL
>> +    select ARCH_HAS_HW_PTE_YOUNG
>>       select ARCH_HAS_SET_DIRECT_MAP if MMU
>>       select ARCH_HAS_SET_MEMORY if MMU
>>       select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
>> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>> index 25966995da04..524cd4131c71 100644
>> --- a/arch/riscv/include/asm/csr.h
>> +++ b/arch/riscv/include/asm/csr.h
>> @@ -195,6 +195,7 @@
>>   /* xENVCFG flags */
>>   #define ENVCFG_STCE            (_AC(1, ULL) << 63)
>>   #define ENVCFG_PBMTE            (_AC(1, ULL) << 62)
>> +#define ENVCFG_ADUE            (_AC(1, ULL) << 61)
>>   #define ENVCFG_CBZE            (_AC(1, UL) << 7)
>>   #define ENVCFG_CBCFE            (_AC(1, UL) << 6)
>>   #define ENVCFG_CBIE_SHIFT        4
>> diff --git a/arch/riscv/include/asm/hwcap.h
>> b/arch/riscv/include/asm/hwcap.h
>> index e17d0078a651..35d7aa49785d 100644
>> --- a/arch/riscv/include/asm/hwcap.h
>> +++ b/arch/riscv/include/asm/hwcap.h
>> @@ -81,6 +81,8 @@
>>   #define RISCV_ISA_EXT_ZTSO        72
>>   #define RISCV_ISA_EXT_ZACAS        73
>>   #define RISCV_ISA_EXT_XANDESPMU        74
>> +#define RISCV_ISA_EXT_SVADE             75
>> +#define RISCV_ISA_EXT_SVADU        76
>>     #define RISCV_ISA_EXT_XLINUXENVCFG    127
>>   diff --git a/arch/riscv/include/asm/pgtable.h
>> b/arch/riscv/include/asm/pgtable.h
>> index aad8b8ca51f1..ec0cdacd7da0 100644
>> --- a/arch/riscv/include/asm/pgtable.h
>> +++ b/arch/riscv/include/asm/pgtable.h
>> @@ -120,6 +120,7 @@
>>   #include <asm/tlbflush.h>
>>   #include <linux/mm_types.h>
>>   #include <asm/compat.h>
>> +#include <asm/cpufeature.h>
>>     #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >>
>> _PAGE_PFN_SHIFT)
>>   @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
>>   }
>>     #ifdef CONFIG_RISCV_ISA_SVNAPOT
>> -#include <asm/cpufeature.h>
>>     static __always_inline bool has_svnapot(void)
>>   {
>> @@ -624,6 +624,17 @@ static inline pgprot_t
>> pgprot_writecombine(pgprot_t _prot)
>>       return __pgprot(prot);
>>   }
>>   +/*
>> + * Both Svade and Svadu control the hardware behavior when the PTE
>> A/D bits need to be set. By
>> + * default the M-mode firmware enables the hardware updating scheme
>> when only Svadu is present in
>> + * DT.
>> + */
>> +#define arch_has_hw_pte_young arch_has_hw_pte_young
>> +static inline bool arch_has_hw_pte_young(void)
>> +{
>> +    return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
>> +}
>> +
>>   /*
>>    * THP functions
>>    */
>> diff --git a/arch/riscv/kernel/cpufeature.c
>> b/arch/riscv/kernel/cpufeature.c
>> index 5ef48cb20ee1..b2c3fe945e89 100644
>> --- a/arch/riscv/kernel/cpufeature.c
>> +++ b/arch/riscv/kernel/cpufeature.c
>> @@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>>       __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>>       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>>       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>> +    __RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
>> +    __RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
>>       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>>       __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>>       __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
>> @@ -554,6 +556,21 @@ static void __init
>> riscv_fill_hwcap_from_isa_string(unsigned long *isa2hwcap)
>>               clear_bit(RISCV_ISA_EXT_v, isainfo->isa);
>>           }
>>   +        /*
>> +         * When neither Svade nor Svadu present in DT, it is technically
>> +         * unknown whether the platform uses Svade or Svadu.
>> Supervisor may
>> +         * assume Svade to be present and enabled or it can discover
>> based
>> +         * on mvendorid, marchid, and mimpid. When both Svade and
>> Svadu present
>> +         * in DT, supervisor must assume Svadu turned-off at boot
>> time. To use
>> +         * Svadu, supervisor must explicitly enable it using the SBI
>> FWFT extension.
>> +         */
>> +        if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
>> +            !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
>> +            set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
>> +        else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
>> +             test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
>> +            clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
>> +
>>           /*
>>            * All "okay" hart should have same isa. Set HWCAP based on
>>            * common capabilities of every "okay" hart, in case they don't
>> @@ -619,6 +636,21 @@ static int __init
>> riscv_fill_hwcap_from_ext_list(unsigned long *isa2hwcap)
>>             of_node_put(cpu_node);
>>   +        /*
>> +         * When neither Svade nor Svadu present in DT, it is technically
>> +         * unknown whether the platform uses Svade or Svadu.
>> Supervisor may
>> +         * assume Svade to be present and enabled or it can discover
>> based
>> +         * on mvendorid, marchid, and mimpid. When both Svade and
>> Svadu present
>> +         * in DT, supervisor must assume Svadu turned-off at boot
>> time. To use
>> +         * Svadu, supervisor must explicitly enable it using the SBI
>> FWFT extension.
>> +         */
>> +        if (!test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
>> +            !test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
>> +            set_bit(RISCV_ISA_EXT_SVADE, isainfo->isa);
>> +        else if (test_bit(RISCV_ISA_EXT_SVADE, isainfo->isa) &&
>> +             test_bit(RISCV_ISA_EXT_SVADU, isainfo->isa))
>> +            clear_bit(RISCV_ISA_EXT_SVADU, isainfo->isa);
>> +

This is a duplicate of the previous chunk of code. Moreover, now that we
have a .validate callback for ISA extension (in for-next), I would
prefer this to be based on that support rather that having duplicated
extension specific handling code.

I think this could be translated (almost) using the following
.validate() callback for SVADU/SVADE extension:

static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
				  const unsigned long *isa_bitmap)
{
	/* SVADE has already been detected, use SVADE only */
	if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_SVADE))
		return -ENOTSUPP;

	return 0;
}

static int riscv_ext_svade_validate(const struct riscv_isa_ext_data *data,
				  const unsigned long *isa_bitmap)
{
	/* Clear SVADU, it will be enable using the FWFT extension if present */
	clear_bit(RISCV_ISA_EXT_SVADU, isa_bitmap);

	return 0;
}

However, this will not enable SVADE if neither SVADU/SVADE are set (as
done by your patch) but since SVADE does not seems to be used explicitly
in your patch series, I think it is sane to keep it like that.

Thanks,

Clément



>>           /*
>>            * All "okay" harts should have same isa. Set HWCAP based on
>>            * common capabilities of every "okay" hart, in case they
>> don't.
> 
> 
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> 
> Thanks,
> 
> Alex
> 

