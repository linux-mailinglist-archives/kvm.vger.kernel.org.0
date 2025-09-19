Return-Path: <kvm+bounces-58152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F46B8A0DC
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CD0C4E07CB
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 14:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D508E313E31;
	Fri, 19 Sep 2025 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GJuQwsn3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1D1243371
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293073; cv=none; b=NXp7H6eNBJcfxC72IEv2aN/v7qmGq/Vh6G4SWieJkzcaKUEPbMHe/F5oA2/l9gTmJHSzz4g2RltTCop4vyBaWZ5V/E/eTNF2lmJupgMpAONA8f9uMYI8pEajWx1hmYoQvRmFuD9l3H6kfvOQ5RTOeDYP7o5hRX8+lc/xtKAsmsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293073; c=relaxed/simple;
	bh=MUj53GleMCqeyfJjFbQ9TQUfYZaREMrgUs/wU8N2VTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fcokOE7xLvvTOzjdUpMmZ2sdErx7pzf2fdwD11/yPFOEIJYrwGa/PLyt6Fk+RNepi2pzQ+BhLvBWGLVR5IzsWxx9P0Tu1gMPANZobFNSe9T7WbO2bvEohwdW1jBzvjU0+gAoxqLinTO64TmxCzLecvUeZF6EmavB3gXnMELI7JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GJuQwsn3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24458274406so41235145ad.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758293071; x=1758897871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4jjvVkgxhUaeqBeONQFEa5pWQaTCfdaimymDJt0jOmE=;
        b=GJuQwsn3yiLEDCx7qH62k+49YtfC1BaobppZyZOBbmju4Vo5/86KIX08i/xQIyRfKp
         RdjELlpEKF3IieKX+uWkUUwL928PcxreoBdl1D82aH/Za0spI4NW5MCJW+bvhvVT/c4X
         mzXhvrzFX1IgslDWW6z5SuSvZnVbvUa7WYO5rWoo/1uA5y8j7BRQBj4VPzgVy/+qSpmF
         4CoR85jOrJJ0OQyHyMnrXVILiYcx/5JxNHHjYzvTQ39wsbTVGCZygEN/Rcl5HnOg7/Vh
         z9IJvAYsq+V2PkU9AArtaqSiX18WuA9PlSJG1IyrB0XZXjwV0JjXZiIMG7pkYnJSURsz
         Z0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293071; x=1758897871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4jjvVkgxhUaeqBeONQFEa5pWQaTCfdaimymDJt0jOmE=;
        b=VuaC72wxVL5TshnrSmCgBswrRbG9/3+jrwg8hveo3v0I5JdNEf0AQi5x6LahQEY9wY
         cte92wGlObLtqDYXeLOkNAvvEJC7uJiyFV7XP6BD8Opst54JeLdajzmW5m3ZjJK7f6Vz
         yW/okJoBvyx1DkiXcCYkqvszdN/aoMNxHDDcVccJhj15Tb6figAL4jG0a4cXr/pi1fiA
         JbMJ7URmrbNwDaNNx0673a6FAgH1wANS6hYZujWN45FktLmUSl3gDAvLJ7NHSghOqk1Q
         tqK0OHffNkh7rLxSbCoa9XWw0b2KznKUfGdT7bDFuHyrcaOC4LZoidXGMg6Odu3KCq/k
         Kueg==
X-Forwarded-Encrypted: i=1; AJvYcCV5y3uhMKhZP3+b1Ni6vdFS4UiXzatQGGzuR/2fXvt2sMxGUdTOv3TvggFC9QcLzGPDGss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yydzpijnh74pTVjApSmouYcu/pKcFg0EJA+XfEsdCn0suW886Z8
	utD6qU971CFAU9Vg9QBQ7+W5ekCDfPlRwOfjYNl9kkXgmQYqwZaRPnr0nKhzc8/gwbCGvqmbIQj
	wXk3vvw==
X-Google-Smtp-Source: AGHT+IEn8X8S7vgSHRiAQYwhDeWozAPVLoysbzfdeOtu6hQCaqgsUdc41VBhlqwjXMLIOm7dR99ZKzBuIek=
X-Received: from pjbqn15.prod.google.com ([2002:a17:90b:3d4f:b0:32e:aa46:d9ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c7:b0:246:2b29:71c7
 with SMTP id d9443c01a7336-269ba4804b7mr43995485ad.25.1758293070937; Fri, 19
 Sep 2025 07:44:30 -0700 (PDT)
Date: Fri, 19 Sep 2025 07:44:29 -0700
In-Reply-To: <73txiv6ycd3umvlptnqnepsc6hozuo4rfmyqj4rhtv7ahkm43k@37jbftataicw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com> <20250919002136.1349663-6-seanjc@google.com>
 <73txiv6ycd3umvlptnqnepsc6hozuo4rfmyqj4rhtv7ahkm43k@37jbftataicw>
Message-ID: <aM1sTc36cXIKxCDb@google.com>
Subject: Re: [PATCH v3 5/6] KVM: SVM: Move global "avic" variable to avic.c
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 19, 2025, Naveen N Rao wrote:
> On Thu, Sep 18, 2025 at 05:21:35PM -0700, Sean Christopherson wrote:
> > @@ -1141,15 +1149,9 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >  	avic_vcpu_load(vcpu, vcpu->cpu);
> >  }
> >  
> > -/*
> > - * Note:
> > - * - The module param avic enable both xAPIC and x2APIC mode.
> > - * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> > - * - The mode can be switched at run-time.
> > - */
> > -bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
> > +static bool __init avic_want_avic_enable(void)
> 
> Maybe avic_can_enable()?

That was actualy one of my first names, but I didn't want to use "can" because
(to me at least) that doesn't capture that the helper is incorporating input from
the user, i.e. that it's also checking what the user "wants".

I agree the name isn't great.  Does avic_want_avic_enabled() read any better?

> >  {
> > -	if (!npt_enabled)
> > +	if (!avic || !npt_enabled)
> >  		return false;
> >  
> >  	/* AVIC is a prerequisite for x2AVIC. */
> > @@ -1174,6 +1176,20 @@ bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
> >  		pr_warn("AVIC unsupported in CPUID but force enabled, your system might crash and burn\n");
> >  
> >  	pr_info("AVIC enabled\n");
> 
> I think it would be good to keep this in avic_hardware_setup() alongside 
> the message printing "x2AVIC enabled".

+1, looks waaay better that way.

