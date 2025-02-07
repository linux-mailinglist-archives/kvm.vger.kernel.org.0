Return-Path: <kvm+bounces-37615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 794BAA2C9D1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C0DC7A6DB1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4967019F462;
	Fri,  7 Feb 2025 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QBFtMVtr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06EA192D80
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738948019; cv=none; b=YQMv06peT1feBwxmzUi0Bs8k5MUDNg68ftYpx/F2SZzkz4WXLqpLjApQwWbNItPy09IR5o9LCyKUqIx/oaXoDhd7R+L6DX/MjifQdPh1IjxHd+D/kwXB8a1fNPN2DPFTiV4CXt6pZsDVwUSjofckjczU24Y9z+dzR2QmBEyGSOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738948019; c=relaxed/simple;
	bh=I2e5fwjdOHrC389H955xUrW7Yt08enQx3eznrVoldiA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ok2ZLUrjWIGvD/e1J2mWY76MYcsEQe0x5kWurL+CrkVXLm9ndOwHIPNvbjR0JbeoiZQ3JloZ94hNQw75dxrT25QWOPaH5yDGQZPlY4We3BPEDRw+1c6yxmTHrwAufXJTaBII5IljPSe7W7hq1u7DI1PlFcFk/1p5yGme+HYC9yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QBFtMVtr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738948016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YX0Ta551pNoazXrou1rxJx7Jk32CWnG6aaI06lzcMPk=;
	b=QBFtMVtrJXtx2mGug91pMiEtiqY3nvfJ9xLiEVH0MvJBFa/Bf2ltTUyyAJBsEnb+QEBrL/
	km1Sh3uKMJkf2AEneT4sW6h7FYaGW0pHWDgdXJqu6NNoHGvQ3eN9mcP+jG1eT5auv2oPmZ
	77oU3LpD55nds/iIVBUEDd9hR4JE26w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-QL2Jnt58NoqBC9xhU_Pkmg-1; Fri, 07 Feb 2025 12:06:52 -0500
X-MC-Unique: QL2Jnt58NoqBC9xhU_Pkmg-1
X-Mimecast-MFC-AGG-ID: QL2Jnt58NoqBC9xhU_Pkmg
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38dcc9653a7so352561f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 09:06:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738948011; x=1739552811;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YX0Ta551pNoazXrou1rxJx7Jk32CWnG6aaI06lzcMPk=;
        b=bqPY1h2LdGmjdK05XzBdY7WCb/rQ/DUSvJaLFFMhK15EYhG6iRis3zt0z/M0+nyf5Y
         kO0DBI2TD6f5BSVEp8cpRvTAt/0aQUqAO6w5hmHeAL7x1I4ONfeCLQi/D5JM/yMpKFmI
         lOcWeQZr3mvkVfDa+rdKIBxqGhs79e7FvIwgPkHKKQLnF4HBYYzj02vEpH2drdTL8tlY
         GqzCNvD3/dxldutXnYT6ZLlhxrI9mPft97Jq9/ZJ8RnxdfzLp39AtUEa3MoM8gltHEJD
         2dbjcIOFBPrr3kqPA1vPM3ikYncPEci1TszWc5nkXVTXIMMgDzKbgjY4ucl4fq21awqS
         E1ag==
X-Forwarded-Encrypted: i=1; AJvYcCU48V4cvArm2zPjjF0hJ+MB+JWUAjzcdktW5tCoTxo80vDYbb1FkGlUvHztFBAAUlDL+UY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/UwzEg6kY4aGNFfSZbzD9JANkiEnU+sU+o/Mwx5/0A5QOhYRa
	GrZMqkdgKhb47/hfljqZxAIdvkVkM6Hpn136HBGV5hFk7OYIpj8AhyK2PXPobBjP585ebW/EtfI
	W1NEJXis8ojExrlnBPbcYBHtxhP7PBlB3LtLw3EgGyGyhIiZbcw==
