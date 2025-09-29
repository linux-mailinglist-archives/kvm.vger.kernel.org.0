Return-Path: <kvm+bounces-58976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D6FBA8B85
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C24A87B1871
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF11B2D3A70;
	Mon, 29 Sep 2025 09:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4TJxTual"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757DE2D0C73
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759139034; cv=none; b=Z7LS7vMmzVqlw1XQrhgI48Q1ElACfV2tZtOb/aG7yE4xcPaOCB4Cf0w+CITHx1/IWPqPOU8FIMYS83sN07eTkYcm7tFSRA8O9o0YalJUvsJEsR/hpIpvd+wbEvx6MYJa//gh7qPV3WdsDR8nYvmULRLx5qypLb2UROm+lpkC1Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759139034; c=relaxed/simple;
	bh=BU4j3BGpszxu9iYIj3uncGhrBLbWYrE0fXoVD9IaZ6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RzMOGNjQl91dgTbOssgMLhWep4T4FOCu9DBhDip6uS42753yK3UaHvY7KEb6ut8RHJ/96SZz2PnJKjK9RYN0tfkuA8q4usjknw13hCuZWfzlrLdC5/qiAeHdGdCc3MCJrIaSWp2SFpnnzLJPQ9FmxVPQAuzEEHMcPqPaslg6lik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4TJxTual; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33826e101ecso897378a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759139032; x=1759743832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pzYNHWstQT9I1y07+9R6xWtUGyijisMRSVgSKfx26Eg=;
        b=4TJxTualPjMKOYdylTge1EqVJsM4v1UjFUT4IQ6NVicj2F5DsJw44m410994i8x/Mr
         xGksg+E4EZ5tTmfXoTgQtLm9CkEEmqZCtN9ZU3o3f4uimqd150lq5dDa039GgqSyYzdc
         y+Rx0Zw9fASYpl1MXvx4o6VBUuQn0j8uPnRZPUeRBh0fi9BrBW3hsLmSQudyPIpr31KU
         AZT1jc59mjHAoAsXLpLLgovazL1KGWtoA0jX0vhf9N9LHSob8wabpdrtR38AGWPAxt3R
         lNvxqLWtyZabJMk9ZDpfG7buV4t76MWHrnnJqZ20nFPG01rOixyXUjaexivE9Ihdf12b
         w/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759139032; x=1759743832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pzYNHWstQT9I1y07+9R6xWtUGyijisMRSVgSKfx26Eg=;
        b=mrLJcml0SCWMp4BH03A6hm1l1XqBAZ+6QXluCEBQZQvrFYH6UX+NvVt0BTB4mPXDuJ
         7hFEL/Q8Idz6QrJvsaBKCe+f6hGwbTj37op9VFPdBOYCDnXetTBrbXqigrUuUZ6DLW5Z
         z7DyJaEfwjaCC9kd5TiMhb/k+03uGF58wzZUe3YF0CNLSwWE7AaSmwYGnphsUsb6XV+D
         ETCkg8s7fsQa6r1MwswPO/n23jlscs9atG2cw/qVBXlzIO5f3FEhBPlHnwTf55lvYjzU
         akF3fYLpT5fCkK2BzQPpuV6Z6c1gj3K1WJe8AUCZbt0WKjeP+y7lzXzu2TMWTyngn3CP
         2ZBw==
X-Forwarded-Encrypted: i=1; AJvYcCWySxRlk0vV4aRtULgl8A2XKDh3LKsUznCMXiEglj/EcrvlvMaA6MfZDoBLjZ5Y1ESHVr4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6000frB9KaJnHq9I4YDIw4PWbn9xu3luV96JAIe3vKxN8bTCh
	v8DZrMYGtp78PhODXcHWUTvsQjnG1R4Yy2qay+wKVhe1wyH3oJHgRmpJNfh2nJvNEpQome44LwF
	GxcO+zn9e72ykRTbsYDrE8jiNDg==
X-Google-Smtp-Source: AGHT+IFlMDZYgT1aOSvVAdawE5wAq1U1PDfbFgVozsOFcMF3G5UsVb7Ien2ixeifU3Gu0oJJQxAhlNx/Wggb4VwMCA==
X-Received: from pjxu4.prod.google.com ([2002:a17:90a:db44:b0:32e:c813:df48])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2703:b0:335:29a7:70c9 with SMTP id 98e67ed59e1d1-336b3cb3f30mr7869316a91.15.1759139031807;
 Mon, 29 Sep 2025 02:43:51 -0700 (PDT)
Date: Mon, 29 Sep 2025 09:43:50 +0000
In-Reply-To: <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
Message-ID: <diqz7bxh386h.fsf@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, roypat@amazon.co.uk, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Hi Sean,
>
> On Fri, 26 Sept 2025 at 17:31, Sean Christopherson <seanjc@google.com> wrote:
>>
>> Add a guest_memfd flag to allow userspace to state that the underlying
>> memory should be configured to be shared by default, and reject user page
>> faults if the guest_memfd instance's memory isn't shared by default.
>> Because KVM doesn't yet support in-place private<=>shared conversions, all
>> guest_memfd memory effectively follows the default state.
>>
>> Alternatively, KVM could deduce the default state based on MMAP, which for
>> all intents and purposes is what KVM currently does.  However, implicitly
>> deriving the default state based on MMAP will result in a messy ABI when
>> support for in-place conversions is added.
>>
>> For x86 CoCo VMs, which don't yet support MMAP, memory is currently private
>> by default (otherwise the memory would be unusable).  If MMAP implies
>> memory is shared by default, then the default state for CoCo VMs will vary
>> based on MMAP, and from userspace's perspective, will change when in-place
>> conversion support is added.  I.e. to maintain guest<=>host ABI, userspace
>> would need to immediately convert all memory from shared=>private, which
>> is both ugly and inefficient.  The inefficiency could be avoided by adding
>> a flag to state that memory is _private_ by default, irrespective of MMAP,
>> but that would lead to an equally messy and hard to document ABI.
>>
>> Bite the bullet and immediately add a flag to control the default state so
>> that the effective behavior is explicit and straightforward.
>>

