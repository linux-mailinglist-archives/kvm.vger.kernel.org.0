Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6959F6C3F6F
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCVBJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCVBJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:09:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15486193DB
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679447349; x=1710983349;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dNGlxH/wnFQTpHNgG8H8livtxTeFmwXwaQsYaEdEclE=;
  b=GAokDfsLBbqZlofxjiY88JI2wasSEHJLm1V8cPFkHlmFPM+4hSnG/BMU
   JXSEiBHXoltYkO1KOBPWmVzF7MlSuXYO+HL/QdVhod5UQ3RJZ35Mnw9YJ
   43W43TVUsEJCeBVzL4agEjtetfnVvZyR/VfwmodFKyz7u8WyWvAdIOkIc
   QnDrgzyaPl+gQwomwPLjmvy3naU841SS3T5MJ3+9I2tnUA+kuWUTr+jER
   x7IfaH5OF5rJK9qNgQ2HsFvlefsGdgCOjjkdqXQl5ieSXVbGH0n57aIZg
   mxJB4xx9Tee9rUP3KKEzdiVXHzG5xJ8wNCD3Y2b1RG5/AuQzHpoAe5Sv/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403982605"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="403982605"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 18:09:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="714218923"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="714218923"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.235]) ([10.238.8.235])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 18:09:07 -0700
Message-ID: <06f054fc-7497-feda-1141-fdc7af0921ba@linux.intel.com>
Date:   Wed, 22 Mar 2023 09:09:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit
 mode
To:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
 <ZBojJgTG/SNFS+3H@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZBojJgTG/SNFS+3H@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/22/2023 5:35 AM, Sean Christopherson wrote:
> On Mon, Mar 20, 2023, Chao Gao wrote:
>> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
>>> get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
>>> to check 64-bit mode. Should use is_64_bit_mode() instead.
>>>
>>> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
>>> Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
>> It is better to split this patch into two: one for nested and one for
>> SGX.
>>
>> It is possible that there is a kernel release which has just one of
>> above two flawed commits, then this fix patch cannot be applied cleanly
>> to the release.
> The nVMX code isn't buggy, VMX instructions #UD in compatibility mode, and except
> for VMCALL, that #UD has higher priority than VM-Exit interception.  So I'd say
> just drop the nVMX side of things.

Got it.
Do you mind if I add a comment about it in code?


>
> I could have sworn ENCLS had the same behavior, but the SDM disagrees.  Though why
> on earth ENCLS is allowed in compatibility mode is beyond me.  ENCLU I can kinda
> sorta understand, but ENCLS?!?!!

Yes, the SDM does have definition about the behavior "outside 64-bit 
mode (IA32_EFER.LAM = 0 || CS.L = 0)".

IMO, the change has very little impact on performance since the two 
intercepted ENCLS leaf EINIT & ECREATE will
only be called once per lifecycle of a SGX Enclave.