X-Gm-Gg: ASbGncuDKNBFQIdlwpKJIzCESSUgK7J5ty6hidyBLVEJa031LISK6br8674yU8zyKSs
	6jPa7xsoBeApqzFwXA5mnNA/Myf4HNNMK+FVkEB3F90WVpHlwVxa9sd1m6TXQnoL7IWrN9yzxno
	At5dxsbU/wDpDXR3m1vbZCVkLifBSGI3Fe9IdxMsLJh1QE8niVYoH3QtqlzovcegrdKfzWEGS1x
	edbOZi3/b7d42OsvdudxCC1ygy+DUnm0iYfZq1cF0MI/xEdCWMkOtZ08J/2/LpjuJS3duGGq4f/
	UeoJUUl0rI71i+a+3A4QzPPD0NX3fTQnZQGwnNhdED3G4mqZ3AcdQfAxGp1v0YAM2A==
X-Received: by 2002:a5d:638d:0:b0:386:5b2:a9d9 with SMTP id ffacd0b85a97d-38dc9497d11mr1923984f8f.53.1738948011043;
        Fri, 07 Feb 2025 09:06:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOdkgTDMixdzesAbzZ6LQT5F1eKCI9U7dpB+ZFF0HwYFgHj2Fc571j17/M7jlf73QfQ/8NiQ==
X-Received: by 2002:a5d:638d:0:b0:386:5b2:a9d9 with SMTP id ffacd0b85a97d-38dc9497d11mr1923876f8f.53.1738948010215;
        Fri, 07 Feb 2025 09:06:50 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391dca0041sm59887155e9.14.2025.02.07.09.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:06:49 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
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
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Paul E. McKenney"
 <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>, Steven Rostedt
 <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, Neeraj Upadhyay
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
Subject: Re: [PATCH v4 22/30] context_tracking: Exit CT_STATE_IDLE upon
 irq/nmi entry
In-Reply-To: <xhsmh5xm0pkuo.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
References: <20250114175143.81438-1-vschneid@redhat.com>
 <20250114175143.81438-23-vschneid@redhat.com>
 <Z5A6NPqVGoZ32YsN@pavilion.home>
 <xhsmh5xm0pkuo.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Date: Fri, 07 Feb 2025 18:06:45 +0100
Message-ID: <xhsmhbjvdk7kq.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 27/01/25 12:17, Valentin Schneider wrote:
> On 22/01/25 01:22, Frederic Weisbecker wrote:
>> And NMIs interrupting userspace don't call
>> enter_from_user_mode(). In fact they don't call irqentry_enter_from_user_mode()
>> like regular IRQs but irqentry_nmi_enter() instead. Well that's for archs
>> implementing common entry code, I can't speak for the others.
>>
>
> That I didn't realize, so thank you for pointing it out. Having another
> look now, I mistook DEFINE_IDTENTRY_RAW(exc_int3) for the general case
> when it really isn't :(
>
>> Unifying the behaviour between user and idle such that the IRQs/NMIs exit the
>> CT_STATE can be interesting but I fear this may not come for free. You would
>> need to save the old state on IRQ/NMI entry and restore it on exit.
>>
>
> That's what I tried to avoid, but it sounds like there's no nice way around it.
>
>> Do we really need it?
>>
>
> Well, my problem with not doing IDLE->KERNEL transitions on IRQ/NMI is that
> this leads the IPI deferral logic to observe a technically-out-of-sync sate
> for remote CPUs. Consider:
>
>   CPUx            CPUy
>                     state := CT_STATE_IDLE
>                     ...
>                     ~>IRQ
>                     ...
>                     ct_nmi_enter()
>                     [in the kernel proper by now]
>
>   text_poke_bp_batch()
>     ct_set_cpu_work(CPUy, CT_WORK_SYNC)
>       READ CPUy ct->state
>       `-> CT_IDLE_STATE
>       `-> defer IPI
>
>
> I thought this meant I would need to throw out the "defer IPIs if CPU is
> idle" part, but AIUI this also affects CT_STATE_USER and CT_STATE_GUEST,
> which is a bummer :(

Soooo I've been thinking...

Isn't

  (context_tracking.state & CT_RCU_WATCHING)

pretty much a proxy for knowing whether a CPU is executing in kernelspace,
including NMIs?

NMI interrupts userspace/VM/idle -> ct_nmi_enter()   -> it becomes true
IRQ interrupts idle              -> ct_irq_enter()   -> it becomes true
IRQ interrupts userspace         -> __ct_user_exit() -> it becomes true
IRQ interrupts VM                -> __ct_user_exit() -> it becomes true

IOW, if I gate setting deferred work by checking for this instead of
explicitely CT_STATE_KERNEL, "it should work" and prevent the
aforementioned issue? Or should I be out drinking instead? :-)


