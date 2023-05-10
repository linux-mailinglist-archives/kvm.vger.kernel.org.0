Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599636FD9A0
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbjEJIjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbjEJIjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:12 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B930DA
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:20 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-54fd9c0e435so487098eaf.2
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707900; x=1686299900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHiYWY9bvHP4MwqbxGKa7jevzatL3qS57fs5xuP7yzI=;
        b=iRWoDJGTbUH5F8l/MHWDwQM+SSBdN7lawEl0Fzcmel9PB5WrdETIX629TQhUSqGKPs
         S8axxbDC/ScyDzmj73GHUiH8X5QcF9mx1GXTHG+l+3fipncFc8Fdvf0eWfTbYD9kIj44
         oShEmtUyzbL//iYOjgOhaorwzNXLSW0FH5BdpWFVaLd3HSfVfmq1I/sAu/ttfG9Y/A6U
         B/F69EhGryKi5xSiHKUnJcWpL4fa1K1/bq8D7CR4FemM9NEPr5I8Y44qq3iyXiJOksQm
         JK89lgClXqRzFmWU0I5TE8jkZpGCbS9dizF0DCyUkdWiWdx2UC3d1VS3w4qoCRSrEc57
         KeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707900; x=1686299900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHiYWY9bvHP4MwqbxGKa7jevzatL3qS57fs5xuP7yzI=;
        b=TAVV5uNHz8D9PFvK782XkHDy1gG95oaKlKYsaBpIlPydtkE1mal9WRg1gyrywf6I0K
         N3Qj/7YOhrhX+3pYDYiHUgR+jYSxY5V4PbF4SLYRwvL2cmzc9ZUkrW/MTuMC5BP8tAkv
         J9p5N2ad4eFQ4jkEm8BCApc6/CwSFemVL+gFyTpJDT/9OEmVQtZXhv4WNmuJGCl8w8H7
         YjoTLXqlRsyGGoRQ6+C1OWlwcDbySIQA6bncZxABch46ZRBJ0jM2VbdhelshBbQsbxgK
         KNKRPfXPnw092+TBflvGNZ6w3f9Z/B2GTHan/83H6D4VKHbrcYh7O4qIGlzugQp612L1
         C5KA==
X-Gm-Message-State: AC+VfDz3XCTj4fPdKuei/AKGoYuTMOSR4RSf7B5Chvf8qqIP07aH5aRv
        53FGjK0ng6L/zgNiaztJMoKWaw==
X-Google-Smtp-Source: ACHHUZ70OA6WXyp3aPEqzfo8HfSG3/T6byheGDBK/16lSDEPYBV+uJKTnUYL2rIpCRwsqy0q3E/xDg==
X-Received: by 2002:a05:6820:291:b0:54f:51f3:48b0 with SMTP id q17-20020a056820029100b0054f51f348b0mr2722934ood.7.1683707899629;
        Wed, 10 May 2023 01:38:19 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:19 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 3/8] riscv: Allow disabling SBI extensions for Guest
Date:   Wed, 10 May 2023 14:07:43 +0530
Message-Id: <20230510083748.1056704-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510083748.1056704-1-apatel@ventanamicro.com>
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

