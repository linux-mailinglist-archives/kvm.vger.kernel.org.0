Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EDA525732
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 23:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358835AbiELVn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 17:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358837AbiELVnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 17:43:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA5811E492
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 14:43:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p12so6030468pfn.0
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 14:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=asbkWMVCfT0D0kFhxSG2+/ViKaMriEwmvm0G0tdM4pY=;
        b=gSmdJBqI9kcpVbCWE65Bp/1XsG3IJgOEsLyWHHB9Ehp0+BI36Oe7MN+3Jm5yXeRlG8
         P1f1qxHDUxbZuBV38NwJfntvxmJ/TlM3PUa//2NcEDgHU2eMx4jErn/xptrUZ1jO8dTV
         TEXQdah7vsR8BdIzzlAGLnGjFBwYnXi/JO/yFqa/AoGuu95C7ni+IgRpnLQ0jGmdV00O
         KuLOIk91Vci/K/CnRvrb0Q1H5fzHq6ezR3m7360JR/VG6I3d5viNAu3MXLQrrlbuywGJ
         JjHl6J5d/JaYSCzqHkX9wfiluM/Wb6lPN2yfyHZ43N2zkcs/UpvtDzi8ZfK3GJCS2Oz/
         WsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=asbkWMVCfT0D0kFhxSG2+/ViKaMriEwmvm0G0tdM4pY=;
        b=sif9UsskqN6wH0BpxZ/mD1uZMu6tUV9Mt+sc/NUJCJOwyecXk8XDOfVCaL6QTJ0O8G
         rr1RYEDUlxq+FFWtPwlshAUbR93APTaPJwsrl9zGfmIZ2IHEyj+s14lL6Fj53K6yoYYK
         oV3EMbGFdp6VVxfbRvY3630Eq/MS91k7UJi34LrAY2CUUPsf3roNRhWlUtpZ4GhhJslz
         9EY5mZa+8vgut2syCJfXz1fSfDFxhCCfYNSaAHq1y3nZ2AdN0p7Mbps4I1ZYK5749jta
         MxGM3X9cNGWGUDUyqGe8lYuPMR6sPTg1ZuG2TvlTKNk4HR2N1LGEQ6OyhIqwzBwolrtO
         lhKg==
X-Gm-Message-State: AOAM531udeYWQr36w7QejhkdNfLOVMVjS9BsEm2+SAKmewSRhWn7sQ/y
        fDXLJGFEa83543W4/aWjC+pX3Q==
X-Google-Smtp-Source: ABdhPJy/ngeunXn7n5bxjYCttMJJ6A23lvp1fw/hQeIa66jM9r7qFeqln4BciytVleZSlshVSsT+wQ==
X-Received: by 2002:a63:2215:0:b0:3c1:fd25:b6a1 with SMTP id i21-20020a632215000000b003c1fd25b6a1mr1277487pgi.406.1652391799656;
        Thu, 12 May 2022 14:43:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t67-20020a632d46000000b003c2f9540127sm157891pgt.93.2022.05.12.14.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 14:43:19 -0700 (PDT)
Date:   Thu, 12 May 2022 21:43:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        mlevitsk@redhat.com
Subject: Re: [PATCH v5] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <Yn1/cyxxl3/vy0wn@google.com>
References: <20220511202932.3266607-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511202932.3266607-1-romanton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 11, 2022, Anton Romanov wrote:
> Don't snapshot tsc_khz into per-cpu cpu_tsc_khz if the host TSC is
> constant, in which case the actual TSC frequency will never change and thus
> capturing TSC during initialization is unnecessary, KVM can simply use
> tsc_khz.  This value is snapshotted from
> kvm_timer_init->kvmclock_cpu_online->tsc_khz_changed(NULL)
> 
> On CPUs with constant TSC, but not a hardware-specified TSC frequency,
> snapshotting cpu_tsc_khz and using that to set a VM's target TSC frequency
> can lead to VM to think its TSC frequency is not what it actually is if
> refining the TSC completes after KVM snapshots tsc_khz.  The actual
> frequency never changes, only the kernel's calculation of what that
> frequency is changes.
> 
> Ideally, KVM would not be able to race with TSC refinement, or would have
> a hook into tsc_refine_calibration_work() to get an alert when refinement
> is complete.  Avoiding the race altogether isn't practical as refinement
> takes a relative eternity; it's deliberately put on a work queue outside of
> the normal boot sequence to avoid unnecessarily delaying boot.
> 
> Adding a hook is doable, but somewhat gross due to KVM's ability to be
> built as a module.  And if the TSC is constant, which is likely the case
> for every VMX/SVM-capable CPU produced in the last decade, the race can be
> hit if and only if userspace is able to create a VM before TSC refinement
> completes; refinement is slow, but not that slow.
> 
> For now, punt on a proper fix, as not taking a snapshot can help some uses
> cases and not taking a snapshot is arguably correct irrespective of the
> race with refinement.
> 
> Signed-off-by: Anton Romanov <romanton@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> @@ -8807,10 +8828,10 @@ static void kvm_timer_init(void)

>  #endif
>  		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>  					  CPUFREQ_TRANSITION_NOTIFIER);
> -	}
>  
> -	cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
> -			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
> +		cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
> +				  kvmclock_cpu_online, kvmclock_cpu_down_prep);
> +	}
>  }

One final thought, it might be easier for readers if kvm_timer_init() became:

  static void kvm_timer_init(void)
  {
	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
		return;

	max_tsc_khz = tsc_khz;

	if (IS_ENABLED(CONFIG_CPU_FREQ)) {
		struct cpufreq_policy *policy;
		int cpu;

		cpu = get_cpu();
		policy = cpufreq_cpu_get(cpu);
		if (policy) {
			if (policy->cpuinfo.max_freq)
				max_tsc_khz = policy->cpuinfo.max_freq;
			cpufreq_cpu_put(policy);
		}
		put_cpu();
	}
	cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
				  CPUFREQ_TRANSITION_NOTIFIER);

	cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
  }

I think I have a slight preference for the above?  Either way is totally fine.
Maybe wait for Paolo to weigh in, or even let Paolo do it as fixup?
