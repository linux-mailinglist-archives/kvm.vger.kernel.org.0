Return-Path: <kvm+bounces-58977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 725D1BA8D90
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 023121C09DB
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C942FB615;
	Mon, 29 Sep 2025 10:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BqBblMkL"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF02FB614
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 10:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759140961; cv=none; b=RZ9G/QiXJhA3F9oEoMoX/DrfbZ2DRl5sKnIImCaHPx44IwETEKZLPjg5u7DH3fpHtARgQMEygTM+MI2529fEbGChxPBfdx30lrPaptVJDIWC0V1+SzbY20aLQhGEPSLLhxRzPmDh+15yi6qEEo1rFfC/soicRHEmXFatLq5zsok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759140961; c=relaxed/simple;
	bh=YYKtnBG7DvxX4aTBPyhm4b+c2rtgas+o8iFNzcgvYtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lCRwtrnXrXtGbNZeGlKGcOIZ41Ih2+NUnO/NO8ZZRnEUES5tEKiE//1NCpVvMHWR4iY/78ZLIfoQF1N6FYJVkK89qmWe/TNqNWOthARX7aPhPcVVOLk9BPWhluU2YmgkMuXKhnGqjMfobUWgHTLdfNurDkmGkq715uTxRTb68ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BqBblMkL; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759140957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HwnJt8i9Iujn1Yt70yEqGIwxGoXk6PzwRTGqmZBuEhQ=;
	b=BqBblMkL0mPwfSTpqlxysaRrshHH3+KjeoE+mf9gTvi5Z//0AKEkyjXDfviGDUBs6+4LQV
	cRDTsaGXn2WgMZnbwk35t0ZbYVbV9jhTM4PSGyj54M9v4xhGWTafEIJ7R93jjg+JW9YKNR
	GJKPxxdsfVEWsZm/8T4PRgJ7OaV4km0=
Date: Mon, 29 Sep 2025 11:15:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, shivankg@amd.com
References: <20250926163114.2626257-1-seanjc@google.com>
 <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Patrick Roy <patrick.roy@linux.dev>
Content-Language: en-US
In-Reply-To: <diqz7bxh386h.fsf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Ackerley!

On Mon, 2025-09-29 at 10:43 +0100, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
>> Hi Sean,
>>
>> On Fri, 26 Sept 2025 at 17:31, Sean Christopherson <seanjc@google.com> wrote:
>>>
>>> Add a guest_memfd flag to allow userspace to state that the underlying
>>> memory should be configured to be shared by default, and reject user page
>>> faults if the guest_memfd instance's memory isn't shared by default.
>>> Because KVM doesn't yet support in-place private<=>shared conversions, all
>>> guest_memfd memory effectively follows the default state.
>>>
>>> Alternatively, KVM could deduce the default state based on MMAP, which for
>>> all intents and purposes is what KVM currently does.  However, implicitly
>>> deriving the default state based on MMAP will result in a messy ABI when
>>> support for in-place conversions is added.
>>>
>>> For x86 CoCo VMs, which don't yet support MMAP, memory is currently private
>>> by default (otherwise the memory would be unusable).  If MMAP implies
>>> memory is shared by default, then the default state for CoCo VMs will vary
>>> based on MMAP, and from userspace's perspective, will change when in-place
>>> conversion support is added.  I.e. to maintain guest<=>host ABI, userspace
>>> would need to immediately convert all memory from shared=>private, which
>>> is both ugly and inefficient.  The inefficiency could be avoided by adding
>>> a flag to state that memory is _private_ by default, irrespective of MMAP,
>>> but that would lead to an equally messy and hard to document ABI.
>>>
>>> Bite the bullet and immediately add a flag to control the default state so
>>> that the effective behavior is explicit and straightforward.
>>>
> 
> I like having this flag, but didn't propose this because I thought folks
> depending on the default being shared (Patrick/Nikita) might have their
> usage broken.

We'll just need to pass the new flag in Firecracker, that's not a problem
at all :) We aren't running this anywhere in production yet, so nothing
would break on our end.

