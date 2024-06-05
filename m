Return-Path: <kvm+bounces-18961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B92578FDA46
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51835282E49
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37F115FA8D;
	Wed,  5 Jun 2024 23:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOWx6Wky"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF18167DBF
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629568; cv=none; b=ViSe7oMQGWhGCDCtkrGGdT1YmwOzQLuMD1fuJFnMadjcEA2YMODS7PF7yNHnt6w+1s5u81fnay3Q6EJE9f8hsS2WLcTp2qVRmdoVJIhhsCpt+xZeLNHujcL8GJ9nvX4z8kL0WzUxz3RB+rXCQfyVaMMa7vtkg9L/b3ZHbfw4zpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629568; c=relaxed/simple;
	bh=OT9vjFDhZJe+JrrZnAEYUNwBDJu9CJaj1NqYkfGoeo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lvAfamaMJSyIGGeR9q+p8s1RmEMLcSUvw9B2gFaf6BEp5HXEWzIoHzhnuXXBn5COCbnR5XOdWf4CmnsKSU7MEyx1zlT0ZPOPobvdOHk/TqPrxjD8saa9jvhbVG2QUYxLVrj2D5if9bPv7wJgABikDiXNJzvZSz6mKkhv79F/4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOWx6Wky; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c1ad1ee431so328253a91.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629566; x=1718234366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ARgGaSqi8KoE1rzp74nNuwJdH1oic2zBLvAnQFTt+74=;
        b=eOWx6WkyZB64F2yv50KrVKWPQvvZnN0dBJ5ZFInZ1FCho1RMgsYnShdf9aW0nZE3uM
         TZWP/QNw+/19J2nQuhYrtoK/Wkqr7USxQhVx5p9pAA+ue5d90agnTSj+lvpzqCHJVgaM
         Wlkhvu/5HEIinP4DqQz5mM0F8tu46i0mz55lfoTzUzsB66mU+8hjmN9R7Jk17B1SXT8K
         +jv92+tEjUlLcc3KjncSkXCWfdFzwcmfpoWjAFC0c8AbVakzH8f8enyaoH3GS3DYa+d1
         wOET/Dt5ycFfbo9SqKlkMI1QWbpojzZk3C6pHVkQP1dpKv3vn+XDNlmzSIN2Wa0gV+P4
         9W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629566; x=1718234366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARgGaSqi8KoE1rzp74nNuwJdH1oic2zBLvAnQFTt+74=;
        b=X6YuVNzwKfXLYmpdPfUGF/tWhGXT3NrNFbB+pQTkz79OAM2J01HL4bWCxGbPKIecx9
         xXgnC7/cdV8QdJPzhsyO7cRHMP1cqovGj++dJxcEK9FvskRqchNVvptREPJxRtJjsqNT
         Mq9qweN4gTIzqHACiL4Bq6L1o2Kbn9S5NZWTIOkc7W6jFGXP9U1B6qGVYcfHOiR8RG/j
         aCaX+LCVI0+Q+cgEUAbsiu/407nlaGa1QSQIy4ueER3dOmBwia1Qz2DCYCZMqyi2PWtZ
         htpTOXJG4XqRZ8INk7Rtoy69zs7JJZ7gxp4naO5DAB8j+aE//3tBbNq/fdIf2idcdQUY
         PCNA==
X-Forwarded-Encrypted: i=1; AJvYcCU209g01vkNF7SGlnJ96/0wCcj4trqtxD+EayzKUelpNVSlwH5sds8DLUPz2ytI6h+R24Ik/wNIsXx/r1g2sCbZWEtV
X-Gm-Message-State: AOJu0Yz9lyZQnsg0XwjE7x80FaMTo2PGRWSiaLNLJCsFFXP4RRJ0z+3r
	jLcyYNU4ztIpeh+Va9QttzMfYBFvbCuahDTibiJnV7XIgbSqyyJVanKISrwdv3TUFSkyyY9AG5k
	WKw==
X-Google-Smtp-Source: AGHT+IEUS/On3FFj7eNLgO/pl33ogfTV3slv6hjA3hktSVZ/uIH5U0G8J1CqwLnY4uPln+tauIKBhcln4jg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:347:b0:2c2:128:47af with SMTP id
 98e67ed59e1d1-2c27db6810cmr14869a91.7.1717629565921; Wed, 05 Jun 2024
 16:19:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:10 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-3-seanjc@google.com>
