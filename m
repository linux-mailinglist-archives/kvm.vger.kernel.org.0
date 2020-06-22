Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359AF203D0B
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgFVQsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:48:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729519AbgFVQsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 12:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592844484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOeVX/Nmmhafg16NYOvc8EUfqW7AqnkiAPvBHza8Wys=;
        b=I7ephK6GXcHf8eWXoVjc/mnJCJ+zqtb8YGgdBBbWNPXp8ROKPStHwnoEXUV+XFO8mlctMC
        ZUBAh4HJAWywChQLr16kSq7zbOoaehR3zRZ6OzcQRPUqpqR5ZNwwR8at3GHYXlloU+cGa1
        2WTxTwx7hxmzFzVZCxBvjBj2VwjZTxc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-3joIunGvNyyp6mU43_Ux3A-1; Mon, 22 Jun 2020 12:47:59 -0400
X-MC-Unique: 3joIunGvNyyp6mU43_Ux3A-1
Received: by mail-wm1-f72.google.com with SMTP id b63so213006wme.1
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 09:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOeVX/Nmmhafg16NYOvc8EUfqW7AqnkiAPvBHza8Wys=;
        b=ek3Fiy9lo9uSBwMejJeH8UByfXPkvWjBaQJXrCkz60FoRBSuj844xFvk69xs9vlyrI
         eRyX1WYbN3xuiwSrzzE76JDgpm9dHUW2WXi8sEYWEkXhCHuNhFPny9m+G4NRpTlRtOE4
         dyl+Xm6Nhv6YPjRwFHnilGmS5Ff/qSQo66yUeNKPMLXJrAt32NBHrEFKu/ScgVR76YQj
         zPrG4f3fC2Cihn951U6a+nxLwwgO/z6RHS/xK4D7tuPon6BlVANf1jv2z4UptFHX1kUb
         Wj50EK34cFNAtbXH/aLwXd2eBfbm1bN93FHBgNcxVIHGYvwoFbtbvHo5nw4O0lv4pI31
         jdeg==
X-Gm-Message-State: AOAM533jy1O5jFnNK6xDn9B04pMc3ujwVzJkYYUsUpdRmj03E9pe0a7/
        xznPYiA+itsyJjtpudaC7at2GLcb9RS11VOTvhgK+GQ/+uV1j2RJnh5/vv555CLcSRDS5Pt2stE
        O+fMTxgVAkhUg
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr13001288wmm.156.1592844478704;
        Mon, 22 Jun 2020 09:47:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHLwyIASJ1NU8MCn0vyMb6gJ0n7NqOi3eUC+ZSx8IQnYJvHUsEt91e44yFMyg/Pc1Zq7UIrg==
X-Received: by 2002:a05:600c:d5:: with SMTP id u21mr13001265wmm.156.1592844478401;
        Mon, 22 Jun 2020 09:47:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id j14sm18864654wrs.75.2020.06.22.09.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 09:47:57 -0700 (PDT)
Subject: Re: [PATCH] kvm: lapic: fix broken vcpu hotplug
To:     Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, wanpengli@tencent.com
References: <20200622160830.426022-1-imammedo@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c00acf88-0655-686e-3b8c-7aad03791f20@redhat.com>
Date:   Mon, 22 Jun 2020 18:47:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622160830.426022-1-imammedo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 18:08, Igor Mammedov wrote:
> Guest fails to online hotplugged CPU with error
>   smpboot: do_boot_cpu failed(-1) to wakeup CPU#4
> 
> It's caused by the fact that kvm_apic_set_state(), which used to call
> recalculate_apic_map() unconditionally and pulled hotplugged CPU into
> apic map, is updating map conditionally [1] on state change which doesn't
> happen in this case and apic map update is skipped.
> 
> Note:
> new CPU during kvm_arch_vcpu_create() is not visible to
> kvm_recalculate_apic_map(), so all related update calls endup
> as NOP and only follow up kvm_apic_set_state() used to trigger map
> update that counted in hotplugged CPU.
> Fix issue by forcing unconditional update from kvm_apic_set_state(),
> like it used to be.
> 
> 1)
> Fixes: (4abaffce4d25a KVM: LAPIC: Recalculate apic map in batch)
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> PS:
> it's alternative to full revert of [1], I've posted earlier
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2205600.html
> so fii free to pick up whatever is better by now
> ---
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 34a7e0533dad..5696831d4005 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2556,6 +2556,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	int r;
>  
> +	apic->vcpu->kvm->arch.apic_map_dirty = true;
>  	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
>  	/* set SPIV separately to get count of SW disabled APICs right */
>  	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
> 

Queued, but it's better to set apic_map_dirty just before the call to
kvm_recalculate_apic_map, or you can have a variant of the race that you
pointed out.

Paolo

