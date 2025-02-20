Return-Path: <kvm+bounces-38802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC4BA3E7A3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6BC73B8EEE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 22:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FD8264F9E;
	Thu, 20 Feb 2025 22:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KkTcK18a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D4E1E9B35
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 22:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740091208; cv=none; b=SFH+aPa4HQZkKqyPWaCD2EfuHk0IiwCkMiKUyAJqeo4Jw7hPFJVhTagzvpzBq8aRXlNTb3HkrEjPXdAXwuFL/zprtSMpObJHiByaEU16qdfgubf8mEk1I1Ji7An8vE19UBfcUrMuEVTG66qNwX95HM9kSoyxvGPTg3tJpRaf/yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740091208; c=relaxed/simple;
	bh=MA+xHDdqUq1yk2Ez9s2XXu1J75s7bgUJ74/iEEmrWOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RHSQNXeAnB9cWcLQXFY98YO6LNoz56jkqQlRDgdKnR8rBSG0L4ZE1SQKv4NjQQYq0VvUJ2AX8+UzTRmo25Lk65BO865/w011KkCPRJtB+u1lo1a6fzX8vUJWMOWncaDMOVLmXFCOQqJdDPvswbIUFi20HvwkL1AiPzDFmqBLzHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KkTcK18a; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abbd96bef64so238349266b.3
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740091204; x=1740696004; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EvYv+aj8j+zTCkL7ssEiUCbMGAzEqKBKYb0x2hzdFs=;
        b=KkTcK18aLdjPfPHwrO8RYr3X7+wR+jLEFyotyJTnwIsNaAxQ0YvSTe9JO/fJxvfAzb
         AkRrpWoPk8oefTeMujZCpWzykCVjx2XwRjLN4koFTBoVTMNMqt0sx+OUvr7LzyTAa0Uo
         6XiFvMZGRypRc/y4mzpWgJB4rNLL17B/BMDt6LmUY2goEPWmLcYufn8pvCjhcw6jbTGo
         z7xQ48RJ0IxJ6iP8zM8ajZoDhvbKUIjK9yIns0gP2rn4exhtsdjTvTE4tu+nI2UDxP8v
         t35UuPbG8rwbSX6o5+NI81YEKQI03YSQUSn5M7CzgE6hf3q0Wg4L19ZpI0JJr4syRckD
         Lciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740091204; x=1740696004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/EvYv+aj8j+zTCkL7ssEiUCbMGAzEqKBKYb0x2hzdFs=;
        b=SRI05uj6kcR43e9fOM++zv1EOHjUyJMCfwGz9w8mXGtW7Y5GYXaeisOC/nPhZpQ4ez
         ll0F968yN3fNtVY6oQd0PEYKawcoCgStUvLGgJUK9k0LtgUoz2uzwVAGJKs+nQM8lBwJ
         DsQy6WFNeUjfSPTGJdPbLCL/Tz5mAeDgZIagvOSWPOKOFHOyrb+y81307OWhGyGKUIbm
         RUqOMrCM16zYHN61r3OlHM4sQ/kwh4mD5ZMNAyosYgMXGEmTtakWGtzdePPGt0F7yTpI
         5fx0qm09OzvN4oHm1YkQ69aXnFt87VczDKgFTSJMzOtbf+zteCNT5xVEkGcbfyWxWMBK
         AzcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKOCTrcPoSM7fv0kouGmAwuiLTF1MwV3j+bOSX0WdYDZDYBAkyVAVf8n8SvVxxzMSFo1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHZLJSEuAAOesM0+dP2SvygdZlJj0hTixQxS9NMe6MhjyWq6rW
	/LwrHghQomkiyXXgYqu8h3Il6BOvAl+g6DUzTAzU2O+FNSc3EQY9H/+v0tW/Lc+Ru0hGQA95zpw
	OieSmnutdZMUCWhDSxvqQ2NBg4cEuyf8c8wQG
X-Gm-Gg: ASbGncsBAgMt/hhN2SFNANBYJK2mAazMD6QQE1Ka062BUtwJAyxrzfOfo664Fr0mlAf
	CFjE3Je0jwez6SMOA5YKROr1UfASzLky11xr7M5RQ0Muh4dGqCxZoZ+OAMcHz/zmed16YFPyoTc
	90lJMuPE4NBVTS2dBfvRgYzWVa6aY=
