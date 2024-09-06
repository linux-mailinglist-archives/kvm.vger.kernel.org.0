Return-Path: <kvm+bounces-25980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA3B96E8A4
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05655286626
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BC84AEF2;
	Fri,  6 Sep 2024 04:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jf4iS0IX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FE18B04;
	Fri,  6 Sep 2024 04:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597182; cv=none; b=qYoaGmkA0jXurW1DyN3TsNQjtdaBxJ1oEUyfLnclPASZKmbHx7GsmDNFGcs2sXpu7Oyy9WpALU/R+srwmHWPen0VnScKXTPR8p5OU++95JT7UA1qq2Kgm/OYTw/TQaE+6kaNL9hH8JCXnAQ3TLSJukGI7I3XetZtl5YXHW7pnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597182; c=relaxed/simple;
	bh=Fj9dEc+tZpcXOsZKa06MZnv9QMwPhL5d/Rc7J136zYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UIMrAH8Vhv0XLOMr0//76xu/p2zssC7jh0VFjJYRliy5XcGaVzOW7QmgN+Dg6tLHF+BAO3CFNxdocc9BLvJH2m0sxt5xEgtfoxLMtWE/yqHIe2BeZZyzNlrlPS3po9u4tTPtKm5F8Ud9vw9X6arvfbNNOlO2UqkUUlQCKvRnQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jf4iS0IX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725597181; x=1757133181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Fj9dEc+tZpcXOsZKa06MZnv9QMwPhL5d/Rc7J136zYM=;
  b=Jf4iS0IXxA7eDmfPwGzqV8CCwrK1sjN0kDqDPXlPjTVF/Fccjogwf/O8
   puv1bZBrPb2QlLqgLSdsP8B7qOaDZtFFjfA+P5DUsISFgA8/AlDjSYQMN
   a04AXPeN8VJGa0OU2jmBh+Kt6iP9kT7l1elONX9Ojk+yjX4d1Qu0alQu1
   A8FOhIi9G9TOVru8fRHlaxPWipLwqI+3jbbsfZAY58dJZPYSaZGzv+PFY
   gaHpGn3JA7tC0EmdILRQWMrfG/oVJsaZXIk0hZUvCAf7Sg5o79t+51srm
   Do/n1DcCf92o1NRKCSdH7apD2Eq0x2gPm88rxL4RzCOMhrf8BP9470UsP
   A==;
X-CSE-ConnectionGUID: rl9KhhKGQzKjrv7HQflYkA==
X-CSE-MsgGUID: pgM06nsvS8maNYugJgtAQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="35493848"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="35493848"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 21:33:00 -0700
X-CSE-ConnectionGUID: mg1kXCLTTP6Brze7PsIp5w==
X-CSE-MsgGUID: iJK6NP+HS8mohDc3yr1wjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="66171134"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.242])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 21:32:56 -0700
Date: Fri, 6 Sep 2024 07:32:48 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <ZtqF8O56_h0_g6oD@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
 <ZtWUATuc5wim02rN@tlindgre-MOBL1>
 <ZtlWzUO+VGzt7Z89@yzhao56-desk.sh.intel.com>
 <Ztl5muQNXr7eGLWU@tlindgre-MOBL1>
 <Ztp/lQ/SaCe+/4qb@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ztp/lQ/SaCe+/4qb@yzhao56-desk.sh.intel.com>

On Fri, Sep 06, 2024 at 12:05:41PM +0800, Yan Zhao wrote:
> On Thu, Sep 05, 2024 at 12:27:54PM +0300, Tony Lindgren wrote:
> > On Thu, Sep 05, 2024 at 02:59:25PM +0800, Yan Zhao wrote:
> > > On Mon, Sep 02, 2024 at 01:31:29PM +0300, Tony Lindgren wrote:
> > > > On Thu, Aug 29, 2024 at 02:27:56PM +0800, Yan Zhao wrote:
> > > > > On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> > > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > 
> > > > > ...
> > > > > > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > > > > > +{
> > > > ...
> > > > 
> > > > > > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > > > > > +	kvm_tdx->attributes = td_params->attributes;
> > > > > > +	kvm_tdx->xfam = td_params->xfam;
> > > > > > +
> > > > > > +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> > > > > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> > > > > > +	else
> > > > > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> > > > > > +
> > > > > Could we introduce a initialized field in struct kvm_tdx and set it true
> > > > > here? e.g
> > > > > +       kvm_tdx->initialized = true;
> > > > > 
> > > > > Then reject vCPU creation in tdx_vcpu_create() before KVM_TDX_INIT_VM is
> > > > > executed successfully? e.g.
> > > > > 
> > > > > @@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > > > >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > > > >         struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > > 
> > > > > +       if (!kvm_tdx->initialized)
> > > > > +               return -EIO;
> > > > > +
> > > > >         /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > > > >         if (!vcpu->arch.apic)
> > > > >                 return -EINVAL;
> > > > > 
> > > > > Allowing vCPU creation only after TD is initialized can prevent unexpected
> > > > > userspace access to uninitialized TD primitives.
> > > > 
> > > > Makes sense to check for initialized TD before allowing other calls. Maybe
> > > > the check is needed in other places too in additoin to the tdx_vcpu_create().
> > > Do you mean in places checking is_hkid_assigned()?
> > 
> > Sounds like the state needs to be checked in multiple places to handle
> > out-of-order ioctls to that's not enough.
> > 
> > > > How about just a function to check for one or more of the already existing
> > > > initialized struct kvm_tdx values?
> > > Instead of checking multiple individual fields in kvm_tdx or vcpu_tdx, could we
> > > introduce a single state field in the two strutures and utilize a state machine
> > > for check (as Chao Gao pointed out at [1]) ?
> > 
> > OK
> > 
> > > e.g.
> > > Now TD can have 5 states: (1)created, (2)initialized, (3)finalized,
> > >                           (4)destroyed, (5)freed.
> > > Each vCPU has 3 states: (1) created, (2) initialized, (3)freed
> > > 
> > > All the states are updated by a user operation (e.g. KVM_TDX_INIT_VM,
> > > KVM_TDX_FINALIZE_VM, KVM_TDX_INIT_VCPU) or a x86 op (e.g. vm_init, vm_destroy,
> > > vm_free, vcpu_create, vcpu_free).
> > > 
> > > 
> > >      TD                                   vCPU
> > > (1) created(set in op vm_init)
> > > (2) initialized
> > > (indicate tdr_pa != 0 && HKID assigned)
> > > 
> > >                                           (1) created (set in op vcpu_create)
> > > 
> > >                                           (2) initialized
> > > 
> > >                                     (can call INIT_MEM_REGION, GET_CPUID here)
> > > 
> > > 
> > > (3) finalized
> > > 
> > >                                  (tdx_vcpu_run(), tdx_handle_exit() can be here)
> > > 
> > > 
> > > (4) destroyed (indicate HKID released)
> > > 
> > >                                          (3) freed
> > > 
> > > (5) freed
> > 
> > So an enum for the TD state, and also for the vCPU state?
> 
> A state for TD, and a state for each vCPU.
> Each vCPU needs to check TD state and vCPU state of itself for vCPU state
> transition.
> 
> Does it make sense?

That sounds good to me :)

Regards,

Tony
 
> > > [1] https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/#t

