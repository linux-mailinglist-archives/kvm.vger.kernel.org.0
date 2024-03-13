Return-Path: <kvm+bounces-11756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 630BB87B01E
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 19:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18DB61F2A429
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 18:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9538A12DDA5;
	Wed, 13 Mar 2024 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="izpRVTxV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B62464CC0;
	Wed, 13 Mar 2024 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710351385; cv=none; b=B3qBwx4qVZTw0d+xVflCTz/gi1Xm8HayBc0Zz5ZseJEzOe5BxXLxrYKPQ5YOKUMaBzXzP/sug5jzI2bSR/jWIdqqgd6OTgLd9t+fsXd36N7fGh5PE5gYoIn409AzHRK1Wq2GAReg2soA7m4JfqYxAe3mF9UXtvb657ohh1RkN1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710351385; c=relaxed/simple;
	bh=nZMYaUvF26Y3Smoh3i1Q4mGy+mqD5+JQOlRmXnRyUio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQJN1mIv4TiR4oWfjweS9aL9ELTt7h6n3FrUm68ZI4QNkhfW2J2Ft+WE6Mo5lnoSJ2J/UZ3rJ/ku3t8kaou+jr7z9jK3kdEuo2R32a3fjqdnanqiQhi++JcnELRa1h+Sr0dns9LOioF6mbgjPIbaASHDIkPGBGDspgHrATK4D14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=izpRVTxV; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710351384; x=1741887384;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nZMYaUvF26Y3Smoh3i1Q4mGy+mqD5+JQOlRmXnRyUio=;
  b=izpRVTxVvn2qYWAUhKJWo/gwGnkVLF2t66+90FH/wczmimg8ymVt9J9c
   j47B0nv60Gnk2LTA8GPZWlOGAJ3udw7vg7mm2gDUmDC4nVCFmXicODQw+
   e/D4ZzDlVistcLxfH6L56ou7VNkUh7S1QvikQgc+hit+rLE64GolELrpI
   pdUJb2KOCMRCNfcQ5Q7mazGZ8IKYujq5gKMxagwg3EpKNQkCqMZ8KsHPr
   8CWZqOw1gJ40w32u9yfFokt1/Ctto90Aju8UMYDu0TE2/ojvRSZ/6yoKn
   3WY08xCSuFRpusr6kXpjTOLh8AGYYQuF0j23ABuPYxG+1X3SV7r1weBAV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5000296"
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="5000296"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 10:36:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="12086180"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 10:36:22 -0700
Date: Wed, 13 Mar 2024 10:36:22 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 021/130] KVM: x86/vmx: initialize loaded_vmcss_on_cpu
 in vmx_init()
Message-ID: <20240313173622.GL935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c1b7f0e5c2476f9f565acda5c1e746b8d181499b.1708933498.git.isaku.yamahata@intel.com>
 <c6279239-fb9c-41ca-a628-c0dd1e8c08a3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c6279239-fb9c-41ca-a628-c0dd1e8c08a3@linux.intel.com>

On Wed, Mar 13, 2024 at 11:30:11PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
> > hardware_disable_all().  To allow hardware_enable/disable_all() before
> > kvm_init(), initialize it in before kvm_x86_vendor_init() in vmx_init()
> > so that tdx module initialization, hardware_setup method, can reference
> > the variable.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> 
> The shortlog should be this?
> KVM: VMX: Initialize loaded_vmcss_on_cpu in vmx_init()

Yes. I also will fix the shortlog in the next patch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

