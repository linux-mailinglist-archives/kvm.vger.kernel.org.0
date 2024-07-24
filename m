Return-Path: <kvm+bounces-22174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B89F493B532
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 18:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 785DB283229
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 16:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C649815EFB2;
	Wed, 24 Jul 2024 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sULpsS5d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2F815ECCF
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 16:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721839343; cv=none; b=Rxo5YZFlZpOgXhuczPKrwOC8u8wkxYHQKE6G6oPf3ooulx6pC7vQLH3HnOwzVA+Oc8eh/wLExNLGpuDkglNZD97ObVMAMJhneHsdqDTqHTPXz/h248x6XCkp3b+lO3PNmuny+WZ1QtEYBsnd2I8NqrKCqVESe3WBrJn35m8Vk3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721839343; c=relaxed/simple;
	bh=p4+Gd7BmotDv1ZX4p7C+4MPitWGe2/wQSkne2jwDM0w=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=bW7borYL+l3b0hydozrkV1QNBBVfDqc65fZAWdaTGaN59fBkiOqkIjMPnimkFXyCFDnZe0F18nHMArXybswmWKTDNC/dFwuVfETwbeZohpZIMc8AZHz0/hDSswex4xGF9FzkTG+jpW6u2q0caqVUYUZN11LccBxxH5h+B/ZqhvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sULpsS5d; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d19a4137dso20479b3a.1
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 09:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721839341; x=1722444141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=quXFMjtZMDuExn79bpSog/9LF2Y7O+Ta5z6Tp776il8=;
        b=sULpsS5dYzyxEgy8leObpBYhk6lmCzfBbJoAFoUIE7aBeKK7hV7VNMhQGmD8/yJ+Hh
         cnGo2ZlZfP8LzT9O1c2mbce+R+tAdA4ZQUd9ptw104HgoxH+XRMaXiCdWHfkTD+xFSzp
         8lAe+C5qjClvf3yyfv03L9c5dIYKB3lMaVuFhSscu54V8yTspcD8Wgp2wChoE0yQaGhu
         TVSN0KZRjCxkHZpcFHVwE1oky+MXBUZqRuCr/d54ZcFmmJ0p1yngrJLBVgircQEvKKsg
         QaCOX2ogexZ8gxC+NrlmlqjGoc2kf5T2SvRCdd0amJF36xGndOA7pbZSKXM0MbEF1XnQ
         /IYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721839341; x=1722444141;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=quXFMjtZMDuExn79bpSog/9LF2Y7O+Ta5z6Tp776il8=;
        b=VSq5Y8zj9oMRlB17fb3jKZpGgsLHsKxk79JltEps4Ki6js0oB0M02EAe04FxrASUhF
         SZLhX7astO8yKc7r5IHjKKMKD6TxOJeNkui7ukm1bjXZRVZw+grTAHRB2YvwCeY2uNKQ
         21QJtYSneSe49at9JMfMEo51+D3Nm4/djOKcnG7pOZTwTidA5BmsuXWPFll3NEwfUcGN
         8JiJjxMIW7Mro7RPgnvsN+MXecn9tpcbnE596QpAL8OM2uouQDJrFoLDFaX46AEd68JG
         vBlLIg19VQCKEoOOsH9Pu44RkjE6TvZ9Do7UBtDAbTMxRlIHgCyGMClNzwuPqjs+EilL
         V+sA==
X-Forwarded-Encrypted: i=1; AJvYcCUzW+xKDzoH6EdeXLu4bwexy1o9Td7sQALMisrlaO9zpMIu++aZxZOMxiGMLo2fGh+KucaM1IZBMY1UMnOedsq8DrpU
X-Gm-Message-State: AOJu0YyvrZwojOu+pU0AGLpe9W2220vZR0rCBHHD4GKM+qK3t+kIa7rQ
	YrxlPmY2KZt/Lw1AJDuWGSXcNyUNNCeiE1xevIpmzI1Vv6T7yPNVJ0JaYhHpIzTagkLALnOm2VD
	Hed/hDOAbd0lg8ZG+VYzPWA==
X-Google-Smtp-Source: AGHT+IHIrwfCPJh1o0JqmPFz3FO0hLjOEEzwgQspX1GMZjdhbr2An4xmUHLxLzB+Uc/ALItH7RCqJY/Tukxlqk7Edg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a05:6a00:944d:b0:70d:10d8:d050 with
 SMTP id d2e1a72fcca58-70ea9fd40e7mr7422b3a.0.1721839340518; Wed, 24 Jul 2024
 09:42:20 -0700 (PDT)
Date: Wed, 24 Jul 2024 16:42:18 +0000
In-Reply-To: <ZdcRpHB43OxY8mpX@yzhao56-desk.sh.intel.com> (message from Yan
 Zhao on Thu, 22 Feb 2024 17:19:32 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzo76myc5x.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 07/29] KVM: selftests: TDX: Update
 load_td_memory_region for VM memory backed by guest memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: sagis@google.com, linux-kselftest@vger.kernel.org, afranji@google.com, 
	erdemaktas@google.com, isaku.yamahata@intel.com, seanjc@google.com, 
	pbonzini@redhat.com, shuah@kernel.org, pgonda@google.com, haibo1.xu@intel.com, 
	chao.p.peng@linux.intel.com, vannapurve@google.com, runanwang@google.com, 
	vipinsh@google.com, jmattson@google.com, dmatlack@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Tue, Dec 12, 2023 at 12:46:22PM -0800, Sagi Shahar wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>> 
