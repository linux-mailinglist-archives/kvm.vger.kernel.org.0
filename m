Return-Path: <kvm+bounces-7553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13499843ADA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7CB28D8B1
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E28B69D37;
	Wed, 31 Jan 2024 09:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N2x9tabN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A45D6995D;
	Wed, 31 Jan 2024 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692505; cv=none; b=m9hjv7luIs9DvtwtqS0zFcdhICuCEjoSBkNhaGGLmmV7FY1zMRq1ZMwjbDWm1Pbo1NZvitKxl7pdFI2vsnBQLc/WNsdxvUrQvkdksJj9FxF9GmJjaxNmPGFDigrewd8MqCuwnax0Av7uFpTjzoaE0zUIpppxXdjTqLrAdlq9brY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692505; c=relaxed/simple;
	bh=hxzRTdZxJSt3TvyZe6HqJcBulFzOOA/CYDt4I8ip2l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4xT3ak4Rb9vo6k4gFrJv4OCJzmrRxX3b9eKoYTN63FWxpQSL5tpUg4ES+Kkf23bPPbTgE4g1zFCCi3Cozp69ZIY5+k173m/c4tVR+YOWiyaHuDC/yhFedMPzZnOtwfcA6ViNVjvMaYAffnLdofm7Ht0I9kVGOIRlMviQ735mMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N2x9tabN; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706692503; x=1738228503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hxzRTdZxJSt3TvyZe6HqJcBulFzOOA/CYDt4I8ip2l4=;
  b=N2x9tabN59nYSvbMWNiY8YH1HANWKKOdTmPn1hRlwAoo/m5Dp4jHaCKi
   ii6X5oAZUBGLLpVvw2i+wV6QeKvEVqybN1BtwkE685HUAlfL32wmaEeK0
   +Zn1w1arBlUb7jcDcJl1VKPSr/VmufnMGbHbCmgx4gqgTyqhjFJkAStgI
   Bhq92RFmUFJRISWpNaVYJ59WCApQZ4q4B5FsebzbZgteGSn9ZrYL4I6HX
   HcFQVIc7QiwDMQcsRGhzAZKDfNzD4udT3+y4AhSopA7CM0cA2E8bPVXiB
   vSWZEAZwrjz+fqNeaDoHFwYACaMU9d3hs6PlltQQO5IiXiea/RPblzEqQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="2479071"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="2479071"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 01:15:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="961555289"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="961555289"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 31 Jan 2024 01:14:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id E88812D5; Wed, 31 Jan 2024 11:12:41 +0200 (EET)
Date: Wed, 31 Jan 2024 11:12:41 +0200
From: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/cpu/intel: Detect TME keyid bits before setting MTRR
 mask registers
Message-ID: <ek5fc344zqxfzto2ntg3j62oqjdkcw4bcezgh5jdrx6bekte5s@urzw7ta2nm5n>
References: <20240130180400.1698136-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130180400.1698136-1-pbonzini@redhat.com>

On Tue, Jan 30, 2024 at 07:04:00PM +0100, Paolo Bonzini wrote:
> MKTME repurposes the high bit of physical address to key id for encryption
> key and, even though MAXPHYADDR in CPUID[0x80000008] remains the same,
> the valid bits in the MTRR mask register are based on the reduced number
> of physical address bits.
> 
> detect_tme() in arch/x86/kernel/cpu/intel.c detects TME and subtracts
> it from the total usable physical bits, but it is called too late.
> Move the call to early_init_intel() so that it is called in setup_arch(),
> before MTRRs are setup.
> 
> This fixes boot on some TDX-enabled systems which until now only worked
> with "disable_mtrr_cleanup".  Without the patch, the values written to
> the MTRRs mask registers were 52-bit wide (e.g. 0x000fffff_80000800)
> and the writes failed; with the patch, the values are 46-bit wide,
> which matches the reduced MAXPHYADDR that is shown in /proc/cpuinfo.
> 
> Fixes: cb06d8e3d020 ("x86/tme: Detect if TME and MKTME is activated by BIOS", 2018-03-12)
> Reported-by: Zixi Chen <zixchen@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Kai Huang <kai.huang@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I've seen the patch before, although by different author and with
different commit message, not sure what is going on.

I had concern about that patch and I don't think it was addressed.
See the thread:

https://lore.kernel.org/all/20231002224752.33qa2lq7q2w4nqws@box

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

