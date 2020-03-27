Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C039B195379
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgC0JAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:00:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54058 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgC0JAV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 05:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585299619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXn06OBqafJOcrur/EKuL7fTmScTGWRZwAAJXIbK1TM=;
        b=C1OH9R8Nj5Jajv8Ex2lvtOvhdXxsGkdPCtYBQduuqh2C8d0Uonao7Sxv9zLdXgPJ11YLom
        VCAzlWBUjHSBBLKOWCqc5/SdP904XYfv/P+Fbh9d82QOLCfddZKS7636FFrjSuyJHLRSnB
        tOQpNy6w6Q4Q+doTHGDCz03slv0PaP0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-W4ix9-X_P7Gage2-CzQWOg-1; Fri, 27 Mar 2020 05:00:17 -0400
X-MC-Unique: W4ix9-X_P7Gage2-CzQWOg-1
Received: by mail-wm1-f69.google.com with SMTP id g9so5339499wmh.1
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 02:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xXn06OBqafJOcrur/EKuL7fTmScTGWRZwAAJXIbK1TM=;
        b=gRs7/S0ECeEq0VtVXFnKty/ybud79XvEBhRrz70Px80XUFbAu88PxIHW3151of5bP1
         rqUHZdgNH4IB5OER/WbiyBfgwIYwZxeyo/3f9i20afaJQP1vAzLZuJrswJE4RnK4osK9
         wPHeO+EeQX6AMpjeDwow9Gek30TU/tij3q7Tc5oZ1SiIhyWKZTkqocrGpCvmx+d2HBTe
         yROu1CANbWuksvnUbViNyw8d+eI+/251F8CBMN2fAHKR96gyvWBIczcgFc0O+jwL8fKY
         HtPa5cKfqnblgc7dVvJW6iYwrvWWQqcpQOTKZnXFhH+nYfC73B6DHAEi1uDtVH8Q24P5
         l1kA==
X-Gm-Message-State: ANhLgQ3tU2cQiybsUisKxhx/VUQwR+L0GllJ9/jCNMzHkJdqvQSJwfzU
        woGyvRQ5YKCaX7e/TmXYTqn07e84ffJmAxSYn18pkS4T4P5WC8sAtOxm8FtSxAd+2R0hbGM2XEO
        ziUKj9R3RfFBC
X-Received: by 2002:a7b:c005:: with SMTP id c5mr4246491wmb.170.1585299616261;
        Fri, 27 Mar 2020 02:00:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vupCgbub67CH9ToceY2ONuYK3r55PSSyGg0pZYTP2Bzke32oW0juDI1XeKQGvWvA4hyB0SRUA==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr4246456wmb.170.1585299616001;
        Fri, 27 Mar 2020 02:00:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 71sm7846558wrc.53.2020.03.27.02.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 02:00:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: X86: Filter the broadcast dest for IPI fastpath
In-Reply-To: <1585290240-18643-1-git-send-email-wanpengli@tencent.com>
References: <1585290240-18643-1-git-send-email-wanpengli@tencent.com>
Date:   Fri, 27 Mar 2020 10:00:14 +0100
Message-ID: <87h7ya41gh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Except destination shorthand, a destination value 0xffffffff is used to 
> broadcast interrupts, let's also filter this for single target IPI fastpath.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 3 ---
>  arch/x86/kvm/lapic.h | 3 +++
>  arch/x86/kvm/x86.c   | 3 ++-
>  3 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a38f1a8..88929b1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -59,9 +59,6 @@
>  #define MAX_APIC_VECTOR			256
>  #define APIC_VECTORS_PER_REG		32
>  
> -#define APIC_BROADCAST			0xFF
> -#define X2APIC_BROADCAST		0xFFFFFFFFul
> -
>  static bool lapic_timer_advance_dynamic __read_mostly;
>  #define LAPIC_TIMER_ADVANCE_ADJUST_MIN	100	/* clock cycles */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_MAX	10000	/* clock cycles */
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index bc76860..25b77a6 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -17,6 +17,9 @@
>  #define APIC_BUS_CYCLE_NS       1
>  #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
>  
> +#define APIC_BROADCAST			0xFF
> +#define X2APIC_BROADCAST		0xFFFFFFFFul
> +
>  enum lapic_mode {
>  	LAPIC_MODE_DISABLED = 0,
>  	LAPIC_MODE_INVALID = X2APIC_ENABLE,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4bb7d8..495709f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1559,7 +1559,8 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>  
>  	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
>  		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
> -		((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
> +		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
> +		((u32)(data >> 32) != X2APIC_BROADCAST)) {
>  
>  		data &= ~(1 << 12);
>  		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

