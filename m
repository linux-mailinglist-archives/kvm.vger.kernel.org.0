Return-Path: <kvm+bounces-11565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ED89F8784EC
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15626B21603
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CBA5677F;
	Mon, 11 Mar 2024 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FX4TF6OE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8354F5EA;
	Mon, 11 Mar 2024 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710173865; cv=none; b=Tnib0cAYMsLla7L8AM4QWyv/d1mzH7LIAJt3EREz0kIvSw3CPC86CZIyHWi+sN2O864PMgqYbZijLHzPWIaXDmXKlsFkDXgTbDUxUmtvFMYCJBcXbLx+pNzGtDI/RSkEu+ZNsanhzF0CFTuGd9r0SgQ23vfD5FiE/Uj7dSIr5f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710173865; c=relaxed/simple;
	bh=qyug1TiSxBgmhet3ML7LgG8vHlI4z2vu4W9y71YYu60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=roYeiBtUQNU4W4sswt1dq41WgXiT421HNM39rpxYxESkLUazwobK6N+xrCxKIIq3S0XZ6FnomzEgdLTj6pLb0srF5qQLFLrKF3hcpP83LcPNNvXGCtk0l7R4Fiy+iRP0ltetfz3Mtm/kNfP+FblTfYPZIzyqTgIpokJ6StEUPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FX4TF6OE; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4133027fa88so2565655e9.1;
        Mon, 11 Mar 2024 09:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710173861; x=1710778661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xZKnKV6vagYMs+CUwMzgN6IK8RsSRi3wmiW45NPZ9I=;
        b=FX4TF6OEYlskr3tMsHR1H4SHdyXhu1wwtNj6I5stZBQwkawaeXIukayYzL6Z4sFN2j
         YKNQFrL3FVWzhUxhJFYCaDPvgg5C4c/N+j6WNVP2tQSb/KfWZciiUzygeCC7bJS36IhC
         sNuQWEHipJyQbkG6iL0zsFyboAJRc0izcV3JDTyPiCb9AuAI0p1l91v881RoPWH/iwIO
         3Yb2JTwDIRv14NX4MkEgL7x4rxQE0miD2uT103Ej+g/yGhdhnmgFtUwOmM8VuPGS/GZb
         PcoQ7nKcyUuO0+iBWpxMUge5LI0VIEVLtj6Kgk85Sjzre+F3i4oYdUfxM2oTw/+xM5PR
         0ERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710173861; x=1710778661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xZKnKV6vagYMs+CUwMzgN6IK8RsSRi3wmiW45NPZ9I=;
        b=DYBwB/2iZmneDIs3uSVWNsmzNK4YUA63fu1BEN3/T8uaiGG4FzrHLoV+rBEE5NoxGq
         ADc1Dp8cTHKl7nvCKjs1+lWuP1nhuvSsPcEcosgqWNOH+KcF6sL0vADaEHR5x+WGwyG0
         3UF9B6NZ62XWUCGXcCgu8kFJJkTktfbk9fasgUaJXxRVoMfOFPD7ZelttaHbxJQz9eGl
         2PPiKPElu4AWuN4/MKcd8kXz41sauMakuXMcILmJvkTRlqrPZHFNlCF23aLl9qxYEJOu
         E4AiF88Lf5YNN+vY8HfsTtz2TfQ2Bvc5peq+62XqpkyV/rUMwaTf9/BcQhVIjtLWMgTF
         U+iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdQsgb4Gc6GbNihV8u9sPR7r4AuFNAwIIkHY5tEIuToyfwtz0322FG2EamXpYtNQUA+k4WtkOLFZlVrAls5NwBUoouYJ7OdxZ7EChb62hmr25z6OBc1dAX+3Otd3dzGZWqoEJD/ZO+8lZ2+9fqkzdut2Ka0NVeRlue
X-Gm-Message-State: AOJu0YwhVpWcRrCXRKimV6Z+hio6m3Q0oB89EhMJBtHpjnM7AjjjTihB
	pzmQaQfiXGpNZwlfj5igtSrKfleVOzI1f97anbplMPBnF029eeHS
X-Google-Smtp-Source: AGHT+IHdxdRKuyogtANKix0xsfVIxJjqfkRL3xOpZ/E6JkPe6fFXU/lAH+e1wKvVax66n9KjcPMJqg==
X-Received: by 2002:a05:600c:5026:b0:413:d95:bb2c with SMTP id n38-20020a05600c502600b004130d95bb2cmr705386wmr.33.1710173860999;
        Mon, 11 Mar 2024 09:17:40 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab47:8200:c3b9:43af:f8e1:76f9])
        by smtp.gmail.com with ESMTPSA id ba14-20020a0560001c0e00b0033e96fe9479sm2823815wrb.89.2024.03.11.09.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 09:17:40 -0700 (PDT)
From: Vasant Karasulli <vsntk18@gmail.com>
To: x86@kernel.org
Cc: joro@8bytes.org,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
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
	Joerg Roedel <jroedel@suse.de>,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v4 6/9] x86/sev: Use AP Jump Table blob to stop CPU
Date: Mon, 11 Mar 2024 17:17:24 +0100
Message-Id: <20240311161727.14916-7-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240311161727.14916-1-vsntk18@gmail.com>
References: <20240311161727.14916-1-vsntk18@gmail.com>
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
index c48db0bfb707..2dbd2238325a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -216,6 +216,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
+void sev_es_stop_this_cpu(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -244,6 +245,7 @@ static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *in
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
+static inline void sev_es_stop_this_cpu(void) { }
 #endif

 #endif
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ab49ade31b0d..ddc3fa076f4d 100644
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
index 08bf897361b9..10f4294904b4 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1350,7 +1350,6 @@ void setup_ghcb(void)
 		snp_register_ghcb_early(__pa(&boot_ghcb_page));
 }

-#ifdef CONFIG_HOTPLUG_CPU
 void __noreturn sev_jumptable_ap_park(void)
 {
 	local_irq_disable();
@@ -1383,6 +1382,20 @@ void __noreturn sev_jumptable_ap_park(void)
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


