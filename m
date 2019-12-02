Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACEC10E785
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 10:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfLBJSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 04:18:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30489 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725977AbfLBJSJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 04:18:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575278288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=npff6qkaiVVRvv7tuPNtj+wwmibAXzAwdtk2EuB02Og=;
        b=jUXMj1oUq+jwkFGdvr4ALUCuZ2vxgAWTPwNlSMtyTaINS0Kf8C9djIJafsyfl/s9WrPnFe
        OshAfS1qgxrvSKGFzYiij42dqz0ey+STZlnaeCDx/ktBdpMqC0WnhZXE0tFG7FN9xfVicg
        zw4j969CJo2Ea4SHOi2aoTToJ+FeXao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-lA8_q7LCMLObSp0hasb-QA-1; Mon, 02 Dec 2019 04:18:05 -0500
Received: by mail-wr1-f71.google.com with SMTP id 90so16750340wrq.6
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 01:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R6aPR3UqicHf4GsiWrf0zN37cxh4xgoEfGHaIlgH6C0=;
        b=aUJgfroBwmWvSPlQf9fX1BMPkWv8ngCTHhXSOnqXAKO3j+ZQrsvgn2x9nqjZ6766mq
         2fC53yH8mjV58XyP4L1oiAHplEO9vdG0FTRTe4PcSKmVKzFgpqT5RzRDEXNjiKH9kTt9
         ZjYAUyP1hYEh2TGThLW5q5fi3METTuXKg3SbViX4Nci5Cvn2YCwlROHlP0StT5884+YF
         RegOwzsv2E53WmS6hnRN2ALAXKiOSknqGD9aj7tIR81klcuycSZfv9Nq7P7Vo+ebuI+Z
         9FSvwjxs3gEDdHzEiQSeiE99jQ3jGdQ6M4b7TlQgpOl4cbquR70P98LWBjLuxqX2QdwU
         4d/g==
X-Gm-Message-State: APjAAAUSAYvuiqEfG+ykMlMsahcl3t9TiQRCWj6zNrZIi8cZAI9m62U8
        qCCpwmurCNQTYCsim3SgwZ9r0KknCnmZR6YGHz4wA2mFWjcsa2vpj/D/XPYbpei7MoX09KCMKNx
        kxjLXXwVDQLH9
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr25285017wmj.58.1575278283803;
        Mon, 02 Dec 2019 01:18:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8JcZBBXm6dvSYhQNB14AMzV0OR34nUmyvp0qHHFqNiqcWeXkqzbmRcx4EvUNVoQ4Qfvpdbw==
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr25284991wmj.58.1575278283477;
        Mon, 02 Dec 2019 01:18:03 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t81sm23770468wmg.6.2019.12.02.01.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:18:02 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com
Subject: Re: [PATCH v2 3/3] KVM: X86: Fixup kvm_apic_match_dest() dest_mode parameter
In-Reply-To: <20191129163234.18902-4-peterx@redhat.com>
References: <20191129163234.18902-1-peterx@redhat.com> <20191129163234.18902-4-peterx@redhat.com>
Date:   Mon, 02 Dec 2019 10:18:00 +0100
Message-ID: <87mucbcchj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: lA8_q7LCMLObSp0hasb-QA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> The problem is the same as the previous patch on that we've got too
> many ways to define a dest_mode, but logically we should only pass in
> APIC_DEST_* macros for this helper.

Using 'the previous patch' in changelog is OK until it comes to
backporting as the order can change. I'd suggest to spell out "KVM: X86:
Use APIC_DEST_* macros properly" explicitly.

>
> To make it easier, simply define dest_mode of kvm_apic_match_dest() to
> be a boolean to make it right while we can avoid to touch the callers.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 5 +++--
>  arch/x86/kvm/lapic.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cf9177b4a07f..80732892c709 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -791,8 +791,9 @@ static u32 kvm_apic_mda(struct kvm_vcpu *vcpu, unsign=
ed int dest_id,
>  =09return dest_id;
>  }
> =20
> +/* Set dest_mode to true for logical mode, false for physical mode */
>  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source=
,
> -=09=09=09   int short_hand, unsigned int dest, int dest_mode)
> +=09=09=09   int short_hand, unsigned int dest, bool dest_mode)
>  {
>  =09struct kvm_lapic *target =3D vcpu->arch.apic;
>  =09u32 mda =3D kvm_apic_mda(vcpu, dest, source, target);
> @@ -800,7 +801,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struc=
t kvm_lapic *source,
>  =09ASSERT(target);
>  =09switch (short_hand) {
>  =09case APIC_DEST_NOSHORT:
> -=09=09if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
> +=09=09if (dest_mode =3D=3D false)

I must admit this seriously harm the readability of the code for
me. Just look at the=20

 if (dest_mode =3D=3D false)

line without a context and try to say what's being checked. I can't.

I see to solutions:
1) Adhere to the APIC_DEST_PHYSICAL/APIC_DEST_LOGICAL (basically - just
check against "dest_mode =3D=3D APIC_DEST_LOGICAL" in the else branch)
2) Rename the dest_mode parameter to 'dest_mode_is_phys' or something
like that.

>  =09=09=09return kvm_apic_match_physical_addr(target, mda);
>  =09=09else
>  =09=09=09return kvm_apic_match_logical_addr(target, mda);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 19b36196e2ff..c0b472ed87ad 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -82,7 +82,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg=
, u32 val);
>  int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  =09=09       void *data);
>  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source=
,
> -=09=09=09   int short_hand, unsigned int dest, int dest_mode);
> +=09=09=09   int short_hand, unsigned int dest, bool dest_mode);
>  int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2=
);
>  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  =09=09=09     struct kvm_lapic_irq *irq,

--=20
Vitaly

