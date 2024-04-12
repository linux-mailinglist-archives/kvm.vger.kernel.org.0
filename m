Return-Path: <kvm+bounces-14543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A821D8A32D0
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 496CA1F21FE3
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 15:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41D91487FE;
	Fri, 12 Apr 2024 15:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w/I0yyVP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC54813BADA
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 15:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712936913; cv=none; b=uymOozTPJA6auyRdvZdjDwcO+j0jqr2Y8yCLcqFNkk3yO9IKWjwQhEg10ZtoGB9twsYfzwVyU2MuwVhVYV3xnhgm8w9EfQa5EbgrQbyVW/ux/NN8ShQXnHiFAU7E4GA66ySMQfrC6ZXAmgVPVgu3XGZ+0O2ml/poOfGNwBVcp8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712936913; c=relaxed/simple;
	bh=ar7/cxhcBFbL7vKVBU8wLrfvAVJqJ3/RxV+hc/udpGY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KYfKduT6TB4rArY6rp/Xk3Z9EFMsfHIJq15g/8uVstZTy4w1tdCL/oacHk5FYxg2h5HjP/7ab0Ud5w1fmp39pPaZ+l9WSjHFIPpFD2lBSUiVZr9/dNFy8t7deoLoMVGT21iWPLkOdsOiF5VGrTFe9HmabIgmKtCozy/h2scUcEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w/I0yyVP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so1786123276.3
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712936910; x=1713541710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3o+vZZ6OKOxQrdR93Vf9TD2giqoTwbCp2qwEdrct+qU=;
        b=w/I0yyVPiiR65sIOlf08LWKEXt0qyM36t6jEws8rO1mmlw1w1ZU4Jole+zRjJbNiEs
         VPciCcS2u9Mb0FvwdsVMQEaqc1zHAZ2PTtRfWeZ06GLT5gv3RLIIMe4KpkxRfcwUO+Ft
         d+q+XWT4xJqLOtkHfmKkcT2vrLC2ylb+ttVu8TSrD1h0vYBLOGKaYJwpFM40DSY0QouM
         NoIbDzO90/Fq9+AcxRulRiM2/H4dtYhZafDtfakpD8FCg0FHPFj8ccgLHEtSgFBfpq+g
         0RQkGqlVdr2cAoOPSWjjKP8uHr18gkAKlYdAIcY2kC9RQbhOGTMRBrUuYRM+20y6kTEM
         f70Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712936910; x=1713541710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3o+vZZ6OKOxQrdR93Vf9TD2giqoTwbCp2qwEdrct+qU=;
        b=GTT40ea1nCMDuTFHsfxDa6jS2mw3MBtYApBpb8Va4qRSZ/gPk6rc1gANh2pEIx52i5
         w03DiTAgUnZwP0GF7dd8x5vxqkHz6eko5gQmneb3pqcz6DRtKZMMXgR9RxzGliA0uz/S
         62kY/v/w9n2nUzafJpfBsi3MYKheaaJ3a1Az8cz6s0lIr1jdQY8AOGNp6pr5IDDO/f3/
         bvuEjUwEAQ+3BDdUaDOx3YM69YJBU85hzhBO1OR40mXJ+uenvDeIC72TUHgvrDReO1fj
         mvTC/rTkQ2Y+izRIi4sz5KdJNmZbWa+vvdIBS2b5otdz0LD5XRWjUft4lDgxRsluWIl3
         hsVQ==
X-Gm-Message-State: AOJu0YyptitN5ZxYHRCWAM/F7P4pLopYayJv0Nis4C3+p6gy0HCAntoA
	m4ex/51Jzftn8UrvuxtjOnrM33Kx2F7bDoXJjN31D5X8ZMJ0lcSmhh8xixA7NO6s12QedylbwCY
	Fkw==
X-Google-Smtp-Source: AGHT+IGvpblNjkHhkdN/jHy17hfNhZb+2SQ49+Fir9yl1Jy+swAphKoksfddiPzThhbg03c/VJQJ35i9AN4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6d04:0:b0:dcd:59a5:7545 with SMTP id
 i4-20020a256d04000000b00dcd59a57545mr147243ybc.10.1712936910568; Fri, 12 Apr
 2024 08:48:30 -0700 (PDT)
Date: Fri, 12 Apr 2024 08:48:29 -0700
In-Reply-To: <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240313125844.912415-1-kraxel@redhat.com> <171270475472.1589311.9359836741269321589.b4-ty@google.com>
 <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com>
Message-ID: <ZhlXzbL66Xzn2t_a@google.com>
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in CPUID.0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 12, 2024, Xiaoyao Li wrote:
> On 4/10/2024 8:19 AM, Sean Christopherson wrote:
> > On Wed, 13 Mar 2024 13:58:41 +0100, Gerd Hoffmann wrote:
> > > Use the GuestPhysBits field (EAX[23:16]) to communicate the max
> > > addressable GPA to the guest.  Typically this is identical to the max
> > > effective GPA, except in case the CPU supports MAXPHYADDR > 48 but does
> > > not support 5-level TDP.
> > > 
> > > See commit messages and source code comments for details.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 misc, with massaged changelogs to be more verbose when
> > describing the impact of each change, e.g. to call out that patch 2 isn't an
> > urgent fix because guest firmware can simply limit itself to using GPAs that
> > can be addressed with 4-level paging.
> > 
> > I also tagged patch 1 for stable@, as KVM-on-KVM will do the wrong thing when
> > patch 2 lands, i.e. KVM will incorrectly advertise the addressable MAXPHYADDR
> > as the raw/real MAXPHYADDR.
> 
> you mean old KVM on new KVM?

Yep.

> As far as I see, it seems no harm. e.g., if the userspace and L0 KVM have
> the new implementation. On Intel SRF platform, L1 KVM sees EAX[23:16]=48,
> EAX[7:0]=52. And when L1 KVM is old, it reports EAX[7:0] = 48 to L1
> userspace.

Yep.

> right, 48 is not the raw/real MAXPHYADDR. But I think there is not statement
> on KVM that CPUID.0x8000_0008.EAX[7:0] of KVM_GET_SUPPORTED_CPUID reports
> the raw/real MAXPHYADDR.

If we go deep enough, it becomes a functional problem.  It's not even _that_
ridiculous/contrived :-)

L1 KVM is still aware that the real MAXPHYADDR=52, and so there are no immediate
issues with reserved bits at that level.

But L1 userspace will unintentionally configure L2 with CPUID.0x8000_0008.EAX[7:0]=48,
and so L2 KVM will incorrectly think bits 51:48 are reserved.  If both L0 and L1
are using TDP, neither L0 nor L1 will intercept #PF.  And because L1 userspace
was told MAXPHYADDR=48, it won't know that KVM needs to be configured with
allow_smaller_maxphyaddr=true in order for the setup to function correctly.

If L2 runs an L3, and does not use EPT, L2 will think it can generate a RSVD #PF
to accelerate emulated MMIO.  The GPA with bits 51:48!=0 created by L2 generates
an EPT violation in L1.  Because L1 doesn't have allow_smaller_maxphyaddr, L1
installs an EPT mapping for the wrong GPA (effectively drops bits 51:48), and
L3 hangs because L1 will keep doing nothing on the resulting EPT violation (L1
thinks there's already a valid mapping).

With patch 1 and the OVMF fixes backported, L1 KVM will enumerate MAXPHYADDR=52,
L1 userspace creates L2 with MAXPHYADDR=52, and L2 OVMF restricts its mappings to
bits 47:0.

At least, I think that's what will happen.

