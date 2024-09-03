Return-Path: <kvm+bounces-25786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B52EA96A83A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 22:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68454285691
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF171D0177;
	Tue,  3 Sep 2024 20:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rn7X9otZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CF641C65
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 20:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395027; cv=none; b=HrL+xFbdq8WEYEL5q/paJSOjuu+nOUqNYoPTz+rnxk5GOv03MZjqFSIjRpu0OyBXIZh6MWCVLfCwsOMaH0yrmeDvTNf9BXbnJ7EgFHJDuTseq5/2LrAbWkCNmc24AKZ+eJkl4XngRJ8t3OJyLuu1/yrOxQITiZ64lIJGCY6SZf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395027; c=relaxed/simple;
	bh=8gOe8SgkgFl79JRNbZ1px6ikd6VAHRUETQTteZr2MG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksEpFdQevGcC+jtaKsjmIri8EdsiIyACqmnX77DzpihG6fz63uplg6n9Da7osUl6bXN4fAVQPUhc1i1637WYmIaYL/GWUCZa0eVBrAjhirJQ4b+bGOn+aRbJpm8L/x6+Bv2TMCqyOXt6nvmJZIFopeYv9GpzQepC80P9KNrLfMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rn7X9otZ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2056aa5cefcso11665ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 13:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725395025; x=1725999825; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qbuCKGzwQIE8OQvh3Ibqt9ERvbhH85xBPEVndwdEVXI=;
        b=rn7X9otZvrLGt3IFUclSlS1itNGgGlTDa8kS0rIEY+HjpSHDxgnlOtFz7u5Y5m0sPF
         iVPYCCeidPhgAGBXEiLdbXY44ifSnedSWtbe/5NkXnSc838UAecO3aAOv/W1R1I/Vudj
         /of6ugtnfScmbdJ0kOp9XWDi0/Nz8rUdQi7v6ts8CNwpgtVdxLu+3vD7R+HrffzlCWnK
         KYH6ALxBUkQf705C58q97oPitk+fM1HHFjNF6HBl/1+PqHGC71cxPZ3cRj3e/TttH9y6
         xHmISNNiC8CZ2b4r0CQsSLDnTyohBDoNf+syQO4xoY/f1unBrI6skwRMNOX5Gl0dNUTh
         QXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725395025; x=1725999825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbuCKGzwQIE8OQvh3Ibqt9ERvbhH85xBPEVndwdEVXI=;
        b=oGvxPTCJcbkccEvp8ETKZvOC/hlKOLKVhFuVPrHsfE8u05vizFSXbip7spniieONq8
         irjkrxVWo48dg+OiwSffelQRlCAH+zQiGukJ32L1SXmaD0zo2uyZfmTWtMPl0NoE0mVq
         rLclVmKz2yetKGJGMm79RxVIPh6QZULMvxKbPQ1eYo7duWKC2xH8vywNOe7kkKsbNogC
         l0wRDTXO5ZexM74IcS2BDR+R/TEgtbd3QjUoYsvzR+mrP7xiIqs1XNN+XdoRCrMbwUOR
         Cum7eu9vlwv410WJtmihkhdJLIJ6TtleuFOYSj7rstK3CQg8U67hEjEq7Myr6wzf07Cr
         2zkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiHg7tztEKzUJKw1virtJUw0H4f0AMoU5OgCd1VKFx4rBJNwQj8oot1AanXhNh5hy7Jzs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgYC6VK2KQWehtfLwDbjnBw79xV5mJ7CizMxqDCVp1XbJMF6Jv
	1ojlkEYkrzFFE2eymjoBDwjQlg3YT7DINIO6NQsiwnKesQtdWZa32agXL/EZRE76IEQnJ9nocGa
	ypQ==
X-Google-Smtp-Source: AGHT+IG1fM5PFFRTAfAeBqxcHt3GhgHnkwns3s2TeeDNrmCSJMIlcxI0UzdRK/x0l8+D8J03VvAhCA==
X-Received: by 2002:a17:902:db01:b0:1f9:dc74:6c2b with SMTP id d9443c01a7336-206b5b776aamr23665ad.29.1725395024452;
        Tue, 03 Sep 2024 13:23:44 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71778522926sm279379b3a.44.2024.09.03.13.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 13:23:43 -0700 (PDT)
Date: Tue, 3 Sep 2024 13:23:39 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
Message-ID: <20240903202339.GA378741.vipinsh@google.com>
References: <20240829191135.2041489-1-vipinsh@google.com>
 <20240829191135.2041489-5-vipinsh@google.com>
 <ZtDU3x9t66BnpPt_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtDU3x9t66BnpPt_@google.com>

On 2024-08-29 13:06:55, Sean Christopherson wrote:
> On Thu, Aug 29, 2024, Vipin Sharma wrote:
> >  		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> 
> Tsk, tsk.  There's a cond_resched_rwlock_write() lurking here.

I'm gonna order a dunce cap.

> 
> Which is a decent argument/segue for my main comment: I would very, very strongly
> prefer to have a single flow for the control logic.  Almost all of the code is
> copy+pasted to the TDP MMU, and there unnecessary and confusing differences between
> the two flows.  E.g. the TDP MMU does unaccount_nx_huge_page() preemptively, while
> the shadow MMU does not.
> 
> The TDP MMU has a few extra "locks" (rcu_read_lock() + tdp_mmu_pages_lock), but
> I don't see any harm in taking those in the shadow MMU flow.  KVM holds a spinlock
> and so RCU practically is meaningless, and tdp_mmu_pages_lock will never be
> contended since it's only ever taken under mmu_lock.
> 
> If we _really_ wanted to bury tdp_mmu_pages_lock in the TDP MMU, it could be
> passed in as an optional paramter.  I'm not super opposed to that, it just looks
> ugly, and I'm not convinced it's worth the effort.  Maybe a middle ground would
> be to provide a helper so that tdp_mmu_pages_lock can stay 64-bit only, but this
> code doesn't need #ifdefs?

How about declaring in tdp_mmu.h and providing different definitions
similar to is_tdp_mmu_page(), i.e. no-op for 32bit and actual lock usage
for 64 bit build?

> 
> Anyways, if the helper is __always_inline, there shouldn't be an indirect call
> to recover_page().  Completely untested, but this is the basic gist.
> 

One more way I can do is to reuse "shared" bool to decide which
nx_recover_page_t to call. Something like:

static __always_inline void kvm_recover_nx_huge_pages(...)
{
...
    if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
	if (shared)
		flush |= tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
	else
		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);

}

tdp_mmu_zap_possible_nx_huge_page() can print WARN_ONCE() and return if
shadow MMU page is passed to it. One downside is now that "shared" bool
and "pages" list are dependent on each other.

This way we don't need to rely on __always_inline to do the right thing
and avoid function pointer call.

I think using bool is more easier to understand its uage compared to
understanding why we used __always_inline. What do you think?


> ---
> typedef bool (*nx_recover_page_t)(struct kvm *kvm, struct kvm_mmu_page *sp,
> 				  struct list_head *invalid_pages);
> 
> static __always_inline void kvm_recover_nx_huge_pages(struct kvm *kvm,
> 						      bool shared,
> 						      spinlock_t *list_lock;
> 						      struct list_head *pages,
> 						      unsigned long nr_pages,
> 						      nx_recover_page_t recover_page)

