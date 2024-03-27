Return-Path: <kvm+bounces-12911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB5D88F35C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF985B21284
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C4C1552F4;
	Wed, 27 Mar 2024 23:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPB7ev08"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA111514CE;
	Wed, 27 Mar 2024 23:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711583459; cv=none; b=PCF7eLmcVrx961wZRLT3bSTlsUgZhoKBnilWGUQfMtjpgDgJsCJmExgjdWJ916IoRZNmXrdMegxoy8xgTtjARCiy/mhlGyWa2eACfLIQof0cPQabKJ4R9i/F1hLqqSNGBCm5z1vmqnxeYjuLdYbAsu+WZFdncS4nEU7iuEzyl2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711583459; c=relaxed/simple;
	bh=555FLQQPCqRByogTrhuwRKGtsnTbnc0NbOQL9lfPUnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFs6clIDAACfTMIV1IrX6JQ5TTFe4hdYFNpO17WI7yYd/1+pwis6LbsZ2IV6tqoMj5+6HRXRroHAHwsLWVvrTLaCdIBeeFsV1UPVfXJk1IcLnpiNiiUJJcJg5fSFddvFgRgX/p1RSrYOyR7Wy8Ze6+Di1HrhcmEA6UEXFc00qTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPB7ev08; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711583456; x=1743119456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=555FLQQPCqRByogTrhuwRKGtsnTbnc0NbOQL9lfPUnE=;
  b=XPB7ev080NjuvRwgLnb6BE1VUbM9E2eaCAVQNiQutYTO6/0cCrDu5vgI
   Bv9gMEQF3ZdBc0Ttjrq6N8J6+HKELt8w6csl5rwg5BCgA7oQhTFAQfCOX
   n1vL84bpSMzYpwhWtQ2lMrFZgQIjTCCsgc2udEi4jBHwvi45UYDS1Rfdj
   hi1azgw9NrF47fNZid7xELxQTQOuyVJuzN82BwWDf39SFjy3kpbNwBFYw
   5jxQRdihCHlJ8CFXEgmO97xkF/IgxJBjezSBAbtTY5bZzN7lVfz+UHl/l
   OVoLoLlETmToZnNHJS1QJxcZMwLxpT/V4BbIzYQasIoHzCQr+WsodgH9d
   Q==;
X-CSE-ConnectionGUID: azEOulgzRoKpOi8GuLhliw==
X-CSE-MsgGUID: MqEGdt59Tuq96cdNsbILOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6848296"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6848296"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 16:50:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16862293"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 16:50:55 -0700
Date: Wed, 27 Mar 2024 16:50:54 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 046/130] KVM: x86/mmu: Add address conversion
 functions for TDX shared bit of GPA
Message-ID: <20240327235054.GH2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <973a3e06111fe84f2b1e971636cbaa3facf7b120.1708933498.git.isaku.yamahata@intel.com>
 <b07d0749-8a72-4a0a-a0ad-808d7ea2b922@intel.com>
 <6052c6cd-635e-483a-90e2-d66beb1bb91b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6052c6cd-635e-483a-90e2-d66beb1bb91b@linux.intel.com>

On Wed, Mar 27, 2024 at 10:09:21PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/27/2024 11:08 AM, Chenyi Qiang wrote:
> > 
> > On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
> > > indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> > > GPA.shared is set, GPA is covered by the existing conventional EPT pointed
> > > by EPTP.  If GPA.shared bit is cleared, GPA is covered by TDX module.
> > > VMM has to issue SEAMCALLs to operate.
> > > 
> > > Add a member to remember GPA shared bit for each guest TDs, add address
> > > conversion functions between private GPA and shared GPA and test if GPA
> > > is private.
> > > 
> > > Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
> > > kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
> > > the new member to remember GPA shared bit is guaranteed to be zero with
> > > this patch unless it's initialized explicitly.
> > > 
> > > 			default or SEV-SNP	TDX: S = (47 or 51) - 12
> > > gfn_shared_mask		0			S bit
> > > kvm_is_private_gpa()	always false		true if GFN has S bit set
> > TDX: true if GFN has S bit clear?
> > 
> > > kvm_gfn_to_shared()	nop			set S bit
> > > kvm_gfn_to_private()	nop			clear S bit
> > > 
> > > fault.is_private means that host page should be gotten from guest_memfd
> > > is_private_gpa() means that KVM MMU should invoke private MMU hooks.
> > > 
> > > Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > ---
> > > v19:
> > > - Add comment on default vm case.
> > > - Added behavior table in the commit message
> > > - drop CONFIG_KVM_MMU_PRIVATE
> > > 
> > > v18:
> > > - Added Reviewed-by Binbin
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >   arch/x86/include/asm/kvm_host.h |  2 ++
> > >   arch/x86/kvm/mmu.h              | 33 +++++++++++++++++++++++++++++++++
> > >   arch/x86/kvm/vmx/tdx.c          |  5 +++++
> > >   3 files changed, 40 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 5da3c211955d..de6dd42d226f 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1505,6 +1505,8 @@ struct kvm_arch {
> > >   	 */
> > >   #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> > >   	struct kvm_mmu_memory_cache split_desc_cache;
> > > +
> > > +	gfn_t gfn_shared_mask;
> > >   };
> > >   struct kvm_vm_stat {
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index d96c93a25b3b..395b55684cb9 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -322,4 +322,37 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
> > >   		return gpa;
> > >   	return translate_nested_gpa(vcpu, gpa, access, exception);
> > >   }
> > > +
> > > +/*
> > > + *			default or SEV-SNP	TDX: where S = (47 or 51) - 12
> > > + * gfn_shared_mask	0			S bit
> > > + * is_private_gpa()	always false		if GPA has S bit set
> 
> Also here,
> TDX: true if GFN has S bit cleared

Oops. Will fix both.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

