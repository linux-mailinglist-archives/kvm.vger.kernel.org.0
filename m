Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F168723599
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 05:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbjFFDJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 23:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbjFFDJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 23:09:20 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF7A118;
        Mon,  5 Jun 2023 20:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686020956; x=1717556956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZjPiHD2dLaeUV1DyYVTrMSjB4gNCH7qHbTFOV0ktpik=;
  b=mBymGkh6FrurtWg7NOk6vAQcdttcK01yTxzYFIMh3V2Dd0FAqmN2KqKd
   SHcvCQ4Ag0k22XL/INFnLUjk+GR73JfP0/w+blKvj16JiLcTqjHfIXRy9
   yIcBYJ8qlpID+Ffw2A15LTTRBTJGmuVgOmOF64vdt3dYFidT3VSA1BjlC
   BME2pZP5q0ZITsmCspVI+0kTmkn3Be3ckbGGuTXZ97hnJYDzQpjXmFgfO
   6yy6BY6hw6iDi94DAxuTiQ8Nx2kj/5mo3eqlKDk8cUFD4BaE+PwbZmHRK
   rhBWqHBToMpnQh/TBZsgXCWke/wqVumsMfy9Ow0sU8Wt2EjuGX71n41do
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="346145155"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="346145155"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 20:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659345977"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="659345977"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.170.218]) ([10.249.170.218])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 20:09:12 -0700
Message-ID: <2a7bd52d-441e-a8da-9c1b-dbc60f6bad7e@intel.com>
Date:   Tue, 6 Jun 2023 11:08:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Content-Language: en-US
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-4-guang.zeng@intel.com>
 <20230605140725.32ogo6gbhqyl4kfl@yy-desk-7060>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20230605140725.32ogo6gbhqyl4kfl@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/5/2023 10:07 PM, Yuan Yao wrote:
> On Thu, Jun 01, 2023 at 10:23:06PM +0800, Zeng Guang wrote:
>> Intel introduces LASS (Linear Address Separation) feature providing
>> an independent mechanism to achieve the mode-based protection.
>>
>> LASS partitions 64-bit linear address space into two halves, user-mode
>> address (LA[bit 63]=0) and supervisor-mode address (LA[bit 63]=1). It
>> stops any code execution or conditional data access[1]
>>      1. from user mode to supervisor-mode address space
>>      2. from supervisor mode to user-mode address space
>> and generates LASS violation fault accordingly.
>>
>> +/*
>> + * Determine whether an access to the linear address causes a LASS violation.
>> + * LASS protection is only effective in long mode. As a prerequisite, caller
>> + * should make sure vCPU running in long mode and invoke this api to do LASS
>> + * violation check.
>> + */
>> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags)
>> +{
>> +	bool user_mode, user_as, rflags_ac;
>> +
>> +	if (!!(flags & X86EMUL_F_SKIPLASS) ||
>> +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
>> +		return false;
>> +
>> +	WARN_ON_ONCE(!is_long_mode(vcpu));
>> +
>> +	user_as = !(la >> 63);
>> +
>> +	/*
>> +	 * An access is a supervisor-mode access if CPL < 3 or if it implicitly
>> +	 * accesses a system data structure. For implicit accesses to system
>> +	 * data structure, the processor acts as if RFLAGS.AC is clear.
>> +	 */
>> +	if (access & PFERR_IMPLICIT_ACCESS) {
>> +		user_mode = false;
>> +		rflags_ac = false;
>> +	} else {
>> +		user_mode = vmx_get_cpl(vcpu) == 3;
>> +		if (!user_mode)
>> +			rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>> +	}
>> +
>> +	if (user_mode == user_as)
> Confused by user_as, it's role of address(U/S) so how about
> "user_addr" ? "if (user_mode == user_addr)" looks more clear
> to me.
>
Actually "as" stands for "address space". I suppose it more precise. :)
