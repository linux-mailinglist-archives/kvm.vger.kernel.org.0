Return-Path: <kvm+bounces-12539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE834887657
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 02:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AF9E283AF9
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 01:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06839137E;
	Sat, 23 Mar 2024 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfTJQiSF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87917F;
	Sat, 23 Mar 2024 01:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711156423; cv=none; b=ACtOMqwzTKiJCBs2up48XBKNy5Qb3OEATzOHC5mG4Xjhqr/8vjkeMvzUqV/WYVYyIx3rSZrN+xdEUoyBWaLRCKcOx0mulmTAh6VWsQY+32XBD6ZQr6CcJQNyzv5/n3XCUJFXOHcisqWsD/IgoCgLIV4dqk6LJW8N/jF6JP4jMno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711156423; c=relaxed/simple;
	bh=xLbSewaaMbbKX1tVWSqvH2rtdDi0Pz86bI2N3o73M4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYZ+5/FTETUl4SEOVJxdpN8K16PnFZ/Ay/iV/m8Fc10cIV5mVEq3uiTtMrjs5LGJ11cqY9ylw4Y5e+5IIIVInnEAXghrtkWKsnDKRFsmdvAN5Mc7nNCgsnyjvGwhtKTvyLxdtKy3vzG+1/CIvBVVcve9e+ZJlBae9j3V7CgDWc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfTJQiSF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711156421; x=1742692421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xLbSewaaMbbKX1tVWSqvH2rtdDi0Pz86bI2N3o73M4M=;
  b=DfTJQiSF8a8XzyUjkedfHRrRebS2951wPFaOZ8yTFCVWl4MggEVFWF8i
   tUMp7CTrK3ux6DXOI18IpywbnE2ki+A9qlP4hFshrfqXpP9Bbywmm/TpG
   u6QDqJ0/go0zEntTw4jcGLbazW5jmxL8iBd461kBTzqZe8FN6SPGAvlk9
   hfyXTJ6RuzXol2sET9vmDDVZSytjNdP5wuXcP3vTinC/6/yReyeJzQPCt
   y92zZXtBWLMXqq5K09nbfqlD3LUhmQH+LpsMuU7uGgjtpUkjO0H1/Gu3M
   i+06tFdUGzFmeTkbvQW12XJq9HONudajvELwzjqv1KOMKTpAShaJVAR9l
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="16767976"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="16767976"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:13:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="38199045"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 18:13:39 -0700
Date: Fri, 22 Mar 2024 18:13:35 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Message-ID: <20240323011335.GC2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>

On Fri, Mar 22, 2024 at 12:36:40PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> So how about:

Thanks for it. I'll update the commit message with some minor fixes.

> "
> TDX has its own mechanism to control the maximum number of VCPUs that the
> TDX guest can use.  When creating a TDX guest, the maximum number of vcpus
> needs to be passed to the TDX module as part of the measurement of the
> guest.
> 
> Because the value is part of the measurement, thus part of attestation, it
                                                                           ^'s
> better to allow the userspace to be able to configure it.  E.g. the users
                  the userspace to configure it                 ^,
> may want to precisely control the maximum number of vcpus their precious VMs
> can use.
> 
> The actual control itself must be done via the TDH.MNG.INIT SEAMCALL itself,
> where the number of maximum cpus is an input to the TDX module, but KVM
> needs to support the "per-VM number of maximum vcpus" and reflect that in
                        per-VM maximum number of vcpus
> the KVM_CAP_MAX_VCPUS.
> 
> Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but doesn't
> allow to enable KVM_CAP_MAX_VCPUS to configure the number of maximum vcpus
                                                     maximum number of vcpus
> on VM-basis.
> 
> Add "per-VM maximum vcpus" to KVM x86/TDX to accommodate TDX's needs.
> 
> The userspace-configured value then can be verified when KVM is actually
                                             used
> creating the TDX guest.
> "


-- 
Isaku Yamahata <isaku.yamahata@intel.com>

