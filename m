Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECACF6B4DE3
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 18:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCJRCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 12:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjCJRB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 12:01:58 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B616D8A5A
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 09:00:02 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a25-20020a056a001d1900b005e82b3dc9f4so3148192pfx.1
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 09:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678467602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=96VhZad7fau15RxlhATOVUVG6AhXrzUQgEwbilYaxXk=;
        b=PhqamPCq0kh+yF3ufPBTjFXe3496VSnG0W5rK2v0utOj9XkQbZD1dO5O+po+IeDBBL
         PtlP4GZ1vwmQoDNXtsNXpwDkhw+2ZwJy/HIM6+EUPXQJ1zVbVP3LXkDsolaqMqs9lRgL
         KLOnVcM2XZ1oQpobzY2gI35dLm7cfMD6nd5oVDOXhwKEx7p0PsMMOdiEvyDfjIjFtHuA
         RPARCpCPP2qbwsTYq9uAnHcJjb9cv3oz/sn6ORVdrXaZVprrrp5lWAalEUV3lH2Ry2X/
         xkXG/eXpnrbDEQbjVq6YRkr9uwKwFPPYvIX0WIs797BlnFl4N0kRkyHLT8BTvZSqto69
         anow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678467602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=96VhZad7fau15RxlhATOVUVG6AhXrzUQgEwbilYaxXk=;
        b=kv9UrqUEJnRyk2HbKZxVsafc8D1FIJKkmwfcTM1oUOTZZ2dy/D2K8o/Kv2oo/Bbmn4
         I7+tvuxpprJpjdztKZuyVCXv2tp9eqWkwSUGGA/awuYKPXBDH24GhAQJP4GPdwvxDkxJ
         BTcGWCJprHuIGdbyhdH+iuOryR3NzcmnboEuXMP/L1pkIrwzLyKbvG9lEq/dMV1AoSFh
         Xb4jjsbjn9H65YzJhqGvjmdq26C396Zt/kCKN99K4HOe+tpKK6hC6bdWXYMiNtc2XeV3
         a+lrIOMc+hQy9f84RTwdJYRnNceJKKGkzMQnyKNLIcti4dBhAYO6nrrma0pFIaC9HDdi
         v35w==
X-Gm-Message-State: AO0yUKXT188CLAMSo1dCgwac7Stcyg7I1oBPfK/YtFY6xd3Row3+e8BS
        IMuZ8tuE1VDczCqawlAPsSjlAsIXmvo=
X-Google-Smtp-Source: AK7set9h7gaS3jxJCUMG+EcVAtd9dHw0FAmSFp99EKPwLsuL99BYlkQvtJ6TlNqsXjHaT4N6zQQEB0RgkKc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:420f:b0:234:13d8:ed5b with SMTP id
 o15-20020a17090a420f00b0023413d8ed5bmr9611955pjg.3.1678467602246; Fri, 10 Mar
 2023 09:00:02 -0800 (PST)
Date:   Fri, 10 Mar 2023 09:00:00 -0800
In-Reply-To: <20230310155955.29652-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230310155955.29652-1-yan.y.zhao@intel.com>
Message-ID: <ZAtiEO/DST05GRRN@google.com>
Subject: Re: [PATCH] KVM: VMX: fix lockdep warning on posted intr wakeup
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023, Yan Zhao wrote:
> Use rcu list to break the possible circular locking dependency reported
> by lockdep.
> 
> path 1, ``sysvec_kvm_posted_intr_wakeup_ipi()`` --> ``pi_wakeup_handler()``
>          -->  ``kvm_vcpu_wake_up()`` --> ``try_to_wake_up()``,
>          the lock sequence is
>          &per_cpu(wakeup_vcpus_on_cpu_lock, cpu) --> &p->pi_lock.

Heh, that's an unfortunate naming collision.  It took me a bit of staring to
realize pi_lock is a scheduler lock, not a posted interrupt lock.

> path 2, ``schedule()`` --> ``kvm_sched_out()`` --> ``vmx_vcpu_put()`` -->
>         ``vmx_vcpu_pi_put()`` --> ``pi_enable_wakeup_handler()``,
>          the lock sequence is
>          &rq->__lock --> &per_cpu(wakeup_vcpus_on_cpu_lock, cpu).
> 
> path 3, ``task_rq_lock()``,
>         the lock sequence is &p->pi_lock --> &rq->__lock
> 
> lockdep report:
>  Chain exists of:
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

I don't think there's a deadlock here.  pi_wakeup_handler() is called from IRQ
context, pi_enable_wakeup_handler() disable IRQs before acquiring
wakeup_vcpus_on_cpu_lock, and "cpu" in pi_enable_wakeup_handler() is guaranteed
to be the current CPU, i.e. the same CPU.  So CPU0 and CPU1 can't be contending
for the same wakeup_vcpus_on_cpu_lock in this scenario.

vmx_vcpu_pi_load() does do cross-CPU locking, but finish_task_switch() drops
rq->__lock before invoking the sched_in notifiers.

> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 94c38bea60e7..e3ffc45c0a7b 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -90,7 +90,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  	 */
>  	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
>  		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> -		list_del(&vmx->pi_wakeup_list);
> +		list_del_rcu(&vmx->pi_wakeup_list);
>  		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));

_If_ there is indeed a possible deadlock, there technically needs to be an explicit 
synchonize_rcu() before freeing the vCPU.  In practice, there are probably multiple
synchonize_rcu() calls in the destruction path, not to mention that it would take a
minor miracle for pi_wakeup_handler() to get stalled long enough to achieve a
use-after-free.

>  	}
>  
> @@ -153,7 +153,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> -	list_add_tail(&vmx->pi_wakeup_list,
> +	list_add_tail_rcu(&vmx->pi_wakeup_list,
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>  	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));


> @@ -219,16 +219,14 @@ void pi_wakeup_handler(void)
>  {
>  	int cpu = smp_processor_id();
>  	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
> -	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
>  	struct vcpu_vmx *vmx;
>  
> -	raw_spin_lock(spinlock);
> -	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
> -
> +	rcu_read_lock();

This isn't strictly necessary, IRQs are disabled.

> +	list_for_each_entry_rcu(vmx, wakeup_list, pi_wakeup_list) {
>  		if (pi_test_on(&vmx->pi_desc))
>  			kvm_vcpu_wake_up(&vmx->vcpu);
>  	}
> -	raw_spin_unlock(spinlock);
> +	rcu_read_unlock();
>  }
>  
>  void __init pi_init_cpu(int cpu)
> 
> base-commit: 89400df96a7570b651404bbc3b7afe627c52a192
> -- 
> 2.17.1
> 
