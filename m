Return-Path: <kvm+bounces-33879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E467A9F3E00
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C368116A9F9
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C2E1D90A9;
	Mon, 16 Dec 2024 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rreLxLUj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819DE1C2443
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 23:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734390349; cv=none; b=QH77mwyo+kDp2mHk1cFdbtqlBE7qi1DdLQlWeh9Cw4H0dxoGSoZdPxILaBUKpT6E/XCAlLbvhiBQpSqw1FDH4rbNuox7syl+w/PtSfBfCoUPkfQmWsgiHeUgCLR11H4XC8vGFa5ELK6r0Mn3vPXGGgZw3jg0Sv4ndpYKvyB/4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734390349; c=relaxed/simple;
	bh=/CZU2qilU52W3Yy/AO6zdTEIKuU4RdrYP5QOXhyd4Ds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D4i/muWwGt/n1LojetBp2zzSNazaI/ESbJ3aU+7wRExkYT9vvGm/jrwaLb2edwknpqA5Ine1w03PBKb7Vp8hmCkfIXIpdexPvjXub7nilaBp9/Y6p/HYF7ku/uOLb7NxmxKCW2SDxJhiO1lw+t9Qae9E+Vqh/0NU/F6ahEurehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rreLxLUj; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725cab4d72bso3581354b3a.2
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 15:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734390347; x=1734995147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PPJ0WAdgf7OkLCa8bcCnWwCBX5F1e7NxMFOdjOrU2OQ=;
        b=rreLxLUjAFCkVhBYMjMkWDyyzgX5DQj8gaLJPBJ9F9VLOKfvHedkr42BK8J82ChEkv
         kTWiLSkqVyijsOYjhhzlDn82BKFZ80VwnXFrKsDgTKmhcDBNE0Q2JwsS7SbUaIbt71Bg
         o0BdX7UybBj+uhe6Kb8lTR/XLNgLWhWTPW4z/5oCnm8uVV06d5Ye8arms0MMH9GaB6gd
         0BKGEzEH+7fG1f5FvxU43ITMktRwBMCdHlFAzaFuq1ehhQy3QsWOOubRCC0qUhIAvsz6
         jpws9hVWf5Tt44NliuiNLEaVRs5M7vtSLDO/xrxdLgpHwh0mLhwRkQV6gieUHFGr25hW
         eq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734390347; x=1734995147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PPJ0WAdgf7OkLCa8bcCnWwCBX5F1e7NxMFOdjOrU2OQ=;
        b=odgHVyUvCbXgAxQn1fqHl6hPXtDNPrPyAa7AG7lp72PhPsNcvrkYQHa0rf+Na+/iym
         prgg7TqULtBw/gnKOZ8HFju+9I2sPPvj8Ol2Vzoqt8IEAQrrClZfjqj2SvzScz5GvonJ
         wj+kxBQyUc9NSD1kFp/gQSPoUi/OaWx3JkyYpMCs8UZWhahNYnovUkTVKzHqTZgl9gKM
         125wyUKF+M1//prKVcEp4O+hT7CVpINa89bQrBHTgbix4n61CuGfYctGrxA1+wwks/1q
         UCCQ2uq41RhCdgqfXexUZDvO/SBxrRtNvrPGH5hhwoKEnZ3/oWeI0oYLlGeQkFCrOKH1
         VIXg==
X-Gm-Message-State: AOJu0Yy8FoQsz7BaTAF616/5nag0szS8ed2Mw7yqbjaVu2B4lQh2zZBH
	fIpeHTJsyC72qrr1l9RKZ7sOMFlPFApxL5/iwepRigboPwwTgEH8/q1NRxiywvLAx0D2RhK9ZRW
	2jQ==
X-Google-Smtp-Source: AGHT+IEMZqtcQtp95LRMQYHysa5Xvsj6OG23GJvw2DUU0qnuBEdP/5dEVz6RoR8u71rW4iq3bNrPmEAD0Pg=
X-Received: from pfmx2.prod.google.com ([2002:a62:fb02:0:b0:725:936f:c305])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a11:b0:1e1:aef4:9ce8
 with SMTP id adf61e73a8af0-1e1dfe6a00bmr22630610637.28.1734390346831; Mon, 16
 Dec 2024 15:05:46 -0800 (PST)
