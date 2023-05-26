Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6420712513
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 12:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbjEZKxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 06:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjEZKxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 06:53:03 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F238DF7
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 03:52:59 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2V44-006Vtl-UK
        for kvm@vger.kernel.org; Fri, 26 May 2023 12:52:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:Subject:From:MIME-Version:Date:Message-ID;
        bh=cp9HTZCElCPDmNw+paChi2Ljkl14tPe4MS0ZkEb288c=; b=dKeAWoRytukvmCR2ez9bNiSW/p
        CGqO9/Sn4qlYEgTEkIs2q7y0G6qIU6ajdaFEGKlC5xSW9eKMxEGqQdkcDzmYTn+XBiuW9CqrDDqjX
        ACUQRnUo1GjyNI+9xkaWeErOCQZrLOYGBraSJ5yd/oscXdEtTEel7ZHYWFaC+A5u70hVViOh/+K+F
        CRXpI9TXCygugJ8oDiS9vagzhiwpMOEJgvlxf+RnYMzWXQqPhgj24lPD1LtFaHoAP4bnrRZvVvn3V
        vrSs/kL/nF4hvL3ZrN8bBLKqMWoOCuvI72heDN5q80Xuo2HH1hVd4ktAkCA1gvsYpKWYMQJMpitha
        AIFpY3gA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2V44-00071u-A3; Fri, 26 May 2023 12:52:56 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2V3o-0001mV-MU; Fri, 26 May 2023 12:52:40 +0200
Message-ID: <016686aa-fedc-08bf-df42-9451bba9f82e@rbox.co>
Date:   Fri, 26 May 2023 12:52:39 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
From:   Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 1/3] KVM: x86: Fix out-of-bounds access in
 kvm_recalculate_phys_map()
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
References: <20230525183347.2562472-1-mhal@rbox.co>
 <20230525183347.2562472-2-mhal@rbox.co> <ZG/4UN2VpZ1a6ek1@google.com>
Content-Language: pl-PL
In-Reply-To: <ZG/4UN2VpZ1a6ek1@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/26/23 02:07, Sean Christopherson wrote:
> On Thu, May 25, 2023, Michal Luczaj wrote:
>> @@ -265,10 +265,14 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
>>  		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
>>  		 * map requires a strict 1:1 mapping between IDs and vCPUs.
>>  		 */
>> -		if (apic_x2apic_mode(apic))
>> +		if (apic_x2apic_mode(apic)) {
>> +			if (x2apic_id > new->max_apic_id)
>> +				return -EINVAL;
> 
> Hmm, disabling the optimized map just because userspace created a new vCPU is
> unfortunate and unnecessary.  Rather than return -EINVAL and only perform the
> check when x2APIC is enabled, what if we instead do the check immediately and
> return -E2BIG?  Then the caller can retry with a bigger array size.  Preemption
> is enabled and retries are bounded by the number of possible vCPUs, so I don't
> see any obvious issues with retrying.

Right, that makes perfect sense.

Just a note, it changes the logic a bit:

- x2apic_format: an overflowing x2apic_id won't be silently ignored.

- !x2apic_format: -E2BIG even for !apic_x2apic_mode() leads to an realloc
instead of "new->phys_map[xapic_id] = apic" right away.

> @@ -228,6 +228,12 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
>  	u32 xapic_id = kvm_xapic_id(apic);
>  	u32 physical_id;
>  
> +	if (WARN_ON_ONCE(xapic_id >= new->max_apic_id))
> +		return -EINVAL;

Shouldn't it be ">" instead of ">="?

That said, xapic_id > new->max_apic_id means something terrible has happened as
kvm_xapic_id() returns u8 and max_apic_id should never be less than 255. Does
this qualify for KVM_BUG_ON?

> +	if (x2apic_id >= new->max_apic_id)
> +		return -E2BIG;

Probably ">"?

> @@ -366,6 +371,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  	unsigned long i;
>  	u32 max_id = 255; /* enough space for any xAPIC ID */
>  	bool xapic_id_mismatch = false;
> +	int r;
>  
>  	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
>  	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
> @@ -386,6 +392,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		return;
>  	}
>  
> +retry:
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		if (kvm_apic_present(vcpu))
>  			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
> @@ -404,9 +411,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		if (!kvm_apic_present(vcpu))
>  			continue;
>  
> -		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
> +		r = kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch);
> +		if (r) {
>  			kvfree(new);
>  			new = NULL;
> +			if (r == -E2BIG)
> +				goto retry;
> +
>  			goto out;
>  		}

Maybe it's not important, but what about moving xapic_id_mismatch
(re)initialization after "retry:"?
