Return-Path: <kvm+bounces-46509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 145AAAB6EB1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 17:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DA54188917F
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49071C3BE2;
	Wed, 14 May 2025 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ckhv8/EH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2519341F
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234930; cv=none; b=uhPMQ1Fc4UiNEOG1PYfbG8Hz20IlFFvH5FQ8ejbR6gxH8FwGXR1w6n1TyBMl8NEhI8eDCyZcoAH76mRiTG8kWJvK3IjMBwqc/BX4BomqLTHRcciOCGKw6jsiH6MNbSRgljN3mJ3Cx/U6Q542LF8G3wR/bg1pho+GlLyZDHTSLFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234930; c=relaxed/simple;
	bh=zFXxawauuxtm7HBHWeV3O57mNyIF/zheVg9ulo2+hHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HaCH+dsGRqtvGrfAoKoMdY+yelSJkjxPw3KoFcvmPXnbt3vK2MiSrIsUhBoyTvIx1bsF4qx5EpVdSg1g3CLoNpHXaBhbNVxdMGr88fzDC03edgjVdCLWxVt+gJCJ5rF6TUUOSrcZcEl4RFLs+4QQ0FhxAfJTywPSNI/3xIN6VxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ckhv8/EH; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747234929; x=1778770929;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zFXxawauuxtm7HBHWeV3O57mNyIF/zheVg9ulo2+hHg=;
  b=Ckhv8/EHXO4Yt4Xd8c2WCTR+igAyFEc3M/SvhTDFbeC3irO4lrQkxZFX
   MkNvjH9nIgN2HGMVjfiDGjQ94lrgY8pqgsP1baWIcWOpsQJ//sI5JRKta
   2+sjYIKEDrrxnPNYZq8fjMZmepBqujIX/ibqhrakJPipzyZvgg1ZdOX+k
   DJUaXTP9McS495SHrB4hdXbES8pFNTiw945r3kcmhJpp2+gj0i4F0rG3H
   XDXhnTElCrcCOGUW1sw+nuOyUPf6IMffELxtIPqO0MJPdz8tghWGgMOGN
   S1UPpCQtDll1kVhVqaSqXnukpVF6Do/tUEnSdPGreiPBsgdHfY7VR9Xu7
   w==;
X-CSE-ConnectionGUID: eUi78bMJRuy0UDRnk8OARQ==
X-CSE-MsgGUID: zNcRqkqKQ2mGZ/+RHOq6HA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="49252084"
X-IronPort-AV: E=Sophos;i="6.15,288,1739865600"; 
   d="scan'208";a="49252084"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 08:02:08 -0700
X-CSE-ConnectionGUID: 1u1skXxNT/KxXkr/t6GMug==
X-CSE-MsgGUID: C+LSK1wxQ92J/Kt+Ibpnzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,288,1739865600"; 
   d="scan'208";a="138117958"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 14 May 2025 08:02:06 -0700
Date: Wed, 14 May 2025 23:23:09 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 06/10] i386/cpu: Introduce enable_cpuid_0x1f to force
 exposing CPUID 0x1f
Message-ID: <aCS1XVotdnLw+kqX@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-7-zhao1.liu@intel.com>
 <20250513144515.37615651@imammedo.users.ipa.redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513144515.37615651@imammedo.users.ipa.redhat.com>

Hi Igor, thanks for your review!

On Tue, May 13, 2025 at 02:45:15PM +0200, Igor Mammedov wrote:
> Date: Tue, 13 May 2025 14:45:15 +0200
> From: Igor Mammedov <imammedo@redhat.com>
> Subject: Re: [RFC 06/10] i386/cpu: Introduce enable_cpuid_0x1f to force
>  exposing CPUID 0x1f
> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
> 
> On Wed, 23 Apr 2025 19:46:58 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Currently, QEMU exposes CPUID 0x1f to guest only when necessary, i.e.,
> > when topology level that cannot be enumerated by leaf 0xB, e.g., die or
> > module level, are configured for the guest, e.g., -smp xx,dies=2.
> > 
> > However, TDX architecture forces to require CPUID 0x1f to configure CPU
> > topology.
> > 
> > Introduce a bool flag, enable_cpuid_0x1f, in CPU for the case that
> > requires CPUID leaf 0x1f to be exposed to guest.
> > 
> > Introduce a new function x86_has_cpuid_0x1f(), which is the warpper of
> > cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
> > to enable cpuid leaf 0x1f for the guest.
> 
> that reminds me about recent attempt to remove enable_cpuid_0xb,
>
> So is enable_cpuid_0x1f inteded to be used by external users or
> it's internal only knob for TDX sake?

TDX needs this and I also try to apply this to named CPU models. For
max/host CPUs, there are no explicit use cases. I think it's enough to
make named CPU models have 0x1f.

Then this should be only used internally.

> I'd push for it being marked as internal|unstable with the means
> we currently have (i.e. adding 'x-' prefix)

Sure, 'x-' is good. (If there is the internal property in the future,
I can also convert this unsatble property into internal one.)

This patch is picked from the TDX series, and in this patch Xiaoyao
doesn't make 0x1f enabling as property. In the next patch (RFC patch 7),
I add the "cpuid-0x1f" property. I'll rename that property as
"x-cpuid-0x1f".

> and also enable_ is not right here, the leaf is enabled when
> topology requires it.
> perhaps s/enable_/force_/

Thanks, I agree force_cpuid_0x1f is a better name.

@Xiaoyao, do you agree with this idea?

But probably TDX won't have v10 though, I can rename the field in my v2
after TDX.

Regards,
Zhao