Date: Mon, 16 Dec 2024 15:05:45 -0800
In-Reply-To: <8889dc3b-d672-41c3-8d11-e88861b7b38e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009150455.1057573-1-seanjc@google.com> <20241009150455.1057573-5-seanjc@google.com>
 <1baf4159-ce53-4a75-99bf-adf4b89dd07b@redhat.com> <ZwgTUNCOIh2xwU6e@google.com>
 <8889dc3b-d672-41c3-8d11-e88861b7b38e@redhat.com>
Message-ID: <Z2CySZTaW8CXPmEP@google.com>
Subject: Re: [PATCH 4/6] Revert "KVM: Fix vcpu_array[0] races"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Michal Luczaj <mhal@rbox.co>, Alexander Potapenko <glider@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Sun, Oct 20, 2024, Paolo Bonzini wrote:
> On 10/10/24 19:48, Sean Christopherson wrote:
> > On Thu, Oct 10, 2024, Paolo Bonzini wrote:

...

> > > > @@ -4298,12 +4299,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> > > >    	kvm_get_kvm(kvm);
> > > >    	r = create_vcpu_fd(vcpu);
> > > >    	if (r < 0)
> > > > -		goto kvm_put_xa_release;
> > > > -
> > > > -	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> > > > -		r = -EINVAL;
> > > > -		goto kvm_put_xa_release;
> > > > -	}
> > > > +		goto kvm_put_xa_erase;
> > > 
> > > I also find it a bit jarring though that we have to undo the insertion. This
> > > is a chicken-and-egg situation where you are pick one operation B that will
> > > have to undo operation A if it fails.  But what xa_store is doing, is
> > > breaking this deadlock.
> > > 
> > > The code is a bit longer, sure, but I don't see the point in complicating
> > > the vcpu_array invariants and letting an entry disappear.
> > 
> > But we only need one rule: vcpu_array[x] is valid if and only if 'x' is less than
> > online_vcpus.  And that rule is necessary regardless of whether or not vcpu_array[x]
> > is filled before success is guaranteed.
> 
> Even if the invariant is explainable I still find xa_erase to be uglier than
> xa_release, but maybe it's just me.

It's uglier, but has the distinct advantage of not being broken :-D

And while uglier, IMO there's value in having a way for fuzzers to test KVM's
online_vcpus logic.  As evidenced by patches 1-3, accessing vcpu_array[] without
first checking online_vcpus is dangerous regardless of how vcpu_array[] is populated.

Allowing fuzzers to trigger removal vcpu_array[] in KASAN kernels provides meaningful
coverage for that code (see Michal's original bug report).   While well-intentioned,
Michal's change in afb2acb2e3a3 simply blamed the wrong code.  Denying ourselves that
coverage and carrying flawed code just because the correct code isn't the prettiest
doesn't seem like a good tradeoff.

> The reason I'm not fully convinced by the explanation is that...
> 
> > I'm not concerned about the code length, it's that we need to do _something_ if
> > xa_store() fails.  Yeah, it should never happen, but knowingly doing nothing feels
> > all kinds of wrong.
> 
> ... it seems to me that this is not just an issue in KVM code; it should
> apply to other uses of xa_reserve()/xa_store() as well.  If xa_store() fails
> after xa_reserve(), you're pretty much using the xarray API incorrectly...
> and then, just make it a BUG()?  I know that BUG() is frowned upon, but if
> the API causes invalid memory accesses when used incorrectly, one might as
> well fail as early as possible and before the invalid memory access becomes
> exploitable.
> 
> > I don't like BUG(), because it's obviously very doable to
> > gracefully handle failure.	
> 
> Yes, you can by using a different API.  But the point is that in the
> reserve/store case the insert failure becomes a reserve failure, never a
> store failure.
> 
> Maybe there should be an xa_store_reserved() that BUGs on failure, I don't
> know.

I agree a version of xa_store() that guarantees success would be nice to have,
but I'm not exactly eager to potentially start a fight Willy *and* Linus :-)

