Return-Path: <kvm+bounces-12530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B078874E6
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D39D1F242C8
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 22:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2516682891;
	Fri, 22 Mar 2024 22:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kRlENm+9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694B26AD4;
	Fri, 22 Mar 2024 22:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711147535; cv=none; b=FeaCYtmB+PMRNpeiNe5OhibP6FQzN3Bsns0oTQObU7oMsd8LZS7SUFylqOx3IPZqdhWKy5DpaVa8W98jody6WHzHp7jJIEZAYF56xjZOgiSx1TIMW43Cw1lvWfQqfzDpAJntHfwOVbnZ2o25Ei3c9y+dJU2O7gOWyvwqwCzK4bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711147535; c=relaxed/simple;
	bh=5DSDTqIBgL+u9vNQy3dkqKf3CogV46CDwNHk/7o9d6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1fZPfiBa3smEVffE/naX1c6faa105lNmnEKZwUAZimEKb/DEXa0yl2pb2GFQsG9zXLS1cxyhC+Iu+4n1/MW8a2vCYhLQDajnsTlybTLQtf3xGVKKEYRn51hCab8MQdQouZ9nsnWnyfg9q37NfGHMBQSVuHU65ckF0HiuYrZLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kRlENm+9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711147533; x=1742683533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5DSDTqIBgL+u9vNQy3dkqKf3CogV46CDwNHk/7o9d6c=;
  b=kRlENm+95+nXP81zvxksBEYaZGIZjXqAwUwG9wAbkBuRspB9OmZ8/0zE
   SijarbFU8cc9t5KKjxZIdhWsp6RHn0M6Z1aujbbS5kdJBBjL7NDVADM8L
   tIR8zkGY24xUkiuzusqp4Tq08yC+lGlL/bIAZVS00ky+OiEPoBChKXbsF
   ozP0VvRDJ2nyj84AWip5D/6i4nHnzRHkfzpx4NH1hp+3mcVPPbrdKtUlq
   uU2TFEgV38ylGbjAMykCnUqGvu6jx3om2Chl541vsU/vOFExLa1q+tzp0
   k5RiG3ag+At1QXbmQbDe2wQv9srlAv3duSKf4fA7ed1fLdBUin7FTlSOy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="6047224"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="6047224"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 15:45:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15467874"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 15:45:32 -0700
Date: Fri, 22 Mar 2024 15:45:31 -0700
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
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Message-ID: <20240322224531.GB1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
 <dd389847-6f67-4f5d-8358-5d6b6a493797@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd389847-6f67-4f5d-8358-5d6b6a493797@intel.com>

On Fri, Mar 22, 2024 at 10:37:20AM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 26/02/2024 9:25 pm, Yamahata, Isaku wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add placeholders TDX VM/vcpu structure that overlays with VMX VM/vcpu
> > structures.  Initialize VM structure size and vcpu size/align so that x86
> > KVM common code knows those size irrespective of VMX or TDX.  Those
> > structures will be populated as guest creation logic develops.
> > 
> > Add helper functions to check if the VM is guest TD and add conversion
> > functions between KVM VM/VCPU and TDX VM/VCPU.
> 
> The changelog is essentially only saying "doing what" w/o "why".
> 
> Please at least explain why you invented the 'struct kvm_tdx' and 'struct
> vcpu_tdx', and why they are invented in this way.
> 
> E.g., can we extend 'struct kvm_vmx' for TDX?
> 
> struct kvm_tdx {
> 	struct kvm_vmx vmx;
> 	...
> };

Here is the updated version.

KVM: TDX: Add placeholders for TDX VM/vcpu structure

Add placeholders TDX VM/vCPU structure, overlaying with the existing
VMX VM/vCPU structures.  Initialize VM structure size and vCPU
size/align so that x86 KVM-common code knows those sizes irrespective
of VMX or TDX.  Those structures will be populated as guest creation
logic develops.

TDX requires its data structure for guest and vcpu.  For VMX, we
already have struct kvm_vmx and struct vcpu_vmx.  Two options to add
TDX-specific members.

1. Append TDX-specific members to kvm_vmx and vcpu_vmx.  Use the same
    struct for both VMX and TDX.
2. Define TDX-specific data struct and overlay.

Choose option two because it has less memory overhead and what member
is needed is clearer

Add helper functions to check if the VM is guest TD and add the conversion
functions between KVM VM/vCPU and TDX VM/vCPU.


> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v19:
> > - correctly update ops.vm_size, vcpu_size and, vcpu_align by Xiaoyao
> > 
> > v14 -> v15:
> > - use KVM_X86_TDX_VM
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/main.c | 14 ++++++++++++
> >   arch/x86/kvm/vmx/tdx.c  |  1 +
> >   arch/x86/kvm/vmx/tdx.h  | 50 +++++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 65 insertions(+)
> >   create mode 100644 arch/x86/kvm/vmx/tdx.h
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 18aef6e23aab..e11edbd19e7c 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -5,6 +5,7 @@
> >   #include "vmx.h"
> >   #include "nested.h"
> >   #include "pmu.h"
> > +#include "tdx.h"
> >   static bool enable_tdx __ro_after_init;
> >   module_param_named(tdx, enable_tdx, bool, 0444);
> > @@ -18,6 +19,9 @@ static __init int vt_hardware_setup(void)
> >   		return ret;
> >   	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > +	if (enable_tdx)
> > +		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> > +					   sizeof(struct kvm_tdx));
> 
> Now I see why you included 'struct kvm_x86_ops' as function parameter.
> 
> Please move it to this patch.

Sure.

> >   	return 0;
> >   }
> > @@ -215,8 +219,18 @@ static int __init vt_init(void)
> >   	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> >   	 * exposed to userspace!
> >   	 */
> > +	/*
> > +	 * kvm_x86_ops is updated with vt_x86_ops.  vt_x86_ops.vm_size must
> > +	 * be set before kvm_x86_vendor_init().
> > +	 */
> >   	vcpu_size = sizeof(struct vcpu_vmx);
> >   	vcpu_align = __alignof__(struct vcpu_vmx);
> > +	if (enable_tdx) {
> > +		vcpu_size = max_t(unsigned int, vcpu_size,
> > +				  sizeof(struct vcpu_tdx));
> > +		vcpu_align = max_t(unsigned int, vcpu_align,
> > +				   __alignof__(struct vcpu_tdx));
> > +	}
> 
> Since you are updating vm_size in vt_hardware_setup(), I am wondering
> whether we can do similar thing for vcpu_size and vcpu_align.
> 
> That is, we put them both to 'struct kvm_x86_ops', and you update them in
> vt_hardware_setup().
> 
> kvm_init() can then just access them directly in this way both 'vcpu_size'
> and 'vcpu_align' function parameters can be removed.

Hmm, now I noticed the vm_size can be moved here.  We have

 	vcpu_size = sizeof(struct vcpu_vmx);
 	vcpu_align = __alignof__(struct vcpu_vmx);
	if (enable_tdx) {
		vcpu_size = max_t(unsigned int, vcpu_size,
				  sizeof(struct vcpu_tdx));
		vcpu_align = max_t(unsigned int, vcpu_align,
				   __alignof__(struct vcpu_tdx));
                vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
                                          sizeof(struct kvm_tdx));
	}


We can add vcpu_size, vcpu_align to struct kvm_x86_ops. If we do so, we have
to touch svm code unnecessarily.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

