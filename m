Return-Path: <kvm+bounces-37865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD78A30D0C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED0D33A83BB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E632F2451F3;
	Tue, 11 Feb 2025 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PN0HethK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61F01FBEA9
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739280842; cv=none; b=GEP/06qAm4T0quO5lUS2toUxyiObVjrGlDPGZnxHoG7sSAu+51jmhR5Y1TOjo4gxMJtzM3p62KDs5FKtI6dx6U2szKcHpGjigq7tRktXY3bLWaZ81BUbUd3A3Htkjz6xrYqIxPwlbouHmWSBVDSsHoobfIg7XDv4BKkAh1+aam8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739280842; c=relaxed/simple;
	bh=I6rYC3Ttea935cxDKXU7eGhmr1cWrMQ3SYanZpPc/20=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VbZrsqRAg+LcAy7JMJSyNCKvgmNn6vcUTGgYc/h9UyHywSpm1psm8F0xK7ACa8o3mkSXspRReRkVqCJiOlTvk+hQrhhvXoLr2dMWnf5hWay5wA7XQi0y/Tys78b3755jJTNBJ3ni60Z4EBqqwPZyldMtXQ/9di39iwdWLqeYUNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PN0HethK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739280838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I6rYC3Ttea935cxDKXU7eGhmr1cWrMQ3SYanZpPc/20=;
	b=PN0HethKvYkcvHG6hz6HFjsztXKJt0k2qodq+Fy8VzY2k7RD6GR7GClMgiu97zMsWQ2o5d
	dSLl+adedNSSfGDCJUUAdZFcW15cZyiB+tuOIqvnPXdE32ogexkXjKLW4nlXSaKpm42STt
	lnrzbZxNlLY+FYHe1Qgox2n9rccBPLk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-12shRbuPMRSIqlG4iAdsXA-1; Tue, 11 Feb 2025 08:33:57 -0500
X-MC-Unique: 12shRbuPMRSIqlG4iAdsXA-1
X-Mimecast-MFC-AGG-ID: 12shRbuPMRSIqlG4iAdsXA
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43945f32e2dso15725225e9.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 05:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739280836; x=1739885636;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6rYC3Ttea935cxDKXU7eGhmr1cWrMQ3SYanZpPc/20=;
        b=TB3RXPWNmifnMUQ7tEYMilOH/e0d2zvKxgsNpQN+pdlVH2ExNb68Je9CaoqbRsV5Cr
         AVPiznUDUqmFxEEZYPKeydDeQo2/90P9KM0aWkzasKu9bsdpvpA5TkDjxxRtErckIdwf
         +MgH6ofaZ78pvTsxbbXIMJibSdSTw6VZzTdNxkPXUo7kIfEEiX7oRPg0uv7+J3H1nB6X
         NqvG6HhfO6EQWAONARcxj7xwZF9/o1bYFhEzsXIuNX97MoqaMZtNA/xBoMhyJeEDQNRg
         yq9S79sgKmN3Q1iXcKMKgtr+PhRv1olYTyEslokTzVYJKcFrAxII6FgvXHJpI/h9C3eL
         HCuA==
X-Forwarded-Encrypted: i=1; AJvYcCX4Fn1hb2IrMtiQlIhVgYETE2jNd031vnk1yM8VlCWSsWhftvccL4q3sSMaZAZnleCXlzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhvaZWt0vl/7Vy0QWsAAUJ+9lnMkw/+ffKAsBRvTkTaUbYanXy
	VcSAusJmAIXZEQLm3otq8XZJACqziHFVzoSiXKdpjL2eBnEIajK0PeLl5teyxaBt6OHP4Wj+z3z
	u5gGUIK0UU5VQBFshXl7kUAZunnjIaPZo1uNVEDvmlIu3JxDhhg==
X-Gm-Gg: ASbGncsHd4GOIQ04/AU3qUjmmaI5Jz4OdKaZJWWm628/sXITDyRQ3W6uh67/kQEbSu5
	GPLKnZ5QldV+HuGo/PPJr26XRmDxbOubF2KsA3+o/kBEuHeX6ZCeSAuY8mWBVxFblOPPSJ/HXZw
	jfBNdZztFdqmmqUM1DYwPN5ByhRvosazlqsmdIveyO4iIDjM+WpYqzhV2eNwrPaVxI30ewXZ4YZ
	FernHmplxgnZbIUkNG5nogpjlNQQMXb99jBhY9gUZtTDnoiNgxrHAeuhwvGARrRGFxPA5Z+0D9S
	wgJKtm4rg0ijPCQ9WNJZpYqeZ1j+q0pC0hToM7itxQvX1iQEsRMYKoI2zkm4z/4CZQ==
