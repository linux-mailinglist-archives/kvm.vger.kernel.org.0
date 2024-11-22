Return-Path: <kvm+bounces-32352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F269D5D22
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 11:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AF4D1F22564
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 10:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B691DE4CE;
	Fri, 22 Nov 2024 10:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODvY3pyH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82C01CB9EB
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732270668; cv=none; b=lagV5aY5f9P+ALk08KlBDOqC34n8TrIFHmKUIsLMocBdZHcAwLB7zYW6lr76DJgU+wAABmAFNNQZ4OXaHwG8zf4ILL9QSHK6ENrSnvuVfPnNj2jUXo3BT4UQjZ1S1W++tyPg5aX5bfTq3e3KFZfncYt0lgP8P44VTJM9+qSTinQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732270668; c=relaxed/simple;
	bh=XUuo/u7cK5K5gY/dFgAwCjVRAIBZqBeX+BIxJiAEQkY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p08nN17gSLM28aSF4fLc9sB+yxHJ6jb/lDbtClN6rk9KOn5wkRqtIs5REWdygfWDHVhwnc4GfTqCD8txC/6Al6ibIDIKu2Cmu/E7qeRpL6RqQ+zHD4sIxkiJ+y9kLt96Kdvs+b1Q0PedInvXn7DH4XY5bVmjOnPjxPKy/PYIYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ODvY3pyH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732270665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=69DVKh9DUZx0Pn4NM7TlxBgCo8xRovdMM0JkhaNwI8A=;
	b=ODvY3pyHJMfA4P6Np7b49iS5zpeaNxVu2/tIID1WbyeFngJa0WZMhRifwNorVLRP8PEQhX
	TS+GuCoUWsl3QqTGmoLjXpB+0YKIS0d5ZVs7lSvDsg4T0ESxRwm2lOoauPkAMyMflTyGyV
	MQNn4tyD5/uL4x+PSqDwgb/rGMSR5v4=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-ijgk3zxHO6Op2yS-7LDiWA-1; Fri, 22 Nov 2024 05:17:43 -0500
X-MC-Unique: ijgk3zxHO6Op2yS-7LDiWA-1
X-Mimecast-MFC-AGG-ID: ijgk3zxHO6Op2yS-7LDiWA
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6eeb9152b2cso36457547b3.1
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 02:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732270663; x=1732875463;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=69DVKh9DUZx0Pn4NM7TlxBgCo8xRovdMM0JkhaNwI8A=;
        b=QNGpFDpC4YwGY2VNAxk/ryhEcUMNe6xIcxt6WPu/6t2BMwC/Ktj0pMAX+MwHIUfmqf
         qO5nRMa1pxLzDD7alMUvnvV7rrPI9pVHAKXQalFImVNoK6sDKPkOf00IP5OM5cNPureg
         raF/Irf/vO0ExutrnQlTk2Wnb4upNgjxYucqeJJedSCepQSgCkUbGdw+WQtzkN6rv0Y4
         mGSSqCRRic8WGnLD858QCEMI0rQcGF3HOG2v2ZL08TnTgy1SFqZhQh9+VfnOx4G+JkjN
         UbcWN6cgsIIyetTOl2V1vdkFAhXFnCK15ovrQQ99KuOtXkceq5Q5iCbu87+aKWIOSwh3
         ilJA==
X-Forwarded-Encrypted: i=1; AJvYcCVg00E4cmN00EVoMcr5UJz4q5jSc+/9NJ58mS/KKcGTgrfSjtlQO3y/br3DIOfONWOBBhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK5Cghj2tdELrsndcf9zlAVAIbVs15JhTmIkvMUQu3VnJmmtxU
	6A9dOivTp1K7IrntCA0zX0iyF9vwwWqW9+dLhSof6izNI1/T1r5PyX5GfWma12I5GfK1cLZw0z5
	SLmME8z4b6qkbOvoHhRE15/tR2h6n4aGm9W5lKSBPKglaweIipg==
