Return-Path: <kvm+bounces-47597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC86AC278F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC10A4A31BC
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE469298271;
	Fri, 23 May 2025 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yLkqPi5/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595232980AD
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748017513; cv=none; b=pw5TeS42H+z6yzsz8qk5C1tmmcCeNZzQtlf+Uq+EJX4EAJ1f0NUY1XAE1gtFzXEyjdNYgGhvmJ/2o+3xbL0xTXDbNoqoTZhndDKNFy14HixVy+4jYbdmg8mqKZa1JoZZtYHPmin3+t48rU9iMLnIRkCleYyUcQXy4RgUXJSKJ3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748017513; c=relaxed/simple;
	bh=1s09C3587I966ryCkLEkcRgAkOUPm8xSk88s/uziFFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FNcA7KKRcf34LmXLRgzQvamlfLra3qPBwnZ43RQWLZb0S81ieEmKT0LKVmkmYfNyu0aQA/WN4R4tCotoxVg3VEAEzUPq4IPTseFpAb+qgltiILOKhT8cET2KE71UqImryEL+3ZusQMRPXj/hGpITYZQwB8g0i9vfaxMZ4aCiLxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yLkqPi5/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1f71ae2181so17239a12.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748017511; x=1748622311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nKO/n7MCg1Zefl3piBKKEOFdcEpmLpkaUUv87HbWvrM=;
        b=yLkqPi5/zQF/EJFXfLRgkU4+8VftfhjzIrXcrJHsgtx1+0pg8uBQeX8dqRZo1E0r6q
         yPl1L6YMh7nlqw6p3W6GbZ+Q/w3y5y9jTzJKch4RORN3Pyu05yCm1ir5gPZqoOknusvU
         5ZbKetQBOKRt8vygvXSLsI8xHHSE9OSySzQVGPgDw0yIeCrJw56R9SR9QDvnKSlX44iC
         nhyiWSTV82Tj+GZRQhVdKyoY0j37oBWEBq0aLpcFzpFddUF4BI504ae2rcp0espOj51I
         zeQJ2aR91PNi9xKSMKUsRPYcU3ycYxMgXwNS01wFEwPlaLHNic5d7JnCwY8rAqqNotGn
         /SWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748017511; x=1748622311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nKO/n7MCg1Zefl3piBKKEOFdcEpmLpkaUUv87HbWvrM=;
        b=aCuzTGfqX9PwZpsfgTyeB6LQ9trujtFXggt6vcgYCu+PQ2N5BugcMm3nIRxbefRID0
         uVF0/VocPAtCiUe7vWLlNFclIORoOHvr2l4iPKlsMz7baTdM54HyfSy7eV7a43MI25x+
         I2Rud70d+uN44frh3GKmWd3KOSr2FNTWWoJ0LSi9i9orH00PgA2cIDQQo0wH8wO01qfP
         FzYBNpb26thx4u5vneSFMZwKgD428wXC8OEiZeaDwuWd0u9Fer+NUqzIdllFGqEToqqx
         xDvnfdtQQwfyiHMIY+/a7wTF0v18R6tUMH8ibMtHVYm/sQrZP74HUbMzRv5lohH37/OQ
         Ex1A==
X-Gm-Message-State: AOJu0Yyp2Lx65xEzYe5dyTqdndX3kaGvQon7P522YJz8N/RcgJ6iNxaW
	UvrcovrRskDNQ1VTD/nq28k1txyccbFc5mBu3o5F0uZUmvsyh7HDbP1RQjYEp7onXLxsXpk3Flk
	EIc02zA==
X-Google-Smtp-Source: AGHT+IH8TUiCIUmGct1M9zy+GdpApTV9fmzLMykQj2DnCZErPsRffEGEaC3DdH3pdqy+xR/WNJTUpLLJX54=
X-Received: from pjj13.prod.google.com ([2002:a17:90b:554d:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e804:b0:231:8030:74a5
 with SMTP id d9443c01a7336-233f25f3ddcmr57732765ad.32.1748017511542; Fri, 23
 May 2025 09:25:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 May 2025 09:25:00 -0700
In-Reply-To: <20250523162504.3281680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523162504.3281680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523162504.3281680-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Posted Interrupt PIR changes for 6.16
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Clean up and optimize KVM's processing of the PIR based on the approach taken
by the kernel for posted MSIs, and then dedup the two users so that any future
optimizations/fixes benefit both parties.

The following changes since commit 45eb29140e68ffe8e93a5471006858a018480a45:

  Merge branch 'kvm-fixes-6.15-rc4' into HEAD (2025-04-24 13:39:34 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pir-6.16

for you to fetch changes up to edaf3eded386257b0e6504f6b2c29fd8d84c8d29:

  x86/irq: KVM: Add helper for harvesting PIR to deduplicate KVM and posted MSIs (2025-04-24 11:19:41 -0700)

----------------------------------------------------------------
KVM x86 posted interrupt changes for 6.16:

Refine and optimize KVM's software processing of the PIR, and ultimately share
PIR harvesting code between KVM and the kernel's Posted MSI handler

----------------------------------------------------------------
Sean Christopherson (8):
      x86/irq: Ensure initial PIR loads are performed exactly once
      x86/irq: Track if IRQ was found in PIR during initial loop (to load PIR vals)
      KVM: VMX: Ensure vIRR isn't reloaded at odd times when sync'ing PIR
      x86/irq: KVM: Track PIR bitmap as an "unsigned long" array
      KVM: VMX: Process PIR using 64-bit accesses on 64-bit kernels
      KVM: VMX: Isolate pure loads from atomic XCHG when processing PIR
      KVM: VMX: Use arch_xchg() when processing PIR to avoid instrumentation
      x86/irq: KVM: Add helper for harvesting PIR to deduplicate KVM and posted MSIs

 arch/x86/include/asm/posted_intr.h | 78 ++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/irq.c              | 63 +++++-------------------------
 arch/x86/kvm/lapic.c               | 20 +++++-----
 arch/x86/kvm/lapic.h               |  4 +-
 arch/x86/kvm/vmx/posted_intr.h     |  2 +-
 5 files changed, 95 insertions(+), 72 deletions(-)

