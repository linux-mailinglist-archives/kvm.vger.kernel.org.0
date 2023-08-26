Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3694678964A
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 13:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjHZL3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 07:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjHZL3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 07:29:31 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE561BF1;
        Sat, 26 Aug 2023 04:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1693049360; bh=jVCVG1/221W+GBfmKbFkmaTpzK/cZFxAofMIlAvip0g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dpQoBgXXGbviD+RTGcpdLy7Eef4gvaNogljYVawGYQnm1S1abeeb/lJd6+BqSSkmK
         PTwVP8nAYFGSh2qmpL6j+Nf6aJA7JtX7rZyDCFyNOmEa9UAoJ/dKkS0hslm+Cp2KNo
         DJlsRP+sgcoT8XcA/mp7Ayn3V052c7OqTY8+od/0=
Received: from [192.168.9.172] (unknown [101.88.24.218])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 5D50C6011B;
        Sat, 26 Aug 2023 19:29:20 +0800 (CST)
Message-ID: <1b0ca747-e6cb-e53f-f5cf-b1bbfc1ed839@xen0n.name>
Date:   Sat, 26 Aug 2023 19:29:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v19 05/30] LoongArch: KVM: Add vcpu related header files
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230817125951.1126909-1-zhaotianrui@loongson.cn>
 <20230817125951.1126909-6-zhaotianrui@loongson.cn>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20230817125951.1126909-6-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 8/17/23 20:59, Tianrui Zhao wrote:
> Add LoongArch vcpu related header files, including vcpu csr
> information, irq number defines, and some vcpu interfaces.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/include/asm/insn-def.h  |  55 ++++++
>   arch/loongarch/include/asm/kvm_csr.h   | 252 +++++++++++++++++++++++++
>   arch/loongarch/include/asm/kvm_vcpu.h  |  95 ++++++++++
>   arch/loongarch/include/asm/loongarch.h |  20 +-
>   arch/loongarch/kvm/trace.h             | 168 +++++++++++++++++
>   5 files changed, 585 insertions(+), 5 deletions(-)
>   create mode 100644 arch/loongarch/include/asm/insn-def.h
>   create mode 100644 arch/loongarch/include/asm/kvm_csr.h
>   create mode 100644 arch/loongarch/include/asm/kvm_vcpu.h
>   create mode 100644 arch/loongarch/kvm/trace.h
>
> diff --git a/arch/loongarch/include/asm/insn-def.h b/arch/loongarch/include/asm/insn-def.h
> new file mode 100644
> index 000000000000..e285ee108fb0
> --- /dev/null
> +++ b/arch/loongarch/include/asm/insn-def.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#ifndef __ASM_INSN_DEF_H
> +#define __ASM_INSN_DEF_H
> +
> +#include <linux/stringify.h>
> +#include <asm/gpr-num.h>
> +#include <asm/asm.h>
> +
> +#define INSN_STR(x)		__stringify(x)
> +#define CSR_RD_SHIFT		0
> +#define CSR_RJ_SHIFT		5
> +#define CSR_SIMM14_SHIFT	10
> +#define CSR_OPCODE_SHIFT	24
> +
> +#define DEFINE_INSN_CSR							\
> +	__DEFINE_ASM_GPR_NUMS						\
> +"	.macro insn_csr, opcode, rj, rd, simm14\n"			\
> +"	.4byte	((\\opcode << " INSN_STR(CSR_OPCODE_SHIFT) ") |"	\
> +"		 (.L__gpr_num_\\rj << " INSN_STR(CSR_RJ_SHIFT) ") |"	\
> +"		 (.L__gpr_num_\\rd << " INSN_STR(CSR_RD_SHIFT) ") |"	\
> +"		 (\\simm14 << " INSN_STR(CSR_SIMM14_SHIFT) "))\n"	\
> +"	.endm\n"

Okay so the previous request (just removing this file and related 
machinery, with detailed analysis [1] as to why this is doable across 
the whole LoongArch ecosystem, and agreed by at least one downstream 
commercial distro [2]) still isn't being honored...

Maybe give your arguments as to what edge case the previous analysis 
wasn't covering, or *at the very least* re-use the existing "parse_r" 
helper and don't re-invent it, should it happen that such usage is 
actually deemed acceptable in the kvm subsystem as previously pointed 
out by Ruoyao [3].

[1]: 
https://lore.kernel.org/loongarch/81270b55-37c4-d566-8cd7-acc90b490c10@xen0n.name/
[2]: 
https://lore.kernel.org/loongarch/367239C38ED9D19C+9ef16061-9057-482c-bd8c-0b9ede71cfa7@uniontech.com/
[3]: 
https://lore.kernel.org/loongarch/6a5ed2266138cc61cbe27577424bb53cda72378d.camel@xry111.site/

