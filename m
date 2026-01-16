Return-Path: <kvm+bounces-68295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5971BD2E71B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 10:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 134BA30EBA08
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 08:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C896313E0C;
	Fri, 16 Jan 2026 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WOtF7sdd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8344261FFE;
	Fri, 16 Jan 2026 08:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768553994; cv=none; b=LD0v0qlw8gpFRpKlGQZX+AxJcIQ06OPvLGSMwLSVnUfOTlG3+9sWSgiH3/WfhGFA199hfV8IDOygkgv+h8VV+5ekTl1DFlusmAj/cQ8LdlzGVx8eKFnBDb6UI++XLfeGeRbTggjNxDsNGdt2gdfkEE5np0NeijddDdPvMJDaepw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768553994; c=relaxed/simple;
	bh=RRDR63VErhM+T/VmECEdubQ1Mb2ExD6A8f3PMBe7h+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2eX58/cvxDSXPL3VdOF4jrKPTJ2ms5BKgtb+pkiRSKdIDO95QZhYH8Vuk+dIufW5e4UbnEtnLp3ksZ6Xlf4XNYKorKB7Zzt9DOa/dCr7g2bqrxvmlKulvO9Pfu5V6enePS5l4XMzdF+8ndF+swOX4o9QuNdLMpMjgA5TRkk1y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WOtF7sdd; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768553987; x=1800089987;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RRDR63VErhM+T/VmECEdubQ1Mb2ExD6A8f3PMBe7h+0=;
  b=WOtF7sddtasz4EN4nP9wdelApbyk2z68K7wtoLBdaaz69c0yaxn8snH/
   r51ooYGaydIcvt+wtTa+6K6TBJ6dwV23SKC5+8B2cRiKQ/nfrwTmEwL1w
   M2h9hNFYdWEyzVJbiyaqlc4MGBBWnS9M1UkSbjlXhtlWZpRS/xTSkznep
   SAa/+lX5I9TKToZ5mR9vURrffS6NgV0/H1szVy1I2OPyowogfpiDH7GFt
   3zcOMlU5eo5SyvQx0NCYtKqJUlke/Ss4E+TfmkgwLfpSEW7wcMlETeBWS
   2wvLZrY7/KlTL1LF4vdxr+KhftDUOlRrDWeexlCqLGdFciFFi5lSKcDMA
   Q==;
X-CSE-ConnectionGUID: p0itxP/zQpyfye5Nfglnvg==
X-CSE-MsgGUID: JXN7uw1zStCqW3Qa7XpAAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69921660"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69921660"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:59:46 -0800
X-CSE-ConnectionGUID: gTAyDTL9RsCZppX1iXlP8Q==
X-CSE-MsgGUID: hRFlWZSuQzemDFEr6qQ2Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209332050"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:59:44 -0800
Message-ID: <4046a4de-5b46-441f-9060-8854c0e570a8@intel.com>
Date: Fri, 16 Jan 2026 16:59:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20260115173427.716021-1-seanjc@google.com>
 <20260115173427.716021-4-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260115173427.716021-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/2026 1:34 AM, Sean Christopherson wrote:
> Disallow access (VMREAD/VMWRITE), both emulated and via a shadow VMCS, to
> VMCS fields that the loaded incarnation of KVM doesn't support, e.g. due
> to lack of hardware support, as a middle ground between allowing access to
> any vmcs12 field defined by KVM (current behavior) and gating access based
> on the userspace-defined vCPU model (the most functionally correct, but
> very costly, implementation).
> 
> Disallowing access to unsupported fields helps a tiny bit in terms of
> closing the virtualization hole (see below), but the main motivation is to
> avoid having to weed out unsupported fields when synchronizing between
> vmcs12 and a shadow VMCS.  Because shadow VMCS accesses are done via
> VMREAD and VMWRITE, KVM_must_ filter out unsupported fields (or eat
> VMREAD/VMWRITE failures), and filtering out just shadow VMCS fields is
> about the same amount of effort, and arguably much more confusing.
> 
> As a bonus, this also fixes a KVM-Unit-Test failure bug when running on
> _hardware_ without support for TSC Scaling, which fails with the same
> signature as the bug fixed by commit ba1f82456ba8 ("KVM: nVMX: Dynamically
> compute max VMCS index for vmcs12"):
> 
>    FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 19, actual: 17
> 
> Dynamically computing the max VMCS index only resolved the issue where KVM
> was hardcoding max index, but for CPUs with TSC Scaling, that was "good
> enough".
> 
> Reviewed-by: Chao Gao<chao.gao@intel.com>
> Reviewed-by: Xin Li<xin@zytor.com>
> Cc: Xiaoyao Li<xiaoyao.li@intel.com>
> Cc: Yosry Ahmed<yosry.ahmed@linux.dev>
> Link:https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
> Link:https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
> Signed-off-by: Sean Christopherson<seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

