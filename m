Return-Path: <kvm+bounces-21852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F7B934FE6
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 17:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7963F1F21EDA
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 15:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB82D1448F1;
	Thu, 18 Jul 2024 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RsqO2imq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E9D7A724;
	Thu, 18 Jul 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721316510; cv=none; b=OnuqzSuf1cjsUlLpYDfPw7GtiFxsQVj0RJHg087PkisCqGUz24HdOCIMdY4l5AGFjOjfqCtDgV0CFWsLaiMz54ZWLQOZCjTanqP92aRURzlRyj6QQAsbk3KtNgz3ifQN+q/iByB/8GX27E0UZsoP3p1M4q/vvFmRZqvoZ+Hg3as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721316510; c=relaxed/simple;
	bh=jl49LSCR3gPldv5VQLdP8sm/wukwB1bh9gHx7piNvSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJvNk0tBCy3Ql4ZhT0Y+YA4cPj26+vyUmKaCidmgn4hkqh4Xbnz/NGbUXX5MHZMR6cb13khrdfzOmiNqLMi+TWqutWdKphM8vPklZiK1rS9X1EMdPAJ3LhosO1GRIlpq4WbBepzhBnOUVbrib+fkxkHgMsRs1QczTMu1pMAILf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RsqO2imq; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721316507; x=1752852507;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=jl49LSCR3gPldv5VQLdP8sm/wukwB1bh9gHx7piNvSE=;
  b=RsqO2imqARowcItepYor9IqOY9wDdyDGFTyaKUflYE1EK1cZiroj49d2
   cnfbfT9l6vqt4zebF9xke5lm9HIlFLoE844w7ehtKY5mLu1VbSA/vUMVZ
   7ime+KqRr5/uT3oaKOC4/4qmmYSNptUehHlmL3zYzlV0tmESm6Z/K2ims
   sg8MbPMnCdoXiz+OR8dO/rk25a+T6XY6kARIIwCNQ3Hu3r09dbPPMw0IG
   6MWlUtlaPvOfdgRN3iMls+YN/4brihl5TuB/v1+E4rT64egpqbjefLsSY
   9/Pm7s9ckQQpD3Nhn/Vt/YJRuJ7uup70G7pLKPoBGrxnPICPjOIWdI7+0
   w==;
X-CSE-ConnectionGUID: Xa0t+9KUSQCv4xnNDjCbuA==
X-CSE-MsgGUID: FzTSjq55TpKRUjmG7vjb2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="36328900"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="36328900"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 08:28:26 -0700
X-CSE-ConnectionGUID: MSt9EznZRhyasg+ywpCYVQ==
X-CSE-MsgGUID: 697LenmXRlq96CRWddfqbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="50519854"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 08:28:24 -0700
Date: Thu, 18 Jul 2024 08:28:23 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Message-ID: <20240718152823.GG1900928@ls.amr.corp.intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>

