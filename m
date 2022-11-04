Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7374618D23
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 01:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKDANl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 20:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKDANi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 20:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91C2229C
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 17:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667520755;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8V2P0sK6vg/zYa0nsGPDkqRLaIh/+PWOrDyxDJZDYA=;
        b=VwYmPc9ZWOUInqkqR8njtBa+sLb3/2MmdPfqJoSfY4KwoLMM/OntQN1543iXtkQOOH29Bj
        u5JGSSlwU9nrGphvn5iyeY3KWDonkGL0j2VGBcVcNtwYSQxsT8zUKIFhW1xzuAOjEXQukb
        qjIk4vJGLSxfMs59M5WnDQ3r3JngVnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-2BYngf1ePvWeqNd1CSCMNQ-1; Thu, 03 Nov 2022 20:12:31 -0400
X-MC-Unique: 2BYngf1ePvWeqNd1CSCMNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E68A98027EA;
        Fri,  4 Nov 2022 00:12:30 +0000 (UTC)
Received: from [10.64.54.56] (vpn2-54-56.bne.redhat.com [10.64.54.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73AC340C6E14;
        Fri,  4 Nov 2022 00:12:24 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com> <Y2RPhwIUsGLQ2cz/@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
Date:   Fri, 4 Nov 2022 08:12:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2RPhwIUsGLQ2cz/@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 11/4/22 7:32 AM, Oliver Upton wrote:
> On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
>> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
>> enabled. It's conflicting with that ring-based dirty page tracking always
>> requires a running VCPU context.
>>
>> Introduce a new flavor of dirty ring that requires the use of both VCPU
>> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
>> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
>> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
>> the VM to the target.
>>
>> Use an additional capability to advertise this behavior. The newly added
>> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
>> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
>> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
> 
> Whatever ordering requirements we settle on between these capabilities
> needs to be documented as well.
> 
> [...]
> 

It's mentioned in 'Documentation/virt/kvm/api.rst' as below.

   After using the dirty rings, the userspace needs to detect the capability
   of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the ring structures
   need to be backed by per-slot bitmaps. With this capability advertised
   and supported, it means the architecture can dirty guest pages without
   vcpu/ring context, so that some of the dirty information will still be
   maintained in the bitmap structure.

The description may be not obvious about the ordering. For this, I can
add the following sentence at end of the section.

   The capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP can't be enabled
   until the capability of KVM_CAP_DIRTY_LOG_RING_ACQ_REL has been enabled.

>> @@ -4588,6 +4594,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>   			return -EINVAL;
>>   
>>   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
>> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>> +		    !kvm->dirty_ring_size)
> 
> I believe this ordering requirement is problematic, as it piles on top
> of an existing problem w.r.t. KVM_CAP_DIRTY_LOG_RING v. memslot
> creation.
> 
> Example:
>   - Enable KVM_CAP_DIRTY_LOG_RING
>   - Create some memslots w/ dirty logging enabled (note that the bitmap
>     is _not_ allocated)
>   - Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
>   - Save ITS tables and get a NULL dereference in
>     mark_page_dirty_in_slot():
> 
>                  if (vcpu && kvm->dirty_ring_size)
>                          kvm_dirty_ring_push(&vcpu->dirty_ring,
>                                              slot, rel_gfn);
>                  else
> ------->		set_bit_le(rel_gfn, memslot->dirty_bitmap);
> 
> Similarly, KVM may unnecessarily allocate bitmaps if dirty logging is
> enabled on memslots before KVM_CAP_DIRTY_LOG_RING is enabled.
> 
> You could paper over this issue by disallowing DIRTY_RING_WITH_BITMAP if
> DIRTY_LOG_RING has already been enabled, but the better approach would
> be to explicitly check kvm_memslots_empty() such that the real
> dependency is obvious. Peter, hadn't you mentioned something about
> checking against memslots in an earlier revision?
> 

The userspace (QEMU) needs to ensure that no dirty bitmap is created
before the capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is enabled.
It's unknown by QEMU that vgic/its is used when KVM_CAP_DIRTY_LOG_RING_ACQ_REL
is enabled.

    kvm_initialization
      enable_KVM_CAP_DIRTY_LOG_RING_ACQ_REL        // Where KVM_CAP_DIRTY_LOG_RING is enabled
    board_initialization                           // Where QEMU knows if vgic/its is used
      add_memory_slots
    kvm_post_initialization
      enable_KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
    :
    start_migration
      enable_dirty_page_tracking
        create_dirty_bitmap                       // With KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP enabled

Thanks,
Gavin


