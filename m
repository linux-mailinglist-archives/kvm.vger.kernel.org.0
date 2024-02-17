Return-Path: <kvm+bounces-8968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FCB859027
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 15:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 620FEB212CC
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 14:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528FA7C0B1;
	Sat, 17 Feb 2024 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrCK03ru"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D916069E03;
	Sat, 17 Feb 2024 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708181389; cv=none; b=S5xKCvniynOhgrmFEg8kpQXTAQ7dCoJL866ZOa4Q1yVgElC25SLbyAMiLqXpiPrxPzFJoZngM7ckD84By/ANkvPN2IbMUjWENbBdw9TrkancF4QrejYxRlosJmSS54fAs1FNGcgGV2mZN+hXbRToK+H7VRhK8DHwtMQ+S1W8v2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708181389; c=relaxed/simple;
	bh=otsEbdPdtjFAM/AizCCrQI4l4jZouA2uDT+VnoJXyhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBBslrKu28w4286p6oSmzhf4YwdoSkXma30lMvB9RfeOPXDD9QR1u9h/TRinPR35WYszyd9cuGPrNcm01t51FlDujyASEwExqKFIg9xy9HdHEgtjrEp2jBTaIoNwE5je8dZws7n59VGiTYPKK1KfBfToyG03RxWhn53THAENX68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrCK03ru; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708181388; x=1739717388;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=otsEbdPdtjFAM/AizCCrQI4l4jZouA2uDT+VnoJXyhY=;
  b=HrCK03ru+pk+aJwbKhipB2QrHsainsqxTYFSdWXVZP5b8WTOgljLMyy9
   hkXrFPhoPUk7P6DNmZbV/dzTdWG8ckFc38c+ZqObcSwPoMH+5zqsyXAO7
   PgADDkwFBDslC/LFjlpVgy+n2kl3Xvnk7hbJDGEJvL85m+Qhx5bA4RPac
   rNJ6fT65NgfdYfXkD7BgmcvRz5ge/vax/yz09uT29IKjF/uhoZWjH5a8Z
   Bbr1PuNG/Ho+u51ME4BtQc45pd+wAS2+Cac0r5XEC7zc+Jvl90DHnovlH
   dCZw1BR2UYD5XPDRNTKjSXCg//9jeGNXbDREvdyixb5iLsyeAIt0Wc6ZS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="19725340"
X-IronPort-AV: E=Sophos;i="6.06,166,1705392000"; 
   d="scan'208";a="19725340"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2024 06:49:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,166,1705392000"; 
   d="scan'208";a="4058262"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 17 Feb 2024 06:49:44 -0800
Date: Sat, 17 Feb 2024 22:45:54 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Friedrich Weber <f.weber@proxmox.com>,
	Kai Huang <kai.huang@intel.com>,
	Yuan Yao <yuan.yao@linux.intel.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 1/4] KVM: x86/mmu: Retry fault before acquiring
 mmu_lock if mapping is changing
Message-ID: <ZdDGooxx/a+sAzmq@yilunxu-OptiPlex-7050>
References: <20240209222858.396696-1-seanjc@google.com>
 <20240209222858.396696-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209222858.396696-2-seanjc@google.com>

>  static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  			   unsigned int access)
>  {
> +	struct kvm_memory_slot *slot = fault->slot;
>  	int ret;
>  
>  	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
>  	smp_rmb();
>  
> +	/*
> +	 * Check for a relevant mmu_notifier invalidation event before getting
> +	 * the pfn from the primary MMU, and before acquiring mmu_lock.
> +	 *
> +	 * For mmu_lock, if there is an in-progress invalidation and the kernel
> +	 * allows preemption, the invalidation task may drop mmu_lock and yield
> +	 * in response to mmu_lock being contended, which is *very* counter-
> +	 * productive as this vCPU can't actually make forward progress until
> +	 * the invalidation completes.
> +	 *
> +	 * Retrying now can also avoid unnessary lock contention in the primary
> +	 * MMU, as the primary MMU doesn't necessarily hold a single lock for
> +	 * the duration of the invalidation, i.e. faulting in a conflicting pfn
> +	 * can cause the invalidation to take longer by holding locks that are
> +	 * needed to complete the invalidation.
> +	 *
> +	 * Do the pre-check even for non-preemtible kernels, i.e. even if KVM
> +	 * will never yield mmu_lock in response to contention, as this vCPU is
> +	 * *guaranteed* to need to retry, i.e. waiting until mmu_lock is held
> +	 * to detect retry guarantees the worst case latency for the vCPU.
> +	 */
> +	if (!slot &&

typo?   if (slot &&

Thanks,
Yilun

> +	    mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn))
> +		return RET_PF_RETRY;
> +
>  	ret = __kvm_faultin_pfn(vcpu, fault);
>  	if (ret != RET_PF_CONTINUE)
>  		return ret;

