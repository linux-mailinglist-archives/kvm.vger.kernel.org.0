Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCDD4F1C0A
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380016AbiDDVVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380643AbiDDUso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 16:48:44 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3D713E9A;
        Mon,  4 Apr 2022 13:46:47 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nbTav-0003dN-Sm; Mon, 04 Apr 2022 22:46:37 +0200
Message-ID: <fde9cf47-b420-23c7-f974-480eb95da221@maciej.szmigiero.name>
Date:   Mon, 4 Apr 2022 22:46:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying the
 instruction
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <a3cf781b-0b1a-0bba-6b37-12666c7fc154@maciej.szmigiero.name>
 <YktIGHM86jHkzGdF@google.com> <YktM9bnq5HaTMKkV@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <YktM9bnq5HaTMKkV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4.04.2022 21:54, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Sean Christopherson wrote:
>> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
>>>>>> index 47e7427d0395..a770a1c7ddd2 100644
>>>>>> --- a/arch/x86/kvm/svm/svm.h
>>>>>> +++ b/arch/x86/kvm/svm/svm.h
>>>>>> @@ -230,8 +230,8 @@ struct vcpu_svm {
>>>>>>    	bool nmi_singlestep;
>>>>>>    	u64 nmi_singlestep_guest_rflags;
>>>>>> -	unsigned int3_injected;
>>>>>> -	unsigned long int3_rip;
>>>>>> +	unsigned soft_int_injected;
>>>>>> +	unsigned long soft_int_linear_rip;
>>>>>>    	/* optional nested SVM features that are enabled for this guest  */
>>>>>>    	bool nrips_enabled                : 1;
>>>>>
>>>>>
>>>>> I mostly agree with this patch, but think that it doesn't address the
>>>>> original issue that Maciej wanted to address:
>>>>>
>>>>> Suppose that there is *no* instruction in L2 code which caused the software
>>>>> exception, but rather L1 set arbitrary next_rip, and set EVENTINJ to software
>>>>> exception with some vector, and that injection got interrupted.
>>>>>
>>>>> I don't think that this code will support this.
>>>>
>>>> Argh, you're right.  Maciej's selftest injects without an instruction, but it doesn't
>>>> configure the scenario where that injection fails due to an exception+VM-Exit that
>>>> isn't intercepted by L1 and is handled by L0.  The event_inj test gets the coverage
>>>> for the latter, but always has a backing instruction.
>>>
>>> Still reviewing the whole patch set, but want to clear this point quickly:
>>> The selftest does have an implicit intervening NPF (handled by L0) while
>>> injecting the first L1 -> L2 event.
>>
>> I'll do some debug to figure out why the test passes for me.  I'm guessing I either
>> got lucky, e.g. IDT was faulted in already, or I screwed up and the test doesn't
>> actually pass.
> 
> Well that was easy.  My code is indeed flawed and skips the wrong instruction,
> the skipped instruction just so happens to be a (spurious?) adjustment of RSP.  The
> L2 guest function never runs to completion and so the "bad" RSP is never consumed.
>   
>     KVM: incomplete injection for L2, vector 32 @ 401c70.  next_rip = 0
>     KVM: injecting for L2, vector 0 @ 401c70.  next_rip = 401c74
> 
> 0000000000401c70 <l2_guest_code>:
>    401c70:       48 83 ec 08             sub    $0x8,%rsp
>    401c74:       83 3d 75 a7 0e 00 01    cmpl   $0x1,0xea775(%rip)        # 4ec3f0 <int_fired>
>    401c7b:       74 1e                   je     401c9b <l2_guest_code+0x2b>
>    401c7d:       45 31 c0                xor    %r8d,%r8d
>    401c80:       b9 32 00 00 00          mov    $0x32,%ecx
>    401c85:       ba 90 40 4b 00          mov    $0x4b4090,%edx
>    401c8a:       31 c0                   xor    %eax,%eax
>    401c8c:       be 02 00 00 00          mov    $0x2,%esi
>    401c91:       bf 02 00 00 00          mov    $0x2,%edi
>    401c96:       e8 05 ae 00 00          call   40caa0 <ucall>
>    401c9b:       0f 01 d9                vmmcall
>    401c9e:       0f 0b                   ud2
>    401ca0:       83 3d 4d a7 0e 00 01    cmpl   $0x1,0xea74d(%rip)        # 4ec3f4 <bp_fired>
>    401ca7:       74 1e                   je     401cc7 <l2_guest_code+0x57>
>    401ca9:       45 31 c0                xor    %r8d,%r8d
>    401cac:       b9 36 00 00 00          mov    $0x36,%ecx
>    401cb1:       ba b8 40 4b 00          mov    $0x4b40b8,%edx
>    401cb6:       31 c0                   xor    %eax,%eax
>    401cb8:       be 02 00 00 00          mov    $0x2,%esi
>    401cbd:       bf 02 00 00 00          mov    $0x2,%edi
>    401cc2:       e8 d9 ad 00 00          call   40caa0 <ucall>
>    401cc7:       f4                      hlt
>    401cc8:       48 83 c4 08             add    $0x8,%rsp
>    401ccc:       c3                      ret
>    401ccd:       0f 1f 00                nopl   (%rax)
> 
> I don't see why the compiler is creating room for a single variable, but it doesn't
> really matter, the easiest way to detect this bug is to assert that the return RIP
> in the INT 0x20 handler points at l2_guest_code, e.g. this fails:
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> index d39be5d885c1..257aa2280b5c 100644
> --- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
> @@ -40,9 +40,13 @@ static void guest_bp_handler(struct ex_regs *regs)
>   }
> 
>   static unsigned int int_fired;
> +static void l2_guest_code(void);
> +
>   static void guest_int_handler(struct ex_regs *regs)
>   {
>          int_fired++;
> +       GUEST_ASSERT_2(regs->rip == (unsigned long)l2_guest_code,
> +                      regs->rip, (unsigned long)l2_guest_code);
>   }
> 
>   static void l2_guest_code(void)

It totally makes sense to add the above as an additional assert to the
self test - the more checks the test have the better at catching bugs
it is.

Thanks,
Maciej
