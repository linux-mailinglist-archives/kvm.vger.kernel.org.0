Return-Path: <kvm+bounces-31605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C16FF9C5287
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8804D283AAA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B4F20E33B;
	Tue, 12 Nov 2024 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TZrc5F1o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877F1E4AD;
	Tue, 12 Nov 2024 09:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731405485; cv=none; b=Tz0hMVa1ThB6r4wTgyKyH8FRGn8oVTfpq10k6lQKMWNCUD9zx5TXFTprvuBHz/oDZCgePUALF8AaFGJsotCrRxMmxvDTOdFVjWA03MoHweeOzr7caBEnn82ozATFbVlgPQ8r2uFH52c1mQiNUtFc+Hy4rd4nIWKDfxwTaan6HR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731405485; c=relaxed/simple;
	bh=FYwKX44a4chADa+zBgV8O2gk95sOkV/2PizgSwnwgTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VckNfay3WLaaQbubzHn8G0h2Oc9uVqCxqV8G63Xh94mRLXYRJsNUOuciD/qXm9FnVAlzfYitNSZyXVxELPX2+WuVGE60M4ZWTiYHuDxQXPxPMSA9FG2lMLqC/F/zQzFrIGzg+coxgZtgyzuWqVaEDBkeH1RrCJ9HK2k81ulXqhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TZrc5F1o; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731405484; x=1762941484;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FYwKX44a4chADa+zBgV8O2gk95sOkV/2PizgSwnwgTA=;
  b=TZrc5F1oHlB1w/iUAU24a2oyzz6ELUCfehWAchWfHieXMfmLwbdVKrAv
   rcGLct1bADl+odYDagf7PKDlnI0t9mDycjPYZTavfxP+FlNfG+N92Z2/t
   ZBqe37r1zp4xMcvaHknL21JW1YripRjVP981j+vqd8sW04kG0XtRfo7R/
   7NiCzSm/7Ja14GYFbDd4G8UojRM4XIAN5PbG/wxnYi6MkrJ/KiV3vE54S
   GMEpntsBQqT99j6Vyz1G0uP1YQY1S7pnLNGicnBIOmbzLw+gp+xisSeAU
   AWB9v3F3qnnNbj0p980ncQljURiFqSyoVUlzLoh/5fMzOoC9uG44IcJqu
   Q==;
X-CSE-ConnectionGUID: I2mKurlVTLOtS3VITcRO0A==
X-CSE-MsgGUID: /1UPG2VeTyuRiF61lOCLzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41792423"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41792423"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 01:58:03 -0800
X-CSE-ConnectionGUID: li7PhifSRmyxfF2knLeXzA==
X-CSE-MsgGUID: wJAhsyRVQF+55jh3Z/tRAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="87545992"
Received: from iklimasz-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.105])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 01:57:59 -0800
Date: Tue, 12 Nov 2024 11:57:54 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Message-ID: <ZzMmomR-orhes_-p@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <d0cf8fb2-9cff-40d0-8ffb-5d0ba9c86539@intel.com>
 <ZzHTLO-TM_5_Q7U3@tlindgre-MOBL1>
 <2f0b7e2c-2d1d-4390-8cc9-72a0c3d44370@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f0b7e2c-2d1d-4390-8cc9-72a0c3d44370@intel.com>

On Tue, Nov 12, 2024 at 09:26:36AM +0200, Adrian Hunter wrote:
> On 11/11/24 11:49, Tony Lindgren wrote:
> > On Thu, Oct 31, 2024 at 09:21:29PM +0200, Adrian Hunter wrote:
> >> On 30/10/24 21:00, Rick Edgecombe wrote:
> >>> Here is v2 of TDX VM/vCPU creation series. As discussed earlier, non-nits 
> >>> from v1[0] have been applied and it’s ready to hand off to Paolo. A few 
> >>> items remain that may be worth further discussion:
> >>>  - Disable CET/PT in tdx_get_supported_xfam(), as these features haven’t 
> >>>    been been tested.
> >>
> >> It seems for Intel PT we have no support for restoring host
> >> state.  IA32_RTIT_* MSR preservation is Init(XFAM(8)) which means
> >> the TDX Module sets the MSR to its RESET value after TD Enty/Exit.
> >> So it seems to me XFAM(8) does need to be disabled until that is
> >> supported.
> > 
> > So for now, we should remove the PT bit from tdx_get_supported_xfam(),
> > but can still keep it in tdx_restore_host_xsave_state()?
> 
> Yes
> 
> > 
> > Then for save/restore, maybe we can just use the pt_guest_enter() and
> > pt_guest_exit() also for TDX. Some additional checks are needed for
> > the pt_mode though as the TDX module always clears the state if PT is
> > enabled. And the PT_MODE_SYSTEM will be missing TDX enter/exit data
> > but might be otherwise usable.
> 
> pt_guest_enter() / pt_guest_exit() are not suitable for TDX.  pt_mode
> is not relevant for TDX because the TDX guest is always hidden from the
> host behind SEAM.  However, restoring host MSRs is not the only issue.
> 
> The TDX Module does not validate Intel PT CPUID leaf 0x14
> (except it must be all zero if Intel PT is not supported
> i.e. if XFAM bit 8 is zero).  For invalid MSR accesses by the guest,
> the TDX Module will inject #GP.  Host VMM could provide valid CPUID
> to avoid that, but it would also need to be valid for the destination
> platform if migration was to be attempted.
> 
> Disabling Intel PT for TDX for now also avoids that issue.

OK thanks for the detailed explanation.

Regards,

Tony

