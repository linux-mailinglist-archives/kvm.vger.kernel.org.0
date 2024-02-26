Return-Path: <kvm+bounces-9930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8303F867952
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A572C1C2B1CB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C8414EFDD;
	Mon, 26 Feb 2024 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2Ro8LPC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6623912FB08;
	Mon, 26 Feb 2024 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958373; cv=none; b=tYkm8GmiqRWcpIJvad8p/vJkbfOnkUvbuTHL/7vQq70e41aSXCZsq3IsLqcLbJzM2KhaVI0RJQCb7MGqP7bwHNv4X4azPIDYVibRw8AQmQWWH1cky1gIVFOaR1e257NHG3SiZRW4rF09GBtYtuKU640A/1K5vqGia/V7nLXzu8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958373; c=relaxed/simple;
	bh=Bea4NFK57XqYcwmGW3u9vwK3rfjIWPn3hka4ZBXdlRI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pSfZgF56wcvyw3x8zxyrpjzEvdfTB2WYUgRkynSkPY92r0/uZ4FG3HcCt+c+MvyqTl3iPvgbYDWUpFvB+Lcy7OW/0ydKa8onFJ+DZfJsxV6haniCmsXqTAE6ORm1RHT/MP3P/a/Mda1I0PLVUcEA6Dx+yl4Ztrfz0bB1ZVVGOv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G2Ro8LPC; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29abd02d0d9so755795a91.0;
        Mon, 26 Feb 2024 06:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958370; x=1709563170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ior8XKCEXf7aXrFeNTkdMW+EWEMRN6zdLbeEAiFvpAA=;
        b=G2Ro8LPC6lmc7Ns1tmqNZrcTwamHWVD90dZBmnkxkRYJNjz8p/6xWKj5w2ziz5Nzsc
         Yu05oicSsjgNezvSw9ayhRTP6N7IwkvfYoy59bHHOkm9twAI9mfC/n7JBxpqiFwLneg0
         k6KgP+W1I1cbaY4BBHJwLGPjJsTc5lf1Jags3IZvZ5V+UcrPjgcvw5eQClhqcq6L7LG1
         RPfU5wFKFcL68ABrkNqJOcvD/aAHH4BpAClQJKCmRPxTwRDssVcOLgUOexdDDB+LfAvZ
         jIm79ALIDAN0nk5UrceUivvdFGUtk2p/lq/8Nd0REu/ymNUvrJ8hpEJ3aBehT/vvwLCo
         sKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958370; x=1709563170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ior8XKCEXf7aXrFeNTkdMW+EWEMRN6zdLbeEAiFvpAA=;
        b=nkFzQnlyZ7rKln63gLr3n6bCl0MK+qb8A2R6sXlVR7hZ07KVNIIZ81D//G8pBcfXFM
         WVYboOybNoewZWrIwrk04UUZbYivt5DpHO7C4f2ph5pi/vTbV8RVKo7G2S2kzT0poRRl
         Jxj5EummZl8Bg8wI1JhhkIYnxrWWcbeuU32bAiOJ4td9bmelD9pCevrSYprnXcs1h9bg
         05yxDfgCffXp0tHZpg4Z5Kj9Sp/vLH+AOCMzPmqsH4IV09NFtUK4jqsJrzLSp6bU/UAT
         eHn/jRXD864QGqsHhFoheI0t8KVt1UhoCZnXJb+6E6J62fveURa4RzaiRXclEB4qkV6c
         FFPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL1M5u3TOypsM5vTEIDZw8KAXyBZ0z7XmoDef6yMJqvhVKwasKPkqp0N6LFDyEQUxD3+4XICzE79bb28OtOO+vhV7S
X-Gm-Message-State: AOJu0YzsHshDd4y6NvuRYu5+BipCBQl/5G3VUXj2n940spMBlJ4w38ot
	INCS8Tpi7i8bqWxCIV9d00DYkA017ZPZqjR8B9jwif5VHj33JyqTvb7PrkVY
X-Google-Smtp-Source: AGHT+IHoSxSZtuAdPrrHHtoExIG3TjunA4TlOnLEguOcCRn6HdDkvG8S8QuYGxBARatgSLkWNS1Jxg==
X-Received: by 2002:a17:90b:4f43:b0:29a:be10:b829 with SMTP id pj3-20020a17090b4f4300b0029abe10b829mr1808536pjb.44.1708958370508;
        Mon, 26 Feb 2024 06:39:30 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id dj8-20020a17090ad2c800b00297138f0496sm6721446pjb.31.2024.02.26.06.39.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:30 -0800 (PST)
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
Subject: [RFC PATCH 67/73] x86/pvm: Implement cpu related PVOPS
Date: Mon, 26 Feb 2024 22:36:24 +0800
Message-Id: <20240226143630.33643-68-jiangshanlai@gmail.com>
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

