Return-Path: <kvm+bounces-7491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 093CA842B6B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6878D1F21014
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 18:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA27C155A50;
	Tue, 30 Jan 2024 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pad/F91o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27714E2C5
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706637848; cv=none; b=JSnUHYunc6nmHmILyGWcWFytaYSbNZdWyBuAPztJWdPl4Qx3+uLMvuLww50l5sbF2r4EWK4tdwdhhS+L/JZOErQgQ9BTlunAku0y0SH/0Vh+T1qfkuGbu9PMisyIUETEseToXZ4bjIg7MTMkP3NqxQK+aEa3FFJovtys/VuqD6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706637848; c=relaxed/simple;
	bh=MPXbEiZO8FTRRwkFuEYTYXcJ9fVUM/SOUAkr7KGxyO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pdDTru/C2Fqe3GezSOdig2SNoEKPT2VMqkbGb2KDHPn+7p3fCv8TiZ4VZKi1RM0JM2jJkbUHgJkGYlPwwRs5mPAM8GFVVocmCsDCLv5hRf3cQtn6jVCpmzecSkStGaxV2nVpzlek3ED/45EZV5tYXcTQkKHnaq56K6YHCjpRt60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pad/F91o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706637845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TazwPLpkgmn3mXSh/xoC2PCLCpZNJsn6snVolHEdHAs=;
	b=Pad/F91oLaqhmB8ac3Na0PstWQehhl7uHRmvkZqhJUPqDDWAHzBaisiVYg1j68I4UqQtgK
	L32TPcaOqjdPIRk9kEELtmCy5iT8XMZqA46axBriuV+Q0eGxxWtM4SUwi16ZeaGrBOtYht
	rJaCOsjVJCIqkugqd+5kMbDP2q1Cpig=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-c8omlRjNM5yZqj5Uwb_I4A-1; Tue, 30 Jan 2024 13:04:03 -0500
X-MC-Unique: c8omlRjNM5yZqj5Uwb_I4A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33aeb5a9275so1242142f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 10:04:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706637842; x=1707242642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TazwPLpkgmn3mXSh/xoC2PCLCpZNJsn6snVolHEdHAs=;
        b=wKhogeZDXEGAzqgOO08p88U9XozD07zzn1QXYAgQ4UkFgPo2q0L5w9xSGF6pWTZ5XK
         LHvBQdlrqsCjQy/NpxSrbb4Z8pFIwpbP9k3BNvKH9rv7wHA0yoWwcJTBaiYeLUDGEygo
         x1MbIcJUlwObCQQUQ8LKZpqQ1YvtZViBo0MlvaprP/QtS7c7o1r/3eZ+diYJHoYaJ6Wz
         NsSnMjPbm6YS2F1VX15Z4zhNWwQLETpA8LtXwP4+6FzKMwQrioe31Nn/ys0ur6q1dnzP
         DCf2aFk8pT7COUlbES8O+BI5dGonFfwAnlu9qmgdv0pQMzw5p8NCCXFUGEN9ELuvD84N
         +Vug==
X-Gm-Message-State: AOJu0Ywx6Xk9X9750ZPMdCTWq/9gXso8jVHb9LN8mq3v4/1wYIaLwNgY
	QrQIw6iIpHJvsLgkAoHJOSpD0XPeARz15rOgoxS5CoDMR9xBYG5OJTbVH0f6zqUBFDPBjORHefK
	N1sel6YxpWXrcAggmGuZMUCrraHVbfSJOT9E5u8EvZnCsOabrAg==
X-Received: by 2002:a05:6000:1acd:b0:33a:ef2c:7a4c with SMTP id i13-20020a0560001acd00b0033aef2c7a4cmr5678458wry.56.1706637842480;
        Tue, 30 Jan 2024 10:04:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFU7/6Rvi9ldAJZO1ucasqfsyxIhxfkV0KJX5nRNIs26IAwrIfRSkZfgCNXiIiSJprvWzbV/A==
X-Received: by 2002:a05:6000:1acd:b0:33a:ef2c:7a4c with SMTP id i13-20020a0560001acd00b0033aef2c7a4cmr5678431wry.56.1706637842100;
        Tue, 30 Jan 2024 10:04:02 -0800 (PST)
Received: from [192.168.10.118] ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id b16-20020a5d6350000000b0033aeb0afa8fsm6862636wrw.39.2024.01.30.10.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 10:04:01 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Zixi Chen <zixchen@redhat.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Kai Huang <kai.huang@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] x86/cpu/intel: Detect TME keyid bits before setting MTRR mask registers
Date: Tue, 30 Jan 2024 19:04:00 +0100
Message-ID: <20240130180400.1698136-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

MKTME repurposes the high bit of physical address to key id for encryption
key and, even though MAXPHYADDR in CPUID[0x80000008] remains the same,
the valid bits in the MTRR mask register are based on the reduced number
of physical address bits.

