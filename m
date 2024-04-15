Return-Path: <kvm+bounces-14706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ADBD8A5EC0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 01:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC8C91C20CEB
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 23:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B403D15959F;
	Mon, 15 Apr 2024 23:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JpTdlcuY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DC71591F9;
	Mon, 15 Apr 2024 23:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224828; cv=none; b=Fwe+RRk0oojktDNGlkVw4To1RIzoYLYcTByXJ9u9uJKDvQmVQIxduG40cj0BtJCWxY0Bd+DgEc95Hgc0GipzysmFiiDdxUFnySBD7xJ2RA04m63hAIokr3oJc2uPLqKdi6R33cgQRM3hznm3CZ5pql+DnU2jxTYH6ybNFCSVads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224828; c=relaxed/simple;
	bh=FWDEXVTguAar4m8imUHlc2m4hlcXNWjBKrE/uYvrpbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIDu0uSn/pbgYzZdP+ATrq500RdG0NrJRBegE/W/HB7IhSH3JOy3GaC0vedh1pn/OEg30DGtFWAI0QwJ70zNrOuSB4gJTQzZcyC+zIbSkYsSNcpoMnF4jvFoRAMlDAe+WY10ve4vsWstjkNPu6FqA/Lv/AMLLiD2v7uaEafhwe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JpTdlcuY; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713224827; x=1744760827;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FWDEXVTguAar4m8imUHlc2m4hlcXNWjBKrE/uYvrpbE=;
  b=JpTdlcuY5MKZhYhrMtDgLFOt0ZTP/+8vpY/bUWGyHejy/pQl1jsE0BV6
   1+Zf5fqKbLKxF/p+HwtPTvJyBJlnKOJovKw09MqjSGpVGNhTnJzz9a1ZP
   npNZFy23DYSI8UUGCoTmXpmC5g4Rpqo0gszhZ6A0ualYz1//3GT4H2lJV
   MgNniCma8MLf289EjWRPtzNgqabwSUZ4iCdIyKKfrGsXQ/HpmpixBgFP6
   24ZhOF2QeosVoLQmXj3+gfiYRn+8Z4CtSPpzt4csZDEX2xyaBpZiu39TQ
   HhuKFXDvTVhftnNfVb3GspK8Uw+sxT+7IOmKb8lXWYUOBAQlU6iHzKwLp
   Q==;
X-CSE-ConnectionGUID: 4fZSILVPSceWE77yp0PtIg==
X-CSE-MsgGUID: hd7ceNFBRg6p3I02QYSeNw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="19245291"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="19245291"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 16:47:06 -0700
X-CSE-ConnectionGUID: dXXmjoOuRnCLnLxLYNOCVQ==
X-CSE-MsgGUID: HVHXiUxHRY+TK7mxa6YkVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22086010"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 16:47:06 -0700
Date: Mon, 15 Apr 2024 16:47:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 01/10] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <20240415234705.GV3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata@intel.com>
 <28923ef142d588836201a1533b73fe4d89ce4696.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28923ef142d588836201a1533b73fe4d89ce4696.camel@intel.com>

On Mon, Apr 15, 2024 at 11:27:20PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> Nits only...
> 
> On Wed, 2024-04-10 at 15:07 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Adds documentation of KVM_MAP_MEMORY ioctl. [1]
> > 
> > It populates guest memory.  It doesn't do extra operations on the
> > underlying technology-specific initialization [2].  For example,
> > CoCo-related operations won't be performed.  Concretely for TDX, this API
> > won't invoke TDH.MEM.PAGE.ADD() or TDH.MR.EXTEND().  Vendor-specific APIs
> > are required for such operations.
> > 
> > The key point is to adapt of vcpu ioctl instead of VM ioctl.
> 
> Not sure what you are trying to say here.
> 
> >   First,
> > populating guest memory requires vcpu.  If it is VM ioctl, we need to pick
> > one vcpu somehow.  Secondly, vcpu ioctl allows each vcpu to invoke this
> > ioctl in parallel.  It helps to scale regarding guest memory size, e.g.,
> > hundreds of GB.
> 
> I guess you are explaining why this is a vCPU ioctl instead of a KVM ioctl. Is
> this clearer:

Right, I wanted to explain why I chose vCPU ioctl.  Let me update the commit
message.


> Although the operation is sort of a VM operation, make the ioctl a vCPU ioctl
> instead of KVM ioctl. Do this because a vCPU is needed internally for the fault
> path anyway, and because... (I don't follow the second point).
> 
> > 
> > [1] https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/
> > [2] https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v2:
> > - Make flags reserved for future use. (Sean, Michael)
> > - Clarified the supposed use case. (Kai)
> > - Dropped source member of struct kvm_memory_mapping. (Michael)
> > - Change the unit from pages to bytes. (Michael)
> > ---
> >  Documentation/virt/kvm/api.rst | 52 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index f0b76ff5030d..6ee3d2b51a2b 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6352,6 +6352,58 @@ a single guest_memfd file, but the bound ranges must
> > not overlap).
> >  
> >  See KVM_SET_USER_MEMORY_REGION2 for additional details.
> >  
> > +4.143 KVM_MAP_MEMORY
> > +------------------------
> > +
> > +:Capability: KVM_CAP_MAP_MEMORY
> > +:Architectures: none
> > +:Type: vcpu ioctl
> > +:Parameters: struct kvm_memory_mapping (in/out)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +Errors:
> > +
> > +  ========== =============================================================
> > +  EINVAL     invalid parameters
> > +  EAGAIN     The region is only processed partially.  The caller should
> > +             issue the ioctl with the updated parameters when `size` > 0.
> > +  EINTR      An unmasked signal is pending.  The region may be processed
> > +             partially.
> > +  EFAULT     The parameter address was invalid.  The specified region
> > +             `base_address` and `size` was invalid.  The region isn't
> > +             covered by KVM memory slot.
> > +  EOPNOTSUPP The architecture doesn't support this operation. The x86 two
> > +             dimensional paging supports this API.  the x86 kvm shadow mmu
> > +             doesn't support it.  The other arch KVM doesn't support it.
> > +  ========== =============================================================
> > +
> > +::
> > +
> > +  struct kvm_memory_mapping {
> > +       __u64 base_address;
> > +       __u64 size;
> > +       __u64 flags;
> > +  };
> > +
> > +KVM_MAP_MEMORY populates guest memory with the range, `base_address` in (L1)
> > +guest physical address(GPA) and `size` in bytes.  `flags` must be zero.  It's
> > +reserved for future use.  When the ioctl returns, the input values are
> > updated
> > +to point to the remaining range.  If `size` > 0 on return, the caller should
> > +issue the ioctl with the updated parameters.
> > +
> > +Multiple vcpus are allowed to call this ioctl simultaneously.  It's not
> > +mandatory for all vcpus to issue this ioctl.  A single vcpu can suffice.
> > +Multiple vcpus invocations are utilized for scalability to process the
> > +population in parallel.  If multiple vcpus call this ioctl in parallel, it
> > may
> > +result in the error of EAGAIN due to race conditions.
> > +
> > +This population is restricted to the "pure" population without triggering
> > +underlying technology-specific initialization.  For example, CoCo-related
> > +operations won't perform.  In the case of TDX, this API won't invoke
> > +TDH.MEM.PAGE.ADD() or TDH.MR.EXTEND().  Vendor-specific uAPIs are required
> > for
> > +such operations.
> 
> Probably don't want to have TDX bits in here yet. Since it's talking about what
> KVM_MAP_MEMORY is *not* doing, it can just be dropped.

Ok.  Will drop it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

