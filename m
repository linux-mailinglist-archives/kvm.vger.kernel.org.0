Return-Path: <kvm+bounces-16552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9448BB6E1
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 00:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF1281F25985
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 22:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D871D5B5D6;
	Fri,  3 May 2024 22:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="puxVyU7p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B308958ACC
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 22:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714774110; cv=none; b=LMIcItjJ5tlv/TRr0h7MUxAE9P6BgosTnXIMpQc4EssP6oBK/HIyTKq4g+DHg9S/+67RRCnWQkIk8kifUtiMOgTE1kp0becgxHhnr2MnWChPD1Vh7Pk/HW/TtXzML4LZIHtyo5FAAXqbKp/ULEoWW27GLLNUL8Hzo453BbH3EJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714774110; c=relaxed/simple;
	bh=A6jfGpt5EXKwXCAL1hqPBBb2Pa8wWg1lk91tDEEpOts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XBV+AxXUtiZPYZMH/eCUDVoCOSwoOmzEh/xJhbg6PcDme3kXnDlPLyJxAV8RyapqQgSq1MQGF47FyOXB4xFhMZs48Y3Uozgv8EBOKY5/G3kJ1mWIwUN+CLlbljjBfaLjlmlkVp6oQkwZnUtiLsQe7Xqv8tFHWyXXzmbm/soEfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=puxVyU7p; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cf35636346so116373a12.3
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 15:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714774108; x=1715378908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ckpfH3TSd67b3OSfhynVSXxzSMXIc0DSB6D80LvHG50=;
        b=puxVyU7pfTfwfPf8OVy3syZfjCunKkG5RKbo7t0ZXQPu2LnbSPVJMhA0q4uZ6OLAb7
         bhTXT5wT7EqqoY83J1TbgL2PHVdCvHmA0ByQ7d1Vkf0aiz6yjPZ5vIj6tiVz0YjTuaMh
         9+/dRK3CU2vBGW4UN/at36gI6P1P8u+FgAvO/mD0UVgxdbP9vYr9X9cbmxZN6Vk+4F8e
         20c5NIAjxVB4az5LtUsakGmQ+6KNZ1ffTIMOF9TVIdrFJxH8OgZvTRpFl10eSGg8Cqi8
         iBiR+UIwsjesAjND0pqrXi7zG/Y6tGeJqfZMi0lt3JgwDJJxoWWdvjo8gW+lo60PFgXj
         XbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714774108; x=1715378908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ckpfH3TSd67b3OSfhynVSXxzSMXIc0DSB6D80LvHG50=;
        b=tzbTzJxRMfncaBk57W373ar0Eu8daLLdc0jjMydu2kVDqJzCWaammKlYxCOWcjMxbL
         kD7qV1ASC0snibZPXyiHpNNifUMOvz2AOOTlV01n6n169/OlGoYZwxDi9OOl8M9r8CkI
         8aMqZz5hCy9lKqBjys6hBO/qpAEHoZcxlT9d8pu4PewrI81aZ2/oBg1UfmbKMrivocJZ
         UgZxt39C2pFq/hDYOjU+QO6fw22Oj7Lpf/2fgSVl+WsKTtLGWk9aHilu6/FswmfYnCEP
         33ebjHf+Lt4dzSgb8ZOXtEZVu+hpiq8bQSjGw25j4wLW2BKCAw4iuEQs7reD2NuDAC0w
         BuAA==
X-Forwarded-Encrypted: i=1; AJvYcCWmM/wd+eNWNXqUT4/Xg5+xvEUVkUuZmwbGEc/1Zvkuz9fUIJY412tFDThBfuW+GghdUyjaEv2K160b1KJOSpfL+Abc
X-Gm-Message-State: AOJu0Yzs3QazxMvjMs4hCny0UPRi8EU0LEYJexXRaQ8bjlDHRQcVExEY
	ZOeR6PdOSgzKXN7yYAJRHPtGvsJdJBmIiWYb0Lt+gJhDXQpp15uU0jzw2ThhlvEdBYH6OXMRzwU
	1rg==
