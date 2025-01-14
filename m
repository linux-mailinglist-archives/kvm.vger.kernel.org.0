Return-Path: <kvm+bounces-35437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C7FA10FC3
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 19:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BB517A05C2
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB0F20F08A;
	Tue, 14 Jan 2025 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EXtm8zSi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3220CCC4
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736878644; cv=none; b=HC3gMugI4uVMpXeBZGFJ9ZPqAtNCMEkaQGGIPHQPtG798GweMSvLrRzPW4ukRgcekwbQk0OvAr2yYeSMnvu9MsF47ps73wPgR/0i+x/l+8nTfCvSjS1Of9mxJztIcEQ6Q/r7Ty/xyANfNLSwTgroXOeO5ov7F7lKEkhPdDRuqms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736878644; c=relaxed/simple;
	bh=I0aYHuk99JA9dU0puEhTqa+Ivu5XtOv7dOMzqH0MLLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lb1EW0Bqe7JGpl5pdIJUDPANhD5RBFDt0+At5syDS3mVempWlDovHPI+zhyVebvUoSNQoS7Uzt+byuYZodg2KzHrpA0J2l1r6+btbIartdld7eBWvgJf2YK+ukfkkeaSTirDrTX0GuplnY36C3bIXzbRixj+a1ZyjuBTxvsRnQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EXtm8zSi; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d9f0ab2313so10869a12.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 10:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736878641; x=1737483441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0aYHuk99JA9dU0puEhTqa+Ivu5XtOv7dOMzqH0MLLU=;
        b=EXtm8zSii3wekymY6ORkKD1JDrVoQy0ggWwTrHyXX1420b4Av/uuY4+JYYiI/hRnvC
         RNIP2ukp8w+O4wfnpBXLBqPL+GaCf3BBfI7manRZsEzpCActvfr9vHL6WJHR2DrG1CK+
         RS9jdbSS/RGqfs0DflA4BC5xAwWToQdtJU7mldacEsYAyVp/NmixwtYO1Pnw6XQEVrzm
         tGZmCJgHUquF5szQ0uPUbVEbPr/QXgRfUsBStXb/nrfkbDaAXA7x534l4fcegzZxzo7C
         kVD2oyGevrHY0bALQymcdJsfMNepU3LctjdMoMOxbb+s4stkse+Dzc07ObbgoO/Mtxiq
         K4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736878641; x=1737483441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I0aYHuk99JA9dU0puEhTqa+Ivu5XtOv7dOMzqH0MLLU=;
        b=Z6GfhcqvFJeEpddH9dxLaI/czgV155BiEI8SsqxLPMjAx/UfErCMFLpeXbG1uG9Fr0
         ZuhsQTeQLyizgANnwWWxZtnb1QPvoXHGxPEyAImG9RKyZcu/lcPNpDJLZlsUxbXrRZBy
         lTqcaG3euJzM0opZtLpZEGsY6CpIJSVPS3F5sf0K58N+TzNsnQV1mz/vaeZPzRARsxcJ
         xZHKR9niQ2FbZN4iipcbdRQeRgg5++ahgPYjqk/86fXKUIXFKu/fxToXLFzSbamKtdG+
         8kEzMD37I08YLnffkZ7fjXlxEW9etym7JO0n4gnJSNCZfWc5BduMu162hRvISmfcRt6O
         Cu6w==
X-Forwarded-Encrypted: i=1; AJvYcCV2Aa1a1lIlUUcxPzyFd5+QGjn/BWOx1HBZADFnOavL+/EYgRuveffKjAL0uIwlst9EE1M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqKE4z5xXCH/9HIyZyZ/iluAx7qyqq5DeAu3O12e1kj1bRZsxw
	z0JjoNN3nzMo2F0u1Dt2kM3bR6s7uIR9Zgkm6hYS8RRLl4k29I9Iwy0rZ/vLkTirxvXQ1N+jwY5
	elEJh5QN8jwEsmedq7quvKauL+tpRJb5bSnwt
X-Gm-Gg: ASbGncv+hgOO9wKAEEr9TqkERAoNtgry/Obpc9q3gRG6GsDEbLgAAzlMkAxCSBoGlJE
	+SwI149/lF2Gry7LEs/nFdBsLJ/dbm5RYtTrzxC3qChHDcg60ljc+yAJwuFpekPogBA==
X-Google-Smtp-Source: AGHT+IFOWOuSvDhgzEqoKb2CNkVmA/sXHofQ9hZDfWF+l4vbbQk0RN2k51cQSZIijLzKAw1RUyxlH5Nb9O1wedqOjko=
X-Received: by 2002:a50:d4d2:0:b0:5d1:22e1:7458 with SMTP id
 4fb4d7f45d1cf-5d9f695dda7mr124694a12.4.1736878640478; Tue, 14 Jan 2025
 10:17:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250114175143.81438-1-vschneid@redhat.com> <20250114175143.81438-30-vschneid@redhat.com>
In-Reply-To: <20250114175143.81438-30-vschneid@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 14 Jan 2025 19:16:44 +0100
X-Gm-Features: AbW1kvY7dNxOnvBqE7JSPz560QoJfBjiwfsZgS18MpZMQ07ZRC1TBr6Zwl5A-60
Message-ID: <CAG48ez1Mh+DOy0ysOo7Qioxh1W7xWQyK9CLGNU9TGOsLXbg=gQ@mail.gmail.com>
Subject: Re: [PATCH v4 29/30] x86/mm, mm/vmalloc: Defer flush_tlb_kernel_range()
 targeting NOHZ_FULL CPUs
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	virtualization@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-perf-users@vger.kernel.org, xen-devel@lists.xenproject.org, 
	kvm@vger.kernel.org, linux-arch@vger.kernel.org, rcu@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, bpf@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, Juergen Gross <jgross@suse.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.amakhalov@broadcom.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Liang, Kan" <kan.liang@linux.intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Clark Williams <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, 
	Tomas Glozar <tglozar@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Shuah Khan <shuah@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Samuel Holland <samuel.holland@sifive.com>, Rong Xu <xur@google.com>, 
	Nicolas Saenz Julienne <nsaenzju@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Yosry Ahmed <yosryahmed@google.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Jinghao Jia <jinghao7@illinois.edu>, 
	Luis Chamberlain <mcgrof@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Tiezhu Yang <yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2025 at 6:51=E2=80=AFPM Valentin Schneider <vschneid@redhat=
.com> wrote:
> vunmap()'s issued from housekeeping CPUs are a relatively common source o=
f
> interference for isolated NOHZ_FULL CPUs, as they are hit by the
> flush_tlb_kernel_range() IPIs.
>
> Given that CPUs executing in userspace do not access data in the vmalloc
> range, these IPIs could be deferred until their next kernel entry.
>
> Deferral vs early entry danger zone
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This requires a guarantee that nothing in the vmalloc range can be vunmap=
'd
> and then accessed in early entry code.

In other words, it needs a guarantee that no vmalloc allocations that
have been created in the vmalloc region while the CPU was idle can
then be accessed during early entry, right?