X-Received: by 2002:a05:600c:384c:b0:439:554f:f64f with SMTP id 5b1f17b1804b1-439554ffb3bmr21891855e9.0.1739280836478;
        Tue, 11 Feb 2025 05:33:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLaJ199QatUt+F367q7Ky9NspQydjwYuxDlEpx56Dm3c1ApLy01ntC7qxuc1s/8cawIiMmnw==
X-Received: by 2002:a05:600c:384c:b0:439:554f:f64f with SMTP id 5b1f17b1804b1-439554ffb3bmr21890805e9.0.1739280836017;
        Tue, 11 Feb 2025 05:33:56 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcb88d5e6sm11688621f8f.1.2025.02.11.05.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 05:33:55 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-perf-users@vger.kernel.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org, rcu@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
 bcm-kernel-feedback-list@broadcom.com, Juergen Gross <jgross@suse.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
 <alexey.amakhalov@broadcom.com>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, Paul
 Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>, Boris Ostrovsky
 <boris.ostrovsky@oracle.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Pawan
 Gupta <pawan.kumar.gupta@linux.intel.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason
 Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard
 Biesheuvel <ardb@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joel@joelfernandes.org>,
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang1211@gmail.com>, Juri Lelli <juri.lelli@redhat.com>,
 Clark Williams <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>,
 Tomas Glozar <tglozar@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Kees Cook
 <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph
 Hellwig <hch@infradead.org>, Shuah Khan <shuah@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>, Rong Xu <xur@google.com>,
 Nicolas Saenz Julienne <nsaenzju@redhat.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Yosry Ahmed <yosryahmed@google.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>, Jinghao Jia <jinghao7@illinois.edu>, Luis
 Chamberlain <mcgrof@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH v4 29/30] x86/mm, mm/vmalloc: Defer
 flush_tlb_kernel_range() targeting NOHZ_FULL CPUs
In-Reply-To: <CAG48ez1EAATYcX520Nnw=P8XtUDSr5pe+qGH1YVNk3xN2LE05g@mail.gmail.com>
References: <20250114175143.81438-1-vschneid@redhat.com>
 <20250114175143.81438-30-vschneid@redhat.com>
 <CAG48ez1Mh+DOy0ysOo7Qioxh1W7xWQyK9CLGNU9TGOsLXbg=gQ@mail.gmail.com>
 <xhsmh34hhh37q.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <CAG48ez3H8OVP1GxBLdmFgusvT1gQhwu2SiXbgi8T9uuCYVK52w@mail.gmail.com>
 <xhsmh5xlhk5p2.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <CAG48ez1EAATYcX520Nnw=P8XtUDSr5pe+qGH1YVNk3xN2LE05g@mail.gmail.com>
Date: Tue, 11 Feb 2025 14:33:51 +0100
Message-ID: <xhsmh34gkk3ls.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/02/25 23:08, Jann Horn wrote:
> On Mon, Feb 10, 2025 at 7:36=E2=80=AFPM Valentin Schneider <vschneid@redh=
at.com> wrote:
>> What if isolated CPUs unconditionally did a TLBi as late as possible in
>> the stack right before returning to userspace? This would mean that upon
>> re-entering the kernel, an isolated CPU's TLB wouldn't contain any kernel
>> range translation - with the exception of whatever lies between the
>> last-minute flush and the actual userspace entry, which should be feasib=
le
>> to vet? Then AFAICT there wouldn't be any work/flush to defer, the IPI
>> could be entirely silenced if it targets an isolated CPU.
>
> Two issues with that:
>

Firstly, thank you for entertaining the idea :-)

> 1. I think the "Common not Private" feature Will Deacon referred to is
> incompatible with this idea:
> <https://developer.arm.com/documentation/101811/0104/Address-spaces/Commo=
n-not-Private>
> says "When the CnP bit is set, the software promises to use the ASIDs
> and VMIDs in the same way on all processors, which allows the TLB
> entries that are created by one processor to be used by another"
>


Sorry for being obtuse - I can understand inconsistent TLB states (old vs
new translations being present in separate TLBs) due to not sending the
flush IPI causing an issue with that, but not "flushing early". Even if TLB
entries can be shared/accessed between CPUs, a CPU should be allowed not to
have a shared entry in its TLB - what am I missing?

> 2. It's wrong to assume that TLB entries are only populated for
> addresses you access - thanks to speculative execution, you have to
> assume that the CPU might be populating random TLB entries all over
> the place.

Gotta love speculation. Now it is supposed to be limited to genuinely
accessible data & code, right? Say theoretically we have a full TLBi as
literally the last thing before doing the return-to-userspace, speculation
should be limited to executing maybe bits of the return-from-userspace
code?

Furthermore, I would hope that once a CPU is executing in userspace, it's
not going to populate the TLB with kernel address translations - AIUI the
whole vulnerability mitigation debacle was about preventing this sort of
thing.


