Return-Path: <kvm+bounces-11344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6DE875C51
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 03:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D13D31C20956
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 02:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0454224B41;
	Fri,  8 Mar 2024 02:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5gUINCI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E0241EC;
	Fri,  8 Mar 2024 02:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709864386; cv=none; b=qXF1Tu75V0v1sz1RDTN04HYL6+YsgS30qOJJa5ZjCaO0GVZfatvQPFpYpYzljcsuv2mjUgPoiRE8wIsZNqGWPrCwNkfvfevk07Y1SPTuJC0+8dtOXHOPAVrtRY+PhFnKPXHanPFHmA8/ScBg9eoqbFwrvh+qfkKud94FkFZfXpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709864386; c=relaxed/simple;
	bh=kGRs/fz24VkTWHH4S8pCCKusmOcJgBiU+R29+4TngFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFz7b6vS4RVXGB1hw1dVdnIDWJnmryTLilw0g5FqffvV+0EQDmN645OnQCcZWRPOk2YOEo3nnX23Uy1WRH6/XYv/0ZIlcen87Kb8H2bmH/yfcKWibSgo2HyoKL36D5gxTzPT+H3XL/2SvXOS/RLIuET4gXr96YhHO3QRjmXjFQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5gUINCI; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709864383; x=1741400383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kGRs/fz24VkTWHH4S8pCCKusmOcJgBiU+R29+4TngFs=;
  b=R5gUINCI0Jvd9HUMKAt2PG8ElVauoPpi/EPDsFsWEJHD5vpnIrBD5WM9
   +uhGkGgVO8zDEDcyaqkCbaxfWhZw5KzOtVEQXOhEc65y46eSpeGfcwhfy
   UOMyCShlSzOpb3WkGLFa6zpJXU4WTKbAj1womxcCZYxlWtCzYzvMHnJ+5
   G6DgKXNlkKhtSxrn/Dh5EP/BDrZZxhBTDXHuTa0d+roJ6aUTNzOd57s/J
   qBmd3XyzwWPm/iyXF5t+rKWs2bSUPW/sRzs+R0/sfiJ/wFbn8E5beRd9a
   kJvN2vDqXuTNXKyegjktrenPuJrSbmEOaizRMg0iPZEWNOu0kvoFzCHy+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="15216711"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15216711"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 18:19:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10870644"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 18:19:42 -0800
Date: Thu, 7 Mar 2024 18:19:41 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <20240308021941.GM368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com>
 <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
 <ZepiU1x7i-ksI28A@google.com>
 <ZepptFuo5ZK6w4TT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZepptFuo5ZK6w4TT@google.com>

