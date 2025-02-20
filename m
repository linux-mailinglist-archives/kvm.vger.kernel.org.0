Return-Path: <kvm+bounces-38724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E200EA3E136
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 798D7189CCC5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 16:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537EF212FA5;
	Thu, 20 Feb 2025 16:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vQRxiUfY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11877212B02
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740069887; cv=none; b=OpkO6A2ZUgpjPLVj1Hnb8XF1PUgzu0TQNPnFnnC2/OrDcAhDlisHaTDyWEwYg3u7hUpE9XgQakwol6VCAk6hfpD6VoXhMwLp2vXc+3IvFAXTlMFmzFLLdegwaRyevzrng5hSKzahYCNSonU+Mw1VcCzDsQzUkvRAVKfH9LWfElg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740069887; c=relaxed/simple;
	bh=9r0fYvX+zlp9IaR/Iw7NohIQaBQqp8BA2iLfsSq9B+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OI1jJpbBNtL4WB5oFADLZgtxxscrsiHctENIntjF1S/SaVczs8AZ/cuxG3dWUXziyiCUcSfWN+eGk0lV2dfp22hlXzZXHIDnv8dlHBdx450cLpiPQRWzdImuIXUgUjLQ7N0MQmD9gMKTQO+CZiTp2Hp6CxpYaCThHWiBhJYgoqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vQRxiUfY; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5ded368fcd9so1730075a12.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 08:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740069882; x=1740674682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtI+UqG4NWO8Dncx/I8qs5z9r1CXuicTbpGR8fFxBTU=;
        b=vQRxiUfY4Dd0m4Oe7cqEMD8NOW+ybTCdc1rak9G4D9fIgl9gaPkyEjeduagwg/Z1lF
         IqbfAMmSvUzGNndpUTZlgKN8y5I9jORQTa0ZG8EAK7ElnF3kfAuEqxHJwcPunkUkcsXw
         Rb8mRUmhM7sRcTRi316EMtyZ+7YkIRJPHJ/al6hMkXMrJLhZUYTJGVl05fnGe61Y3CbD
         ixbmKTGx39fOsNETfFZty+edrnyD4HjGssPQG/Czi3icOmooA9XCI32wrzFb6xgcKXUH
         2XKUhGuue9BDZJjjOCq7B+Z1qhDp89P1n4kOzt1zTcUqnvhHeUpwrpC/4zsPbkLWyDh0
         YzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740069882; x=1740674682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtI+UqG4NWO8Dncx/I8qs5z9r1CXuicTbpGR8fFxBTU=;
        b=g/RiGHf0eKBOmizhEJZQKNhzzTbUYCnJzzMeaocr5AAXQvTNTvNbFIcy7/Fk5SqAJ3
         H4ePehDY12FazRufiKqeiW8/te+jFTEO/lxLfaGpc8se1WpRrNvryROONaPWjC+TRHiI
         y3nzyqS+6uGnKLsciqfkrGa/8qdm/Ix667eyOxfIk2EFO+sxRCOBxQI6nYlxL42I+hbh
         GIvnYGBZK9xvPzP5n/KUOlmcHqqtmwF3Crm3eCOPy+C/MkYF4Gr8yepoQyA9JwyJR3pS
         J/WhSN9Mk3q4nq6T8HYU/uMKLyuxKwvwvktFn/+Uddgq0K60TrGu01LmKuEeLcQwELo/
         67Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUrPjSzb6qTLIKr7C5syDSUHiER6TTj3UsAFKHtVdmr/xFE56b3QNS1AR9TApwHeW0lQ5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YytK0qsM6JR2ax85x7QdzU3JbyKhNH/HEzrCO0hYEpNXu29QgSr
	NkB7KLOOHHES2P0CidqpSS3Ad3euu4Hab4qYcwSypheFWy0Rx2yu0QnAcqbDcZ00xWdYxigv46k
	9MES7TYLWcjduUCUOKKT/j9H1XH3NrhKbrZDp
