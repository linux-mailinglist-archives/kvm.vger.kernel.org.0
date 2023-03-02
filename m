Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70B26A810C
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCBLcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjCBLcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:32:03 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21D82A172
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677756718; x=1709292718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Qkx8FNYLV59mqWKTuyF26XdiQNQCIpCfE7LuOvEB9s=;
  b=l3BTGtG0ZGmTMZu301Z/Ha8fT/I+gE4sNtodrxtiJGi0ykxvmlOS2Sjx
   tcwA2Ny9VKtZZO5x4LTqd4g+6UOvkxoFaV3nXN8fCdPYniJDKXBEcC/8e
   ZgJCPF28aJT0OOX8Hu0o7uYl4R30tAQ7xHGEl/u71HIxkrJfBRYmjO9nm
   mgqw7bE9RxBq2HYaRX4d0lDA3VgHPLWlH/g7K5watnK6xX8Cyu1XzndJt
   l2SWBW5OrxV//AAXAqGRDFdwesqkMKaSVOK9M6tTHH4Qz/z3yA3NtZanu
   b5hUqDspxfdgwcMRkwsvnEat4l6tc85AxzpHMB8DUe8qQNepRRXSLCA1y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322970294"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="322970294"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 03:31:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="849051088"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="849051088"
Received: from akramak-mobl2.ger.corp.intel.com (HELO [10.249.169.115]) ([10.249.169.115])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 03:31:32 -0800
Message-ID: <cdd18331-ae32-42d3-7f90-ebcaf8c8f792@linux.intel.com>
Date:   Thu, 2 Mar 2023 19:31:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when emulating
 data access in 64-bit mode
To:     Chao Gao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-5-robert.hu@linux.intel.com>
 <ZABkb0wPffBt9W8u@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZABkb0wPffBt9W8u@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/2/2023 4:55 PM, Chao Gao wrote:
> On Mon, Feb 27, 2023 at 04:45:46PM +0800, Robert Hoo wrote:
>> Emulate HW LAM masking when doing data access under 64-bit mode.
>>
>> kvm_lam_untag_addr() implements this: per CR4/CR3 LAM bits configuration,
>> firstly check the linear addr conforms LAM canonical, i.e. the highest
>> address bit matches bit 63. Then mask out meta data per LAM configuration.
>> If failed in above process, emulate #GP to guest.
>>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> ---
>> arch/x86/kvm/emulate.c | 13 ++++++++
>> arch/x86/kvm/x86.h     | 70 ++++++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 83 insertions(+)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 5cc3efa0e21c..77bd13f40711 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -700,6 +700,19 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> 	*max_size = 0;
>> 	switch (mode) {
>> 	case X86EMUL_MODE_PROT64:
>> +		/* LAM applies only on data access */
>> +		if (!fetch && guest_cpuid_has(ctxt->vcpu, X86_FEATURE_LAM)) {
>> +			enum lam_type type;
>> +
>> +			type = kvm_vcpu_lam_type(la, ctxt->vcpu);
>> +			if (type == LAM_ILLEGAL) {
>> +				*linear = la;
>> +				goto bad;
>> +			} else {
>> +				la = kvm_lam_untag_addr(la, type);
>> +			}
>> +		}
>> +
>> 		*linear = la;
>> 		va_bits = ctxt_virt_addr_bits(ctxt);
>> 		if (!__is_canonical_address(la, va_bits))
> ...
>
>> +static inline u64 kvm_lam_untag_addr(u64 addr, enum lam_type type)
>> +{
>> +	switch (type) {
>> +	case LAM_U57:
>> +	case LAM_S57:
>> +		addr = __canonical_address(addr, 57);
>> +		break;
>> +	case LAM_U48:
>> +	case LAM_S48:
>> +		addr = __canonical_address(addr, 48);
>> +		break;
>> +	case LAM_NONE:
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return addr;
>> +}
> LAM's change to canonicality check is:
> before performing the check, software metadata in pointers is masked by
> sign-extending the value of bit 56/47.
>
> so, to emulate this behavior, in kvm_lam_untag_addr(), we can simply:
> 1. determine which LAM configuration is enabled, LAM57 or LAM48.
> 2. mask software metadata by sign-extending the bit56/47, i.e.,
>
> 	addr = (sign_extern64(addr, X) & ~BIT_ULL(63)) |
> 	       (addr & BIT_ULL(63));
>
> 	where X=56 for LAM57 and X=47 for LAM48.
>
> Note that this doesn't ensure the resulting @addr is canonical. It
> isn't a problem because the original canonicality check
> (__is_canonical_address() above) can identify non-canonical addresses
> and raise #GP/#SS to the guest.

Thanks for your suggestion. It's much simpler.


