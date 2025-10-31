Return-Path: <kvm+bounces-61737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 57695C2722C
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 23:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7EA6D4F41C4
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 22:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B71E302144;
	Fri, 31 Oct 2025 22:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3K6A1ECk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D262DBF76
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 22:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761950258; cv=none; b=nj4MDR1SyGlMfJYzSHQhykexChsqA+v7gSm4Xojha0A8r0GWgr44X/ZreLQCHHpU8O8Ef2Jt5gq+H9t46aRQcIg4yo3pDxtJnQPV/5Ce3L3dQSwuD6acx+Hs2g5TbCfNdHvofoZsRDloKEeVeIaCpATDg/ciiLOfTZ1/3dDPFBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761950258; c=relaxed/simple;
	bh=vux0Wwx/9W3FtLrC7lRRcKcZZ6Lsj4RQdTq5HQzzrgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JvgiBq8EsbmRu1QMx5Gip9m6A9H3+hQwNefymaBDjeYyH2MGR+zEVTdW60q2oyezaeiwSQXe2hcvM75ddngwGm8A/vHOGYNhVsG/3eaMioFLyEgTe0BHGoXp4ITiDyujHOKhPmhR5Sf274Nb4DpQWUt44CmkVt7OggSCsgGp/Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3K6A1ECk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340299e05easo2662109a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 15:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761950256; x=1762555056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2T//pv73tE9Ei8o1XpXkzLHPQNKRotM7rF6yYw0F0ng=;
        b=3K6A1ECkAh+26/VlWFKuVCrJ/YLOpSz5sm9cbHT4Vt5AvKQEMyehBLDF1rLv0/XU9o
         PQZcD2q4VUMuarS+ia2u0SiLKQaCsYsG++i0BSWhV7P6oUuW4fZHiTXDtEF6ItckxYV1
         p9UThRufukTUcFOCoIgGzNzsy5/Zc3ukaP2P19L1Meg/7hfsA+O4bQSIFaIl1u4W7tWO
         2EkyTFkfNY42GpfuLeMYCfffk50bl1tg8SfghBA2m5IS8GK1dekvz9tZMoks8GRKKoBW
         3FjHVaN5sd8oQ58GvqfuefVtqyFHEDlPhbA7lGxAP/VHlc4wJbKaLCNcbObsDnmsxxKG
         QF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761950256; x=1762555056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2T//pv73tE9Ei8o1XpXkzLHPQNKRotM7rF6yYw0F0ng=;
        b=QVM4hkL8NwnpwjVgMNLm2L1opVZNMmWDAH4l0//sJvjsoh13MfjRRcNLW5qXqsL0sw
         WzGIm1H7WXGj7qjRyQCvDMcd1mZ2SuZElTMFNw5kLAAanmVmCeqhb9Pq0B+nC1HasR6G
         aq+M67nt+/nmV3nLUEdTOIO24zu67Flc3+tLU8/4zKFVN864wK4D3GUKJBl0Fmd6LgJk
         PME05gv28bYkxWeACZyFYje+DzEQj67BTHi7GRSUt77rz9jpmDfua+4KIm6JIJF0u0cn
         lnYTVQjd+uhZ3hujPPIUCGjbzUExbbQxORVMw2b7wv8g2EqqqQh3nDJ1PjWNoS9jLmJ1
         9Fyw==
X-Forwarded-Encrypted: i=1; AJvYcCVo4UKq8tb2/ayIFsTMJq+yNKa9cmmaJ7jCt6gjWZ5/xX2JlLzGrvntTvedY0B1hnptm3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvFGeVWi3pD/BKNbVPaaWnKQ5MZ8slHFeFzfI9PyEip2qZUUKE
	eIWFvk5iU5UqEN9/Td245WC5a5XqrW/4bBPwbxDJ/3dG7RnlJZsKKBEUTSXc9LxUBnJeyAqqMRK
	fT8CT9w==
X-Google-Smtp-Source: AGHT+IFBSsgOmDJAP0ZowasZdt6RS6QGflURINqQVeeKx6xgginy5tuxDnXnTajxz/ozqhWCKYOExEAszeA=
X-Received: from pjzh17.prod.google.com ([2002:a17:90a:ea91:b0:340:bd8e:458f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcc:b0:339:f09b:d36f
 with SMTP id 98e67ed59e1d1-3408308a1b0mr5879498a91.28.1761950256248; Fri, 31
 Oct 2025 15:37:36 -0700 (PDT)
Date: Fri, 31 Oct 2025 15:37:34 -0700
In-Reply-To: <20251031222804.s26squjrtbaq7aly@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-4-seanjc@google.com>
 <20251031222804.s26squjrtbaq7aly@desk>
Message-ID: <aQU6LqP-PxBQ-R0m@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO
 Stale Data mitigation
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Pawan Gupta wrote:
> On Thu, Oct 30, 2025 at 05:30:35PM -0700, Sean Christopherson wrote:
> > Convert the MMIO Stale Data mitigation flag from a static branch into an
> > X86_FEATURE_xxx so that it can be used via ALTERNATIVE_2 in KVM.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/cpufeatures.h   |  1 +
> >  arch/x86/include/asm/nospec-branch.h |  2 --
> >  arch/x86/kernel/cpu/bugs.c           | 11 +----------
> >  arch/x86/kvm/mmu/spte.c              |  2 +-
> >  arch/x86/kvm/vmx/vmx.c               |  4 ++--
> >  5 files changed, 5 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 7129eb44adad..d1d7b5ec6425 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -501,6 +501,7 @@
> >  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
> >  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
> >  #define X86_FEATURE_X2AVIC_EXT		(21*32+17) /* AMD SVM x2AVIC support for 4k vCPUs */
> > +#define X86_FEATURE_CLEAR_CPU_BUF_MMIO	(21*32+18) /* Clear CPU buffers using VERW before VMRUN, iff the vCPU can access host MMIO*/
> 
> Some bikeshedding from my side too:
> s/iff/if/

Heh, that's actually intentional.  "iff" is shorthand for "if and only if".  But
this isn't the first time my use of "iff" has confused people, so I've no objection
to switching to "if".

