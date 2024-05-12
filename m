Return-Path: <kvm+bounces-17276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE748C39C0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C06D52811FD
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9723910A16;
	Mon, 13 May 2024 01:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKWv9Ath"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC18101F7
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562412; cv=none; b=TB0vK5pS7Gji/XfKKLq+7efwOnj67v8eWyPBS2H2DdZE+dYm5yximO2bBYDbiu65feHP21Aln5yIYtAYj68hYhqnTpKFTLWrtT9S+c37iQptQeNvyLttenOfR46DN1de5UYjIVZSRUwZyVmr9IVs4I70xeyhehL7f6HGJ0d2sPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562412; c=relaxed/simple;
	bh=z5mJ1/5uug7AEPGBHrwQP1RnsDF46AQ6CEpaPD25I/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j98KkFBZGo/6VUlKx94R8u02/W8wssrhsh3VMSnkgIKNdNxuu4jxpLqxq03ux3UBIE9BY2X+iwT++y2SWUL1Q3XrqbLaNMP3nhnkrhDmYawxscnqLDTYowd3WXqyGCIdBdyLHvUXhwxBH6vu8iNT0yl1JRtPI2Fm5G4YV2qlYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKWv9Ath; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715562410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4m6P5DzqA8so+cu7rXtxZX9zRgtX/pSS/kHNFecXgEU=;
	b=eKWv9AthtEe5cARwPrH9f3GMajcbdgWb64o66sFPNLzm+kyay7FAOAsRZ6rb21A40OVKco
	XfdtXz5BzVs9hnBp6wbuV9BrXy/doxKVxHw6WDyTx+k+zNtQoUbvj7NigHX1Kw0rogetpw
	BfVb2FJba4tVhF7bDY8JtuuxKYlSewc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-A_bfeSZ0NhqbI3YTU8cf1A-1; Sun, 12 May 2024 21:06:36 -0400
X-MC-Unique: A_bfeSZ0NhqbI3YTU8cf1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22CE485A58C;
	Mon, 13 May 2024 01:06:36 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.2])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C112103A3AA;
	Mon, 13 May 2024 01:06:35 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 16E0F400DF40C; Sun, 12 May 2024 18:44:23 -0300 (-03)
Date: Sun, 12 May 2024 18:44:23 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Message-ID: <ZkE4N1X0wglygt75@tpad>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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

This does not properly fix the current problem, as RCU work might be
scheduled after the VM exit, followed by a timer interrupt.

Correct?

> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
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
> 
> 


