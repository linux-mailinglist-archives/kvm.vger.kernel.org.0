Return-Path: <kvm+bounces-47045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A55ABCB74
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16967167A3B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235C9223DEF;
	Mon, 19 May 2025 23:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b6HgbQQv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D87223300
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697313; cv=none; b=DHK+HJd1n0s4W62UWhtLjlZtIGCfNizmoecVK/QXPjauRMSJqcXYhahQP0hJU6ra3fXNScHYIuwDZpQKY3AUkQtcjdw/9OMvaODELqLOj50AMqOVIv0w1xe8IeKb74elPjwtpsDILB+u+ATlbDamfirZU92Dg6ixA6ZpeneDbVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697313; c=relaxed/simple;
	bh=KT85hNb1nPKLSeD3d7tvXp+kHVg/bRVevrkhmaFdrRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F3usKJh+7Gc6g8KHKYK8dL66+a+hwktZwXLd5lp/hlKSuWdx1NogAGT9bSSBsawI5ADLgAZk0RwIQC2pD+tEA+dcB16QFNax4JsCF00f1WgiezCd4uh6Tl55KAp9GWQtQ3JVEAvKaJJOz3HqVajYs2wLpz3gSoNEp6mtlRD2HB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b6HgbQQv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30ec5cc994eso1724966a91.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697311; x=1748302111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UnY357EqX+lx3OIGqzNGUHT0chY9mSMI7laKdfKayYM=;
        b=b6HgbQQvP/HIqwqCV3Qh52BzubgGNZ5l4esc9k2VbJ9v3ar0B2rPytosPzNts4OfEl
         VyRDB0DNMRkuZ5uIOgbUzY041E7BKAasPct7LC2E+YVdr4v8ymxOUbscaySUGsQNycs5
         iEoxr6o4rr6tUPRFYL6/8ki+cbrbzV/cKjemKwglB4ZuOI68RUKPFirBBHLXpIc2AdpY
         J2+QWiUriTcd2aeRzboz2VGMZgP3v+aQgsf97qYBPIKlWDRNhPTmGT4AK5WVNuqlpqYG
         UstL4kgyDyxsh8ORAcKEh8gpfYd4D20/7n7s1TTU9MfVotRYWyRfN1M9/m6DDJ7Iq8wu
         FkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697311; x=1748302111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UnY357EqX+lx3OIGqzNGUHT0chY9mSMI7laKdfKayYM=;
        b=Y39e8E9OWbZ5LVF2Fu8ExRipXu448R6GBNkieUSvtvBNuKA5moY8Dpkgu0ULxTr0UY
         kQF6deDsciJ14TswWrd4ePAvfDLRr6iuxNhFqqoK3A3f92OfE3N8TeUPS7Z49QFjPlSo
         +6Kkazevzbpi+1n9Sv6K1XM0VA56Kbv0faJATHkj9OXANypXZuSKrpTa5+RBVGa0wIZ1
         PaKZUtSjODqbV00vlxiC3crjU4FxmxN93xQrd/XYKTewNKVv69w5GDP+r7sr1q2u6/x3
         DXPSdx/lZRwjH9pPSWAcFe9+aLmlDDxD2IecohWDP/hytqEoTZb/i6YxUdkQTtQzsBbn
         NAWg==
X-Gm-Message-State: AOJu0YxaKr+3oIKcgRRW/qcKPKuE0+P47EZxQW6SK2j0qlkHqhLC1Qrq
	ISYYmRB6OvnmxIRy4R4/ENcE4ucDItM3YbmQe5m9vhIzQkV6t089c5xg/Kr4nQfZk/DEpddNt5G
	nV96ocA==
X-Google-Smtp-Source: AGHT+IHtFtCumxzhTipUqWyCeTaKG2mOIq8hIVX0ltQyCIbzXTvUEUCPUiAHhLt3YMkpFIqYrZSkQ53mYqY=
X-Received: from pjbse12.prod.google.com ([2002:a17:90b:518c:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0f:b0:2fa:e9b:33b8
 with SMTP id 98e67ed59e1d1-30e7d5565a9mr25304428a91.18.1747697310989; Mon, 19
 May 2025 16:28:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:03 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-11-seanjc@google.com>
Subject: [PATCH 10/15] KVM: Move x86-only tracepoints to x86's trace.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the I/O APIC tracepoints and trace_kvm_msi_set_irq() to x86, as
__KVM_HAVE_IOAPIC is just code for "x86", and trace_kvm_msi_set_irq()
isn't unique to I/O APIC emulation.

Opportunistically clean up the absurdly messy #includes in ioapic.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c      |  2 +-
 arch/x86/kvm/irq_comm.c    | 10 ++---
 arch/x86/kvm/trace.h       | 78 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/kvm.h | 77 -------------------------------------
 4 files changed, 82 insertions(+), 85 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 7d2d47a6c2b6..151ee9a64c3c 100644
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
index 8c827da3e3d6..adef53dc4fef 100644
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
2.49.0.1101.gccaa498523-goog


