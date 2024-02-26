Return-Path: <kvm+bounces-9919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D537867958
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:03:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED864B2D966
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E07148303;
	Mon, 26 Feb 2024 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UdFfYKj2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC3512AAFF;
	Mon, 26 Feb 2024 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958294; cv=none; b=UPrNhFKlDxbEoATPjZ2HqgcyzBckcmTGCew0R1bZfKLzCssSzeKPNoOCi5VBpVGsAJLVZSx4+soXHWFeuqTrkRQ4Vmud0Ox4XzjfYFyICEMmH35R+/sLmYrOlOXG8ex7zUveHRZiZufudl+qT4hxWYc6g8/aY5Z7J9zZrGeBr84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958294; c=relaxed/simple;
	bh=NCJKU3nUGxcKaNdfIK0z08Xjq9FRBvLE0kkArrKryjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fpbyyj7xcz/D2nqv9ocsbIsobbmMKX5xvlJNUenldoIJq8hBCQIR4YA8fNOsP7nknzpGI7ryl6ozO5tCmEOSd7vuO2nIznZ7aETCKl/SHe/7eXNTGu4wVTE9+zHTrNXXd5eeNuUAlyPlmaiw2M2RwzOtHqobIVthqkP/J55MUFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UdFfYKj2; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ce6b5e3c4eso2357652a12.2;
        Mon, 26 Feb 2024 06:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958291; x=1709563091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+gfvWhFbgTyzu48YJx+Ed8XWBq6XxX8rbNsTiG4trvc=;
        b=UdFfYKj2m0CkfU1m8MUlXMQRv/yzFe8J5gH4DZM4kOxfrlljZt9jMPUC9WJA5S47BO
         KvrrlSfmfJWWWxY7HGCJvusbmJAk9mA/Shvhh9OuGipYCyjR6ejUVQu3GcFVgOTFkCpD
         7l0xzxiqmCO1kbSyoxXWhsHOg/7qQqBr6T4rypfVn+GCfA4p2quZZvgJXgq55yZjaz1d
         EBBxycpLnJgk7bNL0yunuF8vNmYi7Ei4LPKyXpANwqvkK+vi2KEc7EOsf5VDw9lDtqjb
         mT+NGg0T4iWJuVhYpAtzFy0eFhm1RofetySkObRKnS6+jFrudo2kG+Veh15noBMHVv1W
         awlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958291; x=1709563091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gfvWhFbgTyzu48YJx+Ed8XWBq6XxX8rbNsTiG4trvc=;
        b=liY+99YVASWTL5LqcJPMHUHfJhPHLe2Im3r1bZzHq6HkxZy7cVvS8OCgvNQ8CldAYB
         EGvdo8JotXwa10OO26v+0Y/V1C0QrTotZgvik9+ntA6s+RiNjZe4nvJHWV5/N1lXGXZs
         GROHJy+zzepW8wrrdSdL5kINWF6VWd8X5mzz3HYy6J0nCxBq+EVewFO9jkxL58VmX0uS
         jyxy8xCtoGdvQ49NYOr5Oo5Cs/H+f7B/xHA0X8TUWqugeRZsHJK6VZFJZ2GkMHbx8Gl/
         X4En0RScFJUn/Aa5kxBkAJe0UUCQnZ/gAXfAY28cFRYHXfahdQwgJj+nYXOLJ91NkFGt
         bO6g==
X-Forwarded-Encrypted: i=1; AJvYcCW0KlHWyTTS+tSZt/FNmWbiujAIpHZOzulkdBjiwLV6KtK+/yc2VMjfEC1exaXidM5fgIz63RnmGUxfMk7Cjd60EjSpHy8kcowZsjMKWiDCD16ht2DXBONn6pTBByPmmWOM81TFHhQ9Eg==
X-Gm-Message-State: AOJu0YyUXYtezgc8w2/JtEnfyBngx0nSSRfREs0ZfWbLMX9iPFtZoKZh
	+SYqobDl8xafRXnCT+ZSrFwS2uLiC+IAzYExLQrKe1kTUt43Q7cSGOvD/zsR
