Return-Path: <kvm+bounces-43368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B29DA8AA88
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 23:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CEF93B434F
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 21:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083AA274FCF;
	Tue, 15 Apr 2025 21:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GmRThp2T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E642A2571BA
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744753966; cv=none; b=eQRzCjPY4jRg7exlp4CJJwRdwrNwNUUFDuM3+TiRhGTXutCSAJH06Vry/VT+cTMbRpQrANI29SDbFcTirwZSZI/SkIjZxr7QmOa8vc0tEFkA4zNCryEjhxKG6zLB6ppTl2aRJrK16aYfSGDUFQZKEuowKUI3Bf+174ZGC+KAmxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744753966; c=relaxed/simple;
	bh=RB9DkFDjFYaAz0XoV8GvJIl9KPIPe0zT4OKarjuneSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gRD60Eo5YhGtMExD6fFkoGtka41QSv0UKcb6wl8t5++7zUciLC2wWlAkFUmgjNUmOznlo0Aw+mgY7q/Ot6EAJQkeW5Awal2bDGU6wg8YHQOLDaCwSN48+Lr+1jDW/Nl2ltcJrrAxSndnrM3teV2efLVa7y6d6WEA2IPFWWU59ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GmRThp2T; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso5997075a91.0
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744753963; x=1745358763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sEakkyYbkL3hmGVUI0s4nR0ZmkUz+iNkcqjHnh41YfA=;
        b=GmRThp2THo8Hz51D2fHGmhCEZIMSEk1bfZfkbcXROXrxi92YJepOQ9ACdmb6Pq0a4q
         otPd6j61CQpK9CXUFZ23HVB2vmMCh/4eKp1w69LLw3eXjhwTm3H9wqwLHgc2FbIEfbfv
         BMw01lFYZrqIEaTdopOZNnlspU0lj/HW5PCGO88A6u3JBiI8MzpYEHi1oJf0OjejWxgF
         3maVlMVCLxNcvAmEWwo5+8QnC6JSEwNlA8Zx4RuUpfpS6t2gl9t5XoApdIePwmacWxpn
         Sxgagi6B5mJtK+GRe/DlgLAJdv0CS00LFAM3ef9kNSAqRqxrXwibOik/sB3vhhzffJ7j
         pzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744753963; x=1745358763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sEakkyYbkL3hmGVUI0s4nR0ZmkUz+iNkcqjHnh41YfA=;
        b=jiQxuWFx9ls1eUMRS1SVXwURLc9QnofFYsNegbvBS3NzAECcq2l9HyJpSd4+K1LJq7
         cTooclS2ahTuhSWAwZZbojz/sF8Rln/6tCivgsvRBwfgSIcwoobxFfEMet5K3ed8i0/B
         SijiWTMW9TxUDVmGspNYqIrikXoCg0pQpZ8zU6odECeOYTIGvli8GcjK/rLk6JPxaTje
         d16RTJ1KGH5lg1/jbK+UZHXI4Kqi2I9MpvrcuY1j/R3t6zA6tPPZGBV7dAMR3wlYZzPm
         YNMpjZFJ32ouv2Bn/3BZbBkfp5YbY3LUcXhpUPLB3WfJo3f2rHlZmtIZtcXV772osYTB
         1nTw==
X-Forwarded-Encrypted: i=1; AJvYcCWE4fqBXpDUeqn5iUfmHDaqr3RnRjMmj1Gh8Ph4ExwhgSsiMJpfe2zadavDGQn2ttF4PQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuLe12po9k+h/lo0aYiECP1TBhndX1IljuF20TqyFcYS06YzzM
	phdGsZ3q62O1VU8IVK9cPCU1gVM1SCYN300cYU3/G4QS5eDvobl5bMFlZZvlFDEzE61ZdVcjpiY
	nfQ==
X-Google-Smtp-Source: AGHT+IE5X1SEViPqpTe89vzn6EtzphukY6AvSLniOTlThnRLrJgSHxS02dH03m+qXPZkT33RR5rviIXHEb8=
X-Received: from pjbok14.prod.google.com ([2002:a17:90b:1d4e:b0:2ff:5df6:7e03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da87:b0:2ff:7b28:a519
 with SMTP id 98e67ed59e1d1-3085efefbb2mr1188859a91.30.1744753963182; Tue, 15
 Apr 2025 14:52:43 -0700 (PDT)
Date: Tue, 15 Apr 2025 14:52:41 -0700
In-Reply-To: <20250415200635.GA210309.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com> <20250401155714.838398-4-seanjc@google.com>
 <20250415200635.GA210309.vipinsh@google.com>
Message-ID: <Z_7VKWxfO7n3eG4p@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Defer allocation of shadow MMU's
 hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 15, 2025, Vipin Sharma wrote:
> On 2025-04-01 08:57:14, Sean Christopherson wrote:
> > +static __ro_after_init HLIST_HEAD(empty_page_hash);
> > +
> > +static struct hlist_head *kvm_get_mmu_page_hash(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	struct hlist_head *page_hash = READ_ONCE(kvm->arch.mmu_page_hash);
> > +
> > +	if (!page_hash)
> > +		return &empty_page_hash;
> > +
> > +	return &page_hash[kvm_page_table_hashfn(gfn)];
> > +}
> > +
> >  
> > @@ -2357,6 +2368,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
> >  	struct kvm_mmu_page *sp;
> >  	bool created = false;
> >  
> > +	BUG_ON(!kvm->arch.mmu_page_hash);
> >  	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> 
> Why do we need READ_ONCE() at kvm_get_mmu_page_hash() but not here?

We don't (need it in kvm_get_mmu_page_hash()).  I suspect past me was thinking
it could be accessed without holding mmu_lock, but that's simply not true.  Unless
I'm forgetting, something, I'll drop the READ_ONCE() and WRITE_ONCE() in
kvm_mmu_alloc_page_hash(), and instead assert that mmu_lock is held for write.

> My understanding is that it is in kvm_get_mmu_page_hash() to avoid compiler
> doing any read tear. If yes, then the same condition is valid here, isn't it?

The intent wasn't to guard against a tear, but to instead ensure mmu_page_hash
couldn't be re-read and end up with a NULL pointer deref, e.g. if KVM set
mmu_page_hash and then nullfied it because some later step failed.  But if
mmu_lock is held for write, that is simply impossible.

