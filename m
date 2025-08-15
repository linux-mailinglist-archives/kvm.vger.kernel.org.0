Return-Path: <kvm+bounces-54814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D59B28857
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 00:24:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45F3E5A3767
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 22:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7319A263F43;
	Fri, 15 Aug 2025 22:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OcMzm3vG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB73B26CE10
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755296592; cv=none; b=pAa/KnZEwysBZovFkKgfjduHW0IyIQaON709q7hfM6PbYmRcM/60YRUDO26zhoVZ8hCYoo0F9FCIwT9tDLiNTtWIG0foi9X+uycBzIE5ERA0w4h6aHhCnHkd3idGMDXAP0uY7WeBbSUiWRgrJdr+iQb8YZExPtwdg2e4bxHwf+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755296592; c=relaxed/simple;
	bh=GNZlH6sJBFZUZvr4/euew/aNaJO1QMHCvlsJQkB/ZCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dPJSUmzo09mc6ouRLsV8z8wUEBCvFMC/ox0gqO+u4cHgePA8geZkzG/J2N088ft50m3JQxeUiYq+U5vjTwQvEsArErdZmYdASatywEZYWXuJaIpYjJ5tLkgUTo7LKi3q9YOv7LqGECZU5od3L1lqPZtP/qg9UKOgb8e/qoKr7Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OcMzm3vG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323266dcf3bso2188554a91.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 15:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755296589; x=1755901389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/L6vEYMs56+QFcZ6UdI2BHBFNkzvBUcTgCy/L2s9Wq0=;
        b=OcMzm3vGVhegW7T2Kce1Yl6zdCULumqtcjCK6M6503vv9S6gyCQYuCSY4DqG1uYoGR
         709T+wJf+9JajmVW5cICJaWXsEylIRovVVYrNDRRXJTOLoD9RG1youB7BidTM8aUzYnG
         i7F3TA3SA9BAJuzhJN0svO7IQV3VyhrDM6J3vjSJgOq1WD4s6FSdZ029i/fGMCHOLz1x
         uKQ+gdNnY8oDi239Ia9lMvgfo6kxlk0hsZdhliaeoGt04uTtGstzG5fDRCK0eRuqSxYX
         H3KpOfSAhgFNDSlTbjlm9plfAtHW5/d0jTGwksq8BnKX72Jb9WQPVL61RKXMZeA/gAUJ
         tAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755296589; x=1755901389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/L6vEYMs56+QFcZ6UdI2BHBFNkzvBUcTgCy/L2s9Wq0=;
        b=FnzQ68e+vwJHi2/rAIOiGB1jCsSVk9yXHidkrZKLDNgIfv5ActxPnMyBqT7I9eCyS+
         fEgQLmSSMHbs6tLOiZbUnwCMP+t8fGL2Ui5yE4lW7DoYjSZtksrvIJdkpkSfNeyvC4wD
         P6s6mBHK2xV78wAc5eUYTEtfyglXHkqw9tXF8UlmlSurEFKDIHo19rzMfd/Dcyoy1zTm
         SZYKQXNsv9wPiDLSZlGIDnU1ERuRfxeDpkiaM/gRMN4Me3f1K7cj37C5rBF9VxZIORrG
         QpT2+z/uNUWgX+MWS9s9xqxfFysAZqMLsv660j3PV7mYIXJia1BVjowRODYTPSzyw7Bx
         L16w==
X-Forwarded-Encrypted: i=1; AJvYcCWntZ9B8R51BEGbbHxbdbBdSq7fFb6r+xXTJhL/nDPQkeWAHOjj4eDttBozbKMmto9y5fo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+CJMM8RPq8+heZ90k918wwJZRMTAbTwobee0+d7YnWJIp2dJR
	+L22cRAOuabMy1xAhdwY5v8Fqym/aYj041n5pFtkCVYaU8R8EwU7FcICFfkhPgMutn9P/wOe0H/
	BaiS5+Q==
X-Google-Smtp-Source: AGHT+IHVWfs0mgpQqtSDpv//90E/3MvsdXYWajddu9pCfcnaEd2SsymQOZ5r4TSvSFwWMIM3mue+CCAq+L8=
X-Received: from pjbdb3.prod.google.com ([2002:a17:90a:d643:b0:31f:a0:fad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cf:b0:321:1680:e056
 with SMTP id 98e67ed59e1d1-32342190296mr5074940a91.9.1755296589049; Fri, 15
 Aug 2025 15:23:09 -0700 (PDT)
Date: Fri, 15 Aug 2025 15:23:07 -0700
In-Reply-To: <aJn_xYSweEauucGv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aII3WuhvJb3sY8HG@google.com> <20250724142227.61337-1-thijs@raymakers.nl>
 <2025072441-degrease-skipping-bbc8@gregkh> <aIKDr_kVpUjC8924@google.com>
 <2025081151-defiling-badass-c926@gregkh> <aJn_xYSweEauucGv@google.com>
Message-ID: <aJ-zS1vv-Ayv78Qd@google.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
From: Sean Christopherson <seanjc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Greg Kroah-Hartman wrote:
> > On Thu, Jul 24, 2025 at 12:04:15PM -0700, Sean Christopherson wrote:
> > > On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
> > > > On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
> > > > > min and dest_id are guest-controlled indices. Using array_index_nospec()
> > > > > after the bounds checks clamps these values to mitigate speculative execution
> > > > > side-channels.
> > > > > 
> > > > > Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> > > > > Cc: stable <stable@kernel.org>
> > > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > Nit, you shouldn't have added my signed off on a new version, but that's
> > > > ok, I'm fine with it.
> > > 
> > > Want me to keep your SoB when applying, or drop it?
> > > 
> > > > > ---
> > > > >  arch/x86/kvm/lapic.c | 2 ++
> > > > >  arch/x86/kvm/x86.c   | 7 +++++--
> > > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > > 
> > > > You also forgot to say what changed down here.
> > > > 
> > > > Don't know how strict the KVM maintainers are, I know I require these
> > > > things fixed up...
> > > 
> > > I require the same things, but I also don't mind doing fixup when applying if
> > > that's the path of least resistance (and it's not a recurring problem).
> > > 
> > > I also strongly dislike using In-Reply-To for new versions, as it tends to confuse
> > > b4, and often confuses me as well.
> > > 
> > > But for this, I don't see any reason to send a v3.
> > 
> > Any status on this?  I don't see it in linux-next at all, nor in
> > 6.17-rc1
> 
> I'll get it applied and sent along to Paolo/Linus this week.

I haven't forgotten about this, but I was out sick most of this week and v6.17-rc1
is crashing on my test systems, so I won't get this sent along until next week.
Sorry for the delay.

