Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633D87938B1
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 11:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjIFJov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 05:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbjIFJou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 05:44:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61E11990
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 02:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693993459; x=1725529459;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mkpCc6+QjXKML4/zwcgUT94O8KNWCx72unD1h2d8Zz0=;
  b=M9Lu+kplkrl9lDomFc08zAW2UdcSuC2mM91g6urJ1LMMfODeUxBrcauA
   jJ0TBte23r4wibFYT3/Qz+/P2Ke3Fj12Phgj/m8tdZa1TxIc+CTlBEGKs
   vds3I7ttSRvS2EAKD5oV7++ddwGfmnpwbOVZKCf/7NWphfrQ1tXjsIC5s
   JOxUbuxOl3iATEyVZIliLE2zh18pCJ0xNkon1QEKkRme3B2nWh03nbeHT
   1n7fiRu8E3iyAeAxwv2AV/aG17LrrtXiw1OQY5M7YTYgIVkcficZ9JcI7
   uuvNjc4U7HB5Ehow7hsC6IYik49xWqRx8OIZQS/x9ZAhVbPsJp1z17Bo4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="362045734"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="362045734"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:44:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="1072319637"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="1072319637"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:44:12 -0700
Message-ID: <276c9031-8d1e-f86b-b5d4-bb9af47e7b88@linux.intel.com>
Date:   Wed, 6 Sep 2023 17:44:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-6-xiong.y.zhang@intel.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230901072809.640175-6-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/2023 3:28 PM, Xiong Zhang wrote:
> With Arch PMU V5, register CPUID.0AH.ECX indicates Fixed Counter
> enumeration. It is a bit mask which enumerates the supported Fixed
> counters.
> FxCtrl[i]_is_supported := ECX[i] || (EDX[4:0] > i)
> where EDX[4:0] is Number of continuous fixed-function performance
> counters starting from 0 (if version ID > 1).
>
> Here ECX and EDX[4:0] should satisfy the following consistency:
> 1. if 1 < pmu_version < 5, ECX == 0;
> 2. if pmu_version == 5 && edx[4:0] == 0, ECX[bit 0] == 0
> 3. if pmu_version == 5 && edx[4:0] > 0,
>     ecx & ((1 << edx[4:0]) - 1) == (1 << edx[4:0]) -1
>
> Otherwise it is mess to decide whether a fixed counter is supported
> or not. i.e. pmu_version = 5, edx[4:0] = 3, ecx = 0x10, it is hard
> to decide whether fixed counters 0 ~ 2 are supported or not.
>
> User can call SET_CPUID2 ioctl to set guest CPUID.0AH, this commit
> adds a check to guarantee ecx and edx consistency specified by user.
>
> Once user specifies an un-consistency value, KVM can return an
> error to user and drop user setting, or correct the un-consistency
> data and accept the corrected data, this commit chooses to
> return an error to user.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e961e9a05847..95dc5e8847e0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -150,6 +150,33 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>   			return -EINVAL;
>   	}
>   
> +	best = cpuid_entry2_find(entries, nent, 0xa,
> +				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> +	if (best && vcpu->kvm->arch.enable_pmu) {
> +		union cpuid10_eax eax;
> +		union cpuid10_edx   edx;


Remove the redundant space before edx.


> +
> +		eax.full = best->eax;
> +		edx.full = best->edx;
> +

We may add SDM quotes as comments here. That makes reader to understand 
the logic easily.


> +		if (eax.split.version_id > 1 &&
> +		    eax.split.version_id < 5 &&
> +		    best->ecx != 0) {
> +			return -EINVAL;
> +		} else if (eax.split.version_id >= 5) {
> +			int fixed_count = edx.split.num_counters_fixed;
> +
> +			if (fixed_count == 0 && (best->ecx & 0x1)) {
> +				return -EINVAL;
> +			} else if (fixed_count > 0) {
> +				int low_fixed_mask = (1 << fixed_count) - 1;
> +
> +				if ((best->ecx & low_fixed_mask) != low_fixed_mask)
> +					return -EINVAL;
> +			}
> +		}
> +	}
> +
>   	/*
>   	 * Exposing dynamic xfeatures to the guest requires additional
>   	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
