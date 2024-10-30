Return-Path: <kvm+bounces-29983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CE19B5875
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 01:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63B581F24398
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 00:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EA214012;
	Wed, 30 Oct 2024 00:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="et+lIRlK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73818125DF
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 00:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730247425; cv=none; b=KNpnOlNDOVCCXJN+e3stxlIhkWBK7JA5kYDsqpDmYB3EtV+YzQ2Qe7u2OxsEk1+BEkT7ed2MNtTTv6xw5pLeT8wBcj043hQeZxTwdu9hLGqPxmjAfclVEPwJ37RL8KPlPBOJWFcGvkbh+EJj2uHiIFU7FbO56+kb9uM1LddJlKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730247425; c=relaxed/simple;
	bh=kL+nSJs/k5eiTKkckVjqUhseoyaNVTxIYCNgVKz9HcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHezEeN7mvlyjbT+ldeOtJBX1GWo336SSX/4fF4DdePC4nTWldnw7ryMViI8GCEaHa6N+HdRKYBjlWu8r8ga84urfjwfWwXP6fL9F7wGq7MKCXvQh7xgjuascLaYgpbfz7wr3clvCsmfJmwQTOV/jlJ8IRXzgpbQ+WDOZhQ0Mko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=et+lIRlK; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-460b295b9eeso73591cf.1
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 17:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730247422; x=1730852222; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCmWu47sjTGX3jar/Dwdhp+9K5zVvqpEnsEiRnQbuZ4=;
        b=et+lIRlKegBfC2h9/n31J6d8TJkbDu440N5TWTD2sNhhoMXP6vXEOMh/inA93j6+F4
         3DKkwv73/9t3NJyDIhv7jzemF2eXJg52P1ihLT74+/JXi0mWUeMhWG6qc3u+23ST3ebS
         U3OHCEnqPzwjWtDThAAH611SkFBuqkumpinc/ISUBCuOZu5yUTrNox1dpJ+4h0SbzhOS
         +SX/RqoypTPdwbV49RETbQL/htObPWplcinnvwcrw8vwp4JP0FFTsS4veGJK59w8BCYr
         wT0rwWxwDaw0dQ/Udb1H+q/AGncW8O2b+boe9voF0/54KyXRoNJ5CEOQw/sDUCzwhMe3
         beGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730247422; x=1730852222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCmWu47sjTGX3jar/Dwdhp+9K5zVvqpEnsEiRnQbuZ4=;
        b=O58D45VGHOONd3wN9mIEkf5B70eP0DGs0t0xEoK2dopdJt9qolUs6MJiM0sawtNYcj
         Efx4f8l2wRxta7fiGDfV0yywkpTEe/URxjWP+riAi9Sz+ixPjoMExtOYawyOG5vTLLMe
         UoW6bDMGx/PtLa57h/7Y6rBdkPILvHHwSAaTQr9BmPBmdr6ufgC+MJrEUnbBHivIfI++
         TQezDWwaCeg6HGW4ZRnZXHaj7sRuteHlYZjnT/u/qqS4RovgqA5NGcj4Cs02x3qDoNZQ
         OjZTJtC3OtUToMx9lN8RPT5Yin++rqILaOYylBqwEuKQfLKeR4/RzZNEuzsS+GVO4Sot
         0GDw==
X-Forwarded-Encrypted: i=1; AJvYcCULCptuGU2hoS7TmuH6EGOrImJyzq0bIluyhsMZlpCbrP/nK4oszxDW4qpUmkbl+cmt8vk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8UeFd4fB7xB2u2qfBr7Pc28XMEC5nvTPkySXKimd/ECTyflmE
	UMBYzguEwTIDcue6Hd6hRw2s1+4nTZGkLPliIc29kbAXg5jInSojfpAkWXOuUjssHWbHvdK03yY
	PvGetqGZdbM3HxzR0j1AROQWtM3+rlfFsqALy
