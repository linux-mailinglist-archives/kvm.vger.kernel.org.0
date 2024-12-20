Return-Path: <kvm+bounces-34193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3789F8965
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6831B16FC13
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825B7134AC;
	Fri, 20 Dec 2024 01:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kVbg8OIm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A6353AC
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734657982; cv=none; b=m/2Pv/M5UGXwiaIvNsIEmLptH8RuZoZsvJm7AWnUZSQKMzPyAnPkMapW2vu85epoNSCyADKv88pxnsnaVEc9VdZgF2Q3UPVAH8i5MBO3Y8qx1Rf3oZRBTDcHw9YVoUL5LYrsw+WVFwhagoy3Uh/daUOas/hiU/IFvE2IMH3YrxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734657982; c=relaxed/simple;
	bh=TCLXqwFwmLMDrwmuSpqcyB7EUIXvzRWGraQwEAz73Oo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=H4AWCVpmm9+qy93T9t2IE9WFAP13GzcwAVy/mqTL8XVo8bVxKKZB1Ku+o7B/74CIZcJSzhhedQSXl0rUha5KG+0jjAZRtKmj2hioXoy9LOCHsMokw/cKGQ28TZy6PB3Xx2OBK/Byy7HcrPrvkAKgVOcex42BcT0EVyKaNcU7ogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kVbg8OIm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef91d5c863so1309461a91.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734657979; x=1735262779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWYvHz9fM4KjcB+AnKzAVNHAbTmmX5uwW6sODCmo1gs=;
        b=kVbg8OImxs8HMioudnOESEpoV5qjw2ULbRWsXxk90pyLAk6ys4Ar9Jb4AHCLb96Ue6
         EurutWzgF76yGIGO52IVnYPKPsLL7HjDhWU2s95PZ89F7CIx/8ETG6+I4OrnCDYi3wKB
         yMesN4OcUXQyCX8UxBufq01ryR/BjHyQoyBAfg7Qoyqr+OLdqddgaU/U/Ifoo9Z8UBiv
         eJgBnUW2fyp844vuMgCPmmZXaBPTX/GEt3lHeVlL8jpWZtnLRznaYYKpvYUBsHvB3+JO
         wVOX7c7dP5SzZUkwVS824bb0ZDnIBbSbUZ1U5WdPV0lRTEr6XyPGcLyjxUsPGT/bMQly
         z97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734657979; x=1735262779;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWYvHz9fM4KjcB+AnKzAVNHAbTmmX5uwW6sODCmo1gs=;
        b=btQJl9mcNgO6i0lWZE4DN8YaadfyGG4f4jrClwmDSS5cvvMChF9t21pinqTsML/AKO
         TQLk17kQRLdrWfD+Rs9YV5CvPB8A5OWiw74mRzivHo7Ww5FQo88BJTkoNCeYNF9DYQJG
         8G40YN7ZEJHIqQmJ9yVQf0cMgvZus529p+RB8Q6he9e5l/KpPbjJserNVLFTzIWCihL6
         i5xp9lywPlsotTMOMBZZRyn+Uz9znVB7FIGRUQtisbszK++rb+910HhGLgVK64RC4oZy
         f55vJhevciOdjw2qfyW/3eel20HPdkVWkMHSMAp42hfuv1TCxtlCSnUWF1NRznV8rgW9
         WSrQ==
X-Gm-Message-State: AOJu0Yy4nNyI5Bwzeu1AG1zn/rqHBTKG5TpLkwFCNsWJXe3o/FetjqGX
	DuLf1vvuWfClIxJGc8YyvXV0HL+53tG/s+dxxeU2qOyZ/fZf/tZ9fcwG8vtlC/hYFbVbnZuswc9
	uKA==
