Return-Path: <kvm+bounces-57695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C50B6B58F9D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BF59178F2D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0956257848;
	Tue, 16 Sep 2025 07:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxSynEpG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FAB14658D
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008950; cv=none; b=N0oHNMiReiRL8lPysiB9o1RKVE6qn7H+nh71jAVO62TwUEUyb9on/rE/IX52BL+07kgbLBexhWcFrp/41SsDkJ8tmzzhErLVKCRMnxYz3noywQSIiVE/I91CbhLn6dFZpWagGMukveMnvGs5ZvoeaBylYGGJjiFfQuItKuiydSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008950; c=relaxed/simple;
	bh=mHB2VC5Df3IVyWAs4VbL6UEKMN4Z24QesNj0rfLy1Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AweFkTT4qsGlASepP65/wOzFY0vpr0WIedjRw5mfH9NrICqj3cF+yxyv/jvnC+cQbV/NDO1GRxBLcjXzflqw79qhLKC02GYg6WQKUUdzasob0DC3J+/evvwnGoFFuIts8u77aK4ieqMJN7xYRkFh2vvy+s/E6KeFBrJAFgyGSds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxSynEpG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C1BC4CEEB;
	Tue, 16 Sep 2025 07:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758008950;
	bh=mHB2VC5Df3IVyWAs4VbL6UEKMN4Z24QesNj0rfLy1Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uxSynEpGZT8JCzIB+BgzSfJCcMjz9b1Aa2FUbNw8h3KLztK+Nkd/m58hPBeHnUeDs
	 EQp/I9TZbIb0VnTKdqB8goSmiDXUmOsGpGq9o+5IctZNgq6YG9198XBP6CyVwL9mua
	 T323mSDv+F5mC0cPr/ZrYikT3Vr9g9vt5F50/qP7n/u0kSNy2oVuoPYefcOkgb3W27
	 IhrMu5fiqU9tP1A3TvWaVg247mDeXIlQvMAA3DT+U1d23N8zEfC/lnIwgBqA9BD3Fm
	 vBvVjMSqbBim8510tLbPEdX/lKkhiUzKn0Vf473A0lkz9X2PdLlm/sJH9SAgwXyNe9
	 z8yfJp3MJn92w==
Date: Tue, 16 Sep 2025 13:09:14 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joao Martins <joao.m.martins@oracle.com>, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
Message-ID: <p4gvfidvfrfpwy6p6cmua3pnm7efigjrbwipsoga7swpz3nmyl@t3ojdu4qx3w6>
References: <cover.1756993734.git.naveen@kernel.org>
 <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
 <aMiY3nfsxlJb2TiD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMiY3nfsxlJb2TiD@google.com>

On Mon, Sep 15, 2025 at 03:53:18PM -0700, Sean Christopherson wrote:
> On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > AVIC and x2AVIC are fully functional since Zen 4, with no known hardware
> > errata. Enable it by default on those processors, but allow users to
> > continue passing 'avic' module parameter to explicitly enable/disable
> > AVIC.
> > 
> > Convert 'avic' to an integer to be able to identify if the user has
> > asked to explicitly enable or disable AVIC. By default, 'avic' is
> > initialized to -1 and AVIC is enabled if Zen 4+ processor is detected
> > (and other dependencies are satisfied).
> > 
> > So as not to break existing usage of 'avic' which was a boolean, switch
> > to using module_param_cb() and use existing callbacks which expose this
> > field as a boolean (so users can still continue to pass 'avic=on' or
> > 'avic=off') but sets an integer value.
> > 
> > Finally, stop warning about missing HvInUseWrAllowed on SNP-enabled
> > systems if trying to enable AVIC by default so as not to spam the kernel
> > log.
> 
> Printing once on a module load isn't spam.

D'uh, :facepalm: - you're right.

> 
> > Users who specifically care about AVIC
> 
> Which we're trying to make "everyone" by enabling AVIC by default (even though
> it's conditional).  The only thing that should care about the "auto" behavior is
> the code that needs to resolve "auto", everything else should act as if "avic" is
> a pure boolean.

This was again about preventing a warning in the default case since 
there is nothing that the user can do here. I think this will trigger on 
most Zen 4 systems if SNP is enabled.

By "users who specifically care about AVIC", I mean those users who want 
to ensure it is enabled and have been loading kvm_amd with "avic=on".  
For them, it is important to print a warning if there are missing 
dependencies. For everyone else, I am not sure it is useful to print a 
warning since there is nothing they can do.

> 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 9fe1fd709458..6bd5079a01f1 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -1095,8 +1095,13 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >   */
> >  void avic_hardware_setup(bool force_avic)
> >  {
> > +	bool default_avic = (avic == -1);
> 
> We should treat any negative value as "auto", otherwise I think the semantics get
> a bit weird, e.g. -1 == auto, but -2 == on, which isn't very intuitive.

Agree. The reason I hard-coded the check to -1 is because 'avic' is 
being exposed as a boolean and there is no way for a user to set it to a 
negative value.


Thanks,
Naveen


