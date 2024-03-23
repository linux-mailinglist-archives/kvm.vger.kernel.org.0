Return-Path: <kvm+bounces-12538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39351887616
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 01:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E306E1F21B58
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B587FD;
	Sat, 23 Mar 2024 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9t3qxJm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D877F;
	Sat, 23 Mar 2024 00:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711153731; cv=none; b=pZZBSCIBioxV13zEzjpNrL65x/5Eqk49zSfvpWlEr7OexCvTjygpZ5Rx7w+sfWKj6GGoja9VM44aFjsI2FHgDGW218+AdarvFbF/Lzq/d7O75P1IW8XK4XwzU0pIGfCYU42zU9Isl8cNyJ5UR2T8HUYjXyHz4VFO9njxjYYd3O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711153731; c=relaxed/simple;
	bh=jVb5GT+16h3jDNU+od6bEZSrMw4FvOmODglDBfW0RcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAlYzHJxW+vl6/lBSXjdeyAfugPtqOS7sk5jgC6pYpZncx7TIcyf64Fg6UNQMQ9Sjgbj3HcOFxKHQJ1RwYmFzb1mdoK/X/nUbKtdvTriHCrST2u2u2AzXJRfrTBIKa0qT0pS/iodWzpRIstCBRkT1+5falowMuINrbzQvXtS5Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9t3qxJm; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711153729; x=1742689729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jVb5GT+16h3jDNU+od6bEZSrMw4FvOmODglDBfW0RcY=;
  b=N9t3qxJmZ7qncCF9nok5ngGE3QLyWNzeG+nZM3tRjfnj06EcIRVQ0w80
   Quuav+aeJw4XOJ8M5FHfML6BPtPD17eMaIzPP5cYB/G9jOXgOHXRg8cX7
   kLUYIIeuO1h9cmYA/NhLs7J6V1r3WQE0c6/vRPpyf3XCC8z5Jvwc5AuJQ
   Z3kuArgtZOvNX6C1dEDoLmEBKVc6x4i6ttE0YccrjJVUIdA6rRsnuhmiw
   aY41Car/Swk0/85olTaYvttuvOLHf+O0CDQOUAebDevfVDqVoC0Q341rP
   R8vgoOvUrULpI20ttwglt8C/VXMi7RPE3k8WtYYFk1uxzLH98boBd/bYE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="23712454"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="23712454"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 17:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="14981765"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 17:28:48 -0700
Date: Fri, 22 Mar 2024 17:28:47 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 036/130] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <20240323002847.GB2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
 <838fe705-4ebe-43f1-9193-4696baa05aad@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <838fe705-4ebe-43f1-9193-4696baa05aad@intel.com>

On Fri, Mar 22, 2024 at 11:26:17AM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 9ea46d143bef..e28189c81691 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -604,4 +604,21 @@ struct kvm_tdx_cpuid_config {
> >   	__u32 edx;
> >   };
> > +/* supported_gpaw */
> > +#define TDX_CAP_GPAW_48	(1 << 0)
> > +#define TDX_CAP_GPAW_52	(1 << 1)
> > +
> > +struct kvm_tdx_capabilities {
> > +	__u64 attrs_fixed0;
> > +	__u64 attrs_fixed1;
> > +	__u64 xfam_fixed0;
> > +	__u64 xfam_fixed1;
> > +	__u32 supported_gpaw;
> > +	__u32 padding;
> > +	__u64 reserved[251];
> > +
> > +	__u32 nr_cpuid_configs;
> > +	struct kvm_tdx_cpuid_config cpuid_configs[];
> > +};
> > +
> 
> I think you should use __DECLARE_FLEX_ARRAY().
> 
> It's already used in existing KVM UAPI header:
> 
> struct kvm_nested_state {
> 	...
>         union {
>                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data,
> 					 vmx);
>                 __DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data,
> 					 svm);
>         } data;
> }

Yes, will use it.


> > +	if (copy_to_user(user_caps->cpuid_configs, &tdx_info->cpuid_configs,
> > +			 tdx_info->num_cpuid_config *
> > +			 sizeof(tdx_info->cpuid_configs[0]))) {
> > +		ret = -EFAULT;
> > +	}
> 
> I think the '{ }' is needed here.

Unnecessary? Will remove braces.


> > +
> > +out:
> > +	/* kfree() accepts NULL. */
> > +	kfree(caps);
> > +	return ret;
> > +}
> > +
> >   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >   {
> >   	struct kvm_tdx_cmd tdx_cmd;
> > @@ -68,6 +121,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >   	mutex_lock(&kvm->lock);
> >   	switch (tdx_cmd.id) {
> > +	case KVM_TDX_CAPABILITIES:
> > +		r = tdx_get_capabilities(&tdx_cmd);
> > +		break;
> >   	default:
> >   		r = -EINVAL;
> >   		goto out;
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 473013265bd8..22c0b57f69ca 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -3,6 +3,9 @@
> >   #define __KVM_X86_TDX_H
> >   #ifdef CONFIG_INTEL_TDX_HOST
> > +
> > +#include "tdx_ops.h"
> > +
> 
> It appears "tdx_ops.h" is used for making SEAMCALLs.
> 
> I don't see this patch uses any SEAMCALL so I am wondering whether this
> chunk is needed here?

Will remove it to move it to an appropriate patch
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

