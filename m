Return-Path: <kvm+bounces-15039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA278A8FE1
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE1D32826AE
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D1B6FCB;
	Thu, 18 Apr 2024 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0+ZJ2xl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D6918E;
	Thu, 18 Apr 2024 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713398922; cv=none; b=u0E0eNXNEfjHBcc02aejwisbT4QqpZf5mzssa/DEjtx4v9/UP4wPT8pFSLmOo1oBV0R4fWHqgS1rMhSmbvmLNftVMO/dA0jAvGUvDLw/EFJx59Pism3GR4pTcQH3gpcxB9vWDXpnfP5QR92E4J9/5eUa83rpOErVtnTpezw8ZbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713398922; c=relaxed/simple;
	bh=y9DTdEaOe4e/Cn2rZQXetzw7u6FLoLfbMCiWjJ/aCgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOcaGctkplcdWX52B2gkr+GcfdFxPG8ffexzBQNisS0HFSNAITOpTV2X2hHPlQ6Vtc1xGXgdS0T12Dms764kGKZmWqucK01GVlAvZ7mNz0s/OpLfe/vVy0YXhTjDiqUb7992q8I90nzsWJSy609cvPztENiJJwocdsaGmSK6HWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0+ZJ2xl; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713398921; x=1744934921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=y9DTdEaOe4e/Cn2rZQXetzw7u6FLoLfbMCiWjJ/aCgM=;
  b=X0+ZJ2xlNhkX5nqwNplaPl4hLNBlXW7xa6/yAVcKmDfHsMEtDBQF6su2
   MKtWvve4HkF+CAIy9QhrCLoFZF3K2WBHG4qT4EM0IO/pro3cb/E0bYRzM
   AKOVAoLj/PYwwUnnBe3B4X9Hg5vDBFD78KaJGa/bwDNOXVw2+Ukq7G+V+
   FBmvwgAlJ4We/pt77ICE2vbAnLi5C09pCtrWuUT7kbm0liuWmIdJqJpHF
   aqPNEoLIwCct/GwOSrlgKYgVnOr/cjnwGL2lDV53yxq5p25ub6QKQjJaI
   HVUNQ8Ck5KoXCAPKZeafxHMhCxoOIj1M9vXem07xEyqzbG9m8f7qaZcSi
   Q==;
X-CSE-ConnectionGUID: jHZAey7gQaGc9oWjRgjodg==
X-CSE-MsgGUID: hiX3B66GToKKSpVWGKd8ag==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9088788"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="9088788"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:08:40 -0700
X-CSE-ConnectionGUID: qGEh2yzYToeKrMxllKLFcg==
X-CSE-MsgGUID: JdC7fVztQFq6ivAEIjfAcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="23394521"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:08:41 -0700
Date: Wed, 17 Apr 2024 17:08:38 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 102/130] KVM: TDX: handle EXCEPTION_NMI and
 EXTERNAL_INTERRUPT
Message-ID: <20240418000838.GA3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3ac413f1d4adbac7db88a2cade97ded3b076c540.1708933498.git.isaku.yamahata@intel.com>
 <ZgpuqJW365ZfuJao@chao-email>
 <20240403185103.GK2444378@ls.amr.corp.intel.com>
 <ac0e50a6-6da4-4e07-8422-0e9f477c3fb3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac0e50a6-6da4-4e07-8422-0e9f477c3fb3@linux.intel.com>

On Wed, Apr 17, 2024 at 11:05:05AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 4/4/2024 2:51 AM, Isaku Yamahata wrote:
> > On Mon, Apr 01, 2024 at 04:22:00PM +0800,
> > Chao Gao <chao.gao@intel.com> wrote:
> > 
> > > On Mon, Feb 26, 2024 at 12:26:44AM -0800, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > Because guest TD state is protected, exceptions in guest TDs can't be
> > > > intercepted.  TDX VMM doesn't need to handle exceptions.
> > > > tdx_handle_exit_irqoff() handles NMI and machine check.  Ignore NMI and
> > > tdx_handle_exit_irqoff() doesn't handle NMIs.
> > Will it to tdx_handle_exception().
> 
> I don't get  why tdx_handle_exception()?
> 
> NMI is handled in tdx_vcpu_enter_exit() prior to leaving the safety of
> noinstr, according to patch 098.
> https://lore.kernel.org/kvm/88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com/
> 
> @@ -837,6 +857,12 @@ static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx
> *tdx)
>      WARN_ON_ONCE(!kvm_rebooting &&
>               (tdx->exit_reason.full & TDX_SW_ERROR) == TDX_SW_ERROR);
> 
> +    if ((u16)tdx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
> +        is_nmi(tdexit_intr_info(vcpu))) {
> +        kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> +        vmx_do_nmi_irqoff();
> +        kvm_after_interrupt(vcpu);
> +    }
>      guest_state_exit_irqoff();
>  }

You're correct. tdx_vcpu_enter_exit() handles EXIT_REASON_EXCEPTION_NMI for NMI,
and tdx_handle_exeption() ignores NMI case.

The commit message should be updated with tdx_vcpu_enter_exit().


> > > > machine check and continue guest TD execution.
> > > > 
> > > > For external interrupt, increment stats same to the VMX case.
> > > > 
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > ---
> > > > arch/x86/kvm/vmx/tdx.c | 23 +++++++++++++++++++++++
> > > > 1 file changed, 23 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 0db80fa020d2..bdd74682b474 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -918,6 +918,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > > > 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
> > > > }
> > > > 
> > > > +static int tdx_handle_exception(struct kvm_vcpu *vcpu)
> 
> Should this function be named as tdx_handle_exception_nmi() since it's
> checking nmi as well?

Ok, tdx_handle_exception_nmi() is more consistent.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

