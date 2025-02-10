Return-Path: <kvm+bounces-37754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA209A2FDA0
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFED13A839C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D04254AF8;
	Mon, 10 Feb 2025 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4rHaX52s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2937A254AF0
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739227303; cv=none; b=SOIv+PC/oozc6OQFWNV3M0qsAJfpG0oUSJ/4NgegIZL5IJHATkKpcC+s9ytc3UJVRweUMhNQpFW8NEoOebBsa/LN46reoJdyOmWs8X+Gj6ujxozuvyH+G2+IB+l36g36sYU8ckPUIbH8nYSo912TkKucd2gU6kuM7R88EhoggV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739227303; c=relaxed/simple;
	bh=J2M5LBZIRA6dmTpu1re8X+PdJJRdN2XLIrkz2r8effU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sq5r3247qKTuyq5xB358pzUNrNnqTgyzNWcrzwcdIZSHJ4Y5nqVvZJSdvfKge6R5foDzvAiBmjksHUzqKjdNWbSOetONxKYg2OL+BgGcLO7i1RAbKf6mnncPgaJhjaJQrK/aJufnJRewwPaPeaKAy8PZYRC0UXaVf5iSVh76PYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4rHaX52s; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa228b4151so7597268a91.1
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 14:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739227301; x=1739832101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DZD6V+4k9UUTVu1q6+YHZha34NbYh40y70H3kTsa6mc=;
        b=4rHaX52sRJ4jIAyvJLAOq2hrrp9wiZ8j1Ner8REYgdlK5KyBt84oPCXh4eVtORkuRA
         B/F6jDotZn0UprV0Dx72Rboz34bU0vby3ajujLRXYG3bKph6HtPmXXT5o5h+cw/NuO55
         39XnICl6g0LkImXReEMpZ7+LCr+aRA00nprKnMaIml6FWZZMP1tjlD10/10lkhIcOJxL
         gQyOM4wtNta1W8nd/vPM/Wuew7M7BeKkK4/cE4S43ZN8Fg88ehBMCrZNNOfhM7idxD8k
         Zop4d9snir/d0ugURk7zVutou/GDnh6eXTyyp8/UKCLBUxz1Bn7Kq63LHrW2IicZSUq3
         ydfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739227301; x=1739832101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZD6V+4k9UUTVu1q6+YHZha34NbYh40y70H3kTsa6mc=;
        b=djbPt6Xo9zJywBkbFFepTpwQAy7nXQlxnlgOAxtslc4VnSzK9QGak9PPcdeuSmDvX3
         fV+AGmk0HYQ70YSYZfuDJbGRNH3qjDsILoEbJyrsPJKeg6xE2tqoalrPlApy+7Ttp7YB
         RUPBSLwRI0fEVqc5ak11rEL/KAAwN98nlSZHbVCPczQfwKg49zwBJLGaPsLZFopSLO64
         Uey3idZe9Rlhjy3BRvwtE1I/Y57JyIJhdg2HoZiZrPj/vBC2Zi0ZYTfRb1W61Q3b+h7C
         zfbdu7l0wYymjU9ob9AJ/fLJyB+eefuLWz6At1tSUrzXEm/oB6rJThrE7UIZNN6f7Or5
         xP0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXoROJyajvwp40c9xCFoN6FiMHZ5j6A3znPDzgVYzdRbsHkD+qmFfxWXRie5y8Ze9wrXvM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNFYZpOkzd0hYJWWCX6wv596BlIeAbjLgWNWFi4urduf1D864J
	Z99kqOUyl9ROnIwFmdlMjBZSekp/EnYw4XgVkCLglZU0LKY2PaxTVo1DK2J87j3HGVyXgpqyzw5
	w+Q==
