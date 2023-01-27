Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A243E67F249
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 00:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjA0XiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 18:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjA0XiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 18:38:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB0C751AC
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 15:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674862649;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E68o1y4L945Wpu1FM7AdpeIAFjXV27retH64u9thADA=;
        b=NzvAkT1fGgw9zH3AH2/znysgrKlO+AbQqK0o0n+A4Oi1bSRltiflyq6C0+hMYDEimZogBh
        MzWOV79AUd7BjDTy1XAPHqL2eV0A1ua9voEFP6VAInSL15jUDMWSn7XSbsC0FS/4CuW3fl
        lj1Lhj8Gcuz6p7+X7NmOYLhld0M8cmg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-uPcJREtdPg6EVDUOUklaEg-1; Fri, 27 Jan 2023 18:37:26 -0500
X-MC-Unique: uPcJREtdPg6EVDUOUklaEg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 575D61C04320;
        Fri, 27 Jan 2023 23:37:25 +0000 (UTC)
Received: from [10.64.54.64] (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBED7492C14;
        Fri, 27 Jan 2023 23:37:16 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Allow no running vcpu on saving vgic3
 pending table
To:     Zenghui Yu <zenghui.yu@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
        corbet@lwn.net, maz@kernel.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        yuzhe@nfschina.com, isaku.yamahata@intel.com, seanjc@google.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
References: <20230126235451.469087-1-gshan@redhat.com>
 <20230126235451.469087-5-gshan@redhat.com>
 <713a3e22-6327-875e-072d-e916f75d5239@linux.dev>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <46612147-9e36-1981-8fdc-e205610a4bc9@redhat.com>
Date:   Sat, 28 Jan 2023 10:37:14 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <713a3e22-6327-875e-072d-e916f75d5239@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 1/28/23 2:57 AM, Zenghui Yu wrote:
> On 2023/1/27 07:54, Gavin Shan wrote:
>> We don't have a running VCPU context to save vgic3 pending table due
>> to KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES} command on KVM
>> device "kvm-arm-vgic-v3". The unknown case is caught by kvm-unit-tests.
>>
>>    # ./kvm-unit-tests/tests/its-pending-migration
>>    WARNING: CPU: 120 PID: 7973 at arch/arm64/kvm/../../../virt/kvm/kvm_main.c:3325 \
>>    mark_page_dirty_in_slot+0x60/0xe0
>>     :
>>    mark_page_dirty_in_slot+0x60/0xe0
>>    __kvm_write_guest_page+0xcc/0x100
>>    kvm_write_guest+0x7c/0xb0
>>    vgic_v3_save_pending_tables+0x148/0x2a0
>>    vgic_set_common_attr+0x158/0x240
>>    vgic_v3_set_attr+0x4c/0x5c
>>    kvm_device_ioctl+0x100/0x160
>>    __arm64_sys_ioctl+0xa8/0xf0
>>    invoke_syscall.constprop.0+0x7c/0xd0
>>    el0_svc_common.constprop.0+0x144/0x160
>>    do_el0_svc+0x34/0x60
>>    el0_svc+0x3c/0x1a0
>>    el0t_64_sync_handler+0xb4/0x130
>>    el0t_64_sync+0x178/0x17c
>>
>> Use vgic_write_guest_lock() to save vgic3 pending table.
>>
>> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>> ---
>>  Documentation/virt/kvm/api.rst | 4 +++-
>>  arch/arm64/kvm/vgic/vgic-v3.c  | 2 +-
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 40ada313faa3..07f07668995e 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -8074,7 +8074,9 @@ NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
>>  tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
>>  KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
>>  command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
>> -"kvm-arm-vgic-its". vgic3 LPI pending status is restored.
>> +"kvm-arm-vgic-its". vgic3 LPI pending status is restored. (3) save
>> +vgic3 pending table through KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES}
>> +command on KVM device "kvm-arm-vgic-v3".
> 
> Can we summarize these 3 examples with something like: "when the guest
> memory (pending tables, ITS tables, etc) is dirtied by the virtual GIC
> or ITS, which is typically triggered by a userspace request (e.g.,
> KVM_DEV_ARM_ITS_SAVE_TABLES) and doesn't require a running VCPU
> context"? In case there will be more no-running-vcpu
> kvm_write_guest_lock() cases in the VGIC emulation code in future and we
> have to extend the documentation..
> 
> But I don't have objection to your writing and the whole series looks
> good.
> 

There are discussions about the documentation when dirty ring is enabled
on ARM64. We prefer to keep the layout where the KVM devices and commands
are explicitly documented. The application developer can identify them
easily and to enable the backup bitmap when those KVM devices have been
used.

By the way, 'vgic3' will be replaced with 'VGICv3' as you suggested in
another reply.

Thanks,
Gavin

