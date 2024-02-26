Return-Path: <kvm+bounces-9924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6F6867A36
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 893BFB265FD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC63149E00;
	Mon, 26 Feb 2024 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcT2jD8W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E8A149DF2;
	Mon, 26 Feb 2024 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958331; cv=none; b=t8FahfVkj+fVSQqjiUHcEht7IwfzzuBCkCbofw99hfU8LQKDW93UkO6K9FEhn60ARsY6O0MUim8mUd3CpjS89oduU/PG/IsvGRACKAbit29bzPWw6TlMrbnrfGPTwzd8sj/ikn+Iadx/U+Ut3bORZ5RLjQjnfNvJptDoBYP9210=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958331; c=relaxed/simple;
	bh=Kpvu6OKJDmlESu/r7oOCgeLu3G/zXXrBQ7wFNVyEq9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJkFhxrUMGoybzDiuW7YbxR6v5a5OqItH4wDSepnE/2e97yOy6BB7e3fNsLDhRBoX8LUUbWhX64cAUSAlLwkyQZmPsSqKo2Qh4hfspFSpFTI45maLpZgjniydGkBfVXJpR84HHbmReY0Av6+2vqbIBViMF8CS96ZF9eOcQ3/j4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcT2jD8W; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e0f803d9dfso2070735b3a.0;
        Mon, 26 Feb 2024 06:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958329; x=1709563129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kzSWReBljDNFLKeUS+5Afa2lRsM7svYZxZXhjEgYHMY=;
        b=TcT2jD8W87TQtys8SDQbwE84PnMTjaK2EVmFOtPsMSclJr6LmkD++XZ7vTmikrYfqy
         k8wac7zAF1DVQXyTD/CCGSs3/+oO9RYSSgxZBx/CVJI0AHGTRv8CRpzNBb0D/dI4ards
         K8EkkBPp5//K/jL8/Qgz8woNT36Zn95wmyOur0c3lVcJDvrAW8VXEPHlk3sen9vkbkUH
         paioUs3IEVD5K7kOEhue6NnkSl4SojEPx/WrZs3cHSi/HqaeQTVNQ6GVYd3uJJQNKJrz
         OkKMzhA4fjSJf57Pw7a+F8rqgUTUSSzD0Cwb461nfPmvagvmbESC8gTYuMpzRIUkuKEh
         0oTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958329; x=1709563129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kzSWReBljDNFLKeUS+5Afa2lRsM7svYZxZXhjEgYHMY=;
        b=NFgn5UEzpnSkq/8eU/2Ba+gHur7hqmdxFzXxiMG5vVwQydsPgzP09s3aLat9OW0m/5
         LOyQRqubfteTV2P3D4XXD/rDuiVTjx3V1PkTYcBuasLPoaI+0SopvrAre/N8nJzSlipM
         BYDN3+tpjVhEGXoHIsukgSusp+gZGeLtZRiWtahuKPig0F8lcoZc5mPDJUi+aFGmgoDD
         y+67W4xEMQDf2Yc5jDT5OXxCbvWJYd6IYUXMSzp+nq/GABsp+wjO8iD0+WaxyCLACfMU
         ZZ2G6/HC1kYe6jbte3ourxRjKT3n14ZeyhahAks4avJREY2wWDAX5Ss6aSYvj3oL6OK5
         YgYg==
X-Forwarded-Encrypted: i=1; AJvYcCU6xzSS2G0YvwBY/ZiB1Gg2n8N8nrpcmoJp48Ip459vSYLek1KYhMM4tMu26Y1MUMwSvPhmpaGl3jyjF2Qs4tU1Mlfq
X-Gm-Message-State: AOJu0YzRi1ekZdC6gRZbY18PoKmH6IgiI5paBaTATHCt0qGkVy6emPWh
	KLtNIbXrDC2Bf73sj7XQIi+jSTFFy0JWDs/Vdm8xKBRu2zMH+wXoipGzbEXl
