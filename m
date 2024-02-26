Return-Path: <kvm+bounces-9988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B42618680DF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F1321F257DE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2F1130AC0;
	Mon, 26 Feb 2024 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XDXGrffo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A53612F586;
	Mon, 26 Feb 2024 19:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975353; cv=none; b=EzMuPpklCaCGp0ouEc7TT8ZxBi7N1NzDxL9e0GCiKE3hpk1OBBSNLm/m9HqEia8MFnJ4Va19I7BSQeuvPrUyYoRJ+XmTXy2B8oZaV3PcBdh1uSh1nmqOSIX8gOD34/s4rjB5ml03NBcPFvY00z9m7KzyU25Cvh8rLBnqpJw7XNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975353; c=relaxed/simple;
	bh=FqFNb4x/x8qbqyzr7+3dDomy9topMozI5OvKyn3dnFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=As7R28CjDofQouy3yn7Sukdg1hf4oVmeYNnTJ3NrZl/7w+I71MHUGt4klqyapNWiOwVvOcWOST55a93IkeHIEindjaLkSgxHug5bRkuwFXGnmve0DV3fCOJTL/UDM6htVteu3IlzNFNDx6F/rdTS8fDg40a0H2LyC5h9WbfRGqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XDXGrffo; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708975352; x=1740511352;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FqFNb4x/x8qbqyzr7+3dDomy9topMozI5OvKyn3dnFg=;
  b=XDXGrffox5NmD0a0frbMlImf5lOCLusfq2JscRxcZp8jJdmitUFJQxFK
   YGnVWjcEWkT8CUlWpdQV0krCHdjYFeBXjV9pFz/HA0+IpHN5Pk+KtjGkL
   aoW5Aztyvusm/qNkrRIC/aeG+fMlga8sASRRLAvZN8HaAMyquDoeOhKc8
   XnUCpLMBMvJ8p5e1VfADKfUwfYUQKwAEQE4FICU40nS5ivtvgQlyVcQMP
   wjn7wmolyJevW2BSGwAY+IklAtyS5ssnjXB1ke0gLEIHDpGj/b9hPTQup
   nmCxzxGhwTLd3rB8P0wObTsjKfWxW+sI0bhwmdOA2dCx05XsIkgbO5adz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14723327"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="14723327"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:22:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6715471"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:22:28 -0800
Date: Mon, 26 Feb 2024 11:22:24 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 061/121] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20240226192224.GQ177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <83048a3bba898a4a81215f3c62489b03e307d180.1705965635.git.isaku.yamahata@intel.com>
 <b676c8f7-fa3c-44f7-bfbf-0f28d46a7576@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b676c8f7-fa3c-44f7-bfbf-0f28d46a7576@linux.intel.com>

On Mon, Feb 19, 2024 at 01:20:58PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
> > thinks MTRR is supported.  Although TDX supports only WB for private GPA,
> > it's desirable to support MTRR for shared GPA.  As guest access to MTRR
> > MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining
> 
> s/remining/remaining
> 
> > part is to implement get_mt_mask method for TDX for shared GPA.
> > 
> > Pass around shared bit from kvm fault handler to get_mt_mask method so that
> > it can determine if the gfn is shared or private.  Implement get_mt_mask()
> > following vmx case for shared GPA and return WB for private GPA.
> 
> But the shared bit is not consumed in get_mt_mask()?

This paragraph became stale. I eliminated this paragraph.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

