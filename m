Return-Path: <kvm+bounces-59782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CC6BCE689
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 21:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A9B119E081C
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 19:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03513016E0;
	Fri, 10 Oct 2025 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UjMQUTNw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020122FE571
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760125140; cv=none; b=gZqDA9cRq+HPHBBDDirJXcqbB4G+xGKC3grQbqPXha7LA+XBvgyVgnfCfJP+aTZsOQpW+xnpciTqB51wYRGQnPxJakKshcLmYIIIEzfrJ9/ltrJopjPSvhb6kAkjpCF6CMPp0fIsue94wOHXfM3Y4WSVZqUFL1n5GFI+5pq51Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760125140; c=relaxed/simple;
	bh=paRUeA0Q8aNKiUJJNXbdcpKV+MxyQuLaa5qB2qCiaUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RDyJU66cL9Ba3QMb57pipcY2iv1+nK5CaC9nOLZSYPa81V+3QeW4dWfXee238pG8TUX7rVcpZndfjSE4nOSHfJBMB22fLdtg5RJ7RYu9aZGxPQ9DPU2V8Z/0FCYqmKkIVInZ4DrRVl6KIJxelEQxtgKZo4XTTUqSgUfrf+bcF74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UjMQUTNw; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e3bcf272aso12055e9.0
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 12:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760125137; x=1760729937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G42i/u8MRJ9M6Twy2bIRqjYAwcznw/QdFBR+ThWzAOg=;
        b=UjMQUTNwyJs1sqXPpb2VLyX677HFoPvxw2EnpX6KMAcDB55KlkjHluKPpXIL0OJQUy
         2Q0+koc0eDMRisTki0OAS3UB+2brXd4nTAhf1TuLtC7RMS/cUXQOpfCSu/w09n41Zo8d
         W/ZUs2gLD+/bC0+vPni0G7q585aZqYyWTXx8jYSi1M38aIwB3O8bL8kKi9E/RcLg3BXQ
         AQ9eJTAk+VdNSGLLDIKtJfUHHhVJFz9H4UrUKnsAsiM0nw3pPAJXI9mz+YN4vmFwoGbz
         7NWTwtZu0UGYra94zSYkqA7VYKZ0ZHo3cpQ3EWuvXzWnyo/sx4Q2qAugYqIi3/79V0YN
         P32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760125137; x=1760729937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G42i/u8MRJ9M6Twy2bIRqjYAwcznw/QdFBR+ThWzAOg=;
        b=m7IJRUlkviG+s4+gEE81f6T5glct0drKLhUW0167OplsuOF+WsVuVqUJuRlPssxdd6
         bPyW/uhMnAYCVq0JgzPT9NbljN0m/3hyEy9VzNKmg1V4V70Sh36WlmjG4gYWYCgkTnBO
         VQB0ijkJ1Iq1jSe+62z/GL2mGJwFlDO4k/9DCcisRIIj5pIZRsMNjHppDQh/So5pMznQ
         OrnNhnQso/8SvY+3IfwhCM8QxB7gnNyjX+J73c51NgFwV2hTvnmt9QXFXYynKGBWxmea
         hniXUlZ2En4xL54agVdDa1j3kbRHHHexQAVX/utDzH226VJVY+KJw36lgBbwc8JxfGZR
         1qDQ==
X-Gm-Message-State: AOJu0YzxQ3cad2/zFRJkJ0inivG6ANl76gvpplL/iFOYPbv0GmRBulhD
	M5nHdl16UQgQUwjGIRimgcsI0heXP4BYmTR7h0p2yFMu+hqGsYjZWwfJ676D73XNe+N9kSRxjdB
	hdojh5M/V3nyb8VJt4X6IQ7m89tPsxMdKca67hBq3
