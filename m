Return-Path: <kvm+bounces-30204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7459B7FFA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:24:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 656E5281F7F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B63A1BBBE4;
	Thu, 31 Oct 2024 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdI0nsKZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A76A1BB6B5
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730391874; cv=none; b=dFNbhTHShYce+1B2skYSYyeOMyzxR9XLa8BOcNfPABcbgvKR+/O2vKFzQIkEGrAqG/Qn1JDH+9Bl+wbGpRFH8XK0VPFQ1b+SA4+8pYZXL1nn1l5fDJ8tXX1sZDvfNJlZWoDX+eDLFDYDn70xbqwMBMXWT5tOtk+VC98KzOVf86Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730391874; c=relaxed/simple;
	bh=FghgVU+wo6hSEkFStLS26KZednPLjsA4abe1oslZ5QU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SGjenDlxrFe4T4K5t/mM/0Dbxfg97drYhFHRd8To2Ktj9rqEfdwXT9uAU95i8ZkzTDbOS9IvClJR1kcNg8xL9CY+SaxK96mFel9BYAgH31f5fsmHLjbEkcgpRa8S8kmCKzWe42xBndEnYCCtmzi1rqg9v2xV3kvxdP5hAevf2P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdI0nsKZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29205f6063so1714020276.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 09:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730391871; x=1730996671; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8lqAqnn2lvPMme1U2y97a/HFiMtT0KQ6DEfhQX5Zr9o=;
        b=QdI0nsKZ9n11B6jYDmO2VHBrQXBebmKJ51NkbrrQEe5zxf2vEj9kmRuxh3Ke4cttiG
         FyHorAmJJLVT26dGYPc0VlIw0iv9FBsiHR7Mge/FrmEtXIqlIS6RMuMAG3v67TJVKxUQ
         WjXVHfNssmi74L5s0cc0LBn7JVJPZcBITYVH4TkmPPNvJx4icD4zD2DtD79O2QOnHbH4
         AdFfsrIq1ajncs4tXvVn6bLfIT75PryRFRfnPCNL9Ova1HFRcWPkDihaibwm7qg2ALE7
         c3ugDYZ5KwNDj2suDDcXszaU61gQr6SVuZedLPCx/52nHSsintIxBQrx4qpbsgVR624Y
         LNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730391871; x=1730996671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8lqAqnn2lvPMme1U2y97a/HFiMtT0KQ6DEfhQX5Zr9o=;
        b=bA/Ua71DBwddtzDRr/Xq14AU10yvpDLVEQLLM46jOkiqZwbLXZXqzE2qhsBh7LpAxU
         XtNMt5+a0kE5QfcHP99CPTTSK/XjHKm6lFGv2fk/ItTEQvtjsWJ7Qd7aS2BnyolhTBTb
         /f74pIe2pXDvimGcav4Q6NGIU9ax1hhm+feuikta+ZAMyTbNI/J8VbUuDydBd36PRcaH
         pMq+VGr6/1b2xRCzTimN8mucPZ12lrYWN3mHUxwDmEq6aUkiudBNus6pVmZkzN606oEB
         2jGEygofaJSvqcT8B945Z0SMTkpMoBZ/JAWou3/bq2YAosqJCtAAZkijG2C1IpNtjve0
         qvOg==
X-Gm-Message-State: AOJu0YxutB00Qkj/WJWc2wYVh2MuCGB3fYrYRrIlxkNnviQcYpVSH6uO
	/1mXmmoldtAOKKFIfGNB9omZOG7u6GVtHl4ADDw8z8k19hqe3EwMRhjooAHlIleQBegzW9JnPMp
	aYQ==
X-Google-Smtp-Source: AGHT+IEB483F5Zv9v+Z746MDaIVcz0jHusWl9dOWUZtSjSpIQ4oyN0kiaMgf5YNfjCgBqxpSevXF29Athqg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:bc0a:0:b0:e29:1893:f461 with SMTP id
 3f1490d57ef6-e33024354e7mr1591276.0.1730391871427; Thu, 31 Oct 2024 09:24:31
 -0700 (PDT)
Date: Thu, 31 Oct 2024 09:24:29 -0700
In-Reply-To: <Zxf4FeRtA3xzdZG3@mias.mediconcil.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241018100919.33814-1-bk@alpico.io> <Zxfhy9uifey4wShq@google.com>
 <Zxf4FeRtA3xzdZG3@mias.mediconcil.de>
Message-ID: <ZyOvPYHrpgPbxUtX@google.com>
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 22, 2024, Bernhard Kauer wrote:
> On Tue, Oct 22, 2024 at 10:32:59AM -0700, Sean Christopherson wrote:
> > On Fri, Oct 18, 2024, Bernhard Kauer wrote:
> > > It used a static key to avoid loading the lapic pointer from
> > > the vcpu->arch structure.  However, in the common case the load
> > > is from a hot cacheline and the CPU should be able to perfectly
> > > predict it. Thus there is no upside of this premature optimization.
> > 
> > Do you happen to have performance numbers? 
> 
> Sure.  I have some preliminary numbers as I'm still optimizing the
> round-trip time for tiny virtual machines.
> 
> A hello-world micro benchmark on my AMD 6850U needs at least 331us.  With
> the static keys it requires 579us.  That is a 75% increase.

For the first VM only though, correct?

> Take the absolute values with a grain of salt as not all of my patches might
> be applicable to the general case.
> 
> For the other side I don't have a relevant benchmark yet.  But I doubt you
> would see anything even with a very high IRQ rate.
> 
> 
> > > The downside is that code patching including an IPI to all CPUs
> > > is required whenever the first VM without an lapic is created or
> > > the last is destroyed.
> > 
> > In practice, this almost never happens though.  Do you have a use case for
> > creating VMs without in-kernel local APICs?
> 
> I switched from "full irqchip" to "no irqchip" due to a significant
> performance gain 

Signifcant performance gain for what path?  I'm genuinely curious.  Unless your
VM doesn't need a timer and doesn't need interrupts of any kind, emulating the
local APIC in userspace is going to be much less performant.

> and the simplicity it promised.

Similar to above, unless you are not emulating a local APIC anywhere, disabling
KVM's in-kernel local APIC isn't a meaningful change in overall complexity.

> I might have to go to "split irqchip" mode for performance reasons but I
> didn't had time to look into it yet.
> 
> So in the end I assume it will be a trade-off: Do I want to rely on these
> 3000 lines of kernel code to gain an X% performance increase, or not?

