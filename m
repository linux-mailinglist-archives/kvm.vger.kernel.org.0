Return-Path: <kvm+bounces-43354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1175A8A23F
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 17:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF0A61901118
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 15:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C5729DB6C;
	Tue, 15 Apr 2025 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SyuNHZeD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3667A29B776
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744729045; cv=none; b=OnuqD3FN/B6G1s0ZGBtCqXG+EPtfOssOmpKrxCMAkSkbgiK4nlF1LFZK3MJfLa6JOGEXz4WBwDxyw2b1OOyrRegzm5jBanP097z6SOeGZcb840MmNYgWLjJ2sHo6eHZs8q9unQcVfXKpdQl4rtgIXHhw03l+85Tu8FFNBGDXRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744729045; c=relaxed/simple;
	bh=TmbQCAQuL850VcC8mWpbyBi0guSCzKnednL7iUfUBi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpN3dbiN09FBauHYnYW9SArgHmvyZ8p/SIWJfaAKSLnJO+dy9EVvWFpq9c5KZmIht1mNrasNO8Qs1P/z4J1D8Iuyirl26KbUBHH8Ueh6xW5wB0i+zP8n2UoI6FCaZ3Cg2dwFRXlGBVXfyM2vc48P1CD5EPOS0SQHNBoBd8co2aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SyuNHZeD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-229170fbe74so47021695ad.2
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 07:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744729043; x=1745333843; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z3cubAcR5buc4RrtmjyrGPOPaYzbW+tbw+H7cOkEDn8=;
        b=SyuNHZeD/735HiymHu0kVG4RFxW8Fo9o8OLcB+v2kx8JqwIxCojQZijto4Q3USH+SZ
         R1J9JGpc53/4Co9G+25dbvX0pGHCSBNYdjg4VBnx1OIH9rBInyTSZNrZujvW3CrhXVCe
         NoY3UNX0kM64N508pGOsPgVIgPTB/GKsiS5g8F1B/b58h+nQ3mttbLppUqvlrCx2fPKs
         n6VVP6EbMnYmLiRb9Fe8zHWTBipECa4BkumAVvkpX0vXZsVB0jPNJFA31DsM8WoUlddH
         +UzhOXKhN8+mcYHmVxv1/nXiE5Dz6HOHOrABKh9W7M+iRhvc/khsoeJQirtXqgdR6mpH
         D8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744729043; x=1745333843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3cubAcR5buc4RrtmjyrGPOPaYzbW+tbw+H7cOkEDn8=;
        b=Cp20Lf5BpfWCAicCdzRQkmu0lg1s/zIPBdvG3XoZGLIRLpBGEoxVRW1BT6oe2D3Brt
         hUWIHtxloJoVgJgjSQn2Q3JvJfial5mm5eopQDsMMnSJyOxqaZGlku+e1YxuhrsOaJca
         shbv9eVjhRhsSSEhgaC/vx7zJ2BSRUVhunGE+K0s1skw4JYpyyFoCdYwv9Gh4S5L7lj2
         70PTxwgQBYLC30NaEy2UqxlGrsGAZgnTcIh2up/oGZhVPd+7TPbR3/hqGgA9GNWAPhnX
         JgtFJ8crvUyP6QiwmpFwpKVK10xMw4Fy2g723vawuPCg7fTmO0UXLsRMXjUhqbXiNGp5
         YK0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWS8TuMRPWivnlyB+cipVZiqWvZkH9GUVXn7DicYm9c7oEEoedIuVLPtf+YqekYeDMGxGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH4pxmvmWu2W9pYApLw0Oq4zDrKPPwn7k5lwTCThbLpB4TUGCw
	VbdzaR3wm6F/VTqdnqi/CeeGHMzHQ5+HoCrdG7EpC88XeO6v1dPDmMO0hxihLCxfcybzmChZEid
	lIg==
X-Google-Smtp-Source: AGHT+IFaFxQFXBxv1LVPQSIMqbDfDKQXIvk2koBUD5c6YTcCNKoR1Psp7St8pkylyftGChHPBfIrP+rfE64=
X-Received: from plri17.prod.google.com ([2002:a17:903:32d1:b0:21f:14cc:68b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b08:b0:21f:85af:4bbf
 with SMTP id d9443c01a7336-22bea4b70d6mr235612035ad.20.1744729043268; Tue, 15
 Apr 2025 07:57:23 -0700 (PDT)
Date: Tue, 15 Apr 2025 07:57:21 -0700
In-Reply-To: <2cc31ce5-0f1a-41d6-a169-491f9712ffdc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-15-seanjc@google.com>
 <2cc31ce5-0f1a-41d6-a169-491f9712ffdc@amd.com>
Message-ID: <Z_5z0an7-BJ1bTzF@google.com>
Subject: Re: [PATCH 14/67] KVM: SVM: Add helper to deduplicate code for
 getting AVIC backing page
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 15, 2025, Sairaj Kodilkar wrote:
> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Hi Sean,
> 
> > Add a helper to get the physical address of the AVIC backing page, both
> > to deduplicate code and to prepare for getting the address directly from
> > apic->regs, at which point it won't be all that obvious that the address
> > in question is what SVM calls the AVIC backing page.
> > 
> > No functional change intended.
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/avic.c | 14 +++++++++-----
> >   1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index f04010f66595..a1f4a08d35f5 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -243,14 +243,18 @@ int avic_vm_init(struct kvm *kvm)
> >   	return err;
> >   }
> > +static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
> > +{
> > +	return __sme_set(page_to_phys(svm->avic_backing_page));
> > +}
> > +
> 
> Maybe why not introduce a generic function like...
> 
> static phsys_addr_t page_to_phys_sme_set(struct page *page)
> {
> 	return __sme_set(page_to_phys(page));
> }
> 
> and use it for avic_logical_id_table_page and
> avic_physical_id_table_page as well.

Because subsequent commits remove the "struct page" tracking (it's suboptimal
and confusing), and I don't want to encourage that bad pattern in the future.

