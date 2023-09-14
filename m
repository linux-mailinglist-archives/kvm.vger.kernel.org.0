Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7009579F88E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbjINDGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjINDGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:06:32 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCC81BD3;
        Wed, 13 Sep 2023 20:06:28 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c06f6f98c0so3976175ad.3;
        Wed, 13 Sep 2023 20:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694660787; x=1695265587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfYGiOc8xcK7Vn4qmYetUsNfG+LL1eRQ4OGdu2ofqYg=;
        b=BidnCH4kE+PhE9wFyBL7zkT+/PiSC9lPGgTS8NHIf0yqlRgV4mEP9zZ4ZkRqH1l+E4
         +yT5540ltgQBqgNxpH+KzxnrbezEllz57LrfKai03RulTkjOv5CFbLqqPR4DhAENE3my
         5hIOt+FUs9yynKJirk9CEjZdfZTKL7vboYknN8UJcslnx4YvO7QyiqF1NZR7JTdYkIHe
         VkC7Ou1Gvs25Lx4BKkA2a58ysscaJbNzdqNtNN3sp7eF14pCwzRhNFPXeS1Uw/78QAs8
         XKzm6QiGfohRhWwsH3pS9FuSFznekHVpMNUAm32eAmWcDf+9OanPFqfOWHYy3vk9wKjG
         PNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694660787; x=1695265587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mfYGiOc8xcK7Vn4qmYetUsNfG+LL1eRQ4OGdu2ofqYg=;
        b=hk1aaZNk36hkcMXp3SABMDAKDxe0xsI/cJkW68brjH3pTTpXJAKhmz2HVrNpwPITUi
         rLNkdn5GYthZKvCinnZJuZ5VFEjOeGRoW2bj16IrksF6Li+iVNFZU3zBhozfMFli/HDv
         9v5T2qq0HrewWNgGMYUDEGUYXD6Og/OLUBBGtk1hX+7XlwtsrPY8t2akSKBuV5hHS4Qt
         nOgsy+BImGtWaysYIhB05KMIWFJtB6ceMhqCkhjL9pIKrchhRtFjH8n5bmA4xwXRfLtK
         DoA/dmkJAGiLvrIMoiNbNuNZ2G6eCH1kNC8e8dkNCPh+yVLB3/CtvUa4pRtviVfZoimC
         /BWw==
X-Gm-Message-State: AOJu0Yyqtu/ymvzyLSIpQtIcgGkkFGxSsF+tP4gDVqxgx2XtO7HEuCm3
        rddmXn2oX++tpoprQtiVUew=
X-Google-Smtp-Source: AGHT+IG3WqcXGZgJKC+ebWxgbWbfJPrHCD9C643smhuax00LIg+lUv4dDkC1nH7oO/eEww9ZpBUIyA==
X-Received: by 2002:a17:902:be0b:b0:1c4:1089:887d with SMTP id r11-20020a170902be0b00b001c41089887dmr258473pls.3.1694660787496;
        Wed, 13 Sep 2023 20:06:27 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902904200b001b567bbe82dsm330521plz.150.2023.09.13.20.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 20:06:25 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au, sachinp@linux.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v5 03/11] KVM: PPC: Rename accessor generator macros
Date:   Thu, 14 Sep 2023 13:05:52 +1000
Message-Id: <20230914030600.16993-4-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
References: <20230914030600.16993-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More "wrapper" style accessor generating macros will be introduced for
the nestedv2 guest support. Rename the existing macros with more
descriptive names now so there is a consistent naming convention.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v3:
  - New to series
v4:
  - Fix ACESSOR typo
---
 arch/powerpc/include/asm/kvm_ppc.h | 60 +++++++++++++++---------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index d16d80ad2ae4..d554bc56e7f3 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -927,19 +927,19 @@ static inline bool kvmppc_shared_big_endian(struct kvm_vcpu *vcpu)
 #endif
 }
 
-#define SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
+#define KVMPPC_BOOKE_HV_SPRNG_ACCESSOR_GET(reg, bookehv_spr)		\
 static inline ulong kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 {									\
 	return mfspr(bookehv_spr);					\
 }									\
 
-#define SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
+#define KVMPPC_BOOKE_HV_SPRNG_ACCESSOR_SET(reg, bookehv_spr)		\
 static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, ulong val)	\
 {									\
 	mtspr(bookehv_spr, val);						\
 }									\
 
