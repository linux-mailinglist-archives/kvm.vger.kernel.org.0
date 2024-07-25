Return-Path: <kvm+bounces-22257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B5893C746
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 18:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7322B20FAE
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2343419DF7A;
	Thu, 25 Jul 2024 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S0YKy6Mu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF019D07C
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721925580; cv=none; b=QZsMwWZbC96XgzAluPeKmSbxovPL4iXoRf/0ZjDcQ3TaQd9VFwNcfAo/op/eRZ79FWah6KznI2JjwYHou8dVyBIHC06T3Zr8Z6uh0S3Bq4Btv+Uv7ztPshmgCfL9zGOPm5VXbxBHVZx6aEXpReycxnL6BF4fhpbX833hmmuYY1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721925580; c=relaxed/simple;
	bh=w0v/iJYVRDvOuOk+qu46YJbJyYB3+t4haue0iNRD7WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVRjobhKE/SdfXh4+p35KwR7rcAchP97pw41LQVYF6yvaR7O2d0ZwbsOVDcg/Rz4mLFw5JGl4kf/sDlAqKODC9y5hgAEv7rD/B84kpigO8OaXqeZ/Hp20CKe8R+Jy8c7c1HIuDw0A5I9ZMYCAdiBn5K/lsebOOB+QbruM2uGFUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S0YKy6Mu; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fc658b6b2eso10117885ad.0
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 09:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721925578; x=1722530378; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QcSVy1tvOkU8yRLWC0qxdbVVrc8ZEhqmlAiyT2QSHkE=;
        b=S0YKy6MuYJ0E+8qrH9Xa3OH0armCipBpLZVS/WSDO9404TnPqoFMtiZTILMqjEbA5d
         xMqEEiSOmU1iLHEuIa4LfnJ2FY9Gd/OUDxPP5oHG4V/c8JMTq+ipl9yltGCMjqtR4dYH
         suYF5LheXRoNIqt5j2yXMLBGu8heby5NmwLR0YmrNjIJTRrA0qK8i0MLjY6f4SNwy+Go
         Q1Urtg7cVvf/eZrTPJMEsfSKkphJuoGGVH3ZOZQjA4fbGxnILVgXunOQiddvXtKSJGmm
         Sd0x/jkPHQ9wh+Cr8H+L8/LS6e3t+mqbanlyk1k8GldHnZ8AbFPryMUn1s46aWWZXcDk
         rGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721925578; x=1722530378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcSVy1tvOkU8yRLWC0qxdbVVrc8ZEhqmlAiyT2QSHkE=;
        b=XHOiJ01G3T0zVQ+4h5pEX0AYIjgFhMclI3WTjG7L2M0DI2vHgU+jaJIK0q2ckyLVfI
         o3qLo+OYslxZmV8yVroIlKxbbzRzmF9KHsYvviGAhSxViGD/RBDUsG4jGCKGP/x07vpS
         8GdJkg4ger3donDLhGMqDe+RwgH7XkyMJyCCEONMCYDznV7h/vHjW0czq/EGQog6UifY
         /OEXS+P2aaickuqydgivDeY5QGBxZ78gQghaasYMZFFWz7e57l7rsSEKPhQfSQZgXZ0E
         cNYJ/Fg3x2hLglfiTIifHAYdoPIpwTPkDg5Trd0q2aPwdK/acjunmQmnwJzHe5M9d63J
         LMnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX94Elf0ydNhafADC/rpkodRm+Pbk2oUP7McQb0C9MXNTewtvCv+o9itth2gnqdKLm1gDmjUnC4m190MzKktDUZeuhV
X-Gm-Message-State: AOJu0YzFnikCnMX2Z0TgqOYwXIVDiqCK1OQ8soxy/WF1IxbvpXhTPOak
	aIPQ4ZyVA1diPytfDQBSFrksHlffa7uY+JT7hKySkB/mF2IloAnXZPv/mGcv6Q==
X-Google-Smtp-Source: AGHT+IHB3MBDNmfV4qXP0PeruhsiIcuNxKT7iPw0JA5SjJko2zFwnnPefUglyTGQ1O1zxG/RUL8Ssw==
X-Received: by 2002:a17:903:1246:b0:1f8:6bae:28f with SMTP id d9443c01a7336-1fed3870ea6mr39885005ad.9.1721925577381;
        Thu, 25 Jul 2024 09:39:37 -0700 (PDT)
