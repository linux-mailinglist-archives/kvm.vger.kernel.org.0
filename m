Return-Path: <kvm+bounces-23941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B5C94FDA4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BD79284469
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADC63B290;
	Tue, 13 Aug 2024 06:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mbQBxQVd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B6A3A8CE;
	Tue, 13 Aug 2024 06:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723529695; cv=none; b=ffMy6lWpoTR0yL2Cr8N7dJbPoJkX3TebNiJ08P/vcNm+X4jAUSqpTXgyUgmbL2uMC8yteMy1wyNxmxSqom4HCw89U+aZPd84HFKhBkT2bvGLQPT1GSAd5LiXAR0Kv0/4aGA1lwzjRVI9IyYWuosZtEMQKHFuKv7Mc26FEIn+J94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723529695; c=relaxed/simple;
	bh=5ay8FA//8SIC8Nqg5Eoh/xnR6B/GaJhByOWfLrKMpS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l169PVYVVYy+yN0MV5SoZa3IBskhQ7BjRNMcxn2CYJKV3nbK9zdbTKWb8zUWFY1DnIXnc2ddk7oXtgj6oMZrm2EmSmlrJNKMFozYrYucAwbQXb2+wFRcBLdyyhGaRyVLCECSTvkMM0hO0e902cABQnrFubIls85qQoTZnpX0KF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mbQBxQVd; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723529695; x=1755065695;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5ay8FA//8SIC8Nqg5Eoh/xnR6B/GaJhByOWfLrKMpS0=;
  b=mbQBxQVd1mhCWiA4UN/V/x2mBNUGrDxfXzosHK4GhepBww7NJogt3p9q
   W94YJrU1EtT4J9HlaA4Advc2oS3Mk1Jm1e95ZEqXqCR20J5Oo+DaAkw2o
   SLofp+ygCG1+F4MGYsGFvWMdrsowuAvyUK2Fnez18pfC9yjfwhYikxhSy
   rtpLMtxE58bwsJrLEHXmihQ7FWsJO9BO2EA1lI8rV1tqOKspzzVn0eA/B
   DL5xBF0BXQ0x5b8IT8fAn0qTlaJ4RWCnI++4hfBBKnpmsMfSyS/8r9bn4
   0wDagOMUDQ5k90BFq8Ro9NdAQRnXfrZGyNU+/WtGCl4RIKE9wHtM4kmC0
   g==;
X-CSE-ConnectionGUID: HaRfXuxLQ/+M8zY4wwFJJg==
X-CSE-MsgGUID: 4EPVSYhSRbmZ2QrqzIYpEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21530010"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21530010"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:14:54 -0700
X-CSE-ConnectionGUID: 82YwJJY4QSG2oSKKBcmHWQ==
X-CSE-MsgGUID: BAlJ7PBWTiC/TMILMM4g/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="62717449"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa003.fm.intel.com with ESMTP; 12 Aug 2024 23:14:52 -0700
Date: Tue, 13 Aug 2024 14:14:51 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com, michael.roth@amd.com
Subject: Re: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Message-ID: <20240813061451.obyytu2rrm6mrmqj@yy-desk-7060>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-2-binbin.wu@linux.intel.com>
 <20240813055614.ndlrtint75ancbno@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813055614.ndlrtint75ancbno@yy-desk-7060>
User-Agent: NeoMutt/20171215

On Tue, Aug 13, 2024 at 01:56:14PM +0800, Yuan Yao wrote:
> On Tue, Aug 13, 2024 at 01:12:55PM +0800, Binbin Wu wrote:
> > Check whether a KVM hypercall needs to exit to userspace or not based on
> > hypercall_exit_enabled field of struct kvm_arch.
> >
> > Userspace can request a hypercall to exit to userspace for handling by
> > enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
> > hypercall_exit_enabled.  Make the check code generic based on it.
> >
> > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 4 ++--
> >  arch/x86/kvm/x86.h | 7 +++++++
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index af6c8cf6a37a..6e16c9751af7 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  	cpl = kvm_x86_call(get_cpl)(vcpu);
> >
> >  	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> > -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> > -		/* MAP_GPA tosses the request to the user space. */
> > +	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
> > +		/* The hypercall is requested to exit to userspace. */
> >  		return 0;
> >
> >  	if (!op_64_bit)
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 50596f6f8320..0cbec76b42e6 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> >  			 unsigned int port, void *data,  unsigned int count,
> >  			 int in);
> >
> > +static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
> > +{
> > +	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
>
> How about:
>
> if (!(BIT(hc_nr) & KVM_EXIT_HYPERCALL_VALID_MASK))
>
> KVM_EXIT_HYPERCALL_VALID_MASK is used to guard kvm->arch.hypercall_exit_enabled
> on KVM_CAP_EXIT_HYPERCALL, "hc_nr > maximum supported hc" AND "hc_nr <=
> bit_count(kvm->arch.hypercall_exit_enabled)" should be treated as invalid yet to
> me.

Not real good idea. Rely on hypercall_exit_enabled is good enough, this brings
unnecessary complexity.

>
> > +		return false;
> > +
> > +	return kvm->arch.hypercall_exit_enabled & (1 << hc_nr);
>
> BIT(xx) instead of "1 << hc_nr" for better readability.
>
> > +}
> >  #endif
> > --
> > 2.43.2
> >
> >
>

