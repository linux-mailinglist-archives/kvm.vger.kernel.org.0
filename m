Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C225FD8B7
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 14:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJMMBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 08:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJMMBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 08:01:43 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44CBDED33;
        Thu, 13 Oct 2022 05:01:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y8so1711118pfp.13;
        Thu, 13 Oct 2022 05:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ElBYTgFlxjWs/MeokXyE9WiTAY9kACvPyV78ldgqQ0I=;
        b=BNvSx3+biHAzmMQ0IwB+wNmj7oDhUd30T5z20pi+MYtPsJqTYGm0SigZ1UJ4sCfoYU
         7phTYl6Wx5eJWe/0/Pslb196lExabN9Tt8xgT/wIsmtNS3itk+rwgbwKhK9G+y5CgUD0
         nKP2Kk12ZOHwFGiugg9w8B3fjedJmBbztIQzBEztZTEYol+SuhXHyTKbotRwQD+vpyXh
         X3yaDZ50lwaQnJq8DzBO6NV6Z3/pvvH1PEvmgwsSz5Om3tG1j7FxJ5MydKDQR+zCGTCA
         NtTe5FWXlBPxa29okQGQgKChv5eW/UScZF68L5PTV2WnQSKbEbhMyJGw8ZofdNChhnj7
         NFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ElBYTgFlxjWs/MeokXyE9WiTAY9kACvPyV78ldgqQ0I=;
        b=hTsbq/AfrJszr3l8HRJngQz3d2KrMf1vrwrobjW7HS6BZ67vocP/r33XEHmGGuJ8Dv
         jO5IVBhat/PBthxjelW/qUgCRtdAFYti2deyMg7aOPmWs7gjEzVgslNWs3jKomHeLk+M
         o4Ue6t7TubnEItRAXx25tqsMemzbmN/sk3NvrVr121//CMl6g8tuAUPo52iOsCPj4Fic
         3xPQjCe6DrDrCqgc8LoG/XNT/17eCTjjHUFb7Con40qAD6et84NyLROBQngW2fHUUE89
         wpyHyeiYoTBiqHUjP/Y1Zhxh/AvoOJxeFXoKHCfjjzE2K84JgvScQTWu+qQb7KS0BjCo
         D7hA==
X-Gm-Message-State: ACrzQf1R61cs4TR0BhOp3k8D0X2ksDR2Rg6YAyThk4ltHFPPuaFOlKRR
        HZHRt7QcTm0PYMaTtZz8BZo=
X-Google-Smtp-Source: AMsMyM4ByYmuC11mk7RUBGIjVJ4rKO/Ymm2irbDGkd6KZkB/DnpPA4JQ8chyE6ZAo9Vo2mOydBCE6A==
X-Received: by 2002:aa7:8f12:0:b0:565:cb1e:bd7f with SMTP id x18-20020aa78f12000000b00565cb1ebd7fmr5853111pfr.86.1665662502067;
        Thu, 13 Oct 2022 05:01:42 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n3-20020a056a00212300b005625d6d2999sm1779709pfj.187.2022.10.13.05.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 05:01:41 -0700 (PDT)
Message-ID: <86d88222-a70f-49ef-71f3-a7d15ae17d7d@gmail.com>
Date:   Thu, 13 Oct 2022 20:01:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 1/4] KVM: x86/pmu: Force reprogramming of all counters on
 PMU filter change
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <likexu@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220923001355.3741194-1-seanjc@google.com>
 <20220923001355.3741194-2-seanjc@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220923001355.3741194-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Firstly, thanks for your comments that spewed out around vpmu.

On 23/9/2022 8:13 am, Sean Christopherson wrote:
> Force vCPUs to reprogram all counters on a PMU filter change to provide
> a sane ABI for userspace.  Use the existing KVM_REQ_PMU to do the
> programming, and take advantage of the fact that the reprogram_pmi bitmap
> fits in a u64 to set all bits in a single atomic update.  Note, setting
> the bitmap and making the request needs to be done _after_ the SRCU
> synchronization to ensure that vCPUs will reprogram using the new filter.
> 
> KVM's current "lazy" approach is confusing and non-deterministic.  It's

The resolute lazy approach was introduced in patch 03, right after this change.

> confusing because, from a developer perspective, the code is buggy as it
> makes zero sense to let userspace modify the filter but then not actually
> enforce the new filter.  The lazy approach is non-deterministic because
> KVM enforces the filter whenever a counter is reprogrammed, not just on
> guest WRMSRs, i.e. a guest might gain/lose access to an event at random
> times depending on what is going on in the host.
> 
> Note, the resulting behavior is still non-determinstic while the filter
> is in flux.  If userspace wants to guarantee deterministic behavior, all
> vCPUs should be paused during the filter update.
> 
> Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
> Cc: Aaron Lewis <aaronlewis@google.com>
> Jim Mattson <jmattson@google.com>

miss "Cc:" ?

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 11 ++++++++++-
>   arch/x86/kvm/pmu.c              | 15 +++++++++++++--
>   2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b3ce723efb43..462f041ede9f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -519,7 +519,16 @@ struct kvm_pmu {
>   	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
>   	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
>   	struct irq_work irq_work;
> -	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
> +
> +	/*
> +	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
> +	 * set in a single access, e.g. to reprogram all counters when the PMU
> +	 * filter changes.
> +	 */
> +	union {
> +		DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
> +		atomic64_t __reprogram_pmi;
> +	};
>   	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
>   	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
>   
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d9b9a0f0db17..4504987cbbe2 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -577,6 +577,8 @@ EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
>   int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_pmu_event_filter tmp, *filter;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
>   	size_t size;
>   	int r;
>   
> @@ -613,9 +615,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>   	mutex_lock(&kvm->lock);
>   	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
>   				     mutex_is_locked(&kvm->lock));
> -	mutex_unlock(&kvm->lock);
> -
>   	synchronize_srcu_expedited(&kvm->srcu);

The relative order of these two operations has been reversed
	mutex_unlock() and synchronize_srcu_expedited()
, extending the execution window of the critical area of "kvm->lock)".
The motivation is also not explicitly stated in the commit message.

> +
> +	BUILD_BUG_ON(sizeof(((struct kvm_pmu *)0)->reprogram_pmi) >
> +		     sizeof(((struct kvm_pmu *)0)->__reprogram_pmi));
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi, -1ull);

How about:
	bitmap_copy(pmu->reprogram_pmi, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
to avoid further cycles on calls of 
"static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit)" ?

> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_PMU);
> +
> +	mutex_unlock(&kvm->lock);
> +
>   	r = 0;
>   cleanup:
>   	kfree(filter);
