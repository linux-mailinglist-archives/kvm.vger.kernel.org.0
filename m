Return-Path: <kvm+bounces-57684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C14FB58EFB
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6257B2A8477
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3843280CC9;
	Tue, 16 Sep 2025 07:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgUqG7d2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC8319D08F
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007153; cv=none; b=tkgZDlDy5HjFW3RISVaAL86Kr/RUQIU8MdQrta1FHvUS8ND7NsHbw7DKGhr1dcQ8lLk59mlnu1XPEuu+ZFKy6u1ocRNYdmpgs88fCo8G5mmwqKKkQgH3THX4WRYBnTBU6eSJOe+3cdhrjXe2aJ05v6R7qLXDndob43HIDpMfKc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007153; c=relaxed/simple;
	bh=9HUBnkRSgd7KOU47UVEXNzjWxBgXt1pt1Pg+ZCfY+wI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDoacZQbciiKs3mohT+amty8uWFenn7vkKwn1/WN3CTuy0j5Z+Frde70RHRWDao04rWGsac5G840Te/9i/80nmrGItOlk7ViozwY5FTwheSp7l7dULyqKlqXyhQYEEERYsMpN09j7NK/7Hiwkq6PkxfAMDeT0myizwVTmXlVAqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgUqG7d2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7279BC4CEF7;
	Tue, 16 Sep 2025 07:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758007152;
	bh=9HUBnkRSgd7KOU47UVEXNzjWxBgXt1pt1Pg+ZCfY+wI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sgUqG7d2uCc8wgLt3QiA7+KFToUhN2AH3C6ay7tqf3WPd0P4dqbecScUR9REIp1ph
	 siB4Oj8hjUgW/8gNSsHX26jdCW240rLU9S2Qtwg/YeCUGd0NyPHLk12G3sv3Pr3tRE
	 W872y5iSiL3FPJ37j2wIWTlPY4djCBFDHBBw5SnPvR8sAjiv59LJiVgFwsXmWhK/P3
	 8XeRqfFiuMueuGlFnGAYy8oHeGk+ErGWl0Ptk2BkkzAZSDvf9N2VsK6SQQDCDBjqsi
	 Qb+wrIjQOGsGz0yr39fmNwTxjiqDBAMMJ0ME2le42RwgwuxFr6WsDcd8DqhLaaBIV1
	 DiEMQw5XOc8yQ==
Date: Tue, 16 Sep 2025 12:44:37 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Joao Martins <joao.m.martins@oracle.com>, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, 
	Mario Limonciello <superm1@kernel.org>
Subject: Re: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit
 alone is enabled
Message-ID: <wo2sfg7sxkpnemiznpjtjou4xc6alad2muewkjulqk2wr2lc5q@vlb7m34ez2il>
References: <cover.1756993734.git.naveen@kernel.org>
 <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
 <aMhxaAh6a3Eps_NJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhxaAh6a3Eps_NJ@google.com>

On Mon, Sep 15, 2025 at 01:04:56PM -0700, Sean Christopherson wrote:
> On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> > A platform can choose to disable AVIC by turning off the AVIC CPUID
> > feature bit, while keeping x2AVIC CPUID feature bit enabled to indicate
> > AVIC support for the x2APIC MSR interface. Since this is a valid
> > configuration, stop printing a warning.
> > 
> > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> > ---
> >  arch/x86/kvm/svm/avic.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index a34c5c3b164e..346cd23a43a9 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -1101,14 +1101,8 @@ bool avic_hardware_setup(void)
> >  	if (!npt_enabled)
> >  		return false;
> >  
> > -	/* AVIC is a prerequisite for x2AVIC. */
> > -	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
> > -		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
> > -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
> > -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
> 
> I agree with the existing code, KVM should treat this as a firmware bug, where
> "firmware" could also be the host VMM.  AIUI, x2AVIC can't actualy work without
> AVIC support, so enumerating x2AVIC without AVIC is pointless and unexpected.

There are platforms where this is the case though:

$ cpuid -1 -l 0x8000000A | grep -i avic
      AVIC: AMD virtual interrupt controller  = false
      X2AVIC: virtualized X2APIC              = true
      extended LVT AVIC access changes        = true

The above is from Zen 4 (Phoenix), and my primary concern is that we 
will start printing a warning by default. Besides, there isn't much a 
user can do here (except start using force_avic, which will taint the 
kernel). Maybe we can warn only if AVIC is being explicitly enabled?

There is another aspect to this: if we are force-enabling AVIC, then 
this can serve as a way to discover support for x2AVIC mode (this is 
what we do currently).  Otherwise, we may want to force-enable x2AVIC 
based on cpu family/model.


- Naveen


