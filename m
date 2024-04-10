Return-Path: <kvm+bounces-14092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C3889EDA9
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43651F22DA1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DEF13E021;
	Wed, 10 Apr 2024 08:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4GHy/91n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8717913D880
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737828; cv=none; b=DbNw/WRQnx4pH/p7JUPbeb+1C8dSScAxkyKSkLp4cRH7qr3DFDENSwOI0/lsQYgjbveoY3Krxo7Kh9mfZUwlMvBzwmVN9ND7e4bYdAaYnquaGXMEoGio/7g8Pfvj1LUQpYpRSbNVNL8TeMefcqfBiehVae5XeF1zToI3i++w8bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737828; c=relaxed/simple;
	bh=sjLo+2j08iLCyaP/ZrrXRs8M6s13hs4gKMe6/iy5SyA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FI0XFM9kSrLjIvWHPt7HHU9eh8FuiQkT6a/c+9dv6TQvDzRPlWnTdKJrwChrjb1AjmFnu0gHYhQwZ6klzKt+YZxkWlKs9J6zBWIrYdlgw1582yF9krwfbXWHVwgDpml5OppJ7RmHL7+WKDIPkdbwlbETFlDCYIQpy1jC+UZhk1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4GHy/91n; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a51c6e91793so573987166b.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737825; x=1713342625; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6DrtWKL4HFIVL/Z+tlpZfy75B2ArHvwYVgq7qkQ5Eg=;
        b=4GHy/91n6yePYMaSwdJJojQnpaAkzjcZSVSfUa0sqCIG2tMFQeGZc/Ovc/ruMyk2P6
         LZHE8x++bhWfO0Nijcf8R8Rpn20yLf78GAlFlzWpcswqncV3ZvB9vllp5fTPM/Rx0I9o
         US/UhttFu7UIRub40gjarw0wYEYXKXPPfTegsT7eVHXqjPeNC9Arkw7MCh8Hm7t/GZhZ
         2Ebyn9d7QcicPd9F3S5kGw0fnQGq4LyUCJ9SOI2NwVPvTn9Yq3fJkND6VuDMtmO4aDMG
         P+1HqI6sUufYf0IdXxGfSXXpZ0V701s97I5H2jSRRR3Mp2Fp6EKxNjoG6noUYY9FuPrn
         FEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737825; x=1713342625;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v6DrtWKL4HFIVL/Z+tlpZfy75B2ArHvwYVgq7qkQ5Eg=;
        b=pbPqG7qkWmwHSKxBcTuuCEgsoovBY7OxU+CwOCJn8/pkw4SS9a5cO/4ZCMkysg3mLm
         cB5wrGxJ6ae5NIu2ZkdtgavEcbs35fYuEHmpuRW1JihnlUFdg7uvE2j6ghrtVVsArBnZ
         fN+wO3w2QwbzgqNmsfod24bD8B+9am+bU9nYgHnprWsuVyBp9DY0EN/mOycQt2kfPMZB
         eIW0EpvBwtXFh6dXF/AFCkJGtNcXTz2WRXjiNJzHpv3ElbDQBP6cFB5byC1M1RFGCUID
         eoSL+0HroxBzm9qZ8y8JTSf7kxDO6rhMK5/7gt/ykL9eb5lK+lodNFYFXiabT1RYbN8U
         ZL2w==
X-Forwarded-Encrypted: i=1; AJvYcCXDyG8QWg7L4TnELw4fqgWsbOT/3gHGrBpkq/JTPPq6Ok+PtOt0v0qesczjSJSzYd9WpLBMPyFtgv4rnZAjTNnFztbF
X-Gm-Message-State: AOJu0YyoyTXk1+cTwNRCqBuzFRVKPSwbJPyUip1eUpJuW6JnCGIvLTtm
	KKo4sr8yWG3s6U06LR3L/XNgRW7Rmshz03CBbg0gLE5D3hOaTLuqQz2RdAYifg==
X-Google-Smtp-Source: AGHT+IE+3bFNql+D7KkAv08EKtihoMoVNO9YFCZha/FUwb6uG6uieK7br/du5MzzN0cCL5aBqVM6xQ==
X-Received: by 2002:a17:907:8686:b0:a52:b70:454f with SMTP id qa6-20020a170907868600b00a520b70454fmr1429337ejc.15.1712737824552;
        Wed, 10 Apr 2024 01:30:24 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id de26-20020a056402309a00b0056c1cca33bfsm6129511edb.6.2024.04.10.01.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:30:24 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:30:20 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
Message-ID: <as6khq6ychznvsfhgcxb7ke6jkkqui5lddovd6qxz26fbjnjmb@lwzgdwx7aomk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

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

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       |  6 ++++++
 arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 2bcf216be376..9eb9e6aa70cf 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -391,6 +391,12 @@ static inline bool esr_is_data_abort(unsigned long esr)
 	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
 }
 
+static inline bool esr_is_cfi_brk(unsigned long esr)
+{
+	return ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
+	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	/* Translation fault, level -1 */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 0bcafb3179d6..0db23a6304ce 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -383,6 +383,15 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+{
+	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+
+	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
+		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -413,6 +422,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		else
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
 					(void *)(panic_addr + kaslr_offset()));
+	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
+		kvm_nvhe_report_cfi_failure(panic_addr);
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
 				(void *)(panic_addr + kaslr_offset()));
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 2250253a6429..2eb915d8943f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,9 +89,9 @@ quiet_cmd_hyprel = HYPREL  $@
 quiet_cmd_hypcopy = HYPCOPY $@
       cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
 
-# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
-# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
-KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Remove ftrace and Shadow Call Stack CFLAGS.
+# This is equivalent to the 'notrace' and '__noscs' annotations.
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 # Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
 # when profile optimization is applied. gen-hyprel does not support SHT_REL and
 # causes a build failure. Remove profile optimization flags.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 5a15737b4233..33fb5732ab83 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -5,6 +5,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
 
 #include <asm/alternative.h>
@@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
 /*
  * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
  *                             void (*finalize_fn)(void));
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Load the inputs from the VA pointer before turning the MMU off */
 	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
 	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

