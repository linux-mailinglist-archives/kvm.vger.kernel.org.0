Return-Path: <kvm+bounces-27688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2E898A932
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 17:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 002D12820FD
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 15:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB143198A2C;
	Mon, 30 Sep 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cebJpICq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B86198A0B
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727711681; cv=none; b=joDcNOxcGyvP2iJSGsk4BwkBvVBp1cEkIRyM/dLMUlTSYXNiSyL0GWhWTCQZJFhrlgTp3y468ziWRUo2c/ypoVAXmnESLqSH0C3ZfdLI9wwGf4RO7G6Zuv/YDcGftPVmKLREu1tHESkmll3Rq4qiDbHRysTOLnZ88kEHsGOWWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727711681; c=relaxed/simple;
	bh=nhhbCce3fqz81/eAPwzKIp/fZN5gncwElsMsTcAVJOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LE8VoGUPH95Tq0sY6SWq2sefqiGaGeGACg5kyduWaNEdhh9ZPSDFUtMZ+Ed7c1Tv8A9S/hD5RXEn2XqFFjNYqIUgpi7CPkDBJfqbQobkGN8ao1215kCTzrUHNgkOA/5Sk3i6bPmucaS8Qr0KpSpGOmzKZdQ0fmCLMX65dFYxQd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cebJpICq; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e000d68bb1so64263257b3.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 08:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727711679; x=1728316479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHlgl1OU10TxRZyUDuW+bs1ccpPD0I2h77Bfdo0uoTM=;
        b=cebJpICqAQZFGVk0enrAhUBARFjgmivtviy335nd8wnUb5fEnguj56fo029ZRtE/UN
         sebXI1Xgz7jpKBNINliAXFQKmzflkXoi0iDqRV+L8VrjdVAcFKstGykoRjXL+0bDY35u
         jXykcsfLRjJizrGweh7ycJ/DAl/0iKxNkCw+otxthQnBhwZky3QtvMRGwmRasxz8x3t2
         U2LeXDKc9OV+yuVJOwfz9oFrU9b2iRGqmcS4Hr6q0dFnH1JLHxBWmBRqh4Bu3ILGtyRV
         GVTAqmlCvuzhsWMDszDg0I776sstjgySHCkSwerboMYGIXdDQ+DLZb2e4wjW2cNjyQOu
         QYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727711679; x=1728316479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KHlgl1OU10TxRZyUDuW+bs1ccpPD0I2h77Bfdo0uoTM=;
        b=Jrd2eC8mChFKzsHvI9nzWrvsoazn0I3aXjvcprTc/2t/Oi4/UNbCuZAOeCWogYtKbS
         60wcS6p7GBHg8tL1NrNQg8a7sY7I+cB+UbY57JIrF42/0wT1aHbNobtJtFb+mjBUT6TS
         b18n+o7Tc9jeM5t8x5+OyQrF3oQ77jVSC1sqYQO2R3S6KroXDICJp7wampoUpdwYZ1QN
         lheP3lakeiTSeVH910w0aY9dQrWmIf6VEKpkukwPfYa8UlkQz87saUXan5ElHeb7/QW3
         bwVxu9Z+sfiFeTJs0A7tKl+nIBFIizHvaOfg+gz4g1qC++3ZzWORPk2+SOVjsd0hokWW
         JjVg==
X-Forwarded-Encrypted: i=1; AJvYcCWAwqcOlLi3xbaNx8/IFPUwko7+cePzM3qo8E+megHnRilX/mQbnNh4YKdpwG2CzH6ZTZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEwNf/51YvneDzWVroGzCRPJrjSP62j0wskCxXlPlJKqgaiKVX
	KrhJobYP65PuSAHIPLTICH2Oct9nHIgnNbDb8xXUx4NkVHmOUoufLLO1L72GMWotRxybkKp5gWb
	e6Q==
X-Google-Smtp-Source: AGHT+IGI8ArXTT++uw268LAHvx9ITQXkBOKCLdaZZuarGLMVL4Raa3nCrYADedAO/OaoBLwiacsp3LFbUlk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6843:0:b0:e20:2da6:ed77 with SMTP id
 3f1490d57ef6-e262c05389cmr43276.5.1727711679207; Mon, 30 Sep 2024 08:54:39
 -0700 (PDT)
