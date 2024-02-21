Return-Path: <kvm+bounces-9314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48ABA85E0C5
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBD311F26F40
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 15:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C298004C;
	Wed, 21 Feb 2024 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b="pwJRn3gW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.domeneshop.no (smtp.domeneshop.no [194.63.252.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86DBC158;
	Wed, 21 Feb 2024 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.63.252.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708528642; cv=none; b=e8Z25Bp4n+GeaW0NzxWZrr6Ge92I+Pen96ImAa7lfTe9j479hfb4dF4UP0vXMenvm1h/HkncR4HleRQhe8SFxoT3ImcGz/hr+6AvVkG1loY5MMASv+AXNKGsjfYcvJpmtSJd9+lQKhBWhT8CtpYyCI60jbAoz5WtbrXHKvyVth0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708528642; c=relaxed/simple;
	bh=agYNnPPCIH97KdPKC1Nh/AulnVyocy0+9HILSckMPjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsHyo6km/7A+2vcIn5fBiKyK2A65zaWQzqPJb+JTud+71PdVpLg1/hGbhh2PV+fcu8oTFIfx5SlR3LJJe4+cvMCveJeu4zk2DiUthivfVBjVYi7U269F6ArUceFPmVu5MudM5tzB/Me0LfQRtnOclpU6ljrL86/wx+bsF8smeiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu; spf=pass smtp.mailfrom=fjasle.eu; dkim=pass (2048-bit key) header.d=fjasle.eu header.i=@fjasle.eu header.b=pwJRn3gW; arc=none smtp.client-ip=194.63.252.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fjasle.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fjasle.eu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fjasle.eu;
	s=ds202307; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9oIgh7QORtk7teQwyM71RcR4VU3ANbMHY2WNi9H443M=; b=pwJRn3gWdD6aejhtap3HU+yeUl
	iQ2W4LQ5bMVhHqaYWVNmdws1Nb4FqB74C2m6mhbtFtNUApeOKIdhCvzqqaM4+Cph1TzjjZ5KOwm3L
	RZ0TW8amloLdHokN9UyYZ5OCt+/gioMZTT+oTZUE6A8DzgNaWsSh4YtDuz1lAcwosOWD6OnzLllXZ
	odwelyI6Ht4gfCVmbZTRnGutXlbfnxi0nzymmkee8VbaWOKeF5KIKyjZzzbJ3hpjRHd3ICuRQSDG9
	ilcBwKlqdlUD3TpK+t/ecNl6leBbZOSZfYqDhBAe9aDX5ZbbYj4xoJFDK5bFoKcoPvhzqk74EdfTZ
	W4CCsuDA==;
Received: from dynamic-176-000-161-131.176.0.pool.telefonica.de ([176.0.161.131]:27469 helo=bergen.fjasle.eu)
	by smtp.domeneshop.no with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <nicolas@fjasle.eu>)
	id 1rcoG6-00DNv3-WC;
	Wed, 21 Feb 2024 16:11:43 +0100
Date: Wed, 21 Feb 2024 16:11:36 +0100
From: Nicolas Schier <nicolas@fjasle.eu>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] kbuild: change tool coverage variables to take the
 path relative to $(obj)
Message-ID: <ZdYSqKnJqiiBnQHu@bergen.fjasle.eu>
References: <20240217055504.2059803-1-masahiroy@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5qX+0rpWSE2BInwC"
Content-Disposition: inline
In-Reply-To: <20240217055504.2059803-1-masahiroy@kernel.org>
X-Operating-System: Debian GNU/Linux trixie/sid
Jabber-ID: nicolas@jabber.no


