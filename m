Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C5C7717FE
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 03:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjHGBqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Aug 2023 21:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjHGBqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Aug 2023 21:46:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F04CBE;
        Sun,  6 Aug 2023 18:46:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-686efb9ee0cso3864664b3a.3;
        Sun, 06 Aug 2023 18:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691372773; x=1691977573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2NckWVGzVKoAl4zO6MDkmoo78bvtrIDrF0tB1Y+yFs=;
        b=bRLdrKHAtAxSZegViCpn3odNY1hP1C9eKxb6+4VWmTVxB6XcBaXOMZ+B76jUAd4qxC
         9NhHmjOaEMViBYfeaaKLMVhNzDm0YxpY3cjAsvfK13+5/q7CM5j9a+59y7SxqrtVBEGh
         /Okkm6BywQ+PTIF9qtZv8fQMTkBmdgE185jYjaU+/LFYVdyfu4tpBG0nZhqPCMhTTQdJ
         jBDTSCSZBFmX5Qi7+Q1lmWlX6mjs+NhEsDCeK52kzzL0TdriVH6U0OuuuqS3TkFhI/m8
         HR4PV1IIh/G/uaH1ZKS2uFTLXC6ipSRozqWvjFxP79JjsNZvPWea2gL5JYeTrWQubTYY
         5TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691372773; x=1691977573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2NckWVGzVKoAl4zO6MDkmoo78bvtrIDrF0tB1Y+yFs=;
        b=V5awQwX9sqfC4eYcyORtOevVF/oAvvB5qCOdS5tLV1NssJy0cGr5A5f4ySjDwsI6id
         Fx2Zj8GW522Yc4xbn0oIWDjpSIiFHaynOm4Q9Fdd/YQ07V0kZdoIaO1rgcfe6ylmOiH0
         aQ0R7Z4zNHuNqZkdgs/ndhH/qsxkKrkO3hrn+fZ3xtu6U9d4S0dWmP3f+DCk9Zc6ozvx
         uUHoyn/5tRwUPowuMprg7CyhywboFahI8Akjh0DzZ8eH4FuH8/Oen+bo26gXLsDyJZMq
         j2KggbMiIasOTQKC+grcs6Ngza6O+JuswBGOIZ4lF1oZ2nut5FMcbq3rwqHJq3OLpuxy
         Ol4g==
X-Gm-Message-State: AOJu0YwlwB4t70h9X5zp5oQdbKvvJ8MIDo0LI2S0IZ0WALJTaor1JMxF
        Hi6jVeJFggPRYnA2VlQNgpuBdIt3S/fo3Q==
X-Google-Smtp-Source: AGHT+IHFD/DItQGDvrYNtM85A9C+YKuIf6ubYuE3IxGBKTF72362heV316NTO63AcU3aAOYzrHWwHQ==
X-Received: by 2002:a05:6a20:385:b0:138:834:5dc7 with SMTP id 5-20020a056a20038500b0013808345dc7mr7096665pzt.30.1691372773572;
        Sun, 06 Aug 2023 18:46:13 -0700 (PDT)
Received: from pwon.ibmuc.com (159-196-117-139.9fc475.syd.nbn.aussiebb.net. [159.196.117.139])
        by smtp.gmail.com with ESMTPSA id jk16-20020a170903331000b001b9e0918b0asm5485139plb.169.2023.08.06.18.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Aug 2023 18:46:13 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v3 2/6] KVM: PPC: Rename accessor generator macros
Date:   Mon,  7 Aug 2023 11:45:49 +1000
Message-Id: <20230807014553.1168699-3-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230807014553.1168699-1-jniethe5@gmail.com>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More "wrapper" style accessor generating macros will be introduced for
the nestedv2 guest support. Rename the existing macros with more
descriptive names now so there is a consistent naming convention.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v3:
  - New to series
