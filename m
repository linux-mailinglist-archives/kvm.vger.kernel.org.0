Return-Path: <kvm+bounces-69689-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHa6Bc13fGmWNAIAu9opvQ
	(envelope-from <kvm+bounces-69689-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:20:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AC366B8D36
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 10:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 691033055CBD
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9B6352F82;
	Fri, 30 Jan 2026 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EUxZsG6I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C346244665;
	Fri, 30 Jan 2026 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769764658; cv=none; b=gMC84s44ZbAPVvlKkjTCjN2GB4hGGIHaEa91YY4p7sO2xdFEE25eEbx6Wbq2F1t9UD+Swv3j67nHAzRw8Hq/wTLdU9tRdna820YEwic+82h4uuiuH4/q4NC8mjrya8sNzA07ldmAX0V+rWAnfZ27fIByhQwY51noo1Se8hqVEpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769764658; c=relaxed/simple;
	bh=EPuY6wLnY+AZQgYYdbUv0uOYsNBKYd29w++7kcaibi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmJ21VDeJt2kGlEMMlwm687BP3FTuo5VNvferbvCQ2wvyULMPZ+ifPq69AeoJJGWTnHwiKJVEeWgc1UgdIL44k6/nqbtClxkZeiTc+8qcvz2IaFhY4D9POTR6gJiSsRdObFH7LUHMUc+BBUjAejyc2dD/h5jKFBPyrtlJvgvoJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EUxZsG6I; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769764658; x=1801300658;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EPuY6wLnY+AZQgYYdbUv0uOYsNBKYd29w++7kcaibi0=;
  b=EUxZsG6I+EjlU7j6l3HsvDNnhDCC37yfOuEK4xarizectK9kiPBHCAhP
   1KX14g3GSFZyDXs7R/25oMQg92Q31XgTAWbb7HpSgoIj7vHGy+9mzqGwN
   7i+WWx8TbFaiNthICKtRlq9IbcqVuYl1Tu6JoS6jldRQQrK7+n6nxqenX
   2zHGQKnJu6hpSSpwO7/jDtCzZa2nc75BZmHO1zLlpCwcTHDk/WifuzM6U
   lUddfinbvEeQZ6f0oG3wAI8u+180zUnmO0HjXNypnp/AqL1uY1Y43nX5A
   cAwo9lRcLb6GUpSRmnnex8D9+u3HvYPBdBrJ0T2D61QPmFoWarHIcif2v
   w==;
X-CSE-ConnectionGUID: NMX6LCKRRVe/Eakmt0zENQ==
X-CSE-MsgGUID: MlJpFVJSTpOyyRw64thvLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="71050577"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="71050577"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 01:17:37 -0800
X-CSE-ConnectionGUID: RbE1IDiNR8uLz2R8uUA4Sg==
X-CSE-MsgGUID: FqQ2j6vWROaFaU/KcVaZCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="213711225"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 01:17:34 -0800
Message-ID: <775f7a7b-b658-43cc-b1f6-e95bca3f0fc5@linux.intel.com>
Date: Fri, 30 Jan 2026 17:17:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS
 config mismatch
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
 John Allen <john.allen@amd.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-4-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260128014310.3255561-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69689-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,linux.intel.com:mid]
X-Rspamd-Queue-Id: AC366B8D36
X-Rspamd-Action: no action



On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> When kvm-intel.ko refuses to load due to a mismatched VMCS config, print
> all mismatching offsets+values to make it easier to debug goofs during
> development, and it to make it at least feasible to triage failures that
> occur during production.  E.g. if a physical core is flaky or is running
> with the "wrong" microcode patch loaded, then a CPU can get a legitimate
> mismatch even without KVM bugs.
> 
> Print the mismatches as 32-bit values as a compromise between hand coding
> every field (to provide precise information) and printing individual bytes
> (requires more effort to deduce the mismatch bit(s)).  All fields in the
> VMCS config are either 32-bit or 64-bit values, i.e. in many cases,
> printing 32-bit values will be 100% precise, and in the others it's close
> enough, especially when considering that MSR values are split into EDX:EAX
> anyways.
> 
> E.g. on mismatch CET entry/exit controls, KVM will print:
> 
>   kvm_intel: VMCS config on CPU 0 doesn't match reference config:
>     Offset 76 REF = 0x107fffff, CPU0 = 0x007fffff, mismatch = 0x10000000
>     Offset 84 REF = 0x0010f3ff, CPU0 = 0x0000f3ff, mismatch = 0x00100000
> 
> Opportunistically tweak the wording on the initial error message to say
> "mismatch" instead of "inconsistent", as the VMCS config itself isn't
> inconsistent, and the wording conflates the cross-CPU compatibility check
> with the error_on_inconsistent_vmcs_config knob that treats inconsistent
> VMCS configurations as errors (e.g. if a CPU supports CET entry controls
> but no CET exit controls).
> 

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


