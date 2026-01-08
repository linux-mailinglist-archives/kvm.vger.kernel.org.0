Return-Path: <kvm+bounces-67490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE55D066A0
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 23:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3F7C3026536
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 22:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D322D47EF;
	Thu,  8 Jan 2026 22:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sdkPgPYT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC02219EB
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 22:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767910645; cv=none; b=o+TpGC3g47I7XwGOaTnqdMufN5QtnYFinUMpJ02AjzlZKqTGz5j9VE5VAr6Q8jvff4VmO50f6e6oTFQjsIcTBJeMebpp88tzZxzYdKx7XIfIysA0/acW0rMDXiiUim/IG2LeDFvKZZV1KjCr039p2R6YZE5Uj09YtBssLq3FguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767910645; c=relaxed/simple;
	bh=kGtIyrozfErdkkp8yatgyuEMfGxbnG/eJ0Eg4bIJqas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tZv9j7tFL5Mxg4ok7fMWKhLrhqvOUKLFX6IBNGMJ0F2vyh4I5GYbEDJKFmnkM5bEjPRlhcZkpEUf0S9aCyRh2PSbGOtMU0mnNa8aHQ4XdtuNOMkhOQRZ1PNqpEL+U5GrfIHIF7aT/eGuCbDjStnZi4s5EOvNjPko6iwH9eVwA1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sdkPgPYT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d43fcb2fso77840195ad.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 14:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767910644; x=1768515444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oX0bkmnPVOAK4yukHCtxtzEmrtPV4mhJxow2A9Nc6IQ=;
        b=sdkPgPYTfsxqh3iHXsq5wrQ/Egs0R31yb6NENIvVr3UPdw3Eb4ZiLI+LocoKsyZDbL
         nYudO+FvHDGYt9qOoMmKj80LIZ2XXJ6HpGwe93iy9oYvrz+5DQewnwUc7Uq5Oj0bnor4
         JXtphOlkcEPpG5X+dXYKGwo8gPbiRRSJShxjnJF59xsvFZqHDuH/RWaFApsqysRozZNb
         BxQtXFdT+09SZPWkZ9QjXKWJKTczfT3HBs/Cy57oqo0zi0CgXxtrDViBoJK47p6rND2R
         kWD4s6Kg6aCxSY3AIIYIAaWFEZMzOHW9PFUIP6exCfZGDZXFwDiAmS9b21f/e8Vv+gqU
         8AcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767910644; x=1768515444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oX0bkmnPVOAK4yukHCtxtzEmrtPV4mhJxow2A9Nc6IQ=;
        b=tqlp6Qv4F0HFNN+OWtMMjmvcus/eLToXC7DyYN8ZbA5vcpe1UayDfaSM8dg2eP0h5H
         I8YU9UFMmLezONCEOywV2UO+FTEVLogdY62DcD9z/GKXm6LoHYV3g7okBblS69kFazRF
         BLyfzR69xJJH1NSCrgXKq0fUjoPt8yjA92j2eAjjbRjsDWO1Mfw0L8vhvLWJ87po2DI7
         E036wfmj1EzvUN/r6J4RDI/KGjf5PJ4+JbJlhiStVOHZ7epKXG6O8zSAwWO/ugpK2xnA
         QLpDccYtFBW+M3pFZ94Bgb/ZjzVUfGyFIj/6UePB9ZfOs4xlh+O3mREYsojpE8vCJ57n
         lKkw==
X-Forwarded-Encrypted: i=1; AJvYcCUAcoIkJD3M/m7IvmvBlTYGVz/GA6MKAjv/bZTrau66rVwK85YZDaQttNhaqiyvDzuyx8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YztpkFsLGFdncYgTh98fVSqRmJNCGuIKyVzscP3RKniQDuHy6qN
	OW8+yxO68ayoU4ljSeTSQViGayD4j+i9+wDpxf1zXsdDtMepX5MfLFWakytsf1xVfXFgi5yfQ3s
	QiWRszw==
X-Google-Smtp-Source: AGHT+IHBPQPVdtqOzZVlwV2MFsxhm6DsSl3Eiuip947UQeWs/gCMNAAUq1vwfiXrUcABp9WPpgsMGngD7P4=
X-Received: from pjbfv11.prod.google.com ([2002:a17:90b:e8b:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a122:b0:384:fa66:c1a
 with SMTP id adf61e73a8af0-3898f997599mr6687544637.48.1767910643892; Thu, 08
 Jan 2026 14:17:23 -0800 (PST)
Date: Thu, 8 Jan 2026 14:17:22 -0800
In-Reply-To: <6ilulzhszphdjk3ta5jt7t222jicn3zj5e6em3fknzmudeqr3f@dogx6h7lsrax>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
 <20251121204803.991707-2-yosry.ahmed@linux.dev> <aV_-YLO4AVQc-ZmY@google.com> <6ilulzhszphdjk3ta5jt7t222jicn3zj5e6em3fknzmudeqr3f@dogx6h7lsrax>
Message-ID: <aWAs8kD9Bhih2mtA@google.com>
Subject: Re: [PATCH v3 1/4] KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF
 when SVME==0
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Yosry Ahmed wrote:
> On Thu, Jan 08, 2026 at 10:58:40AM -0800, Sean Christopherson wrote:
> > On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> > > From: Jim Mattson <jmattson@google.com>
> > > 
> > > GIF==0 together with EFER.SVME==0 is a valid architectural
> > > state. Don't return -EINVAL for KVM_SET_NESTED_STATE when this
> > > combination is specified.
> > > 
> > > Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index c81005b24522..3e4bd8d69788 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1784,8 +1784,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> > >  	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
> > >  	 */
> > >  	if (!(vcpu->arch.efer & EFER_SVME)) {
> > > -		/* GIF=1 and no guest mode are required if SVME=0.  */
> > > -		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> > > +		/* GUEST_MODE must be clear when SVME==0 */
> > > +		if (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)
> > 
> > Hmm, this is technically wrong, as it will allow KVM_STATE_NESTED_RUN_PENDING.
> > Now, arguably KVM already has a flaw there as KVM allows KVM_STATE_NESTED_RUN_PENDING
> > without KVM_STATE_NESTED_GUEST_MODE for SVME=1, but I'd prefer not to make the
> > hole bigger.
> > 
> > The nested if-statement is also unnecessary.
> > 
> > How about this instead?  (not yet tested)
> > 
> > 	/*
> > 	 * If in guest mode, vcpu->arch.efer actually refers to the L2 guest's
> > 	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
> > 	 * If SVME is disabled, the only valid states are "none" and GIF=1
> > 	 * (clearing SVME does NOT set GIF, i.e. GIF=0 is allowed).
> > 	 */
> > 	if (!(vcpu->arch.efer & EFER_SVME) && kvm_state->flags &&
> > 	    kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
> > 		return -EINVAL;
> 
> Looks good to me, with the tiny exception that at this point clearing
> SVME does set GIF. Maybe re-order the patches?
> 
> Let me know if you want me to send a new version or if you'll fix it up
> while applying.

No need for a new version.

