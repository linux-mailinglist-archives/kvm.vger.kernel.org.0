Return-Path: <kvm+bounces-57713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0BE3B5946D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:55:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19ABA1BC1623
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430F82C15AB;
	Tue, 16 Sep 2025 10:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lDs4C1dH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28802848B4;
	Tue, 16 Sep 2025 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758020145; cv=none; b=JBXi6kTJOwqtHnMy0HG4awwq7VfaRmWA3ejX6z7jqcFylR6MbHreZG9XfzeNF1+IwbBTBCTDTIscVV+9sAuGn/42c2Jo4OXHYXGoPeSjJQDD3HPbjfgooS2371Z+CPulVeZhzIc0HfU0lTV1HbqvbzRkDihgDjR8mZSmPSfVgK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758020145; c=relaxed/simple;
	bh=i2lQ9kmd4aAVMjfrEpHE+5ST+C8hkMxt9rOFy9jfnjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBBCjWWH54Foyzgumo7LG4SqXZEMuRFyiGUfpKW4fvXHqYyrIDBrGVCNgfCSzJsww57rlyQSyQtLzM5cn51bBOC35i1V/3UAmhCKLVcFdE8w4QFLlsyM2hZVdVGaLdiJ9hyD6x+bgX7mzdmG7fuImwA0aRR1fDFEGCBkPjnafro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=lDs4C1dH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F2EE640E00DD;
	Tue, 16 Sep 2025 10:55:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uCcOi71IaTmD; Tue, 16 Sep 2025 10:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758020136; bh=JGKPm00kiR0eXGDawCmS03MwfcwvunKUbTpnaKaND2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lDs4C1dHSctKihlPRn0IX0YKbLLdv7C2Sj1F7q9RvGdxSsdlfuYH72BQwrvt+RX2h
	 Emgu6kivalGhVCwHm52xhOWalI/jUQVEXMi4al0Ja4XHhB+nEhbsz6ZA3sIWrxvCFo
	 Xdpk6eFBVRSsmr4e+YvcFvhQIeeDjW7gATkDKRvCdheHpS8XBOPRV27Wf8vU2lmkwP
	 nEJsMn1jmgFA0RM81X161qyr63/17kLATZcFCnTE0baEWpYbil1nM5Ge2x3pNsX7/Q
	 5R7o9VuPlXpYHkhP1igiJFCDUziIOnaJNpOlRmpc3PfsgYudnbGvi6HjBAxTlcRYRO
	 14jRyyM2BcgppNNzkiw2ZPv+QEe6JiRPry7OjV34sFH2m+xbOldk50QeWCiKa4d+zh
	 A3EBWgJnqDEFVN2zhYFBsi4soUXIKCOiHf21U33Fd5qKUw7+1+MaTl2w0sBsWWnFmA
	 F7P42OU/VAWYezbqdmYkm/3YiZGlpEekmOyHoNFLuS5U/S7ihiKoMGsE1APTFU3Jul
	 G7bBTMj58elvNa28InmigBbG2cL7t6aEPJfBddIcQ80tJb1hFeUspErKftZHOLj3HW
	 Ge72ZWFFWVY5RMb1EeX237FVZXr9PnpgZu6SLM0UVojt81Pg8TUnYP/gQa7VeN6oRD
	 2ljGODuCJ+xVhKpzW+Nv/Il8=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id DA80C40E01A3;
	Tue, 16 Sep 2025 10:54:53 +0000 (UTC)
Date: Tue, 16 Sep 2025 12:54:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
	Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <20250916105447.GCaMlB976WLxHHeNMD@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <20250915112510.GAaMf3lkd6Y1E_Oszg@fat_crate.local>
 <b56757b8-3055-455d-b31b-28094dd46231@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b56757b8-3055-455d-b31b-28094dd46231@intel.com>

On Mon, Sep 15, 2025 at 02:07:26PM -0700, Reinette Chatre wrote:
> I successfully completed as much testing as I can do

Thanks a lot - much appreciated!

> I noticed that you modified most changelogs to use closer to 80 characters
> per line, max of 81 characters. Considering this I plan to ignore the
> checkpatch.pl "Prefer a maximum 75 chars per line ..." warning from now on
> when it comes to changelogs and replace it with a check for 80 characters
> with same guidance to resctrl contributors.

Yeah, at least. Simply employ sane human judgement instead of blindly relying
on a tool. Sometimes the paragraph needs to have longer lines in order to fit
function names etc. And we don't use 80x25 terminals anymore so the 80 cols
rule is not even strict but a preferred one, as the coding-style.rst says.

> Thank you very much for catching and fixing the non-ASCII characters in
> patch #29. I added a new patch check step that checks for non-ASCII
> characters.

Sure, np.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

