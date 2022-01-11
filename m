Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8410E48A485
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 01:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiAKAq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 19:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242961AbiAKAq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 19:46:57 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A20C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 16:46:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso1786457pjo.5
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 16:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SqPpCBaIJxWA66e99iweXS9Mhum0NmymuknlhbSSZ50=;
        b=QZPDkrPqDAt2TUvijsCJoWEp8hBX3K7CoUbnIt2KAuwm2a+qT7x7YC0CVczxD0DKkF
         Qvb3kng7kd6ytrqrglellMiWZ7wf/gNQRJAm7jxF9fjla49Kl70HCoFo1A78iD+VVzJX
         q/ADkE+RHouE4kG5HQ8slXBGeaPrndX8VnQbRdP8qjjyA5betkwPk3deVNqXQ4uH5O6Y
         eL05nU+EQH7kNcEMy1ENYBIMnHSGBD6SPKMrE4KZKVj7k8tVXN8kdiNCD9KgjwBD7XyZ
         TojY4f3vH3s2tp4rRsnM0qkCG/Ecb0PwDfegKK2vfM6wXkrspik1OV2HlX8s/L/hHCVp
         bjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SqPpCBaIJxWA66e99iweXS9Mhum0NmymuknlhbSSZ50=;
        b=sAsuS7XF1XtANGiQgDeBxRQV+t1HAHR6MRp5X2myYSiQY6yt1m5LtUuv3MJDMUBX++
         rkWSLRA4o0qnNq2JI3SnBcMOnzoeSKuPyUXrmiU/tGpVci04Ts131bfhAksTMx26T0x1
         gjEG+31o1GfHrCRhg4Qnua1o+EHQ7ERk1jDEZoQWV3QeGa/s4zxbfs40Hb5b3HMwyp5V
         KB3jIyIKEOosnQei1lqzcQ2Q6c6DlJx/vPW+BYHgvZq47A2jEuZ//Iw95xwLnhvPETi9
         VIuVDzcOT0HplkFrnQBhCVt1a1e/EI8PriD7/JUJFoVuOR13vffS94tlGvYgh58wnPZe
         H56A==
X-Gm-Message-State: AOAM532/HlqrN5O0AlvRdMU3LkRM16rvG1VI5Bg5rEHBqHyDBfUOKhLr
        aWQENqhjjg3gMXYIb+fUNwbyHBb/fiUY2w==
X-Google-Smtp-Source: ABdhPJwvMjX/WRnMp8L6dB0iTB31Veyj0mqliwtvWwJIsTSnplQyTL0JYXfytqmDiFdew4n9g9in3w==
X-Received: by 2002:a17:90b:3b81:: with SMTP id pc1mr409953pjb.193.1641862016752;
        Mon, 10 Jan 2022 16:46:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h8sm2269110pfv.4.2022.01.10.16.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 16:46:56 -0800 (PST)
Date:   Tue, 11 Jan 2022 00:46:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: Do compatibility checks on hotplugged CPUs
Message-ID: <YdzTfIEZ727L4g2R@google.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-7-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227081515.2088920-7-chao.gao@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021, Chao Gao wrote:
> At init time, KVM does compatibility checks to ensure that all online
> CPUs support hardware virtualization and a common set of features. But
> KVM uses hotplugged CPUs without such compatibility checks. On Intel
> CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX or
> vmentry failure if the hotplugged CPU doesn't meet minimal feature
> requirements.
> 
> Do compatibility checks when onlining a CPU. If any VM is running,
> KVM hotplug callback returns an error to abort onlining incompatible
> CPUs.
> 
> But if no VM is running, onlining incompatible CPUs is allowed. Instead,
> KVM is prohibited from creating VMs similar to the policy for init-time
> compatibility checks.

...

