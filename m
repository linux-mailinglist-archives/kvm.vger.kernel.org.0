Return-Path: <kvm+bounces-73005-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEf9CpugqmlLUgEAu9opvQ
	(envelope-from <kvm+bounces-73005-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:38:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B31221E134
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D8D87306242A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2675346A1F;
	Fri,  6 Mar 2026 09:36:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98738341AD6
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 09:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772789784; cv=none; b=uGQjin0bOQqIZR4ulOT2gyxZuNF7l2kAlb6VZEtZV9dke2/U+osmJQNk8fUgn5sloGN/rq0ypRUBDbI6Kq3ahSQkDgCVHeqHILq9at3hXTSjUCHCx7SxHkEODpejnVnT+xI3yDAd37HT5LOR3+D6WlEqz9tdvia7w6KH1AqM2is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772789784; c=relaxed/simple;
	bh=aNf+1Sju5FqmSNLvPwNju4jHtRGQlyCVOCZYMGr4LY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Sf+qFOL897ACnBnyJWRWuULFCbEoQP6Qh6dYhE5VaKj2b9kkdzvy+ah3600PzZVWV504ad7qr5687f7SsVCAfhft/0glKDHS79v8AZkZuBAbG0Nzc6vAlsDxZw8WiIkb2YIEkt9elbVQ5lZPZiu04f8Clo63ftjIMogp2u8fbEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1772789770-086e235c855d6b0001-HEqcsx
Received: from ZXBJMBX02.zhaoxin.com (ZXBJMBX02.zhaoxin.com [10.29.252.6]) by mx1.zhaoxin.com with ESMTP id hoLwjjbQVw1crtgc (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 06 Mar 2026 17:36:10 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.6
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Fri, 6 Mar
 2026 17:36:09 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Fri, 6 Mar 2026 17:36:09 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.6
Received: from ewan-server.zhaoxin.com (10.28.44.15) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Fri, 6 Mar
 2026 17:12:56 +0800
Received: from [10.28.44.4] (EwanHaiuntuMini.zhaoxin.com [10.28.44.4])
	by ewan-server.zhaoxin.com (Postfix) with ESMTP id 72B722D0004E;
	Fri,  6 Mar 2026 04:12:56 -0500 (EST)
Message-ID: <940af9a3-399d-4981-95c3-794d4f834ea8@zhaoxin.com>
Date: Fri, 6 Mar 2026 17:12:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Add KVM-only CPUID.0xC0000001:EDX feature bits
To: Sean Christopherson <seanjc@google.com>
X-ASG-Orig-Subj: Re: [PATCH] KVM: x86: Add KVM-only CPUID.0xC0000001:EDX feature bits
CC: <pbonzini@redhat.com>, <tglx@kernel.org>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cobechen@zhaoxin.com>, <tonywwang@zhaoxin.com>, <ludloff@gmail.com>
References: <20260305110519.308860-1-ewanhai-oc@zhaoxin.com>
 <aanc9xtztj5cYFvk@google.com>
Content-Language: en-US
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <aanc9xtztj5cYFvk@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 3/6/2026 5:36:07 PM
X-Barracuda-Connect: ZXBJMBX02.zhaoxin.com[10.29.252.6]
X-Barracuda-Start-Time: 1772789770
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://mx2.zhaoxin.com:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 4770
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155454
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
X-Rspamd-Queue-Id: 8B31221E134
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,zhaoxin.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-73005-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[zhaoxin.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[ewanhai-oc@zhaoxin.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.988];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,zhaoxin.com:mid,zhaoxin.com:email]
X-Rspamd-Action: no action

On 3/6/26 3:43 AM, Sean Christopherson wrote:
> 
> 
> On Thu, Mar 05, 2026, Ewan Hai wrote:
>> Per Paolo's suggestion, add the missing CPUID.0xC0000001:EDX feature
>> bits as KVM-only X86_FEATURE_* definitions, so KVM can expose them to
>> userspace before they are added to the generic cpufeatures definitions.
>>
>> Wire the new bits into kvm_set_cpu_caps() for CPUID_C000_0001_EDX.
>>
>> As a result, KVM_GET_SUPPORTED_CPUID reports these bits according to
>> host capability, allowing VMMs to advertise only host-supported
>> features to guests.
> 
> There needs to be a _lot_ more documentation explaining what these features are,
> and most importantly why it's safe/sane for KVM to advertise support to userspace
> without any corresponding code changes in KVM.
> 

Agreed. We don't have public documentation for most of these features at the
moment, but I will do my best to provide sufficient detail about each feature
and its safety implications in the next submission.

> The _EN flags in particular suggest some amount of emulation is required.

Right, I oversimplified this in the initial patch. I will investigate the _EN
bits more carefully and document what each one actually controls and whether KVM
needs to do anything beyond passthrough.

> 
> The patch also needs to be split up into related feature bundles (or invididual
> patches if each and every feature flag represents a completely independent feature).
> 

Makes sense. I will do thorough research on these features and group them into
logical bundles based on their functionality for the next version.

>> Link: https://lore.kernel.org/all/b3632083-f8ff-4127-a488-05a2c7acf1ad@redhat.com/
>> Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
>> ---
>>  arch/x86/kvm/cpuid.c         | 14 ++++++++++++++
>>  arch/x86/kvm/reverse_cpuid.h | 19 +++++++++++++++++++
>>  2 files changed, 33 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 88a5426674a1..529705079904 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1242,8 +1242,12 @@ void kvm_set_cpu_caps(void)
>>               kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
>>
>>       kvm_cpu_cap_init(CPUID_C000_0001_EDX,
>> +             F(SM2),
>> +             F(SM2_EN),
>>               F(XSTORE),
>>               F(XSTORE_EN),
>> +             F(CCS),
>> +             F(CCS_EN),
>>               F(XCRYPT),
>>               F(XCRYPT_EN),
>>               F(ACE2),
>> @@ -1252,6 +1256,16 @@ void kvm_set_cpu_caps(void)
>>               F(PHE_EN),
>>               F(PMM),
>>               F(PMM_EN),
>> +             F(PARALLAX),
>> +             F(PARALLAX_EN),
>> +             F(TM3),
>> +             F(TM3_EN),
>> +             F(RNG2),
>> +             F(RNG2_EN),
>> +             F(PHE2),
>> +             F(PHE2_EN),
>> +             F(RSA),
>> +             F(RSA_EN),
>>       );
>>
>>       /*
>> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
>> index 81b4a7acf72e..33e6a2755c84 100644
>> --- a/arch/x86/kvm/reverse_cpuid.h
>> +++ b/arch/x86/kvm/reverse_cpuid.h
>> @@ -59,6 +59,25 @@
>>  #define KVM_X86_FEATURE_TSA_SQ_NO    KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
>>  #define KVM_X86_FEATURE_TSA_L1_NO    KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
>>
>> +/*
>> + * Zhaoxin/Centaur-defined CPUID level 0xC0000001 (EDX) features that are
>> + * currently KVM-only and not defined in cpufeatures.h.
>> + */
>> +#define X86_FEATURE_SM2             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 0)
>> +#define X86_FEATURE_SM2_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 1)
>> +#define X86_FEATURE_CCS             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 4)
>> +#define X86_FEATURE_CCS_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 5)
>> +#define X86_FEATURE_PARALLAX        KVM_X86_FEATURE(CPUID_C000_0001_EDX, 16)
>> +#define X86_FEATURE_PARALLAX_EN     KVM_X86_FEATURE(CPUID_C000_0001_EDX, 17)
>> +#define X86_FEATURE_TM3             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 20)
>> +#define X86_FEATURE_TM3_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 21)
>> +#define X86_FEATURE_RNG2            KVM_X86_FEATURE(CPUID_C000_0001_EDX, 22)
>> +#define X86_FEATURE_RNG2_EN         KVM_X86_FEATURE(CPUID_C000_0001_EDX, 23)
>> +#define X86_FEATURE_PHE2            KVM_X86_FEATURE(CPUID_C000_0001_EDX, 25)
>> +#define X86_FEATURE_PHE2_EN         KVM_X86_FEATURE(CPUID_C000_0001_EDX, 26)
>> +#define X86_FEATURE_RSA             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 27)
>> +#define X86_FEATURE_RSA_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 28)
>> +
>>  struct cpuid_reg {
>>       u32 function;
>>       u32 index;
>> --
>> 2.34.1
>>


