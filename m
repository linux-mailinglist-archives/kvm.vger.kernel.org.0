Return-Path: <kvm+bounces-13857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1BD89B8C0
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 583491C21AC2
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB0545955;
	Mon,  8 Apr 2024 07:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMpC4u8n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ABF3FB83;
	Mon,  8 Apr 2024 07:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562076; cv=none; b=mFwecs4rvKjxHb0f2PqFdw+LKKKDKrrGgGbh/Cta6LGFxavobHpDQlhcH2VJeei8GM2ZCZb/tvg8EoqC18YSZJJi99ykkhLNL0rSrBrnZ+6Rz4Xtud7m+rJDmNTMjysHQP2mUQPkIqCKAF96ApC8Jty/HJuLyJZWFZqOzLSyel0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562076; c=relaxed/simple;
	bh=iKjQu5I5XlbEyI8tviReJ85sxcTJ+7YPkv/ktuPKMhM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBLuspG8taBiC358NfDh5EZX1TK+8LOjpt8FyJRR7CvvJeI0hK3+dC9/iy5+oSM0nyS8GdKPWsRgz3DhkjodhlIKMqpH9yTeGZHej4zuvaE/gRwgdcx4vzTSJ9TeH7vD/5OzEWPj5aVkLUuGWh8Msu494N04HUU49QshsIXSzEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RMpC4u8n; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4168a5d7564so512695e9.3;
        Mon, 08 Apr 2024 00:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562073; x=1713166873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJpD29/pv52tcSTFE56JNh7gpAMmLYs2U80V4FBahpg=;
        b=RMpC4u8nbgGSp3n24A/ZSWCM3wIRfJkmKqdkiKcPWYgp6BB4R+CFoGndvUSXAjVsFx
         uWfnG0wKwrVEzbi4iJJ7rU9F9jvumm/QcisU0cnn9v6tIW4ZRV7zuIY/DwcdlzYKMfco
         KLuFE30wxU5Jx6Mk4pKObNbJXg0INbWYcGFklF0TewPrgi0A9YAmMfQI+1JuWs1Pwc5O
         8fzpV0YpYHm73qji0OxwppFijL2fTS8+AzYNZKYgO/hGNXBL7JAhnlExaTjhwHW6vU8c
         HG6KRGbLHlTlsDkeFVPD+0HWsvrjuMHrA/kYi3bkrvfQS8dyX0fz64QnLnaCehYfDitk
         RV5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562073; x=1713166873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJpD29/pv52tcSTFE56JNh7gpAMmLYs2U80V4FBahpg=;
        b=Rg0RIoSweSm0jSE1qHNtTCAqH3i4IFdb9zfAY8WOWYC3a1MkC9qf6vg//bi0VSMMyP
         s4kBoH19ayjGMiHqdYrktYulJAAU0+PblRfo4gsFW6EyJXCiOQxGOkxFrEYCnNA8z4vI
         IDEjoYBWTUeqL6Scj/SSzR7sx2Znc7AREJPDmJ04y5VM9zB555LB/Lg0si4Y4o6ltUQT
         0vzLVNHwGX1Df1OgDt47iNdH7jwVDmEGJzBXwMU5/4Y+bcMfIRx6rtEonQDwrHfy+tCK
         0PBtoaxx+AeSG8dULqgqVN37r/0pKFjqGBWxX+Jqo3p6U/hL6uJbUsJMRJvmJHBYCxQ+
         2agA==
X-Forwarded-Encrypted: i=1; AJvYcCUekVbGVEdVjBvFg6bE4O2LOovVQBa8iSHzkePfTMTTPV8l88Cwd6eaZDiCwF2PBUrmiWi0I3RGeibVcAYmUH35tI3CLHwYrE30iChtgwfksti/W0S1LeOhL5TWrhU+mnv94xIzkyA2Syx2N1Dfp5n0p9G5ba4BVbY+
X-Gm-Message-State: AOJu0YzJLjJ54C92GovaaD7VsysyxomjaZpvc32NPlUmFJs06owiOZl2
	TMAzAssqLwfwUc5tunjh5TR9vhqd3TsJOO9+wfcvMa+X03i9UZqJ
X-Google-Smtp-Source: AGHT+IE8QCaOWgeggvX3bzfdgpzjd9AKZpVWk5t3o1rNmV0yg4I7I6xr4BI4sOPOf3U8/XIcokRopQ==
X-Received: by 2002:a05:600c:350f:b0:416:7071:6eff with SMTP id h15-20020a05600c350f00b0041670716effmr1229085wmq.41.1712562073135;
        Mon, 08 Apr 2024 00:41:13 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:12 -0700 (PDT)
From: vsntk18@gmail.com
To: x86@kernel.org
Cc: cfir@google.com,
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
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	vkarasulli@suse.de,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com
Subject: [PATCH v5 06/10] x86/sev: Use AP Jump Table blob to stop CPU
Date: Mon,  8 Apr 2024 09:40:45 +0200
Message-Id: <20240408074049.7049-7-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408074049.7049-1-vsntk18@gmail.com>
References: <20240408074049.7049-1-vsntk18@gmail.com>
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
index 829650bdd455..dba6cad1f7d3 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -233,6 +233,7 @@ u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void kdump_sev_callback(void);
 void sev_show_status(void);
+void sev_es_stop_this_cpu(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -263,6 +264,7 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void kdump_sev_callback(void) { }
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
index 4c235e310487..17e4263cc7d7 100644
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


