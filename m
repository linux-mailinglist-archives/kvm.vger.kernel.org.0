Return-Path: <kvm+bounces-36545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1A1A1B94A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30E3B161319
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 15:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEF619A288;
	Fri, 24 Jan 2025 15:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AlYu5wyl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D97D155C9E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737732168; cv=none; b=VIzN2o5WrOIf0T8KMRdpqDtHwb+7ZDGGf0xYW4Z6REdMAyBnSWJnvwX4YvwtJMv35TsDcDbxYzsu8njjbCIXqqWz630bLAqFBe4Ef1ixIIxsGjPXw+8J8P6qwlmKHM6YjTAmhkGBDgHfCUPYjt85Ot9KztVFJq8A7L+8g3kIls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737732168; c=relaxed/simple;
	bh=DwitzjRGQEzgyZZn0UD4LNiBUZsqGx1Qrum3CBb5LtE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=I7LnyflJhsqYWzDifCnSsz8v6vAvdq3s1Dkrt2dfx3EF6lyPeq1xFHJeOMc09ZkZ3s8stIPfFpBg1yJtjT6RVYIVsetkjXhYhIa+uZL30SYUhPfFNe/etjJZvz5FMqDbAhtKogMNLNbVR23EkSKKjgR6u4GfTOjsPflXM4jMeFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AlYu5wyl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737732164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DwitzjRGQEzgyZZn0UD4LNiBUZsqGx1Qrum3CBb5LtE=;
	b=AlYu5wylCVEvmaGCJoylwxj4kYhsZLifdnCnrsJLfyKiEiNysQ5opPenaJHdzb26ikUmrO
	RGI8ql0yXUMBoNws2XJhT3XV1/CJeA8T+nzGTj1kml6C2SBwgWqOxmTkiC7vASlWtffFzu
	nqmrIWuBqUi+auEllwgnpfYDB3rbLz4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-9kVkwWXWNuuyG2-NOcJEpA-1; Fri, 24 Jan 2025 10:22:35 -0500
X-MC-Unique: 9kVkwWXWNuuyG2-NOcJEpA-1
X-Mimecast-MFC-AGG-ID: 9kVkwWXWNuuyG2-NOcJEpA
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d88ccf14aeso35586156d6.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 07:22:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737732153; x=1738336953;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DwitzjRGQEzgyZZn0UD4LNiBUZsqGx1Qrum3CBb5LtE=;
        b=Zg3ZQ1h8gFYjf2LbpWDOF8rzeUjlg7BycqkS7DYwLbfPRuNgWrecaaoU0wzcuSknio
         7zo3HYgVXGMzlon6jFIn8bh542BqNYGQ79uq3Bn0eDi5sM8XQKlFiJClymFUfWEvHEka
         +957J7NyNeo1bYex0VEDrFnf7EBAW2dRrroFYGS66IBJynfiiuYqX6j30N48/McrkiA7
         AK9mvdEp1t9DDmkVJYLhrxQ1YyGcA97AlWUx/6W+wJoC5xue0z2p4rB1PhReSjYd4QpI
         hH+8I1Re5M46tTJg0dvZLnrNWBggXskpAzATxXGntLFcr2JZWeomZeNtpdjq1AICGhZo
         VFHg==
X-Forwarded-Encrypted: i=1; AJvYcCVPHVw/ywjzLcUYLw3ozF/v2W2DtZXpKNaPRBTLCJzCtzpBgN4TmML05TY6QgwRvXYQirQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSdY9SnUP3K8hMBrpC4Fe06HcQUxVmgbS5z8CP+U5OaqzXyqhy
	/aul9UU5o1LpaM3ydJlGo55hgeHshA9QUmi9vFkkQMSO1SA13A5EG+pdyhmL4jv+KgFrSIJD3ep
	6991r72I7pf58vs8ogJImXhqRS3fqmITO3giQAMtM4X/xjdhZ9Q==