X-Gm-Gg: ASbGncsEqwGaM75vR0LOhfaUHlmnU63n3zYnbni+jUomQPQ40VrJwSdTuVGSd7DRTCR
	7WFMLmNnfD2rnj49opUlelCVwMmMI9gWAcupeq6FxHKSOtbNdOboMNKApgxLKPUQgmGla39+h
X-Google-Smtp-Source: AGHT+IG7AdiVY1G/TEK1pQrSvIh0n8nrZpdHC90LgKATvuCLj5ANZlaQ719DVlcDviDP0WAhINjce8I/k/BpFTR0Tcs=
X-Received: by 2002:a17:906:f5a3:b0:ab7:eead:57f2 with SMTP id
 a640c23a62f3a-abbcd0bafefmr908617066b.48.1740069882149; Thu, 20 Feb 2025
 08:44:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739997129.git.ashish.kalra@amd.com> <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
In-Reply-To: <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 20 Feb 2025 08:44:30 -0800
X-Gm-Features: AWEUYZm9TkBuiHGbmzSU9NGqTHcsQxo-1HeiZfqfYQzZqJyKatjDtVnyv2y94_U
Message-ID: <CAAH4kHab8rvWCPX2x8cvv6Dm+uhZQxpJgwrrn2GAKzn8sqS9Kg@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, michael.roth@amd.com, nikunj@amd.com, 
	ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, 
	aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2025 at 12:53=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com=
> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Modify the behavior of implicit SEV initialization in some of the
> SEV ioctls to do both SEV initialization and shutdown and add
> implicit SNP initialization and shutdown to some of the SNP ioctls
> so that the change of SEV/SNP platform initialization not being
> done during PSP driver probe time does not break userspace tools
> such as sevtool, etc.
>
> Prior to this patch, SEV has always been initialized before these
> ioctls as SEV initialization is done as part of PSP module probe,
> but now with SEV initialization being moved to KVM module load instead
> of PSP driver probe, the implied SEV INIT actually makes sense and gets
> used and additionally to maintain SEV platform state consistency
> before and after the ioctl SEV shutdown needs to be done after the
> firmware call.
>
> It is important to do SEV Shutdown here with the SEV/SNP initialization
> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
> followed with SEV Shutdown will cause SEV to remain in INIT state and
> then a future SNP INIT in KVM module load will fail.
>
> Similarly, prior to this patch, SNP has always been initialized before
> these ioctls as SNP initialization is done as part of PSP module probe,
> therefore, to keep a consistent behavior, SNP init needs to be done
> here implicitly as part of these ioctls followed with SNP shutdown
> before returning from the ioctl to maintain the consistent platform
> state before and after the ioctl.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 117 ++++++++++++++++++++++++++++-------
>  1 file changed, 93 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 8f5c474b9d1c..b06f43eb18f7 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1461,7 +1461,8 @@ static int sev_ioctl_do_platform_status(struct sev_=
issue_cmd *argp)
>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp,=
 bool writable)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
> -       int rc;
> +       bool shutdown_required =3D false;
> +       int rc, error;
>
>         if (!writable)
>                 return -EPERM;
> @@ -1470,19 +1471,26 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, stru=
ct sev_issue_cmd *argp, bool wr
>                 rc =3D __sev_platform_init_locked(&argp->error);
>                 if (rc)
>                         return rc;
> +               shutdown_required =3D true;
>         }
>
> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +       rc =3D __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +
> +       if (shutdown_required)
> +               __sev_platform_shutdown_locked(&error);

This error is discarded. Is that by design? If so, It'd be better to
call this ignored_error.

