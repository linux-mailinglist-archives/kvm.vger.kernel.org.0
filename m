Return-Path: <kvm+bounces-49136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB1EAD6191
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99C04165856
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A162472A2;
	Wed, 11 Jun 2025 21:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LrFJRpcU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B29A25B313
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677786; cv=none; b=pmiRmYvGYn1DQmQYuqQxe0xn9w/nMV1hhPP9mra4TWwMOxWTee+ccMxw4WIwji9VbpgR3a3SoIqh9CBxax6JNkodUlVHPTIs8qmUiQFHq0kDYSHxS9/6mVsGjlMzsVfERehE7BQROccMqCog1/xlM2yAnPaqSog61BYV98FUeeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677786; c=relaxed/simple;
	bh=sSXkJ0TZe+ygIMYoASgFqHZzpgqIcoACWrzJR/DJBLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CGEd0yqNktQW3r7Bem3EXfYMmAFbwf8Kqf2m68bqUvCRe0mlySQv1w8xDMc7X0tc2kuEfYMzzuLgNIKowRks0faJKYluLWYNcGkwDXb2pTIlO9XwHTsa0lAUixwO90GZPwXhT9Kdb4nOu+Ikhnui6W9cZoqnMiegCDs5Fs94DkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LrFJRpcU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so260344a91.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677784; x=1750282584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JJ4icDH9pAHV3iqWVHA0f06vGLaBRGgQJvOqw3/pxTI=;
        b=LrFJRpcUJEADYUSmzPUn0YHMijlmTzB+/us70hmARmTBoahEhBFJTW1w6etwjiMEkv
         stJP4lF8oZChezcVx5oN7K2ku6f1wNWHwjUxAkNeROEKpb7tAqvflxI69wjp54cTwd6X
         ga7KcpDC9k6uF2/Snjb1x7D5JQtwpcoh6EkNbVWdd8wTOdEAdu/M72zgaSx92sypw/h2
         3DHDGsMluHyawL/8y8qvX9+oNRgludIIJLAV53kB/n/Ewmeor+y3scGoVMROLAk6YkDy
         vlyinAD+gsZuJ6BE6wtzaIlFvRYNhbYhrcKdtULpf6veR4X4MSjwC5jkQYxRmzc84w38
         cNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677784; x=1750282584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JJ4icDH9pAHV3iqWVHA0f06vGLaBRGgQJvOqw3/pxTI=;
        b=rk85XFE9b6JaHn3c43nCWoB40T+jNwqjfdWhkFx3DUREVOgzMeacy0Pkek1dc1SNGH
         0SUPfgI6es5TThV+EttwaGRbUzrRIYm3ATfLT0ch3ZiWwnNN3m6HTBiDx8JXpPPpdzIp
         8DpYwUrH2B2huStmq7IKsyhXGIIstFsxq+MyXx40NBwe1q35gX+5BCR6uXGi3EZXuuVn
         Swg5ceQDWCmD0opTGXotd4ZnKpFEyb/gmhL1pqIKqNqNSvTfx49AKJJ5XwOTWio+OHDe
         vLCnMZiqV3S38hne9NvenIi3Her59tH6QG0sKfsDqTCFWiIYkroEFpg3VkfvNvHRSvAt
         2wKw==
X-Gm-Message-State: AOJu0YwNd/dLZX59NuIIYOB7w6NIQAj37c2agpun7KClapLdu9Npnyus
	BhH7cqWR809wxcK1JTJooFgKLMLhEmo7oIefzag0I6Bu8DQNzW31oKHxqPNqFAo1TvsMW63IT0C
	dBH8R6g==
