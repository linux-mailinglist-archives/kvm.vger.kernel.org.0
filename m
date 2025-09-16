Return-Path: <kvm+bounces-57692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF36B58F6C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DC141891064
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2962B2EA477;
	Tue, 16 Sep 2025 07:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipBPs3fy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07D1215F5C;
	Tue, 16 Sep 2025 07:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008692; cv=none; b=Onx+7m8z3djMxwwO3XgE/XIh83q0Twm2LSWAG/5j2JAx8qTz9HLdJCGehzg8svM5pHh/WNK5augManwcrBGfqljAX92Zugr1yKAd7xFtOW2/TgnDLyvzsdKBoxLgvGWapek55LznT/d4f0RxvkukXTTAdB7ExUY444Wk7ZOMNaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008692; c=relaxed/simple;
	bh=6m0AhTKq2P/We5qSWs7LufXVWjDoaLwb/w8yhyhl/7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n60pvyNnrH6X36MsOZroARVAFtgFn3EuELbpuVrsaM/+l0nDVekepMzgt28M6PpZvzHkId7EPQOhwKgBHmmmGkVur7i438jdcKFp9U8v9latNr2Ffy5CzZoP9mbpnEwEZcOPDi/kq64g07Ved+KWKfpYmHyMXbw+sl5uIIs7720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipBPs3fy; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758008691; x=1789544691;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6m0AhTKq2P/We5qSWs7LufXVWjDoaLwb/w8yhyhl/7U=;
  b=ipBPs3fygKenP1PgXzMVbGT1D5hxEhJj7HF7MIvrYB7E/AlcEooX7I3m
   scU5MN60nCcinBJ35FBy7QyqxMuNz8v0xo4WThG09XdbXUQpih4bmQ02F
   yRcX7qs1s0OajLce7rZ4YVwnrEt8owGquf+4YLEM/MuwVDTBcARiaKiKU
   vuargDjtvtReLbKhmEBNs/WyK/LOn55/0msFzVsZ7AobHyVyVB7yrtAmQ
   3iBnzMofpFATWF4NNB9i6qKLURxGRqaw/N+vcv5mjwcxoO0cH2t2zb2lK
   4/euW6vOwMDGhsjtiily31Jdeg8voTJKkXIyuOkoJbohJeHiFUgCnP0ek
   g==;
X-CSE-ConnectionGUID: Jj6VLMIYSRuUV3BeOCmo9Q==
X-CSE-MsgGUID: JHJtJr4GRjCBeX8atstQ4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="59975031"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="59975031"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:44:51 -0700
X-CSE-ConnectionGUID: UfI9IL35SeWbk8YHC2ewHw==
X-CSE-MsgGUID: 7SXagxhRSCCeov09Y8Veug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174948081"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:44:47 -0700
Message-ID: <6235548b-d542-4f93-8fc0-6267b6215130@intel.com>
Date: Tue, 16 Sep 2025 15:44:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 17/41] KVM: VMX: Set host constant supervisor states
 to VMCS fields
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-18-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
> Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
> post-boot(The exception is BIOS call case but vCPU thread never across it)
> and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
> VM-Exit sequence.
> 
> Host supervisor shadow stack is not enabled now and SSP is not accessible
> to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
> to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
> before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
> SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.
> 
> Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
> in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: snapshot host S_CET if SHSTK *or* IBT is supported]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

