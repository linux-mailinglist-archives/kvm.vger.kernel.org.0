Return-Path: <kvm+bounces-26749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3632976EA3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 457441F24B58
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75B11531D2;
	Thu, 12 Sep 2024 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DrHu0hsJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AE81448C1;
	Thu, 12 Sep 2024 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726158295; cv=none; b=EykMHXPbTwtV16roSRRoxD4GVxULkzCHPJKUQV4hlqcjqWccCf4X2/A/Tb3lvuseyUpYVV6HDOfvJgKbvle1LlibgG6HdW5UPr64MTpzwlgMSGhbJEaQ5F5GhPObA15a+kDyDuyqNr8YV6ar8X1cBptHiZ5CACFsv4/N2MXA6dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726158295; c=relaxed/simple;
	bh=CHEVBjIBBe7uiVAfeq59Zm3quIP3T9dxsy24PDWRhAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPy9UfJy8kBaw2bqmErL5jIl0u+/BOD0eXsVvo/UT7UnsSUxUi7uw47rl8QIqNJObyX4r3vEZjwZlduTxYufboAhrALSWK3vJd4kIn7MY9bw7u/2k6gbIQ2rTm569fPEg58ct4XTYitAJqzcs6PWtqw25Lit8ILljzE5/oOsJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DrHu0hsJ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726158293; x=1757694293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CHEVBjIBBe7uiVAfeq59Zm3quIP3T9dxsy24PDWRhAY=;
  b=DrHu0hsJBvp6/9fjVfApWAKIpowdSUBjAd2eEpN4mb0CovmqX1a09EGm
   D6GcVxeHTvZ5yLy73YQ0uZYstRb3z34biL9FCGduYDbKvv32u2i7A7FtH
   Dbf5X5GBoEQcR2D+FmjzBEjpAu2CuaS+5aYj4Qy0ZrC0xr0qenvIUksCJ
   qLLGCayPVjrW+unRfdvFI9b1yuWBTujtySyfT7d0VPG6/79BDXYM5Et1e
   5U2VGVeyjrEg5sADptjrhwGhht1LDP+mMLGZCKpC0uBovOjXG2l2kr/nE
   p8s/+0bsh0xzoBIUjCk0b6gi8pRAb1t2q9hn6xZpWIM4oUDqqw0gjr6CK
   Q==;
X-CSE-ConnectionGUID: favFiimUTVafdXY+Noh3pQ==
X-CSE-MsgGUID: dTVMRuZDQXGn+hjTTq9B3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="25220812"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="25220812"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 09:24:53 -0700
X-CSE-ConnectionGUID: OQsqQzHLQxCnxvy+2i4sKA==
X-CSE-MsgGUID: OuV2X7C9REi0ZHRY43coRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="67465615"
Received: from merlinax-mobl.amr.corp.intel.com (HELO desk) ([10.125.147.150])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 09:24:52 -0700
Date: Thu, 12 Sep 2024 09:24:40 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
	chao.gao@intel.com
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Message-ID: <20240912162440.be23sgv5v5ojtf3q@desk>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>

On Thu, Sep 12, 2024 at 03:44:38PM +0000, Jon Kohler wrote:
> > It is only worth implementing the long sequence in VMEXIT_ONLY mode if it is
> > significantly better than toggling the MSR.
> 
> Thanks for the pointer! I hadn’t seen that second sequence. I’ll do measurements on
> three cases and come back with data from an SPR system.
> 1. as-is (wrmsr on entry and exit)
> 2. Short sequence (as a baseline)
> 3. Long sequence

I wonder if virtual SPEC_CTRL feature introduced in below series can
provide speedup, as it can replace the MSR toggling with faster VMCS
operations:

  https://lore.kernel.org/kvm/20240410143446.797262-1-chao.gao@intel.com/

Adding Chao for their opinion.

