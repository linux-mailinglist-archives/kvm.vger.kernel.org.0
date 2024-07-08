Return-Path: <kvm+bounces-21132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2043992AB0B
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 514F61C21826
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66EE914EC51;
	Mon,  8 Jul 2024 21:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pB0h5bSd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D29D4503B
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 21:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473533; cv=none; b=dxInTAdIOeyDQYlmMndXaP1a5jq5P3ZXXUok/Bgc2HF+3en2OsA7VVRWQPLTtUDlBNVqL4yxXWm6kC1ES7jmIsXwJL+UA+Bd51XhhcF6HiKaJtw0kLxljdFFmcYg34ZZYkgJUDZU8aX0zNJ8nT1XZ6DcTst3LYzhDGqKLw7dBaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473533; c=relaxed/simple;
	bh=4tpbHtGgkrRcpM7dGHbd69PC5ucXnx833z8uv+u3LPc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZAlUplvVv7YEFVatX2Vb665cmr6GTkT2CYd46U5Lk18Zz6k/gajdzTlMFdjHfjfTQLnxf4r8NkVgvjT9olNy1RfHOmTasZwvPJV7d12ETIKDdN5OzIW54iYqUF4kJ0bt6e8YyCq0ilYLp8vFHbXbDicX8ivJbyaficheQ5j4s6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pB0h5bSd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c9015b0910so4213855a91.1
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 14:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720473531; x=1721078331; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tj1ms3U8LTm4UyZ4fve/C+MAzvup9uK9AJzLieincvc=;
        b=pB0h5bSdO/5rrnI90Jl1oytkGKots4VSA3dFWsODbfmkNedZ2PZL+wG5EAJdxpuYim
         tJzuttGDaSjLKTTeHoetoHT/yVZQmmCs2YQ60xsWXWLTMwKFA2RxdImErAHMociHVj4l
         vDfMdaop0CdV4xKUAA86qpS/dnmQWmoj9dHM8BhcC0DLqMt6d/qGlbRlalnxWZc17rh0
         jPHe6JnlFwtptlHkV9vXqwLRk72hQ3L76kFtTnDZ+1AGXFheI38d7QC3jGxDYEtV6MMH
         sWNpxbGdpqHwARW+POUx4ZfdVtR0ZnIWP6QilLOt0MsSFQwD6Oz14O9UT/QfmXaJXzzI
         mAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720473531; x=1721078331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tj1ms3U8LTm4UyZ4fve/C+MAzvup9uK9AJzLieincvc=;
        b=vBQEp2pRHZ8xzryPXxZt8iGwkCG06/JrQUyDFgE1wxwBGXK/c2U+XpJ38p9Xtlhnim
         5vuvA+MEGIDnq0Gaj4zGZh9FdbUJdOc4tNpHx+eHtGxlo+jmvx+Tl51M4pK6kH40BYHg
         +g12Mqcek1+kEHHwkYY/3XUn2MCVqEMaTrPycFnvvt8rXslswDSb7aWSKIZEQ4PQbioI
         2RCDOMX3pa8qdOU2UGRaQRS7NJOiSXveQhtwPdQQikM4xlelzZuSk3CQH50plBZSwwVI
         O8JhePVRHJg0HgtQYXbDm1P2xbVANnTSD19Am4YW4jLiEYfeYq3bqflocEmeljsRLJyL
         Eheg==
X-Forwarded-Encrypted: i=1; AJvYcCVmVHSVw8N44AT2SRbLWjA3oiBE9i/11XyXcVBCZmcmJL6yKnNB5L90EHsy2fpV2TeeeekPyhwMdqPVEwI5l6tQXv1E
X-Gm-Message-State: AOJu0Yws58q79IotTVI4FPWeHahArVkKXxcypq6EisDETKFjdgsJTCzF
	w6oUqID1xlfEWpUONnhqvBW0L30GjgZ9KtR+O4icR3OCk6H0TpHDzo+f6i5ob102yRqIS/y5c/D
	tsA==
X-Google-Smtp-Source: AGHT+IGg5p5OadF9zVGv2d0hOmKOT17RVRkOTmycs6tdmWNfiB6T/IuUOm5CedZTAAwwzx7oc6rsO31VX+Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a0a:b0:2c8:632:7efe with SMTP id
 98e67ed59e1d1-2ca3a833655mr8182a91.4.1720473531440; Mon, 08 Jul 2024 14:18:51
 -0700 (PDT)
Date: Mon, 8 Jul 2024 14:18:50 -0700
In-Reply-To: <7bf9838f2df676398f7b22f793b3478addde6ff0.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-24-seanjc@google.com>
 <7bf9838f2df676398f7b22f793b3478addde6ff0.camel@redhat.com>
Message-ID: <ZoxXur7da11tP3aO@google.com>
Subject: Re: [PATCH v2 23/49] KVM: x86: Handle kernel- and KVM-defined CPUID
 words in a single helper
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > Merge kvm_cpu_cap_init() and kvm_cpu_cap_init_kvm_defined() into a single
> > helper.  The only advantage of separating the two was to make it somewhat
> > obvious that KVM directly initializes the KVM-defined words, whereas using
> > a common helper will allow for hardening both kernel- and KVM-defined
> > CPUID words without needing copy+paste.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 44 +++++++++++++++-----------------------------
> >  1 file changed, 15 insertions(+), 29 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index f2bd2f5c4ea3..8efffd48cdf1 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -622,37 +622,23 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
> >  	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
> >  }
> >  
> > -/* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
> > -static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
> > +static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
> >  {
> >  	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
> >  
> > -	reverse_cpuid_check(leaf);
> > +	/*
> > +	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
> > +	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
> > +	 * and only authority.
> > +	 */
> > +	if (leaf < NCAPINTS)
> > +		kvm_cpu_caps[leaf] &= mask;
> > +	else
> > +		kvm_cpu_caps[leaf] = mask;
> 
> Hi,
> 
> I have an idea, how about we just initialize the kvm only leafs to 0xFFFFFFFF
> and then treat them exactly in the same way as kernel regular leafs?
> 
> Then the user won't have to figure out (assuming that the user doesn't read
> the comment, who does?) why we use mask as init value.
> 
> But if you prefer to leave it this way, I won't object either.

Huh, hadn't thought of that.  It's a small code change, but I'm leaning towards
keeping the current code as we'd still need a comment to explain why KVM sets
all bits by default.  And in the unlikely case that we royally screw up and fail
to call kvm_cpu_cap_init() on a word, starting with 0xff would result in all
features in the uninitialized word being treated as supported.

For posterity...

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 18ded0e682f2..6fcfb0fa4bd6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -762,11 +762,7 @@ do {                                                                       \
        u32 kvm_cpu_cap_emulated = 0;                                   \
        u32 kvm_cpu_cap_synthesized = 0;                                \
                                                                        \
-       if (leaf < NCAPINTS)                                            \
-               kvm_cpu_caps[leaf] &= (mask);                           \
-       else                                                            \
-               kvm_cpu_caps[leaf] = (mask);                            \
-                                                                       \
+       kvm_cpu_caps[leaf] &= (mask);                                   \
        kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |                   \
                               kvm_cpu_cap_synthesized);                \
        kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;                     \
@@ -780,7 +776,7 @@ do {                                                                        \
 
 void kvm_set_cpu_caps(void)
 {
-       memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
+       memset(kvm_cpu_caps, 0xff, sizeof(kvm_cpu_caps));
 
        BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
                     sizeof(boot_cpu_data.x86_capability));

