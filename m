Return-Path: <kvm+bounces-11774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B52387B5FA
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 02:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3182C287697
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 01:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7894A0F;
	Thu, 14 Mar 2024 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yt8914Mx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA2FA31
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 01:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710378063; cv=none; b=U6qPHBZVkjuW1QR9WOPu3dDmhKamJlkfo6SiiBGtqsz+xD1aAhZJZ657kGvjM3pv+yjKOQ9aWp2GfjrElW2sxWhQjjJEsnLynz1NLxuRY9OKjTqoj42P/km9OtMAcp0fyzdNWOL1U7G2dkLhbfgK2DgKg5h38fmfNNSQO0LcmvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710378063; c=relaxed/simple;
	bh=NtwzHxfvcWxMXOxe3H7rgf2iCheFJhPEn3nXY32Pjhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fA0JVbcxArsvIItHkzI6fZ4H2w4apKWkc2PrNp9Ewfn67Ldw3+nt2T7902ZSoBKXJGXh2awzZ2ttRdouyasSH5WDKUWfHBSwnbIBuzOMnTHSkQutzCJU+y/W+WPGJVuedzybGxMoSNaoOO1pDF9rG6JL3DbTxxZ2v/3dE0Oqu7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yt8914Mx; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1dddb2b6892so4197265ad.0
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 18:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710378061; x=1710982861; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EQTEleojd5viC5A5AYPDJGsPN8oibgqc8we/hfPKc/g=;
        b=Yt8914Mx/Z008O2vqdUZNVCsGtKS/7PS2CZvijIf7Bx1B0nFV/Qie5c881omHU3CIF
         zrATxNMpvcuDCCvhuu1TXIfVQMB14NuqyVaDQUKtTyfpzFB0MMRWs1U6tozy1rhGNOvp
         no9gVVlG/X5Af5M9OA5x5Mp1YLzinElxmWgjvGUoLooRAAcDQD5ILoeEYG1eayRvL6o3
         5xFAfTSmKeq/lWSCvRYjLNf67K6iddCIkKOsx4BaK4sAlzgoRUoBqE8nkgiZuwUT3ebG
         0NJPHY6LgEhcMLANfLZQ/A4dPOZXWm9B0KOPYWtkD36WhLeyTqhbbxRMES6pC40k63Pg
         GdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710378061; x=1710982861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EQTEleojd5viC5A5AYPDJGsPN8oibgqc8we/hfPKc/g=;
        b=VZgcb627pXP+b0KqI5ZEpcvHVW6pxGDMYQS5qU3oaelaBjQ4g9fRQFZuEKyS3BasfF
         +lkXHExAzxMwGt0CLNqQwmrnHCICvMrlRg8l0z448xC+66GXJcZQzQsntEqgBGVfXQun
         TM8kHkB4aSdY6HE2w+DhEoKUPuDupgV+v69eTyOpyuRIJZPKG2jx7OfOHCaubdOFskkS
         HX6We5JyY2Sb+IrDZ0RZyVeNKBZTd4u6hj66LcJv4xkas0gYk32XCIUSO6tOf5bvx7MD
         WPapVmdlmw5He/VhDMkGEOprC4ruhaJP+nD34lWSt1wg4LckNjq6anQ3AHPO5wdKFKHp
         v/CA==
X-Forwarded-Encrypted: i=1; AJvYcCVa0p2hc8sBTmSfCGJYNhMNOnydsKeY4KmQcsiXQKkYDld4hzg2n0UeOBkHPs3pVvJeZfGZuLYOsAga2XmAJEcJoflX
X-Gm-Message-State: AOJu0YzTYflI7bA8a9hWT8nLhcIKR0upgfVNdHsFprX05hWCqsxoFGyV
	wu+k++SYJtxtMzqcmabJ/al21ka8CcPqW2tUlqWy3g5nFUSchCktzgD+ni2jRu9e/gbbetr/3fk
	Y/Q==