X-Gm-Gg: ASbGncu69ZpP8dMkY2E83rv3P9kOUzmmG1A9QqvbkPhOQDiN/HEq9LmQ3csmmv1QMDu
	NLWZwn19Arm/JEzM/USqpotL2hj8dtp75H4CLu6y3YeU1BcUi+shBdnPEbQVJsxagy1Ya6koplz
	K5bjV20oolcBrb1yZtSycI2Exj2vx8P2g/7DDa0jQ3n8f2r7wBuvz9VcA4ExOCbBCJiirMrCneI
	eZSbRIrlJYG8VlkWxn+zazTtac27fqBQUcdrlKCTV2AQWD006iixzn9IF4r8TR1rsMiejSTtSO4
	/88u0QkK/X9sfX8Fch1jkCcbokBQruE9qcA=
X-Received: by 2002:a05:690c:4b8f:b0:6e2:a129:1623 with SMTP id 00721157ae682-6eee0a4e7cbmr23805967b3.38.1732270663066;
        Fri, 22 Nov 2024 02:17:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzjL7GOb26N8xVdZoDD0aeetdAAWaPf+1MRvyDFWpPzlOuVttoePPk8DAQ//wEdbZj+zzG2Q==
X-Received: by 2002:a05:690c:4b8f:b0:6e2:a129:1623 with SMTP id 00721157ae682-6eee0a4e7cbmr23805387b3.38.1732270662779;
        Fri, 22 Nov 2024 02:17:42 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b513f91e8esm72637485a.2.2024.11.22.02.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 02:17:41 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 bpf@vger.kernel.org, x86@kernel.org, rcu@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>, Frederic
 Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Joel Fernandes
 <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, Boqun
 Feng <boqun.feng@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang1211@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, Lorenzo Stoakes
 <lstoakes@gmail.com>, Jason Baron <jbaron@akamai.com>, Kees Cook
 <keescook@chromium.org>, Sami Tolvanen <samitolvanen@google.com>, Ard
 Biesheuvel <ardb@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Juerg
 Haefliger <juerg.haefliger@canonical.com>, Nicolas Saenz Julienne
 <nsaenz@kernel.org>, "Kirill A. Shutemov"
 <kirill.shutemov@linux.intel.com>, Dan Carpenter <error27@gmail.com>,
 Chuang Wang <nashuiliang@gmail.com>, Yang Jihong <yangjihong1@huawei.com>,
 Petr Mladek <pmladek@suse.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Song Liu <song@kernel.org>, Julian Pidancet <julian.pidancet@oracle.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Dionna Glaze
 <dionnaglaze@google.com>, Thomas =?utf-8?Q?Wei=C3=9Fschuh?=
 <linux@weissschuh.net>, Juri
 Lelli <juri.lelli@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Daniel Wagner <dwagner@suse.de>, Petr
 Tesarik <ptesarik@suse.com>
Subject: Re: [RFC PATCH v3 06/15] jump_label: Add forceful jump label type
In-Reply-To: <20241121202106.nqybif4yru57wgu3@jpoimboe>
References: <20241119153502.41361-1-vschneid@redhat.com>
 <20241119153502.41361-7-vschneid@redhat.com>
 <20241119233902.kierxzg2aywpevqx@jpoimboe>
 <20241120145649.GJ19989@noisy.programming.kicks-ass.net>
 <20241120145746.GL38972@noisy.programming.kicks-ass.net>
 <20241120165515.qx4qyenlb5guvmfe@jpoimboe>
 <20241121110020.GC24774@noisy.programming.kicks-ass.net>
 <xhsmhcyioa8lu.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <20241121202106.nqybif4yru57wgu3@jpoimboe>
Date: Fri, 22 Nov 2024 11:17:33 +0100
Message-ID: <xhsmha5dra7ya.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 21/11/24 12:21, Josh Poimboeuf wrote:
> On Thu, Nov 21, 2024 at 04:51:09PM +0100, Valentin Schneider wrote:
>> Okay so forcing the IPI for .noinstr patching lets us get rid of all the
>> force_ipi faff; however I would still want the special marking to tell
>> objtool "yep we're okay with this one", and still get warnings when a new
>> .noinstr key gets added so we double think about it.
>
> Yeah.  Though, instead of DECLARE_STATIC_KEY_FALSE_NOINSTR adding a new
> jump label type, it could just add an objtool annotation pointing to the
> key.  If that's the way we're going I could whip up a patch if that
> would help.
>

Well I'm down for the approach and I'd appreciate help for the objtool side
:-)

> --
> Josh


