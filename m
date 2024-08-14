Return-Path: <kvm+bounces-24195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1419522B8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 21:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D609284C99
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463E21BF300;
	Wed, 14 Aug 2024 19:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dIjF7rsz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FCC374FA
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723664057; cv=none; b=OYYkcIUfFWmjmSuztt4nYhErbibyP7IK9R3KyM7JzxLoagCKIOll+VANRGinYZ4qbHDUCJ+CdeHk1NcDWD860YPDGCi7+wseoZgVqJQSs2scvft+sqjEoq/SiN+uifuAeVLD/Qospi7W5dd3KPoBhMy5n8qmpNw6ASSkSiv5Eag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723664057; c=relaxed/simple;
	bh=FdU8SvzcWm3PWPtIGFD/hoKydvzDoQz5Wplue72HPm4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IazI8egCC5relG+nTvqj4fG4W3+r8AIdwbElnvEW8vAWy24Lw5suIBeJflULbIoUAIEFvdXQGrLl6jvq0/5nuA8RfLH9azPW2UZ2NzQIDp1Q9qF7dFtjwjk+UF9fj1nAMogsOlKq4GVe2AhPVXrKyx4YdvDtk8eONyB9SkzN46U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dIjF7rsz; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-690404fd34eso5997477b3.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 12:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723664055; x=1724268855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y8cWK2+UYGLsva20MxS90pT4B5pootLE6XLQcrnibDs=;
        b=dIjF7rszBcek1yI7j3xtWOmNk8dOHb1hxHQ22/rd5KSj2kXRdziUn80gkQvVQkZ8Do
         MIU8CpQ1KaoCqOW5LrC0iY1vT2C2syZzAO8kR98agNdVO+MXLwKRe1vCe+Y4P0ln6s64
         QEZBuGRju9s+sl4pGtzhN+4XI5g4EWpvxa+Vro1fBEJeP4AQzYPnNy69T+Mb7OMadd1E
         rsmUeKK4dNsSUmoSzbzhrcnhHFpEPUFH55fOyu3q+pxp3+7hcrMCMQyOGRuSuBTmtI7a
         KDi109WyXP8z6vMfm9ptU+RDAY9PRNP7gWESev4JXwAFWAudFPGAdrX8yYJ+XxxQjy6K
         S3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723664055; x=1724268855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y8cWK2+UYGLsva20MxS90pT4B5pootLE6XLQcrnibDs=;
        b=HByyPtIua7bweG2KGhv0/V4YY2bJ0UbB+8X+nGbHryTnWd/9WEH+Q1FYxOcNNte5tZ
         /6LN3S+G9l05Px/98m0+QF/yOfpLWzPNjxXou+GUORPqq6Lx0de7XuCyTpM/zCm4htKd
         Qv7VWvLTAFrU9le5+dN5P33mGLtfRWsk15lToz7DajuUyMASnQSq5rkaDoBwyv8qQfHP
         hHwM5YKt+vJFJLc7agVqnCm3Nvo14yc8zNolCZ/87PkydsoYR3lhSevz0hNgXX6zgw7x
         z05j4QDkuPiayEQs5bHdZb+lZGzzf5wKKiMLj5YlxoaOiHGQiPMLWyHY+oU2h43k+4XJ
         mVAQ==
X-Gm-Message-State: AOJu0YyzuDr0EiFlq8B7kfbo1ZjBzfM9N5pEGx7H/e8h/ddcAIPln/q6
	1nXtcCo8t3EcUEafjfpWZnbzlMakzmhNsTqf32pbp6h6w9QtZW+Rji4IQfyzmNIbQp9I6CmXAok
	uag==
X-Google-Smtp-Source: AGHT+IHLt1+HKA0U+xh5NYnbNVB+Ne7FTbbFACVfA5pF/rj2OeD0F++kPiOpi0T4SKQEBxj/Y2L/KElEtSU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:105:b0:e11:5da7:337 with SMTP id
 3f1490d57ef6-e115da70653mr49577276.3.1723664054395; Wed, 14 Aug 2024 12:34:14
 -0700 (PDT)
