Return-Path: <kvm+bounces-24681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23EE095935A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 05:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 514C11C20826
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 03:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288D1157E62;
	Wed, 21 Aug 2024 03:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MA1Qs/3v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7111803E
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 03:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724211542; cv=none; b=oak46X2T8EhIHKlStyElVDkutd58Or/D3F6VCgCZYQk9UzCasNp1VefccHmAIcn8kDxa4vidD2vSoYaqxpBhzuQc/GIBwD4IiZ7TSPbR6lYjPEav0piO2Wx88+E50im2snMrC9ySjoORwtTkPmAUWFUpeE4IFbl97O+1eDEMO7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724211542; c=relaxed/simple;
	bh=3SeENzUZ2Sg4MfuSfoyMfXg8qA8d1BtZE0T9B4RhKQ8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fDkK7LjYnmT3aCz1d4QAoROwp1BeAYcXQ4++1kjL6jSrBUxxhrIRwy7Un01okFkRekRkbrxbgAUDo1BtVCRKu0AmQ3mvYdMrgR//f1EwSo6tDLWTXxdoDN7c7gF1f50bqo1Msq3+4IDRrqJU5F7C3qoI+ieNPRQkgyV9+e/8g4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MA1Qs/3v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724211539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mniOU0Jv46Kkr7FC0o+Y7JC9pwzDkeZwe6nNhkfibzQ=;
	b=MA1Qs/3vbPogBrGAe4hUVCLhYpnO4//0bHKVy21ZoH3hOQ5sgreChyGlEVKQj9SzT3ySmf
	ebpUP5ZqFRMuOoLuj5id45L1CibQeYjfuZ5Yh37gWa92WkYK1XELTOSxr1pjaSJYRj4mCW
	uUuvboyggGSTPIQCA/DXyp4pCKrrszg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-VvQLa_mAMD-m1lSyz3g34g-1; Tue, 20 Aug 2024 23:38:57 -0400
X-MC-Unique: VvQLa_mAMD-m1lSyz3g34g-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71274faa89aso4069937b3a.2
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 20:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724211536; x=1724816336;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mniOU0Jv46Kkr7FC0o+Y7JC9pwzDkeZwe6nNhkfibzQ=;
        b=j53n7qQ7AElLCOX+LrffCxX4rCuI3PHxHMZ+6CvRLG0K3husCq3cNTl/xNdV3Qshka
         YdBzxfA6lMSbp2xTCzI5kwjG9hTf4vsspo5nbHUnq5SVtPtQLWx+H2PNQIu0xqCITv+Q
         0486XiLMoRDprbQVcbWmpFVzao1ztsLdVBtVvaryc8AXV0wAK93d1ovcT/+LFsrrfXLF
         DahFZYwaZ7PZ9O51cPnJZLtxwIyqUZeTG1CWNLawCF7k4cHZIb72ZZNKkGY+Bctclfpk
         u/PeUjGIaMDZlOjwLMNTjVRBh0g/8mZitjKpPiw2H+omdBHbEU79XBP+j5pzLMWuAeQ8
         G9Sw==
X-Forwarded-Encrypted: i=1; AJvYcCXc321FkoiKhm/awOWrTMLnwAHTwGmokztp/ZDKcvVnx9KL0xIbELgwpcb3PY9xYwSLNEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwC6OVlpXw6rMy+HgnPlNIV93L1qeMAvIu51kPIcEhTwpAHWRR
	NZmQDCQkr9ZInyfus/Sf3kmqi9zPE14NiLpxFQAoJCTQA6OhAjnpjoxNCra+0t7nEK8w5EzGus9
	9ML9DfzoAgJ+j6q2yMegANJhPvrLe2b9Hfg0PX8FAMO4ep1e0NQ==
X-Received: by 2002:a05:6a21:a34b:b0:1c6:ee92:e5f4 with SMTP id adf61e73a8af0-1cad825ab0bmr1540248637.54.1724211536642;
        Tue, 20 Aug 2024 20:38:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFbG6jdjOSB9eCmrWvBe4CdhqGwfDb6L5DPmerEcXkT1EbIQjiI4ycCHoVxTXuUByOYQ1aVQ==
