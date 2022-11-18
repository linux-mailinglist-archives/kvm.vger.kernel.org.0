Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804D662EE7B
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 08:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbiKRHei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 02:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiKRHeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 02:34:37 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564A6725C3
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:34:35 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ND7ns3rxFz15Mlc;
        Fri, 18 Nov 2022 15:34:09 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 15:34:33 +0800
Subject: Re: [RFC PATCH 1/3] KVM: Cap vcpu->halt_poll_ns before halting rather
 than after
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        <wangyuan38@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-2-dmatlack@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <53b4d650-ac00-59df-4dee-7f4f7b6656ad@huawei.com>
Date:   Fri, 18 Nov 2022 15:34:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20221117001657.1067231-2-dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
> Cap vcpu->halt_poll_ns based on the max halt polling time just before
> halting, rather than after the last halt. This arguably provides better
> accuracy if an admin disables halt polling in between halts, although
> the improvement is nominal.
>
> A side-effect of this change is that grow_halt_poll_ns() no longer needs
> to access vcpu->kvm->max_halt_poll_ns, which will be useful in a future
> commit where the max halt polling time can come from the module parameter
> halt_poll_ns instead.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   virt/kvm/kvm_main.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..4b868f33c45d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3385,9 +3385,6 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
>   	if (val < grow_start)
>   		val = grow_start;
>   
> -	if (val > vcpu->kvm->max_halt_poll_ns)
> -		val = vcpu->kvm->max_halt_poll_ns;
> -
>   	vcpu->halt_poll_ns = val;
>   out:
>   	trace_kvm_halt_poll_ns_grow(vcpu->vcpu_id, val, old);
> @@ -3500,11 +3497,16 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>   void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> -	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
>   	ktime_t start, cur, poll_end;
>   	bool waited = false;
> +	bool do_halt_poll;
>   	u64 halt_ns;
>   
> +	if (vcpu->halt_poll_ns > vcpu->kvm->max_halt_poll_ns)
> +		vcpu->halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
> +
> +	do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
> +
>   	start = cur = poll_end = ktime_get();
>   	if (do_halt_poll) {
>   		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
Reviewed-by: Yanan Wang <wangyanan55@huawei.com>

Thanks,
Yanan
