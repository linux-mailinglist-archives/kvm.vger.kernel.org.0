Return-Path: <kvm+bounces-56174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43081B3AAC8
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E474D173EEB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1154265CA8;
	Thu, 28 Aug 2025 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G1cVf1qi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6F72566
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756408887; cv=none; b=bQOsd0QSP5RRh85l8OLORvtot0JXqk6n7+VlAUOrB4JXLLL07dS4M2qjFzwsg9Cy+H3MzqNfZvbWM6WN2nZkyx8nxqWV1GCg0chwuipHex9U29vGZNsh6X+i434m/TwrJGH2o0zGYlENLrTbF8q9/i9HYA8f0DADKpVpGp8/O9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756408887; c=relaxed/simple;
	bh=rDD66MXkQ62CRBDL+PoyFT7bbZIEcKDbwJsMX1RqbYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W0mGRRJSvTyFqsOQv7PuT43GpBJcMlb/8bUx9p6HZnN71+98vSPD95r/pqTelp1TqfK5Mtk8YWt+eLCNA5ugwUqAgXl1c+OmO1qQIsyGYZkyCK7wrE4zJ3pLBkAW6e9Zs4fAAbNVnxt04apjX4uJEgHV6V6KbOW7Z5LBGZXw0+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G1cVf1qi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-248981c02cfso14458245ad.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 12:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756408884; x=1757013684; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNjs6T98kdJx8OM7hbT1Sjw0Nyzd0bo6/V8ToeUSZTA=;
        b=G1cVf1qiboEpFvFx91BYVNlocvHecAV2CSSYb7Jl5e57FqSumDUZgxWEJoQOA8Xbus
         STv/Kaj1rxvg50iBy5r6HWPWKjQfOjg1DwWAyTib4MUytwKcxaiPh53bVT+eyk4IKJ8E
         qkoHp66LYW5C5Z60pGzF2nvaDtFn1JCk5wlHMtrMvbFGHWBJpBBMOFnGupLIIDDzjkEr
         7Hxas3sNEBKLY/SEV86s1v9uawIg6KrIdpJzpLx8DmOkPOcR5cP6Pda7TxxRERMKLPCn
         jlyw5wI/fjnX1zs9JsuqV6r/ddiv0XSY2lvUsxVftKuph0S1MboCrahyFlQNTJ5lNloN
         bivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756408884; x=1757013684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNjs6T98kdJx8OM7hbT1Sjw0Nyzd0bo6/V8ToeUSZTA=;
        b=MlIcJFIU9rEga6YkYZnZXfl+JR7NGWpI62/EYLa6sZKBcXYrjB60VGsaQ/kvrYtGTl
         EreVYCtFE9ByL1R3qZRfAoCH70lanQdxJbov4XUjrNTW2nHrLCdK5HKZ710jhWyrsUI5
         UXF857/b1S3jxM+WCnMEPpkbRt054cySx2B1vUojSR4AlSpNff/vwToh7uJz6GKugZ5a
         HHxu85C+a18rNqI0Zzl7O0PSF182HzrmAa6tcjrZVkXvcwTd/KYdvRsedWjM1d0XSPJX
         8AilbRF5oy9R1Nl2wBjsqMu7/dbP9rUJOx7UO+Mtu+MeX7xUgHM5tGkvz2UuUSvQNaIB
         caBg==
X-Forwarded-Encrypted: i=1; AJvYcCXhDUfJ0KgL6xksfA1g+ynUcEZSwK8KVmRfA1W4NPdUSmZS/0tbjF71ibbbZQIC76C4PhE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyYFFkfnWpRONU6JKJYOJvFTHYo6JZX9HBtvy6Eup6czHW2pqo
	RwsAvpXX1mXvJ9BEpLAff4qwVrWgIL6Gk3RK6I9It69defpQ7Y/TX80HBKQtCYtDrPo2ro8AuzL
	hVPmLPg==
