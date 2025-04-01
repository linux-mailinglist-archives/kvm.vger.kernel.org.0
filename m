Return-Path: <kvm+bounces-42401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5D8A782E8
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 21:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E27341890642
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF0820B7EA;
	Tue,  1 Apr 2025 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DNAmL+lz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC28719005E
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743536965; cv=none; b=IQNoCeV6EXTcxsmERbkhuEarCefQ9f3QxjDlZ7ROazGROn0zkfnBFmIyYLjGuVvZHHKdHre5HErnYovHYSJm8OIX2WWl3I8ye47EtclSF/+hFPdftCNU0rl7uETGUHfHzYGJI4RK9PN3gySwWDWowOyxh+3JStk/6uSwIDsdbbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743536965; c=relaxed/simple;
	bh=DKSSoMpkaMWcUbyqK3fR2YhmJhRbxfxvDtNR+pwWXkQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=imGlX46lbRv3alp7YEVnm4+8QW8rb9YD4RIgBeXJpfzViAblY7txy1YNU6PqX1CgvoNNCxetSjLKc3KyIkjyF9UdS1MmvD/FPYwm0j+iAe04sQIQv4vFQFChrUFbjsXgAgDJMWa86xlrS5cDE/PHMtl7N4mTCiSe++jwvhc0Rcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DNAmL+lz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743536962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6aFdoOLNMaUqdJV8mscrGGeWo5G3sWPq1TH9o5KfjRQ=;
	b=DNAmL+lzUK7imixTSoi6ITJ4efHXlHO5U1Qo8mbor7dJ3g+/b9O7Fd9rg0Ugy9KnreDa21
	rA9ylhKq6/Q9zzpDIEqbDVVP0BLsioAFmOajzlD0mMXoWylIwJKKj8PSe2y9xVnudcHMqe
	akXGqS2ODzXhcJF3KRcmDvqAju2Aafk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-BhCRCm4YMRaEWR8gJlep2Q-1; Tue, 01 Apr 2025 15:49:21 -0400
X-MC-Unique: BhCRCm4YMRaEWR8gJlep2Q-1
X-Mimecast-MFC-AGG-ID: BhCRCm4YMRaEWR8gJlep2Q_1743536961
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c543ab40d3so893043385a.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 12:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743536961; x=1744141761;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6aFdoOLNMaUqdJV8mscrGGeWo5G3sWPq1TH9o5KfjRQ=;
        b=oU3dbbheFe0andTiQeQkoSJMMRTrImmBK3GbRdhwqpr3F/LDhErlaqkYw8gxJbYLbq
         5/ANV6Fv881reAhdAOOEJC5XN5/01XEp9liZX0jhoqWplVJSXxIs56WfWkYXiq9gKJqK
         QlNuuy2BQoMSTeSpvUU7jYCWruj/pnNRd8efUI8EkOvcEwCkP2lZJ63bpxAASNb5hCRy
         LywJd5E1VQgcUOt9tHWVu2E4Vcen+TEf9FqMA+pJm8r5xTVrUFvkVb++drRyHbq6qAh0
         lRHO/7oSiBa9H1oG4LBXthzcWtr8H7KU6MViRBRld9R3C/KBo01aUXYkaCyKx87VEWe6
         pSMA==
X-Gm-Message-State: AOJu0YxXNSx8JXtaNg26NAoFAgwKGTu3jYROKUVmzrlgBuameZw0NIKw
	jpu2e5EICMRV3EyqmEAGCEu4NmYluzXKGJGdOWRr2Vn7xYlhP6zZkYz1rpHCxryR51g+jRZa6/z
	abHwZACfm0RA1yeonPg41+XwyZhnO28lHqJ0Llh8uDXEqL+wyxw==
X-Gm-Gg: ASbGncvjKLamgX3B8+41d4X/TnDHjHL9QiDj293b9D+CS/nz3SWZQQ1sAk7OUneFGSz
	IQd6fyymf17b8czVgQqdZ/yfUpIN7yCLYB7lQKfilQc7hz8GPI4zSRMjLTB4KWJASZKXfzVHqL3
	beFUU47QA9NafOs1q9ONfdmfn/pmmF8JHHzE4IkKSfHDktsEHpU6R1fHTTWuHFd/8YVzEDR9JOJ
	MsPACuzidBnxMBRfGlNb5jB5/v3UpM+KeMwx5MdiMJryXzkxBSeT/2VkWkmUqqWqZx/Ci3yBiED
	RTR0bf0pfjYvixs=
X-Received: by 2002:a05:620a:440f:b0:7c5:4de8:bf71 with SMTP id af79cd13be357-7c690892b51mr2375951185a.50.1743536961118;
        Tue, 01 Apr 2025 12:49:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfcPKa4rVElptgOdiOswt8IrG9UPesQcWUAxmUvbrM7duAAz7UjPlRlhqLGbJSFn0rVOAKQw==
X-Received: by 2002:a05:620a:440f:b0:7c5:4de8:bf71 with SMTP id af79cd13be357-7c690892b51mr2375948385a.50.1743536960770;
        Tue, 01 Apr 2025 12:49:20 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5f76a6afesm695863085a.49.2025.04.01.12.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:49:20 -0700 (PDT)
