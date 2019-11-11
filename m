Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC00CF82AF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 22:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKKV7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 16:59:15 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbfKKV7O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 16:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573509552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Dv3tL26S75qLplpwlQkK/M39pNZmA8SWBDOfblTZaPg=;
        b=QluwttFnChEiVpbFI4W4aag3eN8OoKzbukGSXc5EMgnAX2WQEPUmkL5R9BdnP5h6e2kBqA
        LG95aktsrABRKbSNNBL3/43r/mAGbvkcTWa/6xqAdkZyqYBfNLvgqpNTVSzR530AM2k1lY
        7bytZ1MSFm9lwKSE6dz6zl1qJWtn7Jw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-zBDxlhA4Moa8m1RkQIW9rg-1; Mon, 11 Nov 2019 16:59:10 -0500
Received: by mail-wm1-f69.google.com with SMTP id k184so382899wmk.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 13:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kgtgivx2zAVXI5UqZGPzy7//8r39vIWbbMzuVwc8b0o=;
        b=luonMZN4OHZ4hmiMt2ySS5wHzowEqyTTuReMfRi1vUA3E4tBd+ucLCXJb5UyCB5S1x
         isock/F6+HbxEIBJn8FDWDJk+NXjPhK8ZHXpDs4rGaqwJU3ZIQQ6p120mj+0Y+Xe5zfZ
         NYmPbsaLFQD7X6UrcQ6Kgs0jGahahhDtrLmtuk8W1WzSrLQWsB4sqLcYGrdXZtFBK6Ou
         KaKNC+pjLbRtwFyulJ2a3Vwm25ZNFdycMLKT/w9ga4dG+sakqUN1xnch1cPneqqAJZm4
         SYr9U4PUOUAzRPOGiwXQxfcmjv3x2PWU5RqouvNLjD2+p8sTa+bj1ChKGTuW3CX1VfJN
         zhMw==
X-Gm-Message-State: APjAAAWB/pwmgW1h+ONNBpgT8KRC2qGvAr0pELzUUp/0UaSlvVk2IzD9
        cEIjDPnU4/WNEPjc8sAxEprBZ5h9h/MU4QtPofpoAK1qS3mN+Q7+E3d8ZPPwY5ldcH6VZxrwHLS
        d+mdeiLrSkkur
X-Received: by 2002:a7b:c75a:: with SMTP id w26mr968846wmk.18.1573509549050;
        Mon, 11 Nov 2019 13:59:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqz22JeNQtGSm9nK+srQ2j8r1EnfyfKb82TJSQPtql+aTFEfvGasSkCh4jkf9Q+cEaS43ApF4g==
X-Received: by 2002:a7b:c75a:: with SMTP id w26mr968821wmk.18.1573509548741;
        Mon, 11 Nov 2019 13:59:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id z6sm21332075wro.18.2019.11.11.13.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 13:59:08 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: LAPIC: micro-optimize fixed mode ipi delivery
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
 <1573283135-5502-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7a526814-c44e-c188-fba4-c6fb97b88b71@redhat.com>
Date:   Mon, 11 Nov 2019 22:59:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573283135-5502-2-git-send-email-wanpengli@tencent.com>
Content-Language: en-US
X-MC-Unique: zBDxlhA4Moa8m1RkQIW9rg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/19 08:05, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
>=20
> After disabling mwait/halt/pause vmexits, RESCHEDULE_VECTOR and
> CALL_FUNCTION_SINGLE_VECTOR etc IPI is one of the main remaining
> cause of vmexits observed in product environment which can't be
> optimized by PV IPIs. This patch is the follow-up on commit
> 0e6d242eccdb (KVM: LAPIC: Micro optimize IPI latency), to optimize
> redundancy logic before fixed mode ipi is delivered in the fast
> path.
>=20
> - broadcast handling needs to go slow path, so the delivery mode repair
>   can be delayed to before slow path.

I agree with this part, but is the cost of the irq->shorthand check
really measurable?

Paolo

> - self-IPI will not be intervened by hypervisor any more after APICv is
>   introduced and the boxes support APICv are popular now. In addition,
>   kvm_apic_map_get_dest_lapic() can handle the self-IPI, so there is no
>   need a shortcut for the non-APICv case.
>=20
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/irq_comm.c | 6 +++---
>  arch/x86/kvm/lapic.c    | 5 -----
>  2 files changed, 3 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8ecd48d..aa88156 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -52,15 +52,15 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct =
kvm_lapic *src,
>  =09unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
>  =09unsigned int dest_vcpus =3D 0;
> =20
> +=09if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
> +=09=09return r;
> +
>  =09if (irq->dest_mode =3D=3D 0 && irq->dest_id =3D=3D 0xff &&
>  =09=09=09kvm_lowest_prio_delivery(irq)) {
>  =09=09printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
>  =09=09irq->delivery_mode =3D APIC_DM_FIXED;
>  =09}
> =20
> -=09if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
> -=09=09return r;
> -
>  =09memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
> =20
>  =09kvm_for_each_vcpu(i, vcpu, kvm) {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index b29d00b..ea936fa 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -951,11 +951,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, =
struct kvm_lapic *src,
> =20
>  =09*r =3D -1;
> =20
> -=09if (irq->shorthand =3D=3D APIC_DEST_SELF) {
> -=09=09*r =3D kvm_apic_set_irq(src->vcpu, irq, dest_map);
> -=09=09return true;
> -=09}
> -
>  =09rcu_read_lock();
>  =09map =3D rcu_dereference(kvm->arch.apic_map);
> =20
>=20

