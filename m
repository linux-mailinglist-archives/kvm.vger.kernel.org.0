Return-Path: <kvm+bounces-66808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A13CE861C
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 01:08:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C68A300C376
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 00:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EDD14A91;
	Tue, 30 Dec 2025 00:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVDVeGJn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051B7A930
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 00:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767053305; cv=none; b=pe3QnnuHHGP9qoPww4WdY+sPjb9TfT6HXLzTdwsjbxtm9z43MQE8/hNYvkKZvL12+hcJQgS2mownemeGQBAzLJ55Sen86E+UdUqb7iahZ/cLuNtzCx0aRlw7LmuBO6phrF6dvFTIf6NflKiwJ1gZUnNr82SBr72Svg/CWPrOXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767053305; c=relaxed/simple;
	bh=PvWOqeQhmtcFp7wG+93l9cGt5eqqehplscfVDw+CHeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MeeC5R31LoS8ep3j2jGNWxZODU7c9zCSMlLhmyn36KNdekJWE+KmAOaTQ7t7mURKvS6GyBaQeY1F9dZyMXSNEjohqEdqkB1AIAi75B36dmKzNJN9NscW+MI0I/YRPQhXo8QbqJAZ+9tYuelpdHE9zSBR4h0CyVy5tENCSmDpRAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uVDVeGJn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b90740249dso16827133b3a.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 16:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767053303; x=1767658103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJvjIRxId7foCyAvKZOHFtFgi3eRbWRC1tnPTwn77SQ=;
        b=uVDVeGJnchMRUhJtIfZ6PTIohioxN2Xi00WXPB/dBPXomyetWeK6oJxkDHOAHqpDqS
         aXVBfjyU4sQ2Kr6RGTsXFg3HH7Vjqk8kigSh7Glc5AJPIkWhm8wtj8u/dX/6YknnDbHw
         V336W27Ze/Vo5zArAjmjlcPNyD07MD2w8z3lMbBqgXu1YLKstLSBJ9oo2hmzn+95hNVM
         WCpZdEZQkQ9MtBufWsMdF10abAIjN1P0dGYFGBxt4i5nXbLQYtTE4e+zFzaNCWosmYfZ
         Lg9SYWg7wkvhCtV0XMWwEJBk7rlRdlMYNd/DMeD/kwPWtiE1G4V2L9Zvv87qRkmXDLNe
         7SVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767053303; x=1767658103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJvjIRxId7foCyAvKZOHFtFgi3eRbWRC1tnPTwn77SQ=;
        b=iULclzXVuoaaGyb4qlMmEv8iEILo299UG501It/sEXGJlX5D52kGPf+Dg1K8Y5wCDQ
         mfG0qEaSK66xf+OiVmSDe/9n5JF0+aV+eS43zGeXziHwLuF4rI3zaEnJoLxi6du2QQO/
         FshZhkeMaple8lTe6XaBl+qrk4SHkAp3a+dc4xtL7TIEEuWHVnQK1Q9ww3PsHpYsaTja
         UZkq8f+TlN22cvuPYiQJNFjoycnP21Box9mSESWjDQtrV/T6LPJqq1ySAF7rd3m/jICi
         rTsU09LvGx//QVGALwlYtVkj6HkUvXsA0Y2KVND3jgwg8PXKMYb1gHdtBOqy9d1m3iiQ
         ODsA==
X-Forwarded-Encrypted: i=1; AJvYcCUhCnjQ+zubTx3BvYnG1qwfIEwxApN8H8v9V24jg1p80GbGrviOweqXjl0wR9svtOkrHl8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+XzkObuDoXWBFiU/9cfFyus0/ULLMSLyuSk76X3YXZ5+zNkvJ
	d4ctQr8fZEQ2rmq3rFx4mJukHwHwqizzAT/AxgabZ4Ozct/qmg3K7xMPDMn3tvk7VmpW1Z4fFVJ
	8F7DZdQ==
X-Google-Smtp-Source: AGHT+IGP5yQBkU7MFEQikMCxLwFsQce+og4zqXoPQbaLVM9RO0SEYLXD4zIcmH5z8gekwOMGAc50eKwxSU0=
X-Received: from pfbjj13.prod.google.com ([2002:a05:6a00:93ad:b0:7b0:bc2e:9595])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ac85:b0:7e8:450c:61c0
 with SMTP id d2e1a72fcca58-7ff66674fb2mr32717579b3a.48.1767053303232; Mon, 29
 Dec 2025 16:08:23 -0800 (PST)
Date: Mon, 29 Dec 2025 16:08:21 -0800
In-Reply-To: <2sw7xjtjh4ianp2dz7p24cht2v6u55wcdac4xlrxn5vjgqti77@4ohtwtywinmi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-11-yosry.ahmed@linux.dev> <aUshyQad7LjdhYAY@google.com>
 <2sw7xjtjh4ianp2dz7p24cht2v6u55wcdac4xlrxn5vjgqti77@4ohtwtywinmi>
Message-ID: <aVMX9a2gVxToXjlL@google.com>
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions for
 nested EPTs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 23, 2025, Yosry Ahmed wrote:
> On Tue, Dec 23, 2025 at 03:12:09PM -0800, Sean Christopherson wrote:
> > On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> > > index fb2b2e53d453..62e10b296719 100644
> > > --- a/tools/testing/selftests/kvm/include/x86/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> > > @@ -1447,6 +1447,7 @@ struct pte_masks {
> > >  	uint64_t dirty;
> > >  	uint64_t huge;
> > >  	uint64_t nx;
> > > +	uint64_t x;
> > 
> > To be consistent with e.g. writable, call this executable.
> 
> Was trying to be consistent with 'nx' :) 
> 
> > 
> > >  	uint64_t c;
> > >  	uint64_t s;
> > >  };
> > > @@ -1464,6 +1465,7 @@ struct kvm_mmu {
> > >  #define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
> > >  #define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
> > >  #define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> > > +#define PTE_X_MASK(mmu) ((mmu)->pte_masks.x)
> > >  #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
> > >  #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
> > >  
> > > @@ -1474,6 +1476,7 @@ struct kvm_mmu {
> > >  #define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
> > >  #define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
> > >  #define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> > > +#define pte_x(mmu, pte) (!!(*(pte) & PTE_X_MASK(mmu)))
> > 
> > And then here to not assume PRESENT == READABLE, just check if the MMU even has
> > a PRESENT bit.  We may still need changes, e.g. the page table builders actually
> > need to verify a PTE is _writable_, not just present, but that's largely an
> > orthogonal issue.
> 
> Not sure what you mean? How is the PTE being writable relevant to
> assuming PRESENT == READABLE?

Only tangentially, I was try to say that if we ever get to a point where selftests
support read-only mappings, then the below check won't suffice because walking
page tables would get false positives on whether or not an entry is usable, e.g.
if a test wants to create a writable mapping and ends up re-using a read-only
mapping.

The PRESENT == READABLE thing is much more about execute-only mappings (which
selftests also don't support, but as you allude to below, don't require new
hardware functionality).

> > #define is_present_pte(mmu, pte)		\
> > 	(PTE_PRESENT_MASK(mmu) ?		\
> > 	 !!(*(pte) & PTE_PRESENT_MASK(mmu)) :	\
> > 	 !!(*(pte) & (PTE_READABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu))))
> 
> and then Intel will introduce VMX_EPT_WRITE_ONLY_BIT :P

