Return-Path: <kvm+bounces-9873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F248678C9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E15C01F28F0A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26D512FB0A;
	Mon, 26 Feb 2024 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="br/nDf4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A233212B169;
	Mon, 26 Feb 2024 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958112; cv=none; b=BF7nK62yFlt8AQpvJaidXO1dYfof586caU2Sgh7h+JE8i8qJMeNWTs7u+S3i5jZpww7g4ps375pz9Oi52dzJ3HE4v9XrW6cGfx35OvtLkPLqzo6j8tMrhVlyWaVcVR9BdT8x723lj5FZBQSzmeuMWxPyfbmCyLBuFCNSnJtCR1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958112; c=relaxed/simple;
	bh=Nr7CMfdJ9PM7G4Gfs8lhaw5MGkaNuGFz2WobPAAJvQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n+B12oIDexozNrWLYZ4lurz33uWEhHoJVhSQmDtjFpMceqmkvBJQ7n/FFnMoWfelpYAwM00rjiZCjIG6Pw0AAGLaTSQTc7Cdtv/tO3LRitSifFZjsj7N4ohzKxJKfpXUU3eW8r3rdWeBLzpveb5uSt8IOj49JNRFPCTKM3pOVGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=br/nDf4O; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e4c359e48aso1841974b3a.1;
        Mon, 26 Feb 2024 06:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958110; x=1709562910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rO51ukeMK5niBnG3YPZsyc+qUDg8m1O0dxWi2twkaSQ=;
        b=br/nDf4OQd34dzP7Bdqlt01ex5TpWdMLSLLhzwe3b/AvKovf3BFt3mstethmk5QgYA
         e82R2WT9WGMbRyEgzLc5Vjn/ZGNcQ0dQtitlf57oK8V9XShv81OUAqJmS25MYb9xUTm2
         uV/AxpROuYSzgISDPf8/aXiFnhkTnQDGMH/u+dTyRwsbvo27GsmuaKBOXABNUs+2zWyp
         SSgZyw+B1FmtRR1O8IQ50iWl9Fn3W/QLHWZNcK9HFAudiBlAnJlJstzsLo2hjTsq0jIY
         rPtUvXAYtT9lJqLIhbv0OhhiS1zI+/1k5G+UCVT9qcbPM1QWX6PUM7uRkwCHLbLC02JZ
         3Tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958110; x=1709562910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rO51ukeMK5niBnG3YPZsyc+qUDg8m1O0dxWi2twkaSQ=;
        b=tIoeLJo09yZUUwJPd9AWOojqNNuspakmOaMM8AHu7oFBSiLTrNhjGho2TCuu8h1R/R
         SMy2Py6HGC8zXGIjvJtNsaB8uRNxLGr65Ih7lU2p2UK41bwDtzXHvnDT1nLEMP6K2sq8
         n/w6mBWtUVYm5yKXyLNP8d8OFva5qkiHBng3LG1Y7MOERi1tu3Oo8sUAXE7hZD9tL1Ra
         nVVADqmiKLGmJQEf7M09dcDwxBDgnlFgnXz+ppjbTRPXDLsF75DRcAGYr8oR20kJ0waG
         WmaVYMvwHyjR+ZTZpxM+EpYFNrHSkAd8Vcs7XcZyoU+vIB+eNSj0yB2LXKFVo88+PWEC
         tu5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXo0wcS623gi0l80aDyA0fOWacmJE7PUKH4cl31N0sPJ/lpP2AfYkYtgSvaCPeuir4mK1w3sAspFqmAwpr68Z3nmEG
X-Gm-Message-State: AOJu0Yxnzj2OF9mAHwy3sm0gr0nAxRuQHujnw7I2J9ZB5h0yB+zA3KHk
	8M3+GcqRPPnzP0ERuul+T/lEwNx5lyGVxkhHDuJUgxeiH+4yaQQj+rZRWIV6
