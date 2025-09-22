Return-Path: <kvm+bounces-58351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 811C0B8ED7A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 05:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD1587A12B0
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 03:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7082EC0A9;
	Mon, 22 Sep 2025 03:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SP4QOC/0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609CA208AD;
	Mon, 22 Sep 2025 03:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758510238; cv=none; b=VUBsKvSwOvARToQHG1lW8UzKdM4MnYfYTNdgWiHCOcKHecMrcHNvEiYun/PJoUCRP9HG9LNDYjcnCLbXaEWycF34LAP25iLIP5PLowfxUjmTWdW+U0D6kJMlb8KmxAWU85ccJn/VMUwXLiTyWZzgadsyDtiK3v4x28gzhfr1WIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758510238; c=relaxed/simple;
	bh=LwNhzqr4Stp6PSBaTroNcoKpU5NCq+WcaAQUF15YWmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PivUXUVUBrGkbOzbNkAJwqw8WbZVF9CcY3cNFNBAomnWP2DvIa7LpTh70mCQM0oA249lmZnFYrkhcz3oca2y4HWs0bWlK8pQPfRrI90T2Ug60O5OSxjcyhtiDgPb9gv+duHJi7szsARLzz6lqe42wlSGnn4sWzIIecEUdluba9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SP4QOC/0; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758510236; x=1790046236;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LwNhzqr4Stp6PSBaTroNcoKpU5NCq+WcaAQUF15YWmQ=;
  b=SP4QOC/0ecphgaZHSDpQNqaV3Dj36q66eBlPpXalapZPqZ4AiYD9hLoT
   aSd/5WK9i4w0zTFz3C6q784a6Yxe3Mjep+Mr8icc5xbhfO+SGLiW241yZ
   7C7gZ/gp9imcynTjyZJeSBzNfynbpM0EbdndQdEVXPB4WwJdSWdzRI9ex
   WDuf9nI1K47mhn9zIm3CsdMhqOaEpZGMqiidwzCTlJ7BMiOkSs8cE+FWD
   iuX51kC9g7zbOWFmPvUxqQ3YLMOrehOGq3YX5UDiV8aNf2zUJ0j4Gi8Cc
   +d+ssukW6blDZZO92s0lY8tOvtFwzC7z45EZmYCfza9W8VuJfeByRklg3
   g==;
X-CSE-ConnectionGUID: sJT41RujTWOvauc1avKAvQ==
X-CSE-MsgGUID: 3XgG0FRMSNOyQHis4oBBGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71871265"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71871265"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 20:03:56 -0700
X-CSE-ConnectionGUID: ytUH6DQvQw2K9WZdu37QQg==
X-CSE-MsgGUID: d6tt6VjuSNWBj4oilN6rMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175639312"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 20:03:52 -0700
Message-ID: <39b5a556-72b8-4499-bb85-64e17bb94db7@linux.intel.com>
Date: Mon, 22 Sep 2025 11:03:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 17/51] KVM: VMX: Set host constant supervisor states
 to VMCS fields
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-18-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
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
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


