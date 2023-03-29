Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B986CCFCC
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjC2CJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjC2CI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:08:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B9A10F3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 19:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680055734; x=1711591734;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4KGcO5VOL6UBfQZ3fM6VUduT4bLP8gUcEQzTg+b15E4=;
  b=TLvktdYysNQCpZo6+X5ChV2bDinnSgygBnMcnfW6vX+HFrdxhQntE2Ny
   Y32Len+h3JqiXx0i2BA6HyYtAam/K8h4QwxA7kjtDM7Erds3d00PBzeVo
   35Ku2UDIk/H/vRaSu385OYg6unOL/aEsUZL7q4Ynlp/3QPXYWoks1/2J2
   5krPF905ZSUsAtiPBMoXITau/Pce9BTrxZcbLT98Es9wdJJPVKOVgrAHA
   jkeBS5Uwz1IQNOib7CTO67p3ByMJ6LiIYEsbDFjMswgx0KbmFmMEjbO6s
   oQYISnJXfSqFDhpfEwkSq/EUfzprnwfkkJI4YeSWNdyN6xz75X1iiUE8Z
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="321149662"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="321149662"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="716704432"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="716704432"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.227]) ([10.238.2.227])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:08:51 -0700
Message-ID: <b9e9dd1c-2213-81c7-cd45-f5cf7b86610b@linux.intel.com>
Date:   Wed, 29 Mar 2023 10:08:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     "Huang, Kai" <kai.huang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com>
 <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
 <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
 <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <682d01dec42ecdb80c9d3ffa2902dea3b1d576dd.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/2023 10:04 AM, Huang, Kai wrote:
> On Wed, 2023-03-29 at 09:27 +0800, Binbin Wu wrote:
>> On 3/29/2023 7:33 AM, Huang, Kai wrote:
>>> On Tue, 2023-03-21 at 14:35 -0700, Sean Christopherson wrote:
>>>> On Mon, Mar 20, 2023, Chao Gao wrote:
>>>>> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>>>>>> get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>>>>>> to check 64-bit mode. Should use is_64_bit_mode() instead.
>>>>>>
>>>>>> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>>>>>> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
>>>>> It is better to split this patch into two: one for nested and one for
>>>>> SGX.
>>>>>
>>>>> It is possible that there is a kernel release which has just one of
>>>>> above two flawed commits, then this fix patch cannot be applied cleanly
>>>>> to the release.
>>>> The nVMX code isn't buggy, VMX instructions #UD in compatibility mode, and except
>>>> for VMCALL, that #UD has higher priority than VM-Exit interception.  So I'd say
>>>> just drop the nVMX side of things.
>>> But it looks the old code doesn't unconditionally inject #UD when in
>>> compatibility mode?
>> I think Sean means VMX instructions is not valid in compatibility mode
>> and it triggers #UD, which has higher priority than VM-Exit, by the
>> processor in non-root mode.
>>
>> So if there is a VM-Exit due to VMX instruction , it is in 64-bit mode
>> for sure if it is in long mode.
> Oh I see thanks.
>
> Then is it better to add some comment to explain, or add a WARN() if it's not in
> 64-bit mode?

I also prefer to add a comment if no objection.

Seems I am not the only one who didn't get it  : )

>
