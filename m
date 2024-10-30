Return-Path: <kvm+bounces-30109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C39789B6E8C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:13:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81B71282D4F
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B08215C62;
	Wed, 30 Oct 2024 21:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgX4jy4s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE4F2144CA
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 21:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730322809; cv=none; b=emlwngcMRsvZKwBwU+cGlG2N/pqsg48X7Fu9+4igZIuDtUqpWgFtsYgDBjxFs2CZ+RZUOiAAqCt673RF8RztAn3xpYYzGu4HWPLfNu4Ab/qQflDhoxWiUguPW3XwuMo9j+2hc8GmY/agsamnuoxIqPAqtX0wjqMceqioc6wCec8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730322809; c=relaxed/simple;
	bh=/FTy96P2ETm6sf+VPH671cWZq6UL39N1Z55TKD2tsKY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B5FZ6gw3jhvjjmehGnGSZKx5xR7mRK7+YvKdoHmXCLHqnzZb6EqMPj0SFjhB5bBkmKUM6NwuMkg6BplfpbIP9QVhwbTu85L9C0sfuZo73MrIKpuSnXvs/osa0ual/zXpeKNSrHUzZ+qrHGv3xT0VSIgIFEodJFlu/YoY4LGc6fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgX4jy4s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730322806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mDpS5x8dmu9kuzt32B98o/PyB3+3iZe2sQYd6fMoEgU=;
	b=TgX4jy4sx6w2PmJ6w78y3R9sj5VgLAvMnaNjHPEH+Fc8bPUWnILcxmCN5WklsJerS3NyVO
	+fjIkEXAcbUMywSq8m0j+3YzaC4mmpteyAMiV+NtHy3zd2opLmysWBohYXV8nIZQwqnBQ0
	Ao0BonA8Y2ZL2BUWWaylrMeqGqvD78c=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-1Lh9-J8-M5agE6J5MutCiQ-1; Wed, 30 Oct 2024 17:13:24 -0400
X-MC-Unique: 1Lh9-J8-M5agE6J5MutCiQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d19597cee0so5682536d6.3
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730322804; x=1730927604;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mDpS5x8dmu9kuzt32B98o/PyB3+3iZe2sQYd6fMoEgU=;
        b=kQsvT7Im08RJC1SvANdm+AB/fS850y3lyoERUbtpgqHp6T/zlgwlMB+kUuRViq+Cqf
         tcLQmiCfrhYTCCEK9dP7+6E14YwNvgJirNnDnO2NCJ+v+sE+ayE198ibIcy/Tr7WXO2k
         eJ8V2zwZFZbIfpM+RWHz6Tlr5tfsHSB3tKIleDhLS1FTzZDGFx7pyIOc+p/8ASMr4/Iw
         Nb72Ds4Mmm04AQZOCmsT9+9n0avUUbLe1/nq4nlUQL0SBXpo5FWlljX7ejXcl89u82oa
         4X2c77oHkj5NviTq0LfuAouAIq45MgmjUO69Ir5xpUquHaGQDz48RdQknFKsup4bXY5i
         aCcA==
X-Gm-Message-State: AOJu0YwTqbqFlBwWyozyXeWkXIO6x8UlP0w7Jd9/xEWbNYZtlPzQqVj1
	1iRGuz3Y7JKLhpIe2UXBfds04ZEpwbxhUnMxIIVsuh2v92X3mF1yYyYCodKysdK2LA3xu2Vn2fq
	aiOk7dj9QOJ0J7neaSRv2Nqg2plH1u9U7xdDteNT3CEFkm/Q6XA==
X-Received: by 2002:a05:6214:418e:b0:6c3:5833:260f with SMTP id 6a1803df08f44-6d34609a8b8mr47908356d6.39.1730322804340;
        Wed, 30 Oct 2024 14:13:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvupjoGiDQSbH4vksBPp9cno7jEbTpR6vbKzhEznV2sKwBx0R6PUBrDNOHRwN1Mnr/QvUn9A==
X-Received: by 2002:a05:6214:418e:b0:6c3:5833:260f with SMTP id 6a1803df08f44-6d34609a8b8mr47908106d6.39.1730322804000;
        Wed, 30 Oct 2024 14:13:24 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d3541614e1sm455566d6.86.2024.10.30.14.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:13:23 -0700 (PDT)
Message-ID: <0b9cabc04b9ef9e9b24fe439cafc232afc035972.camel@redhat.com>
Subject: Re: [PATCH v4 3/4] KVM: x86: Add lockdep-guarded asserts on
 register cache usage
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2024 17:13:23 -0400
In-Reply-To: <20241009175002.1118178-4-seanjc@google.com>
References: <20241009175002.1118178-1-seanjc@google.com>
	 <20241009175002.1118178-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-10-09 at 10:50 -0700, Sean Christopherson wrote:
> When lockdep is enabled, assert that KVM accesses the register caches if
> and only if cache fills are guaranteed to consume fresh data, i.e. when
> KVM when KVM is in control of the code sequence.  Concretely, the caches
> can only be used from task context (synchronous) or when handling a PMI
> VM-Exit (asynchronous, but only in specific windows where the caches are
> in a known, stable state).
> 
> Generally speaking, there are very few flows where reading register state
> from an asynchronous context is correct or even necessary.  So, rather
> than trying to figure out a generic solution, simply disallow using the
> caches outside of task context by default, and deal with any future
> exceptions on a case-by-case basis _if_ they arise.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index b1eb46e26b2e..36a8786db291 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -43,6 +43,18 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
>  BUILD_KVM_GPR_ACCESSORS(r15, R15)
>  #endif
>  
> +/*
> + * Using the register cache from interrupt context is generally not allowed, as
> + * caching a register and marking it available/dirty can't be done atomically,
> + * i.e. accesses from interrupt context may clobber state or read stale data if
> + * the vCPU task is in the process of updating the cache.  The exception is if
> + * KVM is handling a PMI IRQ/NMI VM-Exit, as that bound code sequence doesn't
> + * touch the cache, it runs after the cache is reset (post VM-Exit), and PMIs
> + * need to access several registers that are cacheable.
> + */
> +#define kvm_assert_register_caching_allowed(vcpu)		\
> +	lockdep_assert_once(in_task() || kvm_arch_pmi_in_guest(vcpu))
> +
>  /*
>   * avail  dirty
>   * 0	  0	  register in VMCS/VMCB
> @@ -53,24 +65,28 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
>  static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
>  					     enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
>  static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
>  					 enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>  }
>  
>  static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
>  					       enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
>  static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>  					   enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>  }
> @@ -84,6 +100,7 @@ static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>  static __always_inline bool kvm_register_test_and_mark_available(struct kvm_vcpu *vcpu,
>  								 enum kvm_reg reg)
>  {
> +	kvm_assert_register_caching_allowed(vcpu);
>  	return arch___test_and_set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  

Using lockdep for non 100% lockdep purposes is odd, but then these asserts do
guard against races, so I guess this is a fair use of this assert.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


