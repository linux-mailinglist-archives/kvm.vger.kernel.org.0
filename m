Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841706CB998
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjC1IjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 04:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjC1IjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 04:39:07 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A1D735A1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 01:39:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 066EFC14;
        Tue, 28 Mar 2023 01:39:50 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A75563F73F;
        Tue, 28 Mar 2023 01:39:04 -0700 (PDT)
Message-ID: <a3b900b3-661b-f0ac-807d-d4f4f2ca1e85@arm.com>
Date:   Tue, 28 Mar 2023 09:39:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 03/11] KVM: arm64: Add vm fd device attribute accessors
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-4-oliver.upton@linux.dev>
 <5f7dcec1-eeeb-811b-d9bc-85ecb7c73aa9@arm.com> <ZBngKAqIIyIWTEsB@linux.dev>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZBngKAqIIyIWTEsB@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/03/2023 16:49, Oliver Upton wrote:
> Hi Suzuki,
> 
> On Tue, Mar 21, 2023 at 09:53:06AM +0000, Suzuki K Poulose wrote:
>> On 20/03/2023 22:09, Oliver Upton wrote:
>>> A subsequent change will allow userspace to convey a filter for
>>> hypercalls through a vm device attribute. Add the requisite boilerplate
>>> for vm attribute accessors.
>>>
>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>> ---
>>>    arch/arm64/kvm/arm.c | 29 +++++++++++++++++++++++++++++
>>>    1 file changed, 29 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 3bd732eaf087..b6e26c0e65e5 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -1439,11 +1439,28 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>>>    	}
>>>    }
>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>> +{
>>> +	switch (attr->group) {
>>> +	default:
>>> +		return -ENXIO;
>>> +	}
>>> +}
>>> +
>>> +static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>> +{
>>> +	switch (attr->group) {
>>> +	default:
>>> +		return -ENXIO;
>>> +	}
>>> +}
>>> +
>>>    long kvm_arch_vm_ioctl(struct file *filp,
>>>    		       unsigned int ioctl, unsigned long arg)
>>>    {
>>>    	struct kvm *kvm = filp->private_data;
>>>    	void __user *argp = (void __user *)arg;
>>> +	struct kvm_device_attr attr;
>>>    	switch (ioctl) {
>>>    	case KVM_CREATE_IRQCHIP: {
>>> @@ -1479,6 +1496,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>>    			return -EFAULT;
>>>    		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
>>>    	}
>>> +	case KVM_HAS_DEVICE_ATTR: {
>>> +		if (copy_from_user(&attr, argp, sizeof(attr)))
>>> +			return -EFAULT;
>>> +
>>> +		return kvm_vm_has_attr(kvm, &attr);
>>> +	}
>>> +	case KVM_SET_DEVICE_ATTR: {
>>> +		if (copy_from_user(&attr, argp, sizeof(attr)))
>>> +			return -EFAULT;
>>> +
>>> +		return kvm_vm_set_attr(kvm, &attr);
>>> +	}
>>
>> Is there a reason to exclude KVM_GET_DEVICE_ATTR handling ?
> 
> The GET_DEVICE_ATTR would effectively be dead code, as the hypercall filter is
> a write-only attribute. The filter is constructed through iterative calls to
> the attribute, so conveying the end result to userspace w/ the same UAPI
> is non-trivial.
> 
> Hopefully userspace remembers what it wrote to the field ;-)

Fair enough. I am thinking of using VM DEVICE_ATTR for some of the Arm
CCA Realm Configuration, which are now overloaded with ENABLE_CAP.

We could add GET_DEVICE_ATTR if and when we need it.

Thanks
Suzuki


> 

