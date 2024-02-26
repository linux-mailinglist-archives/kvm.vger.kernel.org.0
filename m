Return-Path: <kvm+bounces-9934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7F486795D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:03:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7952C2930BA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E375151CD4;
	Mon, 26 Feb 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsMtG2cv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1213112FF65;
	Mon, 26 Feb 2024 14:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958394; cv=none; b=It7QpyFN28its+hFCi0EtC82jQba0dBfdNMNIclsLJRq/5cZ1SrrYQPqHu7uEsCc3ej5J1rII3FWfY37W4LjfIRUOyDDt62Fa/GG/ANVioxVUzEZAzB9tZzJBN7bYhOY5NRTYEDpvZY8PKLWeHa7zGawpvwK5hheokug07hmoKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958394; c=relaxed/simple;
	bh=BruDZbIrLo4Z+hSY5ZDPzvxJsJH0osgJZhLwKVbC7e4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tXiml4QqNQgRxU65Tt95oVUIycuZkcwLGTNQ3Vgj8CO4Aze2PKpadF13YXK2EoZhFC/OcLPErcM5eR+Pl+t2k5D/2IS0rd52DXGjYdq6Meb/rlWD747IWUOUg7xwmsx/Qiou6lsjRLTm2ssOjgAl+dZYl2cGgzQIu2PB+mmLe/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsMtG2cv; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dcab44747bso5069485ad.1;
        Mon, 26 Feb 2024 06:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958392; x=1709563192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+APYg9JF6Nj9qghtD9fNf7B9/lqpn0PpSUUFoa6b37s=;
        b=ZsMtG2cv/P/ms+BaQgznmyeKNlwzUMpbRQAVhggt/I5V50wC/4uRQ5P7aSkEAO6s/F
         XIxsQlYbAXALsUlLVjpKwTuaY4gVmAjXmFC+smV7zRXCxFPf/eL4xle1LVjB2iYmYn0Q
         +ff39tv/QYJbaTRCTv17CBY2PC3uF7cyDasf3BzWYChKsNQFHq3hfnYTWwAfkQXszdRb
         q+nB91lskGq+DAPV9jR7RnR0YvBJxcUyxLVtMC9NAgGFjgkowedY9OHhSkYg/7AEJn34
         NELxXKVcJbCdRc0XdMMiyEhkwJRwvhPtzTbo3KVM13snnmSJRDW+9WwVAz/lUKRzZt+K
         pwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958392; x=1709563192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+APYg9JF6Nj9qghtD9fNf7B9/lqpn0PpSUUFoa6b37s=;
        b=Su4527EYAfvSnlg9XOUz9m3bsl0TPE5kJmdoeVnna5VEI+N09ClmLhQFayfI3rv++f
         2lWExhfDuKC228GCnIZ/mMqQnMtltN8v/dbl+9tddmxNpfVc38y2kGN62XjeNns2CSjL
         HPUdbwg5kL/wik3Hkw8+FblzgrE3gED83o61YUTItCDfDHyD6xN8Wq9aTpQeCM1BW7Gb
         T5re2L/ZtlsaCJeg5EnAvCu/R4AyW96E/8p3Ak+aKz6knX+N7nJF4fIXMHZRYeGshpZw
         cVvjqQ0/ss4Ix9BjWpFKnINB/QTuv+j6imFnlLHK2QEIMP/oHgPZq4jC56jnKQhs6K3P
         oOSw==
X-Forwarded-Encrypted: i=1; AJvYcCUxNWce/wTvVsqIUe1hKSfdWWijlfVCXqp0TbF0/jdMG6y1iJ7vJ7kxNjuxoaIS6GtlUhIpPcCwIu9KA2MGJSGkZq3f
X-Gm-Message-State: AOJu0YxtP1OYPTy1D6iN5H/pM051ewkrW8BR41ncwOyOAWLM7cXGVGxh
	lvQIEOIPOWQDiyhum0MXwUXqcGDoN7wBNAlV25kK2sru8bNsv7exg+Hw5HW1
X-Google-Smtp-Source: AGHT+IFFKf1/p22eofDzSLdOn4ig5DMTPrqWRXSvqSeQhcPwjZzCENJYGc+o2E87m6hgwQmJkreMaQ==
X-Received: by 2002:a17:903:258d:b0:1dc:63fd:39c1 with SMTP id jb13-20020a170903258d00b001dc63fd39c1mr5445941plb.54.1708958391807;
        Mon, 26 Feb 2024 06:39:51 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902eb4600b001dc0e5ad5desm4032787pli.114.2024.02.26.06.39.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:51 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
Subject: [RFC PATCH 71/73] x86/pvm: Adapt pushf/popf in this_cpu_cmpxchg16b_emu()
Date: Mon, 26 Feb 2024 22:36:28 +0800
Message-Id: <20240226143630.33643-72-jiangshanlai@gmail.com>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

The pushf/popf instructions in this_cpu_cmpxchg16b_emu() are
non-privilege instructions, so they cannot be trapped and emulated,
which could cause a boot failure. However, since the cmpxchg16b
instruction is supported for PVM guest. we can patch
this_cpu_cmpxchg16b_emu() and use cmpxchg16b directly.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kernel/pvm.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 1dc2c0fb7daa..567ea19d569c 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -413,6 +413,34 @@ __visible noinstr void pvm_event(struct pt_regs *regs)
 		common_interrupt(regs, vector);
 }
 
+asm (
+	".pushsection .rodata				\n"
+	".global pvm_cmpxchg16b_emu_template		\n"
+	"pvm_cmpxchg16b_emu_template:			\n"
+	"	cmpxchg16b %gs:(%rsi)			\n"
+	"	ret					\n"
+	".global pvm_cmpxchg16b_emu_tail		\n"
+	"pvm_cmpxchg16b_emu_tail:			\n"
+	".popsection					\n"
+);
+
+extern u8 this_cpu_cmpxchg16b_emu[];
+extern u8 pvm_cmpxchg16b_emu_template[];
+extern u8 pvm_cmpxchg16b_emu_tail[];
+
+static void __init pvm_early_patch(void)
+{
+	/*
+	 * The pushf/popf instructions in this_cpu_cmpxchg16b_emu() are
+	 * non-privilege instructions, so they cannot be trapped and emulated,
+	 * which could cause a boot failure. However, since the cmpxchg16b
+	 * instruction is supported for PVM guest. we can patch
+	 * this_cpu_cmpxchg16b_emu() and use cmpxchg16b directly.
+	 */
+	memcpy(this_cpu_cmpxchg16b_emu, pvm_cmpxchg16b_emu_template,
+	       (unsigned int)(pvm_cmpxchg16b_emu_tail - pvm_cmpxchg16b_emu_template));
+}
+
 extern void pvm_early_kernel_event_entry(void);
 
 /*
@@ -457,6 +485,8 @@ void __init pvm_early_setup(void)
 	wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_early_kernel_event_entry - 256);
 	wrmsrl(MSR_PVM_SUPERVISOR_REDZONE, PVM_SUPERVISOR_REDZONE_SIZE);
 	wrmsrl(MSR_PVM_RETS_RIP, (unsigned long)(void *)pvm_rets_rip);
+
+	pvm_early_patch();
 }
 
 void pvm_setup_event_handling(void)
-- 
2.19.1.6.gb485710b


