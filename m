Return-Path: <kvm+bounces-17245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ABC48C2EF3
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 04:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B46A9281357
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 02:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF17B1CD11;
	Sat, 11 May 2024 02:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvhLtvdG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F8F47781
	for <kvm@vger.kernel.org>; Sat, 11 May 2024 02:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715393655; cv=none; b=jVhulYKwGIMNjKLP5ITE5aQ4TjNjbj2rOyYWc84HVWCTu8U2FSOG2C4nwtSGg2LalMWrGJKnJN+EKJMX37X9fz8b9TM3MtWhBC1sCZiEAf6duYDGjMeZmcIJ0hpCiIuAderop7uy3/NhpD4fNYLaKELFUmGVg5EipRrwBdN7+C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715393655; c=relaxed/simple;
	bh=i370JQajy3aWMRuZbCpfoUCzv45kEjChB2LQhLHEfVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=t7cnVb+I3Mn9Hq4t0raNVLIXIntfXoLQYR1O1KLQtpG5IyYWtNFskegBaCeTQqIxU0wvms/MAaN4YiIgH6Gtgac85MKDHrESjrDwoPTmHyD1wbMjvvmzQGGDoVIaFmUwCxxfIb0nl9gXbvAliCGbRQrM/W1XrveJzNyCkkw7Kmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvhLtvdG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715393643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCrVTsZCa0hoHkBjUZaAalxSusJYxIl0S99WRdYG/Jo=;
	b=QvhLtvdG6ILHrAqmX6Ncb5iNclpjj6xbOKWE5qUEorP8AjPndPHrKyT/2tRoCkszjdZlm/
	5V0sFNKOOp6zCSF0zhSFt1z341hg1om6+OGAgAxK3IspiCSbro713GRNdgh8sVhyPp/FmV
	YArVnCRHBkkPF95HpNpY+lWb3PmLkgE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-BgZxTvlmOjeKTuVs0PdQoQ-1; Fri, 10 May 2024 22:11:46 -0400
X-MC-Unique: BgZxTvlmOjeKTuVs0PdQoQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-792c365cacdso269362585a.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 19:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715393506; x=1715998306;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCrVTsZCa0hoHkBjUZaAalxSusJYxIl0S99WRdYG/Jo=;
        b=DSSXMj7OLmaaHcohCjWhNlXTg4IYZ1T+KPJlmwF6u6L/jMEDZty7/8GXts/ujeLDv3
         iuM1yiU8Vk8R5tj+Qg/i4ddiuBAtXhu1iBQzDdibxGiRMvA9hfzhZ3mwiQJHtxiI3AVO
         0TFGWfn2W5/LJQtDcEirmkn5QzdNI7IXkgUVjlsJkbpjCA6CJT1yczqQXfFqDf2tkrE7
         dutpM2T8emwV1eqiPqXeCDy0ywH2Q/m4wB7U6FSu4ITB7GCwxHnB3jDTtmrnc4aficMh
         OEkzwMsLVlQkZUYvmMOIM5oqp7kG9/sVQbz8GcKBhVlhrarLHfN8mskuJBdHjqrWd7RQ
         3PSw==
X-Forwarded-Encrypted: i=1; AJvYcCUydF53ulkgLUjgiPFCT8hFfs5jOJxRvLiT/SxLlM0k7Yva3Z4qdw6V+NaB9xO9iHdg/jq/vlvzENO1j28DD1Pmw6zR
X-Gm-Message-State: AOJu0Yz26UyBPJ6lx5v2iy7Iit7N/7CSpx+wueH4Go5TKmvKO8rg8Mwt
	LHQ/Kn6I89+U73wR1oldxkcZL/rF0OzUgUyla2r6cEKh4zqmjIJRQoW1GgDOsCARduXXy5VhLUr
	kcZaAs2+S7/3NQN/ZoSq0NNkDpIMRdXYxXnxa5yvhnPtG6IQY8w==
X-Received: by 2002:a05:620a:22f:b0:792:bc48:cdab with SMTP id af79cd13be357-792c757701dmr456482185a.13.1715393506101;
        Fri, 10 May 2024 19:11:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1e1amTkPJC4bHZhB3yzTNDaD6gx/0MhQAvP0aPsfcDRa6XbUU75rxaSQwzuWv94WMS/1PSA==
X-Received: by 2002:a05:620a:22f:b0:792:bc48:cdab with SMTP id af79cd13be357-792c757701dmr456481085a.13.1715393505698;
        Fri, 10 May 2024 19:11:45 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:8d87:eac1:dae4:8dd4:fe50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf275229sm236347485a.18.2024.05.10.19.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 19:11:45 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Date: Fri, 10 May 2024 23:11:41 -0300
Message-ID: <Zj7T3duUQqQPBryS@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240511020557.1198200-1-leobras@redhat.com>
References: <20240511020557.1198200-1-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

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

s/guests/guest

> to deal with any pending RCU operations before being required to invoke
> rcu_core(), and thus avoid the overhead of related scheduler work.
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