> +
> +#define UNDEFINE_INSN_CSR						\
> +"	.purgem insn_csr\n"
> +
> +#define __INSN_CSR(opcode, rj, rd, simm14)				\
> +	DEFINE_INSN_CSR							\
> +	"insn_csr " opcode ", " rj ", " rd ", " simm14 "\n"		\
> +	UNDEFINE_INSN_CSR
> +
> +
> +#define INSN_CSR(opcode, rj, rd, simm14)				\
> +	__INSN_CSR(LARCH_##opcode, LARCH_##rj, LARCH_##rd,		\
> +		   LARCH_##simm14)
> +
> +#define __ASM_STR(x)		#x
> +#define LARCH_OPCODE(v)		__ASM_STR(v)
> +#define LARCH_SIMM14(v)		__ASM_STR(v)
> +#define __LARCH_REG(v)		__ASM_STR(v)
> +#define LARCH___RD(v)		__LARCH_REG(v)
> +#define LARCH___RJ(v)		__LARCH_REG(v)
> +#define LARCH_OPCODE_GCSR	LARCH_OPCODE(5)
> +
> +#define GCSR_read(csr, rd)						\
> +	INSN_CSR(OPCODE_GCSR, __RJ(zero), __RD(rd), SIMM14(csr))
> +
> +#define GCSR_write(csr, rd)						\
> +	INSN_CSR(OPCODE_GCSR, __RJ($r1), __RD(rd), SIMM14(csr))
> +
> +#define GCSR_xchg(csr, rj, rd)						\
> +	INSN_CSR(OPCODE_GCSR, __RJ(rj), __RD(rd), SIMM14(csr))
> +
> +#endif /* __ASM_INSN_DEF_H */
> diff --git a/arch/loongarch/include/asm/kvm_csr.h b/arch/loongarch/include/asm/kvm_csr.h
> new file mode 100644
> index 000000000000..34483bbaec15
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_csr.h
> @@ -0,0 +1,252 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_LOONGARCH_KVM_CSR_H__
> +#define __ASM_LOONGARCH_KVM_CSR_H__
> +#include <asm/loongarch.h>
> +#include <asm/kvm_vcpu.h>
> +#include <linux/uaccess.h>
> +#include <linux/kvm_host.h>
> +
> +#ifdef CONFIG_AS_HAS_LVZ_EXTENSION
> +/* binutils support virtualization instructions */

It may also be LLVM IAS, so I'd suggest removing this comment as the 
config symbol name is pretty self-documenting.

But this Kconfig flag isn't being defined until Patch 28, which feels a 
bit reversed. I'd suggest splitting the definition for this symbol out 
for a small patch before this one, or merging that definition into this 
patch.

> +#define gcsr_read(csr)						\
> +({								\
> +	register unsigned long __v;				\
> +	__asm__ __volatile__(					\
> +		" gcsrrd %[val], %[reg]\n\t"			\
> +		: [val] "=r" (__v)				\
> +		: [reg] "i" (csr)				\
> +		: "memory");					\
> +	__v;							\
> +})
> +
> +#define gcsr_write(v, csr)					\
> +({								\
> +	register unsigned long __v = v;				\
> +	__asm__ __volatile__ (					\
> +		" gcsrwr %[val], %[reg]\n\t"			\
> +		: [val] "+r" (__v)				\
> +		: [reg] "i" (csr)				\
> +		: "memory");					\
> +})
> +
> +#define gcsr_xchg(v, m, csr)					\
> +({								\
> +	register unsigned long __v = v;				\
> +	__asm__ __volatile__(					\
> +		" gcsrxchg %[val], %[mask], %[reg]\n\t"		\
> +		: [val] "+r" (__v)				\
> +		: [mask] "r" (m), [reg] "i" (csr)		\
> +		: "memory");					\
> +	__v;							\
> +})
> +#else
> +/* binutils do not support virtualization instructions */

Similarly this comment could be removed. Or better, instead hint at the 
symbol being checked so readers don't lose context:

#else /* CONFIG_AS_HAS_LVZ_EXTENSION */

> +#define gcsr_read(csr)						\
> +({								\
> +	register unsigned long __v;				\
> +	__asm__ __volatile__ (GCSR_read(csr, %0)		\
> +				: "=r" (__v) :			\
> +				: "memory");			\
> +	__v;							\
> +})
> +
> +#define gcsr_write(val, csr)					\
> +({								\
> +	register unsigned long __v = val;			\
> +	__asm__ __volatile__ (GCSR_write(csr, %0)		\
> +				: "+r" (__v) :			\
> +				: "memory");			\
> +})
> +
> +#define gcsr_xchg(val, mask, csr)				\
> +({								\
> +	register unsigned long __v = val;			\
> +	__asm__ __volatile__ (GCSR_xchg(csr, %1, %0)		\
> +				: "+r" (__v)			\
> +				: "r"  (mask)			\
> +				: "memory");			\
> +	__v;							\
> +})
> +#endif
> +
>
> [snip]

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

