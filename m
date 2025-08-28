Return-Path: <kvm+bounces-56203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D95B3AEB5
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FEC5582C1C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F112DE70D;
	Thu, 28 Aug 2025 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FCmBOZww"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E482262FC0;
	Thu, 28 Aug 2025 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425394; cv=none; b=nYUdm8BP+4m9vOMx1CHCYk0fu+gdbHb8dGYOiTMDAiYrgIWNvH15XYFwb15eOb71fspXQw40JrwqB3QXyACrDUB2M2KO1YbVjRISEVPxXZCj+DEiM56N5Ci8iMQH4WiSFZSES2JRKvlVH0j7ZV9ywIWVwPpcAypBLcAcjKkPWK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425394; c=relaxed/simple;
	bh=jqOpLgavgnkRBITOWBnwEBLwXK1rh8ql4OGzOkGqwIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fccigkxiXMu26HzCCHk/C74nKVTeDf/XmNOon8iFQGuq1pjFt+LSKhvd0XF2/vxvFQk0ok2dh/anJrpg6pHhl5rR0kPuFn3+SfGqCM8mK9Ld+BpcwE160SJj3SdvDs8SqacvjymOel8I/Coy3T++u2hVv6gNsF+6OFKuW64ngF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FCmBOZww; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.128.219] (unknown [20.236.11.69])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6157F2110814;
	Thu, 28 Aug 2025 16:56:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6157F2110814
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1756425392;
	bh=pCexqDkoW83y7LpImpFx62Xw3cNxneYeXhAEgKffuKE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FCmBOZwwR8w+zLgYvdYsQndKdjVa/Zic9g+xriRNGxIyvlCW/6jpNTSZnJfm6AeYV
	 w2ojPM1lFjNBJBy+LYvZF2V3PzDSbQwMQWAu7ekzKLIlFXUd3JJs7xNFRWV7yBhSjO
	 k2ChjjpZ1AKeJCgw2XX5B7Ss1Fvkq4e5nLRu23ks=
Message-ID: <0b4eb0cc-657f-4cdb-8255-e3b8f6b14077@linux.microsoft.com>
Date: Thu, 28 Aug 2025 16:56:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] Drivers: hv: Handle NEED_RESCHED_LAZY before
 transferring to guest
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
 <20250828000156.23389-2-seanjc@google.com>
Content-Language: en-US
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <20250828000156.23389-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/2025 5:01 PM, Sean Christopherson wrote:
> Check for NEED_RESCHED_LAZY, not just NEED_RESCHED, prior to transferring
> control to a guest.  Failure to check for lazy resched can unnecessarily
> delay rescheduling until the next tick when using a lazy preemption model.
> 
> Note, ideally both the checking and processing of TIF bits would be handled
> in common code, to avoid having to keep three separate paths synchronized,
> but defer such cleanups to the future to keep the fix as standalone as
> possible.
> 
> Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>
> Cc: Mukesh R <mrathor@linux.microsoft.com>
> Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
> Fixes: 64503b4f4468 ("Drivers: hv: Introduce mshv_vtl driver")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/hv/mshv_common.c    | 2 +-
>  drivers/hv/mshv_root_main.c | 3 ++-
>  drivers/hv/mshv_vtl_main.c  | 3 ++-
>  3 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
> index 6f227a8a5af7..eb3df3e296bb 100644
> --- a/drivers/hv/mshv_common.c
> +++ b/drivers/hv/mshv_common.c
> @@ -151,7 +151,7 @@ int mshv_do_pre_guest_mode_work(ulong th_flags)
>  	if (th_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>  		return -EINTR;
>  
> -	if (th_flags & _TIF_NEED_RESCHED)
> +	if (th_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY))
>  		schedule();
>  
>  	if (th_flags & _TIF_NOTIFY_RESUME)
> diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
> index 932932cb91ea..0d849f09160a 100644
> --- a/drivers/hv/mshv_root_main.c
> +++ b/drivers/hv/mshv_root_main.c
> @@ -484,7 +484,8 @@ mshv_vp_wait_for_hv_kick(struct mshv_vp *vp)
>  static int mshv_pre_guest_mode_work(struct mshv_vp *vp)
>  {
>  	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
> -				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
> +				 _TIF_NEED_RESCHED  | _TIF_NEED_RESCHED_LAZY |
> +				 _TIF_NOTIFY_RESUME;
>  	ulong th_flags;
>  
>  	th_flags = read_thread_flags();
> diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
> index dc6594ae03ad..12f5e77b7095 100644
> --- a/drivers/hv/mshv_vtl_main.c
> +++ b/drivers/hv/mshv_vtl_main.c
> @@ -728,7 +728,8 @@ static int mshv_vtl_ioctl_return_to_lower_vtl(void)
>  	preempt_disable();
>  	for (;;) {
>  		const unsigned long VTL0_WORK = _TIF_SIGPENDING | _TIF_NEED_RESCHED |
> -						_TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL;
> +						_TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL |
> +						_TIF_NEED_RESCHED_LAZY;
>  		unsigned long ti_work;
>  		u32 cancel;
>  		unsigned long irq_flags;

Tested by compiling with CONFIG_PREEMPT_LAZY=y and booting a guest. For
the test I added a check to confirm _TIF_NEED_RESCHED_LAZY was set and
honored.

Looks good, thanks.

Tested-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>

