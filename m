Return-Path: <kvm+bounces-40074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 372A4A4EDEB
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 20:54:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 884AC1735FC
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F2525F979;
	Tue,  4 Mar 2025 19:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y3vm450d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15041FFC5F
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741118041; cv=none; b=K3mKHovbhxmZjgiCQhNAmj4kF1aXir2aFTpsPITgtQt7GsEqnfH7DCtiJPKTnLFDFHeYKKsQ45GDVwR0VJO2qxJpohXX9LHJobltirQggWi9VieTZdEes+Tz9pHxK9D+gbObAClgwyTMRfnIbnfIR1/WEq+JMrqg2Ervdx2LlIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741118041; c=relaxed/simple;
	bh=h0QmsF5WjU8uUwJMDtkw5V/S9XuBsfrGQ8xVySEL8cg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gGGwkX1X8Y26KilKdRr2IePERzSY2HZuOgVKowFig0YtopF5mibN7yDyTA1slFiqpW7bLiZBIarDxUoEMp35T84iBqINpXfBYYqwLM1KCTrtuCyJzIL7VL9ZXu7BgS0bFaVs6orOltnFfBYQ1QPYRSAwQ1IkLkZtrnphOb7MbuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y3vm450d; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f816a85facso11472565a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 11:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741118039; x=1741722839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FcX8s6TGQjn/ciNyOtVkHsyvdW8iKLLpE8U6tntEZos=;
        b=y3vm450dWDHQJv0jDxz0YiC2xJ8SSdhIHBNjbGQlIn4Zf/G5k330KdRIARzT3kA+LO
         DxwFErOXEltPNFjAttYipAKkA7d5kfEKFtU5fPxB8krnyUizvUv5wJF27toki3zJkz+b
         NZifndeodY1TAQQqDTAYoZiq0quv2zgzmwbNvk8uxWT2IeGulK2l8NeQPvxOSeM85yX/
         QFxMApcuvuY18/z5bRSTlJS50oDvjaZfdOYuxlv5GleEIFqfd72hyew/MX7P219yOkCO
         tkiur2Mu0o9ILzUDqRco67769pvTcUnpOmT47gnyRacKyXOMZOusgpUcn6VAzuqVgcNp
         Fgsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741118039; x=1741722839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcX8s6TGQjn/ciNyOtVkHsyvdW8iKLLpE8U6tntEZos=;
        b=IY5qcLmsUU1EixZSQoxtOgOnAxWqJ+1C4f0xkp/glr7YUtxk3R08YfFBPMIATVnsBB
         mFUScBbHCUYp8Y/wyTtKICiI4tGT+2wkGrkCVCFKtAAUVyNHVi/rnbzq0QrFm6PSOj+V
         yCbRuJLJSH6ZWIuVn2qaaBe/n6tBCJwWiEQYYsTp4QSj8fMWkvc/kGo3KLwqy9MMNpUp
         BBXcjY8abg/lptpdIKzmxgH/4PgHXTF9rZ+/zLv2w54y2DARMfxjnX3fpaDedSDhU1HX
         NuAN3N0+Xob3ALVRYqEQeE5TWGRMUXu3nVABqJgbfXre2G0vqe8fS0Q62gXeJ/povKHf
         JWwA==
X-Forwarded-Encrypted: i=1; AJvYcCXN9/1YKxtzamNSqkNASqghxZY7Nmmb3YocbFx3VIYm11VmvzLlw4dP+C6GSKnEZzY1B9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWBzWkF+X7NeQJw8/QajeCtTpuoizzh820rGSAPZdV8yIjWs3h
	h2eQxQ1DO9U6o8uoKkY4CP/TaM+CfyZZGUT5rtL/s+A1VejA70H/94eI8c9I/4bPDsrkIokHIsu
	IFQ==
X-Google-Smtp-Source: AGHT+IHOGmjXt5qX0JwYqHXuRcMAyZDKrDodX6geowjqs/tfeTheYOjqw3n3RYRUFrP2O9PpebVhmR1sgYI=
X-Received: from pjbsi3.prod.google.com ([2002:a17:90b:5283:b0:2fc:2e92:6cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f06:b0:2f5:88bb:118
 with SMTP id 98e67ed59e1d1-2ff497eb7a6mr724027a91.22.1741118039359; Tue, 04
 Mar 2025 11:53:59 -0800 (PST)
Date: Tue, 4 Mar 2025 11:53:57 -0800
In-Reply-To: <42035a43-660c-4d38-9369-db824e271671@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241126101710.62492-1-chao.gao@intel.com> <Z0WitW5iFdu6L5IV@intel.com>
 <Z4HI2EsPwezokhB0@google.com> <42035a43-660c-4d38-9369-db824e271671@zytor.com>
Message-ID: <Z8daVRCZjNTxLATy@google.com>
Subject: Re: [PATCH v2 0/6] Introduce CET supervisor state support
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, 
	dave.hansen@intel.com, x86@kernel.org, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org, 
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com, weijiang.yang@intel.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 04, 2025, Xin Li wrote:
> On 1/10/2025 5:26 PM, Sean Christopherson wrote:
> > On Tue, Nov 26, 2024, Chao Gao wrote:
> > > On Tue, Nov 26, 2024 at 06:17:04PM +0800, Chao Gao wrote:
> > > > This v2 is essentially a resend of the v1 series. I took over this work
> > > >from Weijiang, so I added my Signed-off-by and incremented the version
> > > > number. This repost is to seek more feedback on this work, which is a
> > > > dependency for CET KVM support. In turn, CET KVM support is a dependency
> > > > for both FRED KVM support and CET AMD support.
> > > 
> > > This series is primarily for the CET KVM series. Merging it through the tip
> > > tree means this code will not have an actual user until the CET KVM series
> > > is merged. A good proposal from Rick is that x86 maintainers can ack this
> > > series, and then it can be picked up by the KVM maintainers along with the
> > > CET KVM series. Dave, Paolo and Sean, are you okay with this approach?
> > 
> > Boris indicated off-list that he would prefer to take this through tip and give
> > KVM an immutable branch.  I'm a-ok with either approach.
> > 
> 
> Hi Sean and Boris,
> 
> At this point because KVM is the only user of this feature, would it
> make more sense to take this patch set through KVM x86 tree?

Which tree it goes through is largely irrelevant, it needs explicit acceptance
from the tip tree folks no matter what.

