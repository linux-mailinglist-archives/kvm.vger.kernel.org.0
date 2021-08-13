Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04403EBDC0
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhHMVNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbhHMVM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:12:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7687EC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:32 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id h21-20020a17090adb95b029017797967ffbso8586154pjv.5
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
        b=tLRfwvEqQSqyt/QVk9wx8D1i5roaNJZj6Y5mrjVxRY1cOOFHxbrnZv08XP9BH1L505
         05zkQ7DDsCBnd64vOSatbSX7cA8NSLqLruoPgASiB/BO1N2h6DZRagt1p4QxemUYGpf8
         pFeogUFdUJgq3Nvf0WICqVvniiaK9AQW4t0+qXpXB5AfXgw/YUR57FXcBRFk6emIyfRE
         /bW1BmjYPUuzPzqKaumRv++9fULqs4udzSu66BBt2d3b3tH4uNyKZFJPyCDG+RlyGzpt
         C/OSN8S6lvFDoJZp03cISdKkVneS4Nn3S7zrGvVHVYSzyHyNDizFt5H9kcG0JxxG4FjL
         G5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
        b=gOPF13wQBdrv1tGsNEY94PL9/oxBUx94+b6jFtc44sXN6pfQ6ix/1dUkuQsHOQMvpp
         MLOOC8IsrMQ8w1FdrO3DsG24feoYxMHKDdoufb1gfRRWNc6ODwItGARe4Z/WKkZcgYhQ
         yBmciflAsUlds5vCu1odsd9sKoAWFBm9gVJI7QxRSnskOXxCsiNnC19Ox31PaGPX3xbo
         tIZ/TdWbTcdSUUk53Q8ra/Y6E5tneHShIcDP/ceXNJwt/nKP7DKpfA89d9KT57s/cTCZ
         zsMjwwEYnXJlpXaRZz7sw0GsvPXb+6hZpCEWIYCICvZt73Sj/Lqaq6XPPGziIVgWf88I
         8eHQ==
X-Gm-Message-State: AOAM530L9u+4gAfpM/1puZKVU6Thing5EhIVu2CYkb9kuZezqwTnOPD6
        xtzT09boCoXeIALHSO0N8vgo2YjdtOGJ
X-Google-Smtp-Source: ABdhPJzbmFEd2uQqU/4nZgMWFmmHA0gDdgA66TV1ZI72XcP1aFw7BHbaSHbuUfx6jZt0qaPY36m5ZWdfn0jK
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:ea91:b0:12d:7aa6:1e46 with SMTP id
 x17-20020a170902ea9100b0012d7aa61e46mr3558910plb.58.1628889151981; Fri, 13
 Aug 2021 14:12:31 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:03 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-3-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 02/10] KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For register names that are unsupported by the assembler or the ones
without architectural names, add the macros write_sysreg_s and
read_sysreg_s to support them.

The functionality is derived from kvm-unit-tests and kernel's
arch/arm64/include/asm/sysreg.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 14f68bf55036..b4bbce837288 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -115,6 +115,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+/*
+ * ARMv8 ARM reserves the following encoding for system registers:
+ * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
+ *  C5.2, version:ARM DDI 0487A.f)
+ *	[20-19] : Op0
+ *	[18-16] : Op1
+ *	[15-12] : CRn
+ *	[11-8]  : CRm
+ *	[7-5]   : Op2
+ */
+#define Op0_shift	19
+#define Op0_mask	0x3
+#define Op1_shift	16
+#define Op1_mask	0x7
+#define CRn_shift	12
+#define CRn_mask	0xf
+#define CRm_shift	8
+#define CRm_mask	0xf
+#define Op2_shift	5
+#define Op2_mask	0x7
+
+/*
+ * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
+ * generates a different encoding for additional KVM processing, and is
+ * only suitable for userspace to access the register via ioctls.
+ * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
+ */
+#define sys_reg(op0, op1, crn, crm, op2) \
+	(((op0) << Op0_shift) | ((op1) << Op1_shift) | \
+	 ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
+	 ((op2) << Op2_shift))
+
+asm(
+"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
+"	.equ	.L__reg_num_x\\num, \\num\n"
+"	.endr\n"
+"	.equ	.L__reg_num_xzr, 31\n"
+"\n"
+"	.macro	mrs_s, rt, sreg\n"
+"	.inst	0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
+"	.endm\n"
+"\n"
+"	.macro	msr_s, sreg, rt\n"
+"	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
+"	.endm\n"
+);
+
+/*
+ * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
+ */
+#define read_sysreg_s(reg) ({						\
+	u64 __val;							\
+	asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));	\
+	__val;								\
+})
+
+#define write_sysreg_s(reg, val) do {					\
+	u64 __val = (u64)val;						\
+	asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
+} while (0)
+
 #define write_sysreg(reg, val)						  \
 ({									  \
 	u64 __val = (u64)(val);						  \
-- 
2.33.0.rc1.237.g0d66db33f3-goog

