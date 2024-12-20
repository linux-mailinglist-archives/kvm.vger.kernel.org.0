Return-Path: <kvm+bounces-34222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 657D99F95E1
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 16:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81F1516FAB1
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 15:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D2D219A79;
	Fri, 20 Dec 2024 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MHF1COo8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1002218AD6
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734710121; cv=none; b=BafhA+/pmf8l20jIzxWVGKS0jbZibniYCusVAY03371mOSIlfMamAEEDIEiMZ/VjQ0+oXzDl2f1lRK9VZ4GbwPPMh6ID+Ua6kUn0ax0s3Rj8v4loJoBk1+HFKEHtRuHoUApZsgqUYaIpJzFN735/zvjYNnzUnSvxdrao+rLDqbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734710121; c=relaxed/simple;
	bh=Zckv0Q1upSWR/j7MpUJsp0zHgylHXi86ht3p/Ud4xSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hn8OBk6SHzCx0mYU36h5UcGxze887uHLwzJ3OloQE/+bR2Y16G9r+jcEFohpqLJZzw/aqXIUJpbBclWpbI/NMPrDE/D68yvcxHNi9Em2Tg6IxYmZ1U6VFmWUUfxwuLRUQpvT0nf+2eBI5X3MZF+hSNihvVurMRbG6IcLFHBu+VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MHF1COo8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-801d2d2d31cso1475527a12.1
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 07:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734710118; x=1735314918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fAOBBY82yz4GhD1Hfrm813zjho5Qs4tjbUvWiIaoR6Q=;
        b=MHF1COo8lqayWxHHX8YD5jnFNnhn4g18VhL6VKvz0ppQzxS1q15Cf7/BlxvybgZ8Lc
         uCQLVqAq6yVZ/D+oVHvIChBLbjw4PqZJC/joOKQwbu4Ycceg0blEEnzbu703JV4qXUlO
         HatOiEYmijlpYcSUZeSVm6L1JHMI+lByCPjTIUO/nrJugWbdRwpWs6TMaGPsrI2o8JVA
         m88qBIU5FfervnxSq7K2Tp+p+VJJLhsUOwFbB7HI24baJK2K2grUm8H/tNsSzbsH3ceF
         3DhBs1hxR3zpWJsbO0nvVEYRplYUk7Amm8m4w7tZSOS3mOeUubQqBkdpzow6aupgz9O8
         UlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734710118; x=1735314918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAOBBY82yz4GhD1Hfrm813zjho5Qs4tjbUvWiIaoR6Q=;
        b=xKbrpcZlTosb0ONpU1z4LrlK2ddh4TGvjxxzZ4wpPVDlBHo+tLif9ocV4lrTNeTupi
         EEXinH+tBsuL00aBffJy88qx7Pk2SeMRgVu2TOurmJSgsLJW2yH0abdWMmcLy2wg53i2
         VtG8lRIIP/2jMni0vR825xjxEDBgThQqBvHPbQZLKnCRLY/ccQyo6GR8MuqIbrWFXSN9
         ObI+rQu4yU5vqdr5YmSZZQd4roU5HUw80mPUn/wHFMv7flzHYddBnGUw9fr/kbezixFi
         APGmQpn6BVmozZWFXJbw2+QbuDtsk/9/cC30nSyBCT/A2T9r9H9atfkSK+QcZHnbB89m
         HR6g==
X-Forwarded-Encrypted: i=1; AJvYcCXiROxfiuD6PGQji9XVkEJtNcGxTZb2yxoznpyz/MszqqBGxnInTz/SNRD0ZrOB6XekuFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfTxNHMdhED9FBZzaKRUP10GZEYNat9PYRFm5qETymkocpQQF5
	pir/l8rsb63ATJhZGxnSXSE7j+Pvq3Y5NwKajMkkz4m3qpKcKHcsaGkxidbIK6dLd6PTnv44qg+
	kIg==
X-Google-Smtp-Source: AGHT+IF82YdP4sqnOK6BCycmMObgP2yll0F5sTNSfwzgcikTaZLRzZ6rtxf0gjPQb7PDx4pt0szN6F0f6ys=
X-Received: from pgot8.prod.google.com ([2002:a63:b248:0:b0:7fd:56a7:26a8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d99:b0:1e0:f390:f2ac
 with SMTP id adf61e73a8af0-1e5e0481528mr6455092637.15.1734710118114; Fri, 20
 Dec 2024 07:55:18 -0800 (PST)
Date: Fri, 20 Dec 2024 07:55:16 -0800
In-Reply-To: <Z2Th31I/0O/HY/Mb@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241218213611.3181643-1-seanjc@google.com> <Z2Th31I/0O/HY/Mb@yzhao56-desk.sh.intel.com>
Message-ID: <Z2WTZGHmPDXHSrTA@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access
 is already allowed
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	leiyang@redhat.com, rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 20, 2024, Yan Zhao wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 4508d868f1cd..2f15e0e33903 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -985,6 +985,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >  	if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
> >  		return RET_PF_SPURIOUS;
> >  
> > +	if (is_shadow_present_pte(iter->old_spte) &&
> > +	    is_access_allowed(fault, iter->old_spte) &&
> > +	    is_last_spte(iter->old_spte, iter->level))
> One nit:
> Do we need to warn on pfn_changed?

Hmm, I definitely don't think we "need" to, but it's not a bad idea.  The shadow
MMU kinda sorta WARNs on this scenario:

	if (!was_rmapped) {
		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
		rmap_add(vcpu, slot, sptep, gfn, pte_access);
	}

My only hesitation in adding a WARN is that the fast page fault path has similar
logic and doesn't WARN, but that's rather silly on my part because it ideally
would WARN, but grabbing the PFN to WARN would make it not-fast :-)

Want to post a patch?  I don't really want to squeeze the WARN into 6.13, just
in case there's some weird edge case we're forgetting.

