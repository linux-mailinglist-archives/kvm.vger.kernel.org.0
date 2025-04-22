Return-Path: <kvm+bounces-43846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A722A975CF
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 21:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAEB91766EF
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 19:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3A429AAE4;
	Tue, 22 Apr 2025 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vd9uFVut"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B4B298CBA;
	Tue, 22 Apr 2025 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745351107; cv=none; b=aWUOSY0gZpPZ4j83ycbbgekCeXqHrLkd3Mq0G4RtarlN4HIWaSaDK10k0rFUlIrxSnMeffWsDH4/n021lGbOY7oTXUVKp882u/lwLKavH6DAIvbnqX55I4l+3tpOd0tCI6Em94qsfuaqrsQRSdq0xvuVoobjuYDt1IihmmWCbho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745351107; c=relaxed/simple;
	bh=SM6p/VeZczxklqTLgYwK5TNBFJzXTVCYUxX3c44n8dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lo21iLWexY+zRZp1CiPvurzbw0X0xfgl8o7AzkqCxrNGgWGrs5f/bqdpzXLH5FSFgVSNIWDM4WJcUQbHcORrMj+f9rU6mxhKYr8XM021vDXaOsYZmHjqmtY3ajQWS3vhly9I6hfCYliYmZ3a2fj0s3DUw1oLJuE0ObZEUQEHcgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vd9uFVut; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47763C4CEE9;
	Tue, 22 Apr 2025 19:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745351107;
	bh=SM6p/VeZczxklqTLgYwK5TNBFJzXTVCYUxX3c44n8dY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vd9uFVutD/DiNg1ZxIBzrJdFL1jU2G6puZbnWNQs6i3n+kf4rc7vjxbWQL0R1Xh0o
	 JPrl6gnfZMUUMuCJ+LVDo47kM2iYR+B7MWiVlw8xE3k2+6jJlOnMuWlpfzng1j0fuc
	 eAe80vnHzBUZ/9P+E1w7FDylcBKZ7LPAR6dUi4s5hvfw4GYmiln7dnDRhkWFTZuLNC
	 OAUF4DLx/eqv0HGxif/3d/pgrzjjX7T3fipHd75VA+jrtzIbVoN5ZCL9JUglMrUv//
	 znxygIRCg4iMtIS6pOSxN31eRvCq5hhNGISN9GHZk2Q+nZkcDEYGreaG3shaMFEoS7
	 b+FuRzJGQ+M5g==
Date: Tue, 22 Apr 2025 21:44:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"acme@kernel.org" <acme@kernel.org>,
	"jgross@suse.com" <jgross@suse.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"namhyung@kernel.org" <namhyung@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"irogers@google.com" <irogers@google.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>,
	"kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>,
	"ajay.kaher@broadcom.com" <ajay.kaher@broadcom.com>,
	"bcm-kernel-feedback-list@broadcom.com" <bcm-kernel-feedback-list@broadcom.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"Ostrovsky, Boris" <boris.ostrovsky@oracle.com>,
	"kys@microsoft.com" <kys@microsoft.com>,
	"haiyangz@microsoft.com" <haiyangz@microsoft.com>,
	"Cui, Dexuan" <decui@microsoft.com>
Subject: Re: [RFC PATCH v2 00/34] MSR refactor with new MSR instructions
 support
Message-ID: <aAfxuby_0eZZTrj-@gmail.com>
References: <20250422082216.1954310-1-xin@zytor.com>
 <aAevpauKYWwObsB7@google.com>
 <cb4e24a0-fdb7-46d2-9b0e-200f5e3e4c96@zytor.com>
 <DS7PR11MB6077B4D80EB7020C4D3FCD52FCBB2@DS7PR11MB6077.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS7PR11MB6077B4D80EB7020C4D3FCD52FCBB2@DS7PR11MB6077.namprd11.prod.outlook.com>


* Luck, Tony <tony.luck@intel.com> wrote:

> > >> base-commit: f30a0c0d2b08b355c01392538de8fc872387cb2b
> > >
> > > This commit doesn't exist in Linus' tree or the tip tree, and the series doesn't
> > > apply cleanly on any of the "obvious" choices.  Reviewing a 34 patches series
> > > without being able to apply it is a wee bit difficult...
> > >
> >
> > $ git show f30a0c0d2b08b355c01392538de8fc872387cb2b
> > commit f30a0c0d2b08b355c01392538de8fc872387cb2b
> > Merge: 49b517e68cf7 e396dd85172c
> > Author: Ingo Molnar <mingo@kernel.org>
> > Date:   Tue Apr 22 08:37:32 2025 +0200
> >
> >      Merge branch into tip/master: 'x86/sev'
> >
> >       # New commits in x86/sev:
> >          e396dd85172c ("x86/sev: Register tpm-svsm platform device")
> >          93b7c6b3ce91 ("tpm: Add SNP SVSM vTPM driver")
> >          b2849b072366 ("svsm: Add header with SVSM_VTPM_CMD helpers")
> >          770de678bc28 ("x86/sev: Add SVSM vTPM probe/send_command
> > functions")
> >
> >      Signed-off-by: Ingo Molnar <mingo@kernel.org>
> >
> >
> > You probably need to git pull from the tip tree :-)
> 
> If possible, you should avoid basing a series on tip/master as it 
> gets recreated frequently by merging all the topic branches. The SHA1 
> is here today, gone tomorrow.

Correct, although for x86 patch submissions via email it's not wrong: 
what applies today will likely apply tomorrow as well, regardless of 
the SHA1 change. :-)

> If your changes only depend on one TIP topic branch, base on that and 
> mention in the cover letter (as well as the SHA1 supplied from git 
> format-patches --base=xxx).

Yeah, the main dependency this series has is tip:x86/msr I believe:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/msr

Which SHA1's should be stable at this point.

Thanks,

	Ingo


