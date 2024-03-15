Return-Path: <kvm+bounces-11949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A018987D753
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:26:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1A4F1C21444
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99A2E5A4E5;
	Fri, 15 Mar 2024 23:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EYfTMfNb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0159B67;
	Fri, 15 Mar 2024 23:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710545160; cv=none; b=UQ42PkV/c1I3Pmkie2G87jVpoGizuBuouZl2JpdJh6CEiHtBNZPNYJ6VmBED98rHgk2YeCbiAW3MBxAABNLnUDbgKaYqUrs2/QyDLNWWiMohz0znK095SJM7QE7Vj7JMQUvm6TrqRjJ3vJHgGgDy3qmZp4xiduHmletXyghZT5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710545160; c=relaxed/simple;
	bh=UPjNS2zHcJlODwjwgS6A76kmOvOv2fnO9gCuNkKThz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XHZ6rWMaQl1lmRAoRxH09p+ZIr/DCt/BsUoQgT5gssLKWsqpxAoHJOoQlH1DkYdVrzsy2wcwowp9aaju3NMOuasih2mMjzWQu6rqlOOIBXwbqkGvXTESTKHzr0VOV96gNU1SdKyejSYDPtRNKoFcLQ8E/H5sbVadT7MThqgJq4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EYfTMfNb; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710545157; x=1742081157;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=UPjNS2zHcJlODwjwgS6A76kmOvOv2fnO9gCuNkKThz4=;
  b=EYfTMfNbTM7d+sHplm621rn6AFt++bdkEbUYslq1OMsMsodhgl5r7OQ6
   RWqF1LVl3TzuEa9qpFuUW5A/JY3+AMEiVYOSpWiA96XxFDEioZdmitRg9
   qeCzgAGMxqiab//n/3xCTl4wEfTk0CwQjtjDNICPRcxju45oFUlZmzaQe
   /bwvX3nP7vxoAkqBW98IuDMw3CKme3u1UrP6kb1T5dxeL8ua08wPsNJ3h
   aa/Idr7hyZtOjDhckgG4oUP5oX3IURKjiCO8Fwt3TnAXV2H4Sax9ggfmU
   2nU+dwzJaNGnvvzZDaOgK8iGHEgBFiZz24LbPo7obj96lFU7Xv59XzGQQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5643720"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="5643720"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 16:25:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="17534882"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 16:25:56 -0700
Date: Fri, 15 Mar 2024 16:25:55 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20240315232555.GK1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>
 <20240314162712.GO935089@ls.amr.corp.intel.com>
 <5470a429-cbbd-4946-b11a-ab86380d9b68@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5470a429-cbbd-4946-b11a-ab86380d9b68@linux.intel.com>

On Fri, Mar 15, 2024 at 12:44:46PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> On 3/15/2024 12:27 AM, Isaku Yamahata wrote:
> > On Thu, Mar 14, 2024 at 10:05:35AM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > > index 18cecf12c7c8..18aef6e23aab 100644
> > > > --- a/arch/x86/kvm/vmx/main.c
> > > > +++ b/arch/x86/kvm/vmx/main.c
> > > > @@ -6,6 +6,22 @@
> > > >    #include "nested.h"
> > > >    #include "pmu.h"
> > > > +static bool enable_tdx __ro_after_init;
> > > > +module_param_named(tdx, enable_tdx, bool, 0444);
> > > > +
> > > > +static __init int vt_hardware_setup(void)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	ret = vmx_hardware_setup();
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >    #define VMX_REQUIRED_APICV_INHIBITS				\
> > > >    	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
> > > >    	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> > > > @@ -22,6 +38,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> > > >    	.hardware_unsetup = vmx_hardware_unsetup,
> > > > +	/* TDX cpu enablement is done by tdx_hardware_setup(). */
> > > How about if there are some LPs that are offline.
> > > In tdx_hardware_setup(), only online LPs are initialed for TDX, right?
> > Correct.
> > 
> > 
> > > Then when an offline LP becoming online, it doesn't have a chance to call
> > > tdx_cpu_enable()?
> > KVM registers kvm_online/offline_cpu() @ kvm_main.c as cpu hotplug callbacks.
> > Eventually x86 kvm hardware_enable() is called on online/offline event.
> 
> Yes, hardware_enable() will be called when online,
> but  hardware_enable() now is vmx_hardware_enable() right?
> It doens't call tdx_cpu_enable() during the online path.

TDX module requires TDH.SYS.LP.INIT() on all logical processors(LPs).  If we
successfully initialized TDX module, we don't need further action for TDX on cpu
online/offline.

If some of LPs are not online when loading kvm_intel.ko, KVM fails to initialize
TDX module. TDX support is disabled.  We don't bother to attempt it.  Leave it
to the admin of the machine.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

