Return-Path: <kvm+bounces-18247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6999B8D29C3
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20E5C2879E6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C98215A863;
	Wed, 29 May 2024 01:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L+qvWV+t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2618D2FE;
	Wed, 29 May 2024 01:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716944792; cv=none; b=XCT45WMBaC1MH13W7Al02/uh0uqJJIjE3NoJeRf/xQPSKues8eT02itEK26V4F5hFM4YAaOQFk76clBUKRtYknCs3xxGF5Oj9mTPomxIoZNjK9dYgUUU3qv4Y5AIZB7fTQvekxowXRXMTke5lupZLel/1PzXYUMQ6IrIhghfXsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716944792; c=relaxed/simple;
	bh=HzrJdIzF71/TdMwwY6rKr0qTW4EAIFYcro4Y8ofZOLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhRUpHB9ffhtwY9LV+2wpLhONza4Z4IGB/99q59Ip5BlsMCw6Cg+zv3ejYf4jubcYNPb6ZfVRZ5ss50PTw3/cXGpAHyiAj/paEOeXW1iTazjDduXErw3oRbkXsixUtIkkQsqzCdPVpgx5sAWdp4Kt1+43+hpEjyXh6vLOcHSqTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L+qvWV+t; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716944790; x=1748480790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HzrJdIzF71/TdMwwY6rKr0qTW4EAIFYcro4Y8ofZOLg=;
  b=L+qvWV+trHrpnF5vj2R2NhR9kHAXkN05XsgxdMO0/sphHaAEwPaqD29H
   5khRZBsmHkx2exeY9m7i/GgU/kajX9jwifIM0RK+evw2Ee6XlBqsda4ml
   gAb0kGUOk/sR64wVekAk+/mIIMRsX8LUVj+Ibq+SK/eKIiuBEi5ghuU5m
   VliDVlV2/jGFIvTwNvOFV8g8YIKjJ6Ikt+Hu2xkyLjirMhGCzkejdUfOA
   1TrsGbeqfFPOXCgd05TzUHZZttPV+6pXW3n5MrC3hrHI4NdQEtCYtaSl5
   JoU86119C8nQUPCkbTKQ4Wr0HfnLzFrbVObZ7ZZwcJY9zirIbccQFkFRN
   g==;
X-CSE-ConnectionGUID: i5oYMAGaSSCWJ+PS271ckA==
X-CSE-MsgGUID: BKiKyEAiRw61ekHnZ1WRkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="17160738"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="17160738"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:06:30 -0700
X-CSE-ConnectionGUID: uenbFkcNRkqzEK4awyaV8A==
X-CSE-MsgGUID: o5kMJ+2TRF6RWQhIzVCpBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="35341860"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:06:30 -0700
Date: Tue, 28 May 2024 18:06:29 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240529010629.GC386318@ls.amr.corp.intel.com>
References: <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
 <CABgObfY=RnDFcs8Mxt3RZYmA1nQ24dux3Rhs4hK0ZfeE_OtLUw@mail.gmail.com>
 <3fa97619ca852854408eec8bb2f7a0ed635b3c1d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3fa97619ca852854408eec8bb2f7a0ed635b3c1d.camel@intel.com>

On Tue, May 28, 2024 at 06:29:59PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-05-28 at 19:16 +0200, Paolo Bonzini wrote:
> > > > After this, gfn_t's never have shared bit. It's a simple rule. The MMU
> > > > mostly
> > > > thinks it's operating on a shared root that is mapped at the normal GFN.
> > > > Only
> > > > the iterator knows that the shared PTEs are actually in a different
> > > > location.
> > > > 
> > > > There are some negative side effects:
> > > > 1. The struct kvm_mmu_page's gfn doesn't match it's actual mapping
> > > > anymore.
> > > > 2. As a result of above, the code that flushes TLBs for a specific GFN
> > > > will be
> > > > confused. It won't functionally matter for TDX, just look buggy to see
> > > > flushing
> > > > code called with the wrong gfn.
> > > 
> > > flush_remote_tlbs_range() is only for Hyper-V optimization.  In other cases,
> > > x86_op.flush_remote_tlbs_range = NULL or the member isn't defined at compile
> > > time.  So the remote tlb flush falls back to flushing whole range.  I don't
> > > expect TDX in hyper-V guest.  I have to admit that the code looks
> > > superficially
> > > broken and confusing.
> > 
> > You could add an "&& kvm_has_private_root(kvm)" to
> > kvm_available_flush_remote_tlbs_range(), since
> > kvm_has_private_root(kvm) is sort of equivalent to "there is no 1:1
> > correspondence between gfn and PTE to be flushed".
> > 
> > I am conflicted myself, but the upsides below are pretty substantial.
> 
> It looks like kvm_available_flush_remote_tlbs_range() is not checked in many of
> the paths that get to x86_ops.flush_remote_tlbs_range().
> 
> So maybe something like:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 65bbda95acbb..e09bb6c50a0b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1959,14 +1959,7 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm
> *kvm)
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> -static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn,
> -                                                  u64 nr_pages)
> -{
> -       if (!kvm_x86_ops.flush_remote_tlbs_range)
> -               return -EOPNOTSUPP;
> -
> -       return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
> -}
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
>  #endif /* CONFIG_HYPERV */
>  
>  enum kvm_intr_type {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43d70f4c433d..9dc1b3db286d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -14048,6 +14048,14 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu,
> unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
> +{
> +       if (!kvm_x86_ops.flush_remote_tlbs_range || kvm_gfn_direct_mask(kvm))
> +               return -EOPNOTSUPP;
> +
> +       return static_call(kvm_x86_flush_remote_tlbs_range)(kvm, gfn, nr_pages);
> +}
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);

kvm_x86_ops.flush_remote_tlbs_range() is defined only when CONFIG_HYPERV=y.
We need #ifdef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE  ... #endif around the
function.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

