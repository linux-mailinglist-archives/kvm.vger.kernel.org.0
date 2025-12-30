Return-Path: <kvm+bounces-66849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3545CEA185
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 16:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 679053028FE0
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 15:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C222F31D726;
	Tue, 30 Dec 2025 15:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ckQ+6tDG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD223EAAD
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767109420; cv=none; b=r6QsDHsqMuFMpL1astq5I/C2eF4uO1VbSeBQuMvIY1T3RHXdhkaAdrEXzDjwhqJ11tNLL56PA3J5oS3U2PpzEIlgunArpZJaURMkhj4sK3jg8bG6Uh+48FguOrV788ONSpVdWHLweBInDmXGhE8X+xfJmYO8W8KE2TV2GP25sMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767109420; c=relaxed/simple;
	bh=PVGG7JfzHJEzPAkrsIuaNh4bQsTTEnA0+kchX4fwi94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcp1wH9eKikma+crXNbmE3nx+YZophdLxcQj+PpnvX/RFxDVAyccT2+RtDJhSKvqQ+8A5toodyfF6YwCX0x5xTnEHivmgJhX8IMK4HVy029B3HJN/vebtnTQo6PzUIodxm5dTg9/AYLPB9K2h2TQuO8BdD+kWRkIUQIjvV8SlCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ckQ+6tDG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so22109057a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 07:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767109419; x=1767714219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P2FhOAhoEBQ0BETm5QI3cfwMEJYegB0MimKAdHgGgOU=;
        b=ckQ+6tDGU99cWhYbQbu7plrDtIE9n6lqodfucliHDjpzxEJ0W3nU7EeBMdDVzN8Cfu
         GoAZtob8IVUw0iYfM40euzHS3QyNEnvB/Q/TEk28+qTmt5TXSDA26wQOo7cyeOjbeBUZ
         Q9SzfKKcfDEweiQh+0X/K/wHNaE+TiYoEtt7GpQ25lj+xjZwKatcSPeqIizj3Q1GC823
         Gjt3cPTpph59olTBuooFDXxB7q32Zzw3QJ2PpIjffGbJWJmCbk3d+jbcAVmQtp4Q68WX
         BO/5bl7+LGNOTjXuDH0sv64Jj+7G9znkxjzaMk6/csrcMIf3JuLplgCEUnhVJMilTple
         +6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767109419; x=1767714219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P2FhOAhoEBQ0BETm5QI3cfwMEJYegB0MimKAdHgGgOU=;
        b=EBGI1fZMcGuO0USKnv/qIYiq4kBPggwK/TxpMhEkDjqARXnfYGiE5IZnidMGVCLCYx
         Y+9a3sYxf0RIM5uMJ92oR+4oPPzwK5weEQ9AqcU6gX6X9erSk2cZ0Mq2EM4NHY/NRAAw
         sDUluHHVrOIUijT/eEXzR3PefrCzx4DvGgHNfFMaxJ9qjADNTGFGJ+eVxVBjNRa0UOKK
         3dpIMMFy5PMhU9wKCBCcZmAyp0r4dPUpYrGP/qUZfq7MWQQliV80t6PTnbr+2Y2WyrIO
         YM4rhds69RYEgeh0I99Ci9AgDUIPtNz2DLlVKILE8UunKo0EMP5CZzGh57oCtkEu0cdB
         G9tA==
X-Forwarded-Encrypted: i=1; AJvYcCXyy/B0lt0daQckHCWzh0d61rF4REeuUD5iAJqKV3WQng59/QUyv6JloDmYqOjbMstvOMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzakJyFseh/2iFxTY0/lKNXHwn043SwPs3n6MpXHy5KaDQydn69
	bi6Vlbo+027xz4Hd4IrMxpzaeL87mkQ9tgU2FhvjxSKofCW2JuDoOyqRhxebL965sD4jQMP+0Z/
	gdUwYrA==
