Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC483184C39
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 17:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCMQTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 12:19:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36353 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbgCMQTI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 12:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584116347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sel3wVVn/IDeCE+QRafOTlr+Thswa40aMpw5w3+KcLk=;
        b=LrHqdxeyGLyNouBKEVmLUrMBWxakb6xSNg6/wBXK2kd6XN2v7dAKvBG/gO0ur2nSGQpL56
        IhFRu7IB1YVDOr+NFkw2Mbw665SgTn2nYI78j1ZZUPaaTxM4xJySuauwU+cEI6548E+aCq
        aKMaWNE0+33n9r2ixgwJ760FgclxaVQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-gb8BgScgOpiay73onfAGog-1; Fri, 13 Mar 2020 12:19:05 -0400
X-MC-Unique: gb8BgScgOpiay73onfAGog-1
Received: by mail-wm1-f70.google.com with SMTP id z26so3570102wmk.1
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 09:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Sel3wVVn/IDeCE+QRafOTlr+Thswa40aMpw5w3+KcLk=;
        b=ACTUVheZXbjz0ARFRYPeybw60RFiaogxvZmfh2Z4NuP0DlBkDjGkvCWYSgaTtR4SYB
         xlfuUS/NGCijzJocvyEDsm2A6CGUKSXtkff+hwlVcmfEaLouooVRYF5UNYp8adjnpIf/
         XfulZsuoqvIZ9KRRA16epLtYxFrmSc6/hKP06BjgPgYx7BwvnBvahi7enenF6r4aozra
         oqEie6Trsf2K7MOaxpBpXXgdKNsQxIbqeNCZUTGAWe8pL+HgKisyiEaL6sU/VjrL/x8e
         FCkpxwOdjR6Era/NlvpfpQL0H1QztF12ubmcPSq2yD2TavqHY4yqjgE9ky3CwShyEZUC
         xmnw==
X-Gm-Message-State: ANhLgQ1Zr6HwV3AprUnFOAB71cBMwu0d0ozU3+BUd+C5joD2bW+JpPMi
        524Iq6utjDNtgWmk9S5K1lEPMHmowaoSSnI+AchTjCG40jYj3CuYmTAHtNtWKpvcDQ+KTGoFLPA
        aY+9lApLNKqvi
X-Received: by 2002:adf:ed86:: with SMTP id c6mr19564270wro.53.1584116340778;
        Fri, 13 Mar 2020 09:19:00 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsGhDC76TPw20+jcWR7sr1cQhX4ivcMb3Es6OrPp3gMT65NEoJZYv9aGV9+66ubHLDl22s7Eg==
X-Received: by 2002:adf:ed86:: with SMTP id c6mr19564241wro.53.1584116340535;
        Fri, 13 Mar 2020 09:19:00 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w67sm13566135wmb.41.2020.03.13.09.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 09:18:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, peterx@redhat.com
Subject: Re: [Patch v2] KVM: x86: Initializing all kvm_lapic_irq fields in ioapic_write_indirect
In-Reply-To: <e20e4fb5-247c-a029-e09f-49f83f2f9d1a@redhat.com>
References: <1584105384-4864-1-git-send-email-nitesh@redhat.com> <871rpwpesg.fsf@vitty.brq.redhat.com> <29c41f43-a8c6-3d72-8647-d46782094524@redhat.com> <e20e4fb5-247c-a029-e09f-49f83f2f9d1a@redhat.com>
Date:   Fri, 13 Mar 2020 17:18:59 +0100
Message-ID: <87v9n8mdn0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitesh Narayan Lal <nitesh@redhat.com> writes:

> On 3/13/20 9:38 AM, Nitesh Narayan Lal wrote:
>> On 3/13/20 9:25 AM, Vitaly Kuznetsov wrote:
>>> Nitesh Narayan Lal <nitesh@redhat.com> writes:
>>>
>>>> Previously all fields of structure kvm_lapic_irq were not initialized
>>>> before it was passed to kvm_bitmap_or_dest_vcpus(). Which will cause
>>>> an issue when any of those fields are used for processing a request.
>>>> For example not initializing the msi_redir_hint field before passing
>>>> to the kvm_bitmap_or_dest_vcpus(), may lead to a misbehavior of
>>>> kvm_apic_map_get_dest_lapic(). This will specifically happen when the
>>>> kvm_lowest_prio_delivery() returns TRUE due to a non-zero garbage
>>>> value of msi_redir_hint, which should not happen as the request belongs
>>>> to APIC fixed delivery mode and we do not want to deliver the
>>>> interrupt only to the lowest priority candidate.
>>>>
>>>> This patch initializes all the fields of kvm_lapic_irq based on the
>>>> values of ioapic redirect_entry object before passing it on to
>>>> kvm_bitmap_or_dest_vcpus().
>>>>
>>>> Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>>>> ---
>>>>  arch/x86/kvm/ioapic.c | 7 +++++--
>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>>>> index 7668fed..3a8467d 100644
>>>> --- a/arch/x86/kvm/ioapic.c
>>>> +++ b/arch/x86/kvm/ioapic.c
>>>> @@ -378,12 +378,15 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>>>>  		if (e->fields.delivery_mode == APIC_DM_FIXED) {
>>>>  			struct kvm_lapic_irq irq;
>>>>  
>>>> -			irq.shorthand = APIC_DEST_NOSHORT;
>>>>  			irq.vector = e->fields.vector;
>>>>  			irq.delivery_mode = e->fields.delivery_mode << 8;
>>>> -			irq.dest_id = e->fields.dest_id;
>>>>  			irq.dest_mode =
>>>>  			    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
>>>> +			irq.level = 1;
>>> 'level' is bool in struct kvm_lapic_irq but other than that, is there a
>>> reason we set it to 'true' here? I understand that any particular
>>> setting is likely better than random
>> Yes, that is the only reason which I had in my mind while doing this change.
>> I was not particularly sure about the value, so I copied what ioapic_serivce()
>> is doing.
>
> Do you think I should skip setting this here?
>

Personally, i'd initialize it to 'false': usualy, if something is not
properly initialized it's either 0 or garbage)

>>>  and it should actually not be used
>>> without setting it first but still?
>>>
>>>> +			irq.trig_mode = e->fields.trig_mode;
>>>> +			irq.shorthand = APIC_DEST_NOSHORT;
>>>> +			irq.dest_id = e->fields.dest_id;
>>>> +			irq.msi_redir_hint = false;
>>>>  			bitmap_zero(&vcpu_bitmap, 16);
>>>>  			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
>>>>  						 &vcpu_bitmap);

-- 
Vitaly

