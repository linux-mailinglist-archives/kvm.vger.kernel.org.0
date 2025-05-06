Return-Path: <kvm+bounces-45562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 657D6AABC82
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 10:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAD42172BAF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815B01EBFE0;
	Tue,  6 May 2025 08:05:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F866CA6B;
	Tue,  6 May 2025 08:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746518731; cv=none; b=rimSgmMgvXGfuKEB4Ydtxiu9BCQCHKTr/Ik/L3kQW7BFOZyoSBe+oZARbeGTc4cyEuJEch5j41ztv2LkvbfERvJKdsYIllMf8KvTEA0yz4arisbwknY1P7VPc5LieX0kZNxrduXcbyFVOKD5csswMtwXbZC6NLUWCgVxKV7SiD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746518731; c=relaxed/simple;
	bh=BOJ0G3dPk7G089vRafNe2YwqOxUXPQQ7nSghUo3eQTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r34yZs/jPhGqEvasdG3Ko3Ds4HnMWVgvrNVo1u+vYnTX9zTjHtqusfJ9dEPKsaoCD/yl5/KIt8UbmJBG61zDNunxL2S7onQJHNIaRAIn6WGe+oeu7vzgkhrafeioLnqQIz6FEt1L8aJ/K98s129eAcXeRmgCR2n+jWZhvQx9Jr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 184851FCF4;
	Tue,  6 May 2025 08:05:22 +0000 (UTC)
Message-ID: <35fed0e0-abfd-42a3-856d-ce7c9b696964@ghiti.fr>
Date: Tue, 6 May 2025 10:05:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] riscv: Move all duplicate insn parsing macros into
 asm/insn.h
Content-Language: en-US
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-4-alexghiti@rivosinc.com>
 <64273b62-3deb-4a1b-b97c-8a98f7d9a9d1@rivosinc.com>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <64273b62-3deb-4a1b-b97c-8a98f7d9a9d1@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvkeefgeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhepveffvdeileeitddtheevgfehjedtuddtudfgvdevgedthfefgeeuhfeufeevteefnecuffhomhgrihhnpehinhhfrhgruggvrggurdhorhhgnecukfhppedvtddtudemkeeiudemfeefkedvmegvfheltdemheekvgdumehfvdgsgeemjegrledvmeefvdeltdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvtddtudemkeeiudemfeefkedvmegvfheltdemheekvgdumehfvdgsgeemjegrledvmeefvdeltddphhgvlhhopeglkffrggeimedvtddtudemkeeiudemfeefkedvmegvfheltdemheekvgdumehfvdgsgeemjegrledvmeefvdeltdgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepuddtpdhrtghpthhtoheptghlvghgvghrsehrihhvohhsihhntgdrtghomhdprhgtphhtthhopegrlhgvgihghhhithhisehrihhvohhsihhntgdrtghomhdprhgtphhtthhop
 ehprghulhdrfigrlhhmshhlvgihsehsihhfihhvvgdrtghomhdprhgtphhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprhgtphhtthhopegrnhhuphessghrrghinhhfrghulhhtrdhorhhgpdhrtghpthhtoheprghtihhshhhpsegrthhishhhphgrthhrrgdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-GND-Sasl: alex@ghiti.fr

Hi Clément,

