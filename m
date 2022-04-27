Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC335120FB
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiD0SgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiD0SfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 14:35:09 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52111155;
        Wed, 27 Apr 2022 11:22:21 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1njmIg-0001kz-B8; Wed, 27 Apr 2022 20:22:06 +0200
Message-ID: <97fdc9bf-2a33-3ca9-cee8-6e88fd0c5d2c@maciej.szmigiero.name>
Date:   Wed, 27 Apr 2022 20:21:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <6991d5b3-0e42-207b-2da3-63dda27e0784@maciej.szmigiero.name>
Subject: Re: [PATCH v2 00/11] KVM: SVM: Fix soft int/ex re-injection
In-Reply-To: <6991d5b3-0e42-207b-2da3-63dda27e0784@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.04.2022 01:01, Maciej S. Szmigiero wrote:
> On 23.04.2022 04:14, Sean Christopherson wrote:
>> Fix soft interrupt/exception reinjection on SVM.
>>
> 
> Thanks for the patch set Sean, I can't see anything being obviously wrong
> during a static code review - just small nits.
> 
> Will test it practically tomorrow and report the results.

I've tested this patch set and it seems to work fine with respect
to soft {exception,interrupt} re-injection and next_rip field consistency.

I have prepared a draft of an updated version at [1] with the following
further changes:
* "Downgraded" the commit affecting !nrips CPUs to just drop nested SVM
support for such parts instead of SVM support in general,

* Added a fix for L1/L2 NMI state confusion during L1 -> L2 NMI re-injection,

* Updated the new KVM self-test to also check for the NMI injection
scenario being fixed (that was found causing issues with a real guest),

* Changed "kvm_inj_virq" trace event "reinjected" field type to bool.

Will post a v3 patch set (with proper SoBs, etc.) if there are no further
comments or objections.

Thanks,
Maciej

[1]: https://github.com/maciejsszmigiero/linux/commits/svm_next_rip-sc