Received: from google.com (61.139.125.34.bc.googleusercontent.com. [34.125.139.61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4ce6sm16408675ad.157.2024.07.25.09.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 09:39:36 -0700 (PDT)
Date: Thu, 25 Jul 2024 09:39:32 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 01/11] KVM: Add lockless memslot walk to KVM
Message-ID: <ZqJ_xANKf3bNcaHM@google.com>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724011037.3671523-2-jthoughton@google.com>

On 2024-07-24 01:10 AM, James Houghton wrote:
> Provide flexibility to the architecture to synchronize as optimally as
> they can instead of always taking the MMU lock for writing.
> 
> Architectures that do their own locking must select
> CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.
> 
> The immediate application is to allow architectures to implement the
> test/clear_young MMU notifiers more cheaply.
> 
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

Aside from the cleanup suggestion (which should be in separate patches
anyway):

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/Kconfig         |  3 +++
>  virt/kvm/kvm_main.c      | 26 +++++++++++++++++++-------
>  3 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 689e8be873a7..8cd80f969cff 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -266,6 +266,7 @@ struct kvm_gfn_range {
>  	gfn_t end;
>  	union kvm_mmu_notifier_arg arg;
>  	bool may_block;
> +	bool lockless;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index b14e14cdbfb9..632334861001 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -100,6 +100,9 @@ config KVM_GENERIC_MMU_NOTIFIER
>         select MMU_NOTIFIER
>         bool
>  
> +config KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
> +       bool
> +
>  config KVM_GENERIC_MEMORY_ATTRIBUTES
>         depends on KVM_GENERIC_MMU_NOTIFIER
>         bool
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..33f8997a5c29 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -555,6 +555,7 @@ struct kvm_mmu_notifier_range {
>  	on_lock_fn_t on_lock;
>  	bool flush_on_ret;
>  	bool may_block;
> +	bool lockless;
>  };
>  
>  /*
> @@ -609,6 +610,10 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  			 IS_KVM_NULL_FN(range->handler)))
>  		return r;
>  
> +	/* on_lock will never be called for lockless walks */
> +	if (WARN_ON_ONCE(range->lockless && !IS_KVM_NULL_FN(range->on_lock)))
> +		return r;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  
>  	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> @@ -640,15 +645,18 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
>  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
>  			gfn_range.slot = slot;
> +			gfn_range.lockless = range->lockless;
>  
>  			if (!r.found_memslot) {
>  				r.found_memslot = true;
> -				KVM_MMU_LOCK(kvm);
> -				if (!IS_KVM_NULL_FN(range->on_lock))
> -					range->on_lock(kvm);
> -
> -				if (IS_KVM_NULL_FN(range->handler))
> -					goto mmu_unlock;
> +				if (!range->lockless) {
> +					KVM_MMU_LOCK(kvm);
> +					if (!IS_KVM_NULL_FN(range->on_lock))
> +						range->on_lock(kvm);
> +
> +					if (IS_KVM_NULL_FN(range->handler))
> +						goto mmu_unlock;
> +				}
>  			}
>  			r.ret |= range->handler(kvm, &gfn_range);
>  		}
> @@ -658,7 +666,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  		kvm_flush_remote_tlbs(kvm);
>  
>  mmu_unlock:
> -	if (r.found_memslot)
> +	if (r.found_memslot && !range->lockless)
>  		KVM_MMU_UNLOCK(kvm);
>  
>  	srcu_read_unlock(&kvm->srcu, idx);
> @@ -679,6 +687,8 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
>  		.on_lock	= (void *)kvm_null_fn,
>  		.flush_on_ret	= true,
>  		.may_block	= false,
> +		.lockless	=
> +			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
>  	};
>  
>  	return __kvm_handle_hva_range(kvm, &range).ret;
> @@ -697,6 +707,8 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
>  		.on_lock	= (void *)kvm_null_fn,
>  		.flush_on_ret	= false,
>  		.may_block	= false,
> +		.lockless	=
> +			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),

kvm_handle_hva_range{,_no_flush}() have very generic names but
they're intimately tied to the "young" notifiers. Whereas
__kvm_handle_hva_range() is the truly generic handler function.