On 22/04/2025 11:36, Clément Léger wrote:
>
> On 22/04/2025 10:25, Alexandre Ghiti wrote:
>> kernel/traps_misaligned.c and kvm/vcpu_insn.c define the same macros to
>> extract information from the instructions.
>>
>> Let's move the definitions into asm/insn.h to avoid this duplication.
>>
>> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>> ---
>>   arch/riscv/include/asm/insn.h        | 164 +++++++++++++++++++++++++++
>>   arch/riscv/kernel/elf_kexec.c        |   1 +
>>   arch/riscv/kernel/traps_misaligned.c | 136 +---------------------
>>   arch/riscv/kvm/vcpu_insn.c           | 127 +--------------------
>>   4 files changed, 167 insertions(+), 261 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
>> index 4063ca35be9b..35f316cdd699 100644
>> --- a/arch/riscv/include/asm/insn.h
>> +++ b/arch/riscv/include/asm/insn.h
>> @@ -286,9 +286,173 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>>   	       (code & RVC_INSN_J_RS1_MASK) != 0;
>>   }
>>   
>> +#define INSN_MATCH_LB		0x3
>> +#define INSN_MASK_LB		0x707f
>> +#define INSN_MATCH_LH		0x1003
>> +#define INSN_MASK_LH		0x707f
>> +#define INSN_MATCH_LW		0x2003
>> +#define INSN_MASK_LW		0x707f
>> +#define INSN_MATCH_LD		0x3003
>> +#define INSN_MASK_LD		0x707f
>> +#define INSN_MATCH_LBU		0x4003
>> +#define INSN_MASK_LBU		0x707f
>> +#define INSN_MATCH_LHU		0x5003
>> +#define INSN_MASK_LHU		0x707f
>> +#define INSN_MATCH_LWU		0x6003
>> +#define INSN_MASK_LWU		0x707f
>> +#define INSN_MATCH_SB		0x23
>> +#define INSN_MASK_SB		0x707f
>> +#define INSN_MATCH_SH		0x1023
>> +#define INSN_MASK_SH		0x707f
>> +#define INSN_MATCH_SW		0x2023
>> +#define INSN_MASK_SW		0x707f
>> +#define INSN_MATCH_SD		0x3023
>> +#define INSN_MASK_SD		0x707f
>> +
>> +#define INSN_MATCH_C_LD		0x6000
>> +#define INSN_MASK_C_LD		0xe003
>> +#define INSN_MATCH_C_SD		0xe000
>> +#define INSN_MASK_C_SD		0xe003
>> +#define INSN_MATCH_C_LW		0x4000
>> +#define INSN_MASK_C_LW		0xe003
>> +#define INSN_MATCH_C_SW		0xc000
>> +#define INSN_MASK_C_SW		0xe003
>> +#define INSN_MATCH_C_LDSP	0x6002
>> +#define INSN_MASK_C_LDSP	0xe003
>> +#define INSN_MATCH_C_SDSP	0xe002
>> +#define INSN_MASK_C_SDSP	0xe003
>> +#define INSN_MATCH_C_LWSP	0x4002
>> +#define INSN_MASK_C_LWSP	0xe003
>> +#define INSN_MATCH_C_SWSP	0xc002
>> +#define INSN_MASK_C_SWSP	0xe003
>> +
>> +#define INSN_OPCODE_MASK	0x007c
>> +#define INSN_OPCODE_SHIFT	2
>> +#define INSN_OPCODE_SYSTEM	28
>> +
>> +#define INSN_MASK_WFI		0xffffffff
>> +#define INSN_MATCH_WFI		0x10500073
>> +
>> +#define INSN_MASK_WRS		0xffffffff
>> +#define INSN_MATCH_WRS		0x00d00073
>> +
>> +#define INSN_MATCH_CSRRW	0x1073
>> +#define INSN_MASK_CSRRW		0x707f
>> +#define INSN_MATCH_CSRRS	0x2073
>> +#define INSN_MASK_CSRRS		0x707f
>> +#define INSN_MATCH_CSRRC	0x3073
>> +#define INSN_MASK_CSRRC		0x707f
>> +#define INSN_MATCH_CSRRWI	0x5073
>> +#define INSN_MASK_CSRRWI	0x707f
>> +#define INSN_MATCH_CSRRSI	0x6073
>> +#define INSN_MASK_CSRRSI	0x707f
>> +#define INSN_MATCH_CSRRCI	0x7073
>> +#define INSN_MASK_CSRRCI	0x707f
>> +
>> +#define INSN_MATCH_FLW			0x2007
>> +#define INSN_MASK_FLW			0x707f
>> +#define INSN_MATCH_FLD			0x3007
>> +#define INSN_MASK_FLD			0x707f
>> +#define INSN_MATCH_FLQ			0x4007
>> +#define INSN_MASK_FLQ			0x707f
>> +#define INSN_MATCH_FSW			0x2027
>> +#define INSN_MASK_FSW			0x707f
>> +#define INSN_MATCH_FSD			0x3027
>> +#define INSN_MASK_FSD			0x707f
>> +#define INSN_MATCH_FSQ			0x4027
>> +#define INSN_MASK_FSQ			0x707f
>> +
>> +#define INSN_MATCH_C_FLD		0x2000
>> +#define INSN_MASK_C_FLD			0xe003
>> +#define INSN_MATCH_C_FLW		0x6000
>> +#define INSN_MASK_C_FLW			0xe003
>> +#define INSN_MATCH_C_FSD		0xa000
>> +#define INSN_MASK_C_FSD			0xe003
>> +#define INSN_MATCH_C_FSW		0xe000
>> +#define INSN_MASK_C_FSW			0xe003
>> +#define INSN_MATCH_C_FLDSP		0x2002
>> +#define INSN_MASK_C_FLDSP		0xe003
>> +#define INSN_MATCH_C_FSDSP		0xa002
>> +#define INSN_MASK_C_FSDSP		0xe003
>> +#define INSN_MATCH_C_FLWSP		0x6002
>> +#define INSN_MASK_C_FLWSP		0xe003
>> +#define INSN_MATCH_C_FSWSP		0xe002
>> +#define INSN_MASK_C_FSWSP		0xe003
>> +
>> +#define INSN_16BIT_MASK		0x3
>> +
>> +#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
>> +
>> +#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
>> +
>> +#define SHIFT_RIGHT(x, y)               \
>> +	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
>> +
>> +#define REG_MASK			\
>> +	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
>> +
>> +#define REG_OFFSET(insn, pos)		\
>> +	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
>> +
>> +#define REG_PTR(insn, pos, regs)	\
>> +	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
>> +
>> +#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
>> +#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
>> +#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
>> +#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
>> +#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
>> +#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
>> +#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
>> +#define IMM_I(insn)		((s32)(insn) >> 20)
>> +#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
>> +				 (s32)(((insn) >> 7) & 0x1f))
> Hi Alex,
>
>> +#define GET_PRECISION(insn) (((insn) >> 25) & 3)
>> +#define GET_RM(insn) (((insn) >> 12) & 7)
>> +#define PRECISION_S 0
>> +#define PRECISION_D 1
> These 4 defines seems unused.
>
>> +
>> +#define SH_RD			7
>> +#define SH_RS1			15
>> +#define SH_RS2			20
>> +#define SH_RS2C			2
>> +#define MASK_RX			0x1f
>> +
>> +#if defined(CONFIG_64BIT)
>> +#define LOG_REGBYTES			3
> There is already a definition for pointer log in asm.h (RISCV_LGPTR)
> although it's a string for !ASSEMBLY, maybe that could be reused rather
> than duplicating that ?


