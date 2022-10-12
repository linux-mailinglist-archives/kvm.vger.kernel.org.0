Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F755FCBDA
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJLUOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJLUOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:14:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A909A9D2
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:14:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h12so64109pjk.0
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1hD4NL0ToajUdsWgIZo98G8hLdI2fHI/D6AjCnZpco=;
        b=NRtSQTBr095dw5s1nMVrCYtxceAL8LJ0hQcqSN57PbeOTbbfX447gF9gL/7oRy+KUJ
         eidxe/PQwrKHzxSQFc08Pqxv6JFnP+9rFOpsaIIyb5+ARxwEB/lHX6l7vONs0eRJmgQe
         qtpMKYpeqFCPP0cwZSiDR/fbbl7u7Q81YcX92W3vc+/2ogl7bZkUfodnF0Dk3AD/kNZN
         NJrrR+afn4inpfUgoUd+kE0pZaZKYunRvmOV097bIjyQagtx0yPx0eDeSBseNK0kBtzZ
         bYG/+SOSs+mEG7AtemF+U96LL4BHvUuyZ7/itgbT7WSGqIpFO79tDGga4pHSFuv6Ue6d
         0IRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1hD4NL0ToajUdsWgIZo98G8hLdI2fHI/D6AjCnZpco=;
        b=MYsEN3E6shoHMgUse9Vjt+LoqwCBjpEQB3P2lzVFHHUzSPW5IoJjmsNzt4epogLj4Z
         nBDWWBZR69OyrM+eY2MDKPtt9Ao0gR9OFuRWW7Jp3K5q3iH9uJiLGDygtw2tAai2bubx
         VgdNdi8GGLT/Do/RFtWedBKNAXNl7LlTqXTl8/ohkgPRaXfieZB0+HcDzPT/EtzN40Cg
         fRYEk8hAyQ8jf2msZf4OCMuc3mmZz2v2Ho48B3hz4eacOQzqJCtqk4ytCZv2JmouY2/C
         k934HaFK4imZqQV3XdZ50Z9rZW5Kngd6YdSvDsUbZYgypac8ckWsvTTag/GT+LYRGyMc
         8LLQ==
X-Gm-Message-State: ACrzQf3qTCygu75xvTGXBOq+8EG486BC2KPx/hw5dPFfrtQG9zZ82YHm
        ldg374iWUViBnmK/k+CilOBgpA==
X-Google-Smtp-Source: AMsMyM4ofl8UdaUxhC/ayK5crlUC8AT/4yN0z6b8jZyYabGNeRSx5+2FWAU/CDj91unDAt4B0Bxjiw==
X-Received: by 2002:a17:90b:4d0c:b0:20b:c983:2d85 with SMTP id mw12-20020a17090b4d0c00b0020bc9832d85mr7110557pjb.45.1665605660707;
        Wed, 12 Oct 2022 13:14:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p18-20020a1709028a9200b0017d97d13b18sm11013567plo.65.2022.10.12.13.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 13:14:20 -0700 (PDT)
Date:   Wed, 12 Oct 2022 20:14:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 09/30] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <Y0cgGEr8nKpOBLrQ@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <92836b09c8e0f19f8e506008e45993881d22b6d1.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92836b09c8e0f19f8e506008e45993881d22b6d1.1663869838.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Because kvm_count_lock unnecessarily complicates the KVM locking convention
> Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
> simplicity.  kvm_arch_hardware_enable/disable() callbacks depend on
> non-preemptiblity with the spin lock.  Add preempt_disable/enable()
> around hardware enable/disable callback to keep the assumption.

There's the other "minor" wrinkle that prior to patch 7, "KVM: Rename and move
CPUHP_AP_KVM_STARTING to ONLINE section, kvm_online_cpu() was called with IRQs
disabled and couldn't sleep, i.e. couldn't acquire a mutex.  That's very important
to capture in the changelog.

> Because kvm_suspend() and kvm_resume() is called with interrupt disabled,
> they don't need preempt_disable/enable() pair.
> 
> Opportunistically add some comments on locking.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

