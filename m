Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5396CCB0E
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjC1T60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC1T6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:58:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AFF3A85
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:09 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u1so7617712wmn.5
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680033488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A416pUmXSfyjfvZmC8DpRUw6ME53SsgLznqZ8bBGXvQ=;
        b=PXfJSuhwiQ7FZQisc1aUqZ35MafZWj18AsDcwFxDGSrbdIUHFDHHNw12nM0YVnjvof
         LfZDfX230Z3IT1Q5f4YmiYznazFru6ktoDwH4rb5NMm5pduXceFyLIQd0mSKkh1xcoAo
         tvpZE2sj8yTeE127cTr528j+An/QwXGRVEHUGNfl/ueyLmKvYCB8WfofLLfTTcmwunmQ
         ESqUpFpKpcQGJJJvwMZjKydItfibCTzFdC2yUNqiqnpBZHtcG2CyBbC48lAsC5VczmBy
         4bvhmfT5lFTPXcoszDXs9TIvI/4d1m1H/K+aCxf/di3O0O8wAa71uDKhM0jMXC8F2zT8
         ovmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A416pUmXSfyjfvZmC8DpRUw6ME53SsgLznqZ8bBGXvQ=;
        b=vLxMfsRj76C8h/pByEltHa67iFuMhyr9TRsEz7LT3n9vSDN2V6J0E5+mKbMiMVpFDO
         xyiItS2L4PX1k6YbECNGgVExEtamy5rHOp1JbM5KyAIj22fqFM8k3jA1yDRwPLCkYjnV
         gm8hwCK9oY0sCWHpdBzUbtNxw4234UFBWrpd3NTDQn3xiwAbTvUVVdIMXzoh9fD2o5yu
         HfwaLGhrqYUOsP+iXLlnYNBH8+PzhYzuRDKaC7I0Z1qnfVCjZ6RG6nuSrUFsGsQQGF4T
         e//h+CQit5hypk3vCevnzmR5aa61co0uLeAH00mN/nPEvuATlXSHuYz8RdZ3jTPc5+f6
         7YDQ==
X-Gm-Message-State: AAQBX9e9LKAkBq/wByuTWlNTXwXKRX2z5GwKiiH6BBKKNlbeaGOJxUrm
        MUHTI8fb5/55+Guncz/bgn93FDQaoWoOSkMY0ig=
X-Google-Smtp-Source: AKy350ZAOz8VV6bkSjlOCGrsiNr2MEoP0GQ/uNLnytCPdeZNDdgNF6XCyh0Xv5cqxCV5+2QxiSKiXw==
X-Received: by 2002:a7b:cdef:0:b0:3ef:7616:d179 with SMTP id p15-20020a7bcdef000000b003ef7616d179mr2667200wmj.20.1680033488375;
        Tue, 28 Mar 2023 12:58:08 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8445:3123:91d7:959d])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm28248386wrw.99.2023.03.28.12.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 12:58:07 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v17 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Date:   Tue, 28 Mar 2023 20:57:58 +0100
Message-Id: <20230328195758.1049469-9-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230328195758.1049469-1-usama.arif@bytedance.com>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Enable parallel bringup for SEV-ES guests. The APs can't actually
execute the CPUID instruction directly during early startup, but they
can make the GHCB call directly instead, just as the VC trap handler
would do.

Thanks to Sabin for talking me through the way this works.

Suggested-by: Sabin Rapan <sabrapan@amazon.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/core.c              |  5 ++++
 arch/x86/include/asm/coco.h       |  1 +
 arch/x86/include/asm/sev-common.h |  3 +++
 arch/x86/include/asm/smp.h        |  5 +++-
 arch/x86/kernel/head_64.S         | 30 ++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c         | 39 ++++++++++++++++++++++++++-----
 6 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f881484..0bab38efb15a 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -129,6 +129,11 @@ u64 cc_mkdec(u64 val)
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
 
+enum cc_vendor cc_get_vendor(void)
+{
+	return vendor;
+}
+
 __init void cc_set_vendor(enum cc_vendor v)
 {
 	vendor = v;
diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
index 3d98c3a60d34..0428d9712c96 100644
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -12,6 +12,7 @@ enum cc_vendor {
 };
 
 void cc_set_vendor(enum cc_vendor v);
+enum cc_vendor cc_get_vendor(void);
 void cc_set_mask(u64 mask);
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index b63be696b776..0abf8a39cee1 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -70,6 +70,7 @@
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
 
+#ifndef __ASSEMBLY__
 /*
  * SNP Page State Change Operation
  *
@@ -161,6 +162,8 @@ struct snp_psc_desc {
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
+#endif /* __ASSEMBLY__ */
+
 /*
  * Error codes related to GHCB input that can be communicated back to the guest
  * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index defe76ee9e64..1584f04a7007 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -204,7 +204,10 @@ extern unsigned int smpboot_control;
 /* Control bits for startup_64 */
 #define STARTUP_APICID_CPUID_0B	0x80000000
 #define STARTUP_APICID_CPUID_01	0x40000000
+#define STARTUP_APICID_SEV_ES	0x20000000
 
-#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B)
+#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | \
+			       STARTUP_APICID_CPUID_0B | \
+			       STARTUP_APICID_SEV_ES)
 
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index ff3a5f008d8a..9c38849fcac8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -26,6 +26,7 @@
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
 #include <asm/smp.h>
