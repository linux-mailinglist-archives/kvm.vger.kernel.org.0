Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5AC4FD668
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353405AbiDLJ6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377914AbiDLHyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 03:54:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E425450461;
        Tue, 12 Apr 2022 00:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649748713; x=1681284713;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mbeK8xN/aT2y1KDi4aPNjhyj0fgSsuJe8W4E5qdpHtU=;
  b=DYRKegG3L/eT8AE8O2/AWbeUhlPqn6oBCTapUW/9Zgaa7kee7NNvw8vw
   h/BXLBPNJBd2JQqDAS+d3ibZg7pbjbHQZoz7bS0WmytU/AvRxFedAbQrf
   v2dWC94VTLXYemeYnN2hUKSjxSXLgZtQrYn2385MSNxEY2RVZwoCQr4tW
   8ZSEt00LoWr4dU7xbnhG7z7jJSZAPwKOkqoM4SUakajxvLSiMXCZSmZI4
   XmVGyu5LmqObe0a9db7CFXgBPJ92Mqi8/+YIzYwrJQqlaQSuC0Nz04W43
   xeBseQ5Sy7shRZ7Zq5f8gn/xrr/SVQDY07u/wCHe/515ol9ultOj8QY0e
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="242239700"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="242239700"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 00:31:53 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="724328119"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.202.123]) ([10.249.202.123])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 00:31:50 -0700
Message-ID: <59376a41-65a9-0efa-dad6-b5906d89fb3c@intel.com>
Date:   Tue, 12 Apr 2022 15:31:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 102/104] KVM: TDX: Add methods to ignore accesses
 to CPU state
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <3a278829a8617b86b36c32b68a82bc727013ace8.1646422845.git.isaku.yamahata@intel.com>
 <ec60ba8e-3ed9-1d06-d8c2-4db9529daf93@intel.com>
 <6e0fd8ac-5f17-44d9-97b7-285d4cbe6bcf@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <6e0fd8ac-5f17-44d9-97b7-285d4cbe6bcf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/2022 2:52 PM, Paolo Bonzini wrote:
> On 4/12/22 08:49, Xiaoyao Li wrote:
>>
>>> +void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>>> +{
>>> +    kvm_register_mark_available(vcpu, reg);
>>> +    switch (reg) {
>>> +    case VCPU_REGS_RSP:
>>> +    case VCPU_REGS_RIP:
>>> +    case VCPU_EXREG_PDPTR:
>>> +    case VCPU_EXREG_CR0:
>>> +    case VCPU_EXREG_CR3:
>>> +    case VCPU_EXREG_CR4:
>>> +        break;
>>> +    default:
>>> +        KVM_BUG_ON(1, vcpu->kvm);
>>> +        break;
>>> +    }
>>> +}
>>
>> Isaku,
>>
>> We missed one case that some GPRs are accessible by KVM/userspace for 
>> TDVMCALL exit.
> 
> If a register is not in the VMX_REGS_LAZY_LOAD_SET it will never be 
> passed to tdx_cache_reg.  As far as I understand those TDVMCALL 
> registers do not include either RSP or RIP.

Sorry, I should not keep the code snippet of tdx_cache_reg() as 
reference to mislead you and other people.

I just want to remind that in the certain case of TDVMCALL, GPRs might 
be accessible.

> Paolo
> 