Message-ID: <6ff7d6508a59587b3f02624a24511c642511f5c2.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Use separate subclasses for PI wakeup
 lock to squash false positive
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Yan Zhao
	 <yan.y.zhao@intel.com>
Date: Tue, 01 Apr 2025 15:49:19 -0400
In-Reply-To: <20250401154727.835231-3-seanjc@google.com>
References: <20250401154727.835231-1-seanjc@google.com>
	 <20250401154727.835231-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-04-01 at 08:47 -0700, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Use a separate subclass when acquiring KVM's per-CPU posted interrupts
> wakeup lock in the scheduled out path, i.e. when adding a vCPU on the list
> of vCPUs to wake, to workaround a false positive deadlock.
> 
>   Chain exists of:
>    &p->pi_lock --> &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                CPU1
>         ----                ----
>    lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>                             lock(&rq->__lock);
>                             lock(&per_cpu(wakeup_vcpus_on_cpu_lock, cpu));
>    lock(&p->pi_lock);
> 
>   *** DEADLOCK ***
> 
> In the wakeup handler, the callchain is *always*:
> 
>   sysvec_kvm_posted_intr_wakeup_ipi()
>   |
>   --> pi_wakeup_handler()
>       |
>       --> kvm_vcpu_wake_up()
>           |
>           --> try_to_wake_up(),
> 
> and the lock order is:
> 
>   &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.
> 
> For the schedule out path, the callchain is always (for all intents and
> purposes; if the kernel is preemptible, kvm_sched_out() can be called from
> something other than schedule(), but the beginning of the callchain will
> be the same point in vcpu_block()):
> 
>   vcpu_block()
>   |
>   --> schedule()
>       |
>       --> kvm_sched_out()
>           |
>           --> vmx_vcpu_put()
>               |
>               --> vmx_vcpu_pi_put()
>                   |
>                   --> pi_enable_wakeup_handler()
> 
> and the lock order is:
> 
>   &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu)
> 
> I.e. lockdep sees AB+BC ordering for schedule out, and CA ordering for
> wakeup, and complains about the A=>C versus C=>A inversion.  In practice,
> deadlock can't occur between schedule out and the wakeup handler as they
> are mutually exclusive.  The entirely of the schedule out code that runs
> with the problematic scheduler locks held, does so with IRQs disabled,
> i.e. can't run concurrently with the wakeup handler.
> 
> Use a subclass instead disabling lockdep entirely, and tell lockdep that
> both subclasses are being acquired when loading a vCPU, as the sched_out
> and sched_in paths are NOT mutually exclusive, e.g.
> 
>       CPU 0                 CPU 1
>   ---------------     ---------------
>   vCPU0 sched_out
>   vCPU1 sched_in
>   vCPU1 sched_out      vCPU 0 sched_in
> 
> where vCPU0's sched_in may race with vCPU1's sched_out, on CPU 0's wakeup
> list+lock.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 840d435229a8..51116fe69a50 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -31,6 +31,8 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
>   */
>  static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
>  
> +#define PI_LOCK_SCHED_OUT SINGLE_DEPTH_NESTING
> +
>  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>  {
>  	return &(to_vmx(vcpu)->pi_desc);
> @@ -89,9 +91,20 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  	 * current pCPU if the task was migrated.
>  	 */
>  	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> -		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +		raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
> +
> +		/*
> +		 * In addition to taking the wakeup lock for the regular/IRQ
> +		 * context, tell lockdep it is being taken for the "sched out"
> +		 * context as well.  vCPU loads happens in task context, and
> +		 * this is taking the lock of the *previous* CPU, i.e. can race
> +		 * with both the scheduler and the wakeup handler.
> +		 */
> +		raw_spin_lock(spinlock);
> +		spin_acquire(&spinlock->dep_map, PI_LOCK_SCHED_OUT, 0, _RET_IP_);
>  		list_del(&vmx->pi_wakeup_list);
> -		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +		spin_release(&spinlock->dep_map, _RET_IP_);
> +		raw_spin_unlock(spinlock);
>  	}
>  
>  	dest = cpu_physical_id(cpu);
> @@ -151,7 +164,20 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  
>  	lockdep_assert_irqs_disabled();
>  
> -	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +	/*
> +	 * Acquire the wakeup lock using the "sched out" context to workaround
> +	 * a lockdep false positive.  When this is called, schedule() holds
> +	 * various per-CPU scheduler locks.  When the wakeup handler runs, it
> +	 * holds this CPU's wakeup lock while calling try_to_wake_up(), which
> +	 * can eventually take the aforementioned scheduler locks, which causes
> +	 * lockdep to assume there is deadlock.
> +	 *
> +	 * Deadlock can't actually occur because IRQs are disabled for the
> +	 * entirety of the sched_out critical section, i.e. the wakeup handler
> +	 * can't run while the scheduler locks are held.
> +	 */
> +	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
> +			     PI_LOCK_SCHED_OUT);
>  	list_add_tail(&vmx->pi_wakeup_list,
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>  	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


