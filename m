Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ECA3F0B30
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhHRSoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbhHRSn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:43:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C881FC061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 134-20020a63008c0000b029023286313a3cso1951665pga.4
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
        b=i9ROhHHLC7+9XVDXCedC9jm56keI2vlEBmvdJN8VFYKW+DoVJfmSia7ZbiPQwaV13S
         m//FjRqZlmB/Q0f4AgFaoRaX/xkqgrcfzh/dhrvnHOiri2x2oUE9qLfITAOgxBFD8N1E
         zWJR3aoeJ3Iq1mFLBeDwgc9cD5oRixUA5X8I/zM/bpb4/NNLJIHYswIuAXFLy4yBf23X
         aPGFRZ+8oe74OomG/nGQt6VI031c3kuPNtvJUqpXAwYjFgJ9sRUDijE39mW4TJNA1O9H
         WB5ZV2iG5E5YREdy1Pt98gbJ8L5AQpYTJNd1flPj/DpVGCfmvdZo/707zZfa+nkMezBs
         Lc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xPoIZjuWep0XnVjE3RZ+lF+QPEA9z7qXvcODMX5rYnc=;
        b=HsQsYDSiTFvIt+zJcxpt7GCvdhlVJ/Ix0WrN/XFYm3wg8m/g4GueM+8CSRRS68fWOg
         fZdAJgpqUVR3Hx39Zfvfo1SZfcfBEGqgck9+SmJ5sSDGKxEWgs7u+Qs+u2VEU07bXnnt
         8SjG1+8XS0Y77fp3+wEtJQO7isI7f2NjnVLc1WKpbzXFB37gBVKTrJ+xbh/q5x8CKkHr
         LF2Mi0MiC2JkLkus+eGkYlOhaH3kHrgPdF94MKMj35SNt4NY7dGle6sL4K2DGnbZG6vA
         JgMzu9y9mon63gWoydTMWoAfesODl8er/prifviOvkNpJ/msmFQgeLxhM1fXqKzWh4B+
         QbRQ==
X-Gm-Message-State: AOAM532BNrQUqwF0cZKCMufGWlWhbdatn4OWv2RRi23Vh1DHRs+Ho62y
        NtErDS1G6RwDZSiLifzEeEhFllmzYZ6x
X-Google-Smtp-Source: ABdhPJzx7O78WEN4MoFWpeiB6hWgg45bljg5ENDsoLX3FLeJ/Yl4YexADXJn8SvFup4tTD/118WwthhmvMgL
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:a503:b029:12b:2429:385e with SMTP
 id s3-20020a170902a503b029012b2429385emr8393704plq.64.1629312201293; Wed, 18
 Aug 2021 11:43:21 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:03 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-3-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 02/10] KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
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