X-Received: by 2002:a05:6a21:a34b:b0:1c6:ee92:e5f4 with SMTP id adf61e73a8af0-1cad825ab0bmr1540225637.54.1724211536071;
        Tue, 20 Aug 2024 20:38:56 -0700 (PDT)
Received: from smtpclient.apple ([122.172.87.209])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5ebb69487sm464692a91.45.2024.08.20.20.38.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2024 20:38:55 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in
 kvm_init()
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <31202ec6-d108-4dd9-a103-f534f36c2821@linaro.org>
Date: Wed, 21 Aug 2024 09:08:41 +0530
Cc: Markus Armbruster <armbru@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 qemu-trivial@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B13D1705-CE12-42FD-8EF0-7945F5731A01@redhat.com>
References: <20240809064940.1788169-1-anisinha@redhat.com>
 <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
 <CAK3XEhM+SR39vYxG_ygQ=hCj_bmDE3dOH6EPFQZbLYrE-Yj-ow@mail.gmail.com>
 <CAK3XEhPZ8X1-Ui6pJ+kYY3Er-N-zW0f5MqpLyaU7t2d3qaQXkA@mail.gmail.com>
 <31202ec6-d108-4dd9-a103-f534f36c2821@linaro.org>
To: =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: Apple Mail (2.3776.700.51)



