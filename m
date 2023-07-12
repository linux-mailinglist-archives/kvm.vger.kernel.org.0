Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4B750EAA
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjGLQf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjGLQf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:27 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105E31BE2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:23 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-666e6541c98so6531388b3a.2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179722; x=1691771722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHiYWY9bvHP4MwqbxGKa7jevzatL3qS57fs5xuP7yzI=;
        b=Pt70bLFfpLwDOUJK4VkWSqpQoAz0+fgY8DbzVbHasdTcIgK7r255l+3jdXa+PxvW4M
         CuHCKcKSyE3SLVdmIKyW3yPIktP2vKYDz1oAfYb5X9p5iegOsFywUCeW2nnJ2ZVhnisz
         5FlfOpUCRv1CLXaHDMagN4B5gdqCv9brThkeLwJ7tf/rCqmi+f+Ys43zqjhxDaW6/gyA
         zv+Ih/MuO18LNVUoe1J+psxwxbeKd76SPH7Rx0qV3PjFq/aMnLJ4PfFhTbH/ttNI5xZv
         IYjLbRHP3jkybRO7Bw7KuKz2778oqJIvE5XF5CwXG5ZTq4jQc7l9HrGngACqH4g2JMAH
         5cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179722; x=1691771722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHiYWY9bvHP4MwqbxGKa7jevzatL3qS57fs5xuP7yzI=;
        b=InNf/SnxWnFdHoYTlW/9BTyItxlyRLcxch2mVYkwloBkQMeBw188Ei2bNGsnuAJTqJ
         7N5lMoFHEstxMD3x2kIG9PeGzjBnWvp4l2eCD1BMsXqcocZcjeJ+vcmmo/ANUwBxy70U
         PLd7t6qAbzCh12r+OrRxZshcm+Hj5mqow0AW9BMG5R1nK+gcw/Fx/ag28MgGHNyjPpgH
         +9GLbydULs5UWO1RGCuMaSdnQY0AVjosUsnj50hfm9aCONBst+X9GZ7TJzn1EaaJlvgk
         z2EBMVI0+is1yumcOnfa/Vt0OW27J9RGo29c+8k7atOdYtzLzlK4nJy0ADm5EQF9028w
         x+0w==
X-Gm-Message-State: ABy/qLZk2xrnDa30kweRdt+DEtYzBygJuWE6S7b7RhaaR4RGs8DFhG0B
        J2+m62FqgW1OHLLmtacCyGhJ5Q==
X-Google-Smtp-Source: APBJJlHAmd+dGoHwDPFGo6Jg9kg1E+Be2oIyYZ+S6rXYEnWwTaljirOZ5btT2PS3bbi+jL8BDdWN6w==
X-Received: by 2002:a17:902:7d97:b0:1b0:f8:9b2d with SMTP id a23-20020a1709027d9700b001b000f89b2dmr18787294plm.29.1689179722340;
        Wed, 12 Jul 2023 09:35:22 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:22 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 4/9] riscv: Allow disabling SBI extensions for Guest
Date:   Wed, 12 Jul 2023 22:04:56 +0530
Message-Id: <20230712163501.1769737-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add "--disable-sbi-<xyz>" options to disable various SBI extensions
visible to the Guest. This allows users to disable deprecated/redundant
SBI extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h | 30 ++++++++++++++++++++++++++++-
 riscv/include/kvm/kvm-cpu-arch.h    | 19 +++++++++++-------
 riscv/kvm-cpu.c                     | 19 +++++++++++++++++-
 3 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index e64e3ca..56676e3 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	u64		custom_marchid;
 	u64		custom_mimpid;
 	bool		ext_disabled[KVM_RISCV_ISA_EXT_MAX];
+	bool		sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
 };
 
 #define OPT_ARCH_RUN(pfx, cfg)						\
