Return-Path: <kvm+bounces-26549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEAD975748
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B78BD1F228F5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B561ABEC8;
	Wed, 11 Sep 2024 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkqiYNgm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D81AB52A
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726069076; cv=none; b=G6i2VUZtTNFknRaOB/nFGVJP0Gl07yoQYmaMziv0e4tJHSYtKDpZccVKwlsfoWA5vfoR5kQP58ReIDy5snTNuS4jPDuVI9zjNimYwqED5DfUYXRaWiwoxx7SL2g0Wbo2NXjKbKWOpQR3+nqnMTKVvADBsb5tcl8D5VMbzAGBC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726069076; c=relaxed/simple;
	bh=/9mGBPcz6bEEuta300HLDU/i5hbGKt+GMHZF6+0ToCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V0e5PPMJqvGIfbybCWrwjTUVJzsh3w0rIutN5bbKdiosTQzAiCPcYsx+2wIagtpUJDHc5I3Ux1lQ4OgEc/Xl1IX4F0F8IpXOpkccFdTJBGUl70BnYBqtE/7yNg0le73OGLcVSC/btgSRJqdiGvpgMwUcW10HJ/u0mZ6gKVX99XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkqiYNgm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-778702b9f8fso848662a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726069074; x=1726673874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KOyOIRL3lgO9opRsCrN+ghOFkRsLNHeHkE/P6t+PUfs=;
        b=fkqiYNgmwZVx1oEG6cEKzjiVE+hLjKOhnABOiozMGZwk64t7n2mEgiTGCbK7iGKgY6
         Nc/yrCDgqmQYai1KWKiXcYetDzBxYNVGPhHhDTa4dMwCvOk/1z/peMvEMRW3PjcL6PoL
         LJA9eparptv2eUMshwOtqEfmAesZ8amBCfCUqk/vaQCk+lH3puHZuRJhjT452ZuF6Ndw
         O1Yl5aaHS19fH5v8VTtwWj8LMS2Zd1ipciusn7N6vB36bMv68/vfKZAkYjTnSmKIKszI
         IA55lDAHLttQLPK7FylF5p8nCfaBtlyIZF8TDVM7yP9qmQjftL1itsz4Z33x93CBg7ZF
         9lXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726069074; x=1726673874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOyOIRL3lgO9opRsCrN+ghOFkRsLNHeHkE/P6t+PUfs=;
        b=SZyjiMSpGevEkf9cRL2t60x19g4yKpTA71OKRjv2XNWzOwpsR1VgEcNaIk2qAXaVTv
         XsLPYDc7kzUqEW6XIc4rl07X7AsqxzBLKulLEf5SqQZLIBsQKHgny2b2HtBzmTufLGGC
         OMxE+2wWVTKJImAbYPl0G2g8xluN/RmSNtWI2H5KEzG62pMzdDEcopfLUaIZEfMhI6Y3
         U/DV8exmx1rpeLVomdhQeOTTOxATvdwhcLmLuJgSk9CfTcmVFhk4OTTvuPh+K1k7Bj2x
         j1mYi8IpAGovvwSTqsv3+MPgcWtcI7SmeMDrNn1MWwZNsxjT4tspfQZJgLyrMwjc8WdJ
         kg5A==
X-Forwarded-Encrypted: i=1; AJvYcCXLFpuE/vhAqhfbUvSalODWTElLIBAt20ftCvcgNH3DMg+7eITeCZvOHdADewolK62QRzY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGAZ3Or9HhT8YNDggnOYFnMC3LXWx1uyul/adpyBfHNDfOKNTL
	GSkREFrjgfiUVGHf2vpbLv/wnKyHJbd+LIkMMhsZvTbXav30Jopqw/qojim3cokZaSWbv+kTceX
	O1Q==
X-Google-Smtp-Source: AGHT+IEhfSIYMnsJNwhqfisaN5qoyB38Lao3g7nOTEDCmftPeFTt71jA12MSRIMm6JGo9mZ+1idIw20uA3s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:f85:b0:7a1:6a6b:4a5b with SMTP id
 41be03b00d2f7-7db0850b96bmr18853a12.2.1726069073748; Wed, 11 Sep 2024
 08:37:53 -0700 (PDT)
Date: Wed, 11 Sep 2024 08:37:52 -0700
In-Reply-To: <44e7f9cba483bda99f8ddc0a2ad41d69687e1dbe.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-23-seanjc@google.com>
 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
 <ZoxVa55MIbAz-WnM@google.com> <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
 <ZqKb_JJlUED5JUHP@google.com> <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
 <ZrFLlxvUs86nqDqG@google.com> <44e7f9cba483bda99f8ddc0a2ad41d69687e1dbe.camel@redhat.com>
Message-ID: <ZuG5ULBjfQ3hv_Jb@google.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 10, 2024, Maxim Levitsky wrote:
> On Mon, 2024-08-05 at 15:00 -0700, Sean Christopherson wrote:
> > If we go with ALIASED_F() (or ALIASED_8000_0001_F()), then that macro is all that
> > is needed, and it's bulletproof.  E.g. there is no KVM_X86_FEATURE_FPU_ALIAS that
> > can be queried, and thus no need to be ensure it's defined in cpuid.c and #undef'd
> > after its use.
> > 
> > Hmm, I supposed we could harden the aliased feature usage in the same way as the
> > ALIASED_F(), e.g.
> > 
> >   #define __X86_FEATURE_8000_0001_ALIAS(feature)				\
> >   ({										\
> > 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> > 	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
> > 	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32);			\
> >   })
> > 
> > If something tries to use an X86_FEATURE_*_ALIAS outside if kvm_cpu_cap_init(),
> > it would need to define and set kvm_cpu_cap_init_in_progress, i.e. would really
> > have to try to mess up.
> > 
> > Effectively the only differences are that KVM would have ~10 or so more lines of
> > code to define the X86_FEATURE_*_ALIAS macros, and that the usage would look like:
> > 
> > 	VIRTUALIZED_F(FPU_ALIAS)
> > 
> > versus
> > 
> > 	ALIASED_F(FPU)
> 
> 
> This is exactly my point. I want to avoid profiliation of the _F macros, because
> later, we will need to figure out what each of them (e.g ALIASED_F) does.
> 
> A whole leaf alias, is once in x86 arch life misfeature, and it is very likely that
> Intel/AMD won't add more such aliases.
> 
> Why VIRTUALIZED_F though, it wasn't in the patch series? Normal F() should be enough
> IMHO.

I'm a-ok with F(), I simply thought there was a desire for more verbosity across
the board.

> > At that point, I'm ok with defining each alias, though I honestly still don't
> > understand the motivation for defining single-use macros.
> > 
> 
> The idea is that nobody will need to look at these macros
> (e.g__X86_FEATURE_8000_0001_ALIAS() and its usages), because it's clear what
> they do, they just define few extra CPUID features that nobody really cares
> about.
> 
> ALIASED_F() on the other hand is yet another _F macro() and we will need,
> once again and again to figure out why it is there, what it does, etc.

That seems easily solved by naming the macro ALIASED_8000_0001_F().  I don't see
how that's any less clear than __X86_FEATURE_8000_0001_ALIAS(), and as above,
there are several advantages to defining the alias in the context of the leaf
builder.

