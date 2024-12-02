Return-Path: <kvm+bounces-32839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 128959E0ABF
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7B7FB36BBC
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CCE1DDC06;
	Mon,  2 Dec 2024 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="st0MqNb4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83F41D9694;
	Mon,  2 Dec 2024 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733162982; cv=none; b=pdR3mFoYmpmdxTR8GWRH4EYtehfgbrS4r6HMPwU9J8Z/0neP6By+hH+2scWAqJbux4EdgD+wdGPZ1bg2y2EydPtp2nbPZdk0SjqshQaHB43EsKGuzNupmxbpzJIoUiyKy0TFcPhCIDMEMUX93SE2ifLONn1VBPcKZVMeIYkMH2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733162982; c=relaxed/simple;
	bh=Kx8yoGCS5+i0osaVs5Inz0KmuCpKhwgyM2hn+aT4a9M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ASo0HQBbUAfDjorvzJ0Of0e6J+cqiulluJjiCRisyTgOjlQiqxURs8GvV8P04/StNR6bM5ZT1wt/BMxKA60ZGd3gypS8sBs1cCoLBZqnP7PqzBMOhZ7cQMJebC2CI6vJqEmkNUPf7wcBQ08//Cd9C+WDnrpXZCMll8X15fsQXTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=st0MqNb4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE2AC4CED1;
	Mon,  2 Dec 2024 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733162981;
	bh=Kx8yoGCS5+i0osaVs5Inz0KmuCpKhwgyM2hn+aT4a9M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=st0MqNb40jkAAqyI+nNoYCJBt1G1B1bj0M0beatIM1i2YBR/2ki7pxqKCi9Qvk5Hx
	 fz7QtYVtAgD2S5o5dTQcPc/Bc26+BrIW9VneZ4clp1fs7VrZ2G0/UPaDmmSYNW7Z2/
	 AB+IpNbXqkDok255L8PPmWO3sO4pZMvZn1fgPEwMzYs0xcJ6YFhYf/HIV+c0qPWTzF
	 vnHOrzdq/1cqg0HCIuzZpIXdf3gq3uzowN8oyNmVa1XGMsAanT7zH5lMeO6kk399dF
	 kk2276OmnJN5zkQgnX3g4rcd7co/d3nZZLFONKdNI0i4yiG/B1ha3TYpscpJvyjgW7
	 3Z0EDzdN7h+hQ==
Message-ID: <4601ca077c95393837eb40909c941a4d67bb04dd.camel@kernel.org>
Subject: Re: [RFC PATCH v3 1/2] x86: cpu/bugs: add AMD ERAPS support;
 hardware flushes RSB
From: Amit Shah <amit@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org
Cc: thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de, 
	peterz@infradead.org, jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, 	corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, 	seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 	kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, 	Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, 	andrew.cooper3@citrix.com, Amit
 Shah <Amit.Shah@amd.com>
Date: Mon, 02 Dec 2024 19:09:34 +0100
In-Reply-To: <7222b969-30a8-42de-b2ca-601f6d1b03cd@intel.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <20241128132834.15126-1-amit@kernel.org>
	 <20241128132834.15126-2-amit@kernel.org>
	 <7222b969-30a8-42de-b2ca-601f6d1b03cd@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 (3.54.2-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-12-02 at 09:26 -0800, Dave Hansen wrote:
> On 11/28/24 05:28, Amit Shah wrote:
> > From: Amit Shah <amit.shah@amd.com>
> >=20
> > When Automatic IBRS is disabled, Linux flushed the RSB on every
> > context
> > switch.=C2=A0 This RSB flush is not necessary in software with the ERAP=
S
> > feature on Zen5+ CPUs that flushes the RSB in hardware on a context
> > switch (triggered by mov-to-CR3).
> >=20
> > Additionally, the ERAPS feature also tags host and guest addresses
> > in
> > the RSB - eliminating the need for software flushing of the RSB on
> > VMEXIT.
> >=20
> > Disable all RSB flushing by Linux when the CPU has ERAPS.
> >=20
> > Feature mentioned in AMD PPR 57238.=C2=A0 Will be resubmitted once APM
> > is
> > public - which I'm told is imminent.
>=20
> There was a _lot_ of discussion about this. But all of that
> discussion
> seems to have been trimmed out and it seems like we're basically back
> to: "this is new hardware supposed to mitigate SpectreRSB, thus it
> mitigates SpectreRSB."

Absolutely, I don't want that to get lost -- but I think that got
captured in Josh's rework patchset.  With that rework, I don't even
need this patchset for the hardware feature to work, because we now
rely on AutoIBRS to do the RSB clearing; and the hardware takes care of
AutoIBRS and ERAPS interaction in Zen5.

The only thing this patch now does is to handle the AutoIBRS-disabled
case -- which happens when SEV-SNP is turned on (i.e. let the hw clear
the RSB instead of stuffing it in Linux).

I can still include the summary of the discussion in this patch - I
just feel it isn't necessary with the rework.

		Amit