X-Gm-Gg: ASbGncs9Z0cLfZu/PZC9tXmT5jZRsBPbsN8MDdWLRbThVdPaTuIeTFvmrpRq9DVFPRy
	eYmSyJ5/pMiyirFFM8ch5DsbD+QBuE0dA+o4+Sovohm0QuHCJjPF+n6PXgQsFKR0I
X-Google-Smtp-Source: AGHT+IEaPibastFimQxIGHeancJlv6kb2dWI4ioRIOkCpZsX0edKkHwzu5czUo3lz8BTR5AsStAJ1WI8kMngUNb28NI=
X-Received: by 2002:ac8:5d91:0:b0:460:48f1:5a49 with SMTP id
 d75a77b69052e-46164f057c4mr6157321cf.14.1730247422165; Tue, 29 Oct 2024
 17:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241028234533.942542-1-rananta@google.com> <868qu63mdo.wl-maz@kernel.org>
 <CAJHc60x3sGdi2_mg_9uxecPYwZMBR11m1oEKPEH4RTYaF8eHdQ@mail.gmail.com> <865xpa3fwe.wl-maz@kernel.org>
In-Reply-To: <865xpa3fwe.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 29 Oct 2024 17:16:48 -0700
Message-ID: <CAJHc60xQNeTwSBuPhrKO_JBuikqZ7R=BM5rkWht3YwieVXwkHg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Get rid of userspace_irqchip_in_use
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 29 Oct 2024 17:06:09 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Tue, Oct 29, 2024 at 9:27=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Mon, 28 Oct 2024 23:45:33 +0000,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > Did you have a chance to check whether this had any negative impact o=
n
> > > actual workloads? Since the entry/exit code is a bit of a hot spot,
> > > I'd like to make sure we're not penalising the common case (I only
> > > wrote this patch while waiting in an airport, and didn't test it at
> > > all).
> > >
> > I ran the kvm selftests, kvm-unit-tests and booted a linux guest to
> > test the change and noticed no failures.
> > Any specific test you want to try out?
>
> My question is not about failures (I didn't expect any), but
> specifically about *performance*, and whether checking the flag
> without a static key can lead to any performance drop on the hot path.
>
> Can you please run an exit-heavy workload (such as hackbench, for
> example), and report any significant delta you could measure?

Oh, I see. I ran hackbench and micro-bench from kvm-unit-tests (which
also causes a lot of entry/exits), on Ampere Altra with kernel at
v6.12-rc1, and see no significant difference in perf.

hackbench:
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Ran on a guest with 64 vCPUs and backed by 8G of memory. The results
are an average of 3 runs:

Task groups | Baseline | Patch | Approx. entry/exits
----------------|------------|--------- |------------------------
100              | 0.154     | 0.164  | 150k
250              | 0.456     | 0.458  | 500k
500              | 0.851     | 0.826  | 920k
(Total tasks for each row =3D=3D task groups * 40)

kvm-unit-tests micro-bench
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The test causes ~530k entry/exits.

Baseline:

name                                    total ns                         av=
g ns
---------------------------------------------------------------------------=
-----------------
hvc                                  20095360.0                          30=
6.0
mmio_read_user           110350040.0                         1683.0
mmio_read_vgic              29572840.0                          451.0
eoi                                        964080.0
        14.0
ipi                                   126236640.0                         1=
926.0
lpi                                   142848920.0                         2=
179.0
timer_10ms                          231040.0                          902.0


Patch:

name                                    total ns                         av=
g ns
---------------------------------------------------------------------------=
-----------------
hvc                                  20067680.0                            =
306.0
mmio_read_user           109513800.0                         1671.0
mmio_read_vgic              29190080.0                           445.0
eoi                                       963400.0
        14.0
ipi                                  116481640.0                          1=
777.0
lpi                                  136556000.0                          2=
083.0
timer_10ms                         234120.0                            914.=
0

Thank you.
Raghavendra

