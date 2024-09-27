Return-Path: <kvm+bounces-27627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 156A998872B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 16:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0121283101
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 14:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4163157A41;
	Fri, 27 Sep 2024 14:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hzg9T+MA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F61101F2
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 14:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727447705; cv=none; b=pRmX38BfOXLa7CB1yYr0cz7LbFWgqd0p6GtlGT4pc4BPU42n8iztExlAJnCvTQOpSWGofXJ7AmlVBvSYhbiFCgmIW2r74LBiEx1zmhvIhIbIM4X4Dhoth23A/TdmhEuWHIspOGPsYce27gv17Owox2fvXTtNmanOTnpR+c+95rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727447705; c=relaxed/simple;
	bh=26xfhZSnR38tIySAMPTN+tZMdkMAV+uEJr9WkWvF/ag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OS9euYUGPhoHxPSu/uP2lhHk7CavD22mSdsBEmXZsSNr0g6cI4aB3TtLn/EZY63wfxYGuooAyzznWG19pjtqHwYBHf3sUUu66XexZG2OB19WHRkHthmMv7sxB8XyuXNSZSNT2rRzJPQHYgZME+XD14QfJzoe3WuRninMtWt0aFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hzg9T+MA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e258c0e02a9so3246992276.3
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 07:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727447703; x=1728052503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7ySq9WAF3LhSVhIL2gzm1kyClTrXusjtIOTa8ObngI=;
        b=hzg9T+MAYpX7YqRRal7w6+nyv/v1i1T3kE9TuATZWKFCHgSqmOHXjgF3xq4KB/AWVG
         vXvO8bIttzMRDYZcXp5M+TkmUSeGISKoRo9jYFUAzGXWtZt1E0/ADarXexwJqNXLIwoj
         +nH6AZKaY9v+2P2DfT7ZrBXmy1e48ug9wUTzIupEp1a9XT3UyxwvUaaf6zFv8uCrgnIA
         4p7dYygRkoX6bxExxPY3yZ4/qQuWZ1+wVShH6O8dos91tiWRDxcl6EVEOY/1CSkpYBV6
         +AKcm48axBCtnDuL5vbR01K5dWw5j0LosS7w0EwOMyGC3Dg2poiDhTcFid9UF9gqiS+X
         qs9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727447703; x=1728052503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7ySq9WAF3LhSVhIL2gzm1kyClTrXusjtIOTa8ObngI=;
        b=HfMiowBNxcUlPYTSDs7fygg9PN7aSvVz1bRyVOv6HVr05MZwYsjp+IuiaStSs+wdwO
         TSBlsVTMG88HKFDTmeIhQ4KeTq9RnjOpfuyxezHNYn794idgjeHEgpNvBAsWyhPdnte0
         4GuZuFsOesDcmNWcRrRCrcS7lgxWP6EaixTZo9+212yhIP56yFVeV3kX4bwRinVV1Haz
         aJoRJX4diEH0/K1wJoNqDm3oY7Jfe62ewYUQJ9V5EktZKBOSEYDb9hURJ7zqe0kX4B6w
         30kIgCNhqBeDbR2itQIv78ojYk0+E/8D9zgIAY/BXyytIfcZXH2Hf9LU9yeObJBhZn2K
         wywQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcI/2IC9krPRPqPEtaxeZr1zeHgZ7TtAGL4sthYB9s7Mj4EYfA7LK1tu11RIVtnd1JxYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPvaYsZRQJPz+umbAWfI68NQlneDAbN53jRdEfu88uJSUQCh5y
	o+CtFg5rvQZU0m8tHZavwOD8C1GI7jZanRfbeyVhpZn7aAz4YTSKawAUz2q5oIJ3r6haPjwYIEQ
	1tg==
X-Google-Smtp-Source: AGHT+IHK44G6MEuSuK54ez0WbjUBvQMLb5IMMQ1FLEA4b5+xVcS/FEkwgYEE6D4iDUrKga1UOzUKK7X15ww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:14c:0:b0:e25:2491:d005 with SMTP id
 3f1490d57ef6-e2604b84f89mr2788276.8.1727447703410; Fri, 27 Sep 2024 07:35:03
 -0700 (PDT)
Date: Fri, 27 Sep 2024 07:32:10 -0700
In-Reply-To: <Zva4aORxE9ljlMNe@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com> <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com> <Zva4aORxE9ljlMNe@google.com>
Message-ID: <ZvbB6s6MYZ2dmQxr@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, sagis@google.com, 
	chao.gao@intel.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 27, 2024, Sean Christopherson wrote:
> On Thu, Sep 26, 2024, Yan Zhao wrote:
> > On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > > On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > > Right now, the fixes for make_spte() are sitting toward the end of the massive
> > > kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> > > fairly confident that series can land in 6.13 (lots and lots of small patches).
> > > 
> > > ---
> > > Author:     Sean Christopherson <seanjc@google.com>
> > > AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> > > Commit:     Sean Christopherson <seanjc@google.com>
> > > CommitDate: Thu Sep 12 16:35:06 2024 -0700
> > > 
> > >     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
> > >     
> > >     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
> > >     leaf SPTE (with the same target pfn) and clears the Writable bit or the
> > >     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
> > >     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
> > >     if the existing SPTE is writable.
> > >     
> > >     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
> > >     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
> > >     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
> > >     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
> > >     the only SPTE that is dirty at the time of the next relevant clearing of
> > >     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
> > >     because it sees the D=0 SPTE, and thus will complete the clearing of the
> > >     dirty logs without performing a TLB flush.
> > But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
> > matter clear_dirty_gfn_range() finds a D bit or not.
> 
> Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> anything should be backported it's that commit.

Actually, a better idea.  I think it makes sense to fully commit to not flushing
when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
TLB flush.

E.g. on top of this change in the mega-series is a cleanup to unify the TDP MMU
and shadow MMU logic for clearing Writable and Dirty bits, with this comment
(which is a massaged version of an existing comment for mmu_spte_update()):

/*
 * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
 * TLBs must be flushed.  Otherwise write-protecting the gfn may find a read-
 * only SPTE, even though the writable SPTE might be cached in a CPU's TLB.
 *
 * Remote TLBs also need to be flushed if the Dirty bit is cleared, as false
 * negatives are not acceptable, e.g. if KVM is using D-bit based PML on VMX.
 *
 * Don't flush if the Accessed bit is cleared, as access tracking tolerates
 * false negatives, and the one path that does care about TLB flushes,
 * kvm_mmu_notifier_clear_flush_young(), uses mmu_spte_update_no_track().
 *
 * Note, this logic only applies to leaf SPTEs.  The caller is responsible for
 * determining whether or not a TLB flush is required when modifying a shadow-
 * present non-leaf SPTE.
 */

But that comment is was made stale by commit b64d740ea7dd.  And looking through
the dirty logging logic, KVM (luckily? thankfully?) flushes based on whether or
not dirty bitmap/ring entries are reaped, not based on whether or not SPTEs were
modified.

