Return-Path: <kvm+bounces-44014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17887A99978
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 22:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7E5D3A89D0
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E4826E142;
	Wed, 23 Apr 2025 20:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HVsUazQR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1182641F8
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 20:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745440220; cv=none; b=W/ou6HmF78Sy49f2GVHCx4jGtDjFY8Nd00jl5LRSTm9+1N3p+FO8nX7vea5Hx611WrrXhql0gdDJFxUKu+5YPXn6NkcUXjoPYOkL2biNDPY2i0GVH6N5tLbw/XJDTey4LkN7UIZ7nQB9BWP9zRvBHpe1xL5naSxytG0qjEptPYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745440220; c=relaxed/simple;
	bh=Jy9AF1bLD9s1kWHMI5cSeRF12B+vXLXM8S1mo/7+Lc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=kx+E3rkkei7IklTS6FSo09BFIHTu7SGYAU83mW3OwNpJBfamGHimPoNclvfTRJn0fzCRt9YRauT2zPuDQ5n1oSfyiW0+3tVjeOdyKilYdv1KVASJVZW4Ghers3/hSZ1aUAsZ21nx+THocZGDRPlm8N+xTMIgCYxminLH34fBN8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HVsUazQR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff605a7a43so363880a91.3
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 13:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745440218; x=1746045018; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wFwfHWKiOnPA3XurBNytw5hRobKKwcuhd1GdyuPU6d4=;
        b=HVsUazQRya4iDpvITl10L8Zzp1NlKOaJXvb4yGySH5HVtFDDeIBJVGIH0bxfXfa16j
         eriGQWH4AvBg4AluzgWf5zEwRPtdw0fQUFHkbVpO3nSARmxQu0TyLKNXsPN4jPBoEu66
         wGe4jN8cZFdO3gMdUf4Avdw03CUtFvwg8Q9cgFqlLA0Q92NC/g+syn+LUdarQ5C+7MVy
         MVBu8W5pCG9vyN9yMSjB530kgAhzlKRtwgNSytiJoHQGuSI6qIdEV3U8xEtmWQN7EWc3
         kuCsOc+CaJJEhIloyL2tTVHoZ25IbZemSNrtibXgB6owrhqI6b7MLbs3llItOpnM+MSB
         4tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745440218; x=1746045018;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFwfHWKiOnPA3XurBNytw5hRobKKwcuhd1GdyuPU6d4=;
        b=jwJFM8D+OH14nVum2ZCk7PIQyuT2zgiiRbPQedxpGJB5Y9kezlwCTvUwwXngUXLmmJ
         nvDfjzXyecRoqXzWlpvQgC5iMM6XzxPLAWfX8ctYvRxF6qmTnUxER/WB0PROcKH13anL
         ewFOOzk8PWj9X79qiX9LK1pzA/xV7VO/RHpBKoo6nxOEcf/AMJItNIO0/UVagK8TXyAt
         4GEARoBqXqcMF4e+4mYI0uoILF95tcvLy/HCoVv+cyAYT0+yhXMcyHWUUL6g9UHn6d/L
         2hm5JCLG2pskWJat4inH1SBz5WeaCntsmlN2h4KyUA+SzN+D62zOllpO88LuewW3hgii
         2RYw==
X-Forwarded-Encrypted: i=1; AJvYcCUr48Qlrvl8XkUzejLThy/odS5X+GQzS/ctRmk0BmXybuQZIGcPDBPHbs6pLXgK7zta5PA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5g+byUxQp7VD5JNJfT8rDYqg+DlAJKJucgreKLdcPETfAMy4m
	3fZgxLaYHG6agCkijplJvhNjobh/zd/WxdouIUTIDv/HbuxZRa62DdsF6oohx4D6X6wlkNgPBrZ
	i8CCRXUFQcAmHF3K2AaSA6g==
X-Google-Smtp-Source: AGHT+IFGGg/B7qp7FkZaVMVZcodyUC28I1xDuj7tEL7LiKI1XvY47f/3SmITZLm5fSRvypwGzfBdYk1oJR2G2wcvyA==
X-Received: from pjqq12.prod.google.com ([2002:a17:90b:584c:b0:2f9:dc36:b11])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:510c:b0:2fe:b8b9:5aa6 with SMTP id 98e67ed59e1d1-309ed341a4amr223367a91.31.1745440218015;
 Wed, 23 Apr 2025 13:30:18 -0700 (PDT)
Date: Wed, 23 Apr 2025 13:30:16 -0700
In-Reply-To: <Z/OMB7HNO/RQyljz@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241212063635.712877-1-michael.roth@amd.com> <20241212063635.712877-4-michael.roth@amd.com>
 <Z9P01cdqBNGSf9ue@yzhao56-desk.sh.intel.com> <Z/OMB7HNO/RQyljz@yzhao56-desk.sh.intel.com>
Message-ID: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, amit.shah@amd.com, 
	pratikrajesh.sampat@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, quic_eberman@quicinc.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
>> This patch would cause host deadlock when booting up a TDX VM even if huge page
>> is turned off. I currently reverted this patch. No further debug yet.
> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
>
> kvm_gmem_populate
>   filemap_invalidate_lock
>   post_populate
>     tdx_gmem_post_populate
>       kvm_tdp_map_page
>        kvm_mmu_do_page_fault
>          kvm_tdp_page_fault
> 	   kvm_tdp_mmu_page_fault
> 	     kvm_mmu_faultin_pfn
> 	       __kvm_mmu_faultin_pfn
> 	         kvm_mmu_faultin_pfn_private
> 		   kvm_gmem_get_pfn
> 		     filemap_invalidate_lock_shared
> 	
> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> ("locking: More accurate annotations for read_lock()").
>

Thank you for investigating. This should be fixed in the next revision.

>> > @@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>> >  	struct file *file = kvm_gmem_get_file(slot);
>> >  	int max_order_local;
>> > +	struct address_space *mapping;
>> >  	struct folio *folio;
>> >  	int r = 0;
>> >  
>> >  	if (!file)
>> >  		return -EFAULT;
>> >  
>> > +	mapping = file->f_inode->i_mapping;
>> > +	filemap_invalidate_lock_shared(mapping);
>> > +
>> >  	/*
>> >  	 * The caller might pass a NULL 'max_order', but internally this
>> >  	 * function needs to be aware of any order limitations set by
>> > @@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
>> >  	if (IS_ERR(folio)) {
>> >  		r = PTR_ERR(folio);
>> > +		filemap_invalidate_unlock_shared(mapping);
>> >  		goto out;
>> >  	}
>> >  
>> > @@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
>> >  
>> >  	folio_unlock(folio);
>> > +	filemap_invalidate_unlock_shared(mapping);
>> >  
>> >  	if (!r)
>> >  		*page = folio_file_page(folio, index);
>> > -- 
>> > 2.25.1
>> > 
>> > 

