Return-Path: <kvm+bounces-38690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFBCA3DB12
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CE0C3B1939
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463171F8676;
	Thu, 20 Feb 2025 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlQADRJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD561EE01A;
	Thu, 20 Feb 2025 13:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740057372; cv=none; b=T0wi8biZG4LQIwfbPmE0LIj8sQcBgSEOnI6fuqqlRqd9prt1aZuVV403r13W7pfx8N+Mn/WU0757R033nsEJPNKI8Al0J8/fQE7oc0ViGjKyQw765Zgj/+VUble97ssud6lUPeFD3TT+SXsCajl7PoCIZYStP/VIaKl5DGac/Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740057372; c=relaxed/simple;
	bh=2+RQ21ihi8uClxa86APb6Id4tl2Ak/483V07rG+or60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KwRUlu+ta0t0JC55tPvSiXCUsGmQEm5/RVtM6BhaxrHqbUxK6fh6JKt+IBK3yTtOAl4M4MXqpRtciIpWpO/lWkEVBR4CThCWTRMGfGkJdhVi+pl0sBODRCRW9l85zllKrA3+4ef25StIt5wEaxgccrXyj64ExJRoR4NdQ9Ppmy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlQADRJ3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740057370; x=1771593370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2+RQ21ihi8uClxa86APb6Id4tl2Ak/483V07rG+or60=;
  b=nlQADRJ3RpUDLRiJn6VygINyy2HdQeKZDYn4HouPeQXUiY6WgJTL2ZSJ
   eBZEvRTiYshlBPdU2wIWGPG+vkZ7cCikxc0cqc4QVboPE5WgSOY2kvhHt
   JVPoqOixJ/b49SEO11s9u9/tio00DUQ7jXy/dzdX9bvIX3BGwxIEtw0gV
   bQCcp7wXXLuDE66TMNCDOprOuoeKUiJgtiuzk6iM7Z/Hl/xrX+czamGme
   lR7pWFXSuUKBo21b+xqrYBXepu3VKz98/QRoDOpkxQY4/e6BtEzO+IVbk
   Ae1Q+HvH56Lpn+BKASVKX741cVM1ZLou4MEpF6TtWwMHAkiaUc0toRdly
   Q==;
X-CSE-ConnectionGUID: thAAMjCWQwu4XKy0gRcqgQ==
X-CSE-MsgGUID: 3AqauAkqR5iYylSpQG2k/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="51452013"
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="51452013"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 05:16:10 -0800
X-CSE-ConnectionGUID: IQ+Iji2IRuKMbWCbAuVtoQ==
X-CSE-MsgGUID: VM0xE809ScO/ar/JjokODQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,301,1732608000"; 
   d="scan'208";a="114770438"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 05:16:05 -0800
Message-ID: <06c73413-d751-45bf-bde9-cdb4f56f95b0@intel.com>
Date: Thu, 20 Feb 2025 21:16:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/12] KVM: TDX: Implement TDX vcpu enter/exit path
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-6-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250129095902.16391-6-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/2025 5:58 PM, Adrian Hunter wrote:
> +#define TDX_REGS_UNSUPPORTED_SET	(BIT(VCPU_EXREG_RFLAGS) |	\
> +					 BIT(VCPU_EXREG_SEGMENTS))
> +
> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> +{
> +	/*
> +	 * force_immediate_exit requires vCPU entering for events injection with
> +	 * an immediately exit followed. But The TDX module doesn't guarantee
> +	 * entry, it's already possible for KVM to_think_ it completely entry
> +	 * to the guest without actually having done so.
> +	 * Since KVM never needs to force an immediate exit for TDX, and can't
> +	 * do direct injection, just warn on force_immediate_exit.
> +	 */
> +	WARN_ON_ONCE(force_immediate_exit);
> +
> +	trace_kvm_entry(vcpu, force_immediate_exit);
> +
> +	tdx_vcpu_enter_exit(vcpu);
> +
> +	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;

I don't understand this. Why only clear RFLAGS and SEGMENTS?

When creating the vcpu, vcpu->arch.regs_avail = ~0 in 
kvm_arch_vcpu_create().

now it only clears RFLAGS and SEGMENTS for TDX vcpu, which leaves other 
bits set. But I don't see any code that syncs the guest value of into 
vcpu->arch.regs[reg].

> +	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> +
> +	return EXIT_FASTPATH_NONE;
> +}