--5qX+0rpWSE2BInwC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 17 Feb 2024 14:55:03 GMT, Masahiro Yamada wrote:
> Commit 54b8ae66ae1a ("kbuild: change *FLAGS_<basetarget>.o to take the
> path relative to $(obj)") changed the syntax of per-file compiler flags.
>=20
> The situation is the same for the following variables:
>=20
>   OBJECT_FILES_NON_STANDARD_<basetarget>.o
>   GCOV_PROFILE_<basetarget>.o
>   KASAN_SANITIZE_<basetarget>.o
>   KMSAN_SANITIZE_<basetarget>.o
>   KMSAN_ENABLE_CHECKS_<basetarget>.o
>   UBSAN_SANITIZE_<basetarget>.o
>   KCOV_INSTRUMENT_<basetarget>.o
>   KCSAN_SANITIZE_<basetarget>.o
>   KCSAN_INSTRUMENT_BARRIERS_<basetarget>.o
>=20
> The <basetarget> is the filename of the target with its directory and
> suffix stripped.
>=20
> This syntax comes into a trouble when two files with the same basename
> appear in one Makefile, for example:
>=20
>   obj-y +=3D dir1/foo.o
>   obj-y +=3D dir2/foo.o
>   OBJECT_FILES_NON_STANDARD_foo.o :=3D y
>=20
> OBJECT_FILES_NON_STANDARD_foo.o is applied to both dir1/foo.o and
> dir2/foo.o. This syntax is not flexbile enough to handle cases where
> one of them is a standard object, but the other is not.
>=20
> It is more sensible to use the relative path to the Makefile, like this:
>=20
>   obj-y +=3D dir1/foo.o
>   OBJECT_FILES_NON_STANDARD_dir1/foo.o :=3D y
>   obj-y +=3D dir2/foo.o
>   OBJECT_FILES_NON_STANDARD_dir2/foo.o :=3D y
>=20
> To maintain the current behavior, I made adjustments to two Makefiles:
>=20
>  - arch/x86/entry/vdso/Makefile, which compiles vclock_gettime.o and
>    vdso32/vclock_gettime.o
>=20
>  - arch/x86/kvm/Makefile, which compiles vmx/vmenter.o and svm/vmenter.o
>=20
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
>=20
>  arch/x86/entry/vdso/Makefile |  2 ++
>  arch/x86/kvm/Makefile        |  3 ++-
>  scripts/Makefile.build       |  2 +-
>  scripts/Makefile.lib         | 16 ++++++++--------
>  4 files changed, 13 insertions(+), 10 deletions(-)
>=20
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> index 7a97b17f28b7..148adfdb2325 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -9,7 +9,9 @@ include $(srctree)/lib/vdso/Makefile
>  # Sanitizer runtimes are unavailable and cannot be linked here.
>  KASAN_SANITIZE			:=3D n
>  KMSAN_SANITIZE_vclock_gettime.o :=3D n
> +KMSAN_SANITIZE_vdso32/vclock_gettime.o	:=3D n
>  KMSAN_SANITIZE_vgetcpu.o	:=3D n
> +KMSAN_SANITIZE_vdso32/vgetcpu.o	:=3D n
> =20
>  UBSAN_SANITIZE			:=3D n
>  KCSAN_SANITIZE			:=3D n
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 475b5fa917a6..a88bb14266b6 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -4,7 +4,8 @@ ccflags-y +=3D -I $(srctree)/arch/x86/kvm
>  ccflags-$(CONFIG_KVM_WERROR) +=3D -Werror
> =20
>  ifeq ($(CONFIG_FRAME_POINTER),y)
> -OBJECT_FILES_NON_STANDARD_vmenter.o :=3D y
> +OBJECT_FILES_NON_STANDARD_vmx/vmenter.o :=3D y
> +OBJECT_FILES_NON_STANDARD_svm/vmenter.o :=3D y
>  endif
> =20
>  include $(srctree)/virt/kvm/Makefile.kvm
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 4971f54c855e..256db2a0e984 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -214,7 +214,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
>  # 'OBJECT_FILES_NON_STANDARD_foo.o :=3D 'y': skip objtool checking for a=
 file
>  # 'OBJECT_FILES_NON_STANDARD_foo.o :=3D 'n': override directory skip for=
 a file
> =20
> -is-standard-object =3D $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD=
_$(basetarget).o)$(OBJECT_FILES_NON_STANDARD)n),y)
> +is-standard-object =3D $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD=
_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),y)
> =20
>  $(obj)/%.o: objtool-enabled =3D $(if $(is-standard-object),$(if $(delay-=
objtool),$(is-single-obj-m),y))
> =20
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index b35d39022a30..328c0d77ed48 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -154,7 +154,7 @@ _cpp_flags     =3D $(KBUILD_CPPFLAGS) $(cppflags-y) $=
(CPPFLAGS_$(target-stem).lds)
>  #
>  ifeq ($(CONFIG_GCOV_KERNEL),y)
>  _c_flags +=3D $(if $(patsubst n%,, \
> -		$(GCOV_PROFILE_$(basetarget).o)$(GCOV_PROFILE)$(CONFIG_GCOV_PROFILE_AL=
L)), \
> +		$(GCOV_PROFILE_$(target-stem).o)$(GCOV_PROFILE)$(CONFIG_GCOV_PROFILE_A=
LL)), \
>  		$(CFLAGS_GCOV))
>  endif
> =20
> @@ -165,29 +165,29 @@ endif
>  ifeq ($(CONFIG_KASAN),y)
>  ifneq ($(CONFIG_KASAN_HW_TAGS),y)
>  _c_flags +=3D $(if $(patsubst n%,, \
> -		$(KASAN_SANITIZE_$(basetarget).o)$(KASAN_SANITIZE)y), \
> +		$(KASAN_SANITIZE_$(target-stem).o)$(KASAN_SANITIZE)y), \
>  		$(CFLAGS_KASAN), $(CFLAGS_KASAN_NOSANITIZE))
>  endif
>  endif
> =20
>  ifeq ($(CONFIG_KMSAN),y)
>  _c_flags +=3D $(if $(patsubst n%,, \
> -		$(KMSAN_SANITIZE_$(basetarget).o)$(KMSAN_SANITIZE)y), \
> +		$(KMSAN_SANITIZE_$(target-stem).o)$(KMSAN_SANITIZE)y), \
>  		$(CFLAGS_KMSAN))
>  _c_flags +=3D $(if $(patsubst n%,, \
> -		$(KMSAN_ENABLE_CHECKS_$(basetarget).o)$(KMSAN_ENABLE_CHECKS)y), \
> +		$(KMSAN_ENABLE_CHECKS_$(target-stem).o)$(KMSAN_ENABLE_CHECKS)y), \
>  		, -mllvm -msan-disable-checks=3D1)
>  endif
> =20
>  ifeq ($(CONFIG_UBSAN),y)
>  _c_flags +=3D $(if $(patsubst n%,, \
> -		$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANIT=
IZE_ALL)), \
> +		$(UBSAN_SANITIZE_$(target-stem).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANI=
TIZE_ALL)), \
>  		$(CFLAGS_UBSAN))
>  endif
> =20
>  ifeq ($(CONFIG_KCOV),y)
>  _c_flags +=3D $(if $(patsubst n%,, \
> -	$(KCOV_INSTRUMENT_$(basetarget).o)$(KCOV_INSTRUMENT)$(CONFIG_KCOV_INSTR=
UMENT_ALL)), \
> +	$(KCOV_INSTRUMENT_$(target-stem).o)$(KCOV_INSTRUMENT)$(CONFIG_KCOV_INST=
RUMENT_ALL)), \
>  	$(CFLAGS_KCOV))
>  endif
> =20
> @@ -197,12 +197,12 @@ endif
>  #
>  ifeq ($(CONFIG_KCSAN),y)
>  _c_flags +=3D $(if $(patsubst n%,, \
> -	$(KCSAN_SANITIZE_$(basetarget).o)$(KCSAN_SANITIZE)y), \
> +	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)y), \
>  	$(CFLAGS_KCSAN))
>  # Some uninstrumented files provide implied barriers required to avoid f=
alse
>  # positives: set KCSAN_INSTRUMENT_BARRIERS for barrier instrumentation o=
nly.
>  _c_flags +=3D $(if $(patsubst n%,, \
> -	$(KCSAN_INSTRUMENT_BARRIERS_$(basetarget).o)$(KCSAN_INSTRUMENT_BARRIERS=
)n), \
> +	$(KCSAN_INSTRUMENT_BARRIERS_$(target-stem).o)$(KCSAN_INSTRUMENT_BARRIER=
S)n), \
>  	-D__KCSAN_INSTRUMENT_BARRIERS__)
>  endif
> =20
> --=20
> 2.40.1
>=20

