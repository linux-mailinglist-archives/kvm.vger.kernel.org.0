Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2D227DA4
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 12:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgGUKvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 06:51:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54114 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgGUKvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 06:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6x8b72+BAW2ZS/XopVU/cZY9GZgo98jcuFZvHSf6+o=;
        b=YdJR7nRowqhlkSwTfFkWMsN3V8JsLXyjjaQKfZi7TrA+uLSo9ClyDNPnx5CVW3w9UDWj1h
        rgjc3Y1BKvSIb2Qr8Y2bek7YwQc0/pvCHOSx2I3vKKlah1hL5SVbDf/iDRkUPrX3O4mtQm
        AkX4AXS/KJXCvFRQIO1CmhViLb9wz/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-RlBZoqwQOde0oEDCL2YgBQ-1; Tue, 21 Jul 2020 06:51:45 -0400
X-MC-Unique: RlBZoqwQOde0oEDCL2YgBQ-1
Received: by mail-wm1-f71.google.com with SMTP id g138so850502wme.7
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 03:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P6x8b72+BAW2ZS/XopVU/cZY9GZgo98jcuFZvHSf6+o=;
        b=SI4zqSOFcgYDgRpTlVw8TQlekZhmrS2PNDCcssfqWJaVW3KCPESjWLU3DB4q2F+tzc
         5+7jDGHTEAS88VRHCJrQMgY2wW9gARtiSZRnw0EQR0Yv1BwzeTVhAs8UiDEvM75zgcvE
         JDhZijN1aThA++I5hc80AOIF8kGR1Rvv6mGnqzIKEO2kbtNUFAowJyN9W2CIK+2GlKXc
         /l49fyDmnEtXYAC5o3LNQ06xQ1GukO+X1t2SNSZ1uoIFPrmR7/1J73zQnbEPjEaxflJK
         4HZXdvMwtYeqh7fXtibLv6z1J59M0lZRyTVZBuPPh/c8RvI1cwjmalBQUgzhg1omo8gy
         QUMw==
X-Gm-Message-State: AOAM530YvoTNo3qQJWTKB3ENbLUu3maE43z3jRevU07xv452lZRLaa/3
        hLltNeiTt0vehVcJfdRNP8eCBoWFU6nNtEOy8lis/130TlWtQTL4xqERu9s0l0xiDHSx3wn4uYB
        zgiec+V5SfNZ9
X-Received: by 2002:adf:dcd0:: with SMTP id x16mr25096962wrm.387.1595328704342;
        Tue, 21 Jul 2020 03:51:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQgZF+XCKusjoWPe1LCm/gSDD1TOc5ZvNM9iscgHiaS1vURkLDx0+jURLsYeYugXZ84y29ZA==
X-Received: by 2002:adf:dcd0:: with SMTP id x16mr25096947wrm.387.1595328704168;
        Tue, 21 Jul 2020 03:51:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 65sm43820717wre.6.2020.07.21.03.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:51:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 2/2] KVM: LAPIC: Set the TDCR settable bits
In-Reply-To: <1595323468-4380-2-git-send-email-wanpengli@tencent.com>
References: <1595323468-4380-1-git-send-email-wanpengli@tencent.com> <1595323468-4380-2-git-send-email-wanpengli@tencent.com>
Date:   Tue, 21 Jul 2020 12:51:42 +0200
Message-ID: <87lfjdp2dd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Only bits 0, 1, and 3 are settable, others are reserved for APIC_TDCR. 
> Let's record the settable value in the virtual apic page.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4ce2ddd..8f7a14d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2068,7 +2068,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  	case APIC_TDCR: {
>  		uint32_t old_divisor = apic->divide_count;
>  
> -		kvm_lapic_set_reg(apic, APIC_TDCR, val);
> +		kvm_lapic_set_reg(apic, APIC_TDCR, val & 0xb);
>  		update_divide_count(apic);
>  		if (apic->divide_count != old_divisor &&
>  				apic->lapic_timer.period) {

AFAIU bit 2 should be 0 and other upper bits are reserved. Checking on
bare hardware,

# wrmsr 0x83e 0xb
# rdmsr 0x83e
b
# wrmsr 0x83e 0xc
wrmsr: CPU 0 cannot set MSR 0x0000083e to 0x000000000000000c
# rdmsr 0x83e
b

Shouldn't we fail the write in case (val & ~0xb) ?

-- 
Vitaly

