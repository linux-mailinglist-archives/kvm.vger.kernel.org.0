Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B535FE904
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 08:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiJNGmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 02:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJNGmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 02:42:05 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10271946E9;
        Thu, 13 Oct 2022 23:42:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h185so3522979pgc.10;
        Thu, 13 Oct 2022 23:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wgMNc1/p3kWYBlyjxsEmMlPIxvpXqHiHcX9JbgUw0hE=;
        b=UaerY0EgkXWYExScySFZ2Prsnh1NEHkEjxmiJzt8PKASJuHT3i1A0OYXLZhltsRRsF
         yGM9xDaVu1JeiMEFUwAfm9YNYqu7jA4JPMD0axLXkjPx6OtsqZkasnVytLYJayBNQpCT
         dr1x8Rdk+6uHUk/18vFqEFDENbQm6CiT+HhAFZOZhn06QOjlejZCimA6YZwwhzdc9ZcK
         TLdKnC/ydl/TW9Zs+uMEtH3mk9toiVMJIru7pt/0iHeLZzSMqNb/crhRB5kObI55ZG33
         t8t11yRqBq3nvoVF3Sa2kQz4jH051C5GguJYxQb9KZSNbL+XEw1PQ6uMgSCs93wA80ZK
         b4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgMNc1/p3kWYBlyjxsEmMlPIxvpXqHiHcX9JbgUw0hE=;
        b=EaF8sM0TAbDY/24siKulu09sozGI7+lw1LZaRVE0GiUQUPKKxLUEq/gIeepkWgHRnA
         /ZyUK3/PjelZxD3SMYbkmcRbtP/9DQlX072ZfVUeKJ62UY2CMJXH3ymtK3+BbKbUiFGr
         OzapvehS5XJQEys9af9yIe25FYBLAb+2sgqgvYUiP63aTuouHSOpRc1zMZ86nqDn0Zn+
         TnaYy8poRsjjQIu+FfHrx3Ws4dAVTbKCeGUXbp8OygBH3s5m+6W5UdPPe8Xb2rD0zzI4
         BQ1/Uv2b14y93el99wb8lQHR/IGG5NrerK1f5g2C4SF5ALMgvDoF6VPYj9+/FHAhb0f4
         BLgw==
X-Gm-Message-State: ACrzQf1D/a/wJnDcIRBksv7poBrYftSxlpCdvgFjcCK/jby0g8Q3XQ6x
        S4u5OFguXtZymm4fXSJpvug=
X-Google-Smtp-Source: AMsMyM78ugh/Q3fxI7oiGZBbomPmFzisVotLkYNBVKamTAzC9zoHFV6Ic+Cz0oV6LOcWkG8KZ32Etg==
X-Received: by 2002:a65:49c9:0:b0:462:9ce1:3f58 with SMTP id t9-20020a6549c9000000b004629ce13f58mr3319538pgs.200.1665729723243;
        Thu, 13 Oct 2022 23:42:03 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t23-20020a656097000000b00434272fe870sm730080pgu.88.2022.10.13.23.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 23:42:02 -0700 (PDT)
Message-ID: <8007659a-6c6c-2c5e-f500-652ed31448fb@gmail.com>
Date:   Fri, 14 Oct 2022 14:41:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 1/4] KVM: x86/pmu: Force reprogramming of all counters on
 PMU filter change
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220923001355.3741194-1-seanjc@google.com>
 <20220923001355.3741194-2-seanjc@google.com>
 <86d88222-a70f-49ef-71f3-a7d15ae17d7d@gmail.com>
 <Y0h6x0ZJWYH56Z88@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y0h6x0ZJWYH56Z88@google.com>
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

On 14/10/2022 4:53 am, Sean Christopherson wrote:
> On Thu, Oct 13, 2022, Like Xu wrote:
>> Firstly, thanks for your comments that spewed out around vpmu.
>>
>> On 23/9/2022 8:13 am, Sean Christopherson wrote:
>>> Force vCPUs to reprogram all counters on a PMU filter change to provide
>>> a sane ABI for userspace.  Use the existing KVM_REQ_PMU to do the
>>> programming, and take advantage of the fact that the reprogram_pmi bitmap
>>> fits in a u64 to set all bits in a single atomic update.  Note, setting
>>> the bitmap and making the request needs to be done _after_ the SRCU
>>> synchronization to ensure that vCPUs will reprogram using the new filter.
>>>
>>> KVM's current "lazy" approach is confusing and non-deterministic.  It's
>>
>> The resolute lazy approach was introduced in patch 03, right after this change.
> 
> This is referring to the lazy recognition of the filter, not the deferred
> reprogramming of the counters.  Regardless of whether reprogramming is handled
> via request or in-line, KVM is still lazily recognizing the new filter as vCPUs
> won't picke up the new filter until the _guest_ triggers a refresh.

It may still be too late for the pmu filter to take effect. To eliminate this 
"non-deterministic",
should we kick out all vpmu-enabled vcpus right after making KVM_REQ_PMU requests ?

> 
>>> @@ -613,9 +615,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>>>    	mutex_lock(&kvm->lock);
>>>    	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
>>>    				     mutex_is_locked(&kvm->lock));
>>> -	mutex_unlock(&kvm->lock);
>>> -
>>>    	synchronize_srcu_expedited(&kvm->srcu);
>>
>> The relative order of these two operations has been reversed
>> 	mutex_unlock() and synchronize_srcu_expedited()
>> , extending the execution window of the critical area of "kvm->lock)".
>> The motivation is also not explicitly stated in the commit message.
> 
> I'll add a blurb, after I re-convince myself that the sync+request needs to be
> done under kvm->lock.
> 
>>> +	BUILD_BUG_ON(sizeof(((struct kvm_pmu *)0)->reprogram_pmi) >
>>> +		     sizeof(((struct kvm_pmu *)0)->__reprogram_pmi));
>>> +
>>> +	kvm_for_each_vcpu(i, vcpu, kvm)
>>> +		atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi, -1ull);
>>
>> How about:
>> 	bitmap_copy(pmu->reprogram_pmi, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>> to avoid further cycles on calls of
>> "static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit)" ?
> 
> bitmap_copy() was my first choice too, but unfortunately it's doesn't guarantee
> atomicity and could lead to data corruption if the target vCPU is concurrently
> modifying the bitmap.

Indeed, it may help to reuse "pmu->global_ctrl_mask" instead of "-1ull":

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4504987cbbe2..8e279f816e27 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -621,7 +621,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void 
__user *argp)
  		     sizeof(((struct kvm_pmu *)0)->__reprogram_pmi));

  	kvm_for_each_vcpu(i, vcpu, kvm)
-		atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi, -1ull);
+		atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi,
+			     pmu->global_ctrl_mask);

  	kvm_make_all_cpus_request(kvm, KVM_REQ_PMU);

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b68956299fa8..a946c1c57e1d 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -185,6 +185,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
  	pmu->nr_arch_fixed_counters = 0;
  	pmu->global_status = 0;
  	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+	pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
  }

  static void amd_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.38.0
