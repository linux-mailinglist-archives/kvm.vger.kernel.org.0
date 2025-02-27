Return-Path: <kvm+bounces-39501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC01DA4725A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 725CF3B4B1C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D4C1EB5EE;
	Thu, 27 Feb 2025 02:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nn0/JtXH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473B1E8334
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622769; cv=none; b=d7oFFpNpibgL9sRanEMi7uPNeQaPJFvtJLtFUQa5PFjrGsJ/N5H5FK5jTsI6m9UD6I8Jvzt8mYyicChTvsfdgEXavTuRyChpjbDPTtO1larT38iWOdECtE4yx57Tguvg/E6dhfhp6t/qiFSW6qcKi3vmfs22TEUWnYImqGWt1a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622769; c=relaxed/simple;
	bh=uls1GZWoryKNI+ZdGNLcku3CfoPFk/9lR0JDodIiYUM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bl3QsYfVF1D3qoYre3six+M1GdFseUN+ija+yvdx31u/wr9QZj+VfUczMwZitx/npsSDmex5iW0QKwl1V695mng7bZAReaX+QP0o4msZ7DOLSvUTAXQp/rL7TW1BqugoleUJuXN7is+UiP+sRHZFmBxojdRZsYkbLIh0x3ncXTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nn0/JtXH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2233b764fc8so7602085ad.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622766; x=1741227566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UfxMQF/rYWh5wJy03aYqaPrcV7f4BOaa6HmKd5c/EfY=;
        b=Nn0/JtXHxutzJ6n/fUVS4j4h157GScc0h43rNHp66lZcSO+UF+aA0aR3xT8RRpiCck
         6uMGqJG9n4RiOb/sgRK1Gy1QspKYb2lPN2P4P64Xv3BdR2RM9FVZn46tIHqOCwlam9Vs
         TBIRrTc4J/4V3erKpGAiBinbXtFTNYMEDZpSmFkmN31/w1UwnAYOiNjxQmYLe9WiYLUs
         A2Ib1dGFrr8r0fAOF7AlWISJfwqVZHklIBEyPAPoQIJeNaPbLQqo+dFcMEGXpjdzAqHQ
         txyQfW6ygJjNTomZTYR/XH1BGRRsNtmJvbSUUMYgSptbbrJMlczObhbePO4HNnVGH8/Q
         HreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622766; x=1741227566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfxMQF/rYWh5wJy03aYqaPrcV7f4BOaa6HmKd5c/EfY=;
        b=XobGMYvpiriNt/gdvAoKhfc549LeLuwQYpWmNRckcz+S4ODOHAnzeg9CuvOjpBYn2y
         ZZl+Fjv054/QabpaE+960KZBhXT+BXSPsIVLj0iPsAeLQM4bHtTCmgbHd6S0jKYpf4JW
         Hq5OiDiaENOKXuznJehAti5NOYlpVtxeNIIF53dqwaHjA3fCAg6skvVFrhC0NZ8d6J3n
         KWdwKvYrw98q9YkitRuSw62hkhIqPMCOBrbpjnDPGWCvjAcn2tjnXkdhU4alGAehBGfe
         AV9NPuZYEEgNFWRYlYjYPIYf0cjV1MIPQmrLMTUZ7cFMI5irs0DVGt+BUYfleLSr7b7A
         +B9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbkMCA389Nw0mt57uBlIfUKkGdNpbRl0TK4fP/C8z3aw0dmF0/ofO533f3i9V9KtYItxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrMZxaVrWFvFPI6h/vCHaAhL9ZArYTtWIhkbWRSmjJ0RBAyUUF
	xHj/UzayC3eMYG+lK5NbH8TAIUm+Kr4yEDQw+e6S4IQ7aIal1nW90iol6HFghKrzpe5CjFqeMTA
	CDQ==
X-Google-Smtp-Source: AGHT+IE7Xj/t7ND33DY7WpQVYCStd1wMVi/xBc5OTLhEqC2e0MCFeJOTyP9t5m80ApVOgGC3SmRws/tVvjE=
X-Received: from pjuw3.prod.google.com ([2002:a17:90a:d603:b0:2fc:2b27:9d35])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec8c:b0:21f:3e2d:7d2e
 with SMTP id d9443c01a7336-2219ffb8b65mr337766155ad.27.1740622765716; Wed, 26
 Feb 2025 18:19:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:29 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-14-seanjc@google.com>
Subject: [PATCH v2 13/38] x86/paravirt: Move handling of unstable PV clocks
 into paravirt_set_sched_clock()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move the handling of unstable PV clocks, of which kvmclock is the only
example, into paravirt_set_sched_clock().  This will allow modifying
paravirt_set_sched_clock() to keep using the TSC for sched_clock in
certain scenarios without unintentionally marking the TSC-based clock as
unstable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/paravirt.h | 7 ++++++-
 arch/x86/kernel/kvmclock.c      | 5 +----
 arch/x86/kernel/paravirt.c      | 6 +++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 041aff51eb50..cfceabd5f7e1 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -28,7 +28,12 @@ u64 dummy_sched_clock(void);
 DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
 DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);
 
-void paravirt_set_sched_clock(u64 (*func)(void));
+void __paravirt_set_sched_clock(u64 (*func)(void), bool stable);
+
+static inline void paravirt_set_sched_clock(u64 (*func)(void))
+{
+	__paravirt_set_sched_clock(func, true);
+}
 
 static __always_inline u64 paravirt_sched_clock(void)
 {
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 223e5297f5ee..aae6fba21331 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -12,7 +12,6 @@
 #include <linux/hardirq.h>
 #include <linux/cpuhotplug.h>
 #include <linux/sched.h>
-#include <linux/sched/clock.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/set_memory.h>
@@ -93,10 +92,8 @@ static noinstr u64 kvm_sched_clock_read(void)
 
 static inline void kvm_sched_clock_init(bool stable)
 {
-	if (!stable)
-		clear_sched_clock_stable();
 	kvm_sched_clock_offset = kvm_clock_read();
-	paravirt_set_sched_clock(kvm_sched_clock_read);
+	__paravirt_set_sched_clock(kvm_sched_clock_read, stable);
 
 	pr_info("kvm-clock: using sched offset of %llu cycles",
 		kvm_sched_clock_offset);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1ccaa3397a67..55c819673a9d 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -14,6 +14,7 @@
 #include <linux/highmem.h>
 #include <linux/kprobes.h>
 #include <linux/pgtable.h>
+#include <linux/sched/clock.h>
 #include <linux/static_call.h>
 
 #include <asm/bug.h>
@@ -85,8 +86,11 @@ static u64 native_steal_clock(int cpu)
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
 
-void paravirt_set_sched_clock(u64 (*func)(void))
+void __paravirt_set_sched_clock(u64 (*func)(void), bool stable)
 {
+	if (!stable)
+		clear_sched_clock_stable();
+
 	static_call_update(pv_sched_clock, func);
 }
 
-- 
2.48.1.711.g2feabab25a-goog


