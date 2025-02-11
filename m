Return-Path: <kvm+bounces-37885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA1FA310DE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:13:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CC7C3A7190
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76F725A359;
	Tue, 11 Feb 2025 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i1HUBeyt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F14250C0F
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739290246; cv=none; b=PCDAqs2Z2SSnAapkQDQ5WaWUOKsBDJPKwhyg+TkhRog4WNcIa/oPfW1zHoqY0AQnVXpThMpfWKFGVMGBv5n6NuuIB+/R1OPiMNu9AjnPoFNx6EPBTa3sxS8B34dGspKtsKwOVGjYt7ogZrUlVF2hguiYKBzgfxgHaRPHptQfhgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739290246; c=relaxed/simple;
	bh=nE7GJqZw+gIEdhcV99Kpd2q5ds+/vCptECGTizt6klE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pGtP1JqZa5z52bvlwVafWrSk3ZMBm1/i+a+fLjta7Gtv6Dbfosz1oAPWJmDVrleBJLBFbc+jA42WCymv5Y8DknWAl0lD6qCGALghx5Bk6h0sa8wE6BIGcPqbgMEFEXs9ZQ1cySMgRfQ2y4u1h9BD6EXUKe0UD9O/Ja3l9gW7fXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i1HUBeyt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739290243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkXKKRZIZ3B6nMXAUQwqba2hAbiJWDhaRaBNOU6/fJw=;
	b=i1HUBeytVZQfuTjrexbgjP7YEuXhfQTbb6pRe91MQPsrHrNvdDzSOfyC/EERd6n8ZWPDjF
	+lZ5tsIl54r4itAaxVJ7JLggTgV7punI/95D8cHSFkAUzbdWyJUgYCJxsfKBbdpQAXbDp7
	n1YwDMda2zzuC6MFCw8XkhNYDMwIpOc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-1zSlL4vxNtaTvHS_G8EF4g-1; Tue, 11 Feb 2025 11:10:42 -0500
X-MC-Unique: 1zSlL4vxNtaTvHS_G8EF4g-1
X-Mimecast-MFC-AGG-ID: 1zSlL4vxNtaTvHS_G8EF4g
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-439385b08d1so22197005e9.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:10:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739290241; x=1739895041;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DkXKKRZIZ3B6nMXAUQwqba2hAbiJWDhaRaBNOU6/fJw=;
        b=ZjXeRttprdNbHDzMMRWvkW7XDoDL/wC6WyZ9mNBz7BWYAZPh4jaI0xeNVOM2BV7EwZ
         tv0QtBPQhgI7VlLxcD3Rgtbht03dDElbHaPOh86Gvb7hpol9y83Lp409myfQTvh3Wcd0
         SsGza7oxL0ZXtVnQmhcyY+tZGopKc9IV3LleZQkS4oUSnwDEUpoC/kmSbBX88sPDZEsn
         SZv7sQNqeUXxu+PSkH1BqdJWJnPrnWUooPxhCEYjMLRDxEik1QeLrhHnjV4hI3T1BPBI
         X+IUG+U4/q3mgpCe9GEgaXk7c2FNlWGsZcz9XwCyeHym5aACAWpIW4rVLKAFbjKX/qD8
         EtMg==
X-Forwarded-Encrypted: i=1; AJvYcCXgJ6NgIhcVOi+b0f0+5tljG/w088oGJW1ALRcMBfJAgnAXUHCCw6G12rk1TDDSu9K2PMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCKoq39ept8nijru+YrJBGsUqnA00+JHLB7bpVi7K8TAGrmZs3
	n833bTBk+cfDnz+viynyqvDXXb1astmElGz4Abp9fpMe9mh7DXJGgmAh0DXSWxZUWqdJEN1v6D+
	BrqvxboPENui2jwjCdOLdq3KbWED3tEmPi/s6fy6NQQHVm/ZgvQ==
