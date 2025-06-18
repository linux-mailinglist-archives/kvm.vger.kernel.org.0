Return-Path: <kvm+bounces-49906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 539BEADF845
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCAB41BC31B3
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 21:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A7D21D3F1;
	Wed, 18 Jun 2025 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SqiZ+pv5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061F20CCD0
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750280381; cv=none; b=c6zFoQouted/77o5xvco+CrP2qdCiAQOet/nTcUiVJIxsqWg1ftyWDcIuuaqPGu/OlcdjgZxw0IFOOSHKuLSoSUgW06sB3cdYim/nIc1WdtEj0BmaBBlC1CAgGg2CIkGH8ZHjlzYTzbEuDyffdmRnh5bBl8HiShilu5XiQlYeQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750280381; c=relaxed/simple;
	bh=TGl3VBkKi7oE2h+1aWKRYyzd0xAZ30Hgfd6PLNHMvvM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X4KwCeprguhbqm6JziF/em2TeTqk7yN5mQ9NmAYb4fm70645a9p6qhw/j37u4FtgCOZAZSepk6BIDX2KInDBQrI8AuElzoLTN6KELrToygKSECP4C6vhA5YniA2O4RCq/gk+khwIjbtisnfhW13HPNKhPbtThLrbiMiZxVaAOpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SqiZ+pv5; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747af0bf0ebso42252b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 13:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750280380; x=1750885180; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aF8FChrkDuPz1pKDYbAfDf2mWO3Vl3/6TjWiBlEasWs=;
        b=SqiZ+pv562nzGlJL5tbxdFLpL1ej9fsTPi79ALeWymANiMixIDY8yZcMcbpwn83siY
         QimvQOMnr2CyaGDgGNed3+CsN4/YtT+Fp3TWbQBecsZ3cE1uIcinGtfwllPr1LtUCmJi
         5oXOmR2B72oFDXLqxgHz2NxcixZwW0i51d1MnsjsMgRhQ9jMx//32Qyv2XoT48u8PFrf
         Rc6dJj7AiIPTRTYEcLFsYG4o3mYHs7s4aeeVdzCTH2u81FONoizcxrhNjQTGLDWSfwRq
         kiUTk2rkPOv3tIJd+LV7g41JSoEd4S1fOw5sNzoudMnJZOLskLx0pThCIpChwrg3R2cL
         +WCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750280380; x=1750885180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aF8FChrkDuPz1pKDYbAfDf2mWO3Vl3/6TjWiBlEasWs=;
        b=rzHF0TEtbocacUY0GAMNwp6IoXvkMcteBB1ezrFjch14GmLt9x22xINyUMW/eTz7y3
         LntkxwbfuCsu0Y5Cey3cIY7kfc1jEfjs4JCyfb+QlMP/6SKWIlXttwaC//5x26xpLPup
         10qc5P6zOitf7O5Hv2OqIlLQBSSm36IP2YlNWCwhAfsu19Z0ONEjD1nuvZqFSZupILpo
         6xwSw0cip/gG2/Z8Egpk3TU3JBkOu9FtckDgOmXh2NZtd5o48kSNpbpTZhjYG4iGjnKC
         6it1LGs93Qft6AfCC65cE5jl7Yr+0qnVagv4/zlSCb1rbNZgHqpx7CSEg+xb0ub9lHJH
         ApXg==
X-Forwarded-Encrypted: i=1; AJvYcCVpQ1WArur8hNTiAteYjtlQtw7NS0YozWO4bqhoxVAcDHNRtIyAwNbGEflDEeJM4wlFz+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEFVXdXtMXmQeLpiwdeHPGIG+0DIemKlh+I17SiLW5f4VAUUNV
	HGCD8o4v2ESPSkd5DYgGGr6dfdlmrkB3eWfwaXkRzRn/QR3JH/Fu/DADAWps3i/rzmz284CW4Wk
	0GPsWgg==
X-Google-Smtp-Source: AGHT+IF2uJOMlygI0ECXMxjUKFr94MDL8dRFNErS7/emaEcq+7yIxFlJ3NplEPfGVdrHzu/gZljNYVWfvEE=
X-Received: from pfoa20.prod.google.com ([2002:aa7:8654:0:b0:748:2476:b25f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4646:b0:748:3822:e8e0
 with SMTP id d2e1a72fcca58-7489cfd5dbemr25408374b3a.13.1750280379840; Wed, 18
 Jun 2025 13:59:39 -0700 (PDT)
Date: Wed, 18 Jun 2025 13:59:38 -0700
In-Reply-To: <7timm7vdq4vjwn6jo5bwgtbn3f7pdtdch7l5dws76pjg7syqwb@al5mifdmboog>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-14-seanjc@google.com>
 <bmx43lru6mwdyun3ktcmoeezqw6baih7vgtykolsrmu5q2x7vu@xp5jrbbqwzej>
 <aFGTYoxlLhZsiMUC@google.com> <7timm7vdq4vjwn6jo5bwgtbn3f7pdtdch7l5dws76pjg7syqwb@al5mifdmboog>
Message-ID: <aFMoumQ8ILTLr7PZ@google.com>
Subject: Re: [PATCH v3 12/62] KVM: SVM: Inhibit AVIC if ID is too big instead
 of rejecting vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen.rao@amd.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Naveen N Rao wrote:
> On Tue, Jun 17, 2025 at 09:10:10AM -0700, Sean Christopherson wrote:
> > Hmm, yes and no.  I completely agree that clearing apicv_active in avic.c
> > is all kinds of gross, but clearing apic->apicv_active in lapic.c to handle
> > this particular scenario is just as problematic, because then
> > avic_init_backing_page() would need to check kvm_vcpu_apicv_active() to
> > determine whether or not to allocate the backing page.  In a way, that's
> > even worse, because setting apic->apicv_active by default is purely an
> > optimization, i.e. leaving it %false _should_ work as well, it would just
> > be suboptimal.  But if AVIC were to key off apic->apicv_active, that could
> > lead to KVM incorrectly skipping allocation of the AVIC backing page.
> 
> I understand your concern about key'ing off apic->apicv_active - that 
> would definitely require a thorough audit and does add complexity to 
> this.
> 
> However, as far as I can see, after your current series, we no longer 
> maintain a pointer to the AVIC backing page, but instead rely on the 
> lapic-allocated page.
> 
> Were you referring to the APIC access page though? 

Gah, yes.  I was hyper aware of the two things when typing up the response, and
still managed to screw up.  *sigh* :-)

> That is behind kvm_apicv_activated() today, which looks to be problematic if
> there are inhibits set during vcpu_create() and if those can be unset later?
> Shouldn't we be allocating the apic access page unconditionally here?

In theory, yes.  In practice, this guards against an unnecessary allocation for
SEV+ guests (see APICV_INHIBIT_REASON_SEV).

That said, I completely agree that checking kvm_apicv_activated() is weird and
sketchy.  Hopefully that can be cleaned up, too (but after this series).

