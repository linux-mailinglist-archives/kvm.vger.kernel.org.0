Return-Path: <kvm+bounces-14059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C24B89E7A1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 03:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B173F282E6A
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B821388;
	Wed, 10 Apr 2024 01:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CN9a8a3Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4184138D;
	Wed, 10 Apr 2024 01:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711563; cv=none; b=V18pdlnGSHxdfh9AueNX66S/bZGDYfLFnnhiSeUavTcJAAIN5kpPy0zOC7qMxa+yCA0/cDQenr5Awuq6vF5ofsg36A4cdYhTOQ5gvmMsTJTwdP03c3dwP+vQonooQC/NjWeDc5qluAVcMuQc5LIZ0htymarFmufpBMNL8x/0BJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711563; c=relaxed/simple;
	bh=r36zZBtPUpWjpojDacVGVLWS1iX2gN7CxDWZCCEiJ2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1gfxRe50fIsFK9YzkOmUI+hVXXcAh93k55sDtl3v2s7NL06VhOEM1wNxdmYP0RgE9e2k0bmikdij15ytQZJNvNfKBg537EZCdJ7Ye1GDYZM+FvzpP+Bok0DJrI+vJ6zdvqfS91tI88bPiB6Q6n9PCd6jXi+9P6eeHUDfHr1pA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CN9a8a3Z; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712711562; x=1744247562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=r36zZBtPUpWjpojDacVGVLWS1iX2gN7CxDWZCCEiJ2M=;
  b=CN9a8a3Zu9WN5e91XeNwT0U94Gx8auJtPp2QyUtWqUHGf9jGRrOvqj2V
   o0ZfKa6u2Tvuy87hFCHPylTaxVpSXZPeTuwLks69NORn8vxY2PZ0oPSOQ
   VKLhyZ4me6i9N7WZRb7QQhvqTf889cw8/OFIikdxJ2IxVOAXeGBh5hQil
   08OEt9ZOjUa4n12zrlGpGyECTm5YgRvOaZx3MAMYWpWSl05YSd3w/ZtDV
   Ox3kw7uV7YWiKclWfYAJVZIBRJ8t60+hpKolg+XgB5td3UWNm3mean7J5
   XjFUg5KXJLFBOB92aZyqwqpcFcn39iugNde46KhKwmG8F6LRsHYgHuw7S
   A==;
X-CSE-ConnectionGUID: +4D3n4BvQ7uavYD2841DNg==
X-CSE-MsgGUID: SLz2k14sSY+DLVavKtQllQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="11844889"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="11844889"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 18:12:41 -0700
X-CSE-ConnectionGUID: jvYkd817RRW8DHYUKZKDeg==
X-CSE-MsgGUID: WdK3P8T6Q8eYgEr+w+2W/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25078755"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 18:12:41 -0700
Date: Tue, 9 Apr 2024 18:12:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	"davidskidmore@google.com" <davidskidmore@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"srutherford@google.com" <srutherford@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Wei Wang <wei.w.wang@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Message-ID: <20240410011240.GA3039520@ls.amr.corp.intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZhQ8UCf40UeGyfE_@google.com>

On Mon, Apr 08, 2024 at 06:51:40PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Apr 08, 2024, Edgecombe, Rick P wrote:
> > On Mon, 2024-04-08 at 09:20 -0700, Sean Christopherson wrote:
> > > > Another option is that, KVM doesn't allow userspace to configure
> > > > CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
> > > > kvm_tdx_init_vm for userspace to configure directly.
> > > > 
> > > > What do you prefer?
> > > 
> > > Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
> > > select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
> > > host.MAXPHYADDR.
> > 
> > So then GPAW would be coded to basically best fit the supported guest.MAXPHYADDR within KVM. QEMU
> > could look at the supported guest.MAXPHYADDR and use matching logic to determine GPAW.
> 
> Off topic, any chance I can bribe/convince you to wrap your email replies closer
> to 80 chars, not 100?  Yeah, checkpath no longer complains when code exceeds 80
> chars, but my brain is so well trained for 80 that it actually slows me down a
> bit when reading mails that are wrapped at 100 chars.
> 
> > Or are you suggesting that KVM should look at the value of CPUID(0X8000_0008).eax[23:16] passed from
> > userspace?
> 
> This.  Note, my pseudo-patch incorrectly looked at bits 15:8, that was just me
> trying to go off memory.
> 
> > I'm not following the code examples involving struct kvm_vcpu. Since TDX
> > configures these at a VM level, there isn't a vcpu.
> 
> Ah, I take it GPAW is a VM-scope knob?  I forget where we ended up with the ordering
> of TDX commands vs. creating vCPUs.  Does KVM allow creating vCPU structures in
> advance of the TDX INIT call?  If so, the least awful solution might be to use
> vCPU0's CPUID.

The current order is, KVM vm creation (KVM_CREATE_VM),
KVM vcpu creation(KVM_CREATE_VCPU), TDX VM initialization (KVM_TDX_INIT_VM).
and TDX VCPU initialization(KVM_TDX_INIT_VCPU).
We can call KVM_SET_CPUID2 before KVM_TDX_INIT_VM.  We can remove cpuid part
from struct kvm_tdx_init_vm by vcpu0 cpuid.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

