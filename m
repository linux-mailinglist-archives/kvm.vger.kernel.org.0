Return-Path: <kvm+bounces-47773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F33AC4AEC
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:59:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0C96189F083
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D65224DCF4;
	Tue, 27 May 2025 08:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dJF13VJF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759A424DCE7
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336335; cv=none; b=S5kl1jAgSHXgS6EUmLnAndp3TT+QCp1mpA5OzepQpV2jI0qvccqhC1rF14yvtHnbr43wvkt/a3gWTwJUgpxzot7eSySeaGSorjnh1rIWuoED1QX4PcbyekT3JAsN1XUqhIAHfcq4CFcoJvdtkPKelJIJ/63TkBdXyYQ/0qxvok4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336335; c=relaxed/simple;
	bh=2gCAULFo/IOpFtt61/UupNVGk18dcBLikbAW8DfnHl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taWM4+3X5M/j3USCDuXS4Y3mNsLXKf0hyPOyiBGakz3hBkHhaqBTvTdbNtyLIS1OUDMsfQzs8pG3APQXkQUhqdY6ZWktXknvK41WeSTNTvKtrw1PwUVAb41Oh2OsRGOMY23gof+pUE0Zrx4kVwRoJ8mpO1/Ay8W4RD5FM04AynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dJF13VJF; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748336333; x=1779872333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2gCAULFo/IOpFtt61/UupNVGk18dcBLikbAW8DfnHl4=;
  b=dJF13VJF2+39XopbrETZAUKLrxr5Pxcnvyezv4V6NutBzEsWb5jyPZGZ
   y46ytgK4YYMQUvd4H4vhRtMjSLOpxpablJ9IAQpkdg40nTc8u3tMa//Rm
   /s7a9NRwD5bsjcKoMbE80eXyq8jolOSKGJmbMceli8XQ1l7r/gj+vEw12
   BLCOnGUHUd4lLEK2pZA5a/lqaIziFEotv2L9LsVicgj6OPhaH+UQXyt5M
   OTbQHB4E5HInpyJyf80XNr/uGUtZp6QY1ZoTDIWBI8ZjFUdqjeYtO1+u9
   Ad1mzht0jU3hLWxe2bDTZySfGeUUMBZEK8Ux/c9IVJIQycCCHy2l+YORz
   Q==;
X-CSE-ConnectionGUID: mHklkjHyRXuHVQkhpKTSBQ==
X-CSE-MsgGUID: KsYZtak0SxiByrwuqLJ2Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50473445"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="50473445"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 01:58:53 -0700
X-CSE-ConnectionGUID: JDtiriPCQa2w8bN8MvuNTA==
X-CSE-MsgGUID: Jqgwy1lvR2iu/TnDJffqmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="165919442"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 27 May 2025 01:58:49 -0700
Date: Tue, 27 May 2025 17:19:59 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model &
 topo CPUID enhencement
Message-ID: <aDWDvygfMR/cHJx2@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <c3ecc32c-badd-487e-a2df-0594661bc65e@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3ecc32c-badd-487e-a2df-0594661bc65e@zhaoxin.com>

On Mon, May 26, 2025 at 06:52:41PM +0800, Ewan Hai wrote:
> Date: Mon, 26 May 2025 18:52:41 +0800
> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
> Subject: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model &
>  topo CPUID enhencement
> 
> 
> 
> On 4/23/25 7:46 PM, Zhao Liu wrote:
> > Hi all,
> > 
> > (Since patches 1 and 2 involve changes to x86 vendors other than Intel,
> > I have also cc'd friends from AMD and Zhaoxin.)
> > 
> > These are the ones I was going to clean up a long time ago:
> >   * Fixup CPUID 0x80000005 & 0x80000006 for Intel (and Zhaoxin now).
> >   * Add cache model for Intel CPUs.
> >   * Enable 0x1f CPUID leaf for specific Intel CPUs, which already have
> >     this leaf on host by default.
> 
> If you run into vendor specific branches while refactoring the
> topology-related code, please feel free to treat Intel and Zhaoxin as one
> class. For every topology CPUID leaf(0x0B, 0x1F, ...) so far, Zhaoxin has
> followed the Intel SDM definition exactly.

Thank you for your confirmation. I'll post v2 soon (If things go well,
it'll be in the next two weeks. :-) )

Regards,
Zhao


