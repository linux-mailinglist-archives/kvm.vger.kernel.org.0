Return-Path: <kvm+bounces-50554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B49FAE702D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 887517A8E11
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554C62E8E0B;
	Tue, 24 Jun 2025 19:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iXvrgX7L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A0823BD00
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794503; cv=none; b=NU0OAP8C6yk0ZTpFvt6WYKgWuH/bZTZ8wc+nSyxwJCMWwrbV4A9/PqPIMlTyVIFVTHGouJtRn4+irDczoxTi6E8TRwOQ73fL/6yc39vpn+wzpCK2bZ8K9amOfhdiXzHfcQv0JFwneMgAuW7btOqEQYD6uTEwYXEkQrXY5s9wtmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794503; c=relaxed/simple;
	bh=6GotpNDPl6kXY95Qph8BUp0563LHJJPy0THk60BPwCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RUzdVF4QIGyQxifnaWHaNYQflYfRtmNAHss9rLbRmmlYkULSqEnqRFn+T38kG+YNWA33xC9unmknTaJfJF3s86euYz6j7z/n38g8mGslbWTgil/JGQEZo8wSUdcLSEUHT1gMwV1k1Cu3glkttS559vCtKJ5xo5BSRZvQghTQUaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iXvrgX7L; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1ffc678adfso570173a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794499; x=1751399299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FqfSnFWDbYX+XfGG95qXGIQa/IUf7HyXIBVSL1oPA5M=;
        b=iXvrgX7LxlZuCfOu6RsvjymC6y4ezqYcyHZ81rwVKLStC2Ro8uPEVwWWkIX7c+gWTO
         eqRhZNf8Knn8byVswwz5LGlRnIC3AjJr57bV2cU++oKAnjd45aHzGa1cxFQga6a1buoP
         twrArYcw/uh6Gq/ftakiPhMGWM1xj6HoeF01/V5ayaJ+wB7Fw9LNR0+sg7OKouYtOnId
         +8OI/jxHuZYDxbo9UbdWTmnP6tsvu+D9KRA6w7lIoCrhNWERPhyU3BdvcezCpKcIn68e
         EHLALC9xux6llqkftURcyKGJIkXsZLJxEN3s1x6ih42ZjCRdCYEPuWSRPPlQqxgekj7i
         ZVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794499; x=1751399299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FqfSnFWDbYX+XfGG95qXGIQa/IUf7HyXIBVSL1oPA5M=;
        b=UZia32RVuhH7LPPuBooJzdbkO0xlV9FWgtpaV1NKKK/6VXbJBL80sWnaWULtGRVyFD
         +oKmdAUMZ4HaLl41cUVfm3TNSENhtRwdj7XqSNOrQwoWNzYUOP5MG46gqQJv+F15SUmv
         p3G/crahbq4I8sJXjj6w0qUYX+VNSH2rg4uO1WM1k/F2/QItqF1XEGHgUXYxWHMR3e7G
         JpPS1S6aRit/hyAx1L7UQdDWApHQ2gQErS/1mGVk7gJRNKw51iXNzQlpoEkv8yWsJ8+o
         XqGixpTllIVYwYToFGenPgQDUdWTXDRdNqymL4CjqRTLmOeAtIghfLscVLozh2+n/w0G
         PZtA==
X-Forwarded-Encrypted: i=1; AJvYcCVwXxeKzMT/9/QmaLaxFDu19n8H3otLsoqejEngJMoXczh1LEwYV4HZsGNH1DwVf9vGtE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP5oyyNcGyoQTBOWD4ZITMmQjlVb9b4sbeaBjLqgCreuuiAF0C
	Diq9MCZitcUk/U5vGX83KqE7Xg/Q7solCivubY77MWQ2z4wkNHTBdeocCh7lhFnLZTZTV4GtLce
	L2pBN7w==
X-Google-Smtp-Source: AGHT+IGpxI8leluMl7D0SzRSyFZPnLIXhC1vo2SBZLbYA6FIywV5P5SjIY/uT1NfQ4kDXoXw/tVSxEHwr2k=
X-Received: from plle12.prod.google.com ([2002:a17:903:166c:b0:234:ddd7:5c24])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec91:b0:235:779:ede0
 with SMTP id d9443c01a7336-2382405cae0mr10401765ad.35.1750794499470; Tue, 24
 Jun 2025 12:48:19 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:48:17 -0700
In-Reply-To: <aDcHfuAbPMrhI9As@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523001138.3182794-1-seanjc@google.com> <20250523001138.3182794-3-seanjc@google.com>
 <7cc5cd92-1854-4e0e-93b7-e4eee5991334@intel.com> <aDcHfuAbPMrhI9As@google.com>
Message-ID: <aFsBAXAbRQTPY45m@google.com>
Subject: Re: [PATCH v4 2/4] KVM: x86/mmu: Dynamically allocate shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 28, 2025, Sean Christopherson wrote:
> On Wed, May 28, 2025, Xiaoyao Li wrote:
> > On 5/23/2025 8:11 AM, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index cbc84c6abc2e..41da2cb1e3f1 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3882,6 +3882,18 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> > >   	return r;
> > >   }
> > > +static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
> > > +{
> > > +	typeof(kvm->arch.mmu_page_hash) h;
> > 
> > Out of curiousity, it is uncommon in KVM to use typeof() given that we know
> > what the type actually is. Is there some specific reason?
> 
> I'm pretty sure it's a leftover from various experiments.  IIRC, I was trying to
> do something odd and was having a hard time getting the type right :-)
> 
> I'll drop the typeof() in favor of "struct hlist_head *", using typeof here isn't
> justified and IMO makes the code a bit harder to read.

Gah, I forgot to switch to address this when applying.  I'll fixup the commit
and force push; it'll only affect this series (hooray for topic branches).