> On 16 Aug 2024, at 11:51=E2=80=AFAM, Philippe Mathieu-Daud=C3=A9 =
<philmd@linaro.org> wrote:
>=20
> On 12/8/24 11:59, Ani Sinha wrote:
>> On Mon, 12 Aug, 2024, 3:23 pm Ani Sinha, <anisinha@redhat.com =
<mailto:anisinha@redhat.com>> wrote:
>>    On Fri, Aug 9, 2024 at 2:06=E2=80=AFPM Philippe Mathieu-Daud=C3=A9
>>    <philmd@linaro.org <mailto:philmd@linaro.org>> wrote:
>>     >
>>     > Hi Ani,
>>     >
>>     > On 9/8/24 08:49, Ani Sinha wrote:
>>     > > error_report() is more appropriate for error situations.
>>    Replace fprintf with
>>     > > error_report. Cosmetic. No functional change.
>>     > >
>>     > > CC: qemu-trivial@nongnu.org <mailto:qemu-trivial@nongnu.org>
>>     > > CC: zhao1.liu@intel.com <mailto:zhao1.liu@intel.com>
>>     >
>>     > (Pointless to carry Cc line when patch is already reviewed next =
line)
>>     >
>>     > > Reviewed-by: Zhao Liu <zhao1.liu@intel.com
>>    <mailto:zhao1.liu@intel.com>>
>>     > > Signed-off-by: Ani Sinha <anisinha@redhat.com
>>    <mailto:anisinha@redhat.com>>
>>     > > ---
>>     > >   accel/kvm/kvm-all.c | 40 =
++++++++++++++++++----------------------
>>     > >   1 file changed, 18 insertions(+), 22 deletions(-)
>>     > >
>>     > > changelog:
>>     > > v2: fix a bug.
>>     > > v3: replace one instance of error_report() with =
error_printf().
>>    added tags.
>>     > >
>>     > > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>     > > index 75d11a07b2..5bc9d35b61 100644
>>     > > --- a/accel/kvm/kvm-all.c
>>     > > +++ b/accel/kvm/kvm-all.c
>>     > > @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>>     > >       QLIST_INIT(&s->kvm_parked_vcpus);
>>     > >       s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", =
O_RDWR);
>>     > >       if (s->fd =3D=3D -1) {
>>     > > -        fprintf(stderr, "Could not access KVM kernel module:
>>    %m\n");
>>     > > +        error_report("Could not access KVM kernel module: =
%m");
>>     > >           ret =3D -errno;
>>     > >           goto err;
>>     > >       }
>>     > > @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>>     > >           if (ret >=3D 0) {
>>     > >               ret =3D -EINVAL;
>>     > >           }
>>     > > -        fprintf(stderr, "kvm version too old\n");
>>     > > +        error_report("kvm version too old");
>>     > >           goto err;
>>     > >       }
>>     > >
>>     > >       if (ret > KVM_API_VERSION) {
>>     > >           ret =3D -EINVAL;
>>     > > -        fprintf(stderr, "kvm version not supported\n");
>>     > > +        error_report("kvm version not supported");
>>     > >           goto err;
>>     > >       }
>>     > >
>>     > > @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>>     > >       } while (ret =3D=3D -EINTR);
>>     > >
>>     > >       if (ret < 0) {
>>     > > -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d
>>    %s\n", -ret,
>>     > > -                strerror(-ret));
>>     > > +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", =
-ret,
>>     > > +                    strerror(-ret));
>>     > >
>>     > >   #ifdef TARGET_S390X
>>     > >           if (ret =3D=3D -EINVAL) {
>>     > > -            fprintf(stderr,
>>     > > -                    "Host kernel setup problem detected.
>>    Please verify:\n");
>>     > > -            fprintf(stderr, "- for kernels supporting the
>>    switch_amode or"
>>     > > -                    " user_mode parameters, whether\n");
>>     > > -            fprintf(stderr,
>>     > > -                    "  user space is running in primary
>>    address space\n");
>>     > > -            fprintf(stderr,
>>     > > -                    "- for kernels supporting the
>>    vm.allocate_pgste sysctl, "
>>     > > -                    "whether it is enabled\n");
>>     > > +            error_report("Host kernel setup problem =
detected.
>>     >
>>     > \n"
>>     >
>>     > Should we use error_printf_unless_qmp() for the following?
>>    Do you believe that qemu_init() -> configure_accelerators() ->
>>    do_configure_accelerator,() -> accel_init_machine() -> kvm_init()  =
can
>>    be called from QMP context?
>> To clarify, that is the only path I saw that calls kvm_init()
>=20
> We don't know whether this code can end refactored or not.

Ok personally I think we can cross the bridge when we get there.

> Personally I rather consistent API uses, since snipped of
> code are often used as example. Up to the maintainer.

OK up to Paolo then :-)=20

>=20
>>     >
>>     > " Please verify:");
>>     > > +            error_report("- for kernels supporting the
>>    switch_amode or"
>>     > > +                        " user_mode parameters, whether");
>>     > > +            error_report("  user space is running in primary
>>    address space");
>>     > > +            error_report("- for kernels supporting the
>>    vm.allocate_pgste "
>>     > > +                        "sysctl, whether it is enabled");
>>     > >           }
>>     > >   #elif defined(TARGET_PPC)
>>     > >           if (ret =3D=3D -EINVAL) {
>>     > > -            fprintf(stderr,
>>     > > -                    "PPC KVM module is not loaded.
>>     >
>>     > \n"
>>     >
>>     > Ditto.
>>     >
>>     > " Try modprobe kvm_%s.\n",
>>     > > -                    (type =3D=3D 2) ? "pr" : "hv");
>>     > > +            error_report("PPC KVM module is not loaded. Try
>>    modprobe kvm_%s.",
>>     > > +                        (type =3D=3D 2) ? "pr" : "hv");
>>     > >           }
>>     > >   #endif
>>     > >           goto err;
>>     > > @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
>>     > >                           nc->name, nc->num, =
soft_vcpus_limit);
>>     > >
>>     > >               if (nc->num > hard_vcpus_limit) {
>>     > > -                fprintf(stderr, "Number of %s cpus requested
>>    (%d) exceeds "
>>     > > -                        "the maximum cpus supported by KVM
>>    (%d)\n",
>>     > > -                        nc->name, nc->num, =
hard_vcpus_limit);
>>     > > +                error_report("Number of %s cpus requested =
(%d)
>>    exceeds "
>>     > > +                             "the maximum cpus supported by
>>    KVM (%d)",
>>     > > +                             nc->name, nc->num, =
hard_vcpus_limit);
>>     > >                   exit(1);
>>     > >               }
>>     > >           }
>>     > > @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>>     > >       }
>>     > >       if (missing_cap) {
>>     > >           ret =3D -EINVAL;
>>     > > -        fprintf(stderr, "kvm does not support %s\n%s",
>>     > > -                missing_cap->name, upgrade_note);
>>     > > +        error_printf("kvm does not support %s\n%s",
>>     > > +                     missing_cap->name, upgrade_note);
>>     >
>>     > Similarly, should we print upgrade_note using
>>    error_printf_unless_qmp?
>>     >
>>     > >           goto err;
>>     > >       }
>>     > >
>>     >



