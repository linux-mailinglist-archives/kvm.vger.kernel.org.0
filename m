Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC10574A337
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjGFRjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjGFRis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:38:48 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FA51FF6
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:38:42 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-78362f57500so36301139f.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665122; x=1691257122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHiYWY9bvHP4MwqbxGKa7jevzatL3qS57fs5xuP7yzI=;
        b=QqXcNqYV7oepKX1/VnAtaKDmB61v3PAZ498kFFi88MRFs7kNuY+dsH/Ml2bSuDLIYE
         xkb8rKDSQ9s0+M4JQ/9QuHj9Eusv+R5X2LG7J7qA0PCHtmSyD9Dinrk2AWz7d2QptLen
         zDFVHWX/Bkt5YYqV3724i5ltXpLlwwB6xX+Y/WaxaSJWhFAtD3x7gD+Iq4Pc9IVU5+Ph
         wzhDJCqKTbhHFGaMrfqoNVK3Wf2chHqbpOufE90NrI/HrzPkPQLayoGye55bARhsP1eV
         5DtD61ULECGypbX5Ngz71jV89ntMjjMp9q5m8HpwKtmWywdUHNjELg9hvl3rEyFBb2Qs
         sabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665122; x=1691257122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHiYWY9bvHP4MwqbxGKa7jevzatL3qS57fs5xuP7yzI=;
        b=UxUJqri6G5SIR+w/zXEOoyuXkn0D7J6V0A8esh3HWOfmklpcDDM9k1aqYq6QheYL2c
         JNCUrxHaqW5wgxYrCqy86lTGRy//mjyibka3QSOUMdR1L2rR/iodvlf4yX++OoUqEjt+
         tNwWvwmMce4lnRJGBFSraoCFBnNXGuKpbYHcKZITZF/5x4reEbQ+i5nG7KhJ75OQFupz
         l2xY7l7HAp69zSPaAr2s5DHpvrcPhQ2eEaNnmr83iHKd1SWxvHGwuVAQJ5Ed4dgoE/Rw
         neV7mD7CbxF9ojvA3SjI0BoOFGX4pQ7DgDqK8hYUJJdhuj++tgrGcsaPFrCtzRJsXTIA
         +k4Q==
X-Gm-Message-State: ABy/qLbVkOwLbFiXJIiHG+dTvu0F123C4AmU87j9/VDaHpu3EU+YvrDu
        s56ivzKUDNqjZYJumUvQVjXfxg==
X-Google-Smtp-Source: APBJJlF+x52u3bATUQTIfIIEjKzcfrwQYrY5gTLGRu0TdM9NSjBoWpzw66njm1qIN+2oAYcA3vTLeg==
X-Received: by 2002:a05:6602:2774:b0:786:3f74:c244 with SMTP id l20-20020a056602277400b007863f74c244mr3042389ioe.17.1688665121735;
        Thu, 06 Jul 2023 10:38:41 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:38:41 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 3/8] riscv: Allow disabling SBI extensions for Guest
Date:   Thu,  6 Jul 2023 23:07:59 +0530
Message-Id: <20230706173804.1237348-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230706173804.1237348-1-apatel@ventanamicro.com>
References: <20230706173804.1237348-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

