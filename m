Return-Path: <kvm+bounces-18326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5318D3D25
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 18:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16030286AD0
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F3F187334;
	Wed, 29 May 2024 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LpyNQ8mD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF4F1C6B2;
	Wed, 29 May 2024 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717001725; cv=none; b=tXVuQDcQuphbDF5MPTIuQNq8F64ME+RNwJjTlN235ek81t9DIyLkLWHjdnNeDSLYNPxi2+RvpTm5CFWeYlguDEuHWRZn/trDcNnaF3dCfYvHRa2sdo4Kk5Pb1meXWIpFsjxqWiMsgSiuOy/Aolya2Ld8N872zJMOF6UaiTxvypE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717001725; c=relaxed/simple;
	bh=adQZoOVxXiRU8SzRlZMsbJp0FGrW/aeQJb2xgSY2l4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRL3hwDkWvtjj7xLiL7kr/Xe70qRCD79rDh6zGN27eVvcwtBfOK4mFx70hfSSe+aCGrPmqgQaGp0i3/OF+Z0YQGJr91lgu49Q8LclXWf++Od8wjAV7OV9QG8rzT0KsxZZBVisvuMzXdZjeqHO+LYaTdtEui0NDHm6sBSsbzrRDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LpyNQ8mD; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717001723; x=1748537723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=adQZoOVxXiRU8SzRlZMsbJp0FGrW/aeQJb2xgSY2l4E=;
  b=LpyNQ8mDnZ9VA18VB3lxH0Id6vE2vAqHQw8d7B37Lu9/jpyBYKYAWLoF
   p4G0sGPXCl51mV7najyydOtKBJxPNZ9bEbYdZn1CNUBFn9VeshEhq2Plm
   YQZ7jnk/lbY3VXbDTh2MQVc6rNRVcJzcZuD7zCLWGkPMzTe2nGfSWcMU/
   ju1kIq5VG5Du/2SZsHW1rrciNBTCU28vo7yNZIF6YlNjZGAxTSpDeHKrj
   qVvKTevxflYp8DzRhzxR/yI72m6+5RytcBaJyW+Oan355VKgMBPBU8OBu
   i7sUY08lYfibg/BjaapbpePqDfXlEee125Em3e2szv/4NQnL5V0GRiFa6
   w==;
X-CSE-ConnectionGUID: 8QlyvXwORJOr9MqOfM/bKw==
X-CSE-MsgGUID: IclgLZvVQUudCZRfJkzPmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="17252043"
X-IronPort-AV: E=Sophos;i="6.08,198,1712646000"; 
   d="scan'208";a="17252043"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 09:55:22 -0700
X-CSE-ConnectionGUID: 3RjkdsR0SbiLRmd3N1zBow==
X-CSE-MsgGUID: 9TNZEWNpQgy44pf7ZX402g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,198,1712646000"; 
   d="scan'208";a="39923851"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 09:55:21 -0700
Date: Wed, 29 May 2024 09:55:20 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240529165520.GH386318@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <a5ad658b1eec38f621315431a24e028187b5ca2d.camel@intel.com>
 <20240529015749.GF386318@ls.amr.corp.intel.com>
 <6a831f1b429ab6d1dd3e60a947cab7ab0b3f7149.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a831f1b429ab6d1dd3e60a947cab7ab0b3f7149.camel@intel.com>

On Wed, May 29, 2024 at 02:13:24AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-05-28 at 18:57 -0700, Isaku Yamahata wrote:
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -438,6 +438,9 @@ static void handle_removed_pt(struct kvm *kvm,
> > > tdp_ptep_t
> > > pt, bool shared)
> > >                           */
> > >                          old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
> > >                                                            REMOVED_SPTE,
> > > level);
> > > +
> > > +                       if (is_mirror_sp(sp))
> > > +                               reflect_removed_spte(kvm, gfn, old_spte,
> > > REMOVED_SPTE, level);
> > 
> > The callback before handling lower level will result in error.
> 
> Hmm, yea the order is changed. It didn't result in an error for some reason
> though. Can you elaborate?

TDH.MEM.{PAGE, SEPT}.REMOVE() needs to be issued from the leaf.  I guess
zapping is done at only leaf by tdp_mmu_zap_leafs(). Subtree zapping case wasn't
exercised.


> > > Otherwise, we could move the "set present" mirroring operations into
> > > handle_changed_spte(), and have some earlier conditional logic do the
> > > REMOVED_SPTE parts. It starts to become more scattered.
> > > Anyway, it's just a code clarity thing arising from having hard time
> > > explaining
> > > the design in the log. Any opinions?
> > 
> > Originally I tried to consolidate the callbacks by following TDP MMU using
> > handle_changed_spte().
> 
> How did it handle the REMOVED_SPTE part of the set_present() path?

is_removed_pt() was used. It was ugly.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