---
 arch/powerpc/include/asm/kvm_ppc.h | 60 +++++++++++++++---------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index d16d80ad2ae4..b66084a81dd0 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -927,19 +927,19 @@ static inline bool kvmppc_shared_big_endian(struct kvm_vcpu *vcpu)
 #endif
 }
 
-#define SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
+#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR_GET(reg, bookehv_spr)		\
 static inline ulong kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 {									\
 	return mfspr(bookehv_spr);					\
 }									\
 
-#define SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
+#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR_SET(reg, bookehv_spr)		\
 static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, ulong val)	\
 {									\
 	mtspr(bookehv_spr, val);						\
 }									\
 
-#define SHARED_WRAPPER_GET(reg, size)					\
+#define KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(reg, size)			\
 static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 {									\
 	if (kvmppc_shared_big_endian(vcpu))				\
@@ -948,7 +948,7 @@ static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
 	       return le##size##_to_cpu(vcpu->arch.shared->reg);	\
 }									\
 
-#define SHARED_WRAPPER_SET(reg, size)					\
+#define KVMPPC_VCPU_SHARED_REGS_ACESSOR_SET(reg, size)			\
 static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
 {									\
 	if (kvmppc_shared_big_endian(vcpu))				\
@@ -957,36 +957,36 @@ static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
 	       vcpu->arch.shared->reg = cpu_to_le##size(val);		\
 }									\
 
-#define SHARED_WRAPPER(reg, size)					\
-	SHARED_WRAPPER_GET(reg, size)					\
-	SHARED_WRAPPER_SET(reg, size)					\
+#define KVMPPC_VCPU_SHARED_REGS_ACESSOR(reg, size)					\
+	KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(reg, size)					\
+	KVMPPC_VCPU_SHARED_REGS_ACESSOR_SET(reg, size)					\
 
-#define SPRNG_WRAPPER(reg, bookehv_spr)					\
-	SPRNG_WRAPPER_GET(reg, bookehv_spr)				\
-	SPRNG_WRAPPER_SET(reg, bookehv_spr)				\
+#define KVMPPC_BOOKE_HV_SPRNG_ACESSOR(reg, bookehv_spr)					\
+	KVMPPC_BOOKE_HV_SPRNG_ACESSOR_GET(reg, bookehv_spr)				\
+	KVMPPC_BOOKE_HV_SPRNG_ACESSOR_SET(reg, bookehv_spr)				\
 
 #ifdef CONFIG_KVM_BOOKE_HV
 
-#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
-	SPRNG_WRAPPER(reg, bookehv_spr)					\
+#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bookehv_spr)	\
+	KVMPPC_BOOKE_HV_SPRNG_ACESSOR(reg, bookehv_spr)			\
 
 #else
 
-#define SHARED_SPRNG_WRAPPER(reg, size, bookehv_spr)			\
-	SHARED_WRAPPER(reg, size)					\
+#define KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(reg, size, bookehv_spr)	\
+	KVMPPC_VCPU_SHARED_REGS_ACESSOR(reg, size)			\
 
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
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(critical, 64)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg0, 64, SPRN_GSPRG0)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg1, 64, SPRN_GSPRG1)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg2, 64, SPRN_GSPRG2)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(sprg3, 64, SPRN_GSPRG3)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr0, 64, SPRN_GSRR0)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(srr1, 64, SPRN_GSRR1)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(dar, 64, SPRN_GDEAR)
+KVMPPC_BOOKE_HV_SPRNG_OR_VCPU_SHARED_REGS_ACCESSOR(esr, 64, SPRN_GESR)
+KVMPPC_VCPU_SHARED_REGS_ACESSOR_GET(msr, 64)
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
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(dsisr, 32)
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(int_pending, 32)
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg4, 64)
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg5, 64)
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg6, 64)
+KVMPPC_VCPU_SHARED_REGS_ACESSOR(sprg7, 64)
 
 static inline u32 kvmppc_get_sr(struct kvm_vcpu *vcpu, int nr)
 {
-- 
2.39.3

