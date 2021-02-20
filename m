Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337EA320416
	for <lists+kvm@lfdr.de>; Sat, 20 Feb 2021 07:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBTGDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Feb 2021 01:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhBTGDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Feb 2021 01:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEA7564EE1
        for <kvm@vger.kernel.org>; Sat, 20 Feb 2021 06:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613800941;
        bh=ShcGVisZXSeMg1DM1Ug/ltlAeszRZetvwkkEgFVlNas=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YSQAOBZjx77Ns4trHoOsngxkQa38xVjltXBABkfbX425KuGX5umsxwyesIcw3M9m0
         E1CBeP+KT/7ktq3qJsK+8ztsAyUo1Y+szBDMXVBUy0LssKWNWODnxjYIHb7kwI0p/U
         OMtv1pX83FzJa09GTTmNeee7rrVKV5Rx57K2tgRQUkoBozsoihRJj5tAd3g/guoNFq
         6dYliAq0igKoimsq0gG8LbZNbMgmQ/dhvUaUHgPv0ypgHnSvTgIePgQyXuaLXydf1z
         grZ/lAFZ3Vje1rb1fjKjkE0NPbbhKxxJZc4dBaGoIP5s/mLVrydINYb/OD9SVtUKPj
         TNTNGsBRQIZHA==
Received: by mail-il1-f171.google.com with SMTP id e7so6359168ile.7
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 22:02:21 -0800 (PST)
X-Gm-Message-State: AOAM533L7sKmKN02HWgbw+Ni3bwQQaScvrdJqcI8ySyLlgfIRw5+RU7Z
        jqbqD1B6oQyqHxJvCfbdSr91T60VUe8pX+QftQA=
X-Google-Smtp-Source: ABdhPJyCLmvlLlMWilIXNLMyuqYrduB90HoBtfugKMuSdQ5Su7DwyI7kL8H7jWSAUPeMHbmo5K5tjSLHJRZ+MPDkFwE=
X-Received: by 2002:a92:6907:: with SMTP id e7mr6713495ilc.134.1613800941002;
 Fri, 19 Feb 2021 22:02:21 -0800 (PST)
MIME-Version: 1.0
References: <20210219173847.2054123-1-philmd@redhat.com> <20210219173847.2054123-6-philmd@redhat.com>
 <31a32613-2a61-7cd2-582a-4e6d10949436@flygoat.com>
In-Reply-To: <31a32613-2a61-7cd2-582a-4e6d10949436@flygoat.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 20 Feb 2021 14:02:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6TJyP8diBUu4EsSWSNrVP7YxxPaMNnm2uuZJfdGY40Jg@mail.gmail.com>
Message-ID: <CAAhV-H6TJyP8diBUu4EsSWSNrVP7YxxPaMNnm2uuZJfdGY40Jg@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] hw/mips: Restrict KVM to the malta & virt machines
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhuacai@kernel.org>

On Sat, Feb 20, 2021 at 12:56 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrot=
e:
>
> =E5=9C=A8 2021/2/20 =E4=B8=8A=E5=8D=881:38, Philippe Mathieu-Daud=C3=A9 =
=E5=86=99=E9=81=93:
> > Restrit KVM to the following MIPS machines:
> > - malta
> > - loongson3-virt
> >
> > Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
>
> Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>
> > ---
> >   hw/mips/loongson3_virt.c | 5 +++++
> >   hw/mips/malta.c          | 5 +++++
> >   2 files changed, 10 insertions(+)
> >
> > diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
> > index d4a82fa5367..c3679dff043 100644
> > --- a/hw/mips/loongson3_virt.c
> > +++ b/hw/mips/loongson3_virt.c
> > @@ -612,6 +612,10 @@ static void mips_loongson3_virt_init(MachineState =
*machine)
> >       loongson3_virt_devices_init(machine, liointc);
> >   }
> >
> > +static const char *const valid_accels[] =3D {
> > +    "tcg", "kvm", NULL
> > +};
> > +
> >   static void loongson3v_machine_class_init(ObjectClass *oc, void *data=
)
> >   {
> >       MachineClass *mc =3D MACHINE_CLASS(oc);
> > @@ -622,6 +626,7 @@ static void loongson3v_machine_class_init(ObjectCla=
ss *oc, void *data)
> >       mc->max_cpus =3D LOONGSON_MAX_VCPUS;
> >       mc->default_ram_id =3D "loongson3.highram";
> >       mc->default_ram_size =3D 1600 * MiB;
> > +    mc->valid_accelerators =3D valid_accels;
> >       mc->kvm_type =3D mips_kvm_type;
> >       mc->minimum_page_bits =3D 14;
> >   }
> > diff --git a/hw/mips/malta.c b/hw/mips/malta.c
> > index 9afc0b427bf..0212048dc63 100644
> > --- a/hw/mips/malta.c
> > +++ b/hw/mips/malta.c
> > @@ -1443,6 +1443,10 @@ static const TypeInfo mips_malta_device =3D {
> >       .instance_init =3D mips_malta_instance_init,
> >   };
> >
> > +static const char *const valid_accels[] =3D {
> > +    "tcg", "kvm", NULL
> > +};
> > +
> >   static void mips_malta_machine_init(MachineClass *mc)
> >   {
> >       mc->desc =3D "MIPS Malta Core LV";
> > @@ -1456,6 +1460,7 @@ static void mips_malta_machine_init(MachineClass =
*mc)
> >       mc->default_cpu_type =3D MIPS_CPU_TYPE_NAME("24Kf");
> >   #endif
> >       mc->default_ram_id =3D "mips_malta.ram";
> > +    mc->valid_accelerators =3D valid_accels;
> >   }
> >
> >   DEFINE_MACHINE("malta", mips_malta_machine_init)
>
