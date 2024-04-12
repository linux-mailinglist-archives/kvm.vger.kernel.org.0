Return-Path: <kvm+bounces-14573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DA78A36E6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B5401F25FF7
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B611514CA;
	Fri, 12 Apr 2024 20:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjfvI559"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558CC1509B9;
	Fri, 12 Apr 2024 20:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712953026; cv=none; b=B/jPGzDVFRWGY2Jv4rjId4u3NhL0GDFEwcME+UyReaeV5DfNJGgJyqsuYHQ8efswremzHPNOQ+48H1c9nl4C0uRm6F5kKmc5ljN0ifDf4bPBCyXj4aHzuwVUWq6gLTUbMx+fHBwLe+mPNEnCO29oMfQifs00iV9f83gxAoEia9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712953026; c=relaxed/simple;
	bh=gRtk42mEkPYRS2+FeeJPBc/53CUWk0nWuXvrBo/KmZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxmGus+ZAjyk0ik0El2BjlWMnR8OP+5dEcgYH6SyOH2Yhh/QZUEid8j3t9v452bqyUhTdco4ZXydQdfcxSiei1oOGNj57uQY9DKtIpOcpG5jcBVSMlVyhbjvKR2roWGewMf8PWfQid6EFior1F1UQGH7l6WlwzmMAqAGKsqi3AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjfvI559; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712953024; x=1744489024;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gRtk42mEkPYRS2+FeeJPBc/53CUWk0nWuXvrBo/KmZ0=;
  b=CjfvI559GqmLFlL9HNOtOsuDFAdbIb7hjRUGa/HIM2yWwwNdX/eCYd0H
   aionN7ATW5fIRjuNu7vfcfYW1MEqfB/ec3pIKpFmCiv0eUxzoGQNN+SXC
   b+4FhjimEpYWfd2W6SOEbtwyMV1CJQQu5Yp62zTLaF+uwEVJHWdu4vh7B
   Km/GME07iALZROEYxPKW/BHvy7lSN9SBPoNalfJgub1r4hkWpuppGNlgY
   UsQyhaqT+8wQx13dln4SVFJNQgn//AIrLeVDql5hBAnXdUeEXsvDD+RMV
   /kpAu+Whkp6OTUONstgpUb/co8FmT+lwX4ZNLDEit0uaEzu9dPvJRXjWC
   A==;
X-CSE-ConnectionGUID: S1T4jC7iTsuyCCPRfb6llQ==
X-CSE-MsgGUID: b4XPtzCETC65Of/R6bJ2WQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12208032"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="12208032"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:17:03 -0700
X-CSE-ConnectionGUID: gxXJc0U9Rw+Z4cl435oOXw==
X-CSE-MsgGUID: p6NoYQyWRMGsXb7kmO5RPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="25982451"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:17:04 -0700
Date: Fri, 12 Apr 2024 13:17:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 079/130] KVM: TDX: vcpu_run: save/restore host
 state(host kernel gs)
Message-ID: <20240412201702.GJ3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a766983346b2c01e943348af3c5ca6691e272f9.1708933498.git.isaku.yamahata@intel.com>
 <8132ddff-16f3-482f-b08b-a73aa8eddbbc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8132ddff-16f3-482f-b08b-a73aa8eddbbc@linux.intel.com>

On Sun, Apr 07, 2024 at 11:02:52AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index d72651ce99ac..8275a242ce07 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -158,6 +158,32 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >   	vmx_vcpu_reset(vcpu, init_event);
> >   }
> > +static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * All host state is saved/restored across SEAMCALL/SEAMRET,
> 
> It sounds confusing to me.
> If all host states are saved/restored across SEAMCALL/SEAMRET, why this
> patch saves/restores MSR_KERNEL_GS_BASE for host?
>

No. Probably we should update the comment. Something like
  restored => restored or initialized to reset state.

Except conditionally saved/restored MSRs (e.g., perfrmon, debugreg), IA32_START,
IA32_LSTART, MSR_SYSCALL_MASK, IA32_TSC_AUX and TA32_KERNEL_GS_BASE are reset to
initial state.  uret handles the first four. The kernel_gs_base needs to be
restored on TDExit.

> >   and the
> > +	 * guest state of a TD is obviously off limits.  Deferring MSRs and DRs
> > +	 * is pointless because the TDX module needs to load *something* so as
> > +	 * not to expose guest state.
> > +	 */
> > +	if (is_td_vcpu(vcpu)) {
> > +		tdx_prepare_switch_to_guest(vcpu);
> > +		return;
> > +	}
> > +
> > +	vmx_prepare_switch_to_guest(vcpu);
> > +}
> > +
> > +static void vt_vcpu_put(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu)) {
> > +		tdx_vcpu_put(vcpu);
> > +		return;
> > +	}
> > +
> > +	vmx_vcpu_put(vcpu);
> > +}
> > +
> >   static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
> >   {
> >   	if (is_td_vcpu(vcpu))
> > @@ -326,9 +352,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >   	.vcpu_free = vt_vcpu_free,
> >   	.vcpu_reset = vt_vcpu_reset,
> > -	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> > +	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
> >   	.vcpu_load = vmx_vcpu_load,
> > -	.vcpu_put = vmx_vcpu_put,
> > +	.vcpu_put = vt_vcpu_put,
> >   	.update_exception_bitmap = vmx_update_exception_bitmap,
> >   	.get_msr_feature = vmx_get_msr_feature,
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index fdf9196cb592..9616b1aab6ce 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1,5 +1,6 @@
> >   // SPDX-License-Identifier: GPL-2.0
> >   #include <linux/cpu.h>
> > +#include <linux/mmu_context.h>
> >   #include <asm/tdx.h>
> > @@ -423,6 +424,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> >   int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >   {
> >   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >   	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> >   	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> > @@ -446,9 +448,47 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >   	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
> >   		vcpu->arch.xfd_no_write_intercept = true;
> > +	tdx->host_state_need_save = true;
> > +	tdx->host_state_need_restore = false;
> > +
> >   	return 0;
> >   }
> > +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> 
> Just like vmx_prepare_switch_to_host(), the input can be "struct vcpu_tdx
> *", since vcpu is not used inside the function.
> And the callsites just use "to_tdx(vcpu)"
> 
> > +{
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> Then, this can be dropped.

prepare_switch_to_guest() is used for kvm_x86_ops.prepare_switch_to_guest().
kvm_x86_ops consistently takes struct kvm_vcpu.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

