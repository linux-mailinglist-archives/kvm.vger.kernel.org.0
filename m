Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8924045AED2
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 23:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhKWWHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 17:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhKWWHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 17:07:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECA9C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 14:04:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso561572pjb.2
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 14:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQLhaF17R2AydETGYrt0kO60mhOXnj8D3N6d6A1vHqY=;
        b=HH1l0mFTXrGaJ38x/iRcc/8UHLE8RBC7TivUYfmCYz4sViNY4CsViZep50cnrgmUCI
         IaJSV58NGhYgeHUwBmYQlKmrvad2a3uWxGnmyLJERDA38bduDD3EVrUcGLZxb6RBcIIV
         xeOlaRTgl4NA2INBSsOSoFjYTFpnRLXA17sZ4BEjzxvLYXIuNigTSB+6TZG/tlUcr8OD
         zuAhhwysJ13YKrqdCARlIKK0C6Yjze4SQan0DNlvkqQi/Nxo7bTVpDGEIvpNTy1/ZMYP
         freC8tvsbJ2bM93qiIYQW60GKQmhJo6YI1dqEe6krccvgS4V9UvEMm3sQ5fth53+KDgS
         VKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQLhaF17R2AydETGYrt0kO60mhOXnj8D3N6d6A1vHqY=;
        b=Tbzu/utDA6AFMog4mihKfOS82wSfmVGlefbqeVYnCFR2YuRdjGt5QqqEj3e4yTQe6+
         UT669xnQHYwOUMOyl79+E3dnYfvpgdLTwNiACgR0fM6sYmQcX0a83FqFYDlbNnJ7OfFc
         awef1UcbOjfN6slH7Q3StjHv1NK/HrccceapTdOL0a0uVsvafmOtDHVP23N4LvYVWHHz
         /smqmyZLjJeY9QLFUzW3XlWhLxeOq6UqykmHf4jK9FMLhzdZh6/ZOQBRkXrzr/ovMCPJ
         jxTpQU/clWktGMAMreYVoo8yThhwRJwQVlLUTua2ck/rIU0uGxXXtJ5S5cwkJwSJoc99
         hOcA==
X-Gm-Message-State: AOAM531kHQPUmH/ogKAtkMb/cj6Ra7AstcHGmerYnjZfBkGdXsxfas+5
        XzzzaO/zuL1LC2+J80KpHsASmmQJMC20nzxF
X-Google-Smtp-Source: ABdhPJwg6gPbsxeJ61hfR66AIexFC+BHl9aSfNelYLxKfaSBVY6B628n1hrIw2UXHaj/YQ2AZb/4ww==
X-Received: by 2002:a17:902:da8e:b0:142:1142:b794 with SMTP id j14-20020a170902da8e00b001421142b794mr11605364plx.82.1637705048365;
        Tue, 23 Nov 2021 14:04:08 -0800 (PST)
Received: from ?IPv6:2601:646:8200:baf:3f99:617e:8ffd:163? ([2601:646:8200:baf:3f99:617e:8ffd:163])
        by smtp.gmail.com with ESMTPSA id om8sm2274531pjb.12.2021.11.23.14.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 14:04:08 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Handle "default" period when selectively
 waking kthread
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211120015706.3830341-1-seanjc@google.com>
From:   Junaid Shahid <junaids@google.com>
Message-ID: <2a30773b-7c2b-2d95-6da7-ba6c2f5e66a4@google.com>
Date:   Tue, 23 Nov 2021 14:04:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211120015706.3830341-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/21 5:57 PM, Sean Christopherson wrote:
> Account for the '0' being a default, "let KVM choose" period, when
> determining whether or not the recovery worker needs to be awakened in
> response to userspace reducing the period.  Failure to do so results in
> the worker not being awakened properly, e.g. when changing the period
> from '0' to any small-ish value.
> 
> Fixes: 4dfe4f40d845 ("kvm: x86: mmu: Make NX huge page recovery period configurable")
> Cc: stable@vger.kernel.org
> Cc: Junaid Shahid <junaids@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 48 +++++++++++++++++++++++++++++-------------
>   1 file changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8f0035517450..db7e1ad4d046 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6165,23 +6165,46 @@ void kvm_mmu_module_exit(void)
>   	mmu_audit_disable();
>   }
>   
> +/*
> + * Calculate the effective recovery period, accounting for '0' meaning "let KVM
> + * select a period of ~1 hour per page".  Returns true if recovery is enabled.
> + */
> +static bool calc_nx_huge_pages_recovery_period(uint *period)
> +{
> +	/*
> +	 * Use READ_ONCE to get the params, this may be called outside of the
> +	 * param setters, e.g. by the kthread to compute its next timeout.
> +	 */
> +	bool enabled = READ_ONCE(nx_huge_pages);
> +	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> +
> +	if (!enabled || !ratio)
> +		return false;
> +
> +	*period = READ_ONCE(nx_huge_pages_recovery_period_ms);
> +	if (!*period) {
> +		/* Make sure the period is not less than one second.  */
> +		ratio = min(ratio, 3600u);
> +		*period = 60 * 60 * 1000 / ratio;
> +	}
> +	return true;
> +}
> +
>   static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp)
>   {
>   	bool was_recovery_enabled, is_recovery_enabled;
>   	uint old_period, new_period;
>   	int err;
>   
> -	was_recovery_enabled = nx_huge_pages_recovery_ratio;
> -	old_period = nx_huge_pages_recovery_period_ms;
> +	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
>   
>   	err = param_set_uint(val, kp);
>   	if (err)
>   		return err;
>   
> -	is_recovery_enabled = nx_huge_pages_recovery_ratio;
> -	new_period = nx_huge_pages_recovery_period_ms;
> +	is_recovery_enabled = calc_nx_huge_pages_recovery_period(&new_period);
>   
> -	if (READ_ONCE(nx_huge_pages) && is_recovery_enabled &&
> +	if (is_recovery_enabled &&
>   	    (!was_recovery_enabled || old_period > new_period)) {
>   		struct kvm *kvm;
>   
> @@ -6245,18 +6268,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>   
>   static long get_nx_lpage_recovery_timeout(u64 start_time)
>   {
> -	uint ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> -	uint period = READ_ONCE(nx_huge_pages_recovery_period_ms);
> +	bool enabled;
> +	uint period;
>   
> -	if (!period && ratio) {
> -		/* Make sure the period is not less than one second.  */
> -		ratio = min(ratio, 3600u);
> -		period = 60 * 60 * 1000 / ratio;
> -	}
> +	enabled = calc_nx_huge_pages_recovery_period(&period);
>   
> -	return READ_ONCE(nx_huge_pages) && ratio
> -		? start_time + msecs_to_jiffies(period) - get_jiffies_64()
> -		: MAX_SCHEDULE_TIMEOUT;
> +	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
> +		       : MAX_SCHEDULE_TIMEOUT;
>   }
>   
>   static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
> 

Reviewed-by: Junaid Shahid <junaids@google.com>
