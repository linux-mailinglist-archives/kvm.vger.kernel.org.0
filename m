Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145BD62651D
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 00:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiKKXCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 18:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKKXCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 18:02:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428A611A3C
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 15:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D217C62118
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 23:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A60C433D6;
        Fri, 11 Nov 2022 23:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668207762;
        bh=rCl3hvT90i/LUm6JzXZchptE3HoIR1Q6GNgSNbCg0Y8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dS+OcfOx9r30Qn9zphgtoz6HH9cIQbWSQ+YzB8g9APccoYqZUb0MJ732A44pU6vyq
         yjT0EtyXx7aJLZZ77ivaPosspsBe6fP9vIbIBTBy1AaDYHaCdoZf1HqBnbk4CwG256
         J8jA3mDe+RwkIFXFu6hH2P2hYBJmfQaYNahu//Gf3qefj7TAAOgDpFlFgQKo7fXECi
         ppcmjkvzpAWt34nYwU7rwF0pHWQebuuBtgOC2SNL5k4gncxZmROMP2SRQyKpUvcndB
         BPF9wONaUxH6rgYsjqMKMeMvsyj6iNrAYugaW2d6S1hMDd27Jrbd2jtvDMRt2khw+I
         VehNTcxk6N3Ng==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1otd2l-005WgO-Lj;
        Fri, 11 Nov 2022 23:02:39 +0000
MIME-Version: 1.0
Date:   Fri, 11 Nov 2022 23:02:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
In-Reply-To: <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com> <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8f641d1f0e73a899c182d822de4911a9@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, seanjc@google.com, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com, pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-11-11 22:19, Gavin Shan wrote:
> Hi Marc,
> 
> On 11/11/22 11:19 PM, Marc Zyngier wrote:
>> On Thu, 10 Nov 2022 23:47:41 +0000,
>> Gavin Shan <gshan@redhat.com> wrote:
>>> 
>>> commit b05377ecbe003f12c8b79846fa3a300401dcab68 (HEAD -> 
>>> kvm/arm64_dirtyring)
>>> Author: Gavin Shan <gshan@redhat.com>
>>> Date:   Fri Nov 11 07:13:12 2022 +0800
>>> 
>>>      KVM: Push dirty information unconditionally to backup bitmap
>>>          In mark_page_dirty_in_slot(), we bail out when no running 
>>> vcpu
>>> exists and
>>>      a running vcpu context is strictly required by architecture. It 
>>> may cause
>>>      backwards compatible issue. Currently, saving vgic/its tables is 
>>> the only
>>>      case where no running vcpu context is required. We may have 
>>> other unknown
>>>      cases where no running vcpu context exists and it's reported by 
>>> the warning
>>>      message. For this, the application is going to enable the backup 
>>> bitmap for
>>>      the unknown cases. However, the dirty information can't be 
>>> pushed to the
>>>      backup bitmap even though the backup bitmap has been enabled, 
>>> until the
>>>      unknown cases are added to the allowed list of non-running vcpu 
>>> context
>>>      with extra code changes to the host kernel.
>>>          In order to make the new application, where the backup 
>>> bitmap
>>> has been
>>>      enabled, to work with the unchanged host, we continue to push 
>>> the dirty
>>>      information to the backup bitmap instead of bailing out early.
>>>          Suggested-by: Sean Christopherson <seanjc@google.com>
>>>      Signed-off-by: Gavin Shan <gshan@redhat.com>
>>> 
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 2719e10dd37d..03e6a38094c1 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -3308,8 +3308,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>          if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>>>                  return;
>>>   -       if
>>> (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) &&
>>> !vcpu))
>>> -               return;
>>> +       WARN_ON_ONCE(!vcpu && 
>>> !kvm_arch_allow_write_without_running_vcpu(kvm));
>> 
>> I'm happy with this.
>> 
> 
> Thanks, it's the primary change in this patch.
> 
>>>   #endif
>>>           if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>>> @@ -3318,7 +3317,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>                   if (kvm->dirty_ring_size && vcpu)
>>>                          kvm_dirty_ring_push(vcpu, slot, rel_gfn);
>>> -               else
>>> +               else if (memslot->dirty_bitmap)
>>>                          set_bit_le(rel_gfn, memslot->dirty_bitmap);
>> 
>> But that I don't get. Or rather, I don't get the commit message that
>> matches this hunk. Do we want to catch the case where all of the
>> following are true:
>> 
>> - we don't have a vcpu,
>> - we're allowed to log non-vcpu dirtying
>> - we *only* have the ring?
>> 
>> If so, can we please capture that in the commit message?
>> 
> 
> Nice catch! This particular case needs to be warned explicitly. Without
> the patch, kernel crash is triggered. With this patch applied, the 
> error
> or warning is dropped silently. We either check memslot->dirty_bitmap
> in mark_page_dirty_in_slot(), or check it in
> kvm_arch_allow_write_without_running_vcpu().
> I personally the later one. Let me post a formal patch on top of your
> 'next' branch where the commit log will be improved accordingly.

I personally prefer this memslot->dirty_bitmap, as this is
a completely legal case (the VMM may not want to track the
ITS dirtying).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
