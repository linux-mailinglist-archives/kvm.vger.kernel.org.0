Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AFD642BD6
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiLEPcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiLEPcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:32:01 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C035225C9;
        Mon,  5 Dec 2022 07:31:15 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1p2DQy-0004NP-Vn; Mon, 05 Dec 2022 16:31:09 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Date:   Mon, 05 Dec 2022 16:31:08 +0100
Message-ID: <4764569.GXAFRqVoOG@diego>
In-Reply-To: <20221204174632.3677-2-jszhang@kernel.org>
References: <20221204174632.3677-1-jszhang@kernel.org> <20221204174632.3677-2-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Sonntag, 4. Dezember 2022, 18:46:20 CET schrieb Jisheng Zhang:
> Alternatives live in a different section, so offsets used by jal
> instruction will point to wrong locations after the patch got applied.
> 
> Similar to arm64, adjust the location to consider that offset.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/include/asm/alternative.h |  2 ++
>  arch/riscv/kernel/alternative.c      | 38 ++++++++++++++++++++++++++++
>  arch/riscv/kernel/cpufeature.c       |  3 +++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
> index c58ec3cc4bc3..33eae9541684 100644
> --- a/arch/riscv/include/asm/alternative.h
> +++ b/arch/riscv/include/asm/alternative.h
> @@ -29,6 +29,8 @@ void apply_module_alternatives(void *start, size_t length);
>  
>  void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
>  				      int patch_offset);
> +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> +			       int patch_offset);
>  
>  struct alt_entry {
>  	void *old_ptr;		 /* address of original instruciton or data  */
> diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
> index 292cc42dc3be..9d88375624b5 100644
> --- a/arch/riscv/kernel/alternative.c
> +++ b/arch/riscv/kernel/alternative.c
> @@ -125,6 +125,44 @@ void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
>  	}
>  }
>  
> +#define to_jal_imm(value)						\
> +	(((value & (RV_J_IMM_10_1_MASK << RV_J_IMM_10_1_OFF)) << RV_I_IMM_11_0_OPOFF) | \
> +	 ((value & (RV_J_IMM_11_MASK << RV_J_IMM_11_OFF)) << RV_J_IMM_11_OPOFF) | \
> +	 ((value & (RV_J_IMM_19_12_OPOFF << RV_J_IMM_19_12_OFF)) << RV_J_IMM_19_12_OPOFF) | \
> +	 ((value & (1 << RV_J_IMM_SIGN_OFF)) << RV_J_IMM_SIGN_OPOFF))
> +
> +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> +			       int patch_offset)
> +{

I think we might want to unfiy this into a common function like

	riscv_alternative_fix_offsets(...)

so that we only run through the code block once

	for (i = 0; i < num_instr; i++) {
		if (riscv_insn_is_auipc_jalr(inst1, inst2)) {
			riscv_alternative_fix_auipc_jalr(...)
			continue;
		}

		if (riscv_insn_is_jal(inst)) {
			riscv_alternative_fix_jal(...)
			continue;
		}
	}

This would also remove the need from calling multiple functions
after patching alternatives.

Thoughts?


Heiko

> +	int num_instr = len / sizeof(u32);
> +	unsigned int call;
> +	int i;
> +	int imm;
> +
> +	for (i = 0; i < num_instr; i++) {
> +		u32 inst = riscv_instruction_at(alt_ptr, i);
> +
> +		if (!riscv_insn_is_jal(inst))
> +			continue;
> +
> +		/* get and adjust new target address */
> +		imm = RV_EXTRACT_JTYPE_IMM(inst);
> +		imm -= patch_offset;
> +
> +		/* pick the original jal */
> +		call = inst;
> +
> +		/* drop the old IMMs, all jal imm bits sit at 31:12 */
> +		call &= ~GENMASK(31, 12);
> +
> +		/* add the adapted IMMs */
> +		call |= to_jal_imm(imm);
> +
> +		/* patch the call place again */
> +		patch_text_nosync(alt_ptr + i * sizeof(u32), &call, 4);
> +	}
> +}
> +
>  /*
>   * This is called very early in the boot process (directly after we run
>   * a feature detect on the boot CPU). No need to worry about other CPUs
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index ba62a4ff5ccd..c743f0adc794 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -324,6 +324,9 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
>  			riscv_alternative_fix_auipc_jalr(alt->old_ptr,
>  							 alt->alt_len,
>  							 alt->old_ptr - alt->alt_ptr);
> +			riscv_alternative_fix_jal(alt->old_ptr,
> +						  alt->alt_len,
> +						  alt->old_ptr - alt->alt_ptr);
>  		}
>  	}
>  }
> 




