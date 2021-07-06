Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692673BD8F4
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhGFOxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:53:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhGFOwz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5YRgxjBVFyVrsecYfIDXV3/UmWdoKFIP6xE5czOL/I=;
        b=PO96Gbaw9iz7nCoIZIkdLahCVRMSc7lXgTrNWTL1YZC7mubYkUpnp7iux+sDWisOI08KFx
        oPxQxKIQATot3dlu2vYIQ9DtKmZMUhXOlvz9igky9lvMcpRR/0pbtlEymFwe1h83Z+boI/
        n0yqnO/LT2BND3fL2SCm92/S9OVqtRc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-Ghh-e-fRMq-RhUbaegceLg-1; Tue, 06 Jul 2021 10:50:14 -0400
X-MC-Unique: Ghh-e-fRMq-RhUbaegceLg-1
Received: by mail-wm1-f69.google.com with SMTP id m7-20020a05600c4f47b02901ff81a3bb59so1979343wmq.2
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s5YRgxjBVFyVrsecYfIDXV3/UmWdoKFIP6xE5czOL/I=;
        b=M247/HiO/WRIneJyqOUPlU46OPWuUzRZKnqBw25s4TParp2Mo5xws2eK7zqtQ1Rt8r
         g1+X+J9ZCOk/9MXt9HrhlGnos+zOubRZqwkefTWW9LDpfo7WqWmBBF9zK+5KjMZfAw4R
         pVVlh7Opkoy/Od+zxB6OBlSYMjlH8zHxFYRO4kHu6IgCj3KgUBp7CN2xqDXl59h8JA6J
         N0gGyBHcPpXl69tv0OpqjYV15sZX+IE0WTG52UpMxZXTTTCwPAgfdC/zcrszBYI1c00X
         hCYD+oGmu0/cAm8u9AAKdaQruh0wmirEr5D72875y5nGGo2txQFOI630wHWH8RVgS2/o
         e+0w==
X-Gm-Message-State: AOAM532yBK3EZ0NaqxJle+Qj3JbutOsqj1mLXFNUA3BqCI7xhjiozjoH
        NbBTdiqYBR40ilfqTTJ4GzAiIXKy9CQb7EODU4fEgidG2Ax4SMjk5ws6HZTI5mqY5uMaZkWU54T
        L9kEXi9gC42mD
X-Received: by 2002:a5d:530f:: with SMTP id e15mr21899214wrv.217.1625583013663;
        Tue, 06 Jul 2021 07:50:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJUXd4AsURshO/WOcPijFSw+4/Maf9g/IRtAdvHhF7Ym+8rdnyoGw/RRjS3QkvtHK5WXo4aA==
X-Received: by 2002:a5d:530f:: with SMTP id e15mr21899201wrv.217.1625583013504;
        Tue, 06 Jul 2021 07:50:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w8sm18306728wrt.83.2021.07.06.07.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:50:12 -0700 (PDT)
Subject: Re: [RFC PATCH v2 37/69] KVM: x86: Check for pending APICv interrupt
 in kvm_vcpu_has_events()
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <489df8a1b8fb43677c2c2c5347398ce985713577.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02369ee0-8e21-2b30-03c6-94bb885a0ffb@redhat.com>
Date:   Tue, 6 Jul 2021 16:50:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <489df8a1b8fb43677c2c2c5347398ce985713577.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
> interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
> access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,
> i.e. needs to generate a posted interrupt and more importantly can't
> manually move requested interrupts into the vIRR (which it also doesn't
> have access to).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/x86.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f1d5e0a53640..92d5a6649a21 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11341,7 +11341,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>   
>   	if (kvm_arch_interrupt_allowed(vcpu) &&
>   	    (kvm_cpu_has_interrupt(vcpu) ||
> -	    kvm_guest_apic_has_interrupt(vcpu)))
> +	     kvm_guest_apic_has_interrupt(vcpu) ||
> +	     (vcpu->arch.apicv_active &&
> +	      kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))))
>   		return true;
>   
>   	if (kvm_hv_has_stimer_pending(vcpu))
> 

Please remove "dy_" from the name of the callback, and use the static 
call.  Also, if it makes sense, please consider using the same test as 
for patch 38 to choose *between* either kvm_cpu_has_interrupt() + 
kvm_guest_apic_has_interrupt() or 
kvm_x86_ops.dy_apicv_has_pending_interrupt().

Paolo

