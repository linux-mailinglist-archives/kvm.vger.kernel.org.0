Return-Path: <kvm+bounces-63433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB89C669AE
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 57F6B2990B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 23:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593D4324B0F;
	Mon, 17 Nov 2025 23:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HKrt9cAM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F330DD2E
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 23:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763423931; cv=none; b=Mgf0/thMD35yTjilGfip9OVq9grK2mX1EPfeSDB9e2ClDWV0lLO6NA4dlGP0CberQ26nfRWaZ0mIhddo5J9dQK4uma+ToPHI9t/vj/Cuh03evckzPKe0x/t9eNJNePriBoqYndlYZSid5Gr4q7Q2MBbgQ+7JWXuTWcN2TDBe2lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763423931; c=relaxed/simple;
	bh=wu6ivN9wLxRLGaox/McaTMnz0CXdPngRCjo8bc4gHMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kBtApDn8zuvhn0/weuvXZju86ZNHRZJzMM9cdevKXrRvcMiKR1+eQnrLsh4Fwz+0x+ag71JCN5yE12yz5gUb+84S1Wn7IHee/f7tTh7Uo1Aw4U9fOwMIh76yu45jrt8kUHcWzyaagGQolDpsFMJeR846ciyFck1YVcDP3RPGlZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HKrt9cAM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a998ab7f87so8761477b3a.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763423928; x=1764028728; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ygYEskeqBNerRcGoe7wVhcGY+hSYx1t0h+PLU7ikDc=;
        b=HKrt9cAMkclePMExyY5tiikvpzzN4MkrFjtaZvtkiXF4AAppBz+587Cpc/4PqH2pA2
         nVuJmEzP+Jxk2VfnRmP8jaVCg0kTuQaP9JAkIz773NXbwNOqIXu3ydzB93pleH4raEZB
         FkGHDyx27OrkvOVb+TCnkftsLNqqvDKwqSO/NuJK+lN3ccDLUBvYfsJdBVaLBtburEkc
         JCOv4ofc1gnQMO1wHsLdn4WEQiq0cZ8C9nEwyBUCi4OnvrGxMpp5G0z4TNO2MKSwlYSB
         BKHuSLC2+1nGQrE4C8YVsrliRDjugu6SrsNKfH9oQ9iFyderDXLXCRU+rPTK3MOP16jc
         K9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763423928; x=1764028728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ygYEskeqBNerRcGoe7wVhcGY+hSYx1t0h+PLU7ikDc=;
        b=gqSrBImGm3CnW67Lf4b8gmMypAPMI1Cl2LBq6XoDZicoJVFUrY86WiOSonB/8kKpgm
         ufUERfj7CS2Eilgj58Hk4tletnbPF+4WVcIIc0R8pHFoEMEng/F91IXmeDQo0FivNlAQ
         cQPRta7G+O7rirGNgRwNk3MnBbC+SvgtuWYBFIhMhLMcdDxE4vkOSkeeQVfKt1YxIL9n
         rAIM72EqGlyOkmEBpu69ULnSTHXho7PoDY2EQrSX59f9Ugdo8irNzUIOrzn9kyMXJdaM
         5kOsz9wxdYtbbrrvleYDHJ/o6UBsRqnTyb7IVsTwP7O6arZbar2LuxaX/LcWKkpKuogX
         Avlg==
X-Forwarded-Encrypted: i=1; AJvYcCX1g4hkkml2YF/IuTrHKoNNuQKZCVLFxA/DbUg8KHN3aWESFzUGrv74qRv2gJpKyeJ6rDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1gA6e/haE3pQN037fnmypAXFWmzWmE02RhgW84cOfY8vEqrOq
	icr8x9vcXrn7UHekI/2g2e+zhaN1G28WW4Y34K6XrA0tTJzyFAGUQJ4WdpiGkTloeTVTPkDG/5+
	OPAjgWD8cBcayHqfJtpKk3bV7mg==
X-Google-Smtp-Source: AGHT+IFxWXTBTtI2UukXobkfyKxRwRm4n7RvJLDKs/34/nWfTRqU+euiKxMKHvOHpr1hhg/cnjE46GW2X2zehltdJA==
X-Received: from pfbhm22.prod.google.com ([2002:a05:6a00:6716:b0:7b8:fc17:3960])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d27:b0:7b8:7219:63e8 with SMTP id d2e1a72fcca58-7ba3aaca144mr15697963b3a.14.1763423928025;
 Mon, 17 Nov 2025 15:58:48 -0800 (PST)
