Return-Path: <kvm+bounces-36014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A896A16DD5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB9B3A15AE
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 13:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F3D1E32A2;
	Mon, 20 Jan 2025 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HbMtC92I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88B21E1A3B
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737381211; cv=none; b=WAMW5A38S8MUObXsA349jqSyyxy5SYfeUhjIkJX2dL7BaP0W3QSzxJjbXFFP+k4ezKK1aD5xJnu66I/avDOe8/lL7gIjP+23NXRCDYiQu7p89MhUofGrj6A+K5SdMB5zjma34sQ+/xe/BdnFmlfIFjDvxstezSBG0+YB0ADJmco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737381211; c=relaxed/simple;
	bh=uxNVkuB1kfPiPhaAvJDAYwdoCzbbN5ig+MfWtinYkGs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AHU8q7D5cSs2uQvk5YmCjio5PUQn1Cz09fQ2Dck3X7DTCeepjdlCpVtwqzvpe4aBdI+XT4XguNZ//6eYsMWC7Bwv2OCOQTxI7EuS4GbxDcdsZj6FDN/wHAxgau9kUNezG9VaKpCSAxR8XT8aBrCitd4/W3bB/+yLxITiyoMBrTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HbMtC92I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737381209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6OUKdt6VXAQzpOTUFB26LmXUDO8O/oST+Zn2uKcAtKs=;
	b=HbMtC92IGEx8a976wcxW0kDoKugHnljw5CJ/V3bldO3EleSl4f8dkr/UxaQd0pGkdw7Vvs
	FLaOvwZFsd3RnEuOP3KbFH5VZ/Mo3jfZrt9VEpg7hpZnAL1LxkF1kfKPvTMoqshvadb4YN
	4Ooo0u4GxuufcBnly1qGnkquaO6lzww=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-j9g3Z6mJMlSRhbFPfVfmJA-1; Mon, 20 Jan 2025 08:53:27 -0500
X-MC-Unique: j9g3Z6mJMlSRhbFPfVfmJA-1
X-Mimecast-MFC-AGG-ID: j9g3Z6mJMlSRhbFPfVfmJA
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-468f80df8caso85758881cf.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 05:53:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737381207; x=1737986007;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6OUKdt6VXAQzpOTUFB26LmXUDO8O/oST+Zn2uKcAtKs=;
        b=TcphS+W8t82YHTozQSVO5Qu3lRTT3wI8rX0EV8nmFaaqmAT+e12+/qQfwI44/S4UUg
         v1F+hdjPQY/YggKmXqONXuE/x+q6IlR5EqJ0sMVlaJs8o2LzZL5eRom8RrUP45sjvXqN
         9/4IamMw5Mi7sUhzouca2+5o3t39mSQ1R5zp8QnQf/sY5C/AtC5g0Dque8uKHU3KdZAP
         6/6Kz4J1AENMmr/oIlBzy5wsSueXewqy1kfxnfHNBdIcxGqa6J+570m5sU4bJQbFsTAH
         k2DWIIf7JwpFH6EGy0OhpuhpemFdbRyN90PISjJJx35LSwLTjYslCHtF9o1r/MuDfgpo
         dzxA==
X-Forwarded-Encrypted: i=1; AJvYcCXM5d/RwzYLHWhPpWYej85bP/naUkWYSAmIkJscfpQko7ykLFnaSBI/JIzLuhTGXGXIMEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyS726rm9Df4keqFSFVZMYHDD02irJTmCpNnuapKiJJfPSRChz5
	UaCQeSmvfBA9EIrXFiq63TWuVdsz8aitROaCcmAGBJAOI8674IBLNA6xDZ/QkDTtrg/ZtrHOZJF
	8+IYxq+i7jWnFXE2JeBZUZbkbXrhQXoSDkkjZjspl4oaSPKjONg==
X-Gm-Gg: ASbGncteC4XjOkJR0lXVLM8K4aVlX0U0gjhZVgbZkDIW0ZU8FT3p2YPsAAwfgNBx4wP
	HHXknZotPzWmNzKGC7ayKSdVm5UI1FRgfSu8xSHpzIDw0N7CwkIBJr06721x6SC68Gttehk/CRw
	R0uiGdiuYh1npN3IOiUEyK/fVyPBU2smQPXU3O+lohFFXKza3HYJ/YqJAl8Xd+oS/L3nTHPzOI+
	hMiQUNnT0BkTn6fCPV4OGQEB7mhnxI8Jqk5vmmy1JP3r4rsR0+In2b8zoOOobsPlfp9ed3ZgGP+
	36TK73iZrtAaSyN7dZn3qqQBhKNc4SDPra2yRgjU81lCjmiu97lesK0=
