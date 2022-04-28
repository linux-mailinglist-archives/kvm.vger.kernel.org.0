Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CBE513519
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 15:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347395AbiD1Naj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 09:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347383AbiD1Naf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 09:30:35 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEBFB18A0;
        Thu, 28 Apr 2022 06:27:19 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nk4Al-0004RG-SE; Thu, 28 Apr 2022 15:27:07 +0200
Message-ID: <4baa5071-3fb6-64f3-bcd7-2ffc1181d811@maciej.szmigiero.name>
Date:   Thu, 28 Apr 2022 15:27:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 02/11] KVM: SVM: Don't BUG if userspace injects a soft
 interrupt with GIF=0
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220423021411.784383-1-seanjc@google.com>
 <20220423021411.784383-3-seanjc@google.com>
 <61ad22d6de1f6a51148d2538f992700cac5540d4.camel@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <61ad22d6de1f6a51148d2538f992700cac5540d4.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.04.2022 09:35, Maxim Levitsky wrote:
> On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
>> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>
>> Don't BUG/WARN on interrupt injection due to GIF being cleared if the
>> injected event is a soft interrupt, which are not actually IRQs and thus
> 
> Are any injected events subject to GIF set? I think that EVENTINJ just injects
> unconditionaly whatever hypervisor puts in it.

That's right, EVENTINJ will pretty much always inject, even when the CPU
is in a 'wrong' state (like for example, injecting a hardware interrupt
or a NMI with GIF masked).

But KVM as a L0 is not supposed to inject a hardware interrupt into guest
with GIF unset since the guest is obviously not expecting it then.
Hence this WARN_ON().

> Best regards,
> 	Maxim Levitsky

Thanks,
Maciej