X-Gm-Gg: ASbGncvxEtdA1VJVoN4djPC9ivEXST3RhIqLM+wf4t3LGyXSN0H6CpM9SSt3fKDUUYV
	JM1fMSQFYDbnmn/GRQFrpJgQXYIBWHeW4QEzCWHuvHCRB6NrA6lokZfvrXqb5EL+DDW+hJWhrub
	FAM6SLYrUHbhgNM+A0C9jvszi2hbhtdmXtEaQXWrqonmg4+TyDPH8cKHTX7zgp8cwKxzBRFFS5S
	i3DEHNPyaxh9Do0Qo927rdGTWR2v92wLKhdTrgBu5ABzfZfrLPiCHpOr7rTjTHmeOdWr4yzwQ==
X-Google-Smtp-Source: AGHT+IHIodl2NROYEXh/33nRBxbfEbLDzR8sSJgEr+hrINiKOgEMjhQA45bKdj70j3vWXJWBDjRujP7bStH4hSJ2gwQ=
X-Received: by 2002:a05:600c:c1d7:20b0:45d:f6a6:a13e with SMTP id
 5b1f17b1804b1-46fa9a94635mr7264035e9.1.1760125137119; Fri, 10 Oct 2025
 12:38:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-10-vipinsh@google.com>
 <DDEJY5ON407O.2O7CMOY9311NV@google.com> <aOlM7ngJJsEW-5sV@google.com>
In-Reply-To: <aOlM7ngJJsEW-5sV@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 10 Oct 2025 12:38:19 -0700
X-Gm-Features: AS18NWBZyUvCG4kU2gu0uAzSe3onaIPRVz7Z1T1oN44tuheRWwvOLEuzuPBM3VY
Message-ID: <CAHVum0e9fFfivmDg2N9VvWQfPdc4DfV0_qEhrRaFQXFjhr8LRA@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
To: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev, 
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com, 
	kvm-riscv <kvm-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 11:14=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Oct 10, 2025, Brendan Jackman wrote:
> > To avoid confusing people and potentially leave the door open to a
> > cleaner integration, please can you add some bits here about how this
> > relates to the rest of the kselftest infrastructure? Some questions I
> > think are worth answering:
> >

It's a good point, I should write about how it compares with kselftest
infrastructure.

> > - As someone who runs KVM selftests, but doesn't work specifically on
> >   KVM, to what extent do I need to know about this tool? Can I still ru=
n
> >   the selftests "the old fashioned way" and if so what do I lose as
> >   compared to using the KVM runner?
>
> The runner is purely optional.  You'll lose whatever you don't have, that=
 the
> runner provides.  E.g. I have (hacky) scripts to run KVM selftests in par=
allel,
> but without much of the niceties provided by this runner.
>

For occasional contributors, it will provide opportunity to run the
default tests and run tests with different combinations of their
command line options. Overall, provides better test coverage and
confidence before sending patches upstream.

For regular contributors and maintainers, a fast execution of
selftests + more coverage. Runner allows them to configure output and
results as per their wish/workflows.

For everyone, to upload their interesting test combinations they use
so that the overall KVM community gets benefit out of it.

> > - Does this system change the "data model" of the selftests at all, and
> >   if so how? I.e. I think (but honestly I'm not sure) that kselftests
> >   are a 2-tier hierarchy of $suite:$test without any further
> >   parameterisation or nesting (where there is more detail, it's hidden
> >   as implementation details of individual $tests). Do the KVM selftests
> >   have this structure?
>
> More or less.
>
> >   If it differs, how does that effect the view from run_kselftest.sh?
>
> AFAIK, nothing in KVM selftests is at odds with run_kselftest.sh.
>
> > - I think (again, not very sure) that in kselftest that each $test is a
> >   command executing a process. And this process communicates its status
> >   by printing KTAP and returning an exit code. Is that stuff the same
> >   for this runner?
>
> Yes?  Except most KVM selftests don't support TAP (yet).

Here each test is executed in its own subprocess. Output of runner is
not in KTAP format, same for majority of the KVM tests.

Execution is any command written in *.test file, which is interpreted
as a command to execute in a shell. This allows us to write tests
which can run based on the resources on the host like number of vcpus
to use, how much memory to allocate, etc.

