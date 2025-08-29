Return-Path: <kvm+bounces-56359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B76B3C28F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01AB21896417
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 18:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984F33451B7;
	Fri, 29 Aug 2025 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ov5WnNhD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCCE3375DA;
	Fri, 29 Aug 2025 18:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756492699; cv=none; b=buttVTHJ+kDDvSgu+XgUIhp9EAX1umGqGygaz66t9x40bT9osxrtiTPC62CGB48tsbTo6hr1hikeeo37N/1mw3g0cJNXmLGskcSmdB+HVnPEszZxKy5JtDj6eLfW11+b89BV8vwrlp+DEHj5As06m74hnTyu1Zgj+1up7dxHP6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756492699; c=relaxed/simple;
	bh=G2OtD6gg+bw9ZqOkq99RiwmobzpQGmczBt388tEvqQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuZrB5v6ysIU9K5ei4eCQuUR6pgA6aULQNRh30YJZ2bGxOaqrg2EsPTXHw04+XIVblAcx5yUR4ZmBMhRS8iQl4acYRMrWM8Fvx+P4ZMp78iDNJcdbk1yZ8UDeb40klNEsUCQA9+a2mmOT0Y48gjh6p9G5CINFOJnGcjt94r9STA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ov5WnNhD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838E8C4CEF0;
	Fri, 29 Aug 2025 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756492698;
	bh=G2OtD6gg+bw9ZqOkq99RiwmobzpQGmczBt388tEvqQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ov5WnNhDYY/E6a4awYJM+K8xgExCClE5Y0Tf2Y11//SUqC2e8H33VSZ3i1uc1POtL
	 3YeCHPT+LRLLcXNmGQk3C5oHa7zsZ0bofiQBgc3pMXL6VH0tJuaARC3EPbSqo4icNK
	 2wfmzXZxZK8E2DR8zjmoS3hnPuPIA3PoPtUqF3bYgIyCzxtY0eWIORQko0EVjTH3+9
	 ZfDkkyLHld0blZUJ+7o4K80ZpSREI4kfSUqIc7jMHAmBsnDS9BGcDpLvn6Kaz95vU6
	 U4WSMzFdzrnSt8Z0481GORe3zvOMdHZ8W4AuagPsc8gBnpvZu0IxNoyLS2Jq773s7J
	 3OXrT9D8lO56A==
Date: Fri, 29 Aug 2025 18:38:16 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Mukesh R <mrathor@linux.microsoft.com>, ssengar@linux.microsoft.com,
	namjain@linux.microsoft.com
Subject: Re: [PATCH v2 2/7] Drivers: hv: Disentangle VTL return cancellation
 from SIGPENDING
Message-ID: <aLHzmBFuWy2P5Opq@liuwe-devbox-ubuntu-v2.tail21d00.ts.net>
References: <20250828000156.23389-1-seanjc@google.com>
 <20250828000156.23389-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828000156.23389-3-seanjc@google.com>

On Wed, Aug 27, 2025 at 05:01:51PM -0700, Sean Christopherson wrote:
> Check for return to a lower VTL being cancelled separately from handling
> pending TIF-based work, as there is no need to immediately process pending
> work; the kernel will immediately exit to userspace (ignoring preemption)
> and handle the pending work at that time.
> 
> Disentangling cancellation from the TIF-based work will allow switching to
> common virtualization APIs for detecting and processing pending work.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks for this patch, Sean.

My current plan is to drop this driver from my tree (hence it will
disappear from linux-next soon) because Peter has an objection to the
ABI it introduces. I just have not gotten around to it yet.

I won't apply this patch, the next one and the last one. I have CC'ed
the owner of that driver to this patch here so that your suggestion can
be incorporated in future submissions.

CC Saurabh and Naman.

Thanks,
Wei

> ---
>  drivers/hv/mshv_vtl_main.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
> index 12f5e77b7095..aa09a76f0eff 100644
> --- a/drivers/hv/mshv_vtl_main.c
> +++ b/drivers/hv/mshv_vtl_main.c
> @@ -731,19 +731,21 @@ static int mshv_vtl_ioctl_return_to_lower_vtl(void)
>  						_TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL |
>  						_TIF_NEED_RESCHED_LAZY;
>  		unsigned long ti_work;
> -		u32 cancel;
>  		unsigned long irq_flags;
>  		struct hv_vp_assist_page *hvp;
>  		int ret;
>  
>  		local_irq_save(irq_flags);
> +		if (READ_ONCE(mshv_vtl_this_run()->cancel)) {
> +			local_irq_restore(irq_flags);
> +			preempt_enable();
> +			return -EINTR;
> +		}
> +
>  		ti_work = READ_ONCE(current_thread_info()->flags);
> -		cancel = READ_ONCE(mshv_vtl_this_run()->cancel);
> -		if (unlikely((ti_work & VTL0_WORK) || cancel)) {
> +		if (unlikely(ti_work & VTL0_WORK)) {
>  			local_irq_restore(irq_flags);
>  			preempt_enable();
> -			if (cancel)
> -				ti_work |= _TIF_SIGPENDING;
>  			ret = mshv_do_pre_guest_mode_work(ti_work);
>  			if (ret)
>  				return ret;
> -- 
> 2.51.0.268.g9569e192d0-goog
> 
> 

