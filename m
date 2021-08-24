Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB03F58BF
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhHXHOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:14:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233025AbhHXHOZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 03:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629789221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mHQV1RhDVLp4LgprkNafJyD8Xso+/EcdUT8pyuTCElk=;
        b=f2EPsMo8Q5UU2Nk3hH8ACLV4TnvG+w1SzvnAVo3fdg4R6nAYPwdBGsLzaZKLA6jW8r1Ryy
        dAFDaD1LSUfywbQrsrZZC/a2dowTJR+WtuVXHaDBBScKpE9uVC4kgHEtxJCN58RkQc4gRX
        nQJV80GgZ/6X6Q01Lo+/2CMHNqXGZwM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-nfeN-m4VOhOCBMccxUTXWw-1; Tue, 24 Aug 2021 03:13:39 -0400
X-MC-Unique: nfeN-m4VOhOCBMccxUTXWw-1
Received: by mail-wm1-f72.google.com with SMTP id c4-20020a1c9a04000000b002e864b7edd1so524875wme.6
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 00:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mHQV1RhDVLp4LgprkNafJyD8Xso+/EcdUT8pyuTCElk=;
        b=iEfeK7ukH2e5qsU46UDNTlLzt0IGrthpB6+fvueHWjIYqeTvsiMiC+LnRjn+HhRlEA
         jLFp1bsueKwePOeeWwy5lWiIuHB3/vd12dKT6MoRXO3oGHHj58JghwpACOBMTT72DO0Q
         O6rJ2mC+aYDsikqFglKJlYpthTk80gCm7N2Q/eChZF7mBHMInc13k80Qux5BPGn2CO2o
         JY8LlEUWHCEB3k0r7nN1UMnzCrw5NAcPOUy7ekZXoUl13kghMSEqhaCree2pe/v6ygf9
         mwnr7nubUUf/GfG6yaw+TUyXr2UMDCdFGNvUjanNB93yJriUEY0cy2qmGOEvsZX4H280
         mlLQ==
X-Gm-Message-State: AOAM530wjID3r6kvV8sY1ixI506ORnQiccZ+D0g9PYgjy2SqTG8D1fzr
        KpufUNCW1oukKHB893SWu5ZqCwemrjAtfRR4RntUzkTvHrkj19g/9hKm2qQHuirfkBUN1f1+2qV
        9LhzVBJkD+SZA
X-Received: by 2002:a05:600c:41d4:: with SMTP id t20mr2600486wmh.92.1629789217825;
        Tue, 24 Aug 2021 00:13:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2mWaXyMXXUDC26Nsu4dEPI1cRg93LOjwHFu68ci+aDY5hV5E4VxH/FtAZhbEk/qFV2v2OWw==
X-Received: by 2002:a05:600c:41d4:: with SMTP id t20mr2600466wmh.92.1629789217592;
        Tue, 24 Aug 2021 00:13:37 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c14sm8302080wrr.58.2021.08.24.00.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 00:13:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
In-Reply-To: <20210823185841.ov7ejn2thwebcwqk@habkost.net>
References: <20210823143028.649818-1-vkuznets@redhat.com>
 <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net>
Date:   Tue, 24 Aug 2021 09:13:36 +0200
Message-ID: <87mtp7jowv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> writes:

> On Mon, Aug 23, 2021 at 04:30:28PM +0200, Vitaly Kuznetsov wrote:
>> KASAN reports the following issue:
>> 
>>  BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>>  Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798
>> 
>>  CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
>>  Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
>>  Call Trace:
>>   dump_stack+0xa5/0xe6
>>   print_address_description.constprop.0+0x18/0x130
>>   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>>   __kasan_report.cold+0x7f/0x114
>>   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>>   kasan_report+0x38/0x50
>>   kasan_check_range+0xf5/0x1d0
>>   kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>>   kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
>>   ? kvm_arch_exit+0x110/0x110 [kvm]
>>   ? sched_clock+0x5/0x10
>>   ioapic_write_indirect+0x59f/0x9e0 [kvm]
>>   ? static_obj+0xc0/0xc0
>>   ? __lock_acquired+0x1d2/0x8c0
>>   ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]
>> 
>> The problem appears to be that 'vcpu_bitmap' is allocated as a single long
>> on stack and it should really be KVM_MAX_VCPUS long. We also seem to clear
>> the lower 16 bits of it with bitmap_zero() for no particular reason (my
>> guess would be that 'bitmap' and 'vcpu_bitmap' variables in
>> kvm_bitmap_or_dest_vcpus() caused the confusion: while the later is indeed
>> 16-bit long, the later should accommodate all possible vCPUs).
>> 
>> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
>> Fixes: 9a2ae9f6b6bb ("KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap")
>> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/ioapic.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index ff005fe738a4..92cd4b02e9ba 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -319,7 +319,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>>  	unsigned index;
>>  	bool mask_before, mask_after;
>>  	union kvm_ioapic_redirect_entry *e;
>> -	unsigned long vcpu_bitmap;
>> +	unsigned long vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>
> Is there a way to avoid this KVM_MAX_VCPUS-sized variable on the
> stack?  This might hit us back when we increase KVM_MAX_VCPUS to
> a few thousand VCPUs (I was planning to submit a patch for that
> soon).

What's the short- or mid-term target?

Note, we're allocating KVM_MAX_VCPUS bits (not bytes!) here, this means
that for e.g. 2048 vCPUs we need 256 bytes of the stack only. In case
the target much higher than that, we will need to either switch to
dynamic allocation or e.g. use pre-allocated per-CPU variables and make
this a preempt-disabled region. I, however, would like to understand if
the problem with allocating this from stack is real or not first.

>
>
>>  	int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
>>  
>>  	switch (ioapic->ioregsel) {
>> @@ -384,9 +384,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>>  			irq.shorthand = APIC_DEST_NOSHORT;
>>  			irq.dest_id = e->fields.dest_id;
>>  			irq.msi_redir_hint = false;
>> -			bitmap_zero(&vcpu_bitmap, 16);
>> +			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
>>  			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>> -						 &vcpu_bitmap);
>> +						 vcpu_bitmap);
>>  			if (old_dest_mode != e->fields.dest_mode ||
>>  			    old_dest_id != e->fields.dest_id) {
>>  				/*
>> @@ -399,10 +399,10 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>>  				    kvm_lapic_irq_dest_mode(
>>  					!!e->fields.dest_mode);
>>  				kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>> -							 &vcpu_bitmap);
>> +							 vcpu_bitmap);
>>  			}
>>  			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
>> -							  &vcpu_bitmap);
>> +							  vcpu_bitmap);
>>  		} else {
>>  			kvm_make_scan_ioapic_request(ioapic->kvm);
>>  		}
>> -- 
>> 2.31.1
>> 

-- 
Vitaly

