Return-Path: <kvm+bounces-7380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7124A841172
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDAF5B22C95
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904023F9FC;
	Mon, 29 Jan 2024 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Cotx7+I0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A313F9DA;
	Mon, 29 Jan 2024 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706551139; cv=none; b=uzE32sVhDNGYbgnToh43AcQr0TF8PV3uwC/hf1kpT6lVq5dhsb940fru2TFoZTbaj3n0xAR4kly7E3WV9Jnc90p/PF7lTlbPDwpymHEocQCGtdeHSPzlOSJ3Xq/rVk/BchIg8RDIehupErUM/pKbCL4+ZzsOTuuZ1dpTMCtyGzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706551139; c=relaxed/simple;
	bh=brZXU+54yeeIyXk8P9EznYfF+mgwIvbQaMmnQXIIBt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXgt2h30MndcNiO6ooNtv+F0NHq1KQsG/Pc1aQmLFiGNQfAu0TAvNBcxHoMjxXzk4nZO8hJd0vYQxXYWm6ZyoSGmDXEX2V2s4PwGHfwIgPsBVwCymxI6vDkQuj7D1BbZyk7JtCyQhkZvf+dZ6QipS5njw6z20iRdK1JfxJe7seA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Cotx7+I0 reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 68C1140E00C5;
	Mon, 29 Jan 2024 17:58:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id i6QaokLd0hxR; Mon, 29 Jan 2024 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706551131; bh=haKRuQSPjwn4cZ6Nd5ze9P3MYIvIFCO4ld+rTiW5Nok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cotx7+I0f/7Gt9x7NWnbs/g0LaIwF6oRcwW5rTcKXCC9xkME6wAfqHrTzkkgOup7A
	 kDUNDxWsdDds1nDmCKD58UhsVntsZo4C1fKrPqXjaY9dqRt+Z9cIJeFDdI9mLbgpKZ
	 s4qgfyCwegiOe+c95T55T+0LMrvWz73oQGMlt6hhTINLQ9u87OV1BBkzI+s3UAMQki
	 EiE6/lwoUIQamQYxuGWU4v8uXNZLA5BzheYMPr+4XA6EAJG+cTumWaule7SYdQzd3X
	 CjbsbDw4O+fCxHaSfXhPPQWWT4oCT5B2SRv3OUnqAXhk8gefpEDl39LkU1ErXglmpz
	 IihJRAoHAdwcNdjWr/KPPnqwegCBx27/RNuUlxQ340dn5QvkqTNFfTdKgGO9WwNUR1
	 aoYa+eaWqChUqSSrv+g/QxeICCyfZaIicFzzOIjUmKN7xRw4Wal7qz4dNYTfEzOT4q
	 q968O/clmAVLn5qoGPNuD3WoaQS/ESk1uAeK2GLknMWm+Rh+HIO8KvXhrRTwibbd0/
	 rzkAqbvj5HS19afzr2rnkbYCCU/HRthEyYW3mpHBsK7JwXgWzu1WEjqZzR5jK15Yt8
	 mtoc0sk0JJii4l6Roz1lSmr79VPsu/i8lclUem/bo+LBSd+mlVZtNyFzNat27QDPzs
	 SNsPorfagbq1htmTG2J6pDaM=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A6D1940E016C;
	Mon, 29 Jan 2024 17:58:12 +0000 (UTC)
Date: Mon, 29 Jan 2024 18:58:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v2 13/25] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <20240129175806.GBZbfnLsqTgqoKwt0S@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-14-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126041126.1927228-14-michael.roth@amd.com>
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 10:11:13PM -0600, Michael Roth wrote:
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 006e4cdbeb78..8128de17f0f4 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -790,10 +790,23 @@ struct sev_data_snp_shutdown_ex {
> =20
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
> =20
> +/**
> + * struct sev_platform_init_args
> + *
> + * @error: SEV firmware error code
> + * @probe: True if this is being called as part of CCP module probe, w=
hich
> + *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until need=
ed
> + *  unless psp_init_on_probe module param is set
> + */
> +struct sev_platform_init_args {
> +	int error;
> +	bool probe;
> +};

This struct definition cannot be under the ifdef, otherwise:

arch/x86/kvm/svm/sev.c: In function =E2=80=98sev_guest_init=E2=80=99:
arch/x86/kvm/svm/sev.c:267:33: error: passing argument 1 of =E2=80=98sev_=
platform_init=E2=80=99 from incompatible pointer type [-Werror=3Dincompat=
ible-pointer-types]
  267 |         ret =3D sev_platform_init(&init_args);
      |                                 ^~~~~~~~~~
      |                                 |
      |                                 struct sev_platform_init_args *
In file included from arch/x86/kvm/svm/sev.c:16:
./include/linux/psp-sev.h:952:42: note: expected =E2=80=98int *=E2=80=99 =
but argument is of type =E2=80=98struct sev_platform_init_args *=E2=80=99
  952 | static inline int sev_platform_init(int *error) { return -ENODEV;=
 }
      |                                     ~~~~~^~~~~
cc1: all warnings being treated as errors

---

on a 32-bit allmodconfig.

Build fix:

---

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index beba10d6b39c..d0e184db9d37 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -797,8 +797,6 @@ struct sev_data_snp_commit {
 	u32 len;
 } __packed;
=20
-#ifdef CONFIG_CRYPTO_DEV_SP_PSP
-
 /**
  * struct sev_platform_init_args
  *
@@ -812,6 +810,8 @@ struct sev_platform_init_args {
 	bool probe;
 };
=20
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+
 /**
  * sev_platform_init - perform SEV INIT command
  *
@@ -949,7 +949,7 @@ void snp_free_firmware_page(void *addr);
 static inline int
 sev_platform_status(struct sev_user_data_status *status, int *error) { r=
eturn -ENODEV; }
=20
-static inline int sev_platform_init(int *error) { return -ENODEV; }
+static inline int sev_platform_init(struct sev_platform_init_args *args)=
 { return -ENODEV; }
=20
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { ret=
urn -ENODEV; }

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