X-Gm-Gg: ASbGncs6w41Fab1/6dsECk8qXQnOXJ40S81j4h6TUhvBzuGxDyNE8DZp9mjqZ+EBRVR
	7xqI41HwGMgh0o7IowsupeaqaIr/B3HrvZ2PR+mDuiYmyisgpMYr80oSegI6qGlx9DMPrxL+FV+
	VH5HsKD73B/+Nc/ip3FsjJxVQDwKiR/fxXeZRk0u2pFcCQ2SsKgpvqtxk69eH6oJbyhlIPKUHSO
	juDs+KTfJTZBLJGGvQkiZwMrqf/RYs0axCB3rWKTHI5HsM+Wo7f2q2RG+OZb427JkZNIW2bzhb/
	ktaE2Q3krq3Ejahzrxgl2hMCBWL6t31mu/eO++1pdLjclAAuv5FZc84=
X-Received: by 2002:a05:6214:1302:b0:6d8:861f:adca with SMTP id 6a1803df08f44-6e1b2235c9fmr497774356d6.42.1737732153309;
        Fri, 24 Jan 2025 07:22:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5TeadQAXYF5iUiWYdZcwN/B3B0GhQEA3OgvrN+YGY06rhpOtkdAXjp93P8gBhIIoKYtqxZQ==
X-Received: by 2002:a05:6214:1302:b0:6d8:861f:adca with SMTP id 6a1803df08f44-6e1b2235c9fmr497773786d6.42.1737732152904;
        Fri, 24 Jan 2025 07:22:32 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e2058c2a51sm9344776d6.109.2025.01.24.07.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 07:22:32 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Jann Horn <jannh@google.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
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
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Tomas Glozar <tglozar@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Kees Cook <kees@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Shuah
 Khan <shuah@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Miguel
 Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, "Mike
 Rapoport (Microsoft)" <rppt@kernel.org>, Samuel Holland
 <samuel.holland@sifive.com>, Rong Xu <xur@google.com>, Nicolas Saenz
 Julienne <nsaenzju@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Yosry Ahmed <yosryahmed@google.com>, "Kirill A. Shutemov"
 <kirill.shutemov@linux.intel.com>, "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>, Jinghao Jia <jinghao7@illinois.edu>, Luis
 Chamberlain <mcgrof@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH v4 29/30] x86/mm, mm/vmalloc: Defer
 flush_tlb_kernel_range() targeting NOHZ_FULL CPUs
In-Reply-To: <Z4_Sl-zu7GprkbaL@pc636>
References: <20250114175143.81438-1-vschneid@redhat.com>
 <20250114175143.81438-30-vschneid@redhat.com>
 <CAG48ez1Mh+DOy0ysOo7Qioxh1W7xWQyK9CLGNU9TGOsLXbg=gQ@mail.gmail.com>
 <xhsmh34hhh37q.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <Z4qBMqcMg16p57av@pc636>
 <xhsmhwmetfk9d.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <Z44wSJTXknQVKWb0@pc636>
 <xhsmhr04xfow1.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <Z4_Sl-zu7GprkbaL@pc636>
Date: Fri, 24 Jan 2025 16:22:19 +0100
Message-ID: <xhsmh8qr0p784.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 21/01/25 18:00, Uladzislau Rezki wrote:
>> >
>> > As noted before, we defer flushing for vmalloc. We have a lazy-threshold
>> > which can be exposed(if you need it) over sysfs for tuning. So, we can add it.
>> >
>>
>> In a CPU isolation / NOHZ_FULL context, isolated CPUs will be running a
>> single userspace application that will never enter the kernel, unless
>> forced to by some interference (e.g. IPI sent from a housekeeping CPU).
>>
>> Increasing the lazy threshold would unfortunately only delay the
>> interference - housekeeping CPUs are free to run whatever, and so they will
>> eventually cause the lazy threshold to be hit and IPI all the CPUs,
>> including the isolated/NOHZ_FULL ones.
>>
> Do you have any testing results for your workload? I mean how much
> potentially we can allocate. Again, maybe it is just enough to back
> and once per-hour offload it.
>

Potentially as much as you want... In our Openshift environments, you can
get any sort of container executing on the housekeeping CPUs and they're
free to do pretty much whatever they want. Per CPU isolation they're not
allowed/meant to disturb isolated CPUs, however.

> Apart of that how critical IPIing CPUs affect your workloads?
>

If I'm being pedantic, a single IPI to an isolated CPU breaks the
isolation. If we can't quiesce IPIs to isolated CPUs, then we can't
guarantee that whatever is running on the isolated CPUs is actually
isolated / shielded from third party interference.