X-Google-Smtp-Source: AGHT+IH/x2k47qxnhOEYdzCjBRPg9dbKoudy8fclIz1n+Ihu7Hk4wZHA1MBpxEJ6fq53oUsC3z7yEw==
X-Received: by 2002:a05:6a21:1394:b0:1a0:eea8:933d with SMTP id oa20-20020a056a21139400b001a0eea8933dmr7158469pzb.42.1708958329024;
        Mon, 26 Feb 2024 06:38:49 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id m20-20020a63f614000000b005b7dd356f75sm4070253pgh.32.2024.02.26.06.38.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:48 -0800 (PST)
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
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [RFC PATCH 61/73] x86/pvm: Allow to install a system interrupt handler
Date: Mon, 26 Feb 2024 22:36:18 +0800
Message-Id: <20240226143630.33643-62-jiangshanlai@gmail.com>
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

Add pvm_sysvec_install() to install a system interrupt handler into PVM
system interrupt handler table.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/pvm_para.h |  6 ++++++
 arch/x86/kernel/kvm.c           |  2 ++
 arch/x86/kernel/pvm.c           | 11 +++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index c344185a192c..9216e539fea8 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -6,12 +6,14 @@
 #include <uapi/asm/pvm_para.h>
 
 #ifndef __ASSEMBLY__
+typedef void (*idtentry_t)(struct pt_regs *regs);
 
 #ifdef CONFIG_PVM_GUEST
 #include <asm/irqflags.h>
 #include <uapi/asm/kvm_para.h>
 
 void __init pvm_early_setup(void);
+void __init pvm_install_sysvec(unsigned int sysvec, idtentry_t handler);
 bool __init pvm_kernel_layout_relocate(void);
 
 static inline void pvm_cpuid(unsigned int *eax, unsigned int *ebx,
@@ -68,6 +70,10 @@ static inline void pvm_early_setup(void)
 {
 }
 
+static inline void pvm_install_sysvec(unsigned int sysvec, idtentry_t handler)
+{
+}
+
 static inline bool pvm_kernel_layout_relocate(void)
 {
 	return false;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index de72a5a1f7ad..87b00c279aaf 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -43,6 +43,7 @@
 #include <asm/reboot.h>
 #include <asm/svm.h>
 #include <asm/e820/api.h>
+#include <asm/pvm_para.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -843,6 +844,7 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
 		static_branch_enable(&kvm_async_pf_enabled);
 		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
+		pvm_install_sysvec(HYPERVISOR_CALLBACK_VECTOR, sysvec_kvm_asyncpf_interrupt);
 	}
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 9399e45b3c13..88b013185ecd 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -128,8 +128,6 @@ static noinstr void pvm_handle_INT80_compat(struct pt_regs *regs)
 	exc_general_protection(regs, 0);
 }
 
-typedef void (*idtentry_t)(struct pt_regs *regs);
-
 #define SYSVEC(_vector, _function) [_vector - FIRST_SYSTEM_VECTOR] = sysvec_##_function
 
 #define pvm_handle_spurious_interrupt ((idtentry_t)(void *)spurious_interrupt)
@@ -167,6 +165,15 @@ static idtentry_t pvm_sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 #endif
 };
 
+void __init pvm_install_sysvec(unsigned int sysvec, idtentry_t handler)
+{
+	if (WARN_ON_ONCE(sysvec < FIRST_SYSTEM_VECTOR))
+		return;
+	if (!WARN_ON_ONCE(pvm_sysvec_table[sysvec - FIRST_SYSTEM_VECTOR] !=
+			  pvm_handle_spurious_interrupt))
+		pvm_sysvec_table[sysvec - FIRST_SYSTEM_VECTOR] = handler;
+}
+
 /*
  * some pointers in pvm_sysvec_table are actual spurious_interrupt() who
  * expects the second argument to be the vector.
-- 
2.19.1.6.gb485710b


