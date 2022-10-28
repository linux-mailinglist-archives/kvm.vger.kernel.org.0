Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE98E610AB5
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 08:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJ1Gth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 02:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiJ1GtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 02:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F231C2081
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 23:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666939452;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OIS6krfwlp4goyv08jor5j844HvFRVnqcPjr6/3Btb8=;
        b=KVUlQhw/BCM56L9TMEi02tOb1BKkrhlpnpyUvz9jBmHEu7323WGAmB6pgp0BxA/Hmj9K1h
        Yt81L+0yRZT85IMxJrA0FvsvQDXUYhHXhypukDQ5QhnANd7ImyXkQRuQ9g8/wf46kaHjS4
        CtWc2rf5XUeHvmw9oGmj8H0WYCH4okE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-aKfA1HCgNOyiL2Cvg7uhaA-1; Fri, 28 Oct 2022 02:44:06 -0400
X-MC-Unique: aKfA1HCgNOyiL2Cvg7uhaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F956185A794;
        Fri, 28 Oct 2022 06:44:05 +0000 (UTC)
Received: from [10.64.54.151] (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5A03C15BA8;
        Fri, 28 Oct 2022 06:43:58 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, shan.gavin@gmail.com
References: <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com> <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com> <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com> <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org> <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org> <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
Date:   Fri, 28 Oct 2022 14:43:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <875yg5glvk.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean and Marc,

On 10/28/22 2:30 AM, Marc Zyngier wrote:
> On Thu, 27 Oct 2022 18:44:51 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Thu, Oct 27, 2022, Marc Zyngier wrote:
>>> On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:

[...]
  
>>
>>>> And ideally such bugs would detected without relying on userspace to
>>>> enabling dirty logging, e.g. the Hyper-V bug lurked for quite some
>>>> time and was only found when mark_page_dirty_in_slot() started
>>>> WARNing.
>>>>
>>>> I'm ok if arm64 wants to let userspace shoot itself in the foot with
>>>> the ITS, but I'm not ok dropping the protections in the common
>>>> mark_page_dirty_in_slot().
>>>>
>>>> One somewhat gross idea would be to let architectures override the
>>>> "there must be a running vCPU" rule, e.g. arm64 could toggle a flag
>>>> in kvm->arch in its kvm_write_guest_lock() to note that an expected
>>>> write without a vCPU is in-progress:
>>>>
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 8c5c69ba47a7..d1da8914f749 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>>          struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>>>   
>>>>   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>>>> -       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>>>> +       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
>>>> +               return;
>>>> +
>>>> +       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>>>>                  return;
>>>>   #endif
>>>>   
>>>> @@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>>                  unsigned long rel_gfn = gfn - memslot->base_gfn;
>>>>                  u32 slot = (memslot->as_id << 16) | memslot->id;
>>>>   
>>>> -               if (kvm->dirty_ring_size)
>>>> +               if (kvm->dirty_ring_size && vcpu)
>>>>                          kvm_dirty_ring_push(&vcpu->dirty_ring,
>>>>                                              slot, rel_gfn);
>>>> -               else
>>>> +               else if (memslot->dirty_bitmap)
>>>>                          set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>>>          }
>>>>   }
>>>
>>> I think this is equally wrong. Writes occur from both CPUs and devices
>>> *concurrently*, and I don't see why KVM should keep ignoring this
>>> pretty obvious fact.
>>>
>>> Yes, your patch papers over the problem, and it can probably work if
>>> the kvm->arch flag only gets set in the ITS saving code, which is
>>> already exclusive of vcpus running.
>>>
>>> But in the long run, with dirty bits being collected from the IOMMU
>>> page tables or directly from devices, we will need a way to reconcile
>>> the dirty tracking. The above doesn't quite cut it, unfortunately.
>>
>> Oooh, are you referring to IOMMU page tables and devices _in the
>> guest_?  E.g. if KVM itself were to emulate a vIOMMU, then KVM would
>> be responsible for updating dirty bits in the vIOMMU page tables.
> 
> No. I'm talking about the *physical* IOMMU, which is (with the correct
> architecture revision and feature set) capable of providing its own
> set of dirty bits, on a per-device, per-PTE basis. Once we enable
> that, we'll need to be able to sink these bits into the bitmap and
> provide a unified view of the dirty state to userspace.
> 
>> Not that it really matters, but do we actually expect KVM to ever
>> emulate a vIOMMU?  On x86 at least, in-kernel acceleration of vIOMMU
>> emulation seems more like VFIO territory.
> 
> I don't expect KVM/arm64 to fully emulate an IOMMU, but at least to
> eventually provide the required filtering to enable a stage-1 SMMU to
> be passed to a guest. This is the sort of things pKVM needs to
> implement for the host anyway, and going the extra mile to support
> arbitrary guests outside of the pKVM context isn't much more work.
> 
>> Regardless, I don't think the above idea makes it any more difficult
>> to support in-KVM emulation of non-CPU stuff, which IIUC is the ITS
>> case.  I 100% agree that the above is a hack, but that's largely due
>> to the use of kvm_get_running_vcpu().
> 
> That I agree.
> 
>> A slightly different alternative would be have a completely separate
>> API for writing guest memory without an associated vCPU.  I.e. start
>> building up proper device emulation support.  Then the vCPU-based
>> APIs could yell if a vCPU isn't provided (or there is no running
>> vCPU in the current mess).  And the deviced-based API could be
>> provided if and only if the architecture actually supports emulating
>> writes from devices, i.e. x86 would not opt-in and so would even
>> have access to the API.
> 
> Which is what I was putting under the "major surgery" label in my
> previous email.
> 
> Anyhow, for the purpose of unblocking Gavin's series, I suggest to
> adopt your per-arch opt-out suggestion as a stop gap measure, and we
> will then be able to bike-shed for weeks on what the shape of the
> device-originated memory dirtying API should be.
> 

It's really a 'major surgery' and I would like to make sure I fully understand
'a completely separate API for writing guest memory without an associated vCPU",
before I'm going to working on v7 for this.

There are 7 functions and 2 macros involved as below. I assume Sean is suggesting
to add another argument, whose name can be 'has_vcpu', for these functions and macros?
Sean, could you please double confirm?

If I'm understanding correctly, and 'has_vcpu' argument will be added for these
functions and macros. Except the call sites in vgic/its, 'has_vcpu' is set to 'true',
and passed to these functions. It means we need a 'false' for the argument in vgic/its
call sites. Please correct me if I'm wrong.

   int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
                            int offset, int len);
   int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
                       unsigned long len);
   int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
                              void *data, unsigned long len);
   int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
                                     void *data, unsigned int offset,
                                     unsigned long len);

   void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
   void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
   void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);

   #define __kvm_put_guest(kvm, gfn, offset, v)
   #define kvm_put_guest(kvm, gpa, v)
   
Thanks,
Gavin


