Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915825E96D5
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 01:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiIYXJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Sep 2022 19:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiIYXJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Sep 2022 19:09:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0936211A32
        for <kvm@vger.kernel.org>; Sun, 25 Sep 2022 16:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664147388;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IW1g6WDrq/4l4r2f8avVv1mAAh4KMUV/pSn5otI3ocI=;
        b=EzTaYWFG2pdV+gl1FkTEtPBO0FmLa9yM+ZXBMtX9E2f/EE9uo7GjnrmGUmiKjTqV+dweRe
        vdx5y54hF8YtSAyK4ysgSc4GSptleyJLECXNvihoOO/cza6vA+B1iR5usbkGfHrLPPM80o
        IA6YsVgtlkqUKZkpZ8aY9kYg365G/8Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-3i_M6GaLNHCbihdAzr9C5A-1; Sun, 25 Sep 2022 19:09:44 -0400
X-MC-Unique: 3i_M6GaLNHCbihdAzr9C5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41A0681172A;
        Sun, 25 Sep 2022 23:09:44 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADA662166B26;
        Sun, 25 Sep 2022 23:09:38 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 2/6] KVM: x86: Move declaration of
 kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        oliver.upton@linux.dev, peterx@redhat.com, pbonzini@redhat.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20220922003214.276736-1-gshan@redhat.com>
 <20220922003214.276736-3-gshan@redhat.com> <877d1sio31.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b226886c-3fc3-8f31-2e91-c4a6e1865097@redhat.com>
Date:   Mon, 26 Sep 2022 09:09:34 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <877d1sio31.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/25/22 5:12 AM, Marc Zyngier wrote:
> On Thu, 22 Sep 2022 01:32:10 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> Not all architectures like ARM64 need to override the function. Move
>> its declaration to kvm_dirty_ring.h to avoid the following compiling
>> warning on ARM64 when the feature is enabled.
>>
>>    arch/arm64/kvm/../../../virt/kvm/dirty_ring.c:14:12:        \
>>    warning: no previous prototype for 'kvm_cpu_dirty_log_size' \
>>    [-Wmissing-prototypes]                                      \
>>    int __weak kvm_cpu_dirty_log_size(void)
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 2 --
>>   arch/x86/kvm/mmu/mmu.c          | 2 ++
>>   include/linux/kvm_dirty_ring.h  | 1 +
>>   3 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 2c96c43c313a..4c0fd517282b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -2082,8 +2082,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>>   #define GET_SMSTATE(type, buf, offset)		\
>>   	(*(type *)((buf) + (offset) - 0x7e00))
>>   
>> -int kvm_cpu_dirty_log_size(void);
>> -
>>   int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>>   
>>   #define KVM_CLOCK_VALID_FLAGS						\
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index e418ef3ecfcb..b3eb6a3627ec 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -1349,10 +1349,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>   		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>>   }
>>   
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING
> 
> I think you can drop the ifdeffery, as HAVE_KVM_DIRTY_RING is
> unconditionally selected by the arch Kconfig.
> 

Yeah, I think so. Lets drop it in v4, which will be rebased on top
of your v2 series.

>>   int kvm_cpu_dirty_log_size(void)
>>   {
>>   	return kvm_x86_ops.cpu_dirty_log_size;
>>   }
>> +#endif
>>   
>>   bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>>   				    struct kvm_memory_slot *slot, u64 gfn,
>> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
>> index 906f899813dc..8c6755981c9b 100644
>> --- a/include/linux/kvm_dirty_ring.h
>> +++ b/include/linux/kvm_dirty_ring.h
>> @@ -71,6 +71,7 @@ static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
>>   
>>   #else /* CONFIG_HAVE_KVM_DIRTY_RING */
>>   
>> +int kvm_cpu_dirty_log_size(void);
>>   u32 kvm_dirty_ring_get_rsvd_entries(void);
>>   int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
> 

Thanks,
Gavin

