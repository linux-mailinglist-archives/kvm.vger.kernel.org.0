Return-Path: <kvm+bounces-11832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E85B87C442
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 516C61C20866
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0950E76052;
	Thu, 14 Mar 2024 20:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KE3zsUxb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A07605D
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447951; cv=none; b=Z04MmJorvcqkU5ELqrSgQwmiC/qe/TZABnR+zj1XgQI1XUFGTAelMI99VsRuh5ZdADINPNJ3K0g88f7yKjjdvjRb0zwL6iniajd9QOUySMWXeXcjes/h/6slCf6pK0sZ2vM/VHdxB3RvBa5nmNmOcntYpqukY9ljg3j6dFvnr6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447951; c=relaxed/simple;
	bh=t+Xjs0gyzs0q7A934MpYYmsAbai7ZXro++u99AU3aL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RheAq8UdEWKZxe4fjyNPQySoN1Hnp04hxxf//IyLaM3hrLyH2OR2GHyHBfHza+1tuX73jVds8jkcYfhED4dXgHGsPfpBj0qHyGS9h9z5h+pKK36qJRX9KU+WOLY219P3rt1/Bsg6mORPSmq5FEeuNgz1zCXFRzcHXhgHMCA8Cwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KE3zsUxb; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a466a256726so246679866b.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447948; x=1711052748; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uw5V0Ihfo7A0TVnpjJhXgB0vBa49XYRYilcTAeCdiBg=;
        b=KE3zsUxblMtO7xe/B65ihVXw8TjllMZnWTsu3OBy/fKCxoMEalWLaazmqdbdhClZ/R
         EJQgtxu0809DPzeBRCL+aBUEMq/f+FdgSedGGdPeX0qqxlnRpMkNweiBMfn1nA0fCvp2
         +CpPXvOMMwI/HWtSF29AJxbDtbPwGEAUQ5bzQLF58AhhkbP6TLU340AUzo0WXFBpAglI
         lJ+5uJdY0SAn/R3ao+2FmlQ8VTxEgqwnsMm7+0OkP+ye3+Oc0I2zrz4iF2oasfJeK3XW
         1euNYeKtp/AE5OIhg0I1TfWXHZDuQe6PI8080XfzkTtQ8ypMwgjBi0EHSevZIg8T9eKY
         BpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447948; x=1711052748;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uw5V0Ihfo7A0TVnpjJhXgB0vBa49XYRYilcTAeCdiBg=;
        b=WxkuZ1ZZ7zEm73vL/wPg6XK2bCqAXbJ5IIKMAjy653/P012uL/pTdw2P0SywV9qgaS
         3S2gLN4F3O01snFa62mXyPAXshYjOctxWYqhj0qJQfV5dDOJOe4xJxu6UXFlz4ugs4m8
         L3EokZ6tAsKbfmclweNo8NMSWteOo3G7TEenefA0TGUGh2GMG0xAxt81JHluYg+axbJw
         JXW2zUt1MbCUEMk+U3p/KbursxYXvpl8qiVtvBQj2PF2U7mEHy/UUUKQD/t4c43yqWMZ
         ek7FeNAA3gqN0WMk+9b9mMymtIxKZqxoU2wwELC/W4pcEJXCyvSWnTWY6uwaduoO9gkJ
         q7WA==
X-Forwarded-Encrypted: i=1; AJvYcCVcHM5fbQYg8dKg9ieo/p37ORPOOBrBLwh//Hv0ODasittB6p+yf8mwRs10C/DKUmGL78+AsjnK6OvSOTWidzPXYEbV
X-Gm-Message-State: AOJu0YxBxnLkfrKyRnlxkutIudg/febdx4zINMfc6WXGR0Wxgh/DquuL
	SkwGAN8nVfPCIhC2nxINA/yX1CTBM20Sf4OvxAqWY1awgJfjpXD6Ta918mTomA==
X-Google-Smtp-Source: AGHT+IFSNYqhVQ94RVZXOtYFwx8fhGK4ErioR53gKmAPavaCWzXWnVTwxghHAngotsX6fUmwQ3r8tQ==
X-Received: by 2002:a17:906:c359:b0:a44:806f:ad56 with SMTP id ci25-20020a170906c35900b00a44806fad56mr2381102ejb.11.1710447947559;
        Thu, 14 Mar 2024 13:25:47 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l5-20020a1709066b8500b00a4320e22b31sm1025683ejr.19.2024.03.14.13.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:25:47 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:25:43 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH 09/10] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
Message-ID: <87885c41627a033d9772dd368049e7f8f5fd4ef7.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

The compiler implements KCFI by adding type information (u32) above
every function that might be indirectly called and, whenever a function
pointer is called, injects a read-and-compare of that u32 against the
value corresponding to the expected type. In case of a mismatch, a BRK
instruction gets executed. When the hypervisor triggers such an
exception, it panics.

Therefore, teach hyp_panic() to detect KCFI errors from the ESR and
report them. If necessary, remind the user that CONFIG_CFI_PERMISSIVE
doesn't affect EL2 KCFI.

Pass $(CC_FLAGS_CFI) to the compiler when building the nVHE hyp code.

Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
call it directly and must use a PA function pointer from C (because it
is part of the idmap page), which would trigger a KCFI failure if the
type ID wasn't present.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       |  6 ++++++
 arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  3 ++-
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index b0c23e7d6595..281e352a4c94 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -397,6 +397,12 @@ static inline bool esr_is_data_abort(unsigned long esr)
 	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
 }
 
+static inline bool esr_is_cfi_brk(unsigned long esr)
+{
+	return ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
+	       (esr_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_FAULT;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index ffa67ac6656c..9b6574e50b13 100644
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
index 8958dd761837..ade73fdfaad9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -5,6 +5,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
 
 #include <asm/alternative.h>
@@ -265,7 +266,7 @@ alternative_else_nop_endif
 
 SYM_CODE_END(__kvm_handle_stub_hvc)
 
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Load the inputs from the VA pointer before turning the MMU off */
 	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
 	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]

-- 
Pierre