X-Google-Smtp-Source: AGHT+IGJvzhfAqivfTGDTqz1/+5gHpSaGMtHtrKKQtMPmpZmCYitbZIOo7kqxHG7B9PqbaEmEEBYQg==
X-Received: by 2002:a05:6a00:2d20:b0:6e5:3ec7:c068 with SMTP id fa32-20020a056a002d2000b006e53ec7c068mr882243pfb.24.1708958109539;
        Mon, 26 Feb 2024 06:35:09 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id it2-20020a056a00458200b006e543b59587sm118471pfb.126.2024.02.26.06.35.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:09 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 10/73] KVM: x86: Introduce vendor feature to expose vendor-specific CPUID
Date: Mon, 26 Feb 2024 22:35:27 +0800
Message-Id: <20240226143630.33643-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

For the PVM guest, it needs to detect PVM support early, even before IDT
setup, so the cpuid instruction is used. Moreover, in order to
differentiate PVM from VMX/SVM, a new CPUID is introduced to expose
vendor-specific features. Currently, only PVM uses it.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  8 +++++++-
 arch/x86/kvm/cpuid.c                 | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/cpuid.h                 |  3 +++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..f999f1d32423 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -5,7 +5,9 @@
 #include <linux/types.h>
 
 /* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
- * should be used to determine that a VM is running under KVM.
+ * should be used to determine that a VM is running under KVM. And it
+ * returns KVM_CPUID_FEATURES in eax if vendor feature is not enabled,
+ * otherwise KVM_CPUID_VENDOR_FEATURES.
  */
 #define KVM_CPUID_SIGNATURE	0x40000000
 #define KVM_SIGNATURE "KVMKVMKVM\0\0\0"
@@ -16,6 +18,10 @@
  * in edx.
  */
 #define KVM_CPUID_FEATURES	0x40000001
+/* This CPUID returns the vendor feature bitmaps in eax and the vendor
+ * signature in ebx.
+ */
+#define KVM_CPUID_VENDOR_FEATURES	0x40000002
 #define KVM_FEATURE_CLOCKSOURCE		0
 #define KVM_FEATURE_NOP_IO_DELAY	1
 #define KVM_FEATURE_MMU_OP		2
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dda6fc4cfae8..31ae843a6180 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -36,6 +36,16 @@
 u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_cpu_caps);
 
+u32 kvm_cpuid_vendor_features;
+EXPORT_SYMBOL_GPL(kvm_cpuid_vendor_features);
+u32 kvm_cpuid_vendor_signature;
+EXPORT_SYMBOL_GPL(kvm_cpuid_vendor_signature);
+
+static inline bool has_kvm_cpuid_vendor_features(void)
+{
+	return !!kvm_cpuid_vendor_signature;
+}
+
 u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
 	int feature_bit = 0;
@@ -1132,7 +1142,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
-		entry->eax = KVM_CPUID_FEATURES;
+		if (!has_kvm_cpuid_vendor_features())
+			entry->eax = KVM_CPUID_FEATURES;
+		else
+			entry->eax = KVM_CPUID_VENDOR_FEATURES;
 		entry->ebx = sigptr[0];
 		entry->ecx = sigptr[1];
 		entry->edx = sigptr[2];
@@ -1160,6 +1173,17 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ecx = 0;
 		entry->edx = 0;
 		break;
+	case KVM_CPUID_VENDOR_FEATURES:
+		if (!has_kvm_cpuid_vendor_features()) {
+			entry->eax = 0;
+			entry->ebx = 0;
+		} else {
+			entry->eax = kvm_cpuid_vendor_features;
+			entry->ebx = kvm_cpuid_vendor_signature;
+		}
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
 	case 0x80000000:
 		entry->eax = min(entry->eax, 0x80000022);
 		/*
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 0b90532b6e26..b93e5fec4808 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -8,6 +8,9 @@
 #include <asm/processor.h>
 #include <uapi/asm/kvm_para.h>
 
+extern u32 kvm_cpuid_vendor_features;
+extern u32 kvm_cpuid_vendor_signature;
+
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
-- 
2.19.1.6.gb485710b