X-Google-Smtp-Source: AGHT+IH4Qv0+6KZvpi+1uMXLZPhezmGXC7uR+1Xj4tehYbACfpkqO8/vS0CgMXXyCsoXJGBUSjhJxEbyphd2GOB9Mpc=
X-Received: by 2002:a17:907:72c8:b0:ab7:e52a:1467 with SMTP id
 a640c23a62f3a-abc09aff659mr125332966b.30.1740091203960; Thu, 20 Feb 2025
 14:40:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1739997129.git.ashish.kalra@amd.com> <f1caff4423a46c50564e625fd98932fde2a9a3fc.1739997129.git.ashish.kalra@amd.com>
 <CAAH4kHab8rvWCPX2x8cvv6Dm+uhZQxpJgwrrn2GAKzn8sqS9Kg@mail.gmail.com>
 <27d63f0a-f840-42df-a31c-28c8cb457222@amd.com> <CAAH4kHYXGNTFABo7hWCQvvebiv4VkXfT8HvV-FPneyQcrHA-9w@mail.gmail.com>
 <f227fa9a-f609-41f3-a63b-1c37ded33134@amd.com>
In-Reply-To: <f227fa9a-f609-41f3-a63b-1c37ded33134@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 20 Feb 2025 14:39:51 -0800
X-Gm-Features: AWEUYZmXe-AfsDb9SasqOdujPJo2AOjKzPGzkt9ECuWbb2oibMH6xOtCbdo7MV8
Message-ID: <CAAH4kHaM6BDD3Ry5KQJn0rVi7m+FCy2auQPnFNSxnMMeLziGhQ@mail.gmail.com>
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

On Thu, Feb 20, 2025 at 2:18=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.com=
> wrote:
>
> On 2/20/2025 3:37 PM, Dionna Amalie Glaze wrote:
> > On Thu, Feb 20, 2025 at 12:07=E2=80=AFPM Kalra, Ashish <ashish.kalra@am=
d.com> wrote:
> >>
> >> Hello Dionna,
> >>
> >> On 2/20/2025 10:44 AM, Dionna Amalie Glaze wrote:
> >>> On Wed, Feb 19, 2025 at 12:53=E2=80=AFPM Ashish Kalra <Ashish.Kalra@a=
md.com> wrote:
> >>>>
> >>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>>
> >>>> Modify the behavior of implicit SEV initialization in some of the
> >>>> SEV ioctls to do both SEV initialization and shutdown and add
> >>>> implicit SNP initialization and shutdown to some of the SNP ioctls
> >>>> so that the change of SEV/SNP platform initialization not being
> >>>> done during PSP driver probe time does not break userspace tools
> >>>> such as sevtool, etc.
> >>>>
> >>>> Prior to this patch, SEV has always been initialized before these
> >>>> ioctls as SEV initialization is done as part of PSP module probe,
> >>>> but now with SEV initialization being moved to KVM module load inste=
ad
> >>>> of PSP driver probe, the implied SEV INIT actually makes sense and g=
ets
> >>>> used and additionally to maintain SEV platform state consistency
> >>>> before and after the ioctl SEV shutdown needs to be done after the
> >>>> firmware call.
> >>>>
> >>>> It is important to do SEV Shutdown here with the SEV/SNP initializat=
ion
> >>>> moving to KVM, an implicit SEV INIT here as part of the SEV ioctls n=
ot
> >>>> followed with SEV Shutdown will cause SEV to remain in INIT state an=
d
> >>>> then a future SNP INIT in KVM module load will fail.
> >>>>
> >>>> Similarly, prior to this patch, SNP has always been initialized befo=
re
> >>>> these ioctls as SNP initialization is done as part of PSP module pro=
be,
> >>>> therefore, to keep a consistent behavior, SNP init needs to be done
> >>>> here implicitly as part of these ioctls followed with SNP shutdown
> >>>> before returning from the ioctl to maintain the consistent platform
> >>>> state before and after the ioctl.
> >>>>
> >>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>>> ---
> >>>>  drivers/crypto/ccp/sev-dev.c | 117 ++++++++++++++++++++++++++++----=
---
> >>>>  1 file changed, 93 insertions(+), 24 deletions(-)
> >>>>
> >>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-d=
ev.c
> >>>> index 8f5c474b9d1c..b06f43eb18f7 100644
> >>>> --- a/drivers/crypto/ccp/sev-dev.c
> >>>> +++ b/drivers/crypto/ccp/sev-dev.c
> >>>> @@ -1461,7 +1461,8 @@ static int sev_ioctl_do_platform_status(struct=
 sev_issue_cmd *argp)
