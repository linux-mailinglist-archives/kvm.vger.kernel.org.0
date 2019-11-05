Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E6BEFAEA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388464AbfKEKXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:23:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388358AbfKEKXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:23:17 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E49D4E919
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:23:17 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v6so2787859wrm.18
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PcBBgu6SOROWeQPJhgSxyE0icLieOSEFxVr+4CYsprY=;
        b=a3f3YQK/M2hr5XMgqNMAFDvd1M7exsbP2KjWnW/9CChJwR3tS6jbR8gLvwWh8gSrAa
         Ub+s64FKqzRyionOd5j6lOMU1zELS99XPaaSgwRCH2/s6cVAS1IC7cT5mKeoz7Rl4TXO
         og9lajmhXeOzkpu8cOMs44Pft3Z5qD+FsJ70YCzBoVzw0Nreg3IOzOgyLHx36EWvSDAB
         r4R71QhSKeUEJA6dcJdkzxetAkaLduSA2trQzSy9ZnwSIDyugVQWkwiuX5gBaSKLmP/7
         OYKZZVoypf2EsWYPzntz8w1izOm1h64vt+uL+8BPpDcTP4DmH9X1YyckFnt3FfSLKHko
         +Emg==
X-Gm-Message-State: APjAAAWupg6bxooIEL9EWFoSLDYREgW+xGmmr1MESYAHaOak3NVEQKEm
        inYUD0T23u4u0TnI0ltFUEAW+thzkGgxxtwi5PF8yi0MHdJM8lvejDE2m+G2st7hnDx0LZLfLEp
        pETeFrflSzlhe
X-Received: by 2002:a5d:6947:: with SMTP id r7mr3007070wrw.129.1572949395716;
        Tue, 05 Nov 2019 02:23:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqybAnv9rx4J+dG+3zALibmvXj0MCS3vNaSu6P5s+2lri5gmcAcljRuafrbJ+2RXJymJ54T8bQ==
X-Received: by 2002:a5d:6947:: with SMTP id r7mr3007044wrw.129.1572949395415;
        Tue, 05 Nov 2019 02:23:15 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 205sm20611901wmb.3.2019.11.05.02.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:23:14 -0800 (PST)
Subject: Re: [PATCH 12/13] KVM: retpolines: x86: eliminate retpoline from
 svm.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-13-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5ed26dee-e439-6c2f-cd10-e73fefbd3a02@redhat.com>
Date:   Tue, 5 Nov 2019 11:21:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104230001.27774-13-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 00:00, Andrea Arcangeli wrote:
> It's enough to check the exit value and issue a direct call to avoid
> the retpoline for all the common vmexit reasons.
> 
> After this commit is applied, here the most common retpolines executed
> under a high resolution timer workload in the guest on a SVM host:
> 
> [..]
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     ktime_get_update_offsets_now+70
>     hrtimer_interrupt+131
>     smp_apic_timer_interrupt+106
>     apic_timer_interrupt+15
>     start_sw_timer+359
>     restart_apic_timer+85
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 1940
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_r12+33
>     force_qs_rnp+217
>     rcu_gp_kthread+1270
>     kthread+268
>     ret_from_fork+34
> ]: 4644
> @[]: 25095
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     lapic_next_event+28
>     clockevents_program_event+148
>     hrtimer_start_range_ns+528
>     start_sw_timer+356
>     restart_apic_timer+85
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 41474
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     clockevents_program_event+148
>     hrtimer_start_range_ns+528
>     start_sw_timer+356
>     restart_apic_timer+85
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 41474
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     ktime_get+58
>     clockevents_program_event+84
>     hrtimer_start_range_ns+528
>     start_sw_timer+356
>     restart_apic_timer+85
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 41887
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     lapic_next_event+28
>     clockevents_program_event+148
>     hrtimer_try_to_cancel+168
>     hrtimer_cancel+21
>     kvm_set_lapic_tscdeadline_msr+43
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 42723
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     clockevents_program_event+148
>     hrtimer_try_to_cancel+168
>     hrtimer_cancel+21
>     kvm_set_lapic_tscdeadline_msr+43
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 42766
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     ktime_get+58
>     clockevents_program_event+84
>     hrtimer_try_to_cancel+168
>     hrtimer_cancel+21
>     kvm_set_lapic_tscdeadline_msr+43
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 42848
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     ktime_get+58
>     start_sw_timer+279
>     restart_apic_timer+85
>     kvm_set_msr_common+1497
>     msr_interception+142
>     vcpu_enter_guest+684
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 499845
> 
> @total: 1780243
> 
> SVM has no TSC based programmable preemption timer so it is invoking
> ktime_get() frequently.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 0021e11fd1fb..3942bca46740 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4995,6 +4995,18 @@ int kvm_x86_handle_exit(struct kvm_vcpu *vcpu)
>  		return 0;
>  	}
>  
> +#ifdef CONFIG_RETPOLINE
> +	if (exit_code == SVM_EXIT_MSR)
> +		return msr_interception(svm);
> +	else if (exit_code == SVM_EXIT_VINTR)
> +		return interrupt_window_interception(svm);
> +	else if (exit_code == SVM_EXIT_INTR)
> +		return intr_interception(svm);
> +	else if (exit_code == SVM_EXIT_HLT)
> +		return halt_interception(svm);
> +	else if (exit_code == SVM_EXIT_NPF)
> +		return npf_interception(svm);
> +#endif
>  	return svm_exit_handlers[exit_code](svm);
>  }
>  
> 

Queued, thanks (BTW, I still disagree about HLT exits but okay).

Paolo
