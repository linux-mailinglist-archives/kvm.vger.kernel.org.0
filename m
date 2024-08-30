Return-Path: <kvm+bounces-25551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FCF966777
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 18:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55094286E77
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB831B86F0;
	Fri, 30 Aug 2024 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i4ib93TQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEDB1B5ED3;
	Fri, 30 Aug 2024 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037184; cv=none; b=CbzIPGCaX7iB8BDhWamSwfJiKTugef/+noaEYu4/AMHOHAx/j2QgPMgD33y2opbmKAJ/0PmMUXDIZNGfZuUm1PgrCyIgf3QwuJxkpPr+TXgBAe1ZosJCBvyy2PtDIeTbsd6qnVvHmLEcLl0bWp7gL/wSVB37ckm+rM923hj5kZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037184; c=relaxed/simple;
	bh=g+CDz/qgnDvPGrRMnmHjXJO8gZVIdvkxBnTYdMpl1Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgnMCyR0riioOtMSyQnfOID+Jy9pnxtaUNQJDkZuFw2VhlkZdKFZ5NVl0MWdnjtYjtgjjoMqHUGtrRr97m256bE4HnAwujfTx5BKNDPhioq1iBxr127MexKDMvfQh15y7nsv1oRGg6/d8xtcaeQjBCj2HB7Qsz1VeZrde1NikD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i4ib93TQ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725037183; x=1756573183;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g+CDz/qgnDvPGrRMnmHjXJO8gZVIdvkxBnTYdMpl1Eo=;
  b=i4ib93TQs4gLyG8nEDEVLi1RRLCsqU03GLbmmJnjF+GrVabuc4T8i3QX
   pLMpX2scEmzWO7bs3p4QRnnVntyWVFtph28EccT7aR9K+Gws+pow7WYVk
   Ej0tr93SsGAlpebRkPw9oTk0J7BPqx3SG0qJPm5EzOlA81qhi1Rm2rKye
   ILd68NTQ5r8QmzDD4iA/NWOXoPa4eGHVWwmGXA+PK52XyWO/dWtv6XjzJ
   70o5Y6/Lv+82/bwApqfyHuAoMvKIq+5hvlztvnbILbzSsHqLa89f+0OE3
   z8sBRhbTs5hQh9Mi1qo6eQU5SXVg8aZanpAbU8TQ64aCxZ9GSilBclgaB
   g==;
X-CSE-ConnectionGUID: o7K/0ZirS7qyT1wOKGa9OQ==
X-CSE-MsgGUID: vrf59SpNRQ+zXh4Z6Vl+mQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11180"; a="23850876"
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="23850876"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 09:59:42 -0700
X-CSE-ConnectionGUID: 8WJvFrZ1S4S5x2a3h0WlzA==
X-CSE-MsgGUID: 5ROgX7cgTDCCRTrQKpm91w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="68842950"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 30 Aug 2024 09:59:38 -0700
Date: Sat, 31 Aug 2024 00:57:10 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 13/21] KVM: X86: Handle private MMIO as shared
Message-ID: <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-14-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-14-aik@amd.com>

On Fri, Aug 23, 2024 at 11:21:27PM +1000, Alexey Kardashevskiy wrote:
> Currently private MMIO nested page faults are not expected so when such
> fault occurs, KVM tries moving the faulted page from private to shared
> which is not going to work as private MMIO is not backed by memfd.
> 
> Handle private MMIO as shared: skip page state change and memfd

This means host keeps the mapping for private MMIO, which is different
from private memory. Not sure if it is expected, and I want to get
some directions here.

From HW perspective, private MMIO is not intended to be accessed by
host, but the consequence may varies. According to TDISP spec 11.2,
my understanding is private device (known as TDI) should reject the
TLP and transition to TDISP ERROR state. But no further error
reporting or logging is mandated. So the impact to the host system
is specific to each device. In my test environment, an AER
NonFatalErr is reported and nothing more, much better than host
accessing private memory.

On SW side, my concern is how to deal with mmu_notifier. In theory, if
we get pfn from hva we should follow the userspace mapping change. But
that makes no sense. Especially for TDX TEE-IO, private MMIO mapping
in SEPT cannot be changed or invalidated as long as TDI is running.

Another concern may be specific for TDX TEE-IO. Allowing both userspace
mapping and SEPT mapping may be safe for private MMIO, but on
KVM_SET_USER_MEMORY_REGION2,  KVM cannot actually tell if a userspace
addr is really for private MMIO. I.e. user could provide shared memory
addr to KVM but declare it is for private MMIO. The shared memory then
could be mapped in SEPT and cause problem.

So personally I prefer no host mapping for private MMIO.

Thanks,
Yilun

> page state tracking.
> 
> The MMIO KVM memory slot is still marked as shared as the guest can
> access it as private or shared so marking the MMIO slot as private
> is not going to help.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 928cf84778b0..e74f5c3d0821 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4366,7 +4366,11 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  {
>  	bool async;
>  
> -	if (fault->is_private)
> +	if (fault->slot && fault->is_private && !kvm_slot_can_be_private(fault->slot) &&
> +	    (vcpu->kvm->arch.vm_type == KVM_X86_SNP_VM))
> +		pr_warn("%s: private SEV TIO MMIO fault for fault->gfn=%llx\n",
> +			__func__, fault->gfn);
> +	else if (fault->is_private)
>  		return kvm_faultin_pfn_private(vcpu, fault);
>  
>  	async = false;
> -- 
> 2.45.2
> 
> 

