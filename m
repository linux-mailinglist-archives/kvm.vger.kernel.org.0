Return-Path: <kvm+bounces-36311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE2FA19BD1
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EC0616995C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C74717993;
	Thu, 23 Jan 2025 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFLnhNyN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA5EF50F;
	Thu, 23 Jan 2025 00:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737592387; cv=none; b=NiKzP8Pk1VJc+g//m4PnnE0B4nlypyFVKEFt0TWtaq/R/z3uSSrSPhQeMEIKXKAP41GIMsGZM4ImQTVGnf6gIobAUXVG7rSlEXcqr/2UnYoPb18NfIaPyMSIRn2i8G1apSBw6rITjI4lrlvgH5KLXvCJARmPk2wu30waC6TI7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737592387; c=relaxed/simple;
	bh=h28eMJyE3PwRYXBGQKjxawEU3KLaC2296RpEr+y+gyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OnL3oFLT9S2v/0qgHZE0lNqY3KCrdiCgOPRk1NqwQiGE4n1TZZgBXQVB+meT3AnBYsIbkyGWkkFkWFcCdW+sf00zO3zKjL3HbeoJn5cX7HwoldCcqNNlsiGJXUAKQFt1Ny6xtcBmYGKTMhe9vg9vjQFJDnPevJpunYE8o2lIoBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFLnhNyN; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737592386; x=1769128386;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h28eMJyE3PwRYXBGQKjxawEU3KLaC2296RpEr+y+gyA=;
  b=XFLnhNyNBON246jOmlFmNAZ6ChKRksIzSaj3OwzGomQ1CGQA3H0yiCPh
   YFPdvtuP36E9l9SKb5WVURbbOfqA9RffIScmZ5RlURr6hw77ZlNbS7PSN
   WdBgNf0eShpUA8epavQy7m2FGIF0Q1J33qb+jScIRlzG5+zTAslgIA8AA
   scKy8Fld7dC/CR551Z6NSt7eYXF1m69I0wqcrHMS9bb0J5RlmupHcUmUF
   PF2OrcozN0TVSimIGqWUEjft8RPxZeAFD9er0T6AzMZhOSpJL0JMTvLan
   OkL3v8dHgiQsbF0S1pUr8ECmtYuB8PMxI73Wl4Fh+KlAAf5EAbgMU6u8v
   w==;
X-CSE-ConnectionGUID: y8t1rPGxQCm7uc7EH4Q88A==
X-CSE-MsgGUID: 8yWAnAtpTTKlJApEfAEfJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="49066111"
X-IronPort-AV: E=Sophos;i="6.13,226,1732608000"; 
   d="scan'208";a="49066111"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 16:33:05 -0800
X-CSE-ConnectionGUID: e4eqRPTXQySwRf1exSNBfg==
X-CSE-MsgGUID: 7SeFBbE8SquXTsKg8apaKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,226,1732608000"; 
   d="scan'208";a="112330363"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.124.222.224]) ([10.124.222.224])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 16:33:02 -0800
Message-ID: <3dd183fa-df95-487e-a2e9-73579fa160be@intel.com>
Date: Wed, 22 Jan 2025 16:33:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
 ubizjak@gmail.com, jgross@suse.com, kvm@vger.kernel.org, pgonda@google.com,
 sidtelang@google.com, mizhang@google.com, rientjes@google.com,
 manalinandan@google.com, szy0127@sjtu.edu.cn
References: <20250122001329.647970-1-kevinloughlin@google.com>
 <20250122013438.731416-1-kevinloughlin@google.com>
 <20250122013438.731416-2-kevinloughlin@google.com>
 <aomvugehkmfj6oi7bwmtiqfbdyet7zyd2llri3c5rgcmgqjkfz@tslxstgihjb5>
 <d2dce9d8-b79e-7d83-15a5-68889b140229@amd.com>
 <f98160b0-4f8b-41ab-b555-8e9de83c8552@intel.com>
 <CAGdbjm+syon_W0W_oEiDJBKu4s5q9JS9cKyPmPoqDAzeyMJf3Q@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAGdbjm+syon_W0W_oEiDJBKu4s5q9JS9cKyPmPoqDAzeyMJf3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/25 16:06, Kevin Loughlin wrote:
>> BTW, I don't think you should be compelled to use alternative() as
>> opposed to a good old:
>>
>>         if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
>>                 ...
> Agreed, though I'm leaving as alternative() for now (both because it
> results in fewer checks and because that's what is used in the rest of
> the file); please holler if you prefer otherwise. If so, my slight
> preference in that case would be to update the whole file
> stylistically in a separate commit.

alternative() can make a _lot_ of sense.  It's extremely compact in the
code it generates. It messes with compiler optimization, of course, just
like any assembly. But, overall, it's great.

In this case, though, we don't care one bit about code generation or
performance. We're running the world's slowest instruction from an IPI.

As for consistency, special_insns.h is gloriously inconsistent. But only
two instructions use alternatives, and they *need* the asm syntax
because they're passing registers and meaningful constraints in.

The wbinvds don't get passed registers and their constraints are
trivial. This conditional:

        alternative_io(".byte 0x3e; clflush %0",
                       ".byte 0x66; clflush %0",
                       X86_FEATURE_CLFLUSHOPT,
                       "+m" (*(volatile char __force *)__p));

could be written like this:

	if (cpu_feature_enabled(X86_FEATURE_CLFLUSHOPT))
	        asm volatile(".byte 0x3e; clflush %0",
                       "+m" (*(volatile char __force *)__p));
	else
		asm volatile(".byte 0x66; clflush %0",
                       "+m" (*(volatile char __force *)__p));

But that's _actively_ ugly.  alternative() syntax there makes sense.
Here, it's not ugly at all:

	if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
		asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
	else
		wbinvd();

and it's actually more readable with alternative() syntax.

So, please just do what makes the code look most readable. Performance
and consistency aren't important. I see absolutely nothing wrong with:

static __always_inline void raw_wbnoinvd(void)
{
        asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
}

void wbnoinvd(void)
{
	if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
		raw_wbnoinvd();
	else
		wbinvd();
}

... except the fact that cpu_feature_enabled() kinda sucks and needs
some work, but that's a whole other can of worms we can leave closed today.

