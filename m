Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72473F6D4
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjF0IUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjF0IUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:20:04 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108EDE5;
        Tue, 27 Jun 2023 01:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1687853998; bh=FNm89gkdhid/F9i0RK3rbfD/L/HwpUHHCTG+95nssus=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=xoWamd7VJHJpaAmhRrr9sJ9Ih38xFEyD6qLt6k/qDNKZOVjq1NqVRIKh07ClO53M9
         kaBZux4vXrf3vFscj2Oa33lclnuqe6k4TRkqNXF1WgHj2roXq5gPmfQx1bCO381a/Y
         bE+/Tg3JgyUQoRqUGPibLrrFr5mDYAGoy26Tzibw=
Received: from [100.100.34.13] (unknown [220.248.53.61])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 017D96011B;
        Tue, 27 Jun 2023 16:19:57 +0800 (CST)
Message-ID: <18bc1f6b-5299-2628-82b7-55f3848e856a@xen0n.name>
Date:   Tue, 27 Jun 2023 16:19:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v15 05/30] LoongArch: KVM: Add vcpu related header files
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
 <20230626084752.1138621-6-zhaotianrui@loongson.cn>
Content-Language: en-US
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20230626084752.1138621-6-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/6/26 16:47, Tianrui Zhao wrote:
> Add LoongArch vcpu related header files, including vcpu csr
> information, irq number defines, and some vcpu interfaces.
> 
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/include/asm/insn-def.h  |  55 ++++++
>   arch/loongarch/include/asm/kvm_csr.h   | 231 +++++++++++++++++++++++++
>   arch/loongarch/include/asm/kvm_vcpu.h  |  97 +++++++++++
>   arch/loongarch/include/asm/loongarch.h |  20 ++-
>   arch/loongarch/kvm/trace.h             | 168 ++++++++++++++++++
>   5 files changed, 566 insertions(+), 5 deletions(-)
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

I still find this unnecessarily complex. First of all this is 
reinventing infra that's already available as the "parse_r" helper 
(check out include/asm/tlb.h in v6.4), but the only usage of the helper 
has just been removed, so it's probably a signal saying this practice 
may not last for long -- people are no longer in a situation like back 
in the MIPS era when toolchain support are not guaranteed (or even 
allowed upstream).

Secondly, while support for older compilers is nice-to-have, but users 
of upstream kernels also already effectively depend on very recent 
toolchains (if not bleeding-edge). So we can just probe for support and 
just use proper mnemonics and automatically get support soon, because we 
can expect most of them to pick up upstream changes very quickly. That's 
to say, if we have something like:

# arch/loongarch/Kconfig
config LOONGARCH
     # ...
     select HAVE_KVM if AS_HAS_LVZ_EXTENSION

config AS_HAS_LVZ_EXTENSION
     def_bool $(as-instr,gcsrrd \$t0$(comma)\$t1$(comma)123)

Then support is guaranteed for all KVM code and this cruft can go away, 
and then the feature will likely be available in a few months.

FYI, support for LSX and LASX instructions are already posted by your 
fellow toolchain folks [1], so it's 100% doable for them to add support 
despite the manuals not being available yet. Just coordinate with them a 
bit...

[1]: https://sourceware.org/pipermail/binutils/2023-June/127990.html

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

