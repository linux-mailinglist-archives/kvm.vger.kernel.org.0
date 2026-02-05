Return-Path: <kvm+bounces-70355-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GIYQOJLRhGk45QMAu9opvQ
	(envelope-from <kvm+bounces-70355-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:21:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F285CF5D55
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3D191300D261
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 17:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D4E30CD87;
	Thu,  5 Feb 2026 17:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GALJfpwf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3D21A453;
	Thu,  5 Feb 2026 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770312023; cv=none; b=T5u6FFnBhZxB1a6V/WjwjbhfZiJATYRqfFsI9grbo23P67/KcgtT1mMzEfkR0bP6ytQkF/MO31GfjjbAyUomA82omMDLOMbSjJx81eAUK1RsgQjKIRfUyosZ+7uOLI3xzjzCLMWT9bKmYl3h2zZa22PazEmG2CsM3OlRHfLxHJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770312023; c=relaxed/simple;
	bh=gv0h/7dYtyPgq/IK/dOGuHkuLQzs30g0Qpln4FWpChc=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=dCqL8gDbW47LKkbQkP+qS+UHqWSsQkjhokr2bucVWsqsU8SAZAhj9J0sPwZhXhLHK2WZf4E/NHHC7KkN6zpwyrc1E7hNvp/YyUU+NW3J+cStVlHHEECnleFjTcGyESWi6QZkmZU0WFBe4P7zJsFEcRPsSb+VEmpz3OEt3b0et0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GALJfpwf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770312023; x=1801848023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=gv0h/7dYtyPgq/IK/dOGuHkuLQzs30g0Qpln4FWpChc=;
  b=GALJfpwfUfvlrUW++QeB7/tGuNcSg+Cma3LvzgA2qOLJ9jkrGaieB0dy
   V7s4H2MQ0yLhFsyTff+Izrl5crIwYnsGtC5OH0V9Yfc5MHAdZi9ZXeHSe
   BqWKPEAVJWwdzk3W0RQaBP/1rIFub2ZVZf1gZN3J7KXJ4vWAE1gd/MQcF
   LYrdKDzIDfK8yvghlJQdKFAFzV6M9zj3TL1yo0OcyN53hfUWGPVcNDTsv
   DjuuAGxM6a0yTV8fOPFp8NwXJ3dlNWFLl5Ea5jgdtxqBEUaS/mzOav7VO
   tvsxELL9okfAh6y5YVV2ZUbSp11pg0VK4N/Acij1RTe2/nSu/4J1zXUJO
   w==;
X-CSE-ConnectionGUID: fQtpNkpIS0es7MVXI8JJmg==
X-CSE-MsgGUID: crH3KWuuQlaadpLpkdpkvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="75135244"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="75135244"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 09:20:23 -0800
X-CSE-ConnectionGUID: d66xjIYIRS+/t/iDfH4O1A==
X-CSE-MsgGUID: MQeKjJ0DQ3ScgAIVex3fVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210652700"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.86]) ([10.125.111.86])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 09:20:21 -0800
Content-Type: multipart/mixed; boundary="------------QggAxsgGl20AkxkHbNXp368e"
Message-ID: <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
Date: Thu, 5 Feb 2026 09:20:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, thomas.lendacky@amd.com
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, xin@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 x86@kernel.org, jon.grimm@amd.com, stable@vger.kernel.org
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.06 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70355-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: F285CF5D55
X-Rspamd-Action: no action

This is a multi-part message in MIME format.
--------------QggAxsgGl20AkxkHbNXp368e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/26 08:10, Dave Hansen wrote:
> Shouldn't we flip the FRED CR4 bit _last_, once all the MSRs are set up?
> Why is it backwards in the first place? Why can't it be fixed?

Ahhh, it was done by CR4 pinning. It's the first thing in C code for
booting secondaries:

static void notrace __noendbr start_secondary(void *unused)
{
        cr4_init();

Since FRED is set in 'cr4_pinned_mask', cr4_init() sets the FRED bit far
before the FRED MSRs are ready. Anyone else doing native_write_cr4()
will do the same thing. That's obviously not what was intended from the
pinning code or the FRED init code.

Shouldn't we fix this properly rather than moving printk()'s around?

One idea is just to turn off all the CR-pinning logic while bringing
CPUs up. That way, nothing before:

	set_cpu_online(smp_processor_id(), true);

can get tripped up by CR pinning. I've attached a completely untested
patch to do that.

The other thing would be to make pinning actually per-cpu:
'cr4_pinned_bits' could be per-cpu and we'd just keep it empty until the
CPU is actually booted and everything is fully set up.

Either way, this is looking like it'll be a bit more than one patch to
do properly.
--------------QggAxsgGl20AkxkHbNXp368e
Content-Type: text/x-patch; charset=UTF-8;
 name="no-cr4-pinning-for-offline-cpus.patch"
Content-Disposition: attachment;
 filename="no-cr4-pinning-for-offline-cpus.patch"
Content-Transfer-Encoding: base64

CgotLS0KCiBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgfCAgIDIxICsrKysrKysr
KysrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pCgpkaWZmIC1wdU4gYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uY35uby1j
cjQtcGlubmluZy1mb3Itb2ZmbGluZS1jcHVzIGFyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9u
LmMKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uY35uby1jcjQtcGlubmluZy1m
b3Itb2ZmbGluZS1jcHVzCTIwMjYtMDItMDUgMDg6Mjc6NDAuNzQzNTM5MDY0IC0wODAwCisr
KyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMJMjAyNi0wMi0wNSAwOToxMDowOC44
MTUxMzQ1NzcgLTA4MDAKQEAgLTQzNCw2ICs0MzQsMjEgQEAgc3RhdGljIGNvbnN0IHVuc2ln
bmVkIGxvbmcgY3I0X3Bpbm5lZF9tYQogc3RhdGljIERFRklORV9TVEFUSUNfS0VZX0ZBTFNF
X1JPKGNyX3Bpbm5pbmcpOwogc3RhdGljIHVuc2lnbmVkIGxvbmcgY3I0X3Bpbm5lZF9iaXRz
IF9fcm9fYWZ0ZXJfaW5pdDsKIAorc3RhdGljIGJvb2wgY3I0X3Bpbm5pbmdfZW5hYmxlZCh2
b2lkKQoreworCWlmICghc3RhdGljX2JyYW5jaF9saWtlbHkoJmNyX3Bpbm5pbmcpKQorCQly
ZXR1cm4gZmFsc2U7CisKKwkvKgorCSAqIERvIG5vdCBlbmZvcmNlIHBpbm5pbmcgZHVyaW5n
IENQVSBicmluZ3VwLiBJdCBtaWdodAorCSAqIHR1cm4gb24gZmVhdHVyZXMgdGhhdCBhcmUg
bm90IHNldCB1cCB5ZXQsIGxpa2UgRlJFRC4KKwkgKi8KKwlpZiAoIWNwdV9vbmxpbmUoc21w
X3Byb2Nlc3Nvcl9pZCgpKSkKKwkJcmV0dXJuIGZhbHNlOworCisJcmV0dXJuIHRydWU7Cit9
CisKIHZvaWQgbmF0aXZlX3dyaXRlX2NyMCh1bnNpZ25lZCBsb25nIHZhbCkKIHsKIAl1bnNp
Z25lZCBsb25nIGJpdHNfbWlzc2luZyA9IDA7CkBAIC00NDEsNyArNDU2LDcgQEAgdm9pZCBu
YXRpdmVfd3JpdGVfY3IwKHVuc2lnbmVkIGxvbmcgdmFsKQogc2V0X3JlZ2lzdGVyOgogCWFz
bSB2b2xhdGlsZSgibW92ICUwLCUlY3IwIjogIityIiAodmFsKSA6IDogIm1lbW9yeSIpOwog
Ci0JaWYgKHN0YXRpY19icmFuY2hfbGlrZWx5KCZjcl9waW5uaW5nKSkgeworCWlmIChjcjRf
cGlubmluZ19lbmFibGVkKCkpIHsKIAkJaWYgKHVubGlrZWx5KCh2YWwgJiBYODZfQ1IwX1dQ
KSAhPSBYODZfQ1IwX1dQKSkgewogCQkJYml0c19taXNzaW5nID0gWDg2X0NSMF9XUDsKIAkJ
CXZhbCB8PSBiaXRzX21pc3Npbmc7CkBAIC00NjAsNyArNDc1LDcgQEAgdm9pZCBfX25vX3By
b2ZpbGUgbmF0aXZlX3dyaXRlX2NyNCh1bnNpZwogc2V0X3JlZ2lzdGVyOgogCWFzbSB2b2xh
dGlsZSgibW92ICUwLCUlY3I0IjogIityIiAodmFsKSA6IDogIm1lbW9yeSIpOwogCi0JaWYg
KHN0YXRpY19icmFuY2hfbGlrZWx5KCZjcl9waW5uaW5nKSkgeworCWlmIChjcjRfcGlubmlu
Z19lbmFibGVkKCkpIHsKIAkJaWYgKHVubGlrZWx5KCh2YWwgJiBjcjRfcGlubmVkX21hc2sp
ICE9IGNyNF9waW5uZWRfYml0cykpIHsKIAkJCWJpdHNfY2hhbmdlZCA9ICh2YWwgJiBjcjRf
cGlubmVkX21hc2spIF4gY3I0X3Bpbm5lZF9iaXRzOwogCQkJdmFsID0gKHZhbCAmIH5jcjRf
cGlubmVkX21hc2spIHwgY3I0X3Bpbm5lZF9iaXRzOwpAQCAtNTAyLDcgKzUxNyw3IEBAIHZv
aWQgY3I0X2luaXQodm9pZCkKIAogCWlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfUENJ
RCkpCiAJCWNyNCB8PSBYODZfQ1I0X1BDSURFOwotCWlmIChzdGF0aWNfYnJhbmNoX2xpa2Vs
eSgmY3JfcGlubmluZykpCisJaWYgKGNyNF9waW5uaW5nX2VuYWJsZWQoKSkKIAkJY3I0ID0g
KGNyNCAmIH5jcjRfcGlubmVkX21hc2spIHwgY3I0X3Bpbm5lZF9iaXRzOwogCiAJX193cml0
ZV9jcjQoY3I0KTsKXwo=

--------------QggAxsgGl20AkxkHbNXp368e--

