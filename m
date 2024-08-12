Return-Path: <kvm+bounces-23833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DC494EA4E
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 11:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC31B281F39
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 09:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF92716E862;
	Mon, 12 Aug 2024 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVBwVeJj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584ED16C85D
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 09:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723456402; cv=none; b=bzJiBH7MgZv8Z0L9VSk6xxGtqKIn4wk/aT86GQSwPLnNsei2L9jLkUNB+LpXM27qG2/Nhya3R3f+Py3J8tfT2rXbgwd7N87GdCEIBL7ZihyMlOG9cx6qow/euDFdEVFq5i2bX8MGSd+tmLZIyZvm/DJVTIHdGuax/fCxFTa8ld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723456402; c=relaxed/simple;
	bh=SwIS8v+BZF5z9FMgqbfwDDBc77R8uZGvAjV+LF4U8xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AfxPH2hOa3/p6uxWDq+MA+oFFV+JI5jznIgaY7e6EsYEleI56lLrkJUGfpnbi1te+jlAPo6jZCMFLK+w1oGTHdGicXXCJX9+xSdMafU8Kx4xmtnZ0TbRxSBM0Av6Y6Db/vH8T8wpcT66gHprFo2q8el2VeyLxQ5GI05C7dVOa3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVBwVeJj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723456399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DaNd/0SeJ2+vXikjwkP3r5pLGCe1rmKQoREGvBy59qk=;
	b=EVBwVeJjlQMAmrwa6/Cjyj/wql7FcmTZ5Q+TH43fu9rEea2v1plBSFk1nKMNh55o6AAOHs
	HnVW+96/6Dl+nYZQH8T7XUlMU/X//wCTu7xyq/Fc8ZKdBFoFcF7AXVBu1hHTrvq8IjquL3
	CT+8YDGm1KyHEQ9wgoS5rG1s3j3QN3k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-X9rGPip1N9mX-Y032-f2TA-1; Mon, 12 Aug 2024 05:53:17 -0400
X-MC-Unique: X9rGPip1N9mX-Y032-f2TA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a80c12dede1so220837666b.0
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 02:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723456396; x=1724061196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaNd/0SeJ2+vXikjwkP3r5pLGCe1rmKQoREGvBy59qk=;
        b=UY7EeJ6NV/cVpTgsXUJHfsE8JQBXzvD83C8l+jgLbwkmHKr3f9xSqVqcY2KLbCt+MU
         tWCeE3pMqTmGlj4mYhKSZ9PqMlyjucqix3U4AQwlLNvEugyr5YSxe9q6H4nueP6uWkMQ
         4NReJK8eqKmglmssUJFGz6Bkvp5eT7LBvPcQbxU5wVQnKWggec+nIKe9Eh1cw4wgXvw2
         1znej+aPkGzlRmg6itEIL+XVoYrpCM+UNkARkk/e+XhUJTxvxxMlX2+AHr4BogHkVPSi
         1YcO43kKls29yabq8ljJU6ZKsJNPs93zKRIbrf2+T/oWKr2BuoBf7jLQMNAH2CpeX/tf
         dmYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8sxMgH8+8ZHaxYZwdo06oNi9+fiSGALdqAlfnAmxhC3hZb60m7I9sURgopvzz+zewpLZQ9qxU6xgsukFz8oXPSTXE
X-Gm-Message-State: AOJu0Yw14+BhtugPfQRNVByansXoU06XRJQz6MNj68dDX6sTFlNVgELr
	qcLPqHH0CU1C+75b+V9x61vTKaQrkhUredu3IQnf1lSOTrg1JFDIdLr5jgW349yy7+jxpTHbUfO
	0qGxxyyOWdOUc/LC4JnChUVx7MaoYHcTQCQJtLYkldghN1nktTGiy8xQuN1n7ogppbYJoM+w95v
	ubCbkR+JgdcaV7fp+7J0Ijmg1H
X-Received: by 2002:a17:907:dac:b0:a7a:bcbc:f7f4 with SMTP id a640c23a62f3a-a80ab795802mr667106966b.14.1723456396352;
        Mon, 12 Aug 2024 02:53:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTpvWhvzJKJINItgkEHZvMCgHN2cqJ5ObqV2x/QDvdU+IVRKhPZr+44cYlBD1rk5d7utrzPNmjj/9yTQ7l2g8=
X-Received: by 2002:a17:907:dac:b0:a7a:bcbc:f7f4 with SMTP id
 a640c23a62f3a-a80ab795802mr667105066b.14.1723456395764; Mon, 12 Aug 2024
 02:53:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809064940.1788169-1-anisinha@redhat.com> <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
In-Reply-To: <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
From: Ani Sinha <anisinha@redhat.com>
Date: Mon, 12 Aug 2024 15:23:04 +0530
Message-ID: <CAK3XEhM+SR39vYxG_ygQ=hCj_bmDE3dOH6EPFQZbLYrE-Yj-ow@mail.gmail.com>
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in kvm_init()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org, zhao1.liu@intel.com, 
	kvm@vger.kernel.org, qemu-devel@nongnu.org, 
	Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 2:06=E2=80=AFPM Philippe Mathieu-Daud=C3=A9 <philmd@=
