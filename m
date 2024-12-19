Return-Path: <kvm+bounces-34096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 276E39F72BE
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0975C1888FF1
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AC986327;
	Thu, 19 Dec 2024 02:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gPfxqSt7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6805D477
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575973; cv=none; b=FGlh3ZYGYzXR9zu5SSaw4e5TiCF0Otf8mX666Mw4pRKqnU76ueqkT6mYVoMasgZTYyZAIRJZ7N87pTDXqdCCnCVat6+409mkXTnwBC9GYsX6EtymdP2PVnK2eEtRVmOZszTqHYsAAEI//ZsVclAPqdWjFO9/McGooVeYGT1S3p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575973; c=relaxed/simple;
	bh=Xh0rRgh/7wTx9OjJbX6VMZNNlvLeBESz6cghvubzIN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mkG9ZLALHEIHmcfv/KP0RpnSKWZiGCrce0MqnEVVsRTtjHM/OZKFR5Th+ShseAWAXoMgMe9rXTPlMDWRS8qsDGQq1UPPHAUea4hM8MIb9qncShcKrwrbqkmPlPAGX7gjrPhctXAlxO/CDl1q4GKoWaY4TXTSEAXgkoG7h/ILA/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gPfxqSt7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216405eea1fso3329245ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734575970; x=1735180770; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HHYSbe9XQeZJstEpYH57Z9R8AR6J6LY/n+7Uz7s2cjk=;
        b=gPfxqSt7gCm/K+DeOXqKCugyYmTfCcYFXa4KP6ot8aFka4a10+Fr3hpaqdF2Lkbrgp
         +zg7Vh5GqXHoMkt1eyrlh5Kr+9oxJLwMVIPxLgqj7qm1EbAXnkRDLfZpfu4qpM8VDgVX
         mWBLDREpqMUgrHM1c108e4IwHPSLsc4AlUPqV+7rsvsUQuX3HlhCHb4tJzU7nkZ4MeuE
         5GGjk0d9nyiP+8QiX0w18waLU/ExU05bQt5/jCpP1vf+IXyVKGskPnqdnKYTcBfydXFa
         Vpi4aNly62aWPdyHJlpRuxs/xe2iCLC98AR/tozJe2zdBSFY3AAk6dGy0jS2vGCHb9/X
         BvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575970; x=1735180770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHYSbe9XQeZJstEpYH57Z9R8AR6J6LY/n+7Uz7s2cjk=;
        b=DKRwLxLSmfeCHRaISjWrjkGvPi75LbNg0m0TAe4rv1TE1TavfKtU2HKZ26ldLj0tuX
         KFmPrOMVSlGMT6ZswCwNNmdTbWqYndEN0BEQ7Hd7TiJf9k4XD2m4qXY+YM6vKi2ldcWU
         FLnzs26uZ2IximToCjYNy/n7VK5w/HG809U05H3pD1VT/rFvAMZYA/1y4WeWnivuEuww
         /Ur5gcyxhqoZkEmt+1E+FYxEoXaPFASn9/7TKUBsFLN+Fx2FIBvf8bPdq8jlc2O9RvV5
         /elBP0ZYg8ee5CZJWiyvGnhG7cGg79xLxOohnAzFq4RAxuPBTqVomNs+UwfB2RGhUNCI
         aNyA==
X-Forwarded-Encrypted: i=1; AJvYcCVsyNEe8q+3x8Dy9QaLQEn4PQ8Ow7wKWgQzGHYlPLICN0S74bt2PLFibybHhogmFW7d8vI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO2ME2MI4B5S+1gFaM6tia/avwV//n/dr9SH+e4R1jqrXzqNmi
	ULBo9yQZs/LdwTKIlVRIlQ2VwnVZsQ9+xo6cDxxvTf3LR5x+2UL2ZgyfBXbpptuE+479Im5Om0f
	8Pg==
X-Google-Smtp-Source: AGHT+IHj8XfMyZosspL2p28bl03iG3qIPDqUHcjBsXSpFYg/u147eJg72V6x67HacWjUgwfmDcZPxQb4Wd4=
X-Received: from pjbsd6.prod.google.com ([2002:a17:90b:5146:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecd1:b0:216:2804:a241
 with SMTP id d9443c01a7336-218d7269e2bmr78557255ad.37.1734575970540; Wed, 18
 Dec 2024 18:39:30 -0800 (PST)
Date: Wed, 18 Dec 2024 18:39:29 -0800
In-Reply-To: <Z2N8bl6ofE2ocQsW@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121115139.26338-1-yan.y.zhao@intel.com> <20241121115703.26381-1-yan.y.zhao@intel.com>
 <Z2IJP-T8NVsanjNd@google.com> <Z2JhXfA14UjC1/fs@yzhao56-desk.sh.intel.com>
 <Z2L0CPLKg9dh6imZ@google.com> <Z2N8bl6ofE2ocQsW@yzhao56-desk.sh.intel.com>
Message-ID: <Z2OHYWZeHeKMHfDy@google.com>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 19, 2024, Yan Zhao wrote:
> On Wed, Dec 18, 2024 at 08:10:48AM -0800, Sean Christopherson wrote:
> > On Wed, Dec 18, 2024, Yan Zhao wrote:
> > > > Anyways, I don't see any reason to make this an arch specific request.
> > > After making it non-arch specific, probably we need an atomic counter for the
> > > start/stop requests in the common helpers. So I just made it TDX-specific to
> > > keep it simple in the RFC.
> > 
> > Oh, right.  I didn't consider the complications with multiple users.  Hrm.
> > 
> > Actually, this doesn't need to be a request.  KVM_REQ_OUTSIDE_GUEST_MODE will
> > forces vCPUs to exit, at which point tdx_vcpu_run() can return immediately with
> > EXIT_FASTPATH_EXIT_HANDLED, which is all that kvm_vcpu_exit_request() does.  E.g.
> > have the zap side set wait_for_sept_zap before blasting the request to all vCPU,
> Hmm, the wait_for_sept_zap also needs to be set and unset in all vCPUs except
> the current one.

Why can't it be a VM-wide flag?  The current vCPU isn't going to do VP.ENTER, is
it?  If it is, I've definitely missed something :-)

> >         /* TDX exit handle takes care of this error case. */
> >         if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
> >                 tdx->vp_enter_ret = TDX_SW_ERROR;
> > @@ -921,6 +924,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> >                 return EXIT_FASTPATH_NONE;
> >         }
> >  
> > +       if (unlikely(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap))
> > +               return EXIT_FASTPATH_EXIT_HANDLED;
> > +
> >         trace_kvm_entry(vcpu, force_immediate_exit);
> >  
> >         if (pi_test_on(&tdx->pi_desc)) {
> Thanks for this suggestion.
> But what's the advantage of this checking wait_for_sept_zap approach?
> Is it to avoid introducing an arch specific request?

Yes, and unless I've missed something, "releasing" vCPUs can be done by clearing
a single variable.

