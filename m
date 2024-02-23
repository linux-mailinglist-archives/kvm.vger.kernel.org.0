Return-Path: <kvm+bounces-9554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F05358618AA
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB0F328648D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579A412CD95;
	Fri, 23 Feb 2024 17:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XYzNY+5N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F99128815
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708707708; cv=none; b=U/A1opAswCeeGytahUZX9pWAuWvE0pFQtTIxwa6eAvr0+g5CO6KxBXuio8e0Zp7KLHANGafR3fZdL1P1RJLavC0iOFcL505c6qT34qzX/yK+blcL4KhDXDum/hLnKTJbpvFQEk8adkaQ10q1Ql+FFn9QE/NF+RWsYbeqiHWvNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708707708; c=relaxed/simple;
	bh=x9++INN2m+gpmUh/KCO+PSvjrYfe9RJFSkVt3950PsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z8aDoQ9zOEg8jp4uf9DBGXMxj3/J+MCPyQwqjRUyBC7u7oDpX+Ywqtr16EveOZinFpS8UuCZh0/NUpmxjcyioQmDELRB3D50sNoq2wQTe2zABv3cFtVL9zbx7v+0zG3iiyf0ulYLygbMBhXtnl1DXziTSrHzzfToF/bNWcVhSh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XYzNY+5N; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cfda2f4716so741333a12.3
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 09:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708707706; x=1709312506; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pfc17/TKkSDYgpRi5ALTWEPHfW2uf7bskubXgF1ZJyM=;
        b=XYzNY+5N9nDJwUBFHJ59wyzsY5acfJX/77wylFZqBcvmkBkeuLWfpsTkVO627VN/k7
         8qhGqEK5DnMb21wTWOxk42QNwALjarm7cAIGJVz/NoAV2yrbybNK9M1PGKclu/RlkiBA
         MiOD2u+LG1vIzDmYLEgfq3f+SlWY6lm5fsSxg4ZtG72oTUo9yMkoVnWsl9R2znh8+vlZ
         kJf0ROc3egeebelhdlu/EgLbFNrN8E0vH8sn7q1Kbnhd1Ix9jhncccIcdtm5SL/4Iy+L
         0Dt4wrIFe0Q0Ibs2EJ6FkZlsqnHO6oeSM2i0lHnj3k9GXIrZWXdt8TXGVxoClmuXqGUm
         ix3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708707706; x=1709312506;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pfc17/TKkSDYgpRi5ALTWEPHfW2uf7bskubXgF1ZJyM=;
        b=iMLOLl1pGUF+RI0VHJSqjlnEMBxphxvbtQXD/u4I8/aqOPZE3KvfqZdjTAkZ7D0OOn
         YcF16DXGFzGwz0OKPNYB7RxSebw+QBFLnmDICTc3RZuskVgsXsc1b8mwGLdqIa2+WxRM
         ubTwRi49jiYIO5U1rsi/wwG1EBg1evAXhvt/6Nmhq1Y9TonP7VAaS8A+RcocXJtGJG1+
         EGoqP/YF7qo42EokmSHQq1iK4yr0Zb6pP0xIwNjjWo2hY+G8lva5dp75mtgjfY7RRbsM
         kg65PkRYkts9+ewOj5IRoFS8CdznEeFCb475jgKbL2x4uzBc6c0HlCcq8RBeBz/HgDSV
         FhVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVma6SfNzwvRzBlDKxzb5qyC1zifQ7y8c4eL1Rbm4F5U/KipyDUgmlzWnvrki9qaFxCbviVRTJkBHu9HsarAPD3y3zs
X-Gm-Message-State: AOJu0YzmiiEODV1AWJEVuyCPDIVKF5i/1w8KKnr9MwDuUMMILJtrTPcP
	pKb7ccZIy3N1QcjDggKOKjBNQXzQo+R0QqI8hrYlZPOuoK6B/Xev02vi7DTEFlRHb33t5yLHHvC
	YTA==
X-Google-Smtp-Source: AGHT+IHN4bcZqxgjuf+nU1Zula5l2c65fnndy7t0fwNKOatXmncYBrpJyaX50gAvLeG5jHGHzeWmn+kw+xU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:995:b0:5ca:43c7:a67 with SMTP id
 cl21-20020a056a02099500b005ca43c70a67mr997pgb.9.1708707706441; Fri, 23 Feb
 2024 09:01:46 -0800 (PST)
Date: Fri, 23 Feb 2024 09:01:44 -0800
In-Reply-To: <43b9125f-35d4-4368-8783-a41799b11c21@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-5-pbonzini@redhat.com>
 <ZdjCpX4LMCCyYev9@google.com> <43b9125f-35d4-4368-8783-a41799b11c21@redhat.com>
Message-ID: <ZdjPeKDITWoVre6o@google.com>
Subject: Re: [PATCH v2 04/11] KVM: SEV: publish supported VMSA features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> On 2/23/24 17:07, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index f760106c31f8..53e958805ab9 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -59,10 +59,12 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
> > >   /* enable/disable SEV-ES DebugSwap support */
> > >   static bool sev_es_debug_swap_enabled = true;
> > >   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
> > > +static u64 sev_supported_vmsa_features;
> > >   #else
> > >   #define sev_enabled false
> > >   #define sev_es_enabled false
> > >   #define sev_es_debug_swap_enabled false
> > > +#define sev_supported_vmsa_features 0
> > 
> > Ok, I've reached my breaking point.  Compiling sev.c for CONFIG_KVM_AMD_SEV=n is
> > getting untenable.  Splattering #ifdefs _inside_ SEV specific functions is weird
> > and confusing.
> 
> Ok, I think in some cases I prefer stubs but I'll weave your 4 patches in
> v3.

No problem, I don't have a strong preference.  I initially added stubs instead of
the IS_ENABLED().  The main reason I switched is when I realized that sev_set_cpu_caps()
*cleared* capabilities, and so decided it would be safer to have a separate patch
that effectively stubbed out the global SEV calls.

