Return-Path: <kvm+bounces-12189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCC48806F2
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 22:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B9961F22CF9
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 21:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884B34F214;
	Tue, 19 Mar 2024 21:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wh4M8w03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A07C3D387;
	Tue, 19 Mar 2024 21:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710885429; cv=none; b=WyOxXDW1mqF29lA1QqbsV7+FCPPbAlfofsck+8pWClcUCWcrWOClRj8ubRekF6yduIyla8HKWFBI5VmIb7RDtlH0m+94Z5m2b54dIHqrRvbZkQv4VQU7Shn1+wVu25TdJ8QPqgNHTMdAxJT8xvHDHUhboEFd9C7pRCN6/rvH8vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710885429; c=relaxed/simple;
	bh=5mBUpRoiE0B5lVQmV9kib3iinYq0hyV/9hyB8jsp1fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huZbmI9pkVMiGauBbMLAqvFN4pAz+4D9g6gE5b/SMTtRsrZitVuYnQPJjYCxNa0u9zbPw96v6OEB47dy3qQx+dK+c5A9KWQLI2A0mikQY1m+4esvuttzb+nzjIs0/INTKFfdIqTwwiCeMiU6j1WKOgDAQHHN/1ok6lfbGRjQj5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wh4M8w03; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710885427; x=1742421427;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5mBUpRoiE0B5lVQmV9kib3iinYq0hyV/9hyB8jsp1fs=;
  b=Wh4M8w03gTMolTOaLq8Cn3dIoMlbFnfEPZvgZlzdVcaRkJJYkwQ9W9qH
   rj8C4+jZCppJ5Dk8prygElIIDWWr8RsOae7UjeiRXgVm26px+R1UWkOVk
   0Amv0NVtyWOJfKIp5Moa3x5XUoewo6X6SmQe0bVUilpPY9D1K9m/GnOs+
   Ojmj3paUbAk/gn6WlvJHo49w1A4heGOh3qRkwECLYDocrHpgdMlwlWy2E
   eqpAptzvyMxPYGXQzWkKmph3KhmNXthafWonSS2KLlr06MHJybBc48tQU
   FY49g9FFYt5dqcSSm3IYkVQZSZdRM4x29EfFeUTpEq86y9Holo2c/tE+A
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5654419"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="5654419"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 14:57:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="14607660"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 14:57:07 -0700
Date: Tue, 19 Mar 2024 14:57:06 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 098/130] KVM: TDX: Add a place holder to handle TDX
 VM exit
Message-ID: <20240319215706.GB1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com>
 <ZfSJIDOJzGJ4lPjX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfSJIDOJzGJ4lPjX@google.com>

On Fri, Mar 15, 2024 at 10:45:04AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > +{
> > +	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> > +
> > +	/* See the comment of tdh_sept_seamcall(). */
> > +	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))
> > +		return 1;
> > +
> > +	/*
> > +	 * TDH.VP.ENTRY checks TD EPOCH which contend with TDH.MEM.TRACK and
> > +	 * vcpu TDH.VP.ENTER.
> > +	 */
> > +	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_TD_EPOCH)))
> > +		return 1;
> > +
> > +	if (unlikely(exit_reason.full == TDX_SEAMCALL_UD)) {
> > +		kvm_spurious_fault();
> > +		/*
> > +		 * In the case of reboot or kexec, loop with TDH.VP.ENTER and
> > +		 * TDX_SEAMCALL_UD to avoid unnecessarily activity.
> > +		 */
> > +		return 1;
> 
> No.  This is unnecessarily risky.  KVM_BUG_ON() and exit to userspace.  The
> response to "SEAMCALL faulted" should never be, "well, let's try again!".
> 
> Also, what about #GP on SEAMCALL?  In general, the error handling here seems
> lacking.

As I replied at [1], let me revise error handling in general TDX KVM code.
[1] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/T/#macc431c87676995d65ddcd8de632261a2dedc525
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

