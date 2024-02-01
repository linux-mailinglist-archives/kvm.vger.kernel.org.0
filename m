Return-Path: <kvm+bounces-7669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F77F845148
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 07:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 586D41C26A06
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 06:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2CC0651A2;
	Thu,  1 Feb 2024 06:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHVbXHYz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614D65FB9C;
	Thu,  1 Feb 2024 06:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706768189; cv=none; b=uHjaCKHjfy6ZxbNOBVD6SbRUxEsOLxMzeko4+DKLMOGXFX5pJZCuV7PHNcWDZY/5qKv2fHHUf1ro+h/OVLldV4/rCAQNJlC+j+Aymy9W4MYzNP/Jng7VGgaFl1yAp1ZsPKaHLttG4WH4Z4zSjKxFuvjfmmAZnnR9PiiNFJmfJQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706768189; c=relaxed/simple;
	bh=/CJW5+f/hsgH8Yfkf9jmrhy26uWv39fxhjkF6NFeymk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0S613SGzvvpyp1yIxRYRiWROg+cZ9OPH9dVNcWWAiKpUn/fzPETXfi1leMeEufjYgw9ibqhUwYTEOETH7qWVfPaCJKP9wnvONXGrKAG9KNquXaJ5rpL9z4PTU4bXrLdgegQM08BOBxiiVB7Ixc2BBkvC/fLujaQ95M71lKjygc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHVbXHYz; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706768187; x=1738304187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/CJW5+f/hsgH8Yfkf9jmrhy26uWv39fxhjkF6NFeymk=;
  b=HHVbXHYzJv7Wu64wkK6JvuK3cmrvmrBIwV3HpdHYGCKEvIZCXCLAYmlD
   pJeESNn+oqfgywjIUzkIUq9JCAtWPzj6ePrXAuYZ5ahEFUvIckG5jsaLf
   6buXAsvTfBEpmEZXDAThK2ud4XUiIYjJ5tEhwviOAy498F2oW2gMYyVMK
   0oTRzIb3bYbDJq3LWLTMwEZvSmC4N5BTyBLdk+sQrOQaKCnVuhKlisizw
   aa0cJw29btrntW7RUxymByKSJjERTsNp29qHR+aa/Jz4JLwrEP3E/79BF
   skqTQF1ZgMHKWMo8EJiKP9+y76uE2kF2+JF/ia+GUxTJwyAawf9Kg9MfJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="394266941"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="394266941"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 22:16:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="4324644"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jan 2024 22:16:22 -0800
Date: Thu, 1 Feb 2024 14:16:22 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 023/121] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <20240201061622.hvun7amakvbplmsb@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ed33ebe29b231e8e657cd610a983fa603b10f530.1705965634.git.isaku.yamahata@intel.com>
 <7cc28677-f7d1-4aba-8557-66c685115074@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cc28677-f7d1-4aba-8557-66c685115074@linux.intel.com>
User-Agent: NeoMutt/20171215

On Wed, Jan 24, 2024 at 09:17:15AM +0800, Binbin Wu wrote:
>
>
> On 1/23/2024 7:52 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > TDX has its own limitation on the maximum number of vcpus that the guest
> > can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> > handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
> > e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
> For legacy VM, KVM just provides the interface to query the max_vcpus.
> Why TD needs to provide a interface for userspace to set the limitation?
> What's the scenario?

I think the reason is TDH.MNG.INIT needs it:

TD_PARAMS:
    MAX_VCPUS:
        offset: 16 bytes.
        type: Unsigned 16b Integer.
        size: 2.
        Description: Maximum number of VCPUs.

May better to clarify this in the commit yet.

