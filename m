Return-Path: <kvm+bounces-21737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 581BE93337B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 23:19:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E76A2815F9
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 21:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7870012B17C;
	Tue, 16 Jul 2024 21:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LXZ1yX4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E86A1DDCE;
	Tue, 16 Jul 2024 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721164787; cv=none; b=nct1i1TLzyaAGKk3X26L94ssU+wVmuNOHd1ZZb1566V6iKINltplenPvMOFlizRXOmXnSkai2R0kl3Trrb/tNvgaiDgF5lLUX6MJhMeBAcjoZS6ccR3WsMEgLVPWEK+JSX8lA7hx1CT3UbCXnIRPZCM47xPQQFOxqKWiCA/kkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721164787; c=relaxed/simple;
	bh=0f7uNePzLK19jWJ41LDpLfJS1Coy9UpYhSDOa2nM1dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OU+wjTP4sS2hmHB4Q9fQXABJxyLHVscHlqyIA7zdNqoT+M1dcgyvtcrTvCOaV2U/hpW+jIE9lYyVlGMvCzMFmSgl1F59/TWAy7CsfeCucTCFSdZv24Lx/CrbQzvac+lSV+l5fRidoM21Gb8AlTeIJCS2WSRQi2D70FF1Et1UkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LXZ1yX4Z; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721164786; x=1752700786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0f7uNePzLK19jWJ41LDpLfJS1Coy9UpYhSDOa2nM1dU=;
  b=LXZ1yX4Z2Iqn/tl6M9RwKIfDKPQZ7tCxZg9PCcZV5xiN8cY58mtJn2Zp
   MzcNcufjXgmiOy+rHm1jLhZTkNt7K2Mk9w1pUSnEeayYYn7AyCs/Nhpxr
   EWYbqJbjWHiA7nKBAtcqbPO8lwgUEJgdjtib6KB8DvTFBzetf6wKPhxw1
   g21ZgHofvw0MvmKI9w+yYii/U5mH4bBSqwlWydNWoSKDd33OMv7Lj7Oy4
   PxsvIt7+qHEkj4cjj+zFnbElv4lxVuru2Fpim1JInXvSrwg64dMDR2Owt
   XyEsDk/dN7LzEEdS7cpXu6ClW9yMNA1weEs3CHyeAF7rsYVLeHtqQzZIS
   Q==;
X-CSE-ConnectionGUID: 9bkih6S2R2eVOJNWPQxDbQ==
X-CSE-MsgGUID: +sTCqPA1R4qVlNvfMTPB8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18774390"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18774390"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 14:19:45 -0700
X-CSE-ConnectionGUID: 1OKmhQDCSeG7sm8EIrYzWQ==
X-CSE-MsgGUID: gLi/OvjpQr+T9P21kaAxoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50227513"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 14:19:45 -0700
Date: Tue, 16 Jul 2024 14:19:44 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v19 109/130] KVM: TDX: Handle TDX PV port io hypercall
Message-ID: <20240716211944.GC1900928@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4f4aaf292008608a8717e9553c3315ee02f66b20.1708933498.git.isaku.yamahata@intel.com>
 <00bb2871-8020-4d60-bdb6-d2cebe79d543@linux.intel.com>
 <20240417201058.GL3039520@ls.amr.corp.intel.com>
 <e7233d96-2ab1-4684-8ce4-0189a78339ca@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7233d96-2ab1-4684-8ce4-0189a78339ca@linux.intel.com>

On Tue, Jul 09, 2024 at 02:26:35PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 4/18/2024 4:10 AM, Isaku Yamahata wrote:
> > On Wed, Apr 17, 2024 at 08:51:39PM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > 
> > > On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > Wire up TDX PV port IO hypercall to the KVM backend function.
> > > > 
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > ---
> > > > v18:
> > > > - Fix out case to set R10 and R11 correctly when user space handled port
> > > >     out.
> > > > ---
> > > >    arch/x86/kvm/vmx/tdx.c | 67 ++++++++++++++++++++++++++++++++++++++++++
> > > >    1 file changed, 67 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index a2caf2ae838c..55fc6cc6c816 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -1152,6 +1152,71 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
> > > >    	return kvm_emulate_halt_noskip(vcpu);
> > > >    }
> > > > +static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> > > > +	tdvmcall_set_return_val(vcpu, 0);
> > > > +	return 1;
> > > > +}
> > > > +
> > > > +static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> > > > +	unsigned long val = 0;
> > > > +	int ret;
> > > > +
> > > > +	WARN_ON_ONCE(vcpu->arch.pio.count != 1);
> > > > +
> > > > +	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
> > > > +					 vcpu->arch.pio.port, &val, 1);
> > > > +	WARN_ON_ONCE(!ret);
> > > > +
> > > > +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> > > > +	tdvmcall_set_return_val(vcpu, val);
> > > > +
> > > > +	return 1;
> > > > +}
> > > > +
> > > > +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> > > > +	unsigned long val = 0;
> > > > +	unsigned int port;
> > > > +	int size, ret;
> > > > +	bool write;
> > > > +
> > > > +	++vcpu->stat.io_exits;
> > > > +
> > > > +	size = tdvmcall_a0_read(vcpu);
> > > > +	write = tdvmcall_a1_read(vcpu);
> > > > +	port = tdvmcall_a2_read(vcpu);
> > > > +
> > > > +	if (size != 1 && size != 2 && size != 4) {
> > > > +		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
> > > > +		return 1;
> > > > +	}
> > > > +
> > > > +	if (write) {
> > > > +		val = tdvmcall_a3_read(vcpu);
> > > > +		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
> > > > +
> > > > +		/* No need for a complete_userspace_io callback. */
> > > I am confused about the comment.
> > > 
> > > The code below sets the complete_userspace_io callback for write case,
> > > i.e. tdx_complete_pio_out().
> > You're correct. This comment is stale and should be removed it.
> Also, since the tdx_complete_pio_out() is installed as complete_userspace_io
> callback for write, it's more reasonable to move the reset of pio.count into
> tdx_complete_pio_out().
> How about the following fixup:

It makes sense. It matches better with other complete callbacks
for tdx_complete_pio_out() to clear pio.count to 0.


> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9ead46cb75ab..b43bb8ccddb9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1115,6 +1115,7 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
> 
>  static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
>  {
> +       vcpu->arch.pio.count = 0;
>         tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
>         tdvmcall_set_return_val(vcpu, 0);
>         return 1;
> @@ -1159,15 +1160,13 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>         if (write) {
>                 val = tdvmcall_a3_read(vcpu);
>                 ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val,
> 1);
> -
> -               /* No need for a complete_userspace_io callback. */
> -               vcpu->arch.pio.count = 0;
> -       } else
> +       } else {
>                 ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
> +       }
> 
> -       if (ret)
> +       if (ret) {
>                 tdvmcall_set_return_val(vcpu, val);
> -       else {
> +       } else {
>                 if (write)
>                         vcpu->arch.complete_userspace_io =
> tdx_complete_pio_out;
>                 else
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

