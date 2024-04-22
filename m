Return-Path: <kvm+bounces-15547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD198AD392
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B0F41F21DF1
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5E1154426;
	Mon, 22 Apr 2024 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fsBSt78+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8EC152197;
	Mon, 22 Apr 2024 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808541; cv=none; b=jRXdkFRRyxOaxX61+waQEvO47IX/vwclvDw0OcqnLAhL0cAVMfbdJBleVg+sP/LklN0WHvwecoBvHdiWrwq5EYAG7WRh42hQcYJyg/9oyNA6h7FQ5AEm2IOBhBO5PKNSTgdDVyiAb2SMtgGQIKdgMNr46OwUIG1YI4SRy8CrB6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808541; c=relaxed/simple;
	bh=6Qrukdm+oftDRYXT1lb8r+vqv5iPHwTKX+hyL1P5koo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vGsYQA887gn+N7/nMOistiEAxXIWekfwS/XfVOUEI/nouyMGqig/YhuC8q2qxHNnbkWPkT8+AQBQm2QWEvZOCMYrpI0FyiM2ETHuE5Gnvd0tURhu9uuZ6Gu50Tdmvq2TSCC0v7FFTDE5oEWGOezfpA3M3hBd19LRWJ+1/LeYRmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fsBSt78+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713808539; x=1745344539;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Qrukdm+oftDRYXT1lb8r+vqv5iPHwTKX+hyL1P5koo=;
  b=fsBSt78+TdFklZwTV6UA61j6qHKVQJZVD0XoGGq6yQ5xkLx1Tmy/rOGq
   eOEcWsbHDy3g/VH39/ouXuf3FonMUTr4MfFkffGwB0pK+d9mV0ZOY1gkt
   BbtAv48Z/xvGiewOSZ5qOcvmSbMs2T5jygWeX1W1Y63vROD/qPIXNr2nW
   mZ3VHkN53qNgSVLUOZO+2/hp/G8ISLSodSkvAtuPg7uV6umRdyFnCrdSr
   BbMtyGaSS2xwRHxr8j88LWgFInhouqt5mcOYHbqsEMAZAygFb///9Z3hB
   zZuXOr/RliGUPb/su2vff7WjcdpHnTXlAFy4c1fj4nlCn34d10EKjSSNb
   A==;
X-CSE-ConnectionGUID: FFGgRTrAT7eGPD/Ls+6WKw==
X-CSE-MsgGUID: uVjK1Pg4Rm2nbCgDNNeXbg==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="34759292"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="34759292"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:55:22 -0700
X-CSE-ConnectionGUID: 1haqLAR8T+W8zDo3immlDA==
X-CSE-MsgGUID: jlma1gcbQV2IpAEITMkNiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="24165434"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 10:55:21 -0700
Date: Mon, 22 Apr 2024 10:55:21 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	isaku.yamahata@intel.com, xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 1/6] KVM: Document KVM_PRE_FAULT_MEMORY ioctl
Message-ID: <20240422175521.GM3596705@ls.amr.corp.intel.com>
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240419085927.3648704-2-pbonzini@redhat.com>

On Fri, Apr 19, 2024 at 04:59:22AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Adds documentation of KVM_PRE_FAULT_MEMORY ioctl. [1]
> 
> It populates guest memory.  It doesn't do extra operations on the
> underlying technology-specific initialization [2].  For example,
> CoCo-related operations won't be performed.  Concretely for TDX, this API
> won't invoke TDH.MEM.PAGE.ADD() or TDH.MR.EXTEND().  Vendor-specific APIs
> are required for such operations.
> 
> The key point is to adapt of vcpu ioctl instead of VM ioctl.  First,
> populating guest memory requires vcpu.  If it is VM ioctl, we need to pick
> one vcpu somehow.  Secondly, vcpu ioctl allows each vcpu to invoke this
> ioctl in parallel.  It helps to scale regarding guest memory size, e.g.,
> hundreds of GB.
> 
> [1] https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/
> [2] https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-ID: <9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 50 ++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f0b76ff5030d..bbcaa5d2b54b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6352,6 +6352,56 @@ a single guest_memfd file, but the bound ranges must not overlap).
>  
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>  
> +4.143 KVM_PRE_FAULT_MEMORY
> +------------------------
> +
> +:Capability: KVM_CAP_PRE_FAULT_MEMORY
> +:Architectures: none
> +:Type: vcpu ioctl
> +:Parameters: struct kvm_pre_fault_memory (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `gpa` and `size` were invalid (e.g. not
> +             page aligned).
> +  ENOENT     The specified `gpa` is outside defined memslots.
> +  EINTR      An unmasked signal is pending and no page was processed.
> +  EFAULT     The parameter address was invalid.
> +  EOPNOTSUPP Mapping memory for a GPA is unsupported by the
> +             hypervisor, and/or for the current vCPU state/mode.

     EIO        Unexpected error happened.

> +  ========== ===============================================================
> +
> +::
> +
> +  struct kvm_pre_fault_memory {
> +	/* in/out */
> +	__u64 gpa;
> +	__u64 size;
> +	/* in */
> +	__u64 flags;
> +	__u64 padding[5];
> +  };
> +
> +KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
> +for the current vCPU state.  KVM maps memory as if the vCPU generated a
> +stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
> +CoW.  However, KVM does not mark any newly created stage-2 PTE as Accessed.
> +
> +In some cases, multiple vCPUs might share the page tables.  In this
> +case, the ioctl can be called in parallel.
> +
> +Shadow page tables cannot support this ioctl because they
> +are indexed by virtual address or nested guest physical address.
> +Calling this ioctl when the guest is using shadow page tables (for
> +example because it is running a nested guest with nested page tables)
> +will fail with `EOPNOTSUPP` even if `KVM_CHECK_EXTENSION` reports
> +the capability to be present.
> +
> +`flags` must currently be zero.

`flags` and `padding`

> +
> +
>  5. The kvm_run structure
>  ========================
>  
> -- 
> 2.43.0
> 
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

