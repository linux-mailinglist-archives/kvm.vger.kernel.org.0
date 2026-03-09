Return-Path: <kvm+bounces-73346-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKzRLvgMr2nHMwIAu9opvQ
	(envelope-from <kvm+bounces-73346-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:10:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7CD23E4CE
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDCB73034567
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B633EF0C1;
	Mon,  9 Mar 2026 18:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gI2aK8y+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57623EF0A0;
	Mon,  9 Mar 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079413; cv=none; b=RNyCQdjO1BaUS82RV9KVB9Ck8FqhoFGHsRF4zv50SRwFcrEN3evfRsTnGxc0XXxadA6SQwGrLpI3ut8QO5pFJ2y1JQG1EA56ALohY8BMw7/Ds16D8PyvXfIse8o06vxu//zrn2KyBWYJqSu160ouHD3VGTQMOKyryeoHAYWj0v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079413; c=relaxed/simple;
	bh=mfFYyaFbN/O1YfBRmMLt0ySeW7NEuIVVxDMZ1FTnxtg=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=t7brl0vgzSjYYDdG6Oo+eaFlgAxxmmzlIazPiIIg5HoVf68YsEYV+x7uRt/7DmK7Px/2rZk8zNkRJ2q7PO/27yc/dfH/J8zu88UhOOPxsK4LH0Bb4PVwsHIT2VTNp1F3I94M/4CvjZz2HQkotJ0uMfJ3LsyF0mMolRekaUUqlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gI2aK8y+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773079412; x=1804615412;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=mfFYyaFbN/O1YfBRmMLt0ySeW7NEuIVVxDMZ1FTnxtg=;
  b=gI2aK8y+OwNoGsaRK+mlqO+fBeWgy0LO4gIc9Cmq5R+hM0SP73+Bze+p
   oBe5OWaIIgg2hT6SEer+dlCFiSTzHyqYLKIyCE5zdsiPLQIuo2aaNHOd5
   db8APd6EwhcVhriXC9oKl9bPYBUVj5CY1a2ZaTez/qDdmdVNn/ppRmWVH
   R7n9JUaWJtoIdaipyhYoYaOqFyPWFiJaRwVibu6ihG5S3g5loYTECG7uT
   g+/frH6pa90QP45jwD1fcqeRB8j+YAZca+ufBJvcqqjUxu6YaPGt3fpC6
   CRwZbAqDaRJNk7C2RaSGM5aA64TYkA/+feIo4LghbFD6m/yj1ddJ3ljWY
   g==;
X-CSE-ConnectionGUID: 7LjDDEPYRACV6LMzYKyEmA==
X-CSE-MsgGUID: FOV7fQa2SsKojwZItznYFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="85463747"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="85463747"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 11:03:31 -0700
X-CSE-ConnectionGUID: 50M/u+KySvKZ6Q0PG8swvw==
X-CSE-MsgGUID: Im/YRD6BRBCLesqCQ68lqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="219772463"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.195]) ([10.125.109.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 11:03:31 -0700
Content-Type: multipart/mixed; boundary="------------MkPVvWUIej1M6m3WoIiNMTwR"
Message-ID: <70644e1d-dd0e-4f0f-81c0-fd095e46e50b@intel.com>
Date: Mon, 9 Mar 2026 11:03:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/cpu: Disable CR pinning during CPU bringup
To: Borislav Petkov <bp@alien8.de>
Cc: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, thomas.lendacky@amd.com, tglx@kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, xin@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
 sohil.mehta@intel.com, jon.grimm@amd.com
References: <20260226092349.803491-1-nikunj@amd.com>
 <20260226092349.803491-2-nikunj@amd.com>
 <20260309134640.GOaa7PQJli_C9QATGB@fat_crate.local>
 <cde957ba-3579-4063-9d17-3630e79ea388@intel.com>
 <20260309161516.GAaa7yFMulhdzNQ-pt@fat_crate.local>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260309161516.GAaa7yFMulhdzNQ-pt@fat_crate.local>
X-Rspamd-Queue-Id: 2B7CD23E4CE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.06 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73346-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	HAS_ATTACHMENT(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid]
X-Rspamd-Action: no action

This is a multi-part message in MIME format.
--------------MkPVvWUIej1M6m3WoIiNMTwR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/9/26 09:15, Borislav Petkov wrote:
> On Mon, Mar 09, 2026 at 08:38:10AM -0700, Dave Hansen wrote:
>> On 3/9/26 06:46, Borislav Petkov wrote:
>>> My SNP guest stops booting with this right:
>> Could you dump out CR4 at wakeup_cpu_via_vmgexit() before and after this
>> patch? Right here:
>>
>>         /* CR4 should maintain the MCE value */
>>         cr4 = native_read_cr4() & X86_CR4_MCE;
>>
>> It's got to be some delta there.
> Looks the same to me:
> 
> before:      31  SEV: wakeup_cpu_via_vmgexit: CR4: 0x3506f0
> 
> That's 31 CPUs - no BSP with the CR4 value above.
> 
> after: [    3.354326] SEV: wakeup_cpu_via_vmgexit: CR4: 0x3506f0
> 
> That stops after CPU1, i.e., the first AP. But the CR4 value is the same.

The only pinned bits in there are: SMAP, SMEP and FSGSBASE.

SMAP and SMEP are unlikely to be biting us here.

FSGSBASE is _possible_ but I don't see any of the {RD,WR}{F,G}SBASE
instructions in early boot where it would bite us.

Can you boot this thing without FSGSBASE support?

The other option would be to boot a working system, normally and see
what is getting flipped by pinning at cr4_init(). The attached patch
does that. It also uses trace_printk() so it hopefully won't trip over
#VC's during early boot with the console.

For me, it's flipping on 0x310800, which is:

	#define X86_CR4_OSXMMEXCPT      (1ul << 10)
	#define X86_CR4_FSGSBASE        (1ul << 16)
	#define X86_CR4_SMEP            (1ul << 20)
	#define X86_CR4_SMAP            (1ul << 21)

*Maybe* the paranoid entry code is getting called from the #VC handler
in early boot? It has ALTERNATIVEs on X86_FEATURE_FSGSBASE and might be
using the FSGSBASE instructions in there.

--------------MkPVvWUIej1M6m3WoIiNMTwR
Content-Type: text/x-patch; charset=UTF-8; name="cr4.patch"
Content-Disposition: attachment; filename="cr4.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgYi9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L2NvbW1vbi5jCmluZGV4IDAyNDcyZmM3NjNkOWIuLmNjNDA4ZWM4MTg4NzAg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKKysrIGIvYXJjaC94
ODYva2VybmVsL2NwdS9jb21tb24uYwpAQCAtNTAxLDEyICs1MDEsMjAgQEAgRVhQT1JUX1NZ
TUJPTF9GT1JfS1ZNKGNyNF9yZWFkX3NoYWRvdyk7CiB2b2lkIGNyNF9pbml0KHZvaWQpCiB7
CiAJdW5zaWduZWQgbG9uZyBjcjQgPSBfX3JlYWRfY3I0KCk7CisJdW5zaWduZWQgbG9uZyBw
cmVwaW5fY3I0OwogCiAJaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9QQ0lEKSkKIAkJ
Y3I0IHw9IFg4Nl9DUjRfUENJREU7CisJcHJlcGluX2NyNCA9IGNyNDsKIAlpZiAoc3RhdGlj
X2JyYW5jaF9saWtlbHkoJmNyX3Bpbm5pbmcpKQogCQljcjQgPSAoY3I0ICYgfmNyNF9waW5u
ZWRfbWFzaykgfCBjcjRfcGlubmVkX2JpdHM7CiAKKwlpZiAocHJlcGluX2NyNCAhPSBjcjQp
IHsKKwkJdHJhY2VfcHJpbnRrKCIgICAgIHByZXBpbl9jcjQ6IDB4JTAxNmx4XG4iLCBwcmVw
aW5fY3I0KTsKKwkJdHJhY2VfcHJpbnRrKCIgICAgICAgICAgICBjcjQ6IDB4JTAxNmx4XG4i
LCBjcjQpOworCQl0cmFjZV9wcmludGsoImNyNF9waW5uZWRfbWFzazogMHglMDE2bHhcbiIs
IGNyNF9waW5uZWRfbWFzayk7CisJCXRyYWNlX3ByaW50aygiY3I0X3Bpbm5lZF9iaXRzOiAw
eCUwMTZseFxuIiwgY3I0X3Bpbm5lZF9iaXRzKTsKKwl9CiAJX193cml0ZV9jcjQoY3I0KTsK
IAogCS8qIEluaXRpYWxpemUgY3I0IHNoYWRvdyBmb3IgdGhpcyBDUFUuICovCg==

--------------MkPVvWUIej1M6m3WoIiNMTwR--

