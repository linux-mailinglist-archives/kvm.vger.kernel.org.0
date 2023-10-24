Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088B37D51E2
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbjJXNfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbjJXNf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:35:28 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426806A7C
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:57 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-408ffb55b35so1895255e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698154075; x=1698758875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AX7Kg3pLTr22HxmtrSzH05kFw/tkq3Ew+3ARfiqVrfA=;
        b=OyVBZos68gZ3uKgmCwXMtsYUjogWMwz/jJwmNiVJqmRmbFwfyxK946EjgVT7mSyuxJ
         b/DCZIPoE/hSxmjjQggOMZ/gNK/ThsTLFSUegbtLxKlGmcw1oOReD3QZ7OtFfQFfsVJd
         Ao/eFatz2AGO+hA1qXQILBIe8v88y+l5YYgTs4qbUlnB4DTy32IKa0wK5AQb1dOrUmNE
         BeycJa4ddcRZoEYt/FyI4GrHeQ+niHeFAUpLPeXn1JBAqZ9Ta3tZxabcLC2bgH644fI7
         4sQCIBV8or+Dfii9cLtyrdEGbV9QyCHamlsNBmDF4mdKqRZrgq0CCUbvMrLKVaTWgg61
         hAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698154075; x=1698758875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AX7Kg3pLTr22HxmtrSzH05kFw/tkq3Ew+3ARfiqVrfA=;
        b=kV+N7PGr9/MrrEypLIOZYdzUARUk0oY8cFB6pQ3aqQwEIbY9pVLW8GjdcPW0KJwtRh
         vT7Ob4KqQJLWtpuEXKcXOcnDM2iJkzG5+I8iJcgUTwCMgEZVX03QYf5eJ8a1NNIvQ5FI
         8tc0B+tYbjT0ves/0j1pjs/QZfGj6xlc1F1W4iRpweyepTNPEzcZ9Pkx+oAaLZ9qYrdc
         aqyaMQLuoJf1fX0O28xpjJHBA/4gsv6s61sd103gpzFT6tppzSuCiW5PfKXa57yIDkBG
         ehYndD6K/P9OWZFMxYfjmFTyGY8Yn6MGJeeWfWkI9fkI+fUKBR8CwM4cXzyO1wDpt8J7
         rz9Q==
X-Gm-Message-State: AOJu0YyH1xRkwo+d0YF7zJtdThMSMsUXRBzdHuEdXtKdO/OYt7rnmLd3
        TubMdRBkFPFuorEQk0JthowZSA==
X-Google-Smtp-Source: AGHT+IHA25WZkPnpG7hkj0epNRPJqd27SODY+lc7O8SDNKvya8GFTiFglhkKPL8RIhS/CoJQXkOmIg==
X-Received: by 2002:a05:600c:35cc:b0:401:7d3b:cc84 with SMTP id r12-20020a05600c35cc00b004017d3bcc84mr9290453wmq.0.1698154075695;
        Tue, 24 Oct 2023 06:27:55 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:597d:e2c5:6741:bac9])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d4151000000b0032d87b13240sm10034964wrq.73.2023.10.24.06.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 06:27:54 -0700 (PDT)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 4/5] riscv: kvm: Use SYM_*() assembly macros instead of deprecated ones
Date:   Tue, 24 Oct 2023 15:26:54 +0200
Message-ID: <20231024132655.730417-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024132655.730417-1-cleger@rivosinc.com>
References: <20231024132655.730417-1-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ENTRY()/END()/WEAK() macros are deprecated and we should make use of the
new SYM_*() macros [1] for better annotation of symbols. Replace the
deprecated ones with the new ones and fix wrong usage of END()/ENDPROC()
to correctly describe the symbols.

[1] https://docs.kernel.org/core-api/asm-annotations.html

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_switch.S | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index d74df8eb4d71..8b18473780ac 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -15,7 +15,7 @@
 	.altmacro
 	.option norelax
 
-ENTRY(__kvm_riscv_switch_to)
+SYM_FUNC_START(__kvm_riscv_switch_to)
 	/* Save Host GPRs (except A0 and T0-T6) */
 	REG_S	ra, (KVM_ARCH_HOST_RA)(a0)
 	REG_S	sp, (KVM_ARCH_HOST_SP)(a0)
@@ -208,9 +208,9 @@ __kvm_switch_return:
 
 	/* Return to C code */
 	ret
-ENDPROC(__kvm_riscv_switch_to)
+SYM_FUNC_END(__kvm_riscv_switch_to)
 
-ENTRY(__kvm_riscv_unpriv_trap)
+SYM_CODE_START(__kvm_riscv_unpriv_trap)
 	/*
 	 * We assume that faulting unpriv load/store instruction is
 	 * 4-byte long and blindly increment SEPC by 4.
@@ -231,12 +231,10 @@ ENTRY(__kvm_riscv_unpriv_trap)
 	csrr	a1, CSR_HTINST
 	REG_S	a1, (KVM_ARCH_TRAP_HTINST)(a0)
 	sret
-ENDPROC(__kvm_riscv_unpriv_trap)
+SYM_CODE_END(__kvm_riscv_unpriv_trap)
 
 #ifdef	CONFIG_FPU
-	.align 3
-	.global __kvm_riscv_fp_f_save
-__kvm_riscv_fp_f_save:
+SYM_FUNC_START(__kvm_riscv_fp_f_save)
 	csrr t2, CSR_SSTATUS
 	li t1, SR_FS
 	csrs CSR_SSTATUS, t1
@@ -276,10 +274,9 @@ __kvm_riscv_fp_f_save:
 	sw t0, KVM_ARCH_FP_F_FCSR(a0)
 	csrw CSR_SSTATUS, t2
 	ret
+SYM_FUNC_END(__kvm_riscv_fp_f_save)
 
-	.align 3
-	.global __kvm_riscv_fp_d_save
-__kvm_riscv_fp_d_save:
+SYM_FUNC_START(__kvm_riscv_fp_d_save)
 	csrr t2, CSR_SSTATUS
 	li t1, SR_FS
 	csrs CSR_SSTATUS, t1
@@ -319,10 +316,9 @@ __kvm_riscv_fp_d_save:
 	sw t0, KVM_ARCH_FP_D_FCSR(a0)
 	csrw CSR_SSTATUS, t2
 	ret
+SYM_FUNC_END(__kvm_riscv_fp_d_save)
 
-	.align 3
-	.global __kvm_riscv_fp_f_restore
-__kvm_riscv_fp_f_restore:
+SYM_FUNC_START(__kvm_riscv_fp_f_restore)
 	csrr t2, CSR_SSTATUS
 	li t1, SR_FS
 	lw t0, KVM_ARCH_FP_F_FCSR(a0)
@@ -362,10 +358,9 @@ __kvm_riscv_fp_f_restore:
 	fscsr t0
 	csrw CSR_SSTATUS, t2
 	ret
+SYM_FUNC_END(__kvm_riscv_fp_f_restore)
 
-	.align 3
-	.global __kvm_riscv_fp_d_restore
-__kvm_riscv_fp_d_restore:
+SYM_FUNC_START(__kvm_riscv_fp_d_restore)
 	csrr t2, CSR_SSTATUS
 	li t1, SR_FS
 	lw t0, KVM_ARCH_FP_D_FCSR(a0)
@@ -405,4 +400,5 @@ __kvm_riscv_fp_d_restore:
 	fscsr t0
 	csrw CSR_SSTATUS, t2
 	ret
+SYM_FUNC_END(__kvm_riscv_fp_d_restore)
 #endif
-- 
2.42.0

