Return-Path: <kvm+bounces-11428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA98E876E86
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:28:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C61E2847E2
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF4A2C6AA;
	Sat,  9 Mar 2024 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IFnnJqxw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4677520B0F
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947656; cv=none; b=dfOPU+P6fm8gkS1zW1JGLzgYy6/8WYmnTrSjhbhqFrEQgrx+f6XJh43kYF9ym9P4VughC3055PL2IXrzeEgol9SkmLKyeDpuyJ2F/Bb9RC93Emo63uxbiTgLwB7fmPQ5ComcqBqhst6NPxBdZPpnx187gVZ9r3uawkI7MQWbb1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947656; c=relaxed/simple;
	bh=rUvlDX/garBo7FQGCqJMZMq6R0UBQe0xv8vny/tefDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TR2OD2K7ZvrN2P1KVeXMOVbW5/7qb1xGG3eFr9/rURqz7hnm/8VHxIMfqMPVn6RLbSs1CcNE7kOpB1NF8Zvq6ARmjXaNWWdJj0Mg+bcUCryv54P4EePEXlcx8y4/s6VmYnoOIkueemxH2Bi+czWaTnxO5veEJTxwZBBsGZXZF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IFnnJqxw; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e672f1880fso915473b3a.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947654; x=1710552454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bOeR0l241/HNIRQwF4+765+GZlbUNLMWslpjXSL9lcI=;
        b=IFnnJqxw3UnRCEpHPAQiTz6fMulfyA4wnvtPnQmxT29Fp1oAxQcvorE8w8h/zqDIfW
         vnmnh4VlUoZ0LFjkNTmEsp5nPlmwfulaEsgC8b8HFhwXZHM6n735jLOZK+l6W9NegVcz
         3QG3nWg7qodbYvwpV9Tvdp0E9NpWEvSb3kTzmMDSFpLoqaKMbvD4q1GLUaM8+g5ShKU8
         FVMHYlQj529mRu2nE6o6uasLxDJ85P/KPydhJpdrA4A6Ahpu1BAXp2+iIbgrO5Q3riU3
         qgeoM+RTf6431QyG+9To7NczxCDqmumcBL1/tR3HJmK3923UpxnZo4vfm73XzvBUaapt
         XlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947654; x=1710552454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOeR0l241/HNIRQwF4+765+GZlbUNLMWslpjXSL9lcI=;
        b=SNfLsX/tZEy8/QQsMDzzXl0mVUIqKnJwypI1nZTxW27sdJ1/3aMmMtBxP+R4Np7xbt
         zQfEFrCUM0RY8uKiYtpz2AFlwG2U7FeV0ITYANhp+hWra03gsBuSfyn/jJt7uOyd/+sS
         5gUpzbGtEx6VUZSzXK21f/ftF/jeVKObZKDbW/2Cri0ijUn98Jdtb7+dKBCScHIGQahP
         0D0LcTjjPPmQmLIwsqvlLa8DlVOVitIBSxbo5LeweBwFN/G5pl15D3C6EfHzz8xE/ItA
         /wEvlfQZqA9LAgjWQerhu7wTexfmYtlMcLJ2hxtKtKL3L5HvPX70QhNLaaGOc70kL/qc
         M7qg==
X-Forwarded-Encrypted: i=1; AJvYcCVrTf1VBjdBD8k2zhA2sx1vxjU+FCqgG5VcNQKagd2sgny4AfRU7QsnXlbfINVkUEDPII13ywCfBN+D1GExbemcX689
X-Gm-Message-State: AOJu0Ywa1qjlmXwb7c7yMZCiX+o7JDS7EzCeoVmP3SPm1thTikyvlUCp
	0vxyaIPlnhjJ2hLCm7KNPASN3iNjUpAZy8LyIuwIFG9Yz6anHeFxT0UjkM4yKKVxX9JET/QQG9g
	0rg==
X-Google-Smtp-Source: AGHT+IEwL6cOqFwCHrQ/97euZuNN3v/7TvrgfRqK8reM7VfQa8XJ7pZXhuIV3Bnnoq/uRQOxrC2CEMSby7g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1741:b0:6e6:2a08:ba90 with SMTP id
 j1-20020a056a00174100b006e62a08ba90mr60420pfc.3.1709947654671; Fri, 08 Mar
 2024 17:27:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:18 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-3-seanjc@google.com>
Subject: [PATCH v6 2/9] x86/cpu: KVM: Move macro to encode PAT value to common header
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move pat/memtype.c's PAT() macro to msr-index.h as PAT_VALUE(), and use it
in KVM to define the default (Power-On / RESET) PAT value instead of open
coding an inscrutable magic number.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h |  6 ++++++
 arch/x86/kvm/x86.h               |  3 ++-
 arch/x86/mm/pat/memtype.c        | 12 +++---------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 29f0ea78e41c..af71f8bb76ae 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -352,6 +352,12 @@
 
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
index a8b71803777b..753403639e72 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -87,7 +87,8 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
 	return max(val, min);
 }
 
-#define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
+#define MSR_IA32_CR_PAT_DEFAULT	\
+	PAT_VALUE(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC)
 
 void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
 int kvm_check_nested_events(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 3e0ba044925f..f2dedddfbaf2 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -245,12 +245,6 @@ void pat_cpu_init(void)
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
@@ -281,7 +275,7 @@ void __init pat_bp_init(void)
 		 * NOTE: When WC or WP is used, it is redirected to UC- per
 		 * the default setup in __cachemode2pte_tbl[].
 		 */
-		pat_msr_val = PAT(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
+		pat_msr_val = PAT_VALUE(WB, WT, UC_MINUS, UC, WB, WT, UC_MINUS, UC);
 	}
 
 	/*
@@ -321,7 +315,7 @@ void __init pat_bp_init(void)
 		 * NOTE: When WT or WP is used, it is redirected to UC- per
 		 * the default setup in __cachemode2pte_tbl[].
 		 */
-		pat_msr_val = PAT(WB, WC, UC_MINUS, UC, WB, WC, UC_MINUS, UC);
+		pat_msr_val = PAT_VALUE(WB, WC, UC_MINUS, UC, WB, WC, UC_MINUS, UC);
 	} else {
 		/*
 		 * Full PAT support.  We put WT in slot 7 to improve
@@ -349,7 +343,7 @@ void __init pat_bp_init(void)
 		 * The reserved slots are unused, but mapped to their
 		 * corresponding types in the presence of PAT errata.
 		 */
-		pat_msr_val = PAT(WB, WC, UC_MINUS, UC, WB, WP, UC_MINUS, WT);
+		pat_msr_val = PAT_VALUE(WB, WC, UC_MINUS, UC, WB, WP, UC_MINUS, WT);
 	}
 
 	memory_caching_control |= CACHE_PAT;
-- 
2.44.0.278.ge034bb2e1d-goog


