Return-Path: <kvm+bounces-13493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D188978D1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 21:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 907C8B295FE
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5EA15445F;
	Wed,  3 Apr 2024 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kg/Pc4Yq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C3F839E1;
	Wed,  3 Apr 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712170266; cv=none; b=jlrD9jd3pSGw7rzFa5EGnnRL1uQYXv5p5Q8Cs3F+3ZwcNIRh4g7HtGY5mZ+l/F2dv1OO85DkJzF/PLH2mWfmEoIBI+rnywTWTP5cMLjkD+iqqAQeKFSHwrFKOl4HuB+RCCjodfdesnxKPWxK61bRKEGxOuL4JJ2mV1JrdlM1JVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712170266; c=relaxed/simple;
	bh=lSO5a/LR2abT5IbXVMvLNuvxnTKyJrqDXsHF2+SQ84c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOPnOApc+tSSq5vwFpn383JYsfLlnUtqaiAoUsf2KMDzfddZ+daaXUgrxa2m9O8hfv3LD28GzOx6kp8A3GpIYyVnWIgT6mb58ZO92AW+/wiegCN4TBlwlB8Hf1Dp1atMHLBOkAwJcbtUrMMzWvVkveHqM05w/ELuGpd6yBfbxec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kg/Pc4Yq; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712170265; x=1743706265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lSO5a/LR2abT5IbXVMvLNuvxnTKyJrqDXsHF2+SQ84c=;
  b=Kg/Pc4YqmTqkPvPpBJ9HmgPGeTjOSRvshMnFRLBo7+L1AohuBpo5673f
   PXoC+dA4I2+8+1tOYg74oAMEW2SPuDBZg91dttMLH785wTAAy8/qkxmOx
   ln11dX8QWoLtKbGhuUr+XvO9WELc9kS7q2XjAOMtLAbZCIo7TU2Ytbb4B
   bD9h1iUoWV5GEUm72wmozgxetYsdOHul5laGv49e6HX4zGChNkKWnQk+3
   dJ+26TvENI2U/KWSLFiYv4eAqWFkKohWVT6boH946eOlONPV1BjPSBlMH
   D0eS5CAqK83Qv4sqDl7frg1vtDtCtL39+okzBc35a57FfOskk6x/a47ox
   g==;
X-CSE-ConnectionGUID: UZAiFbdXTfqZqQtOtLm9Ug==
X-CSE-MsgGUID: ncrA96eMREOKF+CJZod54w==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7538817"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7538817"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:51:04 -0700
X-CSE-ConnectionGUID: anH6KJ8vRluvEQv7Pt4gmA==
X-CSE-MsgGUID: 1UMUQKVqQGGMzXn/qWPyXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="23290440"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:51:04 -0700
Date: Wed, 3 Apr 2024 11:51:03 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 102/130] KVM: TDX: handle EXCEPTION_NMI and
 EXTERNAL_INTERRUPT
Message-ID: <20240403185103.GK2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3ac413f1d4adbac7db88a2cade97ded3b076c540.1708933498.git.isaku.yamahata@intel.com>
 <ZgpuqJW365ZfuJao@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgpuqJW365ZfuJao@chao-email>

On Mon, Apr 01, 2024 at 04:22:00PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:44AM -0800, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Because guest TD state is protected, exceptions in guest TDs can't be
> >intercepted.  TDX VMM doesn't need to handle exceptions.
> >tdx_handle_exit_irqoff() handles NMI and machine check.  Ignore NMI and
> 
> tdx_handle_exit_irqoff() doesn't handle NMIs.

Will it to tdx_handle_exception().


> >machine check and continue guest TD execution.
> >
> >For external interrupt, increment stats same to the VMX case.
> >
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> >---
> > arch/x86/kvm/vmx/tdx.c | 23 +++++++++++++++++++++++
> > 1 file changed, 23 insertions(+)
> >
> >diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >index 0db80fa020d2..bdd74682b474 100644
> >--- a/arch/x86/kvm/vmx/tdx.c
> >+++ b/arch/x86/kvm/vmx/tdx.c
> >@@ -918,6 +918,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
> > }
> > 
> >+static int tdx_handle_exception(struct kvm_vcpu *vcpu)
> >+{
> >+	u32 intr_info = tdexit_intr_info(vcpu);
> >+
> >+	if (is_nmi(intr_info) || is_machine_check(intr_info))
> >+		return 1;
> 
> Add a comment in code as well.

Sure.


> >+
> >+	kvm_pr_unimpl("unexpected exception 0x%x(exit_reason 0x%llx qual 0x%lx)\n",
> >+		intr_info,
> >+		to_tdx(vcpu)->exit_reason.full, tdexit_exit_qual(vcpu));
> >+	return -EFAULT;
> 
> -EFAULT looks incorrect.

As this is unexpected exception, we should exit to to the user-space with
KVM_EXIT_EXCEPTION. Then QEMU will abort with message.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

