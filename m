Return-Path: <kvm+bounces-38797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7896EA3E6C3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8867F19C3721
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B81E264628;
	Thu, 20 Feb 2025 21:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E1OMq2Xq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530DC2147E9
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 21:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740087469; cv=none; b=PFHXbkRNFbyMg0NC5++giYDW5XHYvig5qr4kRnlZy3SfFWkCGB7CgQeEJYrl6+QPSFSKA5H351Je4v5LSr1B4YksfOevWPEkGJRmm0rRuMJP822nGuZYbtzxiS/QPR4+DdJ22l29uokQdda/ek3B0/0HmwfmTlQFeSrlCQkb1Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740087469; c=relaxed/simple;
	bh=88xel4ReXmml0Y0dgHmn02RadkL5KzYs1W8CvR4jbJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V38tZoetrAIHkB1eNuKd5rPwg++2XdsVCISvruOe6cwnTaDyVaQffulVAjfzc8VlpbU1+Kei+glPBZRADPG2U0ZpkhdrK42O2/w3BZgqhKzBMGiSoXqAT8jf3QynefOxfbYXTdaYOw6KGSPc+EsNsAlJchUAGR9ZOscR2PNUca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E1OMq2Xq; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abb8d63b447so190215666b.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 13:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740087465; x=1740692265; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJgY/DEAxcJuwoGxKe8jJ8rEYcAL/Pax8Zc7JijGPQM=;
        b=E1OMq2XqIw5/ZO8mSSnaZsaif7vAgFMIgaOn7PhvvAY4clm0GgDXOQnhAmlkOq6kXd
         vMHF8QG78PFKsQZLxA+I5SYYxjEdeo85M5SOZPXtGjjysBjT9Y1zt/n89eB67C++334T
         /9QLBarLfPkOqdfMQ+4XyNCp1Wp6AwMeIyVAP8Qpcg1Cbc69dKXuvCHfHX1Ir1VEEdfW
         itGao2LDQZG9aBFqyHq9yu0TP3fgiKINqWAd9szHC7HMfjkYl7Y17I7rfYGP+wEf9PoG
         6ZWuItuD0zE5+BKUiVsYDtxb7GL1i3SPEhrVkWw7ZkryLA8tt9FONQFLLyzYwATxQN2n
         PKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740087465; x=1740692265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJgY/DEAxcJuwoGxKe8jJ8rEYcAL/Pax8Zc7JijGPQM=;
        b=hzFGOhcBKgfW863q790LzlcF6aDBAB726X9UOARoi1PIsmJOtIfclxqYQG47Kd5Xtj
         20cO+VnPpDaOv62pgl3gk7gr81H18QJ+6WhH+thwXw4ZBFNfqK9ndB5edeexhOJsh1XF
         BphP2Iiw3Q6KU2mDMZTCb7zFtZl6WwpwMy4W+RWk21k++8qQPcGLttZWrCZDlS1A0Ps3
         xtYV5g8FVcQ4SkE8Su/8LqUbqyJv1SkkoW5u9CI4ryRhWGYU/uYZEwujz6//gGVqdf+3
         FRn650pXGg4xCPtrIlw7Y30y9wgzeQ3kC4TVm9pWso5iCzhl/zX1uj/lMQvzCGNvzWVU
         wTXw==
X-Forwarded-Encrypted: i=1; AJvYcCUCGaY3vznqh05Ej8R3SbGXhXHl5SVYvJIQWXf1LjulhpoFIFtA2X+/eeYzPehd+Kflmz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgb1lRi2WO4TH6YbYnaF3rWx9qnQ6FtdsqBzTVrNRJXOcHdZUR
	2h96Jl6E9g0UiCKE6OUQ1fKhiVlt9P1DZyBvygeTe3XyfxgCcVUmvYkiR2rs9gnkgWXoPSRsB7/
	ITUAuWYFR4G51By4eYjI8VCeR0cWlHOG07uFR
X-Gm-Gg: ASbGncuFncNTFiUyI5txlD6ATVCJpCQ4adh2DIz1sC24Att13z0juSmY+m9UaKoOLSR
	ELJNbmUfqXipvhfG7XyxAT2Evc2he3RdYDHtujHbPFJE517KCsDqPcAVlYtFm/BvmyDuziSqekc
	9W8R/Nxxz/5mZISHBaQrDpYbsomQc=
X-Google-Smtp-Source: AGHT+IHk8/fn5FhZEYC+B8X06zJ7j4NoHhOvN9+v3er2xxjzQYmLbruTLQB4WUbNewXmprb13+b2o7CIyIBuqIUXzPg=
X-Received: by 2002:a17:906:308c:b0:ab7:ec7c:89e4 with SMTP id
 a640c23a62f3a-abc09a0a2c1mr77488566b.21.1740087464402; Thu, 20 Feb 2025
 13:37:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739997129.git.ashish.kalra@amd.com> <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
 <CAAH4kHab8rvWCPX2x8cvv6Dm+uhZQxpJgwrrn2GAKzn8sqS9Kg@mail.gmail.com> <27d63f0a-f840-42df-a31c-28c8cb457222@amd.com>
