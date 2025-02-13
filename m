Return-Path: <kvm+bounces-38013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7DFA33A51
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 09:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7752163BE0
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78F020C46F;
	Thu, 13 Feb 2025 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TAVHyNJM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC8F2063DA;
	Thu, 13 Feb 2025 08:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739436932; cv=none; b=qmow+3VCr39l2Hk6xGo42eBCuY0FTNFJSyoibF+cm37Yw1qMJSwUO4DCB3rNhvEuhxPCRUMXOqjnrt5uFQmqH80KwyHpsbooj1ARsnOCMUrRJTAhCLKt44NoDTphu9421MU4skef+Z+Phvxyr7t68joOPnPFDYF43hj2ie2pNMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739436932; c=relaxed/simple;
	bh=MHpOzFsGTOMh0eNy8NM9PNMvsZ+5FJ1jTrK55cX6qck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FefZjT8TOX/oTFVikGG85jBCW0s8Jg0epcpV/pe35e1f6Bs8TR3Xfn0AdNAIhNlR2EdeAVIMbuB2qGX1O+8D6/H43f0gAjQbg+i9KQUYO6elhyc2ULC6Pz5FwU2FlRi/ZtZnOYteOapn6lS/VFQ5Ie8sJ8onAU7syzEVmE8sVss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TAVHyNJM; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739436930; x=1770972930;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MHpOzFsGTOMh0eNy8NM9PNMvsZ+5FJ1jTrK55cX6qck=;
  b=TAVHyNJMdJIet4i4o1VZbctZb1Jv6P3jm3VhEk8v++ztEzZYzVgUTTOd
   5GW5feUWOa/5c4pS3VHqMH2VqisNJqbHMoPTxvG9exUIQi3nXQoSmT5Yk
   DPvm6In2AiAUMet8v7D5eMiQXAXc6gSQLS0MANSZ4eG+dVIRHEUwIM2Do
   PiPpfzIqKGjPKIHw9NoFn80qILG9DDa1+iw3Y03Mz+JVkw55L1ojpF9NV
   EwVj31zq5HEkMXInpHMIs5/WYxdLtiUEAyxZHoFJwjyVaihAqMgf2x6kH
   6bFrMOmCmd4GaHHlLY2rAedyaeMM3jFkSCZWuKfIoy1pODfQZeeSzX6n8
   w==;
X-CSE-ConnectionGUID: GnqZmV+qTOu3SZcpNqGLqA==
X-CSE-MsgGUID: FbTBCfQJSyaK46Vebg4AWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="39315781"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="39315781"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 00:55:29 -0800
X-CSE-ConnectionGUID: w5l3HZp3SqCCAvQRlF1pNg==
X-CSE-MsgGUID: b/5oDf+eR8iyHeporrBATQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="113263929"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 00:55:27 -0800
Message-ID: <6d817749-cb61-4406-9dfe-b8a0ef333a85@linux.intel.com>
Date: Thu, 13 Feb 2025 16:55:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/17] KVM: TDX: Complete interrupts after TD exit
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-9-binbin.wu@linux.intel.com>
 <Z62rPgmS2RB/LaC7@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z62rPgmS2RB/LaC7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/13/2025 4:20 PM, Chao Gao wrote:
>> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
>> +{
>> +	/* Avoid costly SEAMCALL if no NMI was injected. */
>> +	if (vcpu->arch.nmi_injected) {
>> +		/*
>> +		 * No need to request KVM_REQ_EVENT because PEND_NMI is still
>> +		 * set if NMI re-injection needed.  No other event types need
>> +		 * to be handled because TDX doesn't support injection of
>> +		 * exception, SMI or interrupt (via event injection).
>> +		 */
>> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
>> +							      TD_VCPU_PEND_NMI);
>> +	}
> Why does KVM care whether/when an NMI is injected by the TDX module?
>
> I think we can simply set nmi_injected to false unconditionally here, or even in
> tdx_inject_nmi(). From KVM's perspective, NMI injection is complete right after
> writing to PEND_NMI. It is the TDX module that should inject the NMI at the
> right time and do the re-injection.
Yes, it can/should be cleared unconditionally here.

Previously (v19 and before), nmi_injected will impact the limit of pending nmi.
Now, we don't care the limit of pending nmi because more pending NMIs will be
collapsed to the one pending in the TDX module.

Will update it.
Thanks!

>
>
>> +}
>> +


