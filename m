Return-Path: <kvm+bounces-57250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9D1B52198
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43304565ECB
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0881A2EF664;
	Wed, 10 Sep 2025 20:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="KFXwlq//";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="9cIp2XSP"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5252BB1D;
	Wed, 10 Sep 2025 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757535021; cv=none; b=iDJ0ZI98y2TCJySuF0l9iTgVzuoQMjdJTidMItU5+S5WBC5I5P7HYYfEHIS1gPjrtrKnhLj5UxU56SPOe0hS94J2FARNduOhfpos9jLAYawoAX07HdiC1lXJD/RcklvFBHhFKtd+5tkqxDgJ4LMgevtIQDQ4hDk9HS1qY8aSZzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757535021; c=relaxed/simple;
	bh=mjnlmH46vqpUybfgGI0GS2mBSC0pyBMO3eFuAUlJV7U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pa0paYQx7W81ePzKtD48iXAheb8JC++Pw1rwudYNSat6K4QM9dGIakX+9w3nB0Ltjr5q3H4lSPk1+zbGu+Ofpdst4bINzMC6QmrWLoZVX3e+Up9niYCbAI5M/9GEXZiE2sDI6Ye4Y71hbhGDnw9M1tSYwXwDxRLYNKD59gemDmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=KFXwlq//; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=9cIp2XSP; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1757535016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6mXI0MTVp+bH+g5mA/2NKnCLozHXgMVpvTCY2YWC3M=;
	b=KFXwlq//dUndcehlpb7inmHGwD1eHjIW42/VrrODS7bVJHHTp342kxF5EFXbIQn51ulmZT
	arD+8qvvbdeuWYzJx7Bb1DsHeulrrVJX9T04IIfa8DyXcVuafQogDKdCDLA9JTEL+cfz52
	4JA25jbkgFjzQEqbmZhNl3eX8FoocLxWPX//lqjhHUvtzu7KG0Gq7O/4jyGhQTDctwpt3e
	N+7Q9xZO97I621SvXSO/vSjkkhzsaYkKZB+uNo7T1dv0lctARoP1MH/LRs09OskEUW8Wem
	+uRxsDlVJeTpw2Qnz2deHiMUL+8JVpK+liKPUBATeaKGuUrP0lPHO3sdQWac/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1757535016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6mXI0MTVp+bH+g5mA/2NKnCLozHXgMVpvTCY2YWC3M=;
	b=9cIp2XSP1UIAp4oO9SV5sxJh/Ku64vQiWZeqLjc7gqy1cXzCvd7jQkABSMMjXxo4i20v9j
	k/BcSLjVuzI115CQ==
To: K Prateek Nayak <kprateek.nayak@amd.com>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 x86@kernel.org
Cc: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
 <pawan.kumar.gupta@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Mario Limonciello <mario.limonciello@amd.com>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
 <babu.moger@amd.com>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 stable@vger.kernel.org, Naveen N
 Rao <naveen@kernel.org>
Subject: Re: [PATCH v5 1/4] x86/cpu/topology: Always try
 cpu_parse_topology_ext() on AMD/Hygon
In-Reply-To: <20250901170418.4314-2-kprateek.nayak@amd.com>
References: <20250901170418.4314-1-kprateek.nayak@amd.com>
 <20250901170418.4314-2-kprateek.nayak@amd.com>
Date: Wed, 10 Sep 2025 22:10:15 +0200
Message-ID: <87o6rirrvc.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Sep 01 2025 at 17:04, K. Prateek Nayak wrote:
> Unconditionally call cpu_parse_topology_ext() on AMD and Hygon
> processors to first parse the topology using the XTOPOLOGY leaves
> (0x80000026 / 0xb) before using the TOPOEXT leaf (0x8000001e).
>
> While at it, break down the single large comment in parse_topology_amd()
> to better highlight the purpose of each CPUID leaf.
>
> Cc: stable@vger.kernel.org # Only v6.9 and above; Depends on x86 topology rewrite
> Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
> Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
> Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
> Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> ---
> Changelog v4..v5:
>
> o Made a note on only targeting versions >= v6.9 for stable backports
>   since the fix depends on the x86 topology rewrite. (Boris)

Shouldn't that be backported? I think so, so leave that v6.9 and above
comment out. The stable folks will notice that it does not apply to pre
6.9 kernels and send you a nice email asking you to provide a solution
for pre 6.9 stable kernels.

Thanks,

        tglx