X-Google-Smtp-Source: AGHT+IH2RdmBLZckAl0b1aVX3IeMbOtuIQc9imdRugK5KZRJRktWKbTEjRk/bYnXfpJGJM2fLWrWGj4vd8c=
X-Received: from pjur7.prod.google.com ([2002:a17:90a:d407:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d87:b0:313:2adc:b4c4
 with SMTP id 98e67ed59e1d1-313bfbdb37bmr1601072a91.24.1749677783899; Wed, 11
 Jun 2025 14:36:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:52 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-14-seanjc@google.com>
Subject: [PATCH v2 13/18] KVM: Move x86-only tracepoints to x86's trace.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the I/O APIC tracepoints and trace_kvm_msi_set_irq() to x86, as
__KVM_HAVE_IOAPIC is just code for "x86", and trace_kvm_msi_set_irq()
isn't unique to I/O APIC emulation.

Opportunistically clean up the absurdly messy #includes in ioapic.c.

No functional change intended.

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c      |  2 +-
 arch/x86/kvm/irq_comm.c    | 10 ++---
 arch/x86/kvm/trace.h       | 78 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/kvm.h | 77 -------------------------------------
 4 files changed, 82 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 65626da1407f..fa7481814bc6 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -41,11 +41,11 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
-#include <trace/events/kvm.h>
 
 #include "ioapic.h"
 #include "lapic.h"
 #include "irq.h"
+#include "trace.h"
 
 static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
 		bool line_status);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 138c675dc24b..13d84c25e503 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -15,15 +15,11 @@
 #include <linux/export.h>
 #include <linux/rculist.h>
 
-#include <trace/events/kvm.h>
-
-#include "irq.h"
-
+#include "hyperv.h"
 #include "ioapic.h"
-
+#include "irq.h"
 #include "lapic.h"
-
-#include "hyperv.h"
+#include "trace.h"
 #include "x86.h"
 #include "xen.h"
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ba736cbb0587..4ef17990574d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -260,6 +260,84 @@ TRACE_EVENT(kvm_cpuid,
 		  __entry->used_max_basic ? ", used max basic" : "")
 );
 
