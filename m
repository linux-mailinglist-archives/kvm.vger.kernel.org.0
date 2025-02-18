Return-Path: <kvm+bounces-38460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D176A3A395
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B3307A2BD9
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484AD26F47A;
	Tue, 18 Feb 2025 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RNhBraSR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5C826AABB
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739898472; cv=none; b=FP9WnK/0dEx2OXwAhrnieJwHreRBQviyHcLkrATLhoU1sw0CXWShlGDiTLfbkEVX2NAxE7utzXe4jxBAjsHJtWLpIsf36L/vDQkjLhjAjJjpJX5H3RzoQZC3W82eNlmkpQh1lWRnSza32IMnqXwZ+w9062ZqrmRrYU2dutzMCKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739898472; c=relaxed/simple;
	bh=1NxcraeuXjbuqp0rTKAGYMz3VydHza7fJFuRaJ7IUG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y1y1Cng1lArr0lHg1L6OSi2XayhqrCDe/P6spUdknhifM8r93PHAtT86jm5PoOa3uP9R3w51ghuoz/P1fZ2wSUGgUF/DYk3BGqX6N1OHUmVp8JqWT2UBwUmHmDgBLtH5mYoA+3qBtCvCBynqyhCKPNS2Ub5/rV4g9oz38XPy4Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RNhBraSR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc318bd470so8478468a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739898470; x=1740503270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7G98CO03QnnN9xtWKhsLWFqy1wfvQeBeOeRO1YTnQE=;
        b=RNhBraSRrjp0TGnnY1FN29Orbkx3vxKdJeo4lPa20iqwaGeMAS6T35YIWmg/7jLEpJ
         15Nd18cmgoPdyMybM4IlFz8pB5UHzfMfIKUYrySjTXOh+z6t75/KvefCHUx9r2DdJoSb
         186/lB219p+3Ihcp7cMfn0c+fRU2htCNlzgE8jFYPuqnH7c80P+KiGL6zNSrTn/LmcaV
         mMbI+1R5IJSgfsvEVw2xfLmElBemEU+x0PgiXD6HzSOD8UfukqphXYpuZ+6caQ5Ep+Cz
         lo5UNhDk/RR69/ku9WZdWaFCYZRxgCzX82zAKx6khdOFIlQxpo1cPCQugg9nMWz4xzBH
         s3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739898470; x=1740503270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7G98CO03QnnN9xtWKhsLWFqy1wfvQeBeOeRO1YTnQE=;
        b=N9lMVEJiVzeUiQVj2UqZspUmBEM8F+pXQkAjUcrYiJo4jtLe2iuLVBcVzDW4mnY89n
         eNMu37H13mktcVJ1hyXES1FplTkf1Bu//yG5N8CksO2Z6fGlqjG2+P1W4je2GAacRvSA
         Lezob0O0PemDm1ghZLfsqXm4EgBjaI8gfZStOL/kxwTqfhMucwYMKJWw6Bgkvwf8z6hw
         pYbdDehZkl1j6F1cSfjJSIU2hQjAU9gSbUpN5MhPvf5jdLDGAPl0WzqGnK4lhtbEqoc2
         DHMOFPeyipM2qyWSKn8zlPCSZBaskYqGQKnBgKGKh5Tu6NEoobys8a6Ipyx/ftrL/cS2
         Zk2A==
X-Forwarded-Encrypted: i=1; AJvYcCX+EBat1DSSutG6m8dNGdub0AeqCy1iAOXULUbskfZg+g3ghgRNh/js+++4iekWnc4e5sk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqs86tZkgbi/UGzZT+O02aTLuEeWz+zLd4Y/j65GDdG9n9DxQT
	UizogBrj1OaxVIOKEtafhLj0gZZLRGYwABe2/pQFsDrnhlZrugnDcnM74GRFYh98Gb7163PZKGE
	p1w==
X-Google-Smtp-Source: AGHT+IFFSpaYywVlY9O6AQ/VFTVHYkh6sydzucWQ2EmfRDneUwk2wiuFo7ElcO1xKLr/10aECb1WbymrHWw=
X-Received: from pfbjt23.prod.google.com ([2002:a05:6a00:91d7:b0:730:b665:d832])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:23c5:b0:730:927c:d451
 with SMTP id d2e1a72fcca58-732619150e0mr23520657b3a.20.1739898470209; Tue, 18
 Feb 2025 09:07:50 -0800 (PST)
