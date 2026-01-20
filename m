Return-Path: <kvm+bounces-68640-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SAUXFMrgb2n8RwAAu9opvQ
	(envelope-from <kvm+bounces-68640-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:08:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D621F4B090
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DDE2F9E95E7
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6FA44B672;
	Tue, 20 Jan 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDYDoExI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D624943CED2
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932551; cv=none; b=SUhJzUwSiW5ileg9Pq6N1kIT4NRunlMxf8R6UDzrNBn4TfoZu+8Qval1BlEnsPdbMR1Pebl4ugvks5Ejn24Eq02R+eSNYz8cXvPluCOQD6esBJDEygg+fxNHx9Qyi1VX47kzPXc8b7/5NDZJIfnhjEuT+hz6uJ6qPtGzBI5kyh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932551; c=relaxed/simple;
	bh=KBTrGAOG3GHU/Gh2kayZjePQbGcEh734b6U31OPXquI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLKKbWoUodpAuTNQrMps/9/aKZXjy4Ofd+HORNE5lCIvPdFh5UrGKbSoA5tl1P+i35GZvsyPA70pg8iIEB7auccBAKVVjwkBn6e+cHQWKqEe0B4BbOEIxWZoL0uV2Lq1BKsxDFRX5qQkcAJYtQcunwjajRdtZsRsqERa8cy6/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDYDoExI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768932550; x=1800468550;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KBTrGAOG3GHU/Gh2kayZjePQbGcEh734b6U31OPXquI=;
  b=gDYDoExIqPi3s7Ze66Zx7CFGgpZGkyZCnZqUj6o6kbq92YZ+fYbWs7/b
   f0dk3cDSBfDNsam74TsajGmHSGWXRZ2IL5VDgdaCoANHKAGE3YXjkIHRr
   UmnlqbmTtam/rWgIpwIgh3tkwJYH7Zbo3OU2XbmSiKaZFBMHvxWkSm0ig
   lGDvXiSnEzgCEl8bAFbum7r2Xk7HcTMZ9oZclRJirJZ4Z6aJT9iG6YHGE
   ssPfejwTcFqMmEVehZbY6UVVIJwnIfzwxk53rsdCRwtlkxvOEV8RKGE1d
   5KNiTV9sXvDqxmtCw9U3qVVv97M1Pb7D750MrHUDjBMHAdFw6qny6kPKQ
   A==;
X-CSE-ConnectionGUID: jVnXlSMCQjCblp9UEL9ObA==
X-CSE-MsgGUID: ViFFpME2QG6pvZgQahgXWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="80454734"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="80454734"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 10:09:09 -0800
X-CSE-ConnectionGUID: 1DZXw2idSMaL80mK8mZe4g==
X-CSE-MsgGUID: 0KkiTAtjRmauPNmX3UZ3Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="237444273"
Received: from unknown (HELO [10.241.241.232]) ([10.241.241.232])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 10:09:06 -0800
Message-ID: <8e73265d-378e-4257-9171-ca67a103da14@intel.com>
Date: Tue, 20 Jan 2026 10:09:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] target/i386: Disable unsupported BTS for guest
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-2-zide.chen@intel.com>
 <d3be3cd0-5dce-4410-b2f8-e137562a678c@linux.intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <d3be3cd0-5dce-4410-b2f8-e137562a678c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68640-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: D621F4B090
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 1/18/2026 5:47 PM, Mi, Dapeng wrote:
> 
> On 1/17/2026 9:10 AM, Zide Chen wrote:
>> BTS (Branch Trace Store), enumerated by IA32_MISC_ENABLE.BTS_UNAVAILABLE
>> (bit 11), is deprecated and has been superseded by LBR and Intel PT.
>>
>> KVM yields control of the above mentioned bit to userspace since KVM
>> commit 9fc222967a39 ("KVM: x86: Give host userspace full control of
>> MSR_IA32_MISC_ENABLES").
>>
>> However, QEMU does not set this bit, which allows guests to write the
>> BTS and BTINT bits in IA32_DEBUGCTL.  Since KVM doesn't support BTS,
>> this may lead to unexpected MSR access errors.
>>
>> Setting this bit does not introduce migration compatibility issues, so
>> the VMState version_id is not bumped.
>>
>> Signed-off-by: Zide Chen <zide.chen@intel.com>
>> ---
>>  target/i386/cpu.h | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 2bbc977d9088..f2b79a8bf1dc 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -474,7 +474,10 @@ typedef enum X86Seg {
>>  
>>  #define MSR_IA32_MISC_ENABLE            0x1a0
>>  /* Indicates good rep/movs microcode on some processors: */
>> -#define MSR_IA32_MISC_ENABLE_DEFAULT    1
>> +#define MSR_IA32_MISC_ENABLE_FASTSTRING    1
> 
> To keep the same code style and make users clearly know the macro is a
> bitmask, better define MSR_IA32_MISC_ENABLE_FASTSTRING like below.
> 
> #define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)

Yes. Thanks.

> 
>> +#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
>> +#define MSR_IA32_MISC_ENABLE_DEFAULT       (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
>> +                                            MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
> 
> Better move the macro "MSR_IA32_MISC_ENABLE_DEFAULT" after
> "MSR_IA32_MISC_ENABLE_MWAIT".
> 

Thanks. Will do.

>>  #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
>>  
>>  #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))


