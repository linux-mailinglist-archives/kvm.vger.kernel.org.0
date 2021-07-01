Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256C03B9206
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbhGANLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236567AbhGANLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA7161409;
        Thu,  1 Jul 2021 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625144963;
        bh=qrilNYhpZ8LEHXuIhCayQjjeFyN6ko8qjsn3aCbPrDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lf7X2EFnNud+je98QD9F+//v3CQOcPKQldnJoaGHAs3B/dQKhQons4e5BTTCCujE9
         bZKCe26rniqAhUMljMCtwtfDZTC+VTvvksnBLp+12Er5nfWraKWPyRL+/pLXSi9v9g
         va7M5Lc5pcYOqJ19gRlzo9qjuDA23O9U0VUwXHJ3MgwMQtkQbmZFwjOETT7vtjqauT
         acHqpw2FybV36CYPbtzXR4BY5sIrMjrQAqlm0P4VmOSVOkNm7e1WfTVLbTbABE0sNW
         jkbMV5UTKRxGq18pJqCvWkNsApJfWAKNGMU4YaQIFQlnxzecPsXgBN9yqBQvi9gKPK
         zAPm/MWfJ82zQ==
Date:   Thu, 1 Jul 2021 14:09:17 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 04/13] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
Message-ID: <20210701130917.GD9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-5-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-5-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:41PM +0100, Fuad Tabba wrote:
> Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> common code. It will be used in nVHE in a later patch.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 30 +-----------------------------
>  arch/arm64/kvm/sys_regs.h | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 29 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 9d0621417c2a..b8e2a4dd830f 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -11,6 +11,12 @@
>  #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
>  #define __ARM64_KVM_SYS_REGS_LOCAL_H__
>  
> +#include <linux/bsearch.h>
> +
> +#define reg_to_encoding(x)						\
> +	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
> +		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> +
>  struct sys_reg_params {
>  	u8	Op0;
>  	u8	Op1;
> @@ -21,6 +27,14 @@ struct sys_reg_params {
>  	bool	is_write;
>  };
>  
> +#define esr_sys64_to_params(esr)                                               \
> +	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
> +				  .Op1 = ((esr) >> 14) & 0x7,                  \
> +				  .CRn = ((esr) >> 10) & 0xf,                  \
> +				  .CRm = ((esr) >> 1) & 0xf,                   \
> +				  .Op2 = ((esr) >> 17) & 0x7,                  \
> +				  .is_write = !((esr)&1) })

Formatting has gone funny here (need spaces around the '&' in that last
entry).

> +
>  struct sys_reg_desc {
>  	/* Sysreg string for debug */
>  	const char *name;
> @@ -152,6 +166,24 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>  	return i1->Op2 - i2->Op2;
>  }
>  
> +static inline int match_sys_reg(const void *key, const void *elt)
> +{
> +	const unsigned long pval = (unsigned long)key;
> +	const struct sys_reg_desc *r = elt;
> +
> +	return pval - reg_to_encoding(r);
> +}
> +
> +static inline const struct sys_reg_desc *
> +find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
> +	 unsigned int num)
> +{
> +	unsigned long pval = reg_to_encoding(params);
> +
> +	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]),
> +				match_sys_reg);

You don't mention why you change bsearch() to __inline_bsearch().

Will
