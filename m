Return-Path: <kvm+bounces-15359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9548AB512
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF51D1F221E6
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76F913C9D2;
	Fri, 19 Apr 2024 18:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SjLIet3E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC5D13C9C2;
	Fri, 19 Apr 2024 18:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713551331; cv=none; b=bRmPswUlj0yCLNMGVsE7lE01LG1/vzinshcSPG+w+Hqn40PztzDh/m9Q3c5OCDXap7mjXzrtILJojgAUYHnv8xC/5ltAm12UaH5jAAMRWuPWpyQ8w826oxVW8uSHKlo9ObBKtDMOndb4nDk9elq0/MYA4Y61XZrg9BFzclGMYGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713551331; c=relaxed/simple;
	bh=M8YCz1l4+lVCy1G5QB3VTe1tQ3kMUzwdhw6ZeI71acc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHRvD7UMO+5O8VQR/LrqSjYBWlwiLKgpWqaJmVhCNXDHdgMaNx1nHonfN1yNc1yctgKc2MeiQdd3OmdwaO8ou2krV1dL8P/r6Yf4SHHeAo/XubJrx38JgoGx7DYXMaBbTzBqkMN+RJP6JEbA3byX1Ncz0X3LBb5/L6JFbLZF66g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SjLIet3E; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713551329; x=1745087329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M8YCz1l4+lVCy1G5QB3VTe1tQ3kMUzwdhw6ZeI71acc=;
  b=SjLIet3E1mOab7oeGLM9ayRlURAwqpJEiBigVnybvwaXfRfkYOocItmH
   HYaAIvHQvYsNwbZj4IS7jI8hxyj2Sq6sbujwgD8Su91M37nwE3UYFvueg
   3FRoHrH5qCSgRqk9lGds7iUvfpf6DLP3iiQFXjHl6yNtmNQzvqPGUv02E
   WEeOc8W31WHmJiy5kMXQUbDWvyECEip4PqAEtpDoF+O4P3pO48RDeVFGo
   C+IzOVH/3n8fTRq1PVw5wXGaL4++bwVbflEoElu+Cgt2i725gti8XeSTl
   YsejN8nV7MFkPdkm1tJeggrHlqC+sC0esb1BZU4czrNuQRw4J4N3Lx3sM
   A==;
X-CSE-ConnectionGUID: geSL8RDZTT6RU+cgtp7yJQ==
X-CSE-MsgGUID: lVgkbk31QE6H2Bw2/XGzNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9038286"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="9038286"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:28:48 -0700
X-CSE-ConnectionGUID: lZZYufypTZq1LxnkDtZSiA==
X-CSE-MsgGUID: Y7ab4wxlRzyZ4YeiJDEcUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="27867809"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:28:48 -0700
Date: Fri, 19 Apr 2024 11:28:48 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 010/130] KVM: x86: Pass is_private to gmem hook of
 gmem_max_level
Message-ID: <20240419182848.GI3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8108cc2b8ff01ec22de68f0d0758ef0671db43fc.1708933498.git.isaku.yamahata@intel.com>
 <ZiHGoUUcGlZObQvx@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZiHGoUUcGlZObQvx@yzhao56-desk.sh.intel.com>

On Fri, Apr 19, 2024 at 09:19:29AM +0800,
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:25:12AM -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX wants to know the faulting address is shared or private so that the max
> > level is limited by Secure-EPT or not.  Because fault->gfn doesn't include
> > shared bit, gfn doesn't tell if the faulting address is shared or not.
> > Pass is_private for TDX case.
> > 
> > TDX logic will be if (!is_private) return 0; else return PG_LEVEL_4K.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 3 ++-
> >  arch/x86/kvm/mmu/mmu.c          | 3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d15f5b4b1656..57ce89fc2740 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1797,7 +1797,8 @@ struct kvm_x86_ops {
> >  
> >  	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
> >  
> > -	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
> > +	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
> > +			      bool is_private, u8 *max_level);
> >  };
> >  
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1e5e12d2707d..22db1a9f528a 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4324,7 +4324,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >  
> >  	max_level = kvm_max_level_for_order(max_order);
> >  	r = static_call(kvm_x86_gmem_max_level)(vcpu->kvm, fault->pfn,
> > -						fault->gfn, &max_level);
> > +						fault->gfn, fault->is_private,
> > +						&max_level);
> fault->is_private is always true in kvm_faultin_pfn_private().
> Besides, as shared page allocation will not go to kvm_faultin_pfn_private(),
> why do we need to add the "is_private" parameter ?

You're right, we don't need this patch.
As Paolo picked the patch to add a hook, the discussion is happening at
https://lore.kernel.org/all/20240409234632.fb5mly7mkgvzbtqo@amd.com/#t
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

