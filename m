Return-Path: <kvm+bounces-34001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B67E9F59DC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 958FD188F822
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 22:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408A81F9A98;
	Tue, 17 Dec 2024 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xL2+mjJi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4D71D86F6
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 22:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734475922; cv=none; b=rz8lkHInI30os2RJQu+nM+CCzt6H6FT/jwZ2vsYOy7dNDny1o7MxG8gMY9u7liQnz7Ev83UcCOSeOf0pe0B1M7Fuwd7PXZclW3Hr0R1cNcpx9x6JzlWshowibGDuIJj1lqAXNRfJe3OaMNV82X+dikX7xH8SCoghJNKYBXpdb6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734475922; c=relaxed/simple;
	bh=+eyhKNJumZs6/FTEwOn6NrjFWtzki3e9oRxmhRQgX1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u2p9/L/rklcG3QxjSPJxhehVqaUXYQBHvLLSi/s6c+PbMUwaxa9GUUVZ+0qE2shPzNycb5lchEwtUe8usPezJjtEsTMiz8wiK8HW/Q6R7RCYLhK37qHfSjQw1/z2zPqcnYvT6JaYrWtGFV8R/WV9T0n0FSlk3uvGSx5kcPXt8u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xL2+mjJi; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so1175367966b.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734475919; x=1735080719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IVYL3s9CILTnwogTJZ1OTIZuv0ARpRPo5KpbFGa6KD8=;
        b=xL2+mjJi2YQwtSt4Yapr/JgbFLX9aECv5HMoMBmOG3xvVfDIIG2n1gK9XrKlBpxpwH
         90qjWwizqyRFAJt7176MCmN+5YBUGI9TshVBz5kTtoE4n+SlB2UMYosMkaGt4FWl4Nvi
         eh3eZ5nJxmuiIHN5QUW/zxuZNq+YmuWuZ8OSYMZbZIez3nFgs0cL2hbBHcyBs2MV9XEf
         HL/+vJmEYft9P0hCn2BiLUOgWTgQygby9ZeOuB9W4/Xtmx6a9aFMTWOVXYN9caaPcdy0
         JaXuEZsKQbHPykEDA3JPV/snigAlHVRryUzMOaOWqzd4OOeAOIGB9ZobUFgKJDHLrkLG
         iW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734475919; x=1735080719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVYL3s9CILTnwogTJZ1OTIZuv0ARpRPo5KpbFGa6KD8=;
        b=awU815Qbt15eaw7GAfKGWy7VnmfVEKjUqoh7TemKRqoYrbCYECLAqnn6ZWFLwMb/65
         QZnsrdXalzUqT5T7Zfsr9THgTWHIyeaQu1Tz/A42BWDJrFScLzqoc5Bl8ww/FWawjYxU
         tDJHFYHEN0mqxpKW4Zpkv06ZsAfFaHdWQ46AIIOLWRofCJgKeRnyvpri7mkgbp3RdxdI
         9lNmGGQHCwJrFgyYut8dO2UB8tenHoCi/BtDv0NjJ95k4av9POxg6oBcg7DKBxokMFzr
         exiVY5kKd/f76XSFVxAgVPLYk6fRycaGbmyN6XUyB4oM0F6t5rJQZvM/U3kXm6jotT7R
         SSKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO6UeRazbYv2/sh/to+fDYAlNNhNwdDnldUw9od6IcKzCCVSWOw+EsThT7LfSD2mridmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxItH2ghSAkP8eDc+vDFDp7M6Dy/57I9Ky6yi477864pjddyGzA
	nZ/WOoqGwndfJz4Z8VnlxYfZomzkbQdbZoWpGfI1RWl7yT+vBMeYc0mBv2Cu71ZEvvshBLPy2tm
	arTbG9DKceO4p7DeZOpC38cmKLAmHJ2kqKhh4
X-Gm-Gg: ASbGncvrFg6ozuu7OKUwvHCz58XCOf48qFsA97tcQRC3cOOpvECcnzFyubWkCWdZ1Z9
	NH1ESzmcr/PEyOH4fO+2EztRN+uxvItMUTofsYg==
X-Google-Smtp-Source: AGHT+IH1GTjImrAaApRrEGDhHMKaiEFNxqjHCuhUD4o38YaFXBS8IA8KoPJRL636fi9mhowUw350/nmafoSV7nTEPLA=
X-Received: by 2002:a17:907:72cb:b0:aa6:8a1b:8b74 with SMTP id
 a640c23a62f3a-aabf4920960mr39223766b.53.1734475918650; Tue, 17 Dec 2024
 14:51:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
In-Reply-To: <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 17 Dec 2024 14:51:47 -0800
X-Gm-Features: AbW1kvaHDgTDS8JrAFaBs3expr5K210DWpQNsbnGYLLnTtGnZ9fPc2iUNyA1dYg
Message-ID: <CAAH4kHai4mqmY6CB3Ybk6JxD7M=OX44k0S=2n_h_F4mVSVco6w@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] crypto: ccp: Register SNP panic notifier only if
 SNP is enabled
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2024 at 3:58=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Register the SNP panic notifier if and only if SNP is actually
> initialized and deregistering the notifier when shutting down
> SNP in PSP driver when KVM module is unloaded.
>
> Currently the SNP panic notifier is being registered
> irrespective of SNP being enabled/initialized and with this
> change the SNP panic notifier is registered only if SNP
> support is enabled and initialized.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9632a9a5c92e..7c15dec55f58 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +                                unsigned long reason, void *arg);
> +
> +static struct notifier_block snp_panic_notifier =3D {
> +       .notifier_call =3D snp_shutdown_on_panic,
> +};
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
> @@ -1191,6 +1198,9 @@ static int __sev_snp_init_locked(int *error)
>         dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major=
,
>                  sev->api_minor, sev->build);
>
> +       atomic_notifier_chain_register(&panic_notifier_list,
> +                                      &snp_panic_notifier);
> +
>         sev_es_tmr_size =3D SNP_TMR_SIZE;
>
>         return 0;
> @@ -1751,6 +1761,9 @@ static int __sev_snp_shutdown_locked(int *error, bo=
ol panic)
>         sev->snp_initialized =3D false;
>         dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>
> +       atomic_notifier_chain_unregister(&panic_notifier_list,
> +                                        &snp_panic_notifier);
> +
>         /* Reset TMR size back to default */
>         sev_es_tmr_size =3D SEV_TMR_SIZE;
>
> @@ -2490,10 +2503,6 @@ static int snp_shutdown_on_panic(struct notifier_b=
lock *nb,
>         return NOTIFY_DONE;
>  }
>
> -static struct notifier_block snp_panic_notifier =3D {
> -       .notifier_call =3D snp_shutdown_on_panic,
> -};
> -
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>                                 void *data, int *error)
>  {
> @@ -2542,8 +2551,6 @@ void sev_pci_init(void)
>         dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initial=
ized ?
>                 "-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>
> -       atomic_notifier_chain_register(&panic_notifier_list,
> -                                      &snp_panic_notifier);
>         return;
>
>  err:
> @@ -2561,6 +2568,4 @@ void sev_pci_exit(void)
>
>         sev_firmware_shutdown(sev);
>
> -       atomic_notifier_chain_unregister(&panic_notifier_list,
> -                                        &snp_panic_notifier);
>  }
> --
> 2.34.1
>

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

