Return-Path: <kvm+bounces-33207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE48D9E6A7B
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 10:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5148416C020
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 09:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9501F131A;
	Fri,  6 Dec 2024 09:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E51sDRbg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C782E3D6B;
	Fri,  6 Dec 2024 09:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733477874; cv=none; b=Zl7mdZdGxdRuTaeR3UjYnSEg9grCz0ZkB5tVNQnmJ4cdJZxfmFKLQThCtWrWZ80DE4ruUBBEfP/j8ahin2xobGfvUHSnHavbMzfj05JkZ833JZ0ResedH+pjwF5g6TsNb9rBo1FeRvO0FFYO19iLKrm2vj0Ek4yB0olKwAxmJok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733477874; c=relaxed/simple;
	bh=lp1XiMOItjj/3Qsk2rUq8nPErrJnc5vYA8HE5WKIWlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tS/qYT3y4v+ZM7wKiN+SJyzx9/f2ga0hFNdXRpsra+DelxW66gGB7/kvPCzGfSNB84XzZFxyOZRab9pkd28U8t0c0rumbg6ZhlRamB06wnKtAnKCM9JR27fu/t1I54zOqfmQXXok7kOyrEQPZyI0w3QLnynj+oJQKLmKt4MHnOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E51sDRbg; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733477873; x=1765013873;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lp1XiMOItjj/3Qsk2rUq8nPErrJnc5vYA8HE5WKIWlA=;
  b=E51sDRbgm7o9oLQSu8TbB1JE0UD+ehqm91iaq/NWnj/96Tj9EHGNVp/E
   Dzfr5NDaO4Fk8HU0PommRouUCYGafFtcuz0FVsxWKlriwkamHbKoOCgTj
   snAnB/twmjz3nApQTZLNsBED+Jp7CNDyxtZxtWRYdcPu1Y/QMyAYlhux4
   K90LcNQk4i2TVx2bANdKv0XcePXZLc2FTa9xZu0II39vrul/fYD0G+p/r
   iER7WPRZrOdjZpSlfRp46VwBAGk+Apmm2JUm0M/WFgRGbODNnvr0g8XRr
   Kdemi3WHHZZgiXGlarnWo6gy/Y2SxUnXum/5h2Px+VYualVO0PPYtXJKa
   w==;
X-CSE-ConnectionGUID: HYkZoPwgQAWWw2/UBnqz+A==
X-CSE-MsgGUID: F2cMcYXgREaetz/tWN7w7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="44844611"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44844611"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 01:37:53 -0800
X-CSE-ConnectionGUID: HPMwe1FMSquTj9FgHAIOmQ==
X-CSE-MsgGUID: ZJYuGZhYQKGxfBLl/QJYkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="125204423"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.124]) ([10.124.241.124])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 01:37:49 -0800
Message-ID: <8b797d00-442e-4f6b-9de9-e44464e8ae68@linux.intel.com>
Date: Fri, 6 Dec 2024 17:37:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, michael.roth@amd.com,
 linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-6-binbin.wu@linux.intel.com>
 <Z1LEe1VL2YvoCp0A@yilunxu-OptiPlex-7050>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z1LEe1VL2YvoCp0A@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/6/2024 5:31 PM, Xu Yilun wrote:
>> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 reg_mask = kvm_rcx_read(vcpu);
>> +	u64* opt_regs;
>> +
>> +	/*
>> +	 * Skip sanity checks and let userspace decide what to do if sanity
>> +	 * checks fail.
>> +	 */
>> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
>> +	vcpu->run->system_event.ndata = 10;
>> +	/* Error codes. */
>> +	vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
>> +	/* GPA of additional information page. */
>> +	vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
>> +	/* Information passed via registers (up to 64 bytes). */
>> +	opt_regs = &vcpu->run->system_event.data[2];
>> +
>> +#define COPY_REG(REG, MASK)						\
>> +	do {								\
>> +		if (reg_mask & MASK)					\
>> +			*opt_regs = kvm_ ## REG ## _read(vcpu);		\
>> +		else							\
>> +			*opt_regs = 0;					\
>> +		opt_regs++;						\
>> +	} while (0)
>> +
>> +	/* The order is defined in GHCI. */
>> +	COPY_REG(r14, BIT_ULL(14));
>> +	COPY_REG(r15, BIT_ULL(15));
>> +	COPY_REG(rbx, BIT_ULL(3));
>> +	COPY_REG(rdi, BIT_ULL(7));
>> +	COPY_REG(rsi, BIT_ULL(6));
>> +	COPY_REG(r8, BIT_ULL(8));
>> +	COPY_REG(r9, BIT_ULL(9));
>> +	COPY_REG(rdx, BIT_ULL(2));
> Nit:
>
> #undef COPY_REG
Thanks for catching it!

>
> Thanks,
> Yilun
>
>> +
>> +	/*
>> +	 * Set the status code according to GHCI spec, although the vCPU may
>> +	 * not return back to guest.
>> +	 */
>> +	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
>> +
>> +	/* Forward request to userspace. */
>> +	return 0;
>> +}


