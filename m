Return-Path: <kvm+bounces-24940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 427BD95D60E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 21:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73ED428585D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E9A1925A2;
	Fri, 23 Aug 2024 19:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sn3Q9POA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBCA8F6B
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 19:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724441264; cv=none; b=gWMA7oUDe5CYRTa/8nvOkKYcVu1+uolYVOj+0FxzuIn9pf7Sa966yDkFwW8ukVVwud3uEqTi+C6/k0gKkV72uzhPf9e8kSzWKhw+Qd0zo/gg03ZjmNmRl9CIciudqsDZJYqMsi+FfV+ysyUuvNznPNMwEFTR0fan9zFL7P9drsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724441264; c=relaxed/simple;
	bh=IxXH4yqEjBZYuKr0LQyjuOrlrGfwNdQCl7HuhZAk8I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNW8f5yxq/vAVEOUktLHi4wK1kfipnKELIb/EyEUpGR2EVExIxbnBzgVAZfijJ51srtuke3Ftu4TI6uNiqFgK2djoDYKFjJzpoTBgrjiWoSBwZ9zNaqYDo6NR+QhYJJa/OZ5oXQxehgnB0u/o7bLumiAt+xly5LbDEpkaAvwjEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sn3Q9POA; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20260346ca1so34515ad.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 12:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724441262; x=1725046062; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sW/KIdWg4GMnaTZlrBgO/OACPZTU5MORyHXW0t4xnM=;
        b=Sn3Q9POATvJhNwGCtjnZBlidT6sN/gsnvDPhUvQEcPWt1F8WJzRtArmpsjg7Wm+GmU
         b9waVWo9alYbkk1Wma9Fr2d4iiylsMohINBAkrN20DTVV4UJ/05JI+t/+AxPd/5qrwoI
         ZL1UAVqkIqTbHg+qzhCfYenZgYATdb6YpF7PcRqS6L9JBV2VXrjOZqri1bF/WTteI94x
         Bfxgo+U/28BHZFQafJEM0Lad8eXq3fjmyUeVuVL2LPeF39JJrov1gV18sylu3i7HBAQt
         EJ3BMW7jLv8Ks6afbJMdWL0ZhNNqX6a92IJc+GzJsIBeZgXYOW0nMpXhhUOftuXRwa9L
         FL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724441262; x=1725046062;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sW/KIdWg4GMnaTZlrBgO/OACPZTU5MORyHXW0t4xnM=;
        b=Krx45akKyiKD82Hue4ylM6Cl6qE3Io9mqiI/iFJHJhFwsQe43593/5v14hdO8fACbc
         WIplEytWYUQ+5aAR9Td5HNXBbitvqW8hbhYR8w/6euMOVeFJcm0AXz2g7FEovZ4lirql
         4kNv7Zmeqha8qmBweANzF2s5l+DMoz11OqlfJrZpeLNCLX7j0VBR/hC4dqYrPA/2go/N
         FM7PEOVzqp+x9qQAQmbDKKq8QZTWevZdOn4SVvXG2I4Ddt5OhE2o0IxQK+NSdx7d5H0x
         CKZ9L6Jmy2CWwYULEBVdPM0402MARD4tI1E41HU4U99Q3wOgsA7F6NA6VwQp4TPPIoyS
         B7eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeaKqPeEyq9q1yLqyxvAQ1SC8BMSvtOJNKhbPoYQ6Xbw333jn0L28/eYkiumzoLfvOcm8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzgjw8SprOzirG96sE9zhxOB44bQhrK8+Ez9bd2BK48q1lONGET
	75ibNu4UEzzXqbsTQD8SQPOpzmvYuk+rcTT9Tto+JrNv3vKempMghE1Pv68G2Q==
X-Google-Smtp-Source: AGHT+IH8Yu9URYCV6GYm8RY+OUmJzjfJGuB6x/nQyDb2ooK2vE1LzL3Z3soPgmQw8zCzlltDiQ8Tzg==
X-Received: by 2002:a17:902:ec92:b0:1fb:2924:5c7e with SMTP id d9443c01a7336-203b2f3678amr333135ad.11.1724441261846;
        Fri, 23 Aug 2024 12:27:41 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9ad6e563sm3569519a12.81.2024.08.23.12.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 12:27:41 -0700 (PDT)
Date: Fri, 23 Aug 2024 12:27:36 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
Message-ID: <20240823192736.GA678289.vipinsh@google.com>
References: <20240812171341.1763297-1-vipinsh@google.com>
 <20240812171341.1763297-3-vipinsh@google.com>
 <ZsPE56MnelsV490m@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsPE56MnelsV490m@google.com>

On 2024-08-19 15:19:19, Sean Christopherson wrote:
> On Mon, Aug 12, 2024, Vipin Sharma wrote:
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -817,9 +817,11 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> >  	rcu_read_unlock();
> >  }
> >  
> > -bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> 
> At this point, I think we should rename this to tdp_mmu_zap_possible_nx_huge_page(),
> as I can't imagine there's another use case where we'll zap a SP starting from the
> SP itself, i.e. without first walking from the root.
> 

Okay.

> >  {
> > -	u64 old_spte;
> > +	struct tdp_iter iter = {};
> 
> Rather than initializes the on-stack structure, I think it makes sense to directly
> initialize the whole thing and then WARN after, e.g. so that its easier to see
> that "iter" is simply being filled from @sp.
> 
> 	struct tdp_iter iter = {
> 		.old_spte = sp->ptep ? kvm_tdp_mmu_read_spte(sp->ptep) : 0,
> 		.sptep = sp->ptep,
> 		.level = sp->role.level + 1,
> 		.gfn = sp->gfn,
> 		.as_id = kvm_mmu_page_as_id(sp),
> 	};

Okay.

> > +retry:
> > +	/*
> > +	 * Since mmu_lock is held in read mode, it's possible to race with
> > +	 * another CPU which can remove sp from the page table hierarchy.
> > +	 *
> > +	 * No need to re-read iter.old_spte as tdp_mmu_set_spte_atomic() will
> > +	 * update it in the case of failure.
> > +	 */
> > +	if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
> >  		return false;
> >  
> > -	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> > -			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
> > +	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
> > +		goto retry;
> 
> I'm pretty sure there's no need to retry.  Non-leaf SPTEs don't have Dirty bits,
> and KVM always sets the Accessed bit (and never clears it) for non-leaf SPTEs.
> Ditty for the Writable bit.
> 
> So unless I'm missing something, the only way for the CMPXCHG to fail is if the
> SPTE was zapped or replaced with something else, in which case the sp->spt will
> fail.  I would much prefer to WARN on that logic failing than have what appears
> to be a potential infinite loop.

I don't think we should WARN() in that scenario. Because there is
nothing wrong with someone racing with NX huge page recovery for zapping
or replacing the SPTE. This function should be just trying to zap a page
and if that didn't suceed then return the error and let caller handle
however they want to.

NX huge page recovery should be tolerant of this zapping failure and
move on to the next shadow page. May be we can put WARN if NX huge page
recovery couldn't zap any pages during its run time. For example, if it
was supposed to zap 10 pages and it couldn't zap any of them then print
using WARN_ON_ONCE. This is with the assumption that if more than 1
pages are there to be zapped then at least some of them will get zapped
whenever recovery worker kicks in.



