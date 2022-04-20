Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F04508B8E
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379973AbiDTPJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiDTPI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:08:58 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670D237AB7;
        Wed, 20 Apr 2022 08:06:10 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nhBtr-0000AB-0t; Wed, 20 Apr 2022 17:05:47 +0200
Message-ID: <98fca5c8-ca8e-be1f-857d-3d04041b66d7@maciej.szmigiero.name>
Date:   Wed, 20 Apr 2022 17:05:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/8] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-2-seanjc@google.com>
 <112c2108-7548-f5bd-493d-19b944701f1b@maciej.szmigiero.name>
 <YkspIjFMwpMYWV05@google.com>
 <4505b43d-5c33-4199-1259-6d4e8ebac1ec@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <4505b43d-5c33-4199-1259-6d4e8ebac1ec@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.04.2022 17:00, Paolo Bonzini wrote:
> On 4/4/22 19:21, Sean Christopherson wrote:
>> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
>>>> @@ -1606,7 +1622,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>>>        nested_copy_vmcb_control_to_cache(svm, ctl);
>>>>        svm_switch_vmcb(svm, &svm->nested.vmcb02);
>>>> -    nested_vmcb02_prepare_control(svm);
>>>> +    nested_vmcb02_prepare_control(svm, save->rip);
>>>
>>>                        ^
>>> I guess this should be "svm->vmcb->save.rip", since
>>> KVM_{GET,SET}_NESTED_STATE "save" field contains vmcb01 data,
>>> not vmcb{0,1}2 (in contrast to the "control" field).
>>
>> Argh, yes.  Is userspace required to set L2 guest state prior to KVM_SET_NESTED_STATE?
>> If not, this will result in garbage being loaded into vmcb02.
>>
> 
> Let's just require X86_FEATURE_NRIPS, either in general or just to
> enable nested virtualiazation

👍

> 
> If I looked it up correctly it was introduced around 2010-2011.

A quick Internet search showed that the first CPUs with NextRIP were
the second-generation Family 10h CPUs (Phenom II, Athlon II, etc.).
They started being released in early 2009.

> Paolo

Thanks,
Maciej
