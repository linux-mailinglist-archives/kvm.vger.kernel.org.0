Return-Path: <kvm+bounces-18106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 697AD8CE1D7
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 09:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2616F2825DB
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 07:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EDC83CDB;
	Fri, 24 May 2024 07:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/NtIItA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111D86FCC;
	Fri, 24 May 2024 07:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716537321; cv=none; b=BhrUNPsVYnN4QbCetY+rvwXw/l1vIFxXzCtYZWsHPn1c21dHYa4FAp3v3hedehtUx0kT+hq/3dZ0wCSMxKh8BX/s8laWArlWNUABUO2DLpbUqK/V1FWbPypV/eKh4aUce39l+U12gD62YjG2Opt72dSRtuX3MnFN78M+a5XgTJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716537321; c=relaxed/simple;
	bh=u9XYM378s13S95kk/UOjXzX8CF8ut9uPIj6c0utzj7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBT9qsCLX58+uAOhXw4DiZLlkvQM/xj718GUhrp8SI0JxfQbZWgo/a7aKL87S2vWHKlnQJePlxN+wH9I2VPa+4declgsjwwc6AV6tBAZWmIwytZHNsgT8MKmSuD4IMPNfJtEWCC4o86dRBfHi0z03dTbbnHVahu/IEPaM6cqQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/NtIItA; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716537320; x=1748073320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=u9XYM378s13S95kk/UOjXzX8CF8ut9uPIj6c0utzj7M=;
  b=M/NtIItApmqbFmorQb4Sa3wHOutafcUZJQ99bKuIdmNkS1R3TpEdFmfF
   vZncJGnWSyMpf2fJvPneeLkYlwLUlucAtg8yPZ1JY/mlcuEX5czochy8E
   0wrL0CpWen1mWhFq14tazWWBI837LmAT62M3LN+VWqq6xj3KtrRnV823f
   64N+ZFhcy7n7xTuGUf2AXkYSCc5pMMuTg5ip5GRQJQXu0fu65fSvz1ece
   jl7AMbPP+6fQCQpnZrPvp30A3PQ1TmZq3nwksLjK9RH5d465zVCQwJz/4
   3o1wjV9j7YM+uvOXwIJcHI/NEfk3yr+unMYxn7UKBCJ/v4KI0q4cSvnyP
   Q==;
X-CSE-ConnectionGUID: //qraz2sRlO/5DQmiVWwaQ==
X-CSE-MsgGUID: IajMaoAvTyGeTBJduvc31Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="13081361"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="13081361"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 00:55:20 -0700
X-CSE-ConnectionGUID: 0RGi0TV4Rg6Gn/rfk2sdgA==
X-CSE-MsgGUID: QFXpfw8wT7y5Pa8iG2+1qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="33864767"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 00:55:19 -0700
Date: Fri, 24 May 2024 00:55:19 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240524075519.GF212599@ls.amr.corp.intel.com>
References: <20240517191630.GC412700@ls.amr.corp.intel.com>
 <20240520233227.GA29916@ls.amr.corp.intel.com>
 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
 <20240521161520.GB212599@ls.amr.corp.intel.com>
 <20240522223413.GC212599@ls.amr.corp.intel.com>
 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
 <20240522234754.GD212599@ls.amr.corp.intel.com>
 <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
 <20240523000100.GE212599@ls.amr.corp.intel.com>
 <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>

On Thu, May 23, 2024 at 06:27:49PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-05-22 at 17:01 -0700, Isaku Yamahata wrote:
> > Ok, Let's include the patch.
> 
> We were discussing offline, that actually the existing behavior of
> kvm_mmu_max_gfn() can be improved for normal VMs. It would be more proper to
> trigger it off of the GFN range supported by EPT level, than the host MAXPA. 
> 
> Today I was thinking, to fix this would need somthing like an x86_ops.max_gfn(),
> so it could get at VMX stuff (usage of 4/5 level EPT). If that exists we might
> as well just call it directly in kvm_mmu_max_gfn().
> 
> Then for TDX we could just provide a TDX implementation, rather than stash the
> GFN on the kvm struct? Instead it could use gpaw stashed on struct kvm_tdx. The
> op would still need to be take a struct kvm.
> 
> What do you think of that alternative?

I don't see benefit of x86_ops.max_gfn() compared to kvm->arch.max_gfn.
But I don't have strong preference. Either way will work.

The max_gfn for the guest is rather static once the guest is created and
initialized.  Also the existing codes that use max_gfn expect that the value
doesn't change.  So we can use x86_ops.vm_init() to determine the value for VMX
and TDX.  If we introduced x86_ops.max_gfn(), the implementation will be simply
return kvm_vmx->max_gfn or return kvm_tdx->max_gfn. (We would have similar for
SVM and SEV.)  So I don't see benefit of x86_ops.max_gfn() than
kvm->arch.max_gfn.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

