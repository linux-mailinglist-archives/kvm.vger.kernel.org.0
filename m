Return-Path: <kvm+bounces-43735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCA7A95A24
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 02:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 825577A8A6B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 00:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8EC175D5D;
	Tue, 22 Apr 2025 00:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nJtply7p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D246756B81
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 00:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745281472; cv=none; b=Z9X4o4FymKrIofIhAlTv7vgsSZIcneqWx44bHwsZcym/xkTQQpzsPFVrDwGBuHjt5TPXEVjYMtohU2xFsMMmnVozsm46xfp7P7G/ZBYzrhTSipyTpSMViT3uqrglgSlWtVJaK9IMxXF5URaydqt2oXIO9stzmeYyRixONafJE6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745281472; c=relaxed/simple;
	bh=seKhfN+lIcgtz1j3ejpF+U+pNMyG75cEZU4MRUl3spk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CgvVFGtH3vSQm4bvE8GRe9YpSMppeyuYJXifiR6OUDkKB+hdumn58i29pJfasvPOFizS+ZKAtQFhelvDP61worYCENTNfZAQUUgen0BwmfVxzkLB+T334HKZ/K2o84LHLptitzxhdTFB8N36Frb+D/4+Qx6IwnFhyVqMwZqwZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nJtply7p; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736cd36189bso6018461b3a.2
        for <kvm@vger.kernel.org>; Mon, 21 Apr 2025 17:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745281470; x=1745886270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SMviy5+kOGRvpsxzIcn2E2CvZk5Y/HComOdf4ewswVQ=;
        b=nJtply7pLN1Ue7dzgQsIMNiOdxYX3GFthHrIQgExgWVZm4+fUrX6c7+YJ1pCXt3C5+
         aguLLqa53Fpc0Gewc7/uHf0polbkOImy3hPYTf7qebURLimzssyXJ4uZUy6GFuc8Sa8v
         r3npMRobu4YLtDhZpEvaYSEC9/6TsjAgEm3Wh93au2uMVx2xPingYb6AWvd8ElVB/HHK
         Ygr+gDeYaPlQxvtn8HWPBanO05RGKasQz8D/ZKcR/alD8OiuUZqCI/WkPUXU2uJSe8Rt
         fahi7K8JwO8x4tUQp4DWEZtorLE2ScKmWHo11pl9R4QRDAcl0wWKYoEhpKZqwGG/ckIW
         iGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745281470; x=1745886270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SMviy5+kOGRvpsxzIcn2E2CvZk5Y/HComOdf4ewswVQ=;
        b=ToH5xXSHSLRzikGfQ+4XiNoEqi24ZVbYdGaOTQvGOeMzDfM4ikZCQgIdfvl8Q84KjJ
         4W2aLnrq9EstJxWUR5Vo/gIcS7/mzT1AIijX6xfQWtImzKpt0KS33iH9DIyeYqvWFT7b
         avLjp7Pc2PaVPceBeavnswwhOG1VKv7rqwctQ+0t3u/lSIPEdI/8c0EkT4q1VKDqKAXk
         q4SFWX+FB8IPuaht2UYdyhMe1rTXgo8pzh4tP5InqliMarI25om5Oyl1rtsAKLPmQeWK
         /22O/bXr61TC7NMYVrgGH3uzETa6BTP1/b9hXyj8dtAboQuEPnuUCEl9PDXhse1i+mwN
         tRuw==
X-Forwarded-Encrypted: i=1; AJvYcCXjMcsJGK5fAoD2WcbjKNEzE69qpU9bszBI+dF7vP9VG3Jcw14CoxzgJKCE0KGrA9geG88=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHDl459nwkGc/4+foLdFMUwZ42yobY2MMw//5asTm29sYI81wU
	mfyBWZH/X5jrnTAo6NCsd8zt4Gksv5CeHbs6nRFm577whG7llzHmg4D46tPy38yzUBDHUbu6lWD
	BpA==
X-Google-Smtp-Source: AGHT+IE+k74Qv8xNJI5yuUCUNvrDG4g/fwCOOnIFv35QesHxpUhWzYA0SeHmlnpbDxqeT+CNnDn5wg1xEmU=
X-Received: from pfat15.prod.google.com ([2002:a05:6a00:aa0f:b0:736:415f:3d45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a81:b0:736:5545:5b84
 with SMTP id d2e1a72fcca58-73dc14536b9mr18602088b3a.3.1745281470085; Mon, 21
 Apr 2025 17:24:30 -0700 (PDT)
Date: Mon, 21 Apr 2025 17:24:28 -0700
In-Reply-To: <Z_7VKWxfO7n3eG4p@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com> <20250401155714.838398-4-seanjc@google.com>
 <20250415200635.GA210309.vipinsh@google.com> <Z_7VKWxfO7n3eG4p@google.com>
Message-ID: <aAbhvKa8g973-lV6@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 15, 2025, Sean Christopherson wrote:
> On Tue, Apr 15, 2025, Vipin Sharma wrote:
> > On 2025-04-01 08:57:14, Sean Christopherson wrote:
> > > +static __ro_after_init HLIST_HEAD(empty_page_hash);
> > > +
> > > +static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
> > > +{
> > > +	struct hlist_head *page_hash = READ_ONCE(kvm->arch.mmu_page_hash);
> > > +
> > > +	if (!page_hash)
> > > +		return &empty_page_hash;
> > > +
> > > +	return &page_hash[kvm_page_table_hashfn(gfn)];
> > > +}
> > > +
> > >  
> > > @@ -2357,6 +2368,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
> > >  	struct kvm_mmu_page *sp;
> > >  	bool created = false;
> > >  
> > > +	BUG_ON(!kvm->arch.mmu_page_hash);
> > >  	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > 
> > Why do we need READ_ONCE() at kvm_get_mmu_page_hash() but not here?
> 
> We don't (need it in kvm_get_mmu_page_hash()).  I suspect past me was thinking
> it could be accessed without holding mmu_lock, but that's simply not true.  Unless
> I'm forgetting, something, I'll drop the READ_ONCE() and WRITE_ONCE() in
> kvm_mmu_alloc_page_hash(), and instead assert that mmu_lock is held for write.

I remembered what I was trying to do.  The _writer_, kvm_mmu_alloc_page_hash(),
doesn't hold mmu_lock, and so the READ/WRITE_ONCE() is needed.

But looking at this again, there's really no point in such games.  All readers
hold mmu_lock for write, so kvm_mmu_alloc_page_hash() can take mmu_lock for read
to ensure correctness.  That's far easier to reason about than taking a dependency
on shadow_root_allocated.

For performance, taking mmu_lock for read is unlikely to generate contention, as
this is only reachable at runtime if the TDP MMU is enabled.  And mmu_lock is
going to be taken for write anyways (to allocate the shadow root).

> > My understanding is that it is in kvm_get_mmu_page_hash() to avoid compiler
> > doing any read tear. If yes, then the same condition is valid here, isn't it?
> 
> The intent wasn't to guard against a tear, but to instead ensure mmu_page_hash
> couldn't be re-read and end up with a NULL pointer deref, e.g. if KVM set
> mmu_page_hash and then nullfied it because some later step failed.  But if
> mmu_lock is held for write, that is simply impossible.

