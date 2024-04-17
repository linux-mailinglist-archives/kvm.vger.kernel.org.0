Return-Path: <kvm+bounces-14932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EF48A7C9E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 08:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88CC128184B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 06:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73166A329;
	Wed, 17 Apr 2024 06:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wd6lwUK+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB48657C3;
	Wed, 17 Apr 2024 06:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713336965; cv=none; b=KvnHqTNzIENfKMO3Y5MyUR3stHAIm17pj2aXE2U4ffZYoXIPLtZuyaCzTE2rrxwUH1Zk2QeoJgmwgB/oUtK3jE3wnSdQYlg8KD9LArwd0FUhYw2UdZCybVSZhqnO2POnyUglwL5hd4oYSF1AHNU72aDtZmtQ9cbsYLcptzWCo1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713336965; c=relaxed/simple;
	bh=4gyETBmyEzwQWkMrvdh+Q58c/+yuC5ufSLF4lGhzQ+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPoAFtWrg+kta1hdoTeBIFKrNiDDqXE1D6W4qqQt/DKEi5zIhkisGukH4q0/Frz7d+fPh9glWLDPsoZpWKSw2ZKucrq7mM6aoeeTBZoEgaKnr0r6CxSF2QcSx6+OKafJcC1NBAtsxcgBQ9bnkK3XEW745q8tZ6Zt99ltcsBQDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wd6lwUK+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713336963; x=1744872963;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4gyETBmyEzwQWkMrvdh+Q58c/+yuC5ufSLF4lGhzQ+8=;
  b=Wd6lwUK+X3R3tq9jB9JYtcJxwFJQ5WPQ9uFB/VOi5Ubyq/t7BirRYaWJ
   J2gjtozbeQF+Q2zY72K3xYICJpYEqpXaGM9yl9XFTqeYuAKXpdGjS6Mx4
   AmBarAEoIsGrgEsurOgIkU4Od5DIT6smKbWo20PuQR7bKSaJiCSJ+6rUL
   2XX3gv9OhXT8i/kjMhpuQBzpvI2menmyrAajFZdygyvoyyDWalNicBXbe
   kcjhlmiGJoT/eif+7oRaZxBaW9Y0KuYvcYG+wBMajfDZMIcA54ruJi28g
   Rp7VCzja8ttv/6I0BzBke8j3w8gmPVAdDhjWrQjoKRHwRpYsGDCVjRZiO
   Q==;
X-CSE-ConnectionGUID: NaxOOBOoQtmjX4E5/bXY0w==
X-CSE-MsgGUID: v0aIhjORTgCKoAJzPoSFfQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8940345"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8940345"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 23:56:02 -0700
X-CSE-ConnectionGUID: Ju82xnaAR8O7O7nQuVFBKw==
X-CSE-MsgGUID: vlXegU/nST+uqttb6eGwKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="59942086"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 23:56:01 -0700
Date: Tue, 16 Apr 2024 23:56:00 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
Message-ID: <20240417065600.GE3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
 <7d19f693-d8e9-4a9d-8cfa-3ec9c388622f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7d19f693-d8e9-4a9d-8cfa-3ec9c388622f@intel.com>

On Tue, Apr 16, 2024 at 11:23:01AM -0700,
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Isaku,
> 
> (In shortlog "tdexit" can be "TD exit" to be consistent with
> documentation.)
> 
> On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > This corresponds to VMX __vmx_complete_interrupts().  Because TDX
> > virtualize vAPIC, KVM only needs to care NMI injection.
> 
> This seems to be the first appearance of NMI and the changelog
> is very brief. How about expending it with:
> 
> "This corresponds to VMX __vmx_complete_interrupts().  Because TDX
>  virtualize vAPIC, KVM only needs to care about NMI injection.
> 
>  KVM can request TDX to inject an NMI into a guest TD vCPU when the
>  vCPU is not active. TDX will attempt to inject an NMI as soon as
>  possible on TD entry. NMI injection is managed by writing to (to
>  inject NMI) and reading from (to get status of NMI injection)
>  the PEND_NMI field within the TDX vCPU scope metadata (Trust
>  Domain Virtual Processor State (TDVPS)).
> 
>  Update KVM's NMI status on TD exit by checking whether a requested
>  NMI has been injected into the TD. Reading the metadata via SEAMCALL
>  is expensive so only perform the check if an NMI was injected.
> 
>  This is the first need to access vCPU scope metadata in the
>  "management" class. Ensure that needed accessor is available. 
> "
> 
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > ---
> > v19:
> > - move tdvps_management_check() to this patch
> > - typo: complete -> Complete in short log
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
> >  arch/x86/kvm/vmx/tdx.h |  4 ++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 83dcaf5b6fbd..b8b168f74dfe 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	 */
> >  }
> >  
> > +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> > +{
> > +	/* Avoid costly SEAMCALL if no nmi was injected */
> 
> 	/* Avoid costly SEAMCALL if no NMI was injected. */
> 
> > +	if (vcpu->arch.nmi_injected)
> > +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> > +							      TD_VCPU_PEND_NMI);
> > +}
> > +
> >  struct tdx_uret_msr {
> >  	u32 msr;
> >  	unsigned int slot;
> > @@ -663,6 +671,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> >  	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> >  
> > +	tdx_complete_interrupts(vcpu);
> > +
> >  	return EXIT_FASTPATH_NONE;
> >  }
> >  
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 44eab734e702..0d8a98feb58e 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -142,6 +142,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> >  			 "Invalid TD VMCS access for 16-bit field");
> >  }
> >  
> > +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
> 
> Is this intended to be a stub or is it expected to be fleshed out with
> some checks?

It was used to check if field id matches bits.  We should make
tdvps_vmcs_check() common for vmcs, management and state_non_arch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

