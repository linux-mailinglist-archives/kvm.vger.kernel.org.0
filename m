Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF281640DB
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 10:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBSJyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 04:54:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726385AbgBSJyV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 04:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582106060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+590MGy8slvCwOcarh/x5+GjQgQiBdCOw3lnRNEYUq8=;
        b=ZxNK/F3byo44IIjWwGEjQ5uFlmj9mfkEXFfZLiku8jRV9fGr320WUDjEYNfBQ0o0H6l5+Y
        Fx7EvgR0JcXh9Xe5BMWqke8du8XbDyLiGvaUBsEDxVHSpDqb9xZ0bUMVjYbbFhKwxSeenh
        oNTNjL6T20YQfEH7IAdmdxMydmk6hok=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-2VLV1mwpPqGijoOzJG328A-1; Wed, 19 Feb 2020 04:54:17 -0500
X-MC-Unique: 2VLV1mwpPqGijoOzJG328A-1
Received: by mail-wm1-f69.google.com with SMTP id n17so1391357wmk.1
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 01:54:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+590MGy8slvCwOcarh/x5+GjQgQiBdCOw3lnRNEYUq8=;
        b=o/1UQF515RjNcSxLcEKUh7TVBC9gYxC7fH5FFRWkgaNqvBiDvpaveLqFcSLQeRcf2a
         Yw3VtoZMZ9bU/N6L0PPcqSe4GRJSC7jkIfoxCn7p8Xaf+iOKO+KMHLzfYZq9ENVQ5D94
         V+V+EQbU6nyrOeT47PqGjmuuScFe0NQnpls1fR2+RGAk5/Jum1XdJ9MJgt491qLjjpiI
         p01ASmdRN5laJZNXmUn85tSiyy7l30hPY4QFPZC5QZNLUwqnRKw7gjDUZifqaFgxJr40
         lfT5a2UxLyfXJWsIWhoK+FdJJ0llXNaUq7H5WKfHzk+f7qtyl5kEioke6AWgVxOUTmk7
         DJXw==
X-Gm-Message-State: APjAAAU7fC+wJQ6q9XL0ow3j5P3ttftBdOok0sU+FhO+Uft62erszx/Y
        bdaI/MbsxBEQUTczUcqZMSfwI3PifkDkzpxBEIrBrHfY+F/L9eyP0/pnYCieYi8b2NF9ASGkQFm
        Klfe8jUrkyD2F
X-Received: by 2002:a5d:5273:: with SMTP id l19mr36731477wrc.175.1582106056553;
        Wed, 19 Feb 2020 01:54:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqxztJqRwkbVqb4PRGgJGnIqDWtAG3o0PybRen6hTmJaEvGmq984n2y6ghWTKyEO5UUMDCh4Rg==
X-Received: by 2002:a5d:5273:: with SMTP id l19mr36731437wrc.175.1582106056175;
        Wed, 19 Feb 2020 01:54:16 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t128sm2361371wmf.28.2020.02.19.01.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 01:54:15 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] target/i386: filter out VMX_PIN_BASED_POSTED_INTR when enabling SynIC
In-Reply-To: <d5a3159d-4cab-ef94-bbfc-e9120324cd3e@redhat.com>
References: <20200218144415.94722-1-vkuznets@redhat.com> <9b4b46c2-e2cf-a3d5-70e4-c8772bf6734f@redhat.com> <87k14j962l.fsf@vitty.brq.redhat.com> <d5a3159d-4cab-ef94-bbfc-e9120324cd3e@redhat.com>
Date:   Wed, 19 Feb 2020 10:54:14 +0100
Message-ID: <878sky9a2h.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/02/20 18:08, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>>> On 18/02/20 15:44, Vitaly Kuznetsov wrote:
>>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>> ---
>>>> RFC: This is somewhat similar to eVMCS breakage and it is likely possible
>>>> to fix this in KVM. I decided to try QEMU first as this is a single
>>>> control and unlike eVMCS we don't need to keep a list of things to disable.
>>>
>>> I think you should disable "virtual-interrupt delivery" instead (which
>>> in turn requires "process posted interrupts" to be zero).  That is the
>>> one that is incompatible with AutoEOI interrupts.
>> 
>> I'm fighting the symptoms, not the cause :-) My understanding is that
>> when SynIC is enabled for CPU0 KVM does
>> 
>> kvm_vcpu_update_apicv()
>> 	vmx_refresh_apicv_exec_ctrl()
>> 		pin_controls_set()
>> 
>> for *all* vCPUs (KVM_REQ_APICV_UPDATE). I'm not sure why
>> SECONDARY_EXEC_APIC_REGISTER_VIRT/SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
>> are not causing problems and only PIN_BASED_POSTED_INTR does as we clear
>> them all (not very important atm).
>
> Let's take a step back, what is the symptom, i.e. how does it fail?

I just do

~/qemu/x86_64-softmmu/qemu-system-x86_64 -machine q35,accel=kvm -cpu host,hv_vpindex,hv_synic -smp 2 -m 16384 -vnc :0
and get
qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016
qemu-system-x86_64: /root/qemu/target/i386/kvm.c:2684: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
Aborted

(it works with '-smp 1' or without 'hv_synic')

> Because thinking more about it, since we have separate VMCS we can set
> PIN_BASED_POSTED_INTR and SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY just fine
> in the vmcs02.
> The important part is to unconditionally call
> vmx_deliver_nested_posted_interrupt.
>
> Something like
>
> 	if (kvm_x86_ops->deliver_posted_interrupt(vcpu, vector)) {
>                 kvm_lapic_set_irr(vector, apic);
>                 kvm_make_request(KVM_REQ_EVENT, vcpu);
>                 kvm_vcpu_kick(vcpu);
>         }
>
> and in vmx_deliver_posted_interrupt
>
>         r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
>         if (!r)
>                 return 0;
>
> 	if (!vcpu->arch.apicv_active)
>                 return -1;
>         ...
>         return 0;

Sound like a plan, let me try playing with it.

-- 
Vitaly

