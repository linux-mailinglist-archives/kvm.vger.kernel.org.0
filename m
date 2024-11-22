Return-Path: <kvm+bounces-32358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8575A9D600F
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 14:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14A0EB235C6
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 13:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09EE7BB15;
	Fri, 22 Nov 2024 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JT21EBqH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F87C33985
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283802; cv=none; b=nU35zQ+HPHXI/YGczqyjD3ESco9FdwmgY7H+vAfIRJ4wttr+4P7AlGaM5LiLBvYoGLvQUy9/70PIdVMWR3Gl8AwpZQW3xEF2ohJvGTURLkuMCDCAPdPkalO2jKkOo2ylsAiKrfsS2pXpAtrkdW0Zo1L+Jh2SWoFgCla0n7rFwdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283802; c=relaxed/simple;
	bh=8WMrdbry8cYbb3PwBwFzfa4t8XIIPzo0aJN5xmp6Bzw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AVcko5PEVaeKJ0WRVocb5Vgmxrs4pqYRaKSEgKrT+OBxFbcWOx35kWe5dCH1steaIfqkti9KlgV3q7ePBO9r5o2pQwzw8+7ipJh4JG+M77hrA3oisAO3fxd7n6uVTLyLMCS/Ez0bZUwUTf7tb+VB+y/Idh4sz+Gv6N8eNweGhNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JT21EBqH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732283800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsHaI1ei1IfQPr0KsTU1Bgjr9RwL5hBLdlpSc5oHDTU=;
	b=JT21EBqHCsSyPl3ffxSYLitOS3ro9JY0IAUhMjt9E36t6a+G6X/H/tySP9VReojvYaO77b
	6IGOJhOGa70iW84GramlQRpeVRMH6U22TFnURm2+dF89PZ3SaG9KetU82JAEVLekpAqBe1
	AumAMroVV+cpwlFwA82P7JIRuEyxAVs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-mULHIGIWOLizk-LkncEZOw-1; Fri, 22 Nov 2024 08:56:39 -0500
X-MC-Unique: mULHIGIWOLizk-LkncEZOw-1
X-Mimecast-MFC-AGG-ID: mULHIGIWOLizk-LkncEZOw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38243a4ba5fso1455509f8f.2
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 05:56:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732283798; x=1732888598;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SsHaI1ei1IfQPr0KsTU1Bgjr9RwL5hBLdlpSc5oHDTU=;
        b=t5mnjMYo4uIMiyZhkU/berS9mzKbsvRAqtpZPsGkYNtwQt2LoXFY4U8hgEhJ8xmfof
         8UcRN3fqtrcclpFN5Iy0ZEq+bnopV+iKtjfdy0xBMLjdpvvbpZyYwwzcpJIV/k6rOMBq
         SXi8cyAzDCLGIOgO2qSf0LCo1kxP38U+elqFW+GBUZ0IMJXVppx4hfgZyim1cjhRtyuW
         x9fOnduuQeKV0puQWNQBzkqfihsLpaDwjL3Vy7uqf3G/3fdpdvdLs/rjNs5gPVbV1RZ0
         J8DyhwxgC53aNCxtMViurimXMJQ0NGXNf+sH3lxSPEPQWmpyq8T0KNltN3OdB6X349rp
         YRGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmLNL9NV8Jc3/3Fz4BHWgctEAn9zkU4wiHCoQ1zLhUAucA+N+sTS6+nNwne8QwDYjRSd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx+KPvUCq+T/jgQDpnZ3aV8L7gxBFgcVzRc74VD5irFAMpATLy
	pk0rG0mdo7bCECHV1pIGx+Hc1quE9yVdux4ldD5E+O6f7HQKMZtFbcGg/EdnedBgKXracsy/zr6
	uzDbNyoBeakDxpBI0Rkp1Ztz5aw9lkglXJG0UCLxN216dbRbbiw==
X-Gm-Gg: ASbGnctyCTZTy1Btg5UEJb4dVT39x3eYW+9wsMKbyn6yYk5bjKV4bDubyIjL+bx8TkV
	A9ZOZp25qtBjjPGe3Oiz49+o6BkhmbgoNec+HeROTxOiv6pNcUsGCxiaMOlTAvBFabOHtApKaHJ
	UFCdS75ZsoBnkiOenujEYfBlr7y+OJnji7d7ig/6Bfqa1Dm+Aycav7PPfPu2TjvwKqwPEiQhQHM
	tnI062o6+JaORfwVu3p2lgkHYobEF73CXezhzF0suXfD3RaVDVHBBndzSF63uMfR1lBDjHUD1Os
	y2/dTdWUBfOesgE9Saipcn47BqeB6KT51mo=