> +
> +       return rc;
>  }
>
>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writabl=
e)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
>         struct sev_user_data_pek_csr input;
> +       bool shutdown_required =3D false;
>         struct sev_data_pek_csr data;
>         void __user *input_address;
>         void *blob =3D NULL;
> -       int ret;
> +       int ret, error;
>
>         if (!writable)
>                 return -EPERM;
> @@ -1513,6 +1521,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cm=
d *argp, bool writable)
>                 ret =3D __sev_platform_init_locked(&argp->error);
>                 if (ret)
>                         goto e_free_blob;
> +               shutdown_required =3D true;
>         }
>
>         ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error)=
;
> @@ -1531,6 +1540,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cm=
d *argp, bool writable)
>         }
>
>  e_free_blob:
> +       if (shutdown_required)
> +               __sev_platform_shutdown_locked(&error);

Another discarded error. This function is called in different
locations in sev-dev.c with and without checking the result, which
seems problematic.

> +
>         kfree(blob);
>         return ret;
>  }
> @@ -1747,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue=
_cmd *argp, bool writable)
>         struct sev_device *sev =3D psp_master->sev_data;
>         struct sev_user_data_pek_cert_import input;
>         struct sev_data_pek_cert_import data;
> +       bool shutdown_required =3D false;
>         void *pek_blob, *oca_blob;
> -       int ret;
> +       int ret, error;
>
>         if (!writable)
>                 return -EPERM;
> @@ -1780,11 +1793,15 @@ static int sev_ioctl_do_pek_import(struct sev_iss=
ue_cmd *argp, bool writable)
>                 ret =3D __sev_platform_init_locked(&argp->error);
>                 if (ret)
>                         goto e_free_oca;
> +               shutdown_required =3D true;
>         }
>
>         ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp=
->error);
>
>  e_free_oca:
> +       if (shutdown_required)
> +               __sev_platform_shutdown_locked(&error);

Again.

> +
>         kfree(oca_blob);
>  e_free_pek:
>         kfree(pek_blob);
> @@ -1901,17 +1918,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issu=
e_cmd *argp, bool writable)
>         struct sev_data_pdh_cert_export data;
>         void __user *input_cert_chain_address;
>         void __user *input_pdh_cert_address;
> -       int ret;
> -
> -       /* If platform is not in INIT state then transition it to INIT. *=
/
> -       if (sev->state !=3D SEV_STATE_INIT) {
> -               if (!writable)
> -                       return -EPERM;
> -
> -               ret =3D __sev_platform_init_locked(&argp->error);
> -               if (ret)
> -                       return ret;
> -       }
> +       bool shutdown_required =3D false;
> +       int ret, error;
>
>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(inpu=
t)))
>                 return -EFAULT;
> @@ -1952,6 +1960,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issu=
e_cmd *argp, bool writable)
>         data.cert_chain_len =3D input.cert_chain_len;
>
>  cmd:
> +       /* If platform is not in INIT state then transition it to INIT. *=
/
> +       if (sev->state !=3D SEV_STATE_INIT) {
> +               if (!writable)
> +                       goto e_free_cert;
> +               ret =3D __sev_platform_init_locked(&argp->error);

Using argp->error for init instead of the ioctl-requested command
means that the user will have difficulty distinguishing which process
is at fault, no?

> +               if (ret)
> +                       goto e_free_cert;
> +               shutdown_required =3D true;
> +       }
> +
>         ret =3D __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp=
->error);
>
>         /* If we query the length, FW responded with expected data. */
> @@ -1978,6 +1996,9 @@ static int sev_ioctl_do_pdh_export(struct sev_issue=
_cmd *argp, bool writable)
>         }
>
>  e_free_cert:
> +       if (shutdown_required)
> +               __sev_platform_shutdown_locked(&error);

Again.

> +
>         kfree(cert_blob);
>  e_free_pdh:
>         kfree(pdh_blob);
> @@ -1987,12 +2008,13 @@ static int sev_ioctl_do_pdh_export(struct sev_iss=
ue_cmd *argp, bool writable)
>  static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
> +       bool shutdown_required =3D false;
>         struct sev_data_snp_addr buf;
>         struct page *status_page;
> +       int ret, error;
>         void *data;
> -       int ret;
>
> -       if (!sev->snp_initialized || !argp->data)
> +       if (!argp->data)
>                 return -EINVAL;
>
>         status_page =3D alloc_page(GFP_KERNEL_ACCOUNT);
> @@ -2001,6 +2023,13 @@ static int sev_ioctl_do_snp_platform_status(struct=
 sev_issue_cmd *argp)