+#include <asm/sev-common.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -242,6 +243,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	 *
 	 * Bit 31	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
 	 * Bit 30	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
+	 * Bit 29	STARTUP_APICID_SEV_ES flag (CPUID 0x0b via GHCB MSR)
 	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
 	 */
 	movl	smpboot_control(%rip), %ecx
@@ -249,6 +251,10 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	jnz	.Luse_cpuid_0b
 	testl	$STARTUP_APICID_CPUID_01, %ecx
 	jnz	.Luse_cpuid_01
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	testl	$STARTUP_APICID_SEV_ES, %ecx
+	jnz	.Luse_sev_cpuid_0b
+#endif
 	andl	$0x0FFFFFFF, %ecx
 	jmp	.Lsetup_cpu
 
@@ -259,6 +265,30 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	shr	$24, %edx
 	jmp	.Lsetup_AP
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+.Luse_sev_cpuid_0b:
+	/* Set the GHCB MSR to request CPUID 0xB_EDX */
+	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
+	movl	$(GHCB_CPUID_REQ_EDX << 30) | GHCB_MSR_CPUID_REQ, %eax
+	movl	$0x0B, %edx
+	wrmsr
+
+	/* Perform GHCB MSR protocol */
+	rep; vmmcall		/* vmgexit */
+
+	/*
+	 * Get the result. After the RDMSR:
+	 *   EAX should be 0xc0000005
+	 *   EDX should have the CPUID register value and since EDX
+	 *   is the target register, no need to move the result.
+	 */
+	rdmsr
+	andl	$GHCB_MSR_INFO_MASK, %eax
+	cmpl	$GHCB_MSR_CPUID_RESP, %eax
+	jne	1f
+	jmp	.Lsetup_AP
+#endif
+
 .Luse_cpuid_0b:
 	mov	$0x0B, %eax
 	xorl	%ecx, %ecx
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 05d202b7dcaa..6ef040fd28a0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -85,6 +85,7 @@
 #include <asm/hw_irq.h>
 #include <asm/stackprotector.h>
 #include <asm/sev.h>
+#include <asm/coco.h>
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
@@ -1514,15 +1515,36 @@ void __init smp_prepare_cpus_common(void)
  * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
  * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
  * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
- * hard. And not for SEV-ES guests because they can't use CPUID that
- * early.
+ * hard.
  */
 static bool prepare_parallel_bringup(void)
 {
-	if (IS_ENABLED(CONFIG_X86_32) || cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+	bool has_sev_es = false;
+
+	if (IS_ENABLED(CONFIG_X86_32))
 		return false;
 
-	if (x2apic_mode) {
+	/*
+	 * Encrypted guests other than SEV-ES (in the future) will need to
+	 * implement an early way of finding the APIC ID, since they will
+	 * presumably block direct CPUID too. Be kind to our future selves
+	 * by warning here instead of just letting them break. Parallel
+	 * startup doesn't have to be in the first round of enabling patches
+	 * for any such technology.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
+		switch (cc_get_vendor()) {
+		case CC_VENDOR_AMD:
+			has_sev_es = true;
+			break;
+
+		default:
+			pr_info("Disabling parallel bringup due to guest state encryption\n");
+			return false;
+		}
+	}
+
+	if (x2apic_mode || has_sev_es) {
 		if (boot_cpu_data.cpuid_level < 0x0b)
 			return false;
 
@@ -1531,8 +1553,13 @@ static bool prepare_parallel_bringup(void)
 			return false;
 		}
 
-		pr_debug("Using CPUID 0xb for parallel CPU startup\n");
-		smpboot_control = STARTUP_APICID_CPUID_0B;
+		if (has_sev_es) {
+			pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
+			smpboot_control = STARTUP_APICID_SEV_ES;
+		} else {
+			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
+			smpboot_control = STARTUP_APICID_CPUID_0B;
+		}
 	} else {
 		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
 		if (boot_cpu_data.cpuid_level < 0x01)
-- 
2.25.1

