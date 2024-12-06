Return-Path: <kvm+bounces-33210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A41739E6FB2
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 14:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F762285151
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 13:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9826020C47C;
	Fri,  6 Dec 2024 13:57:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DA0207DF9
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 13:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733493464; cv=none; b=im1fBajowGvPFzpSp2NiDO152MnmlGjD4wBI5LevNPkEvX9+ISCxQ3Z5dSKyzwP/5VtUJtC2Y2GUFVK5DCOOHyhdEh8LAf130j7gqh5rIImU3xImXK+HoCz5EppZBT5j1v1vl3w2We+Fn6wBdE3BDcFt5J8awER/CI9gE2hVolM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733493464; c=relaxed/simple;
	bh=BnaE+B3sx+ftJBkruhBvPWxADTb1r6NsNkI4huFjUB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=HHh2UC9RktwsqZgK6wVI4Kx3Lfs+Q1vr5ewOewYyEcdTsgBv0X34aaS1zA2weFddXdCS5S5ejPJCPuBhvmnMQEA/47ppD+4P27DkNTdkGSDl6s1WZbPHF0TTXF6//dBsibFk+t1JUeHlwkJZydcyI29KBYwT+iqyUHVj56imw9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-167-EZHAcN5-Mh68KJfFcc05EQ-1; Fri, 06 Dec 2024 13:57:39 +0000
X-MC-Unique: EZHAcN5-Mh68KJfFcc05EQ-1
X-Mimecast-MFC-AGG-ID: EZHAcN5-Mh68KJfFcc05EQ
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 6 Dec
 2024 13:56:53 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 6 Dec 2024 13:56:53 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Arnd Bergmann' <arnd@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Linus
 Torvalds" <torvalds@linux-foundation.org>, Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Sean Christopherson
	<seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Thread-Topic: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Thread-Index: AQHbRjg+4x576lYtVEaZjwt66lpA/LLZPZ8Q
Date: Fri, 6 Dec 2024 13:56:53 +0000
Message-ID: <0163dae8b39b48c2b3ab9e26ed7279bc@AcuMS.aculab.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
In-Reply-To: <20241204103042.1904639-10-arnd@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Oa7AdZk9nyh4auYisHaE24KJUgMFOKGNAPcISJPhI9g_1733493458
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Arnd Bergmann
> Sent: 04 December 2024 10:31
> Building an x86-64 kernel with CONFIG_GENERIC_CPU is documented to
> run on all CPUs, but the Makefile does not actually pass an -march=3D
> argument, instead relying on the default that was used to configure
> the toolchain.
>=20
> In many cases, gcc will be configured to -march=3Dx86-64 or -march=3Dk8
> for maximum compatibility, but in other cases a distribution default
> may be either raised to a more recent ISA, or set to -march=3Dnative
> to build for the CPU used for compilation. This still works in the
> case of building a custom kernel for the local machine.
>=20
> The point where it breaks down is building a kernel for another
> machine that is older the the default target. Changing the default
> to -march=3Dx86-64 would make it work reliable, but possibly produce
> worse code on distros that intentionally default to a newer ISA.
>=20
> To allow reliably building a kernel for either the oldest x86-64
> CPUs or a more recent level, add three separate options for
> v1, v2 and v3 of the architecture as defined by gcc and clang
> and make them all turn on CONFIG_GENERIC_CPU. Based on this it
> should be possible to change runtime feature detection into
> build-time detection for things like cmpxchg16b, or possibly
> gate features that are only available on older architectures.
>=20
> Link: https://lists.llvm.org/pipermail/llvm-dev/2020-July/143289.html
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/x86/Kconfig.cpu | 39 ++++++++++++++++++++++++++++++++++-----
>  arch/x86/Makefile    |  6 ++++++
>  2 files changed, 40 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index 139db904e564..1461a739237b 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -260,7 +260,7 @@ endchoice
>  choice
>  =09prompt "x86-64 Processor family"
>  =09depends on X86_64
> -=09default GENERIC_CPU
> +=09default X86_64_V2
>  =09help
>  =09  This is the processor type of your CPU. This information is
>  =09  used for optimizing purposes. In order to compile a kernel
> @@ -314,15 +314,44 @@ config MSILVERMONT
>  =09  early Atom CPUs based on the Bonnell microarchitecture,
>  =09  such as Atom 230/330, D4xx/D5xx, D2xxx, N2xxx or Z2xxx.
>=20
> -config GENERIC_CPU
> -=09bool "Generic-x86-64"
> +config X86_64_V1
> +=09bool "Generic x86-64"
>  =09depends on X86_64
>  =09help
> -=09  Generic x86-64 CPU.
> -=09  Run equally well on all x86-64 CPUs.
> +=09  Generic x86-64-v1 CPU.
> +=09  Run equally well on all x86-64 CPUs, including early Pentium-4
> +=09  variants lacking the sahf and cmpxchg16b instructions as well
> +=09  as the AMD K8 and Intel Core 2 lacking popcnt.

