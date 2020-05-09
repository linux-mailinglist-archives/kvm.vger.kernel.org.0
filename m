Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759661CC1C7
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgEIN0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 09:26:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgEIN0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 9 May 2020 09:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589030764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJ5RDywFb8p02L3LFUPRLr4TwiBeNt4sPEKLa6XsCZ8=;
        b=RwP6PDtlaCZfCdkahnKMqxJyX76eodVZ+sseM83tc8row/R96I81zOEDSOTDIzyFMUartV
        hvvM6Qnv3DHOx3ZxPJFnWt3wTis4YK4qFWmQwoYqmUWw6t5XaAIeHD9C+cAZ+j7J54l2Tv
        O/1nimbJtz2vb168pjyhrcejQilu8HY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-wdZ9_63_M9mphiQUo0osOA-1; Sat, 09 May 2020 09:26:03 -0400
X-MC-Unique: wdZ9_63_M9mphiQUo0osOA-1
Received: by mail-wr1-f71.google.com with SMTP id 30so2374514wrq.15
        for <kvm@vger.kernel.org>; Sat, 09 May 2020 06:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yJ5RDywFb8p02L3LFUPRLr4TwiBeNt4sPEKLa6XsCZ8=;
        b=KPvivR8uPeMQ4ik0z0isYfOk3IBpYGcFOjf625FfQebQFtgr5NymTcUFVnjZ62N78c
         5oyAgOqXRejuAIcvnb+MCb0UTbTZoNHRD7coS4qaWLVZ3hkuQM8ZnLy2zVuyCGJu45p3
         Cz9Upqu5/6C6mO+HorFD2bkbc08RdsPR9RTarwaj4tvA9uCK1QDsDiXtmuMxlzCRm6sR
         6FgUiinl4Pfj47GG4IALuNH+7GyMgjMwpGy0pr6iT7TcFsJUiaKTeaf526fpyNRNKFQJ
         dcXzvAEDLRyAtghRnEgPc3ASyU5pedaypzlT5lpX8BTZCkS3fHm0OiHU/neNbJDyl5f4
         L6lw==
X-Gm-Message-State: AGi0PuYiEPVg4cjUwqza1ucva9bhSUF1uupCwQBSKqcvmzJz1WuJZGtK
        nWKiNgdptXSKZkibBsFLebtFGdPZ1WTYch+pvzA3lXfFaHwH0+iAV6BuLVhSDqMMFNg4Y5G2bJy
        5vywJDQELYOja
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr8361514wrx.113.1589030761403;
        Sat, 09 May 2020 06:26:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypLnCucXzjeaAUyze+f/hgWgZ3qMP3bKLXUz3hmKkRqCcX5QdqwGQkNawxAz7P8VSkFF1pNQlw==
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr8361495wrx.113.1589030761153;
        Sat, 09 May 2020 06:26:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cb4:2b36:6750:73ce? ([2001:b07:6468:f312:1cb4:2b36:6750:73ce])
        by smtp.gmail.com with ESMTPSA id h74sm8565819wrh.76.2020.05.09.06.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 06:26:00 -0700 (PDT)
Subject: Re: [PATCH] kvm: add halt-polling cpu usage stats
To:     Jon Cargille <jcargill@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>
References: <20200508182240.68440-1-jcargill@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <914f1aec-de5e-dcc9-9f99-4ffbcd7e8a53@redhat.com>
Date:   Sat, 9 May 2020 15:25:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508182240.68440-1-jcargill@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 20:22, Jon Cargille wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Two new stats for exposing halt-polling cpu usage:
> halt_poll_success_ns
> halt_poll_fail_ns
> 
> Thus sum of these 2 stats is the total cpu time spent polling. "success"
> means the VCPU polled until a virtual interrupt was delivered. "fail"
> means the VCPU had to schedule out (either because the maximum poll time
> was reached or it needed to yield the CPU).
> 
> To avoid touching every arch's kvm_vcpu_stat struct, only update and
> export halt-polling cpu usage stats if we're on x86.

I fixed all the other architectures and queued it, thanks.

Paolo

> 
> Exporting cpu usage as a u64 and in nanoseconds means we will overflow at
> ~500 years, which seems reasonably large.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jon Cargille <jcargill@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/x86.c              |  2 ++
>  virt/kvm/kvm_main.c             | 20 +++++++++++++++++---
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a239a297be33..3287159ab15b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1032,6 +1032,8 @@ struct kvm_vcpu_stat {
>  	u64 irq_injections;
>  	u64 nmi_injections;
>  	u64 req_event;
> +	u64 halt_poll_success_ns;
> +	u64 halt_poll_fail_ns;
>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8c0b77ac8dc6..9736d91ce877 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -217,6 +217,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VCPU_STAT("nmi_injections", nmi_injections),
>  	VCPU_STAT("req_event", req_event),
>  	VCPU_STAT("l1d_flush", l1d_flush),
> +	VCPU_STAT( "halt_poll_success_ns", halt_poll_success_ns),
> +	VCPU_STAT( "halt_poll_fail_ns", halt_poll_fail_ns),
>  	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
>  	VM_STAT("mmu_pte_write", mmu_pte_write),
>  	VM_STAT("mmu_pte_updated", mmu_pte_updated),
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 33e1eee96f75..348b4a6bde53 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2664,19 +2664,30 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static inline void
> +update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
> +{
> +#ifdef CONFIG_X86
> +	if (waited)
> +		vcpu->stat.halt_poll_fail_ns += poll_ns;
> +	else
> +		vcpu->stat.halt_poll_success_ns += poll_ns;
> +#endif
> +}
> +
>  /*
>   * The vCPU has executed a HLT instruction with in-kernel mode enabled.
>   */
>  void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
> -	ktime_t start, cur;
> +	ktime_t start, cur, poll_end;
>  	DECLARE_SWAITQUEUE(wait);
>  	bool waited = false;
>  	u64 block_ns;
>  
>  	kvm_arch_vcpu_blocking(vcpu);
>  
> -	start = cur = ktime_get();
> +	start = cur = poll_end = ktime_get();
>  	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
>  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
>  
> @@ -2692,7 +2703,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  					++vcpu->stat.halt_poll_invalid;
>  				goto out;
>  			}
> -			cur = ktime_get();
> +			poll_end = cur = ktime_get();
>  		} while (single_task_running() && ktime_before(cur, stop));
>  	}
>  
> @@ -2712,6 +2723,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> +	update_halt_poll_stats(
> +		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
> +
>  	if (!kvm_arch_no_poll(vcpu)) {
>  		if (!vcpu_valid_wakeup(vcpu)) {
>  			shrink_halt_poll_ns(vcpu);
> 

