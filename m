Return-Path: <kvm+bounces-55677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E40CB34D82
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883F33AC5F0
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1538A29BDAC;
	Mon, 25 Aug 2025 21:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m9umoNnG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C161628DF2B
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 21:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155926; cv=none; b=ftbsHeBVJZtBx2EStY88VhZnPZL90vSN6TuuExFP5rIs6RLgVKGo9Ssqs4oik9vzsMRVvdDbEd0Kb/AZIsJyawPslFk0KH1SwL4DVCsYioPHK8vPnuFlamF5002Hv5nTTqgXvXV8JegwjxzE1JSWukVTYshP0Cw/qwz7BhuJPC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155926; c=relaxed/simple;
	bh=FMCrqrks/dXpZHsprf5BWivpfad0MjoU6jkP3WQ/7Og=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IAQVYuAbM5qVCh5dHysWDzqyx1RSfl69Mk1aYY4rVmxg4hN5oyQRkBKMc6Uy6fiWuCxkqLzi0nT+rsmWChOBV5X7AvVtLWru//Fuef6Q4tqpl9V1qvbzBcRx66A5T+aoQI66R8DBoitPodFMsc3kVw2AMn+0RDA40LdbBRQ9M4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m9umoNnG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-325228e9bedso6171728a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756155924; x=1756760724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7d15ca6DDhUkwd5VLfHJQyeR86hJJRH7e9ofbHHP6cU=;
        b=m9umoNnGILYqNDaKr7ZJw2hjYFHmzqKLHKpnRXjARP1K/u8ZwGywfslURERyjYemag
         SPkVcYvRdUAPcbt7kNlpFu/NjncDHgnnjAC7rwbGE1LH/OkKQjIPVJsq1ZNOnnfcRLvs
         0lyFFBmCI490zKXkbFhuTWVdWgEkYEOyokA3mMcJym/cvSN1lmTlLMHQ+wdoc7D6WHdw
         2XXQ+oo4U0GKK28YnaxmrHX/IRgxDGNV0Us7Zk9DgOKckvhiO/WNCN4G4OA2kg7//aoF
         B8Z3SJ8bxtN5QTf7NtKSUaw4iIwN83kr24GAjANZpZzQf/wyDUUEG1VxTgnyG+/+0aXp
         D5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756155924; x=1756760724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7d15ca6DDhUkwd5VLfHJQyeR86hJJRH7e9ofbHHP6cU=;
        b=b37VN+tF5cdeNqG4t9kkTDLRzVJQOLh+fgrN+PrpRmipwwEZJSz5Hwj6Anep9CJdB9
         C2+JJR0TYXAV2ykwaiaNUeKOJ+TOTfeuMC7yylAkq9ZuTpdSuJiRwc/yVa0/00Bdw2kG
         NJJWhPphWdvDVX2aPuSAjpUIgP9OcO/1x0ItRJTvFTVy522/KWLgwFjjvpvIviB2d/ru
         QMKyFmyXg4mLXliQtB3zu9oTFI6at2AgwV723VUHKA0uM9i50BymFisFHKuyUHaMXqPR
         LAK7EyV9squ5VaDbOdsB18SKd6sLTN/5Qxk2ETbsQ0bIHVKXsGArlSbdG65OfEem70vw
         JTBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUge8dmnWwzfVT7Hq/1pc97cEWl16YxCQ6C6KtYFjtAeb4tSnzXvv0HPP2vs/lxSQfIrMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzozFwcNH4Sir63o/ve9dKB3a31piigfNQn2CYTZ+KncIA4gqV7
	OymE7dwDdopSkSOLlhuE3Rq1tWrbxrN8iJOlMg8jHfr8oen3VyWalbyYyoojI/3Kq4NshB5pJ0I
	5+HQvYQ==
X-Google-Smtp-Source: AGHT+IEm4/q7R9vqsalDGxIoUCdP69IoDYNKhvzEhXQffHVAOixTwa8x+rJdf1yKoahs9B9e41d388NCl58=
X-Received: from pjn5.prod.google.com ([2002:a17:90b:5705:b0:325:b894:3c4f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384a:b0:325:8e03:c159
 with SMTP id 98e67ed59e1d1-3258e03c39amr6971375a91.9.1756155924087; Mon, 25
 Aug 2025 14:05:24 -0700 (PDT)
Date: Mon, 25 Aug 2025 14:05:22 -0700
In-Reply-To: <20250822080235.27274-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822080100.27218-1-yan.y.zhao@intel.com> <20250822080235.27274-1-yan.y.zhao@intel.com>
Message-ID: <aKzQEi4fykQwvqLE@google.com>
Subject: Re: [PATCH v3 2/3] KVM: Skip invoking shared memory handler for
 entirely private GFN ranges
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, peterx@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 22, 2025, Yan Zhao wrote:
> When a GFN range is entirely private, it's unnecessary for
> kvm_handle_hva_range() to invoke handlers for the GFN range, because
> 1) the gfn_range.attr_filter for the handler is KVM_FILTER_SHARED, which
>    is for shared mappings only;
> 2) KVM has already zapped all shared mappings before setting the memory
>    attribute to private.
> 
> This can avoid unnecessary zaps on private mappings for VMs of type
> KVM_X86_SW_PROTECTED_VM, e.g., during auto numa balancing scans of VMAs.

This feels like the wrong place to try and optimize spurious zaps.  x86 should
be skipping SPTEs that don't match.  For KVM_X86_SW_PROTECTED_VM, I don't think
we care about spurious zpas, because that's a testing-only type that doesn't have
line of sight to be being a "real" type.

For SNP, we might care?  But actually zapping private SPTEs would require
userspace to retain the shared mappings across a transition, _and_ be running
NUMA autobalancing in the first place.  If someone actually cares about optimizing
this scenario, KVM x86 could track private SPTEs via a software-available bit.

We also want to move away from KVM_MEMORY_ATTRIBUTE_PRIVATE and instead track
private vs. shared in the gmem instance.

So I'm inclined to skip this...

> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  virt/kvm/kvm_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f769d1dccc21..e615ad405ce4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -620,6 +620,17 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.slot = slot;
>  			gfn_range.lockless = range->lockless;
>  
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +			/*
> +			 * If GFN range are all private, no need to invoke the
> +			 * handler.
> +			 */
> +			if (kvm_range_has_memory_attributes(kvm, gfn_range.start,
> +							    gfn_range.end, ~0,
> +							    KVM_MEMORY_ATTRIBUTE_PRIVATE))
> +				continue;
> +#endif
> +
>  			if (!r.found_memslot) {
>  				r.found_memslot = true;
>  				if (!range->lockless) {
> -- 
> 2.43.2
> 

