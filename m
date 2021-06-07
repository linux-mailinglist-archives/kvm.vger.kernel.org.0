Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F50E39DD08
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFGM4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 08:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFGM4i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 08:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623070486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k8SsabsUZynWfNUAOHQvP42MWVxlVeq8xWJkSvPvldk=;
        b=Bo2FTRJIxf3m1RpLpFPUE23H0JAAmQHFkAXJ0j9ciXmasuBmOVEcYlSCvnFTvQSE/kWwwy
        LuB2/HFlIebMde785KuyBSXs6q/xMJrl3aEmBWKntH6J6O10iKMJZS9NiqWK0NdR93CDaW
        wyOX+/HZgOCFWlN3Ei8nPF1FBqMkPTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-RCO4hQnqMEyBcKOd3h_O_w-1; Mon, 07 Jun 2021 08:54:45 -0400
X-MC-Unique: RCO4hQnqMEyBcKOd3h_O_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 756A4106BB3B;
        Mon,  7 Jun 2021 12:54:44 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6D1E60CCF;
        Mon,  7 Jun 2021 12:54:41 +0000 (UTC)
Message-ID: <fe13fe734a01bb54f47fea06624c617beb062fdd.camel@redhat.com>
Subject: Re: [PATCHv3 2/2] kvm: x86: implement KVM PM-notifier
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 07 Jun 2021 15:54:40 +0300
In-Reply-To: <20210606021045.14159-2-senozhatsky@chromium.org>
References: <20210606021045.14159-1-senozhatsky@chromium.org>
         <20210606021045.14159-2-senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2021-06-06 at 11:10 +0900, Sergey Senozhatsky wrote:
> Implement PM hibernation/suspend prepare notifiers so that KVM
> can reliably set PVCLOCK_GUEST_STOPPED on VCPUs and properly
> suspend VMs.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  arch/x86/kvm/Kconfig |  1 +
>  arch/x86/kvm/x86.c   | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index fb8efb387aff..ac69894eab88 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -43,6 +43,7 @@ config KVM
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_VFIO
>  	select SRCU
> +	select HAVE_KVM_PM_NOTIFIER if PM
>  	help
>  	  Support hosting fully virtualized guest machines using hardware
>  	  virtualization extensions.  You will need a fairly recent
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b594275d49b5..af1ab527a0cb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -58,6 +58,7 @@
>  #include <linux/sched/isolation.h>
>  #include <linux/mem_encrypt.h>
>  #include <linux/entry-kvm.h>
> +#include <linux/suspend.h>
>  
>  #include <trace/events/kvm.h>
>  
> @@ -5615,6 +5616,41 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> +static int kvm_arch_suspend_notifier(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i, ret = 0;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu->arch.pv_time_enabled)
> +			continue;
> +
> +		ret = kvm_set_guest_paused(vcpu);
> +		if (ret) {
> +			kvm_err("Failed to pause guest VCPU%d: %d\n",
> +				vcpu->vcpu_id, ret);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&kvm->lock);
> +
> +	return ret ? NOTIFY_BAD : NOTIFY_DONE;
> +}
> +
> +int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
> +{
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		return kvm_arch_suspend_notifier(kvm);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +#endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {

Overall this looks OK to me.
 
Do you have a test case in which this patch helps to make the guest behave better after
the host suspend though? I tested this and I don't see any significant change.
(guest works after host suspend before and after, and I still have clocksource
watchdogs firing in the guest)
 
 
Also I would like to add my .02 cents on my observations on what happens when I suspend my system
with guests running, which I do once in a while.
I haven't dug deep into it yet as host suspend with VM running wasn't high on my priority list.
 
First of all after a host suspend/resume cycle (and that is true on all 3 machines I own),
the host TSC is reset to 0 on all CPUs, thus while it is still synchronized, it jumps backward.
 
Host kernel has no issues coping with this.
 
Guests however complain about clocksource watchdog and mark the tsc clocksource as unstable,
at least when invtsc is used (regardless of this patch, I wasn't able to notice a difference
with and without it yet).
 
 
[  287.515864] clocksource: timekeeping watchdog on CPU0: Marking clocksource 'tsc' as unstable because the skew is too large:
[  287.516926] clocksource:                       'kvm-clock' wd_now: 4437767926 wd_last: 429c3c42f5 mask: ffffffffffffffff
[  287.527100] clocksource:                       'tsc' cs_now: c33f6ce157 cs_last: c1be2ad19f mask: ffffffffffffffff
[  287.528493] tsc: Marking TSC unstable due to clocksource watchdog
[  287.556640] clocksource: Switched to clocksource kvm-clock
 
 
This is from Intel system with stable TSC, but I have seen this on my AMD systems as well,
but these have other issues which might affect this (see below).
 
AFAIK, we have code in kvm_arch_hardware_enable for this exact case but it might not work
correctly or be not enough to deal with this.
 
Also I notice that this code sets kvm->arch.backwards_tsc_observed = true which 
in turn disables the master clock which is not good as well.
 
I haven't yet allocated time to investigate this.
 
 
Another bit of information which I didn't start a discussion (but I think I should), 
which is relevant to AMD systems, is in 'unsynchronized_tsc' function.

On AMD guest it will mark the TSC as unstable in the guest as long as invtsc is not used.
I patched that code out for myself, that is why I am mentioning it.

Best regards,
	Maxim Levitsky


