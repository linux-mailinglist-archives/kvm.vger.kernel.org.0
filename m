Return-Path: <kvm+bounces-32823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D2D9E01F9
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 13:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38C63282192
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D7F1FECAE;
	Mon,  2 Dec 2024 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D5MqestK"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C41FC7E1;
	Mon,  2 Dec 2024 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733142023; cv=none; b=IcJur8+omXT/uDtguvEoFOTOzTQYeV07i+qAWoHcGD5wYvDUxflOWq93ZV6Wyp4k67q9YJOEMohxYwGehGgUooaROV37oiUjz8Fw8oAcLWFk/xWXWR/dIdfN7MRyVhFeHXKrDBBSYV6wJ0dS8OPO7LvI59tXQfyFGu0YklOY5/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733142023; c=relaxed/simple;
	bh=4ercBYKdr/wS+o70Dt/gc0Ud0Nppd4D/VDU7L4WgZ2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGD3l1U9AeIwQvxfhafeA9KXG4iHDWuYnltoREwHgBdBqZWsMxp9EBQci3EzlhO4XcME6/7hJnWYBusPXV3EML5GYsHy8Ae33j5/V/7A/q0AlYkEWjkif3wHC8fCpxdpGfJ24b24Wp87AJAGpVnLHyAM8ACWDEcIAUUs2f58O70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D5MqestK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0CF4F40E0274;
	Mon,  2 Dec 2024 12:20:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nvbI2-M_wWXx; Mon,  2 Dec 2024 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733142013; bh=F1tq3BbMqJG0Q+uEocbwn+TMofehPuuwsk1YGluROtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D5MqestKzwdYuwfiTkml9kiljHzKJJMu0iV9qRJU2Ia8whtgl9vnxdMOp8zjPPMpS
	 owr9iMvWPpXB/k92bQ2xLZA2qy9nFdW3BHBBV4Mv0imuOB3DPxF0P3qAotG772awvt
	 dvmKHLBBDSHWR1mvmaD4rBwSQfjHOkiUdIdeaDLUJkVTuHqy4z8h26VcYfkGSzeNpR
	 +n4pAVdUgJvBL1T1cfLQ7ZI8qPLn2YFCKinItIWA1CYRRsclrlY0/nuWfggOAae4wc
	 qCsAAtDuVYF4MZpJQ6ahgN6AJYy4nc0cWntREe8RrYPNE6msKZax+zhKbXTRj/InlM
	 jSQtfve8h4DKtsBBPN8YfDGBM+YMHHfNIt4+pvalemS4ZRuIQmPnnuUUihzf5teENL
	 mB9Uty38zOIMbB6cnQI5Gx69CazRahYocPtCaxW11zqYY0sLjzKl0e47gGokLxaGFT
	 nAKgAC984y3LzvymQ2UDVpY5/4jkrp6rqtp4kTlosspQ/3ProJndP8Hjb1lFoOBNjr
	 FzLmzAXXtNGSKzSX7LIwp0DwMHARHKhc0SHGo5GYA3NDOIy3K7e+CU9BHi3piQvBPI
	 DiXhKmKu2DuZfIS8CaPSx+m8boCyztZHV0Tl9J+G30j6qXkPCxYr2vFhNgVo1owlX9
	 YEhn5/WtRncF8OFTiddLTgQk=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 173A340E01A2;
	Mon,  2 Dec 2024 12:19:49 +0000 (UTC)
Date: Mon, 2 Dec 2024 13:19:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Shah, Amit" <Amit.Shah@amd.com>
Cc: "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"amit@kernel.org" <amit@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241202121942.GBZ02l3pnKRs51AI-7@fat_crate.local>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
 <f43ebdd781d821d7fabdd85f1eebf8acd980566f.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f43ebdd781d821d7fabdd85f1eebf8acd980566f.camel@amd.com>

On Mon, Dec 02, 2024 at 11:15:24AM +0000, Shah, Amit wrote:
> FWIW, I'd say we have fairly decent documentation with commit messages
> + code + comments in code.

You mean everytime we want to swap back in why we did some mitigation decision
the way we did, we should do git archeology and go on a chase?

I've been doing it for years now and it is an awful experience. Absolutely
certainly can be better.
 
> If you're saying that we need *additional* documentation that replicates hw
> manuals and the knowledge we have in our commit + code + comments, that
> I agree with.

We need documentation or at least pointers to vendor documentation which
explain why we're doing this exact type of mitigation and why we're not doing
other. Why is it ok to disable SMT, why is it not, for example? This patch is
another good example.

> I got the feeling earlier, though, that you were saying we need that
> documentation *instead of* the current comments-within-code, and that
> didn't sound like the right thing to do.

Comments within the code are fine. Big fat comment which is almost a page long
is pushing it. It can very well exist in Documentation/ and a short comment
can point to it.

And in Documentation/ we can go nuts and explain away...

> ... and the code flows and looks much better after this commit (for
> SpectreRSB at least), which is a huge plus.

Why does it look better?

Because of the move of SPECTRE_V2_EIBRS_RETPOLINE?

> It's important to note that at some point in the past we got vulnerabilities
> and hw features/quirks one after the other, and we kept tacking mitigation
> code on top of the existing one -- because that's what you need to do during
> an embargo period.  Now's the moment when we're consolidating it all while
> taking stock of the overall situation.

Yes, that's exactly why I'm pushing for improving the documentation and the
reasoning for each mitigation. Exactly because stuff is not under NDA anymore
and we can do all the debating in the open, and the dust has settled.

> This looks like a sound way to go about taking a higher-level view and
> simplifying the code.

Yap.

And to give you another argument for it: when we clean it up nicely, it'll be
easier to add new mitigations. :)

And no, I don't want more but no one's listening to me anyway...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