>
>         data =3D page_address(status_page);
>
> +       if (!sev->snp_initialized) {
> +               ret =3D __sev_snp_init_locked(&argp->error);

Error provenance confusion.

> +               if (ret)
> +                       goto cleanup;
> +               shutdown_required =3D true;
> +       }
> +
>         /*
>          * Firmware expects status page to be in firmware-owned state, ot=
herwise
>          * it will report firmware error code INVALID_PAGE_STATE (0x1A).
> @@ -2029,6 +2058,9 @@ static int sev_ioctl_do_snp_platform_status(struct =
sev_issue_cmd *argp)
>                 ret =3D -EFAULT;
>
>  cleanup:
> +       if (shutdown_required)
> +               __sev_snp_shutdown_locked(&error, false);
> +
>         __free_pages(status_page, 0);
>         return ret;
>  }
> @@ -2037,21 +2069,34 @@ static int sev_ioctl_do_snp_commit(struct sev_iss=
ue_cmd *argp)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
>         struct sev_data_snp_commit buf;
> +       bool shutdown_required =3D false;
> +       int ret, error;
>
> -       if (!sev->snp_initialized)
> -               return -EINVAL;
> +       if (!sev->snp_initialized) {
> +               ret =3D __sev_snp_init_locked(&argp->error);

Error provenance confusion.

> +               if (ret)
> +                       return ret;
> +               shutdown_required =3D true;
> +       }
>
>         buf.len =3D sizeof(buf);
>
> -       return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error=
);
> +       ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->erro=
r);
> +
> +       if (shutdown_required)
> +               __sev_snp_shutdown_locked(&error, false);

Again.

> +
> +       return ret;
>  }
>
>  static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool =
writable)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
>         struct sev_user_data_snp_config config;
> +       bool shutdown_required =3D false;
> +       int ret, error;
>
> -       if (!sev->snp_initialized || !argp->data)
> +       if (!argp->data)
>                 return -EINVAL;
>
>         if (!writable)
> @@ -2060,17 +2105,30 @@ static int sev_ioctl_do_snp_set_config(struct sev=
_issue_cmd *argp, bool writable
>         if (copy_from_user(&config, (void __user *)argp->data, sizeof(con=
fig)))
>                 return -EFAULT;
>
> -       return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->er=
ror);
> +       if (!sev->snp_initialized) {
> +               ret =3D __sev_snp_init_locked(&argp->error);

Error provenance problem again.

> +               if (ret)
> +                       return ret;
> +               shutdown_required =3D true;
> +       }
> +
> +       ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->e=
rror);
> +
> +       if (shutdown_required)
> +               __sev_snp_shutdown_locked(&error, false);
> +
> +       return ret;
>  }
>
>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool w=
ritable)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
>         struct sev_user_data_snp_vlek_load input;
> +       bool shutdown_required =3D false;
> +       int ret, error;
>         void *blob;
> -       int ret;
>
> -       if (!sev->snp_initialized || !argp->data)
> +       if (!argp->data)
>                 return -EINVAL;
>
>         if (!writable)
> @@ -2089,8 +2147,19 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_i=
ssue_cmd *argp, bool writable)
>
>         input.vlek_wrapped_address =3D __psp_pa(blob);
>
> +       if (!sev->snp_initialized) {
> +               ret =3D __sev_snp_init_locked(&argp->error);

Error provenance confusion.

> +               if (ret)
> +                       goto cleanup;
> +               shutdown_required =3D true;
> +       }
> +
>         ret =3D __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp-=
>error);
>
> +       if (shutdown_required)
> +               __sev_snp_shutdown_locked(&error, false);

Again.

> +
> +cleanup:
>         kfree(blob);
>
>         return ret;
> --
> 2.34.1
>


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