X-Google-Smtp-Source: AGHT+IEIutnYKn12v5tvNLy/G9rTRg1goq2sEiyOH6n7oCM/wCUKEcvtJKvKWrDR0plMg8cjveFEyw==
X-Received: by 2002:a17:902:8349:b0:1dc:1fda:202e with SMTP id z9-20020a170902834900b001dc1fda202emr6685293pln.51.1708958291395;
        Mon, 26 Feb 2024 06:38:11 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d3-20020a170903230300b001d9edac54b1sm4015055plh.171.2024.02.26.06.38.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:11 -0800 (PST)
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
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Darren Hart <dvhart@infradead.org>,
	Andy Shevchenko <andy@infradead.org>,
	xen-devel@lists.xenproject.org,
	platform-driver-x86@vger.kernel.org
Subject: [RFC PATCH 56/73] x86/pvm: Relocate kernel image early in PVH entry
Date: Mon, 26 Feb 2024 22:36:13 +0800
Message-Id: <20240226143630.33643-57-jiangshanlai@gmail.com>
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

For a PIE kernel, it runs in a high virtual address in the PVH entry, so
it needs to relocate the kernel image early in the PVH entry for the PVM
guest.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/init.h       |  5 +++++
 arch/x86/kernel/head64_identity.c |  5 -----
 arch/x86/platform/pvh/enlighten.c | 22 ++++++++++++++++++++++
 arch/x86/platform/pvh/head.S      |  4 ++++
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index cc9ccf61b6bd..f78edef60253 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -4,6 +4,11 @@
 
 #define __head	__section(".head.text")
 
+#define SYM_ABS_VA(sym) ({					\
+	unsigned long __v;					\
+	asm("movabsq $" __stringify(sym) ", %0":"=r"(__v));	\
+	__v; })
+
 struct x86_mapping_info {
 	void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
 	void *context;			 /* context for alloc_pgt_page */
diff --git a/arch/x86/kernel/head64_identity.c b/arch/x86/kernel/head64_identity.c
index 4e6a073d9e6c..f69f9904003c 100644
--- a/arch/x86/kernel/head64_identity.c
+++ b/arch/x86/kernel/head64_identity.c
@@ -82,11 +82,6 @@ static void __head set_kernel_map_base(unsigned long text_base)
 }
 #endif
 
-#define SYM_ABS_VA(sym) ({					\
-	unsigned long __v;					\
-	asm("movabsq $" __stringify(sym) ", %0":"=r"(__v));	\
-	__v; })
-
 static unsigned long __head sme_postprocess_startup(struct boot_params *bp, pmdval_t *pmd)
 {
 	unsigned long vaddr, vaddr_end;
diff --git a/arch/x86/platform/pvh/enlighten.c b/arch/x86/platform/pvh/enlighten.c
index 00a92cb2c814..8c64c31c971b 100644
--- a/arch/x86/platform/pvh/enlighten.c
+++ b/arch/x86/platform/pvh/enlighten.c
@@ -1,8 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/acpi.h>
+#include <linux/pgtable.h>
 
 #include <xen/hvc-console.h>
 
+#include <asm/init.h>
 #include <asm/io_apic.h>
 #include <asm/hypervisor.h>
 #include <asm/e820/api.h>
@@ -113,6 +115,26 @@ static void __init hypervisor_specific_init(bool xen_guest)
 		xen_pvh_init(&pvh_bootparams);
 }
 
+#ifdef CONFIG_PVM_GUEST
+void pvm_relocate_kernel(unsigned long physbase);
+
+void __init pvm_update_pgtable(unsigned long physbase)
+{
+	pgdval_t *pgd;
+	pudval_t *pud;
+	unsigned long base;
+
+	pvm_relocate_kernel(physbase);
+
+	pgd = (pgdval_t *)init_top_pgt;
+	base = SYM_ABS_VA(_text);
+	pgd[pgd_index(base)] = pgd[0];
+	pgd[pgd_index(page_offset_base)] = pgd[0];
+	pud = (pudval_t *)level3_ident_pgt;
+	pud[pud_index(base)] = (unsigned long)level2_ident_pgt + _KERNPG_TABLE_NOENC;
+}
+#endif
+
 /*
  * This routine (and those that it might call) should not use
  * anything that lives in .bss since that segment will be cleared later.
diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index baaa3fe34a00..127f297f7257 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -109,6 +109,10 @@ SYM_CODE_START_LOCAL(pvh_start_xen)
 	wrmsr
 
 #ifdef CONFIG_X86_PIE
+#ifdef CONFIG_PVM_GUEST
+	leaq	_text(%rip), %rdi
+	call	pvm_update_pgtable
+#endif
 	movabs  $2f, %rax
 	ANNOTATE_RETPOLINE_SAFE
 	jmp *%rax
-- 
2.19.1.6.gb485710b