X-Google-Smtp-Source: AGHT+IG+5c9SrJO5xry8RVPssSWfXw9IHN+FSthC+5Hv7QBecTBRBBhL3VDJOaA1466ABt58kduoIeSJmJc=
X-Received: from pjyr15.prod.google.com ([2002:a17:90a:e18f:b0:2f4:47fc:7f17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5183:b0:2ee:5111:a54b
 with SMTP id 98e67ed59e1d1-2f452eec7dcmr1409339a91.31.1734657979513; Thu, 19
 Dec 2024 17:26:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:26:17 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220012617.3513898-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Add helpers for locally (un)blocking IRQs on x86
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Copy KVM-Unit-Tests' x86 helpers for emitting STI and CLI, comments and
all, and use them throughout x86 selftests.  The safe_halt() and sti_nop()
logic in particular benefits from centralized comments, as the behavior
isn't obvious unless the reader is already aware of the STI shadow.

Cc: Manali Shukla <Manali.Shukla@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     | 40 +++++++++++++++++++
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  6 ++-
 .../selftests/kvm/x86/svm_int_ctl_test.c      |  5 +--
 .../selftests/kvm/x86/ucna_injection_test.c   |  2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  3 +-
 .../selftests/kvm/x86/xapic_state_test.c      |  4 +-
 .../selftests/kvm/x86/xen_shinfo_test.c       |  5 +--
 7 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index d60da8966772..1f9798ed71f1 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1339,6 +1339,46 @@ static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
 	GUEST_ASSERT(!ret);
 }
 
+/*
+ * Execute HLT in an STI interrupt shadow to ensure that a pending IRQ that's
+ * intended to be a wake event arrives *after* HLT is executed.  Modern CPUs,
+ * except for a few oddballs that KVM is unlikely to run on, block IRQs for one
+ * instruction after STI, *if* RFLAGS.IF=0 before STI.  Note, Intel CPUs may
+ * block other events beyond regular IRQs, e.g. may block NMIs and SMIs too.
+ */
+static inline void safe_halt(void)
+{
+	asm volatile("sti; hlt");
+}
+
+/*
+ * Enable interrupts and ensure that interrupts are evaluated upon return from
+ * this function, i.e. execute a nop to consume the STi interrupt shadow.
+ */
+static inline void sti_nop(void)
+{
+	asm volatile ("sti; nop");
+}
+
+/*
+ * Enable interrupts for one instruction (nop), to allow the CPU to process all
+ * interrupts that are already pending.
+ */
+static inline void sti_nop_cli(void)
+{
+	asm volatile ("sti; nop; cli");
+}
+
+static inline void sti(void)
+{
+	asm volatile("sti");
+}
+
+static inline void cli(void)
+{
+	asm volatile ("cli");
+}
+
 void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index 22c0c124582f..2b5b4bc6ef7e 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -63,8 +63,10 @@ static void receiver_code(void *hcall_page, vm_vaddr_t pgs_gpa)
 	/* Signal sender vCPU we're ready */
 	ipis_rcvd[vcpu_id] = (u64)-1;
 
-	for (;;)
-		asm volatile("sti; hlt; cli");
+	for (;;) {
+		safe_halt();
+		cli();
+	}
 }
 
 static void guest_ipi_handler(struct ex_regs *regs)
diff --git a/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
index 916e04248fbb..917b6066cfc1 100644
--- a/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
@@ -42,10 +42,7 @@ static void l2_guest_code(struct svm_test_data *svm)
 	x2apic_write_reg(APIC_ICR,
 		APIC_DEST_SELF | APIC_INT_ASSERT | INTR_IRQ_NUMBER);
 
-	__asm__ __volatile__(
-		"sti\n"
-		"nop\n"
-	);
+	sti_nop();
 
 	GUEST_ASSERT(vintr_irq_called);
 	GUEST_ASSERT(intr_irq_called);
diff --git a/tools/testing/selftests/kvm/x86/ucna_injection_test.c b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
index 57f157c06b39..1e5e564523b3 100644
--- a/tools/testing/selftests/kvm/x86/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86/ucna_injection_test.c
@@ -86,7 +86,7 @@ static void ucna_injection_guest_code(void)
 	wrmsr(MSR_IA32_MCx_CTL2(UCNA_BANK), ctl2 | MCI_CTL2_CMCI_EN);
 
 	/* Enables interrupt in guest. */
-	asm volatile("sti");
+	sti();
 
 	/* Let user space inject the first UCNA */
 	GUEST_SYNC(SYNC_FIRST_UCNA);
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index a76078a08ff8..6228c0806e89 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -106,7 +106,8 @@ static void halter_guest_code(struct test_data_page *data)
 		data->halter_tpr = xapic_read_reg(APIC_TASKPRI);
 		data->halter_ppr = xapic_read_reg(APIC_PROCPRI);
 		data->hlt_count++;
-		asm volatile("sti; hlt; cli");
+		safe_halt();
+		cli();
 		data->wake_count++;
 	}
 }
diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
index 88bcca188799..fdebff1165c7 100644
--- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
@@ -18,7 +18,7 @@ struct xapic_vcpu {
 
 static void xapic_guest_code(void)
 {
-	asm volatile("cli");
+	cli();
 
 	xapic_enable();
 
@@ -38,7 +38,7 @@ static void xapic_guest_code(void)
 
 static void x2apic_guest_code(void)
 {
-	asm volatile("cli");
+	cli();
 
 	x2apic_enable();
 
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index a59b3c799bb2..287829f850f7 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -191,10 +191,7 @@ static void guest_code(void)
 	struct vcpu_runstate_info *rs = (void *)RUNSTATE_VADDR;
 	int i;
 
-	__asm__ __volatile__(
-		"sti\n"
-		"nop\n"
-	);
+	sti_nop();
 
 	/* Trigger an interrupt injection */
 	GUEST_SYNC(TEST_INJECT_VECTOR);

base-commit: dcab55cef6f247a71a75a239d4063018dc83a671
-- 
2.47.1.613.gc27f4b7a9f-goog


