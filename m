Return-Path: <kvm+bounces-17345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24B1E8C460E
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDE91281DE3
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9859922F00;
	Mon, 13 May 2024 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kurVcHcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491FF20DE8
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621492; cv=none; b=lVieKzi0mHsIkubus4zPEkUEantikYaOUzu0JQjrn/5MnuS9hTsNUdbd673dA0HryOIL5BwhXoEKrvLdPrqg12ZNrbWOOs09reHIYQvGrIKeGHCf+ffdjiVOZmQRDJrSZeJPXMjYKZ2yGNK9k4euqPI2O9l5D88HEoYm9Q075Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621492; c=relaxed/simple;
	bh=EyY6dM+BwYruN5Dec5VKwj6CPokffR2F/ZvHPPbD8N8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EVddK8A6pp32Wl1QSfN1LDdOH6Wg4B663YPJ+b/tinolc2F6uOGQV/3PYUebjgVtJCzDA2W7oLpRNGOHTtbJl4GNVj8JIaBMyp2bMxi5rK0gl4VBFmiKC7mx7g4VlvZ3X44tpB24Ch6gt1bXE6SHO7BfNURXTabHKEJ+mwbsjIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kurVcHcM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de615257412so8294002276.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 10:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715621489; x=1716226289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0dgYn6JxWZgYuUksjjgLPAFKoY39/xTqa2uyfMub0pU=;
        b=kurVcHcMyy+gcBjkFVRIHmLtqAzWusl0rWYeDLXnzkoRH7OxiLWcbB9a0rJOTd2jzJ
         AtnnC7cg0nZ0eZYk5YJlgBXOGXDgELG/dTXFxpNpY8O2d8N2XgV0cLJB1cU0qwam0X57
         aWIsGJDWC7M5/w7q9nJx2lCYDollnjvixHbBcjr+ttedaT9WPnLFYqTht5YCJJlx3qiS
         Y+mMg2PdqTxTdVqPtq8fvjWhdOVh0OJEMhwD8DMH87CV+bkAcN72Jk837uz8HS+TEdyE
         2kNBbJwcG2MFtNwoS2CEfjJscisBWul07UCe3FYerHEc/AydvS58q9YQlfT8je5U50H0
         Nczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715621489; x=1716226289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0dgYn6JxWZgYuUksjjgLPAFKoY39/xTqa2uyfMub0pU=;
        b=bA82Fp4fiyaLCT5pw6M89gK0kZWj1/Hh6US3hiIkD/ZCx0EdLByEvFd2oe9mEma+dn
         syVgsKvK0YF8PbUgQwM9/+9faaa0tHFpy+tlx3/8P512a+U3M/TvykY8cokCmInM6eJM
         AcwQktidsOPrzok4MjTUDJfiO9O3mbt2fFByFBjHb4gNclUyXoHrRmLohgh38bz2Vm0o
         Fg9UOmxMv7GvED7+jwXIVliPkJImP20tXeMNIGQm49U98opSCJXi5FGSd7pG3T2TSN7g
         8Zm/pe+wUaiTn2w/oKCUtS+SojZaXTC+jh2irRAi8A2CCihRqbD9eWDMFu5jRHo/SnL7
         nGFw==
X-Forwarded-Encrypted: i=1; AJvYcCX8f1iY7InWZyaEZr3DhBqYlCG+2B9H30t8cJJ4FBOZCbhdqATPCBP/c2BuUuAQ2XyyOKGeqDV42DiWWLbsejjZ1VR0
X-Gm-Message-State: AOJu0Yz45jhGFVX2tkQnRmn0cZ10JUJIgh2BGwwOve1tEPCRWbMFHABX
	9tArEDYfg/GUmkBuzf9ZH6yY2rx8n70ZU3yc6uo4JqqTq3NYyLcyFmJ4xm9ROY1HAp2/auTi0U8
	Qxw==
X-Google-Smtp-Source: AGHT+IFQset6SjwpwvVPpNmhl4NIM65WNzAgXX+cfWJEfUX6e1kfPn0nfLSCJZXjMlAohxyrtYzX2C4OFAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1027:b0:dcc:c57c:8873 with SMTP id
 3f1490d57ef6-dee4f3659c5mr2944912276.9.1715621489131; Mon, 13 May 2024
 10:31:29 -0700 (PDT)
Date: Mon, 13 May 2024 10:31:27 -0700
In-Reply-To: <3b6bc6ac-276f-4a83-8972-68b98db672c7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240507155817.3951344-1-pbonzini@redhat.com> <20240507155817.3951344-5-pbonzini@redhat.com>
 <3b6bc6ac-276f-4a83-8972-68b98db672c7@intel.com>
Message-ID: <ZkJOb4zJJnOAYnTi@google.com>
Subject: Re: [PATCH 04/17] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 13, 2024, Xiaoyao Li wrote:
> On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Move the sanity check that hardware never sets bits that collide with KVM-
> > define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
> > i.e. make the sanity check #NPF specific.  The legacy #PF path already
> > WARNs if _any_ of bits 63:32 are set, and the error code that comes from
> > VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
> > EXIT_QUALIFICATION into error code flags).
> > 
> > Add a compile-time assert in the legacy #PF handler to make sure that KVM-
> > define flags are covered by its existing sanity check on the upper bits.
> > 
> > Opportunistically add a description of PFERR_IMPLICIT_ACCESS, since we
> > are removing the comment that defined it.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > Message-ID: <20240228024147.41573-8-seanjc@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  6 ++++++
> >   arch/x86/kvm/mmu/mmu.c          | 14 +++-----------
> >   arch/x86/kvm/svm/svm.c          |  9 +++++++++
> >   3 files changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 58bbcf76ad1e..12e727301262 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -267,7 +267,13 @@ enum x86_intercept_stage;
> >   #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
> >   #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
> >   #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
> > +
> > +/*
> > + * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
> > + * when emulating instructions that triggers implicit access.
> > + */
> >   #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
> > +#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
> >   #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
> >   				 PFERR_WRITE_MASK |		\
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c72a2033ca96..5562d693880a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4502,6 +4502,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
> >   		return -EFAULT;
> >   #endif
> > +	/* Ensure the above sanity check also covers KVM-defined flags. */
> 
> 1. There is no sanity check above related to KVM-defined flags yet. It has
> to be after Patch 6.

Ya, it's not just the comment, the entire changelog expects this patch to land
after patch 6.
> 
> 2. I somehow cannot parse the comment properly, though I know it's to ensure
> KVM-defined PFERR_SYNTHETIC_MASK not contain any bit below 32-bits.

Hmm, how about this?

	/*
	 * Ensure that the above sanity check on hardware error code bits 63:32
	 * also prevents false positives on KVM-defined flags.
	 */