> ---
>  virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c1054604d1e8..0ff80076d48d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -106,6 +106,8 @@ LIST_HEAD(vm_list);
>  static cpumask_var_t cpus_hardware_enabled;
>  static int kvm_usage_count;
>  static atomic_t hardware_enable_failed;
> +/* Set if hardware becomes incompatible after CPU hotplug */
> +static bool hardware_incompatible;
>  
>  static struct kmem_cache *kvm_vcpu_cache;
>  
> @@ -4855,20 +4857,32 @@ static void hardware_enable_nolock(void *junk)
>  
>  static int kvm_online_cpu(unsigned int cpu)
>  {
> -	int ret = 0;
> +	int ret;
>  
> +	ret = kvm_arch_check_processor_compat();
>  	raw_spin_lock(&kvm_count_lock);
>  	/*
>  	 * Abort the CPU online process if hardware virtualization cannot
>  	 * be enabled. Otherwise running VMs would encounter unrecoverable
>  	 * errors when scheduled to this CPU.
>  	 */
> -	if (kvm_usage_count) {
> +	if (!ret && kvm_usage_count) {
>  		hardware_enable_nolock(NULL);
>  		if (atomic_read(&hardware_enable_failed)) {
>  			ret = -EIO;
>  			pr_info("kvm: abort onlining CPU%d", cpu);
>  		}
> +	} else if (ret && !kvm_usage_count) {
> +		/*
> +		 * Continue onlining an incompatible CPU if no VM is
> +		 * running. KVM should reject creating any VM after this
> +		 * point. Then this CPU can be still used to run non-VM
> +		 * workload.
> +		 */
> +		ret = 0;
> +		hardware_incompatible = true;

This has a fairly big flaw in that it prevents KVM from creating VMs even if the
offending CPU is offlined.  That seems like a very reasonable thing to do, e.g.
admin sees that hotplugging a CPU broke KVM and removes the CPU to remedy the
problem.  And if KVM is built-in, reloading KVM to wipe hardware_incompatible
after offlining the CPU isn't an option.

To make this approach work, I think kvm_offline_cpu() would have to reevaluate
hardware_incompatible if the flag is set.

And should there be a KVM module param to let the admin opt in/out of this
behavior?  E.g. if the primary use case for a system is to run VMs, disabling
KVM just to online a CPU isn't very helpful.

That said, I'm not convinced that continuing with the hotplug in this scenario
is ever the right thing to do.  Either the CPU being hotplugged really is a different
CPU, or it's literally broken.  In both cases, odds are very, very good that running
on the dodgy CPU will hose the kernel sooner or later, i.e. KVM's compatibility checks
are just the canary in the coal mine.

TDX is a different beast as (a) that's purely a security restriction and (b) anyone
trying to run TDX guests darn well better know that TDX doesn't allow hotplug.
In other words, if TDX gets disabled due to hotplug, either someone majorly screwed
up and is going to be unhappy no matter what, or there's no intention of using TDX
and it's a complete don't care.

> +		pr_info("kvm: prohibit VM creation due to incompatible CPU%d",

pr_info() is a bit weak, this should be at least pr_warn() and maybe even pr_err().

> +			cpu);

Eh, I'd omit the newline and let that poke out.

>  	}
>  	raw_spin_unlock(&kvm_count_lock);
>  	return ret;
> @@ -4913,8 +4927,24 @@ static int hardware_enable_all(void)
>  {
>  	int r = 0;
>  
> +	/*
> +	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> +	 * is called. on_each_cpu() between them includes the CPU. As a result,
> +	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
> +	 * This would enable hardware virtualization on that cpu without
> +	 * compatibility checks, which can potentially crash system or break
> +	 * running VMs.
> +	 *
> +	 * Disable CPU hotplug to prevent this case from happening.
> +	 */
> +	cpus_read_lock();
>  	raw_spin_lock(&kvm_count_lock);
>  
> +	if (hardware_incompatible) {

Another error message would likely be helpful here.  Even better would be if KVM
could provide some way for userspace to query which CPU(s) is bad.

> +		r = -EIO;
> +		goto unlock;
> +	}
> +
>  	kvm_usage_count++;
>  	if (kvm_usage_count == 1) {
>  		atomic_set(&hardware_enable_failed, 0);
> @@ -4926,7 +4956,9 @@ static int hardware_enable_all(void)
>  		}
>  	}
>  
> +unlock:
>  	raw_spin_unlock(&kvm_count_lock);
> +	cpus_read_unlock();
>  
>  	return r;
>  }
> -- 
> 2.25.1
> 