The 'equally well' text was clearly always wrong (equally badly?)
but is now just 'plain wrong'.
Perhaps:
=09Runs on all x86-64 CPUs including early cpu that lack the sahf,
=09cmpxchg16b and popcnt instructions.

Then for V2 (or whatever it gets called)
=09Requires support for the sahf, cmpxchg16b and popcnt instructions.
=09This will not run on AMD K8 or Intel before Sandy bridge.

I think someone suggested that run-time detect of AVX/AVX2/AVX512
is fine?

=09David

> +
> +config X86_64_V2
> +=09bool "Generic x86-64 v2"
> +=09depends on X86_64
> +=09help
> +=09  Generic x86-64-v2 CPU.
> +=09  Run equally well on all x86-64 CPUs that meet the x86-64-v2
> +=09  definition as well as those that only miss the optional
> +=09  SSE3/SSSE3/SSE4.1 portions.
> +=09  Examples of this include Intel Nehalem and Silvermont,
> +=09  AMD Bulldozer (K10) and Jaguar as well as VIA Nano that
> +=09  include popcnt, cmpxchg16b and sahf.
> +
> +config X86_64_V3
> +=09bool "Generic x86-64 v3"
> +=09depends on X86_64
> +=09help
> +=09  Generic x86-64-v3 CPU.
> +=09  Run equally well on all x86-64 CPUs that meet the x86-64-v3
> +=09  definition as well as those that only miss the optional
> +=09  AVX/AVX2 portions.
> +=09  Examples of this include the Intel Haswell and AMD Excavator
> +=09  microarchitectures that include the bmi1/bmi2, lzncnt, movbe
> +=09  and xsave instruction set extensions.
>=20
>  endchoice
>=20
> +config GENERIC_CPU
> +=09def_bool X86_64_V1 || X86_64_V2 || X86_64_V3
> +
>  config X86_GENERIC
>  =09bool "Generic x86 support"
>  =09depends on X86_32
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 05887ae282f5..1fdc3fc6a54e 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -183,6 +183,9 @@ else
>          cflags-$(CONFIG_MPSC)=09=09+=3D -march=3Dnocona
>          cflags-$(CONFIG_MCORE2)=09=09+=3D -march=3Dcore2
>          cflags-$(CONFIG_MSILVERMONT)=09+=3D -march=3Dsilvermont
> +        cflags-$(CONFIG_MX86_64_V1)=09+=3D -march=3Dx86-64
> +        cflags-$(CONFIG_MX86_64_V2)=09+=3D $(call cc-option,-march=3Dx86=
-64-v2,-march=3Dx86-64)
> +        cflags-$(CONFIG_MX86_64_V3)=09+=3D $(call cc-option,-march=3Dx86=
-64-v3,-march=3Dx86-64)
>          cflags-$(CONFIG_GENERIC_CPU)=09+=3D -mtune=3Dgeneric
>          KBUILD_CFLAGS +=3D $(cflags-y)
>=20
> @@ -190,6 +193,9 @@ else
>          rustflags-$(CONFIG_MPSC)=09+=3D -Ctarget-cpu=3Dnocona
>          rustflags-$(CONFIG_MCORE2)=09+=3D -Ctarget-cpu=3Dcore2
>          rustflags-$(CONFIG_MSILVERMONT)=09+=3D -Ctarget-cpu=3Dsilvermont
> +        rustflags-$(CONFIG_MX86_64_V1)=09+=3D -Ctarget-cpu=3Dx86-64
> +        rustflags-$(CONFIG_MX86_64_V2)=09+=3D -Ctarget-cpu=3Dx86-64-v2
> +        rustflags-$(CONFIG_MX86_64_V3)=09+=3D -Ctarget-cpu=3Dx86-64-v3
>          rustflags-$(CONFIG_GENERIC_CPU)=09+=3D -Ztune-cpu=3Dgeneric
>          KBUILD_RUSTFLAGS +=3D $(rustflags-y)
>=20
> --
> 2.39.5
>=20

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


