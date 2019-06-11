Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E873C656
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 10:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404523AbfFKIqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 04:46:31 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43273 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391351AbfFKIqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 04:46:31 -0400
Received: by mail-ot1-f66.google.com with SMTP id i8so11078439oth.10;
        Tue, 11 Jun 2019 01:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ijkPdrXeX6Fz/gKpBalT5IMu3KLaHyuDjWll/dYwskM=;
        b=fB0y7JxUBu68bn1OlQLIjzj3t15wwwxRvu7xtdYcWM3dGPE4h4ru9X3vqTxVTM15uQ
         ZAYRALcEXp1mdW52i9AkRhaavQhOU7ToYp5INXoDBxuuB+pEZfF/Av2lhcO1CpdUSP4p
         7CV/k/CtOxT2/DpCkV2Wyep6H5TXnzSpQPrwogISHCqXkAnSskKzMXRSQ3gp56D//jSz
         0Av/YhyW3n59pinJ3t2zqlW6YGnQt9punzHDeVx1dYsDIm0BqS3OSqhaYLRW4UYNuHOg
         oek7a1Vt4N231WJhjjGwaHqBWFZscnfpUAZ8oWuD2yHQdikAv/6S00kh33PTQ2UZ0aVY
         yihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ijkPdrXeX6Fz/gKpBalT5IMu3KLaHyuDjWll/dYwskM=;
        b=EReUB5UapjsZ9tRIRen1RbHyRc47JCW05su/4Wc4LH/ZiOsWCTZih+ocWoRyh0hYuM
         kwMf7/krky1p+iByY5ISk9cfE7T7iNp6QYwn1S74L8AgQfgTLDIXFTSQaJt6PXkb6N7M
         00lhtpw9xP9ddKMUl4C3oLJeTmyh/1iyqZpSahh7NDwBfrx4vqNRLmWpNgKhZm0c2vPr
         0k7wyWvVHKS1u7EeDy4UM7r0alPZKbMPE4RNj+fsnnzylAbpYwUVFhOl/I/ISC4i5DlM
         I/Wz+fx8oFpn2f+jjxkOe0A5m9GHyihciOErbgx7Ke2HbT4K2KNo+vuTawRfFKJS0ogG
         2WEQ==
X-Gm-Message-State: APjAAAUuJkZreEDQCtraPYWkEjAOvzoa7OTCohzoilYDsjpe4MAV59wH
        /RlvDWsJ5D2u9wvKuNfgFr8dNfaxpV/OjJA+mzs=
X-Google-Smtp-Source: APXvYqywuI6wFgrsQGHTLB1NysIvC+a8HIsD9HjKbcDFdKVzCuluDb4Lm+flneSL9irfE4h4TgHTZz1eHxxTFYXr4G8=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr34287686otb.185.1560242790932;
 Tue, 11 Jun 2019 01:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <1559178307-6835-3-git-send-email-wanpengli@tencent.com> <20190610141717.GA6604@flask>
In-Reply-To: <20190610141717.GA6604@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 16:47:15 +0800
Message-ID: <CANRm+CyGZiEfWb4KaXU2LG1AMcFq+jmb6kfjnPkKeyG-zOQPAA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] KVM: X86: Implement PV sched yield hypercall
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jun 2019 at 22:17, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-05-30 09:05+0800, Wanpeng Li:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The target vCPUs are in runnable state after vcpu_kick and suitable
> > as a yield target. This patch implements the sched yield hypercall.
> >
> > 17% performance increasement of ebizzy benchmark can be observed in an
> > over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush
> > call-function IPI-many since call-function is not easy to be trigged
> > by userspace workload).
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > @@ -7172,6 +7172,28 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *=
vcpu)
> >       kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
> >  }
> >
> > +static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
> > +{
> > +     struct kvm_vcpu *target =3D NULL;
> > +     struct kvm_apic_map *map =3D NULL;
> > +
> > +     rcu_read_lock();
> > +     map =3D rcu_dereference(kvm->arch.apic_map);
> > +
> > +     if (unlikely(!map) || dest_id > map->max_apic_id)
> > +             goto out;
> > +
> > +     if (map->phys_map[dest_id]->vcpu) {
>
> This should check for map->phys_map[dest_id].

Yeah, make a mistake here.

>
> > +             target =3D map->phys_map[dest_id]->vcpu;
> > +             rcu_read_unlock();
> > +             kvm_vcpu_yield_to(target);
> > +     }
> > +
> > +out:
> > +     if (!target)
> > +             rcu_read_unlock();
>
> Also, I find the following logic clearer
>
>   {
>         struct kvm_vcpu *target =3D NULL;
>         struct kvm_apic_map *map;
>
>         rcu_read_lock();
>         map =3D rcu_dereference(kvm->arch.apic_map);
>
>         if (likely(map) && dest_id <=3D map->max_apic_id && map->phys_map=
[dest_id])
>                 target =3D map->phys_map[dest_id]->vcpu;
>
>         rcu_read_unlock();
>
>         if (target)
>                 kvm_vcpu_yield_to(target);
>   }

More better, thanks.

Regards,
Wanpeng Li
