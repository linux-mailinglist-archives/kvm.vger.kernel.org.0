Return-Path: <kvm+bounces-33202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 115479E6A68
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 10:36:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 343B4168832
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 09:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4314E1F9EAE;
	Fri,  6 Dec 2024 09:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xzl4y1Yr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F6D1EF097;
	Fri,  6 Dec 2024 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733477697; cv=none; b=bajn6mCTeC3LqMbv5NweHxtXmt8IVWL3g4+sqwKrd2jP2UtfqAqGHA+FHRjFV6CD1N+O9oAWNY1P9F37osdVLpzbrCOAdWcXkgTB6981rNYzik8mPbjeKyqWgiXbom9CDvPCRICJtc9//lmcWzvb4s2Obqhw6sl7/6gWesqy9RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733477697; c=relaxed/simple;
	bh=/i0+YCGdEkqQWh9rUMU2mm58oTj6C06sUI/9CvnFWeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWPdSmPl6QgJJAqTHJ9I4HdXTKH35qEPQexaUx3M1eNu+rfkmJUleW9Tf0FkK6pl3xdDp9HKlN/cLel2RGoODinrJzC9MSi/4DFjeKYEMSEPOfzJL1dvXmR5Lf/mvdzZZxvjZQggb5ZBgjRqVsbfmrRiBVPdzh00bO8C4BVF0Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xzl4y1Yr; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733477696; x=1765013696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/i0+YCGdEkqQWh9rUMU2mm58oTj6C06sUI/9CvnFWeo=;
  b=Xzl4y1YrfNhuh9z9mC+p2xqVBqhKNMOSiOAp7T4ATREtrQHq7xHo/xcf
   sg0lgnoMdFrfuhQgmeBIWo2GpOlB28s7run1mN/RW4IdTKTBKcEa4j+oX
   F55fJZYT8SMGanAgfhTTDht9qUUNRL2RRTagQplH0EJXRuVAwgkN/tfqV
   OOg5PTLULNDX0anq238n4mSEXui6TDJyN3VK/ESUY0x9Mbxzbm1Znij+0
   9lwmZ2IXpI8TIYlMENkny6gDlvvCkd/WHFKrZgPWE5aM1GJro7GulWfHg
   Op5L512I/Ia7Eyy+JVs00Z5qBSKl1eqRCCp+Isbk9atRFS0s5yp7KYPo7
   w==;
X-CSE-ConnectionGUID: XgtgCHCKTOmgmu49EEI1AA==
X-CSE-MsgGUID: Joh8vJMlRVKCWUEoADDYkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="33953897"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="33953897"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 01:34:55 -0800
X-CSE-ConnectionGUID: rXIgzfzBQ8yRDHJPmvq4+g==
X-CSE-MsgGUID: YI3MsMMqRHqmywejOfkvhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="99421496"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 06 Dec 2024 01:34:51 -0800
Date: Fri, 6 Dec 2024 17:31:39 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, kai.huang@intel.com,
	adrian.hunter@intel.com, reinette.chatre@intel.com,
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
	michael.roth@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
Message-ID: <Z1LEe1VL2YvoCp0A@yilunxu-OptiPlex-7050>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-6-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-6-binbin.wu@linux.intel.com>

> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg_mask = kvm_rcx_read(vcpu);
> +	u64* opt_regs;
> +
> +	/*
> +	 * Skip sanity checks and let userspace decide what to do if sanity
> +	 * checks fail.
> +	 */
> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
> +	vcpu->run->system_event.ndata = 10;
> +	/* Error codes. */
> +	vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
> +	/* GPA of additional information page. */
> +	vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
> +	/* Information passed via registers (up to 64 bytes). */
> +	opt_regs = &vcpu->run->system_event.data[2];
> +
> +#define COPY_REG(REG, MASK)						\
> +	do {								\
> +		if (reg_mask & MASK)					\
> +			*opt_regs = kvm_ ## REG ## _read(vcpu);		\
> +		else							\
> +			*opt_regs = 0;					\
> +		opt_regs++;						\
> +	} while (0)
> +
> +	/* The order is defined in GHCI. */
> +	COPY_REG(r14, BIT_ULL(14));
> +	COPY_REG(r15, BIT_ULL(15));
> +	COPY_REG(rbx, BIT_ULL(3));
> +	COPY_REG(rdi, BIT_ULL(7));
> +	COPY_REG(rsi, BIT_ULL(6));
> +	COPY_REG(r8, BIT_ULL(8));
> +	COPY_REG(r9, BIT_ULL(9));
> +	COPY_REG(rdx, BIT_ULL(2));

Nit:

#undef COPY_REG

Thanks,
Yilun

> +
> +	/*
> +	 * Set the status code according to GHCI spec, although the vCPU may
> +	 * not return back to guest.
> +	 */
> +	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
> +
> +	/* Forward request to userspace. */
> +	return 0;
> +}

