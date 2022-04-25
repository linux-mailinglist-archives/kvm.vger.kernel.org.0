Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4651F50E950
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 21:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244894AbiDYTTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiDYTTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 15:19:30 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F10387BC
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:16:16 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id j4BrnYRN3jXpHj4BrnJm6d; Mon, 25 Apr 2022 21:16:15 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 25 Apr 2022 21:16:15 +0200
X-ME-IP: 86.243.180.246
Message-ID: <19a812b3-73b4-7e5a-8885-ec652598a5ce@wanadoo.fr>
Date:   Mon, 25 Apr 2022 21:16:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 07/34] x86/hyperv: Introduce
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
Content-Language: fr
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-8-vkuznets@redhat.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220414132013.1588929-8-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 14/04/2022 à 15:19, Vitaly Kuznetsov a écrit :
> It may not come clear from where the magical '64' value used in
> __cpumask_to_vpset() come from. Moreover, '64' means both the maximum
> sparse bank number as well as the number of vCPUs per bank. Add defines
> to make things clear. These defines are also going to be used by KVM.
> 
> No functional change.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   include/asm-generic/hyperv-tlfs.h |  5 +++++
>   include/asm-generic/mshyperv.h    | 11 ++++++-----
>   2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index fdce7a4cfc6f..020ca9bdbb79 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -399,6 +399,11 @@ struct hv_vpset {
>   	u64 bank_contents[];
>   } __packed;
>   
> +/* The maximum number of sparse vCPU banks which can be encoded by 'struct hv_vpset' */
> +#define HV_MAX_SPARSE_VCPU_BANKS (64)
> +/* The number of vCPUs in one sparse bank */
> +#define HV_VCPUS_PER_SPARSE_BANK (64)
> +
>   /* HvCallSendSyntheticClusterIpi hypercall */
>   struct hv_send_ipi {
>   	u32 vector;
> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
> index c08758b6b364..0abe91df1ef6 100644
> --- a/include/asm-generic/mshyperv.h
> +++ b/include/asm-generic/mshyperv.h
> @@ -214,9 +214,10 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
>   {
>   	int cpu, vcpu, vcpu_bank, vcpu_offset, nr_bank = 1;
>   	int this_cpu = smp_processor_id();
> +	int max_vcpu_bank = hv_max_vp_index / HV_VCPUS_PER_SPARSE_BANK;
>   
> -	/* valid_bank_mask can represent up to 64 banks */
> -	if (hv_max_vp_index / 64 >= 64)
> +	/* vpset.valid_bank_mask can represent up to HV_MAX_SPARSE_VCPU_BANKS banks */
> +	if (max_vcpu_bank >= HV_MAX_SPARSE_VCPU_BANKS)
>   		return 0;
>   
>   	/*
> @@ -224,7 +225,7 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
>   	 * structs are not cleared between calls, we risk flushing unneeded
>   	 * vCPUs otherwise.
>   	 */
> -	for (vcpu_bank = 0; vcpu_bank <= hv_max_vp_index / 64; vcpu_bank++)
> +	for (vcpu_bank = 0; vcpu_bank <= max_vcpu_bank; vcpu_bank++)
>   		vpset->bank_contents[vcpu_bank] = 0;

and here:
	bitmap_clear(vpset->bank_contents, 0, hv_max_vp_index);
or maybe even if it is safe to do so:
	bitmap_zero(vpset->bank_contents, hv_max_vp_index);

CJ

>   
>   	/*
> @@ -236,8 +237,8 @@ static inline int __cpumask_to_vpset(struct hv_vpset *vpset,
>   		vcpu = hv_cpu_number_to_vp_number(cpu);
>   		if (vcpu == VP_INVAL)
>   			return -1;
> -		vcpu_bank = vcpu / 64;
> -		vcpu_offset = vcpu % 64;
> +		vcpu_bank = vcpu / HV_VCPUS_PER_SPARSE_BANK;
> +		vcpu_offset = vcpu % HV_VCPUS_PER_SPARSE_BANK;
>   		__set_bit(vcpu_offset, (unsigned long *)
>   			  &vpset->bank_contents[vcpu_bank]);
>   		if (vcpu_bank >= nr_bank)