> >>>>  static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *=
argp, bool writable)
> >>>>  {
> >>>>         struct sev_device *sev =3D psp_master->sev_data;
> >>>> -       int rc;
> >>>> +       bool shutdown_required =3D false;
> >>>> +       int rc, error;
> >>>>
> >>>>         if (!writable)
> >>>>                 return -EPERM;
> >>>> @@ -1470,19 +1471,26 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd,=
 struct sev_issue_cmd *argp, bool wr
> >>>>                 rc =3D __sev_platform_init_locked(&argp->error);
> >>>>                 if (rc)
> >>>>                         return rc;
> >>>> +               shutdown_required =3D true;
> >>>>         }
> >>>>
> >>>> -       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> >>>> +       rc =3D __sev_do_cmd_locked(cmd, NULL, &argp->error);
> >>>> +
> >>>> +       if (shutdown_required)
> >>>> +               __sev_platform_shutdown_locked(&error);
> >>>
> >>> This error is discarded. Is that by design? If so, It'd be better to
> >>> call this ignored_error.
> >>>
> >>
> >> This is by design, we cannot overwrite the error for the original comm=
and being issued
> >> here which in this case is do_pek_pdh_gen, hence we use a local error =
for the shutdown command.
> >> And __sev_platform_shutdown_locked() has it's own error logging code, =
so it will be printing
> >> the error message for the shutdown command failure, so the shutdown er=
ror is not eventually
> >> being ignored, that error log will assist in any inconsistent SEV/SNP =
platform state and
> >> subsequent errors.
> >>
> >>>> +
> >>>> +       return rc;
> >>>>  }
> >>>>
> >>>>  static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool wr=
itable)
> >>>>  {
> >>>>         struct sev_device *sev =3D psp_master->sev_data;
> >>>>         struct sev_user_data_pek_csr input;
> >>>> +       bool shutdown_required =3D false;
> >>>>         struct sev_data_pek_csr data;
> >>>>         void __user *input_address;
> >>>>         void *blob =3D NULL;
> >>>> -       int ret;
> >>>> +       int ret, error;
> >>>>
> >>>>         if (!writable)
> >>>>                 return -EPERM;
> >>>> @@ -1513,6 +1521,7 @@ static int sev_ioctl_do_pek_csr(struct sev_iss=
ue_cmd *argp, bool writable)
> >>>>                 ret =3D __sev_platform_init_locked(&argp->error);
> >>>>                 if (ret)
> >>>>                         goto e_free_blob;
> >>>> +               shutdown_required =3D true;
> >>>>         }
> >>>>
> >>>>         ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->e=
rror);
> >>>> @@ -1531,6 +1540,9 @@ static int sev_ioctl_do_pek_csr(struct sev_iss=
ue_cmd *argp, bool writable)
> >>>>         }
> >>>>
> >>>>  e_free_blob:
> >>>> +       if (shutdown_required)
> >>>> +               __sev_platform_shutdown_locked(&error);
> >>>
> >>> Another discarded error. This function is called in different
> >>> locations in sev-dev.c with and without checking the result, which
> >>> seems problematic.
> >>
> >> Not really, if shutdown fails for any reason, the error is printed.
> >> The return value here reflects the value of the original command/funct=
ion.
> >> The command/ioctl could have succeeded but the shutdown failed, hence,
> >> shutdown error is printed, but the return value reflects that the ioct=
l succeeded.
> >>
> >> Additionally, in case of INIT before the command is issued, the comman=
d may
> >> have failed without the SEV state being in INIT state, hence the error=
 for the