The MSR read/write operations are in the hot path, so use hypercalls in
their PVOPS to enhance performance. Additionally, it is important to
ensure that load_gs_index() and load_tls() notify the hypervisor in
their PVOPS.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/Kconfig      |  1 +
 arch/x86/kernel/pvm.c | 85 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 32a2ab49752b..60e28727580a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -855,6 +855,7 @@ config PVM_GUEST
 	bool "PVM Guest support"
 	depends on X86_64 && KVM_GUEST && X86_PIE && !KASAN
 	select PAGE_TABLE_ISOLATION
+	select PARAVIRT_XXL
 	select RANDOMIZE_MEMORY
 	select RELOCATABLE_UNCOMPRESSED_KERNEL
 	default n
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index d39550a8159f..12a35bef9bb8 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -73,6 +73,81 @@ static __always_inline long pvm_hypercall3(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
+static void pvm_load_gs_index(unsigned int sel)
+{
+	if (sel & 4) {
+		pr_warn_once("pvm guest doesn't support LDT");
+		this_cpu_write(pvm_vcpu_struct.user_gsbase, 0);
+	} else {
+		unsigned long base;
+
+		preempt_disable();
+		base = pvm_hypercall1(PVM_HC_LOAD_GS, sel);
+		__this_cpu_write(pvm_vcpu_struct.user_gsbase, base);
+		preempt_enable();
+	}
+}
+
+static unsigned long long pvm_read_msr_safe(unsigned int msr, int *err)
+{
+	switch (msr) {
+	case MSR_FS_BASE:
+		*err = 0;
+		return rdfsbase();
+	case MSR_KERNEL_GS_BASE:
+		*err = 0;
+		return this_cpu_read(pvm_vcpu_struct.user_gsbase);
+	default:
+		return native_read_msr_safe(msr, err);
+	}
+}
+
+static unsigned long long pvm_read_msr(unsigned int msr)
+{
+	switch (msr) {
+	case MSR_FS_BASE:
+		return rdfsbase();
+	case MSR_KERNEL_GS_BASE:
+		return this_cpu_read(pvm_vcpu_struct.user_gsbase);
+	default:
+		return pvm_hypercall1(PVM_HC_RDMSR, msr);
+	}
+}
+
+static int notrace pvm_write_msr_safe(unsigned int msr, u32 low, u32 high)
+{
+	unsigned long base = ((u64)high << 32) | low;
+
+	switch (msr) {
+	case MSR_FS_BASE:
+		wrfsbase(base);
+		return 0;
+	case MSR_KERNEL_GS_BASE:
+		this_cpu_write(pvm_vcpu_struct.user_gsbase, base);
+		return 0;
+	default:
+		return pvm_hypercall2(PVM_HC_WRMSR, msr, base);
+	}
+}
+
+static void notrace pvm_write_msr(unsigned int msr, u32 low, u32 high)
+{
+	pvm_write_msr_safe(msr, low, high);
+}
+
+static void pvm_load_tls(struct thread_struct *t, unsigned int cpu)
+{
+	struct desc_struct *gdt = get_cpu_gdt_rw(cpu);
+	unsigned long *tls_array = (unsigned long *)gdt;
+
+	if (memcmp(&gdt[GDT_ENTRY_TLS_MIN], &t->tls_array[0], sizeof(t->tls_array))) {
+		native_load_tls(t, cpu);
+		pvm_hypercall3(PVM_HC_LOAD_TLS, tls_array[GDT_ENTRY_TLS_MIN],
+			       tls_array[GDT_ENTRY_TLS_MIN + 1],
+			       tls_array[GDT_ENTRY_TLS_MIN + 2]);
+	}
+}
+
 void __init pvm_early_event(struct pt_regs *regs)
 {
 	int vector = regs->orig_ax >> 32;
@@ -302,6 +377,16 @@ void __init pvm_early_setup(void)
 	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
 	setup_force_cpu_cap(X86_FEATURE_PV_GUEST);
 
+	/* PVM takes care of %gs when switching to usermode for us */
+	pv_ops.cpu.load_gs_index = pvm_load_gs_index;
+	pv_ops.cpu.cpuid = pvm_cpuid;
+
+	pv_ops.cpu.read_msr = pvm_read_msr;
+	pv_ops.cpu.write_msr = pvm_write_msr;
+	pv_ops.cpu.read_msr_safe = pvm_read_msr_safe;
+	pv_ops.cpu.write_msr_safe = pvm_write_msr_safe;
+	pv_ops.cpu.load_tls = pvm_load_tls;
+
 	wrmsrl(MSR_PVM_VCPU_STRUCT, __pa(this_cpu_ptr(&pvm_vcpu_struct)));
 	wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_early_kernel_event_entry - 256);
 	wrmsrl(MSR_PVM_SUPERVISOR_REDZONE, PVM_SUPERVISOR_REDZONE_SIZE);
-- 
2.19.1.6.gb485710b


