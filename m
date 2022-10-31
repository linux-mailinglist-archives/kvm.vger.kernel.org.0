Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6742E61415B
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 00:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJaXJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 19:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJaXJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 19:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DE12BE7
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 16:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667257729;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQFFGriLEOJQiVzKnvQsJXHkfhk9DM13xloxVckNyEY=;
        b=bUoZZaERRZKDsx4vIU+VkxULEG0XZH6GHAVi08SnZRBzKFY2q1NF82A8NEBBVJsm2T6Zwx
        t7VDqr5orKvw+4KcjIQZ1xvdufanElwoJNPhDj5gY7FrEyb7N9mcpRNMtl/T2Aer6Mf/f/
        xzYPZKa4c0uY9WAbGXzMlJBUsPPuAYQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-qvL3ykXUNg-TfIivNzV1IQ-1; Mon, 31 Oct 2022 19:08:44 -0400
X-MC-Unique: qvL3ykXUNg-TfIivNzV1IQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A06C3804506;
        Mon, 31 Oct 2022 23:08:43 +0000 (UTC)
Received: from [10.64.54.151] (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79B7C17584;
        Mon, 31 Oct 2022 23:08:34 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 5/9] KVM: arm64: Improve no-running-vcpu report for
 dirty ring
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-6-gshan@redhat.com> <Y1+QiS0S3e6b358Q@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <d3a4278a-94e2-7af4-da2d-946c903d8825@redhat.com>
Date:   Tue, 1 Nov 2022 07:08:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y1+QiS0S3e6b358Q@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/31/22 5:08 PM, Oliver Upton wrote:
> On Mon, Oct 31, 2022 at 08:36:17AM +0800, Gavin Shan wrote:
>> KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP should be enabled only when KVM
>> device "kvm-arm-vgic-its" is used by userspace. Currently, it's the
>> only case where a running VCPU is missed for dirty ring. However,
>> there are potentially other devices introducing similar error in
>> future.
>>
>> In order to report those broken devices only, the no-running-vcpu
>> warning message is escaped from KVM device "kvm-arm-vgic-its". For
>> this, the function vgic_has_its() needs to be exposed with a more
>> generic function name (kvm_vgic_has_its()).
>>
>> Link: https://lore.kernel.org/kvmarm/Y1ghIKrAsRFwSFsO@google.com
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
> 
> I don't think this should be added as a separate patch.
> 
> The weak kvm_arch_allow_write_without_running_vcpu() (and adding its
> caller) should be rolled into patch 4/9. The arm64 implementation of
> that should be introduced in patch 6/9.
> 

Ok, the changes will be distributed in PATCH[4/9] and PATCH[6/9].

>> ---
>>   arch/arm64/kvm/mmu.c               | 14 ++++++++++++++
>>   arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
>>   arch/arm64/kvm/vgic/vgic-irqfd.c   |  4 ++--
>>   arch/arm64/kvm/vgic/vgic-its.c     |  2 +-
>>   arch/arm64/kvm/vgic/vgic-mmio-v3.c | 18 ++++--------------
>>   arch/arm64/kvm/vgic/vgic.c         | 10 ++++++++++
>>   arch/arm64/kvm/vgic/vgic.h         |  1 -
>>   include/kvm/arm_vgic.h             |  1 +
>>   include/linux/kvm_dirty_ring.h     |  1 +
>>   virt/kvm/dirty_ring.c              |  5 +++++
>>   virt/kvm/kvm_main.c                |  2 +-
>>   11 files changed, 41 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 60ee3d9f01f8..e0855b2b3d66 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -932,6 +932,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>   	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>>   }
>>   
>> +/*
>> + * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
>> + * without the running VCPU when dirty ring is enabled.
>> + *
>> + * The running VCPU is required to track dirty guest pages when dirty ring
>> + * is enabled. Otherwise, the backup bitmap should be used to track the
>> + * dirty guest pages. When vgic/its is enabled, we need to use the backup
>> + * bitmap to track the dirty guest pages for it.
>> + */
>> +bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>> +{
>> +	return kvm->dirty_ring_with_bitmap && kvm_vgic_has_its(kvm);
>> +}
> 
> It is trivial for userspace to cause a WARN to fire like this. Just set
> up the VM with !RING_WITH_BITMAP && ITS.
> 
> The goal is to catch KVM bugs, not userspace bugs, so I'd suggest only
> checking whether or not an ITS is present.
> 
> [...]
> 

Ok. 'kvm->dirty_ring_with_bitmap' needn't to be checked here if we don't
plan to catch userspace bug. Marc had suggestions to escape from the
no-running-vcpu check only when vgic/its tables are being restored [1].

In order to cover Marc's concern, I would introduce a different helper
kvm_vgic_save_its_tables_in_progress(), which simply returns
'bool struct vgic_dist::save_its_tables_in_progress'. The newly added
field is set and cleared in vgic_its_ctrl(). All these changes will be
folded to PATCH[v7 6/9]. Oliver and Marc, could you please let me know
if the changes sounds good?

    static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
    {
        const struct vgic_its_abi *abi = vgic_its_get_abi(its);
        struct vgic_dist *dist = &kvm->arch.vgic;
        int ret = 0;
          :
        switch (attr) {
        case KVM_DEV_ARM_ITS_CTRL_RESET:
             vgic_its_reset(kvm, its);
             break;
        case KVM_DEV_ARM_ITS_SAVE_TABLES:
             dist->save_its_tables_in_progress = true;
             ret = abi->save_tables(its);
             dist->save_its_tables_in_progress = false;
             break;
        case KVM_DEV_ARM_ITS_RESTORE_TABLES:
             ret = abi->restore_tables(its);
             break;
        }
        :
     }
  
[1] https://lore.kernel.org/kvmarm/2ce535e9-f57a-0ab6-5c30-2b8afd4472e6@redhat.com/T/#mcf10e2d3ca0235ab1cac8793d894c1634666d280

>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index 91201f743033..10218057c176 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -38,20 +38,10 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>>   	return reg | ((u64)val << lower);
>>   }
>>   
>> -bool vgic_has_its(struct kvm *kvm)
>> -{
>> -	struct vgic_dist *dist = &kvm->arch.vgic;
>> -
>> -	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
>> -		return false;
>> -
>> -	return dist->has_its;
>> -}
>> -
> 
> nit: renaming/exposing this helper should be done in a separate patch.
> Also, I don't think you need to move it anywhere either.
> 
> [...]
> 

As Marc suggested, we tend to escape the site of saving vgic/its tables from
the no-running-vcpu check. So we need a new helper kvm_vgic_save_its_tables_in_progress()
instead, meaning kvm_vgic_has_its() isn't needed.

>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index 7ce6a5f81c98..f27e038043f3 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -26,6 +26,11 @@ bool kvm_use_dirty_bitmap(struct kvm *kvm)
>>   	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
>>   }
>>   
>> +bool __weak kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>> +{
>> +	return kvm->dirty_ring_with_bitmap;
>> +}
>> +
> 
> Same comment on the arm64 implementation applies here. This should just
> return false by default.
> 

Ok. It return 'false' and the addition of kvm_arch_allow_write_without_running_vcpu()
will be folded to PATCH[4/9], as you suggested.

Thanks,
Gavin

