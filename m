Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAD942FEAB
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 01:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhJOX2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 19:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243501AbhJOX2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 19:28:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B738C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 16:26:26 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s136so6667393pgs.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 16:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJ2YVnKXuCapD+GC+e6jPtJ+8reV521rhOMXMMjLFFQ=;
        b=FEKBFlN5wG9yAV2kBppjcw/xoIl103tlpwWPoOYcaTivN6B+Q7J4gJ4HIwRveDvqZj
         cUUk4ke64+QNWZUYnzC1ERhlCUwZcaO3PnfOHgNqTTK8e2tOii+RRN/zfPoIQAxUNf4m
         QMGuUSKp7X8D7JzkiI3kyqTDZvpJvQla44ATmJzLuhPjQgasY9W3ALSdSO6UeUmDX6lo
         VwZEln3HpV2MoWwzKX+7oQh5b9aFgDJrJMnFW63YVxVomjzmf2ZYcxayTLyhK/wVzTYJ
         slyL+KWyioSrGuspuUxNMjjqCnUC7+D+4N6d43OEm61HhmOxmHyL79eSEYIo5IZpFxAw
         2hEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJ2YVnKXuCapD+GC+e6jPtJ+8reV521rhOMXMMjLFFQ=;
        b=6meIg/5NIOOKchGGysHIWbIh7eID4HhdeOZE2W5pQdEaglM94UP/lKSTwiG1SY6/T7
         0uGy45zPyDO0UQflTuW7/6URem2IaY9LXjS5CSRPUGR3kpRgIexohL8ZllfRrZfGqHsu
         8YyWwfDSDszCWrqxIe/U06gIFk1UyOC7hlY/LwGSVKQGkUBQiWlIWs9vGMiQDLSv4Yu6
         ulLKUGv5aVyVEGCE0JNXD7cwE0C3mNScyMHnJow+WuKzhHkqT8cd/LveueEBS2ndsHi5
         0bdjEFZFKbALqj/REXYhlZmH2QA9k/rT+KaRWFfc/R3DOYgMVKca6imgmXgPOeI3KMwm
         1+XQ==
X-Gm-Message-State: AOAM531sg7ry5Ecj45hssBdY7+qVtLVIz1b10UvZM0HD9v1Lbj7rtJtg
        1BGbdEnFk1ArVYOLjq+cAsWNJA==
X-Google-Smtp-Source: ABdhPJz3dM1jOK77yQ3YA/EhyHfHvYvgcPqzyaQNIMfPWv2Mc+oTlnhWR75YPgic17CIAtdS9N5TEQ==
X-Received: by 2002:aa7:949c:0:b0:44c:a0df:2c7f with SMTP id z28-20020aa7949c000000b0044ca0df2c7fmr14727451pfk.34.1634340384249;
        Fri, 15 Oct 2021 16:26:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t22sm1451643pfg.148.2021.10.15.16.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:26:23 -0700 (PDT)
Date:   Fri, 15 Oct 2021 23:26:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 3/3] KVM: vCPU kick tax cut for running vCPU
Message-ID: <YWoOG40Ap0Islpu2@google.com>
References: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
 <1633770532-23664-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1633770532-23664-3-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 09, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Sometimes a vCPU kick is following a pending request, even if @vcpu is 
> the running vCPU. It suffers from both rcuwait_wake_up() which has 
> rcu/memory barrier operations and cmpxchg(). Let's check vcpu->wait 
> before rcu_wait_wake_up() and whether @vcpu is the running vCPU before 
> cmpxchg() to tax cut this overhead.
> 
> We evaluate the kvm-unit-test/vmexit.flat on an Intel ICX box, most of the 
> scores can improve ~600 cpu cycles especially when APICv is disabled.
> 
> tscdeadline_immed
> tscdeadline
> self_ipi_sti_nop
> ..............
> x2apic_self_ipi_tpr_sti_hlt
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * move checking running vCPU logic to kvm_vcpu_kick
>  * check rcuwait_active(&vcpu->wait) etc
> 
>  virt/kvm/kvm_main.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7851f3a1b5f7..18209d7b3711 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3314,8 +3314,15 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  {
>  	int me, cpu;
>  
> -	if (kvm_vcpu_wake_up(vcpu))
> -		return;
> +	me = get_cpu();
> +
> +	if (rcuwait_active(&vcpu->wait) && kvm_vcpu_wake_up(vcpu))

This needs to use kvm_arch_vcpu_get_wait(), not vcpu->wait, because PPC has some
funky wait stuff.

One potential issue I didn't think of before.  rcuwait_active() comes with the
below warning, which means we might be at risk of a false negative that could
result in a missed wakeup.  I'm not postive on that though.

/*
 * Note: this provides no serialization and, just as with waitqueues,
 * requires care to estimate as to whether or not the wait is active.
 */

> +		goto out;
> +
> +	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
> +		WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE);
> +		goto out;
> +	}
>  
>  	/*
>  	 * Note, the vCPU could get migrated to a different pCPU at any point
> @@ -3324,12 +3331,12 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
>  	 * vCPU also requires it to leave IN_GUEST_MODE.
>  	 */
> -	me = get_cpu();
>  	if (kvm_arch_vcpu_should_kick(vcpu)) {
>  		cpu = READ_ONCE(vcpu->cpu);
>  		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
>  			smp_send_reschedule(cpu);
>  	}
> +out:
>  	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> -- 
> 2.25.1
> 
