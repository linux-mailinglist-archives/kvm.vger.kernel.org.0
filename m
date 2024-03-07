Return-Path: <kvm+bounces-11316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF5887556B
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 794941F257EF
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 17:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94310130AE1;
	Thu,  7 Mar 2024 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YJ7tDhwH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C00F74262
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709833388; cv=none; b=KLuzJ9Z8MRGV/wRQZGo01eqZV6WsAkypemQyYiz8HfewpPdbwh+Fo4xl2BTIbW/If9pTGj6Tjv24V1v5idWn0RN99Xx0iGW40C32uRh6ahmCf1hLbPbLAes2XdQWOoD2lOVzjUcd/P21DNU3+yfMzFbLc9VRDTLlW34jgeHARaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709833388; c=relaxed/simple;
	bh=1lsVsguPPQhppE27G7fGmWeuudFk/07LF8KMTfRtQ9k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uoeJu781eXF/dad3ghmGHO5OLe6wlMmpQZPz/jPCoD9XFGH3zzsNwg9PjSNZWjeZvnH95LtB3Q2uxuTjs4VLnd54H4PulIU7R36p1hdqiLJV700KvkBa/FMZMu5gSNhPuHgiYLTP0cyBkTjA+iWOzmbF4DvMEXROOsYEv3z5hQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YJ7tDhwH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609a1063919so21644247b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 09:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709833386; x=1710438186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+5Nth4pqkIcnddTjv6Z5nf7/zGpa8tqI8lzvmd174U=;
        b=YJ7tDhwHtKHWMFttjMwKlCRHzWlL4DOEQY9HeCvh6V4Cc8V+Wle4e1Pa67N2MaIRNt
         lKq+mrT9jQukBLU27QhZDzKDW/9J4c4g5YNvOCzaHLAvlyXKoDkiWPRBdZL0AIY22Izx
         APBnn6b3ZbYXP4KOo2gqNquv6k+FvVBVXbEftfQ1F//V+32yJsdjVvhuPt0IJIVUFtQo
         +2lg97lmA8mwHQ3wYNp3kgHmjfDjBz6k7lnHn8hEwwQJSacMSUuumFIR5e2D+EI9NiNE
         eEfCxeaJ0j3AwbmDz0VkOdOYM09B40JheQm1+sbEkADHxYUlofaZ5CrWz87A9YJ9m8Mx
         Q1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709833386; x=1710438186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+5Nth4pqkIcnddTjv6Z5nf7/zGpa8tqI8lzvmd174U=;
        b=Oa5UY4drwzWquJAr5oKbEpAjlvyYpnotY46Gnbz30zGh9lWiZfINWjxXOEm9/hAi1z
         GXR2bPmDp89l/lZH09/UXZgDWshETYJHhLQ8glhf48th4tTC/3i+g+I0O/PnCOksOGAf
         vtldxFyD+2JceKZnUGUSpnyxQM4DSWmUTyb/tRXrho4FZQ+iFDJwVFaJuzNAMbaOTRfg
         SKHpU0BnCkdcTmniG97CHKMBcsiw29VtfioO9olpcTr7Rzqo7KssiQCPpjujycG/gLF+
         RThCAcyRjqFuLjdcpce6oqvxv89XOm20pm4LYbCYJhxfr9RHEXo4+sJ81m5McAI+s9x0
         Mx8A==
X-Forwarded-Encrypted: i=1; AJvYcCUjqkFJi1g3Fn0crMSASTlemimpSl5kTKgzZ5TIQ+wK5SS5wr8HVS3JEibPw8Vme/NB/U9q2G25+mL+WkQOrQOdNLXY
X-Gm-Message-State: AOJu0YxXHgVn1UfLO56tI3qzeIvGMVtJfqFUscfo/McssTB9+83SLgnt
	qeUERLmuuNopQllLmoOzyljd99EuWBzgRJSVjNt08aFmnicNcbrjcVZ9OM94V0tyUxPssFdgj6z
	PBA==
