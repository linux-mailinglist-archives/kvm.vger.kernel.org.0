Return-Path: <kvm+bounces-14212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 757008A06E5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 05:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B5D51F2369D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 03:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A86513BAF7;
	Thu, 11 Apr 2024 03:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEnJu8yd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EE52629C;
	Thu, 11 Apr 2024 03:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712807213; cv=none; b=izDtJL3JgyWfCLfYEEKUByc+xAwH06UIVthORmZ5Rir3R/IZQ8AAcYnmYl8m+DL/XCxo9kwPIPosyNRo26eGbUg0aXcAMSbPgVuKQzn0CcGop+9kZP/FOsu3SnfIz2qO2L3mBahsBOo+vg3OQNNnbYypoxaqAiUKLIxC64Ogfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712807213; c=relaxed/simple;
	bh=aSJMXFqBHj64ZHw3XBaJVQwaBxKdPsTbSdM7BP6QotE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8d8OeCdSC82w2879yH127mVQvcFqAMfz5A34i7opo0J4CA2rUsVcGqE5678UcF6Y3OkV7xD8zyVKeyjs4o3WLGH14zRqTcuKEI4phoLGEyhc94VtH8tke6qPxDR/KWAJfaNZXWYEC7e3tLuRLr/4FKqxzuiBnwjme51vgWIsRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEnJu8yd; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712807212; x=1744343212;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=aSJMXFqBHj64ZHw3XBaJVQwaBxKdPsTbSdM7BP6QotE=;
  b=FEnJu8ydJ+mMJaCvjnMGdvqyvlfHVRWsprkfDzD1L52b3Us+Bbm8chXb
   FMDy6j8lXJ/yY9iENIFJ7fA+jCtW94OGsJ+T2NuzwZDYYQHzMrVBNj2Qh
   7WT/axdFJVQ+c/mkuX0qqL3tk52zw2nZFfFnF24WQhu+nPz/2TzUF3A4A
   TGFP/j2492oiW9d/IHTfkZKSTBx8qnL/HcXSAS5SYNbvpv+xEV0ypxtHg
   wklc4ElFX+pkkuHDrfHrZ0gO8hOmPR7+6nI7S4gbdX8kOyZ9sY4zK/aK9
   yF14fz8TFc4flFcb54USu1dZuTqGEfRjZL+iNvgs5HX6zsvCOA/URDS/5
   Q==;
X-CSE-ConnectionGUID: qpeUC8mwQvWl8rp6QEb37w==
X-CSE-MsgGUID: KjIdjtDdScy5xS4dhmJmYA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="11991351"
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="11991351"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 20:46:52 -0700
X-CSE-ConnectionGUID: FB4jrCZfRN6PfhRviThd3Q==
X-CSE-MsgGUID: X9G7ZkCeQYac311zIvtQTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="20850716"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 20:46:51 -0700
Date: Wed, 10 Apr 2024 20:46:50 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"davidskidmore@google.com" <davidskidmore@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"srutherford@google.com" <srutherford@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Message-ID: <20240411034650.GC3039520@ls.amr.corp.intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com>
 <20240410011240.GA3039520@ls.amr.corp.intel.com>
 <1628a8053e01d84bcc7a480947ca882028dbe5b9.camel@intel.com>
 <20240411010352.GB3039520@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240411010352.GB3039520@ls.amr.corp.intel.com>

On Wed, Apr 10, 2024 at 06:03:52PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> On Wed, Apr 10, 2024 at 02:03:26PM +0000,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
> > On Tue, 2024-04-09 at 18:12 -0700, Isaku Yamahata wrote:
> > > On Mon, Apr 08, 2024 at 06:51:40PM +0000,
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > > On Mon, Apr 08, 2024, Edgecombe, Rick P wrote:
> > > > > On Mon, 2024-04-08 at 09:20 -0700, Sean Christopherson wrote:
> > > > > > > Another option is that, KVM doesn't allow userspace to configure
> > > > > > > CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
> > > > > > > kvm_tdx_init_vm for userspace to configure directly.
> > > > > > > 
> > > > > > > What do you prefer?
> > > > > > 
> > > > > > Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
> > > > > > select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
> > > > > > host.MAXPHYADDR.
> > > > > 
> > > > > So then GPAW would be coded to basically best fit the supported guest.MAXPHYADDR within KVM. QEMU
> > > > > could look at the supported guest.MAXPHYADDR and use matching logic to determine GPAW.
> > > > 
> > > > Off topic, any chance I can bribe/convince you to wrap your email replies closer
> > > > to 80 chars, not 100?  Yeah, checkpath no longer complains when code exceeds 80
> > > > chars, but my brain is so well trained for 80 that it actually slows me down a
> > > > bit when reading mails that are wrapped at 100 chars.
> > > > 
> > > > > Or are you suggesting that KVM should look at the value of CPUID(0X8000_0008).eax[23:16] passed from
> > > > > userspace?
> > > > 
> > > > This.  Note, my pseudo-patch incorrectly looked at bits 15:8, that was just me
> > > > trying to go off memory.
> > > > 
> > > > > I'm not following the code examples involving struct kvm_vcpu. Since TDX
> > > > > configures these at a VM level, there isn't a vcpu.
> > > > 
> > > > Ah, I take it GPAW is a VM-scope knob?  I forget where we ended up with the ordering
> > > > of TDX commands vs. creating vCPUs.  Does KVM allow creating vCPU structures in
> > > > advance of the TDX INIT call?  If so, the least awful solution might be to use
> > > > vCPU0's CPUID.
> > > 
> > > The current order is, KVM vm creation (KVM_CREATE_VM),
> > > KVM vcpu creation(KVM_CREATE_VCPU), TDX VM initialization (KVM_TDX_INIT_VM).
> > > and TDX VCPU initialization(KVM_TDX_INIT_VCPU).
> > > We can call KVM_SET_CPUID2 before KVM_TDX_INIT_VM.  We can remove cpuid part
> > > from struct kvm_tdx_init_vm by vcpu0 cpuid.
> > 
> > What's the reason to call KVM_TDX_INIT_VM after KVM_CREATE_VCPU?
> 
> The KVM_TDX_INIT_VM (it requires cpuids) doesn't requires any order between two,
> KVM_TDX_INIT_VM and KVM_CREATE_VCPU.  We can call KVM_TDX_INIT_VM before or
> after KVM_CREATE_VCPU because there is no limitation between two.
> 
> The v5 TDX QEMU happens to call KVM_CREATE_VCPU and then KVM_TDX_INIT_VM
> because it creates CPUIDs for KVM_TDX_INIT_VM from qemu vCPU structures after
> KVM_GET_CPUID2.  Which is after KVM_CREATE_VCPU.

Sorry, let me correct it. QEMU creates QEMU's vCPU struct with its CPUIDs.
KVM_TDX_INIT_VM, KVM_CREATE_VCPU, and KVM_SET_CPUID2.  QEMU passes CPUIDs as is
to KVM_SET_CPUID2.

The v19 KVM_TDX_INIT_VM checks if the KVM vCPU is not created yet.  But it's can
be relaxed.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

