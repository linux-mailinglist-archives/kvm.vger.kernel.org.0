Return-Path: <kvm+bounces-63426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B57B0C666BE
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 23:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 5446E29885
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 22:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5864328B7C;
	Mon, 17 Nov 2025 22:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ay5gOt95"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EBB3093BF
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763417947; cv=none; b=pC2JOQTvuRgvdERZ4ymrMg/kIQu9u1qChFZHQDGAwaabXk151rtd8ACKCOSHB0g44WI3CDUktQPYxIyjb3S3oWOAKHrYAd/POgNpINzbbYB1xtJlgxEIqTyfyL5yBIDj8ffqXN62yG7WuIJYjlEXouaD0lr59EpRqqWqUDFfu/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763417947; c=relaxed/simple;
	bh=m+SUNOSsRGNg6e4fertlZE3XZICpzyYhXKuDwT0ifo4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HcRMjgEvO3Y6EHxZe6+9mhtmJ13ipE6YnKFtmOwFJrGH9v8P0p7wtTWzkD7/7NE1TIcu7Qe+eIjK7ZuSaia+AVqS2Uyja1t32xdMRdidvIrZGFCnt8dHtVXakT4vtyIt5GbyXQ5elYX5f/thC+1CNfcIkJWoa80QW1t7xtZtU5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ay5gOt95; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29806c42760so173209105ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 14:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763417945; x=1764022745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jketl0ykgqH6CHwpfbMW0pLhEMzOqTEcodUiqzB4Vy0=;
        b=ay5gOt95NJG0eyq5BmKYG0JYQzAk4CpYrvJeoTU97Ov6f3sHWZuVTdPPQkyk8jHtmB
         yeYb2uYTELW4UaXCA24n0uVX+IM+ix6aNqaMBPKoAvVG0C0NT9MsXfYJBJci/uWeJXR6
         Ym05liNKL7p99SB8dFZLIxx1lCnWCvQqcgk+64zSCDIpjHGAyUWaiVvW30Pb7b4M1EkQ
         uC3VCHwsFQfsyeHtM4Hv/hXMWIef6IxZv+KwwkW+rOjXKH48Tn2IZ0RbxnWteA7Vt5K6
         U0GTWPbba4d9niJiFbt7bf7fXkPDP2ujIGJyk5xnu38mNbZeqehM0o2thqwXuCgNf9fk
         HKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763417945; x=1764022745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jketl0ykgqH6CHwpfbMW0pLhEMzOqTEcodUiqzB4Vy0=;
        b=VPyt+LRSYtk2i/qUO/dE6UXIjMLZ+ieX1AKScArTMePna1BJBFh0Ow3GVJgGUGYTwS
         GibYr+gTIHI0D9EcCMjJiOwRWvoGLy1RSx5E2XKODO7kGNlsFWVieVpEUChFXmcCvPwP
         ZDwSkw/hIAWO2feaJMXlRuYMNPi8yU5AfTqk4spidebOF2e8Ck0Ap3y+taH3I4p53BPm
         6KNCmF7ao5Dzxq9bUWp1IJc1bYBRgyjA9j96B19sf2GcFIc2E1h21d8E4TZj8JSsq1gJ
         yc8ecKXk+tnNlmlcsTfPLAYoGBeEdhQAm5T1zpOlmVjatx4oveHmNn92H3OCJAKEd1OJ
         C8Ww==
X-Gm-Message-State: AOJu0Yx02HEx8/D/z6NsYngqLUqDcDOCmNvoxQJJzXsy6IJG6ubKvP6M
	OHymcMWqsWFHeCC30DcTW0S7JIqetxT00W0Y+j6DyRWFGg+O41M8vqirxwUcgCEyFo7D6dsqlhg
	zuqmx3g==
X-Google-Smtp-Source: AGHT+IHcdd0ArWlATEcfj8BU5F82GWD1Li5aCx6PmaH0PInTm//H/NUZ3GqyQdoRB02rIu9vl/OLgCgIy78=
X-Received: from plgn12.prod.google.com ([2002:a17:902:f60c:b0:297:e1db:fee5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e951:b0:298:46a9:df1f
 with SMTP id d9443c01a7336-2986a6b88fbmr168676665ad.12.1763417944666; Mon, 17
 Nov 2025 14:19:04 -0800 (PST)
Date: Mon, 17 Nov 2025 14:19:03 -0800
In-Reply-To: <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com> <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
Message-ID: <aRufV8mPlW3uKMo4@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Nov 15, 2025, Mathias Krause wrote:
> On 14.11.25 19:25, Sean Christopherson wrote:
> > On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
> >> This is v2 of [1], trying to enhance backtraces involving leaf
> >> functions.
> >>
> >> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> >> fails hard for leaf functions lacking a proper stack frame setup, making
> >> it dereference invalid pointers. ARM64 just skips frames, much like x86
> >> does.
> >>
> >> [...]
> > 
> > Applied to kvm-x86 next, thanks!
> 
> Thanks a lot, Sean!
> 
> > P.S. This also prompted me to get pretty_print_stacks.py working in my
> >      environment, so double thanks!
> 
> Haha, you're welcome! :D
> 
> > 
> > [1/4] Makefile: Provide a concept of late CFLAGS
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
> > [2/4] x86: Better backtraces for leaf functions
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a

Spoke too soon :-(

The x86 change breaks the realmode test.  I didn't try hard to debug, as that
test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.

I can't for the life of me figure out how to get Makefile variables to do what I
want, so for now I'm going to drop the x86 change so as not to block the rest of
the stuff I've got applied.

I'll keep the rest applied, so just resubmit the x86 patch against kvm-x86/next.

FWIW, conceptually I think we want something like this:

diff --git a/x86/Makefile.common b/x86/Makefile.common
index be18a77a..65e41578 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -44,6 +44,7 @@ COMMON_CFLAGS += -O1
 KEEP_FRAME_POINTER := y
 
 ifneq ($(KEEP_FRAME_POINTER),)
+ifneq ($(no_profiling),y)
 # Fake profiling to force the compiler to emit a frame pointer setup also in
 # leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
 #
@@ -53,6 +54,7 @@ ifneq ($(KEEP_FRAME_POINTER),)
 # during compilation makes this do "The Right Thing."
 LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
 endif
+endif
 
 FLATLIBS = lib/libcflat.a
 
@@ -120,6 +122,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o $(SRCDIR)/$(TEST_DIR)/realmode.
        $(LD) -m elf_i386 -nostdlib -o $@ \
              -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $(filter %.o, $^)
 
+$(TEST_DIR)/realmode.o: no_profiling = y
 $(TEST_DIR)/realmode.o: bits = $(realmode_bits)
 
 $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o

> > [3/4] arm64: Better backtraces for leaf functions
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/da1804215c8e
> > [4/4] arm: Fix backtraces involving leaf functions
> >       https://github.com/kvm-x86/kvm-unit-tests/commit/c885c94f523e
> > 
> > --
> > https://github.com/kvm-x86/kvm-unit-tests/tree/next
> 

