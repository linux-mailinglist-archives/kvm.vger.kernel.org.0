Return-Path: <kvm+bounces-18293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 811398D361C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1BA0B24F02
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA7D181BBB;
	Wed, 29 May 2024 12:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBjdCQU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A947F18131C
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984895; cv=none; b=fQMPzy+DrkEQgTt6tCBL9zXeq9UGf1tVv+68nHnz14JvvH+UPlTQi4OyKxIks2S6kAC+ncKm7zgD28UfgYCR0EbXBk1GCxG85oMOI0vNzt3EBGnmKfCsbptdl/fue04BN1nhO3W5kmYfGPmot9Io4BKGV9fzcu9cNydP4H/fe0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984895; c=relaxed/simple;
	bh=RAWRwxx2x29Z9C8sFEWaOgpe83fasv5IFOL7pJOwjNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JV904Z/WjnFYNFFIC5vey7b6dUPGaOtGxQn1dq2xurnovt51CpRbNlO4yLTOgki2CxeD3ZJbEGTCXi3e3JTo1bBNRl6VEVeQkLNtIROvHLPuCmn7Rzsak+kZpgXfsvXxFHVhQGA8trI2JbJbjJO0ZAAJp3hBmvfsfYHz6gHO3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBjdCQU4; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df796aaa57dso2772949276.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984893; x=1717589693; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4CCra/rqIFpxe8HMFYt7fMIj2cwQLIfhoDjzzJPzF3M=;
        b=iBjdCQU4EHK6ZI6z9MtEIgWGV2fEAYZN+WjKBq9bipr/Y57cLzHNDjhm1t5phMOEjT
         a4FDYful+ML5M1K/u1b6Lwzc9GOO206H8dmcRV6h73vowL4/lVV9qTgaQ0HQ2XOF6aVx
         aY7dPicsjgpcgdoq/yNQBLwWNgtQgW/sl0WCHV/Ka2pPt1c84EKrSocyHLveOkOrldfr
         UMscRJzeBEDyoLMK30Dz6CbcqcQqfDvdTtldPRK77EmMke4ywQEOTV3MAOPdA4ZekMLz
         wFrhpUmAXjz9B62sFlIyI7+IEr7JxghbfZRW2v9TTdbde4mOjVBTYJD8VWJwb5XOjZ/2
         GTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984893; x=1717589693;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4CCra/rqIFpxe8HMFYt7fMIj2cwQLIfhoDjzzJPzF3M=;
        b=xNynDX2cYeNdnJAy/AWeLNp/2tx9RIMLhuEvBW08A9c0hk4K/uCMV/wqgMKcGC8RQp
         rNfmhdYQKuG/d8ydkcccGtkL7UG5z/S1e/qXqHL7tSVRJQ3a8MG6nObRJ2Dry58I01R0
         4Rsze2bFrEUYVZiYuR9WprovzQ5dO/jYzLakBZ0oRUP5icY8SJQ7kY7t0QKGtC8tSV2o
         ePOo70ukj1/jbzlme3XzcQq5Eipy51DmxRKi78tQayL+1+BucYyKmfZRzvMKx4JO0POC
         hkqGwlDXrwp93Sdi8YO9YTULgRuRPhfTojSMRYwFsspfX7i14RCGCu408Wnx9nRlc3vo
         4q4A==
X-Forwarded-Encrypted: i=1; AJvYcCX/6urZIT0f0yT1/L0zKcWPSNenPgDCy+LZYQmErq3C+OYFumSGdGcJixuAnaoCWnEtBbh8s3sUXlze/2KLmitEZR80
X-Gm-Message-State: AOJu0YxvD+B/YqYb94MTT6CNALkJIranJoFY20hkOTjMwDYeS14o91C0
	f4mCyjIr1V8LXyZFwWZ9Qu5ZYAQR/5ITSaVB8Hte1vD+IratkBVV/lGnzpzMZ4SHsPDJEXppWg=
	=
X-Google-Smtp-Source: AGHT+IHKlfLzIehWc22oDX8uMfcDmLL5aEy3cA9blPvEjAUh7oYjXMJskW3TDfNlIiBODMYBSdvEYmQV4w==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1248:b0:df7:6f84:f36f with SMTP id
 3f1490d57ef6-df772172705mr1421198276.4.1716984892739; Wed, 29 May 2024
 05:14:52 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:16 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-11-ptosi@google.com>
Subject: [PATCH v4 10/13] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The compiler implements kCFI by adding type information (u32) above
every function that might be indirectly called and, whenever a function
pointer is called, injects a read-and-compare of that u32 against the
value corresponding to the expected type. In case of a mismatch, a BRK
instruction gets executed. When the hypervisor triggers such an
exception in nVHE, it panics and triggers and exception return to EL1.

Therefore, teach nvhe_hyp_panic_handler() to detect kCFI errors from the
ESR and report them. If necessary, remind the user that EL2 kCFI is not
affected by CONFIG_CFI_PERMISSIVE.

Pass $(CC_FLAGS_CFI) to the compiler when building the nVHE hyp code.

Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
call it directly and must use a PA function pointer from C (because it
is part of the idmap page), which would trigger a kCFI failure if the
type ID wasn't present.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c       | 10 ++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b3d6657a259d..69b08ac7322d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -417,6 +417,14 @@ static void print_nvhe_hyp_panic(const char *name, u64=
 panic_addr)
 		(void *)(panic_addr + kaslr_offset()));
 }
=20
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+{
+	print_nvhe_hyp_panic("CFI failure", panic_addr);
+
+	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
+		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -446,6 +454,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
 			print_nvhe_hyp_panic("BUG", panic_addr);
+	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
+		kvm_nvhe_report_cfi_failure(panic_addr);
 	} else {
 		print_nvhe_hyp_panic("panic", panic_addr);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index 50fa0ffb6b7e..782b34b004be 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,9 +89,9 @@ quiet_cmd_hyprel =3D HYPREL  $@
 quiet_cmd_hypcopy =3D HYPCOPY $@
       cmd_hypcopy =3D $(OBJCOPY) --prefix-symbols=3D__kvm_nvhe_ $< $@
=20
-# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
-# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotation=
s.
-KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FL=
AGS_CFI), $(KBUILD_CFLAGS))
+# Remove ftrace and Shadow Call Stack CFLAGS.
+# This is equivalent to the 'notrace' and '__noscs' annotations.
+KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUI=
LD_CFLAGS))
 # Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profil=
e'
 # when profile optimization is applied. gen-hyprel does not support SHT_RE=
L and
 # causes a build failure. Remove profile optimization flags.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index d859c4de06b6..b1c8977e2812 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -5,6 +5,7 @@
  */
=20
 #include <linux/arm-smccc.h>
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
=20
 #include <asm/alternative.h>
@@ -267,8 +268,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
=20
 /*
  * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void)=
);
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirec=
tly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x9, sctlr_el2
--=20
2.45.1.288.g0e0cd299f1-goog


