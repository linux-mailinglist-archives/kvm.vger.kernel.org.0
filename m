Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517F2522885
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 02:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbiEKAhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 20:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 20:37:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBAE5996E
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 17:37:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c14so601173pfn.2
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 17:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U6ep+fH6runQ48BrE/lZEkguN2nVjXzSUale+8a5RSI=;
        b=iIX3wbKehZ2C+u6OqYJc7bNjwG461YgQq9r5BbqARnXOVJJ7UrtXFUA/rBOrs1i348
         5UcDwhyI323K0AFrH+KgyDQt1/mfxb2Ih5WKJm0QWjP+PkgO+u4uki59HyNXKEd1qIFB
         jQXi/ujPFp7vi2erzrS7QsR9+mvPuB9xspaqdHYXGNHAzbB/Ib3hlwRcfqYHeX6OmI/d
         0wvosxDDGTs45HUsEY3ENeFcxX1ZIbIH9LSA0uVrWwjRU0YWSfStO0GsSQIWkGDuOhWt
         vifGtqO5YSKym4rkHwyMJITX8JMWP+E7jpv8wQ1vvjXZUEHaN3yXY4MmnSmiWFi+Khqb
         ho4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U6ep+fH6runQ48BrE/lZEkguN2nVjXzSUale+8a5RSI=;
        b=dTfUCXNefd1FpFUmPB571wnJiPgSLU9idFj6xTNRN8lCVXfuw0hkZhiozmm58S9dTT
         ywTH9zvVkTyKo+FsHVMWDiAlWX7rdlVACFs2KkjrSs0+5QCfOj8TegjIEw1ELRK3N4XF
         bxef/OSlTJqyL48BVsDPQSEforQ+bimK6XJsVgoiFvVSUWiMReh0s1qVOtspudfVSWoI
         FlnUlanO1sp6MA0a9O4Jld+iXSz9NsMn/Hq12MQz0Cy00gvvFOS7pHJuRxTMuWpHSt85
         diV8M7LsRFhjc9igXbG4ERjenOEMMe22o/oJmY0KhwfP5kfarSCfKmRXSr3rZlL7EdOx
         O5Bg==
X-Gm-Message-State: AOAM533lzv1dQ+O7PSoXFTN8pIEzXtOz7WTOh/pBDLDqut6wnSnF4Wvf
        3YpIJRuF9hoiIQGYzquymeXMURARjm3ZcA==
X-Google-Smtp-Source: ABdhPJw5g31Qg2UjD2THYQMVE3HWIupUzi540ll45U+pDHQxLHxp/tUrt7peZh4Hw4ZWJlj00ZOj7Q==
X-Received: by 2002:a05:6a00:a8b:b0:4e1:52db:9e5c with SMTP id b11-20020a056a000a8b00b004e152db9e5cmr22899945pfl.38.1652229437021;
        Tue, 10 May 2022 17:37:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z16-20020a170903019000b0015f33717612sm199731plg.128.2022.05.10.17.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 17:37:16 -0700 (PDT)
Date:   Wed, 11 May 2022 00:37:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        mlevitsk@redhat.com
Subject: Re: [PATCH v3] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <YnsFOCzvotRBEJqR@google.com>
References: <20220421172352.188745-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421172352.188745-1-romanton@google.com>
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

On Thu, Apr 21, 2022, Anton Romanov wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 547ba00ef64f..f6f6ddaa2f6a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2907,6 +2907,19 @@ static void kvm_update_masterclock(struct kvm *kvm)
>  	kvm_end_pvclock_update(kvm);
>  }
>  
> +/*
> + * If kvm is built into kernel it is possible that tsc_khz saved into
> + * per-cpu cpu_tsc_khz was yet unrefined value. If CPU provides CONSTANT_TSC it
> + * doesn't make sense to snapshot it anyway so just return tsc_khz


I wouldn't mention KVM being built into the kernel.  It is relevant to reproducing
the original bug, but KVM being built as a module doesn't 100% guarantee the race
can't be triggered.

Similarly, I wouldn't mention snapshotting, at least not without explaining _why_
it doesn't makes sense.  Even if KVM were to get a notification when TSC calibration
completes, the correct behavior would be to prevent VM creation until calibration
completes.  I.e. regardless of races, snapshotting when TSC is constant is never
the right thing to do, so IMO bringing it up in a comment only adds confusion.

Something like...

/*
 * Use the kernel's tsc_khz directly if the TSC is constant, otherwise use KVM's
 * per-CPU value (which may be zero if a CPU is going offline).  Note, tsc_khz
 * can change during boot even if the TSC is constant, as it's possible for KVM
 * to be loaded before TSC calibration completes.  Ideally, KVM would get a
 * notification when calibration completes, but practically speaking calibration
 * will complete before userspace is alive enough to create VMs.
 */

