Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7366628F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbjAKSML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjAKSMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:12:01 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699A634768
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:11:55 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bn26so15940808wrb.0
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3qNjCgtCiFMyIYhxMDbaTasJyJ7EAMrtsxaOkH6xleA=;
        b=JAY+f8OHx5UfKGQZx7kF5zot7xfb0jQNF961xcXesWbBvMHEveWwjj0UG4HyKx3azG
         AA6kgivY4jCkHV/1HoDtIYhpP+8PnGP2QrNGHVyEEDa+WhqfkNphCF91owPGLz+qTlpR
         ZjzZ7GF5l0zF+U5Lda+maO9N3vQCsvLRdQsxQVDRgLmll1khhdfsKkJo5xCC5utjtKh4
         b4vOaz2in4hA3mxhGehryvQ152TtlLWA663D8g+RI3DwbEfOZbDg3BZ82GjvSKQXsNJG
         bv3xDDqkMuY1zN7vlBVJ3/7wWtSMwZkq8pUkGyLGNo5VDBveIK/JBPOEDKqnpX0XFwz+
         F4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qNjCgtCiFMyIYhxMDbaTasJyJ7EAMrtsxaOkH6xleA=;
        b=thQMxeRavH2EcqzPB7T0rhjaFoN2SfhiN0WUpPMWf/hXJYTSNCfotlOuMwF4NNG3AQ
         DuLs8hKUpIAl/pQVKG/9/ksV7u6N2GEZ7kwZsy71iYPc4LKVzjmfrrwEYuAf3Nck0nzW
         JDVMptHnpxsH3LkJJsWojdlEAQoQH7PQNpQkeVKaf7VM8zoqvlfra7k5sZ7Rhl9qLZNn
         Y0aQLyTs7Fyf1W3RM2HpiW0W8xxYZO0l26jMeUNeCYJd5rNTQ/zBDmSKTE6fqhsnMOlx
         gKzNDj6nFcw+69d0iQwMu/jhHFfO8WC5PQ4U25NQ7MOuIUCqRDVYoRdnU1h4ADV92/8k
         yjWQ==
X-Gm-Message-State: AFqh2koki/GpC30QhzxzS7Ll7TudVydcIiMsQgIDlgb6run1H4AB0AGp
        VtmVW/A6NnES52lqjQFkYgQOTQ==
X-Google-Smtp-Source: AMrXdXvUew920jU+Lr17it/M2QvyLnGR/nuiaulC5//SLD5ZreOji9KY0iqN+iwjsSpQ4x1Is6qJ/Q==
X-Received: by 2002:a5d:618a:0:b0:2bc:5115:f072 with SMTP id j10-20020a5d618a000000b002bc5115f072mr8751439wru.50.1673460714002;
        Wed, 11 Jan 2023 10:11:54 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id t10-20020a5d534a000000b00272c0767b4asm14459920wrv.109.2023.01.11.10.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:11:53 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:11:52 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 09/13] riscv: switch to relative alternative entries
