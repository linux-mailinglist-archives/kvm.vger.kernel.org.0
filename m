Return-Path: <kvm+bounces-34533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2021EA00B73
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 16:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F034416371D
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 15:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604CE1FA838;
	Fri,  3 Jan 2025 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iDt79RED"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477F81FA24A
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735918281; cv=none; b=hflgssIPjNuqKWpUGNFG7SdTIAi8Sf9Fkr3RPSHP9aZGOjPqgnxQtft7x7ZkhMcPhFnPp2dx3LJdYzt4isYRE+KBiyzVpPQ1SFPrAa/9ofMu9VTGCVJ35iRN8vewVriPKc3UV1QU/YWM92fUt0r/kgVFO+6ozEZUPKJ5PmPqehw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735918281; c=relaxed/simple;
	bh=UxzyePBqFZ2gnpbI9K6VX5Sh4Z2rlQhso6W0tOBdMno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzXqbFsUfic9fIxvo58+9K1uAquwxX9CFKvdZazKHnhhl+zen5y2a2KUkDfh4Jx+HXrYuxp//hLeWD0CMY89QQrUMu3fTybBL9nvt6hn27NPl6O8MHTqlIUfNtlXt0n2XwqJKOF5G+v3BupCkfxxskuyscRvPFSuwaPanChlh3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iDt79RED; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735918278; x=1767454278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UxzyePBqFZ2gnpbI9K6VX5Sh4Z2rlQhso6W0tOBdMno=;
  b=iDt79REDXin+L++uBEUE6X2FAYMKuKW5RLIuYcOITe40NTGt5M/ejLCs
   dhKLqVlobM+rMWKVcG4F6N2dnC/STgWXzdK5zZl+YUU24IMhwA+BkihQp
   p+AaFlmhCEQpuJ5tPF0pJApBew4DH01xMkoPG0DRB2HtqFRjr7TPiQzZ+
   kwMEevhPiBG6crQVD9Z7zlkEgpV3aojDU202vNbFn73MYPUjMwkBSK5Kd
   ecp/QAc3lFRfWAHub7zUetuqLfUbfy/fmtRXN9GIX9OfCL4NKAvpkBTnH
   E5wrWa/B60Gf00yCCtSSRk0u1j8gmDLw4Ra2lYT+jQVC4Ro2AeFy1EFm/
   g==;
X-CSE-ConnectionGUID: HyEk1X3cTFCnCbfno5M+yA==
X-CSE-MsgGUID: KqmVfjmNTd+Syg2F2ncxcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="39847827"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="39847827"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 07:31:17 -0800
X-CSE-ConnectionGUID: duyNQYX0Sv6TDimdUERQGA==
X-CSE-MsgGUID: JRXouV0sStKa4cn3i3YZDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="132668761"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 03 Jan 2025 07:31:13 -0800
Date: Fri, 3 Jan 2025 23:50:00 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: Rob Herring <robh@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	"Daniel P . Berrang" <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe Mathieu-Daud <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
Message-ID: <Z3gHKEalN6sLv8Mf@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
 <44212226-3692-488b-8694-935bd5c3a333@redhat.com>
 <Z2t2DuMBYb2mioB0@intel.com>
 <20250102145708.0000354f@huawei.com>
 <CAL_JsqKeA4dSwO40VgARVAiVM=w1PU8Go8GJYv4v8Wri64UFbw@mail.gmail.com>
 <20250102180141.00000647@huawei.com>
 <Z3efFsigJ6SxhqMf@intel.com>
 <20250103140457.00004c4b@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250103140457.00004c4b@huawei.com>

> > > > You asked me for the opposite though, and I described how you can
> > > > share the cache. If you want a cache per thread, then you probably
> > > > want a node per thread.
> > > > 
> > > > Rob
> > > >   
> > > 
> > > Hi Rob,
> > > 
> > > That's right, I made the mistake in my prior message, and you
> > > recalled correctly. I wanted shared caches between two threads,
> > > though I have missed your answer before, just found it.
> > >   
> > 
> > Thank you all!
> > 
> > Alireza, do you know how to configure arm node through QEMU options?
> 
> Hi Zhao, do you mean the -smp param?
>

I mean do you know how to configure something like "a node per thread"
by QEMU option? :-) I'm curious about the relationship between "node"
and the SMP topology on the ARM side in the current QEMU. I'm not sure
if this "node" refers to the NUMA node.

Thanks,
Zhao