X-Received: by 2002:ac8:7d82:0:b0:467:5e61:c116 with SMTP id d75a77b69052e-46e12a1e36cmr160728821cf.7.1737381207207;
        Mon, 20 Jan 2025 05:53:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCbxGDy6CHUSfOLqTxGL3gA1S6wKRHlUvydXAdXodFBspL8+Pdog+OKdfN6k1jzDkgqmOx+A==
X-Received: by 2002:ac8:7d82:0:b0:467:5e61:c116 with SMTP id d75a77b69052e-46e12a1e36cmr160728291cf.7.1737381206799;
        Mon, 20 Jan 2025 05:53:26 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e1030da00sm42651971cf.33.2025.01.20.05.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 05:53:25 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-perf-users@vger.kernel.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org, rcu@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
 bcm-kernel-feedback-list@broadcom.com, Peter Zijlstra
 <peterz@infradead.org>, Nicolas Saenz Julienne <nsaenzju@redhat.com>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.amakhalov@broadcom.com>, Russell King
 <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Paul Walmsley <paul.walmsley@sifive.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, Boris
 Ostrovsky <boris.ostrovsky@oracle.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes
 <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, Boqun
 Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan
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
 <samuel.holland@sifive.com>, Rong Xu <xur@google.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Yosry Ahmed <yosryahmed@google.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>, Jinghao Jia <jinghao7@illinois.edu>, Luis
 Chamberlain <mcgrof@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH v4 25/30] context_tracking,x86: Defer kernel text
 patching IPIs
In-Reply-To: <Z4qQL89GZ_gk0vpu@google.com>
References: <20250114175143.81438-1-vschneid@redhat.com>
 <20250114175143.81438-26-vschneid@redhat.com>
 <Z4bTlZkqihaAyGb4@google.com>
 <xhsmhed11hiuy.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <Z4qQL89GZ_gk0vpu@google.com>
Date: Mon, 20 Jan 2025 14:53:13 +0100
Message-ID: <xhsmhtt9tfv7a.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 17/01/25 09:15, Sean Christopherson wrote:
> On Fri, Jan 17, 2025, Valentin Schneider wrote:
>> On 14/01/25 13:13, Sean Christopherson wrote:
>> > On Tue, Jan 14, 2025, Valentin Schneider wrote:
>> >> +/**
>> >> + * is_kernel_noinstr_text - checks if the pointer address is located in the
>> >> + *                    .noinstr section
>> >> + *
>> >> + * @addr: address to check
>> >> + *
>> >> + * Returns: true if the address is located in .noinstr, false otherwise.
>> >> + */
>> >> +static inline bool is_kernel_noinstr_text(unsigned long addr)
>> >> +{
>> >> +	return addr >= (unsigned long)__noinstr_text_start &&
>> >> +	       addr < (unsigned long)__noinstr_text_end;
>> >> +}
>> >
>> > This doesn't do the right thing for modules, which matters because KVM can be
>> > built as a module on x86, and because context tracking understands transitions
>> > to GUEST mode, i.e. CPUs that are running in a KVM guest will be treated as not
>> > being in the kernel, and thus will have IPIs deferred.  If KVM uses a static key
>> > or branch between guest_state_enter_irqoff() and guest_state_exit_irqoff(), the
>> > patching code won't wait for CPUs to exit guest mode, i.e. KVM could theoretically
>> > use the wrong static path.
>>>
>> AFAICT guest_state_{enter,exit}_irqoff() are only used in noinstr functions
>> and thus such a static key usage should at the very least be caught and
>> warned about by objtool - when this isn't built as a module.
>
> That doesn't magically do the right thing though.  If KVM is built as a module,
> is_kernel_noinstr_text() will get false negatives even for static keys/branches
> that are annotaed as NOINSTR.

Quite so.

I've been looking at mod_mem_type & friends, I'm thinking adding a
MOD_NOINSTR_TEXT type might be overkill considering modules really
shouldn't be involved with early entry, KVM being the one exception.

Your suggestion to have a KVM-module-specific noinstr section sounds good
to me, I'll have a look at that.