+#define kvm_deliver_mode		\
+	{0x0, "Fixed"},			\
+	{0x1, "LowPrio"},		\
+	{0x2, "SMI"},			\
+	{0x3, "Res3"},			\
+	{0x4, "NMI"},			\
+	{0x5, "INIT"},			\
+	{0x6, "SIPI"},			\
+	{0x7, "ExtINT"}
+
+TRACE_EVENT(kvm_ioapic_set_irq,
+	    TP_PROTO(__u64 e, int pin, bool coalesced),
+	    TP_ARGS(e, pin, coalesced),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		e		)
+		__field(	int,		pin		)
+		__field(	bool,		coalesced	)
+	),
+
+	TP_fast_assign(
+		__entry->e		= e;
+		__entry->pin		= pin;
+		__entry->coalesced	= coalesced;
+	),
+
+	TP_printk("pin %u dst %x vec %u (%s|%s|%s%s)%s",
+		  __entry->pin, (u8)(__entry->e >> 56), (u8)__entry->e,
+		  __print_symbolic((__entry->e >> 8 & 0x7), kvm_deliver_mode),
+		  (__entry->e & (1<<11)) ? "logical" : "physical",
+		  (__entry->e & (1<<15)) ? "level" : "edge",
+		  (__entry->e & (1<<16)) ? "|masked" : "",
+		  __entry->coalesced ? " (coalesced)" : "")
+);
+
+TRACE_EVENT(kvm_ioapic_delayed_eoi_inj,
+	    TP_PROTO(__u64 e),
+	    TP_ARGS(e),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		e		)
+	),
+
+	TP_fast_assign(
+		__entry->e		= e;
+	),
+
+	TP_printk("dst %x vec %u (%s|%s|%s%s)",
+		  (u8)(__entry->e >> 56), (u8)__entry->e,
+		  __print_symbolic((__entry->e >> 8 & 0x7), kvm_deliver_mode),
+		  (__entry->e & (1<<11)) ? "logical" : "physical",
+		  (__entry->e & (1<<15)) ? "level" : "edge",
+		  (__entry->e & (1<<16)) ? "|masked" : "")
+);
+
+TRACE_EVENT(kvm_msi_set_irq,
+	    TP_PROTO(__u64 address, __u64 data),
+	    TP_ARGS(address, data),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		address		)
+		__field(	__u64,		data		)
+	),
+
+	TP_fast_assign(
+		__entry->address	= address;
+		__entry->data		= data;
+	),
+
+	TP_printk("dst %llx vec %u (%s|%s|%s%s)",
+		  (u8)(__entry->address >> 12) | ((__entry->address >> 32) & 0xffffff00),
+		  (u8)__entry->data,
+		  __print_symbolic((__entry->data >> 8 & 0x7), kvm_deliver_mode),
+		  (__entry->address & (1<<2)) ? "logical" : "physical",
+		  (__entry->data & (1<<15)) ? "level" : "edge",
+		  (__entry->address & (1<<3)) ? "|rh" : "")
+);
+
 #define AREG(x) { APIC_##x, "APIC_" #x }
 
 #define kvm_trace_symbol_apic						    \
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index fc7d0f8ff078..96e581900c8e 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -85,83 +85,6 @@ TRACE_EVENT(kvm_set_irq,
 #endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
 #if defined(__KVM_HAVE_IOAPIC)
-#define kvm_deliver_mode		\
-	{0x0, "Fixed"},			\
-	{0x1, "LowPrio"},		\
-	{0x2, "SMI"},			\
-	{0x3, "Res3"},			\
-	{0x4, "NMI"},			\
-	{0x5, "INIT"},			\
-	{0x6, "SIPI"},			\
-	{0x7, "ExtINT"}
-
-TRACE_EVENT(kvm_ioapic_set_irq,
-	    TP_PROTO(__u64 e, int pin, bool coalesced),
-	    TP_ARGS(e, pin, coalesced),
-
-	TP_STRUCT__entry(
-		__field(	__u64,		e		)
-		__field(	int,		pin		)
-		__field(	bool,		coalesced	)
-	),
-
-	TP_fast_assign(
-		__entry->e		= e;
-		__entry->pin		= pin;
-		__entry->coalesced	= coalesced;
-	),
-
-	TP_printk("pin %u dst %x vec %u (%s|%s|%s%s)%s",
-		  __entry->pin, (u8)(__entry->e >> 56), (u8)__entry->e,
-		  __print_symbolic((__entry->e >> 8 & 0x7), kvm_deliver_mode),
-		  (__entry->e & (1<<11)) ? "logical" : "physical",
-		  (__entry->e & (1<<15)) ? "level" : "edge",
-		  (__entry->e & (1<<16)) ? "|masked" : "",
-		  __entry->coalesced ? " (coalesced)" : "")
-);
-
-TRACE_EVENT(kvm_ioapic_delayed_eoi_inj,
-	    TP_PROTO(__u64 e),
-	    TP_ARGS(e),
-
-	TP_STRUCT__entry(
-		__field(	__u64,		e		)
-	),
-
-	TP_fast_assign(
-		__entry->e		= e;
-	),
-
-	TP_printk("dst %x vec %u (%s|%s|%s%s)",
-		  (u8)(__entry->e >> 56), (u8)__entry->e,
-		  __print_symbolic((__entry->e >> 8 & 0x7), kvm_deliver_mode),
-		  (__entry->e & (1<<11)) ? "logical" : "physical",
-		  (__entry->e & (1<<15)) ? "level" : "edge",
-		  (__entry->e & (1<<16)) ? "|masked" : "")
-);
-
-TRACE_EVENT(kvm_msi_set_irq,
-	    TP_PROTO(__u64 address, __u64 data),
-	    TP_ARGS(address, data),
-
-	TP_STRUCT__entry(
-		__field(	__u64,		address		)
-		__field(	__u64,		data		)
-	),
-
-	TP_fast_assign(
-		__entry->address	= address;
-		__entry->data		= data;
-	),
-
-	TP_printk("dst %llx vec %u (%s|%s|%s%s)",
-		  (u8)(__entry->address >> 12) | ((__entry->address >> 32) & 0xffffff00),
-		  (u8)__entry->data,
-		  __print_symbolic((__entry->data >> 8 & 0x7), kvm_deliver_mode),
-		  (__entry->address & (1<<2)) ? "logical" : "physical",
-		  (__entry->data & (1<<15)) ? "level" : "edge",
-		  (__entry->address & (1<<3)) ? "|rh" : "")
-);
 
 #define kvm_irqchips						\
 	{KVM_IRQCHIP_PIC_MASTER,	"PIC master"},		\
-- 
2.50.0.rc1.591.g9c95f17f64-goog


