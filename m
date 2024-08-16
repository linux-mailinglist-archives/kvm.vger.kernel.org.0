Return-Path: <kvm+bounces-24348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F36595410C
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 967D0B24CEE
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 05:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB9A7EEF5;
	Fri, 16 Aug 2024 05:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BbBPMB+4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D82F43;
	Fri, 16 Aug 2024 05:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785523; cv=none; b=GW/sMHSzeQIUlyZjx/bkPvQp5TvlI5KCBzUkhkmnhGcP6dYMXn75FbALEE7HewfDk5VHVCpTJY1BV2j/bJ8fdXSvQHD76yAGxlLxSVonEUIMbyvrUGv/c5WCDy7jjECy9YvJlM3ijfU9cneMMalD7LMfinGnvmAC/Zyzz4frdJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785523; c=relaxed/simple;
	bh=uczEQFn0M+zJmibo6PmU1cMyOQuXQASNsXcWO/BLptk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1iPhbDzURZ/HwLji+Q+XujepYGiDbp0DIgGKcuMz9l07M3AGoQw/t52SYnfMjjeMgkPYBCtUQ0ey2RSUEFRPixjIBwQiXHf5zOQcsA608wKrHB9gxuESUjUM4COFBg9nnjvM5MtxxvKtbRJIPwgrY7OwjsQ4/lgG7R+IBaDF1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BbBPMB+4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723785522; x=1755321522;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uczEQFn0M+zJmibo6PmU1cMyOQuXQASNsXcWO/BLptk=;
  b=BbBPMB+4lMB3yDkVzdtLuOjDVlhzJ7m6tg5cDM4NRkbIzLh7pPqrrWUo
   Swxwece7Fiyajh7oGDwmjMOS0XdyDbaMp4w2i7Bzpr4Sf6TR2B85q3Scu
   9nYRyHDYCfajgh8o/bFfRzd3uUSl26Ut9sVc78Db76c7RdUjrOg7lFbnh
   YGf+J0thpR1rDZiEXDVx28JST4pAcj6m3L2BI5GqlVexp02i0+zgJWWAr
   wD5hv6OnsEjVjF8Tr6oGQMBIUCkGwcbyBdfL/sEauks0HUiOsv5GJlQAE
   XPRkuPsrhdenKAN+cjlOd3Ac8qNTILAfR+c5CcBBp07Vmdm+t6nttAW8i
   A==;
X-CSE-ConnectionGUID: 32Y7CZZCTCiKwoO/NGL0Kw==
X-CSE-MsgGUID: HpIUa98CTzisn7pmohTzHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="24974810"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="24974810"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 22:18:41 -0700
X-CSE-ConnectionGUID: JZ8RL1VAQ1y836N9uXnLcw==
X-CSE-MsgGUID: d3SEh16ERlK4NW/+VVwywg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="82774842"
Received: from ltuz-desk.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.186])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 22:18:37 -0700
Date: Fri, 16 Aug 2024 08:18:31 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/25] TDX vCPU/VM creation
Message-ID: <Zr7hJ9ytXT0G-ZvT@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <Zr2QI_JKj6gs1K3e@tlindgre-MOBL1>
 <148dec1f2d895581f4fec63359e475013ad40c6d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148dec1f2d895581f4fec63359e475013ad40c6d.camel@intel.com>

On Thu, Aug 15, 2024 at 11:46:00PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2024-08-15 at 08:20 +0300, Tony Lindgren wrote:
> > We can generate a TDX suitable default CPUID configuration by adding
> > KVM_GET_SUPPORTED_TDX_CPUID. This would handled similar to the existing
> > KVM_GET_SUPPORTED_CPUID and KVM_GET_SUPPORTED_HV_CPUID.
> 
> What problem are you suggesting to solve with it? To give something to userspace
> to say "please filter these out yourself?"

To produce a usable default CPUID set for TDX early on. That's before the
kvm_cpu_caps is initialized in kvm_arch_init_vm(), so I don't think there's
any other way to do it early. That is if we want to prodce a TDX specific
set :)

> From the thread with Sean on this series, it seems maybe we won't need the
> filtering in any case.

Yeah let's see.

> Sorry if I missed your point. KVM_GET_SUPPORTED_HV_CPUID only returns a few
> extra entries associated with HV, right? I'm not following the connection to
> what TDX needs here.

The the code to handle would be common except for the TDX specific CPUID
filtering call.

Regards,

Tony

