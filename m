Return-Path: <kvm+bounces-69250-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNceGyTZeGmwtgEAu9opvQ
	(envelope-from <kvm+bounces-69250-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:26:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D89B996A88
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:26:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 93A4F309C459
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03792FFDE1;
	Tue, 27 Jan 2026 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cfx8L67t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED5E221DB5;
	Tue, 27 Jan 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526845; cv=none; b=My5CkXbD5dhfd05oeyhRriM5j8khGFhsr7H4uBDho1+Jv3SlTgMDYJNtwRitL4bvYmK6v+xH7h1ngfVKJUEqxqVEOaX2sk52wldpVQL7z8EsJFKsSVxb3DlTreknoU5Ay2fyTlPSskri5vP2PMlbiUucl9zJD0sFBE+WW20Qc30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526845; c=relaxed/simple;
	bh=JjDQYPMPlPPAuA2/btS43uKru1OrVyzgZ7Xm/UEHlSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=so26/98UMPUa2lQJYkUqSCXZB9MkEyFIdbB/RbVKGQEos9ypQ1tnmW+FmwZ1gmoZePHjiyTWlJnlqJl3cq+YWTkX6i+HOKamgwm7mSa2F4wd7X5wKBhOOk/J4mSyUJkntFxCjkzujx65c2xphwFCvKtryXNFE5kgw7SnpRiAYAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cfx8L67t; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769526843; x=1801062843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JjDQYPMPlPPAuA2/btS43uKru1OrVyzgZ7Xm/UEHlSk=;
  b=cfx8L67t3hPNxe58O0w5foQX8G1fgfbpdZ1kyiSrfH2lR5l+6hCvslYB
   rzd0P/aK6HvgTIA0sfi07PL7fOwnyucisQm+65cToZlIDbSCuA0ZsfxHw
   wFLLtHTI99pZU0ADxDrztS0o/7FYZDGmV4MoRh/Zqi8C6LmJI6NWa+VYP
   Jc/znSWv10nIWoUqVr42TQXjKalYNKXg8qew3LYQj85TSlvzAjHxjMM3v
   VlLdl9+aPQA8JfYxk0ii5GdWu4OxlL2uUjTcq3E3IFm0PnlfgNOQxBryq
   PZ0j85v4IM9DnF6RJMG4uQNrjR4zsSZ4Ywv5Pe5oYQoVPq9F1dkkzma89
   Q==;
X-CSE-ConnectionGUID: dHaBiZ/tTru/T8yqCYrlLw==
X-CSE-MsgGUID: gaebrFw0RWykGUq/uLYBig==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="74350633"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="74350633"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 07:12:52 -0800
X-CSE-ConnectionGUID: Aezs6RtGSmmtBCfpjeueZQ==
X-CSE-MsgGUID: UGb2j53ITBazeyPHvruMWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="207798948"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 07:12:49 -0800
Message-ID: <204d5234-9afd-4745-b40a-4355afad1e6b@intel.com>
Date: Tue, 27 Jan 2026 23:12:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: x86: Finalize kvm_cpu_caps setup from
 {svm,vmx}_set_cpu_caps()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
References: <20260123221542.2498217-1-seanjc@google.com>
 <20260123221542.2498217-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260123221542.2498217-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69250-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D89B996A88
X-Rspamd-Action: no action

On 1/24/2026 6:15 AM, Sean Christopherson wrote:
...
> +void kvm_finalize_cpu_caps(void)

It also finalizes the kvm_caps, at least kvm_caps.supported_xss, which 
seems not consistent with the name.

Even more, just look at the function body, the name 
"kvm_finalize_supported_xss" seems to fit better while clearing SHSTK 
and IBT just the side effect of the finalized kvm_caps.supported_xss.



> +{
> +	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> +		kvm_caps.supported_xss = 0;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +
> +	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +	}
> +}