>>> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Fuad Tabba <tabba@google.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>  Documentation/virt/kvm/api.rst                 | 10 ++++++++--
>>>  include/uapi/linux/kvm.h                       |  3 ++-
>>>  tools/testing/selftests/kvm/guest_memfd_test.c |  5 +++--
>>>  virt/kvm/guest_memfd.c                         |  6 +++++-
>>>  4 files changed, 18 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index c17a87a0a5ac..4dfe156bbe3c 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -6415,8 +6415,14 @@ guest_memfd range is not allowed (any number of memory regions can be bound to
>>>  a single guest_memfd file, but the bound ranges must not overlap).
>>>
>>>  When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>>> -supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>>> -enables mmap() and faulting of guest_memfd memory to host userspace.
>>> +supports GUEST_MEMFD_FLAG_MMAP and  GUEST_MEMFD_FLAG_DEFAULT_SHARED.  Setting
>>
>> There's an extra space between `and` and `GUEST_MEMFD_FLAG_DEFAULT_SHARED`.
>>
> 
> +1 on this. Also, would you consider putting the concept of "at creation
> time" or "at initialization time" into the name of the flag?
> 
> "Default" could be interpreted as "whenever a folio is allocated for
> this guest_memfd", the memory the folio represents is by default
> shared.
> 
> What we want to represent is that when the guest_memfd is created,
> memory at all indices are initialized as shared.
> 
> Looking a bit further, when conversion is supported, if this flag is not
> specified, then all the indices are initialized as private, right?
> 
>>> +the MMAP flag on guest_memfd creation enables mmap() and faulting of guest_memfd
>>> +memory to host userspace (so long as the memory is currently shared).  Setting
>>> +DEFAULT_SHARED makes all guest_memfd memory shared by default (versus private
>>> +by default).  Note!  Because KVM doesn't yet support in-place private<=>shared
>>> +conversions, DEFAULT_SHARED must be specified in order to fault memory into
>>> +userspace page tables.  This limitation will go away when in-place conversions
>>> +are supported.
>>
>> I think that a more accurate (and future proof) description of the
>> mmap flag could be something along the lines of:
>>
> 
> +1 on these suggestions, I agree that making the concepts of SHARED vs
> MMAP orthogonal from the start is more future proof.
> 
>> + Setting GUEST_MEMFD_FLAG_MMAP enables using mmap() on the file descriptor.
>>
>> + Setting GUEST_MEMFD_FLAG_DEFAULT_SHARED makes all memory in the file shared
>> + by default
> 
> See above, I'd prefer clarifying this as "at initialization time" or
> something similar.
> 
>> , as opposed to private. Shared memory can be faulted into host
>> + userspace page tables. Private memory cannot.
>>
>>>  When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>>>  guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index 6efa98a57ec1..38a2c083b6aa 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -1599,7 +1599,8 @@ struct kvm_memory_attributes {
>>>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>>>
>>>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>>> -#define GUEST_MEMFD_FLAG_MMAP  (1ULL << 0)
>>> +#define GUEST_MEMFD_FLAG_MMAP          (1ULL << 0)
>>> +#define GUEST_MEMFD_FLAG_DEFAULT_SHARED        (1ULL << 1)
>>>
>>>  struct kvm_create_guest_memfd {
>>>         __u64 size;
>>> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
>>> index b3ca6737f304..81b11a958c7a 100644
>>> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
>>> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
>>> @@ -274,7 +274,7 @@ static void test_guest_memfd(unsigned long vm_type)
>>>         vm = vm_create_barebones_type(vm_type);
>>>
>>>         if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
>>> -               flags |= GUEST_MEMFD_FLAG_MMAP;
>>> +               flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>>>
>>>         test_create_guest_memfd_multiple(vm);
>>>         test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
>>> @@ -337,7 +337,8 @@ static void test_guest_memfd_guest(void)
>>>                     "Default VM type should always support guest_memfd mmap()");
>>>
>>>         size = vm->page_size;
>>> -       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
>>> +       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
>>> +                                            GUEST_MEMFD_FLAG_DEFAULT_SHARED);
>>>         vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
>>>
>>>         mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 08a6bc7d25b6..19f05a45be04 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -328,6 +328,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>         if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>>>                 return VM_FAULT_SIGBUS;
>>>
>>> +       if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_DEFAULT_SHARED))
>>> +               return VM_FAULT_SIGBUS;
>>> +
>>>         folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>>         if (IS_ERR(folio)) {
>>>                 int err = PTR_ERR(folio);
>>> @@ -525,7 +528,8 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>>>         u64 valid_flags = 0;
>>>
>>>         if (kvm_arch_supports_gmem_mmap(kvm))
>>> -               valid_flags |= GUEST_MEMFD_FLAG_MMAP;
>>> +               valid_flags |= GUEST_MEMFD_FLAG_MMAP |
>>> +                              GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>>
>> At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
>> GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
>> checking for that, at least until we have in-place conversion? Having
>> only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
>> isn't a useful combination.
>>
> 
> I think it's okay to have the two flags be orthogonal from the start.

I think I dimly remember someone at one of the guest_memfd syncs
bringing up a usecase for having a VMA even if all memory is private,
not for faulting anything in, but to do madvise or something? Maybe it
was the NUMA stuff? (+Shivank)

So for that, having the flags be orthogonal would be useful even without
conversion support.

> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> 
>> That said, these are all nits, I'll leave it to you. With that:
>>
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Tested-by: Fuad Tabba <tabba@google.com>
>>
>> Cheers,
>> /fuad
>>
>>
>>
>>>
>>>         if (flags & ~valid_flags)
>>>                 return -EINVAL;
>>> --
>>> 2.51.0.536.g15c5d4f767-goog
>>>

Best,
Patrick