It does not work out of the box because of the string definition for 
!ASSEMBLY, I'll keep it that way then to avoid introducing a new define 
(I just move stuff here).


>
>> +#define XLEN				64
>> +#else
>> +#define LOG_REGBYTES			2
>> +#define XLEN				32
>> +#endif
>
>> +#define REGBYTES			(1 << LOG_REGBYTES)
>> +#define XLEN_MINUS_16			((XLEN) - 16)
> These 2 defines seems unused and can be removed (XLEN can be removed as
> well)
>
> Thanks,
>
> Clément


Thanks,

Alex


>
>> +
>> +#define MASK_FUNCT3			0x7000
>> +
>> +#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
>> +
>>   #define RV_IMM_SIGN(x) (-(((x) >> 31) & 1))
>>   #define RVC_IMM_SIGN(x) (-(((x) >> 12) & 1))
>>   #define RV_X(X, s, n) (((X) >> (s)) & ((1 << (n)) - 1))
>> +#define RVC_LW_IMM(x)	((RV_X(x, 6, 1) << 2) | \
>> +			 (RV_X(x, 10, 3) << 3) | \
>> +			 (RV_X(x, 5, 1) << 6))
>> +#define RVC_LD_IMM(x)	((RV_X(x, 10, 3) << 3) | \
>> +			 (RV_X(x, 5, 2) << 6))
>> +#define RVC_LWSP_IMM(x)	((RV_X(x, 4, 3) << 2) | \
>> +			 (RV_X(x, 12, 1) << 5) | \
>> +			 (RV_X(x, 2, 2) << 6))
>> +#define RVC_LDSP_IMM(x)	((RV_X(x, 5, 2) << 3) | \
>> +			 (RV_X(x, 12, 1) << 5) | \
>> +			 (RV_X(x, 2, 3) << 6))
>> +#define RVC_SWSP_IMM(x)	((RV_X(x, 9, 4) << 2) | \
>> +			 (RV_X(x, 7, 2) << 6))
>> +#define RVC_SDSP_IMM(x)	((RV_X(x, 10, 3) << 3) | \
>> +			 (RV_X(x, 7, 3) << 6))
>> +#define RVC_RS1S(insn)	(8 + RV_X(insn, SH_RD, 3))
>> +#define RVC_RS2S(insn)	(8 + RV_X(insn, SH_RS2C, 3))
>> +#define RVC_RS2(insn)	RV_X(insn, SH_RS2C, 5)
>>   #define RV_X_mask(X, s, mask)  (((X) >> (s)) & (mask))
>>   #define RVC_X(X, s, mask) RV_X_mask(X, s, mask)
>>   
>> diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
>> index 15e6a8f3d50b..1c3b76a67356 100644
>> --- a/arch/riscv/kernel/elf_kexec.c
>> +++ b/arch/riscv/kernel/elf_kexec.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/memblock.h>
>>   #include <linux/vmalloc.h>
>>   #include <asm/setup.h>
>> +#include <asm/insn.h>
>>   
>>   int arch_kimage_file_post_load_cleanup(struct kimage *image)
>>   {
>> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
>> index fb2599d62752..0151f670cd46 100644
>> --- a/arch/riscv/kernel/traps_misaligned.c
>> +++ b/arch/riscv/kernel/traps_misaligned.c
>> @@ -17,141 +17,7 @@
>>   #include <asm/hwprobe.h>
>>   #include <asm/cpufeature.h>
>>   #include <asm/vector.h>
>> -
>> -#define INSN_MATCH_LB			0x3
>> -#define INSN_MASK_LB			0x707f
>> -#define INSN_MATCH_LH			0x1003
>> -#define INSN_MASK_LH			0x707f
>> -#define INSN_MATCH_LW			0x2003
>> -#define INSN_MASK_LW			0x707f
>> -#define INSN_MATCH_LD			0x3003
>> -#define INSN_MASK_LD			0x707f
>> -#define INSN_MATCH_LBU			0x4003
>> -#define INSN_MASK_LBU			0x707f
>> -#define INSN_MATCH_LHU			0x5003
>> -#define INSN_MASK_LHU			0x707f
>> -#define INSN_MATCH_LWU			0x6003
>> -#define INSN_MASK_LWU			0x707f
>> -#define INSN_MATCH_SB			0x23
>> -#define INSN_MASK_SB			0x707f
>> -#define INSN_MATCH_SH			0x1023
>> -#define INSN_MASK_SH			0x707f
>> -#define INSN_MATCH_SW			0x2023
>> -#define INSN_MASK_SW			0x707f
>> -#define INSN_MATCH_SD			0x3023
>> -#define INSN_MASK_SD			0x707f
>> -
>> -#define INSN_MATCH_FLW			0x2007
>> -#define INSN_MASK_FLW			0x707f
>> -#define INSN_MATCH_FLD			0x3007
>> -#define INSN_MASK_FLD			0x707f
>> -#define INSN_MATCH_FLQ			0x4007
>> -#define INSN_MASK_FLQ			0x707f
>> -#define INSN_MATCH_FSW			0x2027
>> -#define INSN_MASK_FSW			0x707f
>> -#define INSN_MATCH_FSD			0x3027
>> -#define INSN_MASK_FSD			0x707f
>> -#define INSN_MATCH_FSQ			0x4027
>> -#define INSN_MASK_FSQ			0x707f
>> -
>> -#define INSN_MATCH_C_LD			0x6000
>> -#define INSN_MASK_C_LD			0xe003
>> -#define INSN_MATCH_C_SD			0xe000
>> -#define INSN_MASK_C_SD			0xe003
>> -#define INSN_MATCH_C_LW			0x4000
>> -#define INSN_MASK_C_LW			0xe003
>> -#define INSN_MATCH_C_SW			0xc000
>> -#define INSN_MASK_C_SW			0xe003
>> -#define INSN_MATCH_C_LDSP		0x6002
>> -#define INSN_MASK_C_LDSP		0xe003
>> -#define INSN_MATCH_C_SDSP		0xe002
>> -#define INSN_MASK_C_SDSP		0xe003
>> -#define INSN_MATCH_C_LWSP		0x4002
>> -#define INSN_MASK_C_LWSP		0xe003
>> -#define INSN_MATCH_C_SWSP		0xc002
>> -#define INSN_MASK_C_SWSP		0xe003
>> -
>> -#define INSN_MATCH_C_FLD		0x2000
>> -#define INSN_MASK_C_FLD			0xe003
>> -#define INSN_MATCH_C_FLW		0x6000
>> -#define INSN_MASK_C_FLW			0xe003
>> -#define INSN_MATCH_C_FSD		0xa000
>> -#define INSN_MASK_C_FSD			0xe003
>> -#define INSN_MATCH_C_FSW		0xe000
>> -#define INSN_MASK_C_FSW			0xe003
>> -#define INSN_MATCH_C_FLDSP		0x2002
>> -#define INSN_MASK_C_FLDSP		0xe003
>> -#define INSN_MATCH_C_FSDSP		0xa002
>> -#define INSN_MASK_C_FSDSP		0xe003
>> -#define INSN_MATCH_C_FLWSP		0x6002
>> -#define INSN_MASK_C_FLWSP		0xe003
>> -#define INSN_MATCH_C_FSWSP		0xe002
>> -#define INSN_MASK_C_FSWSP		0xe003
>> -
>> -#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
>> -
>> -#if defined(CONFIG_64BIT)
>> -#define LOG_REGBYTES			3
>> -#define XLEN				64
>> -#else
>> -#define LOG_REGBYTES			2
>> -#define XLEN				32
>> -#endif
>> -#define REGBYTES			(1 << LOG_REGBYTES)
>> -#define XLEN_MINUS_16			((XLEN) - 16)
>> -
>> -#define SH_RD				7
>> -#define SH_RS1				15
>> -#define SH_RS2				20
>> -#define SH_RS2C				2
>> -
>> -#define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
>> -					 (RV_X(x, 10, 3) << 3) | \
>> -					 (RV_X(x, 5, 1) << 6))
>> -#define RVC_LD_IMM(x)			((RV_X(x, 10, 3) << 3) | \
>> -					 (RV_X(x, 5, 2) << 6))
>> -#define RVC_LWSP_IMM(x)			((RV_X(x, 4, 3) << 2) | \
>> -					 (RV_X(x, 12, 1) << 5) | \
>> -					 (RV_X(x, 2, 2) << 6))
>> -#define RVC_LDSP_IMM(x)			((RV_X(x, 5, 2) << 3) | \
>> -					 (RV_X(x, 12, 1) << 5) | \
>> -					 (RV_X(x, 2, 3) << 6))
>> -#define RVC_SWSP_IMM(x)			((RV_X(x, 9, 4) << 2) | \
>> -					 (RV_X(x, 7, 2) << 6))
>> -#define RVC_SDSP_IMM(x)			((RV_X(x, 10, 3) << 3) | \
>> -					 (RV_X(x, 7, 3) << 6))
>> -#define RVC_RS1S(insn)			(8 + RV_X(insn, SH_RD, 3))
>> -#define RVC_RS2S(insn)			(8 + RV_X(insn, SH_RS2C, 3))
>> -#define RVC_RS2(insn)			RV_X(insn, SH_RS2C, 5)
>> -
>> -#define SHIFT_RIGHT(x, y)		\
>> -	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
>> -
>> -#define REG_MASK			\
>> -	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
>> -
>> -#define REG_OFFSET(insn, pos)		\
>> -	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
>> -
>> -#define REG_PTR(insn, pos, regs)	\
>> -	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
>> -
>> -#define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
>> -#define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
>> -#define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
>> -#define GET_RS2S(insn, regs)		(*REG_PTR(RVC_RS2S(insn), 0, regs))
>> -#define GET_RS2C(insn, regs)		(*REG_PTR(insn, SH_RS2C, regs))
>> -#define GET_SP(regs)			(*REG_PTR(2, 0, regs))
>> -#define SET_RD(insn, regs, val)		(*REG_PTR(insn, SH_RD, regs) = (val))
>> -#define IMM_I(insn)			((s32)(insn) >> 20)
>> -#define IMM_S(insn)			(((s32)(insn) >> 25 << 5) | \
>> -					 (s32)(((insn) >> 7) & 0x1f))
>> -#define MASK_FUNCT3			0x7000
>> -
>> -#define GET_PRECISION(insn) (((insn) >> 25) & 3)
>> -#define GET_RM(insn) (((insn) >> 12) & 7)
>> -#define PRECISION_S 0
>> -#define PRECISION_D 1
>> +#include <asm/insn.h>
>>   
>>   #ifdef CONFIG_FPU
>>   
>> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>> index ba4813673f95..de1f96ea6225 100644
>> --- a/arch/riscv/kvm/vcpu_insn.c
>> +++ b/arch/riscv/kvm/vcpu_insn.c
>> @@ -8,132 +8,7 @@
>>   #include <linux/kvm_host.h>
>>   
>>   #include <asm/cpufeature.h>
>> -
>> -#define INSN_OPCODE_MASK	0x007c
>> -#define INSN_OPCODE_SHIFT	2
>> -#define INSN_OPCODE_SYSTEM	28
>> -
>> -#define INSN_MASK_WFI		0xffffffff
>> -#define INSN_MATCH_WFI		0x10500073
>> -
>> -#define INSN_MASK_WRS		0xffffffff
>> -#define INSN_MATCH_WRS		0x00d00073
>> -
>> -#define INSN_MATCH_CSRRW	0x1073
>> -#define INSN_MASK_CSRRW		0x707f
>> -#define INSN_MATCH_CSRRS	0x2073
>> -#define INSN_MASK_CSRRS		0x707f
>> -#define INSN_MATCH_CSRRC	0x3073
>> -#define INSN_MASK_CSRRC		0x707f
>> -#define INSN_MATCH_CSRRWI	0x5073
>> -#define INSN_MASK_CSRRWI	0x707f
>> -#define INSN_MATCH_CSRRSI	0x6073
>> -#define INSN_MASK_CSRRSI	0x707f
>> -#define INSN_MATCH_CSRRCI	0x7073
>> -#define INSN_MASK_CSRRCI	0x707f
>> -
>> -#define INSN_MATCH_LB		0x3
>> -#define INSN_MASK_LB		0x707f
>> -#define INSN_MATCH_LH		0x1003
>> -#define INSN_MASK_LH		0x707f
>> -#define INSN_MATCH_LW		0x2003
>> -#define INSN_MASK_LW		0x707f
>> -#define INSN_MATCH_LD		0x3003
>> -#define INSN_MASK_LD		0x707f
>> -#define INSN_MATCH_LBU		0x4003
>> -#define INSN_MASK_LBU		0x707f
>> -#define INSN_MATCH_LHU		0x5003
>> -#define INSN_MASK_LHU		0x707f
>> -#define INSN_MATCH_LWU		0x6003
>> -#define INSN_MASK_LWU		0x707f
>> -#define INSN_MATCH_SB		0x23
>> -#define INSN_MASK_SB		0x707f
>> -#define INSN_MATCH_SH		0x1023
>> -#define INSN_MASK_SH		0x707f
>> -#define INSN_MATCH_SW		0x2023
>> -#define INSN_MASK_SW		0x707f
>> -#define INSN_MATCH_SD		0x3023
>> -#define INSN_MASK_SD		0x707f
>> -
>> -#define INSN_MATCH_C_LD		0x6000
>> -#define INSN_MASK_C_LD		0xe003
>> -#define INSN_MATCH_C_SD		0xe000
>> -#define INSN_MASK_C_SD		0xe003
>> -#define INSN_MATCH_C_LW		0x4000
>> -#define INSN_MASK_C_LW		0xe003
>> -#define INSN_MATCH_C_SW		0xc000
>> -#define INSN_MASK_C_SW		0xe003
>> -#define INSN_MATCH_C_LDSP	0x6002
>> -#define INSN_MASK_C_LDSP	0xe003
>> -#define INSN_MATCH_C_SDSP	0xe002
>> -#define INSN_MASK_C_SDSP	0xe003
>> -#define INSN_MATCH_C_LWSP	0x4002
>> -#define INSN_MASK_C_LWSP	0xe003
>> -#define INSN_MATCH_C_SWSP	0xc002
>> -#define INSN_MASK_C_SWSP	0xe003
>> -
>> -#define INSN_16BIT_MASK		0x3
>> -
>> -#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
>> -
>> -#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
>> -
>> -#ifdef CONFIG_64BIT
>> -#define LOG_REGBYTES		3
>> -#else
>> -#define LOG_REGBYTES		2
>> -#endif
>> -#define REGBYTES		(1 << LOG_REGBYTES)
>> -
>> -#define SH_RD			7
>> -#define SH_RS1			15
>> -#define SH_RS2			20
>> -#define SH_RS2C			2
>> -#define MASK_RX			0x1f
>> -
>> -#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
>> -				 (RV_X(x, 10, 3) << 3) | \
>> -				 (RV_X(x, 5, 1) << 6))
>> -#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
>> -				 (RV_X(x, 5, 2) << 6))
>> -#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
>> -				 (RV_X(x, 12, 1) << 5) | \
>> -				 (RV_X(x, 2, 2) << 6))
>> -#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
>> -				 (RV_X(x, 12, 1) << 5) | \
>> -				 (RV_X(x, 2, 3) << 6))
>> -#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
>> -				 (RV_X(x, 7, 2) << 6))
>> -#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
>> -				 (RV_X(x, 7, 3) << 6))
>> -#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
>> -#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
>> -#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
>> -
>> -#define SHIFT_RIGHT(x, y)		\
>> -	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
>> -
>> -#define REG_MASK			\
>> -	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
>> -
>> -#define REG_OFFSET(insn, pos)		\
>> -	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
>> -
>> -#define REG_PTR(insn, pos, regs)	\
>> -	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
>> -
>> -#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
>> -
>> -#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
>> -#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
>> -#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
>> -#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
>> -#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
>> -#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
>> -#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
>> -#define IMM_I(insn)		((s32)(insn) >> 20)
>> -#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
>> -				 (s32)(((insn) >> 7) & 0x1f))
>> +#include <asm/insn.h>
>>   
>>   struct insn_func {
>>   	unsigned long mask;
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

