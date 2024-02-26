Return-Path: <kvm+bounces-9918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D561867934
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:57:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 938821F25777
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EE41474AE;
	Mon, 26 Feb 2024 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSaROuhD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D656712AAFF;
	Mon, 26 Feb 2024 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958285; cv=none; b=gpbry4X6FuzNjq2DM2VVBMaP4JRzVEGTNVo5fUOzuhGMC8cgk3x8fKroffXy/0r201Ov7yR4k5Xvhy4EK5DXO6+IiKpaADDpsNCV5kD66FoY7jEopjoNW7u0r+3ZW+EUOXlGMNdu9XemXfj8DWtWfy2G6cFX+pKf508ZytPo/3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958285; c=relaxed/simple;
	bh=kcNZ0lhM9kk5ZqiWC7oiKK6STog5OGE3f4B2GekF4Ys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=laVEKoVkM/M6HaFJd3rLs2Ch566I9c7JWWkAmSSkq4G0mbzDS798ps9dHnKpsLSqyupgAjNF2jU+1kF4UwGBKQsj+25B/DrgFncraUjRrh49/+kV5NiogCM4smxtg8ZSj2Ol3rXmst5RoE7esou/nXcKyXo9FkMdWBlCTs71id8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSaROuhD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dc3b4b9b62so26756195ad.1;
        Mon, 26 Feb 2024 06:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958283; x=1709563083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wF5I3QGcDe499zvzwDfAHdHqAxG40+9SQfq6UFOiBbY=;
        b=WSaROuhD9PpSiFeIhsaXzJ4U2q7+OoEyKLiw/VpecKjuf+6Hy2fPROGGc6nahG1Dc2
         xjNZrkCd4wTSOoO7Ak9c94KR3sAkpwu6/avT8e5M+i1r4Ij7nRymqn6xdLgaaml/rfq7
         BCohSMGUT2mG1XeEsIcnpL+RHxzU1nAc/q9jxKNT/2RaDqiz7FfGAxomRP7rlXrMzqcs
         sObS/4vX8gNzzwdD7q5cX3Otrsn4NxNKChWlt7dJ0IxudnSgndrHj3XRPndaygfllkXk
         y1JMxUdHPJk7K06rB69zvHc0oWygJ2aGjEhscwXaCKmso6QL3Bhx7lWbKAZ3jPHUxNfn
         VJ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958283; x=1709563083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wF5I3QGcDe499zvzwDfAHdHqAxG40+9SQfq6UFOiBbY=;
        b=HC5urZi5V2vmO1Y1igWOSdoQcqmcTeLIlgw2Tn94ZUCmLkuaEB2rho8fUllzhpE9FA
         0c8NT0tvQ8jxP0IZCVmh/UOBUg1QZHkROHtqPfkHF0D1c+sDXesWcGKKqo7R0OcT86T9
         ETNl/7DNtCbVXaby4qps/if8ADkPbCDby3SoUcwx98T8miKXXNkhQQeW1iHXxJk+lIZv
         Cc5hJLZYZTZBU5rxFw7lHB7McYnoHS6G3JRVx5YDY8KP+ASktkoAcolbOjPSH4n/trcq
         GIXMC5Hsl4xQKTXTjro3hcuAWodGmtOrfUuz+twBN6WXjP2Q0WWJvC8D7dnKAhJFc0il
         uONQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkkeLVEYBWI4ia/swGVVVR56dQ3Vqe2gYXfUXDe9tb+ZqaNulhh2VUYuuUVau+6aYM/dfhcB7Hsdh71bv4snlx3++X
X-Gm-Message-State: AOJu0YwKFr+YczyNt3kDD3eQHeDOJ4FbC38JNy3AWtJ05kDPhwfSQRTA
	l9GFLA9MXn+xKJIta+WzQOdRrBB8sxk8gPzScHZv7wb8QlI4HV5oTKPJkoti
X-Google-Smtp-Source: AGHT+IEBOatbi0zsLKeC/BI5oxkPGQKl9gN+gvqMHyn8obAn/tdzQdkUPLAn2vjrNgBgJiRxD1DwBw==
X-Received: by 2002:a17:902:c404:b0:1d7:836d:7b3f with SMTP id k4-20020a170902c40400b001d7836d7b3fmr9974536plk.9.1708958283008;
        Mon, 26 Feb 2024 06:38:03 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id ks14-20020a170903084e00b001dc30f13e6asm4018049plb.137.2024.02.26.06.38.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:02 -0800 (PST)
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
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Brian Gerst <brgerst@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Garnier <thgarnie@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 55/73] x86/pvm: Relocate kernel image to specific virtual address range
Date: Mon, 26 Feb 2024 22:36:12 +0800
Message-Id: <20240226143630.33643-56-jiangshanlai@gmail.com>
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

