Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9038E6A1F78
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 17:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBXQR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 11:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBXQR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 11:17:26 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ED58679A9;
        Fri, 24 Feb 2023 08:17:22 -0800 (PST)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 390D120B9C3D;
        Fri, 24 Feb 2023 08:17:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 390D120B9C3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1677255441;
        bh=qRbpr0mo3xoPDxDkui69w/iMTWGJFuTVtDxTNoOJRKs=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=LiWSIIFlY9HGgMz2TB69jqOBWziWRArRGag+jg1fkk9mSZDQSuHwHtyhhKUJSGH6C
         yqYD6vP21yOFqwzJjU19q19mJqfJ/1H77aQcXl4R7+/CP9sX0dJHvHYOXTSBMq2DQy
         mduckMo9X9TVL8zRvUvd37jOiEgcxeIrTN3lfS+c=
Message-ID: <113888e0-ba94-deca-57a1-d3549d55a315@linux.microsoft.com>
Date:   Fri, 24 Feb 2023 17:17:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com>
 <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
 <Y+qLe42h9ZPRINrG@google.com>
 <CABgObfaZQOvt6v0yGz3MR7FBU7DcrTTGmS6M8RWCX0uy6WML1Q@mail.gmail.com>
 <20d189fc-8d20-8083-b448-460cc0420151@linux.microsoft.com>
 <Y+1ZpxAkome9s1Ve@google.com>
 <7e1d3590-2205-401c-c6f5-e4da534d85a7@linux.microsoft.com>
In-Reply-To: <7e1d3590-2205-401c-c6f5-e4da534d85a7@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/02/2023 15:40, Jeremi Piotrowski wrote:
> On 15/02/2023 23:16, Sean Christopherson wrote:
>> On Tue, Feb 14, 2023, Jeremi Piotrowski wrote:
>>> On 13/02/2023 20:56, Paolo Bonzini wrote:
>>>> On Mon, Feb 13, 2023 at 8:12 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>>> Depending on the performance results of adding the hypercall to
>>>>>> svm_flush_tlb_current, the fix could indeed be to just disable usage of
>>>>>> HV_X64_NESTED_ENLIGHTENED_TLB.
>>>>>
>>>>> Minus making nested SVM (L3) mutually exclusive, I believe this will do the trick:
>>>>>
>>>>> +       /* blah blah blah */
>>>>> +       hv_flush_tlb_current(vcpu);
>>>>> +
>>>>
>>>> Yes, it's either this or disabling the feature.
>>>>
>>>> Paolo
>>>
>>> Combining the two sub-threads: both of the suggestions:
>>>
>>> a) adding a hyperv_flush_guest_mapping(__pa(root->spt) after kvm_tdp_mmu_get_vcpu_root_hpa's call to tdp_mmu_alloc_sp()
>>> b) adding a hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa) to svm_flush_tlb_current()
>>>
>>> appear to work in my test case (L2 vm startup until panic due to missing rootfs).
>>>
>>> But in both these cases (and also when I completely disable HV_X64_NESTED_ENLIGHTENED_TLB)
>>> the runtime of an iteration of the test is noticeably longer compared to tdp_mmu=0.
>>
>> Hmm, what is test doing?
> 
> Booting through OVMF and kernel with no rootfs provided, and panic=-1 specified on the
> kernel command line. It's a pure startup time test.
> 

Hi Sean,

Have you been able to reproduce this by any chance?

I would be glad to see either of the two fixes getting merged (b) or a) if it doesn't require
special L3 nested handling) in order to get this regression resolved.

Jeremi
