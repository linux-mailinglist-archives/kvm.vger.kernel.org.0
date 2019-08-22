Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD2990FC
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbfHVKhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:37:11 -0400
Received: from foss.arm.com ([217.140.110.172]:43452 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfHVKhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:37:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF26615AD;
        Thu, 22 Aug 2019 03:37:09 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4D2C3F246;
        Thu, 22 Aug 2019 03:37:07 -0700 (PDT)
Subject: Re: [PATCH v3 04/10] KVM: Implement kvm_put_guest()
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
 <20190821153656.33429-5-steven.price@arm.com>
 <20190822112930.000052db@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <003f509f-964b-2af0-d5da-1155fb4ec9d6@arm.com>
Date:   Thu, 22 Aug 2019 11:37:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822112930.000052db@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2019 11:29, Jonathan Cameron wrote:
> On Wed, 21 Aug 2019 16:36:50 +0100
> Steven Price <steven.price@arm.com> wrote:
> 
>> kvm_put_guest() is analogous to put_user() - it writes a single value to
>> the guest physical address. The implementation is built upon put_user()
>> and so it has the same single copy atomic properties.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  include/linux/kvm_host.h | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index fcb46b3374c6..e154a1897e20 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -746,6 +746,30 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>>  				  unsigned long len);
>>  int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>>  			      gpa_t gpa, unsigned long len);
>> +
>> +#define __kvm_put_guest(kvm, gfn, offset, value, type)			\
>> +({									\
>> +	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
>> +	type __user *__uaddr = (type __user *)(__addr + offset);	\
>> +	int __ret = 0;							\
> 
> Why initialize __ret?

Good question. Actually looking at this again if I reorder this to be
pessimistic I can make it shorter:

	int __ret = -EFAULT;

	if (!kvm_is_error_hva(__addr))
		__ret = put_user(value, __uaddr);
	if (!__ret)
		mark_page_dirty(kvm, gfn);				
	__ret;

Thanks for taking a look.

Steve

>> +									\
>> +	if (kvm_is_error_hva(__addr))					\
>> +		__ret = -EFAULT;					\
>> +	else								\
>> +		__ret = put_user(value, __uaddr);			\
>> +	if (!__ret)							\
>> +		mark_page_dirty(kvm, gfn);				\
>> +	__ret;								\
>> +})
>> +
>> +#define kvm_put_guest(kvm, gpa, value, type)				\
>> +({									\
>> +	gpa_t __gpa = gpa;						\
>> +	struct kvm *__kvm = kvm;					\
>> +	__kvm_put_guest(__kvm, __gpa >> PAGE_SHIFT,			\
>> +			offset_in_page(__gpa), (value), type);		\
>> +})
>> +
>>  int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
>>  int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
>>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

