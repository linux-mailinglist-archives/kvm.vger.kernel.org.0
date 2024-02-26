Return-Path: <kvm+bounces-9618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED71F866A88
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4088282937
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 07:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33431BDF4;
	Mon, 26 Feb 2024 07:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hFO19x23"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6531BDCD;
	Mon, 26 Feb 2024 07:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708931678; cv=none; b=owP+ckRp89TpfLCRpz9DwY55KYFe99v/BubuZtDo+xWxzouBSwWcebyM1KpdptqlaKjhy5Nu0scIkfvhQv57h49SIled9xyuwDKXHvaZmY1TxUUTVzzapwDI3X6zzzHAJLlkFX8VjhZRnUnYSg18+idlCOumYcquOqm7IdUhNro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708931678; c=relaxed/simple;
	bh=84WLTzyDlnzOxy+y2JEyz7+nxtE7gM9OqxOxGtRK5fA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVewCmWvVEZ5yhAhwUInNvq4kDHua8jCupnNQ84Vi7qn6ERSLx0e1GQJFUe4mxVrcritb/If19qgggw8j1IwmoTq+I1POjSuZjrV7tS9iRCNmOxlZAChLaQH6eSNmszUVjSXpHEMgAY1dJ4aRdmR57Km7nf9oTWu/BoyqIDDddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hFO19x23; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708931677; x=1740467677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=84WLTzyDlnzOxy+y2JEyz7+nxtE7gM9OqxOxGtRK5fA=;
  b=hFO19x237BzvQ3Zsryh6l6aq5tmQEh0glJhPXFMCqtpRL2qg3nfsdUTc
   heMdaK+OmLrZ0nhlK3LLN+ig/i+mtZVDsR5BiYYv1o4m/UGBfaraJLbhV
   R9nv9Xuz7cB0KponAck8Q7tO7Pibxx8jSaq4xkrqI4nVaXLYes+1+dEHk
   Hh09uPYukv3Rg1IQ7wQW9465sQlkPsSNojcRgYrN0VM6mSR/8jAnUiOIv
   Vly0yFX47J/kj5JmTH53Bz62zzISr3TmIF3lgH77lWxxEXj9NZg3zD/PN
   WVMrr/0TZgge2x/j3OqvH2BIXy6iIsyQgbHejMOpDJuULzKkbNYW3SD4Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6146193"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6146193"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 23:14:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="37569524"
Received: from linux.bj.intel.com ([10.238.157.71])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 23:14:33 -0800
Date: Mon, 26 Feb 2024 15:11:39 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yi Lai <yi1.lai@intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
Message-ID: <Zdw5qziEGdTyLIFN@linux.bj.intel.com>
References: <20240110002340.485595-1-seanjc@google.com>
 <170864656017.3080257.14048100709856204250.b4-ty@google.com>
 <dfca56c5-770b-46a3-90a3-3a6b219048f2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfca56c5-770b-46a3-90a3-3a6b219048f2@intel.com>

On Mon, Feb 26, 2024 at 09:30:33AM +0800, Xiaoyao Li wrote:
> On 2/23/2024 9:35 AM, Sean Christopherson wrote:
> > On Tue, 09 Jan 2024 16:23:40 -0800, Sean Christopherson wrote:
> > > Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> > > whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> > > enumerated via MSR, i.e. aren't accessible to userspace without help from
> > > the kernel, and knowing whether or not 5-level EPT is supported is sadly
> > > necessary for userspace to correctly configure KVM VMs.
> > > 
> > > When EPT is enabled, bits 51:49 of guest physical addresses are consumed
> > > if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
> > > *can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
> > > creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
> > > above bit 48 will be completely broken.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 vmx, with a massaged changelog to avoid presenting this as a
> > bug fix (and finally fixed the 51:49=>51:48 goof):
> > 
> >      Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
> >      whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
> >      enumerated via MSR, i.e. aren't accessible to userspace without help from
> >      the kernel, and knowing whether or not 5-level EPT is supported is useful
> >      for debug, triage, testing, etc.
> >      For example, when EPT is enabled, bits 51:48 of guest physical addresses
> >      are consumed by the CPU if and only if 5-level EPT is enabled.  For CPUs
> >      with MAXPHYADDR > 48, KVM *can't* map all legal guest memory if 5-level
> >      EPT is unsupported, making it more or less necessary to know whether or
> >      not 5-level EPT is supported.
> > 
> > [1/1] x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
> >        https://github.com/kvm-x86/linux/commit/b1a3c366cbc7
> 
> Do we need a new KVM CAP for this? This decides how to interact with old
> kernel without this patch. In that case, no ept_5level in /proc/cpuinfo,
> what should we do in the absence of ept_5level? treat it only 4 level EPT
> supported?

Maybe also adding flag for 4-level EPT can be an option. If userspace
checks both 4-level and 5-level are not in /proc/cpuinfo, it can regard
the kernel as old.

Thanks,
Tao

> 
> 
> 
> > --
> > https://github.com/kvm-x86/linux/tree/next
> > 
> 

