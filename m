Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA543612F58
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 04:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJaDjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 23:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaDjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 23:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2159B95A0
        for <kvm@vger.kernel.org>; Sun, 30 Oct 2022 20:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667187490;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5heqDPTvyg/WwWWnO5zE1eTi0JOXR9TBRklxSqDrFRk=;
        b=JS/EZA67N4oVlfQLudFfF8wsLOvmK3466a77t8XWPCiHt5ECDXH2Z2pOTMSAEYKhV43Lad
        iVwYVM0vJBTLh/X0X/aW13Y5bL00InALm2AnIkTYALrxD05DRCFotWmpU4bFougMcPtPlZ
        UTFHFMzrXHvRkoo7TJGp0aSHH/ykEtk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-n2y_sGmJMmC9_R0eH2-6_w-1; Sun, 30 Oct 2022 23:38:06 -0400
X-MC-Unique: n2y_sGmJMmC9_R0eH2-6_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC95D185A792;
        Mon, 31 Oct 2022 03:38:05 +0000 (UTC)
Received: from [10.64.54.151] (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 788FE4EA5B;
        Mon, 31 Oct 2022 03:37:59 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, shan.gavin@gmail.com
References: <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com> <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org> <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org> <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
 <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
 <Y1wIj/sdJw7VMiY5@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <a162a328-fc28-ce23-6f1c-e84abc4fab0c@redhat.com>
Date:   Mon, 31 Oct 2022 11:37:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y1wIj/sdJw7VMiY5@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/29/22 12:51 AM, Sean Christopherson wrote:
> On Fri, Oct 28, 2022, Gavin Shan wrote:
>> On 10/28/22 2:30 AM, Marc Zyngier wrote:
>>> On Thu, 27 Oct 2022 18:44:51 +0100,
>>> Sean Christopherson <seanjc@google.com> wrote:
>>>>
>>>> On Thu, Oct 27, 2022, Marc Zyngier wrote:
>>>>> On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:
>>
>> [...]
>>>>
>>>>>> And ideally such bugs would detected without relying on userspace to
>>>>>> enabling dirty logging, e.g. the Hyper-V bug lurked for quite some
>>>>>> time and was only found when mark_page_dirty_in_slot() started
>>>>>> WARNing.
>>>>>>
>>>>>> I'm ok if arm64 wants to let userspace shoot itself in the foot with
>>>>>> the ITS, but I'm not ok dropping the protections in the common
>>>>>> mark_page_dirty_in_slot().
>>>>>>
>>>>>> One somewhat gross idea would be to let architectures override the
>>>>>> "there must be a running vCPU" rule, e.g. arm64 could toggle a flag
>>>>>> in kvm->arch in its kvm_write_guest_lock() to note that an expected
>>>>>> write without a vCPU is in-progress:
>>>>>>
>>>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>>>> index 8c5c69ba47a7..d1da8914f749 100644
>>>>>> --- a/virt/kvm/kvm_main.c
>>>>>> +++ b/virt/kvm/kvm_main.c
>>>>>> @@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>>>>           struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>>>>>    #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>>>>>> -       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>>>>>> +       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
>>>>>> +               return;
>>>>>> +
>>>>>> +       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>>>>>>                   return;
>>>>>>    #endif
>>>>>> @@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>>>>                   unsigned long rel_gfn = gfn - memslot->base_gfn;
>>>>>>                   u32 slot = (memslot->as_id << 16) | memslot->id;
>>>>>> -               if (kvm->dirty_ring_size)
>>>>>> +               if (kvm->dirty_ring_size && vcpu)
>>>>>>                           kvm_dirty_ring_push(&vcpu->dirty_ring,
>>>>>>                                               slot, rel_gfn);
>>>>>> -               else
>>>>>> +               else if (memslot->dirty_bitmap)
>>>>>>                           set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>>>>>           }
>>>>>>    }
> 
> ...
> 
>>>> A slightly different alternative would be have a completely separate
>>>> API for writing guest memory without an associated vCPU.  I.e. start
>>>> building up proper device emulation support.  Then the vCPU-based
>>>> APIs could yell if a vCPU isn't provided (or there is no running
>>>> vCPU in the current mess).  And the deviced-based API could be
>>>> provided if and only if the architecture actually supports emulating
>>>> writes from devices, i.e. x86 would not opt-in and so would even
>>>> have access to the API.
>>>
>>> Which is what I was putting under the "major surgery" label in my
>>> previous email.
>>>
>>> Anyhow, for the purpose of unblocking Gavin's series, I suggest to
>>> adopt your per-arch opt-out suggestion as a stop gap measure, and we
>>> will then be able to bike-shed for weeks on what the shape of the
>>> device-originated memory dirtying API should be.
>>>
>>
>> It's really a 'major surgery' and I would like to make sure I fully understand
>> 'a completely separate API for writing guest memory without an associated vCPU",
>> before I'm going to working on v7 for this.
>>
>> There are 7 functions and 2 macros involved as below. I assume Sean is suggesting
>> to add another argument, whose name can be 'has_vcpu', for these functions and macros?
> 
> No.
> 
> As March suggested, for your series just implement the hacky arch opt-out, don't
> try and do surgery at this time as that's likely going to be a months-long effort
> that touches a lot of cross-arch code.
> 
> E.g. I believe the ARM opt-out (opt-in?) for the above hack would be
> 
> bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
> {
> 	return vgic_has_its(kvm);
> }
> 

Ok, Thanks for your confirm. v7 was just posted to address comments from Marc,
Peter, Oliver and you. Please help to review when you get a chance.

https://lore.kernel.org/kvmarm/20221031003621.164306-1-gshan@redhat.com/T/#t

Thanks,
Gavin

