Return-Path: <kvm+bounces-14562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D7C8A34F8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27AA71F240C4
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 17:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6BA14EC52;
	Fri, 12 Apr 2024 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LyPQISXo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC81149009;
	Fri, 12 Apr 2024 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943583; cv=none; b=cDIDEqyTiNDmympcLiGNkbXll365v8wy0qQPXR9W+voZmN4DykfRCvSWaknEf2ll451yLC3NcyppHpPPVL9gGKqg8ZQAe+/92DuTTYUtF/AJAOKBU3olqTlHfhOzD/4cLyfDgeymrJI/GzRYBb4K+LC0D6YLLsxYlYcpri99ggQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943583; c=relaxed/simple;
	bh=BLEtjVnBJnqOweid/o9LC3AV3pOUNEEl+F0GkqNkFZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FH+ZouSA/BXCU+3TM+AZWD7zhZjLBUyuObm26h8QZJHpsSJh3PtYwkXsuUbW88VBJ27FqDoz4uQyw8iDZD34miTbT6tyb49wNVWnpHn+THBLX0a5GbfhmKdZYRrB1pUFRQH1H+/UESkM1+f6beGFZxBeuqKadCXkBseZF9npp7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LyPQISXo; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712943581; x=1744479581;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=BLEtjVnBJnqOweid/o9LC3AV3pOUNEEl+F0GkqNkFZY=;
  b=LyPQISXowwLs8hF6e9XiqxVrGM9ZpDw/e21JwcdiM2RC+l5DI5CcjkCb
   TNNHbPfPxpNGn3tUxPPpxY76wPGb+J7VgomC2jT+SDekifRbAt4m5Fuwq
   gCKAgqPRNW9t7+c4iTcKj3K4lr9KUMcv9lZX5Z5yf8jRzAR4VnI9CUtsK
   6SBsqH/kgjfZxhSkkE3m+e1QV8qccb1fCHdWADUYlyXNuuQvNKRClGZLW
   4rFJosugwQbLXEDrg8GRaHfUYjGdR8dNn7UumrrM7Z8XPX+dSmcFF2UfH
   G3ThtBHFBemj0FaqlfCRmzByj4vPsD3e2HTX07cm4iQQr7GsHScYYKooB
   g==;
X-CSE-ConnectionGUID: ztjrNoHFSye3GXWj8f/EhQ==
X-CSE-MsgGUID: MoJXHl80TjWVm4geLrv+HA==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8277874"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="8277874"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:39:41 -0700
X-CSE-ConnectionGUID: Q/wtgR9TSKKcHm8USHN4oA==
X-CSE-MsgGUID: x4MyejV5RhG52WFZYasWAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="26094811"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:39:41 -0700
Date: Fri, 12 Apr 2024 10:39:35 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"davidskidmore@google.com" <davidskidmore@google.com>,
	"srutherford@google.com" <srutherford@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Wang, Wei W" <wei.w.wang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Message-ID: <20240412173935.GH3039520@ls.amr.corp.intel.com>
References: <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com>
 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com>
 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
 <ZhfyNLKsTBUOI7Vp@google.com>
 <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
 <ZhgBGkPTwpIsE6P6@google.com>
 <437e0da5de22c0a1e77e25fcb7ebb1f052fef754.camel@intel.com>
 <19a0f47e-6840-42f8-b200-570a9aa7455d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19a0f47e-6840-42f8-b200-570a9aa7455d@intel.com>

On Fri, Apr 12, 2024 at 04:40:37PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> > The second issue is that userspace can’t know what CPUID values are configured
> > in the TD. In the existing API for normal guests, it knows because it tells the
> > guest what CPUID values to have. But for the TDX module that model is
> > complicated to fit into in its API where you tell it some things and it gives
> > you the resulting leaves. How to handle KVM_SET_CPUID kind of follows from this
> > issue.
> > 
> > One option is to demand the TDX module change to be able to efficiently wedge
> > into KVM’s exiting “tell” model. This looks like the metadata API to query the
> > fixed bits. Then userspace can know what bits it has to set, and call
> > KVM_SET_CPUID with them. I think it is still kind of awkward. "Tell me what you
> > want to hear?", "Ok here it is".
> > 
> > Another option would be to add TDX specific KVM APIs that work for the TDX
> > module's “ask” model, and meet the enumerated two goals. It could look something
> > like:
> > 1. KVM_TDX_GET_CONFIG_CPUID provides a list of directly configurable bits by
> > KVM. This is based on static data on what KVM supports, with sanity check of
> > TD_SYSINFO.CPUID_CONFIG[]. Bits that KVM doesn’t know about, but are returned as
> > configurable by TD_SYSINFO.CPUID_CONFIG[] are not exposed as configurable. (they
> > will be set to 1 by KVM, per the recommendation)
> 
> This is not how KVM works. KVM will never enable unknown features blindly.
> If the feature is unknown to KVM, it cannot be enable for guest. That's why
> every new feature needs enabling patch in KVM, even the simplest case that
> needs one patch to enumerate the CPUID of new instruction in
> KVM_GET_SUPPORTED_CPUID.

We can use device attributes as discussed at
https://lore.kernel.org/kvm/CABgObfZzkNiP3q8p=KpvvFnh8m6qcHX4=tATaJc7cvVv2QWpJQ@mail.gmail.com/
https://lore.kernel.org/kvm/20240404121327.3107131-6-pbonzini@redhat.com/

Something like

#define KVM_X86_GRP_TDX         2
ioctl(fd, KVM_GET_DEVICE_ATTR, (KVM_X86_GRP_TDX, metadata_field_id))


> > 2. KVM_TDX_INIT_VM is passed userspaces choice of configurable bits, along with
> > XFAM and ATTRIBUTES as dedicated fields. They go into TDH.MNG.INIT.
> > 3. KVM_TDX_INIT_VCPU_CPUID takes a list of CPUID leafs. It pulls the CPUID bits
> > actually configured in the TD for these leafs. They go into the struct kvm_vcpu,
> > and are also passed up to userspace so everyone knows what actually got
> > configured.

Any reason to introduce KVM_TDX_INIT_VCPU_CPUID in addition to
KVM_TDX_INIT_VCPU?  We can make single vCPU KVM TDX ioctl do all.


> > KVM_SET_CPUID is not used for TDX.

What cpuid does KVM_TDX_INIT_VCPU_CPUID accept?  The one that TDX module
accepts with TDH.MNG.INIT()?  Or any cpuids that KVM_SET_CPUID2 accepts?
I'm asking it because TDX module virtualizes only subset of CPUIDs. 
TDG.VP.VMCALL<CPUID> would need info from KVM_SET_CPUID.


> > Then we get TDX module folks to commit to never breaking KVM/userspace that
> > follows this logic. One thing still missing is how to handle unknown future
> > leafs with fixed bits. If a future leaf is defined and gets fixed 1, QEMU
> > wouldn't know to query it.
> 
> We can make KVM_TDX_INIT_VCPU_CPUID provide a large enough CPUID leafs and
> KVM reports every leafs to userpsace. Instead of something that userspace
> cares leafs X,Y,Z and KVM only reports back leafs X,Y,Z via
> KVM_TDX_INIT_VCPU_CPUID.

If new CPUID index is introduced, the userspace will get default values of
CPUIDs and don't touch unknown CPUIDs?  Or KVM_TDX_GET_CONFIG_CPUID will mask
out CPUID unknown to KVM?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

