Return-Path: <kvm+bounces-32178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F649D4024
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B116B2B8BE
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527771527B1;
	Wed, 20 Nov 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fsf083JN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEF71474A7
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732119329; cv=none; b=hDjJVJDWhxNFeYiuwJ3ZWuMEMOcmVls17XVj6lKms+0XCfXKNY3lbJULzHPedzA+H/dO/AzJnLZleFHQbyL/tUgzeJ8ClSj2eCAmd1uGnVrpB5PHRuYKVugL+jQy0GfgsY2FtZjC004HJLCNHHYXpCvGrgGvNOqGT7GkJwaew98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732119329; c=relaxed/simple;
	bh=VNWYPyllDhn6wyHA8vHCBZcrdTpypW9KdBxrUGgTSiU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lRmKzLrnBt2joHvZBh8nxhaqv3map3k403QCyp2jUYgbWjHaOIY74Pv+mgM5eOY55V4ShvFoZNZqBok/7pI255iKYxQZInk/6t2RC0bzqiVkazS9f6goPfRUBsz8QIYnRK7wiIieFWFXCWF7AwgfN3mzN8aqvalUYC0CL9AESkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fsf083JN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732119327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9neiNV5Ecw1Rm63FFkLc6Zp+LPvspTbTCjcardEBqA=;
	b=Fsf083JNsS9wwCI0HmA2S9Xn2NrHwnCRh05e9UpS49I47v3ZJqDPly9WbuhZk+Ocnc1Qa2
	g37lh1RL/CrlVht8/QkAzN9/QRQJwdcaQKpMEbBcNAZovArHwEhyml48lEYeU/Bprkgt74
	GaBJqnn5EBVLoAHWHNnbUn0t+KecXbI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-I04FG-OxNka4v0T94TEl0A-1; Wed, 20 Nov 2024 11:15:24 -0500
X-MC-Unique: I04FG-OxNka4v0T94TEl0A-1
X-Mimecast-MFC-AGG-ID: I04FG-OxNka4v0T94TEl0A
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d4173d329fso33903216d6.2
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 08:15:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732119324; x=1732724124;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9neiNV5Ecw1Rm63FFkLc6Zp+LPvspTbTCjcardEBqA=;
        b=pjj5N/qIzrIvvLVtjh5w537sr/Lygv4jhFnan8UkclOMEBOp4b4dWje3ErWwMwFh+I
         HbnygnnNTrY8uA4iBPvvrfORKpDHwZHqBjQXTtgHGY9c8XIpqSezrbYKzT7TsIA2tAco
         9skNiU7JRtLY6QX6VaS9jCXhR/nibok0woaxWiFu509nhfK4tyyQd7hMzlIiGnseLr7w
         QJMoH12GBh5PLF4PYBYj2Fd1w5k7KlDxsqQGRWaXlU+30g36uyIh9wAisNsvIWP5BI63
         3L+u8O4sLslKgsJkm0+KdMBSyZg+eMn+Cdhg7Y0mOxlc+AlzmFIdcjJUSsaEJFAWODs1
         DoNw==
X-Forwarded-Encrypted: i=1; AJvYcCWBGuIPgcH3fTOI37JnunF/bMm4WZCz0HmF6uylYazMQIT9nqw98TWIdfCWjEPlOyVEDd8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS8lBUOAN15vjowCI7arsz5h4HB0TPPnYdVVnPGEIe/uyH3g22
	xv+mvDufx6rulwGkGbLFGhE5PdzsDHZnlwSpEWPgs/BgvY+DwZ/ByJFKHIp95O73ZNda2s+WJGd
	jajZGLK6AECfrbEACGqG3oE0nEa2YObevnlImA7C09ffIdLwfwg==
X-Gm-Gg: ASbGnctiJ890u7c0TPUOq6Shm/FNCdtTJBfRyxSomTGqCWNFGsOQhc2Rzk5ZTGAPyWO
	3jOCezuV9EURPB2AvceFs3lDl1IkxYyxi/DU4FUejru6jUCYGg+KtYzXec/G+VfDv01SUiFrQ/K
	roSphDkoPzKyM+IYBf3YE83HXBKEmGGmHfoUmABNUpHGi0YSm/8TdCKZ0XgfI9YxZPfT+bIsQM7
	aWgK6F1pdasyxESO/nJ9ZraLwqzbnrBPeYUiPengc3SqyZiOP1krYL9FSuabVAdaj+7UBhLzVDt
	TT/+EDodkbPpz5qFU+3ytKCzd6Tcssc/LBQ=
X-Received: by 2002:a05:6214:2aa7:b0:6d4:1f86:b1f2 with SMTP id 6a1803df08f44-6d4377bd8bcmr43340696d6.11.1732119324074;
        Wed, 20 Nov 2024 08:15:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErytLY/ydBtG/c68cV9sB/Rs0q2MHssCkf2mLl/ZoHSY4DaUVm1Hfo6p7yhhfkcknSTmK2WQ==
X-Received: by 2002:a05:6214:2aa7:b0:6d4:1f86:b1f2 with SMTP id 6a1803df08f44-6d4377bd8bcmr43339716d6.11.1732119323729;
        Wed, 20 Nov 2024 08:15:23 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d43812ab67sm12352206d6.88.2024.11.20.08.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 08:15:22 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 x86@kernel.org, rcu@vger.kernel.org, linux-kselftest@vger.kernel.org,
 "Paul E . McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Vitaly
 Kuznetsov <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>,
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
In-Reply-To: <20241120145049.GI19989@noisy.programming.kicks-ass.net>
References: <20241119153502.41361-1-vschneid@redhat.com>
 <20241119153502.41361-5-vschneid@redhat.com>
 <20241120145049.GI19989@noisy.programming.kicks-ass.net>
Date: Wed, 20 Nov 2024 17:15:14 +0100
Message-ID: <xhsmh1pz5j2zx.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 20/11/24 15:50, Peter Zijlstra wrote:
> On Tue, Nov 19, 2024 at 04:34:51PM +0100, Valentin Schneider wrote:
>> A later commit will reduce the size of the RCU watching counter to free up
>> some bits for another purpose. Paul suggested adding a config option to
>> test the extreme case where the counter is reduced to its minimum usable
>> width for rcutorture to poke at, so do that.
>> 
>> Make it only configurable under RCU_EXPERT. While at it, add a comment to
>> explain the layout of context_tracking->state.
>
> Note that this means it will get selected by allyesconfig and the like,
> is that desired?
>

I would say no

> If no, depends on !COMPILE_TEST can help here.

Noted, thank you!


