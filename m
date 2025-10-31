Return-Path: <kvm+bounces-61720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0A6C26701
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98D1E188FEA2
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068A630170E;
	Fri, 31 Oct 2025 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BF+Oob+x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F0B26ED55
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932587; cv=none; b=PpcwJXsv0J/HHXkXlmAPMkbXSNYiqsrhttgNeYMcN+QcmDhw8LKn2H/F0EwXyXyhb4k4uIw3QZkLN7bpH8yIK0yU5pzeTy7bCe+wXneG9k3uh1SDel3qOE1ndFxDEqT7RvqRbcDds2W2gLIxQKkU3iiYwM4+OENCR/HMXruoo60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932587; c=relaxed/simple;
	bh=89kyHpPbJXmhylbv/+r/d1Rty7NEIIBLxACE0Nh9fx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Db0SX5Xawi7FZR51ufv3gB6pX1TiOgntg84MRG4NYlpjXNmcSsUg1Q91FE7cmYjcGXmZk6N7Es9114aMt5tMG2n4T+AiL3imoK/kFBZwoZ4ZL2fAz+WrHeWaKkJwBzRrFqLII1RgjfLXWtkRnBRdbxEZgrxyK5zNPFvz4NNZ4rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BF+Oob+x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-277f0ea6ee6so24761435ad.0
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761932584; x=1762537384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4KIS8YznzNIn0xjee6YBCS61sxbopStZxFkL5pmhtOU=;
        b=BF+Oob+xIbALUbieJ6UFCDs5rt4gjfH/fdC2DqrgDtueZo7G0Wq+qFqB6BuXCyA06B
         PVamO+WGdXJcmLjp8UD7z6xPwFZKjloytK3BHMnkX3/lCBjTQQ/+07TO84ySuUfq9a11
         B6OxTnVjjzdWec9TsBMsFMQMAr1TivaNYVBhrUGy9B+CbGVeuDL5HyY32DPO169OWq3r
         1nMOJE0EgFGma+lwlKAXAKkiNAmjnKJ3YJLjt3E1X5qWNJiWSU4kZrITd40pK+oeEHhJ
         hzszy5kWfHpEDJmBC01GseFNqPmBoJ1tki5yf60GmJGQPyQfXGAP+lo2TBkS1jqAwg1+
         3fRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932584; x=1762537384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4KIS8YznzNIn0xjee6YBCS61sxbopStZxFkL5pmhtOU=;
        b=Zmr/VIdqms4TCXkKDUkQPqqXuv1utYdJA8lVL/GPkY3BjxAh3tE99cbEE3/8Clgq8h
         J9ry/+Z/zY9amGlxI6uy1FeM+qXMcDWQYZG7JjH5EnmxWlIjeWcyWd7rgVnI6mfXsYc2
         4RTaQ5ggEB9pvip0UHyyEYEHCg5OV8cCmbkjQWyfOfUoK2p+1deP8oheO5uoGXGHZIvf
         l7K7P/viEQEKXApnXhpwY+rkQhfEv1LfdGZNdBhVYUnn7kezlKE3KgkUVDZiG2M5mAcX
         ezL1NUKIrzGJMLIHWBvxYANn6F05CNv7W9Zn6q0yC7HCTkm29olb1/smOi498KSCSdf9
         cdYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCsOhb47YianqIC7erV8zRfQqpCHz78yU1wEUfLIf4vj8NMdRJAux2HgyX19naqeiItXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDpC0auEulIPdjuGUY/kqGCsxDTYfO3q6DBDadyPYaTABVulHQ
	FGbAv70spOnZHCmZXbAg8MpYgVMpnTz497T8BSz4u0YAP7xLFX/79wA+iv3k5aZ6GUauuHsTEp6
	kZVgFPA==
