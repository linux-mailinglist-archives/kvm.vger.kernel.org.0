Return-Path: <kvm+bounces-9932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A7A867957
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A3361F2DC78
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8814614F986;
	Mon, 26 Feb 2024 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baCu8jxg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5796B14F975;
	Mon, 26 Feb 2024 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958384; cv=none; b=PNk6giOU5Us8xKasPHFblfCJzl/+aJsYOM0gy9MWcAgzxHM/aNB/aIUe8jpk39rtzkpXOpcQErRCjSUN6S5YCDSy9GLOwtu7nUw2iTLfRi/GYLZn/teVT/KcJWetgK8bEAwpuXdyAblVTDwXElIqzfvdaT3xyzemd53vJ9wkNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958384; c=relaxed/simple;
	bh=QoH9b93OPUhcL2ymZ5y++6zNb6PgFanAxGJWrP1JJ0U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crBDLbEH3oQ2qnu+bec/j/m/cNoeOlI4dZP5O78mxtxh3Er1R+Kw54UFaHwKPAf/pbbkeehwYWbywNBsE/GwafMo2brx6VKJU/YjdKyL4mao1zkely1/osvWZ6r0SIIIu5V2w7BA4VJ9ZGkVJD/Mr3fsQdA0AUtRzov/qJxrK1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=baCu8jxg; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dcad814986so4575105ad.0;
        Mon, 26 Feb 2024 06:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958382; x=1709563182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyUwxtfxrCb1Y6YMuPhhZhGxcT5rupSBWwJ7nh5wrj4=;
        b=baCu8jxggOlFmm32ZNTeTq/kh3WFkP0czlhly5opQogjyr0JRVQeOQk9sURG2mJapy
         4V+tYza4FsgD4jFoEkSyc5CpqCobD8PA/6cewMx2OurmV/ZawSEIaTT+jKmIU/mlNDs6
         DBTGc1AdIntbZDEAFCjG5YQ2zlzHs1A13VZfCRusGOD9Z7iuodQwaGZdOvZbMiX+sDMk
         zALizPMe5+BZMeaKmGHZBdiGUwOPIqE+N4IEH73wRPbyXv3yFH6j2pg/VJMNNz2lbWhS
         0dPfcL0r+5JlNLEmfAQTNCQ/N0OSUgSjgrF1sQR2bV5/wSosfyxjpmu152GveVT2JhEl
         N0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958382; x=1709563182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyUwxtfxrCb1Y6YMuPhhZhGxcT5rupSBWwJ7nh5wrj4=;
        b=cD0lIJ6kdxAVqtnQakxzVGuTxL+db2cmFiIeMo7UmEVxfpqkqZqgIfI92Wf8DSx3+t
         FZrTvOSktcgAnF/q++UK+P4YYG6grhkl0a4VtSWWISqwwiOWkQ0vYhvUpvKGM2uIjLwl
         /1Y+oSNsCtCrWn5jrZgSDErKMyh8QBgVuBiusrom3fS47HRYpoWZInu/yYTnaR4h39in
         9+EKVb/BrAuIRtrFzUeBnLfNSsq0lcl1f5pR8qRd1it/m1Y6ORenIB35oT/2pWl+Uzn+
         SB5sz+emaidss7b4I+YebbAnCeAMMXMqls0ifgYrzO/gVqeGbKjyCXalou4EJsP42+mS
         9jfg==
X-Forwarded-Encrypted: i=1; AJvYcCXM3kD1MrVOf2G20ASCSTpbO380nStnmZ2jynQyAY2L8rCPKEAgtSireh5swqrwYFdjc3NNHc/hNUa2sgeZdGJnTe2q
X-Gm-Message-State: AOJu0Ywt2qghaUN6qZkzPjyEwn9aqVtUfnNaX1BCbwp0X2Rr3fvfPY3Y
	Oe0s4o8cY1HKp2CNi+7NURLkWVv+mVJBBYC/AnI38XHSxVicq+b/zQnNwd4u
X-Google-Smtp-Source: AGHT+IEn1oqsBh4RGj9UVLCZqdOuZh4zIFwWm/F6YVc6bX7bWgQDy8/p7G+ALzLCY13ngxYKBB6tVw==
X-Received: by 2002:a17:903:2281:b0:1db:35b5:7e37 with SMTP id b1-20020a170903228100b001db35b57e37mr9442029plh.50.1708958382541;
        Mon, 26 Feb 2024 06:39:42 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id ix14-20020a170902f80e00b001dbcb39dd7dsm3992856plb.125.2024.02.26.06.39.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:42 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 69/73] x86/pvm: Implement mmu related PVOPS
