Return-Path: <kvm+bounces-7038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B2D83D1D6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 02:00:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A5A6292D6A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 01:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2781A524F;
	Fri, 26 Jan 2024 01:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXtUAFSa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0236399
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 01:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706230839; cv=none; b=HC1U0o4y7ZzRF3T1naOn2Om2k5XWSpDZiUtK+Aoaj/JI9VJfHz2+aCRXCSdyJsdo60bO9xks8iRJ4qtSiIPOtJfhbgq1zJz/C7Et4y/X6LuSFSHGugpR/HQt+Kkb32GZuKVeyWWNAFn3ZLaEW5E9p9vY5YpZ9qbwIx2XIQSzwbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706230839; c=relaxed/simple;
	bh=b1EysaVqnVOuKJxM2IaK/TxCQ3p1ykl4Repgjoi2kfQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CDI/MkyzLeui6ZEKMeyuOCioSrQYmi/EXvHvRaTkR4w0OzUK6uW5mPB/6vqTzsjG1t1xn8KieytbmPelRAV00m4i0poIwu5KccTk99bCFMC3ezxaY5tnfrdrGBjFUCDKUQXDmRvmtNBQ7yxPLqL11hpdauIduaYFahOBEQ8XZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXtUAFSa; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-55c89dbef80so3665a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 17:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706230836; x=1706835636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoRz9Pe9GXZ+r6gty+528GFeZ2jb+Iln87IYuPoUJm4=;
        b=uXtUAFSavHIAlokoD9ChlZDw7bcCC+GKxtYPDXbA1y5/qumtsgjcvjZSKg+CiZuLlN
         /+JmWcwoKoUeB9+XaTjDqH/bIFe1jF1RM899+YUvG7Kb/l6RmyLSuzfmGBMvc3tQiDnh
         DC1CV3IAsMYbUI+jiS5K8LHygztIGmUxR2E6UwphAc0/8siFIROE099EhkgYtv47fQfg
         uT1ESirUBpk1zo4Qv4eASm1FzeCPYu6TRi12+dtMZCWwFHxhVwbR2JClK4/4vgbnrgir
         rYGpQ9pUAaAkfOHx3+r0CKS7Izh4bULrfIw27XQQDIH1BmJGJIF8D5SOCPf7tG5lU4DH
         5sIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706230836; x=1706835636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UoRz9Pe9GXZ+r6gty+528GFeZ2jb+Iln87IYuPoUJm4=;
        b=AeHhZ2YxD6yRWWW/OA7huqJGYdTXOhhb9d6gQHPOgElXAT3Y3L4SjOkDwBJ6+ifyLI
         2EVTD+ju2mILVK+ZJCtZFJUpsvUP6CW7Wmgi2Aa81EHnHwjQAr4X4iEYlT2Z4vlTq7D6
         WzFUT/mRNlEu3QsMcyPHx+kr9dj7AUKXORPYxD+t9cpGqjShFYW4i8Aj5GjMieKw82ZX
         M8J+ivW3IrvQZx6juZtT6yIexQ0E/HktZnGdCHD0VF+pmNT3kC3dJMlGcWFl9aKKW26i
         aAECV9RQvp0XAaarLdlJ/Wl9z8QxPgY16/IUmuS0a1leTS928MWRSKebp/v5LK8j6blZ
         pPtw==
X-Gm-Message-State: AOJu0YzQTQzHae7sH1gJyTxUjR+b6Jbefk4SqBYcJhfe5Pvz7gZIsi6t
	iCdexdpApgGOGO47txMSc/8EIRUv/ElITGpNgcE+3bsGTMljHYGp5k7/RGU4PH1LZvwOZ65MSBK
	w3aP15gUtsgJ2BiLzickoHX4/EcUt8S+kslyq
X-Google-Smtp-Source: AGHT+IGL6rWZU5v103N0xcbcUzq2l0nfavM24hYp0Ft0qdPxvPUH9Pfo6QzVp+PC4QsbaCA/ecx9XWSzUb/uCr9Bg04=
X-Received: by 2002:a05:6402:b6f:b0:55c:e4da:760d with SMTP id
 cb15-20020a0564020b6f00b0055ce4da760dmr48283edb.1.1706230835791; Thu, 25 Jan
 2024 17:00:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220151358.2147066-1-nikunj@amd.com> <8cd3e742-2103-44b4-8ccf-92acda960245@amd.com>
In-Reply-To: <8cd3e742-2103-44b4-8ccf-92acda960245@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 25 Jan 2024 17:00:22 -0800
Message-ID: <CAAH4kHZ8TWbWtf2_2DjEQosO8M08wD-EvaEsBKrXmPUaiFg+ug@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] Add Secure TSC support for SNP guests
To: nikunj@amd.com
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 10:08=E2=80=AFPM Nikunj A. Dadhania <nikunj@amd.com=
> wrote:
>
> On 12/20/2023 8:43 PM, Nikunj A Dadhania wrote:
> > Secure TSC allows guests to securely use RDTSC/RDTSCP instructions as t=
he
> > parameters being used cannot be changed by hypervisor once the guest is
> > launched. More details in the AMD64 APM Vol 2, Section "Secure TSC".
> >
> > During the boot-up of the secondary cpus, SecureTSC enabled guests need=
 to
> > query TSC info from AMD Security Processor. This communication channel =
is
> > encrypted between the AMD Security Processor and the guest, the hypervi=
sor
> > is just the conduit to deliver the guest messages to the AMD Security
> > Processor. Each message is protected with an AEAD (AES-256 GCM). See "S=
EV
> > Secure Nested Paging Firmware ABI Specification" document (currently at
> > https://www.amd.com/system/files/TechDocs/56860.pdf) section "TSC Info"
> >
> > Use a minimal GCM library to encrypt/decrypt SNP Guest messages to
> > communicate with the AMD Security Processor which is available at early
> > boot.
> >
> > SEV-guest driver has the implementation for guest and AMD Security
> > Processor communication. As the TSC_INFO needs to be initialized during
> > early boot before smp cpus are started, move most of the sev-guest driv=
er
> > code to kernel/sev.c and provide well defined APIs to the sev-guest dri=
ver
> > to use the interface to avoid code-duplication.
> >
> > Patches:
> > 01-08: Preparation and movement of sev-guest driver code
> > 09-16: SecureTSC enablement patches.
> >
> > Testing SecureTSC
> > -----------------
> >
> > SecureTSC hypervisor patches based on top of SEV-SNP Guest MEMFD series=
:
> > https://github.com/nikunjad/linux/tree/snp-host-latest-securetsc_v5
> >
> > QEMU changes:
> > https://github.com/nikunjad/qemu/tree/snp_securetsc_v5
> >
> > QEMU commandline SEV-SNP-UPM with SecureTSC:
> >
> >   qemu-system-x86_64 -cpu EPYC-Milan-v2,+secure-tsc,+invtsc -smp 4 \
> >     -object memory-backend-memfd-private,id=3Dram1,size=3D1G,share=3Dtr=
ue \
> >     -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,=
secure-tsc=3Don \
> >     -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram=
1,kvm-type=3Dsnp \
> >     ...
> >
> > Changelog:
> > ----------
> > v7:
> > * Drop mutex from the snp_dev and add snp_guest_cmd_{lock,unlock} API
> > * Added comments for secrets page failure
> > * Added define for maximum supported VMPCK
> > * Updated comments why sev_status is used directly instead of
> >   cpu_feature_enabled()
>
> A gentle reminder.
>

From the Google testing side of things, we may not get to this for
another while.

> Regards
> Nikunj
>


--=20
-Dionna Glaze, PhD (she/her)