I like having this flag, but didn't propose this because I thought folks
depending on the default being shared (Patrick/Nikita) might have their
usage broken.

>> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  Documentation/virt/kvm/api.rst                 | 10 ++++++++--
>>  include/uapi/linux/kvm.h                       |  3 ++-
>>  tools/testing/selftests/kvm/guest_memfd_test.c |  5 +++--
>>  virt/kvm/guest_memfd.c                         |  6 +++++-
>>  4 files changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index c17a87a0a5ac..4dfe156bbe3c 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6415,8 +6415,14 @@ guest_memfd range is not allowed (any number of memory regions can be bound to
>>  a single guest_memfd file, but the bound ranges must not overlap).
>>
>>  When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>> -supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>> -enables mmap() and faulting of guest_memfd memory to host userspace.
>> +supports GUEST_MEMFD_FLAG_MMAP and  GUEST_MEMFD_FLAG_DEFAULT_SHARED.  Setting
>
> There's an extra space between `and` and `GUEST_MEMFD_FLAG_DEFAULT_SHARED`.
>

+1 on this. Also, would you consider putting the concept of "at creation
time" or "at initialization time" into the name of the flag?

"Default" could be interpreted as "whenever a folio is allocated for
this guest_memfd", the memory the folio represents is by default
shared.

What we want to represent is that when the guest_memfd is created,
memory at all indices are initialized as shared.

Looking a bit further, when conversion is supported, if this flag is not
specified, then all the indices are initialized as private, right?

>> +the MMAP flag on guest_memfd creation enables mmap() and faulting of guest_memfd
>> +memory to host userspace (so long as the memory is currently shared).  Setting
>> +DEFAULT_SHARED makes all guest_memfd memory shared by default (versus private
>> +by default).  Note!  Because KVM doesn't yet support in-place private<=>shared
>> +conversions, DEFAULT_SHARED must be specified in order to fault memory into
>> +userspace page tables.  This limitation will go away when in-place conversions
>> +are supported.
>
> I think that a more accurate (and future proof) description of the
> mmap flag could be something along the lines of:
>

+1 on these suggestions, I agree that making the concepts of SHARED vs
MMAP orthogonal from the start is more future proof.

> + Setting GUEST_MEMFD_FLAG_MMAP enables using mmap() on the file descriptor.
>
> + Setting GUEST_MEMFD_FLAG_DEFAULT_SHARED makes all memory in the file shared
> + by default

See above, I'd prefer clarifying this as "at initialization time" or
something similar.

> , as opposed to private. Shared memory can be faulted into host
> + userspace page tables. Private memory cannot.
>
>>  When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>>  guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 6efa98a57ec1..38a2c083b6aa 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1599,7 +1599,8 @@ struct kvm_memory_attributes {
>>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>>
>>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>> -#define GUEST_MEMFD_FLAG_MMAP  (1ULL << 0)
>> +#define GUEST_MEMFD_FLAG_MMAP          (1ULL << 0)
>> +#define GUEST_MEMFD_FLAG_DEFAULT_SHARED        (1ULL << 1)
>>
>>  struct kvm_create_guest_memfd {
>>         __u64 size;
>> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
>> index b3ca6737f304..81b11a958c7a 100644
>> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
>> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
>> @@ -274,7 +274,7 @@ static void test_guest_memfd(unsigned long vm_type)
>>         vm = vm_create_barebones_type(vm_type);
>>
>>         if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
>> -               flags |= GUEST_MEMFD_FLAG_MMAP;
>> +               flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>>
>>         test_create_guest_memfd_multiple(vm);
>>         test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
>> @@ -337,7 +337,8 @@ static void test_guest_memfd_guest(void)
>>                     "Default VM type should always support guest_memfd mmap()");
>>
>>         size = vm->page_size;
>> -       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
>> +       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
>> +                                            GUEST_MEMFD_FLAG_DEFAULT_SHARED);
>>         vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
>>
>>         mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 08a6bc7d25b6..19f05a45be04 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -328,6 +328,9 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>         if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>>                 return VM_FAULT_SIGBUS;
>>
>> +       if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_DEFAULT_SHARED))
>> +               return VM_FAULT_SIGBUS;
>> +
>>         folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>         if (IS_ERR(folio)) {
>>                 int err = PTR_ERR(folio);
>> @@ -525,7 +528,8 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>>         u64 valid_flags = 0;
>>
>>         if (kvm_arch_supports_gmem_mmap(kvm))
>> -               valid_flags |= GUEST_MEMFD_FLAG_MMAP;
>> +               valid_flags |= GUEST_MEMFD_FLAG_MMAP |
>> +                              GUEST_MEMFD_FLAG_DEFAULT_SHARED;
>
> At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
> GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
> checking for that, at least until we have in-place conversion? Having
> only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
> isn't a useful combination.
>

I think it's okay to have the two flags be orthogonal from the start.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> That said, these are all nits, I'll leave it to you. With that:
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
>
> Cheers,
> /fuad
>
>
>
>>
>>         if (flags & ~valid_flags)
>>                 return -EINVAL;
>> --
>> 2.51.0.536.g15c5d4f767-goog
>>