Date: Mon, 17 Nov 2025 15:58:46 -0800
In-Reply-To: <20251113230759.1562024-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com> <20251113230759.1562024-2-michael.roth@amd.com>
Message-ID: <diqzqztwb495.fsf@google.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, vannapurve@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"

Michael Roth <michael.roth@amd.com> writes:

> guest_memfd currently uses the folio uptodate flag to track:
>
>   1) whether or not a page has been cleared before initial usage
>   2) whether or not the architecture hooks have been issued to put the
>      page in a private state as defined by the architecture
>
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
>
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
>

This looks good to me, thanks!

What do you think of moving preparation (or SNP-specific work) to be
done when the page is actually mapped by KVM instead? So whatever's done
in preparation is now called from KVM instead of within guest_memfd [1]?

I'm concerned about how this preparation needs to be done for the entire
folio. With huge pages, could it be weird if actually only one page in
the huge page is faulted in, and hence only that one page needs to be
prepared, instead of the entire huge page?

In the other series [2], there was a part about how guest_memfd should
invalidate the shared status on conversion from private to shared. Is
that still an intended step, after this series to remove preparation
tracking?

[1] https://lore.kernel.org/all/diqzcy7op5wg.fsf@google.com/
[2] https://lore.kernel.org/all/20250613005400.3694904-4-michael.roth@amd.com/

> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 32 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..9160379df378 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>  
> -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> -{
> -	folio_mark_uptodate(folio);
> -}
> -
>  /*
>   * Process @folio, which contains @gfn, so that the guest can use it.
>   * The folio must be locked and the gfn must be contained in @slot.
> @@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  				  gfn_t gfn, struct folio *folio)
>  {
> -	unsigned long nr_pages, i;
>  	pgoff_t index;
> -	int r;
> -
> -	nr_pages = folio_nr_pages(folio);
> -	for (i = 0; i < nr_pages; i++)
> -		clear_highpage(folio_page(folio, i));
>  
>  	/*
>  	 * Preparing huge folios should always be safe, since it should
> @@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
>  	index = kvm_gmem_get_index(slot, gfn);
>  	index = ALIGN_DOWN(index, folio_nr_pages(folio));
> -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> -	if (!r)
> -		kvm_gmem_mark_prepared(folio);
>  
> -	return r;
> +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
>  /*
> @@ -420,7 +406,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  
>  	if (!folio_test_uptodate(folio)) {
>  		clear_highpage(folio_page(folio, 0));
> -		kvm_gmem_mark_prepared(folio);
> +		folio_mark_uptodate(folio);
>  	}
>  
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
> @@ -757,7 +743,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  					struct kvm_memory_slot *slot,
>  					pgoff_t index, kvm_pfn_t *pfn,
> -					bool *is_prepared, int *max_order)
> +					int *max_order)
>  {
>  	struct file *slot_file = READ_ONCE(slot->gmem.file);
>  	struct gmem_file *f = file->private_data;
> @@ -787,7 +773,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	if (max_order)
>  		*max_order = 0;
>  
> -	*is_prepared = folio_test_uptodate(folio);
>  	return folio;
>  }
>  
> @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  {
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct folio *folio;
> -	bool is_prepared = false;
>  	int r = 0;
>  
>  	CLASS(gmem_get_file, file)(slot);
>  	if (!file)
>  		return -EFAULT;
>  
> -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
>  
> -	if (!is_prepared)
> -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (!folio_test_uptodate(folio)) {
> +		unsigned long i, nr_pages = folio_nr_pages(folio);
> +
> +		for (i = 0; i < nr_pages; i++)
> +			clear_highpage(folio_page(folio, i));
> +		folio_mark_uptodate(folio);
> +	}
> +
> +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>  
>  	folio_unlock(folio);
>  
> @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
>  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		bool is_prepared = false;
>  		kvm_pfn_t pfn;
>  
>  		if (signal_pending(current)) {
> @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
>  		}
>  
> -		if (is_prepared) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			ret = -EEXIST;
> -			break;
> -		}
> -
>  		folio_unlock(folio);
>  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>  			(npages - i) < (1 << max_order));
> @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		p = src ? src + i * PAGE_SIZE : NULL;
>  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>  		if (!ret)
> -			kvm_gmem_mark_prepared(folio);
> +			folio_mark_uptodate(folio);
>  
>  put_folio_and_exit:
>  		folio_put(folio);
> -- 
> 2.25.1

