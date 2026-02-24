Return-Path: <kvm+bounces-71669-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UDGxLD8QnmlBTQQAu9opvQ
	(envelope-from <kvm+bounces-71669-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:55:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3534018C86B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91DC0305E338
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8766F33B967;
	Tue, 24 Feb 2026 20:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fU9VoxpY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96FF223702;
	Tue, 24 Feb 2026 20:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771966458; cv=none; b=UrnWBL1gfcFxHD4yBnnAz/tsqFruYyYCYy8arFGsY8udGfjxr1VZhY0iDfZ97FT3az4J4UK5UYG3N95hhOBzMCvklGZFO9SYeOa4qHGJsboR9RPZDPDFo6qvlOLp2llmWX1PMeKzfMWkhbj9fyw06/PfDZcUgRfphNmbtvtNbH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771966458; c=relaxed/simple;
	bh=EgVAY0e5tBoSz6A6iwW5/XO8EvjgmD/hBAtfckjnAIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYAnzz9U5FxQuc4Rqy2FvOFxvDucL3f8KD4suueeBHMUNoT65/1L3p18QpxlaZMypcuRRyPHwTUsrxUXeKJnCEucpZ+X/dqjB2S4vz9bSufpCdTNTepXugqXrWhR4ZqvrCff0tOy71HcYw/OboNreJlLI4JJdDQ4QZ89hfRDxBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fU9VoxpY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279EDC116D0;
	Tue, 24 Feb 2026 20:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771966458;
	bh=EgVAY0e5tBoSz6A6iwW5/XO8EvjgmD/hBAtfckjnAIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fU9VoxpYqnAVrd4t/fIENYWIsMId2KNEP3dfw2h4SjQzeH/MBV/5Cee/wntRTQCP6
	 8EADR9JKKOK/hSexd/fEomD/ZrU3e+Mo0cAkKAlisOPYRwuKJXzT3MA26tdQTXMvpb
	 cFKvEXyKAe/X10m3pmNX2H1z0cczPw3iZWdEsiJJoujd4S5bnLIF7pTBSYnWQRgIVb
	 lO1qmLmIs5NJLzUq5pV5qVfuG1vDdgGb4JylPzxBqN/lvS2sL0Y7jYkwDaBcxLLsMY
	 M8xREJGMjxcu5uVJY3DLJp8/BXSitkrqLBWUKwurl88mBMEyWsx/eqM0TQ42RGOP4K
	 O37lVNZp675Mw==
Date: Tue, 24 Feb 2026 12:54:16 -0800
From: Oliver Upton <oupton@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, broonie@kernel.org, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v13 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aZ4P-AcVjxfCFsew@kernel.org>
References: <20260223174802.458411-1-yeoreum.yun@arm.com>
 <20260223174802.458411-8-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223174802.458411-8-yeoreum.yun@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71669-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oupton@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3534018C86B
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 05:48:01PM +0000, Yeoreum Yun wrote:
> Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
> is enabled, avoiding the need to clear the PAN bit.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/include/asm/futex.h | 17 +----------------
>  arch/arm64/include/asm/lsui.h  | 27 +++++++++++++++++++++++++++
>  arch/arm64/kvm/at.c            | 32 +++++++++++++++++++++++++++++++-
>  3 files changed, 59 insertions(+), 17 deletions(-)
>  create mode 100644 arch/arm64/include/asm/lsui.h
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index b579e9d0964d..6779c4ad927f 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -7,11 +7,9 @@
>  
>  #include <linux/futex.h>
>  #include <linux/uaccess.h>
> -#include <linux/stringify.h>
>  
> -#include <asm/alternative.h>
> -#include <asm/alternative-macros.h>
>  #include <asm/errno.h>
> +#include <asm/lsui.h>
>  
>  #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
>  
> @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>  
>  #ifdef CONFIG_ARM64_LSUI
>  
> -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> -
>  #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
>  static __always_inline int						\
>  __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>  {
>  	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
>  }
> -
> -#define __lsui_llsc_body(op, ...)					\
> -({									\
> -	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> -		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> -})
> -
> -#else	/* CONFIG_ARM64_LSUI */
> -
> -#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> -
>  #endif	/* CONFIG_ARM64_LSUI */
>  
>  
> diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
> new file mode 100644
> index 000000000000..4f956188835e
> --- /dev/null
> +++ b/arch/arm64/include/asm/lsui.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_LSUI_H
> +#define __ASM_LSUI_H
> +
> +#include <linux/compiler_types.h>
> +#include <linux/stringify.h>
> +#include <asm/alternative.h>
> +#include <asm/alternative-macros.h>
> +#include <asm/cpucaps.h>
> +
> +#ifdef CONFIG_ARM64_LSUI
> +
> +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> +
> +#define __lsui_llsc_body(op, ...)					\
> +({									\
> +	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> +})
> +
> +#else	/* CONFIG_ARM64_LSUI */
> +
> +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> +
> +#endif	/* CONFIG_ARM64_LSUI */
> +
> +#endif	/* __ASM_LSUI_H */
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 885bd5bb2f41..1aceeef04567 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -9,6 +9,7 @@
>  #include <asm/esr.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/lsui.h>
>  
>  static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
>  {
> @@ -1704,6 +1705,33 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
>  	}
>  }
>  
> +#ifdef CONFIG_ARM64_LSUI
> +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> +{
> +	u64 tmp = old;
> +	int ret = 0;
> +
> +	uaccess_ttbr0_enable();
> +
> +	asm volatile(__LSUI_PREAMBLE
> +		     "1: caslt	%[old], %[new], %[addr]\n"
> +		     "2:\n"
> +		     _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w[ret])
> +		     : [old] "+r" (old), [addr] "+Q" (*ptep), [ret] "+r" (ret)
> +		     : [new] "r" (new)
> +		     : "memory");
> +
> +	uaccess_ttbr0_disable();
> +
> +	if (ret)
> +		return ret;
> +	if (tmp != old)
> +		return -EAGAIN;
> +
> +	return ret;
> +}
> +#endif
> +
>  static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
>  {
>  	u64 tmp = old;
> @@ -1779,7 +1807,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
>  		return -EPERM;
>  
>  	ptep = (u64 __user *)hva + offset;
> -	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
> +	if (IS_ENABLED(CONFIG_ARM64_LSUI) && cpus_have_final_cap(ARM64_HAS_LSUI))

cpucap_is_possible() is where the Kconfig check should go.

Thanks,
Oliver