@@ -38,6 +39,33 @@ struct kvm_config_arch {
 		    "Disable Zicbom Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
-		    "Disable Zihintpause Extension"),
+		    "Disable Zihintpause Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-legacy",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],	\
+		    "Disable SBI Legacy Extensions"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-time",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_TIME],	\
+		    "Disable SBI Time Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-ipi",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_IPI],	\
+		    "Disable SBI IPI Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-rfence",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_RFENCE],	\
+		    "Disable SBI RFence Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-srst",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_SRST],	\
+		    "Disable SBI SRST Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-hsm",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_HSM],	\
+		    "Disable SBI HSM Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-pmu",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_PMU],	\
+		    "Disable SBI PMU Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-experimental",			\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_EXPERIMENTAL],\
+		    "Disable SBI Experimental Extensions"),		\
+	OPT_BOOLEAN('\0', "disable-sbi-vendor",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_VENDOR],	\
+		    "Disable SBI Vendor Extensions"),
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
index e014839..1e9a7b0 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -7,9 +7,10 @@
 
 #include "kvm/kvm.h"
 
-static inline __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
+static inline __u64 __kvm_reg_id(__u64 type, __u64 subtype,
+				 __u64 idx, __u64  size)
 {
-	return KVM_REG_RISCV | type | idx | size;
+	return KVM_REG_RISCV | type | subtype | idx | size;
 }
 
 #if __riscv_xlen == 64
@@ -18,25 +19,29 @@ static inline __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
 #define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
 #endif
 
-#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
+#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, 0, \
 					     KVM_REG_RISCV_CONFIG_REG(name), \
 					     KVM_REG_SIZE_ULONG)
 
-#define RISCV_ISA_EXT_REG(id)	__kvm_reg_id(KVM_REG_RISCV_ISA_EXT, \
+#define RISCV_ISA_EXT_REG(id)	__kvm_reg_id(KVM_REG_RISCV_ISA_EXT, 0, \
 					     id, KVM_REG_SIZE_ULONG)
 
-#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
+#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, 0, \
 					     KVM_REG_RISCV_CORE_REG(name), \
 					     KVM_REG_SIZE_ULONG)
 
-#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
+#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, 0, \
 					     KVM_REG_RISCV_CSR_REG(name), \
 					     KVM_REG_SIZE_ULONG)
 
-#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
+#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, 0, \
 					     KVM_REG_RISCV_TIMER_REG(name), \
 					     KVM_REG_SIZE_U64)
 
+#define RISCV_SBI_EXT_REG(subtype, id)	\
+				__kvm_reg_id(KVM_REG_RISCV_SBI_EXT, subtype, \
+					     id, KVM_REG_SIZE_ULONG)
+
 struct kvm_cpu {
 	pthread_t	thread;
 
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 89122b4..540baec 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -23,7 +23,8 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	struct kvm_cpu *vcpu;
 	u64 timebase = 0;
 	unsigned long isa = 0, id = 0;
-	int coalesced_offset, mmap_size;
+	unsigned long masks[KVM_REG_RISCV_SBI_MULTI_REG_LAST + 1] = { 0 };
+	int i, coalesced_offset, mmap_size;
 	struct kvm_one_reg reg;
 
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
@@ -88,6 +89,22 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("KVM_SET_ONE_REG failed (config.mimpid)");
 	}
 
+	for (i = 0; i < KVM_RISCV_SBI_EXT_MAX; i++) {
+		if (!kvm->cfg.arch.sbi_ext_disabled[i])
+			continue;
+		masks[KVM_REG_RISCV_SBI_MULTI_REG(i)] |=
+					KVM_REG_RISCV_SBI_MULTI_MASK(i);
+	}
+	for (i = 0; i <= KVM_REG_RISCV_SBI_MULTI_REG_LAST; i++) {
+		if (!masks[i])
+			continue;
+
+		reg.id = RISCV_SBI_EXT_REG(KVM_REG_RISCV_SBI_MULTI_DIS, i);
+		reg.addr = (unsigned long)&masks[i];
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			die("KVM_SET_ONE_REG failed (sbi_ext %d)", i);
+	}
+
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-- 
2.34.1

