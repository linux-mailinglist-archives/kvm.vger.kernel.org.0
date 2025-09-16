Return-Path: <kvm+bounces-57678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0453B58EA8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D034177D99
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 06:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D6E2DFA4A;
	Tue, 16 Sep 2025 06:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEtYQE2w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB122C0268;
	Tue, 16 Sep 2025 06:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758005526; cv=none; b=eohZtUoFEgTXHOXxqTyTHU/RnWkgiLnVEjVVVYUMUSS+FtvAqlmcpLq2sdqs1BaPjcEmF9MgYViK+hgaBzEdI0Qdr2nQuAiW7u9/agnQGJL5YFSvfq7qdvUaoGHFwtklQ30ZCjktNPmmCGNBILseEjDR7wKxlPEVfR78Vv6arYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758005526; c=relaxed/simple;
	bh=bqghi87Ugi16dvXZgjxqHnhX8XPm7QFh1FH2pRwAYh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ftmbiHkzBc3fVYYflf7sQgw3rgReanRCQ9Gd33SUIm+aaSCeemFer4yKBv8fx3/WpHBmtS3iR34pV3GPZ6b8xoefW0f01yR0sDJ1V3OiPFVZWYwtFNlgOkjeWIH05BEB9U/Zy8yqAC9hI/itbq0awLbfzAvFqPcB0x3Bwfn5Gw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEtYQE2w; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758005524; x=1789541524;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bqghi87Ugi16dvXZgjxqHnhX8XPm7QFh1FH2pRwAYh8=;
  b=OEtYQE2wZMmK7Xv6F72cuf+kHK6+OqQZkZNjX/qPJogsjJaVO4BXDvcR
   tz23WOtrq5DHwaBEkXpMX1SF+NSu39ZxbIqABlzXNDU/TRXrtmBf/ALBq
   K7t0e+DnuEUigLBHMArP3lPTiU9yitdRaRnLp7tFqG98b8RCKCYB6j66X
   UXLxD22BXM9Wx7A/e0NwLZoHYE75U5LtTBm5PG0wXGiy5GPe2i0ebHxYd
   MpA292ISMl6oig0crmWZlosaDLhmay1Ns40wU1YZtQoQriBi/Q7ZdRuYr
   NDlx+VSiWlM4rkgeaFc4fkGk/Lg7zwtmfbbXvY7laNM3wCPMFN8x+IeC3
   w==;
X-CSE-ConnectionGUID: 8aKmK1XWRk2VDjJD78KcVQ==
X-CSE-MsgGUID: agLjsGOFSgifJ7VdgHaowQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70896679"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70896679"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 23:52:03 -0700
X-CSE-ConnectionGUID: FPgxPgwRTAyY+90DJFq//w==
X-CSE-MsgGUID: 655Fp1EXSdyfCm5Qe9j2mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="175286077"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 23:52:00 -0700
Message-ID: <34eeea73-0f38-4471-b06b-aa6d598851ee@intel.com>
Date: Tue, 16 Sep 2025 14:51:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/41] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-10-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250912232319.429659-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
> to facilitate access to such kind of MSRs.
> 
> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
> the guest MSRs are swapped with host's before vCPU exits to userspace and
> after it reenters kernel before next VM-entry.
> 
> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
> explicitly check @vcpu is non-null before attempting to load guest state.
> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
> loading guest FPU state (which doesn't exist).
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed to
> access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> The two helpers are put here in order to manifest accessing xsave-managed
> MSRs requires special check and handling to guarantee the correctness of
> read/write to the MSRs.
> 
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: drop S_CET, add big comment, move accessors to x86.c]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

