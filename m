Return-Path: <kvm+bounces-24083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D6AB951183
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C28E81C22CA0
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 01:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587B21643A;
	Wed, 14 Aug 2024 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXJndk9j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798C59445;
	Wed, 14 Aug 2024 01:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723598413; cv=none; b=VEdmcdSKaaB+y9dHsonPi4B/OaG8u1iHTGBHqj/1huN/igHmlWD9xtkTzzJtirir+k27Ju9gawe64DFQXdluVpEm5bRxIfQzxx2HTg8h5RmClX8J2oSdvU3Yh2Ezx3FDGytfYsz1p7RAkgsgbi8tKkqzxjBbGpYGMtEfkmrXBRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723598413; c=relaxed/simple;
	bh=4dHxNI/c0RYsg6Z3/TwqTK70mT03W2PIDlscJn5sr2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sdLYBinSu6BQ3hiGZmpKjBYgNiiuh0fBP00tRsL0TofNmZll4MlGqWr4Dcunkm1L3vpuGF1D0+pxnDftRHoHfdwg10DiMusdroTiqrtKTUTqWEhHm5L1mFexODXrTUejA9WaAV1PBQJ+uOuJ0zunWmNFa2O3peHmuDnK2lvvwKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXJndk9j; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723598412; x=1755134412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4dHxNI/c0RYsg6Z3/TwqTK70mT03W2PIDlscJn5sr2o=;
  b=OXJndk9jHOX12ZHCl+5t8unq35duPv96ZuM5Yebgs7+Q8k47gWbLSljm
   igXv4A7qdHeNbnKmL7tCrk/k2v8oISROlWbdHYoOcCaEhzQ76pJB7WHqy
   xzpiC0VmfFfBxB3gInL3lUrnqU0s1C30/aGNAUXQABX056bRaRriWI6US
   /819vVLVqiN0OgzFwHNtBVytaAZeuy0zwVj+9zwQl1QjgRhVv+6iKz8FL
   A62ey69HuUf0lXeri+eUxrWG6j6FWMJYvPghQhiwkCDF+t12hR0dVbnGA
   t3HgEA6B0qLBnSttoRGuYTFPeB+8pN9UPnOKDsF+5gEsEv7etKP+JtsWM
   g==;
X-CSE-ConnectionGUID: bqb13lSBRumdyztPFYUROw==
X-CSE-MsgGUID: QdxJW9rwSaW5/pQ4tSqobg==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32471485"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="32471485"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 18:20:11 -0700
X-CSE-ConnectionGUID: 2M1QR03GSZii4azdmVgguw==
X-CSE-MsgGUID: GkNhsz+sRtac9WkO0xpr+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="59611015"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa008.jf.intel.com with ESMTP; 13 Aug 2024 18:20:07 -0700
Date: Wed, 14 Aug 2024 09:20:06 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20240814012006.tqxrfb3mu7wfsrqb@yy-desk-7060>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
 <ZruWBHdNwIAwm7QE@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZruWBHdNwIAwm7QE@ls.amr.corp.intel.com>
User-Agent: NeoMutt/20171215

On Tue, Aug 13, 2024 at 10:21:08AM -0700, Isaku Yamahata wrote:
> On Tue, Aug 13, 2024 at 04:00:09PM +0800,
> Yuan Yao <yuan.yao@linux.intel.com> wrote:
>
> > > +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> > > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > > +{
> > > +	const struct tdx_sysinfo_module_info *modinfo = &tdx_sysinfo->module_info;
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +	unsigned long va;
> > > +	int ret, i;
> > > +	u64 err;
> > > +
> > > +	if (is_td_vcpu_created(tdx))
> > > +		return -EINVAL;
> > > +
> > > +	/*
> > > +	 * vcpu_free method frees allocated pages.  Avoid partial setup so
> > > +	 * that the method can't handle it.
> > > +	 */
> >
> > This looks not that clear, why vcpu_free can't handle it is not explained.
> >
> > Looking the whole function, page already added into TD by
> > SEAMCALL should be cleared before free back to kernel,
> > tdx_vcpu_free() can handle them. Other pages can be freed
> > directly and can't be handled by tdx_vcpu_free() because
> > they're not added into TD. Is this right understanding ?
>
> Yes.  If we result in error in the middle of TDX vCPU initialization,
> TDH.MEM.PAGE.RECLAIM() result in error due to TDX module state check.
> TDX module seems to assume that we don't fail in the middle of TDX vCPU
> initialization.  Maybe we can add WARN_ON_ONCE() for such cases.
>
>
> > > +		ret = -EIO;
> > > +		pr_tdx_error(TDH_VP_CREATE, err);
> > > +		goto free_tdvpx;
> > > +	}
> > > +
> > > +	for (i = 0; i < tdx_sysinfo_nr_tdcx_pages(); i++) {
> > > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > +		if (!va) {
> > > +			ret = -ENOMEM;
> > > +			goto free_tdvpx;
> >
> > It's possible that some pages already added into TD by
> > tdh_vp_addcx() below and they won't be handled by
> > tdx_vcpu_free() if goto free_tdvpx here;
>
> Due to TDX TD state check, we can't free partially assigned TDCS pages.
> TDX module seems to assume that TDH.VP.ADDCX() won't fail in the middle.

The already partially added TDCX pages are initialized by
MOVDIR64 with the TD's private HKID in TDX module, the above
'goto free_tdvpx' frees them back to kernel directly w/o
take back the ownership with shared HKID. This violates the
rule that a page's ownership should be taken back with shared
HKID before release to kernel if they were initialized by any
private HKID before.

How about do tdh_vp_addcx() afer allocated all TDCX pages
and give WARN_ON_ONCE() to the return value of
tdh_vp_addcx() if the tdh_vp_addcx() won't fail except some
BUG inside TDX module in our current usage ?

>
>
> > > +	else
> > > +		err = tdh_vp_init(tdx, vcpu_rcx);
> > > +
> > > +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> > > +		pr_tdx_error(TDH_VP_INIT, err);
> > > +		return -EIO;
> > > +	}
> > > +
> > > +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > +	tdx->td_vcpu_created = true;
> > > +
> > > +	return 0;
> > > +
> > > +free_tdvpx:
> >
> > How about s/free_tdvpx/free_tdcx
> >
> > In 1.5 TDX spec these pages are all called TDCX pages, and
> > the function context already indicates that we're talking about
> > vcpu's TDCX pages.
>
> Oops, this is left over when tdvpx was converted to tdcs.
>
>
> > > +static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> > > +{
> > > +	struct msr_data apic_base_msr;
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +	int ret;
> > > +
> > > +	if (cmd->flags)
> > > +		return -EINVAL;
> > > +	if (tdx->initialized)
> > > +		return -EINVAL;
> > > +
> > > +	/*
> > > +	 * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
> > > +	 * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
> > > +	 * KVM_SET_CPUID2.  Otherwise kvm_set_apic_base() will fail.
> > > +	 */
> > > +	apic_base_msr = (struct msr_data) {
> > > +		.host_initiated = true,
> > > +		.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
> > > +		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0),
> > > +	};
> > > +	if (kvm_set_apic_base(vcpu, &apic_base_msr))
> > > +		return -EINVAL;
> > > +
> > > +	ret = tdx_td_vcpu_init(vcpu, (u64)cmd->data);
>
> Because we set guest rcx only, we use cmd->data.  Can we add reserved area for
> future use similar to struct kvm_tdx_init_vm?
> i.e. introduce something like
> struct kvm_tdx_init_vcpu {u64 rcx; u64 reserved[]; }
> --
> Isaku Yamahata <isaku.yamahata@intel.com>