X-Received: by 2002:a5d:64a9:0:b0:382:4fa4:e544 with SMTP id ffacd0b85a97d-38260b3caf5mr2941924f8f.6.1732283797809;
        Fri, 22 Nov 2024 05:56:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiRi9yMi/lEmTBvU6LjIZoyT2mo/EJzfL6hLaHeWfXh/dSLFhhXDExODAa08mxumRLkt9jSw==
X-Received: by 2002:a5d:64a9:0:b0:382:4fa4:e544 with SMTP id ffacd0b85a97d-38260b3caf5mr2941848f8f.6.1732283797392;
        Fri, 22 Nov 2024 05:56:37 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbedf40sm2418281f8f.98.2024.11.22.05.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 05:56:36 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: paulmck@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 x86@kernel.org, rcu@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Wanpeng Li
 <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <quic_neeraju@quicinc.com>, Joel Fernandes <joel@joelfernandes.org>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, Andrew
 Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, Lorenzo Stoakes
 <lstoakes@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jason Baron
 <jbaron@akamai.com>, Kees Cook <keescook@chromium.org>, Sami Tolvanen
 <samitolvanen@google.com>, Ard Biesheuvel <ardb@kernel.org>, Nicholas
 Piggin <npiggin@gmail.com>, Juerg Haefliger
 <juerg.haefliger@canonical.com>, Nicolas Saenz Julienne
 <nsaenz@kernel.org>, "Kirill A. Shutemov"
 <kirill.shutemov@linux.intel.com>, Nadav Amit <namit@vmware.com>, Dan
 Carpenter <error27@gmail.com>, Chuang Wang <nashuiliang@gmail.com>, Yang
 Jihong <yangjihong1@huawei.com>, Petr Mladek <pmladek@suse.com>, "Jason A.
 Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>, Julian Pidancet
 <julian.pidancet@oracle.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Dionna Glaze <dionnaglaze@google.com>, Thomas =?utf-8?Q?Wei=C3=9Fschuh?=
 <linux@weissschuh.net>, Juri Lelli <juri.lelli@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, Daniel
 Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [RFC PATCH v3 04/15] rcu: Add a small-width RCU watching
 counter debug option
In-Reply-To: <f85c0f84-7ae3-4fb5-889a-d9b83f9603fe@paulmck-laptop>
References: <20241119153502.41361-1-vschneid@redhat.com>
 <20241119153502.41361-5-vschneid@redhat.com>
 <f85c0f84-7ae3-4fb5-889a-d9b83f9603fe@paulmck-laptop>
Date: Fri, 22 Nov 2024 14:56:34 +0100
Message-ID: <xhsmh7c8v9xt9.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 22/11/24 04:53, Paul E. McKenney wrote:
> On Tue, Nov 19, 2024 at 04:34:51PM +0100, Valentin Schneider wrote:
>> +config RCU_DYNTICKS_TORTURE
>> +	bool "Minimize RCU dynticks counter size"
>> +	depends on RCU_EXPERT
>> +	default n
>> +	help
>> +	  This option controls the width of the dynticks counter.
>> +
>> +	  Lower values will make overflows more frequent, which will increase
>> +	  the likelihood of extending grace-periods. This option sets the width
>> +	  to its minimum usable value.
>
> The second sentence ("Lower values ...") sounds at first reading like
> this Kconfig option directly controls the width.  The third sentence sets
> things straight, but the reader might well be irretrievably confused by
> that point.  How about something like this instead?
>
>       help
>         This option sets the width of the dynticks counter to its
>         minimum usable value.  This minimum width greatly increases
>         the probability of flushing out bugs involving counter wrap,
>         but it also increases the probability of extending grace period
>         durations.  This Kconfig option should therefore be avoided in
>         production due to the consequent increased probability of OOMs.
>
>         This has no value for production and is only for testing.
>

Much better, I'll take that, thank you!

>>  endmenu # "RCU Debugging"
>> --
>> 2.43.0
>>