On Fri, Jun 21, 2024 at 07:08:22PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Fri, 2024-06-21 at 15:10 +0800, Yan Zhao wrote:
> > On Wed, Jun 19, 2024 at 03:36:14PM -0700, Rick Edgecombe wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 630e6b6d4bf2..a1ab67a4f41f 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -37,7 +37,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> > >          * for zapping and thus puts the TDP MMU's reference to each root,
> > > i.e.
> > >          * ultimately frees all roots.
> > >          */
> > > -       kvm_tdp_mmu_invalidate_all_roots(kvm);
> > > +       kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
> > all roots (mirror + direct) are invalidated here.
> 
> Right.
> > 
> > >         kvm_tdp_mmu_zap_invalidated_roots(kvm);
> > kvm_tdp_mmu_zap_invalidated_roots() will zap invalidated mirror root with
> > mmu_lock held for read, which should trigger KVM_BUG_ON() in
> > __tdp_mmu_set_spte_atomic(), which assumes "atomic zapping don't operate on
> > mirror roots".
> > 
> > But up to now, the KVM_BUG_ON() is not triggered because
> > kvm_mmu_notifier_release() is called earlier than kvm_destroy_vm() (as in
> > below
> > call trace), and kvm_arch_flush_shadow_all() in kvm_mmu_notifier_release() has
> > zapped all mirror SPTEs before kvm_mmu_uninit_vm() called in kvm_destroy_vm().
> > 
> > 
> > kvm_mmu_notifier_release
> >   kvm_flush_shadow_all
> >     kvm_arch_flush_shadow_all
> >       static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
> >       kvm_mmu_zap_all  ==>hold mmu_lock for write
> >         kvm_tdp_mmu_zap_all ==>zap KVM_ALL_ROOTS with mmu_lock held for write
> > 
> > kvm_destroy_vm
> >   kvm_arch_destroy_vm
> >     kvm_mmu_uninit_vm
> >       kvm_mmu_uninit_tdp_mmu
> >         kvm_tdp_mmu_invalidate_roots ==>invalid all KVM_VALID_ROOTS
> >         kvm_tdp_mmu_zap_invalidated_roots ==> zap all roots with mmu_lock held
> > for read
> > 
> > 
> > A question is that kvm_mmu_notifier_release(), as a callback of primary MMU
> > notifier, why does it zap mirrored tdp when all other callbacks are with
> > KVM_FILTER_SHARED?
> > 
> > Could we just zap all KVM_DIRECT_ROOTS (valid | invalid) in
> > kvm_mmu_notifier_release() and move mirrord tdp related stuffs from 
> > kvm_arch_flush_shadow_all() to kvm_mmu_uninit_tdp_mmu(), ensuring mmu_lock is
> > held for write?
> 
> Sigh, thanks for flagging this. I agree it seems weird to free private memory
> from an MMU notifier callback. I also found this old thread where Sean NAKed the
> current approach (free hkid in mmu release):
> https://lore.kernel.org/kvm/ZN+1QHGa6ltpQxZn@google.com/#t
> 
> One challenge is that flush_shadow_all_private() needs to be done before
> kvm_destroy_vcpus(), where it gets into tdx_vcpu_free(). So kvm_mmu_uninit_vm()
> is too late. Perhaps this is why it was shoved into mmu notifier release (which
> happens long before as you noted). Isaku, do you recall any other reasons?

Although it's a bit late, it's for record.

It's to optimize the destruction Secure-EPT.  Free HKID early and destruct
Secure-EPT by TDH.PHYMEM.PAGE.RECLAIM().  QEMU doesn't close any KVM file
descriptors on exit. (gmem fd references KVM VM fd. so vm destruction happens
after all gmem fds are closed.  Closing gmem fd causes secure-EPT zapping befure
releasing HKID.)

Because we're ignoring such optimization for now, we can simply defer releasing
HKID following Seans's call.


> But static_call_cond(kvm_x86_vm_destroy) happens before kvm_destroy_vcpus, so we
> could maybe actually just do the tdx_mmu_release_hkid() part there. Then drop
> the flush_shadow_all_private x86 op. See the (not thoroughly checked) diff at
> the bottom of this mail.

Yep, we can release HKID at vm destruction with potential too slow zapping of
Secure-EPT.  The following change basically looks good to me.
(The callback for Secure-EPT can be simplified.)

Thanks,

