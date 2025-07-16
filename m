Return-Path: <kvm+bounces-52602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA60B07194
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86DC416A3BF
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B8C2F0C40;
	Wed, 16 Jul 2025 09:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5//JEXq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8FE157493;
	Wed, 16 Jul 2025 09:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657950; cv=none; b=O8QpVd0YyNzeq1sWNDYCtD6y8/Z6TiwVcJCYT14vdp94EkyVYDvH7g3iIgbQUjGFEfqJhG4Btj3u30g/tMgrrP7matcBGifuO1LlSqqgcawmE9mbq2ucQquUQ6kvIOdGtv0cEJef19zJKbdKjMPBtNKbI+q2/Fz1NQqKTmZX5Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657950; c=relaxed/simple;
	bh=jqP3XKj0UG3jxjSdrLTwsmuhVKrBduNxvkcDJoejd90=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlPexhaMkjTudLSH7BfgoFkKXJ1tZRhJiHB8EMEd7WFSQ/0QeZ2JVun6U9aJwvMACcc9muVrCCsCxOi1JkhBJXt14xTtDD3tc5jCy6noRvt/cPgg3KNQvmo8JIBiDADOH/L9B23sUFez1fsAolsRvXRvNFVZX5GlZd5r2nuPlCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5//JEXq; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752657949; x=1784193949;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jqP3XKj0UG3jxjSdrLTwsmuhVKrBduNxvkcDJoejd90=;
  b=d5//JEXqElMnCcjhT+OxLZK3nrdsBAptetse4W5rN+ZCdoKvKEM79NKU
   aD+4hE9NoX+DTDzUDdMBPZ2nupAgkFYk+8UaspWX2yPaQQy7KAqyvGG8G
   d+CXic631hrlauZS1stkyQZr2W4dNh81widJxwuDgfMLGTZx7s15wEaFK
   VcSbKg9fKoVlH6xFTeXpzfWq/NtxIXpueTJfupI6xOm17zBMclzdIR8AE
   KEDmc1L/HXPzN7nTRSF0/Sp3wMA0CX2JYG2EzG8UvkysJuXXv186ZJE5J
   gS5IdOwsGWlbxo1uJxOTGfLe1QaQhxtgnlXzPodUpY71tTB9de4722TMH
   Q==;
X-CSE-ConnectionGUID: UDSlbLNET+yUt+ZIJaFnsg==
X-CSE-MsgGUID: q73LvfZ5RZe01Kq9ILbuMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="55041973"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="55041973"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 02:25:49 -0700
X-CSE-ConnectionGUID: T3Nue4BRQTulDUlZw9iz7w==
X-CSE-MsgGUID: cN0v4DW4TvC1i77p+ldAnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="194602593"
Received: from wdu1-mobl.ccr.corp.intel.com (HELO [10.238.0.228]) ([10.238.0.228])
  by orviesa001.jf.intel.com with ESMTP; 16 Jul 2025 02:25:45 -0700
Message-ID: <31f27919-926f-4cbd-81fa-5a52c453feca@intel.com>
Date: Wed, 16 Jul 2025 17:25:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] x86/paravirt: add backoff mechanism to
 virt_spin_lock
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Tianyou Li <tianyou.li@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
References: <20250703022332.254500-1-wangyang.guo@intel.com>
Content-Language: en-US
From: "Guo, Wangyang" <wangyang.guo@intel.com>
In-Reply-To: <20250703022332.254500-1-wangyang.guo@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Any comments or suggestions to this patch? Is there any further updates 
or changes needed?

BR
Wangyang

