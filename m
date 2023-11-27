Return-Path: <kvm+bounces-2539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D28DE7FAD5B
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 23:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73528B2139A
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 22:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DF848CDE;
	Mon, 27 Nov 2023 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uSglpwtt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16B82126
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 14:20:47 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ccc8b7f578so75119857b3.2
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 14:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701123647; x=1701728447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oznesxFwrvBjWVLV8MzMnU76lp7dsyZKrsJygxTLUfs=;
        b=uSglpwttk5Fyc0kVd9ilOFq7e5RjvY3YcgqHqS8KNCXnzcUgktluRBwDqGP3zlo2tm
         Ah/GuhXDMQ/Vs4mXsrpuyWft83AUzRGaCs6+POLNx7uadwyIGJx/0M9SPhYEH5xc5jKs
         VYH1d0Od/gvDozUdntLP5hhnSMnWO3CR9XKCoyTd5SBvwZxHgM9I9KF8Wqpw7epKfJxY
         gboFmdX89mSmvJ/L2aFAYmmRxVUYMjLc38Hbv79dLY5fGx3vtt8LpopXmbhlB7QvVOs0
         AaXQAU2b1s633wVpSGBa4R3FheeLjJBva+tg8SXgn4uBPXo4Y36jlojET+yz66PRTica
         6NmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701123647; x=1701728447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oznesxFwrvBjWVLV8MzMnU76lp7dsyZKrsJygxTLUfs=;
        b=t5YrDYoI8FuOZzeGCWBiThPttfulouQTvweOKKEP0I45yv86lK0EBab/goV8RISnu7
         nDyvaPbAHT3ym83ndFYfxa6kMuP7kh9svywPGM17rkq1No59c+9CHmlP8xqPr/rp/KrG
         fYdrjgHx7SN/S5+N46851F3i8nzzoGKpNLAD3xnQPrAy4KrRj8sTnLfeUcp2HS8zZxSg
         1viE3/9JrE1Z6oBd5pUy37ygVh5rzN40QEvi6p92CAa0DoVSxmLVHPMqvHfK3vErmgeq
         NwSPoA+K6OjkDb80qDM6PQm6cHkzsxkrdFMfrE9ig3nt//n2LpEQh3tjZjvavZnr6Lop
         1B5g==
X-Gm-Message-State: AOJu0Yyiing/TiEd0fSRO0ZdxHL40UK5y+AYmXdjHdAZpy7nEzRBLuiZ
	vpYEHA7nD9rpXJonvjHELB1LPJgZaEM=
X-Google-Smtp-Source: AGHT+IFwra0+HV5FKvUpEQxDt3kN8Dy+vJAehp6awy7CFsSorhFrKshysFPUsywbqDFjIVgQl8OCUKb9/sk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4406:0:b0:5cb:6639:8024 with SMTP id
 r6-20020a814406000000b005cb66398024mr417245ywa.6.1701123646847; Mon, 27 Nov
 2023 14:20:46 -0800 (PST)
Date: Mon, 27 Nov 2023 14:20:45 -0800
In-Reply-To: <20231120105528.760306-4-vschneid@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231120105528.760306-1-vschneid@redhat.com> <20231120105528.760306-4-vschneid@redhat.com>
Message-ID: <ZWUWPQJLY4rzHXFR@google.com>
Subject: Re: [PATCH 3/5] x86/kvm: Make kvm_async_pf_enabled __ro_after_init
From: Sean Christopherson <seanjc@google.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, x86@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jason Baron <jbaron@akamai.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Feng Tang <feng.tang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, 
	"ndesaulniers@google.com" <ndesaulniers@google.com>, Michael Kelley <mikelley@microsoft.com>, 
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 20, 2023, Valentin Schneider wrote:
> kvm_async_pf_enabled is only ever enabled in __init kvm_guest_init(), so
> mark it as __ro_after_init.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

