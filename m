Return-Path: <kvm+bounces-19171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEF8901F40
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E96728148A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18E081ADA;
	Mon, 10 Jun 2024 10:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BdSLbM1E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B47580C15;
	Mon, 10 Jun 2024 10:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014898; cv=none; b=S+KqK5DWgUJIgE9Rn1VITUuV10sxxnnDGal0WDyEdDqzUcZbN8aY0CxUChh0TjXCgKde7TYcL+aH0wnVNbCf8DMehuSiou6BYg31ITgNTWKoOzW/uOs0crffXFuVQH+kpzPlH1B96qbw2Lv5SRQFL5/y1+1Zheij9w8RzvB2pHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014898; c=relaxed/simple;
	bh=6hjKrjcN/fccXqU8gSFAlshSHB5uk9WyGsc7Vny1jAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XUkyEcCimzXu0gldfobpE0U6bbVA/H7tDlarYZVF6A1w/Ic3U59E9ogCcVDuZ8ZlDDDafafJgobOp41IUZQntDnuuswnyVvut0NVdvKBYRg58R4sIHX/xhqVb2fkf7BMlS3U2FAN71ESckoZE94OP7VP+3YVFSoy9DrCe/krGaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BdSLbM1E; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a6f0e153eddso176157566b.0;
        Mon, 10 Jun 2024 03:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014895; x=1718619695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aoHFRW4tBY00Dbn8PrHJW1+pduEfvLupGWHJaJBOf7w=;
        b=BdSLbM1E8MP51oqY7WKNyGa0Fe/U7B+UucHfNXuji7TbAhGpDUurMIQ1rsRbOcIewC
         Ea+Ek9flNJvdEgU6+vBnC2pkzQYW1yWp+rH640sflg/NNutdnaUg+S3QSNkNZ2VaEpGQ
         bWvA+wZUV8bIGb8mM0AP/krK3fYg4/r0lgxF6CKdjOCD5uxhiIxTS4wAbEK0ClP/eNoy
         IAB4ahYs3p5ouI/NRcdvnlufuUU5Y/dYflhpaLC8piO/V4JI+Mu05YgmsfwvAm8wsKWK
         18dTxyMmB4H7ULH5iUHmGdJ6oflI+gkKwjBvbtWI5QBDEVZ7gMiqktQZ0YGBPXwCcv5O
         +OgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014895; x=1718619695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aoHFRW4tBY00Dbn8PrHJW1+pduEfvLupGWHJaJBOf7w=;
        b=F1WlCJ2yRrjp5+zh3DFIgl5pdCJhmCRvOLw0fQHJCA1DoUZAaYLEWQ2a51OPCW5iLk
         kmLY+bMrOF6Zv7oVNox9JR101882UwocVFAXhC4hrnChrAf+gIEsiEGJVfrITj1MFUny
         f1xu2FEald8Z8V+HQHg0NBmtzAAdLpdItJFaepTAGiWVXUkUh5/68uo8BmIYqFOghpp2
         mwYXG4BCJniiiHwnKK9sbv3Lyl8sIzooB02uRomtZxIHqXxPWpl3fnJRCAp7YEz+YYtC
         X6/aifr8ur0P2cOnMhVTej3idVc4yHd1TQtRO2tWhWwrFBxfH2PX8b9XlahAVSkP9XUz
         VofA==
X-Forwarded-Encrypted: i=1; AJvYcCXYTeNJkr0K4mshbJy62cC/EYze6SMM2Bzm17dD02t1ST0IMS/T5kgxoeG5xGV605VsxSm0uKy1bPZmeepmtFarxAKoVezAeQaxikI5M4DJvK6TlByVc5NUKGrvPuOBdT7SFLCfRuzjegSMDORdKhNCas/mPvu/Axx/
X-Gm-Message-State: AOJu0Yw0bt90donPLTuWMnF1oCShNKIoCkG/nd0INToZ/PR0k995z8n6
	bbitnZYD6kzlRUVkt3PhlwdD2HC9VIOsOdMfgfwzdRxyXXJk/W26
X-Google-Smtp-Source: AGHT+IESMzVFf+AerzXltPGxT0c2xQkXFKXDrzd1HTo0VAZxc9MRROEt3iL3xUr1my5F1e40MBIekw==
X-Received: by 2002:a17:907:7e9d:b0:a6f:17a9:947a with SMTP id a640c23a62f3a-a6f17a9f1bemr225645366b.71.1718014895432;
        Mon, 10 Jun 2024 03:21:35 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:35 -0700 (PDT)
From: vsntk18@gmail.com
To: vsntk18@gmail.com
Cc: x86@kernel.org,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com,
	ashish.kalra@amd.com,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jroedel@suse.de,
	jslaby@suse.cz,
	keescook@chromium.org,
	kexec@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	luto@kernel.org,
	martin.b.radev@gmail.com,
	mhiramat@kernel.org,
	michael.roth@amd.com,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	vkarasulli@suse.de
Subject: [PATCH v6 06/10] x86/sev: Use AP Jump Table blob to stop CPU
Date: Mon, 10 Jun 2024 12:21:09 +0200
Message-Id: <20240610102113.20969-7-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610102113.20969-1-vsntk18@gmail.com>
References: <20240610102113.20969-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

To support kexec under SEV-ES the APs can't be parked with HLT. Upon
wakeup the AP needs to find its way to execute at the reset vector set
by the new kernel and in real-mode.

This is what the AP jump table blob provides, so stop the APs the
SEV-ES way by calling the AP-reset-hold VMGEXIT from the AP jump
table.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/kernel/process.c  |  8 ++++++++
 arch/x86/kernel/sev.c      | 15 ++++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 963d51dcf0e6..6f681ced6594 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -232,6 +232,7 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
+void sev_es_stop_this_cpu(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -261,6 +262,7 @@ static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
+static inline void sev_es_stop_this_cpu(void) { }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b8441147eb5e..0bc615d69c0e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -52,6 +52,7 @@
 #include <asm/tdx.h>
 #include <asm/mmu_context.h>
 #include <asm/shstk.h>
+#include <asm/sev.h>
 
 #include "process.h"
 
@@ -836,6 +837,13 @@ void __noreturn stop_this_cpu(void *dummy)
 	cpumask_clear_cpu(cpu, &cpus_stop_mask);
 
 	for (;;) {
+		/*
+		 * SEV-ES guests need a special stop routine to support
+		 * kexec. Try this first, if it fails the function will
+		 * return and native_halt() is used.
+		 */
+		sev_es_stop_this_cpu();
+
 		/*
 		 * Use native_halt() so that memory contents don't change
 		 * (stack usage and variables) after possibly issuing the
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 84b79630f065..8d3cc5cd7e11 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1357,7 +1357,6 @@ void setup_ghcb(void)
 		snp_register_ghcb_early(__pa(&boot_ghcb_page));
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 void __noreturn sev_jumptable_ap_park(void)
 {
 	local_irq_disable();
@@ -1390,6 +1389,20 @@ void __noreturn sev_jumptable_ap_park(void)
 }
 STACK_FRAME_NON_STANDARD(sev_jumptable_ap_park);
 
+void sev_es_stop_this_cpu(void)
+{
+	if (!(cc_vendor == CC_VENDOR_AMD) ||
+	    !cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		return;
+
+	/* Only park in the AP jump table when the code has been installed */
+	if (!sev_ap_jumptable_blob_installed)
+		return;
+
+	sev_jumptable_ap_park();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
 static void sev_es_ap_hlt_loop(void)
 {
 	struct ghcb_state state;
-- 
2.34.1


