Return-Path: <kvm+bounces-2193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B7B7F3215
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 394A7282D1E
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 15:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90215676B;
	Tue, 21 Nov 2023 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G111lDO4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FA7BB
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 07:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700579774; x=1732115774;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=meE7zH+vwYXacbKxcWugOVMx6Q4OnYNT6H2nuw/QAz4=;
  b=G111lDO4YOwV+MymPAtcjbN7h0fc6rq3zOzPLnLzFb2lEYvEzaV2/bhD
   9gCa110B0823SLp2Upg+lsV6MaSG52pAL7or+518y1Cjm7dDazcGZ/GHV
   H+cNZDBF/h8QM59Mu/eridsufiN7I/XT127I6WbR6nz6q0clAIiC1vZQx
   WinREEQlj+g30QBRtmIMSfDxTQjc686MyJTQ+fQkv0WjEmkgN4xSEVxML
   L8XlO5ttAcP1cvK8sjLUimD9u5PT7BG/ELqo3/J1Eo8TKZlPBo/jsw4D2
   5Y5obEUk7p3uKyFxBb6A33HvqfqdffZK6nEGG3gPlZL38R/pfwQXD3wYf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="5054710"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="5054710"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 07:16:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="1098088044"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="1098088044"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga005.fm.intel.com with ESMTP; 21 Nov 2023 07:16:12 -0800
Date: Tue, 21 Nov 2023 23:14:20 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
Message-ID: <ZVzJTK4J+sm5prKG@yilunxu-OptiPlex-7050>
References: <20231117122633.47028-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117122633.47028-1-lirongqing@baidu.com>

On Fri, Nov 17, 2023 at 08:26:33PM +0800, Li RongQing wrote:
> Static key kvm_has_noapic_vcpu should be reduced when fail
> to create vcpu, this patch fixes it
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/x86.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 41cce50..2a22e66 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11957,7 +11957,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	kfree(vcpu->arch.mci_ctl2_banks);
>  	free_page((unsigned long)vcpu->arch.pio_data);
>  fail_free_lapic:
> -	kvm_free_lapic(vcpu);
> +	if (!lapic_in_kernel(vcpu))
> +		static_branch_dec(&kvm_has_noapic_vcpu);
> +	else
> +		kvm_free_lapic(vcpu);
>  fail_mmu_destroy:
>  	kvm_mmu_destroy(vcpu);
>  	return r;

It is good to me. But is it better also take the chance to tidy up
kvm_arch_vcpu_destroy():

	kvm_free_lapic(vcpu);
	idx = srcu_read_lock(&vcpu->kvm->srcu);
	kvm_mmu_destroy(vcpu);
	srcu_read_unlock(&vcpu->kvm->srcu, idx);
	free_page((unsigned long)vcpu->arch.pio_data);
	kvfree(vcpu->arch.cpuid_entries);
	if (!lapic_in_kernel(vcpu))
		static_branch_dec(&kvm_has_noapic_vcpu);

Thanks,
Yilun

> -- 
> 2.9.4
> 
> 

