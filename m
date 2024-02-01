Return-Path: <kvm+bounces-7683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C731B845375
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 10:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CA78289AA8
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1852D15B0EC;
	Thu,  1 Feb 2024 09:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gYphGDPP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F9A15B0E2;
	Thu,  1 Feb 2024 09:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706778706; cv=none; b=hgwLTfzG7i/MOuENYeeJO0mqo6XwZf7v6TdqFa2WaLa3S6sKkxEJ1EAt0fEi5DjJ5giZkaxDc4qTvN7i1MSahzD6CvBQAH9StNkmHvMbVTEIpp7fu1R06w7shscGzI0Gk8jsk9i8m7pK/0Kd6qa30VDbeOIMWwCRb7T/cLtLnAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706778706; c=relaxed/simple;
	bh=d0QUE64pt164Gb922DtwPyKlQyM7T2wpfLolXVuFrVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GyUWj6V7xk488MWEfEsYvdEbj7W1qpifSqmyaZG2MOnL3ZjyDmZj2/aDfu7E0CP3RBVSKybGAsFRee3+Op94DdIc6fUXzv+b4RN2pTX1+y9lt2zhz/wkcG/5TLFNTCwp1azzCAoNOer0k9rCL2wZWQuizHtpa6Z5e+xtx4w0gds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gYphGDPP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706778704; x=1738314704;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d0QUE64pt164Gb922DtwPyKlQyM7T2wpfLolXVuFrVk=;
  b=gYphGDPPNcBTKGk5usgi+ZEV9J/LOq04Z5XX6SJ21D++N5bY6A++5iAD
   engs6rVkYkV32TGt+daTknu2VbbuBGOa9D0TvmqKcq/K4ecbC20bQgp1O
   0D1gnMtfJlsuTLFR7QynLWf2odavd+MJi+YZCbWBh1X6XGCWOW2mjBZnZ
   2f4t4zCuIksF4Oh52xZtjzSsy/XZZ+98k2WPZijoDvaxcgRzL7KrM9/et
   5p68b6jdQXW0jT6ImfGknonLzfZ3FbUvAePLzlq0FLDuQvNI7DmDCL7LR
   QiiiMLDWlmtgoxVHAYVjSwsoewPPvVSMdjRlYsrFlHtP13dQj0/QPdObk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="2785324"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="2785324"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 01:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="879056989"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="879056989"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Feb 2024 01:11:40 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 0363E8EA; Thu,  1 Feb 2024 10:34:48 +0200 (EET)
Date: Thu, 1 Feb 2024 10:34:48 +0200
From: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@kernel.org>, x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/cpu/intel: Detect TME keyid bits before
 setting MTRR mask registers
Message-ID: <qtzc3jejjsvxpa6sz3zgoelf77ejr7fioxdaw2o5ezuxevetks@kcwjgzp2gi2u>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <20240131230902.1867092-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131230902.1867092-3-pbonzini@redhat.com>

On Thu, Feb 01, 2024 at 12:09:02AM +0100, Paolo Bonzini wrote:
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
> This fixes boot on TDX-enabled systems, which until now only worked with
> "disable_mtrr_cleanup".  Without the patch, the values written to the
> MTRRs mask registers were 52-bit wide (e.g. 0x000fffff_80000800) and
> the writes failed; with the patch, the values are 46-bit wide, which
> matches the reduced MAXPHYADDR that is shown in /proc/cpuinfo.
> 
> Reported-by: Zixi Chen <zixchen@redhat.com>
> Cc: Adam Dunlap <acdunlap@google.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

