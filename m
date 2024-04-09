Return-Path: <kvm+bounces-14041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36AD689E5FA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5670B2270A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD72158DB3;
	Tue,  9 Apr 2024 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ol/4c4ht"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD22712F381
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 23:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704485; cv=none; b=sXdYHf+y5We5LKcNQE8nVpNqWDNKAx5omGCLP3RbJWhv19Um5lu/6h9TyUGIaxZH3Avwrn3/6/GghS9RJSQpzhl+X1DRLt2vM8v03e53936cIsD6WVJkyfQXhKQ/SS42PEO2Hq/J5a9mCbBZ+JpAns92h1ITOSG30+w3CHm8S9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704485; c=relaxed/simple;
	bh=zdMLguQ+lY7TAYbRHJJNU74aUnKWfs2RJcrFuAnyOS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FulkMxI0wS4mfEXrDbQedvjmkWkdCfDLZAuNnGDn4R3ADmWIBVv3b1ubZN+oQiDziDMSO3AQSpfk1NDze76Kmm/YaRduUd3/hvMj0v8RVq4v7/v8uXZ/ITiEDE0BHiNa1HeqKw9Wsbr1Q5AZfHTGkNfRGf3yWglDXQHQy52OAls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ol/4c4ht; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso11214314276.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 16:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712704483; x=1713309283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IHMCMmw+UGA4RM283j2BmahH1pVpA+RRW5zuHrCjOiY=;
        b=Ol/4c4htajzq3Rs19qga312/jxJO++/m5DRFan2xkS0TSXO1UYXuvtCTg1Tc/8XcGa
         mUnDpdKigYqbXA5CN4c4cNwGyz2Zw9LvZUrMuj8eFcWHi+AayEMMHnXuVifw/SbWGD6H
         qNdgMf8w84MACOAETUgVA+fqNDf/65anDo+5y3yH7wJd8b3KvoKy8SF+/0h0+Rs/W9Fa
         Xwykd9YFgH4qDk77rmUiW1bwxc/M3q2otcXLj2kqO7xaICs+53BQea3iKbTL1rewYlEa
         zU1nteb8Eys49W0eSuPK+eKEac+W/03jy2B/bfTgwMuuThwTA7IgvaxwEwmKRnqmSidX
         +Alg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712704483; x=1713309283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IHMCMmw+UGA4RM283j2BmahH1pVpA+RRW5zuHrCjOiY=;
        b=wVlCQOxC1XVOM7qccB4G+I38zGuJ27p1GvugqeOUds9UUJK+RRXn4lUZqaCzR63ycb
         Kesl42jPpkF27r17jvw3HsNZ7VTQksLeKah1Ve50OXgWR+IXyYl4KE9Tn6R++V8zLk4V
         u34rJr5Waj/9L7eMsZ+xal82H+L4xiHwwt9X7P6NSm60K26roF4X42q0m/VZNntvFyvS
         +bR536wDx3soPxRLIRolNcRHzav1IvzvztsPmWhUcLXnSgTBFM5AiY7lJo1lDYeQCvfb
         NbY0++9GnBDiUY0LT43U54sJyYmZ4DKbSNQWLyLL2B61dUR/44/FQUyrqOzhlAZwcFYJ
         DmMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEJIR+LmnELsP/4q+7f9RS8dHWh663ZFUI/ioBbi2AbX0/HtzYPVR7EODSAle7w++qoNCNDsRrFsjllQr/iiBWgDrM
X-Gm-Message-State: AOJu0YxhYYwTqxc3O8Zia9vSdN1eYd6qPP7yeRP/3zsRZjG31dY9XtXx
	vGB5mSr2NRZRHudoucWmOJCd3iNfgSDuOxi+GjPeo3hZZX67aabqTbSBigrYjyzxLOYUzZq7A/l
	lRA==
X-Google-Smtp-Source: AGHT+IH9/IqQ0n4glK+8yWKf23A1twiMsZDldRsgPGIb/MHEwwCKGhuF01gJnvQOeD8FNRnFNhEvPGJqnO8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1509:b0:dc6:dfd9:d431 with SMTP id
 q9-20020a056902150900b00dc6dfd9d431mr359086ybu.1.1712704482833; Tue, 09 Apr
 2024 16:14:42 -0700 (PDT)
Date: Tue, 9 Apr 2024 16:14:41 -0700
In-Reply-To: <20240315230541.1635322-4-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com> <20240315230541.1635322-4-dmatlack@google.com>
Message-ID: <ZhXL4aXU9HtDwYos@google.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Fix and clarify comments about clearing
 D-bit vs. write-protecting
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 15, 2024, David Matlack wrote:
> Drop the "If AD bits are enabled/disabled" verbiage from the comments
> above kvm_tdp_mmu_clear_dirty_{slot,pt_masked}() since TDP MMU SPTEs may
> need to be write-protected even when A/D bits are enabled. i.e. These
> comments aren't technically correct.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 01192ac760f1..1e9b48b5f6e1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1544,11 +1544,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>  }
>  
>  /*
> - * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
> - * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
> - * If AD bits are not enabled, this will require clearing the writable bit on
> - * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
> - * be flushed.
> + * Clear the dirty status (D-bit or W-bit) of all the SPTEs mapping GFNs in the
> + * memslot. Returns true if an SPTE has been changed and the TLBs need to be
> + * flushed.
>   */
>  bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
>  				  const struct kvm_memory_slot *slot)
> @@ -1606,11 +1604,9 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>  }
>  
>  /*
> - * Clears the dirty status of all the 4k SPTEs mapping GFNs for which a bit is
> - * set in mask, starting at gfn. The given memslot is expected to contain all
> - * the GFNs represented by set bits in the mask. If AD bits are enabled,
> - * clearing the dirty status will involve clearing the dirty bit on each SPTE
> - * or, if AD bits are not enabled, clearing the writable bit on each SPTE.
> + * Clears the dirty status (D-bit or W-bit) of all the 4k SPTEs mapping GFNs for

Heh, purely because it stood out when reading the two comments back-to-back, I
I opportunistically used "Clear" instead of "Clears" so that the comments use
similar tone.

> + * which a bit is set in mask, starting at gfn. The given memslot is expected to
> + * contain all the GFNs represented by set bits in the mask.
>   */
>  void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  				       struct kvm_memory_slot *slot,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog
> 