> >> INIT command failure is returned back from the ioctl.
> >>
> >>>
> >>>> +
> >>>>         kfree(blob);
> >>>>         return ret;
> >>>>  }
> >>>> @@ -1747,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_=
issue_cmd *argp, bool writable)
> >>>>         struct sev_device *sev =3D psp_master->sev_data;
> >>>>         struct sev_user_data_pek_cert_import input;
> >>>>         struct sev_data_pek_cert_import data;
> >>>> +       bool shutdown_required =3D false;
> >>>>         void *pek_blob, *oca_blob;
> >>>> -       int ret;
> >>>> +       int ret, error;
> >>>>
> >>>>         if (!writable)
> >>>>                 return -EPERM;
> >>>> @@ -1780,11 +1793,15 @@ static int sev_ioctl_do_pek_import(struct se=
v_issue_cmd *argp, bool writable)
> >>>>                 ret =3D __sev_platform_init_locked(&argp->error);
> >>>>                 if (ret)
> >>>>                         goto e_free_oca;
> >>>> +               shutdown_required =3D true;
> >>>>         }
> >>>>
> >>>>         ret =3D __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, =
&argp->error);
> >>>>
> >>>>  e_free_oca:
> >>>> +       if (shutdown_required)
> >>>> +               __sev_platform_shutdown_locked(&error);
> >>>
> >>> Again.
> >>>
> >>>> +
> >>>>         kfree(oca_blob);
> >>>>  e_free_pek:
> >>>>         kfree(pek_blob);
> >>>> @@ -1901,17 +1918,8 @@ static int sev_ioctl_do_pdh_export(struct sev=
_issue_cmd *argp, bool writable)
> >>>>         struct sev_data_pdh_cert_export data;
> >>>>         void __user *input_cert_chain_address;
> >>>>         void __user *input_pdh_cert_address;
> >>>> -       int ret;
> >>>> -
> >>>> -       /* If platform is not in INIT state then transition it to IN=
IT. */
> >>>> -       if (sev->state !=3D SEV_STATE_INIT) {
> >>>> -               if (!writable)
> >>>> -                       return -EPERM;
> >>>> -
> >>>> -               ret =3D __sev_platform_init_locked(&argp->error);
> >>>> -               if (ret)
> >>>> -                       return ret;
> >>>> -       }
> >>>> +       bool shutdown_required =3D false;
> >>>> +       int ret, error;
> >>>>
> >>>>         if (copy_from_user(&input, (void __user *)argp->data, sizeof=
(input)))
> >>>>                 return -EFAULT;
> >>>> @@ -1952,6 +1960,16 @@ static int sev_ioctl_do_pdh_export(struct sev=
_issue_cmd *argp, bool writable)
> >>>>         data.cert_chain_len =3D input.cert_chain_len;
> >>>>
> >>>>  cmd:
> >>>> +       /* If platform is not in INIT state then transition it to IN=
IT. */
> >>>> +       if (sev->state !=3D SEV_STATE_INIT) {
> >>>> +               if (!writable)
> >>>> +                       goto e_free_cert;
> >>>> +               ret =3D __sev_platform_init_locked(&argp->error);
> >>>
> >>> Using argp->error for init instead of the ioctl-requested command
> >>> means that the user will have difficulty distinguishing which process
> >>> is at fault, no?
> >>>
> >>
> >> Not really, in case the SEV command has still not been issued, argp->e=
rror is still usable
> >> and returned back to the caller (no need to use a local error here), w=
e are not overwriting
> >> the argp->error used for the original command/ioctl here.
> >>
> >
> > I mean in the case that argp->error is set to a value shared by the
> > command and init, it's hard to know what the problem was.
> > I'd like to ensure that the documentation is updated to reflect that
> > (in this case) if PDH_CERT_EXPORT returns INVALID_PLATFORM_STATE, then
> > it's because the platform was not in PSTATE.UNINIT state.
> > The new behavior of initializing when you need to now means that you
> > should have ruled out INVALID_PLATFORM_STATE as a possible value from
> > PDH_EXPORT_CERT. Same for SNP_CONFIG.
> >
> > There is not a 1-to-1 mapping between the ioctl commands and the SEV
> > commands now, so I think you need extra documentation to clarify the
> > new error space for at least pdh_export and set_config
> >
> > SNP_PLATFORM_STATUS, VLEK_LOAD, and SNP_COMMIT appear to not
> > necessarily have a provenance confusion after looking closer.
> >
> >
>
> I am more of less trying to match the current behavior of sev_ioctl_do_pe=
k_import()
> or sev_ioctl_do_pdh_export().
>
> All this is implementation specific handling so we can't update SEV/SNP f=
irmware
> API specs documentation for this new error space, this is not a firmware =
specific return code.
>

I was just talking about the uapi for the ioctls, not AMD reference
documentation.

> But to maintain 1-to-1 mapping between the ioctl commands and the SEV/SNP=
 commands,
> i think it will be better to handle this INIT in the same way as SHUTDOWN=
, which
> is to use a local error for INIT and in case of implicit INIT failures, l=
et the
> error logs from __sev_platform_init_locked() OR __sev_snp_init_locked() b=
e printed
> and always return INVALID_PLATFORM_STATE as error back to the caller.
>
> Thanks,
> Ashish
>


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