X-Google-Smtp-Source: AGHT+IHk01rKNUVNTE/9QLom8LLLSWyyqEEMiirrvuhsmpQc7J1hUNr59x9uT8Jo0uZI0KspWc1dCf8RjPY=
X-Received: from pjxx11.prod.google.com ([2002:a17:90b:58cb:b0:34c:6f7a:2ab8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c7:b0:34c:a29d:992a
 with SMTP id 98e67ed59e1d1-34e921d6cbamr24908645a91.34.1767109418785; Tue, 30
 Dec 2025 07:43:38 -0800 (PST)
Date: Tue, 30 Dec 2025 07:43:37 -0800
In-Reply-To: <e0ce2edb275d2f249beb8ab908f0bad55f8b9037@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-11-yosry.ahmed@linux.dev> <aUshyQad7LjdhYAY@google.com>
 <2sw7xjtjh4ianp2dz7p24cht2v6u55wcdac4xlrxn5vjgqti77@4ohtwtywinmi>
 <aVMX9a2gVxToXjlL@google.com> <e0ce2edb275d2f249beb8ab908f0bad55f8b9037@linux.dev>
Message-ID: <aVPzKQeP6ZGhg9mx@google.com>
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions for
 nested EPTs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 30, 2025, Yosry Ahmed wrote:
> December 29, 2025 at 4:08 PM, "Sean Christopherson" <seanjc@google.com mailto:seanjc@google.com?to=%22Sean%20Christopherson%22%20%3Cseanjc%40google.com%3E > wrote:
> > 
> > On Tue, Dec 23, 2025, Yosry Ahmed wrote:
> > 
> > > On Tue, Dec 23, 2025 at 03:12:09PM -0800, Sean Christopherson wrote:
> > >  On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > >  > diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> > >  > index fb2b2e53d453..62e10b296719 100644
> > >  > --- a/tools/testing/selftests/kvm/include/x86/processor.h
> > >  > +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> > >  > @@ -1447,6 +1447,7 @@ struct pte_masks {
> > >  > uint64_t dirty;
> > >  > uint64_t huge;
> > >  > uint64_t nx;
> > >  > + uint64_t x;
> > >  
> > >  To be consistent with e.g. writable, call this executable.
> > >  
> > >  Was trying to be consistent with 'nx' :) 
> > >  
> > >  
> > >  > uint64_t c;
> > >  > uint64_t s;
> > >  > };
> > >  > @@ -1464,6 +1465,7 @@ struct kvm_mmu {
> > >  > #define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
> > >  > #define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
> > >  > #define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> > >  > +#define PTE_X_MASK(mmu) ((mmu)->pte_masks.x)
> > >  > #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
> > >  > #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
> > >  > 
> > >  > @@ -1474,6 +1476,7 @@ struct kvm_mmu {
> > >  > #define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
> > >  > #define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
> > >  > #define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> > >  > +#define pte_x(mmu, pte) (!!(*(pte) & PTE_X_MASK(mmu)))
> > >  
> > >  And then here to not assume PRESENT == READABLE, just check if the MMU even has
> > >  a PRESENT bit. We may still need changes, e.g. the page table builders actually
> > >  need to verify a PTE is _writable_, not just present, but that's largely an
> > >  orthogonal issue.
> > >  
> > >  Not sure what you mean? How is the PTE being writable relevant to
> > >  assuming PRESENT == READABLE?
> > > 
> > Only tangentially, I was try to say that if we ever get to a point where selftests
> > support read-only mappings, then the below check won't suffice because walking
> > page tables would get false positives on whether or not an entry is usable, e.g.
> > if a test wants to create a writable mapping and ends up re-using a read-only
> > mapping.
> > 
> > The PRESENT == READABLE thing is much more about execute-only mappings (which
> > selftests also don't support, but as you allude to below, don't require new
> > hardware functionality).
> 
> Oh okay, thanks for clarifying. Yeah that makes sense, if/when read-only
> mappings are ever supported the page table builders will need to be updated
> accordingly.
> 
> Although now that you point this out, I think it would be easy to miss. If
> new helpers are introduced that just modify existing page tables to remove
> the write bit, then we'll probably miss updating the page table builders to
> check for writable mappings. Then again, we'll probably only update the leaf
> PTEs to be read-only, and the page table builders already do not re-use leaf
> entries.

Yep, unless we rewrite the KUT access test :-)

> We could be paranoid and add some TEST_ASSERT() calls to guard against that
> (e.g. in virt_create_upper_pte()), but probably not worth it.

Agreed.

