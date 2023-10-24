Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9857D43CE
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjJXAQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJXAQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:16:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45C2110
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:16:47 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9b774f193so32920375ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698106607; x=1698711407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T6ALsOVdAlXxureR7/QG1Tl27zbxYFHpyn+YFicZdFw=;
        b=i9HwRcdQ9Snto35wwaub/NWGrf4zhl8z+CwyN/hcPoeChICO78mEZyINA1Gg5i198B
         qxxJF1mcm9UmfSGhTrI9E4UZqF1PUnooB7bxayu11gUCI9ChoqrrSRTNoJ+/xc/EGVvo
         zv6jxeZP1oHGSgL7uSqcxf1aSdc19JqNpRvfuED76VZr6Z7cPIHC9vrj3/PF2GiKDCEO
         lkPaNohK2gr0eivBcxP48FqktbbnXh1pu7F7labgzNDjuKo5M7REutWAlynSYpL8hpHC
         0UP3oYdEDNWYhvVSpKjVv6PLfGgHtgKl0LIHRzKaarUPofqhTY5/ze38tQ3Vk25Hiw8Y
         He8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698106607; x=1698711407;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T6ALsOVdAlXxureR7/QG1Tl27zbxYFHpyn+YFicZdFw=;
        b=tNxDcW5/d4/kDbfAh3ClKFc+MIFb+tfRuihp4EgAVRsCoOw3DJhBuWGci/5yhvFUfr
         m+T71lxyikh34RYOBoSMqs1rrhKhTMExAhHaW0UUPAVT93hl6XctypxJn6oCU6wWGCc/
         DiJwWX+yh8nECSAPN8DWI5uKJ0r0L4RS5KAk2LW8nq1eG+VjA+revRB2uQhBdfQWcc57
         JJqcAUMCnNuldBubN3TuGPDCWd1/NTfwPFRRNXh9/iHXoK93JwBzG6l/1N8DZSGFOUH7
         JUPixJtBT6Bu7FoiTOXImNYv5pCoVndYbO+aThWxSHxqkhkv7pjwgs5iGkaBBzygHQyf
         H4fA==
X-Gm-Message-State: AOJu0YwNzHzndsKFhi20Vh/a20ZFKX2nq7g7e6pzK84oT456hbvB7Csi
        Fc/vkazVvlbsbb82avSKusQpYBCWBAh5SvFvng2A+fRXSSwiXp/1g+XjDWGkpfe7Hflms6kSQ0J
        RbyVc+g+ma617D/k+B46W4qg0DTAEF+kkGdN5bJHHdAkqA4WuL1Z84FLHFgWS9Xo=
X-Google-Smtp-Source: AGHT+IFDCMmMrkqcHkV/IvrXQJsoF6mLgyYuQOcv/2eqAiN+SXhRfmuUXJSzhGqA+xfyOTY6AsU9aSipfADbnw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:7fc6:b0:1c9:e830:15fa with SMTP
 id t6-20020a1709027fc600b001c9e83015famr187346plb.0.1698106606998; Mon, 23
 Oct 2023 17:16:46 -0700 (PDT)
Date:   Mon, 23 Oct 2023 17:16:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024001636.890236-1-jmattson@google.com>
Subject: [PATCH 1/2] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to userspace
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Paolo Bonzini '" <pbonzini@redhat.com>,
        "'Sean Christopherson '" <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The low five bits {INTEL_PSFD, IPRED_CTRL, RRSBA_CTRL, DDPD_U, BHI_CTRL}
advertise the availability of specific bits in IA32_SPEC_CTRL. Since KVM
dynamically determines the legal IA32_SPEC_CTRL bits for the underlying
hardware, the hard work has already been done. Just let userspace know
that a guest can use these IA32_SPEC_CTRL bits.

The sixth bit (MCDT_NO) states that the processor does not exhibit MXCSR
Configuration Dependent Timing (MCDT) behavior. This is an inherent
property of the physical processor that is inherited by the virtual
CPU. Pass that information on to userspace.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c         | 21 ++++++++++++++++++---
 arch/x86/kvm/reverse_cpuid.h | 12 ++++++++++++
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c134c181ba80..e5fc888b2715 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -677,6 +677,11 @@ void kvm_set_cpu_caps(void)
 		F(AMX_COMPLEX)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
+		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
+		F(BHI_CTRL) | F(MCDT_NO)
+	);
+
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
@@ -957,13 +962,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* function 7 has additional index. */
 	case 7:
-		entry->eax = min(entry->eax, 1u);
+		max_idx = entry->eax = min(entry->eax, 2u);
 		cpuid_entry_override(entry, CPUID_7_0_EBX);
 		cpuid_entry_override(entry, CPUID_7_ECX);
 		cpuid_entry_override(entry, CPUID_7_EDX);
 
-		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
-		if (entry->eax == 1) {
+		/* KVM only supports up to 0x7.2, capped above via min(). */
+		if (max_idx >= 1) {
 			entry = do_host_cpuid(array, function, 1);
 			if (!entry)
 				goto out;
@@ -973,6 +978,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->ebx = 0;
 			entry->ecx = 0;
 		}
+		if (max_idx >= 2) {
+			entry = do_host_cpuid(array, function, 2);
+			if (!entry)
+				goto out;
+
+			cpuid_entry_override(entry, CPUID_7_2_EDX);
+			entry->ecx = 0;
+			entry->ebx = 0;
+			entry->eax = 0;
+		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		union cpuid10_eax eax;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index b81650678375..17007016d8b5 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -16,6 +16,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
 	CPUID_8000_0022_EAX,
+	CPUID_7_2_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -46,6 +47,14 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
+#define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
+#define X86_FEATURE_IPRED_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 1)
+#define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
+#define X86_FEATURE_DDPD_U		KVM_X86_FEATURE(CPUID_7_2_EDX, 3)
+#define X86_FEATURE_BHI_CTRL		KVM_X86_FEATURE(CPUID_7_2_EDX, 4)
+#define X86_FEATURE_MCDT_NO		KVM_X86_FEATURE(CPUID_7_2_EDX, 5)
+
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
@@ -80,6 +89,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
+	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 };
 
 /*
@@ -116,6 +126,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_CONSTANT_TSC;
 	else if (x86_feature == X86_FEATURE_PERFMON_V2)
 		return KVM_X86_FEATURE_PERFMON_V2;
+	else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
+		return KVM_X86_FEATURE_RRSBA_CTRL;
 
 	return x86_feature;
 }
-- 
2.42.0.758.gaed0368e0e-goog

