Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223485096E6
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 07:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384492AbiDUFlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 01:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345361AbiDUFlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 01:41:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E5A7120A5
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 22:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650519493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRfdOwYT8QI9WApcESbh13xQ3QY4wlvROLHeUH82pMM=;
        b=dYzByq6FjAoyW81ZeaWDCIgxsvY/D61Pn3Bcii81zHvTITDRAOc/F1GcLYJQrke+HFbs18
        hqUOX2tc7Irksh9MSCznfb0zrZ5TJQx0qVx2mE3zd9CXigHDdEeIFkH0cg7yiHrTwZBWaM
        y4lrjjXoUIiqeKLCs4NKHuy23zyeDFE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-zlA8ZTsLNgGr4fULQMeyvw-1; Thu, 21 Apr 2022 01:38:10 -0400
X-MC-Unique: zlA8ZTsLNgGr4fULQMeyvw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A35023C0F082;
        Thu, 21 Apr 2022 05:38:09 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DAB54320EE;
        Thu, 21 Apr 2022 05:38:08 +0000 (UTC)
Message-ID: <243bdbfc17f9c615970ddb36a4968fa0466b959b.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com
Date:   Thu, 21 Apr 2022 08:38:07 +0300
In-Reply-To: <20220421005645.56801-1-romanton@google.com>
References: <20220421005645.56801-1-romanton@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-21 at 00:56 +0000, Anton Romanov wrote:
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
> v2:
>     fixed commit msg indentation
>     added WARN_ON_ONCE in kvm_hyperv_tsc_notifier
>     opened up condition in __get_kvmclock
>  arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 547ba00ef64f..1043cfd26576 100644
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
> +		(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
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
> +
>  	mutex_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list)
>  		kvm_make_mclock_inprogress_request(kvm);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


A question to AMD engineers: Is that really true that AMD cpu doesn't report
TSC frequency somewhere (CPUID/msr)?

It really sucks that we still have to measure it.

Best regards,
	Maxim Levitsky