-#define SHARED_WRAPPER_GET(reg, size)					\
+#define KVMPPC_VCPU_SHARED_REGS_ACCESSOR_GET(reg, size)			\
 static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 {									\
 	if (kvmppc_shared_big_endian(vcpu))				\
@@ -948,7 +948,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 	       return le##size##_to_cpu(vcpu->arch.shared->reg);	\
 }									\
 
-#define SHARED_WRAPPER_SET(reg, size)					\
+#define KVMPPC_VCPU_SHARED_REGS_ACCESSOR_SET(reg, size)			\
 static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
 {									\
 	if (kvmppc_shared_big_endian(vcpu))				\
@@ -957,36 +957,36 @@ static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
 	       vcpu->arch.shared->reg = cpu_to_le##size(val);		\
 }									\
 
-#define SHARED_WRAPPER(reg, size)					\
-	SHARED_WRAPPER_GET(reg, size)					\
-	SHARED_WRAPPER_SET(reg, size)					\
+#define KVMPPC_VCPU_SHARED_REGS_ACCESSOR(reg, size)			\
+	KVMPPC_VCPU_SHARED_REGS_ACCESSOR_GET(reg, size)			\
+	KVMPPC_VCPU_SHARED_REGS_ACCESSOR_SET(reg, size)			\
 
-#define SPRNG_WRAPPER(reg, bookehv_spr)					\
-	SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
-	SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
+#define KVMPPC_BOOKE_HV_SPRNG_ACCESSOR(reg, bookehv_spr)		\
+	KVMPPC_BOOKE_HV_SPRNG_ACCESSOR_GET(reg, bookehv_spr)		\
+	KVMPPC_BOOKE_HV_SPRNG_ACCESSOR_SET(reg, bookehv_spr)		\
 
 #ifdef CONFIG_KVM_BOOKE_HV
 
-#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
-	SPRNG_WRAPPER(reg, bookehv_spr)					\
+#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bookehv_spr)	\
+	KVMPPC_BOOKE_HV_SPRNG_ACCESSOR(reg, bookehv_spr)		\
 
 #else
 
-#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
-	SHARED_WRAPPER(reg, size)					\
+#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bookehv_spr)	\
+	KVMPPC_VCPU_SHARED_REGS_ACCESSOR(reg, size)			\
 
 #endif
 
-SHARED_WRAPPER(critical, 64)
-SHARED_SPRNG_WRAPPER(sprg0, 64, SPRN_GSPRG0)
-SHARED_SPRNG_WRAPPER(sprg1, 64, SPRN_GSPRG1)
-SHARED_SPRNG_WRAPPER(sprg2, 64, SPRN_GSPRG2)
-SHARED_SPRNG_WRAPPER(sprg3, 64, SPRN_GSPRG3)
-SHARED_SPRNG_WRAPPER(srr0, 64, SPRN_GSRR0)
-SHARED_SPRNG_WRAPPER(srr1, 64, SPRN_GSRR1)
-SHARED_SPRNG_WRAPPER(dar, 64, SPRN_GDEAR)
-SHARED_SPRNG_WRAPPER(esr, 64, SPRN_GESR)
-SHARED_WRAPPER_GET(msr, 64)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(critical, 64)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg0, 64, SPRN_GSPRG0)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg1, 64, SPRN_GSPRG1)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg2, 64, SPRN_GSPRG2)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg3, 64, SPRN_GSPRG3)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr0, 64, SPRN_GSRR0)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr1, 64, SPRN_GSRR1)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(dar, 64, SPRN_GDEAR)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(esr, 64, SPRN_GESR)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR_GET(msr, 64)
 static inline void kvmppc_set_msr_fast(struct kvm_vcpu *vcpu, u64 val)
 {
 	if (kvmppc_shared_big_endian(vcpu))
@@ -994,12 +994,12 @@ static inline void kvmppc_set_msr_fast(struct kvm_vcpu *vcpu, u64 val)
 	else
 	       vcpu->arch.shared->msr = cpu_to_le64(val);
 }
-SHARED_WRAPPER(dsisr, 32)
-SHARED_WRAPPER(int_pending, 32)
-SHARED_WRAPPER(sprg4, 64)
-SHARED_WRAPPER(sprg5, 64)
-SHARED_WRAPPER(sprg6, 64)
-SHARED_WRAPPER(sprg7, 64)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(dsisr, 32)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(int_pending, 32)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(sprg4, 64)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(sprg5, 64)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(sprg6, 64)
+KVMPPC_VCPU_SHARED_REGS_ACCESSOR(sprg7, 64)
 
 static inline u32 kvmppc_get_sr(struct kvm_vcpu *vcpu, int nr)
 {
-- 
2.39.3