X-Google-Smtp-Source: AGHT+IESYWjtdItYLqBwcEmHqqmP0CPrZ5lahVGTlH9mdBWh4wk3eyfim34G+iQPgn2+yKydL4oM1vpHp8A=
X-Received: from pjbcs23.prod.google.com ([2002:a17:90a:f517:b0:33f:df7f:3c2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1ca:b0:295:105:c87d
 with SMTP id d9443c01a7336-2951a55b729mr53114805ad.32.1761932583797; Fri, 31
 Oct 2025 10:43:03 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:43:02 -0700
In-Reply-To: <DDWH6WN6G64S.22FTEH7M615YJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-3-seanjc@google.com>
 <DDWH6WN6G64S.22FTEH7M615YJ@google.com>
Message-ID: <aQT1JgdgiNae3Ybl@google.com>
Subject: Re: [PATCH v4 2/8] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Brendan Jackman wrote:
> On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
> > Decouple the use of ALTERNATIVE from the encoding of VERW to clear CPU
> > buffers so that KVM can use ALTERNATIVE_2 to handle "always clear buffers"
> > and "clear if guest can access host MMIO" in a single statement.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/nospec-branch.h | 21 ++++++++++-----------
> >  1 file changed, 10 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 08ed5a2e46a5..923ae21cbef1 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -308,24 +308,23 @@
> >   * CFLAGS.ZF.
> >   * Note: Only the memory operand variant of VERW clears the CPU buffers.
> >   */
> > -.macro __CLEAR_CPU_BUFFERS feature
> >  #ifdef CONFIG_X86_64
> > -	ALTERNATIVE "", "verw x86_verw_sel(%rip)", \feature
> > +#define CLEAR_CPU_BUFFERS_SEQ	verw x86_verw_sel(%rip)
> >  #else
> > -	/*
> > -	 * In 32bit mode, the memory operand must be a %cs reference. The data
> > -	 * segments may not be usable (vm86 mode), and the stack segment may not
> > -	 * be flat (ESPFIX32).
> > -	 */
> > -	ALTERNATIVE "", "verw %cs:x86_verw_sel", \feature
> > +/*
> > + * In 32bit mode, the memory operand must be a %cs reference. The data segments
> > + * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
> > + */
> > +#define CLEAR_CPU_BUFFERS_SEQ	verw %cs:x86_verw_sel
> >  #endif
> > -.endm
> > +
> > +#define __CLEAR_CPU_BUFFERS	__stringify(CLEAR_CPU_BUFFERS_SEQ)
> 
> Maybe CLEAR_CPU_BUFFERS_SEQ should just be defined as a string in the
> first place?

Heh, I tried that, and AFAICT it simply can't work with the way ALTERNATIVE and
friends are implemented, as each paramater needs to be a single unbroken string.

E.g. this 

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 61a809790a58..ffa6bc2345e3 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -63,6 +63,8 @@
        RET
 .endm
 
+#define CLEAR_CPU_BUFFERS_SEQ_STRING  "verw x86_verw_sel(%rip)"
+
 .section .noinstr.text, "ax"
 
 /**
@@ -169,9 +171,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 
        /* Clobbers EFLAGS.ZF */
        ALTERNATIVE_2 "",                                                       \
-                     __stringify(jz .Lskip_clear_cpu_buffers;                  \
-                                 CLEAR_CPU_BUFFERS_SEQ;                        \
-                                 .Lskip_clear_cpu_buffers:),                   \
+                     "jz .Lskip_clear_cpu_buffers; "                           \
+                     CLEAR_CPU_BUFFERS_SEQ_STRING;                             \
+                     ".Lskip_clear_cpu_buffers:",                              \
                      X86_FEATURE_CLEAR_CPU_BUF_MMIO,                           \
                      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
 
yields wonderfully helpful error messages like so:

  arch/x86/kvm/vmx/vmenter.S: Assembler messages:
  arch/x86/kvm/vmx/vmenter.S:173: Error: too many positional arguments

If there's a magic incanation to get things to work, it's unknown to me.

