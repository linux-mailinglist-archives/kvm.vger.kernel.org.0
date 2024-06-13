Return-Path: <kvm+bounces-19633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDE3907DF0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 23:15:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 541311C22A6A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 21:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F419143C59;
	Thu, 13 Jun 2024 21:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kSVhbVO2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323DE7604D
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 21:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313324; cv=none; b=WD19oT13hSwboyTPlvhIHAQWkOaTA24zhKtz9+81zWBOqWSlyOv8PNNQkN2RYA+f1gFr+GlyK8NGFTKpyAmlKsNNgRR2IuSCJsO6T4BL6jie2YUHfFMxE61iYhk4/vSYt97dEUZtGbdeMAWgbQhK1bwvIt/4I8tbkwcYvxGfH4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313324; c=relaxed/simple;
	bh=otpjWfOj/P3HY6NhzwMzWb+mDk9KLd0gam744reGguc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=re+DVQhiHAxgwhsN4TGQadgDE2u7f4XlMc8hYHhGNdGHetrzM3Ur72t9V8sEq0zr3UKBYSmjDmd3yktJSD+4E00OqEGk9AiAq3FOZgby2Iafnr723OS5fDvg9yvkNRZe1u45KQUwOwPgmAwe5Ag3QI49vgZ+CE9fGVbZEMGq17I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kSVhbVO2; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-6c4f3e0e3d2so1167167a12.1
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 14:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718313322; x=1718918122; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t25aB9Gq8it2Mtps73/qLgo6F2v2XleuU6e8SRbqil8=;
        b=kSVhbVO2foR4tMo7PMTvTEvL4qDCQbgtu0vA2F3CeKPgC+HJ5fX+GMNWhEX6/zOdzi
         joLU3XSqN6RUpA5yU6wVTMHVzQol5Sgq4NDvnoQNQzGcyf3WZW4omdIeyfUol7yaEnMD
         HPszUb/9NJMeB2um2BbjmIexLOK098liMbIIuJkLm+gYaPoTNGmGmdGeLiegTLX4d/cH
         pKHUI3MDDMdp8bqZUOHg9ROonimg2qcnIlaS4iGdbXqI6vfmcGOb7cq+rNLalaVnanRN
         6tEB5Ap3dkv6cE8AM3dtyE84MAYeFqefn7b2Iixykw19nZT5oOOB4JAZpOw2WxO6t6Uk
         wtuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718313322; x=1718918122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t25aB9Gq8it2Mtps73/qLgo6F2v2XleuU6e8SRbqil8=;
        b=Z44FOyS9+eMYrybW/py95eABi81w/tT/FC2bD2U05YGEWBI+tD2KpnCklNpKg2JtPa
         XkOHu9z45oU8HKkAzYR2EpakKEq39gaQmdZpTCZYDBuL/3YOrzMfzYgauAci93lJ/OdK
         rstA2sE9/i7mrJuziVJjJK8GFudTXiSQsBaymXpGnDPQH14HXgfJw2asRqFv65/612XK
         AXx9dtFdRnt8HN+ufrHt3EiW7/764PlQS4vf2DEm1vjNmKqsa/w+u5wmvUEKOKykkUbK
         pILpWE/lJry0b7Y63r+zbtTOmNtzs/RGfBt+vTqEMmMxYKa9yRKb4Mn8r46Q1Ny2jm7k
         gvrw==
X-Forwarded-Encrypted: i=1; AJvYcCXTU+aa0xESrmjwmC3fHbydgZrQApJVy3SeKkI3kSxTlVLMc3JNUiEIZaewnHKO0bvPg+uUt5tRVic9caPYO3tEJ6j7
X-Gm-Message-State: AOJu0YyzVFqdRzBU6J08oE/TlfyPCEbo0214RmX0i75bLzgv+nDBQpxb
	qBU9plMl4rDs86f25fmjdT7Z6P2HdCgipCYylJWvGAsySMWqgp2vvyVE9xmNKg==
X-Google-Smtp-Source: AGHT+IFKK7MiyDs9i/VS74ftQi6VQh4wr14lBKqhEpRuOzZqONxAk+Ykt14WDFapc978v2dOqaOubg==
X-Received: by 2002:a17:902:e549:b0:1f7:11dd:6d8e with SMTP id d9443c01a7336-1f862804baemr11521685ad.48.1718313321985;
        Thu, 13 Jun 2024 14:15:21 -0700 (PDT)
Received: from google.com (210.145.16.34.bc.googleusercontent.com. [34.16.145.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1ad05sm18578555ad.242.2024.06.13.14.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 14:15:21 -0700 (PDT)
Date: Thu, 13 Jun 2024 14:15:17 -0700
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Clean up function comments for dirty
 logging APIs
Message-ID: <ZmthZVGmgcM5NQEm@google.com>
References: <20240611215805.340664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611215805.340664-1-seanjc@google.com>

On 2024-06-11 02:58 PM, Sean Christopherson wrote:
> Rework the function comment for kvm_arch_mmu_enable_log_dirty_pt_masked(),
> as it has gotten a bit stale, and is the last source of warnings for W=1
> builds in KVM x86 due to using a kernel-doc comment without documenting
> all parameters.
> 
> Opportunistically subsume the functions comments for
> kvm_mmu_write_protect_pt_masked() and kvm_mmu_clear_dirty_pt_masked(), as
> there is no value in regurgitating the same parameter information, and
> capturing the differences between write-protection and PML-based dirty
> logging is best done in a common location.
> 
> No functional change intended.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> I don't actually care too much about the comment itself, I really just want to
> get rid of the annoying warnings (I was *very* tempted to just delete the extra
> asterisk), so if anyone has any opinion whatsoever...

I vote to drop it and document the nuance around PML in the function
body itself. The initially-all-set / huge page stuff is already mostly
documented in the function body. e.g.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dfea48bdd285..d56fa757ee81 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1372,24 +1372,16 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	}
 }

