Return-Path: <kvm+bounces-17143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A140F8C1A11
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 01:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D0A428475F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 23:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECF7130E31;
	Thu,  9 May 2024 23:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vl8hPhxK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9AA8613B;
	Thu,  9 May 2024 23:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715298926; cv=none; b=Can7KmCkVGokgrgeCW8oy5EAMgQSguTpVCZTxFUV8HYV3MaOjYuyLHiP2XhUVGkpx7tGDS8hxyIEVyMlJOT0VMV9kM5TcziN5dFg9swjtkr1+Zdo0DwnzvpbHC6vAMfzWFXKxEm5EGnTpmrgNvyzFeW5Fs0riz1PWAtL5KYXeh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715298926; c=relaxed/simple;
	bh=7/soxTI+3MXWFVHgVh8iK/kBqfVXHC6t1BKr3iVMYRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jh11xQx1kaUaVwTu59Z+B6DzlfHbg6ob3Pltu8mcWPIO6b/NY2O0ZSzGug1XavbJeDlVZKyTNktkYPpxwbkoJfhYSi0Z2itkz7F+n+Yv298jxOkQYa7ggsbkv0Qj8B06Zymvn3/4Iew3RDYTFc9iWhh/dFEbaasrTgGqzTCDNuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vl8hPhxK; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715298924; x=1746834924;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7/soxTI+3MXWFVHgVh8iK/kBqfVXHC6t1BKr3iVMYRU=;
  b=Vl8hPhxK6l8uuBiz7sMkzGds0pszjSnWYt13y4ZyCF4IRGQzY9JKsfHL
   Hs/EXlwQ5Qd8Wr32Qeu1TEy/CAaiiQX20Q0WYOAGoLoOuUC9JXJrnaWbQ
   7rZ7kRMQMTwYHxxISauezT66HYnywUekLxT/WcnEGzAAs3XwJHIkENEL9
   kSYMIdsTuY6ggnEkTDrZyrFFlQDENYxKHaygNFvWLhYFw1MKGGd4mun0l
   1Ykk1RCEUaDVC2w0NoGI+rNLFNsnOcd3A8Vo/NuiPsjdi4COCaM5XWd1/
   hrz5SuFRKoXwH9jx7XlZ/DKToHASR9G/bVR/qakoa+praMwFDrH++fB8I
   w==;
X-CSE-ConnectionGUID: xTzUOELaT7y6CP03LshLhQ==
X-CSE-MsgGUID: wYvGOXVYRwi2K2ovrr4kDg==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11423875"
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="11423875"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 16:55:24 -0700
X-CSE-ConnectionGUID: SQhZUk6JRKqPuRsmQkuEuQ==
X-CSE-MsgGUID: MLGjs9O4SsGd6HsYNvbVkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="29977810"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 16:55:24 -0700
Date: Thu, 9 May 2024 16:55:22 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <20240509235522.GA480079@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com>
 <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
 <Zj1Ty6bqbwst4u_N@google.com>
 <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>

On Fri, May 10, 2024 at 11:19:44AM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 10/05/2024 10:52 am, Sean Christopherson wrote:
> > On Fri, May 10, 2024, Kai Huang wrote:
> > > On 10/05/2024 4:35 am, Sean Christopherson wrote:
> > > > KVM x86 limits KVM_MAX_VCPUS to 4096:
> > > > 
> > > >     config KVM_MAX_NR_VCPUS
> > > > 	int "Maximum number of vCPUs per KVM guest"
> > > > 	depends on KVM
> > > > 	range 1024 4096
> > > > 	default 4096 if MAXSMP
> > > > 	default 1024
> > > > 	help
> > > > 
> > > > whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
> > > > a 16-bit unsigned value:
> > > > 
> > > >     #define TDX_MAX_VCPUS  (~(u16)0)
> > > > 
> > > > i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
> > > > And _if_ it becomes a problem, we don't necessarily need to have a different
> > > > _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
> > > > being <= 64k.
> > > 
> > > Actually later versions of TDX module (starting from 1.5 AFAICT), the module
> > > has a metadata field to report the maximum vCPUs that the module can support
> > > for all TDX guests.
> > 
> > My quick glance at the 1.5 source shows that the limit is still effectively
> > 0xffff, so again, who cares?  Assert on 0xffff compile time, and on the reported
> > max at runtime and simply refuse to use a TDX module that has dropped the minimum
> > below 0xffff.
> 
> I need to double check why this metadata field was added.  My concern is in
> future module versions they may just low down the value.

TD partitioning would reduce it much.


> But another way to handle is we can adjust code when that truly happens?
> Might not be ideal for stable kernel situation, though?
>
> > > And we only allow the kvm->max_vcpus to be updated if it's a TDX guest in
> > > the vt_vm_enable_cap().  The reason is we want to avoid unnecessary change
> > > for normal VMX guests.
> > 
> > That's a frankly ridiculous reason to bury code in TDX.  Nothing is _forcing_
> > userspace to set KVM_CAP_MAX_VCPUS, i.e. there won't be any change to VMX VMs
> > unless userspace _wants_ there to be a change.
> 
> Right.  Anyway allowing userspace to set KVM_CAP_MAX_VCPUS for non-TDX
> guests shouldn't have any issue.
> 
> The main reason to bury code in TDX is it needs to additionally check
> tdx_info->max_vcpus_per_td.  We can just do in common code if we avoid that
> TDX specific check.

So we can make it arch-independent.

When creating VM, we can set kvm->max_vcpu = tdx_info->max_vcpus_per_td by
tdx_vm_init().  The check can be common like
"if (new max_vcpu > kvm->max_vcpu) error".

Or we can add kvm->hard_max_vcpu or something,  arch-common code can have
"if (kvm->hard_max_vcpu && new max_vcpu > kvm->hard_max_vcpu) error".
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

