Return-Path: <kvm+bounces-30749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 548279BD22F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A84EFB22957
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777CF183CA7;
	Tue,  5 Nov 2024 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQCL75+C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA3914A4DC;
	Tue,  5 Nov 2024 16:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823575; cv=none; b=a/m/puAhCBjNQOCFOcvlzvEh/G0289cSCwaekhVzHMN3hSPLSdWLCc4Zq5z9DxmWRCWtXR1OL/KatfRVmUhw7H6AOJjHwJqf45QESmlGFVd8DXmqs9w7IueAfnJWLJcf7COxai7g7EdB5qzYkcfDiXnXp+o9lJlJLnyuEifdW9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823575; c=relaxed/simple;
	bh=qJNMnp+LrrgIGj5CZr93+j1C+pialaLH7dJc6Y+9Abo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SVsRd4G7beMAzj053EMtiy11fGhY2+shzeItC01dOwFtAM7pm0wabsocXtk4TDNcxdncgsrgMEC47ZLwMY8gFridBsWtnttUI9ccic+I1jjmaHj5jurWXw8OUL3vqiq3ZSiRvsMCopjSCfJvaHmEvIZX67oATaRWnOsko6JqWEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQCL75+C; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730823574; x=1762359574;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qJNMnp+LrrgIGj5CZr93+j1C+pialaLH7dJc6Y+9Abo=;
  b=BQCL75+Cql/M73WdkAAlAZO2++mBDFPlzcC4YzzJHNICWHmQx7rI4uPC
   LR/9L8e5HOQEqELF3rGcwuk8xnYc98ewKZv02blJY4KyKxJZCrVpfWxSJ
   k8bwYTFZeh9y6vJUNQpTv4UCUgqEWtZFBQ2R5ytJHtlZ8adY64mvkZ1CA
   vRoeuPB77MC4nzbGIxDI4Q0B1bfLvXINb09rveHPa0I173w9e3EEbPTNP
   A809nBA6mxnNa4bmpQI4IG9XB6AvFJ8/He8077IgZfJzWx/I6vLzbmdBf
   sWhynPK0OjmN699olhDeoZSAFSS6MLfhTwXpu3jKfbz8ELx2tFYA096U8
   w==;
X-CSE-ConnectionGUID: 28IeSjOeQNCWBGE2qVZaIA==
X-CSE-MsgGUID: lxmuGPFPRjqBAfg0/sQQvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41685705"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41685705"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 08:19:33 -0800
X-CSE-ConnectionGUID: rqykdkczQ828ldwGq4612g==
X-CSE-MsgGUID: ChPcx99zRgCim36FNRxJvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="88587469"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.124.221.212]) ([10.124.221.212])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 08:19:32 -0800
Message-ID: <a296a079-fec6-42d7-82fe-b1b7e9004230@intel.com>
Date: Tue, 5 Nov 2024 08:19:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
To: "Shah, Amit" <Amit.Shah@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
 "kai.huang@intel.com" <kai.huang@intel.com>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "Moger, Babu"
 <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
 "Kaplan, David" <David.Kaplan@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
 <20241031153925.36216-2-amit@kernel.org>
 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
 <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
 <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
 <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
 <62063466-69bc-4eca-9f22-492c70b02250@intel.com>
 <975a74f19f9c8788e5abe99d37ca2b7697b55a23.camel@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <975a74f19f9c8788e5abe99d37ca2b7697b55a23.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/5/24 02:39, Shah, Amit wrote:
> On Mon, 2024-11-04 at 09:45 -0800, Dave Hansen wrote:
> I'm expecting the APM update come out soon, but I have put together
> 
> https://amitshah.net/2024/11/eraps-reduces-software-tax-for-hardware-bugs/
> 
> based on information I have.  I think it's mostly consistent with what
> I've said so far - with the exception of the mov-CR3 flush only
> confirmed yesterday.

That's better.  But your original cover letter did say:

	Feature documented in AMD PPR 57238.

which is technically true because the _bit_ is defined.  But it's far,
far from being sufficiently documented for Linux to actually use it.

Could we please be more careful about these in the future?

>> So, I'll flip this back around.  Today, X86_FEATURE_RSB_CTXSW zaps
>> the
>> RSB whenever RSP is updated to a new task stack.  Please convince me
>> that ERAPS provides superior coverage or is unnecessary in all the
>> possible combinations switching between:
>>
>> 	different thread, same mm
> 
> This case is the same userspace process with valid addresses in the RSB
> for that process.  An invalid speculation isn't security sensitive,
> just a misprediction that won't be retired.  So we are good here.

Does that match what the __switch_to_asm comment says, though?

>         /*
>          * When switching from a shallower to a deeper call stack
>          * the RSB may either underflow or use entries populated
>          * with userspace addresses. On CPUs where those concerns
>          * exist, overwrite the RSB with entries which capture
>          * speculative execution to prevent attack.
>          */

It is also talking just about call depth, not about same-address-space
RSB entries being harmless.  That's because this is also trying to avoid
having the kernel consume any user-placed RSB entries, regardless of
whether they're from the same mm or not.

>> 	user=>kernel, same mm
>> 	kernel=>user, same mm
> 
> user-kernel is protected with SMEP.  Also, we don't call
> FILL_RETURN_BUFFER for these switches?

Amit, I'm beginning to fear that you haven't gone and looked at the
relevant code here.  Please go look at SYM_FUNC_START(__switch_to_asm)
in arch/x86/entry/entry_64.S.  I believe this code is called for all
task switches, including switching from a user task to a kernel task.  I
also believe that FILL_RETURN_BUFFER is used unconditionally for every
__switch_to_asm call (when X86_FEATURE_RSB_CTXSW is on of course).

Could we please start over on this patch?

Let's get the ERAPS+TLB-flush nonsense out of the kernel and get the
commit message right.

Then let's go from there.

