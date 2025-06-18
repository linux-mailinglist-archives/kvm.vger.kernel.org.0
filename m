Return-Path: <kvm+bounces-49909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B78FADF892
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F30537A96F8
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 21:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB04B27584D;
	Wed, 18 Jun 2025 21:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FmlWRqHQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E54274FD6
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 21:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750281468; cv=none; b=ttxuBa8gGl3fcPdPxpCuFf4EXtNp1xk8eclE65bLh2TTt+2xxQb+JgmFXqHfdzmP6XhMY1HJVS0bTelJbIyZpTSZTj3gaSpP7SfPimhHZDiX3BCS82EyKSQbO8GG3rgubiU0LyvmXMnZx3FA1RdvYz22VOH9xfi2136aSXdsDsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750281468; c=relaxed/simple;
	bh=CMs2h4kbVtiV15SKFeOJCR6/uSQFgcHkomdTrmd6ICM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K71FzoDKEp8rh8ohOawWkeIcbi8lPAbNqXZL9I4OItyWAUbAQS1a1UMwuMCQUpiuAtOLTLu7Xj6RJbD1dT5CkTiqvJh2sIYmIbo8Xs3I8/c+sTBB1AD9tEjiIles+bsom6sSwdMR4ov9bu7ctTKSeci2qxbOL1vPTKpTGpakeMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FmlWRqHQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7394772635dso66648b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 14:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750281465; x=1750886265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDeX7q/l2+xg1imuGAxKGeggwWOnK+wgg5Zm+bSeJk0=;
        b=FmlWRqHQXaKSWosrOxrkfXMLMZf0nfBTbax4oS+1dFJqz6txfxDPA9eTkML5FilCa7
         BmdshjclBUyrVxpKspVrHLRUkB4dhC+5FQrhxkoecPdbfzM2SN/dEPdI8qQS4GXzbrjc
         calWORmoLLnRaM7oTSEBnlwRaDm35nzwYue9DgdjFq/hK7UHElUcLhHriGmcWoAGMfob
         B4v7XcF/EO/RBeNEEtnbf+riDWvj0xbLMmnVtL8FGS5KuyaQT1gP6j/UekkYULwx8vgK
         P3hzDYdRaasYRZpmQOOIMWafcoSApNbaeRQUKE5a9mRZXpBdbaV7pd8tptYT1XMHPyBp
         CfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750281465; x=1750886265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDeX7q/l2+xg1imuGAxKGeggwWOnK+wgg5Zm+bSeJk0=;
        b=n6ZstAH78HYDG2tD6HFx3+pSAc/sKMhsUd5qQfdUUoy0yxXyX987O+J2t/+IwV0x/R
         WXBcDSJbfExp7c6lRWOzgOIyr5hS0hlF/wwDcF0/4HH964Qs2/4gPyMzUZBdQzVM87D+
         POrmEucaltj4p/XDlieaBqeDdlyJgHnvEvvmaVwcbFv31XPwcQDOYEaqWMxN6lDWfaxd
         0fiBn9zF0LxO9yxvm92C6qA8a+G9XFZLh5gpbstUsLG8h19mxh12iSdap2ahR8d6/BrZ
         jEnpO2/BP5x6z1Vxkud9ytR8sjo3N2KP0PiGtS7egynb7t3Vmq0Q0MTK66161v+QcEBQ
         f18A==
X-Forwarded-Encrypted: i=1; AJvYcCWigq8rMpZlh5wGWny6npOihOh7fPPZY0vj2vZFdSyyEJje/OvmBXqim7Cpsf9z9gJO0Es=@vger.kernel.org
X-Gm-Message-State: AOJu0YwozQ0+Lezz/grOpGTWukbqYH+ScpIPlnL9neBW/ey1NbsYv7Ss
	LmuRnV9dnPNibk9tIEkBdyJhK94aK5dL2plofnTnGCN3/BfVvniw4lvzmcf7bVHwSXNsAZRfEIU
	KliXXhA==
X-Google-Smtp-Source: AGHT+IFrMBaSJPDppRsJZ5jvlklOZU4VQzs3tJ3F6qMENhjmoLLRaWLyHwVi7GAyrqStyqYxXS8ZDE6slDQ=
X-Received: from pfbef26.prod.google.com ([2002:a05:6a00:2c9a:b0:747:aac7:7c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3399:b0:21a:e091:ac25
 with SMTP id adf61e73a8af0-21fbd505f24mr32186546637.6.1750281465010; Wed, 18
 Jun 2025 14:17:45 -0700 (PDT)
Date: Wed, 18 Jun 2025 14:17:43 -0700
In-Reply-To: <aFMS4O2TkWN8nexY@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-3-jthoughton@google.com> <aFMS4O2TkWN8nexY@linux.dev>
Message-ID: <aFMs9_GBVsiRmgz7@google.com>
Subject: Re: [PATCH v3 02/15] KVM: arm64: Add "struct kvm_page_fault" to
 gather common fault variables
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Oliver Upton wrote:
> On Wed, Jun 18, 2025 at 04:24:11AM +0000, James Houghton wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Introduce "struct kvm_page_fault" and use it in user_mem_abort() in lieu
> > of a collection of local variables.  Providing "struct kvm_page_fault"
> > will allow common KVM to provide APIs to take in said structure, e.g. when
> > preparing memory fault exits.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  9 +++++++++
> >  arch/arm64/kvm/mmu.c              | 32 +++++++++++++++++--------------
> >  2 files changed, 27 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 6ce2c51734820..ae83d95d11b74 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -413,6 +413,15 @@ struct kvm_vcpu_fault_info {
> >  	u64 disr_el1;		/* Deferred [SError] Status Register */
> >  };
> >  
> > +struct kvm_page_fault {
> > +	const bool exec;
> > +	const bool write;
> > +	const bool is_private;
> > +
> > +	gfn_t gfn;
> > +	struct kvm_memory_slot *slot;
> > +};
> > +
> 
> So this seems to cherry-pick "interesting" values into the structure but

s/interesting/necessary.  I literally grabbed only the fields that were needed
to handle the userfault :-)

> leaves the rest of the abort context scattered about in locals. If we're
> going to do something like this I'd rather have a wholesale refactoring
> than just the bits to intersect with x86 (more on that later...)

Definitely no objection from me.  How about I send a standalone patch so that we
can iterate on just that without James having to respin the entire series (for
changes that have no meaningful impact)?  I'm anticipating we'll need a few rounds
to strike the right balance between what was done here and "throw everything into
kvm_page_fault".  E.g. we probably don't want "vma" in kvm_page_fault.

Hmm, yeah, and I suspect/hope that moving more things into kvm_page_fault will
allow for encapsulating the mmap_read_lock() section in a helper without having
a bajillion boolean flags being passed around.  That would obviate the need to
nullify vma, because it would simply go out of scope.

