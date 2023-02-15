Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FA7697B2D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 12:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjBOLxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 06:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbjBOLxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 06:53:36 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E5B37702;
        Wed, 15 Feb 2023 03:53:35 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id bw10so2591521pfb.0;
        Wed, 15 Feb 2023 03:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L2pMCXc09R4Uny8y3qV44rEj4nyGTe53deetytJyiYk=;
        b=GkxXvs92dofMVCg4+IPtoJt2huIDyUeA8Oyvwb7XxvbL1IWIA0UeXG/fNkDNagbpDq
         skfzBDX7IguDZRrx6Bu7/shmRBhSK0CzHol6uPVmmwSWDTmagD8sxJgi858DYty0S954
         MmHeuWSdWHP8HW1IhnHPMgPMt+ZDBwQBsOpKxKQNkkPOXkbtYDTq635AUTJryO99nKJV
         pUBAAevskLKFnTKf7YrjQBA17Qxg+xzz3mjNVFHOFMnCI8krEgE5qQztGjEl82Z9xILR
         CUHz6BHpbTsMAuxnS4mjhK+7hD5kMP8Nsivjzc43jaNF59mlltLfMIEpAzkCE+Mx57pg
         4+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2pMCXc09R4Uny8y3qV44rEj4nyGTe53deetytJyiYk=;
        b=m/m3lrv75nNRatQ8NL97SwTHqoZjIIpF+pECgSg2t8m6AMigOEUe5pROidDQgIVA8q
         9hwPdHjrJK9sQxUG/xe4rp608Rxbvj2pL6rVlycgDr5RMIw35ThPjy81A7QJmjkeeBSK
         LA72hely998Z9XvvlRK70VjItf56lq0phGGotyzF5axPtBbaM+zBDKPZClScwb1NDh7u
         oK3TDk2oQieTc2YEtL12aAPtPZpI+BO72ncdEm9X9o6+grJwvhIXSvM5JsBMqbSln80z
         8lrJe99wLmF7RnNZSk5h9CfaQDuIeamaLuO6VVo1wSLBhyEMvRK4TFyT57Jds9FWDP60
         sr5Q==
X-Gm-Message-State: AO0yUKUrjIQw7Vxb1b6irnbStLKBvxRfZhQbSoigzkHWJd0Avye8X2y7
        VC+2VfzOMvo2wht32xnumck=
X-Google-Smtp-Source: AK7set8Dw0HeCND/M2BuLpi3Na8t24gXTsdS59W28wA6RBbP9xpPN2j4aKHv7A26uWPoleFkpS9akg==
X-Received: by 2002:aa7:96f7:0:b0:5a8:51bd:e0f4 with SMTP id i23-20020aa796f7000000b005a851bde0f4mr1590614pfq.18.1676462015326;
        Wed, 15 Feb 2023 03:53:35 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78018000000b00593baab06dcsm11521471pfi.198.2023.02.15.03.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 03:53:34 -0800 (PST)
Message-ID: <54d64f0e-871f-3004-d8a6-55c60affede0@gmail.com>
Date:   Wed, 15 Feb 2023 19:53:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 06/21] KVM: x86/pmu: WARN and bug the VM if PMU is
 refreshed after vCPU has run
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-7-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230210003148.2646712-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2023 8:31 am, Sean Christopherson wrote:
> Now that KVM disallows changing feature MSRs, i.e. PERF_CAPABILITIES,
> after running a vCPU, WARN and bug the VM if the PMU is refreshed after
> the vCPU has run.
> 
> Note, KVM has disallowed CPUID updates after running a vCPU since commit
> feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN"), i.e.
> PERF_CAPABILITIES was the only remaining way to trigger a PMU refresh
> after KVM_RUN.

A malicious user space could have saved the vcpu state and then deleted
and recreated a new vcpu w/ previous state so that it would have a chance
to re-set the features msr.

The key to this issue may be focused on the KVM_CREATE_VM interface.

How about the contract that when the first vcpu is created and "after
KVM_RUN of any vcpu", the values of all feature msrs for all vcpus on
the same guest cannot be changed, even if the (likely) first ever ran
vcpu is deleted ?

> 
> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/pmu.c |  3 +++
>   arch/x86/kvm/x86.c | 10 +++++++++-
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 612e6c70ce2e..7e974c4e61b0 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -589,6 +589,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>    */
>   void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>   {
> +	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
> +		return;
> +
>   	static_call(kvm_x86_pmu_refresh)(vcpu);
>   }
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 186cb6a81643..1b14632a94a3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3626,9 +3626,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (data & ~kvm_caps.supported_perf_cap)
>   			return 1;
>   
> +		/*
> +		 * Note, this is not just a performance optimization!  KVM
> +		 * disallows changing feature MSRs after the vCPU has run; PMU
> +		 * refresh will bug the VM if called after the vCPU has run.
> +		 */
> +		if (vcpu->arch.perf_capabilities == data)
> +			break;
> +
>   		vcpu->arch.perf_capabilities = data;
>   		kvm_pmu_refresh(vcpu);
> -		return 0;
> +		break;
>   	case MSR_EFER:
>   		return set_efer(vcpu, msr_info);
>   	case MSR_K7_HWCR:
