Return-Path: <kvm+bounces-41147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8731CA62529
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A8FA7AFB82
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B9819F12D;
	Sat, 15 Mar 2025 03:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZnE+4jTn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D44819D897
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742008007; cv=none; b=Cv+ZRZ2KgvxSwL3nuaA9zD7xh7EIeB1yK/6AJXEqevs+i0o8M2ItIPUoMWn+saoCnq1z81s68aTDiVf1PfJM24ox7kfqmfaJbdfts9jM3DA7twDMRsMr/PprQ1vfHTPsrhjDIf/VPRHNV5ydjGeYU3IoR+my7HPSov5wO2pEScU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742008007; c=relaxed/simple;
	bh=6Ct4ueqTACT+40mgDDmV2LJlgiyUgvMZWTdwVdt+2AI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Usxiy15zxwZqi2QLdCHUQWYDJRcdh56B4EevMroELsLZQKySyEL09TG7g+UdQ/LjtPgKhnSZVg7l1f0TEenB7/WBZUviaZ9p6UGVDWEVAYmdsW/k98naPzF81+mcFtZdbaNrBNmQoiQMfZ3EySBf3mRee9yuqayOtO3yg1iS3Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZnE+4jTn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff68033070so473402a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742008005; x=1742612805; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Rqh78WRgDr7mgiGuvPqk9U1mgup3ydPWLYkuR7DIMcg=;
        b=ZnE+4jTnlbpy00U4j0HY28sde+eEOjoiEsddr8wce1yFa3en54ot9o407cEAIIoB5F
         qBnLJBUllfU6zfE6AAE0HuOBVVctF9EcfV+mz1a1b7sjkre0Se+Hrq0pJlM8YYKzldGI
         nC4p7MjI/YIT29mE1IKONotGxwL/hJS1DSNvW5N/LMoO6Pg6IUg5pYiuqWLUHUbmiTEm
         alGFNDOP+bY0Uzeab7rSiT9jFAthbxnx94DQrNb6sBSaOrQXenCegqLs+xYdfJDHE0gu
         NW/SE0XQhu6GdMroMvM8VgOOjfmIDLsc64gxmG50+gFZSk9BbWAb455oq5pFn7UExP9E
         4hRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742008005; x=1742612805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rqh78WRgDr7mgiGuvPqk9U1mgup3ydPWLYkuR7DIMcg=;
        b=GC134bcTdglWmXeegCjZX6wCCSjDQUBIrZKdgw2dgG/r7eEMhW7mQG7zjAqJdN+WA+
         fpkjw3yyeJBcfuzT7KVx8uLWIyU13YPPAOJ0ZLtrh4PN3/i4GBsKO9VrlaPzN4y+IoGR
         tVTfpQZ6yeYFeEOrMTqx6KUcu/zADp+5kUdeAPm9UbdUllXG+9dRIdpkkOc91SDDlzH1
         YLSpJ1K1NQhxDUhFLF+1ndmqX1OHKquZArctrnLUBR2EoMjtfm9ln40t+5waVh8XO39M
         n4hfn1YXgg3kfkJcFr/6D2KVhLczqm14y7OmgeFzur/2Kejvrra/Ojm2kAY9GuZ1ipJd
         msIw==
X-Forwarded-Encrypted: i=1; AJvYcCX1uAR1sLuAjxOjFv5LrukeqyDbkGB7f2eDUD+rBqNwQCt+m1obe6bEdZ+6OggUvcW+1yE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkggTmeNa/uK4l/Hsqs7wbGyoaxr8YDJRN7Wx9dfeeejM8C/Tk
	mf5TSo5GCr0n5lRIczcT7ENOAsXT54f6dt5OiSqJBx2fD769wv/2hDoijBY3OWgtHc+iLPepOGI
	V/A==
