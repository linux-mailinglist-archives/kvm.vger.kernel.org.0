Return-Path: <kvm+bounces-19162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5954D901B50
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB1A428170C
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E681C383A5;
	Mon, 10 Jun 2024 06:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eBrBISl5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828E31CD11
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001203; cv=none; b=QRNcVh0G3hF06j47QclAbFqwFxFADFAnNFAnemFNlGxV4Tm1/iDjmWe0cflg3shqpMJlJ8lF/rh50t0npgBw69oOBLW762eZVGIvqBOQGPgYQq2ny/dEVyUsFzGttGP6K6cXf4p29BObZbxDHFW85jZyJDIWr4Mp3Amqes1YqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001203; c=relaxed/simple;
	bh=qfv6I1jjnDAU1Imno9iVu5bVjsuWAXtM6J7EWpc+Pus=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HB0hYTehiEBg3FBfa7AKWE/XJqkCVrteuDYlPH7a+BGSoYcBExKY01rih1+pPDruKXlVN7iCi+CYk6zpgGiMyZvKMmVEge2HsjlxtI2XDfBCzyC3i1Zmo8tvRyibJFwv0B1IpFL0sAoqiYYaOvSMtDXQXxbxCJaPCsQyxESdqNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eBrBISl5; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-57c738349baso784759a12.1
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001200; x=1718606000; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3Fqo6uZ6WACSXr1SiKgfaQUsW+tD2BveY2g61YybgU=;
        b=eBrBISl56c8QxPl8HpNOhiBcID0A3GaCDaiCj2rETVOow+cn8TrhTu7YIDcN8gWJH9
         jwFzQMNZM3YDV7h0sQkfxZh3R15DJaRSSlRdi9suPdm6vTFVnFl3ljUYo2k4tDxM9H+t
         4oadOEpN5KPOQ/HR2v8SGp/WUVd1YQFEC89zjBGDnV0Stxc7kcUH5yA1cb9GnqVBW+Xn
         UzsDc7/Ajv1q5Z+mQoII2V9LPLJNBCk9S3LjavDCvm0v1s5R76Ll8WLYUPmyt4EMoqjg
         I3Gr/aDmXNKkALQ73eu8POC2BnaqBepKXubn9RSxCfJopoVaKUmlUv8vparvOgrOX9On
         ENhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001200; x=1718606000;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/3Fqo6uZ6WACSXr1SiKgfaQUsW+tD2BveY2g61YybgU=;
        b=jYYnqQIvcsngJnoXLjFuH4w5yG3FqM1Shym8WMVdCT4ULKpuX1sk+LJzLA8MGkEtKb
         WkNp3qV0yYFsL5eJfvZ0k1Lilo3yjZntxojdqJckV4k0x/BSH3A2Sv4YdWvKe+6n59CT
         JL78YucomEwJRb6zi9AfqCbEiGXqYudBEqZDQmkkpDUy7s/plZHCybj5tP7dmwApJB8p
         2aLAvz+cpgw0cs7iwF0nzYywjkOQYiMF2t07Tmws9+LC0SqOHO96cSVYFl6ozxqfdsjm
         cF0U9D1WIV/74UQrPOVqNWkloI3y7xrGYTDHnxR5ZKZ85YOQ8ssfLE2ACeJ8E1nZQPrt
         GB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWe8xfa0zW3QLnWappb7rzUjxXGKSOxD602VCuTuSZnE19RpeG372bm30/RVpe6i4iFdGBxoj8dSj3yi6JRwoMunto/
X-Gm-Message-State: AOJu0YxOENoRACAde+n3UTwMEZQ6vTCu6S1Cd3msoPB6PXzLlOakHAUt
	S7Ct4I9iGmThz2iBYs8cs7Oc6nhWhcDTQluy8CMpTFa233Z5BbGvKd6tHhStIr8zIHUmKdCDPA=
	=
X-Google-Smtp-Source: AGHT+IGl14UbfzJFzP5FVcOdHdoo6VR8VgccIp2YuEQvM8uJdIjgJCFM5cwo5OdJoioDTQ1NLN2OfjF80w==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:381b:b0:57c:803e:3a57 with SMTP id
 4fb4d7f45d1cf-57c803e3c99mr3092a12.2.1718001200147; Sun, 09 Jun 2024 23:33:20
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:37 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-9-ptosi@google.com>
Subject: [PATCH v5 8/8] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
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
Acked-by: Will Deacon <will@kernel.org>
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
index 3a2836a52e85..07120b37da35 100644
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
@@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
 /*
  * void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
  *                             void (*fn)(void));
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirec=
tly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x3, sctlr_el2
--=20
2.45.2.505.gda0bf45e8d-goog


