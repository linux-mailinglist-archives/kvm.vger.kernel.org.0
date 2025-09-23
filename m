Return-Path: <kvm+bounces-58520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4094FB95218
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 11:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFDEC7B25A2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 09:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D5D320390;
	Tue, 23 Sep 2025 09:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zx+cx/WX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4FD2F0C52;
	Tue, 23 Sep 2025 09:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618422; cv=none; b=l6616uCKsLAarTcpPBwLRcXiixNHZVaUKx1brZhvUbOM6rc9B8mX0SB6a5D4Rnau36BJ+j499M56gDwMqllbCOohcFCnFW7t0eogt650cc+PDIn+no7lYU04Gspl02kXh1yaxZ6zAkMRIAdn1w/kZqeuvjWdpSoxf77RcaqCnUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618422; c=relaxed/simple;
	bh=XtGQOaqFEVnIS+TAw+0T2tFGVmpxhSe74dKuYWcvxGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kOR6BiQETPIM49KNsYSDRiSw4c9O6Zl9+S5dnNvC/vNvzlQoCpwLNONIX+4QnR8pnWWKfwp5qLrXCRTfF7B/sPkHdtAqyy2tCkWWiABJ4kB/HrTRCslcFqStllsE3Xpyd/EQQwrfE13RTqhGbYPLG9Xxf66Jo19Bud0MTNur+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zx+cx/WX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758618419; x=1790154419;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XtGQOaqFEVnIS+TAw+0T2tFGVmpxhSe74dKuYWcvxGU=;
  b=Zx+cx/WXBDgwWcD0F+dZDVa8KveNGjKrx8NtH+X2AZGWlXxnReR2ibGF
   PGIZl6KB+DgnvQn9JdTecMMPPTeN047ZCuFpT4Or6toJntfwi7Sv/L9d7
   0iNRLWVmlFYjNSXEORnVA4VxRAK0vq2XrXYZGOYFOQRgFoW1oKPFrRqLs
   CwRj03E4F9cQ+2gZVKaB2yqoy9dISadLx8SpxR1kbPvNbIclXWtil74IS
   YcR7B7yqxyuPlM7CKh4gxfHKu3gXLyXNYcxj0OAhbQUMT4v9zSzfntE37
   bOur+00Lz2oUMGVRsEOHHgA71D8VJt+L2rNipdVeD26JsU0DMMPkg/CMG
   Q==;
X-CSE-ConnectionGUID: IGAssne3SG2e+93pooA9/g==
X-CSE-MsgGUID: JVxgepbpRueoztOl9FFwrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72317569"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="72317569"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 02:06:56 -0700
X-CSE-ConnectionGUID: K90JrBDbRxKmkgkUKV+SjQ==
X-CSE-MsgGUID: 7kMkqISrQmKb2LH8FAVC8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="175846948"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 02:06:48 -0700
Message-ID: <d4f42030-2e83-4a30-a74a-e8107fc5cb12@intel.com>
Date: Tue, 23 Sep 2025 17:06:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 13/51] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-14-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919223258.1604852-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang<weijiang.yang@intel.com>
> 
> Add a KVM-defined ONE_REG register, KVM_REG_GUEST_SSP, to let userspace
> save and restore the guest's Shadow Stack Pointer (SSP).  On both Intel
> and AMD, SSP is a hardware register that can only be accessed by software
> via dedicated ISA (e.g. RDSSP) or via VMCS/VMCB fields (used by hardware
> to context switch SSP at entry/exit).  As a result, SSP doesn't fit in
> any of KVM's existing interfaces for saving/restoring state.
> 
> Internally, treat SSP as a fake/synthetic MSR, as the semantics of writes
> to SSP follow that of several other Shadow Stack MSRs, e.g. the PLx_SSP
> MSRs.  Use a translation layer to hide the KVM-internal MSR index so that
> the arbitrary index doesn't become ABI, e.g. so that KVM can rework its
> implementation as needed, so long as the ONE_REG ABI is maintained.
> 
> Explicitly reject accesses to SSP if the vCPU doesn't have Shadow Stack
> support to avoid running afoul of ignore_msrs, which unfortunately applies
> to host-initiated accesses (which is a discussion for another day).  I.e.
> ensure consistent behavior for KVM-defined registers irrespective of
> ignore_msrs.
> 
> Link:https://lore.kernel.org/all/aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com
> Suggested-by: Sean Christopherson<seanjc@google.com>
> Signed-off-by: Yang Weijiang<weijiang.yang@intel.com>
> Tested-by: Mathias Krause<minipli@grsecurity.net>
> Tested-by: John Allen<john.allen@amd.com>
> Tested-by: Rick Edgecombe<rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao<chao.gao@intel.com>
> Co-developed-by: Sean Christopherson<seanjc@google.com>
> Signed-off-by: Sean Christopherson<seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>



