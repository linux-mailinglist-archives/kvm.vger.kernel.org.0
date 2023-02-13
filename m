Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC788694BDF
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 16:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjBMP7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 10:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjBMP7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 10:59:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1DD3170B;
        Mon, 13 Feb 2023 07:59:11 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 840444B3;
        Mon, 13 Feb 2023 07:59:53 -0800 (PST)
Received: from [10.57.13.51] (unknown [10.57.13.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CC353F703;
        Mon, 13 Feb 2023 07:59:07 -0800 (PST)
Message-ID: <748a6bcf-ec16-0870-8e33-bc29ab311211@arm.com>
Date:   Mon, 13 Feb 2023 15:59:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 04/28] arm64: RME: Check for RME support at KVM init
Content-Language: en-GB
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-5-steven.price@arm.com>
 <20230213174846.00003fad@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230213174846.00003fad@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/2023 15:48, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:08 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h | 17 ++++++++++
>>  arch/arm64/include/asm/kvm_host.h    |  4 +++
>>  arch/arm64/include/asm/kvm_rme.h     | 22 +++++++++++++
>>  arch/arm64/include/asm/virt.h        |  1 +
>>  arch/arm64/kvm/Makefile              |  3 +-
>>  arch/arm64/kvm/arm.c                 |  8 +++++
>>  arch/arm64/kvm/rme.c                 | 49 ++++++++++++++++++++++++++++
>>  7 files changed, 103 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>  create mode 100644 arch/arm64/kvm/rme.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 9bdba47f7e14..5a2b7229e83f 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -490,4 +490,21 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
>>  	return test_bit(feature, vcpu->arch.features);
>>  }
>>  
>> +static inline bool kvm_is_realm(struct kvm *kvm)
>> +{
>> +	if (static_branch_unlikely(&kvm_rme_is_available))
>> +		return kvm->arch.is_realm;
>> +	return false;
>> +}
>> +
>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>> +{
>> +	return READ_ONCE(kvm->arch.realm.state);
>> +}
>> +
>> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 35a159d131b5..04347c3a8c6b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -26,6 +26,7 @@
>>  #include <asm/fpsimd.h>
>>  #include <asm/kvm.h>
>>  #include <asm/kvm_asm.h>
>> +#include <asm/kvm_rme.h>
>>  
>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>>  
>> @@ -240,6 +241,9 @@ struct kvm_arch {
>>  	 * the associated pKVM instance in the hypervisor.
>>  	 */
>>  	struct kvm_protected_vm pkvm;
>> +
>> +	bool is_realm;
>                ^
> It would be better to put more comments which really helps on the review.

Thanks for the feedback - I had thought "is realm" was fairly
self-documenting, but perhaps I've just spent too much time with this code.

> I was looking for the user of this memeber to see when it is set. It seems
> it is not in this patch. It would have been nice to have a quick answer from the
> comments.

The usage is in the kvm_is_realm() function which is used in several of
the later patches as a way to detect this kvm guest is a realm guest.

I think the main issue is that I've got the patches in the wrong other.
Patch 7 "arm64: kvm: Allow passing machine type in KVM creation" should
probably be before this one, then I could add the assignment of is_realm
into this patch (potentially splitting out the is_realm parts into
another patch).

Thanks,

Steve

