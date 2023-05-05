Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179CF6F7ADB
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 04:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjEECXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 22:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEECX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 22:23:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063BB11638;
        Thu,  4 May 2023 19:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683253407; x=1714789407;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9qXWAh7qGjkOOeTp9fwUba4lPO1AOjZU8zBnNPwIU/M=;
  b=O2r5ZbUBPXye7v2gv4VEXa+7WE6CY2mWxLtLTA08+nSvgaBoinPZVhmD
   ILCGteFMi6uzK6Zb2uNTpwZhtKDvPxIp6pRndPfU6U3OfqIjYshoT97Kk
   q2VGTfJIYfRDInxv/EpV18SHBcdgSmpdgERzizs9zBkMAyr6kuxE8o8Bj
   w8t4Nn4r79aGoU6FVax1uWx6TqvfiT79FtOKNDW2TwU6w2tCkL2N/2Vmm
   IwTzQgvU00bk2k4I5wpOkaa1JntrFnPb8BrV3sHrcFZrXFOlrTrp8Uay7
   cuSxXaq4mwxJTNP9R9TX00megW79mGvJhNrzpgv6TIhfdNs0atPyhFcVS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="338292466"
X-IronPort-AV: E=Sophos;i="5.99,250,1677571200"; 
   d="scan'208";a="338292466"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 19:22:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="691409296"
X-IronPort-AV: E=Sophos;i="5.99,250,1677571200"; 
   d="scan'208";a="691409296"
Received: from yuzhongq-mobl.ccr.corp.intel.com (HELO [10.255.29.220]) ([10.255.29.220])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 19:22:44 -0700
Message-ID: <32dbc22a-421f-d513-c605-88d9c7538b0a@linux.intel.com>
Date:   Fri, 5 May 2023 10:22:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 11/21] KVM:VMX: Introduce CET VMCS fields and control
 bits
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     rick.p.edgecombe@intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-12-weijiang.yang@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230421134615.62539-12-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/2023 9:46 PM, Yang Weijiang wrote:
> CET (Control-flow Enforcement Technology) is a CPU feature used to prevent
> Return/Jump-Oriented Programming (ROP/JOP) attacks. CET introduces a new
> exception type, Control Protection (#CP), and two sub-features(SHSTK,IBT)
> to defend against ROP/JOP style control-flow subversion attacks.
>
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode.  When shadow stacks
>    are enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    signals a #CP.
>
> Indirect Branch Tracking (IBT):
>    IBT adds a new instrution, ENDBRANCH, that is used to mark valid target
/s/instrution/instruction

>    addresses of indirect branches (CALL, JMP, ENCLU[EEXIT], etc...). If an
>    indirect branch is executed and the next instruction is _not_ an
>    ENDBRANCH, the processor signals a #CP.
>
> Several new CET MSRs are defined to support CET:
>    MSR_IA32_{U,S}_CET: Controls the CET settings for user mode and kernel
>                        mode respectively.
>
>    MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for CPL-0,1,2,3
>                              protection respectively.
>
>    MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack pointer table.
According to the name of the MSR, it is interrupt related, right?
It's better to describe the MSR more precisely.

>
> Two XSAVES state bits are introduced for CET:
>    IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>    IA32_XSS:[bit 12]: Control saving/restoring kernel mode CET states.
>
> Six VMCS fields are introduced for CET:
>    {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>    {HOST,GUEST}_SSP: Stores shadow stack pointer of current active task/thread.
>    {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer table.
ditto

>
> If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored from
> the following VMCS fields at VM-Exit:
>    HOST_S_CET
>    HOST_SSP
>    HOST_INTR_SSP_TABLE
>
> If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded from
> the following VMCS fields at VM-Entry:
>    GUEST_S_CET
>    GUEST_SSP
>    GUEST_INTR_SSP_TABLE
>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/include/asm/vmx.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 498dc600bd5c..fe2aff27df8c 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -102,6 +102,7 @@
>   #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>   #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>   #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_LOAD_CET_STATE                  0x10000000
>   
>   #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>   
> @@ -115,6 +116,7 @@
>   #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>   #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>   #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> +#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
>   
>   #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>   
> @@ -343,6 +345,9 @@ enum vmcs_field {
>   	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
>   	GUEST_SYSENTER_ESP              = 0x00006824,
>   	GUEST_SYSENTER_EIP              = 0x00006826,
> +	GUEST_S_CET                     = 0x00006828,
> +	GUEST_SSP                       = 0x0000682a,
> +	GUEST_INTR_SSP_TABLE            = 0x0000682c,
>   	HOST_CR0                        = 0x00006c00,
>   	HOST_CR3                        = 0x00006c02,
>   	HOST_CR4                        = 0x00006c04,
> @@ -355,6 +360,9 @@ enum vmcs_field {
>   	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
>   	HOST_RSP                        = 0x00006c14,
>   	HOST_RIP                        = 0x00006c16,
> +	HOST_S_CET                      = 0x00006c18,
> +	HOST_SSP                        = 0x00006c1a,
> +	HOST_INTR_SSP_TABLE             = 0x00006c1c
>   };
>   
>   /*

