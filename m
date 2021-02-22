Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150E53210A0
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 07:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBVGAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 01:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBVGAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 01:00:36 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E45C061574
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 21:59:56 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DkWjj1HJCz9sVV; Mon, 22 Feb 2021 16:59:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1613973593;
        bh=AY6wvTF45hDdtk/1CpIGS2xL+8YeDQJOtv+n0NJmFCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pkel7UI59661cPEq42sFwtAV/SW8gIGlw3cy8clzRcKqMZD3D76DkRZALGDvH+8T1
         ucjxSwyzImOVTBraSk+bhxS1gZoSaCLUo6erCzTbY8KW5tyjfr0YLFUow8U6xq9lTD
         KFkZAMzgAJg9jmzoQESAqP2yYaujBccgSFqP8TkA=
Date:   Mon, 22 Feb 2021 16:59:30 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?iso-8859-1?Q?Herv=E9?= Poussineau <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [RFC PATCH v2 06/11] hw/ppc: Restrict KVM to various PPC machines
Message-ID: <YDNIQiHG0nfKXNR8@yekko.fritz.box>
References: <20210219173847.2054123-1-philmd@redhat.com>
 <20210219173847.2054123-7-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ItpTtSJa605u8HWx"
Content-Disposition: inline
In-Reply-To: <20210219173847.2054123-7-philmd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ItpTtSJa605u8HWx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 19, 2021 at 06:38:42PM +0100, Philippe Mathieu-Daud=E9 wrote:
> Restrit KVM to the following PPC machines:
> - 40p
> - bamboo
> - g3beige
> - mac99
> - mpc8544ds
> - ppce500
> - pseries
> - sam460ex
> - virtex-ml507

Hrm.

The reason this list is kind of surprising is because there are 3
different "flavours" of KVM on ppc: KVM HV ("pseries" only), KVM PR
(almost any combination, theoretically, but kind of buggy in
practice), and the Book E specific KVM (Book-E systems with HV
extensions only).

But basically, qemu explicitly managing what accelerators are
available for each machine seems the wrong way around to me.  The
approach we've generally taken is that qemu requests the specific
features it needs of KVM, and KVM tells us whether it can supply those
or not (which may involve selecting between one of the several
flavours).

That way we can extend KVM to cover more situations without needing
corresponding changes in qemu every time.


> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
> ---
> RFC: I'm surprise by this list, but this is the result of
>      auditing calls to kvm_enabled() checks.
>=20
>  hw/ppc/e500plat.c      | 5 +++++
>  hw/ppc/mac_newworld.c  | 6 ++++++
>  hw/ppc/mac_oldworld.c  | 5 +++++
>  hw/ppc/mpc8544ds.c     | 5 +++++
>  hw/ppc/ppc440_bamboo.c | 5 +++++
>  hw/ppc/prep.c          | 5 +++++
>  hw/ppc/sam460ex.c      | 5 +++++
>  hw/ppc/spapr.c         | 5 +++++
>  8 files changed, 41 insertions(+)
>=20
> diff --git a/hw/ppc/e500plat.c b/hw/ppc/e500plat.c
> index bddd5e7c48f..9701dbc2231 100644
> --- a/hw/ppc/e500plat.c
> +++ b/hw/ppc/e500plat.c
> @@ -67,6 +67,10 @@ HotplugHandler *e500plat_machine_get_hotpug_handler(Ma=
chineState *machine,
> =20
>  #define TYPE_E500PLAT_MACHINE  MACHINE_TYPE_NAME("ppce500")
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void e500plat_machine_class_init(ObjectClass *oc, void *data)
>  {
>      PPCE500MachineClass *pmc =3D PPCE500_MACHINE_CLASS(oc);
> @@ -98,6 +102,7 @@ static void e500plat_machine_class_init(ObjectClass *o=
c, void *data)
>      mc->max_cpus =3D 32;
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("e500v2_v30");
>      mc->default_ram_id =3D "mpc8544ds.ram";
> +    mc->valid_accelerators =3D valid_accels;
>      machine_class_allow_dynamic_sysbus_dev(mc, TYPE_ETSEC_COMMON);
>   }
> =20
> diff --git a/hw/ppc/mac_newworld.c b/hw/ppc/mac_newworld.c
> index e991db4addb..634f5ad19a0 100644
> --- a/hw/ppc/mac_newworld.c
> +++ b/hw/ppc/mac_newworld.c
> @@ -578,6 +578,11 @@ static char *core99_fw_dev_path(FWPathProvider *p, B=
usState *bus,
> =20
>      return NULL;
>  }
> +
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static int core99_kvm_type(MachineState *machine, const char *arg)
>  {
>      /* Always force PR KVM */
> @@ -595,6 +600,7 @@ static void core99_machine_class_init(ObjectClass *oc=
, void *data)
>      mc->max_cpus =3D MAX_CPUS;
>      mc->default_boot_order =3D "cd";
>      mc->default_display =3D "std";
> +    mc->valid_accelerators =3D valid_accels;
>      mc->kvm_type =3D core99_kvm_type;
>  #ifdef TARGET_PPC64
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("970fx_v3.1");
> diff --git a/hw/ppc/mac_oldworld.c b/hw/ppc/mac_oldworld.c
> index 44ee99be886..2c58f73b589 100644
> --- a/hw/ppc/mac_oldworld.c
> +++ b/hw/ppc/mac_oldworld.c
> @@ -424,6 +424,10 @@ static char *heathrow_fw_dev_path(FWPathProvider *p,=
 BusState *bus,
>      return NULL;
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static int heathrow_kvm_type(MachineState *machine, const char *arg)
>  {
>      /* Always force PR KVM */
> @@ -444,6 +448,7 @@ static void heathrow_class_init(ObjectClass *oc, void=
 *data)
>  #endif
>      /* TOFIX "cad" when Mac floppy is implemented */
>      mc->default_boot_order =3D "cd";
> +    mc->valid_accelerators =3D valid_accels;
>      mc->kvm_type =3D heathrow_kvm_type;
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("750_v3.1");
>      mc->default_display =3D "std";
> diff --git a/hw/ppc/mpc8544ds.c b/hw/ppc/mpc8544ds.c
> index 81177505f02..92b0e926c1b 100644
> --- a/hw/ppc/mpc8544ds.c
> +++ b/hw/ppc/mpc8544ds.c
> @@ -36,6 +36,10 @@ static void mpc8544ds_init(MachineState *machine)
>      ppce500_init(machine);
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void e500plat_machine_class_init(ObjectClass *oc, void *data)
>  {
>      MachineClass *mc =3D MACHINE_CLASS(oc);
> @@ -56,6 +60,7 @@ static void e500plat_machine_class_init(ObjectClass *oc=
, void *data)
>      mc->max_cpus =3D 15;
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("e500v2_v30");
>      mc->default_ram_id =3D "mpc8544ds.ram";
> +    mc->valid_accelerators =3D valid_accels;
>  }
> =20
>  #define TYPE_MPC8544DS_MACHINE  MACHINE_TYPE_NAME("mpc8544ds")
> diff --git a/hw/ppc/ppc440_bamboo.c b/hw/ppc/ppc440_bamboo.c
> index b156bcb9990..02501f489e4 100644
> --- a/hw/ppc/ppc440_bamboo.c
> +++ b/hw/ppc/ppc440_bamboo.c
> @@ -298,12 +298,17 @@ static void bamboo_init(MachineState *machine)
>      }
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void bamboo_machine_init(MachineClass *mc)
>  {
>      mc->desc =3D "bamboo";
>      mc->init =3D bamboo_init;
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("440epb");
>      mc->default_ram_id =3D "ppc4xx.sdram";
> +    mc->valid_accelerators =3D valid_accels;
>  }
> =20
>  DEFINE_MACHINE("bamboo", bamboo_machine_init)
> diff --git a/hw/ppc/prep.c b/hw/ppc/prep.c
> index 7e72f6e4a9b..90d884b0883 100644
> --- a/hw/ppc/prep.c
> +++ b/hw/ppc/prep.c
> @@ -431,6 +431,10 @@ static void ibm_40p_init(MachineState *machine)
>      }
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void ibm_40p_machine_init(MachineClass *mc)
>  {
>      mc->desc =3D "IBM RS/6000 7020 (40p)",
> @@ -441,6 +445,7 @@ static void ibm_40p_machine_init(MachineClass *mc)
>      mc->default_boot_order =3D "c";
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("604");
>      mc->default_display =3D "std";
> +    mc->valid_accelerators =3D valid_accels;
>  }
> =20
>  DEFINE_MACHINE("40p", ibm_40p_machine_init)
> diff --git a/hw/ppc/sam460ex.c b/hw/ppc/sam460ex.c
> index e459b43065b..79adb3352f0 100644
> --- a/hw/ppc/sam460ex.c
> +++ b/hw/ppc/sam460ex.c
> @@ -506,6 +506,10 @@ static void sam460ex_init(MachineState *machine)
>      boot_info->entry =3D entry;
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void sam460ex_machine_init(MachineClass *mc)
>  {
>      mc->desc =3D "aCube Sam460ex";
> @@ -513,6 +517,7 @@ static void sam460ex_machine_init(MachineClass *mc)
>      mc->default_cpu_type =3D POWERPC_CPU_TYPE_NAME("460exb");
>      mc->default_ram_size =3D 512 * MiB;
>      mc->default_ram_id =3D "ppc4xx.sdram";
> +    mc->valid_accelerators =3D valid_accels;
>  }
> =20
>  DEFINE_MACHINE("sam460ex", sam460ex_machine_init)
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 85fe65f8947..c5f985f0187 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -4397,6 +4397,10 @@ static void spapr_cpu_exec_exit(PPCVirtualHypervis=
or *vhyp, PowerPCCPU *cpu)
>      }
>  }
> =20
> +static const char *const valid_accels[] =3D {
> +    "tcg", "kvm", NULL
> +};
> +
>  static void spapr_machine_class_init(ObjectClass *oc, void *data)
>  {
>      MachineClass *mc =3D MACHINE_CLASS(oc);
> @@ -4426,6 +4430,7 @@ static void spapr_machine_class_init(ObjectClass *o=
c, void *data)
>      mc->default_ram_size =3D 512 * MiB;
>      mc->default_ram_id =3D "ppc_spapr.ram";
>      mc->default_display =3D "std";
> +    mc->valid_accelerators =3D valid_accels;
>      mc->kvm_type =3D spapr_kvm_type;
>      machine_class_allow_dynamic_sysbus_dev(mc, TYPE_SPAPR_PCI_HOST_BRIDG=
E);
>      mc->pci_allow_0_address =3D true;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ItpTtSJa605u8HWx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAzSEIACgkQbDjKyiDZ
s5KQOw//YS94mBUeu/EPKaGiexiH4d4Orn932aJsK8KfT2d6JHky9L3Z55oFSk8A
r13ZUkzrZFuUfpX1s138QN61Y7aCkK6JgxY7jl8Uj6jOJP6Vk26lnXiVim8r94n2
ouAsoi9TDVxDD5Ewxwmr+PHD/s9f3lvWpjVCvI0V1mHIfDrEyMIzM+Il4PeBkxgO
bmakSOE25jouYGjY1uf1Bx2/BZkU2o7J6n0yaD8M/ZpUVxgBFF0av8b0ZTqP66dc
CDw//dCygGegCNohXuTW5rYh+FSy9FMkxsQqHtn/aiJoUQJvbydRueNszc1N1W6D
aYSbkhX77ZU1wSGJbBDkGeyMhsRkwi9VJdG8fRAXRkYCutRbKKU+zIs1oAty8l5J
E8I5GwxVprM5G1tujmCuBw8D4yXmlBrSksNkka01UjErfoQIutrMbmhGu6LtXyi2
VCz18YUvhrI+6xgJQPMiOHasOQmoEUq/6KHmWlp39nj6MoiOUZXpMBOVyQqkHEKN
ZuQZe5RJKv2X3fu2laxX4MjShgBmhqKUCzqAcYzQDPHpU/f82tO+f3a08+6m2y32
b0KtPw8ojvPHflgCgTjWbug7byXAit1ZCjFkX4Sen3TMV6FFoKheh29Dlujn08xR
9oQ98yWtCnc7xQ0fj1vTSsdjvf8PlVkoQucMqa1ShpAVr3zRV6c=
=unpI
-----END PGP SIGNATURE-----

--ItpTtSJa605u8HWx--
