Return-Path: <kvm+bounces-72009-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCUqIMNhoGk0jAQAu9opvQ
	(envelope-from <kvm+bounces-72009-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:07:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F791A840B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30BCF31DE387
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A693DA7C7;
	Thu, 26 Feb 2026 14:52:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91603242D98;
	Thu, 26 Feb 2026 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117573; cv=none; b=kihBBE3NbbNqAgRU3nj/qf1Ru5S8q8kGDcKNkY9/mfzXq9UcuYNQejDJ0pPOGwaEvE7ICwWmekuQNrMmuUKWHbMKSya++9jjidGGHK4kRp1ZSL4/Dk+uPD7Be52OJe0AI5eJD+5XuBRV0wXQ08sUCamxPCoWnjGsmtzuINjl/Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117573; c=relaxed/simple;
	bh=22FZM+HRfWrKd5081W115uEyqByOD2yn3rfZTSk65I8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CxhHE9oR0DrbL1E47yE7Ml7djMCl8ahjpvAShApgNHPZY1Q23aITLAenjoD8woAimItXMkNXUvNyx0MMTkjqnifFKf+G+hUqnvqfsUwsbWxbGnkpdHVigblhKh0pjszX49pyqApS21YEdNkEzqjXaotFPbglKUcOCSDkQd5MVWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B8BA497;
	Thu, 26 Feb 2026 06:52:44 -0800 (PST)
Received: from [10.57.73.122] (unknown [10.57.73.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8A003F73B;
	Thu, 26 Feb 2026 06:52:48 -0800 (PST)
Message-ID: <ec3fc327-042a-4672-ab39-88cd1ce41065@arm.com>
Date: Thu, 26 Feb 2026 14:52:47 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Content-Language: en-GB
To: Yeoreum Yun <yeoreum.yun@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
 broonie@kernel.org, ardb@kernel.org, lpieralisi@kernel.org,
 joey.gouly@arm.com, yuzenghui@huawei.com
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com> <867brzah6g.wl-maz@kernel.org>
 <aaBTM3C2MbIvtUn8@e129823.arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aaBTM3C2MbIvtUn8@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72009-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: D8F791A840B
X-Rspamd-Action: no action

On 26/02/2026 14:05, Yeoreum Yun wrote:
> Hi Marc,
> 
>> On Wed, 25 Feb 2026 18:27:07 +0000,
>> Yeoreum Yun <yeoreum.yun@arm.com> wrote:
>>>
>>> Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
>>> is enabled, avoiding the need to clear the PAN bit.
>>>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>>   arch/arm64/include/asm/cpucaps.h |  2 ++
>>>   arch/arm64/include/asm/futex.h   | 17 +----------------
>>>   arch/arm64/include/asm/lsui.h    | 27 +++++++++++++++++++++++++++
>>>   arch/arm64/kvm/at.c              | 30 +++++++++++++++++++++++++++++-
>>>   4 files changed, 59 insertions(+), 17 deletions(-)
>>>   create mode 100644 arch/arm64/include/asm/lsui.h
>>>
>>> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
>>> index 177c691914f8..6e3da333442e 100644
>>> --- a/arch/arm64/include/asm/cpucaps.h
>>> +++ b/arch/arm64/include/asm/cpucaps.h
>>> @@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
>>>   		return true;
>>>   	case ARM64_HAS_PMUV3:
>>>   		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
>>> +	case ARM64_HAS_LSUI:
>>> +		return IS_ENABLED(CONFIG_ARM64_LSUI);
>>>   	}
>>>
>>>   	return true;
>>
>> It would make more sense to move this hunk to the first patch, where
>> you deal with features and capabilities, instead of having this in a
>> random KVM-specific patch.
> 
> Okay. But as Suzuki mention, I think it seems to be redundant.
> I'll remove it.
> 

No, this is required and Marc is right. This hunk should be part of the
original patch that adds the cap. What I am saying is that you don't
need to explicitly call the cpucap_is_poissible() down, but it is
implicitly called by cpus_have_final_cap().

Kind regards
Suzuki


>>
>>> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
>>> index b579e9d0964d..6779c4ad927f 100644
>>> --- a/arch/arm64/include/asm/futex.h
>>> +++ b/arch/arm64/include/asm/futex.h
>>> @@ -7,11 +7,9 @@
>>>
>>>   #include <linux/futex.h>
>>>   #include <linux/uaccess.h>
>>> -#include <linux/stringify.h>
>>>
>>> -#include <asm/alternative.h>
>>> -#include <asm/alternative-macros.h>
>>>   #include <asm/errno.h>
>>> +#include <asm/lsui.h>
>>>
>>>   #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
>>>
>>> @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>>>
>>>   #ifdef CONFIG_ARM64_LSUI
>>>
>>> -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
>>> -
>>>   #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
>>>   static __always_inline int						\
>>>   __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
>>> @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
>>>   {
>>>   	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
>>>   }
>>> -
>>> -#define __lsui_llsc_body(op, ...)					\
>>> -({									\
>>> -	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
>>> -		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
>>> -})
>>> -
>>> -#else	/* CONFIG_ARM64_LSUI */
>>> -
>>> -#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
>>> -
>>>   #endif	/* CONFIG_ARM64_LSUI */
>>>
>>>
>>> diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
>>> new file mode 100644
>>> index 000000000000..8f0d81953eb6
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/lsui.h
>>> @@ -0,0 +1,27 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#ifndef __ASM_LSUI_H
>>> +#define __ASM_LSUI_H
>>> +
>>> +#include <linux/compiler_types.h>
>>> +#include <linux/stringify.h>
>>> +#include <asm/alternative.h>
>>> +#include <asm/alternative-macros.h>
>>> +#include <asm/cpucaps.h>
>>> +
>>> +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
>>> +
>>> +#ifdef CONFIG_ARM64_LSUI
>>> +
>>> +#define __lsui_llsc_body(op, ...)					\
>>> +({									\
>>> +	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
>>> +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
>>> +})
>>> +
>>> +#else	/* CONFIG_ARM64_LSUI */
>>> +
>>> +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
>>> +
>>> +#endif	/* CONFIG_ARM64_LSUI */
>>> +
>>> +#endif	/* __ASM_LSUI_H */
>>
>> Similarly, fold this into the patch that introduces FEAT_LSUI support
>> for futexes (#5) so that the code is in its final position from the
>> beginning. This will avoid churn that makes the patches pointlessly
>> hard to follow, since this change is unrelated to KVM.
> 
> Okay. I'll fold it into #5.
> 
>>
>>> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
>>> index 885bd5bb2f41..fd3c5749e853 100644
>>> --- a/arch/arm64/kvm/at.c
>>> +++ b/arch/arm64/kvm/at.c
>>> @@ -9,6 +9,7 @@
>>>   #include <asm/esr.h>
>>>   #include <asm/kvm_hyp.h>
>>>   #include <asm/kvm_mmu.h>
>>> +#include <asm/lsui.h>
>>>
>>>   static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
>>>   {
>>> @@ -1704,6 +1705,31 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
>>>   	}
>>>   }
>>>
>>> +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
>>> +{
>>> +	u64 tmp = old;
>>> +	int ret = 0;
>>> +
>>> +	uaccess_ttbr0_enable();
>>
>> Why do we need this? If FEAT_LSUI is present, than FEAT_PAN is also
>> present. And since PAN support not a compilation option anymore, we
>> should be able to rely on PAN being enabled.
>>
>> Or am I missing something? If so, please document why we require it.
> 
> That was my origin thought but there was relevant discussion about this:
>    - https://lore.kernel.org/all/aW5dzb0ldp8u8Rdm@willie-the-truck/
>    - https://lore.kernel.org/all/aYtZfpWjRJ1r23nw@arm.com/
> 
> In summary, I couldn't make that assumption --
> PAN always presents when LSUI presents for :
> 
>     - CPU bugs happen all the time
>     - Virtualisation and idreg overrides mean illegal feature combinations
>      can show up
> 
> So, uaccess_ttbr0_enable() is for when SW_PAN is enabled.
> 
> I'll make a comment for this.
> 
> [...]
> 
> Thanks!
> 
> --
> Sincerely,
> Yeoreum Yun