X-Google-Smtp-Source: AGHT+IGxta86IRHLgGEt2ecmMu/Zj2MP8ZHry1zOcjR1Qn5pmbRw4LCjm959jaMZRYjAagvAW7vHEj3bDxI=
X-Received: from plpc6.prod.google.com ([2002:a17:903:1b46:b0:246:727:7f8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1984:b0:246:80e9:85b0
 with SMTP id d9443c01a7336-24680e9887bmr257282235ad.41.1756408884538; Thu, 28
 Aug 2025 12:21:24 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:21:23 -0700
In-Reply-To: <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-7-seanjc@google.com>
 <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
Message-ID: <aLCsM6DShlGDxPOd@google.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-08-26 at 17:05 -0700, Sean Christopherson wrote:
> > Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
> > when a VM has been killed due to a KVM bug, not -EINVAL.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 9fb6e5f02cc9..ef4ffcad131f 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1624,7 +1624,7 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  
> >  	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> > -		return -EINVAL;
> > +		return -EIO;
> >  
> >  	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
> >  	atomic64_inc(&kvm_tdx->nr_premapped);
> > @@ -1638,7 +1638,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  
> >  	/* TODO: handle large pages. */
> >  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > -		return -EINVAL;
> > +		return -EIO;
> >  
> >  	/*
> >  	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> > @@ -1849,7 +1849,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
> >  	 * and slot move/deletion.
> >  	 */
> >  	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
> > -		return -EINVAL;
> > +		return -EIO;
> >  
> >  	/*
> >  	 * The HKID assigned to this TD was already freed and cache was
> > @@ -1870,7 +1870,7 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	 * there can't be anything populated in the private EPT.
> >  	 */
> >  	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> > -		return -EINVAL;
> > +		return -EIO;
> >  
> >  	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
> >  	if (ret <= 0)
> 
> 
> Did you miss?

I did indeed.

> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f9ac590e8ff0..fd1b8fea55a9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1656,10 +1656,10 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm,
> gfn_t gfn,
>  
>         /* TODO: handle large pages. */
>         if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> -               return -EINVAL;
> +               return -EIO;
>  
>         if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
> -               return -EINVAL;
> +               return -EIO;
>  
>         /*
>          * When zapping private page, write lock is held. So no race condition
> 
> 
> We really have a lot of KVM_BUG_ON()s in tdx code. I hesitate to pull them out
> but it feels a bit gratuitous.

Generally speaking, the number of KVM_BUG_ON()s is fine.  What we can do though
is reduce the amount of boilerplate and the number of paths the propagate a SEAMCALL
err through multiple layers, e.g. by eliminating single-use helpers (which is made
easier by reducing boilerplate and thus lines of code).

Concretely, if we combine the KVM_BUG_ON() usage with pr_tdx_error():

#define __TDX_BUG_ON(__err, __fn_str, __kvm, __fmt, __args...)			\
({										\
	struct kvm *_kvm = (__kvm);						\
	bool __ret = !!(__err);							\
										\
	if (WARN_ON_ONCE(__ret && (!_kvm || !_kvm->vm_bugged))) {		\
		if (_kvm)							\
			kvm_vm_bugged(_kvm);					\
		pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx"	\
				   __fmt "\n",  __err,  __args); 		\
	}									\
	unlikely(__ret);							\
})

#define TDX_BUG_ON(__err, __fn, __kvm)				\
	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")

#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)

#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)

#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)


And a macro to handle retry when kicking vCPUs out of the guest:

#define tdh_do_no_vcpus(tdh_func, kvm, args...)					\
({										\
	struct kvm_tdx *__kvm_tdx = to_kvm_tdx(kvm);				\
	u64 __err;								\
										\
	lockdep_assert_held_write(&kvm->mmu_lock);				\
										\
	__err = tdh_func(args);							\
	if (unlikely(tdx_operand_busy(__err))) {				\
		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, true);			\
		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);	\
										\
		__err = tdh_func(args);						\
										\
		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, false);		\
	}									\
	__err;									\
})

And do a bit of massaging, then we can end up e.g. this, which IMO is much easier
to follow than the current form of tdx_sept_remove_private_spte(), which has
several duplicate sanity checks and error handlers.

The tdh_do_no_vcpus() macro is a little mean, but I think it's a net positive
as eliminates quite a lot of "noise", and thus makes it easier to focus on the
logic.  And alternative to a trampoline macro would be to implement a guard()
and then do a scoped_guard(), but I think that'd be just as hard to read, and
would require almost as much boilerplate as there is today.

static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
					 enum pg_level level, u64 spte)
{
	struct page *page = pfn_to_page(spte_to_pfn(spte));
	int tdx_level = pg_level_to_tdx_sept_level(level);
	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
	gpa_t gpa = gfn_to_gpa(gfn);
	u64 err, entry, level_state;

	/*
	 * HKID is released after all private pages have been removed, and set
	 * before any might be populated. Warn if zapping is attempted when
	 * there can't be anything populated in the private EPT.
	 */
	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
		return;

	/* TODO: handle large pages. */
	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
		return;

	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
			      tdx_level, &entry, &level_state);
	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
		return;

	/*
	 * TDX requires TLB tracking before dropping private page.  Do
	 * it here, although it is also done later.
	 */
	tdx_track(kvm);

	/*
	 * When zapping private page, write lock is held. So no race condition
	 * with other vcpu sept operation.
	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
	 */
	err = tdh_do_no_vcpus(tdh_mem_page_remove, kvm, &kvm_tdx->td, gpa,
			      tdx_level, &entry, &level_state);
	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
		return;

	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
		return;

	tdx_clear_page(page);
}


