Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B35608B0A
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 11:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJVJXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 05:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiJVJWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 05:22:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE2218540F
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666427646;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdpz2k/x2U5SPm3VOUnkRfHFJsPHZODvyBsW6VGuYyY=;
        b=Zfn7ifKA6BGpkTkD1tpuYVWltA2MTlzotNgPeqbhI47Pzd/Pa9DY4H5EZFoLHOHN9K7oA0
        uCX/NffxvP0SXctZ9DQ8DuE0AMbcfwE3fxRQie5GrtDGUtcpmARTMG4fo1o+Dzk0pLYl9p
        1fv5Hn86KnR61HCZ59Z0/2ffunfCAOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-yrtANGCLNeaMxmueE6HdYg-1; Sat, 22 Oct 2022 04:27:51 -0400
X-MC-Unique: yrtANGCLNeaMxmueE6HdYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBEBE87B2AA;
        Sat, 22 Oct 2022 08:27:50 +0000 (UTC)
Received: from [10.64.54.99] (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7288940C6E14;
        Sat, 22 Oct 2022 08:27:44 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, will@kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
        zhenyzha@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        shan.gavin@gmail.com
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com> <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org> <Y1LDRkrzPeQXUHTR@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <6dd09645-056f-6fb2-6f35-b6b86aada722@redhat.com>
Date:   Sat, 22 Oct 2022 16:27:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y1LDRkrzPeQXUHTR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/22/22 12:05 AM, Sean Christopherson wrote:
> On Fri, Oct 21, 2022, Marc Zyngier wrote:
>> On Fri, 21 Oct 2022 00:44:51 +0100,
>> Sean Christopherson <seanjc@google.com> wrote:
>>>
>>> On Tue, Oct 11, 2022, Gavin Shan wrote:
>>>> Some architectures (such as arm64) need to dirty memory outside of the
>>>> context of a vCPU. Of course, this simply doesn't fit with the UAPI of
>>>> KVM's per-vCPU dirty ring.
>>>
>>> What is the point of using the dirty ring in this case?  KVM still
>>> burns a pile of memory for the bitmap.  Is the benefit that
>>> userspace can get away with scanning the bitmap fewer times,
>>> e.g. scan it once just before blackout under the assumption that
>>> very few pages will dirty the bitmap?
>>
>> Apparently, the throttling effect of the ring makes it easier to
>> converge. Someone who actually uses the feature should be able to
>> tell you. But that's a policy decision, and I don't see why we should
>> be prescriptive.
> 
> I wasn't suggesting we be prescriptive, it was an honest question.
> 
>>> Why not add a global ring to @kvm?  I assume thread safety is a
>>> problem, but the memory overhead of the dirty_bitmap also seems like
>>> a fairly big problem.
>>
>> Because we already have a stupidly bloated API surface, and that we
>> could do without yet another one based on a sample of *one*?
> 
> But we're adding a new API regardless.  A per-VM ring would definitely be a bigger
> addition, but if using the dirty_bitmap won't actually meet the needs of userspace,
> then we'll have added a new API and still not have solved the problem.  That's why
> I was asking why/when userspace would want to use dirty_ring+dirty_bitmap.
> 

Bitmap can help to solve the issue, but the extra memory consumption due to
the bitmap is a concern, as you mentioned previously. More information about
the issue can be found here [1]. On ARM64, multiple guest's physical pages are
used by VGIC/ITS to store its states during migration or system shutdown.

[1] https://lore.kernel.org/kvmarm/320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com/

>> Because dirtying memory outside of a vcpu context makes it incredibly awkward
>> to handle a "ring full" condition?
> 
> Kicking all vCPUs with the soft-full request isn't _that_ awkward.  It's certainly
> sub-optimal, but if inserting into the per-VM ring is relatively rare, then in
> practice it's unlikely to impact guest performance.
> 

It's still possible the per-vcpu-ring becomes hard full before it can be
kicked off. per-vm-ring has other issues, one of which is synchronization
between kvm and userspace to avoid overrunning per-kvm-ring. bitmap was
selected due to its simplicity.

>>>> Introduce a new flavor of dirty ring that requires the use of both vCPU
>>>> dirty rings and a dirty bitmap. The expectation is that for non-vCPU
>>>> sources of dirty memory (such as the GIC ITS on arm64), KVM writes to
>>>> the dirty bitmap. Userspace should scan the dirty bitmap before
>>>> migrating the VM to the target.
>>>>
>>>> Use an additional capability to advertize this behavior and require
>>>> explicit opt-in to avoid breaking the existing dirty ring ABI. And yes,
>>>> you can use this with your preferred flavor of DIRTY_RING[_ACQ_REL]. Do
>>>> not allow userspace to enable dirty ring if it hasn't also enabled the
>>>> ring && bitmap capability, as a VM is likely DOA without the pages
>>>> marked in the bitmap.
>>
>> This is wrong. The *only* case this is useful is when there is an
>> in-kernel producer of data outside of the context of a vcpu, which is
>> so far only the ITS save mechanism. No ITS? No need for this.
> 
> How large is the ITS?  If it's a fixed, small size, could we treat the ITS as a
> one-off case for now?  E.g. do something gross like shove entries into vcpu0's
> dirty ring?
> 

There are several VGIC/ITS tables involved in the issue. I checked the
specification and the implementation. As the device ID is 16-bits, so
the maximal devices can be 0x10000. Each device has its ITT (Interrupt
Translation Table), looked by a 32-bits event ID. The memory used for
ITT can be large enough in theory.

     Register       Description           Max-size   Entry-size  Max-entries
     -----------------------------------------------------------------------
     GITS_BASER0    ITS Device Table      512KB      8-bytes     0x10000
     GITS_BASER1    ITS Collection Table  512KB      8-bytes     0x10000
     GITS_BASER2    (GICv4) ITS VPE Table 512KB      8-bytes(?)  0x10000

     max-devices * (1UL << event_id_shift) * entry_size =
     0x10000 * (1UL << 32) * 8                          = 1PB

>> Userspace knows what it has created the first place, and should be in
>> charge of it (i.e. I want to be able to migrate my GICv2 and
>> GICv3-without-ITS VMs with the rings only).
> 
> Ah, so enabling the dirty bitmap isn't strictly required.  That means this patch
> is wrong, and it also means that we need to figure out how we want to handle the
> case where mark_page_dirty_in_slot() is invoked without a running vCPU on a memslot
> without a dirty_bitmap.
> 
> I.e. what's an appropriate action in the below sequence:
> 
> void mark_page_dirty_in_slot(struct kvm *kvm,
> 			     const struct kvm_memory_slot *memslot,
> 		 	     gfn_t gfn)
> {
> 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> 
> #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> 	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
> 		return;
> 
> #ifndef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
> 	if (WARN_ON_ONCE(!vcpu))
> 		return;
> #endif
> #endif
> 
> 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> 		unsigned long rel_gfn = gfn - memslot->base_gfn;
> 		u32 slot = (memslot->as_id << 16) | memslot->id;
> 
> 		if (vcpu && kvm->dirty_ring_size)
> 			kvm_dirty_ring_push(&vcpu->dirty_ring,
> 					    slot, rel_gfn);
> 		else if (memslot->dirty_bitmap)
> 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> 		else
> 			???? <=================================================
> 	}
> }
> 
> 
> Would it be possible to require a dirty bitmap when an ITS is created?  That would
> allow treating the above condition as a KVM bug.
> 

