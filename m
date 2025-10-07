Return-Path: <kvm+bounces-59587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE76BC21E0
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BEFF3E2BC1
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5011521A420;
	Tue,  7 Oct 2025 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TxZCZtrZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24A21B0F1C
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759854688; cv=none; b=lXX7+Irzjb4ZwP/28ZN+BiCKCOR3zivJvTwrDFZG0JsCExgRrtn1wLk9F0NCS2TVb8Gy3f6AYxSU+RHbo7hGf57iCrDHL8gGIcUX2IFBNSi1riGMAQloUiOUXTVOAvufUK/Mb07PbDVcmALKHpomXi/ECzoRJnGyHcvHX408Oos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759854688; c=relaxed/simple;
	bh=zRn9l5M3+J57K4Nf/MSyE1kact60dzbaTi+YViUvQEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EiOBt4apFlDCV3sR3kspSaF6IahqCVb7MSlQL8fuYwkuwxhGH6GUn+zLAFPvaSebCWhq2K8BaARG1hbiCZc8YUb5WDK844bx+FSfqgrKmb+0ExijJiZ6Gd1/Obg6azZtf4arQ8nl7JMMhGg8jnrVWLBHXB0qA3dB8kzqiNfrqGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TxZCZtrZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33274f8ff7cso9502645a91.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 09:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759854686; x=1760459486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DUfQZGdB8vnQ3BrO/9eKlA0A4GR0IweUUWX2EFRalJA=;
        b=TxZCZtrZmPIMiH2jB1H2EB6QFXa1nnepz0E0xDH7weZTfOjxJqcmIRvdsgegYZsEZi
         Q+IOutPCqcY0HOvYEZCCeJBqGNA6kpxWsZ95rR8ifrH2vzKAdTahg746pQB4PrDFY6tC
         C0bfLvPoHKtf+de7jieD7GwalecwdeyX6Ni5JULfy0CgiMvpj5LDDGYfB5xQeIjGTgkP
         7tZEb0f+qjF5+Lo4odTen5N9rxGw8hvtERqcfoZojDEHvdEou3zHolqsb4U2iyy0wYkU
         Kszs+CB4liWrZZ/ONXeDaaYvowHlxc6+0XYLGtcJIHJX0g0Qf/ns314SU7GMff1WmsFr
         D80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759854686; x=1760459486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUfQZGdB8vnQ3BrO/9eKlA0A4GR0IweUUWX2EFRalJA=;
        b=XbfA6uu1gM5bYmDqWHfx49k+yctdiQGA2BuZriTlNKmEH/yNNx0d8lnLHVkyYTPBfY
         7c0hDZoYHNPYjnA2tAua10Feyl3c8+GzsjDoyfchqyLO8LlslvI0Y7zvbcINyWDTVtH2
         Sc3em8KtoHIy0BjTwHDSAbLac0bGgJvHJWtvPHtHCfiZNYIOmpmxAoqcRxPX0z9GGF/Z
         LuuZBjchwxxsORq5nhFI7N69H1vYsHt6DVBe0OCbIKkXb+5WzzMQicDj2YdjOSefdM0Q
         dAhtUyqzf/8tY37lfVFMIBnmpSHf4djeCU3erloUKE+18K1zvm8i86iFijLeMzb8lVp6
         8aRw==
X-Gm-Message-State: AOJu0YyPaxmwl/MtDAc/5vyJtOaudYr5cE9XH0fnn3uPHcH1jlrFlnZe
	rYvakqcNmZXwhZKXe/bORgfpgNT/g64ZKwHvyp72DPJF/RK9eLmi+Z2/EH5YmZOdKQVN1ZeP+/B
	XfvqnNEzCFRv2iAQTzVHJ7xYFnw==
X-Google-Smtp-Source: AGHT+IFhqcZFcRMhW8qlWIS/kR93SNJpodMaSdwu3z7otH1Ts8WLKOWU6DlQ64PJlD/ZZmNPqHVeCV0AVk821S0veA==
X-Received: from pjbdj15.prod.google.com ([2002:a17:90a:d2cf:b0:330:793a:2e77])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a52:b0:332:84c1:31de with SMTP id 98e67ed59e1d1-33b513ced6emr119418a91.25.1759854686135;
 Tue, 07 Oct 2025 09:31:26 -0700 (PDT)
Date: Tue, 07 Oct 2025 09:31:24 -0700
In-Reply-To: <20251003232606.4070510-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-4-seanjc@google.com>
Message-ID: <diqzbjmiekrn.fsf@google.com>
Subject: Re: [PATCH v2 03/13] KVM: guest_memfd: Invalidate SHARED GPAs if gmem
 supports INIT_SHARED
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> When invalidating gmem ranges, e.g. in response to PUNCH_HOLE, process all
> possible range types (PRIVATE vs. SHARED) for the gmem instance.  Since
> since guest_memfd doesn't yet support in-place conversions, simply pivot
> on INIT_SHARED as a gmem instance can currently only have private or shared
> memory, not both.
>
> Failure to mark shared GPAs for invalidation is benign in the current code
> base, as only x86's TDX consumes KVM_FILTER_{PRIVATE,SHARED}, and TDX
> doesn't yet support INIT_SHARED with guest_memfd.

