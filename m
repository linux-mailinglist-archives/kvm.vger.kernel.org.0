Return-Path: <kvm+bounces-67187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FF8CFB5C9
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 00:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7ECD530935FF
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 23:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CC930171A;
	Tue,  6 Jan 2026 23:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Jacduat"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30C476025
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 23:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767742741; cv=none; b=M9mTXkS5Gk6dSEGs+VONpXWFY1qi0OLsj7jDih3vlpwnwXPdEf0JyQILZEPqTBqpQkjLn7X1aguIMi928m2jffefwgcT40S9Tz/1ZCWw+dgPH6ninCy48lEk4+xkACch0EUdIDt3VEq/IihisYCXgb42V6yAHR9fLS+JlmNJUK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767742741; c=relaxed/simple;
	bh=WTJU9b8VejX4pR7UB4F0/aOzL0mji0Tdt5825ZEHoE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TddAIPIpf827nRUwkOvhDedYrAApuTK0kqN6S7Isvxu4ZLfaMBiacggsM+Pb0RgqeRctLXlr7IbhYo1T+dB0RFVlQFqMHhzQFeN6YMBf95wrIegdGl++FMkrANdqNxmxFWfL5zkZja7/fV4gr/YtuxM0Ruh3Ah8GmPAAWQnv5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Jacduat; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f25e494c2so2909265ad.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 15:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767742739; x=1768347539; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1jLe8ybjebTXBAl7a+rRc0OaBnzlDZTtyJM7a0ly/E=;
        b=2Jacduat0nS1qUknA1KS23jQqfQyTmd2Ha1dMjFqY8Fjr5QUm3z7k3Ge4OU/mHSXP7
         QWt/3iMtd6BbKX9jr/gh2Ba1IoVRzxDLHHAj6TsFPgfUGF3j/njBw+ncb1zlBE1HgKxh
         1t2rdGoYpTrQH1pwYte4RZYDPTCCQE2tN1NNnksg3KTJlpni5iUId/Gc0PlxPFlxvqi7
         Q+ixKAOvJkxZDIVyAzY61fQSOyKZGGyUm6eapnB3dTDmzQy0odz+ddD13q2gknUrbXR4
         Iy4wCLrlleXS0mF+9kXG70/6iUQWgG2TYd+7hY21NNci6VihamvDGZ/AJmv631OD7TDO
         WcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767742739; x=1768347539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1jLe8ybjebTXBAl7a+rRc0OaBnzlDZTtyJM7a0ly/E=;
        b=w3nhtahedLFJAcD1cM022jk61low7cVNsh9UbfS1dN7z71mn8xZ5IERvA2PCnuYNiU
         wRQPY1GhUsVflgy1UNbMMvzCCg7LGYCKKdkHNNGUnJTAzLK8edhtJsy5mtu8eMF4DmjM
         jHafeT72EoBKLMJhCG0js88EWeIt4zkWvVJzOmbfSQj0inrf27b2nTZiKonmZ91mT/gT
         V1w48s8OvSAc9mqrrxyITugAtiHTz73QTEPjzRqrYMMExuUVcdmnPF9xqIOQXVnk83Ql
         iyjqBrIJ+foakbP8ruA/Tfm8xotNSXHLxN4PeiKB23Suve9cDZ2Hahv/H7S6oqE4VjQ8
         QPCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmyxHrneUqbTcqC+WOdOOxCdhaIWEUwUwi/5bjTH2FqgSHNfjRkgTjwJUrYkRtCuqUMbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCejKl7m2pRKssar29crEZZEt3kFMetxqo9xqYizdHV05Lew7q
	4EQpFpfHZHZnwfGIJ3574TCYoMzSi5lwktQzIcHlFLJKQ0i+xnRDz9AiAWZJwEFJ6dH3n8m9E6y
	vZCT3mw==
X-Google-Smtp-Source: AGHT+IGrd0cFMyk0bafvh7/4bm0POWNIvR79189Ny+lzxKJul2sigwq1Wyjef3D8hqgu9VzI6T5gWBsc8e8=
X-Received: from plhw11.prod.google.com ([2002:a17:903:2f4b:b0:2a0:f83c:bb4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3508:b0:2a0:a33d:1385
 with SMTP id d9443c01a7336-2a3e39d7c25mr39388425ad.17.1767742739237; Tue, 06
 Jan 2026 15:38:59 -0800 (PST)
Date: Tue, 6 Jan 2026 15:38:57 -0800
In-Reply-To: <pbbfdqgd7vu6xknmrlg6ezrbhprnw42ngbkp7f55thxanqgnuf@7l4fkbrk7v76>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106041250.2125920-1-chengkev@google.com> <20260106041250.2125920-3-chengkev@google.com>
 <aV1UpwppcDbOim_K@google.com> <pbbfdqgd7vu6xknmrlg6ezrbhprnw42ngbkp7f55thxanqgnuf@7l4fkbrk7v76>
Message-ID: <aV2dEWVolv2862-D@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Yosry Ahmed wrote:
> On Tue, Jan 06, 2026 at 10:29:59AM -0800, Sean Christopherson wrote:
> > > +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> > > +{
> > > +	/*
> > > +	 * If VMMCALL from L2 is not intercepted by L1, the instruction raises a
> > > +	 * #UD exception
> > > +	 */
> > 
> > Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavior.  And
> > IMO the most notable thing is what's missing: an intercept check.  _That_ is
> > worth commenting, e.g.
> > 
> > 	/*
> > 	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> > 	 * and only if the VMCALL intercept is not set in vmcb12.
> 
> Nit: VMMCALL
> 
> > 	 */
> > 
> 
> Would it be too paranoid to WARN if the L1 intercept is set here?

Yes.  At some point we have to rely on not being completely inept :-D, and more
importantly this is something that should be trivial easy to validate via tests.

My hesitation for such a check is that adding a WARN here begs the question of
what makes _this_ particular handler special, i.e. why doesn't every other handler
also check that an exit shouldn't have been routed to L1?  At that point we'd be
replicating much of the routing logic into every exit handler.

And it _still_ wouldn't guarantee correctness, e.g. wouldn't detect the case where
KVM incorrectly forwarded a VMMCALL to L1, i.e. we still need the aforementioned
tests, and so I see the WARN as an overall net-negative.

> WARN_ON_ONCE(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_VMMCALL));

