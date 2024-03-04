Return-Path: <kvm+bounces-10813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF8C87060A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 16:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C44E1F26CFA
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283614F613;
	Mon,  4 Mar 2024 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dN/z8E/a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798C84E1B3;
	Mon,  4 Mar 2024 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709566775; cv=none; b=Pqf1eI2UegtKUDuHo+370zqaHxO8m7gnFk7Y0Vh3CTXTwwlKVWfZIB0MldP74I/6iAjn2dalRmDOSFJW7E8YeSiYVMJ08JgGO3a6c+rv4/nEqiXWY47U7uXs+1q8/5e9+UQgf391ecfGAgvmlIXx/GfAXhsvk4BYHq8k7WO/RaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709566775; c=relaxed/simple;
	bh=WyAFF4efHQkvhI2LMhQ5MDLPX/vPJq0gOCWzwgBSs5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2mGo1K072w0Zo7PEWasMvKPr7NRjIQEpxz4i1OzxwZPv/TMQZOC9DRxMkWRjvm2BbssGRRR/JGaorvWsH5oEudKpQNRvLxl9NS//f+Zd2aqAZo8zI8Tm0bCV/Em/aTaHtKGC81sWQE77hQkdZHHlbM+scso+szGvvwMoqyOa+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dN/z8E/a; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709566773; x=1741102773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WyAFF4efHQkvhI2LMhQ5MDLPX/vPJq0gOCWzwgBSs5o=;
  b=dN/z8E/afRx4eFz1buZqDvq8L2a/IRYyZTvr4/DqD4517U4kQv+2CugK
   HGXAuHlEC0oaubRPmAlpoOPldzi+U2T8lCYC78VZbQV4gU4FhAXqs7snv
   Ua+8Qd4JhC0RYkR0vooFyhnQRDWXAglgCzwRl/JK2D9UwVSHdU3r7WBvA
   YdTdPcOmiV3BfblkXFDf6YYM++tXu4+CedGrsdhaARL31wc91Pf5f5GWA
   zc45mBcf2rJcJJxU5L7tVKHFXe+DDntxX8zGAIb24F3jkHKqMP4segvps
   3oJTIYPhE6LaQy+a1d+LUAkdfe4Ie3OX/EFzsW9AZxLKyMKWb55nBDYQ7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="4229563"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="4229563"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 07:39:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="9458305"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 04 Mar 2024 07:39:28 -0800
Date: Mon, 4 Mar 2024 23:35:16 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, aik@amd.com
Subject: Re: [PATCH v3 14/15] KVM: SEV: introduce KVM_SEV_INIT2 operation
Message-ID: <ZeXqNLr2nfMJ0RhZ@yilunxu-OptiPlex-7050>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-15-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-15-pbonzini@redhat.com>

