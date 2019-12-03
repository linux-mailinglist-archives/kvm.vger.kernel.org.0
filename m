Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5086510FEB2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLCNXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:23:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50232 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726105AbfLCNXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 08:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575379431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TmDDmZX5Ejs1GQa9K66OcY7Gbn7kFUvZnowG15fIpkQ=;
        b=PYHHxmrEurr/iDj750ACoLdBxjVyheU6g1Lcz5SXnfQlg4CIeHaUIAJJCVFaw/VYKn28Bg
        qUE7khjZd8Xt6UQ/vPKnFxvmE7dDJ0wVUmxPe8BGvByM+HLbcbioLd+bOBjputDmyeq8S/
        FseEvtVfuXC3k6C+kmv21QyUKWmMrYw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-_TMqJRjqP4yedReiAzk0cg-1; Tue, 03 Dec 2019 08:23:50 -0500
Received: by mail-wr1-f70.google.com with SMTP id t3so1747190wrm.23
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:23:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4gF8jYWE7o2WymPCFFXK4BxIXszqCtc2FDr8FramSDg=;
        b=juO4jnHyEj2QgHiJJZiE/9AIJPDBkOK+3qeEZYlRDrHgftaq7rYlzVgue0u0mGj7Fk
         X63zBOpDRle7FqFo7F0swI5bAo1akLOUjTfg12a3bPkOMDFeQehFesKMLtxh3MvBpwK4
         1CmocZzBBa4QXuTcJowoxdjDRr35QM6u/ROGAtfBiyTTr+Uh8/dmSRNBdCRlmbgmeaPp
         VfiFOzkK43TOKyfvhE5Uk+pAbRFK0hHNcWWXhhI5Nv/boOZeXTDpbMTLiUcbhdbvHPV9
         xphaEYIw4r0/Tjo0HWAEWDKYGg/IUSG8D1KQA55PGBIYZSE3mtwctqCTZGsEdXU/I2+/
         mmtA==
X-Gm-Message-State: APjAAAV7lvvBSbqx8VqxC5PGoEYygWH7oxZ0GiT+knWIotSKnHwIbeid
        zY+5KtohX+6SV9DV9tWLxiLrP+VO6uco4+bB/AlTSxdIT8yeBKw78duj91HI+guXt9OmAb7EAKJ
        h095VtxQUSpIA
X-Received: by 2002:adf:bc4f:: with SMTP id a15mr5244028wrh.160.1575379428945;
        Tue, 03 Dec 2019 05:23:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzcX91ox4qhl6lD+EvEVZgeEbvemuCzJn3XWAm4KKpnHSVB5XVPtWF3yr9q+0zvxdnLWE38oQ==
X-Received: by 2002:adf:bc4f:: with SMTP id a15mr5244001wrh.160.1575379428714;
        Tue, 03 Dec 2019 05:23:48 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l17sm3463911wro.77.2019.12.03.05.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 05:23:47 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
In-Reply-To: <20191202201314.543-6-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com> <20191202201314.543-6-peterx@redhat.com>
Date:   Tue, 03 Dec 2019 14:23:47 +0100
Message-ID: <87r21lbl0c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: _TMqJRjqP4yedReiAzk0cg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> Callers of kvm_apic_match_dest() should always pass in APIC_DEST_*
> macros for either dest_mode and short_hand parameters.  Fix up all the
> callers of kvm_apic_match_dest() that are not following the rule.
>
> Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/ioapic.c   | 11 +++++++----
>  arch/x86/kvm/irq_comm.c |  3 ++-
>  2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 901d85237d1c..1082ca8d11e5 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -108,8 +108,9 @@ static void __rtc_irq_eoi_tracking_restore_one(struct=
 kvm_vcpu *vcpu)
>  =09union kvm_ioapic_redirect_entry *e;
> =20
>  =09e =3D &ioapic->redirtbl[RTC_GSI];
> -=09if (!kvm_apic_match_dest(vcpu, NULL, 0,=09e->fields.dest_id,
> -=09=09=09=09e->fields.dest_mode))
> +=09if (!kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> +=09=09=09=09 e->fields.dest_id,
> +=09=09=09=09 kvm_lapic_irq_dest_mode(e->fields.dest_mode)))
>  =09=09return;
> =20
>  =09new_val =3D kvm_apic_pending_eoi(vcpu, e->fields.vector);
> @@ -237,6 +238,7 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulo=
ng *ioapic_handled_vectors)
>  =09struct dest_map *dest_map =3D &ioapic->rtc_status.dest_map;
>  =09union kvm_ioapic_redirect_entry *e;
>  =09int index;
> +=09u16 dm;
> =20
>  =09spin_lock(&ioapic->lock);
> =20
> @@ -250,8 +252,9 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulo=
ng *ioapic_handled_vectors)
>  =09=09if (e->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG ||
>  =09=09    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) |=
|
>  =09=09    index =3D=3D RTC_GSI) {
> -=09=09=09if (kvm_apic_match_dest(vcpu, NULL, 0,
> -=09=09=09             e->fields.dest_id, e->fields.dest_mode) ||
> +=09=09=09dm =3D kvm_lapic_irq_dest_mode(e->fields.dest_mode);

Nit: you could've defined 'dm' right here in the block (after '{') but
in any case I'd suggest to stick to 'dest_mode' and not shorten it to
'dm' for consistency.

> +=09=09=09if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> +=09=09=09=09=09=09e->fields.dest_id, dm) ||
>  =09=09=09    kvm_apic_pending_eoi(vcpu, e->fields.vector))
>  =09=09=09=09__set_bit(e->fields.vector,
>  =09=09=09=09=09  ioapic_handled_vectors);
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 5f59e5ebdbed..e89c2160b39f 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -417,7 +417,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
> =20
>  =09=09=09kvm_set_msi_irq(vcpu->kvm, entry, &irq);
> =20
> -=09=09=09if (irq.level && kvm_apic_match_dest(vcpu, NULL, 0,
> +=09=09=09if (irq.level &&
> +=09=09=09    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>  =09=09=09=09=09=09irq.dest_id, irq.dest_mode))
>  =09=09=09=09__set_bit(irq.vector, ioapic_handled_vectors);
>  =09=09}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