In-Reply-To: <27d63f0a-f840-42df-a31c-28c8cb457222@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 20 Feb 2025 13:37:31 -0800
X-Gm-Features: AWEUYZkw8JRzTMCWoOsQe1qrRf6TLzBp_lxe1iYiNlk4nmTmKATxQq-pAaeLENg
Message-ID: <CAAH4kHYXGNTFABo7hWCQvvebiv4VkXfT8HvV-FPneyQcrHA-9w@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] crypto: ccp: Ensure implicit SEV/SNP init and
 shutdown in ioctls
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, michael.roth@amd.com, nikunj@amd.com, 
	ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, 
	aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 12:07=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.co=
m> wrote:
>
> Hello Dionna,
>
> On 2/20/2025 10:44 AM, Dionna Amalie Glaze wrote:
> > On Wed, Feb 19, 2025 at 12:53=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd=
.com> wrote:
> >>
> >> From: Ashish Kalra <ashish.kalra@amd.com>
> >>
> >> Modify the behavior of implicit SEV initialization in some of the
> >> SEV ioctls to do both SEV initialization and shutdown and add
> >> implicit SNP initialization and shutdown to some of the SNP ioctls
> >> so that the change of SEV/SNP platform initialization not being
> >> done during PSP driver probe time does not break userspace tools
> >> such as sevtool, etc.
> >>
> >> Prior to this patch, SEV has always been initialized before these
> >> ioctls as SEV initialization is done as part of PSP module probe,
> >> but now with SEV initialization being moved to KVM module load instead
> >> of PSP driver probe, the implied SEV INIT actually makes sense and get=
s
> >> used and additionally to maintain SEV platform state consistency
> >> before and after the ioctl SEV shutdown needs to be done after the
> >> firmware call.
> >>
> >> It is important to do SEV Shutdown here with the SEV/SNP initializatio=
n
> >> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls not
> >> followed with SEV Shutdown will cause SEV to remain in INIT state and
> >> then a future SNP INIT in KVM module load will fail.
> >>
> >> Similarly, prior to this patch, SNP has always been initialized before
> >> these ioctls as SNP initialization is done as part of PSP module probe=
,
> >> therefore, to keep a consistent behavior, SNP init needs to be done
> >> here implicitly as part of these ioctls followed with SNP shutdown
> >> before returning from the ioctl to maintain the consistent platform
> >> state before and after the ioctl.
> >>
> >> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >> ---
> >>  drivers/crypto/ccp/sev-dev.c | 117 ++++++++++++++++++++++++++++------=
-
> >>  1 file changed, 93 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev=
.c
> >> index 8f5c474b9d1c..b06f43eb18f7 100644
> >> --- a/drivers/crypto/ccp/sev-dev.c
> >> +++ b/drivers/crypto/ccp/sev-dev.c
> >> @@ -1461,7 +1461,8 @@ static int sev_ioctl_do_platform_status(struct s=
ev_issue_cmd *argp)
> >>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *ar=
gp, bool writable)
> >>  {
> >>         struct sev_device *sev =3D psp_master->sev_data;
> >> -       int rc;
> >> +       bool shutdown_required =3D false;
> >> +       int rc, error;
> >>
> >>         if (!writable)
> >>                 return -EPERM;
> >> @@ -1470,19 +1471,26 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, s=
truct sev_issue_cmd *argp, bool wr
> >>                 rc =3D __sev_platform_init_locked(&argp->error);
> >>                 if (rc)
> >>                         return rc;
> >> +               shutdown_required =3D true;
> >>         }
> >>
> >> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> >> +       rc =3D __sev_do_cmd_locked(cmd, NULL, &argp->error);
> >> +
> >> +       if (shutdown_required)
> >> +               __sev_platform_shutdown_locked(&error);
> >
> > This error is discarded. Is that by design? If so, It'd be better to
> > call this ignored_error.
> >
>
> This is by design, we cannot overwrite the error for the original command=
 being issued
> here which in this case is do_pek_pdh_gen, hence we use a local error for=
 the shutdown command.
> And __sev_platform_shutdown_locked() has it's own error logging code, so =
it will be printing
> the error message for the shutdown command failure, so the shutdown error=
 is not eventually
