Return-Path: <kvm+bounces-9926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84788867948
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CCBD1C25D50
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CDB14A4DE;
	Mon, 26 Feb 2024 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0DHxCtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A89712F59E;
	Mon, 26 Feb 2024 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958347; cv=none; b=oOVSByAtxUtxBOyx2iHjq4l9TNI6pKMYoj4QdMaD6yl0B8wQfw3OREBCYAxpATnTzsyC7tSXC9IpbpWncvXBX/6XRoaGUcVZb2axzBdJSgb1RjtN9oXQFpuAg0J7aWkgSPVUTOp/zrrImG4UvZGkU3vGw1I0neO7UBI3Y9cNu0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958347; c=relaxed/simple;
	bh=ag8Q2ckwAIVyhLdyymUbxED1UwHq/TzpNBbOj/uIlg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D44EfaVkAyko3gT5hB6NDktMH0da0/T6JDZXp96kZK7Fphq6uisnbfncKYTCASl6U93lsOxU9sVeIL+KIxByjAaiwTrvuRoEks8GdGs7LuXBCbqwHX9rJAdJBZ9iRTnmuYqB9PczZ3tvj3lzF1xkwLDZ5pPjLV+M0VLPf6LYKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0DHxCtV; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5a034c12090so1301395eaf.2;
        Mon, 26 Feb 2024 06:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958345; x=1709563145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwNizCD/fZ2aImktIeVQE2S+xAX0NlliquuDy32Zgd8=;
        b=L0DHxCtVnNhJxDvTs0P7h6tOdL0Ox+vhwp5bttqAiHEWnxChsLb6wnIE/qJUQq4TL6
         vCS78FndR5hKD4nFREPWypqxjHzJ94/W1J+m43cjve7tLVNQ3kJOZJPnFsBZI/zf9a0a
         hwiNSoOIMhHxsarTppXIx8ksHVC5uSWf8LQIKBLFkIlBcOZL1XTFAN6q8mCgFWN6/J9K
         0e5s+Lu+EMUAhSYWCiTAFgitEMt8+o1nVprCutLd04t5Nb/UjM9s6bvVYLqdU8GDau55
         h5SIdjFMP+aSuG6UMSdEk/2NaAj5pESVeo2Z9zT7qbK3tUGAyOz0VccAiaiaDYEYIpDK
         BoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958345; x=1709563145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fwNizCD/fZ2aImktIeVQE2S+xAX0NlliquuDy32Zgd8=;
        b=snom6wXwP+SGSiPihiSbk9SwyK5Fm1+VsAxBS8zxQ8e5F+G9oHx1XfqWkTV2+YMsck
         vNTZ5dRTF6uQtPOYELTHHtKGVC1GAtE/fZltD4Bb8KcBZIyWZc4v7gwMsQ+7V23kNEfr
         NR9DscQvoEWlEHP0F8kben7WVnE8EfkY4/bw3sMorZdHCFgelP9nfuqELSL6Ckr94927
         /f6u1QTCzgjMAcrxOBXqoFBpI/6J8UQB1Uyom8nO/F4JqqzydY2mHyVfqefmg9/Mt9Fc
         H+FvCJf0agScIc1FLMx0vItl9oRL1NrncnSZJbA7HMFKYyVU4yAH0zCe4ldO8hjXQ0jl
         bhSA==
X-Forwarded-Encrypted: i=1; AJvYcCUQd3QsmdwIcExkhi9OTmjEmktDyKUfFZbu6TvgsIEIozsfgOucXReqmcT0GnORxGBKEEM4lJ+fCDIEWGhsv7lxT3NU
X-Gm-Message-State: AOJu0Yz8J/8pb5WVTDYNEzWvvc4RqjcCvKDtDqI2szk0ZwFg5UZaXz81
	TEGFQPjKdNwrTsHizPctryfHYfJkeT2dcl+d0WGrry2pn7rz59nCatKnvk7D
