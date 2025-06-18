Return-Path: <kvm+bounces-49832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41414ADE716
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C09BF188EC1A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 09:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CF82820CD;
	Wed, 18 Jun 2025 09:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9HebMdw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E0720110B
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 09:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750239256; cv=none; b=iIXiRsiysXAFN/w0doq+RD0ikXoT/KE+TMRtgQGyRjj0cum1JwWIo/DGgl/wkURlepTw21Jwv15S4zOz/3oLmhCpIQ6siE2F9F20m9TJmPiSnuIwFRK5cYrD5qwFGuyaJmUmQcDaW+sFmy2lnISgVafh+XAFPtQiqeoflPgeYe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750239256; c=relaxed/simple;
	bh=LuHYpGPjFGUkZ5LJO0CBa86/7riHZ0vweor+qBLNns8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mDKL9lgasTg8Y/AyWNgztIR7j8+7Z+T1piSzv1NKum+OOyF+wkEu1jbhrvCJhUKlbEWJbExTGI68A1K81mFlg9yq5FlrpL8xGlZPIWMggEe3oQu0o7KrrVzFFQAS8RAxASs1onM/WerwMoba01aaaufzVV8/XyqICz4T9JapaAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I9HebMdw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750239254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=noez7PDMjGNfyqAC2iiFATetkxxnOVVDqKKI/+ShM2Q=;
	b=I9HebMdwVbuW3KEc9uxIVLzI+bWEfCnK/18fZEodtTmiMaqYxm6c6qnC9MiidPqC+HXmWP
	+ELhrqZuSMZn7szkWox9WtDBKAXh0eFW9dN0GMMvgZhwNL7NLMfytQNPl5d9wQwf75ERHG
	Jm8lIefQYqvqIH+Bbdv/GZVngJ2oriE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-rTeq-rD-O9SoinRgVG-gjA-1; Wed, 18 Jun 2025 05:34:12 -0400
X-MC-Unique: rTeq-rD-O9SoinRgVG-gjA-1
X-Mimecast-MFC-AGG-ID: rTeq-rD-O9SoinRgVG-gjA_1750239251
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-adeaa4cc91eso54642266b.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 02:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750239251; x=1750844051;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=noez7PDMjGNfyqAC2iiFATetkxxnOVVDqKKI/+ShM2Q=;
        b=HFBzQDJPUCz/saYsny2jxiNHQfAMXID6lTVA0CQWAXK7skemSwNMpKrFRrOvTva2Fo
         byFJSYa4madAZH41iSB+jWesSIZhq2upb9uDlD9mOTUKFsNWZZtFNFTc7YYN7x7sbu87
         RiGx2QjRAS98F38m+TpTlCbc5+st4LYiM2CeD3v/tPa/euukalLpTRJFAQhq/kD6I1Iq
         DXjxNyMBOu7tXwVd6CRF+w+8p7M9g7jaHlV8Igwz7OAQHoTVndCAlNrvJDAde7nWyT1l
         /ogX+hgls2ALVp6KksexKgfJ9x1Q9ZOuK6Kw9XSI9fET6eP3mOSHXEWuRLva/aQq0C/M
         sOfA==
X-Gm-Message-State: AOJu0YyRFr2LDSPCGwb5KWi/C4p6c9o9xklBsX7sm9HvxpeA172NBwD3
	oSldUv/wHx571pJetm6X1r8oTOA46xNAJJcA1xmvwtR63kzgniBeQBJCiY5wSpQou+e2NoKe+g0
	A9eyB2SVmiL6pL3mTOVa7BjTxcDo6sBV4cbLAqMsk45MDfGEaHFp0rrlJF6+SQJ1e
X-Gm-Gg: ASbGncvHuONoEwJM7h6Gs3ddnhd8HmVDJNm/0lfgJn76IJBLoUahtk/ZIy7I44AZh3Q
	/aAVrCium9wxgu5wgH9klMpOjyokg+WNVluMzvqqrIYxqFyLhMxaXL3WUqJ3y3mYRf1Nqnul3Qt
	8j95u6HW7BtxkIPgmwwf8ISBPYIwFd9bpjgne7Dd/DmwNCxlLY/JMrE6r+yo/qFepgb+H4+Y3IS
	7UQGuDsXEflIXCB6QocilDXvjwzEFpu+gmeo8eiAeCfjex2THtISUZ16YXVM3r47GQXCSxnHnve
	HiNXk88mn3MhxxWaTTAEGIkmKdDXk21kAlSEtuNQyH+6Y56O1gbONqNftg1zWO+FRNn/GOAFhq/
	wJByu0KrxJ7GAjb6hybRtVIlBeccYGH6/vQIJ18hC/akM9TU=
X-Received: by 2002:a17:907:fd18:b0:ad2:27b1:7214 with SMTP id a640c23a62f3a-ae01f7791e9mr175246966b.17.1750239251096;
        Wed, 18 Jun 2025 02:34:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuGwoj8/gwtmr/WyWhYG1KWkxADFjLP/JXwSfXswYNhIZMwDVtmJ6h2OCLLp788xTNZ9fKTQ==