Message-ID: <20230111181152.7c646ffbdhh6lblr@orel>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-10-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111171027.2392-10-jszhang@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 01:10:23AM +0800, Jisheng Zhang wrote:
> Instead of using absolute addresses for both the old instrucions and
> the alternative instructions, use offsets relative to the alt_entry
> values. So this not only cuts the size of the alternative entry, but
> also meets the prerequisite for patching alternatives in the vDSO,
> since absolute alternative entries are subject to dynamic relocation,
> which is incompatible with the vDSO building.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/errata/sifive/errata.c           |  4 +++-
>  arch/riscv/errata/thead/errata.c            | 11 ++++++++---
>  arch/riscv/include/asm/alternative-macros.h | 20 ++++++++++----------
>  arch/riscv/include/asm/alternative.h        | 12 ++++++------
>  arch/riscv/kernel/cpufeature.c              |  8 +++++---
>  5 files changed, 32 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
> index 1031038423e7..0e537cdfd324 100644
> --- a/arch/riscv/errata/sifive/errata.c
> +++ b/arch/riscv/errata/sifive/errata.c
> @@ -107,7 +107,9 @@ void __init_or_module sifive_errata_patch_func(struct alt_entry *begin,
>  
>  		tmp = (1U << alt->errata_id);
>  		if (cpu_req_errata & tmp) {
> -			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +			patch_text_nosync((void *)&alt->old_offset + alt->old_offset,
> +					  (void *)&alt->alt_offset + alt->alt_offset,

I was hoping to see Conor's macro suggestion show up in this version.

> +					  alt->alt_len);
>  			cpu_apply_errata |= tmp;
>  		}
>  	}
> diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
> index fac5742d1c1e..d56d76a529b5 100644
> --- a/arch/riscv/errata/thead/errata.c
> +++ b/arch/riscv/errata/thead/errata.c
> @@ -87,6 +87,7 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
>  	struct alt_entry *alt;
>  	u32 cpu_req_errata = thead_errata_probe(stage, archid, impid);
>  	u32 tmp;
> +	void *oldptr, *altptr;
>  
>  	for (alt = begin; alt < end; alt++) {
>  		if (alt->vendor_id != THEAD_VENDOR_ID)
> @@ -96,12 +97,16 @@ void __init_or_module thead_errata_patch_func(struct alt_entry *begin, struct al
>  
>  		tmp = (1U << alt->errata_id);
>  		if (cpu_req_errata & tmp) {
> +			oldptr = (void *)&alt->old_offset + alt->old_offset;
> +			altptr = (void *)&alt->alt_offset + alt->alt_offset;
> +
>  			/* On vm-alternatives, the mmu isn't running yet */
>  			if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
> -				memcpy((void *)__pa_symbol(alt->old_ptr),
> -				       (void *)__pa_symbol(alt->alt_ptr), alt->alt_len);
> +				memcpy((void *)__pa_symbol(oldptr),
> +				       (void *)__pa_symbol(altptr),
> +				       alt->alt_len);
>  			else
> -				patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +				patch_text_nosync(oldptr, altptr, alt->alt_len);
>  		}
>  	}
>  
> diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
> index 7226e2462584..3c3ca65e521b 100644
> --- a/arch/riscv/include/asm/alternative-macros.h
> +++ b/arch/riscv/include/asm/alternative-macros.h
> @@ -7,11 +7,11 @@
>  #ifdef __ASSEMBLY__
>  
>  .macro ALT_ENTRY oldptr newptr vendor_id errata_id new_len
> -	RISCV_PTR \oldptr
> -	RISCV_PTR \newptr
> -	REG_ASM \vendor_id
> -	REG_ASM \new_len
> -	.word	\errata_id
> +	.long \oldptr - .
> +	.long \newptr - .
> +	.short \vendor_id
> +	.short \new_len
> +	.long \errata_id

nit: I like .2byte and .4byte since I always have to double check how many
bytes .long is.

>  .endm
>  
>  .macro ALT_NEW_CONTENT vendor_id, errata_id, enable = 1, new_c : vararg
> @@ -59,11 +59,11 @@
>  #include <linux/stringify.h>
>  
>  #define ALT_ENTRY(oldptr, newptr, vendor_id, errata_id, newlen)		\
> -	RISCV_PTR " " oldptr "\n"					\
> -	RISCV_PTR " " newptr "\n"					\
> -	REG_ASM " " vendor_id "\n"					\
> -	REG_ASM " " newlen "\n"						\
> -	".word " errata_id "\n"
> +	".long	((" oldptr ") - .) \n"					\
> +	".long	((" newptr ") - .) \n"					\
> +	".short	" vendor_id "\n"					\
> +	".short	" newlen "\n"						\
> +	".long	" errata_id "\n"
>  
>  #define ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)		\
>  	".if " __stringify(enable) " == 1\n"				\
> diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
> index 1bd4027d34ca..b6050a235f50 100644
> --- a/arch/riscv/include/asm/alternative.h
> +++ b/arch/riscv/include/asm/alternative.h
> @@ -31,12 +31,12 @@ void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
>  				   int patch_offset);
>  
>  struct alt_entry {
> -	void *old_ptr;		 /* address of original instruciton or data  */
> -	void *alt_ptr;		 /* address of replacement instruction or data */
> -	unsigned long vendor_id; /* cpu vendor id */
> -	unsigned long alt_len;   /* The replacement size */
> -	unsigned int errata_id;  /* The errata id */
> -} __packed;
> +	s32 old_offset;		/* offset relative to original instruciton or data  */
                                                               ^
							       instruction

(The typo was already there, but, IMO, we can fix something like that
while touching it.)

> +	s32 alt_offset;		/* offset relative to replacement instruction or data */
> +	u16 vendor_id;		/* cpu vendor id */
> +	u16 alt_len;		/* The replacement size */
> +	u32 errata_id;		/* The errata id */
> +};
>  
>  struct errata_checkfunc_id {
>  	unsigned long vendor_id;
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 6db8b31d9149..c394cde2560b 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -280,6 +280,7 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
>  						  unsigned int stage)
>  {
>  	struct alt_entry *alt;
> +	void *oldptr, *altptr;
>  
>  	if (stage == RISCV_ALTERNATIVES_EARLY_BOOT)
>  		return;
> @@ -293,12 +294,13 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
>  			continue;
>  		}
>  
> +		oldptr = (void *)&alt->old_offset + alt->old_offset;
> +		altptr = (void *)&alt->alt_offset + alt->alt_offset;
>  		if (!__riscv_isa_extension_available(NULL, alt->errata_id))
>  			continue;
>  
> -		patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> -		riscv_alternative_fix_offsets(alt->old_ptr, alt->alt_len,
> -					      alt->old_ptr - alt->alt_ptr);
> +		patch_text_nosync(oldptr, altptr, alt->alt_len);
> +		riscv_alternative_fix_offsets(oldptr, alt->alt_len, oldptr - altptr);
>  	}
>  }
>  #endif
> -- 
> 2.38.1

Besides preferring a macro and the nits, LGTM

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
