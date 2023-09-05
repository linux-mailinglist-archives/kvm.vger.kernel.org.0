Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AFE792794
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbjIEQEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353786AbjIEIKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 04:10:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3831AD;
        Tue,  5 Sep 2023 01:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693901439; x=1725437439;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FKt4N39+eLOrfCYx28v1L2U/jY+7IRlu5++Gi9mCgMM=;
  b=VNf9/SRxaFCDcJDPSR61lZ9HwiPy01ijSQYsuBkE+ocaSxstJMplUlLB
   jOac5346Zeh3BJB53RxFFgoVvpn+AM1udRxT2Mlyl+sUol2LPZKULAP3h
   EBi34wxOvKgdxWvc0I/3SmD42CkMQnrAVoEEgVIWWcU9diloRqvxUwXZe
   wXkzflSE+rLEZSMchan+4VOk+4+/Qxzs06PnF49snJatQaM/4IPTyA646
   ru8gGnNMX1jLH+tejUwiRql4E8Tdh8CMQovJPPIlgz3XQkXxtkyA4I1wX
   AgvZm+Aqq76teOAXWFVSMTCbcwxvWXGeMwuz7CKYa51Eg+8pcz1FCv9if
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="443137224"
X-IronPort-AV: E=Sophos;i="6.02,228,1688454000"; 
   d="scan'208";a="443137224"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 01:10:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="717799453"
X-IronPort-AV: E=Sophos;i="6.02,228,1688454000"; 
   d="scan'208";a="717799453"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.2.44]) ([10.93.2.44])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 01:10:35 -0700
Message-ID: <fef75d54-e319-5170-5f76-f5abc4856315@linux.intel.com>
Date:   Tue, 5 Sep 2023 16:10:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [RFC PATCH v4 01/16] KVM: TDP_MMU: Go to next level if smaller
 private mapping exists
To:     isaku.yamahata@intel.com, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1690323516.git.isaku.yamahata@intel.com>
 <b263e32affd62ddd675ae50981a4ae3ef7b3c607.1690323516.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b263e32affd62ddd675ae50981a4ae3ef7b3c607.1690323516.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/26/2023 6:23 AM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Cannot map a private page as large page if any smaller mapping exists.
>
> It has to wait for all the not-mapped smaller page to be mapped and
> promote it to larger mapping.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 95ba78944712..a9f0f4ade2d0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1293,7 +1293,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
>   		int r;
>   
> -		if (fault->nx_huge_page_workaround_enabled)
> +		if (fault->nx_huge_page_workaround_enabled ||
> +		    kvm_gfn_shared_mask(vcpu->kvm))
>   			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>   
>   		/*
The implementation of disallowed_hugepage_adjust() is as following:

void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, 
int cur_level)
{
     if (cur_level > PG_LEVEL_4K &&
         cur_level == fault->goal_level &&
         is_shadow_present_pte(spte) &&
         !is_large_pte(spte) &&
         spte_to_child_sp(spte)->nx_huge_page_disallowed) {
             ...
     }
}

One condition is spte_to_child_sp(spte)->nx_huge_page_disallowed should be
true to decrease the goal level of the fault.
Does this condition make the change of this patch invalid?

