Return-Path: <kvm+bounces-12918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B9988F3BD
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18B7F2A6B36
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902D410A1C;
	Thu, 28 Mar 2024 00:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="axSgu3pI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5D817;
	Thu, 28 Mar 2024 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586202; cv=none; b=OL3jiqniUZIABEl5RYDZZa0J0WNsBvvgZVFp8bMsH7Y+MHMYCeG9BBycOnfedd507bM5kUsLxcSBCL5rfaJ1d4Qgeoyxj81FxfsgVxA/AKOjJ/cPCb5dtfgAHNVKCw5mjA5g4Q2dN9/jZQG8RlGueRV+PGvwGykj+hnj5qzXabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586202; c=relaxed/simple;
	bh=bKy2b8DlGeDsZdgu01uYDVooRH0V8usjwDuPx2wkFeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViDXYriBLRe/nBPtrpomUICQeRt1xiub+EG7i+nScqTIuRAnOOPBTKu8x/ESEfqLQ6XrlS/CsyOHVITGLI8VaQqZJMyu9t3sfBZ2q0LSbZg3nI5NwTRltGEsBvTJRSjeumDWsYlCjJ2+Wl5tZbRZtgWrMaQ35+DXGLes6v8VchY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=axSgu3pI; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711586201; x=1743122201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=bKy2b8DlGeDsZdgu01uYDVooRH0V8usjwDuPx2wkFeY=;
  b=axSgu3pINFmv37lkmwRFemEsboFFSATzLbisc/0W+tlYCNnnJ+FADXuJ
   VBluXruQNqmAw8Puny6YberExQax+RPQUrFc65DCDFYLksrobfOYYh3+o
   e8KzwmZbEqd69AJ7aulCM/UKJvC76hxi+EJgC78oMz+QwPGgYKy7RM3Uz
   yG6XubL3bGDC0+7P/3d8p9zBrd6/2MJujf9rM2SzLiNfg+e96dXDpi403
   UVQ4pSgyJmwXktRDKbkCP+CZmObtMWgchacVUV+XOCkdHZPWZVjdX/q3Y
   K9qq33Sc4Wk8mgqPC+c2dkbeM4tm163PVgO9S5RMfWQkRYOJ2O5wMNBls
   w==;
X-CSE-ConnectionGUID: YwhkT75tSr+/lG7ggSTZHQ==
X-CSE-MsgGUID: uXuYcLYeS+mAqyXyuYF93w==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6583777"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6583777"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:36:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21121383"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:36:38 -0700
Date: Wed, 27 Mar 2024 17:36:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240328003637.GM2444378@ls.amr.corp.intel.com>
References: <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>

On Thu, Mar 28, 2024 at 08:06:53AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 3/28/2024 1:36 AM, Edgecombe, Rick P wrote:
> > On Wed, 2024-03-27 at 10:54 +0800, Xiaoyao Li wrote:
> > > > > If QEMU doesn't configure the msr filter list correctly, KVM has to handle
> > > > > guest's MTRR MSR accesses. In my understanding, the
> > > > > suggestion is KVM zap private memory mappings.
> 
> TDX spec states that
> 
>   18.2.1.4.1 Memory Type for Private and Opaque Access
> 
>   The memory type for private and opaque access semantics, which use a
>   private HKID, is WB.
> 
>   18.2.1.4.2 Memory Type for Shared Accesses
> 
>   Intel SDM, Vol. 3, 28.2.7.2 Memory Type Used for Translated Guest-
>   Physical Addresses
> 
>   The memory type for shared access semantics, which use a shared HKID,
>   is determined as described below. Note that this is different from the
>   way memory type is determined by the hardware during non-root mode
>   operation. Rather, it is a best-effort approximation that is designed
>   to still allow the host VMM some control over memory type.
>     • For shared access during host-side (SEAMCALL) flows, the memory
>       type is determined by MTRRs.
>     • For shared access during guest-side flows (VM exit from the guest
>       TD), the memory type is determined by a combination of the Shared
>       EPT and MTRRs.
>       o If the memory type determined during Shared EPT walk is WB, then
>         the effective memory type for the access is determined by MTRRs.
>       o Else, the effective memory type for the access is UC.
> 
> My understanding is that guest MTRR doesn't affect the memory type for
> private memory. So we don't need to zap private memory mappings.

So, there is no point to (try to) emulate MTRR.  The direction is, don't
advertise MTRR to the guest (new TDX module is needed.) or enforce
the guest to not use MTRR (guest command line clearcpuid=mtrr).  KVM will
simply return error to guest access to MTRR related registers.

QEMU or user space VMM can use the MSR filter if they want.


> > > > > But guests won't accept memory again because no one
> > > > > currently requests guests to do this after writes to MTRR MSRs. In this case,
> > > > > guests may access unaccepted memory, causing infinite EPT violation loop
> > > > > (assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
> > > > > the host. But I think it would be better if we can avoid wasting CPU resource
> > > > > on the useless EPT violation loop.
> > > > 
> > > > Qemu is expected to do it correctly.  There are manyways for userspace to go
> > > > wrong.  This isn't specific to MTRR MSR.
> > > 
> > > This seems incorrect. KVM shouldn't force userspace to filter some
> > > specific MSRs. The semantic of MSR filter is userspace configures it on
> > > its own will, not KVM requires to do so.
> > 
> > I'm ok just always doing the exit to userspace on attempt to use MTRRs in a TD, and not rely on the
> > MSR list. At least I don't see the problem.
> 
> What is the exit reason in vcpu->run->exit_reason? KVM_EXIT_X86_RDMSR/WRMSR?
> If so, it breaks the ABI on KVM_EXIT_X86_RDMSR/WRMSR.

It's only when the user space requested it with the MSR filter.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