> But most of what is being discussed is in future patches where it starts to get
> into the TDX module interaction. So I wonder if we should drop this patch 17
> from "part 1" and include it with the next series so it can all be considered
> together.
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-
> ops.h
> index 2adf36b74910..3927731aa947 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -23,7 +23,6 @@ KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
>  KVM_X86_OP_OPTIONAL(vm_enable_cap)
>  KVM_X86_OP(vm_init)
> -KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL(vm_free)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8a72e5873808..8b2b79b39d0f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1647,7 +1647,6 @@ struct kvm_x86_ops {
>         unsigned int vm_size;
>         int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>         int (*vm_init)(struct kvm *kvm);
> -       void (*flush_shadow_all_private)(struct kvm *kvm);
>         void (*vm_destroy)(struct kvm *kvm);
>         void (*vm_free)(struct kvm *kvm);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e1299eb03e63..4deeeac14324 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6446,7 +6446,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>          * lead to use-after-free.
>          */
>         if (tdp_mmu_enabled)
> -               kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +               kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
>  }
>  
>  static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> @@ -6977,13 +6977,6 @@ static void kvm_mmu_zap_all(struct kvm *kvm)
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> -       /*
> -        * kvm_mmu_zap_all() zaps both private and shared page tables.  Before
> -        * tearing down private page tables, TDX requires some TD resources to
> -        * be destroyed (i.e. keyID must have been reclaimed, etc).  Invoke
> -        * kvm_x86_flush_shadow_all_private() for this.
> -        */
> -       static_call_cond(kvm_x86_flush_shadow_all_private)(kvm);
>         kvm_mmu_zap_all(kvm);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 68dfcdb46ab7..9e8b012aa8cc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -38,7 +38,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>          * ultimately frees all roots.
>          */
>         kvm_tdp_mmu_invalidate_roots(kvm, KVM_VALID_ROOTS);
> -       kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +       kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
>  
>         WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
>         WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
> @@ -1057,7 +1057,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>          * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
>          */
>         lockdep_assert_held_write(&kvm->mmu_lock);
> -       for_each_tdp_mmu_root_yield_safe(kvm, root)
> +       __for_each_tdp_mmu_root_yield_safe(kvm, root, -1, KVM_DIRECT_ROOTS)
>                 tdp_mmu_zap_root(kvm, root, false);
>  }
>  
> @@ -1065,11 +1065,14 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
>   * zap" completes.
>   */
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
>  {
>         struct kvm_mmu_page *root;
>  
> -       read_lock(&kvm->mmu_lock);
> +       if (shared)
> +               read_lock(&kvm->mmu_lock);
> +       else
> +               write_lock(&kvm->mmu_lock);
>  
>         for_each_tdp_mmu_root_yield_safe(kvm, root) {
>                 if (!root->tdp_mmu_scheduled_root_to_zap)
> @@ -1087,7 +1090,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>                  * that may be zapped, as such entries are associated with the
>                  * ASID on both VMX and SVM.
>                  */
> -               tdp_mmu_zap_root(kvm, root, true);
> +               tdp_mmu_zap_root(kvm, root, shared);
>  
>                 /*
>                  * The referenced needs to be put *after* zapping the root, as
> @@ -1097,7 +1100,10 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>                 kvm_tdp_mmu_put_root(kvm, root);
>         }
>  
> -       read_unlock(&kvm->mmu_lock);
> +       if (shared)
> +               read_unlock(&kvm->mmu_lock);
> +       else
> +               write_unlock(&kvm->mmu_lock);
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 56741d31048a..7927fa4a96e0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -68,7 +68,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page
> *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
>                                   enum kvm_tdp_mmu_root_types root_types);
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
>  
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index b6828e35eb17..3f9bfcd3e152 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -98,16 +98,12 @@ static int vt_vm_init(struct kvm *kvm)
>         return vmx_vm_init(kvm);
>  }
>  
> -static void vt_flush_shadow_all_private(struct kvm *kvm)
> -{
> -       if (is_td(kvm))
> -               tdx_mmu_release_hkid(kvm);
> -}
> -
>  static void vt_vm_destroy(struct kvm *kvm)
>  {
> -       if (is_td(kvm))
> +       if (is_td(kvm)) {
> +               tdx_mmu_release_hkid(kvm);
>                 return;
> +       }
>  
>         vmx_vm_destroy(kvm);
>  }
> @@ -980,7 +976,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>         .vm_size = sizeof(struct kvm_vmx),
>         .vm_enable_cap = vt_vm_enable_cap,
>         .vm_init = vt_vm_init,
> -       .flush_shadow_all_private = vt_flush_shadow_all_private,
>         .vm_destroy = vt_vm_destroy,
>         .vm_free = vt_vm_free,
>  
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

