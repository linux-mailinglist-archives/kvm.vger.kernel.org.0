Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6225A4D665A
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 17:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbiCKQbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 11:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiCKQb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 11:31:28 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383F51C65C5;
        Fri, 11 Mar 2022 08:30:24 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nSi9Z-0000nv-Cq; Fri, 11 Mar 2022 17:30:09 +0100
Message-ID: <d04e096a-b12e-91e2-204e-b3643a62d705@maciej.szmigiero.name>
Date:   Fri, 11 Mar 2022 17:30:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220311032801.3467418-1-seanjc@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Sean,

On 11.03.2022 04:27, Sean Christopherson wrote:
> The main goal of this series is to fix KVM's longstanding bug of not
> honoring L1's exception intercepts wants when handling an exception that
> occurs during delivery of a different exception.  E.g. if L0 and L1 are
> using shadow paging, and L2 hits a #PF, and then hits another #PF while
> vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
> KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
> so that the #PF is routed to L1, not injected into L2 as a #DF.
> 
> nVMX has hacked around the bug for years by overriding the #PF injector
> for shadow paging to go straight to VM-Exit, and nSVM has started doing
> the same.  The hacks mostly work, but they're incomplete, confusing, and
> lead to other hacky code, e.g. bailing from the emulator because #PF
> injection forced a VM-Exit and suddenly KVM is back in L1.

Looks like we were working on similar KVM area recently [1].

It look like parts of our patch sets touch the same code.
Since your patch set is much bigger and comprehensive I will base mine on
top of yours once there are no more incoming review comments for your
patch set (in other words, once it is in its final form).

Thanks,
Maciej

[1]: https://lore.kernel.org/kvm/cover.1646944472.git.maciej.szmigiero@oracle.com/
