Return-Path: <kvm+bounces-19505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 824C1905D60
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D5821C20326
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1A885923;
	Wed, 12 Jun 2024 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bW+jOPvr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC44012D752
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 21:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718226181; cv=none; b=fCwVkieEuqZ2/nUNkuMJArVIprRIcTrsavFQ2SxblppREWDcko9k2C14AYj6kbjlXcMJzrwvqWeNWrXxf34BDAuljVPhPNDr/YBSt2j7RZxERUvYxN1s5jyO/BzDgZgFa5mQ663bGaH8BPUbEnY1of9COfNpZF8ZcDcENG29dXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718226181; c=relaxed/simple;
	bh=1TYIkyImVcWQGBXXHpL6wbMEynsMIkTMy8d3F8mZSP0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f2aO5NMrcRBuuJBdrYKqz4XVOg8b5gPQ/gW3Vf48lz30B5hDd92+ooRGXIaO/zoZyw76nXO9rscRatKmeJv5G7vesMt1idncbeL2OkwuDFL0wppoBwwydGaOv4ZSKNnaRZYoDZkL4SQs2W3H5jo5LXR6Vy2XBYTMNsoD/3wiG3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bW+jOPvr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2fe3c4133so181169a91.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718226179; x=1718830979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J3xgWRxCgfKePUIQRk1/bOVRKkSjNiVa6+ku2rMooqI=;
        b=bW+jOPvrXWc2sN7IGlpVQaq8Zx9w7YW/aPk2UtDiT5Ev/7RR4PBWThSAVJj2YUDWRc
         DzZPTEKxCvRVYPLZhpe3TtAKgdcGC/+/RHJzfhYp+pGRQpTghRtTT2JI8UaX1Sd76jLV
         vr/A8JrJkoMVkydXTRobtq8LpBQAdfymeE6FfSXk3PszR5JUMX+vyYxe1CDeZIuZ48bs
         LDauAl6Lh25UP03oml8RjZFoEpfLnxRNBjTscaAZmDGCu2M6+7GL6c+vDyl34WHNY/lB
         5OWD3pd0J/Tt+xyWyh+m2PSJr4I4h69C5Q+hTk+rr69c0qnSUiF/Uoh18pmMixeO0aF0
         43ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718226179; x=1718830979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J3xgWRxCgfKePUIQRk1/bOVRKkSjNiVa6+ku2rMooqI=;
        b=I8T3o3f6HwzxkBoaA4NOE3ERhN/vFeX8pGlpKLrSW/VmF2uAgq60Fxpg4qZxrIUZ9t
         RWSopMF0gOpNxwIPso1e1c5QAPhmqC29EAiFCpDUifSZK1kJ0pu336t7GX6pnaGbPMFk
         QygHhdndl5jNE3ghaRqEXJx/lhfK2VeQKRB+FDTWO7dANHNbBGlJh4Nmd8pTLRuACGGw
         yOUG9CefQ42skMwIPIUwFv2Cc78tTVCzqkfwxAYIy0dxfgZYVSiMNUGVX3ikZermTKr/
         6VPaqKoaSGi93B0u2M7sroA4/gyO9vp5fVlU/sfr/KAjydFiFZ1RDVOQrFD457lcHNfH
         6XTg==
X-Forwarded-Encrypted: i=1; AJvYcCXBq4krHqs7McdDzt0f4iPnIdYMXKd15px0JtZw0M2B/vuDhwCm1apQGqHmrRi2eiQpR/JyO+33SRkmDzyXDVCuJnNh
X-Gm-Message-State: AOJu0Ywf/xhpZbtA89qj62Lp/T7sg1KlOO9lw9du9U/B/Fi5EHY5TQ0o
	6WroIL/ERYw8yZce51LuDFswKFNs9xqWP+d5QCIhb2SbC29Q9mbZJq/7Y7cGGzb9u/3wGwd4DNd
	/iw==
X-Google-Smtp-Source: AGHT+IHtBONcZJ3ua6rr9KF0YTE06FmHu2WTAWj/KJP5w7j/Ttnoq6SE0bp0Q5inkEDQ0elbifO9mus7g/Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:62c9:b0:2c2:c65f:52dc with SMTP id
 98e67ed59e1d1-2c4a770e8f6mr8383a91.6.1718226179078; Wed, 12 Jun 2024 14:02:59
 -0700 (PDT)
Date: Wed, 12 Jun 2024 14:02:57 -0700
In-Reply-To: <d5a6e125-bff4-4d82-ae65-b99d9cb10e90@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419085927.3648704-1-pbonzini@redhat.com> <20240419085927.3648704-6-pbonzini@redhat.com>
 <d5a6e125-bff4-4d82-ae65-b99d9cb10e90@intel.com>
Message-ID: <ZmoNAQmwIH5tigyv@google.com>
Subject: Re: [PATCH 5/6] KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 22, 2024, Xiaoyao Li wrote:
> On 4/19/2024 4:59 PM, Paolo Bonzini wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 10e90788b263..a045b23964c0 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4647,6 +4647,78 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	return direct_page_fault(vcpu, fault);
> >   }
> > +static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > +		     u8 *level)

Align parameters:

static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
			    u8 *level)

> > +{
> > +	int r;
> > +
> > +	/* Restrict to TDP page fault. */

This is fairly obvious from the code, what might not be obvious is _why_.  I'm
also ok dropping the comment entirely, but it's easy enough to provide a hint to
the reader.

> > +	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> > +		return -EOPNOTSUPP;
> > +
> > +retry:
> > +	r = __kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
> > +	if (r < 0)
> > +		return r;
> > +
> > +	switch (r) {
> > +	case RET_PF_RETRY:
> > +		if (signal_pending(current))
> > +			return -EINTR;
> > +		cond_resched();
> > +		goto retry;

Rather than a goto+retry from inside a switch statement, what about:

	int r;

	/* 
	 * Pre-faulting a GPA is supported only non-nested TDP, as indirect
	 * MMUs map either GVAs or L2 GPAs, not L1 GPAs.
	 */
	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
		return -EOPNOTSUPP;

	do {
		if (signal_pending(current))
			return -EINTR;

		cond_resched();

		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
	} while (r == RET_PF_RETRY);

	switch (r) {
	case RET_PF_FIXED:
	case RET_PF_SPURIOUS:
		break;

	case RET_PF_EMULATE:
		return -ENOENT;

	case RET_PF_CONTINUE:
	case RET_PF_INVALID:
	case RET_PF_RETRY:
	default:
		WARN_ON_ONCE(r >= 0);
		return -EIO;
	}

	return 0;

