Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA0767DA28
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 01:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjA0ADx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 19:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjA0ADw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 19:03:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289752B611
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 16:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674777787;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhI12ICe242ci+pWMRLlhSgKz/EtJeRMJyar7EF8onw=;
        b=deLkXVmwLTh56UwPVnCUkjY3FwYCOFiQQDFU/wuHJtjNxXHCQpcrIPC0VJiHxrR68e7Tmh
        r1MZ2uwdZwPk+3YAen5QY30Ip9maDjFhIqb0dmIJ/IYugam/V0T2XR/796n8XcimZsIzRT
        d1Igc8oigCtqnP/DUv8fWks05y1sI80=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-bRSEd4VSPWK3FSgK10-1kg-1; Thu, 26 Jan 2023 19:03:03 -0500
X-MC-Unique: bRSEd4VSPWK3FSgK10-1kg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF4743810B26;
        Fri, 27 Jan 2023 00:03:02 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C654492B02;
        Fri, 27 Jan 2023 00:02:55 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Add helper vgic_write_guest_lock()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        maz@kernel.org, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        reijiw@google.com, ardb@kernel.org, Julia.Lawall@inria.fr,
        yuzenghui@huawei.com, seanjc@google.com, shan.gavin@gmail.com
References: <20230119234405.349644-1-gshan@redhat.com>
 <20230119234405.349644-2-gshan@redhat.com> <Y9LgplvWZtdjXCEE@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <847162da-f3fd-9bcd-f784-e1b152ad6336@redhat.com>
Date:   Fri, 27 Jan 2023 11:02:53 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y9LgplvWZtdjXCEE@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 1/27/23 7:20 AM, Oliver Upton wrote:
> On Fri, Jan 20, 2023 at 07:44:03AM +0800, Gavin Shan wrote:
>> Currently, the unknown no-running-vcpu sites are reported when a
>> dirty page is tracked by mark_page_dirty_in_slot(). Until now, the
>> only known no-running-vcpu site is saving vgic/its tables through
>> KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on KVM device
>> "kvm-arm-vgic-its". Unfortunately, there are more unknown sites to
>> be handled and no-running-vcpu context will be allowed in these
>> sites: (1) KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} command
>> on KVM device "kvm-arm-vgic-its" to restore vgic/its tables. The
>> vgic3 LPI pending status could be restored. (2) Save vgic3 pending
>> table through KVM_DEV_ARM_{VGIC_GRP_CTRL, VGIC_SAVE_PENDING_TABLES}
>> command on KVM device "kvm-arm-vgic-v3".
>>
>> In order to handle those unknown cases, we need a unified helper
>> vgic_write_guest_lock(). struct vgic_dist::save_its_tables_in_progress
>> is also renamed to struct vgic_dist::save_tables_in_progress. Besides,
>> "asm/kvm_mmu.h" needs to be included for "vgic.h" for the definition
>> of kvm_write_guest_lock().
>>
>> No functional change intended.
>>
>> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/vgic-sys-reg-v3.c   |  1 +
>>   arch/arm64/kvm/vgic/vgic-irqfd.c   |  1 +
>>   arch/arm64/kvm/vgic/vgic-its.c     | 13 +++++--------
>>   arch/arm64/kvm/vgic/vgic-mmio-v2.c |  1 +
>>   arch/arm64/kvm/vgic/vgic-mmio.c    |  1 +
>>   arch/arm64/kvm/vgic/vgic-v4.c      |  1 +
>>   arch/arm64/kvm/vgic/vgic.c         |  1 +
>>   arch/arm64/kvm/vgic/vgic.h         | 13 +++++++++++++
>>   include/kvm/arm_vgic.h             |  2 +-
>>   9 files changed, 25 insertions(+), 9 deletions(-)
> 
> You wouldn't have to add the include all around the shop if you instead
> just stuck it in vgic.h...
> 
> Having said that, we really ought to get a fix in for this sooner rather
> than later. I just hit it myself testing kvmarm/next.
> 
> Marc, could you take care of the include fix when applying?
> 

I've posted v3 to have a separate PATCH[1/4] where the header file inclusions
are handled, to save Marc's valuable time. After 'kvm_mmu.h' is included to
'vgic.h', the duplicate inclusions of 'kvm_mmu.h' needs to be removed. A separate
patch would make the follow-up patches clean.

https://lore.kernel.org/kvmarm/20230126235451.469087-1-gshan@redhat.com/T/#t

Thanks,
Gavin

