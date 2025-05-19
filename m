Return-Path: <kvm+bounces-46995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B33ABC36E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6751D4A306F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F91286D49;
	Mon, 19 May 2025 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="coH15fm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A87286D47
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747670582; cv=none; b=sVuV+WhI4t12S/v4taEyzY7tH5cgR+TZjyiK9yWFR4HmYoZIC8HgkrFTifuDAAlCREsQm1myK4k/UBgx4UZAJGDery15y8FQQ5YYBNLjRxCHrs62NIZgx7Y9Le/Ex08gmVpW/lS+QdSUUi4KyUzAW1KZEGI6IykOFB5HrdlnvNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747670582; c=relaxed/simple;
	bh=jJebhOC5pck9JgTcHl2pSKfcuNTMt61u6YUTJ5kvTUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JWh4yf5/QE0CXnuN6EqakjGCfO+vaV0uiZ5txb7QebpxW+0nL7daTtDrBhE383qAuGVRDktF8eU3DrF4TcnE7Wgvlh9sCFm0UAjykyiYHloyXC67v7JGFdC8tsBYFC20vFyjdGXGKYK9LIF8jnBQRv4m+6duN4EtvmFy6nwY7MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=coH15fm8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9e8d3e85so3046836a91.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 09:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747670580; x=1748275380; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ebJzx1LorPbf1NWqtTpnidvsrFRDAcdzNorkYWG1GY4=;
        b=coH15fm8DVgjJ9oVSK3pCxJlawUFPoHKISQE8BhpNKYwmBUliHUCewwDchSulcNumd
         LdvmKH3uF3FH//WFA4pI67zykejtgvMNAdvTUD1Mp4uXq3283uHUkZ74/RTmm3etKu+G
         KKsfUjsPXPBH3T3X3S8FDrfMdQmtfCzap8btLV53zHZIYl20gfP888Vc8EFwksn04HnD
         HbnKZxqcwDmzFmYvD7mo2U/nWYtoVrM/w8/K/ek2s3Xv/23sNjEVwZprupLZZkZIlhK/
         d7peMsu1j3yHtyNIpKxcWjgaS2TgKUrlxl3UpUkW0biPVs8xqJQiM5okPefBDAXzQDXk
         L2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747670580; x=1748275380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ebJzx1LorPbf1NWqtTpnidvsrFRDAcdzNorkYWG1GY4=;
        b=u+q1+cqfO2tDGpnDOCN/hwdz1/qzy6AnKC01cnCL8ZynglQmgzWoIiw9XbA8bpwUFS
         Rq4S936WkioYxaaxe3pJAFyC8kKRhWG9ADOqZtlzkV9Z2RMzK+7qu7jDRf2S6QGA/cAQ
         R4uJsEYFNN8BMYWHiGa76Mt5SW+icsa7Fqh8zKGRQl2TUWz7YGLVY9iRijtbzgacznrX
         kTay7XXIxMxbC2GhN/SwuaKxJV1gNQdn7c+6zQwS5PaIVibiLugMfHL1cuoL/+ng6Rud
         Lgj+VA3x456C6fkvEwpxPceOTMLBoFetZGoYKRxSBaJLdPCDG1oNj6HGhERXp+bnuaqu
         fQ7w==
X-Forwarded-Encrypted: i=1; AJvYcCUwH/hdw/ihf3vWKb/VT6EXzFG7wZWuIiJslKtOhvcP6TkmEPkeRiG3a5ABhCFCPu5TOj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHSMz6bXDfhYpQRWsW+Rmf11Qax+9xBmSa2ovpsaC0N8eKAefW
	Qf4E6gPzrS064dCOnny28YLCng49mAVNWNXlrs7gaLWQhoHGO6CWNsxBVqHCwc25xxHaYTJxSeM
	gO/2Kyw==
X-Google-Smtp-Source: AGHT+IGgPwGOMBLaCWE5KFajgM1k5GAAtbgHFzAkvoKLZILtRQoRL0lrXZ29F1zNrZz+oqAiBi5JJlM1Uas=
X-Received: from pja16.prod.google.com ([2002:a17:90b:5490:b0:30a:3021:c1af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d888:b0:30e:823f:ef3c
 with SMTP id 98e67ed59e1d1-30e823ff09dmr21512162a91.25.1747670580528; Mon, 19
 May 2025 09:03:00 -0700 (PDT)
Date: Mon, 19 May 2025 09:02:59 -0700
In-Reply-To: <aCg0Xc9fEB2Qn5Th@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516212833.2544737-1-seanjc@google.com> <20250516212833.2544737-8-seanjc@google.com>
 <aCg0Xc9fEB2Qn5Th@gmail.com>
Message-ID: <aCtWM63FyQKMJzqE@google.com>
Subject: Re: [PATCH v2 7/8] x86, lib: Add wbinvd and wbnoinvd helpers to
 target multiple CPUs
From: Sean Christopherson <seanjc@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Kai Huang <kai.huang@intel.com>, 
	Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, May 17, 2025, Ingo Molnar wrote:
> 
> * Sean Christopherson <seanjc@google.com> wrote:
> 
> > From: Zheyun Shen <szy0127@sjtu.edu.cn>
> > 
> > Extract KVM's open-coded calls to do writeback caches on multiple CPUs to
> > common library helpers for both WBINVD and WBNOINVD (KVM will use both).
> > Put the onus on the caller to check for a non-empty mask to simplify the
> > SMP=n implementation, e.g. so that it doesn't need to check that the one
> > and only CPU in the system is present in the mask.
> > 
> > Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Link: https://lore.kernel.org/r/20250128015345.7929-2-szy0127@sjtu.edu.cn
> > [sean: move to lib, add SMP=n helpers, clarify usage]
> > Acked-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/smp.h | 12 ++++++++++++
> >  arch/x86/kvm/x86.c         |  8 +-------
> >  arch/x86/lib/cache-smp.c   | 12 ++++++++++++
> >  3 files changed, 25 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> > index e08f1ae25401..fe98e021f7f8 100644
> > --- a/arch/x86/include/asm/smp.h
> > +++ b/arch/x86/include/asm/smp.h
> > @@ -113,7 +113,9 @@ void native_play_dead(void);
> >  void play_dead_common(void);
> >  void wbinvd_on_cpu(int cpu);
> >  void wbinvd_on_all_cpus(void);
> > +void wbinvd_on_many_cpus(struct cpumask *cpus);
> >  void wbnoinvd_on_all_cpus(void);
> > +void wbnoinvd_on_many_cpus(struct cpumask *cpus);
> 
> Let's go with the _on_cpumask() suffix:
> 
>     void wbinvd_on_cpu(int cpu);
>    +void wbinvd_on_cpumask(struct cpumask *cpus);
>     void wbinvd_on_all_cpus(void);
> 
> And the wb*invd_all_cpus() methods should probably be inlined wrappers 
> with -1 as the cpumask, or so - not two separate functions?

Using two separate functions allows _on_all_cpus() to defer the mask generation
to on_each_cpu(), i.e. avoids having to duplicate the passing of cpu_online_mask.
IMO, duplicating passing __wbinvd is preferable to duplicating the use of
cpu_online_mask.
 
> In fact it would be nice to have the DRM preparatory patch and all the 
> x86 patches at the beginning of the next version of the series, so 
> those 4 patches can be applied to the x86 tree. Can make it a separate 
> permanent branch based on v6.15-rc6/rc7.

Can do, assuming there's no lurking dependency I'm missing.

