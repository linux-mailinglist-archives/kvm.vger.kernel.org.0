Return-Path: <kvm+bounces-21636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 278FE930FE7
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A35C4B215FE
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E00D41849F4;
	Mon, 15 Jul 2024 08:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaCwJOua"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106FE13AD16;
	Mon, 15 Jul 2024 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721032529; cv=none; b=KrKUj2T0EwbLs9WGNfRDxMiBjitpKfH8fJetAqk4yCVqzDIZxjLX6U8A67fIzv+s6RfoPJzP5qcaMto9gLnw8+FLvpjqmZ6iXv8LiT+c5le8/JupBZf8ioBJs6QCBzfSPU5k+K08sHfD1jBPlz5mQBtAOnujEtFsWrmTyksQJ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721032529; c=relaxed/simple;
	bh=jAlufq6YBFy5pNLAiRTrVpUAjA/a0pbhT3MiEyZ9Cs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=py4ZJ9gxnLEPpncYdKrnJK9bJUPws0nrFG+B91L0s6+iPIAMf/2kyQK2xT/iEF/9FEwIlPP6ePsC1lPzetO4OH3AB7i460tUqJgnrevGEuSY5nMWyQupgaRgagMcC2rQIiMx+rMLrtMSZBRvlCAmicH8iHNMOZp1Ie1btXq2y48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaCwJOua; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2B8C32782;
	Mon, 15 Jul 2024 08:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721032528;
	bh=jAlufq6YBFy5pNLAiRTrVpUAjA/a0pbhT3MiEyZ9Cs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MaCwJOuankTwhH0HxrC61CUi9I6lDhu8TCEAtSr/qk22KpFWVEXu1cPR/7/3f568J
	 UBNhMLmVpWNRpDaEJJ6r48nWP/ItjyHd3AADPsvHstVL1lJS/2IdVD9mythJJriWnk
	 q4GG3h7hgJfPRbFE+5eDjjH4/v8u62aEc4tUYSrYYxbasMlu7uyfTInmF5mwuBUw6h
	 UacxO25eIYtR3ApDWkiPHsOVr43JGf9p5EminJTTQUqcYySqziUKCWjrGRx8Vu09f2
	 YbxSCpTs1is1LCZyGXLUrQQSFfAeQEyTZ7NC1oQK54cAUnf/BhPB1TzTx+VBkltRoW
	 vT6c2e99o7LPQ==
Date: Mon, 15 Jul 2024 10:35:26 +0200
From: Amit Shah <amit@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: David Kaplan <David.Kaplan@amd.com>, Jim Mattson <jmattson@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
Message-ID: <ZpTeuJHgwz9u8d_k@t470s.drde.home.arpa>
References: <20240626073719.5246-1-amit@kernel.org>
 <Zn7gK9KZKxBwgVc_@google.com>
 <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
 <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org>
 <DS7PR12MB57665C3E8A7F0AF59E034B3C94D32@DS7PR12MB5766.namprd12.prod.outlook.com>
 <Zow3IddrQoCTgzVS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zow3IddrQoCTgzVS@google.com>

On (Mon) 08 Jul 2024 [11:59:45], Sean Christopherson wrote:
> On Mon, Jul 01, 2024, David Kaplan wrote:
> > > > >        /*
> > > > >         * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the
> > > > > Intel feature
> > > > >         * flag and protect from vendor-specific bugs via the
> > > > > whitelist.
> > > > >         *
> > > > >         * Don't use AutoIBRS when SNP is enabled because it degrades
> > > > > host
> > > > >         * userspace indirect branch performance.
> > > > >         */
> > > > >        if ((x86_arch_cap_msr & ARCH_CAP_IBRS_ALL) ||
> > > > >            (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
> > > > >             !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
> > > > >                setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
> > > > >                if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB)
> > > > > &&
> > > > >                    !(x86_arch_cap_msr & ARCH_CAP_PBRSB_NO))
> > > > >                        setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
> > > > >        }
> > > >
> > > > Families 0FH through 12H don't have EIBRS or AutoIBRS, so there's no
> > > > cpu_vuln_whitelist[] lookup. Hence, no need to set the NO_EIBRS_PBRSB
> > > > bit, even if it is accurate.
> > >
> > > The commit that adds the RSB_VMEXIT_LITE feature flag does describe the
> > > bug in a good amount of detail:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?i
> > > d=2b1299322016731d56807aa49254a5ea3080b6b3
> > >
> > > I've not seen any indication this is required for AMD CPUs.
> > >
> > > David, do you agree we don't need this?
> > >
> > 
> > It's not required, as AMD CPUs don't have the PBRSB issue with AutoIBRS.
> > Although I think Sean was talking about being extra paranoid
> 
> Ya.  I'm asking if there's a reason not to tack on X86_FEATURE_RSB_VMEXIT_LITE,
> beyond it effectively being dead code.  There's no runtime cost, and so assuming
> it doesn't get spuriously enabled, I don't see a downside.

Ah - I get it now.  You want to add this code for parity with
vmenter.S so that a future bug like this doesn't happen.

I disagree, though.  It's not really dead code - it does get patched
at runtime.  If a future AMD CPU has a bug that Intel doesn't, we'll
have to introduce a new ALTERNATIVE just for that condition - leading
to more complexity than is actually required.

Also - reviewers of code will get confused, wondering why this code
for AMD exists when the CPU vuln does not.

I get that we want to write defensive code, but this was a very
special condition that is unlikely to happen in this part of the code,
and also this was missed by the devs and the reviewers.

The good thing here is that missing this only leads to suboptimal
code, not a security bug.  So given all this, I vote for the
simplicity of code, rather than tacking on something.

Sound OK?


		Amit
-- 

