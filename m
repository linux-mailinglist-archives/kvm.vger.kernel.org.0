Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FB76CCF79
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 03:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjC2B1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 21:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjC2B1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 21:27:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723DD2700
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 18:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680053231; x=1711589231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vvzs+6O5p8/UteczypXjM7DDL2Cf734qdip5bLd2kx0=;
  b=RXtR3gKs9BltK82OVn1qAWS1nbr1RTKUyPKos9NMNvuCQdkB/ZFBFsOL
   GVsgBD0NqyBK70KuIM0ogfZWt2WTVZaAicfHONsfrSgPug54gSme2zTlC
   diKnsJ+68D2wDs67om2mVj+X7AkVnoOcOJu5ExYJnJMliFLkeQv2uDmIs
   kcmPOZrUdVCa1DZPUphtrxViOWUBpQPUDic9H8WdRMOUkgMnBBpJ26FN2
   uMzvSUor7TvzZXAMgbosY9EJudhbCOP+Sxi2Ugj2i2CKPirQ1+v2pGln2
   nypQEmrWN2Zq/mz6prcy/cd2EpqXZJC4KO2LB/do2iPkrfbD/ujwGVfEG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403362499"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="403362499"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 18:27:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="795025275"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="795025275"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.227]) ([10.238.2.227])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 18:27:09 -0700
Message-ID: <e0442b13-09f4-0985-3eb4-9b6a20d981fb@linux.intel.com>
Date:   Wed, 29 Mar 2023 09:27:07 +0800
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
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <12c4f1d3c99253f364f3945a998fdccb0ddf300f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/2023 7:33 AM, Huang, Kai wrote:
> On Tue, 2023-03-21 at 14:35 -0700, Sean Christopherson wrote:
>> On Mon, Mar 20, 2023, Chao Gao wrote:
>>> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>>>> get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>>>> to check 64-bit mode. Should use is_64_bit_mode() instead.
>>>>
>>>> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>>>> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
>>> It is better to split this patch into two: one for nested and one for
>>> SGX.
>>>
>>> It is possible that there is a kernel release which has just one of
>>> above two flawed commits, then this fix patch cannot be applied cleanly
>>> to the release.
>> The nVMX code isn't buggy, VMX instructions #UD in compatibility mode, and except
>> for VMCALL, that #UD has higher priority than VM-Exit interception.  So I'd say
>> just drop the nVMX side of things.
> But it looks the old code doesn't unconditionally inject #UD when in
> compatibility mode?

I think Sean means VMX instructions is not valid in compatibility mode 
and it triggers #UD, which has higher priority than VM-Exit, by the 
processor in non-root mode.

So if there is a VM-Exit due to VMX instruction , it is in 64-bit mode 
for sure if it is in long mode.


>
>          /* Checks for #GP/#SS exceptions. */
>          exn = false;
>          if (is_long_mode(vcpu)) {
>                  /*
>                   * The virtual/linear address is never truncated in 64-bit
>                   * mode, e.g. a 32-bit address size can yield a 64-bit virtual
>                   * address when using FS/GS with a non-zero base.
>                   */
>                  if (seg_reg == VCPU_SREG_FS || seg_reg == VCPU_SREG_GS)
>                          *ret = s.base + off;
>                  else
>                          *ret = off;
>                                                                                                                                                     
>                  /* Long mode: #GP(0)/#SS(0) if the memory address is in a
>                   * non-canonical form. This is the only check on the memory
>                   * destination for long mode!
>                   */
>                  exn = is_noncanonical_address(*ret, vcpu);
> 	}
> 	...
>
> The logic of only adding seg.base for FS/GS to linear address (and ignoring
> seg.base for all other segs) only applies to 64 bit mode, but the code only
> checks _long_ mode.
>
> Am I missing something?
>   
>> I could have sworn ENCLS had the same behavior, but the SDM disagrees.  Though why
>> on earth ENCLS is allowed in compatibility mode is beyond me.  ENCLU I can kinda
>> sorta understand, but ENCLS?!?!!
> I can reach out to Intel guys to (try to) find the answer if you want me to? :)
