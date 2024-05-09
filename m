Return-Path: <kvm+bounces-17081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 226298C09E7
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 04:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D54552815AD
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 02:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949DC13BC3C;
	Thu,  9 May 2024 02:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="GkoSngcW"
X-Original-To: kvm@vger.kernel.org
Received: from out0-221.mail.aliyun.com (out0-221.mail.aliyun.com [140.205.0.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905C2823AF;
	Thu,  9 May 2024 02:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715222950; cv=none; b=X/CMieXuDCgS9mEOf86VaYcO/mzn39Iu4KA0lNfe1gA507KiGzZg9DJkPTG2CG3kgTCLfCcPwWe4/7/LUEJpakbkMolDZ1el0fVq88gbScZ7enCm+865FjlTqgCqLXz/E5qh6ila1D4CExNlpyfxy6cSX0OFIpGKHOi9Rdh4LyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715222950; c=relaxed/simple;
	bh=dQHFoqzYCvZBkYfUOAkV55ujKQpZEjJAxYjhgBfhha8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1FveIl21yCAhRcMxnV8716Pkmow0oCITEGMkHGntFSDwVBngcREyfmxUnggwhYtaqujJMhl/skxq6XTDT3Wc2/XctRQZOgIj8jaHFWFax2l06R3L465u6r9pn6zlHWEEA2vXgwrmkhI4CbSAvKaheiCgOkj6LakqS9LyJeg9b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=GkoSngcW; arc=none smtp.client-ip=140.205.0.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1715222938; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=pe68F7LmpCizr0uGa4//gBpg6kUVfgqCxDbEX900zvI=;
	b=GkoSngcW1hadh5LDPIn/yIVV+AnP/xJRjqo9FQUskfnSY8+LlojVDXxTzBZ6DuP/jFFEKP5wZLK/Gd5MwpuVla2meDVoied4X9Iah2B5YN7O3dHy5lO1oBpb+fUy1uiBkKR2AgmDXrP5IDJfYsoDIVDdFtVkwogt5B0gNk+hO48=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047209;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.XWD6JwE_1715222936;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.XWD6JwE_1715222936)
          by smtp.aliyun-inc.com;
          Thu, 09 May 2024 10:48:57 +0800
Date: Thu, 09 May 2024 10:48:56 +0800
From: "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc:  <kvm@vger.kernel.org>,
  "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
  "Paolo Bonzini" <pbonzini@redhat.com>,
  "Thomas Gleixner" <tglx@linutronix.de>,
  "Ingo Molnar" <mingo@redhat.com>,
  "Borislav Petkov" <bp@alien8.de>,
  "Dave Hansen" <dave.hansen@linux.intel.com>,
   <x86@kernel.org>,
  "H. Peter Anvin" <hpa@zytor.com>,
   <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Only allocate shadowed translation cache
 for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL
Message-ID: <20240509024856.GA83446@k08j02272.eu95sqa>
References: <bf08a06675ed97d2456f7dcd9b0b2ef92f4602be.1715137643.git.houwenlong.hwl@antgroup.com>
 <ZjuSRjwc_wRTSXQp@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjuSRjwc_wRTSXQp@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, May 08, 2024 at 10:55:02PM +0800, Sean Christopherson wrote:
> On Wed, May 08, 2024, Hou Wenlong wrote:
> > Only the indirect SP with sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL might
> > have leaf gptes, so allocation of shadowed translation cache is needed
> > only for it. Additionally, use sp->shadowed_translation to determine
> > whether to use the information in shadowed translation cache or not.
> > 
> > Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 27 +++++++++++++++++++--------
> >  1 file changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index fc3b59b59ee1..8be987d0f05e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -716,12 +716,12 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp);
> >  
> >  static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> >  {
> > +	if (sp->shadowed_translation)
> > +		return sp->shadowed_translation[index] >> PAGE_SHIFT;
> > +
> >  	if (sp->role.passthrough)
> >  		return sp->gfn;
> >  
> > -	if (!sp->role.direct)
> > -		return sp->shadowed_translation[index] >> PAGE_SHIFT;
> 
> Why change the order?  Either the order doesn't matter, in which case go for the
> smallest diff, or the order does matter, in which case this warrants an explanation
> in the changelog (or perhaps even a separate patch, but that's likely overkill).
>
I believe the order doesn't matter, and the initial purpose is to keep
the code of the 2 cases, which doesn't have shadowed_translation, close
together. I'll drop the order change to keep the smallest diff.

> > -
> >  	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
> >  }
> >  
> > @@ -733,7 +733,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> >   */
> >  static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
> 
> Can you also extend the WARN in FNAME(sync_spte)()?  Partly to help communicate
> to future readers that sync_spte() operates on leaf GPTEs, and also to help make
> it somewhat obvious that this patch doesn't break shadow_mmu_get_sp_for_split()
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 7a87097cb45b..89b5d73e9e3c 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -911,7 +911,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>         gpa_t pte_gpa;
>         gfn_t gfn;
>  
> -       if (WARN_ON_ONCE(!sp->spt[i]))
> +       if (WARN_ON_ONCE(!sp->spt[i] || !sp->shadowed_translation))
>                 return 0;
>  
>         first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
>
Sure, I'll add this in the v2.
 
Thanks!

> >  {
> > -	if (sp_has_gptes(sp))
> > +	if (sp->shadowed_translation)
> >  		return sp->shadowed_translation[index] & ACC_ALL;
> >  
> >  	/*
> > @@ -754,7 +754,7 @@ static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
> >  static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
> >  					 gfn_t gfn, unsigned int access)
> >  {
> > -	if (sp_has_gptes(sp)) {
> > +	if (sp->shadowed_translation) {
> >  		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
> >  		return;
> >  	}
> > @@ -1697,7 +1697,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
> >  	hlist_del(&sp->hash_link);
> >  	list_del(&sp->link);
> >  	free_page((unsigned long)sp->spt);
> > -	if (!sp->role.direct)
> > +	if (sp->shadowed_translation)
> >  		free_page((unsigned long)sp->shadowed_translation);
> 
> Just drop the manual check, free_page() already handles the NULL/0 case.
> 
> >  	kmem_cache_free(mmu_page_header_cache, sp);
> >  }
> > @@ -1850,6 +1850,17 @@ static bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> >  static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> >  				    struct list_head *invalid_list);
> >  
> > +static bool sp_might_have_leaf_gptes(struct kvm_mmu_page *sp)
> 
> Hmm, I think I'd prefer to forego the helper entirely, as this really is intended
> to be used only when allocating the shadow page.  That way we avoid having to try
> and clarify exactly what "might" means in this context, as well as potential future
> goofs, e.g. if someone had the clever idea to check sp->shadowed_translation.
> 
> Oof, yeah, definitely omit the helper.  It took me a minute to fully appreciate
> the difference between "leaf gptes" and "gptes" as it relates to write-protecting
> gfns.
> 
> > +{
> > +	if (sp->role.direct)
> > +		return false;
> > +
> > +	if (sp->role.level > KVM_MAX_HUGEPAGE_LEVEL)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> >  static bool sp_has_gptes(struct kvm_mmu_page *sp)
> >  {
> >  	if (sp->role.direct)
> > @@ -2199,7 +2210,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
> >  
> >  	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
> >  	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
> > -	if (!role.direct)
> > +	sp->role = role;
> > +	if (sp_might_have_leaf_gptes(sp))
> 
> And then this becomes:
> 
> 	if (!role.direct && role.level <= KVM_MAX_HUGEPAGE_LEVEL)
> 
> >  		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
> >  
> >  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > @@ -2216,7 +2228,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
> >  	kvm_account_mmu_page(kvm, sp);
> >  
> >  	sp->gfn = gfn;
> > -	sp->role = role;
> 
> And this code doesn't need to move.
> 
> >  	hlist_add_head(&sp->hash_link, sp_list);
> >  	if (sp_has_gptes(sp))
> >  		account_shadowed(kvm, sp);
> > -- 
> > 2.31.1
> > 

