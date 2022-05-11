Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB6523DF0
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 21:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbiEKTtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 15:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiEKTts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 15:49:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4F822EA76
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 12:49:47 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m12so2889954plb.4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 12:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZVkPI9a8IRQYesSQ+ttpdf1MEApR5I7+chVPKoDZ99s=;
        b=nIoo+zRXBCE354qcDqmyRcSP+nF6p22udtllsKXP1zogFPEU1EFfZYPHRPoRJU8JpB
         428+dzj8kCeID2z7WOpvVvWSwuCMArB90RlJrpEjs+6Y0Fufw2inabVbfc7Z2Qo7fcSf
         kKsCes/1R5w0SVAaqc3m2vHep14mlGpJCTmLWhO3lC88XqKB+eJf/8Sb6gJK5NAKzdtJ
         JZQvJKfug/GASArf0hooe1gdKbk6l54Z1h+cNiHfEtgDxI1LgiPZpfdpObtBtYsvQeVg
         vkyjHLh0VsfHIsroYjhEQKHnhMsnMbJGs0kXJkmHYwBvSWEgk9hg10HkjFxsFjqDUGGS
         OySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZVkPI9a8IRQYesSQ+ttpdf1MEApR5I7+chVPKoDZ99s=;
        b=Df2A/GpNXESwwQSI7u8GJ4XZEiv2hj0lXGXlDvUKcu58E5LVlQQLzVu58h8Y7Wzeep
         xFT2qhhoeq5CusxRSNQae59bCAjeMjCe9LZuTKU7dtOaBN1q9Hrrl81pdGbLnLjWHWc7
         ZT9ZUPKTTO842uWnIsFhhrN6i0EQraEn5+Hq7rvEnRqhgrMXXVnbbqP+//iUL2YJylK9
         63HiFeZHeXProtP8AQShw3oO3t4lm0GZLFPiOUMYKHEU8In8Qxp9+8+xTfaA51LUNyct
         Ai10e3RUI6S0EJVZCe4oKHy/s3XLb/BFIBJB+fNlaQ/ak0lCO+ycmiLHitE7IHs4YHJE
         HC4A==
X-Gm-Message-State: AOAM532Y14AkZq5qBDsx/ZzTNeq/aW7OM++Asvw4JqU27+Velagezqhn
        EAIRHiGAF0nh0m0PctuUijpCIQ==
X-Google-Smtp-Source: ABdhPJzobbBzVLRt1UTC1cCqa+FyF9eR5QJcvw+JjqEoc83pnXQmqeNo2pRGVmXo5R894GftjgDQaQ==
X-Received: by 2002:a17:90b:1b0d:b0:1dc:672e:c8c2 with SMTP id nu13-20020a17090b1b0d00b001dc672ec8c2mr7151228pjb.96.1652298587255;
        Wed, 11 May 2022 12:49:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n16-20020a170902969000b0015e8d4eb1e3sm2276475plp.45.2022.05.11.12.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 12:49:46 -0700 (PDT)
Date:   Wed, 11 May 2022 19:49:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        mlevitsk@redhat.com
Subject: Re: [PATCH v4] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <YnwTV2TEzmEQqVvZ@google.com>
References: <20220511014226.3099627-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511014226.3099627-1-romanton@google.com>
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
> @@ -8646,9 +8663,10 @@ static void tsc_khz_changed(void *data)
>  	struct cpufreq_freqs *freq = data;
>  	unsigned long khz = 0;
>  
> +	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));

Nit, please add a newline to isolate the WARN.

>  	if (data)
>  		khz = freq->new;
> -	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +	else
>  		khz = cpufreq_quick_get(raw_smp_processor_id());
>  	if (!khz)
>  		khz = tsc_khz;
> @@ -8669,8 +8687,10 @@ static void kvm_hyperv_tsc_notifier(void)
>  	hyperv_stop_tsc_emulation();
>  
>  	/* TSC frequency always matches when on Hyper-V */
> -	for_each_present_cpu(cpu)
> -		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> +	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +		for_each_present_cpu(cpu)
> +			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> +	}
>  	kvm_max_guest_tsc_khz = tsc_khz;
>  
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> @@ -8783,7 +8803,8 @@ static struct notifier_block kvmclock_cpufreq_notifier_block = {
>  
>  static int kvmclock_cpu_online(unsigned int cpu)
>  {
> -	tsc_khz_changed(NULL);
> +	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		tsc_khz_changed(NULL);


Ah rats, I missed something in v3.  Rather than handle this in the notifier, KVM
can simply not register the notifier in the first place.  The CPUHP_AP_X86_KVM_CLK_ONLINE
hook exists purely to muck with cpu_tsc_khz.  And that makes the WARN_ON_ONCE in
tsc_khz_changed() much less rendunat (having a caller and its callee check the
same thing in quick succession felt silly).

I.e. instead of modifying kvmclock_cpu_online(), do:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6567aec84223..e9efb8d00673 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8882,10 +8882,10 @@ static void kvm_timer_init(void)
                }
                cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
                                          CPUFREQ_TRANSITION_NOTIFIER);
-       }
 
-       cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
-                         kvmclock_cpu_online, kvmclock_cpu_down_prep);
+               cpuhp_setup_state(CPUHP_AP_X86_KVM_CLK_ONLINE, "x86/kvm/clk:online",
+                                 kvmclock_cpu_online, kvmclock_cpu_down_prep);
+       }
 }
 
 #ifdef CONFIG_X86_64
@@ -9038,10 +9038,11 @@ void kvm_arch_exit(void)
 #endif
        kvm_lapic_exit();
 
-       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
                cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
                                            CPUFREQ_TRANSITION_NOTIFIER);
-       cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
+               cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
+       }
 #ifdef CONFIG_X86_64
        pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
        irq_work_sync(&pvclock_irq_work);



>  	return 0;
>  }
>  
> -- 
> 2.36.0.550.gb090851708-goog
> 