...

> @@ -5028,13 +5029,20 @@ static int kvm_online_cpu(unsigned int cpu)
>  	if (kvm_usage_count) {
>  		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
>  
> +		/*
> +		 * arch callback kvm_arch_hardware_eanble() assumes that

s/eanble/enable

Though even better would be to avoid function names entirely.

> +		 * preemption is disabled for historical reason.  Disable
> +		 * preemption until all arch callbacks are fixed.
> +		 */

Probably better to put this comment above to the WARN_ON_ONCE() in hardware_enable_nolock()
since that's where the oddity and dependency on arch behavior lies.  And then it
can be turned into a FIXME, e.g.

	/*
	 * FIXME: drop the "preemption disabled" requirement here and in the
	 * disable path once all arch code plays nice with preemption.
	 */

> +		preempt_disable();
>  		hardware_enable_nolock(NULL);
> +		preempt_enable();
>  		if (atomic_read(&hardware_enable_failed)) {
>  			atomic_set(&hardware_enable_failed, 0);
>  			ret = -EIO;
>  		}
>  	}
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
>  	return ret;
>  }
>  
> @@ -5042,6 +5050,8 @@ static void hardware_disable_nolock(void *junk)
>  {
>  	int cpu = raw_smp_processor_id();
>  
> +	WARN_ON_ONCE(preemptible());
> +
>  	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
>  		return;
>  	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
> @@ -5050,10 +5060,18 @@ static void hardware_disable_nolock(void *junk)
>  
>  static int kvm_offline_cpu(unsigned int cpu)
>  {
> -	raw_spin_lock(&kvm_count_lock);
> -	if (kvm_usage_count)
> +	mutex_lock(&kvm_lock);
> +	if (kvm_usage_count) {
> +		/*
> +		 * arch callback kvm_arch_hardware_disable() assumes that
> +		 * preemption is disabled for historical reason.  Disable
> +		 * preemption until all arch callbacks are fixed.
> +		 */

I vote to drop this comment and instead document everything in the enable FIXME
(see above).

> +		preempt_disable();
>  		hardware_disable_nolock(NULL);
> -	raw_spin_unlock(&kvm_count_lock);
> +		preempt_enable();
> +	}
> +	mutex_unlock(&kvm_lock);
>  	return 0;
>  }

...

> @@ -5708,15 +5728,27 @@ static void kvm_init_debug(void)
>  
>  static int kvm_suspend(void)
>  {
> -	if (kvm_usage_count)
> +	/*
> +	 * The caller ensures that CPU hotplug is disabled by
> +	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
> +	 * locking.

Disabling CPU hotplug prevents racing with kvm_online_cpu()/kvm_offline_cpu(), but
doesn't prevent racing with hardware_enable_all()/hardware_disable_all(). 

And the lockdep doesn't mesh with the comment, which explains why kvm_lock doesn't
 _need_ to be held, but not why kvm_lock _can't_ be held.

Maybe this?

	/*
	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
	 * is stable.  Assert that kvm_lock is not held as a paranoid sanity
	 * check that the system isn't suspended when KVM is enabling hardware.
	 */

> +	 */
> +	lockdep_assert_not_held(&kvm_lock);
> +
> +	if (kvm_usage_count) {
> +		/*
> +		 * Because kvm_suspend() is called with interrupt disabled,  no
> +		 * need to disable preemption.
> +		 */

Add a lockdep and drop the comment, e.g. below the lockdep_assert_not_held(), add

	lockdep_assert_irqs_disabled();

That covers the "why doesn't this disable preemption" _and_ enforces that IRQs are
indeed disabled.

>  		hardware_disable_nolock(NULL);
> +	}
>  	return 0;
>  }
>  
>  static void kvm_resume(void)
>  {
>  	if (kvm_usage_count) {
> -		lockdep_assert_not_held(&kvm_count_lock);
> +		lockdep_assert_not_held(&kvm_lock);
>  		hardware_enable_nolock(NULL);
>  	}
>  }
> -- 
> 2.25.1
> 
