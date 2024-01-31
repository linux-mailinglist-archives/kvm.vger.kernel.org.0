Return-Path: <kvm+bounces-7542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 578EB843A6D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA4911F2AD0A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64D66DCEB;
	Wed, 31 Jan 2024 09:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h7/3s84I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D836027F;
	Wed, 31 Jan 2024 09:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692136; cv=none; b=hOrIp/H/q506mmfiQSM7eXBkTSG6U7s8OhfbmX2HRkr8ZUDY9SGJksjR4V/oB45cQPlmAPefunybst3/xhoVINiiJX5WMPhtqmYBKpR037RhBBz7UwJ9Gjp94ELuxbKSEXiULn1VjE7xFW+sTNC5GnsfcR597dMDELlgz7BosuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692136; c=relaxed/simple;
	bh=hxzRTdZxJSt3TvyZe6HqJcBulFzOOA/CYDt4I8ip2l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARCZzxtjh+d6DApGWw/i2EYl8aCiZSw++c2iGcdONKkW6ezMVQNV3CfuurlcvKuC3TUkJeHQqeXlukLePH4oOPGB22OJZ1SOqaY3/F66/cd/B9uS1TqjZkwFODcMtXPn1RJT1oIkkP1jcdnNsT+aAYuGoF9eUHYPiUk5FO2TSGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h7/3s84I; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706692133; x=1738228133;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hxzRTdZxJSt3TvyZe6HqJcBulFzOOA/CYDt4I8ip2l4=;
  b=h7/3s84IVSjc+w194EUXLr+YHeSzxAiiAHK3kCg7koKWHy0r4qI/07Vo
   v6PrCPbVM4BwAXKmNm3tyE6ziJWidZWqbMaRTV0i5SF6y7lX6qufGUW88
   kksp8ERcwA4Q7nn4ttc+G1ELFXCBpoczJSgcOqSKdG6GM3I/fMP+t8ovT
   3S5ldHEATqN9TidCzxR3U17CTSOY0mn/tSYRnTgSL/rjOUqeqWS2kPCye
   vQzokjEjka2cx+7b9Nqk9NN0M3tYB03M/b0yaFK6OzhahXb2SyF0oVdxB
   1uFK99Xegf7vwGONvLA0Y5SVDbJyArMxOp+P0Tg1EKQ/oBHD6T7FbnM4R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10207460"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="10207460"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 01:08:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="931776091"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="931776091"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2024 01:08:49 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 7A2316E4; Wed, 31 Jan 2024 10:39:14 +0200 (EET)
Date: Wed, 31 Jan 2024 10:39:14 +0200
From: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/cpu/intel: Detect TME keyid bits before setting MTRR
 mask registers
Message-ID: <bf3ptwhblztmal3c5b7jhjpohizw7q64th76pzit6rpgnewmo5@atq3oy6sp5vn>
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

