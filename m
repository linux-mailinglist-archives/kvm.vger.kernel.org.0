Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72571D38F9
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgENSOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 14:14:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48685 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbgENSOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 14:14:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589480076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mzIRU4hVPjXb67rBZK7y/2XlzdUyGaI9NSRoPkeSbzM=;
        b=ej7RVucZZp7pD3E+g2drq3xqyWwsU+OiMNkcwkO37qkGBQDVfXC6ZbFf9PGgxTNVtZDFmr
        osYZQWuYisxGc55c9G7YCiNuR2diKijfkvoC0JUXa+exQI+q3VYL+GfZR9Lch491gqkD2z
        F4THVaQMNJZxfOqOd5JpS2/VOpiRKqI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-w5fwDPYHPLKyS2ZcnD6XBw-1; Thu, 14 May 2020 14:14:34 -0400
X-MC-Unique: w5fwDPYHPLKyS2ZcnD6XBw-1
Received: by mail-wm1-f69.google.com with SMTP id m123so7143792wmm.5
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 11:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mzIRU4hVPjXb67rBZK7y/2XlzdUyGaI9NSRoPkeSbzM=;
        b=OL/vwJUn2yDfSzi0oB/WW/5PZShAM+ZJdgKw15+ASjZk/VHu9z9XFiO67mbf7qew4e
         jSamWZ034x5sSCteR61NZNewHayIFfk0L2ZubVeuXmySCpoF6FM1IV2NIHt7BNQdv+QG
         ry3tDVe/NaSsFP4r6mBc14yOR0QscULzAzkWzykFMLb9NWAllKe94f553RP8JkdTRIrq
         YpRAEyn4/GfcSN4ZbsGfC7wu9LeLSjRbQzTSGms5wSgSp28b5hgeTbGb+ZG0lTQNGQ8z
         J+83lXNTKH8WG8Fa9foKJzdbyLXbI7XU4dq8kP/RmjQ1deg8g4WxyRBWuZQp8L5YiBTg
         TG1w==
X-Gm-Message-State: AOAM530EKrJwJpoWBFHvp5v6mOvOMxYAO83xXERkUbVTyY9YPT5/S2zx
        FAO0z0YrYpnrDm1Y1ovVAKnF2HDcRz5nCsj4m6/bvSW7FNR5NTs7e0RTxy+I+qpaCQSmrnuIqzu
        Wn2VI5vfu8mwU
X-Received: by 2002:a5d:6984:: with SMTP id g4mr6936846wru.205.1589480073426;
        Thu, 14 May 2020 11:14:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeTxfc3WgAu3tduIxRklHv12LODcL10ChQ0vTuJJthnagTCTpnhId4fsqEruy7KgrIjEIUEw==
X-Received: by 2002:a5d:6984:: with SMTP id g4mr6936819wru.205.1589480073134;
        Thu, 14 May 2020 11:14:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b145sm20013128wme.41.2020.05.14.11.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 11:14:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] KVM: x86: Interrupt-based mechanism for async_pf 'page present' notifications
In-Reply-To: <20200513141644.GD173965@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com> <20200513141644.GD173965@redhat.com>
Date:   Thu, 14 May 2020 20:14:31 +0200
Message-ID: <87lfluwfi0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, May 11, 2020 at 06:47:44PM +0200, Vitaly Kuznetsov wrote:
>> Concerns were expressed around (ab)using #PF for KVM's async_pf mechanism,
>> it seems that re-using #PF exception for a PV mechanism wasn't a great
>> idea after all. The Grand Plan is to switch to using e.g. #VE for 'page
>> not present' events and normal APIC interrupts for 'page ready' events.
>> This series does the later.
>
> Hi Vitaly,
>
> How does any of this impact nested virtualization code (if any).
>
> I have tried understanding that logic, but I have to admit, I could
> never get it.
>
> arch/x86/kvm/mmu/mmu.c
>
> int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>                                 u64 fault_address, char *insn, int insn_len)
> {
>         switch (vcpu->arch.apf.host_apf_reason) {
> 		case KVM_PV_REASON_PAGE_NOT_PRESENT:
> 			kvm_async_pf_task_wait(fault_address, 0);
> 		case KVM_PV_REASON_PAGE_READY:
> 			kvm_async_pf_task_wake(fault_address);
> 	}
> }
>

"[PATCH 8/8] KVM: x86: drop KVM_PV_REASON_PAGE_READY case from
kvm_handle_page_fault()" modifies this a little bit.

Basically (and if I understand this correctly) we have the following APF
related feature (bit 2 in MSR_KVM_ASYNC_PF_EN): "asynchronous page faults
are delivered to L1 as #PF vmexits.". When enabled, it allows L0 to
inject #PF when L2 guest is running. L1 will see this as '#PF vmexit'
and the code you cite will do exactly what do_async_page_fault() is
doing.

When we switch to interrupt based delivery for 'page ready' events we
don't need a special handling for them in L1 (as we don't need any
special handling for all interrupts from devices in kernel when KVM
guest is running).

I have to admit I haven't tested nested scenario yet, "what could go
wrong?" :-)

-- 
Vitaly

