Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449A6286FF2
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 09:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgJHHx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 03:53:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728551AbgJHHxy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Oct 2020 03:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602143632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EeM2tLJZZ0I2/r5lqO36RjPkuKxF/JUEoiCYcpWWhqk=;
        b=ZgoC3w7QSWyCOVwtlVTogZhL3L1m8FLkSGCjyZ+U9orJsbb/kyq7hNKy9q/T8BYtfGv7Vp
        vm1S90kMAI3r4wIxVnkcUgOgwF4tlH52gNRx2GRLAVq1JwssRieDpz+0CGZM9VnbaRQQck
        KtjJGViBJO1uhy5I6vGLPxcPlf92BNA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-yR4Zlmg1MYqHYgX-HGRVew-1; Thu, 08 Oct 2020 03:53:50 -0400
X-MC-Unique: yR4Zlmg1MYqHYgX-HGRVew-1
Received: by mail-wm1-f71.google.com with SMTP id l15so2835851wmh.9
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 00:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EeM2tLJZZ0I2/r5lqO36RjPkuKxF/JUEoiCYcpWWhqk=;
        b=ROQNBpDoHoXmXjVEIWOLgAOuh0drafFYwJ/8ATJc3bCNtCHSzdrK2G+TlDIlhu2RRE
         VJkctminpz+tGGCTUdUcWruSJ4TppucE5ymEFQTumK/DD5S55lqGIf5oI6ixz4PimlKd
         V/zeBHGDEQNUs6SaXgQV1qb5a350GZIVOy0jtJ0fc0/zPc6vgiwVHGlcZbpNkd+kU+Pu
         M2nJ+/HVt75buBAqUgJZrDWOIcqBWezwvALuVoDbUeF5k4RjmGCLJNxq+jClLj7U4WTA
         1m27r4O6ETa3MTCSaQpIJBCnDCO1O0nINqlv1TZ4lFN8SNKxNi+Tq+zO6BJT618nYzRa
         +YXw==
X-Gm-Message-State: AOAM530BMGXNWwSOxAsIrVN+vSEFydSiNj5pOrRYKKIFhHgjZITJ1L50
        Z+lza5ncVKxPSnwFV3CwZFv0AmiYdsGEzl4+e8eAeNV+v7Bi3FSv+uKjdd7DQLlHZ2kqBw6dd4o
        L+uiUvb612Uby
X-Received: by 2002:a1c:18e:: with SMTP id 136mr7256355wmb.22.1602143629380;
        Thu, 08 Oct 2020 00:53:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlqMrh6Oifv8gtpC0X15zKaWdZW+8KKdLiQ7jPmO272mmr1uqaYmTj1jdafiVks0BedvgiZQ==
X-Received: by 2002:a1c:18e:: with SMTP id 136mr7256338wmb.22.1602143629140;
        Thu, 08 Oct 2020 00:53:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bb8c:429c:6de1:f4ec? ([2001:b07:6468:f312:bb8c:429c:6de1:f4ec])
        by smtp.gmail.com with ESMTPSA id t124sm5954769wmg.31.2020.10.08.00.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 00:53:48 -0700 (PDT)
Subject: Re: [PATCH] target/i386: Support up to 32768 CPUs without IRQ
 remapping
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     x86 <x86@kernel.org>, kvm <kvm@vger.kernel.org>
References: <78097f9218300e63e751e077a0a5ca029b56ba46.camel@infradead.org>
 <6f8704bf-f832-9fcc-5d98-d8e8b562fe2f@redhat.com>
 <698c8ab6783a3113d90d8435d07a2dce6a2e2ec9.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b9c8ca4-e89e-e140-d591-76dcb2cad485@redhat.com>
Date:   Thu, 8 Oct 2020 09:53:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <698c8ab6783a3113d90d8435d07a2dce6a2e2ec9.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/20 09:29, David Woodhouse wrote:
> On Thu, 2020-10-08 at 08:56 +0200, Paolo Bonzini wrote:
>> On 05/10/20 16:18, David Woodhouse wrote:
>>> +        if (kvm_irqchip_is_split()) {
>>> +            ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
>>> +        }
>>
>> IIUC this is because in-kernel IOAPIC still doesn't work; and when it
>> does, KVM will advertise the feature itself so no other QEMU changes
>> will be needed.
> 
> More the MSI handling than the IOAPIC. I haven't actually worked out
> *what* handles cycles to addresses in the 0xFEExxxxx range for the in-
> kernel irqchip and turns them into interrupts (after putting them
> through interrupt remapping, if/when the kernel learns to do that).

That's easy: it's QEMU. :)  See kvm_apic_mem_write in hw/i386/kvm/apic.c
(note that this memory region is never used when the CPU accesses
0xFEExxxxx, only when QEMU does.

Conversion from the IOAPIC and MSI formats to struct kvm_lapic_irq is
completely separate in KVM, it is respectively in ioapic_service and
kvm_set_msi_irq.  Both of them prepare a struct kvm_lapic_irq, but
they're two different paths.

> Ideally the IOAPIC would just swizzle the bits in its RTE to create an
> MSI message and pass it on to the same code to be (translated and)
> delivered.
> 
> You'll note my qemu patch didn't touch IOAPIC code at all, because
> qemu's IOAPIC really does just that.

Indeed the nice thing about irqchip=split is that the handling of device
interrupts is entirely confined within QEMU, no matter if they're IOAPIC
or MSI.  And because we had to implement interrupt remapping, the IOAPIC
is effectively using MSIs to deliver its interrupts.

There's still the hack to communicate IOAPIC routes to KVM and have it
set the EOI exit bitmap correctly, though.  The code is in
kvm_scan_ioapic_routes and it uses kvm_set_msi_irq (with irqchip=split
everything is also an MSI within the kernel).  I think you're not
handling that correctly for CPUs >255, so after all we _do_ need some
kernel support.

Paolo

>> I queued this, though of course it has to wait for the corresponding
>> kernel patches to be accepted (or separated into doc and non-KVM
>> parts; we'll see).
> 
> Thanks.
> 

