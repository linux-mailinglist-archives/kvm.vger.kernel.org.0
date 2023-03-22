Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED67D6C49AE
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCVLv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCVLv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:51:26 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25EF71BD2;
        Wed, 22 Mar 2023 04:51:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D05F9AD7;
        Wed, 22 Mar 2023 04:52:08 -0700 (PDT)
Received: from [10.57.53.137] (unknown [10.57.53.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDC243F93E;
        Wed, 22 Mar 2023 04:51:21 -0700 (PDT)
Message-ID: <3f4dcc1e-7679-0f7c-44ef-6b0824400259@arm.com>
Date:   Wed, 22 Mar 2023 11:51:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 16/28] arm64: RME: Allow populating initial contents
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
 <20230127112932.38045-17-steven.price@arm.com>
 <20230306193439.000048f2@gmail.com>
 <6c6ff608-2314-a49a-84ee-fac883c4e227@arm.com>
 <20230314173121.00006cfb@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230314173121.00006cfb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/03/2023 15:31, Zhi Wang wrote:
> On Fri, 10 Mar 2023 15:47:16 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> On 06/03/2023 17:34, Zhi Wang wrote:
>>> On Fri, 27 Jan 2023 11:29:20 +0000
>>> Steven Price <steven.price@arm.com> wrote:

<snip>

>>>> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>>>> +		return -EBUSY;  
>>>
>>> Maybe -EINVAL? The realm hasn't been created (RMI_REALM_CREATE is not called
>>> yet). The userspace shouldn't reach this path.  
>>
>> Well user space can attempt to populate in the ACTIVE state - which is
>> where the idea of 'busy' comes from. Admittedly it's a little confusing
>> when RMI_REALM_CREATE hasn't been called.
>>
>> I'm not particularly bothered about the return code, but it's useful to
>> have a different code to -EINVAL as it's not an invalid argument, but
>> calling at the wrong time. I can't immediately see a better error code
>> though.
>>
> The reason why I feel -EBUSY is little bit off is EBUSY usually indicates
> something is already initialized and currently running, then another
> calling path wanna to operate it. 
> 
> I took a look on the ioctls in arch/arm64/kvm/arm.c. It seems people have
> different opinions for calling execution path at a wrong time:
> 
> For example:
> 
> long kvm_arch_vcpu_ioctl()
> ...
>         case KVM_GET_REG_LIST: {
>                 struct kvm_reg_list __user *user_list = argp;
>                 struct kvm_reg_list reg_list;
>                 unsigned n;
> 
>                 r = -ENOEXEC;
>                 if (unlikely(!kvm_vcpu_initialized(vcpu)))
>                         break;
> 
>                 r = -EPERM;
>                 if (!kvm_arm_vcpu_is_finalized(vcpu))
>                         break;
> 
> If we have to choose one, I prefer -ENOEXEC as -EPERM is stranger. But
> personally my vote goes to -EINVAL.

Ok, I think you've convinced me - I'll change to -EINVAL. It is invalid
use of the API and none of the other error codes seem a great fit.

Although I do wish Linux had more descriptive error codes - I often end
up peppering the kernel with a few printks when using a new API to find
out what I'm doing wrong.

Steve

>> Steve
>>
>>>> +
>>>> +	if (!IS_ALIGNED(args->populate_ipa_base, PAGE_SIZE) ||
>>>> +	    !IS_ALIGNED(args->populate_ipa_size, PAGE_SIZE))
>>>> +		return -EINVAL;
>>>> +
>>>> +	ipa_base = args->populate_ipa_base;
>>>> +	ipa_end = ipa_base + args->populate_ipa_size;
>>>> +
>>>> +	if (ipa_end < ipa_base)
>>>> +		return -EINVAL;
>>>> +
>>>> +	return populate_par_region(kvm, ipa_base, ipa_end);
>>>> +}
>>>> +
>>>>  static int set_ipa_state(struct kvm_vcpu *vcpu,
>>>>  			 unsigned long ipa,
>>>>  			 unsigned long end,
>>>> @@ -748,6 +1102,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>>>  		r = kvm_init_ipa_range_realm(kvm, &args);
>>>>  		break;
>>>>  	}
>>>> +	case KVM_CAP_ARM_RME_POPULATE_REALM: {
>>>> +		struct kvm_cap_arm_rme_populate_realm_args args;
>>>> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
>>>> +
>>>> +		if (copy_from_user(&args, argp, sizeof(args))) {
>>>> +			r = -EFAULT;
>>>> +			break;
>>>> +		}
>>>> +
>>>> +		r = kvm_populate_realm(kvm, &args);
>>>> +		break;
>>>> +	}
>>>>  	default:
>>>>  		r = -EINVAL;
>>>>  		break;  
>>>   
>>
> 