-/**
- * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
- * PT level pages.
- *
- * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
- * enable dirty logging for them.
- *
- * We need to care about huge page mappings: e.g. during dirty logging we may
- * have such mappings.
- */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
 	/*
-	 * Huge pages are NOT write protected when we start dirty logging in
-	 * initially-all-set mode; must write protect them here so that they
-	 * are split to 4K on the first write.
+	 * If the slot was assumed to be "initially all dirty", write-protect
+	 * huge pages to ensure they are split to 4KiB on the first write (KVM
+	 * dirty logs at 4KiB granularity). If eager page splitting is enabled,
+	 * try to split pages, e.g. so that vCPUs don't get saddled with the
+	 * cost of splitting.
 	 *
 	 * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
 	 * of memslot has no such restriction, so the range can cross two large
@@ -1411,7 +1403,16 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 						       PG_LEVEL_2M);
 	}

-	/* Now handle 4K PTEs.  */
+	/*
+	 * Re(enable) dirty logging for all 4KiB SPTEs that map the GFNs in
+	 * mask. If PML is enabled and the and the GFN doesn't need to be
+	 * write-protected for other reasons, e.g. shadow paging, clear the
+	 * Dirty bit. Otherwise clear the Writable bit.
+	 *
+	 * Note that kvm_mmu_clear_dirty_pt_masked() is called whenever PML is
+	 * enabled but it chooses between clearing the Dirty bit and Writeable
+	 * bit based on the context.
+	 */
 	if (kvm_x86_ops.cpu_dirty_log_size)
 		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
 	else

> 
>  arch/x86/kvm/mmu/mmu.c | 43 ++++++++++++++++++------------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f2c9580d9588..7eb87d473223 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1307,15 +1307,6 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  	return flush;
>  }
>  
> -/**
> - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> - * @kvm: kvm instance
> - * @slot: slot to protect
> - * @gfn_offset: start of the BITS_PER_LONG pages we care about
> - * @mask: indicates which pages we should protect
> - *
> - * Used when we do not need to care about huge page mappings.
> - */
>  static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot,
>  				     gfn_t gfn_offset, unsigned long mask)
> @@ -1339,16 +1330,6 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  	}
>  }
>  
> -/**
> - * kvm_mmu_clear_dirty_pt_masked - clear MMU D-bit for PT level pages, or write
> - * protect the page if the D-bit isn't supported.
> - * @kvm: kvm instance
> - * @slot: slot to clear D-bit
> - * @gfn_offset: start of the BITS_PER_LONG pages we care about
> - * @mask: indicates which pages we should clear D-bit
> - *
> - * Used for PML to re-log the dirty GPAs after userspace querying dirty_bitmap.
> - */
>  static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  					 struct kvm_memory_slot *slot,
>  					 gfn_t gfn_offset, unsigned long mask)
> @@ -1373,14 +1354,26 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  }
>  
>  /**
> - * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> - * PT level pages.
> + * kvm_arch_mmu_enable_log_dirty_pt_masked - (Re)Enable dirty logging for a set
> + * of GFNs
>   *
> - * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> - * enable dirty logging for them.
> + * @kvm: kvm instance
> + * @slot: slot to containing the gfns to dirty log
> + * @gfn_offset: start of the BITS_PER_LONG pages we care about

Someone once told me to avoid using "we" in comments :)

> + * @mask: indicates which gfns to dirty log (1 == enable)
>   *
> - * We need to care about huge page mappings: e.g. during dirty logging we may
> - * have such mappings.
> + * (Re)Enable dirty logging for the set of GFNs indicated by the slot,
> + * gfn_offset, and mask, e.g. after userspace has harvested dirty information
> + * and wants to re-log dirty GFNs for the next round of migration.
> + *
> + * If the slot was assumed to be "initially all dirty", write-protect hugepages
> + * to ensure they are split to 4KiB on the first write (KVM dirty logs at 4KiB
> + * granularity).  If eager page splitting is enabled, immediately try to split
> + * hugepages, e.g. so that vCPUs don't get saddled with the cost of the split.
> + *
> + * If Page-Modification Logging (PML) is enabled and the GFN doesn't need to be
> + * write-protected for other reasons, e.g. shadow paging, clear the Dirty Bit.
> + * Otherwise write-protect the GFN, i.e. clear the Writable Bit.
>   */
>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  				struct kvm_memory_slot *slot,
> 
> base-commit: f99b052256f16224687e5947772f0942bff73fc1
> -- 
> 2.45.2.505.gda0bf45e8d-goog
> 