detect_tme() in arch/x86/kernel/cpu/intel.c detects TME and subtracts
it from the total usable physical bits, but it is called too late.
Move the call to early_init_intel() so that it is called in setup_arch(),
before MTRRs are setup.

This fixes boot on some TDX-enabled systems which until now only worked
with "disable_mtrr_cleanup".  Without the patch, the values written to
the MTRRs mask registers were 52-bit wide (e.g. 0x000fffff_80000800)
and the writes failed; with the patch, the values are 46-bit wide,
which matches the reduced MAXPHYADDR that is shown in /proc/cpuinfo.

Fixes: cb06d8e3d020 ("x86/tme: Detect if TME and MKTME is activated by BIOS", 2018-03-12)
Reported-by: Zixi Chen <zixchen@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Kai Huang <kai.huang@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/cpu/intel.c | 178 ++++++++++++++++++------------------
 1 file changed, 91 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 579e34bdf7cd..70ee316a97a9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -181,6 +181,90 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+#define MSR_IA32_TME_ACTIVATE		0x982
+
+/* Helpers to access TME_ACTIVATE MSR */
+#define TME_ACTIVATE_LOCKED(x)		(x & 0x1)
+#define TME_ACTIVATE_ENABLED(x)		(x & 0x2)
+
+#define TME_ACTIVATE_POLICY(x)		((x >> 4) & 0xf)	/* Bits 7:4 */
+#define TME_ACTIVATE_POLICY_AES_XTS_128	0
+
+#define TME_ACTIVATE_KEYID_BITS(x)	((x >> 32) & 0xf)	/* Bits 35:32 */
+
+#define TME_ACTIVATE_CRYPTO_ALGS(x)	((x >> 48) & 0xffff)	/* Bits 63:48 */
+#define TME_ACTIVATE_CRYPTO_AES_XTS_128	1
+
+/* Values for mktme_status (SW only construct) */
+#define MKTME_ENABLED			0
+#define MKTME_DISABLED			1
+#define MKTME_UNINITIALIZED		2
+static int mktme_status = MKTME_UNINITIALIZED;
+
+static void detect_tme_early(struct cpuinfo_x86 *c)
+{
+	u64 tme_activate, tme_policy, tme_crypto_algs;
+	int keyid_bits = 0, nr_keyids = 0;
+	static u64 tme_activate_cpu0 = 0;
+
+	rdmsrl(MSR_IA32_TME_ACTIVATE, tme_activate);
+
+	if (mktme_status != MKTME_UNINITIALIZED) {
+		if (tme_activate != tme_activate_cpu0) {
+			/* Broken BIOS? */
+			pr_err_once("x86/tme: configuration is inconsistent between CPUs\n");
+			pr_err_once("x86/tme: MKTME is not usable\n");
+			mktme_status = MKTME_DISABLED;
+
+			/* Proceed. We may need to exclude bits from x86_phys_bits. */
+		}
+	} else {
+		tme_activate_cpu0 = tme_activate;
+	}
+
+	if (!TME_ACTIVATE_LOCKED(tme_activate) || !TME_ACTIVATE_ENABLED(tme_activate)) {
+		pr_info_once("x86/tme: not enabled by BIOS\n");
+		mktme_status = MKTME_DISABLED;
+		return;
+	}
+
+	if (mktme_status != MKTME_UNINITIALIZED)
+		goto detect_keyid_bits;
+
+	pr_info("x86/tme: enabled by BIOS\n");
+
+	tme_policy = TME_ACTIVATE_POLICY(tme_activate);
+	if (tme_policy != TME_ACTIVATE_POLICY_AES_XTS_128)
+		pr_warn("x86/tme: Unknown policy is active: %#llx\n", tme_policy);
+
+	tme_crypto_algs = TME_ACTIVATE_CRYPTO_ALGS(tme_activate);
+	if (!(tme_crypto_algs & TME_ACTIVATE_CRYPTO_AES_XTS_128)) {
+		pr_err("x86/mktme: No known encryption algorithm is supported: %#llx\n",
+				tme_crypto_algs);
+		mktme_status = MKTME_DISABLED;
+	}
+detect_keyid_bits:
+	keyid_bits = TME_ACTIVATE_KEYID_BITS(tme_activate);
+	nr_keyids = (1UL << keyid_bits) - 1;
+	if (nr_keyids) {
+		pr_info_once("x86/mktme: enabled by BIOS\n");
+		pr_info_once("x86/mktme: %d KeyIDs available\n", nr_keyids);
+	} else {
+		pr_info_once("x86/mktme: disabled by BIOS\n");
+	}
+
+	if (mktme_status == MKTME_UNINITIALIZED) {
+		/* MKTME is usable */
+		mktme_status = MKTME_ENABLED;
+	}
+
+	/*
+	 * KeyID bits effectively lower the number of physical address
+	 * bits.  Update cpuinfo_x86::x86_phys_bits accordingly.
+	 */
+	c->x86_phys_bits -= keyid_bits;
+}
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
@@ -332,6 +416,13 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 */
 	if (detect_extended_topology_early(c) < 0)
 		detect_ht_early(c);
