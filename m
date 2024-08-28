Return-Path: <kvm+bounces-25247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D9B96275E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D58A8285E3A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F1717799F;
	Wed, 28 Aug 2024 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+0DU64U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938E1175D4B
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724848845; cv=none; b=AEMDAbElE8ksQzlp+mjqqfxj4+0kdw20YREdFzA5SxgLd4GvZP0mmOSMV0Kfi8uoyLoCYwadabt9WrJu0lcdEf20ruvp02bmziyO/2ha1T2xpSH37F9J0HUTeTHyMHgAFr8iRPg9UwDBX3vQssbv8k4IYQTsNeZ0EIrjg0OGrE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724848845; c=relaxed/simple;
	bh=3Q5IIGuIhGG53S9GSmDJefe9WGJ4h3uAzUcC4jnAq/4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ATwgK/90EHyqz4dBK8ndCM/B2Ki8X3rOBzz6Jg0BesgvGROjy2SdG7xvch3JHHg/+l1XZLahmhGmEsbUz9eG0ZbOfh7pWNxcKimM9nubYhyb8KaW+can+wfDyU2O6CWrIerSm1RF1EfMPQUvcLWseZNGTPy7j7cD2dXA2wbydbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C+0DU64U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724848842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Uc9V6Z9gsEBagLDtoMdvf9aNrKWRZsqunldE/a+zhwg=;
	b=C+0DU64UiVyixUU9iKKSplT7dO8GtgKlJfazOjDI39ucHBCHsIsIpot6P8hLPVJVhJa6Qb
	V+CH+mP7gaQ+imdioI8KpeBABJ41PPltv9tHC0TknySwXfM1eX/a5GKHSonwjYEOstBXs2
	4LpR2rMeK57HxJ5tICa9iGjVm/D4Jxw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-2TSfqia_Pdysn8-ixKgYlw-1; Wed, 28 Aug 2024 08:40:41 -0400
X-MC-Unique: 2TSfqia_Pdysn8-ixKgYlw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-7c6b192a39bso5760230a12.2
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724848840; x=1725453640;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uc9V6Z9gsEBagLDtoMdvf9aNrKWRZsqunldE/a+zhwg=;
        b=K1W8uni4eBSiMW4ku1A6Oei4Uz9mOoLwXWeR/RwQANgbXCfRYzzX9XMuE+6IjWMbrB
         2unrhnUcC0LBe2haCKgLDQd+p/+fhxvoxeRjx95SCqWQAUxVI7Zg9uj6kgdqdRmx3MhP
         n9RFvsIKJSWiGXWL/ibjK3dwXMzJAZLzoigKL29eAaTnUTaJfKS/Xel2MeE5w8G15zLI
         Ogti/KLSyvi2Pdy1N18Dajg1hnVQHHpTfn9/BBUJ+S0YZgkFDnF0nk9ebWHaCP8NS/jF
         LKQ5gQ2Bk9c+g3MbyPAgQ0psE6ttztuHSLTd2muMNe8f01+HGJQDIFy5rlbPNomBEKzY
         bBAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuiAiwjR+rshhMH3ETzlYYGpUH2ra9FCavBtd68GFBV9NlFEalZN/KtPQF4XTcaCrvjAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtonJUAO1EXrsFT0DLMnyv6hrl+YLj13HoMzcV/BM5fUR1eP6S
	2YDINZ5Y2o3AheApyUzZvUma25hmO3VsVlDk9VoAx2rghqUZBHXacb8645Ps8jHC0mhM+4TLp4a
	mBDu3Ey/l8BE43M9f8AWf5EbHeXWheXP9NpVTRLF/8nO6RYrd5hGhIwNY8Ent
X-Received: by 2002:a05:6a20:cf90:b0:1c6:fb2a:4696 with SMTP id adf61e73a8af0-1cc89d6bac4mr16366395637.19.1724848839913;
        Wed, 28 Aug 2024 05:40:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2OkywfwyMS5jMSJTc/hbRwLB1qeRez6eb9hJnBZAq/ieouxWUiQeqH6pzUCsYQoGaTa9WeQ==
