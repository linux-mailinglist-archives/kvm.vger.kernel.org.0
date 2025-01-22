Return-Path: <kvm+bounces-36305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C67A19B62
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A95FE1887C5B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7EEB1CBEA4;
	Wed, 22 Jan 2025 23:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BbhGj7pk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0A1C3C1A;
	Wed, 22 Jan 2025 23:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737587801; cv=none; b=WJrCpG1TQ37zgRq6p3tIqeEPXGvWK5HyohD08kQcIL59J/yk8tLBcff+CI0APSRXvlQ240yH2LF8uI9MXe8aHb/PJBwCoo5FbxXWwL4+E0n0FU7xN6H3GQ2Nr46AMPDzC2jKahdGRjOfLi+NJ9RWAoUZFwVODa6SBSEkzNisezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737587801; c=relaxed/simple;
	bh=bkPaVoLudwCXM7Z21kphw6E1T8ofBfSKYIHsCrjGcRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oILJz2QL9Jx/B48wKWlLIeSA7WxyHZLPqTq+eG2CLaZp8YPFYqNflxh/syvfJUQUIseBE2SZnnFrDPCUwLPbwpnLBymWjI1C4exHRc43dek06bea26tSKldDpmcwHpQ1Purr/HBtUDu13NIRtr4o/U0BsjNrddvBUePbnSOQJEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BbhGj7pk; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737587799; x=1769123799;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bkPaVoLudwCXM7Z21kphw6E1T8ofBfSKYIHsCrjGcRI=;
  b=BbhGj7pkKRYxhq2jXsSmr1VllcBUV+v+4xQiA6OKY9uqDBltHPvEEyKN
   twE6+uvNFIhbk/d+RpcKmen1mMebBmww+wa5FHBrDFpkTXEOcPtdgYxQM
   q+sSAWteKLaYBbXLKwR/BoYP4xY1IQo8fjCPmxWBF9Xkn/jaZZ0eoAv7w
   j88j2cUWTfm1wbGH9qM8Mq8L+FD2ew3zUDPQuyoUJFTWhGEiAGldaL3o4
   4Jgxl4/cEaZoJU1PpR2xZX5t29EGZ1ddTspiByx2gcsH+aEJ77/Mv+Kfj
   8GNz4gFeiipCw/q8JtPV2yWrhgStosCssfYDecZEqzSZWd7Vr07XLJRL+
   A==;
X-CSE-ConnectionGUID: o17pBahySgetrdvYfXXmIg==
X-CSE-MsgGUID: YQUUFwYQSnuGJ4Q1kfk0xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="41827004"
X-IronPort-AV: E=Sophos;i="6.13,226,1732608000"; 
   d="scan'208";a="41827004"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 15:16:38 -0800
X-CSE-ConnectionGUID: QlCIPAkpSf+NR2Y/tPrkeg==
X-CSE-MsgGUID: r4Ny4NLNRgC8l6XpOcl1RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,226,1732608000"; 
   d="scan'208";a="107881429"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.124.222.224]) ([10.124.222.224])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 15:16:37 -0800
Message-ID: <f98160b0-4f8b-41ab-b555-8e9de83c8552@intel.com>
Date: Wed, 22 Jan 2025 15:16:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86, lib: Add WBNOINVD helper functions
To: Tom Lendacky <thomas.lendacky@amd.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Kevin Loughlin <kevinloughlin@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
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
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <d2dce9d8-b79e-7d83-15a5-68889b140229@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/25 11:39, Tom Lendacky wrote:
>> I think you need to do something like.
>>
>> 	alternative("wbinvd", ".byte 0xf3; wbinvd", X86_FEATURE_WBNOINVD);
> I think "rep; wbinvd" would work as well.

I don't want to bike shed this too much.

But, please, no.

The fact that wbnoinvd can be expressed as "rep; wbinvd" is a
implementation detail. Exposing how it's encoded in the ISA is only
going to add confusion. This:

static __always_inline void wbnoinvd(void)
{
        asm volatile(".byte 0xf3,0x0f,0x09\n\t": : :"memory");
}

is perfectly fine and a billion times less confusing than:

        asm volatile(".byte 0xf3; wbinvd\n\t": : :"memory");
or
        asm volatile("rep; wbinvd\n\t": : :"memory");

It only gets worse if it's mixed in an alternative() with the _actual_
wbinvd.

BTW, I don't think you should be compelled to use alternative() as
opposed to a good old:

	if (cpu_feature_enabled(X86_FEATURE_WBNOINVD))
		...


