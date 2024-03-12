Return-Path: <kvm+bounces-11627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3965878DE6
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 05:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B4832825CC
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 04:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0C3C8E0;
	Tue, 12 Mar 2024 04:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bohHnNVt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFDEBE49;
	Tue, 12 Mar 2024 04:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710218580; cv=none; b=p33PIcrcgpyMfOUnCcogwhu9hksE0EHen8n99uaGTWw/ltH1rpXpOr15qDDDa9xZtGnXop5/WgBbEEkYoz/7paVZ51Ps08BJQ2484Ir3W5XXUbpyWJptgJJkOSTtxYn3TY430YlxzqnhYYBbAvxSEeZaLJcccm+AR+mN4knY1DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710218580; c=relaxed/simple;
	bh=NhkGM4RbuqoMHpdBSX9DN68Zuh8flIi501dIobET/rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXh6VlvoH7eq719nBKs0U6/ACK+JmOqz2GY5PrvZSJ5KJqy/uxiHVcwcbj1Liugwakb2YcVw2jNrq85efCJ393oiT7xPjXnwpat/hxfUor1sOcFIr1GeMzoA6Ma+ABNNGz0yXeBho4I4wzd+amuSlU3tFZ0CVk98Ixw1GvgbAVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bohHnNVt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710218579; x=1741754579;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NhkGM4RbuqoMHpdBSX9DN68Zuh8flIi501dIobET/rE=;
  b=bohHnNVtgGujJe7M8KW1oJMJb4YIBEa+FMcbJspndN19/DfX6sFolAlU
   yCRWKFGwJZ3TK5dUYASH7zVZOAfv2ifzQvcJd+B2YE2fl3LC1bTBNGcGW
   fRJxoY51P/8MmyzCXn9poAeXHUHEvizBq1VnF3rG2cCJgpWpVKKQCBDMi
   a7vHC+gyMfUEkgU0GamIB7ehRCOMa8B8DRbmC/d/JorvQWBhuk+AuB1On
   +Epm1xh//VIIzDmXsmIR+3yutSL7pZFzFgDZRiUnO04KPNnoDapfp02gs
   MQtxwaHJx9NooZ8W6u2bAPXu/B5f/qJ8BC5foteOTR+WeEb0XyPvL0mVR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="16055071"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16055071"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 21:42:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="48852063"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 21:42:58 -0700
Date: Mon, 11 Mar 2024 21:42:57 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yin Fengwei <fengwei.yin@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20240312044257.GH935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
 <aa5359e5-46a3-48d0-b4af-3b812b4c93ae@intel.com>
 <20240312021524.GG935089@ls.amr.corp.intel.com>
 <c7be9930-26e7-454c-87f6-c8cdf2fce481@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c7be9930-26e7-454c-87f6-c8cdf2fce481@intel.com>

On Tue, Mar 12, 2024 at 10:21:28AM +0800,
Yin Fengwei <fengwei.yin@intel.com> wrote:

> 
> 
> On 3/12/24 10:15, Isaku Yamahata wrote:
> >>> -
> >>> -	__vmx_exit();
> >>> -}
> >>> -module_exit(vmx_exit);
> >>> -
> >>> -static int __init vmx_init(void)
> >>> +int __init vmx_init(void)
> >>>   {
> >>>   	int r, cpu;
> >>> -	if (!kvm_is_vmx_supported())
> >>> -		return -EOPNOTSUPP;
> >>> -
> >>> -	/*
> >>> -	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> >>> -	 * to unwind if a later step fails.
> >>> -	 */
> >>> -	hv_init_evmcs();
> >>> -
> >>> -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> >>> -	for_each_possible_cpu(cpu)
> >>> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> >>> -
> >>> -	r = kvm_x86_vendor_init(&vt_init_ops);
> >>> -	if (r)
> >>> -		return r;
> >>> -
> >>>   	/*
> >>>   	 * Must be called after common x86 init so enable_ept is properly set
> >>>   	 * up. Hand the parameter mitigation value in which was stored in
> >> I am wondering whether the first sentence of above comment should be
> >> moved to vt_init()? So vt_init() has whole information about the init
> >> sequence.
> > If we do so, we should move the call of "vmx_setup_l1d_flush() to vt_init().
> > I hesitated to remove static of vmx_setup_l1d_flush().
> I meant this one:
>  "Must be called after common x86 init so enable_ept is properly set up"
> 
> Not necessary to move vmx_setup_l1d_flush().

Ah, you mean "only" first sentence. Ok. I'll move it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