X-Google-Smtp-Source: AGHT+IEbfpQupzITGwOB3jYT6JWViwHBjL3w3EJsB6cDh5GZAUKltsAsyIQL3Y7yOWKCB7t0jXD1dXx+/7k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1dc:b333:f2a4 with SMTP id
 d9-20020a170903230900b001dcb333f2a4mr1246plh.12.1710378061383; Wed, 13 Mar
 2024 18:01:01 -0700 (PDT)
Date: Wed, 13 Mar 2024 18:00:59 -0700
In-Reply-To: <ZfJA3AaLga5OXoL1@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-6-seanjc@google.com> <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com>
 <Ze-hC8NozVbOQQIT@google.com> <BN9PR11MB527600EC915D668127B97E3C8C2B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfB9rzqOWmbaOeHd@google.com> <ZfD++pl/3pvyi0xD@yzhao56-desk.sh.intel.com>
 <BN9PR11MB527688657D92896F1B19C2F98C2A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfFp6HtYSmO4Q6sW@yzhao56-desk.sh.intel.com> <ZfHBqNzaoh36PXDn@google.com> <ZfJA3AaLga5OXoL1@yzhao56-desk.sh.intel.com>
Message-ID: <ZfJMS9ac-MA8mV9u@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rcu@vger.kernel.org" <rcu@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 14, 2024, Yan Zhao wrote:
> On Wed, Mar 13, 2024 at 08:09:28AM -0700, Sean Christopherson wrote:
> > On Wed, Mar 13, 2024, Yan Zhao wrote:
> > > > We'll certain fix the security hole on CPUs w/ self-snoop. In this case
> > > > CPU accesses are guaranteed to be coherent and the vulnerability can
> > > > only be exposed via non-coherent DMA which is supposed to be fixed
> > > > by your coming series. 
> > > > 
> > > > But for old CPUs w/o self-snoop the hole can be exploited using either CPU
> > > > or non-coherent DMA once the guest PAT is honored. As long as nobody
> > > > is willing to actually fix the CPU path (is it possible?) I'm kind of convinced
> > > We can cook a patch to check CPU self-snoop and force WB in EPT even for
> > > non-coherent DMA if no self-snoop. Then back porting such a patch together
> > > with the IOMMU side mitigation for non-coherent DMA.
> > 
> > Please don't.  This is a "let sleeping dogs lie" situation.
> > 
> >   let sleeping dogs lie - avoid interfering in a situation that is currently
> >   causing no problems but might do so as a result of such interference.
> > 
> > Yes, there is technically a flaw, but we have zero evidence that anyone cares or
> > that it is actually problematic in practice.  On the other hand, any functional
> > change we make has a non-zero changes of breaking existing setups that have worked
> > for many years. 
> > 
> > > Otherwise, IOMMU side mitigation alone is meaningless for platforms of CPU of
> > > no self-snoop.
> > > 
> > > > by Sean that sustaining the old behavior is probably the best option...
> > > Yes, as long as we think exposing secuirty hole on those platforms is acceptable. 
> > 
> > Yes, I think it's acceptable.  Obviously not ideal, but given the alternatives,
> > I think it is a reasonable risk.
> > 
> > Being 100% secure is simply not possible.  Security is often about balancing the
> > risk/threat against the cost.  In this case, the risk is low (old hardware,
> > uncommon setup for untrusted guests, small window of opportunity, and limited
> > data exposure), whereas the cost is high (decent chance of breaking existing VMs).
> Ok, thanks for explanation!
> I still have one last question: if in future there are CPUs with no selfsnoop
> (for some unknown reason, or just paranoid),

Don't jinx us :-)

> do we allow this unsafe honoring of guest memory type for non-coherent DMAs? 

Hmm, no?  AIUI, the intent is that all future CPUs will support self-snoop.
Assuming that's the case, then I think it's fair to put the onus on Intel to not
have escapes, i.e. to not end up shipping CPUs with erratas.  Then, if an erratum
does come along, we can make a decision, e.g. allow older CPUs by default, but
require an admin opt-in for new CPUs.

But let's just hope that's a problem we never have to deal with.  :-D

