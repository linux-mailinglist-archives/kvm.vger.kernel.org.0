Return-Path: <kvm+bounces-12521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2FF887278
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 19:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB37C1C21C07
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9841F612D1;
	Fri, 22 Mar 2024 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjvKDjRA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4667360EEA;
	Fri, 22 Mar 2024 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711130520; cv=none; b=JBT6k7Ru0H3xKR5TgM4W2lOtIyycRgJUNfW/lbbMjwww5uzAl2UhHgULtUTLap2bWniEy5tJNSo4auFGCJDvsxB/Mqfr1rnQNrCOpQo1uQ/qJb/EyhAs5Nnbsk97ueLIqhE1FsQIvoB4UPp/xlkMa57eIWCr98L9EfOOTzIO7kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711130520; c=relaxed/simple;
	bh=CrBkY7rJGNx/B1+kYRaEEWRhGnM321H+h3eef8L3DeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seCBxHSTQQwUjjDtSYFbVlvDlcpuxOQdIAO7Q54VT6D254NuKcWyQfl4dj5cQK+NipGoZv3iHL9yRW9dECzUL2dJMhnX6c6gFfJJKhn77AxcpOyg2xRjyCpyqPPHyUnSSJ/+LOV8kP7oY7/Patcuv2aQzHIq8856cwyLwaoAYDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjvKDjRA; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711130519; x=1742666519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CrBkY7rJGNx/B1+kYRaEEWRhGnM321H+h3eef8L3DeA=;
  b=CjvKDjRA6IZ5XzlG9WVf+TlXSOHD5Cerfec2L/szd8b5vKXJBJSKpwIO
   ytQGPb4lXYTPvDbnHXnVIhMXhnmZt2Rq5LqsYIFheVVn35FAth/FjLP+/
   UyKAUuqGi154Ewiwph1tOK7Hgz+WEGbLMOl3XkWaCmXKQrQ/Wf8imMbQC
   aPW15CbxVkMx07zZ5BqG11wiVB7L+AC4K1ZLbG+/+EPsQ4YlMnO3eTt3K
   eVrSeXxNCUs2pVEYyoaVPRStbWOsEqfeGRBug8/2LFQcZufro5jbT2aZb
   //Rokst3T6eqXuDY1f0+RFkoU7qCjmR2fytbi+tTqzNqZLFHO/sCugITL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6024357"
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="6024357"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 11:01:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="15652633"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 11:01:42 -0700
Date: Fri, 22 Mar 2024 11:01:41 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20240322180141.GZ1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>
 <20240314162712.GO935089@ls.amr.corp.intel.com>
 <5470a429-cbbd-4946-b11a-ab86380d9b68@linux.intel.com>
 <20240315232555.GK1258280@ls.amr.corp.intel.com>
 <e90e5993a565eaca9a567c00378b8486889ceb67.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e90e5993a565eaca9a567c00378b8486889ceb67.camel@intel.com>

On Thu, Mar 21, 2024 at 12:39:34PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Fri, 2024-03-15 at 16:25 -0700, Isaku Yamahata wrote:
> > > > > How about if there are some LPs that are offline.
> > > > > In tdx_hardware_setup(), only online LPs are initialed for TDX, right?
> > > > Correct.
> > > > 
> > > > 
> > > > > Then when an offline LP becoming online, it doesn't have a chance to call
> > > > > tdx_cpu_enable()?
> > > > KVM registers kvm_online/offline_cpu() @ kvm_main.c as cpu hotplug callbacks.
> > > > Eventually x86 kvm hardware_enable() is called on online/offline event.
> > > 
> > > Yes, hardware_enable() will be called when online,
> > > but  hardware_enable() now is vmx_hardware_enable() right?
> > > It doens't call tdx_cpu_enable() during the online path.
> > 
> > TDX module requires TDH.SYS.LP.INIT() on all logical processors(LPs).  If we
> > successfully initialized TDX module, we don't need further action for TDX on cpu
> > online/offline.
> > 
> > If some of LPs are not online when loading kvm_intel.ko, KVM fails to initialize
> > TDX module. TDX support is disabled.  We don't bother to attempt it.  Leave it
> > to the admin of the machine.
> 
> No.  We have relaxed this.  Now the TDX module can be initialized on a subset of
> all logical cpus, with arbitrary number of cpus being offline.  
> 
> Those cpus can become online after module initialization, and TDH.SYS.LP.INIT on
> them won't fail.

Ah, you're right. So we need to call tdx_cpu_enable() on online.  For offline,
KVM has to do nothing.  It's another story to shutdown TDX module.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