On Mon, Feb 26, 2024 at 02:03:43PM -0500, Paolo Bonzini wrote:
> The idea that no parameter would ever be necessary when enabling SEV or
> SEV-ES for a VM was decidedly optimistic.  In fact, in some sense it's
> already a parameter whether SEV or SEV-ES is desired.  Another possible
> source of variability is the desired set of VMSA features, as that affects
> the measurement of the VM's initial state and cannot be changed
> arbitrarily by the hypervisor.
> 
> Create a new sub-operation for KVM_MEMORY_ENCRYPT_OP that can take a struct,
> and put the new op to work by including the VMSA features as a field of the
> struct.  The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
> supported VMSA features for backwards compatibility.
> 
> The struct also includes the usual bells and whistles for future
> extensibility: a flags field that must be zero for now, and some padding
> at the end.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 40 +++++++++++++--
>  arch/x86/include/uapi/asm/kvm.h               |  9 ++++
>  arch/x86/kvm/svm/sev.c                        | 50 +++++++++++++++++--
>  3 files changed, 92 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 5ed11bc16b96..b951d82af26c 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -75,15 +75,49 @@ are defined in ``<linux/psp-dev.h>``.
>  KVM implements the following commands to support common lifecycle events of SEV
>  guests, such as launching, running, snapshotting, migrating and decommissioning.
>  
> -1. KVM_SEV_INIT
> ----------------
> +1. KVM_SEV_INIT2
> +----------------
>  
> -The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
> +The KVM_SEV_INIT2 command is used by the hypervisor to initialize the SEV platform
>  context. In a typical workflow, this command should be the first command issued.
>  
> +For this command to be accepted, either KVM_X86_SEV_VM or KVM_X86_SEV_ES_VM
> +must have been passed to the KVM_CREATE_VM ioctl.  A virtual machine created
> +with those machine types in turn cannot be run until KVM_SEV_INIT2 is invoked.
> +
> +Parameters: struct kvm_sev_init (in)
>  
>  Returns: 0 on success, -negative on error
>  
> +::
> +
> +        struct struct kvm_sev_init {

Remove the duplicated "struct"

> +                __u64 vmsa_features;  /* initial value of features field in VMSA */
> +                __u32 flags;          /* must be 0 */
> +                __u32 pad[9];
> +        };
> +
> +It is an error if the hypervisor does not support any of the bits that
> +are set in ``flags`` or ``vmsa_features``.  ``vmsa_features`` must be
> +0 for SEV virtual machines, as they do not have a VMSA.
> +
> +This command replaces the deprecated KVM_SEV_INIT and KVM_SEV_ES_INIT commands.
> +The commands did not have any parameters (the ```data``` field was unused) and
> +only work for the KVM_X86_DEFAULT_VM machine type (0).
> +
> +They behave as if:
> +
> +* the VM type is KVM_X86_SEV_VM for KVM_SEV_INIT, or KVM_X86_SEV_ES_VM for
> +  KVM_SEV_ES_INIT
> +
> +* the ``flags`` and ``vmsa_features`` fields of ``struct kvm_sev_init`` are
> +  set to zero
> +
> +If the ``KVM_X86_SEV_VMSA_FEATURES`` attribute does not exist, the hypervisor only
> +supports KVM_SEV_INIT and KVM_SEV_ES_INIT.  In that case, note that KVM_SEV_ES_INIT
> +might set the debug swap VMSA feature (bit 5) depending on the value of the
> +``debug_swap`` parameter of ``kvm-amd.ko``.
> +
>  2. KVM_SEV_LAUNCH_START
>  -----------------------
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 9d950b0b64c9..51b13080ed4b 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -690,6 +690,9 @@ enum sev_cmd_id {
>  	/* Guest Migration Extension */
>  	KVM_SEV_SEND_CANCEL,
>  
> +	/* Second time is the charm; improved versions of the above ioctls.  */
> +	KVM_SEV_INIT2,
> +
>  	KVM_SEV_NR_MAX,
>  };
>  
> @@ -701,6 +704,12 @@ struct kvm_sev_cmd {
>  	__u32 sev_fd;
>  };
>  
> +struct kvm_sev_init {
> +	__u64 vmsa_features;
> +	__u32 flags;
> +	__u32 pad[9];
> +};
> +
>  struct kvm_sev_launch_start {
>  	__u32 handle;
>  	__u32 policy;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1248ccf433e8..909e67a9044b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -239,23 +239,30 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>  	sev_decommission(handle);
>  }
>  
> -static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
> +			    struct kvm_sev_init *data,
> +			    unsigned long vm_type)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	bool es_active = kvm->arch.has_protected_state;
> +	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
>  	int ret;
>  
>  	if (kvm->created_vcpus)
>  		return -EINVAL;
>  
> -	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +	if (data->flags)
> +		return -EINVAL;
> +
> +	if (data->vmsa_features & ~valid_vmsa_features)
>  		return -EINVAL;
>  
>  	if (unlikely(sev->active))
>  		return -EINVAL;
>  
>  	sev->active = true;
> -	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> -	sev->vmsa_features = 0;
> +	sev->es_active = es_active;
> +	sev->vmsa_features = data->vmsa_features;
>  
>  	ret = sev_asid_new(sev);
>  	if (ret)
> @@ -283,6 +290,38 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_init data = {
> +		.vmsa_features = 0,
> +	};
> +	unsigned long vm_type;
> +
> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
                                 ^

Same here, KVM_X86_SEV_VM?

Thanks,
Yilun

> +		return -EINVAL;
> +
> +	vm_type = (argp->id == KVM_SEV_INIT ? KVM_X86_SEV_VM : KVM_X86_SEV_ES_VM);
> +	return __sev_guest_init(kvm, argp, &data, vm_type);
> +}
> +
> +static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_init data;
> +
> +	if (!sev->need_init)
> +		return -EINVAL;
> +
> +	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
> +	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
> +		return -EFAULT;
> +
> +	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type);
> +}
> +
>  static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>  {
>  	unsigned int asid = sev_get_asid(kvm);
> @@ -1898,6 +1937,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_INIT:
>  		r = sev_guest_init(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_INIT2:
> +		r = sev_guest_init2(kvm, &sev_cmd);
> +		break;
>  	case KVM_SEV_LAUNCH_START:
>  		r = sev_launch_start(kvm, &sev_cmd);
>  		break;
> -- 
> 2.39.1
> 
> 
> 

