Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130FB6EA6B8
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDUJOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjDUJOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:14:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACE4A257
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 02:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682068439; x=1713604439;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VV550qoFM/qnnHJlwWwPuUI2gc6dxpn9Y8z5GmWFXP8=;
  b=DHcrBZEgdJ/aT5Y/H2x6JpmHlH2gRlXf0X54wKhHSBfieZw0P1M7H+p0
   996BT0+u/qtFyqZDxQL6WSZg3bHPhaTaUrV8EljLGAA8TbMuVAOjvYy23
   M/iVgZcIo5qIN5ZuNHQ+njf4khPb8tUXB+3WmAlbH9U2V8fJFDYbdirVg
   yTywYBUreb0LXIQyoyN5gXer2VmvuHEZAN3rBmEHNxfuHFNkSdusK+HPO
   uZdIREMU54p++UH7QMmLarYGo61xlWik9UtHFdpFGi2jkVxC7NLF4KLsf
   9YQvyE4XVqSrY98ifJi2lRIYhzF6sUwwfwyk2HuhV/uP7v/o5wtkaoS2g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="432228119"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="432228119"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:13:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="761505043"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="761505043"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.158]) ([10.254.214.158])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:13:57 -0700
Message-ID: <2980bc42-88e0-9eff-0b88-084341c4d61a@linux.intel.com>
Date:   Fri, 21 Apr 2023 17:13:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kai.huang@intel.com, xuelian.guo@intel.com,
        robert.hu@linux.intel.com
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-5-binbin.wu@linux.intel.com>
 <ZD+NiODiAiIY55Fx@chao-env>
 <f1d564d1-572e-75fc-aa68-05b52abc2914@linux.intel.com>
 <ZEJLGGUPD5PFJ0at@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZEJLGGUPD5PFJ0at@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/2023 4:36 PM, Chao Gao wrote:
> On Fri, Apr 21, 2023 at 03:57:15PM +0800, Binbin Wu wrote:
>>>> --- a/arch/x86/kvm/emulate.c
>>>> +++ b/arch/x86/kvm/emulate.c
>>>> @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>>>> 				       struct segmented_address addr,
>>>> 				       unsigned *max_size, unsigned size,
>>>> 				       bool write, bool fetch,
>>>> -				       enum x86emul_mode mode, ulong *linear)
>>>> +				       enum x86emul_mode mode, ulong *linear,
>>>> +				       u64 untag_flags)
>>> @write and @fetch are like flags. I think we can consolidate them into
>>> the @flags first as a cleanup patch and then add a flag for LAM.
>> OK. Here is the proposed cleanup patch:
> looks good to me
>
>>
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -48,6 +48,15 @@ void kvm_spurious_fault(void);
>>   #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX USHRT_MAX
>>   #define KVM_SVM_DEFAULT_PLE_WINDOW     3000
>>
>> +/* x86-specific emulation flags */
>> +#define KVM_X86_EMULFLAG_FETCH                 _BITULL(0)
>> +#define KVM_X86_EMULFLAG_WRITE                 _BITULL(1)
> Can we move the definitions to arch/x86/kvm/kvm_emulate.h?

Then, the flags needs to be removed from .untag_addr() interface since 
currently
KVM_X86_EMULFLAG_SKIP_UNTAG_VMX is used in vmx. :(



>
>>
>> And the following two will be defined for untag:
>>
>> #define KVM_X86_EMULFLAG_SKIP_UNTAG_VMX     _BITULL(2)
>> #define KVM_X86_EMULFLAG_SKIP_UNTAG_SVM     _BITULL(3) /* reserved for SVM */
>>
>>
