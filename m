Return-Path: <kvm+bounces-55707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2AB2B34F86
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 01:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0BA67A3064
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516A42BEFE5;
	Mon, 25 Aug 2025 23:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="07VBr36x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0804323D7C3
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 23:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756163303; cv=none; b=u095oKyibaBXSAl1rQqF51+A9ApZb4+QynshHh1B46GQ2j/C9eeyNLAh1WeUaCc6AdcZ4a5Xi1mBackdghYkliEjIE6Mh9egON9QBT30B+zwCWFcyPuLtSY5LAo5+PAhyI9PJ4oje06XcCNS6AlqIvLeCb4KqctFBo25ra+Uq2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756163303; c=relaxed/simple;
	bh=JnpQNhUrspUsEG6Bk+5IiCAKB5CxWFoNLMNhiIbFz6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hPkL2Uyi32SPtYUYGBw64WdrAw/BXS8Mmpt6KobIJ9HyU5KyLJ+kpIzmPeT+fOQ4OLOXJOiyTyCKrdkqY/4MCMhKXsegCztOXF3c0Mftc9D/ygzaEUMrAD+uswwMVxLjECxjYKnc7kN5aKNjA7nE6B/TeSfw4gv1jg9o0+1xmuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=07VBr36x; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e4c3af5fso5068679a91.3
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 16:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756163301; x=1756768101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6PJFrEMJOsfQGkwPQ/N5M5tBh51DW0OHIWOkD4RTR+M=;
        b=07VBr36xewHbXVYao/wy2JKQtWS3mcXizRpT4epjl1fyqgnU5D450q6W156gEUoUdL
         V67Rr+JjdHwpFTQ9hplR5x+NUhQzm7mCZuoDon8BQ9PiMw724cceKgE3uKXSZhfy3mMQ
         NtjyFvZJ6XdSjO0S20h96qWzpPU+UkPh5xzlbB+7V3YlP8nn85otzIhdfi9UuJK2ysbM
         4OUjU7ro6dO5QC6QrtrfJUYWzAQn5Qmjfrxfz9opvYiyjxKsdPFpfw5UE+DfnDi5H0/M
         9DbsKjMIFqfSX4dvvyMnsRKi3PDiToRynavg/YP9DZs9V1xknQlUB7PlAZjVtjjmLqJV
         7Ghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756163301; x=1756768101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PJFrEMJOsfQGkwPQ/N5M5tBh51DW0OHIWOkD4RTR+M=;
        b=Bz+c47KZeHJYB4DGCn2riwN6fu894flBghBmZuY8Un1LQIVQJCuF93SB+Lv/g/dp2N
         FPlP8Ak1wkOl7CSm0EkOcsUu0WdNdTUCepNuoTUhukcSNSAQYVNQ/E1OBa+MQRMHQqDV
         kP1XnT88h0DDmnda/aL/Vz20X3c5wLoJR7/p714TzaETEWXAmQiP1wV6v1i1mdaRuoFg
         6l9g0X37ms5hBRa4teTTMZr+05hRgXdJj8iI7iRFpaazqDck4wr1V4i+U2j8Vbk74l/l
         zf3vuwLWjJzEJPveZhdMXTPhkfma1y+nObJ7Ny0/Q6fzA9kf884nribASs4dhcXvwU+/
         Phxw==
X-Forwarded-Encrypted: i=1; AJvYcCXlnmYUMJVLL/LeRGEP4BJqJqbxJYB+3bDk4un+joqGC1+RfZGtA27tOcQ9Rj92cDKErHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF9f02Rj1vrkGnpOgYxfDlJX9e0GyNYPG1XlGtiH07V1HXPEyB
	jDbIQVLjnzd8lhx0+VpYk12018AAukaeWIeAfqtyUr5+3CJWSyeTL7vrNeH92ek1T3q0xnf1fVg
	l3VYWL2y6sCpb2Kdj/MgwloeEBg==
X-Google-Smtp-Source: AGHT+IGrq+HLRwUNYqwfx0diY7kjY6ycSz8/ZKkUZKHTSFbsyen18fZ+mR6CbkMqwPv1W2G7A6frXbr5O63R9MtgwQ==
X-Received: from pjbpl15.prod.google.com ([2002:a17:90b:268f:b0:325:220a:dd41])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f88:b0:31c:36f5:d95 with SMTP id 98e67ed59e1d1-32515e2b881mr14983372a91.2.1756163301311;
 Mon, 25 Aug 2025 16:08:21 -0700 (PDT)
Date: Mon, 25 Aug 2025 16:08:19 -0700
In-Reply-To: <20250613005400.3694904-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com> <20250613005400.3694904-2-michael.roth@amd.com>
Message-ID: <diqztt1vf198.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"

Michael Roth <michael.roth@amd.com> writes:

> guest_memfd currently uses the folio uptodate flag to track:
>
>   1) whether or not a page had been cleared before initial usage
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
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 32 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 35f94a288e52..cc93c502b5d8 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
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
> @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
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
> @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,

While working on HugeTLB support for guest_memfd, I added a test that
tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
gfn.

I understand that config would destroy the performance advantages of
huge pages, but I think the test is necessary since Yan brought up the
use case here [1].

The conclusion in that thread, I believe, was to allow binding of
unaligned GFNs to offsets, but disallow large pages in that case. The
next series for guest_memfd HugeTLB support will include a fix similar
to this [2].

While testing, I hit this WARN_ON with a non-huge-page-aligned
gmem.pgoff.

>  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));

Do you all think this WARN_ON can be removed?

Also, do you think kvm_gmem_prepare_folio()s interface should perhaps be
changed to take pfn, gfn, nr_pages (PAGE_SIZE pages) and level?

I think taking a folio is kind of awkward since we're not really setting
up the folio, we're setting up something mapping-related for the
folio. Also, kvm_gmem_invalidate() doesn't take folios, which is more
aligned with invalidating mappings rather than something folio-related.

[1] https://lore.kernel.org/all/aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com/
[2] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df

>  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
>  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
> -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> -	if (!r)
> -		kvm_gmem_mark_prepared(folio);
>  
> -	return r;
> +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
> 
> [...snip...]
> 

