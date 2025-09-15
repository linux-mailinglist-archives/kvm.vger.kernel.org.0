Return-Path: <kvm+bounces-57621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C947B58660
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5989200E47
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892B42C0268;
	Mon, 15 Sep 2025 21:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bRnmGwR7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF042882D6
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757970539; cv=none; b=R4bHro9UhdZi8mHIE7ZE17T6gGwemxhD4vDsZ4vc/jPQMgev5S7XNZmnrFux7hAT/6NKaqYjZhy5u88QmbG2kU8v0yGCYVn6WuRbI12IZzESbkwC7ySirQRwkYphP2e+YfeGQvu6vSrZnfqYmdjggLRau/CwRtGihwQFfKb26jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757970539; c=relaxed/simple;
	bh=Ih/U4z/3ttn5Yg9C7BXzOVkvezPJKgWCvyMiUq/ik2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nAFwhaT/puLtBlMD6N8T/S2pGgkeQJpuF/KQivCQ6aACngkoqpYG7mS20XTb+zFE4JAxF5Ns49S0RyspiJFzIBVfd0XwXENJzOv+nWbU/yEGZBkMtrryHaAvLjRWlAcnMRT2YTzsJvIONGGqG3Pv5lIqE8FvezyZBDAkjEcTx4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bRnmGwR7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458274406so90623015ad.3
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757970537; x=1758575337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHoV5x8lSTUyrMscJova2iCZDY1TZMS3J7e0N01HyDk=;
        b=bRnmGwR7PXthzxKvMGDjb1XJiXTshFtUJ0Qe4PzMc/HRz81I9NkYc2krrjMdP8j9ET
         wrmyO6CPJPFEy/Gjy7ctvSCeiaMLlmcVE/xnJRFXzkIwd1cuIEGWZOYNaLcibgxIfR75
         APTx+62J4ckxpjcI4SNXGmK1puHmD8YLmP492fuhdxaobQVyrgzG15snNLRpYxxWGO68
         7gvvLqzXBkYEwyg8aIjcm6Bdjab0q8lL7wP9rhs4oJPWMqLWIpAIwN4uBgmbA2mOlN8A
         SSU6zxaFMTVYIXNKLe69Ht/oYyNk8BlZ3MOC8gceAtVNCD3OWAJvaFCnDtxorjepQdxl
         eCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757970537; x=1758575337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHoV5x8lSTUyrMscJova2iCZDY1TZMS3J7e0N01HyDk=;
        b=RWd0NHHP5CG/zKZuVRuIVbtieUaJUDBaU6ZUX017L0DrzVUClhhzJa4v4i/5O1KlgB
         M27B3kSnQA/4J+tc4CfizAOu8ZaGSIBlCRIWHUhybtLiEli33t4J9dOyKniJNYsDFsvh
         99rLrtipXKt8RDZt6PgVX5TOoHWnVCIUPx0AZG5Bi8N6GrK7H7j5vy00aGR4CKTnnk27
         If3SW4OUdSTijvFxZgE6wpL1H1d85v+9RlrkuQV4T9JzJct9JEJScYkPH+ypKS5haY8I
         gGFnqjqX7kBi0vkXu8ois59En0T6CpVkAwzzNE8IA+3FodFJblPM5YXFrIafO2uYpJin
         AhrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGpnnJTEF4qwwgmGixyE7+yRImB9NrhN90KrydWF0rvveTicz45eT5OHql45hhXiHL+j8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOnhCV44iMAc5qiaQlgA5EFWi0FwK7f2IZp6LD0SFjLlI4qBpo
	QFbaznxAirP0PVbNn/71XIbemdDIGIvPBtyE2IDW3ecriMWBuSrE5uQeTE5KqNZEKStMkPDqTb4
	kU5QQEQ==
X-Google-Smtp-Source: AGHT+IFhspb9CP1/t+ouX1v7WI9sXhhBWzH1IoI9+og+oNmjMAVrJzxLQy34obRp+DaPbO854t20JPjzujU=
X-Received: from pjx12.prod.google.com ([2002:a17:90b:568c:b0:329:ccdd:e725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f785:b0:267:bdcb:6854
 with SMTP id d9443c01a7336-267c4a77eb0mr8403995ad.10.1757970537606; Mon, 15
 Sep 2025 14:08:57 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:08:56 -0700
In-Reply-To: <43b841ed-a5c3-4f65-9c7e-0c09f15cce3f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-3-seanjc@google.com>
 <43b841ed-a5c3-4f65-9c7e-0c09f15cce3f@amd.com>
Message-ID: <aMiAaEMucEeOKiTj@google.com>
Subject: Re: [PATCH v15 02/41] KVM: SEV: Read save fields from GHCB exactly once
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Tom Lendacky wrote:
> On 9/12/25 18:22, Sean Christopherson wrote:
> > Wrap all reads of GHCB save fields with READ_ONCE() via a KVM-specific
> > GHCB get() utility to help guard against TOCTOU bugs.  Using READ_ONCE()
> > doesn't completely prevent such bugs, e.g. doesn't prevent KVM from
> > redoing get() after checking the initial value, but at least addresses
> > all potential TOCTOU issues in the current KVM code base.
> > 
> > Opportunistically reduce the indentation of the macro-defined helpers and
> > clean up the alignment.
> > 
> > Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Just wondering if we should make the kvm_ghcb_get_*() routines take just
> a struct vcpu_svm routine so that they don't get confused with the
> ghcb_get_*() routines? The current uses are just using svm->sev_es.ghcb
> to set the ghcb variable that gets used anyway. That way the KVM
> versions look specifically like KVM versions.

Yeah, that's a great idea.  I'll send a patch, and then as Boris put it, play
patch tetris to avoid unnecessary dependencies (I want to keep the CET series
in a separate branch for a variety of reasons).

