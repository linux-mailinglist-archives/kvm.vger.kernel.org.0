Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330FF6D588D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 08:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjDDGPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 02:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDDGPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 02:15:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AA62D78
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 23:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680588910; x=1712124910;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CrK2If2rSAseB71Nd7AamQfkvRB/x4rIfO062Pj00gM=;
  b=XwCgXLaWW0Yb0uT9xnszqk8Gccp6sEHusLSKGM7SwBHr+hOa/axEz4yn
   Ctitnb58lg+Vlz3H7zcYpPyPCw8/dyZILCrKqZeNhc9H2B0kc59hk62A2
   73earqVkzMoYKbjTfNBCj4z0VKYxp1Wjn+nqQz402KuGIFyOPBXnlT8MH
   OudTb9idGtKcx4NljyZdLHPZeriZkpJ3Dwiu6IlKrgLItxYEc2dmZ08+/
   TaRyImZqhaDIbNuiHDBrVk6NoTANLr7TIMP3Ld339qC/fcjVID9O8Pm2C
   EJjkRf1g8KsMjdp2VkBy5urtyArew5TU5I972QYYEBUQpb9knUdAYNAp6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="343799563"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="343799563"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 23:14:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="797391195"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="797391195"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.140]) ([10.254.215.140])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 23:14:57 -0700
Message-ID: <ecb442b3-b846-30da-20dc-5b83f10e8bdf@linux.intel.com>
Date:   Tue, 4 Apr 2023 14:14:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com>
 <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
 <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
 <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
 <ZCR2PBx/4lj9X0vD@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZCR2PBx/4lj9X0vD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/30/2023 1:34 AM, Sean Christopherson wrote:
> On Wed, Mar 29, 2023, Binbin Wu wrote:
>> On 3/29/2023 10:04 AM, Huang, Kai wrote:
>>> On Wed, 2023-03-29 at 09:27 +0800, Binbin Wu wrote:
>>>> On 3/29/2023 7:33 AM, Huang, Kai wrote:
>>>>> On Tue, 2023-03-21 at 14:35 -0700, Sean Christopherson wrote:
>>>>>> On Mon, Mar 20, 2023, Chao Gao wrote:
>>>>>>> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>>>>>>>> get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>>>>>>>> to check 64-bit mode. Should use is_64_bit_mode() instead.
>>>>>>>>
>>>>>>>> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>>>>>>>> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
>>>>>>> It is better to split this patch into two: one for nested and one for
>>>>>>> SGX.
>>>>>>>
>>>>>>> It is possible that there is a kernel release which has just one of
>>>>>>> above two flawed commits, then this fix patch cannot be applied cleanly
>>>>>>> to the release.
>>>>>> The nVMX code isn't buggy, VMX instructions #UD in compatibility mode, and except
>>>>>> for VMCALL, that #UD has higher priority than VM-Exit interception.  So I'd say
>>>>>> just drop the nVMX side of things.
>>>>> But it looks the old code doesn't unconditionally inject #UD when in
>>>>> compatibility mode?
>>>> I think Sean means VMX instructions is not valid in compatibility mode
>>>> and it triggers #UD, which has higher priority than VM-Exit, by the
>>>> processor in non-root mode.
>>>>
>>>> So if there is a VM-Exit due to VMX instruction , it is in 64-bit mode
>>>> for sure if it is in long mode.
>>> Oh I see thanks.
>>>
>>> Then is it better to add some comment to explain, or add a WARN() if it's not in
>>> 64-bit mode?
>> I also prefer to add a comment if no objection.
>>
>> Seems I am not the only one who didn't get itï¿½ : )
> I would rather have a code change than a comment, e.g.
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f63b28f46a71..0460ca219f96 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4931,7 +4931,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>          int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
>          bool base_is_valid  = !(vmx_instruction_info & (1u << 27));
>   
> -       if (is_reg) {
> +       if (is_reg ||
> +           WARN_ON_ONCE(is_long_mode(vcpu) && !is_64_bit_mode(vcpu))) {
>                  kvm_queue_exception(vcpu, UD_VECTOR);
>                  return 1;
>          }
>
>
> The only downside is that querying is_64_bit_mode() could unnecessarily trigger a
> VMREAD to get the current CS.L bit, but a measurable performance regressions is
> extremely unlikely because is_64_bit_mode() all but guaranteed to be called in
> these paths anyways (and KVM caches segment info), e.g. by kvm_register_read().
>
> And then in a follow-up, we should also be able to do:
>
> @@ -5402,7 +5403,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>          if (instr_info & BIT(10)) {
>                  kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value);
>          } else {
> -               len = is_64_bit_mode(vcpu) ? 8 : 4;
> +               len = is_long_mode(vcpu) ? 8 : 4;
>                  if (get_vmx_mem_address(vcpu, exit_qualification,
>                                          instr_info, true, len, &gva))
>                          return 1;
> @@ -5476,7 +5477,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>          if (instr_info & BIT(10))
>                  value = kvm_register_read(vcpu, (((instr_info) >> 3) & 0xf));
>          else {
> -               len = is_64_bit_mode(vcpu) ? 8 : 4;
> +               len = is_long_mode(vcpu) ? 8 : 4;
>                  if (get_vmx_mem_address(vcpu, exit_qualification,
>                                          instr_info, false, len, &gva))
>                          return 1;

Agree to replace is_64_bit_mode() with is_long_mode().
But, based on the implementation and comment of 
nested_vmx_check_permission(),
do you think it still needs to add the check for compatibility mode?