Date: Wed, 14 Aug 2024 12:34:12 -0700
In-Reply-To: <96293a7d-0347-458e-9776-d11f55894d34@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-4-seanjc@google.com>
 <96293a7d-0347-458e-9776-d11f55894d34@redhat.com>
Message-ID: <Zr0GtPKepCbBgjWW@google.com>
Subject: Re: [PATCH 03/22] KVM: x86/mmu: Trigger unprotect logic only on
 write-protection page faults
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> On 8/9/24 21:03, Sean Christopherson wrote:
> > Trigger KVM's various "unprotect gfn" paths if and only if the page fault
> > was a write to a write-protected gfn.  To do so, add a new page fault
> > return code, RET_PF_WRITE_PROTECTED, to explicitly and precisely track
> > such page faults.
> > 
> > If a page fault requires emulation for any MMIO (or any reason besides
> > write-protection), trying to unprotect the gfn is pointless and risks
> > putting the vCPU into an infinite loop.  E.g. KVM will put the vCPU into
> > an infinite loop if the vCPU manages to trigger MMIO on a page table walk.
> > 
> > Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> > Cc: stable@vger.kernel.org
> 
> Do we really want Cc: stable@ for all these patches?  Most of them are of
> the "if it hurts, don't do it" kind;

True.  I was thinking that the VMX PFERR_GUEST_{FINAL,PAGE}_MASK bug in particular
was stable-worthy, but until TDX comes along, it's only relevant if guests puts
PDPTRs in an MMIO region.  And in that case, the guest is likely hosed anyway,
the only difference is if it gets stuck or killed.

I'll drop the stable@ tags unless someone objects.

> as long as there are no infinite loops in a non-killable region, I prefer not
> to complicate our lives with cherry picks of unknown quality.

Yeah, the RET_PF_WRITE_PROTECTED one in particular has high potential for a bad
cherry-pick.

> That said, this patch could be interesting for 6.11 because of the effect on
> prefaulting (see below).
> 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c          | 78 +++++++++++++++++++--------------
> >   arch/x86/kvm/mmu/mmu_internal.h |  3 ++
> >   arch/x86/kvm/mmu/mmutrace.h     |  1 +
> >   arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
> >   arch/x86/kvm/mmu/tdp_mmu.c      |  6 +--
> >   5 files changed, 53 insertions(+), 37 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 901be9e420a4..e3aa04c498ea 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2914,10 +2914,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> >   		trace_kvm_mmu_set_spte(level, gfn, sptep);
> >   	}
> > -	if (wrprot) {
> > -		if (write_fault)
> > -			ret = RET_PF_EMULATE;
> > -	}
> > +	if (wrprot && write_fault)
> > +		ret = RET_PF_WRITE_PROTECTED;
> >   	if (flush)
> >   		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
> > @@ -4549,7 +4547,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >   		return RET_PF_RETRY;
> >   	if (page_fault_handle_page_track(vcpu, fault))
> > -		return RET_PF_EMULATE;
> > +		return RET_PF_WRITE_PROTECTED;
> >   	r = fast_page_fault(vcpu, fault);
> >   	if (r != RET_PF_INVALID)
> > @@ -4642,7 +4640,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
> >   	int r;
> >   	if (page_fault_handle_page_track(vcpu, fault))
> > -		return RET_PF_EMULATE;
> > +		return RET_PF_WRITE_PROTECTED;
> >   	r = fast_page_fault(vcpu, fault);
> >   	if (r != RET_PF_INVALID)
> > @@ -4726,6 +4724,9 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> >   	case RET_PF_EMULATE:
> >   		return -ENOENT;
> > +	case RET_PF_WRITE_PROTECTED:
> > +		return -EPERM;
> 
> Shouldn't this be a "return 0"?  Even if kvm_mmu_do_page_fault() cannot
> fully unprotect the page, it was nevertheless prefaulted as much as
> possible.

Hmm, I hadn't thought about it from that perspective.  Ah, right, and the early
check in page_fault_handle_page_track() only handles PRESENT faults, so KVM will
at least install a read-only mapping.

So yeah, agreed this should return 0.