This is arguably a pre-existing issue, but adding
CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS makes these functions even more
intamtely tied to the "young" notifiers.

We could rename kvm_handle_hva_range{,_no_flush}() but I think the
cleanest thing to do might be to just drop them entirely and move their
contents into their callers (there are only 2 callers of these 3
functions). That will create a little duplication but IMO will make the
code easier to read.

And then we can also rename __kvm_handle_hva_range() to
kvm_handle_hva_range().

e.g. Something like this as the end result:


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 86fb2b560d98..0146c83e24bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -590,8 +590,8 @@ static void kvm_null_fn(void)
 	     node;							     \
 	     node = interval_tree_iter_next(node, start, last))	     \
 
-static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
-							   const struct kvm_mmu_notifier_range *range)
+static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
+							 const struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_mmu_notifier_return r = {
 		.ret = false,
@@ -674,48 +674,6 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	return r;
 }
 
-static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
-						unsigned long start,
-						unsigned long end,
-						gfn_handler_t handler)
-{
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_mmu_notifier_range range = {
-		.start		= start,
-		.end		= end,
-		.handler	= handler,
-		.on_lock	= (void *)kvm_null_fn,
-		.flush_on_ret	= true,
-		.may_block	= false,
-		.lockless	=
-			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
-	};
-
-	return __kvm_handle_hva_range(kvm, &range).ret;
-}
-
-static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
-							 unsigned long start,
-							 unsigned long end,
-							 gfn_handler_t handler,
-							 bool fast_only)
-{
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_mmu_notifier_range range = {
-		.start			= start,
-		.end			= end,
-		.handler		= handler,
-		.on_lock		= (void *)kvm_null_fn,
-		.flush_on_ret		= false,
-		.may_block		= false,
-		.lockless		=
-			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
-		.arg.fast_only		= fast_only,
-	};
-
-	return __kvm_handle_hva_range(kvm, &range).ret;
-}
-
 void kvm_mmu_invalidate_begin(struct kvm *kvm)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -808,7 +766,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * that guest memory has been reclaimed.  This needs to be done *after*
 	 * dropping mmu_lock, as x86's reclaim path is slooooow.
 	 */
-	if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
+	if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
 		kvm_arch_guest_memory_reclaimed(kvm);
 
 	return 0;
@@ -854,7 +812,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	};
 	bool wake;
 
-	__kvm_handle_hva_range(kvm, &hva_range);
+	kvm_handle_hva_range(kvm, &hva_range);
 
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
@@ -876,6 +834,17 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long start,
 					      unsigned long end)
 {
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_mmu_notifier_range range = {
+		.start		= start,
+		.end		= end,
+		.handler	= kvm_age_gfn,
+		.on_lock	= (void *)kvm_null_fn,
+		.flush_on_ret	= true,
+		.may_block	= false,
+		.lockless	= IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
+	};
+
 	trace_kvm_age_hva(start, end, false);
 
 	return kvm_handle_hva_range(mn, start, end, kvm_age_gfn);
@@ -887,6 +856,18 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					unsigned long end,
 					bool fast_only)
 {
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_mmu_notifier_range range = {
+		.start		= start,
+		.end		= end,
+		.handler	= kvm_age_gfn,
+		.on_lock	= (void *)kvm_null_fn,
+		.flush_on_ret	= false,
+		.may_block	= false,
+		.lockless	= IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
+		.arg.fast_only	= fast_only,
+	};
+
 	trace_kvm_age_hva(start, end, fast_only);
 
 	/*
@@ -902,8 +883,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
-	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn,
-					     fast_only);
+	return kvm_handle_hva_range(kvm, &range).ret;
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -911,6 +891,18 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       unsigned long address,
 				       bool fast_only)
 {
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_mmu_notifier_range range = {
+		.start		= address,
+		.end		= address + 1,
+		.handler	= kvm_test_age_gfn,
+		.on_lock	= (void *)kvm_null_fn,
+		.flush_on_ret	= false,
+		.may_block	= false,
+		.lockless	= IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
+		.arg.fast_only	= fast_only,
+	};
+
 	trace_kvm_test_age_hva(address, fast_only);
 
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,

>  	};
>  
>  	return __kvm_handle_hva_range(kvm, &range).ret;
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

