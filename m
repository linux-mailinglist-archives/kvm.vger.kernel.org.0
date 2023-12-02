Return-Path: <kvm+bounces-3259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26ED7801DC3
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 17:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 566E51C2096C
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 16:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFF116430;
	Sat,  2 Dec 2023 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyGcmui4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2DD11A
	for <kvm@vger.kernel.org>; Sat,  2 Dec 2023 08:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701534973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yt4yCDhbgJbVqEjZGY+0zrwL/gtoQ/Q8nFWZ1u+3nY8=;
	b=cyGcmui40LxaaDL147+fL4K1GV5zvfXhAQqptcYdDztAPPbtFhWLAEXnQKkS7upnB1cBqp
	HrX6PokkYHfCy37HnizIrg51TG2+B5adPsT6qKSSGK/qLNA/2r29UttZFNfLWDemlml1lK
	SuoLPbq5UKPXcSn0hKJNdlH3Z8lG5Fo=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-Y8vwmrwBOuC64RbB9xF0SA-1; Sat, 02 Dec 2023 11:36:11 -0500
X-MC-Unique: Y8vwmrwBOuC64RbB9xF0SA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5d0c4ba7081so56434147b3.0
        for <kvm@vger.kernel.org>; Sat, 02 Dec 2023 08:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701534969; x=1702139769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yt4yCDhbgJbVqEjZGY+0zrwL/gtoQ/Q8nFWZ1u+3nY8=;
        b=IQBwK3YQH/xehg+gwy8pa4SqDKaV6XD4I1FgSRApE9/CEdFFGClmgvhqh2f06Z8k7u
         yv4jb+OweAbAMKwx8vWZC+QXFpjQLh9cdtCf5tgNiQKVKX3l3achD2m0ZgI6n+qXXDS6
         d6oF0E/uB44wuKKZV/CcaCn8/YqyaVTg5WOdy8qGbcy02bk7e0KfnxdAXIOs/cfqWiGg
         1mec7GYKPPgv3WP3YwKIbCxI920PFQ0UZLQSFhfMHvq6A9rcMvQo2hEpshYJO31NnEwW
         71sa/woieI/O4fo/3811dZy9qLX2SAWTf7POd4Codv60Gei4ovKPC8oAhok1LaSezC4J
         2KIg==
X-Gm-Message-State: AOJu0Yx+rRF0XPs23y9YayODK2qvBU0F5uX/LDdgKyun661JcjCLvSy/
	7pNwqoM+TOjz0249eulL83pgWvxPeGBrYSUzaaPtBdY4/eZaIlY0tkb8GG/hZFTe+wlMKggAZ1v
	nahlv7zb2yHq8
X-Received: by 2002:a25:ae8c:0:b0:db7:dacf:59e4 with SMTP id b12-20020a25ae8c000000b00db7dacf59e4mr769306ybj.88.1701534968787;
        Sat, 02 Dec 2023 08:36:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEftyDWBBv+mMnPECb2rVK9oTYatxunIoB2W4Ql4AbzgDHuw14U6JLB0Zeu8QENlNaWlUxpXw==
X-Received: by 2002:a25:ae8c:0:b0:db7:dacf:59e4 with SMTP id b12-20020a25ae8c000000b00db7dacf59e4mr769287ybj.88.1701534968536;
        Sat, 02 Dec 2023 08:36:08 -0800 (PST)
Received: from treble (fixed-187-191-47-119.totalplay.net. [187.191.47.119])
        by smtp.gmail.com with ESMTPSA id b25-20020a67e999000000b0046450681113sm698807vso.9.2023.12.02.08.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Dec 2023 08:36:08 -0800 (PST)
Date: Sat, 2 Dec 2023 10:36:05 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Feng Tang <feng.tang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	"ndesaulniers@google.com" <ndesaulniers@google.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: Re: [PATCH 0/5] jump_label: Fix __ro_after_init keys for modules &
 annotate some keys
Message-ID: <20231201204400.wckmtoe3kroiyv4s@treble>
References: <20231120105528.760306-1-vschneid@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231120105528.760306-1-vschneid@redhat.com>

On Mon, Nov 20, 2023 at 11:55:23AM +0100, Valentin Schneider wrote:
> Hi folks,
> 
> After chatting about deferring IPIs [1] at LPC I had another look at my patches
> and realized a handful of them could already be sent as-is.
> 
> This series contains the __ro_after_init static_key bits, which fixes
> __ro_after_init keys used in modules (courtesy of PeterZ) and flags more keys as
> __ro_after_init.
> 
> [1]: https://lore.kernel.org/lkml/20230720163056.2564824-1-vschneid@redhat.com/

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh


