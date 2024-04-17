Return-Path: <kvm+bounces-15008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1AD38A8CCA
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F4712814D5
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56E2383BF;
	Wed, 17 Apr 2024 20:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eimtY/Yj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4802208D6;
	Wed, 17 Apr 2024 20:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713384674; cv=none; b=GzROvuIrV6q48YMdbIhGlXX7k+17WKMg6ODjsROmnxlsYbNX9nPqhGj8SarieiHoQBuff8S50nC8kF8z31eKXLMwkdlUeh2PBBLbhy53/8WD+PDOeEp87rU4MtOYjAAC95w1asEAzlA8ws3iiLbY5wuEPns27/j5+N8g/awsiFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713384674; c=relaxed/simple;
	bh=WOJjjXPmt5T73gBoMsSOip3W1PBw8vG3OglSmkgGACQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X52qONXKGYtSKW6aIKM78Lfy6d9uXcl9J5LzuPujGEMJ8HIuC/+DajyWZ6p7wMtCD+MZsU9NBrSLjgxaJLBfwOH7kPMy1tYEKqLsr2HE2pP36gYCc4E7yyP+85FtJI/U7Q3vHdxsD+qeq8ekDJQMPENH+CbhO0Y3ApyXXlucryU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eimtY/Yj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713384673; x=1744920673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WOJjjXPmt5T73gBoMsSOip3W1PBw8vG3OglSmkgGACQ=;
  b=eimtY/YjR9PtC7cnPrO7XmcR2n805QQJFDB8phGYmAN0PolshS20jk1L
   ZtkQ81ihYIADNHMC5Mbmwq8vkn3Rw469A5mqOTVItLDJbNEHiaYuQrDxI
   yFT3yT4SPvafrh+wT5Vlbk/kLaKYU+bSYq4o+3DBHkZy2lg9l+2FHNSkP
   WYcOujgpmmeygnV719Ju+YX98JnCNZZU3AANKpyjbi8Huqmjfdi/mBDbA
   5RoPnDfu08R8QICgt9h3UaSBO7hWP1btGiiMlwhNrwej6M2GrEPBNnVbj
   RG7dKq211yKzf/QfA0vZuS9Ym297+Sx6h2C8D4UqYBAU04KJ5KWmw4BaR
   Q==;
X-CSE-ConnectionGUID: QQz/d5juT4G8XOlvihFcIQ==
X-CSE-MsgGUID: 1M1AL+4dQpqPAtXpF99YfQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19504694"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="19504694"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 13:10:59 -0700
X-CSE-ConnectionGUID: BwxQWrhIRgKaGHE0XVmIEA==
X-CSE-MsgGUID: IpseWg/9TG6DSsxubstNxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="23336391"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 13:10:58 -0700
Date: Wed, 17 Apr 2024 13:10:58 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 109/130] KVM: TDX: Handle TDX PV port io hypercall
Message-ID: <20240417201058.GL3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4f4aaf292008608a8717e9553c3315ee02f66b20.1708933498.git.isaku.yamahata@intel.com>
 <00bb2871-8020-4d60-bdb6-d2cebe79d543@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00bb2871-8020-4d60-bdb6-d2cebe79d543@linux.intel.com>

On Wed, Apr 17, 2024 at 08:51:39PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Wire up TDX PV port IO hypercall to the KVM backend function.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> > v18:
> > - Fix out case to set R10 and R11 correctly when user space handled port
> >    out.
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 67 ++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 67 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index a2caf2ae838c..55fc6cc6c816 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1152,6 +1152,71 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
> >   	return kvm_emulate_halt_noskip(vcpu);
> >   }
> > +static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
> > +{
> > +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> > +	tdvmcall_set_return_val(vcpu, 0);
> > +	return 1;
> > +}
> > +
> > +static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
> > +{
> > +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> > +	unsigned long val = 0;
> > +	int ret;
> > +
> > +	WARN_ON_ONCE(vcpu->arch.pio.count != 1);
> > +
> > +	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
> > +					 vcpu->arch.pio.port, &val, 1);
> > +	WARN_ON_ONCE(!ret);
> > +
> > +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
> > +	tdvmcall_set_return_val(vcpu, val);
> > +
> > +	return 1;
> > +}
> > +
> > +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
> > +{
> > +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> > +	unsigned long val = 0;
> > +	unsigned int port;
> > +	int size, ret;
> > +	bool write;
> > +
> > +	++vcpu->stat.io_exits;
> > +
> > +	size = tdvmcall_a0_read(vcpu);
> > +	write = tdvmcall_a1_read(vcpu);
> > +	port = tdvmcall_a2_read(vcpu);
> > +
> > +	if (size != 1 && size != 2 && size != 4) {
> > +		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
> > +		return 1;
> > +	}
> > +
> > +	if (write) {
> > +		val = tdvmcall_a3_read(vcpu);
> > +		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
> > +
> > +		/* No need for a complete_userspace_io callback. */
> I am confused about the comment.
> 
> The code below sets the complete_userspace_io callback for write case,
> i.e. tdx_complete_pio_out().

You're correct. This comment is stale and should be removed it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