X-Gm-Gg: ASbGncsyWGqOe32FGQU6KUqDXlSZ99NH7eCD2ZSOSMHaCWsd5IhlcmoQ1Hxp3sLsPa+
	goJTigQOlpwknnXC7rTjE3dA0MDRzRwLQxmI2e7EEJjceDMbfLGkmTFvPOs+diIcZEC3x75uJ56
	vmMSZPpD0l7A/kLD5fqL5j88aCsyJgTJsNLshhZZP7K55UYgRBI3neBtyb+H21KDX/m1ukotOh0
	DUzMRVG9VpN6i2iwCZCkTX+gEf4v/4VdhY7vyaR+2m6iqDnkHqOeDYXZU5ektDp7bfhhkfcamV3
	r9jQQw0uUzhQvvLY5ETp+Cd7OXy9xNNH8yB3MBoBzihGzWaWveeOG0Y+phsCl/rNWQ==
X-Received: by 2002:a05:600c:500b:b0:439:48d9:d8b0 with SMTP id 5b1f17b1804b1-43948d9dd41mr73108175e9.16.1739290240824;
        Tue, 11 Feb 2025 08:10:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxNXfn5PLr2I3O9shVB9BLvMIo6l6XNn4GHuv5+NRtXPlNDWEKqGeQnOp/tv15slnT46loqA==
X-Received: by 2002:a05:600c:500b:b0:439:48d9:d8b0 with SMTP id 5b1f17b1804b1-43948d9dd41mr73107295e9.16.1739290240325;
        Tue, 11 Feb 2025 08:10:40 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dc9ef8ac6sm12561610f8f.27.2025.02.11.08.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 08:10:39 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>, Jann Horn <jannh@google.com>
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
In-Reply-To: <352317e3-c7dc-43b4-b4cb-9644489318d0@intel.com>
References: <20250114175143.81438-1-vschneid@redhat.com>
 <20250114175143.81438-30-vschneid@redhat.com>
 <CAG48ez1Mh+DOy0ysOo7Qioxh1W7xWQyK9CLGNU9TGOsLXbg=gQ@mail.gmail.com>
 <xhsmh34hhh37q.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <CAG48ez3H8OVP1GxBLdmFgusvT1gQhwu2SiXbgi8T9uuCYVK52w@mail.gmail.com>
 <xhsmh5xlhk5p2.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <CAG48ez1EAATYcX520Nnw=P8XtUDSr5pe+qGH1YVNk3xN2LE05g@mail.gmail.com>
 <xhsmh34gkk3ls.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <352317e3-c7dc-43b4-b4cb-9644489318d0@intel.com>
Date: Tue, 11 Feb 2025 17:10:36 +0100
Message-ID: <xhsmhv7tgihs3.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 11/02/25 06:22, Dave Hansen wrote:
> On 2/11/25 05:33, Valentin Schneider wrote:
>>> 2. It's wrong to assume that TLB entries are only populated for
>>> addresses you access - thanks to speculative execution, you have to
>>> assume that the CPU might be populating random TLB entries all over
>>> the place.
>> Gotta love speculation. Now it is supposed to be limited to genuinely
>> accessible data & code, right? Say theoretically we have a full TLBi as
>> literally the last thing before doing the return-to-userspace, speculation
>> should be limited to executing maybe bits of the return-from-userspace
>> code?
>
> In practice, it's mostly limited like that.
>
> Architecturally, there are no promises from the CPU. It is within its
> rights to cache anything from the page tables at any time. If it's in
> the CR3 tree, it's fair game.
>
>> Furthermore, I would hope that once a CPU is executing in userspace, it's
>> not going to populate the TLB with kernel address translations - AIUI the
>> whole vulnerability mitigation debacle was about preventing this sort of
>> thing.
>
> Nope, unfortunately. There's two big exception to this. First, "implicit
> supervisor-mode accesses". There are structures for which the CPU gets a
> virtual address and accesses it even while userspace is running. The LDT
> and GDT are the most obvious examples, but there are some less
> ubiquitous ones like the buffers for PEBS events.
>
> Second, remember that user versus supervisor is determined *BY* the page
> tables. Before Linear Address Space Separation (LASS), all virtual
> memory accesses walk the page tables, even userspace accesses to kernel
> addresses.  The User/Supervisor bit is *in* the page tables, of course.
>
> A userspace access to a kernel address results in a page walk and the
> CPU is completely free to cache all or part of that page walk. A
> Meltdown-style _speculative_ userspace access to kernel memory won't
> generate a fault either. It won't leak data like it used to, of course,
> but it can still walk the page tables. That's one reason LASS is needed.

Bummer, now I have at least two architectures proving me wrong :-) Thank
you as well for the education, I really appreciate it.