> being ignored, that error log will assist in any inconsistent SEV/SNP pla=
tform state and
> subsequent errors.
>
> >> +
> >> +       return rc;
> >>  }
> >>
> >>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writ=
able)
> >>  {
> >>         struct sev_device *sev =3D psp_master->sev_data;
> >>         struct sev_user_data_pek_csr input;
> >> +       bool shutdown_required =3D false;
> >>         struct sev_data_pek_csr data;
> >>         void __user *input_address;
> >>         void *blob =3D NULL;
> >> -       int ret;
> >> +       int ret, error;
> >>
> >>         if (!writable)
> >>                 return -EPERM;
> >> @@ -1513,6 +1521,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue=
_cmd *argp, bool writable)
> >>                 ret =3D __sev_platform_init_locked(&argp->error);
> >>                 if (ret)
> >>                         goto e_free_blob;
> >> +               shutdown_required =3D true;
> >>         }
> >>
> >>         ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->err=
or);
> >> @@ -1531,6 +1540,9 @@ static int sev_ioctl_do_pek_csr(struct sev_issue=
_cmd *argp, bool writable)
> >>         }
> >>
> >>  e_free_blob:
> >> +       if (shutdown_required)
> >> +               __sev_platform_shutdown_locked(&error);
> >
> > Another discarded error. This function is called in different
> > locations in sev-dev.c with and without checking the result, which
> > seems problematic.
>
> Not really, if shutdown fails for any reason, the error is printed.
> The return value here reflects the value of the original command/function=
.
> The command/ioctl could have succeeded but the shutdown failed, hence,
> shutdown error is printed, but the return value reflects that the ioctl s=
ucceeded.
>
> Additionally, in case of INIT before the command is issued, the command m=
ay
> have failed without the SEV state being in INIT state, hence the error fo=
r the
> INIT command failure is returned back from the ioctl.
>
> >
> >> +
> >>         kfree(blob);
> >>         return ret;
> >>  }
> >> @@ -1747,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_is=
sue_cmd *argp, bool writable)
> >>         struct sev_device *sev =3D psp_master->sev_data;
> >>         struct sev_user_data_pek_cert_import input;
> >>         struct sev_data_pek_cert_import data;
> >> +       bool shutdown_required =3D false;
> >>         void *pek_blob, *oca_blob;
> >> -       int ret;
> >> +       int ret, error;
> >>
> >>         if (!writable)
> >>                 return -EPERM;
> >> @@ -1780,11 +1793,15 @@ static int sev_ioctl_do_pek_import(struct sev_=
issue_cmd *argp, bool writable)
> >>                 ret =3D __sev_platform_init_locked(&argp->error);
> >>                 if (ret)
> >>                         goto e_free_oca;
> >> +               shutdown_required =3D true;
> >>         }
> >>
> >>         ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &a=
rgp->error);
> >>
> >>  e_free_oca:
> >> +       if (shutdown_required)
> >> +               __sev_platform_shutdown_locked(&error);
> >
> > Again.
> >
> >> +
> >>         kfree(oca_blob);
> >>  e_free_pek:
> >>         kfree(pek_blob);
> >> @@ -1901,17 +1918,8 @@ static int sev_ioctl_do_pdh_export(struct sev_i=
ssue_cmd *argp, bool writable)
> >>         struct sev_data_pdh_cert_export data;
> >>         void __user *input_cert_chain_address;
> >>         void __user *input_pdh_cert_address;
> >> -       int ret;
> >> -
> >> -       /* If platform is not in INIT state then transition it to INIT=
. */
> >> -       if (sev->state !=3D SEV_STATE_INIT) {
> >> -               if (!writable)
> >> -                       return -EPERM;
> >> -
> >> -               ret =3D __sev_platform_init_locked(&argp->error);
> >> -               if (ret)
> >> -                       return ret;
> >> -       }
> >> +       bool shutdown_required =3D false;
> >> +       int ret, error;
> >>
> >>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(i=
nput)))
> >>                 return -EFAULT;
> >> @@ -1952,6 +1960,16 @@ static int sev_ioctl_do_pdh_export(struct sev_i=
ssue_cmd *argp, bool writable)
> >>         data.cert_chain_len =3D input.cert_chain_len;
> >>
> >>  cmd:
> >> +       /* If platform is not in INIT state then transition it to INIT=
. */
> >> +       if (sev->state !=3D SEV_STATE_INIT) {
> >> +               if (!writable)
> >> +                       goto e_free_cert;
> >> +               ret =3D __sev_platform_init_locked(&argp->error);
> >
> > Using argp->error for init instead of the ioctl-requested command
> > means that the user will have difficulty distinguishing which process
> > is at fault, no?
> >
>
> Not really, in case the SEV command has still not been issued, argp->erro=
r is still usable
> and returned back to the caller (no need to use a local error here), we a=
re not overwriting
> the argp->error used for the original command/ioctl here.
>

I mean in the case that argp->error is set to a value shared by the
command and init, it's hard to know what the problem was.
I'd like to ensure that the documentation is updated to reflect that
(in this case) if PDH_CERT_EXPORT returns INVALID_PLATFORM_STATE, then
it's because the platform was not in PSTATE.UNINIT state.
The new behavior of initializing when you need to now means that you
should have ruled out INVALID_PLATFORM_STATE as a possible value from
PDH_EXPORT_CERT. Same for SNP_CONFIG.

There is not a 1-to-1 mapping between the ioctl commands and the SEV
commands now, so I think you need extra documentation to clarify the
new error space for at least pdh_export and set_config

SNP_PLATFORM_STATUS, VLEK_LOAD, and SNP_COMMIT appear to not
necessarily have a provenance confusion after looking closer.



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

