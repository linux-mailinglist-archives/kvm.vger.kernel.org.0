Return-Path: <kvm+bounces-11091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5427E872C81
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 03:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFE521F289B3
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A5DDDAA;
	Wed,  6 Mar 2024 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHTfL2f1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B301AD518
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709690529; cv=none; b=dxWFnbHlR+iIZJe0CGjR0yEEognCE+PWfXNzdT1xt34FhFz24n+cR4QC0Wm15BWV1/HJ3ajBPBQubKW56C8OPnTxyCwVMp4pgC8pOfrwQ5YXgcQsTfBO3ogILi/DSCQeUyFjPDB6UMJa5AJ0XsLhi62l9ESEOFepInkl2J/eJno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709690529; c=relaxed/simple;
	bh=sj3Ndp8Opn8SFftC+mF5wy9/jACmHxqK0vbq4I+R76A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aHbsHaqxeFxNyWNn9wKGNAQzx9f2bHoj6fjphr+9r0BP5bep2R+0Mjm6lZgTMa6PNnaGIBKuSGY0Skx/OFMbYC0rLWfDEX49rBlKtQcTnDg5uhwNgb1xYHrwaQ3elupFwguREWXRdoDLDbPteI9puc9BBBmp/+kZCGhbSPul3MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LHTfL2f1; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso879928276.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 18:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709690526; x=1710295326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cgtE41l9iCbMAdWAWVcpbmBmFwz/dS6MgbuAWiL0tj0=;
        b=LHTfL2f1U+Ql3ClZqXMh8VB/iDBJWC/hyqQ8UKqsRLF2FcDWXjN+dxPTwkWib7MhFz
         Ep52EY9vym1bWDnAu2/ajWJuewQHAuHCFu3aeiaeGZPI1dbJX9LBotUKXvirs6RXbkY9
         7BMzGowubtCF/OAg+4Z8SI6/O+vRPucH6ti8iOnbxEsNsb9S1s2SIz5SKg0LqF0aMoYs
         bHiOBaItBvIaCy5XY0+bJSLEEts3OVv2xynL/lMnn35dMIdzgvafSz6RR1LMPJwLal7N
         p4ltXyvutJDNl7pL///UK1EeXO02g/QDVUk5tB8iI5ZGQ0yX/jnkD/05i1zDtgaZkPAG
         UZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709690526; x=1710295326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cgtE41l9iCbMAdWAWVcpbmBmFwz/dS6MgbuAWiL0tj0=;
        b=YwpbMCThe7uNeGOQwZpkVW6Mkr/GX8ycFG3Xq5fANHSfaY1fQqRu+0V9m0QAqRMKJl
         L1SnAIX26V4phSFqjSJsqhhmsNg6Kd5Y3A4yLfibdrD3YnKJNE45kZ0Umu1XZ7gUK9i8
         lZ4U6/PuCmx+Zvs4kEWu5tY7zA2ymilwHcZlDV93J5dgl9NFrPtFlB2glzEGgkKpAr/q
         lfsQkgCCUTzB8hIZ9Cw4mMyECBo4V4l/iY0eYEwMdnffIcnBSGZ01H27bL4VyvfF9TCY
         b5hZzuQ6gME+uLIQQRPyE1VDIPmDaM+Hr5gSnzIL4c607/EAYDSWTn8Rni/XXS198O08
         1zWA==
X-Forwarded-Encrypted: i=1; AJvYcCXg3aNRYJ4PfqyGHNBP9aR06eLCOT60DjVQ2+mxxADTpnHu8ksWBQm0ijWYSxBQ9bJxuWrvxYcuohXSWPQZ9Nx2L4xD
X-Gm-Message-State: AOJu0YwIDNwtEncp86VQVcYzC+4FrPpIw1R7J7ESJ+z7MSUOBd83Q1hL
	jSz5PVIU3+vETdCJXryNcCb70zkbpqe5X0NjpukCWmX3E4EHUm8tjlaQ9LmqLck1x4we6/xS7sC
	LTw==
X-Google-Smtp-Source: AGHT+IGn5PHRMQ1fMLGmFCBEsBmuNqQ6YcSzb2UmyIjN9D4dI9GcrUinEDDKakjxoexTeFAqPSO0Pvfl2SA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2181:b0:dc6:ff54:249f with SMTP id
 dl1-20020a056902218100b00dc6ff54249fmr3435657ybb.8.1709690526675; Tue, 05 Mar
 2024 18:02:06 -0800 (PST)
Date: Tue, 5 Mar 2024 18:02:05 -0800
In-Reply-To: <a8dbea9d-cca7-4720-9193-6dbeaa62bb67@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-10-seanjc@google.com>
 <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com> <Zee7IhqAU_UZFToW@google.com>
 <a8dbea9d-cca7-4720-9193-6dbeaa62bb67@intel.com>
Message-ID: <ZefOnduZJurb9sty@google.com>
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 06, 2024, Kai Huang wrote:
> 
> 
> On 6/03/2024 1:38 pm, Sean Christopherson wrote:
> > On Wed, Mar 06, 2024, Kai Huang wrote:
> > > 
> > > 
> > > On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> > > > Prioritize private vs. shared gfn attribute checks above slot validity
> > > > checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
> > > > userspace if there is no memslot, but emulate accesses to the APIC access
> > > > page even if the attributes mismatch.
> > > 
> > > IMHO, it would be helpful to explicitly say that, in the later case (emulate
> > > APIC access page) we still want to report MEMORY_FAULT error first (so that
> > > userspace can have chance to fixup, IIUC) instead of emulating directly,
> > > which will unlikely work.
> > 
> > Hmm, it's not so much that emulating directly won't work, it's that KVM would be
> > violating its ABI.  Emulating APIC accesses after userspace converted the APIC
> > gfn to private would still work (I think), but KVM's ABI is that emulated MMIO
> > is shared-only.
> 
> But for (at least) TDX guest I recall we _CAN_ allow guest's MMIO to be
> mapped as private, right?  The guest is supposed to get a #VE anyway?

Not really.  KVM can't _map_ emulated MMIO as private memory, because S-EPT
entries can only point at convertible memory.  KVM _could_ emulate in response
to a !PRESENT EPT violation, but KVM is not going to do that.

https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com

> Perhaps I am missing something -- I apologize if this has already been
> discussed.
> 
> > 
> > FWIW, I doubt there's a legitmate use case for converting the APIC gfn to private,
> > this is purely to ensure KVM has simple, consistent rules for how private vs.
> > shared access work.
> 
> Again I _think_ for TDX APIC gfn can be private?  IIUC virtualizing APIC is
> done by the TDX module, which injects #VE to guest when emulation is
> required.

It's a moot point for TDX, as x2APIC is mandatory.

