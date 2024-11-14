Return-Path: <kvm+bounces-31848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0A69C86A9
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 10:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F412283396
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AF61F8909;
	Thu, 14 Nov 2024 09:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cO/m/WtF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EB91F7552;
	Thu, 14 Nov 2024 09:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731578132; cv=none; b=pZ1/M+Sq90ZK3tbKbK0TwOxQ10cnBTQcvEgjjN4i6iynOPjcnL/D7Ekdk4aK79P+1S6hUnfN5oQuay1Jx3DvXGMgmHAN/F/AFR0CrKiAii1k9Larsd8Nn+yVDDYTURsuKm8SN/Me4Hw1+0AKiu31zoe9Wl4fTRvAotR1m662ols=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731578132; c=relaxed/simple;
	bh=+HWak88Ehw4C3GkW1MzZbhh/Cfp+jj9+xNEBtIU+veI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBno3JEvS+uMt1Hv7ZsNLYUhrznpK2Tzfj2y+PfGDw+rhnterm8yLpn2sWtTnU/zYvp07KYuqT92y142WVBJjNQcLyNfJJMnhSnDha9DjNVvcFt0RwAazeW+G/1bDtAAXuHY/gXF4AdRHsGeQkn85cwJ4TpoK5IBJFzuHNotDEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cO/m/WtF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9E99F40E015E;
	Thu, 14 Nov 2024 09:55:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2h1FGJGz5C49; Thu, 14 Nov 2024 09:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731578122; bh=3UbCZxfhVYy6kTAHF2vSeHP8crTqfM8XNr9sTd6/eVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cO/m/WtFjo/Sh9MlAgWGwC1BzUHJencXvBIDgBmjn5CyaCSgJi4QXuxLwYi6oEHn2
	 mN4G2MJasrqKEEJztkIlT6Ydxxi80uWu7igASB0V9DbdqAUNEt//ZoEE1ptCqVfK7M
	 nchT/sXkDMOg1ImKiy40o2+JOnAqn3p57NwpP6pfKMHR6J8GzsQzgBTWD0O62g+bgg
	 BvkZBvJsKbOl4ww4BishlygL5Y1FI97NExuM0FF26oq2OZMnQfb+r3oOTy5/BHtBJl
	 HZmBqbs8UMtGmyVMOxQUgunZO7djANxWDfQiNChcA542aelACiV1YrJZ0GuzKXVRwd
	 LF8rEbrNdal9wRSaqbSzJGq2k0zTECCQN6UCNxRSGqxfeO8r4XzajaA8/rS10S1JWL
	 35GLvcURzZ7BBFahU2IO9dMK1Cx3FvYzgsmA0QqLWCvrufpPd8apECbo1Z/D0ZYNoT
	 EECdLenaZ4o9MV2cpocZP9b1obb2h6H3t4eJfPbnd6ihEQaz1oTIfdVa0BC8LKQxk5
	 XDNI0aIv/1Q1Lk2MHPc+4dC0Xlgn2YgpXp0cBn9z4U+TCfrv53C/SNwMW6ShQmZK5P
	 Cvq/tS3XCUfK2ybr6WmS7oTbKq6oYMDSgdI8CMXmTSSGTakyrVroJBJPBR+mP3XsRK
	 bLZ8bwV4CccYZyAnwnHDaeA4=
Received: from zn.tnic (p200300ea973a31a9329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31a9:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A8BAC40E0220;
	Thu, 14 Nov 2024 09:54:55 +0000 (UTC)
Date: Thu, 14 Nov 2024 10:54:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de,
	peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241114095450.GCZzXI6rY0s-OWJ6X1@fat_crate.local>
References: <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
 <20241113212440.slbdllbdvbnk37hu@jpoimboe>
 <20241113213724.GJZzUcFKUHCiqGLRqp@fat_crate.local>
 <20241114004358.3l7jxymrtykuryyd@jpoimboe>
 <20241114074733.GAZzWrFTZM7HZxMXP5@fat_crate.local>
 <ZzXHK1O9E1sQ8mBt@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZzXHK1O9E1sQ8mBt@gmail.com>

On Thu, Nov 14, 2024 at 10:47:23AM +0100, Ingo Molnar wrote:
> I think in-line documentation is better in this case: the primary defense
> against mistakes and misunderstandings is in the source code itself.
> 
> And "it's too long" is an argument *against* moving it out into some obscure
> place 99% of developers aren't even aware of...

You mean developers can't even read?

	/* 
	 * See Documentation/arch/x86/ for details on this mitigation
	 * implementation.
	 */

And if we want to expand the "why" and do proper documentation on the
implementation decisions of each mitigation, we still keep it there in the
code?

Or we do one part in Documentation/ and another part in the code?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

