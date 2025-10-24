Return-Path: <kvm+bounces-61038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 812CAC07643
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:48:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66BD53AD48B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 16:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46D9338922;
	Fri, 24 Oct 2025 16:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3kE1an0p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36552DCF5D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761324498; cv=none; b=bfh0LaAfamA5HU9eKJZak+Wc4m53wu+m5w01LlCtcCMOPvU/6gtzFH8ukG54caBXKlHKKClnbu4cy49EgGuYTgj0OI65+T7DSL2VWkLKpVYUVhokvgijPvJMlrhw9jQS6DSAJQ6XtlFGcJIl0Z40hV1XXo3bGHHsMQs+husQAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761324498; c=relaxed/simple;
	bh=f2a3PKTXtxiqGjxZTh9T4s+dCE9zdgxrYpNNXCt4lP4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PMY3WjLBZBrH86phrfdd7EfoVhFVVh8fTiE6+cY1JsruHF4t34ASvrO109bU/oBdTsVK7y21x4J6j7iYCkcEnjpLVNbRgyu65OV/Gfiv1fHRkaQ14K0UlrLAQ5MUNkby0CnYW90PWzwQWitl/sj8dgR9/nJ+B6uMhJlpwHqoaxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3kE1an0p; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ceeea4addso1909379a12.1
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 09:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761324494; x=1761929294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N0ZqooCPaM4r88VkiqaSJuwNdNXDKXHQHEd4a0Vhrkk=;
        b=3kE1an0pZPerDXVZT/Eryt9uJLK3d3syqHXqx2U9sE68vp+cA0k//igGNp03uLI6v0
         bWU0BPVXcZnbk5Cp1wLp0ziT+rVR2R+VT3VF9WQSRVuPO1rEDSDxx10EIkOV2bBqF29i
         vO9SoLzY3B9//15oc0CnGQia/eN+qYvIaGyyg0xJN5PC6Ro7mmgEFr7rdnazQFjyfylC
         V8Z/K65gdxDsiJOn7zA2L/fiI7N9ow9FzNYJmItwiEzsnpk9PBme5+h18wyva85Il8xv
         DXn4xNKhzPIeDLEm07oce/QTQ1rLUINZ6X0qMvPgfRna8f7azAG05IzBLssyFwAa6ZfA
         udoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761324494; x=1761929294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N0ZqooCPaM4r88VkiqaSJuwNdNXDKXHQHEd4a0Vhrkk=;
        b=wWotVbNtdn4TpYD36bn3KMeyUnb5GB9P6mY9C1Y8ZLEFjVs4dEBQJJvxhgbYJhCtMM
         3ZZn/VK9+LFidiJuuwCb1uTI4oyBihkWsyQyNKZ9XqovDmqtga+S22zKPyqj3ddRArQW
         QOCLX+XR8+6ennMFz8xLy1sZEyfcWCKdqB4hBCzVzRelQpY8xIcEShVS3DYJkFQMb08U
         20A21u2jf2ZfeNfsA7KocljQk5sMAgrL+IzZnw5OjJXv1KmJR07s/Ws34DMkE4ShlmeE
         p/sURBZFg6Vtogu60uc6Pt/d1t49FBiB5VgQ45y3PEIir9h/vABYqK9FoHy0nbc1Az1p
         hgoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXczgAjzItkD/VIOWObaO6TVIgMRFFzUqsUgBWCf9Sq6wbJ9Zo0EtpE37fqP/DWqcMug3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxedHerMqbuSyfTEQ4nf9NFFghBGbIAVYDzA+KaTuuCgVtcRxpf
	JQztU9unJAGex1hZlrI21x1E6h76m5ceoupTfWETwqnk7qe1jDJA8bPzLICf65OG9/ahFqXC/C+
	6a3hfImuu5+6cgUAicqVxatVHmQ==
X-Google-Smtp-Source: AGHT+IEK36TdUsL0vlOCqmspe4caiObjbOIOsGdu4QEVuayy/5SWQrXbR3hmNgi0EJY8rePbH10nOdC3ZkaAHHoKBw==
X-Received: from pjyj23.prod.google.com ([2002:a17:90a:e617:b0:339:ae3b:2bc7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9988:b0:334:b8bb:b11d with SMTP id adf61e73a8af0-33dead4c65cmr3868140637.31.1761324494100;
 Fri, 24 Oct 2025 09:48:14 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:48:12 -0700
In-Reply-To: <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
Message-ID: <diqzldl0dz5f.fsf@google.com>
Subject: Re: [RFC PATCH v1 16/37] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> From: Sean Christopherson <seanjc@google.com>
>
> Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
> vm_mem_add().
>
> When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
> provided (or created) gmem_fd as the fd for the user memory region. This
> makes it available to be mmap()-ed from just like fds from other memory
> sources. mmap() from guest_memfd using the provided gmem_flags and
> gmem_offset.
>
> Add a kvm_slot_to_fd() helper to provide convenient access to the file
> descriptor of a memslot.
>
> Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
> preserve existing behavior.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [For guest_memfds, mmap() using gmem_offset instead of 0 all the time.]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  7 ++++++-
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++--------
>  .../kvm/x86/private_mem_conversions_test.c     |  2 +-
>  3 files changed, 17 insertions(+), 10 deletions(-)
>
> 
> [...snip...]
> 
> @@ -1050,13 +1049,16 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	}
>  
>  	region->fd = -1;
> -	if (backing_src_is_shared(src_type))
> +	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP)
> +		region->fd = kvm_dup(gmem_fd);
> +	else if (backing_src_is_shared(src_type))
>  		region->fd = kvm_memfd_alloc(region->mmap_size,
>  					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
>  

Doing this makes it hard to test the legacy dual-backing case.

It actually broke x86/private_mem_conversions_test for the legacy
dual-backing case because there's no way to mmap or provide a
userspace_address from the memory provider that is not guest_memfd, as
determined by src_type.

I didn't test the legacy dual-backing case before posting this RFC and
probably should have.

> -	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> -				      vm_mem_backing_src_alias(src_type)->flag,
> -				      region->fd);
> +	mmap_offset = flags & KVM_MEM_GUEST_MEMFD ? gmem_offset : 0;
> +	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> +					vm_mem_backing_src_alias(src_type)->flag,
> +					region->fd, mmap_offset);
>  
>  	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
>  		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
> @@ -1117,7 +1119,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  				 uint64_t gpa, uint32_t slot, uint64_t npages,
>  				 uint32_t flags)
>  {
> -	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
> +	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index 1969f4ab9b280..41f6b38f04071 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
>  	for (i = 0; i < nr_memslots; i++)
>  		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
>  			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
> -			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
> +			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
>  
>  	for (i = 0; i < nr_vcpus; i++) {
>  		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
> -- 
> 2.51.0.858.gf9c4a03a3a-goog

