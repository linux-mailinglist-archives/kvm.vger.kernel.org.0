Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACD35ED131
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 01:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiI0XsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 19:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiI0XsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 19:48:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A785D1B348F
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 16:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664322479;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i0BKLfn5B7UzJtj+8D3KQv1ZOgyYXogau2GtF6aG8EE=;
        b=AXAqJTkUjWe0gMCxZ/0MNC/yRoRv5kBBI2g7Ofq+XCqN7gHO3lum9X5tSQN1J70UMC2wPI
        Pl0BzEY43SwYtNPYDANbw/YCViOyhXExhHlH8TcLbADg+3iMU2np1kgQ1maMiHChtUcjiw
        +ZBZEUU6Ng64P4zi45IMqSX9KbtcMmQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-kFXFsxtZPZGpRiWLb-rIhw-1; Tue, 27 Sep 2022 19:47:53 -0400
X-MC-Unique: kFXFsxtZPZGpRiWLb-rIhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 645E91C0896D;
        Tue, 27 Sep 2022 23:47:52 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2058740C6EC2;
        Tue, 27 Sep 2022 23:47:45 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
To:     Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com> <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org> <YzM/DFV1TgtyRfCA@x1n>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
Date:   Wed, 28 Sep 2022 09:47:43 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YzM/DFV1TgtyRfCA@x1n>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter and Marc,

On 9/28/22 4:21 AM, Peter Xu wrote:
> On Tue, Sep 27, 2022 at 01:32:07PM -0400, Marc Zyngier wrote:
>> On Tue, 27 Sep 2022 12:02:52 -0400,
>> Peter Xu <peterx@redhat.com> wrote:

[...]

>>>
>>> Any decision made on how to tackle with the GIC status dirty bits?
>>
>> Which dirty bits? Are you talking of the per-RD pending bits?
> 
> Gavin found that some dirty pfn path may not have vcpu context for aarch64
> offlist.
> 
> Borrowing Gavin's trace dump:
> 
>    el0t_64_sync
>    el0t_64_sync_handler
>    el0_svc
>    do_el0_svc
>    __arm64_sys_ioctl
>    kvm_device_ioctl
>    vgic_its_set_attr
>    vgic_its_save_tables_v0
>    kvm_write_guest
>    __kvm_write_guest_page
>    mark_page_dirty_in_slot
> 
> With current code it'll trigger the warning in mark_page_dirty_in_slot.
> 
> An userspace approach is doable by setting these pages as always dirty in
> userspace (QEMU), but even if so IIUC we'll need to drop the warning
> message in mark_page_dirty_in_slot() then we take no-vcpu dirty as no-op
> and expected.
> 
> I'll leave the details to Gavin.
> 

Thanks to Peter for bringing the issue to here for further discussion. I'm
slowly approaching the idea/design to resolve the issue. If Marc agrees, It
wouldn't stop us to merge the series since the newly introduced capability
is only used by kvm/selftests/dirty_log_test. It means more changes are needed
by QEMU in order to enable the feature there through KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
I can post follow-up patches to fix the VGIC/ITS issue.

We had some internal discussion about the mentioned issue. It's all about the
various VGIC/ITS tables, listed as below. In QEMU, those tables are requested
to be saved to memory for migration or shutdown. Unfortunately, there is no
running vcpu in this particular path and the corresponding dirty bits are
dropped with warning messages in mark_page_dirty_in_slot().

    ---> Command to save VGIC/ITS tables
         group: KVM_DEV_ARM_VGIC_GRP_CTRL
         attr : KVM_DEV_ARM_ITS_SAVE_TABLES

    ---> VGIC/ITS tables to be saved
         Device Table                     // REG_GITS_BASER_0
         Interrupt Translation Tables     // GITS_CMD_MAPD
         Collection Table                 // REG_GITS_BASER_1

    ---> QEMU's backtraces, triggering the issue

         main                                thread_start
         qemu_main                           start_thread
         qemu_cleanup                        qemu_thread_start
         vm_shutdown                         migration_thread
         do_vm_stop                          migration_iteration_run
         vm_state_notify                     migration_completion
         vm_change_state_handler             vm_stop_force_state
                                             do_vm_stop
                                             vm_state_notify
                                             vm_change_state_handler          // In hw/intc/arm_gicv3_its_kvm.c

I have rough idea as below. It's appreciated if you can comment before I'm
going a head for the prototype. The overall idea is to introduce another
dirty ring for KVM (kvm-dirty-ring). It's updated and visited separately
to dirty ring for vcpu (vcpu-dirty-ring).

    - When the various VGIC/ITS table base addresses are specified, kvm-dirty-ring
      entries are added to mark those pages as 'always-dirty'. In mark_page_dirty_in_slot(),
      those 'always-dirty' pages will be skipped, no entries pushed to vcpu-dirty-ring.

    - Similar to vcpu-dirty-ring, kvm-dirty-ring is accessed from userspace through
      mmap(kvm->fd). However, there won't have similar reset interface. It means
      'struct kvm_dirty_gfn::flags' won't track any information as we do for
      vcpu-dirty-ring. In this regard, kvm-dirty-ring is purely shared buffer to
      advertise 'always-dirty' pages from host to userspace.
      
    - For QEMU, shutdown/suspend/resume cases won't be concerning us any more. The
      only concerned case is migration. When the migration is about to complete,
      kvm-dirty-ring entries are fetched and the dirty bits are updated to global
      dirty page bitmap and RAMBlock's dirty page bitmap. For this, I'm still reading
      the code to find the best spot to do it.

Thanks,
Gavin