+
+	/*
+	 * Adjust the number of physical bits early because it affects the
+	 * valid bits of the MTRR mask registers.
+	 */
+	if (cpu_has(c, X86_FEATURE_TME))
+		detect_tme_early(c);
 }
 
 static void bsp_init_intel(struct cpuinfo_x86 *c)
@@ -492,90 +583,6 @@ static void srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
 
-#define MSR_IA32_TME_ACTIVATE		0x982
-
-/* Helpers to access TME_ACTIVATE MSR */
-#define TME_ACTIVATE_LOCKED(x)		(x & 0x1)
-#define TME_ACTIVATE_ENABLED(x)		(x & 0x2)
-
-#define TME_ACTIVATE_POLICY(x)		((x >> 4) & 0xf)	/* Bits 7:4 */
-#define TME_ACTIVATE_POLICY_AES_XTS_128	0
-
-#define TME_ACTIVATE_KEYID_BITS(x)	((x >> 32) & 0xf)	/* Bits 35:32 */
-
-#define TME_ACTIVATE_CRYPTO_ALGS(x)	((x >> 48) & 0xffff)	/* Bits 63:48 */
-#define TME_ACTIVATE_CRYPTO_AES_XTS_128	1
-
-/* Values for mktme_status (SW only construct) */
-#define MKTME_ENABLED			0
-#define MKTME_DISABLED			1
-#define MKTME_UNINITIALIZED		2
-static int mktme_status = MKTME_UNINITIALIZED;
-
-static void detect_tme(struct cpuinfo_x86 *c)
-{
-	u64 tme_activate, tme_policy, tme_crypto_algs;
-	int keyid_bits = 0, nr_keyids = 0;
-	static u64 tme_activate_cpu0 = 0;
-
-	rdmsrl(MSR_IA32_TME_ACTIVATE, tme_activate);
-
-	if (mktme_status != MKTME_UNINITIALIZED) {
-		if (tme_activate != tme_activate_cpu0) {
-			/* Broken BIOS? */
-			pr_err_once("x86/tme: configuration is inconsistent between CPUs\n");
-			pr_err_once("x86/tme: MKTME is not usable\n");
-			mktme_status = MKTME_DISABLED;
-
-			/* Proceed. We may need to exclude bits from x86_phys_bits. */
-		}
-	} else {
-		tme_activate_cpu0 = tme_activate;
-	}
-
-	if (!TME_ACTIVATE_LOCKED(tme_activate) || !TME_ACTIVATE_ENABLED(tme_activate)) {
-		pr_info_once("x86/tme: not enabled by BIOS\n");
-		mktme_status = MKTME_DISABLED;
-		return;
-	}
-
-	if (mktme_status != MKTME_UNINITIALIZED)
-		goto detect_keyid_bits;
-
-	pr_info("x86/tme: enabled by BIOS\n");
-
-	tme_policy = TME_ACTIVATE_POLICY(tme_activate);
-	if (tme_policy != TME_ACTIVATE_POLICY_AES_XTS_128)
-		pr_warn("x86/tme: Unknown policy is active: %#llx\n", tme_policy);
-
-	tme_crypto_algs = TME_ACTIVATE_CRYPTO_ALGS(tme_activate);
-	if (!(tme_crypto_algs & TME_ACTIVATE_CRYPTO_AES_XTS_128)) {
-		pr_err("x86/mktme: No known encryption algorithm is supported: %#llx\n",
-				tme_crypto_algs);
-		mktme_status = MKTME_DISABLED;
-	}
-detect_keyid_bits:
-	keyid_bits = TME_ACTIVATE_KEYID_BITS(tme_activate);
-	nr_keyids = (1UL << keyid_bits) - 1;
-	if (nr_keyids) {
-		pr_info_once("x86/mktme: enabled by BIOS\n");
-		pr_info_once("x86/mktme: %d KeyIDs available\n", nr_keyids);
-	} else {
-		pr_info_once("x86/mktme: disabled by BIOS\n");
-	}
-
-	if (mktme_status == MKTME_UNINITIALIZED) {
-		/* MKTME is usable */
-		mktme_status = MKTME_ENABLED;
-	}
-
-	/*
-	 * KeyID bits effectively lower the number of physical address
-	 * bits.  Update cpuinfo_x86::x86_phys_bits accordingly.
-	 */
-	c->x86_phys_bits -= keyid_bits;
-}
-
 static void init_cpuid_fault(struct cpuinfo_x86 *c)
 {
 	u64 msr;
@@ -712,9 +719,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 	init_ia32_feat_ctl(c);
 
-	if (cpu_has(c, X86_FEATURE_TME))
-		detect_tme(c);
-
 	init_intel_misc_features(c);
 
 	split_lock_init();
-- 
2.43.0


