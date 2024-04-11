Return-Path: <kvm+bounces-14203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4D88A0532
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 03:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF33F1F23846
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 01:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B689604BB;
	Thu, 11 Apr 2024 01:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OejP+i39"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639F05FDC8;
	Thu, 11 Apr 2024 01:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712797436; cv=none; b=tCWUxDCCvUwxAH3aeSQX7SI0uAqQPQTR88FbfragFeJUp1s6lAvVofASZs1yKZPvQgHLjHZN0ss3erutRtS3MSQmw4rcBRc/Ii9ywqN1FLxajHMfO/pMaFmrO9vXhou6DOK0wZWvyM3mF91a9gQt2fKhKcl4AHNai+bQ0vAXqqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712797436; c=relaxed/simple;
	bh=bZk5VrtNaLrmqjqtO4EPOJ0fJRlhFdO8m8+hzzHrNHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=akJcIcSxlHB+v27sZ85vpNhbywJHJs/vgz5vl/HljbuC3ReehOg2qs1uHxZ2rjODapTW50WZKb2S8xQE0PaA/iemcMilVWq4tjw8bciHg/OWgaqCnceILXRGa3uxQdzNhwE1NVynrMm2BvXw3G8h2nch3wDGbM6UQPj8h1zyN14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OejP+i39; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712797435; x=1744333435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bZk5VrtNaLrmqjqtO4EPOJ0fJRlhFdO8m8+hzzHrNHM=;
  b=OejP+i39DTK6YunM7Wf1kHYUsKdEodUi+q7dxfdqxcUR2+OWJVkRHu5j
   CoQnyt2pwaRfE17S2P/NZqMqIot/lhjVg6PBeedTcBlG5WPcpXysy8aRk
   4cXgiYfYHmrXm6se/buTdFYH7fK7eIxPrxq7NOkLh7Qj0tetczrAX3Bbu
   J6G3OXj2lkwZvOEPzRKHdQk0PJ3gLchuf8Tk/rY0v+iKRbadm/MCwdHgL
   F9eFT/ie1/EpOHtnDatd5eIDboYN5H9qkc2AIHmnUMSENyrursIuAsA8F
   Aj5B8i3c3xxAXADyzqYlLjOTZnxdqZf9AfJDxcVRU+r9j26fyTBoirV3n
   A==;
X-CSE-ConnectionGUID: 6kSLxG9+SXeKKZ0vQhwpPw==
X-CSE-MsgGUID: y1jppkvSQNC+w500xgbjPw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="25645482"
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="25645482"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 18:03:54 -0700
X-CSE-ConnectionGUID: 1cV0c/bqToOsX9GcltqIjQ==
X-CSE-MsgGUID: 3Ojv3KNzT6yFkaT7xw5b5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,192,1708416000"; 
   d="scan'208";a="20800007"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 18:03:54 -0700
Date: Wed, 10 Apr 2024 18:03:52 -0700
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
Message-ID: <20240411010352.GB3039520@ls.amr.corp.intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com>
 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com>
 <20240410011240.GA3039520@ls.amr.corp.intel.com>
 <1628a8053e01d84bcc7a480947ca882028dbe5b9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1628a8053e01d84bcc7a480947ca882028dbe5b9.camel@intel.com>

On Wed, Apr 10, 2024 at 02:03:26PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2024-04-09 at 18:12 -0700, Isaku Yamahata wrote:
> > On Mon, Apr 08, 2024 at 06:51:40PM +0000,
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Mon, Apr 08, 2024, Edgecombe, Rick P wrote:
> > > > On Mon, 2024-04-08 at 09:20 -0700, Sean Christopherson wrote:
> > > > > > Another option is that, KVM doesn't allow userspace to configure
> > > > > > CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
> > > > > > kvm_tdx_init_vm for userspace to configure directly.
> > > > > > 
> > > > > > What do you prefer?
> > > > > 
> > > > > Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
> > > > > select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
> > > > > host.MAXPHYADDR.
> > > > 
> > > > So then GPAW would be coded to basically best fit the supported guest.MAXPHYADDR within KVM. QEMU
> > > > could look at the supported guest.MAXPHYADDR and use matching logic to determine GPAW.
> > > 
> > > Off topic, any chance I can bribe/convince you to wrap your email replies closer
> > > to 80 chars, not 100?  Yeah, checkpath no longer complains when code exceeds 80
> > > chars, but my brain is so well trained for 80 that it actually slows me down a
> > > bit when reading mails that are wrapped at 100 chars.
> > > 
> > > > Or are you suggesting that KVM should look at the value of CPUID(0X8000_0008).eax[23:16] passed from
> > > > userspace?
> > > 
> > > This.  Note, my pseudo-patch incorrectly looked at bits 15:8, that was just me
> > > trying to go off memory.
> > > 
> > > > I'm not following the code examples involving struct kvm_vcpu. Since TDX
> > > > configures these at a VM level, there isn't a vcpu.
> > > 
> > > Ah, I take it GPAW is a VM-scope knob?  I forget where we ended up with the ordering
> > > of TDX commands vs. creating vCPUs.  Does KVM allow creating vCPU structures in
> > > advance of the TDX INIT call?  If so, the least awful solution might be to use
> > > vCPU0's CPUID.
> > 
> > The current order is, KVM vm creation (KVM_CREATE_VM),
> > KVM vcpu creation(KVM_CREATE_VCPU), TDX VM initialization (KVM_TDX_INIT_VM).
> > and TDX VCPU initialization(KVM_TDX_INIT_VCPU).
> > We can call KVM_SET_CPUID2 before KVM_TDX_INIT_VM.  We can remove cpuid part
> > from struct kvm_tdx_init_vm by vcpu0 cpuid.
> 
> What's the reason to call KVM_TDX_INIT_VM after KVM_CREATE_VCPU?

The KVM_TDX_INIT_VM (it requires cpuids) doesn't requires any order between two,
KVM_TDX_INIT_VM and KVM_CREATE_VCPU.  We can call KVM_TDX_INIT_VM before or
after KVM_CREATE_VCPU because there is no limitation between two.

The v5 TDX QEMU happens to call KVM_CREATE_VCPU and then KVM_TDX_INIT_VM
because it creates CPUIDs for KVM_TDX_INIT_VM from qemu vCPU structures after
KVM_GET_CPUID2.  Which is after KVM_CREATE_VCPU.


> I guess I have been away for this for too long time, but I had believed
> KVM_TDX_INIT_VM is called before creating any vcpu, which turns out to be wrong.
> 
> I am not against to make KVM_TDX_INIT_VM must be called after creating (at least
> one?) vcpu if there's good reason, but it seems if the purpose is just to pass
> CPUID(0x8000_0008).EAX[23:16] to KVM so KVM can determine GPAW for TDX guest,
> then we can also make KVM_TDX_INIT_VM to pass that.
> 
> KVM just need to manually handle CPUID(0x8000_0008) in KVM_TDX_INIT_VM, but
> that's the thing KVM needs to do anyway even if we use vcpu0's CPUID.
> 
> Am I missing anything?

Userspace VMM needs to create CPUID list somehow for KVM_TDX_INIT_VM or
KVM_SET_CPUID2 whichever is first.  It's effortless to reuse the CPUID list
for KVM_SET_CPUID2.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

