Return-Path: <kvm+bounces-20488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BED6291697F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F08BA1C230D5
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F315168C33;
	Tue, 25 Jun 2024 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BrMpNS56"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E7216729D
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719323603; cv=none; b=TymtlTwtSGK8jajvi0HPpqtQxqzaxQ94VJeh6RBH+JxhNGiXUx5H59fSAuoF2ksHUAGbo/bj+kUlGG8xNRG9zOP5bVBVZzG3dznOnBZlbboq4L7mF9qaT2kqVCYLZu5kjRzC/u606wlEHXP/XLX9FkWEYdvm3crwh0m3QhMf0Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719323603; c=relaxed/simple;
	bh=VDqj8FLLXt2GlyHOeiwwgvCcHIxT7PLjCZ1Sav3JPg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8+emcQ1mcMH/gMUUe7SfMGTz2DWrkYi+CXXr6zxhYst2Ayu/iDpZGc4ST3U3GWxcGy7up+hH0MfQgZJjxqTnFfr95qUOs+Ik0awgmYGSxoFIOORxHXRsCI7FX9+cffUK9O4ktsqeYAxLDh1+YkSC2EJIcHCgiREVwC6kwXuREE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BrMpNS56; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719323602; x=1750859602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VDqj8FLLXt2GlyHOeiwwgvCcHIxT7PLjCZ1Sav3JPg4=;
  b=BrMpNS56gGRgnxfCeEDoOl2S94Q5L7NiOqbpri/J5Y9qgINGDUWHtaCS
   W3pspwY/vp3/GNkd31IdnqfOQEv97Ff/6K32PbakuU0RH1HL7HfZbEReI
   coKdxEVZ8pyBeSCdJnTfT89IlXKCpj8F4+3hL9F+DG8Sn2sHBMc4yEnTo
   1bGBMMJErYwQ3VxFKPdBZzqtMSxyZQ5TUv6rjQq2WFi/625xoCLIrpL/t
   EbVTg66M5jYioVwNH7b6JA8HMRitx5WRS3YorlM0bLk83yoCQIaioeV29
   uvwEe8fepzC4kDb2ZkxWesJSmzdLXvbb7e3dOSNpTNLNjx7Dtw3nMwJik
   g==;
X-CSE-ConnectionGUID: vQv2B2oXRGON7eEfykADUA==
X-CSE-MsgGUID: q9Z6KJdiTkaki+GQvDKVQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="20119522"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="20119522"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 06:53:22 -0700
X-CSE-ConnectionGUID: JQb3GVzcQ+6FV7eH1DDqzg==
X-CSE-MsgGUID: Gt67F+chRiWxW5GuUeWN4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43539764"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 25 Jun 2024 06:53:19 -0700
Date: Tue, 25 Jun 2024 22:08:53 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
	mtosatti@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com
Subject: Re: [PATCH v3] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
Message-ID: <ZnrPdZdgcBSY1sMi@intel.com>
References: <20240624095806.214525-1-ewanhai-oc@zhaoxin.com>
 <ZnqSj4PGrUeZ7OT1@intel.com>
 <53119b66-3528-41d6-ac44-df166699500a@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53119b66-3528-41d6-ac44-df166699500a@zhaoxin.com>

[snip]

> > Additionally, has_msr_vmx_vmfunc has the similar compat issue. I think
> > it deserves a fix, too.
> > 
> > -Zhao
> Thanks for your reply. In fact, I've tried to process has_msr_vmx_vmfunc in
> the same
> way as has_msr_vmx_procbased_ctls in this patch, but when I tested on Linux
> kernel
> 4.19.67, I encountered an "error: failed to set MSR 0x491 to 0x***".
> 
> This issue is due to Linux kernel commit 27c42a1bb ("KVM: nVMX: Enable
> VMFUNC
> for the L1 hypervisor", 2017-08-03) exposing VMFUNC to the QEMU guest
> without
> corresponding VMFUNC MSR modification code, leading to an error when QEMU
> attempts
> to set the VMFUNC MSR. This bug affects kernels from 4.14 to 5.2, with a fix
> introduced
> in 5.3 by Paolo (e8a70bd4e "KVM: nVMX: allow setting the VMFUNC controls
> MSR", 2019-07-02).

It looks like this fix was not ported to the 4.19 stable kernel.

> So the fix for has_msr_vmx_vmfunc is clearly different from
> has_msr_vmx_procbased_ctls2.
> However, due to the different kernel support situations, I have not yet come
> up with a suitable
> way to handle the compatibility of has_msr_vmx_procbased_ctls2 across
> different kernel versions.
> 
> Therefore, should we consider only fixing has_msr_vmx_procbased_ctls2 this
> time and addressing
> has_msr_vmx_vmfunc in a future patch when the timing is more appropriate?
> 

I agree this fix should focus on MSR_IA32_VMX_PROCBASED_CTLS2.

But I think at least we need a comment (maybe a TODO) to note the case of
has_msr_vmx_vmfunc in a followup patch.

Let's wait and see what Paolo will say.

-Zhao