Date: Mon, 26 Feb 2024 22:36:26 +0800
Message-Id: <20240226143630.33643-70-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

CR2 is passed directly in the event entry, allowing it to be read
directly in PVOPS. Additionally, write_cr3() for context switch needs to
notify the hypervisor in its PVOPS. For performance reasons, TLB-related
PVOPS utilize hypercalls.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kernel/pvm.c | 56 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index b4522947374d..1dc2c0fb7daa 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -21,6 +21,7 @@
 #include <asm/traps.h>
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct pvm_vcpu_struct, pvm_vcpu_struct);
+static DEFINE_PER_CPU(unsigned long, pvm_guest_cr3);
 
 unsigned long pvm_range_start __initdata;
 unsigned long pvm_range_end __initdata;
@@ -153,6 +154,52 @@ static noinstr void pvm_safe_halt(void)
 	pvm_hypercall0(PVM_HC_IRQ_HALT);
 }
 
+static noinstr unsigned long pvm_read_cr2(void)
+{
+	return this_cpu_read(pvm_vcpu_struct.cr2);
+}
+
+static noinstr void pvm_write_cr2(unsigned long cr2)
+{
+	native_write_cr2(cr2);
+	this_cpu_write(pvm_vcpu_struct.cr2, cr2);
+}
+
+static unsigned long pvm_read_cr3(void)
+{
+	return this_cpu_read(pvm_guest_cr3);
+}
+
+static unsigned long pvm_user_pgd(unsigned long pgd)
+{
+	return pgd | BIT(PTI_PGTABLE_SWITCH_BIT) | BIT(X86_CR3_PTI_PCID_USER_BIT);
+}
+
+static void pvm_write_cr3(unsigned long val)
+{
+	/* Convert CR3_NO_FLUSH bit to hypercall flags. */
+	unsigned long flags = ~val >> 63;
+	unsigned long pgd = val & ~X86_CR3_PCID_NOFLUSH;
+
+	this_cpu_write(pvm_guest_cr3, pgd);
+	pvm_hypercall3(PVM_HC_LOAD_PGTBL, flags, pgd, pvm_user_pgd(pgd));
+}
+
+static void pvm_flush_tlb_user(void)
+{
+	pvm_hypercall0(PVM_HC_TLB_FLUSH_CURRENT);
+}
+
+static void pvm_flush_tlb_kernel(void)
+{
+	pvm_hypercall0(PVM_HC_TLB_FLUSH);
+}
+
+static void pvm_flush_tlb_one_user(unsigned long addr)
+{
+	pvm_hypercall1(PVM_HC_TLB_INVLPG, addr);
+}
+
 void __init pvm_early_event(struct pt_regs *regs)
 {
 	int vector = regs->orig_ax >> 32;
@@ -397,6 +444,15 @@ void __init pvm_early_setup(void)
 	pv_ops.irq.irq_enable = __PV_IS_CALLEE_SAVE(pvm_irq_enable);
 	pv_ops.irq.safe_halt = pvm_safe_halt;
 
+	this_cpu_write(pvm_guest_cr3, __native_read_cr3());
+	pv_ops.mmu.read_cr2 = __PV_IS_CALLEE_SAVE(pvm_read_cr2);
+	pv_ops.mmu.write_cr2 = pvm_write_cr2;
+	pv_ops.mmu.read_cr3 = pvm_read_cr3;
+	pv_ops.mmu.write_cr3 = pvm_write_cr3;
+	pv_ops.mmu.flush_tlb_user = pvm_flush_tlb_user;
+	pv_ops.mmu.flush_tlb_kernel = pvm_flush_tlb_kernel;
+	pv_ops.mmu.flush_tlb_one_user = pvm_flush_tlb_one_user;
+
 	wrmsrl(MSR_PVM_VCPU_STRUCT, __pa(this_cpu_ptr(&pvm_vcpu_struct)));
 	wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_early_kernel_event_entry - 256);
 	wrmsrl(MSR_PVM_SUPERVISOR_REDZONE, PVM_SUPERVISOR_REDZONE_SIZE);
-- 
2.19.1.6.gb485710b