According to the above calculation, it's impossible to determine the memory size for
the bitmap in advance. The memory used by ITE (Interrupt Translation Entry) tables
can be huge enough to use all guest's system memory in theory. ITE tables are scattered
in guest's system memory, but we don't know its location in advance. ITE tables are
created dynamically on requests from guest.

However, I think it's a good idea to enable the bitmap only when "arm-its-kvm" is
really used in userspace (QEMU). For example, the machine and (kvm) accelerator are
initialized like below. It's unknown if "arm-its-kvm" is used until (c). So we can
enable KVM_CAP_DIRTY_RING_WITH_BITMAP in (d) and the bitmap is created in (e) by
KVM.

   main
     qemu_init
       qemu_create_machine                   (a) machine instance is created
       configure_accelerators
         do_configure_accelerator
           accel_init_machine
             kvm_init                        (b) KVM is initialized
       :
       qmp_x_exit_preconfig
         qemu_init_board
           machine_run_board_init            (c) The board is initialized
       :
       accel_setup_post                      (d) KVM is post initialized
       :
       <migration>                           (e) Migration starts

In order to record if the bitmap is really needed, "struct kvm::dirty_ring_with_bitmap"
is still needed.

    - KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is advertised when CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
      is selected.

    - KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is enabled in (d) only when "arm-its-kvm"
      is used in QEMU. After the capability is enabled, "struct kvm::dirty_ring_with_bitmap"
      is set to 1.

    - The bitmap is created by KVM in (e).

If the above analysis makes sense, I don't see there is anything missed from the patch
Of course, KVM_CAP_DIRTY_LOG_RING_{ACQ_REL, WITH_BITMAP} needs to be enabled separately
and don't depend on each other. the description added to "Documentation/virt/kvm/abi.rst"
need to be improved as Peter and Oliver suggested. kvm_dirty_ring_exclusive() needs to be
renamed to kvm_use_dirty_bitmap() and "#ifdef" needs to be cut down as Sean suggested.


>>>> @@ -4499,6 +4507,11 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
>>>>   {
>>>>   	int r;
>>>>   
>>>> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
>>>> +	if (!kvm->dirty_ring_with_bitmap)
>>>> +		return -EINVAL;
>>>> +#endif
>>>
>>> This one at least is prettier with IS_ENABLED
>>>
>>> 	if (IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) &&
>>> 	    !kvm->dirty_ring_with_bitmap)
>>> 		return -EINVAL;
>>>
>>> But dirty_ring_with_bitmap really shouldn't need to exist.  It's
>>> mandatory for architectures that have
>>> HAVE_KVM_DIRTY_RING_WITH_BITMAP, and unsupported for architectures
>>> that don't.  In other words, the API for enabling the dirty ring is
>>> a bit ugly.
>>>
>>> Rather than add KVM_CAP_DIRTY_LOG_RING_ACQ_REL, which hasn't been
>>> officially released yet, and then KVM_CAP_DIRTY_LOG_ING_WITH_BITMAP
>>> on top, what about usurping bits 63:32 of cap->args[0] for flags?
>>> E.g.
> 
> For posterity, filling in my missing idea...
> 
> Since the size is restricted to be well below a 32-bit value, and it's unlikely
> that KVM will ever support 4GiB per-vCPU rings, we could usurp the upper bits for
> flags:
> 
>    static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u64 arg0)
>    {
> 	u32 flags = arg0 >> 32;
> 	u32 size = arg0;
> 
> However, since it sounds like enabling dirty_bitmap isn't strictly required, I
> have no objection to enabling KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP, my objection
> was purely that KVM was adding a per-VM flag just to sanity check the configuration.
> 

If KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is enabled for "arm-its-kvm", it'd better
to allow enabling those two capability (ACQ_REL and WITH_BITMAP) separately, as I
explained above. userspace (QEMU) will gain flexibility if these two capabilities
can be enabled separately.

To QEMU, KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL are accelerator's
properties. KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is board's property. Relaxing their
dependency will give flexibility to QEMU.


[...]

Thanks,
Gavin