> + */
> +static unsigned long get_cpu_tsc_khz(void)
> +{
> +	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		return tsc_khz;
> +	else
> +		return __this_cpu_read(cpu_tsc_khz);
> +}
> +
>  /* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
>  static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  {
> @@ -2917,7 +2930,8 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  	get_cpu();
>  
>  	data->flags = 0;
> -	if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
> +	if (ka->use_master_clock &&
> +		(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz))) {

Align indentation, e.g.

	if (ka->use_master_clock &&
	    (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz))) {

>  #ifdef CONFIG_X86_64
>  		struct timespec64 ts;
>  
> @@ -2931,7 +2945,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  		data->flags |= KVM_CLOCK_TSC_STABLE;
>  		hv_clock.tsc_timestamp = ka->master_cycle_now;
>  		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> -		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
> +		kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
>  				   &hv_clock.tsc_shift,
>  				   &hv_clock.tsc_to_system_mul);
>  		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
> @@ -3049,7 +3063,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  
>  	/* Keep irq disabled to prevent changes to the clock */
>  	local_irq_save(flags);
> -	tgt_tsc_khz = __this_cpu_read(cpu_tsc_khz);
> +	tgt_tsc_khz = get_cpu_tsc_khz();
>  	if (unlikely(tgt_tsc_khz == 0)) {
>  		local_irq_restore(flags);
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> @@ -8646,9 +8660,12 @@ static void tsc_khz_changed(void *data)
>  	struct cpufreq_freqs *freq = data;
>  	unsigned long khz = 0;
>  
> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))

I think it'd be better to do this in kvmclock_cpu_online().  The other caller,
__kvmclock_cpufreq_notifier(), is unreachable if the TSC is constant, and see a
"TSC changed" call with a constant TSC is odd/confusing.  Might be worth adding
a WARN here to prevent future goofs though?

@@ -8856,7 +8858,8 @@ static struct notifier_block kvmclock_cpufreq_notifier_block = {

 static int kvmclock_cpu_online(unsigned int cpu)
 {
-       tsc_khz_changed(NULL);
+       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+               tsc_khz_changed(NULL);
        return 0;
 }



> +		return;
> +
>  	if (data)
>  		khz = freq->new;
> -	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +	else
>  		khz = cpufreq_quick_get(raw_smp_processor_id());
>  	if (!khz)
>  		khz = tsc_khz;
> @@ -8661,6 +8678,8 @@ static void kvm_hyperv_tsc_notifier(void)
>  	struct kvm *kvm;
>  	int cpu;
>  
> +	WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TSC_RELIABLE));

Vitaly wasn't 100% certain that this is (or should be) unreachable on migration
even with a "reliable" TSC.  I would just drop the WARN, it doesn't change what
KVM needs to do for a constant TSC.  If we do want to add it, we should do so in
a separate commit as it's not strictly relevant, and so that it can be easily
reverted.

What should go in this patch is to not write cpu_tsc_khz if TSC is constant.  I
don't care about the cost of the write, I care about establishing an invariant that
cpu_tsc_khz isn't touched if the TSC is constant.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 53e9a429dff0..9453f844f147 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8742,8 +8742,10 @@ static void kvm_hyperv_tsc_notifier(void)
        hyperv_stop_tsc_emulation();

        /* TSC frequency always matches when on Hyper-V */
-       for_each_present_cpu(cpu)
-               per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+               for_each_present_cpu(cpu)
+                       per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
+       }
        kvm_max_guest_tsc_khz = tsc_khz;

        list_for_each_entry(kvm, &vm_list, vm_list) {


>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list)
>  		kvm_make_mclock_inprogress_request(kvm);
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
