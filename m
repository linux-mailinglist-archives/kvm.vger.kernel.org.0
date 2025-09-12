Return-Path: <kvm+bounces-57484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D41C2B55A4C
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:35:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 159625C461B
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:35:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF982E9EB1;
	Fri, 12 Sep 2025 23:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mRcSUT3X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100BC2E8B99
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719480; cv=none; b=QZBO9u200pQbGkOJAAQp70Usr/6z8TZXNqhNo9ZiTQCynOxo4Sq2zU7XmOaJyNHkJWlw2m6DUy6ezSadI0sVzsQJl3w5+txr4G+Wl8rBvExyocvuko6+SrniSLDJ6qfYIFQEaAhHGwjT1CXaGQg0slRVV7kBYOY+7HnpzjuibmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719480; c=relaxed/simple;
	bh=OWTTMi08oveLIrPuJqP45tpmsLGScshtxdeU8uIZNEk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N9qTQQlPZiJp1U8ZQgkX8yv+NkV+rRxRRFcakzjPxm9ITyHJxvELd+QyK8fLQ+OIQCnW+/sY6MaGw0q2D4ci4zWsl2iIuSy0NByLhrmzaPs8eB6yEqC+PtF+WSRxl9Q2UCGw0+PNOLlaf+251V++L0G4RqtRC6oNBkfg8QlYERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mRcSUT3X; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e41e946eso4344207a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719478; x=1758324278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UalbFbYpbYP+6PV9nGy4JWWryNap6zGGgleYmZzrupU=;
        b=mRcSUT3XjYXuFOSCPFJOpRTOY/36djqUjb1k4csghvVxYLpuyMmqz4KSRxzYreceli
         gKnZO7qhPyCNMga3mtnC1dqG1z5QZYDrwRpgPiyaBxTQUBbrHj7TUQ5i9qMvYoiLdgeK
         rshJaQltbKNg8/TmGHxvaNQBwo3k+XmtnAFndg+8TxcsXmb/KxW0vFXbRCtun8zI+3Mu
         sfwbWxEDZe1WbB1leMbfCSK6dr4coLpOmwm5Zy7OZaXvAJpiV3YZK9xxRMkxTP7iP0dV
         xvK5Aslkfv7VosHA0WYugNDXyWOyWo+95k4QY8+5li3qrDR4mdiKXLd2BGrhGr/j2Tes
         CH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719478; x=1758324278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UalbFbYpbYP+6PV9nGy4JWWryNap6zGGgleYmZzrupU=;
        b=SJWREPQb4lpeIgM85qSWBx/2cYPdexSbJvh5z/edv1BQjNW/4YbbTsPv/zPPnicolD
         aP/djJlnwYLxuf+v1us/l06+cp6Rz8ksAm+CAKhodvjsA4nE8PhCQy2R2cmsFQ9XofIp
         C7Faxcj/DE6KJ5n317nlg0pnUGEdQ28vvyDqr5qhx7/CfrZskDfxgx+iWXfk8VlHOCw/
         2ZSper0h1BG8TwRJQxFQ2vbXyY9pcYe0zxKDgXu1E8uskvxyjUJNKkVEQpg/qFnW725N
         nKQ3xoHCnxljoSNOV35g2gz0AtWOK9FyKsQIYeapS99qW5tE/sN+HBRlO+D9Dn30+gEE
         INaA==
X-Gm-Message-State: AOJu0YzWS+x0FQRSESTVX22PHhcFW8GIvUJERqGJNRBfDKuKl9HDHcn0
	BtqXaCn4d6oJmTyrsYFdF6+pORKWEE0kuVyLQt8c7gyNm5gCw2yiPnvojr52uruH23AUy6Psxgj
	AmxUiOQ==
X-Google-Smtp-Source: AGHT+IHUuOlxNOMwEPAMe7F2+HYod0TA3wRiT968IXMC6hLEeFRUjBha/TOLMv9OfQI78AbJpZp4d3uWhq0=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:329:d09b:a3f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c10:b0:32d:d8de:1929
 with SMTP id 98e67ed59e1d1-32de4e7e2ddmr5026221a91.2.1757719478303; Fri, 12
 Sep 2025 16:24:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:19 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-42-seanjc@google.com>
Subject: [PATCH v15 41/41] KVM: VMX: Make CR4.CET a guest owned bit
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

Make CR4.CET a guest-owned bit under VMX by extending
KVM_POSSIBLE_CR4_GUEST_BITS accordingly.

There's no need to intercept changes to CR4.CET, as it's neither
included in KVM's MMU role bits, nor does KVM specifically care about
the actual value of a (nested) guest's CR4.CET value, beside for
enforcing architectural constraints, i.e. make sure that CR0.WP=1 if
CR4.CET=1.

Intercepting writes to CR4.CET is particularly bad for grsecurity
kernels with KERNEXEC or, even worse, KERNSEAL enabled. These features
heavily make use of read-only kernel objects and use a cpu-local CR0.WP
toggle to override it, when needed. Under a CET-enabled kernel, this
also requires toggling CR4.CET, hence the motivation to make it
guest-owned.

Using the old test from [1] gives the following runtime numbers (perf
stat -r 5 ssdd 10 50000):

* grsec guest on linux-6.16-rc5 + cet patches:
  2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )

* grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
  1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )

Not only does not intercepting CR4.CET make the test run ~35% faster,
it's also more stable with less fluctuation due to fewer VMEXITs.

Therefore, make CR4.CET a guest-owned bit where possible.

This change is VMX-specific, as SVM has no such fine-grained control
register intercept control.

If KVM's assumptions regarding MMU role handling wrt. a guest's CR4.CET
value ever change, the BUILD_BUG_ON()s related to KVM_MMU_CR4_ROLE_BITS
and KVM_POSSIBLE_CR4_GUEST_BITS will catch that early.

Link: https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/ [1]
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 36a8786db291..8ddb01191d6f 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,8 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE \
+	 | X86_CR4_CET)
 
 #define X86_CR0_PDPTR_BITS    (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
 #define X86_CR4_TLBFLUSH_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
-- 
2.51.0.384.g4c02a37b29-goog


