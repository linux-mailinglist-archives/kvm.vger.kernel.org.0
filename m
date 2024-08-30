Return-Path: <kvm+bounces-25458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7D096573E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C970B24717
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CC9150989;
	Fri, 30 Aug 2024 06:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhwYnLGs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A004E535DC;
	Fri, 30 Aug 2024 06:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997656; cv=none; b=mjNaVA1WlNFAuCDSdR1w7JiVkMqDp1vWDCyV6MSUrx0J8RIGNJiPYJEKhBBgPnPAzg1g0cmo79s9RBaybbYpu1VBlETDmUpeov6G8RiabmZ/clKJ7Q73hUu1SWaBYqiaaeHIJUgKx4GenDL6bIVsfE2aIe/wcUnnIrglJ3mfaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997656; c=relaxed/simple;
	bh=1ezEneNMPPs4x8UsDNuVhlkjEapBF3fd/to4sho4mOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rf3NQ+Iqs7sUq0fk8asyl/DcVyz/fc518fuhEgb1VyfGEBzQcMdFyiCoU54zAkOX0K6nTyA6E87JBrTfMUSuMO7mHJ6ilCPF9g7ncJBk3iGU7Y/LEnVTwuhgiz+FyWIfBjw0EjxU79JrjYZNYQL8nivekUXLNtcqOx1Udq1PxAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhwYnLGs; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724997655; x=1756533655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1ezEneNMPPs4x8UsDNuVhlkjEapBF3fd/to4sho4mOU=;
  b=dhwYnLGstxCFtxrSPeojsfiyxjm2P6o+QuczLI5/xPiwV9ZJVnb2NlK1
   9RlHu4LmHHV52jNqM8R6A9SP2ew/Y07B67AqkiJJ32uP4LSAdGxjx19sz
   A5/qSichBXtSgx8Jq7WDH4wRyqwEVcvCftfB7xlHrWO7Fhd5VSFz5Z4Cj
   Fwkrt1C36k6nVRRRscw8lReOf6WpzuMTvUeLPece+az8oI7oFRO88F2nb
   E9rcO/oQBLKhWhk91WyjVMqSlXeArQuuwEeLAcUIZyi3fjSKehAI5nNHr
   ykEcmeXSj5N1ou1Ia6JKc420836WModYzyyQte2TK+EcikPgQeo57uJqY
   w==;
X-CSE-ConnectionGUID: QssbJdNhR+C+ML/HQoj3PA==
X-CSE-MsgGUID: U6gEsM+RSwSL2w/lG+vFTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="41126154"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="41126154"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:00:54 -0700
X-CSE-ConnectionGUID: NV7nv2J7TuOegCadHEn11A==
X-CSE-MsgGUID: 2Psw7ocHTpe4ZSvekz2pJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="94539458"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:00:51 -0700
Date: Fri, 30 Aug 2024 09:00:46 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/25] KVM: TDX: Add place holder for TDX VM specific
 mem_enc_op ioctl
Message-ID: <ZtFgDrazxvF5KQix@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-9-rick.p.edgecombe@intel.com>
 <ZruLs4+EE5xHCAcp@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZruLs4+EE5xHCAcp@ls.amr.corp.intel.com>

On Tue, Aug 13, 2024 at 09:37:07AM -0700, Isaku Yamahata wrote:
> On Mon, Aug 12, 2024 at 03:48:03PM -0700,
> Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:
> 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index b1c885ce8c9c..de14e80d8f3a 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2,6 +2,7 @@
> >  #include <linux/cpu.h>
> >  #include <asm/tdx.h>
> >  #include "capabilities.h"
> > +#include "x86_ops.h"
> >  #include "tdx.h"
> >  
> >  #undef pr_fmt
> > @@ -29,6 +30,37 @@ static void __used tdx_guest_keyid_free(int keyid)
> >  	ida_free(&tdx_guest_keyid_pool, keyid);
> >  }
> >  
> > +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> > +{
> > +	struct kvm_tdx_cmd tdx_cmd;
> > +	int r;
> > +
> > +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> > +		return -EFAULT;
> > +
> > +	/*
> > +	 * Userspace should never set @error. It is used to fill
> 
> nitpick: @hw_error

Thanks will do a patch for this.

Tony