X-Received: by 2002:a05:6a20:cf90:b0:1c6:fb2a:4696 with SMTP id adf61e73a8af0-1cc89d6bac4mr16366374637.19.1724848839471;
        Wed, 28 Aug 2024 05:40:39 -0700 (PDT)
Received: from smtpclient.apple ([115.96.157.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385566490sm98202755ad.38.2024.08.28.05.40.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2024 05:40:38 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v5 1/2] kvm: replace fprintf with error_report()/printf()
 in kvm_init()
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <87ikvkriw3.fsf@pond.sub.org>
Date: Wed, 28 Aug 2024 18:10:24 +0530
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 qemu-trivial@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E66A6507-F348-49F9-8887-1CE24A5827EF@redhat.com>
References: <20240828075630.7754-1-anisinha@redhat.com>
 <20240828075630.7754-2-anisinha@redhat.com> <87ikvkriw3.fsf@pond.sub.org>
To: Markus Armbruster <armbru@redhat.com>
X-Mailer: Apple Mail (2.3776.700.51)



> On 28 Aug 2024, at 4:53=E2=80=AFPM, Markus Armbruster =
<armbru@redhat.com> wrote:
>=20
> Ani Sinha <anisinha@redhat.com> writes:
>=20
>> error_report() is more appropriate for error situations. Replace =
fprintf with
>> error_report() and error_printf() as appropriate. Cosmetic. No =
functional
>> change.
>=20
> Uh, I missed this last time around: the change is more than just
> cosmetics!  The error messages change, e.g. from
>=20
>    $ qemu-system-x86_64 -nodefaults -S -display none --accel kvm
>    qemu-system-x86_64: --accel kvm: Could not access KVM kernel =
module: Permission denied
>    qemu-system-x86_64: --accel kvm: failed to initialize kvm: =
Permission denied
>=20
> to
>=20
>    $ qemu-system-x86_64 -nodefaults -S -display none --accel kvm
>    Could not access KVM kernel module: Permission denied
>    qemu-system-x86_64: --accel kvm: failed to initialize kvm: =
Permission denied

You got this backwards. This is what I have:

Before:
$ ./qemu-system-x86_64 --accel kvm
Could not access KVM kernel module: No such file or directory
qemu-system-x86_64: --accel kvm: failed to initialize kvm: No such file =
or directory

Now:
$ ./qemu-system-x86_64 --accel kvm
qemu-system-x86_64: --accel kvm: Could not access KVM kernel module: No =
such file or directory
qemu-system-x86_64: --accel kvm: failed to initialize kvm: No such file =
or directory


>=20
> Note: the second message is from kvm_init()'s caller.  Reporting the
> same error twice is wrong, but not this patch's problem.
>=20
> Moreover, the patch tweaks an error message at [*].
>=20
> Suggest something like
>=20
>  Replace fprintf() with error_report() and error_printf() where
>  appropriate.  Error messages improve, e.g. from
>=20
>      Could not access KVM kernel module: Permission denied
>=20
>  to
>=20
>      qemu-system-x86_64: --accel kvm: Could not access KVM kernel =
module: Permission denied

Yes this seems correct.

>=20
>> CC: qemu-trivial@nongnu.org
>> CC: zhao1.liu@intel.com
>> CC: armbru@redhat.com
>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>> ---
>> accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>> 1 file changed, 18 insertions(+), 22 deletions(-)
>>=20
>> changelog:
>> v2: fix a bug.
>> v3: replace one instance of error_report() with error_printf(). added =
tags.
>> v4: changes suggested by Markus.
>> v5: more changes from Markus's comments on v4.
>>=20
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 75d11a07b2..fcc157f0e6 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>>     QLIST_INIT(&s->kvm_parked_vcpus);
>>     s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>>     if (s->fd =3D=3D -1) {
>> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
>> +        error_report("Could not access KVM kernel module: %m");
>>         ret =3D -errno;
>>         goto err;
>>     }
>> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>>         if (ret >=3D 0) {
>>             ret =3D -EINVAL;
>>         }
>> -        fprintf(stderr, "kvm version too old\n");
>> +        error_report("kvm version too old");
>>         goto err;
>>     }
>>=20
>>     if (ret > KVM_API_VERSION) {
>>         ret =3D -EINVAL;
>> -        fprintf(stderr, "kvm version not supported\n");
>> +        error_report("kvm version not supported");
>>         goto err;
>>     }
>>=20
>> @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>>     } while (ret =3D=3D -EINTR);
>>=20
>>     if (ret < 0) {
>> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", =
-ret,
>> -                strerror(-ret));
>> +        error_report("ioctl(KVM_CREATE_VM) failed: %s", =
strerror(-ret));
>=20
> [*] This is where you change an error message.
>=20
>>=20
>> #ifdef TARGET_S390X
>>         if (ret =3D=3D -EINVAL) {
>> -            fprintf(stderr,
>> -                    "Host kernel setup problem detected. Please =
verify:\n");
>> -            fprintf(stderr, "- for kernels supporting the =
switch_amode or"
>> -                    " user_mode parameters, whether\n");
>> -            fprintf(stderr,
>> -                    "  user space is running in primary address =
space\n");
>> -            fprintf(stderr,
>> -                    "- for kernels supporting the vm.allocate_pgste =
sysctl, "
>> -                    "whether it is enabled\n");
>> +            error_printf("Host kernel setup problem detected."
>> +                         " Please verify:\n");
>> +            error_printf("- for kernels supporting the"
>> +                        " switch_amode or user_mode parameters, =
whether");
>> +            error_printf(" user space is running in primary address =
space\n");
>> +            error_printf("- for kernels supporting the =
vm.allocate_pgste"
>> +                         " sysctl, whether it is enabled\n");
>>         }
>> #elif defined(TARGET_PPC)
>>         if (ret =3D=3D -EINVAL) {
>> -            fprintf(stderr,
>> -                    "PPC KVM module is not loaded. Try modprobe =
kvm_%s.\n",
>> -                    (type =3D=3D 2) ? "pr" : "hv");
>> +            error_printf("PPC KVM module is not loaded. Try modprobe =
kvm_%s.\n",
>> +                         (type =3D=3D 2) ? "pr" : "hv");
>>         }
>> #endif
>>         goto err;
>> @@ -2526,9 +2522,9 @@ static int kvm_init(MachineState *ms)
>>                         nc->name, nc->num, soft_vcpus_limit);
>>=20
>>             if (nc->num > hard_vcpus_limit) {
>> -                fprintf(stderr, "Number of %s cpus requested (%d) =
exceeds "
>> -                        "the maximum cpus supported by KVM (%d)\n",
>> -                        nc->name, nc->num, hard_vcpus_limit);
>> +                error_report("Number of %s cpus requested (%d) =
exceeds "
>> +                             "the maximum cpus supported by KVM =
(%d)",
>> +                             nc->name, nc->num, hard_vcpus_limit);
>>                 exit(1);
>>             }
>>         }
>> @@ -2542,8 +2538,8 @@ static int kvm_init(MachineState *ms)
>>     }
>>     if (missing_cap) {
>>         ret =3D -EINVAL;
>> -        fprintf(stderr, "kvm does not support %s\n%s",
>> -                missing_cap->name, upgrade_note);
>> +        error_report("kvm does not support %s", missing_cap->name);
>> +        error_printf("%s", upgrade_note);
>>         goto err;
>>     }
>=20
> With the commit message corrected:
> Reviewed-by: Markus Armbruster <armbru@redhat.com>



