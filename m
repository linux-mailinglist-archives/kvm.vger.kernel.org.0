Return-Path: <kvm+bounces-25706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDB496938B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 404C71C22B3B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 06:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E74C1CF2BD;
	Tue,  3 Sep 2024 06:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcvodTCp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05771CDFDB;
	Tue,  3 Sep 2024 06:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725344504; cv=none; b=OzAUEzz59/0Xvcnfjiq6YZ9ilQuWUoPk4V6zMc+ACW2Ocw+Awt/8mxddIy732pVJD7c8lCiYxnSCa2azeGvDKUEQBgO7/G5iE/LQ/oUyTCD2yEstYwO4yaqiea5DmOxtuIHNReqq/NAv77aHd2qt0lBg86njcEAMmLJvwH1GONE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725344504; c=relaxed/simple;
	bh=TUm6Md9hq8i6W7VSECV3QMlNtJ365HsBvg9qlZ4dujQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzgnP3hVt+JMbIZozYMSuNrYCNaM/NlRV/vbXsf2sqYWxL1+8jvy/pR/h/igc96BIu7nlmgNYkYYCh/G9VmviW9yPhIjJ+5cVkY5/FzyJzriWpzwupN1KmFRiG/rtTI9TeOOUUIyB+bY6EVkoVJQvaeMY6Pl53/2vdBLdsi7ZV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcvodTCp; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725344503; x=1756880503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TUm6Md9hq8i6W7VSECV3QMlNtJ365HsBvg9qlZ4dujQ=;
  b=KcvodTCpS+RMBWSC+Epwr1OlkDFlRASCRD6Qkq177rrq6WiSe0y+MoSf
   TFEqsL1S6V8hsc8EIB8cOSgQ3VYLSCueAl5onvpoo/udYmQBhMZd0mouB
   WP/oggG/AGOgvnP0vLW2vnoZAEew8tyH8af9LU5m6ltHfGMr15/aVvMjb
   gWEsavnILUiPkhCv4WoZISc9iuZVMgAw6OtujSp2qgrRZBzdC+G4JRcgX
   UGYKJ6Gvn4zMQfzgZEMsTp1mpaafARPmOzDNXiKp26xcpQawiz8dyhCpL
   MCvIEGnT8h5UhlZvyjBkrmCfhWD+zwBHCa1jsJ3kXPdwZIlN3cJf89Vu+
   A==;
X-CSE-ConnectionGUID: A9E8YRofTUybNsyoVonG0Q==
X-CSE-MsgGUID: 8uLFDh2NQnS4w2FLcpN4CQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="24102253"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="24102253"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 23:21:42 -0700
X-CSE-ConnectionGUID: bcP4FGLFRT2Ioo80e4k+Ng==
X-CSE-MsgGUID: MHiwQC3ISdytBCZAcQw6yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="64426811"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.115])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 23:21:38 -0700
Date: Tue, 3 Sep 2024 09:21:33 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Message-ID: <Ztaq7YKVHSwfAzvJ@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
 <ZsK1JRf1amTEAW6q@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsK1JRf1amTEAW6q@linux.bj.intel.com>

On Mon, Aug 19, 2024 at 10:59:49AM +0800, Tao Su wrote:
> On Mon, Aug 12, 2024 at 03:48:16PM -0700, Rick Edgecombe wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > +		/*
> > +		 * Work around missing support on old TDX modules, fetch
> > +		 * guest maxpa from gfn_direct_bits.
> > +		 */
> > +		if (output_e->function == 0x80000008) {
> > +			gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> > +			unsigned int g_maxpa = __ffs(gpa_bits) + 1;
> > +
> > +			output_e->eax &= ~0x00ff0000;
> > +			output_e->eax |= g_maxpa << 16;
> > +		}
> 
> I suggest putting all guest_phys_bits related WA in a WA-only patch, which will
> be clearer.

The 80000008 workaround needs to be tidied up for sure, it's hard to follow.

> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -25,6 +25,11 @@ struct kvm_tdx {
> >  	bool finalized;
> >  
> >  	u64 tsc_offset;
> > +
> > +	/* For KVM_MAP_MEMORY and KVM_TDX_INIT_MEM_REGION. */
> > +	atomic64_t nr_premapped;
> 
> I don't see it is used in this patch set.

Yes that should have been in a later patch.

Regards,

Tony

