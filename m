Return-Path: <kvm+bounces-14576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4FCF8A3712
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4952849F0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940A61514E0;
	Fri, 12 Apr 2024 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7gZOQUj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621A14F9EE
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 20:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712953728; cv=none; b=H7RTKc9wIqeXYqGlmC2GNR1MGkGq3cj4acE10ZbxHLzrpr6UCTbzBqEFHzcM13w34wGC1thWTFBYXZOy1ObHE2FV2PynMj1yYuAxTfFEgtzvigKThCn3TOwMoYvXjxjjxZHWNx7Tt9YfbdZR538/L86U+ozYCrFlniufn4Wz5rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712953728; c=relaxed/simple;
	bh=N7IX9nF8vCF0/TX4kpM+9leGLDqEbSW+fKgzpAt+uAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtJgpXv156wj7s9cd2ZHEpdNdGoP1/6mGNUWvuf41kEB+04oQcum7hr/41Z9gtizDMYZhsjfSkT9i8ZNnqMQvDMnSvmtmKTqtQ1ObhHyXTSV9hz50OunVQOnjdPxA/hr4iFHLLFDMz84FD5miYxeWvl+WVi0kRc7ds46jPVYL+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7gZOQUj; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6edc61d0ff6so1181015b3a.2
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712953726; x=1713558526; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pGFHwuKbuynzrcj4lfuCemo+GDIQliA585QXUWNhvcc=;
        b=e7gZOQUjOr1oZ/EUQJnbgowbDAzP8hsYRbZJQrMKJ8TMpuMa/9HNNhGg94+Zf7O6T6
         3HLx7bTDjOKZ7U3YDxOFj1StjinRslqkwbYyb509yhiYCdwegV8e1qot0FuuUaVysPdV
         HqBcrGxkfgtlChaDlXn9Vew83q3e6KobYllsG6Wf2E2hmvCRO4AzAxxetpOniZ69FcyV
         D2o3h0F0WHi6ybdUuf+dEK+qltlQw23nbA6femovHCuuPobTWIa2P1NaX2WI3jxMxKKj
         KsSW6z9pnefaTYKDHQKerR4RDSox2ZfwJ81BRGaK/gUkSGzFP2QZJODT6Dz9FhguZgvz
         WjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712953726; x=1713558526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGFHwuKbuynzrcj4lfuCemo+GDIQliA585QXUWNhvcc=;
        b=a9aqylCZ8pc/UKRp6szHWfC/aqd6Gomg0uBzb/ZiJNRTPeX9P95TR4efEFgbX/IdG/
         GGdK/OfjV8l2J4j12kRIohL4nL8O1RGEYxtId6UfmTkBlGGb1zcdR1AE4NdGRoGtbAX6
         16dNR9/DiwvR0wCRtW1ab/QAHs7zDuKoqEbHzoeR0ofaDOkdpUmeMGIo7LDpkNYwGlTD
         giMDQlzyIBriSD1QT7L+zmxt8nRRh/tnAbLhJDyBWitaOWzet+y+zS3YtGefhWhutjip
         TgGTnJl1Ra+sbZqukUlmVZLj2S/zdZUBFAJg4ItMtdPuQFyEN0ugNBFX96lUCRBC5FQb
         oodw==
X-Forwarded-Encrypted: i=1; AJvYcCVY+IGi7pLB820td0Wr7OwX4A/Ic/RP67ujPrBYjDXx9O6m+SAlDJHiPYGAVHuSpeJOqVurqL3pOe9WtEwSL0LNDng4
X-Gm-Message-State: AOJu0Yyisc1t7vpv9JfhoqBAo5FpQOg5fdNk6N00khTG2Tu4H/IX87Ss
	nflQgIu+yJ8NSdujgbj/UO5l9SImkE1dyZN+mXK8NG1PvbygXXw0phqRum3DWA==
X-Google-Smtp-Source: AGHT+IF/pyYKCdeesipfm1c6SntP3hTFdZQDzGdbrUr79KrgoGi8Ou4ETsGS1IaVSoTAedJJIXBLVg==
X-Received: by 2002:a05:6a00:a8c:b0:6ec:f28b:659f with SMTP id b12-20020a056a000a8c00b006ecf28b659fmr4075582pfl.3.1712953725642;
        Fri, 12 Apr 2024 13:28:45 -0700 (PDT)
