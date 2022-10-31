Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F1D6132A6
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 10:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiJaJYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 05:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiJaJXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 05:23:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A12FDF63;
        Mon, 31 Oct 2022 02:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667208166; x=1698744166;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dk392vKLE9i7N1vmzYLQyKcqIsTeZR+TmuP19K/V+0o=;
  b=JvliAE6/SFscSyOFremvahmR3HgXWgyAYI5PLzBte67nZgl3E4s+7PIW
   PIJU9igcks8qSekAWtYajAL2RqdyOqFbVauIr6GB+8eiB19Gvhum8GX4R
   9PIkk7NQt5YA1HcAKHAFx3Io6k2yvvOMPFAr+OIMplzfxzvEyEjN3rsZx
   w1lNmlChxlvS7AMqZQw7trO4X+/2ctn89OcJQEs5JlVqoJcCJM5fa86q6
   /T76uEGGnGj/p9twMqEPjfNQ1tHnFQQ5uLXgTaXPLekNCn3E2kYqluzjk
   k561uB7k2YGUYN8NMEw2Oefo4imyjV4vbwts0e8afubTJD8q7ih6HtRyS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10516"; a="288570195"
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="288570195"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 02:22:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10516"; a="696941190"
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="696941190"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.35]) ([10.255.28.35])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 02:22:15 -0700
Message-ID: <f1fdc428-f407-9582-c392-579f873f7562@linux.intel.com>
Date:   Mon, 31 Oct 2022 17:22:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 010/108] KVM: TDX: Add TDX "architectural" error codes
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <679bb45187dc54b82ebc9df5381a7d5de0b782d5.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <679bb45187dc54b82ebc9df5381a7d5de0b782d5.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add error codes for the TDX SEAMCALLs both for TDX VMM side for TDH
> SEAMCALL and TDX guest side for TDG.VP.VMCALL.  KVM issues the TDX
> SEAMCALLs and checks its error code.  KVM handles hypercall from the TDX
> guest and may return an error.  So error code for the TDX guest is also
> needed.
>
> TDX SEAMCALL uses bits 31:0 to return more information, so these error
> codes will only exactly match RAX[63:32].  Error codes for TDG.VP.VMCALL is
> defined by TDX Guest-Host-Communication interface spec.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx_errno.h | 38 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
>
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> new file mode 100644
> index 000000000000..ce246ba62454
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* architectural status code for SEAMCALL */
> +
> +#ifndef __KVM_X86_TDX_ERRNO_H
> +#define __KVM_X86_TDX_ERRNO_H
> +
> +#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
> +
> +/*
> + * TDX SEAMCALL Status Codes (returned in RAX)
> + */
> +#define TDX_SUCCESS				0x0000000000000000ULL
> +#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000ULL
> +#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
> +#define TDX_OPERAND_BUSY                        0x8000020000000000ULL

one minor format issue, spaces are used  instread of tabs this line.


> +#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
> +#define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
> +#define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
> +#define TDX_KEY_CONFIGURED			0x0000081500000000ULL
> +#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000ULL
> +#define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
> +
> +/*
> + * TDG.VP.VMCALL Status Codes (returned in R10)
> + */
> +#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000ULL
> +#define TDG_VP_VMCALL_RETRY			0x0000000000000001ULL
> +#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000ULL
> +#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001ULL
> +
> +/*
> + * TDX module operand ID, appears in 31:0 part of error code as
> + * detail information
> + */
> +#define TDX_OPERAND_ID_RCX			0x01
> +#define TDX_OPERAND_ID_SEPT			0x92
> +
> +#endif /* __KVM_X86_TDX_ERRNO_H */
