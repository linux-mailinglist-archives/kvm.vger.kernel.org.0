Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D70B62EECF
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 09:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbiKRIAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 03:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241034AbiKRIAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 03:00:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CAF12AA0
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 00:00:10 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ND8MQ4WrPzRpPb;
        Fri, 18 Nov 2022 15:59:46 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 16:00:08 +0800
Subject: Re: [RFC PATCH 2/3] KVM: Avoid re-reading kvm->max_halt_poll_ns
 during halt-polling
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        <wangyuan38@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-3-dmatlack@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <116d140b-61a9-c5d3-b28a-b32f89ed05a2@huawei.com>
Date:   Fri, 18 Nov 2022 16:00:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20221117001657.1067231-3-dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/17 8:16, David Matlack wrote:
> Avoid re-reading kvm->max_halt_poll_ns multiple times during
> halt-polling except when it is explicitly useful, e.g. to check if the
> max time changed across a halt. kvm->max_halt_poll_ns can be changed at
> any time by userspace via KVM_CAP_HALT_POLL.
>
> This bug is unlikely to cause any serious side-effects. In the worst
> case one halt polls for shorter or longer than it should, and then is
> fixed up on the next halt. Furthmore, this is still possible since
s/Furthmore/Furthermore
> kvm->max_halt_poll_ns are not synchronized with halts.
>
> Fixes: acd05785e48c ("kvm: add capability for halt polling")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   virt/kvm/kvm_main.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
Looks good to me:
Reviewed-by: Yanan Wang <wangyanan55@huawei.com>

Thanks,
Yanan
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4b868f33c45d..78caf19608eb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3488,6 +3488,11 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   	}
>   }
>   
> +static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
> +{
> +	return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
> +}
> +
>   /*
>    * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
>    * polling is enabled, busy wait for a short time before blocking to avoid the
> @@ -3496,14 +3501,15 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>    */
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
> +	unsigned int max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
>   	ktime_t start, cur, poll_end;
>   	bool waited = false;
>   	bool do_halt_poll;
>   	u64 halt_ns;
>   
> -	if (vcpu->halt_poll_ns > vcpu->kvm->max_halt_poll_ns)
> -		vcpu->halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
> +	if (vcpu->halt_poll_ns > max_halt_poll_ns)
> +		vcpu->halt_poll_ns = max_halt_poll_ns;
>   
>   	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>   
> @@ -3545,18 +3551,21 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   		update_halt_poll_stats(vcpu, start, poll_end, !waited);
>   
>   	if (halt_poll_allowed) {
> +		/* Recompute the max halt poll time in case it changed. */
> +		max_halt_poll_ns = kvm_vcpu_max_halt_poll_ns(vcpu);
> +
>   		if (!vcpu_valid_wakeup(vcpu)) {
>   			shrink_halt_poll_ns(vcpu);
> -		} else if (vcpu->kvm->max_halt_poll_ns) {
> +		} else if (max_halt_poll_ns) {
>   			if (halt_ns <= vcpu->halt_poll_ns)
>   				;
>   			/* we had a long block, shrink polling */
>   			else if (vcpu->halt_poll_ns &&
> -				 halt_ns > vcpu->kvm->max_halt_poll_ns)
> +				 halt_ns > max_halt_poll_ns)
>   				shrink_halt_poll_ns(vcpu);
>   			/* we had a short halt and our poll time is too small */
> -			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -				 halt_ns < vcpu->kvm->max_halt_poll_ns)
> +			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
> +				 halt_ns < max_halt_poll_ns)
>   				grow_halt_poll_ns(vcpu);
>   		} else {
>   			vcpu->halt_poll_ns = 0;