linaro.org> wrote:
>
> Hi Ani,
>
> On 9/8/24 08:49, Ani Sinha wrote:
> > error_report() is more appropriate for error situations. Replace fprint=
f with
> > error_report. Cosmetic. No functional change.
> >
> > CC: qemu-trivial@nongnu.org
> > CC: zhao1.liu@intel.com
>
> (Pointless to carry Cc line when patch is already reviewed next line)
>
> > Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> > Signed-off-by: Ani Sinha <anisinha@redhat.com>
> > ---
> >   accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
> >   1 file changed, 18 insertions(+), 22 deletions(-)
> >
> > changelog:
> > v2: fix a bug.
> > v3: replace one instance of error_report() with error_printf(). added t=
ags.
> >
> > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > index 75d11a07b2..5bc9d35b61 100644
> > --- a/accel/kvm/kvm-all.c
> > +++ b/accel/kvm/kvm-all.c
> > @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
> >       QLIST_INIT(&s->kvm_parked_vcpus);
> >       s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
> >       if (s->fd =3D=3D -1) {
> > -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
> > +        error_report("Could not access KVM kernel module: %m");
> >           ret =3D -errno;
> >           goto err;
> >       }
> > @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
> >           if (ret >=3D 0) {
> >               ret =3D -EINVAL;
> >           }
> > -        fprintf(stderr, "kvm version too old\n");
> > +        error_report("kvm version too old");
> >           goto err;
> >       }
> >
> >       if (ret > KVM_API_VERSION) {
> >           ret =3D -EINVAL;
> > -        fprintf(stderr, "kvm version not supported\n");
> > +        error_report("kvm version not supported");
> >           goto err;
> >       }
> >
> > @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
> >       } while (ret =3D=3D -EINTR);
> >
> >       if (ret < 0) {
> > -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> > -                strerror(-ret));
> > +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> > +                    strerror(-ret));
> >
> >   #ifdef TARGET_S390X
> >           if (ret =3D=3D -EINVAL) {
> > -            fprintf(stderr,
> > -                    "Host kernel setup problem detected. Please verify=
:\n");
> > -            fprintf(stderr, "- for kernels supporting the switch_amode=
 or"
> > -                    " user_mode parameters, whether\n");
> > -            fprintf(stderr,
> > -                    "  user space is running in primary address space\=
n");
> > -            fprintf(stderr,
> > -                    "- for kernels supporting the vm.allocate_pgste sy=
sctl, "
> > -                    "whether it is enabled\n");
> > +            error_report("Host kernel setup problem detected.
>
> \n"
>
> Should we use error_printf_unless_qmp() for the following?

Do you believe that qemu_init() -> configure_accelerators() ->
do_configure_accelerator,() -> accel_init_machine() -> kvm_init()  can
be called from QMP context?

>
> " Please verify:");
> > +            error_report("- for kernels supporting the switch_amode or=
"
> > +                        " user_mode parameters, whether");
> > +            error_report("  user space is running in primary address s=
pace");
> > +            error_report("- for kernels supporting the vm.allocate_pgs=
te "
> > +                        "sysctl, whether it is enabled");
> >           }
> >   #elif defined(TARGET_PPC)
> >           if (ret =3D=3D -EINVAL) {
> > -            fprintf(stderr,
> > -                    "PPC KVM module is not loaded.
>
> \n"
>
> Ditto.
>
> " Try modprobe kvm_%s.\n",
> > -                    (type =3D=3D 2) ? "pr" : "hv");
> > +            error_report("PPC KVM module is not loaded. Try modprobe k=
vm_%s.",
> > +                        (type =3D=3D 2) ? "pr" : "hv");
> >           }
> >   #endif
> >           goto err;
> > @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
> >                           nc->name, nc->num, soft_vcpus_limit);
> >
> >               if (nc->num > hard_vcpus_limit) {
> > -                fprintf(stderr, "Number of %s cpus requested (%d) exce=
eds "
> > -                        "the maximum cpus supported by KVM (%d)\n",
> > -                        nc->name, nc->num, hard_vcpus_limit);
> > +                error_report("Number of %s cpus requested (%d) exceeds=
 "
> > +                             "the maximum cpus supported by KVM (%d)",
> > +                             nc->name, nc->num, hard_vcpus_limit);
> >                   exit(1);
> >               }
> >           }
> > @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
> >       }
> >       if (missing_cap) {
> >           ret =3D -EINVAL;
> > -        fprintf(stderr, "kvm does not support %s\n%s",
> > -                missing_cap->name, upgrade_note);
> > +        error_printf("kvm does not support %s\n%s",
> > +                     missing_cap->name, upgrade_note);
>
> Similarly, should we print upgrade_note using error_printf_unless_qmp?
>
> >           goto err;
> >       }
> >
>


