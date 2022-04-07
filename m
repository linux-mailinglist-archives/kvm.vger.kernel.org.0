Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2CA4F75CA
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 08:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiDGGPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 02:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbiDGGPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 02:15:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156851C8DB8;
        Wed,  6 Apr 2022 23:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649311985; x=1680847985;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C3nT1yCtjX7kKzPi6gJkoB5VNcsfCgvLH5dyegPN6I0=;
  b=AZ7Q1KjSjGWovTeacTWtTQTzf9y+6shEcM4s5gwj0jxmzqemI/laNZVf
   sL1Ly/2qzvJ957nto0X0fQZfCQrtocD+AAtgTMA6dJaDFJ3uckNjJtt+L
   vGbZYQwmNhvzSGrolDfIw4FaRFNNtEQ0jspnqiI+L6TLZnkC3+M3BOYaZ
   Ny4QixdwjEl1WT7WszXjmLYJkhY37elpv1tpbQ8Y8RT7bRMZJ/eG62wFW
   bcdozJYypEYIooO+ixVduf6+0wFHNTJ2pXwYtLo6Odl2D6nzzubb9OqJt
   XmG2piGTqSZVtJqWc8P9pnijgfbtHdPKnUJv3S7KwoHU3sdcGxfUORIRj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="243373080"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="243373080"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 23:13:04 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="549880694"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.174.148]) ([10.249.174.148])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 23:13:01 -0700
Message-ID: <8347e6e3-5b22-c9c9-5e6b-9ea33c614d5a@intel.com>
Date:   Thu, 7 Apr 2022 14:12:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
 <20220318074955.22428-2-chenyi.qiang@intel.com> <YkzRSHHDMaVBQrxd@google.com>
 <YkzUceG4rhw15U3i@google.com> <Yk4C8gA2xVCrzgrG@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <Yk4C8gA2xVCrzgrG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/7/2022 5:15 AM, Sean Christopherson wrote:
> On Tue, Apr 05, 2022, Sean Christopherson wrote:
>> On Tue, Apr 05, 2022, Sean Christopherson wrote:
>>> On Fri, Mar 18, 2022, Chenyi Qiang wrote:
>>>> @@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>>>   		}
>>>>   	}
>>>>   
>>>> +	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
>>>> +		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>>>> +
>>>>   	kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>
>>> Looks correct, but this really needs a selftest, at least for the SET path since
>>> the intent is to use that for the NOTIFY handling.  Doesn't need to be super fancy,
>>> e.g. do port I/O from L2, inject a triple fault, and verify L1 sees the appropriate
>>> exit.
>>>
>>> Aha!  And for the GET path, abuse KVM_X86_SET_MCE with CR4.MCE=0 to coerce KVM into
>>> making a KVM_REQ_TRIPLE_FAULT, that way there's no need to try and hit a timing
>>> window to intercept the request.
>>
>> Drat, I bet that MCE path means the WARN in nested_vmx_vmexit() can be triggered
>> by userspace.  If so, this patch makes it really, really easy to hit, e.g. queue the
>> request while L2 is active, then do KVM_SET_NESTED_STATE to force an "exit" without
>> bouncing through kvm_check_nested_events().
>>
>>    WARN_ON_ONCE(kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
>>
>> I don't think SVM has a user-triggerable WARN, but the request should still be
>> dropped on forced exit from L2, e.g. I believe this is the correct fix:
> 
> Confirmed the WARN can be triggered by abusing this patch, I'll get a patch out
> once I figure out why kvm/queue is broken.
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index 2e0a92da8ff5..b7faeae3dcc4 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -210,6 +210,12 @@ int main(int argc, char *argv[])
>                  memset(&regs1, 0, sizeof(regs1));
>                  vcpu_regs_get(vm, VCPU_ID, &regs1);
> 
> +               if (stage == 6) {
> +                       state->events.flags |= 0x20;
> +                       vcpu_events_set(vm, VCPU_ID, &state->events);
> +                       vcpu_nested_state_set(vm, VCPU_ID, &state->nested, false);
> +               }
> +
>                  kvm_vm_release(vm);
> 
>                  /* Restore state in a new VM.  */

Also verified the WARN with this. Then, is it still necessary to add an 
individual selftest about the working flow of save/restore triple fault 
event?

> 