Subject: [PATCH v8 02/10] x86/cpu: KVM: Move macro to encode PAT value to
 common header
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move pat/memtype.c's PAT() macro to msr-index.h as PAT_VALUE(), and use it
in KVM to define the default (Power-On / RESET) PAT value instead of open
coding an inscrutable magic number.

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h |  6 ++++++
 arch/x86/kvm/x86.h               |  3 ++-
 arch/x86/mm/pat/memtype.c        | 13 +++----------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1978ba0adb49..d93b73476583 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -377,6 +377,12 @@
 
 #define MSR_IA32_CR_PAT			0x00000277
 
+#define PAT_VALUE(p0, p1, p2, p3, p4, p5, p6, p7)			\
+	((X86_MEMTYPE_ ## p0)      | (X86_MEMTYPE_ ## p1 << 8)  |	\
+	(X86_MEMTYPE_ ## p2 << 16) | (X86_MEMTYPE_ ## p3 << 24) |	\
+	(X86_MEMTYPE_ ## p4 << 32) | (X86_MEMTYPE_ ## p5 << 40) |	\
+	(X86_MEMTYPE_ ## p6 << 48) | (X86_MEMTYPE_ ## p7 << 56))
+
 #define MSR_IA32_DEBUGCTLMSR		0x000001d9
 #define MSR_IA32_LASTBRANCHFROMIP	0x000001db
 #define MSR_IA32_LASTBRANCHTOIP		0x000001dc
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5da5b869a991..056cc4a12e56 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -103,7 +103,8 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 	return max(val, min);
 }
 
-#define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
+#define MSR_IA32_CR_PAT_DEFAULT	\
+	PAT_VALUE(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC)
 
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 15b888ebaf17..6c4e29457c10 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -248,12 +248,6 @@ void pat_cpu_init(void)
 void __init pat_bp_init(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
-#define PAT(p0, p1, p2, p3, p4, p5, p6, p7)				\
-	((X86_MEMTYPE_ ## p0)      | (X86_MEMTYPE_ ## p1 << 8)  |	\
-	(X86_MEMTYPE_ ## p2 << 16) | (X86_MEMTYPE_ ## p3 << 24) |	\
-	(X86_MEMTYPE_ ## p4 << 32) | (X86_MEMTYPE_ ## p5 << 40) |	\
-	(X86_MEMTYPE_ ## p6 << 48) | (X86_MEMTYPE_ ## p7 << 56))
-
 
 	if (!IS_ENABLED(CONFIG_X86_PAT))
 		pr_info_once("x86/PAT: PAT support disabled because CONFIG_X86_PAT is disabled in the kernel.\n");
@@ -284,7 +278,7 @@ void __init pat_bp_init(void)
 		 * NOTE: When WC or WP is used, it is redirected to UC- per
 		 * the default setup in __cachemode2pte_tbl[].
 		 */
-		pat_msr_val = PAT(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
+		pat_msr_val = PAT_VALUE(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
 	}
 
 	/*
@@ -319,7 +313,7 @@ void __init pat_bp_init(void)
 		 * NOTE: When WT or WP is used, it is redirected to UC- per
 		 * the default setup in __cachemode2pte_tbl[].
 		 */
-		pat_msr_val = PAT(WB, WC, UC_MINUS, UC, WB, WC, UC_MINUS, UC);
+		pat_msr_val = PAT_VALUE(WB, WC, UC_MINUS, UC, WB, WC, UC_MINUS, UC);
 	} else {
 		/*
 		 * Full PAT support.  We put WT in slot 7 to improve
@@ -347,13 +341,12 @@ void __init pat_bp_init(void)
 		 * The reserved slots are unused, but mapped to their
 		 * corresponding types in the presence of PAT errata.
 		 */
-		pat_msr_val = PAT(WB, WC, UC_MINUS, UC, WB, WP, UC_MINUS, WT);
+		pat_msr_val = PAT_VALUE(WB, WC, UC_MINUS, UC, WB, WP, UC_MINUS, WT);
 	}
 
 	memory_caching_control |= CACHE_PAT;
 
 	init_cache_modes(pat_msr_val);
-#undef PAT
 }
 
 static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype accesses */
-- 
2.45.1.467.gbab1589fc0-goog


