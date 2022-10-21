Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD2E606DE1
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 04:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJUCkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 22:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiJUCkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 22:40:14 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E8D136427
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 19:40:09 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1olhx8-002n6F-F4; Fri, 21 Oct 2022 04:40:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=q4I7pgKWTXv8viVqRYt7sFYnq2RnraCwZHBZf4HVaho=; b=P+qvgs5yAJwoa3Ik0APhkLHh1S
        V8ZRd/c5b/+hULq5BcnHvMXlWAwVibEDGnhqf2aVU3zE81duBv9pMEKkSSvn+jZt6S06+fSKTagIt
        mArk8shSgnepTYE6ztp9BKRX4yxFR0chvWWTObunmQtrMkaw2MENjA3JYWOfoe0JGxSH1iE3ql++J
        xWg5gapT4bLYNdihPSP7Qi8mhIJtF5Nk44s0pnrLJXBnP66mSdKWXhWEbY8TAMCZPMOGmCu5Z09M7
        EOaEFNn5n3KQ3SHf0m/KTbPQBfCw7LT9LcZ7Cy1X4B5Afmk0ZGsM28ui2fIbLJn3sme3YG1VIXNnh
        +XoW7rDQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1olhx8-0001ek-3g; Fri, 21 Oct 2022 04:40:06 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1olhwu-00013a-Rj; Fri, 21 Oct 2022 04:39:52 +0200
Message-ID: <c0df3aef-286f-8eca-4079-bf9768cd3409@rbox.co>
Date:   Fri, 21 Oct 2022 04:39:51 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 8/8] KVM: x86: Fix NULL pointer dereference in
 kvm_xen_set_evtchn_fast()
Content-Language: pl-PL, en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-9-mhal@rbox.co> <Y0SquPNxS5AOGcDP@google.com>
 <Y0daPIFwmosxV/NO@google.com> <Y0h0/x3Fvn17zVt6@google.com>
 <0574dd3d-4272-fc93-50c0-ba2994e272ba@rbox.co> <Y1F+QdQglodavC1V@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y1F+QdQglodavC1V@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 18:58, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Michal Luczaj wrote:
>> Speaking about SCHEDOP_poll, are XEN vmcalls considered trusted?
> 
> I highly doubt they are trusted.

Does it mean a CPL3 guest can vmcall SCHEDOP_poll? If so, is the use of
kvm_mmu_gva_to_gpa_system() justified?

>> I've noticed that kvm_xen_schedop_poll() fetches guest-provided
>> sched_poll.ports without checking if the values are sane. Then, in
>> wait_pending_event(), there's test_bit(ports[i], pending_bits) which
>> (for some high ports[i] values) results in KASAN complaining about
>> "use-after-free":
>>
>> [   36.463417] ==================================================================
>> [   36.463564] BUG: KASAN: use-after-free in kvm_xen_hypercall+0xf39/0x1110 [kvm]
> 
> ...
> 
>> I can't reproduce it under non-KASAN build, I'm not sure what's going on.
> 
> KASAN is rightly complaining because, as you already pointed out, the high ports[i]
> value will touch memory well beyond the shinfo->evtchn_pending array.  Non-KASAN
> builds don't have visible failures because the rogue access is only a read, and
> the result of the test_bit() only affects whether or not KVM temporarily stalls
> the vCPU.  In other words, KVM is leaking host state to the guest, but there is
> no memory corruption and no functional impact on the guest.

OK, so such vCPU stall-or-not is a side channel leaking host memory bit by
bit, right? I'm trying to understand what is actually being leaked here.
Is it user space memory of process that is using KVM on the host?

> I think this would be the way to fix this particular mess?
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 93c628d3e3a9..5d09a47db732 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -961,7 +961,9 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
>         struct kvm *kvm = vcpu->kvm;
>         struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
>         unsigned long *pending_bits;
> +       unsigned long nr_bits;
>         unsigned long flags;
> +       evtchn_port_t port;
>         bool ret = true;
>         int idx, i;
>  
> @@ -974,13 +976,19 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
>         if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
>                 struct shared_info *shinfo = gpc->khva;
>                 pending_bits = (unsigned long *)&shinfo->evtchn_pending;
> +               nr_bits = sizeof(shinfo->evtchn_pending) * BITS_PER_BYTE;
>         } else {
>                 struct compat_shared_info *shinfo = gpc->khva;
>                 pending_bits = (unsigned long *)&shinfo->evtchn_pending;
> +               nr_bits = sizeof(shinfo->evtchn_pending) * BITS_PER_BYTE;
>         }
>  
>         for (i = 0; i < nr_ports; i++) {
> -               if (test_bit(ports[i], pending_bits)) {
> +               port = ports[i];
> +               if (port >= nr_bits)
> +                       continue;
> +
> +               if (test_bit(array_index_nospec(port, nr_bits), pending_bits)) {
>                         ret = true;
>                         break;
>                 }

Great, that looks good and passes the test.

Thanks,
Michal