Received: from google.com (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with ESMTPSA id fa1-20020a056a002d0100b006e6b7124b33sm3233340pfb.209.2024.04.12.13.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 13:28:45 -0700 (PDT)
Date: Fri, 12 Apr 2024 13:28:40 -0700
From: David Matlack <dmatlack@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhao <yuzhao@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Rientjes <rientjes@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] KVM: Add basic bitmap support into
 kvm_mmu_notifier_test/clear_young
Message-ID: <ZhmZeFPRwOJVue5y@google.com>
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401232946.1837665-4-jthoughton@google.com>

On 2024-04-01 11:29 PM, James Houghton wrote:
> Add kvm_arch_prepare_bitmap_age() for architectures to indiciate that
> they support bitmap-based aging in kvm_mmu_notifier_test_clear_young()
> and that they do not need KVM to grab the MMU lock for writing. This
> function allows architectures to do other locking or other preparatory
> work that it needs.

There's a lot going on here. I know it's extra work but I think the
series would be easier to understand and simplify if you introduced the
KVM support for lockless test/clear_young() first, and then introduce
support for the bitmap-based look-around.

Specifically:

 1. Make all test/clear_young() notifiers lockless. i.e. Move the
    mmu_lock into the architecture-specific code (kvm_age_gfn() and
    kvm_test_age_gfn()).

 2. Convert KVM/x86's kvm_{test,}_age_gfn() to be lockless for the TDP
    MMU.

 4. Convert KVM/arm64's kvm_{test,}_age_gfn() to hold the mmu_lock in
    read-mode.

 5. Add bitmap-based look-around support to KVM/x86 and KVM/arm64
    (probably 2-3 patches).

> 
> If an architecture does not implement kvm_arch_prepare_bitmap_age() or
> is unable to do bitmap-based aging at runtime (and marks the bitmap as
> unreliable):
>  1. If a bitmap was provided, we inform the caller that the bitmap is
>     unreliable (MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE).
>  2. If a bitmap was not provided, fall back to the old logic.
> 
> Also add logic for architectures to easily use the provided bitmap if
> they are able. The expectation is that the architecture's implementation
> of kvm_gfn_test_age() will use kvm_gfn_record_young(), and
> kvm_gfn_age() will use kvm_gfn_should_age().
> 
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  include/linux/kvm_host.h | 60 ++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      | 92 +++++++++++++++++++++++++++++-----------
>  2 files changed, 127 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1800d03a06a9..5862fd7b5f9b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1992,6 +1992,26 @@ extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
>  extern const struct kvm_stats_header kvm_vcpu_stats_header;
>  extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
>  
> +/*
> + * Architectures that support using bitmaps for kvm_age_gfn() and
> + * kvm_test_age_gfn should return true for kvm_arch_prepare_bitmap_age()
> + * and do any work they need to prepare. The subsequent walk will not
> + * automatically grab the KVM MMU lock, so some architectures may opt
> + * to grab it.
> + *
> + * If true is returned, a subsequent call to kvm_arch_finish_bitmap_age() is
> + * guaranteed.
> + */
> +#ifndef kvm_arch_prepare_bitmap_age
> +static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn)

I find the name of these architecture callbacks misleading/confusing.
The lockless path is used even when a bitmap is not provided. i.e.
bitmap can be NULL in between kvm_arch_prepare/finish_bitmap_age().

> +{
> +	return false;
> +}
> +#endif
> +#ifndef kvm_arch_finish_bitmap_age
> +static inline void kvm_arch_finish_bitmap_age(struct mmu_notifier *mn) {}
> +#endif

kvm_arch_finish_bitmap_age() seems unnecessary. I think the KVM/arm64
code could acquire/release the mmu_lock in read-mode in
kvm_test_age_gfn() and kvm_age_gfn() right?