X-Google-Smtp-Source: AGHT+IH2c0dkWdxSoUH/P+c/MHYnOos+sGeNLUsxpV+Tj6PKAdhff85ZIO3F/CXDLvmSmNqvrbsH0zqif9M=
X-Received: from pjbsq11.prod.google.com ([2002:a17:90b:530b:b0:2f7:ff61:48e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d8c:b0:2ea:2a8d:dd2a
 with SMTP id 98e67ed59e1d1-2fa242e6928mr22387097a91.27.1739227301444; Mon, 10
 Feb 2025 14:41:41 -0800 (PST)
Date: Mon, 10 Feb 2025 14:41:40 -0800
In-Reply-To: <Z6bJF8uA9R0x3QGp@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207030640.1585-1-yan.y.zhao@intel.com> <20250207030931.1902-1-yan.y.zhao@intel.com>
 <Z6YixPh_j517vqcP@google.com> <Z6bJF8uA9R0x3QGp@yzhao56-desk.sh.intel.com>
Message-ID: <Z6qApByaoCs_Y0eb@google.com>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Free obsolete roots when pre-faulting SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 08, 2025, Yan Zhao wrote:
> On Fri, Feb 07, 2025 at 07:12:04AM -0800, Sean Christopherson wrote:
> > On Fri, Feb 07, 2025, Yan Zhao wrote:
> > > Always free obsolete roots when pre-faulting SPTEs in case it's called
> > > after a root is invalidated (e.g., by memslot removal) but before any
> > > vcpu_enter_guest() processing of KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> > > 
> > > Lack of kvm_mmu_free_obsolete_roots() in this scenario can lead to
> > > kvm_mmu_reload() failing to load a new root if the current root hpa is an
> > > obsolete root (which is not INVALID_PAGE). Consequently,
> > > kvm_arch_vcpu_pre_fault_memory() will retry infinitely due to the checking
> > > of is_page_fault_stale().
> > > 
> > > It's safe to call kvm_mmu_free_obsolete_roots() even if there are no
> > > obsolete roots or if it's called a second time when vcpu_enter_guest()
> > > later processes KVM_REQ_MMU_FREE_OBSOLETE_ROOTS. This is because
> > > kvm_mmu_free_obsolete_roots() sets an obsolete root to INVALID_PAGE and
> > > will do nothing to an INVALID_PAGE.
> > 
> > Why is userspace changing memslots while prefaulting?
> It currently only exists in the kvm selftest (written by myself...)
> Not sure if there's any real use case like this.

It's decidedly odd.  I asked, because maybe there's a way we can disallow the
scenario.  Doing that without making things more complex than simply handling
obsolete roots is probably a fool's errand though.

> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 47fd3712afe6..72f68458049a 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4740,7 +4740,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > >  	/*
> > >  	 * reload is efficient when called repeatedly, so we can do it on
> > >  	 * every iteration.
> > > +	 * Before reload, free obsolete roots in case the prefault is called
> > > +	 * after a root is invalidated (e.g., by memslot removal) but
> > > +	 * before any vcpu_enter_guest() processing of
> > > +	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.
> > >  	 */
> > > +	kvm_mmu_free_obsolete_roots(vcpu);
> > >  	r = kvm_mmu_reload(vcpu);
> > >  	if (r)
> > >  		return r;
> > 
> > I would prefer to do check for obsolete roots in kvm_mmu_reload() itself, but
> Yes, it's better!
> I previously considered doing in this way, but I was afraid to introduce
> overhead (the extra compare) to kvm_mmu_reload(), which is called quite
> frequently.
> 
> But maybe we can remove the check in vcpu_enter_guest() to reduce the overhead?
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b2d9a16fd4d3..6a1f2780a094 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10731,8 +10731,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                                 goto out;
>                         }
>                 }
> -               if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
> -                       kvm_mmu_free_obsolete_roots(vcpu);
>                 if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
>                         __kvm_migrate_timers(vcpu);
>                 if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
> 
> > keep the main kvm_check_request() so that the common case handles the resulting
> > TLB flush without having to loop back around in vcpu_enter_guest().
> Hmm, I'm a little confused.
> What's is the resulting TLB flush?

For the common case where KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is pending before
vcpu_enter_guest, kvm_mmu_free_obsolete_roots() may trigger KVM_REQ_TLB_FLUSH
via kvm_mmu_commit_zap_page().  Processing KVM_REQ_MMU_FREE_OBSOLETE_ROOTS before
KVM_REQ_TLB_FLUSH means vcpu_enter_guest() doesn't have to "abort" and redo the
whole loop (the newly pending request won't be detected until kvm_vcpu_exit_request(),
which isn't that late in the entry sequence, but there is a decent amount of work
that needs to be undone).

On the other hand, the cost of kvm_check_request(), especially a check that's
guarded by kvm_request_pending(), is negligible.

That said, obsolete roots shouldn't actually require a TLB flush.  E.g. the TDP
MMU hasn't flushed invalid roots since commit fcdffe97f80e ("KVM: x86/mmu: Don't
do TLB flush when zappings SPTEs in invalid roots").  I'd have to think more about
whether or not that's safe/correct for the shadow MMU though.

For this case, I think it makes sense to just add the check in kvm_mmu_reload().

