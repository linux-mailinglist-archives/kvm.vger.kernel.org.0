Return-Path: <kvm+bounces-9967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7976B868045
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44067B28B87
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B85512F59E;
	Mon, 26 Feb 2024 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cny+eNz8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C321E866;
	Mon, 26 Feb 2024 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974083; cv=none; b=Cah14Xo0ogwrNMp2WCdIRknag62BT9PVyCq00Cb4jvCtOIxs+PMN8/4nONQp+sBd9zeR/3NT6LN8pUxyVljYnlD4gx3k5dcuSBxmdo/3fMQ9g9FqoeI1g+jlaeRaBZIzC5+ssuDD2GhLonjzausg+uiHmFRAqc4peWlKcvr8mBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974083; c=relaxed/simple;
	bh=yOFcvLPco3wQISY5eg48pUdY5mUUXeOE0Rt33co90sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tx0eZALfdGIuOjuvP21knOUk38mW2OHdzVLVXBzebntYECIIsjJYRYKyqIgWO1erASCJJV4mZ7Juf/jkSoPdk+GzX/Y4k5KpUswrjg7QrruKiG4btMTEu+NTD1imsmm8cO/Plj1j/xjZTOyGSjraLc7SgAaoxTUvBRXaDMBaMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cny+eNz8; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708974082; x=1740510082;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yOFcvLPco3wQISY5eg48pUdY5mUUXeOE0Rt33co90sU=;
  b=cny+eNz8d/q3mNrwUhQho3yIF/HfClJ62O5fzhGxtYc6h5hziNcq7JOM
   RrY0PjV6KdbUw1Bvi+5kJfA/ZCtwKSK0ZZnhY1Jnm43+S4Q27YmshRHFo
   cgs/D0TxHnVw+mPihHnFaVxWhZYRXJ7cARZU0pZwVNcbYBR/rNRBrqpm5
   LZkDa4nStiUvdA68YyDJC3Ys4cfMQkcc5UnoCuv5qrUOAETcy/unHsEHW
   5/3oesLQPmjdtG2aTalE/VpfSX4la29vIV9cwPHqr8r/TbpzdW0X7Wa8k
   SDwh46TM2Nw4U2DQBAajb/8GIhIUQ/chftdJZh/RSVf/g10y9RCqma6Ta
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3208044"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3208044"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:01:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6793381"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:01:21 -0800
Date: Mon, 26 Feb 2024 11:01:20 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 030/121] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20240226190120.GM177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <9ac6ab3979a477d4a40e0655208248b70bb43ebb.1705965635.git.isaku.yamahata@intel.com>
 <f3321756-95f1-4532-b1de-42b334b684ba@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3321756-95f1-4532-b1de-42b334b684ba@linux.intel.com>

On Thu, Jan 25, 2024 at 03:56:53PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8330f448ab8e..245be29721b4 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
...
> > @@ -951,15 +992,147 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >   	return r;
> >   }
> > +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	unsigned long *tdvpx_pa = NULL;
> > +	unsigned long tdvpr_pa;
> > +	unsigned long va;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	if (is_td_vcpu_created(tdx))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * vcpu_free method frees allocated pages.  Avoid partial setup so
> > +	 * that the method can't handle it.
> > +	 */
> > +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +	if (!va)
> > +		return -ENOMEM;
> > +	tdvpr_pa = __pa(va);
> > +
> > +	tdvpx_pa = kcalloc(tdx_info->nr_tdvpx_pages, sizeof(*tdx->tdvpx_pa),
> > +			   GFP_KERNEL_ACCOUNT);
> > +	if (!tdvpx_pa) {
> > +		ret = -ENOMEM;
> > +		goto free_tdvpr;
> > +	}
> > +	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +		if (!va) {
> > +			ret = -ENOMEM;
> > +			goto free_tdvpx;
> > +		}
> > +		tdvpx_pa[i] = __pa(va);
> > +	}
> > +
> > +	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> > +	if (KVM_BUG_ON(err, vcpu->kvm)) {
> > +		ret = -EIO;
> > +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> > +		goto free_tdvpx;
> > +	}
> > +	tdx->tdvpr_pa = tdvpr_pa;
> > +
> > +	tdx->tdvpx_pa = tdvpx_pa;
> > +	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> > +		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> > +		if (KVM_BUG_ON(err, vcpu->kvm)) {
> > +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> > +			for (; i < tdx_info->nr_tdvpx_pages; i++) {
> > +				free_page((unsigned long)__va(tdvpx_pa[i]));
> > +				tdvpx_pa[i] = 0;
> > +			}
> > +			/* vcpu_free method frees TDVPX and TDR donated to TDX */
> vcpu_free() interface is called by two sites.
> One is the error handling path of kvm_vm_ioctl_create_vcpu() when vcpu
> creation.
> The other is during kvm_destroy_vm().
> 
> What about the error occurs in KVM_TDX_INIT_VCPU?
> Let's assume TDR and some of tdvpx pages are donated to TDX, and the next
> call of tdh_vp_addcx() failed. The comment says "vcpu_free method frees
> TDVPX
> and TDR donated to TDX", but if it happens, it seems that vcpu_free() would
> not be called? Memory leakage?

vcpu_free() is called because we already created vcpu with KVM_VCPU_CREATE
irrelevant of the result of TDX_VCPU_INIT.
tdx_vcpu_free() handles error case of TDX_VCPU_INIT. So no leakage.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

