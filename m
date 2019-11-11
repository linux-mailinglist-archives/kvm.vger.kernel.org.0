Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE50F75FF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKKOIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:08:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726915AbfKKOIV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 09:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573481299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ZU6bCvh91D91ZsafUUxbgJ1R77Uo1RQ7ISt3fpO3U3k=;
        b=JedRtw8FKYMcsMdVNdOEF0kzRR40SPunMQ60Ip+UQGzy/e7ImcaWJbWYRIekF+iPG4oBpK
        hOMdKikM/bZsP7J/JLQ/v9wNWX7poq7OfzDqi3SWrXESWL8ht6vgApamxb0Uu0MX9udY8B
        GS1X5/g/5bXHXWcWfYv8k6MF6JYOrxk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-2vdMXf67OzCdevmP2-8DFg-1; Mon, 11 Nov 2019 09:08:16 -0500
Received: by mail-wm1-f70.google.com with SMTP id y14so6892977wmj.9
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:08:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuFVmZT2ZpgS0RPM/o02vIuy7ZHIOMQH37/kEUM7XjI=;
        b=PYvEAc9W7rw2DkbtcTWaOMSjJiborFpoiCthNNuZpq6bFlEUpsL0UXvLbM3jD6RrEE
         Mx7CBUOcg9XfMbfDm0l+K8Ux32NXqsGNpauazCmF0Wh6As+HB93h0DVGGpbVRPaGjlaB
         y1i+dWm2XvBEYT07tBGz+rMiC9ablNAASXbqnjLKJTo81Nj/KdFPZXGORXovae50Yafi
         azK3zm4ANN0BE4mKY6bF4EBIseU8BHhMy08Ni8mKYDi4HkPgX4qvWwKzKQSjKJSpZaXh
         ggueoF287Rd2MtIczGHgDbwnBdUUnoDgqMzTlY7gRaGbXOMzzLxwtuWH695DbF25a+Qy
         4HHQ==
X-Gm-Message-State: APjAAAUcGGcBP/GhC2UJE1FOJ7pIPQnaYC/Ir56UzQUBPjA6m4jfjy4B
        p4Z4CntyJBAjEwVRTpHJ24rclZD9Ub0Qg3jZUnV8TO46xvsWjXoqsSj8OjlVh/z9a9LGfonbMTO
        uprDSz2z4Q82c
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr5271514wrr.287.1573481295104;
        Mon, 11 Nov 2019 06:08:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCOWNPEsvcNwwhsvu8Rceg3mTSMJ6db/8msnt7G0nYYed15bBJcXlyhj/vhLj0SUDNR7OHDA==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr5271498wrr.287.1573481294859;
        Mon, 11 Nov 2019 06:08:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id d13sm15611356wrq.51.2019.11.11.06.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:08:14 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: avoid unused setup_syscalls_segments call when
 SYSCALL check failed
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1573289934-14430-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <37dcc0bb-b624-4ea2-976a-51f5bfbd81a6@redhat.com>
Date:   Mon, 11 Nov 2019 15:08:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573289934-14430-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: 2vdMXf67OzCdevmP2-8DFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/19 09:58, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> When SYSCALL/SYSENTER ability check failed, cs and ss is inited but
> remain not used. Delay initializing cs and ss until SYSCALL/SYSENTER
> ability check passed.
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/emulate.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 698efb8c3897..952d1a4f4d7e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2770,11 +2770,10 @@ static int em_syscall(struct x86_emulate_ctxt *ct=
xt)
>  =09=09return emulate_ud(ctxt);
> =20
>  =09ops->get_msr(ctxt, MSR_EFER, &efer);
> -=09setup_syscalls_segments(ctxt, &cs, &ss);
> -
>  =09if (!(efer & EFER_SCE))
>  =09=09return emulate_ud(ctxt);
> =20
> +=09setup_syscalls_segments(ctxt, &cs, &ss);
>  =09ops->get_msr(ctxt, MSR_STAR, &msr_data);
>  =09msr_data >>=3D 32;
>  =09cs_sel =3D (u16)(msr_data & 0xfffc);
> @@ -2838,12 +2837,11 @@ static int em_sysenter(struct x86_emulate_ctxt *c=
txt)
>  =09if (ctxt->mode =3D=3D X86EMUL_MODE_PROT64)
>  =09=09return X86EMUL_UNHANDLEABLE;
> =20
> -=09setup_syscalls_segments(ctxt, &cs, &ss);
> -
>  =09ops->get_msr(ctxt, MSR_IA32_SYSENTER_CS, &msr_data);
>  =09if ((msr_data & 0xfffc) =3D=3D 0x0)
>  =09=09return emulate_gp(ctxt, 0);
> =20
> +=09setup_syscalls_segments(ctxt, &cs, &ss);
>  =09ctxt->eflags &=3D ~(X86_EFLAGS_VM | X86_EFLAGS_IF);
>  =09cs_sel =3D (u16)msr_data & ~SEGMENT_RPL_MASK;
>  =09ss_sel =3D cs_sel + 8;
>=20

Queued, thanks.

Paolo

