Return-Path: <kvm+bounces-54412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F664B20C24
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 16:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11C591893F98
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 14:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F354253954;
	Mon, 11 Aug 2025 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTXG7RBb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082392D3735
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754922953; cv=none; b=ZmyW0QximBjFJEhUKNCLFvX5fgAvCNXbpHD6Hfmz0KxBJIZbc8mK5CHd0ILineml9VwGDAcrbPl/zCcRJsu/SjXp9/klC59XPSRcO1I6a+bAvNlMOb6uwHSTlu2QHx6F5lrin6Qhjx6ZSjWLztYWwUQV/8Mf6r/ctj9BIxm77Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754922953; c=relaxed/simple;
	bh=Zg2aUIdWgLRM/ZDQm/OXL79EtzSUG8Mhzf8uAeX7TGE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DbI8084vEmGhS91HCbnHG+ByA54kzv6nDij7yGEwuP8ZbSckZRlM6s4u3nGmp/xVX0yNqTI+MFx343elakA1eu+gaFOssl9R3WeOFDZ/oESNIY7qaBAgM4iLEU6FukFIiCe3aJe5Lfo8fOTgSIZNLF+H6Uj9U6O5ZBlP9/AWSJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTXG7RBb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f32271a1fso5812228a91.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 07:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754922951; x=1755527751; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZP6ZO0fHZJ9zRjj/9Uq+YjEREw70zRgUoUlMarb0f8Y=;
        b=GTXG7RBbBRAynKGqErMBbT/wANAgG9DVBbHL9Wa1E4VxucMg0Yj4QakfkFWxIZkUJY
         xJdIpod1mZdLNCGhoU93Y3iG7HLeXsZOD6ivylxnWsH4GDmDq2T4ZL4NFr8KtlXD9ETd
         AQgAj8/BZ2kCCLHGBmHbbN37OzvUDBhPhMaUepgL4NW+gUbQ0yn0jE1Ib/WuPPhIUBcm
         BgMhswTZrryY2wqM3be5kWtVIwomUSymcEX8Llz3nSkrPbtsIJcj49eiRrvffxL7ZyUs
         6RuFY+NHVfBiNHLPooY2vDWP4Zd+Lw55YHCNDT/fIbScnNZSXL578+O4S90I9jue2nGM
         wz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754922951; x=1755527751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZP6ZO0fHZJ9zRjj/9Uq+YjEREw70zRgUoUlMarb0f8Y=;
        b=KEGMYnJRIR/CLsSyuBs++5JadTf+dlCgAW4YHBGPSocg97q5feKm54vInfaxtwUpyT
         LhP1i1FEysZtP+F8g77+OAS0Ck0LFc5culaD6lkz1+Pa8MftrygS7lSkC/3ibOzD8tYA
         lzU5G+qNxqraTTneEHhq2PRZY3l86a6eb4CcriwXTl7epXGi7ESlD1S9waZI3nH2eFHo
         Jyvk86IyVW7w0Etwzeb8dXngQGGE3oI4rHQT9fXnPjGcSIA2b2VOLZfjzhtcmh1Ue6QG
         gzb0z8Nq8QY74FNn0rmCPAowd3+cK/rVtFPbyDAw69D4S/Rl2lb78vROx3BYOazcq94X
         aqlg==
X-Forwarded-Encrypted: i=1; AJvYcCXOJ2uHQ+mT0qcYgUpMklRUyHDYFhCgc/6JkmxnBK/iazr7pftP3MRqPNKHnyb5USuqn/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI/hEL2ZogaKMKxdfJqbTcQsyEff4A+evxLTsfDnSzrxUaaK7n
	zRHQpM7AFFEML+fyaV/NgarnobaIDDLbsQjELW+cI2cx7SQ+DvFgwyL+pKHnHJSYB+TvhMAIwqZ
	e/+hGaQ==
X-Google-Smtp-Source: AGHT+IFij9Nt5QAKYlT8XkR3okPv1FV8h6qONZok1V7RA/0du/2W8giV5AGspo4pJBdOgqLYnRhDdDp62Dc=
X-Received: from pjl11.prod.google.com ([2002:a17:90b:2f8b:b0:321:b969:1e5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d87:b0:314:2cd2:595d
 with SMTP id 98e67ed59e1d1-321c03095cbmr159795a91.8.1754922950984; Mon, 11
 Aug 2025 07:35:50 -0700 (PDT)
Date: Mon, 11 Aug 2025 07:35:49 -0700
In-Reply-To: <2025081151-defiling-badass-c926@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aII3WuhvJb3sY8HG@google.com> <20250724142227.61337-1-thijs@raymakers.nl>
 <2025072441-degrease-skipping-bbc8@gregkh> <aIKDr_kVpUjC8924@google.com> <2025081151-defiling-badass-c926@gregkh>
Message-ID: <aJn_xYSweEauucGv@google.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
From: Sean Christopherson <seanjc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Greg Kroah-Hartman wrote:
> On Thu, Jul 24, 2025 at 12:04:15PM -0700, Sean Christopherson wrote:
> > On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
> > > On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
> > > > min and dest_id are guest-controlled indices. Using array_index_nospec()
> > > > after the bounds checks clamps these values to mitigate speculative execution
> > > > side-channels.
> > > > 
> > > > Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> > > > Cc: stable <stable@kernel.org>
> > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > Nit, you shouldn't have added my signed off on a new version, but that's
> > > ok, I'm fine with it.
> > 
> > Want me to keep your SoB when applying, or drop it?
> > 
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 2 ++
> > > >  arch/x86/kvm/x86.c   | 7 +++++--
> > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > You also forgot to say what changed down here.
> > > 
> > > Don't know how strict the KVM maintainers are, I know I require these
> > > things fixed up...
> > 
> > I require the same things, but I also don't mind doing fixup when applying if
> > that's the path of least resistance (and it's not a recurring problem).
> > 
> > I also strongly dislike using In-Reply-To for new versions, as it tends to confuse
> > b4, and often confuses me as well.
> > 
> > But for this, I don't see any reason to send a v3.
> 
> Any status on this?  I don't see it in linux-next at all, nor in
> 6.17-rc1

I'll get it applied and sent along to Paolo/Linus this week.

