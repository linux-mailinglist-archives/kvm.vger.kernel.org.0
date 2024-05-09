Return-Path: <kvm+bounces-17097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1008C0B59
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 08:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7029DB20F84
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 06:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F88149C74;
	Thu,  9 May 2024 06:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WEm/VoPd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D700A1494C6
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 06:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715235263; cv=none; b=R1I6huXM1zVM/78drb4dc4mNbTOZY6NHUSmedNkXYmI+LHH/28bmpKOpR+M2AxtQvmqXHivghgqzPVHtsZ76SaCs+arrzGcQWZtUM46rBrRoqI6M7O4q2MXH85kGplz2GIO34HxkXxb1t9ZyGNnuWmr2eF75nopL4z8geUyiQ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715235263; c=relaxed/simple;
	bh=EL59YAvQ+NejbE+MgsQ0pGcYE6qA6HsEuHDusaEk0N4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g80+BH94R5mKdOLBVH5hhHhMrWybYyKKti6DonXp06A3y+9/2pvraPmxyuADvmsOX2FKmmso2WF9T7+o6qntwzMxTpNf/8BXJJs39YHu2q+FiLfIQiYJLegkpX+1LMnD9uNLYcBTEtsjgEanFxsQ6veIc+0xSxjJEDKx14tT290=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WEm/VoPd; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5724736770cso4820a12.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 23:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715235259; x=1715840059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72bWBwjQodIuSi8MsUtQvKNvKwdUWjXGREUei480Xwo=;
        b=WEm/VoPdoWkj0T759QWiuYvMX4pHXbQGtGV6B8BdS6/Cq0VFDkresAaaMIYb++Xv07
         NGG+jf4a1dEnvAy0YaC/s7lcBHZYg4XfdFyn0UE/NSSxuV4NI+ONOzRkSN7wuCtF7G6m
         GTOO87BGuQVGfzWL5T65/lgJj6fjNzyMISuP7RyGnMi7ZT8v5eJ20/bJPOff/6tMEzYf
         htFF4m10x/m7ACoxg+H+qSKb1axBk/xf7pNTnIFlBhJxau06TJtioZB85NLY3yGUoNGf
         qsBS4tNQxQMxJEtkUampvrB3zly877wqooUCzxdQkmiqESGQ2AKpeP3mEO/CMSG07Le0
         wmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715235259; x=1715840059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72bWBwjQodIuSi8MsUtQvKNvKwdUWjXGREUei480Xwo=;
        b=vX/PXtSUlCMS6p89RAznfAIhO+/gQ9bFzimi+l4xlOSgORvdppBFbEWLDVx+MVZ4/n
         l1XeQ3B7d23++ZsVL8n/RZeMzMf6pqVovufqJx0X9bCDiElvB7og143DBldULZWeyqHU
         h+vADGeKXwFVP46wWz775et0lI4KoQs7B2ZRjLEt2eJgHv/xJwKivZ+sFDbIhOfT9yKY
         P35wx9h1di88ZVQY/lt+znmxXJvuQnypWx6z5Iv5muQMVb3uxjsfdOJ6QsYEqiQGwf6r
         lC1eqJSdNp6okkmzaClwBPJUWlVkNk/acKy1Ut99PlmlEahNFY/er1Qu0ph7MkQBUP39
         Vq9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/VR9BpcsVP86y/0CHSdCEgqOFKZWuxPISUbJ02WZXTNc6oe17RaEloViLyl3D31Wy81UKmeHKmZjL1LAVGBACJAE5
X-Gm-Message-State: AOJu0YyR4jwoVIlE6JHe8BrG6QvWmOm9R5gdj0mc6vTvi0dIEC5BPdC0
	+DVSEuRYU8YtBJIHcUwYWQ7LYAyciiwvgj692tU9K4WPUPylWVKDPo5h4frshssnP6j31cRxu1V
	o514/Yx/m5LY4C4TJ2xrMfYZ5livh1VfhfmzK
X-Google-Smtp-Source: AGHT+IHsPAG0LEeM4cJXnAxgH06RrdZlxemOxK5bdPXtb66jyshH3jVsPNC7i5pX8kAB1x6smMgaq3eKTmHMEonCtFw=
X-Received: by 2002:a05:6402:5206:b0:572:a23b:1d81 with SMTP id
 4fb4d7f45d1cf-5733b9d3b3emr79412a12.5.1715235258767; Wed, 08 May 2024
 23:14:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507214254.2787305-1-edliaw@google.com> <f4e45604-86b0-4be6-9bea-36edf301df33@linuxfoundation.org>
In-Reply-To: <f4e45604-86b0-4be6-9bea-36edf301df33@linuxfoundation.org>
From: Edward Liaw <edliaw@google.com>
Date: Wed, 8 May 2024 23:13:51 -0700
Message-ID: <CAG4es9XE2D94BNboRSf607NbJVW7OW4xkVq4jZ8pDZ_AZsb3nQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Define _GNU_SOURCE for sources using
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Christian Brauner <brauner@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <keescook@chromium.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, Andy Lutomirski <luto@amacapital.net>, 
	Will Drewry <wad@chromium.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Seth Forshee <sforshee@kernel.org>, Bongsu Jeon <bongsu.jeon@samsung.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	=?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@android.com, 
	linux-sound@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-input@vger.kernel.org, iommu@lists.linux.dev, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-security-module@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-actions@lists.infradead.org, mptcp@lists.linux.dev, 
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 4:10=E2=80=AFPM Shuah Khan <skhan@linuxfoundation.or=
g> wrote:
>
> On 5/7/24 15:38, Edward Liaw wrote:
> > 809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
> > asprintf into kselftest_harness.h, which is a GNU extension and needs
> > _GNU_SOURCE to either be defined prior to including headers or with the
> > -D_GNU_SOURCE flag passed to the compiler.
> >
> > v1: https://lore.kernel.org/linux-kselftest/20240430235057.1351993-1-ed=
liaw@google.com/
> > v2: add -D_GNU_SOURCE to KHDR_INCLUDES so that it is in a single
> > location.  Remove #define _GNU_SOURCE from source code to resolve
> > redefinition warnings.
> >
> > Edward Liaw (5):
> >    selftests: Compile kselftest headers with -D_GNU_SOURCE
> >    selftests/sgx: Include KHDR_INCLUDES in Makefile
>
> I appled patches 1/5 and 2.5 - The rest need to be split up.
>
> >    selftests: Include KHDR_INCLUDES in Makefile
> >    selftests: Drop define _GNU_SOURCE
> >    selftests: Drop duplicate -D_GNU_SOURCE
> >
>
> Please split these patches pwe test directory. Otherwise it will
> cause merge conflicts which can be hard to resolve.

Hi Shuah,
Sean asked that I rebase the patches on linux-next, and I will need to
remove additional _GNU_SOURCE defines.  Should I send an unsplit v3 to
be reviewed, then split it afterwards?  I'm concerned that it will be
difficult to review with ~70 patches once split.

