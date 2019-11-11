Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720C1F7604
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKKOKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:10:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726877AbfKKOKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 09:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573481421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7ZBq9QSoT6FgXPfyPjV1GwdjDqGwpRv6nD2/9NQqjcE=;
        b=cq6C+ag+Iegk4OuXM9OwrJKLCVzr65q+fTP+b2/OlCSZv9y3H1AdE8AuO1OGn9C77iwd2U
        Roff18Y5Qcs81sUNMf82D/85/IOTAQREmghivjE8epIGeS5XLroojS1eK3bU+6kp1FNXIb
        TukL85YI+iKZ5oYKqyVh7NgRHa3NFTY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-TLsge69OMb2cJFSGrv9Tgw-1; Mon, 11 Nov 2019 09:10:20 -0500
Received: by mail-wr1-f72.google.com with SMTP id e3so9961148wrs.17
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:10:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tgoqYA+8hwe2zTcbHs/UJukx3h3GolwfCf5nsCXxKIE=;
        b=Z6z6wXB2Qlz5iHCzKJT5Y32EFxoE50XpgPyMRW+75E1VuqamPVtGspp/LXKFMeNjI2
         3Korp3Xis+iSdUwj3hWY5f2NhkVFZmOH5AjAdQFhooqN4nMDT2J/fRV4eyo4OQ3WXx3u
         2n5dr7s17tAPMhitb2hopG8z6VzLeLBO8mVb/c1jQKeaKp3bL4BuOqCwdtFxlArYTKHw
         9UrlM2mHri9Ausy4nO+77LHm+2RejDt8FqmAKR4ZoLSW160YSPBgEQcgqykRa5R68iXW
         epEN/aBnYz+13jF/c/hdipOppTB0pedqXt/KdIWU/pHI49+rNdPOjnHroyAPuhtLnH6W
         E9Hg==
X-Gm-Message-State: APjAAAXe9FG7hGT5pPzvgHbMhUO09oOEB1fUiKu7G4miWwjtbhsuPhQL
        yZQ/oRJfQ/ZpItdv/zTRfC2GpLLUkRJ+cgW3Bd96fWJkRPQQUs4QIgtLeZwjZqhy6a2+IloZzTi
        CiGIsz3OyUGsQ
X-Received: by 2002:a7b:c4c8:: with SMTP id g8mr19087753wmk.36.1573481418631;
        Mon, 11 Nov 2019 06:10:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqz32fok14gHNpnDfuiKRmJvdPzPxLe4MT2ZPhzOi5DUpChQhCSbqVGGAxAdbGlR8erjPXlPug==
X-Received: by 2002:a7b:c4c8:: with SMTP id g8mr19087734wmk.36.1573481418327;
        Mon, 11 Nov 2019 06:10:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id q15sm7201581wrs.91.2019.11.11.06.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:10:17 -0800 (PST)
Subject: Re: [PATCH] KVM: APIC: add helper func to remove duplicate code in
 kvm_pv_send_ipi
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1573292809-18181-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <afcc4015-13f1-61d3-7ab8-e24f2b9c0ea8@redhat.com>
Date:   Mon, 11 Nov 2019 15:10:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573292809-18181-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: TLsge69OMb2cJFSGrv9Tgw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/19 10:46, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> There are some duplicate code in kvm_pv_send_ipi when deal with ipi
> bitmap. Add helper func to remove it, and eliminate odd out label,
> get rid of unnecessary kvm_lapic_irq field init and so on.
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/lapic.c | 65 ++++++++++++++++++++------------------------
>  1 file changed, 29 insertions(+), 36 deletions(-)
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index b29d00b661ff..2f8f10103f5f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -557,60 +557,53 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct =
kvm_lapic_irq *irq,
>  =09=09=09irq->level, irq->trig_mode, dest_map);
>  }
> =20
> +static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map =
*map,
> +=09=09=09 struct kvm_lapic_irq *irq, u32 min)
> +{
> +=09int i, count =3D 0;
> +=09struct kvm_vcpu *vcpu;
> +
> +=09if (min > map->max_apic_id)
> +=09=09return 0;
> +
> +=09for_each_set_bit(i, ipi_bitmap,
> +=09=09min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
> +=09=09if (map->phys_map[min + i]) {
> +=09=09=09vcpu =3D map->phys_map[min + i]->vcpu;
> +=09=09=09count +=3D kvm_apic_set_irq(vcpu, irq, NULL);
> +=09=09}
> +=09}
> +
> +=09return count;
> +}
> +
>  int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  =09=09    unsigned long ipi_bitmap_high, u32 min,
>  =09=09    unsigned long icr, int op_64_bit)
>  {
> -=09int i;
>  =09struct kvm_apic_map *map;
> -=09struct kvm_vcpu *vcpu;
>  =09struct kvm_lapic_irq irq =3D {0};
>  =09int cluster_size =3D op_64_bit ? 64 : 32;
> -=09int count =3D 0;
> +=09int count;
> +
> +=09if (icr & (APIC_DEST_MASK | APIC_SHORT_MASK))
> +=09=09return -KVM_EINVAL;
> =20
>  =09irq.vector =3D icr & APIC_VECTOR_MASK;
>  =09irq.delivery_mode =3D icr & APIC_MODE_MASK;
>  =09irq.level =3D (icr & APIC_INT_ASSERT) !=3D 0;
>  =09irq.trig_mode =3D icr & APIC_INT_LEVELTRIG;
> =20
> -=09if (icr & APIC_DEST_MASK)
> -=09=09return -KVM_EINVAL;
> -=09if (icr & APIC_SHORT_MASK)
> -=09=09return -KVM_EINVAL;
> -
>  =09rcu_read_lock();
>  =09map =3D rcu_dereference(kvm->arch.apic_map);
> =20
> -=09if (unlikely(!map)) {
> -=09=09count =3D -EOPNOTSUPP;
> -=09=09goto out;
> +=09count =3D -EOPNOTSUPP;
> +=09if (likely(map)) {
> +=09=09count =3D __pv_send_ipi(&ipi_bitmap_low, map, &irq, min);
> +=09=09min +=3D cluster_size;
> +=09=09count +=3D __pv_send_ipi(&ipi_bitmap_high, map, &irq, min);
>  =09}
> =20
> -=09if (min > map->max_apic_id)
> -=09=09goto out;
> -=09/* Bits above cluster_size are masked in the caller.  */
> -=09for_each_set_bit(i, &ipi_bitmap_low,
> -=09=09min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
> -=09=09if (map->phys_map[min + i]) {
> -=09=09=09vcpu =3D map->phys_map[min + i]->vcpu;
> -=09=09=09count +=3D kvm_apic_set_irq(vcpu, &irq, NULL);
> -=09=09}
> -=09}
> -
> -=09min +=3D cluster_size;
> -
> -=09if (min > map->max_apic_id)
> -=09=09goto out;
> -
> -=09for_each_set_bit(i, &ipi_bitmap_high,
> -=09=09min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
> -=09=09if (map->phys_map[min + i]) {
> -=09=09=09vcpu =3D map->phys_map[min + i]->vcpu;
> -=09=09=09count +=3D kvm_apic_set_irq(vcpu, &irq, NULL);
> -=09=09}
> -=09}
> -
> -out:
>  =09rcu_read_unlock();
>  =09return count;
>  }
>=20

Queued, thanks.

Paolo

