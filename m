Return-Path: <kvm+bounces-61734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F76C27135
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 22:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CDCA3BDFBC
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 21:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CDF329382;
	Fri, 31 Oct 2025 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZC7AovEw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9913153BD9
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 21:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761947238; cv=none; b=BPzGroQh0y+0qhQ/aCI75TkpxoCJfvPstsCfC690PFjyflHT5EvUE4SbDzZig5Cdg2bQ9RpYUGR03k91HFXvxp6Z/2L6LCTfx7Vc1x9msENVxAbJYcqbP3z8WklpJwVwYmqkabr6kwNL2LvW/kaCSG9wFiesNsyhfHYDt933Sok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761947238; c=relaxed/simple;
	bh=Hhz6ySoXM+lPDNct4NNaPC+oi8yVnGrWseVlq52Eujw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UFfdoZIONcG/Hv2fnVLdYe3zHqfKdJetoBvL70E/gzO5kfgzizhPIHt9MzDUcMhGzS388QYg1bnaFvVGY+Wj6PjBBKXyLxkZygkqp/ojK7c57ePPI1e2j1g2D0hWVxeLq7HHa4F9++8cbY4giNQy0SIGkhypLqcRCrUTpVStSYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZC7AovEw; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b9612ae5ce3so307526a12.2
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 14:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761947236; x=1762552036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOBuQ6TysDM/FZfgp6GKviiBazoSCF47O+yS25Nwy5c=;
        b=ZC7AovEwfystl9e+CkOQyNsMmyLXuYE+BvAyokm0+ojgcOITRN4/YN0baS/QrSlBQ2
         Ov89y2Ht4Q3/AGI64kg0zGhy6CKZ3QEulSxhcKhIyCRIsV4pqa8qQGG84vdguGoSKQ7z
         gXcfZuR2zyaiguQFvIsVIxfseFAaBQN0LSzO0zew8RsNcwYdifc3lN1+xWWwsvO/Vxyu
         AfhGzllf61FiuRyVzMr+AdGmBr6S5QJuWx2zd8aEjvJitxhUIGlALkoFe9tOqLe7WVdr
         KJfa1qE2e7vrHQ+/xnbpLiEYDj8oGJ7o7ONEq70a98ZyIlj7+Pbput2FEgCfRfqs+gLs
         jhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761947236; x=1762552036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOBuQ6TysDM/FZfgp6GKviiBazoSCF47O+yS25Nwy5c=;
        b=gPIDgCkAqRKkkC5zddG5Yv2rIR2IdsdMzvUkUg24b502+c87Zw9LUKW99NwLdqoAsE
         I1IzMcIhwBjw38b3VNn+ra78ufHJIhIBHt0vARorIBNZX3xdjttXdsFY6Eg6zJhsnZKw
         8wetWeOofIcXyVuFGRS96VI9cBuOVd+Nh7DmoMmAwXjYDKRMP4vCXQWQ+iKtiPhhI7sj
         hWRlwKqKxgGK1mwTYwhbETKKTzHI0uESB410Qqr0RMolcsad8MmJ5BAFoi1DUMwJdLgA
         x+h+/yOChDc3JHcXFg4D71WjQNMZOxmp3tLPSsvS0uOMhAqYXG3gpVBIhk8pOQsDS59t
         Mz7A==
X-Forwarded-Encrypted: i=1; AJvYcCUVsVj2BjtZGBSJNK3IasTJEun4SwxOtGy6xGff3qmky9iLN3vAXubENfzF/ZwyBKgT0Ug=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrR2qUsTP2oN3lmgjrV1xZrvPEwTbjoh7A0ZHfzeJOrJRAOrwB
	7a+9mViHTfHks5LkH3vEIDNLnl+nhlDonqo4YWrpbY6USEP9pRDhzkFrhDuDRmwN7mV9M8trvoa
	sdtXUMA==
X-Google-Smtp-Source: AGHT+IGDeCqUb3RNIyHUyAiEcvl8QtAACK45tpx/VkjuJjAV4SKTXhXG8JST/BdKvu1paDG/E+hSOguUWmw=
X-Received: from plbj13.prod.google.com ([2002:a17:903:464d:b0:294:f56f:ed7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e552:b0:295:b94:70dd
 with SMTP id d9443c01a7336-2951a4f011dmr71114255ad.44.1761947236119; Fri, 31
 Oct 2025 14:47:16 -0700 (PDT)
Date: Fri, 31 Oct 2025 14:47:14 -0700
In-Reply-To: <DDWHCMBU8GVB.1CXGUGVWSF8RD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-4-seanjc@google.com>
 <DDWHCMBU8GVB.1CXGUGVWSF8RD@google.com>
Message-ID: <aQUuYqowQtbRCYyC@google.com>
Subject: Re: [PATCH v4 3/8] x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO
 Stale Data mitigation
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Brendan Jackman wrote:
> On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 723666a1357e..9acf6343b0ac 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -192,14 +192,6 @@ EXPORT_SYMBOL_GPL(cpu_buf_idle_clear);
> >   */
> >  DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
> >  
> > -/*
> > - * Controls CPU Fill buffer clear before VMenter. This is a subset of
> > - * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
> > - * mitigation is required.
> > - */
> 
> This comment wasn't super clear IMO but now that we're losing it, maybe
> we can replace it with a WARN_ON() at the end of
> cpu_apply_mitigations() or something (maybe it belongs in VMX code)? To
> make it more obvious that X86_FEATURE_CLEAR_CPU_BUF_VM and
> X86_FEATURE_CLEAR_CPU_BUF_MMIO are mutually exclusive.

No objection from me if we want strong guarantees that CLEAR_CPU_BUF_VM and
CLEAR_CPU_BUF_MMIO are mutually exclusive.  Though I do think the KVM side of
things (and the kernel in general) should be paranoid and not lean _too_ hard
on such assumptions.