> +
>  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
>  static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
>  {
> @@ -2076,9 +2096,16 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
>  	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
>  }
>  
> +struct test_clear_young_metadata {
> +	unsigned long *bitmap;
> +	unsigned long bitmap_offset_end;

bitmap_offset_end is unused.

> +	unsigned long end;
> +	bool unreliable;
> +};
>  union kvm_mmu_notifier_arg {
>  	pte_t pte;
>  	unsigned long attributes;
> +	struct test_clear_young_metadata *metadata;

nit: Maybe s/metadata/test_clear_young/ ?

>  };
>  
>  struct kvm_gfn_range {
> @@ -2087,11 +2114,44 @@ struct kvm_gfn_range {
>  	gfn_t end;
>  	union kvm_mmu_notifier_arg arg;
>  	bool may_block;
> +	bool lockless;

Please document this as it's somewhat subtle. A reader might think this
implies the entire operation runs without taking the mmu_lock.

>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> +
> +static inline void kvm_age_set_unreliable(struct kvm_gfn_range *range)
> +{
> +	struct test_clear_young_metadata *args = range->arg.metadata;
> +
> +	args->unreliable = true;
> +}
> +static inline unsigned long kvm_young_bitmap_offset(struct kvm_gfn_range *range,
> +						    gfn_t gfn)
> +{
> +	struct test_clear_young_metadata *args = range->arg.metadata;
> +
> +	return hva_to_gfn_memslot(args->end - 1, range->slot) - gfn;
> +}
> +static inline void kvm_gfn_record_young(struct kvm_gfn_range *range, gfn_t gfn)
> +{
> +	struct test_clear_young_metadata *args = range->arg.metadata;
> +
> +	WARN_ON_ONCE(gfn < range->start || gfn >= range->end);
> +	if (args->bitmap)
> +		__set_bit(kvm_young_bitmap_offset(range, gfn), args->bitmap);
> +}
> +static inline bool kvm_gfn_should_age(struct kvm_gfn_range *range, gfn_t gfn)
> +{
> +	struct test_clear_young_metadata *args = range->arg.metadata;
> +
> +	WARN_ON_ONCE(gfn < range->start || gfn >= range->end);
> +	if (args->bitmap)
> +		return test_bit(kvm_young_bitmap_offset(range, gfn),
> +				args->bitmap);
> +	return true;
> +}
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0545d88c802..7d80321e2ece 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -550,6 +550,7 @@ struct kvm_mmu_notifier_range {
>  	on_lock_fn_t on_lock;
>  	bool flush_on_ret;
>  	bool may_block;
> +	bool lockless;
>  };
>  
>  /*
> @@ -598,6 +599,8 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  	struct kvm_memslots *slots;
>  	int i, idx;
>  
> +	BUILD_BUG_ON(sizeof(gfn_range.arg) != sizeof(gfn_range.arg.pte));
> +
>  	if (WARN_ON_ONCE(range->end <= range->start))
>  		return r;
>  
> @@ -637,15 +640,18 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
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
> -					break;
> +				if (!range->lockless) {
> +					KVM_MMU_LOCK(kvm);
> +					if (!IS_KVM_NULL_FN(range->on_lock))
> +						range->on_lock(kvm);
> +
> +					if (IS_KVM_NULL_FN(range->handler))
> +						break;
> +				}
>  			}
>  			r.ret |= range->handler(kvm, &gfn_range);
>  		}
> @@ -654,7 +660,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  	if (range->flush_on_ret && r.ret)
>  		kvm_flush_remote_tlbs(kvm);
>  
> -	if (r.found_memslot)
> +	if (r.found_memslot && !range->lockless)
>  		KVM_MMU_UNLOCK(kvm);
>  
>  	srcu_read_unlock(&kvm->srcu, idx);
> @@ -682,19 +688,24 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
>  	return __kvm_handle_hva_range(kvm, &range).ret;
>  }
>  
> -static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
> -							 unsigned long start,
> -							 unsigned long end,
> -							 gfn_handler_t handler)
> +static __always_inline int kvm_handle_hva_range_no_flush(
> +		struct mmu_notifier *mn,
> +		unsigned long start,
> +		unsigned long end,
> +		gfn_handler_t handler,
> +		union kvm_mmu_notifier_arg arg,
> +		bool lockless)
>  {
>  	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>  	const struct kvm_mmu_notifier_range range = {
>  		.start		= start,
>  		.end		= end,
>  		.handler	= handler,
> +		.arg		= arg,
>  		.on_lock	= (void *)kvm_null_fn,
>  		.flush_on_ret	= false,
>  		.may_block	= false,
> +		.lockless	= lockless,
>  	};
>  
>  	return __kvm_handle_hva_range(kvm, &range).ret;
> @@ -909,15 +920,36 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
>  				    kvm_age_gfn);
>  }
>  
> -static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
> -					struct mm_struct *mm,
> -					unsigned long start,
> -					unsigned long end,
> -					unsigned long *bitmap)
> +static int kvm_mmu_notifier_test_clear_young(struct mmu_notifier *mn,
> +					     struct mm_struct *mm,
> +					     unsigned long start,
> +					     unsigned long end,
> +					     unsigned long *bitmap,
> +					     bool clear)

Perhaps pass in the callback (kvm_test_age_gfn/kvm_age_gfn) instead of
true/false to avoid the naked booleans at the callsites?

>  {
> -	trace_kvm_age_hva(start, end);
> +	if (kvm_arch_prepare_bitmap_age(mn)) {
> +		struct test_clear_young_metadata args = {
> +			.bitmap		= bitmap,
> +			.end		= end,
> +			.unreliable	= false,
> +		};
> +		union kvm_mmu_notifier_arg arg = {
> +			.metadata = &args
> +		};
> +		bool young;
> +
> +		young = kvm_handle_hva_range_no_flush(
> +					mn, start, end,
> +					clear ? kvm_age_gfn : kvm_test_age_gfn,
> +					arg, true);

I suspect the end result will be cleaner we make all architectures
lockless. i.e. Move the mmu_lock acquire/release into the
architecture-specific code.

This could result in more acquire/release calls (one per memslot that
overlaps the provided range) but that should be a single memslot in the
majority of cases I think?

Then unconditionally pass in the metadata structure.

Then you don't need any special casing for the fast path / bitmap path.
The only thing needed is to figure out whether to return
MMU_NOTIFIER_YOUNG vs MMU_NOTIFIER_YOUNG_LOOK_AROUND and that can be
plumbed via test_clear_young_metadata or by changing gfn_handler_t to
return an int instead of a bool.

> +
> +		kvm_arch_finish_bitmap_age(mn);
>  
> -	/* We don't support bitmaps. Don't test or clear anything. */
> +		if (!args.unreliable)
> +			return young ? MMU_NOTIFIER_YOUNG_FAST : 0;
> +	}
> +
> +	/* A bitmap was passed but the architecture doesn't support bitmaps */
>  	if (bitmap)
>  		return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;
>  
> @@ -934,7 +966,21 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
>  	 * cadence. If we find this inaccurate, we might come up with a
>  	 * more sophisticated heuristic later.
>  	 */
> -	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
> +	return kvm_handle_hva_range_no_flush(
> +			mn, start, end, clear ? kvm_age_gfn : kvm_test_age_gfn,
> +			KVM_MMU_NOTIFIER_NO_ARG, false);

Should this return MMU_NOTIFIER_YOUNG explicitly? This code is assuming
MMU_NOTIFIER_YOUNG == (int)true.

> +}
> +
> +static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
> +					struct mm_struct *mm,
> +					unsigned long start,
> +					unsigned long end,
> +					unsigned long *bitmap)
> +{
> +	trace_kvm_age_hva(start, end);
> +
> +	return kvm_mmu_notifier_test_clear_young(mn, mm, start, end, bitmap,
> +						 true);
>  }
>  
>  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
> @@ -945,12 +991,8 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
>  {
>  	trace_kvm_test_age_hva(start, end);
>  
> -	/* We don't support bitmaps. Don't test or clear anything. */
> -	if (bitmap)
> -		return MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE;
> -
> -	return kvm_handle_hva_range_no_flush(mn, start, end,
> -					     kvm_test_age_gfn);
> +	return kvm_mmu_notifier_test_clear_young(mn, mm, start, end, bitmap,
> +						 false);
>  }
>  
>  static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
> -- 
> 2.44.0.478.gd926399ef9-goog
> 