>
>
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v18:
> > - use TDX instead of "x86, tdx" in subject
> > - use min(max_vcpu, TDX_MAX_VCPU) instead of
> >    min3(max_vcpu, KVM_MAX_VCPU, TDX_MAX_VCPU)
> > - make "if (KVM_MAX_VCPU) and if (TDX_MAX_VCPU)" into one if statement
> > ---
> >   arch/x86/include/asm/kvm-x86-ops.h |  2 ++
> >   arch/x86/include/asm/kvm_host.h    |  2 ++
> >   arch/x86/kvm/vmx/main.c            | 22 ++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx.c             | 29 +++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/x86_ops.h         |  5 +++++
> >   arch/x86/kvm/x86.c                 |  4 ++++
> >   6 files changed, 64 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 943b21b8b106..2f976c0f3116 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -21,6 +21,8 @@ KVM_X86_OP(hardware_unsetup)
> >   KVM_X86_OP(has_emulated_msr)
> >   KVM_X86_OP(vcpu_after_set_cpuid)
> >   KVM_X86_OP(is_vm_type_supported)
> > +KVM_X86_OP_OPTIONAL(max_vcpus);
> > +KVM_X86_OP_OPTIONAL(vm_enable_cap)
> >   KVM_X86_OP(vm_init)
> >   KVM_X86_OP_OPTIONAL(vm_destroy)
> >   KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 26f4668b0273..db44a92e5659 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1602,7 +1602,9 @@ struct kvm_x86_ops {
> >   	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
> >   	bool (*is_vm_type_supported)(unsigned long vm_type);
> > +	int (*max_vcpus)(struct kvm *kvm);
> >   	unsigned int vm_size;
> > +	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
> >   	int (*vm_init)(struct kvm *kvm);
> >   	void (*vm_destroy)(struct kvm *kvm);
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 50da807d7aea..4611f305a450 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -6,6 +6,7 @@
> >   #include "nested.h"
> >   #include "pmu.h"
> >   #include "tdx.h"
> > +#include "tdx_arch.h"
> >   static bool enable_tdx __ro_after_init;
> >   module_param_named(tdx, enable_tdx, bool, 0444);
> > @@ -16,6 +17,17 @@ static bool vt_is_vm_type_supported(unsigned long type)
> >   		(enable_tdx && tdx_is_vm_type_supported(type));
> >   }
> > +static int vt_max_vcpus(struct kvm *kvm)
> > +{
> > +	if (!kvm)
> > +		return KVM_MAX_VCPUS;
> > +
> > +	if (is_td(kvm))
> > +		return min(kvm->max_vcpus, TDX_MAX_VCPUS);
> > +
> > +	return kvm->max_vcpus;
> > +}
> > +
> >   static int vt_hardware_enable(void)
> >   {
> >   	int ret;
> > @@ -54,6 +66,14 @@ static void vt_hardware_unsetup(void)
> >   	vmx_hardware_unsetup();
> >   }
> > +static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> > +{
> > +	if (is_td(kvm))
> > +		return tdx_vm_enable_cap(kvm, cap);
> > +
> > +	return -EINVAL;
> > +}
> > +
> >   static int vt_vm_init(struct kvm *kvm)
> >   {
> >   	if (is_td(kvm))
> > @@ -91,7 +111,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >   	.has_emulated_msr = vmx_has_emulated_msr,
> >   	.is_vm_type_supported = vt_is_vm_type_supported,
> > +	.max_vcpus = vt_max_vcpus,
> >   	.vm_size = sizeof(struct kvm_vmx),
> > +	.vm_enable_cap = vt_vm_enable_cap,
> >   	.vm_init = vt_vm_init,
> >   	.vm_destroy = vmx_vm_destroy,
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8c463407f8a8..876ad7895b88 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -100,6 +100,35 @@ struct tdx_info {
> >   /* Info about the TDX module. */
> >   static struct tdx_info *tdx_info;
> > +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> > +{
> > +	int r;
> > +
> > +	switch (cap->cap) {
> > +	case KVM_CAP_MAX_VCPUS: {
> > +		if (cap->flags || cap->args[0] == 0)
> > +			return -EINVAL;
> > +		if (cap->args[0] > KVM_MAX_VCPUS ||
> > +		    cap->args[0] > TDX_MAX_VCPUS)
> > +			return -E2BIG;
> > +
> > +		mutex_lock(&kvm->lock);
> > +		if (kvm->created_vcpus)
> > +			r = -EBUSY;
> > +		else {
> > +			kvm->max_vcpus = cap->args[0];
> > +			r = 0;
> > +		}
> > +		mutex_unlock(&kvm->lock);
> > +		break;
> > +	}
> > +	default:
> > +		r = -EINVAL;
> > +		break;
> > +	}
> > +	return r;
> > +}
> > +
> >   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> >   {
> >   	struct kvm_tdx_capabilities __user *user_caps;
> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index 6e238142b1e8..3a3be66888da 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -139,12 +139,17 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> >   void tdx_hardware_unsetup(void);
> >   bool tdx_is_vm_type_supported(unsigned long type);
> > +int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> >   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> >   #else
> >   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> >   static inline void tdx_hardware_unsetup(void) {}
> >   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> > +static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> > +{
> > +	return -EINVAL;
> > +};
> >   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> >   #endif
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index dd3a23d56621..a1389ddb1b33 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4726,6 +4726,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   		break;
> >   	case KVM_CAP_MAX_VCPUS:
> >   		r = KVM_MAX_VCPUS;
> > +		if (kvm_x86_ops.max_vcpus)
> > +			r = static_call(kvm_x86_max_vcpus)(kvm);
> >   		break;
> >   	case KVM_CAP_MAX_VCPU_ID:
> >   		r = KVM_MAX_VCPU_IDS;
> > @@ -6683,6 +6685,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >   		break;
> >   	default:
> >   		r = -EINVAL;
> > +		if (kvm_x86_ops.vm_enable_cap)
> > +			r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
> >   		break;
> >   	}
> >   	return r;
>
>