X-Google-Smtp-Source: AGHT+IEv6+SMIA4XY6jCfQBvGsq2ofA2gzV1dxKYvTWh4nVs4/v+GPoNA3ko3QSN22pGFMrnguOfgg==
X-Received: by 2002:a05:6358:190a:b0:17b:5b6a:de9d with SMTP id w10-20020a056358190a00b0017b5b6ade9dmr9800743rwm.23.1708958344977;
        Mon, 26 Feb 2024 06:39:04 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id o7-20020a63f147000000b005dc9439c56bsm4053749pgk.13.2024.02.26.06.39.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:04 -0800 (PST)
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
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 63/73] x86/pvm: Add hypercall support
Date: Mon, 26 Feb 2024 22:36:20 +0800
Message-Id: <20240226143630.33643-64-jiangshanlai@gmail.com>
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

For the PVM guest, it will use the syscall instruction as the hypercall
instruction and follow the KVM hypercall call convention.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/entry/entry_64_pvm.S   | 15 +++++++++++
 arch/x86/include/asm/pvm_para.h |  1 +
 arch/x86/kernel/pvm.c           | 46 +++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/arch/x86/entry/entry_64_pvm.S b/arch/x86/entry/entry_64_pvm.S
index 256baf86a9f3..abb57e251e73 100644
--- a/arch/x86/entry/entry_64_pvm.S
+++ b/arch/x86/entry/entry_64_pvm.S
@@ -52,6 +52,21 @@ SYM_CODE_START(entry_SYSCALL_64_pvm)
 	jmp	entry_SYSCALL_64_after_hwframe
 SYM_CODE_END(entry_SYSCALL_64_pvm)
 
+.pushsection .noinstr.text, "ax"
+SYM_FUNC_START(pvm_hypercall)
+	push	%r11
+	push	%r10
+	movq	%rcx, %r10
+	UNWIND_HINT_SAVE
+	syscall
+	UNWIND_HINT_RESTORE
+	movq	%r10, %rcx
+	popq	%r10
+	popq	%r11
+	RET
+SYM_FUNC_END(pvm_hypercall)
+.popsection
+
 /*
  * The new RIP value that PVM event delivery establishes is
  * MSR_PVM_EVENT_ENTRY for vector events that occur in user mode.
diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index bfb08f0ea293..72c74545dba6 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -87,6 +87,7 @@ static inline bool pvm_kernel_layout_relocate(void)
 
 void entry_SYSCALL_64_pvm(void);
 void pvm_user_event_entry(void);
+void pvm_hypercall(void);
 void pvm_retu_rip(void);
 void pvm_rets_rip(void);
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index b3b4ff0bbc91..352d74394c4a 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -27,6 +27,52 @@ unsigned long pvm_range_end __initdata;
 
 static bool early_traps_setup __initdata;
 
+static __always_inline long pvm_hypercall0(unsigned int nr)
+{
+	long ret;
+
+	asm volatile("call pvm_hypercall"
+		     : "=a"(ret)
+		     : "a"(nr)
+		     : "memory");
+	return ret;
+}
+
+static __always_inline long pvm_hypercall1(unsigned int nr, unsigned long p1)
+{
+	long ret;
+
+	asm volatile("call pvm_hypercall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1)
+		     : "memory");
+	return ret;
+}
+
+static __always_inline long pvm_hypercall2(unsigned int nr, unsigned long p1,
+					   unsigned long p2)
+{
+	long ret;
+
+	asm volatile("call pvm_hypercall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2)
+		     : "memory");
+	return ret;
+}
+
+static __always_inline long pvm_hypercall3(unsigned int nr, unsigned long p1,
+					   unsigned long p2, unsigned long p3)
+{
+	long ret;
+
+	asm volatile("call pvm_hypercall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
+	return ret;
+}
+
 void __init pvm_early_event(struct pt_regs *regs)
 {
 	int vector = regs->orig_ax >> 32;
-- 
2.19.1.6.gb485710b