X-Received: by 2002:a05:600c:c109:b0:453:84a:e8d6 with SMTP id 5b1f17b1804b1-4535996524amr12309365e9.1.1750238756701;
        Wed, 18 Jun 2025 02:25:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2d:2400:4052:3b5:fff9:4ed0? (p200300d82f2d2400405203b5fff94ed0.dip0.t-ipconnect.de. [2003:d8:2f2d:2400:4052:3b5:fff9:4ed0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e256630sm206510575e9.29.2025.06.18.02.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jun 2025 02:25:55 -0700 (PDT)
Message-ID: <9f252a62-9232-4048-ac10-0c6cdf2154fe@redhat.com>
Date: Wed, 18 Jun 2025 11:25:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com> <aEySD5XoxKbkcuEZ@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aEySD5XoxKbkcuEZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index d00b85cb168c..cb19150fd595 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
>>   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>>   
>>   #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
> 

Coming back to this part of the initial mail:

> I find the SUPPORT_SHARED terminology to be super confusing.  I had to dig quite
> deep to undesrtand that "support shared" actually mean "userspace explicitly
> enable sharing on _this_ guest_memfd instance".  E.g. I was surprised to see
> 
> IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
> weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
> novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
> is to share memory, but that's a _use case_, not the property of guest_memfd that
> is being controlled by userspace.

Looking back, it would all have made more sense if one would have to 
explicitly request support for "private" memory, and the non-private 
(ordinary?) would have been the default ... :)


> 
> And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
> memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
> instance is the _only_ entry point to the memslot.
> 
> So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
> KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:

As raised, GUEST_MEMFD_FLAG_MMAPPABLE / GUEST_MEMFD_FLAG_MMAP or sth. 
like that that spells out "mmap" would be better IMHO. Better than 
talking about faultability or mappability. (fault into what? map into 
what? mmap() cleanly implies user space)

That means that we have "mmap() support implies support for non-private 
memory", I can live with that, although some code might end up being a 
bit confusing (e.g., that's why you proposed kvm_is_memslot_gmem_only() 
below).

> 
> 	if (kvm_slot_has_gmem(slot) &&
> 	    (kvm_gmem_memslot_supports_shared(slot) ||
> 	     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> 		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> 	}
> 
> much more intutive:
> 
> 	if (kvm_is_memslot_gmem_only(slot) ||
> 	    kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
> 		return kvm_gmem_max_mapping_level(slot, gfn, max_level);

Hiding the details in such a helper makes it easier to digest.

> 
> And then have kvm_gmem_mapping_order() do:
> 
> 	WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
> 	return 0;
> 
>>   struct kvm_create_guest_memfd {
>>   	__u64 size;
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index 559c93ad90be..e90884f74404 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>>          bool
>>          depends on KVM_GMEM
>> +
>> +config KVM_GMEM_SHARED_MEM
>> +       select KVM_GMEM
>> +       bool
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 6db515833f61..06616b6b493b 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>>   }
>>   
>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>> +{
>> +	const u64 flags = (u64)inode->i_private;
>> +
>> +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>> +		return false;
>> +
>> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>> +}
>> +
>> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> 
> And to my point about "shared", this is also very confusing, because there are
> zero checks in here about shared vs. private.

I assume it's simply a "kvm_gmem_fault" right now.

> 
>> +{
>> +	struct inode *inode = file_inode(vmf->vma->vm_file);
>> +	struct folio *folio;
>> +	vm_fault_t ret = VM_FAULT_LOCKED;
>> +
>> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>> +		return VM_FAULT_SIGBUS;
>> +
>> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>> +	if (IS_ERR(folio)) {
>> +		int err = PTR_ERR(folio);
>> +
>> +		if (err == -EAGAIN)
>> +			return VM_FAULT_RETRY;
>> +
>> +		return vmf_error(err);
>> +	}
>> +
>> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
>> +		ret = VM_FAULT_SIGBUS;
>> +		goto out_folio;
>> +	}
>> +
>> +	if (!folio_test_uptodate(folio)) {
>> +		clear_highpage(folio_page(folio, 0));
>> +		kvm_gmem_mark_prepared(folio);
>> +	}
>> +
>> +	vmf->page = folio_file_page(folio, vmf->pgoff);
>> +
>> +out_folio:
>> +	if (ret != VM_FAULT_LOCKED) {
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
>> +	.fault = kvm_gmem_fault_shared,
>> +};
>> +
>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	if (!kvm_gmem_supports_shared(file_inode(file)))
>> +		return -ENODEV;
>> +
>> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>> +	    (VM_SHARED | VM_MAYSHARE)) {
> 
> And the SHARED terminology gets really confusing here, due to colliding with the
> existing notion of SHARED file mappings.
> 

kvm_gmem_supports_mmap() would be as clear as it gets for this case here.

-- 
Cheers,

David / dhildenb