On Thu, Mar 07, 2024 at 05:28:20PM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Mar 07, 2024, David Matlack wrote:
> > On 2024-03-08 01:20 PM, Huang, Kai wrote:
> > > > > > +:Parameters: struct kvm_memory_mapping(in/out)
> > > > > > +:Returns: 0 on success, <0 on error
> > > > > > +
> > > > > > +KVM_MAP_MEMORY populates guest memory without running vcpu.
> > > > > > +
> > > > > > +::
> > > > > > +
> > > > > > +  struct kvm_memory_mapping {
> > > > > > +	__u64 base_gfn;
> > > > > > +	__u64 nr_pages;
> > > > > > +	__u64 flags;
> > > > > > +	__u64 source;
> > > > > > +  };
> > > > > > +
> > > > > > +  /* For kvm_memory_mapping:: flags */
> > > > > > +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
> > > > > > +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
> > > > > > +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
> > > > > 
> > > > > I am not sure what's the good of having "FLAG_USER"?
> > > > > 
> > > > > This ioctl is called from userspace, thus I think we can just treat this always
> > > > > as user-fault?
> > > > 
> > > > The point is how to emulate kvm page fault as if vcpu caused the kvm page
> > > > fault.  Not we call the ioctl as user context.
> > > 
> > > Sorry I don't quite follow.  What's wrong if KVM just append the #PF USER
> > > error bit before it calls into the fault handler?
> > > 
> > > My question is, since this is ABI, you have to tell how userspace is
> > > supposed to use this.  Maybe I am missing something, but I don't see how
> > > USER should be used here.
> > 
> > If we restrict this API to the TDP MMU then KVM_MEMORY_MAPPING_FLAG_USER
> > is meaningless, PFERR_USER_MASK is only relevant for shadow paging.
> 
> +1
> 
> > KVM_MEMORY_MAPPING_FLAG_WRITE seems useful to allow memslots to be
> > populated with writes (which avoids just faulting in the zero-page for
> > anon or tmpfs backed memslots), while also allowing populating read-only
> > memslots.
> > 
> > I don't really see a use-case for KVM_MEMORY_MAPPING_FLAG_EXEC.
> 
> It would midly be interesting for something like the NX hugepage mitigation.
> 
> For the initial implementation, I don't think the ioctl() should specify
> protections, period.
> 
> VMA-based mappings, i.e. !guest_memfd, already have a way to specify protections.
> And for guest_memfd, finer grained control in general, and long term compatibility
> with other features that are in-flight or proposed, I would rather userspace specify
> RWX protections via KVM_SET_MEMORY_ATTRIBUTES.  Oh, and dirty logging would be a
> pain too.
> 
> KVM doesn't currently support execute-only (XO) or !executable (RW), so I think
> we can simply define KVM_MAP_MEMORY to behave like a read fault.  E.g. map RX,
> and add W if all underlying protections allow it.
> 
> That way we can defer dealing with things like XO and RW *if* KVM ever does gain
> support for specifying those combinations via KVM_SET_MEMORY_ATTRIBUTES, which
> will likely be per-arch/vendor and non-trivial, e.g. AMD's NPT doesn't even allow
> for XO memory.
> 
> And we shouldn't need to do anything for KVM_MAP_MEMORY in particular if
> KVM_SET_MEMORY_ATTRIBUTES gains support for RWX protections the existing RWX and
> RX combinations, e.g. if there's a use-case for write-protecting guest_memfd
> regions.
> 
> We can always expand the uAPI, but taking away functionality is much harder, if
> not impossible.

Ok, let me drop all the flags.  Here is the updated one.

4.143 KVM_MAP_MEMORY
------------------------

:Capability: KVM_CAP_MAP_MEMORY
:Architectures: none
:Type: vcpu ioctl
:Parameters: struct kvm_memory_mapping(in/out)
:Returns: 0 on success, < 0 on error

Errors:

  ======   =============================================================
  EINVAL   vcpu state is not in TDP MMU mode or is in guest mode.
           Currently, this ioctl is restricted to TDP MMU.
  EAGAIN   The region is only processed partially.  The caller should
           issue the ioctl with the updated parameters.
  EINTR    An unmasked signal is pending.  The region may be processed
           partially.  If `nr_pages` > 0, the caller should issue the
           ioctl with the updated parameters.
  ======   =============================================================

KVM_MAP_MEMORY populates guest memory before the VM starts to run.  Multiple
vcpus can call this ioctl simultaneously.  It may result in the error of EAGAIN
due to race conditions.

::

  struct kvm_memory_mapping {
	__u64 base_gfn;
	__u64 nr_pages;
	__u64 flags;
	__u64 source;
  };

KVM_MAP_MEMORY populates guest memory at the specified range (`base_gfn`,
`nr_pages`) in the underlying mapping. `source` is an optional user pointer.  If
`source` is not NULL and the underlying technology supports it, the memory
contents of `source` are copied into the guest memory.  The backend may encrypt
it.  `flags` must be zero.  It's reserved for future use.

When the ioctl returns, the input values are updated.  If `nr_pages` is large,
it may return EAGAIN or EINTR for pending signal and update the values
(`base_gfn` and `nr_pages`.  `source` if not zero) to point to the remaining
range.

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

