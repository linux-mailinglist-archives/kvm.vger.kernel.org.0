Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4840F991C8
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 13:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388153AbfHVLL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 07:11:59 -0400
Received: from foss.arm.com ([217.140.110.172]:44044 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbfHVLL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 07:11:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47D2A344;
        Thu, 22 Aug 2019 04:11:58 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DA7D3F246;
        Thu, 22 Aug 2019 04:11:56 -0700 (PDT)
Subject: Re: [PATCH v3 07/10] KVM: arm64: Provide a PV_TIME device to user
 space
To:     Jonathan Cameron <jonathan.cameron@huawei.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-8-steven.price@arm.com>
 <20190822115722.00005aa7@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <87bc2a01-8cf5-5161-45f8-00384775cf3a@arm.com>
Date:   Thu, 22 Aug 2019 12:11:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822115722.00005aa7@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2019 11:57, Jonathan Cameron wrote:
> On Wed, 21 Aug 2019 16:36:53 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> Allow user space to inform the KVM host where in the physical memory
>> map the paravirtualized time structures should be located.
>>
>> A device is created which provides the base address of an array of
>> Stolen Time (ST) structures, one for each VCPU. There must be (64 *
>> total number of VCPUs) bytes of memory available at this location.
>>
>> The address is given in terms of the physical address visible to
>> the guest and must be page aligned. The guest will discover the address
>> via a hypercall.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> Hi Steven,
> 
> One general question inline.  I'm not particularly familiar with this area
> of the kernel, so maybe I'm missing something obvious, but having
> .destroy free the kvm_device which wasn't created in .create seems
> 'unusual'. 
> 
> Otherwise, FWIW looks good to me.
> 
> Jonathan
> 
[...]
>> +static void kvm_arm_pvtime_destroy(struct kvm_device *dev)
>> +{
>> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
>> +
>> +	pvtime->st_base = GPA_INVALID;
>> +	kfree(dev);
> 
> Nothing to do with your patch as such... All users do the same.
> 
> This seems miss balanced. Why do we need to free the device by hand
> when we didn't create it in the create function?  I appreciate
> the comments say this is needed, but as far as I can see every
> single callback does kfree(dev) at the end which seems an
> odd thing to do.

Yes I think this is odd too - indeed when I initially wrote this I
missed off the kfree() call and had to track down the memory leak.

When I looked into potentially tiding this up I found some other
oddities, e.g. "kvm-xive" (arch/powerpc/kvm/book3s_xive.c) doesn't have
a destroy callback. But I can't see anything in the common code which
deals with that case. So I decided to just "go with the flow" at the
moment, since I don't understand how some of these existing devices work
(perhaps they are already broken?).

Steve

>> +}
>> +
>> +static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
>> +				   struct kvm_device_attr *attr)
>> +{
>> +	struct kvm *kvm = dev->kvm;
>> +	struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
>> +	u64 __user *user = (u64 __user *)attr->addr;
>> +	struct kvm_dev_arm_st_region region;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_PV_TIME_REGION:
>> +		if (copy_from_user(&region, user, sizeof(region)))
>> +			return -EFAULT;
>> +		if (region.gpa & ~PAGE_MASK)
>> +			return -EINVAL;
>> +		if (region.size & ~PAGE_MASK)
>> +			return -EINVAL;
>> +		switch (attr->attr) {
>> +		case KVM_DEV_ARM_PV_TIME_ST:
>> +			if (pvtime->st_base != GPA_INVALID)
>> +				return -EEXIST;
>> +			pvtime->st_base = region.gpa;
>> +			pvtime->st_size = region.size;
>> +			return 0;
>> +		}
>> +		break;
>> +	}
>> +	return -ENXIO;
>> +}
>> +
>> +static int kvm_arm_pvtime_get_attr(struct kvm_device *dev,
>> +				   struct kvm_device_attr *attr)
>> +{
>> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
>> +	u64 __user *user = (u64 __user *)attr->addr;
>> +	struct kvm_dev_arm_st_region region;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_PV_TIME_REGION:
>> +		switch (attr->attr) {
>> +		case KVM_DEV_ARM_PV_TIME_ST:
>> +			region.gpa = pvtime->st_base;
>> +			region.size = pvtime->st_size;
>> +			if (copy_to_user(user, &region, sizeof(region)))
>> +				return -EFAULT;
>> +			return 0;
>> +		}
>> +		break;
>> +	}
>> +	return -ENXIO;
>> +}
>> +
>> +static int kvm_arm_pvtime_has_attr(struct kvm_device *dev,
>> +				   struct kvm_device_attr *attr)
>> +{
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_PV_TIME_REGION:
>> +		switch (attr->attr) {
>> +		case KVM_DEV_ARM_PV_TIME_ST:
>> +			return 0;
>> +		}
>> +		break;
>> +	}
>> +	return -ENXIO;
>> +}
>> +
>> +static const struct kvm_device_ops pvtime_ops = {
>> +	"Arm PV time",
>> +	.create = kvm_arm_pvtime_create,
>> +	.destroy = kvm_arm_pvtime_destroy,
>> +	.set_attr = kvm_arm_pvtime_set_attr,
>> +	.get_attr = kvm_arm_pvtime_get_attr,
>> +	.has_attr = kvm_arm_pvtime_has_attr
>> +};
>> +
>> +void kvm_pvtime_init(void)
>> +{
>> +	kvm_register_device_ops(&pvtime_ops, KVM_DEV_TYPE_ARM_PV_TIME);
>> +}
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

