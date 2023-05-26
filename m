Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58E4712B9F
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjEZRSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 13:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242487AbjEZRSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 13:18:38 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDF6E6C
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 10:18:03 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q2b4i-0076B4-6r
        for kvm@vger.kernel.org; Fri, 26 May 2023 19:18:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=pZulzih1ofPtyRY9EIJibinm9H5qMQgVw6OZvtCrIO0=; b=TD+6IdJvHhhbAphV/AaB1zOP8K
        pAIUO0MAyiywpRy5dEl0KaOBdekzgFlrQSrrmPlZHJD8YX5rFbs1Ot7Q3D9jbRldIAtAeruDs5sG6
        ukNsmZRLj1252rtpo+b3h8YJ+OexB2P7PLnKMY3N5UkTVeBN9hdeukJAUPPy5YHnWvcpfaJE21P/l
        KPUdVzu/3Gnvu49rCCD7FXZ8Ub85QKcgwlHC1bqpykZ63ZpC83UkdQS1sDFYWwkwD4DKBbEdo9VeK
        T13oavnzpnZnm2WgUQ7GNf3q7zVy8QFVv23dGAHIb44dGvdRbPBDFqqkN2x4Ye9saHtm0TRn3fDAd
        x7oEiukQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q2b4g-0001K9-G2; Fri, 26 May 2023 19:17:59 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q2b4f-0000q0-4r; Fri, 26 May 2023 19:17:57 +0200
Message-ID: <f4c2108d-b5a0-bdee-f354-28ed7e5d4bd5@rbox.co>
Date:   Fri, 26 May 2023 19:17:55 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 1/3] KVM: x86: Fix out-of-bounds access in
 kvm_recalculate_phys_map()
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
References: <20230525183347.2562472-1-mhal@rbox.co>
 <20230525183347.2562472-2-mhal@rbox.co> <ZG/4UN2VpZ1a6ek1@google.com>
 <016686aa-fedc-08bf-df42-9451bba9f82e@rbox.co> <ZHDbos7Kf2aX/zyg@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZHDbos7Kf2aX/zyg@google.com>
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

On 5/26/23 18:17, Sean Christopherson wrote:
> On Fri, May 26, 2023, Michal Luczaj wrote:
>> On 5/26/23 02:07, Sean Christopherson wrote:
>>> On Thu, May 25, 2023, Michal Luczaj wrote:
>>>> @@ -265,10 +265,14 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
>>>>  		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
>>>>  		 * map requires a strict 1:1 mapping between IDs and vCPUs.
>>>>  		 */
>>>> -		if (apic_x2apic_mode(apic))
>>>> +		if (apic_x2apic_mode(apic)) {
>>>> +			if (x2apic_id > new->max_apic_id)
>>>> +				return -EINVAL;
>>>
>>> Hmm, disabling the optimized map just because userspace created a new vCPU is
>>> unfortunate and unnecessary.  Rather than return -EINVAL and only perform the
>>> check when x2APIC is enabled, what if we instead do the check immediately and
>>> return -E2BIG?  Then the caller can retry with a bigger array size.  Preemption
>>> is enabled and retries are bounded by the number of possible vCPUs, so I don't
>>> see any obvious issues with retrying.
>>
>> Right, that makes perfect sense.
>>
>> Just a note, it changes the logic a bit:
>>
>> - x2apic_format: an overflowing x2apic_id won't be silently ignored.
> 
> Nit, I wouldn't describe the current behavior as silently ignored.  KVM doesn't
> ignore the case, KVM instead disables the optimized map.

I may be misusing "silently ignored", but currently if (x2apic_format &&
apic_x2apic_mode && x2apic_id > new->max_apic_id) new->phys_map[x2apic_id]
remains unchanged, then kvm_recalculate_phys_map() returns 0 (not -EINVAL).
I.e. this does not result in rcu_assign_pointer(kvm->arch.apic_map, NULL).

>> That said, xapic_id > new->max_apic_id means something terrible has happened as
>> kvm_xapic_id() returns u8 and max_apic_id should never be less than 255. Does
>> this qualify for KVM_BUG_ON?
> 
> I don't think so?  The intent of the WARN is mostly to document that KVM always
> allocates enough space for xAPIC IDs, and to guard against that changing in the
> future.  In the latter case, there's no need to kill the VM despite there being
> a KVM bug since running with the optimized map disabled is functionally ok.
> 
> If the WARN fires because of host data corruption, then so be it.

Ahh, OK, I get it.

>> Maybe it's not important, but what about moving xapic_id_mismatch
>> (re)initialization after "retry:"?
> 
> Oof, good catch.  I think it makes sense to move max_id (re)initialization too,
> even though I can't imagine it would matter in practice.

Right, I forgot that max APIC ID can decrease along the way.
