Return-Path: <kvm+bounces-52041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7B8B0048D
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 16:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 067551891AEC
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 13:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515F7273809;
	Thu, 10 Jul 2025 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sk7vll0S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E0F271A7B
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752155802; cv=none; b=udGrNceSTbl0R8GC147uxvOSW3pXzlzYnkA9Bi9dC0wMfM309Ye8l3R2PW7Sxt58pKSNHWlc4S1QCyxBnMbOdSPe9YckcP0jZTZqMuOvubCzCKOKmtfmJd7SfO7RuytGPZl+aFZDvLbU9xk8NYp3RQmaS7diAL28mNHtTvCus3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752155802; c=relaxed/simple;
	bh=5DtOimy0T+XI5TFEUlM8L85pT4fht3/s31oyvwu1R7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JR6xZgC/o9J54ZHlzQbFO6Cr+AX6mCRZY3ScdBPGZCJB8A5k8f+gQe2+HpaLytMicZWSot97boC1pJEFMvYiUzlEvoxqR0a8eO78yiLdLdom5iZF6HoZkKOSeh3c5/c1SwRwbWUYxl/10cDPuR0+mAZV3j1M1JWfKaGUBRdno8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sk7vll0S; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7494999de28so1399133b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 06:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752155800; x=1752760600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jdivoy2i5Gr9aD8xwW1tsvlEITdtVn9BeGlg1mVQmjw=;
        b=Sk7vll0SXqBIdEQp0GLBdsoo65qqS+hg07GoZaKsXnnASUiREsb6Vsz5ddpc2CDGJb
         lNQ3+yU6qWvAGRTW0grLTihs9kLyNyrH4Fe3jOPLhyRZ/rxZd9MSaqt6BgwrwW/4ZeE2
         Cbo5x28WpBwpl5AmmxLs7voa/5AE6eWT2gQsq6rRHlwclbvQGnOOADrbsohNyeEjsrlJ
         HR2tnMfzhPbskVE2MGkGl4XcyrsEIRsKp4FPQym2sc/5gg0PtyVRdtY0r0/YE3TPy8UV
         h5mJBIp2KJ3HT/R3j3o3qewS32AO4w+Y3TquZ2A0M1CeHswSMBbnMYfCt+QL4oUU4DX9
         CR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752155800; x=1752760600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdivoy2i5Gr9aD8xwW1tsvlEITdtVn9BeGlg1mVQmjw=;
        b=fczUZCReKKDHmHXY/8z/aK8zEy5N1cekGfBEc4exxjlc5hvXCKOk6U6CKuel+4EHwr
         53TEnqXa96wvaKmmxu1tuRUKBGV82P4rkwNUiSRwFnmdcYGIA/blEQjcfoivm8X39ldB
         mYJzqQcVUgt78bSOoW4B3jSwEMAPwWPBQ54C0b7cEn3TUGxN9D7fuY4FchhL1ockukIP
         /1COfHHoxLHOdwzJyK8cap6iDOZ8qQ0Z6NSlOAOSVvLQshVdZHOYqqBENuMejLbl3+c4
         MZ7+oGVqepEFhK/ug5VrE47g3YAZ6Jvw5wAB0jx8riwzriX+ErlB61Sb3o4o6jfR8/pB
         O+uw==
X-Forwarded-Encrypted: i=1; AJvYcCUVOR5QL9jwNQZkBYlgAYLIZIOJfQw5sZzAQ1Dn+KMkG43+sXCOa/rQOrwhjytaJ+XpXUw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3eWqop1bhnKsagMbQQbUTqJRbyHG2Ts96gvWO3mV6hO1OguBd
	W+7WNUc2tFHTICA5CRsjX2ZrCJZ9Trmk+SIbJ9MIMEWHe6y6s3kDXPSBO6Cjr4QZD/R7E7jYHGH
	vCaonYA==
X-Google-Smtp-Source: AGHT+IFQLmoe4r0uGjszcjS65GBUmZL9XmUcIofKbdPbRYIZxHVIlOanHmYbmqpsneWEQZcfGa1zcK869ME=
X-Received: from pfbfi6.prod.google.com ([2002:a05:6a00:3986:b0:746:247f:7384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c8c:b0:749:ad1:ac8a
 with SMTP id d2e1a72fcca58-74ea6684ae5mr10003879b3a.11.1752155800315; Thu, 10
 Jul 2025 06:56:40 -0700 (PDT)
Date: Thu, 10 Jul 2025 06:56:38 -0700
In-Reply-To: <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com> <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
Message-ID: <aG_GlsJWRU0fVxt4@google.com>
Subject: Re: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Kevin Loughlin <kevinloughlin@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Mingwei Zhang <mizhang@google.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 10, 2025, Borislav Petkov wrote:
> On Thu, May 22, 2025 at 04:37:27PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> > index 079c3f3cd32c..1789db5d8825 100644
> > --- a/arch/x86/lib/cache-smp.c
> > +++ b/arch/x86/lib/cache-smp.c
> > @@ -19,3 +19,14 @@ void wbinvd_on_all_cpus(void)
> >  	on_each_cpu(__wbinvd, NULL, 1);
> >  }
> >  EXPORT_SYMBOL(wbinvd_on_all_cpus);
> > +
> > +static void __wbnoinvd(void *dummy)
> > +{
> > +	wbnoinvd();
> > +}
> > +
> > +void wbnoinvd_on_all_cpus(void)
> > +{
> > +	on_each_cpu(__wbnoinvd, NULL, 1);
> > +}
> > +EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
> 
> If there's no particular reason for the non-GPL export besides being
> consistent with the rest - yes, I did the change for wbinvd_on_all_cpus() but
> that was loooong time ago - I'd simply make this export _GPL.

Yeah, AFAIK, no reason other than consistency.  GPL it.

