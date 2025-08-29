Return-Path: <kvm+bounces-56204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E27A1B3AEC6
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CDC63B2C81
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9E235950;
	Fri, 29 Aug 2025 00:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="b/Cp3YVn"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BBE179A3;
	Fri, 29 Aug 2025 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425814; cv=none; b=YTBj0yqhbVA+ubrrf6ULi7Iugfb/zc07Vb5ecJcpQSMwmfeQFVVzD2SV+JgFp7y0rfqk5I1zyuwh0JuAHSppaYFOwhtXo2VG5DjflXvelxaKcSrx3jOh+eIJy+stKA1jWO6KUh2rrKhNz2Dz4nEaEDFG/cYJyA5tQgR2AIT2UPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425814; c=relaxed/simple;
	bh=h9ECKGOoE8l6lXBXfI/nqr/yvcdfmjjurJiByFbfZ+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hxBnOUAOqJVRqK8WUpAb6X83ZGXxxFdmPoPs0eB30AwCuJFlcFClPLyuZyw3zJhLxmu3UTklnxyINB5mFN2x27+BIsgOoQbfjgGLHJD1mzHoj3Dg6k/ydyisxQ0CNngI4TpaFBeDciR9zG9dKWLcPcOZXtG9EYKLn+mMraICO2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=b/Cp3YVn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.128.219] (unknown [20.236.11.69])
	by linux.microsoft.com (Postfix) with ESMTPSA id 29236211080D;
	Thu, 28 Aug 2025 17:03:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 29236211080D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1756425810;
	bh=NHYELJgOgtoYXMJjyiZ6Y/1BY77k4JUs4dbKzcllNgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b/Cp3YVnPly7ZmtMQDa2AEMRoQa4CxzO0/V6ejotdr50lR5itAta36gVWEjEJkADW
	 rU7s8pjJhzWn/fR2q78z1pzSDm8R5EbcWLUxToRvAEbLWCrmz4XX39aTX/yCwcbIg0
	 s7ITLAqpkbVOXbI9g+AL0NaazVp0H0AaluYJk0kI=
Message-ID: <c1a5ab1d-1601-46db-83da-b26422a2aabd@linux.microsoft.com>
Date: Thu, 28 Aug 2025 17:03:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] Drivers: hv: Use common "entry virt" APIs to do
 work in root before running guest
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-hyperv@vger.kernel.org, rcu@vger.kernel.org,
 Mukesh R <mrathor@linux.microsoft.com>
References: <20250828000156.23389-1-seanjc@google.com>
 <20250828000156.23389-7-seanjc@google.com>
Content-Language: en-US
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <20250828000156.23389-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/2025 5:01 PM, Sean Christopherson wrote:
> Use the kernel's common "entry virt" APIs to handle pending work prior to
> (re)entering guest mode, now that the virt APIs don't have a superfluous
> dependency on KVM.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/hv/Kconfig          |  1 +
>  drivers/hv/mshv_root_main.c | 32 ++++++--------------------------
>  2 files changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> index 2e8df09db599..894037afcbf9 100644
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -66,6 +66,7 @@ config MSHV_ROOT
>  	# no particular order, making it impossible to reassemble larger pages
>  	depends on PAGE_SIZE_4KB
>  	select EVENTFD
> +	select VIRT_XFER_TO_GUEST_WORK
>  	default n
>  	help
>  	  Select this option to enable support for booting and running as root
> diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
> index 0d849f09160a..7c83f656e071 100644
> --- a/drivers/hv/mshv_root_main.c
> +++ b/drivers/hv/mshv_root_main.c
> @@ -8,6 +8,7 @@
>   * Authors: Microsoft Linux virtualization team
>   */
>  
> +#include <linux/entry-virt.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/fs.h>
> @@ -481,29 +482,6 @@ mshv_vp_wait_for_hv_kick(struct mshv_vp *vp)
>  	return 0;
>  }
>  
> -static int mshv_pre_guest_mode_work(struct mshv_vp *vp)
> -{
> -	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
> -				 _TIF_NEED_RESCHED  | _TIF_NEED_RESCHED_LAZY |
> -				 _TIF_NOTIFY_RESUME;
> -	ulong th_flags;
> -
> -	th_flags = read_thread_flags();
> -	while (th_flags & work_flags) {
> -		int ret;
> -
> -		/* nb: following will call schedule */
> -		ret = mshv_do_pre_guest_mode_work(th_flags);
> -
> -		if (ret)
> -			return ret;
> -
> -		th_flags = read_thread_flags();
> -	}
> -
> -	return 0;
> -}
> -
>  /* Must be called with interrupts enabled */
>  static long mshv_run_vp_with_root_scheduler(struct mshv_vp *vp)
>  {
> @@ -524,9 +502,11 @@ static long mshv_run_vp_with_root_scheduler(struct mshv_vp *vp)
>  		u32 flags = 0;
>  		struct hv_output_dispatch_vp output;
>  
> -		ret = mshv_pre_guest_mode_work(vp);
> -		if (ret)
> -			break;
> +		if (__xfer_to_guest_mode_work_pending()) {
> +			ret = xfer_to_guest_mode_handle_work();
> +			if (ret)
> +				break;
> +		}
>  
>  		if (vp->run.flags.intercept_suspend)
>  			flags |= HV_DISPATCH_VP_FLAG_CLEAR_INTERCEPT_SUSPEND;

Also tested mshv_root with 1-6 applied, looks good to me. Possibly Naman,
Saurabh, or Roman can test the mshv_vtl patches, I can't do it
unfortunately.

Tested-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

