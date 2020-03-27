Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0006719538D
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 10:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgC0JHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 05:07:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46301 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgC0JHE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 05:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585300023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=71Cru4C3vnzvZ26+jzuOXh79FYop4hgTcQe3zQfrsj4=;
        b=jQ59fB2eZsLT26pdWxpa+T058DrR+X7ADtyGxJlCWK2+XOOC4Biz5aIM5tiCHwTxTnit6o
        koT+hr/Y7NeooK39vNo2s1HPpGQKwLwQXjHWlJEzk+lr5fag3W9ue1cttUtki886629WEJ
        FyGFhF28Lcgr/9UWqUFM/zXhiUIGpJA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-Z6WGw0blOdCqCcNJH6ukuw-1; Fri, 27 Mar 2020 05:07:01 -0400
X-MC-Unique: Z6WGw0blOdCqCcNJH6ukuw-1
Received: by mail-wr1-f70.google.com with SMTP id y1so4243607wrn.10
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 02:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=71Cru4C3vnzvZ26+jzuOXh79FYop4hgTcQe3zQfrsj4=;
        b=q83xYqlvlnZ4ppepkjvSMELs0O7Evq6hMRYlmA95OuwpGlpiJYjXtAmDYWUu1wn0AD
         AgpICKSqV9jHW8KsS63q+Hk2lv2xbu+jx8X1UIpwLsxUmyQmYGlzesEBn1EwnLMhf7np
         QBxFhEUreuXolA5i+1ZVjPXcQW5H78A9rzs8MhvOl/AKGcP+Niyn5cM/VrpRq8EaQu2b
         NrJRnxPVda8ZvbP603+GfifNM5iRzh9BW3RnO5YUX5VaWv0TzNMomrzu0PGZyo/R3oGf
         /cNCQ7IBI+VpFh13oh4AtuLf6DNU1N6GgfAB7zKXnSktNExIY9j5wvi3VDIys3C3urTm
         JJvw==
X-Gm-Message-State: ANhLgQ0lK/6a237cjrpKPz9fa6PdYM2itMl6jEpPDMm0+7NWUvqbgh2i
        BYUFjiBDehCFdW+Eu8jz/bvHUdON31t1unzuh04mGQVZXvFYsESY9wuYsSTBPh2L3cVhxq9SNlN
        qxHCgGrnkQ0ZD
X-Received: by 2002:a1c:456:: with SMTP id 83mr4350168wme.54.1585300020156;
        Fri, 27 Mar 2020 02:07:00 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtZ4qh8zvYAdJlTYjI7+wfGokNX7n+hK9IBSpYR6QPlJ9hK8Hp1qimejmKl24bCB91TTDz8pA==
X-Received: by 2002:a1c:456:: with SMTP id 83mr4350146wme.54.1585300019959;
        Fri, 27 Mar 2020 02:06:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b11sm7419945wrq.26.2020.03.27.02.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 02:06:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/2] KVM: LAPIC: Don't need to clear IPI delivery status for x2apic
In-Reply-To: <1585290240-18643-2-git-send-email-wanpengli@tencent.com>
References: <1585290240-18643-1-git-send-email-wanpengli@tencent.com> <1585290240-18643-2-git-send-email-wanpengli@tencent.com>
Date:   Fri, 27 Mar 2020 10:06:57 +0100
Message-ID: <87eete415a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> IPI delivery status field is not present for x2apic, don't need 
> to clear IPI delivery status for x2apic.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 3 ++-
>  arch/x86/kvm/x86.c   | 1 -
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 88929b1..f6d69e2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1942,7 +1942,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  	}
>  	case APIC_ICR:
>  		/* No delay here, so we always clear the pending bit */

'Always' in the comment above now reads a bit odd, I'd suggest modifying
it to 'Immediately clear Delivery Status field in xAPIC mode' - or just
drop it altogeter.

> -		val &= ~(1 << 12);
> +		if (!apic_x2apic_mode(apic))
> +			val &= ~(1 << 12);
>  		kvm_apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
>  		kvm_lapic_set_reg(apic, APIC_ICR, val);
>  		break;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 495709f..6ced0e1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1562,7 +1562,6 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>  		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
>  		((u32)(data >> 32) != X2APIC_BROADCAST)) {
>  
> -		data &= ~(1 << 12);
>  		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
>  		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
>  		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR, (u32)data);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