On 7/3/2025 10:23 AM, Wangyang Guo wrote:
> When multiple threads waiting for lock at the same time, once lock owner
> releases the lock, waiters will see lock available and all try to lock,
> which may cause an expensive CAS storm.
> 
> Binary exponential backoff is introduced. As try-lock attempt increases,
> there is more likely that a larger number threads compete for the same
> lock, so increase wait time in exponential.
> 
> The optimization can improves SpecCPU2017 502.gcc_r benchmark by ~4% for
> 288 cores VM on Intel Xeon 6 E-cores platform.
> 
> For micro benchmark, the patch can have significant performance gain
> in high contention case. Slight regression is found in some of mid-
> conetented cases because the last waiter might take longer to check
> unlocked. No changes to low contented scenario as expected.
> 
> Micro Bench: https://github.com/guowangy/kernel-lock-bench
> Test Platform: Xeon 8380L
> First Row: critical section length
> First Col: CPU core number
> Values: backoff vs linux-6.15, throughput based, higher is better
> 
> non-critical-length: 1
>         0     1     2     4     8    16    32    64   128
> 1   1.01  1.00  1.00  1.00  1.01  1.01  1.01  1.01  1.00
> 2   1.02  1.01  1.02  0.97  1.02  1.05  1.01  1.00  1.01
> 4   1.15  1.20  1.14  1.11  1.34  1.26  0.99  0.93  0.98
> 8   1.59  1.71  1.18  1.80  1.95  1.45  1.05  0.99  1.17
> 16  1.04  1.37  1.08  1.31  1.85  1.50  1.24  0.99  1.24
> 32  1.24  1.36  1.23  1.40  1.50  1.86  1.45  1.18  1.48
> 64  1.12  1.24  1.11  1.31  1.34  1.37  2.01  1.60  1.43
> 
> non-critical-length: 32
>         0     1     2     4     8    16    32    64   128
> 1   1.00  1.00  1.00  1.00  1.00  0.99  1.00  1.00  1.01
> 2   1.00  1.00  1.00  1.00  1.00  1.00  1.00  0.99  1.00
> 4   1.12  1.25  1.09  1.07  1.12  1.16  1.13  1.16  1.09
> 8   1.02  1.16  1.03  1.02  1.04  1.07  1.04  0.99  0.98
> 16  0.97  0.95  0.84  0.96  0.99  0.98  0.98  1.01  1.03
> 32  1.05  1.03  0.87  1.05  1.25  1.16  1.25  1.30  1.27
> 64  1.83  1.10  1.07  1.02  1.19  1.18  1.21  1.14  1.13
> 
> non-critical-length: 128
>         0     1     2     4     8    16    32    64   128
> 1   1.00  1.00  1.00  1.00  1.00  1.00  1.00  1.00  1.00
> 2   0.99  1.02  1.00  1.00  1.00  1.00  1.00  1.00  1.00
> 4   0.98  0.99  1.00  1.00  0.99  1.04  0.99  0.99  1.02
> 8   1.08  1.08  1.08  1.07  1.15  1.12  1.03  0.94  1.00
> 16  1.00  1.00  1.00  1.01  1.01  1.01  1.36  1.06  1.02
> 32  1.07  1.08  1.07  1.07  1.09  1.10  1.22  1.36  1.25
> 64  1.03  1.04  1.04  1.06  1.13  1.18  0.82  1.02  1.14
> 
> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Wangyang Guo <wangyang.guo@intel.com>
> ---
>   arch/x86/include/asm/qspinlock.h | 28 +++++++++++++++++++++++++---
>   1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
> index 68da67df304d..ac6e1bbd9ba4 100644
> --- a/arch/x86/include/asm/qspinlock.h
> +++ b/arch/x86/include/asm/qspinlock.h
> @@ -87,7 +87,7 @@ DECLARE_STATIC_KEY_FALSE(virt_spin_lock_key);
>   #define virt_spin_lock virt_spin_lock
>   static inline bool virt_spin_lock(struct qspinlock *lock)
>   {
> -	int val;
> +	int val, locked;
>   
>   	if (!static_branch_likely(&virt_spin_lock_key))
>   		return false;
> @@ -98,11 +98,33 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
>   	 * horrible lock 'holder' preemption issues.
>   	 */
>   
> +#define MAX_BACKOFF 64
> +	int backoff = 1;
> +
>    __retry:
>   	val = atomic_read(&lock->val);
> +	locked = val;
> +
> +	if (locked || !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL)) {
> +		int spin_count = backoff;
> +
> +		while (spin_count--)
> +			cpu_relax();
> +
> +		/*
> +		 * Here not locked means lock tried, but fails.
> +		 *
> +		 * When multiple threads waiting for lock at the same time,
> +		 * once lock owner releases the lock, waiters will see lock available
> +		 * and all try to lock, which may cause an expensive CAS storm.
> +		 *
> +		 * Binary exponential backoff is introduced. As try-lock attempt
> +		 * increases, there is more likely that a larger number threads
> +		 * compete for the same lock, so increase wait time in exponential.
> +		 */
> +		if (!locked)
> +			backoff = (backoff < MAX_BACKOFF) ? backoff << 1 : backoff;
>   
> -	if (val || !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL)) {
> -		cpu_relax();
>   		goto __retry;
>   	}
>   


