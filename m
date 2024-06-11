Return-Path: <kvm+bounces-19342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF79904172
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5957F286247
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8A83BB48;
	Tue, 11 Jun 2024 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPav3AZk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3621138FA0
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718123737; cv=none; b=dXoOgF9VqEMTRzXZUWyI9DQ527awjOARPevihVXqzWCTsnYLZj76nrSIHvxtvOSv+ZYncJTPBYSqRwr34Qv4zb+yym+ORhaXC+Ql/OtwIUBESmTTx7AcgutJnee3GvYoROkHfiKt6KIuEK1OrS1IlQgEkGarWoimmTFOoIK5gVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718123737; c=relaxed/simple;
	bh=3HM6i6zrhqS92eFX0rcBTaE34IL7ONn3eX6LnpwKS8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gyowaCk98/laS+QKZt3XC3XjBFnwRJTL/vFD1O07Q5ISP1oBuwiE/Fs53b9GQxO2GpicxvkpZi685WY+vC6O+5kZi8/6x8ArV3Fg9jR8FgfKt4kNzAxnVNsSAlP+rLZOFCCl80Zx6594u6fdsKBMLoX9vez+3wpPNlFm3+aBa6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPav3AZk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f656692564so10886425ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718123735; x=1718728535; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sy8cYUcbFFJWNmfBV4hjqU10SqwSRoXFxmzf2bgnVG8=;
        b=HPav3AZkAkfqsescJX/g6FEn6DO6q/l8p4OOm9U0LrmGve7dAxbbtol2Do+VZPg3KY
         FzI/kuY52lbpUQ8U/xIPwrexWNibNIHtLC0hBL2qtKJyxGaxWNeW8z0gkMNuGhCw/n3w
         CEfh29CCxif7FFj2eXwhj4HUWr4m2x4EwOG7XrmMwlMAwV7bkwKeaw/VAqbGZLDI69+u
         ijnGslh70VDUptr5AKMHVLfcwKsgYJz5QRXzZvjCVccB/sgcHlqS49Sfvz/sKCHhjSd1
         HpsoqytjcVtOtr02zXAqsWwQOxyq41wD1ox1Z3zBEXyQzCn0LoPgjfhzj4k7YdlZaoDg
         8RWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718123735; x=1718728535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sy8cYUcbFFJWNmfBV4hjqU10SqwSRoXFxmzf2bgnVG8=;
        b=tYeN904A0cHX9o7i05S4BHpZcGTs8PT8OhFzq5eLDIw/q5Z5v6XbruI4Ybr1qUbMAb
         I5lc6+qAXrkCM03aMsm0gCy6GASh2yy85Ot9VZJqJdqP3QPEPJtRb5XeI5nhj5QkxO4R
         Vsxc+ZGODL+IoqgZFFgGzQRqHowRIalSjBtQTYr9Vz0CkMy/ab+FGMavtB2R97PM862D
         YPgiNZNXFYuWDn21uJCbB2Ma2ECLjQmd+QaMpjFYZTGzLnU1GwdeJdTRaP+//86XB26d
         z9l7Ns6nkeL6MOAcg1jy6j6+1T+LscLuP9bZDtZV5Swxkn9aeh4NNUev12QhjL7yt56N
         up4g==
X-Forwarded-Encrypted: i=1; AJvYcCV39VYqulyhLt/NckPAyCCLOUxgz00Ngv9tIxWP1XgLl7Sqsv96wjVyuaj494HJWwDGdaT9kIo7swaVkcTbvzSbvYYW
X-Gm-Message-State: AOJu0Yzsd82yTTLWURXgPzwr53os7dQ4AfUuEI3aPT68zcj/qZgNHvTu
	ighuiXx3t++izyYHY1LAG5ZrzJ/KIxLYPlXlVNsV+E9i5FEINy1R+JeVRqzpSTz7s6TXEg4ifAi
	boQ==
X-Google-Smtp-Source: AGHT+IFqXchqKKKSOXvmsXF4dzM7UtKtVZ8RsUC4UyrsKBXtHV0YGZj0BXlb8PWK7cGM8Xh3b9rpS7Epjko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea03:b0:1f3:f8c:55d5 with SMTP id
 d9443c01a7336-1f6d02be357mr2172085ad.2.1718123735342; Tue, 11 Jun 2024
 09:35:35 -0700 (PDT)
Date: Tue, 11 Jun 2024 09:35:32 -0700
In-Reply-To: <ZmhtYqtAou031wjV@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240509181133.837001-1-dmatlack@google.com> <Zl4H0xVkkq5p507k@google.com>
 <ZmhtYqtAou031wjV@google.com>
Message-ID: <Zmh81J7eflG-aj4X@google.com>
Subject: Re: [PATCH v3] KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU
 SPs for eager splitting
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 11, 2024, David Matlack wrote:
> On 2024-06-03 11:13 AM, Sean Christopherson wrote:
> > On Thu, May 09, 2024, David Matlack wrote:
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index aaa2369a9479..2089d696e3c6 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -1385,11 +1385,11 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
> > >  	return spte_set;
> > >  }
> > >  
> > > -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> > > +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(void)
> > >  {
> > > +	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
> > >  	struct kvm_mmu_page *sp;
> > >  
> > > -	gfp |= __GFP_ZERO;
> > >  
> > >  	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
> > 
> > This can more simply and cleary be:
> > 
> > 	sp = kmem_cache_zalloc(mmu_page_header_cache, GFP_KERNEL_ACCOUNT);
> 
> Will do. And I assume you'd prefer get_zeroed_page(GFP_KERNEL_ACCOUNT)
> as well below?

Ah, yeah, good catch!