X-Google-Smtp-Source: AGHT+IEFdrePC6jrLSxMCygJbktCPsMWiSl/LWI6oM30L+7vw4xa5OxhWDTaaP8A8BzveH9E5qNZgrCJqhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:56:0:b0:61b:2c4c:30e6 with SMTP id
 83-20020a630056000000b0061b2c4c30e6mr10162pga.1.1714774107972; Fri, 03 May
 2024 15:08:27 -0700 (PDT)
Date: Fri, 3 May 2024 15:08:26 -0700
In-Reply-To: <20240426041559.3717884-2-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240426041559.3717884-1-foxywang@tencent.com> <20240426041559.3717884-2-foxywang@tencent.com>
Message-ID: <ZjVgWvrXyyVYXoxj@google.com>
Subject: Re: [v4 RESEND 1/3] KVM: setup empty irq routing when create vm
From: Sean Christopherson <seanjc@google.com>
To: Yi Wang <up2wing@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	foxywang@tencent.com, oliver.upton@linux.dev, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
> 
> Add a new function to setup empty irq routing in kvm path, which
> can be invoded in non-architecture-specific functions. The difference
> compared to the kvm_setup_empty_irq_routing() is this function just
> alloc the empty irq routing and does not need synchronize srcu, as
> we will call it in kvm_create_vm().
> 
> Using the new adding function, we can setup empty irq routing when
> kvm_create_vm(), so that x86 and s390 no longer need to set
> empty/dummy irq routing when creating an IRQCHIP 'cause it avoid
> an synchronize_srcu.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>
> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/irqchip.c       | 19 +++++++++++++++++++
>  virt/kvm/kvm_main.c      |  4 ++++
>  3 files changed, 24 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..9256539139ef 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2100,6 +2100,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  			const struct kvm_irq_routing_entry *entries,
>  			unsigned nr,
>  			unsigned flags);
> +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm);

This is in an #ifdef, the #else needs a stub (for MIPS).

>  int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue);
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..266bab99a8a8 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -237,3 +237,22 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  
>  	return r;
>  }
> +
> +int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm)

I vote for kvm_init_irq_routing() to make it more obvious that the API is purely
for initializing the routing, i.e. only to be used at VM creation.  Then the
"lockless" tag is largely redundant.  And then maybe add a comment about how this
creates an empty routing table?  Because every time I look at this code, it takes
me a few seconds to remember how this is actually an empty table.

> +{
> +	struct kvm_irq_routing_table *new;
> +	int chip_size;
> +
> +	new = kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
> +	if (!new)
> +		return -ENOMEM;
> +
> +	new->nr_rt_entries = 1;
> +
> +	chip_size = sizeof(int) * KVM_NR_IRQCHIPS * KVM_IRQCHIP_NUM_PINS;
> +	memset(new->chip, -1, chip_size);
> +
> +	RCU_INIT_POINTER(kvm->irq_routing, new);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ff0a20565f90..b5f4fa9d050d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1285,6 +1285,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  	if (r)
>  		goto out_err;
>  
> +	r = kvm_setup_empty_irq_routing_lockless(kvm);
> +	if (r)
> +		goto out_err;

This is too late.  It might not matter in practice, but the call before this is
to kvm_arch_post_init_vm(), which quite strongly suggests that *all* common setup
is done before that arch hook is invoked.

Calling this right before kvm_arch_init_vm() seems like the best/easiest fit, e.g.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e388972d856..ab607441686f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1197,9 +1197,13 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
                rcu_assign_pointer(kvm->buses[i],
                        kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
                if (!kvm->buses[i])
-                       goto out_err_no_arch_destroy_vm;
+                       goto out_err_no_irq_routing;
        }
 
+       r = kvm_init_irq_routing(kvm);
+       if (r)
+               goto out_err_no_irq_routing;
+
        r = kvm_arch_init_vm(kvm, type);
        if (r)
                goto out_err_no_arch_destroy_vm;
@@ -1254,6 +1258,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
        WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
        for (i = 0; i < KVM_NR_BUSES; i++)
                kfree(kvm_get_bus(kvm, i));
+       kvm_free_irq_routing(kvm);
+out_err_no_irq_routing:
        cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
        cleanup_srcu_struct(&kvm->srcu);