>> If guest memory is backed by restricted memfd
>> 
>> + UPM is being used, hence encrypted memory region has to be
>>   registered
>> + Can avoid making a copy of guest memory before getting TDX to
>>   initialize the memory region
>> 
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ryan Afranji <afranji@google.com>
>> Signed-off-by: Sagi Shahar <sagis@google.com>
>> ---
>>  .../selftests/kvm/lib/x86_64/tdx/tdx_util.c   | 41 +++++++++++++++----
>>  1 file changed, 32 insertions(+), 9 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
>> index 6b995c3f6153..063ff486fb86 100644
>> --- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx_util.c
>> @@ -192,6 +192,21 @@ static void tdx_td_finalizemr(struct kvm_vm *vm)
>>  	tdx_ioctl(vm->fd, KVM_TDX_FINALIZE_VM, 0, NULL);
>>  }
>>  
>> +/*
>> + * Other ioctls
>> + */
>> +
>> +/**
>> + * Register a memory region that may contain encrypted data in KVM.
>> + */
>> +static void register_encrypted_memory_region(
>> +	struct kvm_vm *vm, struct userspace_mem_region *region)
>> +{
>> +	vm_set_memory_attributes(vm, region->region.guest_phys_addr,
>> +				 region->region.memory_size,
>> +				 KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> +}
>> +
>>  /*
>>   * TD creation/setup/finalization
>>   */
>> @@ -376,30 +391,38 @@ static void load_td_memory_region(struct kvm_vm *vm,
>>  	if (!sparsebit_any_set(pages))
>>  		return;
>>  
>> +
>> +	if (region->region.guest_memfd != -1)
>> +		register_encrypted_memory_region(vm, region);
>> +
>>  	sparsebit_for_each_set_range(pages, i, j) {
>>  		const uint64_t size_to_load = (j - i + 1) * vm->page_size;
>>  		const uint64_t offset =
>>  			(i - lowest_page_in_region) * vm->page_size;
>>  		const uint64_t hva = hva_base + offset;
>>  		const uint64_t gpa = gpa_base + offset;
>> -		void *source_addr;
>> +		void *source_addr = (void *)hva;
>>  
>>  		/*
>>  		 * KVM_TDX_INIT_MEM_REGION ioctl cannot encrypt memory in place,
>>  		 * hence we have to make a copy if there's only one backing
>>  		 * memory source
>>  		 */
>> -		source_addr = mmap(NULL, size_to_load, PROT_READ | PROT_WRITE,
>> -				   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> -		TEST_ASSERT(
>> -			source_addr,
>> -			"Could not allocate memory for loading memory region");
>> -
>> -		memcpy(source_addr, (void *)hva, size_to_load);
>> +		if (region->region.guest_memfd == -1) {
>> +			source_addr = mmap(NULL, size_to_load, PROT_READ | PROT_WRITE,
>> +					MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> +			TEST_ASSERT(
>> +				source_addr,
>> +				"Could not allocate memory for loading memory region");
>> +
>> +			memcpy(source_addr, (void *)hva, size_to_load);
>> +			memset((void *)hva, 0, size_to_load);
>> +		}
>>  
>>  		tdx_init_mem_region(vm, source_addr, gpa, size_to_load);
>>  
>> -		munmap(source_addr, size_to_load);
>> +		if (region->region.guest_memfd == -1)
>> +			munmap(source_addr, size_to_load);
>>  	}
>
> For memslot 0, 1, 2, when guest_memfd != -1,
> is it possible to also munmap(mmap_start, mmap_size) after finish loading?
>

Thank you for your review!

Did you mean "possible" as in whether it is "correct" to do munmap() for
the rest of the earlier memslots containing non-test-code?

It is correct because the munmap() just deallocates memory that was
recently allocated in mmap() in this same change. The memory set up for
the VM is not affected.

Hope that answers your question, and here's some further detail, hope
this helps too:

load_td_memory_region() loads a memory region into a TD by calling the
KVM_TDX_INIT_MEM_REGION ioctl, which copies (and encrypts) the data in
an existing memory region into TD private memory for the TD to use.

In these selftests, we use the KVM selftest framework to set up a TD's
memory as if it were a regular VM, and then use this function to
copy+encrypt the memory that is already set up for the TD. This lets us
re-use most of the code from the KVM selftest framework for TDs, which
is extremely useful for setting up page tables, exception handlers, etc
for the TD. These key pieces of memory setup are in the memslots with
smaller indices, as you pointed out.

KVM_TDX_INIT_MEM_REGION ioctl uses the provided gpa and struct kvm to
look up the destination address, and uses source_addr as the source
address for the copying. 

If we are not using guest_memfd (region->region.guest_memfd == -1), then
we need to make the source and destination address different by copying
the contents at the source address somewhere else for the call to
tdx_init_mem_region(). That is what the mmap() is doing. This temporary
buffer then needs to be freed, hence the munmap(). Without this copying,
the destination address for the ioctl's copy would be the same as the
source address, since those very same pages are provided in the memslot
for this memory region.

If we are using guest_memfd, then the destination address for the
ioctl's copy will be taken from the guest_memfd, which is already
different from the source address, hence we can skip the copying.

>>  }
>>  
>> -- 
>> 2.43.0.472.g3155946c3a-goog
>> 
>> 

