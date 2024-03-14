Return-Path: <kvm+bounces-11805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 418B187C166
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:38:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5AA0B21645
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990DE74401;
	Thu, 14 Mar 2024 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iws/2AUw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC111E529;
	Thu, 14 Mar 2024 16:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710434277; cv=none; b=o6oN4cXR1bgib0FUO8sebojMZjHnoPVeLI3OJBpkwzxzl3XyxGSq2jYSnYnu8pK5DNox7R8LB5K62VsDlTT+7opYQ2Q584UImLaBJwKSJJmKpA/uaM0wv8x+STTJQr4aLQjD02P48YAnp1Lypxd0DASdDVBcWYj+AAEsvPJ7si0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710434277; c=relaxed/simple;
	bh=89SB6/Lm3nQq91hRbocRMx7TBx2IIowK8lQdEgFpcVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdX1sIivNEGVzoU4xYjSuaeV62j+HkdFYjCqr+pSRoQZqOz4lSZ7Y+S/ZVX5Tn6bUt61IU2DQG5vZTp8k6CLXD1OeWkxMLuht+zkwwxdXxR9r2SUW8QGKKRzEOdUmqm3n6O17oaMDAMIKKfGY1rlxbFzndMQhb9RMi5JfUF7z38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iws/2AUw; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710434276; x=1741970276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=89SB6/Lm3nQq91hRbocRMx7TBx2IIowK8lQdEgFpcVM=;
  b=Iws/2AUwBi09CfgV6XqwYxyDEKyvjLahJRzNrEHQWho6dxkXN6iUgnma
   Rw2BoWxiC9AKYlnKPtwLUiFXCUMmxbFTXRU7nli76FihOf2DVlBXxIvUl
   jVgHSS3gZm2qqMo/5pYLNhVRLqzCpX1GQTg7e1XGcU+s8zWiZrQ5bzsSq
   4Dmoix+tPLHlqI0yTepWpcoYcXX6Vogzbydq4f8JoDk0J26jGqoqfhaR5
   bzaDB2W2OvNA0iiJPcmiEZvxn5S3CbLQD2PIY85XKsQWwB1YPg0rZS1JR
   tnldyN/WdvhO4g6inlk7FfHSKu0STgXa4brxxo5SgCz0OAnNNAfYuxl5x
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5135704"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="5135704"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:37:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="12749010"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:37:55 -0700
Date: Thu, 14 Mar 2024 09:37:53 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Message-ID: <20240314163753.GP935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
 <1ae483bc-b279-44ca-b396-04aa480e3781@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ae483bc-b279-44ca-b396-04aa480e3781@linux.intel.com>

On Thu, Mar 14, 2024 at 02:21:04PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 18aef6e23aab..e11edbd19e7c 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -5,6 +5,7 @@
> >   #include "vmx.h"
> >   #include "nested.h"
> >   #include "pmu.h"
> > +#include "tdx.h"
> >   static bool enable_tdx __ro_after_init;
> >   module_param_named(tdx, enable_tdx, bool, 0444);
> > @@ -18,6 +19,9 @@ static __init int vt_hardware_setup(void)
> >   		return ret;
> >   	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > +	if (enable_tdx)
> > +		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> > +					   sizeof(struct kvm_tdx));
> >   	return 0;
> >   }
> > @@ -215,8 +219,18 @@ static int __init vt_init(void)
> >   	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> >   	 * exposed to userspace!
> >   	 */
> > +	/*
> > +	 * kvm_x86_ops is updated with vt_x86_ops.  vt_x86_ops.vm_size must
> > +	 * be set before kvm_x86_vendor_init().
> 
> The comment is not right?
> In this patch, vt_x86_ops.vm_size is set in  vt_hardware_setup(),
> which is called in kvm_x86_vendor_init().
> 
> Since kvm_x86_ops is updated by kvm_ops_update() with the fields of
> vt_x86_ops. I guess you wanted to say vt_x86_ops.vm_size must be set
> before kvm_ops_update()?

Correct. Here's an updated version.

       /*
        * vt_hardware_setup() updates vt_x86_ops.  Because kvm_ops_update()
        * copies vt_x86_ops to kvm_x86_op, vt_x86_ops must be updated before
        * kvm_ops_update() called by kvm_x86_vendor_init().
        */
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

