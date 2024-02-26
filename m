Return-Path: <kvm+bounces-9965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE72F868032
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DA0D28F8FA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB1412FF69;
	Mon, 26 Feb 2024 18:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MYcOGbK9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4939F12E1F0;
	Mon, 26 Feb 2024 18:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973844; cv=none; b=atd/pWxk92SjifchLYzBZv5EKWhuBrejPOj2inmPqWvw7xXArTS0iIOcBZRI/sd84EiZHy1K0H5A2jRvueD4Q40gBIhCElXXnE4AqSEApx67YQP55+QKGCPL0PSnvUkLlNYo/u/HdPyHRmZ4UGtPLUC7WReoL48ou6X3bFE3NrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973844; c=relaxed/simple;
	bh=nJFSrLqJiwp8ithW3MjfceFdjdGmcRw4CXHZqvKmUPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xbs40pbK+T6hDFOch1V/eHKQxU0AbSHSIKERFqR6PfmB7H3KfRlzzNLRZMfPHa/lMgeyRiYjZBLdqHF5JvoiWVQeCuGjdr1UWlUsDQeDnW4FfMccvkD2aietctKqWaXdicbP3t8yDRNv2CeG8C8CIkCwbioPpqGUh4qTBDwmKTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MYcOGbK9; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708973842; x=1740509842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nJFSrLqJiwp8ithW3MjfceFdjdGmcRw4CXHZqvKmUPI=;
  b=MYcOGbK9YqBhGXmsRJWhkL3jfAoDx8HWo3zItdv4V2YLHyrVPIkHI6hN
   9arFmG6e2ID10vC/3xKaxNMr3V+4ClFRd92V9lXB7fx1H9I5EEqvC3VxL
   IhtulB8UNdMjAycjQLdkPQIqBQgFlEnuzf8T56N0GGJp9NTks7WqXyc0+
   It9tAKhi/E6m8DIQAj1en8Aeh4bvGauBIBIGYhMQsZxMOeH9nPiMXRRFv
   OACgzrSx8d4OQoKjIpyIJv0NnDHC67QYuKzuvXnT/4xkjpTxRB1Qr8Bgk
   HbkYLCMq6MkIriJBf6JqbXJg7ROtr2OglEA2DjJwntIZcG4qIE+XxNYeH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="7107236"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7107236"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6977793"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:57:21 -0800
Date: Mon, 26 Feb 2024 10:57:20 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 025/121] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240226185720.GK177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <af0e1a82fdf797a7fffc9d08141d15037ed8537b.1705965634.git.isaku.yamahata@intel.com>
 <6e517d2e-45ae-46ec-8067-c3e7eb1b2afa@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6e517d2e-45ae-46ec-8067-c3e7eb1b2afa@linux.intel.com>

On Thu, Jan 25, 2024 at 10:19:30AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires additional parameters for TDX VM for confidential execution to
> > protect the confidentiality of its memory contents and CPU state from any
> > other software, including VMM.  When creating a guest TD VM before creating
> > vcpu, the number of vcpu, TSC frequency (the values are the same among
> > vcpus, and it can't change.)  CPUIDs which the TDX module emulates.  Guest
> > TDs can trust those CPUIDs and sha384 values for measurement.
> > 
> > Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
> > guest.  It assigns an encryption key to the TDX guest for memory
> > encryption.  TDX encrypts memory per guest basis.  The device model, say
> > qemu, passes per-VM parameters for the TDX guest.  The maximum number of
> > vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
> > vcpu.  The TDX guest can not change it.), attributes (production or debug),
> > available extended features (which configure guest XCR0, IA32_XSS MSR),
> > CPUIDs, sha384 measurements, etc.
> > 
> > Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
> > configurations aren't available yet.  So CPUIDs configuration values need
> > to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
> > to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v18:
> > - remove the change of tools/arch/x86/include/uapi/asm/kvm.h
> > - typo in comment. sha348 => sha384
> > - updated comment in setup_tdparams_xfam()
> > - fix setup_tdparams_xfam() to use init_vm instead of td_params
> > 
> > v15 -> v16:
> > - Removed AMX check as the KVM upstream supports AMX.
> > - Added CET flag to guest supported xss
> > 
> > v14 -> v15:
> > - add check if the reserved area of init_vm is zero
> > ---
> >   arch/x86/include/uapi/asm/kvm.h |  27 ++++
> >   arch/x86/kvm/cpuid.c            |   7 +
> >   arch/x86/kvm/cpuid.h            |   2 +
> >   arch/x86/kvm/vmx/tdx.c          | 261 ++++++++++++++++++++++++++++++--
> >   arch/x86/kvm/vmx/tdx.h          |  18 +++
> >   arch/x86/kvm/vmx/tdx_arch.h     |   6 +
> >   6 files changed, 311 insertions(+), 10 deletions(-)
> > 
> [...]
> > +
> > +static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> > +{
> > +	const struct kvm_cpuid_entry2 *entry;
> > +	u64 guest_supported_xcr0;
> > +	u64 guest_supported_xss;
> > +
> > +	/* Setup td_params.xfam */
> > +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
> > +	if (entry)
> > +		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> > +	else
> > +		guest_supported_xcr0 = 0;
> > +	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> > +
> > +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
> > +	if (entry)
> > +		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> > +	else
> > +		guest_supported_xss = 0;
> > +
> > +	/*
> > +	 * PT can be exposed to TD guest regardless of KVM's XSS and CET
> > +	 * support.
> > +	 */
> According to the code below, it seems that both PT and CET can be exposed to
> TD
> guest regardless of KVM's XSS support?

Yes, updated the comment.

> > +	guest_supported_xss &=
> > +		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
> > +
> > +	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> > +	if (td_params->xfam & XFEATURE_MASK_LBR) {
> > +		/*
> > +		 * TODO: once KVM supports LBR(save/restore LBR related
> > +		 * registers around TDENTER), remove this guard.
> > +		 */
> > +#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
> > +		pr_warn(MSG_LBR);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > +			struct kvm_tdx_init_vm *init_vm)
> > +{
> > +	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> > +	int ret;
> > +
> > +	if (kvm->created_vcpus)
> > +		return -EBUSY;
> > +
> > +	if (init_vm->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > +		/*
> > +		 * TODO: save/restore PMU related registers around TDENTER.
> > +		 * Once it's done, remove this guard.
> > +		 */
> > +#define MSG_PERFMON	"TD doesn't support perfmon yet. KVM needs to save/restore host perf registers properly.\n"
> > +		pr_warn(MSG_PERFMON);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	td_params->max_vcpus = kvm->max_vcpus;
> Can the max vcpu number be passed by KVM_TDX_INIT_VM?
> So that no need to add KVM_CAP_MAX_VCPUS in patch 23/121.

Please see the comment there.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

