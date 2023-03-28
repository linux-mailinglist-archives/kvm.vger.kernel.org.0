Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014736CB458
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 04:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjC1Cux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjC1Cuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 22:50:51 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2E9272A;
        Mon, 27 Mar 2023 19:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679971846; x=1711507846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OR5mYfrScR3UC8cfo0vCPsOTOZHpOQ0EpnHHxOtVJY0=;
  b=HZQekl+8xRdKNQrfFo++eADk+4iOe5H/Heus19BHtzKPK6AbRjRNzRKp
   p3DR6VWcoFLaEEXlxcDk3hLRyqE8Zzj1tpFGp3o7Oi7mt2lTKEMuoeObT
   /xKxbkKgCRqeYpiU7Y76eNqOTxlFnUtXhWGoXK0mgnWY3r2D60D28cPGv
   81bLM0qCM6IjyUh/1d7Kp9gzw8GFsseCUgHLoIDiGLaqnDXN56P8dfMw3
   vn6ujgBlU5j/ve/RdtvyZlFrk5/AzwUK9qKdcpHtDYCO+CDH/bDNwHETI
   DtIXHNWR4vtNOFzKrkbAfNiKKbvcDOLl8uq2dkBrhMHefbanDtJS0BYK8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="337955498"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="337955498"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 19:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="748230299"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="748230299"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga008.fm.intel.com with ESMTP; 27 Mar 2023 19:50:43 -0700
Date:   Tue, 28 Mar 2023 10:39:12 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v13 039/113] KVM: x86/mmu: Assume guest MMIOs are shared
Message-ID: <ZCJTUIJsaJDNjcPP@yilunxu-OptiPlex-7050>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <80912a430d4642acf85c454e97c8320f96e4b737.1678643052.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80912a430d4642acf85c454e97c8320f96e4b737.1678643052.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-12 at 10:56:03 -0700, isaku.yamahata@intel.com wrote:
> From: Chao Gao <chao.gao@intel.com>
> 
> Current TD guest doesn't invoke MAP_GPA to convert MMIO range to shared
> before accessing it. It implies that current TD guest assumes MMIOs are
> shared.
> 
> When TD tries to access assigned device's MMIO as shared, an EPT violation

Seems the patch is dealing with emulated MMIO, not assigned device's MMIO.

> is raised first. kvm_mem_is_private() checks the page shared or private
> attribute against the access type (shared bit in GPA). Then since no
> MAP_GPA is called for the MMIO, KVM thinks the MMIO is private and refuses
> shared access and doesn't set up shared EPT. Then KVM returns to TD and TD
> just retries and this causes an infinite loop.
> 
> Instead of requiring guest to invoke MAP_GPA for MMIOs, assume guest MMIOs
> are shared in KVM as well and don't expect explicit calls of MAP_GAP for
> guest MMIOs (i.e., GPAs either have no kvm_memory_slot or are backed by
> host MMIOs). So, allow shared access to guest MMIOs and move the page type
> check after the corresponding pfn is available.

Didn't see the movement.

Seems the commit message needs update.

> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5883ab95ff07..ce8a896a3cfa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4314,7 +4314,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
> +	/*
> +	 * !fault->slot means MMIO.  Don't require explicit GPA conversion for
> +	 * MMIO because MMIO is assigned at the boot time.
> +	 */
> +	if (fault->slot &&

This only exempts emulated MMIO, how about the passthrough device's MMIO?

Thanks,
Yilun

> +	    fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
>  		return kvm_do_memory_fault_exit(vcpu, fault);
>  
>  	if (fault->is_private)
> -- 
> 2.25.1
> 
