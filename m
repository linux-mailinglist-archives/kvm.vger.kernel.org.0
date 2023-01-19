Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3866D672DDA
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 02:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjASBMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 20:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjASBMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 20:12:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064F766EEA
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 17:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674090720;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1s/focwXYH9ypammfY4jmkagsBW5DWFSgWPXj6TkN40=;
        b=Z/jFNBzyXJdGfpKF4qeONTM90x/T/p3lWBGX2ObYWcObZEoia78mYwf+5BFfzNXWLPva0d
        hbEVQT6EomMLgHfHIeziYx9fKnwBTBIxRlb4RecwnvAGYv2jCO42rUtJ2U8mkfJUaVzgyJ
        xWjUz2+RMKVaLLTTI0/Qj/+BmgZjm74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-g-IkxgauOgGNQSydGKEIsg-1; Wed, 18 Jan 2023 20:11:56 -0500
X-MC-Unique: g-IkxgauOgGNQSydGKEIsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CECDD101A521;
        Thu, 19 Jan 2023 01:11:55 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E18D40C2064;
        Thu, 19 Jan 2023 01:11:47 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/4] KVM: arm64: Allow saving vgic3 LPI pending status in
 no running vcpu context
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, corbet@lwn.net,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, seanjc@google.com,
        shan.gavin@gmail.com
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-2-gshan@redhat.com> <Y8cKQRIbpLWVcdcw@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <0626e135-5d6b-8d09-ccd1-068e42a052f6@redhat.com>
Date:   Thu, 19 Jan 2023 12:11:44 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y8cKQRIbpLWVcdcw@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 1/18/23 7:51 AM, Oliver Upton wrote:
> On Mon, Jan 16, 2023 at 12:04:02PM +0800, Gavin Shan wrote:
>> When dirty ring is enabled, the dirty page information is pushed to
>> the dirty ring if there is a running VCPU context. Otherwise, the
>> dirty page information is still tracked by the backup dirty bitmap.
>> In order to detect if there is a running VCPU context when a guest
>> page becomes dirty, kvm_arch_allow_write_without_running_vcpu() was
>> introduced to warn when no running VCPU context exists on unknown
>> cases.
>>
>> Other than the site of saving ITS tables, it's possible to save vgic3
>> LPI pending status in no running vcpu context because it can happen when
>> ITS ITE is restored through the command KVM_DEV_ARM_ITS_RESTORE_TABLES
>> on 'kvm-arm-vgic-its' device.
>>
>> Fix it by allowing to save vgic3 LPI pending status in no running
>> vcpu context.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 5 +++--
>>   arch/arm64/kvm/vgic/vgic-its.c | 3 ++-
>>   arch/arm64/kvm/vgic/vgic-v3.c  | 3 +++
>>   include/kvm/arm_vgic.h         | 1 +
>>   4 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 9807b05a1b57..18b245a0ba02 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -8071,8 +8071,9 @@ state is final and avoid missing dirty pages from another ioctl ordered
>>   after the bitmap collection.
>>   
>>   NOTE: One example of using the backup bitmap is saving arm64 vgic/its
>> -tables through KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on
>> -KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
>> +tables and vgic3 LPI pending status through KVM_DEV_ARM_{VGIC_GRP_CTRL,
>> +ITS_SAVE_TABLES} and KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES}
>> +command on KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
>>   
>>   8.30 KVM_CAP_XEN_HVM
>>   --------------------
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 94a666dd1443..119a9c7a0a52 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -2792,7 +2792,8 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>>   {
>>   	struct vgic_dist *dist = &kvm->arch.vgic;
>>   
>> -	return dist->save_its_tables_in_progress;
>> +	return dist->save_vgic_v3_tables_in_progress ||
>> +	       dist->save_its_tables_in_progress;
> 
> I'd much prefer using a single bool to keep track of this, i.e:
> 

Yes, it's clean to have 'dist->save_tables_in_progress' for all
3 cases. One more concern like below.

> 	return dist->save_tables_in_progress;
> 
>>   }
>>   
>>   static int vgic_its_set_attr(struct kvm_device *dev,
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 2074521d4a8c..32998c8587a8 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -304,6 +304,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>>   int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>>   {
>>   	struct kvm_vcpu *vcpu;
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>   	int byte_offset, bit_nr;
>>   	gpa_t pendbase, ptr;
>>   	bool status;
>> @@ -339,7 +340,9 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
>>   	if (status) {
>>   		/* clear consumed data */
>>   		val &= ~(1 << bit_nr);
>> +		dist->save_vgic_v3_tables_in_progress = true;
>>   		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
>> +		dist->save_vgic_v3_tables_in_progress = false;
> 
> With the above suggestion of using a bool, this should become a helper
> used at all the affected callsites:
> 
>    static int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
>    				   const void *data, unsigned long len)
>    {
>    	struct vgic_dist *dist = &kvm->arch.vgic;
> 	int ret;
> 
> 	dist->save_tables_in_progress = true;
> 	ret = kvm_write_guest_lock(kvm, gpa, data, len);
> 	dist->save_tables_in_progress = false;
> 
> 	return ret;
>    }
> 

I will have vgic_write_guest_lock() in v2. Note that those 3 paths can't be
running in parallel since one switch is shared by them. Alternatively, we
extend struct vgic_dist::save_tables_in_progress from 'bool' to 'unsigned long'.
Several bit is defined for each site as below. In this way, the 3 paths can be
running in parallel:

   unsigned long struct vgic_dist::save_tables_in_progress

   #define VGIC_DIST_SAVE_ITS_ITE		0	/* ITS Translation Entry */
   #define VGIC_DIST_SAVE_ITS_DTE		1	/* ITS Device Table Entry */
   #define VGIC_DIST_SAVE_ITS_CTE		2	/* ITS Collection Table Entry */
   #define VGIC_DIST_SAVE_ITS_CT			3	/* ITS Collection Table */
   #define VGIC_DIST_SAVE_VGIC3_LPI		4	/* VGIC3 LPI Pending Status */
   #define VGIC_DIST_SAVE_VGIC3_PENDING_TABLE	5	/* VGIC3 Pending Table */

The drawback is the calls are limited to 64. If those 3 paths can't be running
in parallel, we needn't the extension at all.

Thanks,
Gavin

