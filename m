Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6550A65F48F
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbjAETe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbjAETed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:34:33 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC83DE96
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 11:32:41 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDVyg-0017ja-FH; Thu, 05 Jan 2023 20:32:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=ZsoM7Qcg3UVn27+XKOiU6qcMJbUpQRGqju/2dcMWNQs=; b=Ze6RJVda911piQpfsiJJBpQdCl
        RjKWhQa3ijT8eMPrgcFgyp9fPYECn1mwII57lFDTMZI39U1FqiMIT3Sb2HRAejmDrRFx7QrG4e9DZ
        Lcy24kpFKw0ANZNkc7DhxFTtFP4xq0tCz+N7BvXDliB+HzBqgnIwry77XOXWsUApREJ/Wnp2G5Txn
        r8/w992JoC99MQ8wZcnSjWG33O3abxq4n1sZVE9odrlF44f5VUeR/4fnwn38A9RQWgmSeEdXeOmfn
        scfOeiCiVICrUEsZSz9mUBHdR0QP8IdngOJS+/E6wj1tH6l9qLeSVOEvdtfIxAgBXfZMahusg4COQ
        3qB4wmng==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDVyf-0000NT-On; Thu, 05 Jan 2023 20:32:37 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDVyS-00067l-GJ; Thu, 05 Jan 2023 20:32:24 +0100
Message-ID: <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
Date:   Thu, 5 Jan 2023 20:32:23 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Content-Language: pl-PL, en-GB-large
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        paul@xen.org
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co> <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y7RjL+0Sjbm/rmUv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/23 18:17, Sean Christopherson wrote:
> On Thu, Dec 29, 2022, Michal Luczaj wrote:
>> Move synchronize_srcu(&kvm->srcu) out of kvm->lock critical section.
> 
> This needs a much more descriptive changelog, and an update to
> Documentation/virt/kvm/locking.rst to define the ordering requirements between
> kvm->scru and kvm->lock.  And IIUC, there is no deadlock in the current code
> base, so this really should be a prep patch that's sent along with the Xen series[*]
> that wants to take kvm->-srcu outside of kvm->lock.
> 
> [*] https://lore.kernel.org/all/20221222203021.1944101-2-mhal@rbox.co

I'd be happy to provide a more descriptive changelog, but right now I'm a
bit confused. I'd be really grateful for some clarifications:

I'm not sure how to understand "no deadlock in the current code base". I've
ran selftests[1] under the up-to-date mainline/master and I do see the
deadlocks. Is there a branch where kvm_xen_set_evtchn() is not taking
kvm->lock while inside kvm->srcu?

Also, is there a consensus as for the lock ordering? IOW, is the state of
virt/kvm/locking.rst up to date, regardless of the discussion going on[2]?

[1] https://lore.kernel.org/kvm/15599980-bd2e-b6c2-1479-e1eef02da0b5@rbox.co/
[2] https://lore.kernel.org/kvm/Y7RpB+trpnhVRhQW@google.com/

thanks,
Michal
