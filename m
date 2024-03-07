Return-Path: <kvm+bounces-11330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4053087587A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 21:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0B1C2812E0
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 20:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51E964CDC;
	Thu,  7 Mar 2024 20:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dp7wx2PO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF5139571;
	Thu,  7 Mar 2024 20:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843624; cv=none; b=YTmFq9DnCwEjAa33FKSTpp+Es/bVONBR9uOTUMzuhj2qVXtz21saP6YfDsc02vDpC6a9h5s1ck9KIqZzeSYxlBLY0cj5suhhVHg2bZfGlewzLSd6grZfdlOC2Oj6NTdAIaEF3+Xpc488IkTw7Q+aYmuP0rQLMmgN/acCNo6/jAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843624; c=relaxed/simple;
	bh=pYm922DxqcT6fMWqbP4U26AYgN9ggB1aB8F8XfUPFDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxpqlsPUJ9wkceLmJmFkPWAl3sTDrK6hUfIFygIZz668vGwohG7FgootaFGfx4qmjl73o/OzT7D24r0nypCaOXBnsveNzVbsCVMjjSGAxZtgcXup7z/OitRJIONHloD5lplcZpO2Dzf8hjzer0IVIwENf9yma5wD7jNrsYcx/CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dp7wx2PO; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709843622; x=1741379622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pYm922DxqcT6fMWqbP4U26AYgN9ggB1aB8F8XfUPFDY=;
  b=dp7wx2POs3xpLzSCM+m21mhYB5gxMakh50CsTujO1zMNKRcBFGjlvwK0
   MjAvSoT30HTdj/LrLBNH59xXS1XqRTrChtp6li/TzWO0xiRmypfru/Jh/
   vw+PNrVkVnf5DCRmUdG9dMvIHnsXUm2UhuMFPBA5EnbZ57sjq49wKBLH0
   v420U6JMlJM7J+QM20SHUbGOgEWjY1XrESNtgykdQE0SvsaLz6VFqvyjJ
   ESbwCm/QAmXlbhFfTnDis61nqqoESUKjcJ62jR6p+E7pF33bet3wiTcJB
   ZqU0HJCDcRAVxz+1EH9pSEbTZ2n0UyNBd8Y+QQHyrcDkiUlDnXCzrf9dC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="15109178"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="15109178"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 12:33:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="41212476"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 12:33:41 -0800
Date: Thu, 7 Mar 2024 12:33:40 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Message-ID: <20240307203340.GI368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>

On Thu, Mar 07, 2024 at 12:30:04PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Fri, 2024-03-01 at 09:28 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Adds documentation of KVM_MAP_MEMORY ioctl.
> > 
> > It pre-populates guest memory. And potentially do initialized memory
> > contents with encryption and measurement depending on underlying
> > technology.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 36 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 0b5a33ee71ee..33d2b63f7dbf 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6352,6 +6352,42 @@ a single guest_memfd file, but the bound ranges must not overlap).
> >  
> >  See KVM_SET_USER_MEMORY_REGION2 for additional details.
> >  
> > +4.143 KVM_MAP_MEMORY
> > +------------------------
> > +
> > +:Capability: KVM_CAP_MAP_MEMORY
> > +:Architectures: none
> > +:Type: vcpu ioctl
> 
> I think "vcpu ioctl" means theoretically it can be called on multiple vcpus.
> 
> What happens in that case?

Each vcpu can handle the ioctl simaltaneously.  If we assume tdp_mmu, each vcpu
calls the kvm fault handler simultaneously with read spinlock.
If gfn ranges overlap, vcpu will get 0 (success) or EAGAIN.


> > +:Parameters: struct kvm_memory_mapping(in/out)
> > +:Returns: 0 on success, <0 on error
> > +
> > +KVM_MAP_MEMORY populates guest memory without running vcpu.
> > +
> > +::
> > +
> > +  struct kvm_memory_mapping {
> > +	__u64 base_gfn;
> > +	__u64 nr_pages;
> > +	__u64 flags;
> > +	__u64 source;
> > +  };
> > +
> > +  /* For kvm_memory_mapping:: flags */
> > +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
> > +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
> > +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
> 
> I am not sure what's the good of having "FLAG_USER"?
> 
> This ioctl is called from userspace, thus I think we can just treat this always
> as user-fault?

The point is how to emulate kvm page fault as if vcpu caused the kvm page
fault.  Not we call the ioctl as user context.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