X-Google-Smtp-Source: AGHT+IHNTAEAMeaU5NCWBeLFwT7ykzpqTDT1vNYBMW7hMx5a61k23ruY/0B0R8r7RW9EZoJZ8cIFK3Zky4I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c86:b0:608:ce23:638c with SMTP id
 cm6-20020a05690c0c8600b00608ce23638cmr5279235ywb.4.1709833386363; Thu, 07 Mar
 2024 09:43:06 -0800 (PST)
Date: Thu, 7 Mar 2024 09:43:04 -0800
In-Reply-To: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
Message-ID: <Zen8qGzVpaOB_vKa@google.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Anup Patel <anup@brainfault.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Anup Patel wrote:
> ----------------------------------------------------------------
> KVM/riscv changes for 6.9
> 
> - Exception and interrupt handling for selftests
> - Sstc (aka arch_timer) selftest
> - Forward seed CSR access to KVM userspace
> - Ztso extension support for Guest/VM
> - Zacas extension support for Guest/VM
> 
> ----------------------------------------------------------------
> Anup Patel (5):
>       RISC-V: KVM: Forward SEED CSR access to user space
>       RISC-V: KVM: Allow Ztso extension for Guest/VM
>       KVM: riscv: selftests: Add Ztso extension to get-reg-list test
>       RISC-V: KVM: Allow Zacas extension for Guest/VM
>       KVM: riscv: selftests: Add Zacas extension to get-reg-list test
> 
> Haibo Xu (11):
>       KVM: arm64: selftests: Data type cleanup for arch_timer test
>       KVM: arm64: selftests: Enable tuning of error margin in arch_timer test
>       KVM: arm64: selftests: Split arch_timer test code
>       KVM: selftests: Add CONFIG_64BIT definition for the build
>       tools: riscv: Add header file csr.h
>       tools: riscv: Add header file vdso/processor.h
>       KVM: riscv: selftests: Switch to use macro from csr.h
>       KVM: riscv: selftests: Add exception handling support
>       KVM: riscv: selftests: Add guest helper to get vcpu id

Uh, what's going on with this series?  Many of these were committed *yesterday*,
but you sent a mail on February 12th[1] saying these were queued.  That's quite
the lag.

I don't intend to police the RISC-V tree, but this commit caused a conflict with
kvm-x86/selftests[2].  It's a non-issue in this case because it's such a trivial
conflict, and we're all quite lax with selftests, but sending a pull request ~12
hours after pushing commits that clearly aren't fixes is a bit ridiciulous.  E.g.
if this were to happen with a less trivial conflict, the other sub-maintainer would
be left doing a late scramble to figure things out just before sending their own
pull requests.

  tag kvm-riscv-6.9-1
  Tagger:     Anup Patel <anup@brainfault.org>
  TaggerDate: Thu Mar 7 11:54:34 2024 +0530

...

  commit d8c0831348e78fdaf67aa95070bae2ef8e819b05
  Author:     Anup Patel <apatel@ventanamicro.com>
  AuthorDate: Tue Feb 13 13:39:17 2024 +0530
  Commit:     Anup Patel <anup@brainfault.org>
  CommitDate: Wed Mar 6 20:53:44 2024 +0530

The other reason this caught my eye is that the conflict happened in common code,
but the added helper is RISC-V specific and used only from RISC-V code.  ARM does
have an identical helper, but AFAICT ARM's helper is only used from ARM code.

But the prototype of guest_get_vcpuid() is in common code.  Which isn't a huge
deal, but it's rather undesirable because there's no indication that its
implementation is arch-specific, and trying to use it in code built for s390 or
x86 (or MIPS or PPC, which are on the horizon), would fail.  I'm all for making
code common where possible, but going halfway and leaving a trap for other
architectures makes for a poor experience for developers.

And again, this showing up _so_ late means it's unnecessarily difficult to clean
things up.  Which is kinda the whole point of getting thing into linux-next, so
that folks that weren't involved in the original patch/series can react if there
is a hiccup/problem/oddity.

[1] https://lore.kernel.org/all/CAAhSdy2wFzk0h5MiM5y9Fij0HyWake=7vNuV1MExUxkEtMWShw@mail.gmail.com
[2] https://lore.kernel.org/all/20240307145946.7e014225@canb.auug.org.au

>       KVM: riscv: selftests: Change vcpu_has_ext to a common function
>       KVM: riscv: selftests: Add sstc timer test