Looks good to me!

Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>

--5qX+0rpWSE2BInwC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEh0E3p4c3JKeBvsLGB1IKcBYmEmkFAmXWEqMACgkQB1IKcBYm
Emmh5RAAsoH93ItGYSneI0D+OnqwrEyqw11ht+RFBPgQbdR3fN014CVhL5A9B1EG
1Qa5v+IiOzX5p4kykduJchoYFpuZKBcimTOsTLnhp/QL8vfdR1mmiVHaKg3hhjUi
NiEdFeeV2kWNzPf5jfIltmdiNTDyfR/nGiohEwgq+x9jq6uf05u/iPmFBgflw62o
nGR7xu2dyM0+OntMX7LoMeZ5uSjwWeRiBX0czE8aJjp4iOCgDHle/JS9k2VQCgeS
YPyyuRaSvKQg6arUFeYSGFjiN7fWw/WYVeDSkQPIUl/W7VzFfj0EfuIysN/b0Hzu
cV0jkEP720Ytd4nDIWVgea1H1hsElKTU3N7sk4CfhOkIlkrU+2ARIE0bwbHLt6mZ
I1HmPBBQoPlype+MwIzVP0YnRKjjDCoL0EecKL2mcGUY0W3g0lDbp2HXIeJ8rzt2
c5BlEOo1SeX4xC3yMYXcpIQGFl1x8u3/RuY5jqeCryvJxvSwSwPWrRF66VG2ldmS
3+ni4ydMpAd14E7cqnOqXpWr5k7Ygt3NLBN4RTYHkEmQgI2suPXxPS2AmzwL7hJm
dmF1MIi+Qu2muEgCLqp04SnzXG5oDscWrDWdkxd+n2FLBFLWgBcsdQc+ozfzm/i8
KtKHUMwHc4Xy2NDLthAciVxWbgf6UnRwuZhO4WPEEJ6Xb2pJyhQ=
=409f
-----END PGP SIGNATURE-----

--5qX+0rpWSE2BInwC--