For a PVM guest, it is only allowed to run in the specific virtual
address range provided by the hypervisor. Therefore, the PVM guest needs
to be a PIE kernel and perform relocation during the booting process.
Additionally, for a compressed kernel image, kaslr needs to be disabled;
otherwise, it will fail to boot.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/Kconfig                  |  3 ++-
 arch/x86/kernel/head64_identity.c | 27 +++++++++++++++++++++++++++
 arch/x86/kernel/head_64.S         | 13 +++++++++++++
 arch/x86/kernel/pvm.c             |  5 ++++-
 4 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2ccc8a27e081..1b4bea3db53d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -853,7 +853,8 @@ config KVM_GUEST
 
 config PVM_GUEST
 	bool "PVM Guest support"
-	depends on X86_64 && KVM_GUEST
+	depends on X86_64 && KVM_GUEST && X86_PIE
+	select RELOCATABLE_UNCOMPRESSED_KERNEL
 	default n
 	help
 	  This option enables the kernel to run as a PVM guest under the PVM
diff --git a/arch/x86/kernel/head64_identity.c b/arch/x86/kernel/head64_identity.c
index 4548ad615ecf..4e6a073d9e6c 100644
--- a/arch/x86/kernel/head64_identity.c
+++ b/arch/x86/kernel/head64_identity.c
@@ -20,6 +20,7 @@
 #include <asm/trapnr.h>
 #include <asm/sev.h>
 #include <asm/init.h>
+#include <asm/pvm_para.h>
 
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 extern unsigned int next_early_pgt;
@@ -385,3 +386,29 @@ void __head __relocate_kernel(unsigned long physbase, unsigned long virtbase)
 	}
 }
 #endif
+
+#ifdef CONFIG_PVM_GUEST
+extern unsigned long pvm_range_start;
+extern unsigned long pvm_range_end;
+
+static void __head detect_pvm_range(void)
+{
+	unsigned long msr_val;
+	unsigned long pml4_index_start, pml4_index_end;
+
+	msr_val = __rdmsr(MSR_PVM_LINEAR_ADDRESS_RANGE);
+	pml4_index_start = msr_val & 0x1ff;
+	pml4_index_end = (msr_val >> 16) & 0x1ff;
+	pvm_range_start = (0x1fffe00 | pml4_index_start) * P4D_SIZE;
+	pvm_range_end = (0x1fffe00 | pml4_index_end) * P4D_SIZE;
+}
+
+void __head pvm_relocate_kernel(unsigned long physbase)
+{
+	if (!pvm_detect())
+		return;
+
+	detect_pvm_range();
+	__relocate_kernel(physbase, pvm_range_end - (2UL << 30));
+}
+#endif
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index b8278f05bbd0..1d931bab4393 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -91,6 +91,19 @@ SYM_CODE_START_NOALIGN(startup_64)
 	movq	%rdx, PER_CPU_VAR(this_cpu_off)
 #endif
 
+#ifdef CONFIG_PVM_GUEST
+	leaq	_text(%rip), %rdi
+	call	pvm_relocate_kernel
+#ifdef CONFIG_SMP
+	/* Fill __per_cpu_offset[0] again, because it got relocated. */
+	movabs	$__per_cpu_load, %rdx
+	movabs	$__per_cpu_start, %rax
+	subq	%rax, %rdx
+	movq	%rdx, __per_cpu_offset(%rip)
+	movq	%rdx, PER_CPU_VAR(this_cpu_off)
+#endif
+#endif
+
 	call	startup_64_setup_env
 
 	/* Now switch to __KERNEL_CS so IRET works reliably */
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 2d27044eaf25..fc82c71b305b 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -13,9 +13,12 @@
 #include <asm/cpufeature.h>
 #include <asm/pvm_para.h>
 
+unsigned long pvm_range_start __initdata;
+unsigned long pvm_range_end __initdata;
+
 void __init pvm_early_setup(void)
 {
-	if (!pvm_detect())
+	if (!pvm_range_end)
 		return;
 
 	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
-- 
2.19.1.6.gb485710b


