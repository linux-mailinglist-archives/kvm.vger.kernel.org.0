Return-Path: <kvm+bounces-33673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B9A9EFF27
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A93ED28290D
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 22:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAD81DC07D;
	Thu, 12 Dec 2024 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OoqcguUH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F71898FB
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 22:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041879; cv=none; b=BTy8VxQtxc4l0HDe3dl+3ip9t37kUEg4VDiTVcPJ3no3siyqeEaIB6Y9R/EUSb5s/13hMDPArPh+ikNm4c5XKGm3YyJGPU4KwYcBeDhdOENbmjMY3bLEz7qvqt2K+VBjtqLJZ3uZJbrErZX3Kztezp9Iwxs+ju+RZziFoU+8Yc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041879; c=relaxed/simple;
	bh=+hke1jTpTPORrYTONurCc0B9Riuzl04wqPrCFnU+0vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KX2omDpFqAGnd0MihhyxLQv2gLoQrtOI2j957sbBgnk+9aCGReejXdeNY6XUHiCN2cjqQiph/jkW5hJwvRS5W/jWQRID9C0K9EVTKoRVdzGV0GlCnSzKsVEvPBH95RFJqTdWFV7s4OdD8OupDmHiAgVC5DOTfgWecSII07+k2Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OoqcguUH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734041877; x=1765577877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+hke1jTpTPORrYTONurCc0B9Riuzl04wqPrCFnU+0vM=;
  b=OoqcguUH7a94KqUjbTc0NRirQy8Oy3QfqTGmXINQwONOmG7o4LCIZ03L
   mjihtM7TXi/rYG/XxWN0Faq3m4it3sDHcyXxyUtNe5qlAfSS/KUyaeBHG
   OuUV8mSdSrVZ4ne8xE1magHz8eqrI4p3e4lIBWLC2FbNGegC92yDAjO/s
   nCAsQkan9LQono7Ueb0/NOdAfGADAuumKvPWsJeZu4vZsRaK1daA4/aa1
   BLLdKR9x0sww3IOs0/GAg+K0+3FftTyXz82Z7ViKD+8WV4y4BhjdrB5/c
   QxpNc06+o3TohPcDdiVun4P1OerGJZsKvctLd11JqUEpqT8yU2CZ9MOgI
   A==;
X-CSE-ConnectionGUID: xjx4TkSbQ82410Gbv3T8gw==
X-CSE-MsgGUID: L1rbB33uQzWvsmcAB580+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34400114"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="34400114"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:17:56 -0800
X-CSE-ConnectionGUID: CCR3J1XKRlCFf6Bcr96NOQ==
X-CSE-MsgGUID: xJNdr9q+Qg+WsINy+GQKVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119604793"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:17:54 -0800
Date: Thu, 12 Dec 2024 16:17:53 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 36/60] i386/tdx: Force exposing CPUID 0x1f
Message-ID: <Z1thEdonGTThi7MX@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-37-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-37-xiaoyao.li@intel.com>

On Tue, Nov 05, 2024 at 01:23:44AM -0500, Xiaoyao Li wrote:
> TDX uses CPUID 0x1f to configure TD guest's CPU topology. So set
> enable_cpuid_0x1f for TDs.

If you squashed this into patch 35 I think it might make more sense overall
after some commit message clean ups.

Ira

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 289722a129ce..19ce90df4143 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -388,7 +388,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
>  
>  static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
>  {
> +    X86CPU *x86cpu = X86_CPU(cpu);
> +
>      object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
> +
> +    x86cpu->enable_cpuid_0x1f = true;
>  }
>  
>  static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
> -- 
> 2.34.1
> 