This is the correct fix, and I agree it is not a problem in current code
since before this patch series and the introduction of INIT_SHARED,
mmap() was only supported by non-CoCo, which doesn't interpret
KVM_FILTER_{PRIVATE,SHARED} anyway.

Had something similar/related here [1]

[1] https://lore.kernel.org/all/d3832fd95a03aad562705872cbda5b3d248ca321.1747264138.git.ackerleytng@google.com/

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> However, invalidating
> only private GPAs is conceptually wrong and a lurking bug, e.g. could
> result in missed invalidations if ARM starts filtering invalidations based
> on attributes.
>
> Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 64 +++++++++++++++++++++++++++++-------------
>  1 file changed, 44 insertions(+), 20 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index cf3afba23a6b..e10d2c71e78c 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -102,8 +102,17 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  	return filemap_grab_folio(inode->i_mapping, index);
>  }
>  
> -static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> -				      pgoff_t end)
> +static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
> +{
> +	if ((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED)
> +		return KVM_FILTER_SHARED;
> +
> +	return KVM_FILTER_PRIVATE;
> +}
> +
> +static void __kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> +					pgoff_t end,
> +					enum kvm_gfn_range_filter attr_filter)
>  {
>  	bool flush = false, found_memslot = false;
>  	struct kvm_memory_slot *slot;
> @@ -118,8 +127,7 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
>  			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
>  			.slot = slot,
>  			.may_block = true,
> -			/* guest memfd is relevant to only private mappings. */
> -			.attr_filter = KVM_FILTER_PRIVATE,
> +			.attr_filter = attr_filter,
>  		};
>  
>  		if (!found_memslot) {
> @@ -139,8 +147,21 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
>  		KVM_MMU_UNLOCK(kvm);
>  }
>  
> -static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
> -				    pgoff_t end)
> +static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
> +				      pgoff_t end)
> +{
> +	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> +	enum kvm_gfn_range_filter attr_filter;
> +	struct kvm_gmem *gmem;
> +
> +	attr_filter = kvm_gmem_get_invalidate_filter(inode);
> +
> +	list_for_each_entry(gmem, gmem_list, entry)
> +		__kvm_gmem_invalidate_begin(gmem, start, end, attr_filter);
> +}
> +
> +static void __kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
> +				      pgoff_t end)
>  {
>  	struct kvm *kvm = gmem->kvm;
>  
> @@ -151,12 +172,20 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
>  	}
>  }
>  
> +static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
> +				    pgoff_t end)
> +{
> +	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> +	struct kvm_gmem *gmem;
> +
> +	list_for_each_entry(gmem, gmem_list, entry)
> +		__kvm_gmem_invalidate_end(gmem, start, end);
> +}
> +
>  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  {
> -	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	pgoff_t start = offset >> PAGE_SHIFT;
>  	pgoff_t end = (offset + len) >> PAGE_SHIFT;
> -	struct kvm_gmem *gmem;
>  
>  	/*
>  	 * Bindings must be stable across invalidation to ensure the start+end
> @@ -164,13 +193,11 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  	 */
>  	filemap_invalidate_lock(inode->i_mapping);
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		kvm_gmem_invalidate_begin(gmem, start, end);
> +	kvm_gmem_invalidate_begin(inode, start, end);
>  
>  	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		kvm_gmem_invalidate_end(gmem, start, end);
> +	kvm_gmem_invalidate_end(inode, start, end);
>  
>  	filemap_invalidate_unlock(inode->i_mapping);
>  
> @@ -280,8 +307,9 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * Zap all SPTEs pointed at by this file.  Do not free the backing
>  	 * memory, as its lifetime is associated with the inode, not the file.
>  	 */
> -	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
> -	kvm_gmem_invalidate_end(gmem, 0, -1ul);
> +	__kvm_gmem_invalidate_begin(gmem, 0, -1ul,
> +				    kvm_gmem_get_invalidate_filter(inode));
> +	__kvm_gmem_invalidate_end(gmem, 0, -1ul);
>  
>  	list_del(&gmem->entry);
>  
> @@ -403,8 +431,6 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
>  
>  static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
>  {
> -	struct list_head *gmem_list = &mapping->i_private_list;
> -	struct kvm_gmem *gmem;
>  	pgoff_t start, end;
>  
>  	filemap_invalidate_lock_shared(mapping);
> @@ -412,8 +438,7 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>  	start = folio->index;
>  	end = start + folio_nr_pages(folio);
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		kvm_gmem_invalidate_begin(gmem, start, end);
> +	kvm_gmem_invalidate_begin(mapping->host, start, end);
>  
>  	/*
>  	 * Do not truncate the range, what action is taken in response to the
> @@ -424,8 +449,7 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>  	 * error to userspace.
>  	 */
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		kvm_gmem_invalidate_end(gmem, start, end);
> +	kvm_gmem_invalidate_end(mapping->host, start, end);
>  
>  	filemap_invalidate_unlock_shared(mapping);
>  
> -- 
> 2.51.0.618.g983fd99d29-goog