X-Google-Smtp-Source: AGHT+IFf+R/IdkB9dMtQz0tp3pLrCC/oKPbyU6izvyqg+RZIyQsLWC+utkXYHnwPh9OG4z6WE2OE7PdpDaY=
X-Received: from pjbdy6.prod.google.com ([2002:a17:90b:6c6:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d10:b0:2fe:b470:dde4
 with SMTP id 98e67ed59e1d1-30151cd796dmr7085921a91.12.1742008005673; Fri, 14
 Mar 2025 20:06:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:29 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-9-seanjc@google.com>
Subject: [PATCH 8/8] x86/irq: KVM: Add helper for harvesting PIR to
 deduplicate KVM and posted MSIs
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that posted MSI and KVM harvesting of PIR is identical, extract the
code (and posted MSI's wonderful comment) to a common helper.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/posted_intr.h | 65 ++++++++++++++++++++++++++++++
 arch/x86/kernel/irq.c              | 50 +----------------------
 arch/x86/kvm/lapic.c               | 16 +-------
 3 files changed, 68 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index c3e6e4221a5b..6b1ddebbf06a 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -1,8 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _X86_POSTED_INTR_H
 #define _X86_POSTED_INTR_H
+
+#include <asm/cmpxchg.h>
+#include <asm/rwonce.h>
 #include <asm/irq_vectors.h>
 
+#include <linux/bitmap.h>
+
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
 
@@ -26,6 +31,66 @@ struct pi_desc {
 	u32 rsvd[6];
 } __aligned(64);
 
+/*
+ * De-multiplexing posted interrupts is on the performance path, the code
+ * below is written to optimize the cache performance based on the following
+ * considerations:
+ * 1.Posted interrupt descriptor (PID) fits in a cache line that is frequently
+ *   accessed by both CPU and IOMMU.
+ * 2.During software processing of posted interrupts, the CPU needs to do
+ *   natural width read and xchg for checking and clearing posted interrupt
+ *   request (PIR), a 256 bit field within the PID.
+ * 3.On the other side, the IOMMU does atomic swaps of the entire PID cache
+ *   line when posting interrupts and setting control bits.
+ * 4.The CPU can access the cache line a magnitude faster than the IOMMU.
+ * 5.Each time the IOMMU does interrupt posting to the PIR will evict the PID
+ *   cache line. The cache line states after each operation are as follows,
+ *   assuming a 64-bit kernel:
+ *   CPU		IOMMU			PID Cache line state
+ *   ---------------------------------------------------------------
+ *...read64					exclusive
+ *...lock xchg64				modified
+ *...			post/atomic swap	invalid
+ *...-------------------------------------------------------------
+ *
+ * To reduce L1 data cache miss, it is important to avoid contention with
+ * IOMMU's interrupt posting/atomic swap. Therefore, a copy of PIR is used
+ * when processing posted interrupts in software, e.g. to dispatch interrupt
+ * handlers for posted MSIs, or to move interrupts from the PIR to the vIRR
+ * in KVM.
+ *
+ * In addition, the code is trying to keep the cache line state consistent
+ * as much as possible. e.g. when making a copy and clearing the PIR
+ * (assuming non-zero PIR bits are present in the entire PIR), it does:
+ *		read, read, read, read, xchg, xchg, xchg, xchg
+ * instead of:
+ *		read, xchg, read, xchg, read, xchg, read, xchg
+ */
+static __always_inline bool pi_harvest_pir(unsigned long *pir,
+					   unsigned long *pir_vals)
+{
+	bool found_irq = false;
+	int i;
+
+	for (i = 0; i < NR_PIR_WORDS; i++) {
+		pir_vals[i] = READ_ONCE(pir[i]);
+		if (pir_vals[i])
+			found_irq = true;
+	}
+
+	if (!found_irq)
+		return false;
+
+	for (i = 0; i < NR_PIR_WORDS; i++) {
+		if (!pir_vals[i])
+			continue;
+
+		pir_vals[i] = arch_xchg(&pir[i], 0);
+	}
+
+	return true;
+}
+
 static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
 {
 	return test_and_set_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 704c104ff7a4..b98a5abdeaec 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -373,60 +373,14 @@ void intel_posted_msi_init(void)
 	this_cpu_write(posted_msi_pi_desc.ndst, destination);
 }
 
-/*
- * De-multiplexing posted interrupts is on the performance path, the code
- * below is written to optimize the cache performance based on the following
- * considerations:
- * 1.Posted interrupt descriptor (PID) fits in a cache line that is frequently
- *   accessed by both CPU and IOMMU.
- * 2.During posted MSI processing, the CPU needs to do 64-bit read and xchg
- *   for checking and clearing posted interrupt request (PIR), a 256 bit field
- *   within the PID.
- * 3.On the other side, the IOMMU does atomic swaps of the entire PID cache
- *   line when posting interrupts and setting control bits.
- * 4.The CPU can access the cache line a magnitude faster than the IOMMU.
- * 5.Each time the IOMMU does interrupt posting to the PIR will evict the PID
- *   cache line. The cache line states after each operation are as follows:
- *   CPU		IOMMU			PID Cache line state
- *   ---------------------------------------------------------------
- *...read64					exclusive
- *...lock xchg64				modified
- *...			post/atomic swap	invalid
- *...-------------------------------------------------------------
- *
- * To reduce L1 data cache miss, it is important to avoid contention with
- * IOMMU's interrupt posting/atomic swap. Therefore, a copy of PIR is used
- * to dispatch interrupt handlers.
- *
- * In addition, the code is trying to keep the cache line state consistent
- * as much as possible. e.g. when making a copy and clearing the PIR
- * (assuming non-zero PIR bits are present in the entire PIR), it does:
- *		read, read, read, read, xchg, xchg, xchg, xchg
- * instead of:
- *		read, xchg, read, xchg, read, xchg, read, xchg
- */
 static __always_inline bool handle_pending_pir(unsigned long *pir, struct pt_regs *regs)
 {
-	int i, vec = FIRST_EXTERNAL_VECTOR;
+	int vec = FIRST_EXTERNAL_VECTOR;
 	unsigned long pir_copy[NR_PIR_WORDS];
-	bool found_irq = false;
 
-	for (i = 0; i < NR_PIR_WORDS; i++) {
-		pir_copy[i] = READ_ONCE(pir[i]);
-		if (pir_copy[i])
-			found_irq = true;
-	}
-
-	if (!found_irq)
+	if (!pi_harvest_pir(pir, pir_copy))
 		return false;
 
-	for (i = 0; i < NR_PIR_WORDS; i++) {
-		if (!pir_copy[i])
-			continue;
-
-		pir_copy[i] = arch_xchg(&pir[i], 0);
-	}
-
 	for_each_set_bit_from(vec, pir_copy, FIRST_SYSTEM_VECTOR)
 		call_irq_handler(vec, regs);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b65e0f7223fe..1c611b84b8ab 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -659,7 +659,6 @@ bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 {
 	unsigned long pir_vals[NR_PIR_WORDS];
 	u32 *__pir = (void *)pir_vals;
-	bool found_irq = false;
 	u32 i, vec;
 	u32 irr_val, prev_irr_val;
 	int max_updated_irr;
@@ -667,22 +666,9 @@ bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 	max_updated_irr = -1;
 	*max_irr = -1;
 
-	for (i = 0; i < NR_PIR_WORDS; i++) {
-		pir_vals[i] = READ_ONCE(pir[i]);
-		if (pir_vals[i])
-			found_irq = true;
-	}
-
-	if (!found_irq)
+	if (!pi_harvest_pir(pir, pir_vals))
 		return false;
 
-	for (i = 0; i < NR_PIR_WORDS; i++) {
-		if (!pir_vals[i])
-			continue;
-
-		pir_vals[i] = arch_xchg(&pir[i], 0);
-	}
-
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
 		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