Date: Tue, 18 Feb 2025 09:07:48 -0800
In-Reply-To: <9066c1cc-57e7-4053-bb33-dc8d64a789ba@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207233410.130813-1-kim.phillips@amd.com> <20250207233410.130813-3-kim.phillips@amd.com>
 <4eb24414-4483-3291-894a-f5a58465a80d@amd.com> <Z6vFSTkGkOCy03jN@google.com>
 <6829cf75-5bf3-4a89-afbe-cfd489b2b24b@amd.com> <Z66UcY8otZosvnxY@google.com> <9066c1cc-57e7-4053-bb33-dc8d64a789ba@amd.com>
Message-ID: <Z7S-ZKuOp6aqcR7l@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	"Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Kishon Vijay Abraham I <kvijayab@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 14, 2025, Kim Phillips wrote:
> On 2/13/25 6:55 PM, Sean Christopherson wrote:
> > On Thu, Feb 13, 2025, Kim Phillips wrote:
> > > > > Not sure if the cpu_feature_enabled() check is necessary, as init should
> > > > > have failed if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES wasn't set in
> > > > > sev_supported_vmsa_features.
> > > > 
> > > > Two things missing from this series:
> > > > 
> > > >    1: KVM enforcement.  No way is KVM going to rely on userspace to opt-in to
> > > >       preventing the guest from enabling features.
> > > >    2: Backwards compatilibity if KVM unconditionally enforces ALLOWED_SEV_FEATURES.
> > > >       Although maybe there's nothing to do here?  I vaguely recall all of the gated
> > > >       features being unsupported, or something...
> > > 
> > > This contradicts your review comment from the previous version of the series [1].
> > 
> > First off, my comment was anything but decisive.  I don't see how anyone can read
> > this and come away thinking "this is exactly what Sean wants".
> > 
> >    This may need additional uAPI so that userspace can opt-in.  Dunno.  I hope guests
> >    aren't abusing features, but IIUC, flipping this on has the potential to break
> >    existing VMs, correct?
> > 
> > Second, there's a clear question there that went unanswered.  Respond to questions
> > and elaborate as needed until we're all on the same page.  Don't just send patches.
> > 
> > Third, letting userspace opt-in to something doesn't necessarily mean giving
> > userspace full control.  Which is the entire reason I asked the question about
> > whether or not this can break userspace.  E.g. we can likely get away with only
> > making select features opt-in, and enforcing everything else by default.
> > 
> > I don't think RESTRICTED_INJECTION or ALTERNATE_INJECTION can work without KVM
> > cooperation, so enforcing those shouldn't break anything.
> > 
> > It's still not clear to me that we don't have a bug with DEBUG_SWAP.  AIUI,
> > DEBUG_SWAP is allowed by default.  I.e. if ALLOWED_FEATURES is unsupported, then
> > the guest can use DEBUG_SWAP via SVM_VMGEXIT_AP_CREATE without KVM's knowledge.
> > 
> > So _maybe_ we have to let userspace opt-in to enforcing DEBUG_SWAP, but I suspect
> > we can get away with fully enabling ALLOWED_FEATURES without userspace's blessing.
> 
> If I hardcode DEBUG_SWAP (bit 5) in the vmsa->sev_features assignment
> in wakeup_cpu_via_vmgexit(), such guest boots successfully with the
> kvm_amd module's debug_swap parameter set.
> 
> The guest *doesn't* boot if I also turn on allowed_sev_features=1 with
> qemu and this patchseries.
> 
> So, the answer is yes, always enforcing ALLOWED_SEV_FEATURES does break
> existing guests, thus the userspace opt-in for it.

That is not an "existing" guest.  That's a deliberately misconfigured guest that
serves as testcase/reproducer.  IIUC, the BSP can't enable DEBUG_SWAP through a
backdoor, so I don't think it's at all sane/reasonable for the guest to expect
that enabling DEBUG_SWAP only on APs will function.  Ah, and KVM will still set
the DR7 intercepts, i.e. the guest can't read/write DR7, so this is definitely a
nonsensical/unsupported configuration.

So unless I've missed something, KVM can unconditionally enforce ALLOWED_SEV_FEATURES.

