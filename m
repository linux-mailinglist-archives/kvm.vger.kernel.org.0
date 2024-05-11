Return-Path: <kvm+bounces-17252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E59D48C31F9
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 16:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FA36281D45
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 14:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E25356448;
	Sat, 11 May 2024 14:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtnLedF1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D051E526;
	Sat, 11 May 2024 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715439356; cv=none; b=JurrWZECkNLrBiuqhjIDnn4SROBdSuuzLbJl95J208h59z/cqN4VladiDzl0o1t6tG/83P/PJtORnsbohNh8ywQ/3UXvk1mnKP8I8T4JbGbfBpffH1q5PeQPyGzAEt3xTFQiL4+4EyuKkU0RjoVu6nG8M5thcsNEYYYSM0Z8OYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715439356; c=relaxed/simple;
	bh=6DaDv/aTgU/LZfJ58oDLB7kdos+gFtmzwvnoGqwfpIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0fvAOSg7AXs0/dh0RGnv0N036DARCRNmVLPbZynpJw4JVWXyGuopaHNzzOft6VRSxmm2/I6Sl51AnKb0MKrMp2fdlkeXo1h77TQS7NW5/WkyMF/r7+VTuEbuQ7yD34meSWcPqrtUQ9aPxDoFJtDSbpSY4uaZCvd+eWisZ8o5GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtnLedF1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21487C2BD11;
	Sat, 11 May 2024 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715439356;
	bh=6DaDv/aTgU/LZfJ58oDLB7kdos+gFtmzwvnoGqwfpIA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=UtnLedF1ycLpwyfLm9aXe0rro8YcpWVqtOydbHroNV3uMetv/7QUqr6trC1JwysyI
	 wdmx+WUWMgIdLaTGWacx9L9XHop1frC8AYexeE4mVwVkzj6QPz8INx84yVNaHNVPzO
	 5svWuehf9w5QsiMqkRkJkSJAmwNbgzUlWq3alZ2oziE1vkHPBm8cPJ2xadmeWGdcHv
	 T2GmPV1pwgc07EQN0p6j0Bzy7pvsTyl5G4P5YtohmaCAbrrLUwkWXhgz34vTB57YBb
	 r7A2sCTvdIXsG31yGmCBpv1xxuaOqWwkB9SsMMJ5ywB0NBlg31sJ4+5eWycP5Yn6Xk
	 GNahXig56Du0g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C01D1CE0F8E; Sat, 11 May 2024 07:55:55 -0700 (PDT)
Date: Sat, 11 May 2024 07:55:55 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Leonardo Bras <leobras@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Message-ID: <e6e42572-f73b-4217-871a-37c439ec8552@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240511020557.1198200-1-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511020557.1198200-1-leobras@redhat.com>

On Fri, May 10, 2024 at 11:05:56PM -0300, Leonardo Bras wrote:
> As of today, KVM notes a quiescent state only in guest entry, which is good
> as it avoids the guest being interrupted for current RCU operations.
> 
> While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> check for any RCU operations waiting for this CPU. In case there are any of
> such, it invokes rcu_core() in order to sched-out the current thread and
> note a quiescent state.
> 
> This occasional schedule work will introduce tens of microsseconds of
> latency, which is really bad for vcpus running latency-sensitive
> applications, such as real-time workloads.
> 
> So, note a quiescent state in guest exit, so the interrupted guests is able
> to deal with any pending RCU operations before being required to invoke
> rcu_core(), and thus avoid the overhead of related scheduler work.
> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
> 
> ps: A patch fixing this same issue was discussed in this thread:
> https://lore.kernel.org/all/20240328171949.743211-1-leobras@redhat.com/
> 
> Also, this can be paired with a new RCU option (rcutree.nocb_patience_delay)
> to avoid having invoke_rcu() being called on grace-periods starting between
> guest exit and the timer IRQ. This RCU option is being discussed in a
> sub-thread of this message:
> https://lore.kernel.org/all/5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop/
> 
> 
>  include/linux/context_tracking.h |  6 ++++--
>  include/linux/kvm_host.h         | 10 +++++++++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index 6e76b9dba00e..8a78fabeafc3 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -73,39 +73,41 @@ static inline void exception_exit(enum ctx_state prev_ctx)
>  }
>  
>  static __always_inline bool context_tracking_guest_enter(void)
>  {
>  	if (context_tracking_enabled())
>  		__ct_user_enter(CONTEXT_GUEST);
>  
>  	return context_tracking_enabled_this_cpu();
>  }
>  
> -static __always_inline void context_tracking_guest_exit(void)
> +static __always_inline bool context_tracking_guest_exit(void)
>  {
>  	if (context_tracking_enabled())
>  		__ct_user_exit(CONTEXT_GUEST);
> +
> +	return context_tracking_enabled_this_cpu();
>  }
>  
>  #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))
>  
>  #else
>  static inline void user_enter(void) { }
>  static inline void user_exit(void) { }
>  static inline void user_enter_irqoff(void) { }
>  static inline void user_exit_irqoff(void) { }
>  static inline int exception_enter(void) { return 0; }
>  static inline void exception_exit(enum ctx_state prev_ctx) { }
>  static inline int ct_state(void) { return -1; }
>  static inline int __ct_state(void) { return -1; }
>  static __always_inline bool context_tracking_guest_enter(void) { return false; }
> -static __always_inline void context_tracking_guest_exit(void) { }
> +static __always_inline bool context_tracking_guest_exit(void) { return false; }
>  #define CT_WARN_ON(cond) do { } while (0)
>  #endif /* !CONFIG_CONTEXT_TRACKING_USER */
>  
>  #ifdef CONFIG_CONTEXT_TRACKING_USER_FORCE
>  extern void context_tracking_init(void);
>  #else
>  static inline void context_tracking_init(void) { }
>  #endif /* CONFIG_CONTEXT_TRACKING_USER_FORCE */
>  
>  #ifdef CONFIG_CONTEXT_TRACKING_IDLE
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..e37724c44843 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -480,21 +480,29 @@ static __always_inline void guest_state_enter_irqoff(void)
>  /*
>   * Exit guest context and exit an RCU extended quiescent state.
>   *
>   * Between guest_context_enter_irqoff() and guest_context_exit_irqoff() it is
>   * unsafe to use any code which may directly or indirectly use RCU, tracing
>   * (including IRQ flag tracing), or lockdep. All code in this period must be
>   * non-instrumentable.
>   */
>  static __always_inline void guest_context_exit_irqoff(void)
>  {
> -	context_tracking_guest_exit();
> +	/*
> +	 * Guest mode is treated as a quiescent state, see
> +	 * guest_context_enter_irqoff() for more details.
> +	 */
> +	if (!context_tracking_guest_exit()) {
> +		instrumentation_begin();
> +		rcu_virt_note_context_switch();
> +		instrumentation_end();
> +	}
>  }
>  
>  /*
>   * Stop accounting time towards a guest.
>   * Must be called after exiting guest context.
>   */
>  static __always_inline void guest_timing_exit_irqoff(void)
>  {
>  	instrumentation_begin();
>  	/* Flush the guest cputime we spent on the guest */
> -- 
> 2.45.0
> 

