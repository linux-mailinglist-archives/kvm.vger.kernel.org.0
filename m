Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEAE4B178D
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 22:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344592AbiBJV2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 16:28:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243233AbiBJV2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 16:28:43 -0500
X-Greylist: delayed 1671 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 13:28:41 PST
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399B7AF;
        Thu, 10 Feb 2022 13:28:41 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nIGYM-000368-37; Thu, 10 Feb 2022 22:00:34 +0100
Message-ID: <4524b1c9-3a32-8a2d-b7b8-5c4e65df017b@maciej.szmigiero.name>
Date:   Thu, 10 Feb 2022 22:00:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Michal Hocko <mhocko@suse.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Willy Tarreau <w@1wt.eu>
References: <1acaee7fa7ef7ab91e51f4417572b099caf2f400.1643405658.git.maciej.szmigiero@oracle.com>
 <YfRkivAI2P6urdfn@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] KVM: x86: Fix rmap allocation for very large memslots
In-Reply-To: <YfRkivAI2P6urdfn@google.com>
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

On 28.01.2022 22:47, Sean Christopherson wrote:
> On Fri, Jan 28, 2022, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") has
>> forbidden using kvmalloc() to make allocations larger than INT_MAX (2 GiB).
>>
>> Unfortunately, adding a memslot exceeding 1 TiB in size will result in rmap
>> code trying to make an allocation exceeding this limit.
>> Besides failing this allocation, such operation will also trigger a
>> WARN_ON_ONCE() added by the aforementioned commit.
>>
>> Since we probably still want to use kernel slab for small rmap allocations
>> let's only redirect such oversized allocations to vmalloc.
>>
>> A possible alternative would be to add some kind of a __GFP_LARGE flag to
>> skip the INT_MAX check behind kvmalloc(), however this will impact the
>> common kernel memory allocation code, not just KVM.
> 
> Paolo has a cleaner fix for this[1][2], but it appears to have stalled out somewhere.
> 
> Paolo???
> 
> [1] https://lore.kernel.org/all/20211015165519.135670-1-pbonzini@redhat.com
> [2] https://lore.kernel.org/all/20211016064302.165220-1-pbonzini@redhat.com

So, what we do here?

Apparently the cleaner fix at [2] wasn't picked up despite Kees giving
it his "Reviewed-by".

Thanks,
Maciej
