Return-Path: <kvm+bounces-17644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF258C8A2C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C78481F286D5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6ABD13DB9C;
	Fri, 17 May 2024 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dv31S/Dr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7EB13D625
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715963749; cv=none; b=lxwLtG1QlZHLlBPaf4FOHSKaK1m2p5eUl1/8mFznKZ5xHrG8jBAWPZQhNDbjGe2pRHk9zr20QlVrmmEgPUwWYmRPPrPJ9BH/g8OCpjjDHx080p+VnGUUnNlKEa4JajFbpoEYk5/twbccewJw2RvBuzQMZuiSjTQuFF/ilg+P56E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715963749; c=relaxed/simple;
	bh=dn2I3QeRbGuLMznRZYnCEyYGH2dD0p7y71tzzAvSUAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A2R2Gg0OUrCPKQnMP28RI3+gAwt5peNZNLeIZ4JdanK/cg3ZIqGtM6F1ez+oEYZyn+kTkrqB0Ciwewz6O2+cFFRBKu0FpBspyDEJsnoDvs/2Luup9rq33lOlLIPpvzslujTLL/eswrgOVVEwyt88oDS1+s+55RInhqjR685O+mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dv31S/Dr; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627751b5411so54124077b3.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715963746; x=1716568546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYclK1Nqgk3C/otGfNkgx1EhBgjnWqPyonRkpKzx7A4=;
        b=dv31S/DrUXObWY1n2Q0p26lrQM9bkrds/KgMXPbneSy2IasR0Ke0rAtjyhV82S4gM+
         hhO/Q7xidKmR5eoc8p8Z24y7Zlo7dDiLZyk8xAiDJFVTUJe4+BOC65SfmJ9vPbVIa+DZ
         OcIQl0F1rOnk8pxJoTfPdeFl0mlWqwerNGEgj+KRaHKNNv+EVuWbwzMFI/NGGxBk93Sa
         hEDs03qI4d12o0LLsI7HpwmyYQgktEbjPKG2gjqR48CiRfX+ar7wQmWYERPv3nOkNVtv
         TtYL8O3iBrWtnx2zlDMlUZns3PJ2Ace4vSQTHSdjqrAaqmuQ+78ItNpkAJrtLSLQgx/P
         eTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715963746; x=1716568546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYclK1Nqgk3C/otGfNkgx1EhBgjnWqPyonRkpKzx7A4=;
        b=jz7h54cJNX21Cv8dzTBGVT5AmfizvgWwiyuDr0bv/s6HQoGHC0dPCW2sc7ed5CxLau
         GIlJaZ/CSJcfq8C5TWKsZiMygREYKUW90LnmgbfRlfxKAEkoJhzWgIuNgfADROVwC9Ye
         QKHjS4N1zdPZMxhgyYiJWwN3ibAbg+eDNqLTGh9WdszbH6V9S3dhLrMWfc4MkCMfI6jo
         EP+zMBRnwZ1jTjcAyYE5SuykSOrobTgjHc7ypexyURwAofPzWrxbbsZiAe1Y4q8H6K7d
         Nh+OgnX9P+WCqCSQ6HSdLuPreFR/xbaY8gWGUjsFCSf+bwHu29c7FKRi+fpAAw9NVWkz
         s3Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXQpB8KSQ+4sNSx1TS5gMbV06m9ivE7vfy1R/T4ZQ0S8MZWkb7i31X5bbNqIA5AFiJhpnnL4Kc+n7FEjm7VWtivGL8n
X-Gm-Message-State: AOJu0YzsF4oHeCbmoX75wc0JDqkQodDoekAuInjHjRmGvpk5GShyswIi
	hhIaYjHv+nYeHSUh3rV8TfP6Lvcu0GwWSOLdUd4GKMh1fkZBvAnSXcj2yna1vegAlXR0k35LgrM
	aSg==
X-Google-Smtp-Source: AGHT+IG4+t3aIHvGvVYY+Sa6msqPRgtSgUyf/2Km8yKnyWYTqfj5UbM9ztBh+9XSIrG3ntKnFDL+VhZdbrI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:149:b0:de5:5225:c3a4 with SMTP id
 3f1490d57ef6-dee4f304cb7mr5161352276.7.1715963746499; Fri, 17 May 2024
 09:35:46 -0700 (PDT)
Date: Fri, 17 May 2024 09:35:45 -0700
In-Reply-To: <20240517095649.GB412700@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240507154459.3950778-1-pbonzini@redhat.com> <20240507154459.3950778-8-pbonzini@redhat.com>
 <ZkVHh49Hn8gB3_9o@google.com> <Zka1cub00xu37mHP@google.com> <20240517095649.GB412700@ls.amr.corp.intel.com>
Message-ID: <ZkeHYUiVnFcv32wI@google.com>
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, May 17, 2024, Isaku Yamahata wrote:
> On Thu, May 16, 2024 at 06:40:02PM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Wed, May 15, 2024, Sean Christopherson wrote:
> > > On Tue, May 07, 2024, Paolo Bonzini wrote:
> > > > @@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> > > >  	if (is_invalid_opcode(intr_info))
> > > >  		return handle_ud(vcpu);
> > > >  
> > > > +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
> > > > +		return -EIO;
> > > 
> > > I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
> > > the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
> > > still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.
> > > 
> > > I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
> > > there's another bug lurking.
> > 
> > *sigh*
> > 
> > AFAICT, I'm hitting a hardware issue.  The #VE occurs when the CPU does an A/D
> > assist on an entry in the L2's PML4 (L2 GPA 0x109fff8).  EPT A/D bits are disabled,
> > and KVM has write-protected the GPA (hooray for shadowing EPT entries).  The CPU
> > tries to write the PML4 entry to do the A/D assist and generates what appears to
> > be a spurious #VE.
> > 
> > Isaku, please forward this to the necessary folks at Intel.  I doubt whatever
> > is broken will block TDX, but it would be nice to get a root cause so we at least
> > know whether or not TDX is a ticking time bomb.
> 
> Sure, let me forward it.
> I tested it lightly myself.  but I couldn't reproduce it.

This repros on a CLX and SKX, but not my client RPL box.  I verified the same
A/D-assist write-protection EPT Violation occurs on RPL, and that PROVE_VE is
enabled, so I don't think RPL is simply getting lucky.

Unless I'm missing something, this really does look like a CPU issue.