Date: Mon, 30 Sep 2024 08:54:38 -0700
In-Reply-To: <ZvkdkAQkN5LmDaE6@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com> <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com> <ZvbB6s6MYZ2dmQxr@google.com> <ZvkdkAQkN5LmDaE6@yzhao56-desk.sh.intel.com>
Message-ID: <ZvrJvucBw1iIwEG6@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, sagis@google.com, 
	chao.gao@intel.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Sep 29, 2024, Yan Zhao wrote:
> On Fri, Sep 27, 2024 at 07:32:10AM -0700, Sean Christopherson wrote:
> > On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > > On Thu, Sep 26, 2024, Yan Zhao wrote:
> > > > On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > > > > On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > > > > Right now, the fixes for make_spte() are sitting toward the end of the massive
> > > > > kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> > > > > fairly confident that series can land in 6.13 (lots and lots of small patches).
> > > > > 
> > > > > ---
> > > > > Author:     Sean Christopherson <seanjc@google.com>
> > > > > AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> > > > > Commit:     Sean Christopherson <seanjc@google.com>
> > > > > CommitDate: Thu Sep 12 16:35:06 2024 -0700
> > > > > 
> > > > >     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
> > > > >     
> > > > >     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
> > > > >     leaf SPTE (with the same target pfn) and clears the Writable bit or the
> > > > >     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
> > > > >     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
> > > > >     if the existing SPTE is writable.
> > > > >     
> > > > >     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
> > > > >     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
> > > > >     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
> > > > >     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
> > > > >     the only SPTE that is dirty at the time of the next relevant clearing of
> > > > >     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
> > > > >     because it sees the D=0 SPTE, and thus will complete the clearing of the
> > > > >     dirty logs without performing a TLB flush.
> > > > But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
> > > > matter clear_dirty_gfn_range() finds a D bit or not.
> > > 
> > > Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> > > posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> > > x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> > > anything should be backported it's that commit.
> > 
> > Actually, a better idea.  I think it makes sense to fully commit to not flushing
> > when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
> > TLB flush.
> > 
> > E.g. on top of this change in the mega-series is a cleanup to unify the TDP MMU
> > and shadow MMU logic for clearing Writable and Dirty bits, with this comment
> > (which is a massaged version of an existing comment for mmu_spte_update()):
> > 
> > /*
> >  * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
> >  * TLBs must be flushed.  Otherwise write-protecting the gfn may find a read-
> >  * only SPTE, even though the writable SPTE might be cached in a CPU's TLB.
> >  *
> >  * Remote TLBs also need to be flushed if the Dirty bit is cleared, as false
> >  * negatives are not acceptable, e.g. if KVM is using D-bit based PML on VMX.
> >  *
> >  * Don't flush if the Accessed bit is cleared, as access tracking tolerates
> >  * false negatives, and the one path that does care about TLB flushes,
> >  * kvm_mmu_notifier_clear_flush_young(), uses mmu_spte_update_no_track().
> I have a question about why access tracking tolerates false negatives on the
> path kvm_mmu_notifier_clear_flush_young().
> 
> kvm_mmu_notifier_clear_flush_young() invokes kvm_flush_remote_tlbs()
> only when kvm_age_gfn() returns true. But age_gfn_range()/kvm_age_rmap() will
> return false if the old spte is !is_accessed_spte().
> 
> So, if the Access bit is cleared in make_spte(), is a TLB flush required to
> avoid that it's not done in kvm_mmu_notifier_clear_flush_young()?

Because access tracking in general is tolerant of stale results due to lack of
TLB flushes.  E.g. on many architectures, the primary MMU has omitted TLB flushes
for years (10+ years on x86, commit b13b1d2d8692).  The basic argument is that if
there is enough memory pressure to trigger reclaim, then there will be enough TLB
pressure to ensure that omitting the TLB flush doesn't result in a large number
of "bad" reclaims[1].  And conversely, if there isn't much TLB pressure, then the
kernel shouldn't be reclaiming.

For KVM, I want to completely eliminate the TLB flush[2] for all architectures
where it's architecturally legal.  Because for KVM, the flushes are often even
more expensive than they are for the primary MMU, e.g. due to lack of batching,
the cost of VM-Exit => VM-Enter (for architectures without broadcast flushes).

[1] https://lore.kernel.org/all/CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com
[2] https://lore.kernel.org/all/Zmnbb-Xlyz4VXNHI@google.com

