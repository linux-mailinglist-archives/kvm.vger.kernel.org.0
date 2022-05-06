Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA1651DBA1
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442780AbiEFPNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442745AbiEFPNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:13:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508626D1AD;
        Fri,  6 May 2022 08:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651849771; x=1683385771;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ozT16fP9uZM5368h+nOi7loe0DpIGRiHdi5VvAV0IK0=;
  b=ixlA1t7lhVSKaLRBZ2tkL+gkRCScTiCGL6gtkn/AnoXOgYwsNT2qM1Wp
   S2Ufn4+WDykSy+TlYbSCH/LAm+oiUCeET7KUnWeux4dmwYQExpPFCqtrT
   pFjHa2Aw0ZEtj0b7xlxipWfauMUJZc6rnBSsHfpcQ1DcupWt5Ydq8ucwm
   wt06347UjV9lVgeoVwc1bhu6NDTFffbhJHPlYsxRZsyqmVYX7dSwF20sQ
   TuSgqIQgIcfR0w198pvwZmjHzhB27TCPrNOZfN4QRiw3slYIGp6bz0AW0
   AOuu9k6kAQ2DXLBxIbhYbjZ8RvLSHMbJZikEkUPicNjy0gGFFfuPB5HAk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="250492651"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="250492651"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 08:09:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="654731889"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 06 May 2022 08:09:02 -0700
Received: from [10.252.212.236] (kliang2-MOBL.ccr.corp.intel.com [10.252.212.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9FD8558093E;
        Fri,  6 May 2022 08:09:00 -0700 (PDT)
Message-ID: <d2d17aa4-58fc-3621-59bb-0c9ce751ebd1@linux.intel.com>
Date:   Fri, 6 May 2022 11:08:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest
 state change
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-15-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220506033305.5135-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/2022 11:33 PM, Yang Weijiang wrote:
> Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
> on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
> values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
> LBRs." So clear Arch LBREn bit on #SMI and restore it on RSM manully, also
> clear the bit when guest does warm reset.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6d6ee9cf82f5..b38f58868905 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4593,6 +4593,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	if (!init_event) {
>   		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>   			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
> +	} else {
> +		flip_arch_lbr_ctl(vcpu, false);
>   	}
>   }
>   
> @@ -7704,6 +7706,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>   	vmx->nested.smm.vmxon = vmx->nested.vmxon;
>   	vmx->nested.vmxon = false;
>   	vmx_clear_hlt(vcpu);
> +	flip_arch_lbr_ctl(vcpu, false);
>   	return 0;
>   }
>   
> @@ -7725,6 +7728,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>   		vmx->nested.nested_run_pending = 1;
>   		vmx->nested.smm.guest_mode = false;
>   	}
> +	flip_arch_lbr_ctl(vcpu, true);
>   	return 0;
>   }
>   
