Return-Path: <kvm+bounces-19174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7036901F4B
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8C01F24D1D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E088513210C;
	Mon, 10 Jun 2024 10:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACvOjDr6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01FD84DE0;
	Mon, 10 Jun 2024 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014906; cv=none; b=LyCwJgqrS938hUCyRrJHuMgkaVi6rSBDDcTfDHK9QaXQHBO4cgMSy+I0bmVDZJehpJpfa7xLjhgUdIedZiG4Qj7lC6I8/SpsNxbkJJOEm4Fji4JUqrC3StHDjOtKbASDnM2BRMoXidkJZOGbrUPhZw3TTSUl3I3VUFtR5ci2GOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014906; c=relaxed/simple;
	bh=/9mG+Gjg7peWW7HnQepJ7FLCY6yAMicMO5w7jMUE6lc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TZvk0ZbNdNulUytMIU1U76DtnZPw3fxqazfU3dnaRRxWvvs7+WdgshIHsumDcYW+yQ0JNTvp0EeKPMKmWLqTHylWBSxKO+N6XxP1f/QmPxLhDZyPal5PvLvd5+dd/OfCsPUwV8fwwi8F3P/lXVO2TWwTWMPm6uflX/zCDRZ/2vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ACvOjDr6; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a6f21ff4e6dso55580466b.3;
        Mon, 10 Jun 2024 03:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014902; x=1718619702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tjh976F+w5dkctaCwhyVJIF3AZpvtw+7R+eeFp89bGc=;
        b=ACvOjDr60hT3vH0Hsv92z3LQPu209rOvEzL8UDJo97ooQTfGNtdaJGc77koO/VtCkp
         LKNi9/pEEFHHrEszjSWGt5WSmeIfAILIQkh81UFeU13mI2+SpmA4r4thwxB/Ptvt46MG
         t+ahmeMKHQRO+ZtTVxkb4K1EkUqQ6zxNRaES3ajxF98vqnoR4h/08I6FM7vZjvb6Bl3o
         6zQ2Zukr+i6Ytls5gL0g678ppvNVEpY4RLw3mVCuj71VU/jmdKvMvkWLkLLE0B/f3TDY
         VWWl6xBTk7j2G8CBiNcF6ktfvrb2svTGGYG01Vrok/uJuR9FrTdYcZXBXmA6OwqKXHpB
         vPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014902; x=1718619702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tjh976F+w5dkctaCwhyVJIF3AZpvtw+7R+eeFp89bGc=;
        b=i8hQF0gQ8fVXDBY8WOj874ttMVRhOdDaL6pFMn0ryZq9MoTPNfBQgAartvqQb68INU
         X5RgNpATPRg8O0jjpgILDM9t3z+Hkyiy9nsaPP0ivr3eMSoXvn7vCItiQeC+MJy+m3MS
         WhmCqiodhCewXz2JRxTeUclixOsetgk9kSwJ/+SZJtALjRY5WvGKM1GbUfGwaJP0PCFZ
         laZg9OF21xNZ6lodVXfVJjdtrbi5+nAs9laC4zRgnw8Nu5bodo1oD6pw5+j7tIt74/eD
         ehfgb7dAVjl/qMkxjj5vY7Gw6Nqem/WXOETD659ljg6jT7tnXOCa/sLNQMdumkCn8G8R
         NMbw==
X-Forwarded-Encrypted: i=1; AJvYcCUfxqFU/4zxOjSIbULvFEaLicvliCH2gZJrsU2AuimhmBg6BsrWgs/5L54UBYNGZLqZMtOjG5kyRtF7vhHWVQaCCOqRP6G8WpP3mbsq/YghGQGCt/vwG3U8Y4tfGB60tdYEXNs5p68b3Tp5h1wGo1p58vti8BFBGTy4
X-Gm-Message-State: AOJu0YyiHz1sgoeReyRqvy7+/I7OrllxTk+Rz1LDmjBY4KGX9eZ2Pbsr
	A39JDOB2pwEo+6QZ43W53NN/dlO1dk5nLI39ZMlJhsrfYrrnGv9k
X-Google-Smtp-Source: AGHT+IEHe6hQkeUB13VRsNS95Hd5J4lzAWr+VF1fStw/ZH7jO5g8M7PodQMj2dQ17+7klWDhdygebg==
X-Received: by 2002:a17:906:6a0a:b0:a6f:1d19:c0b1 with SMTP id a640c23a62f3a-a6f1d19c496mr194718166b.18.1718014902187;
        Mon, 10 Jun 2024 03:21:42 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:41 -0700 (PDT)
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
Subject: [PATCH v6 09/10] x86/kexec/64: Support kexec under SEV-ES with AP Jump Table Blob
Date: Mon, 10 Jun 2024 12:21:12 +0200
Message-Id: <20240610102113.20969-10-vsntk18@gmail.com>
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

When the AP jump table blob is installed the kernel can hand over the
APs from the old to the new kernel. Enable kexec when the AP jump
table blob has been installed.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/include/asm/sev.h         |  2 ++
 arch/x86/kernel/machine_kexec_64.c |  3 ++-
 arch/x86/kernel/sev.c              | 15 +++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 6f681ced6594..e557eadb0ec9 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -233,6 +233,7 @@ u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
 void sev_es_stop_this_cpu(void);
+bool sev_kexec_supported(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -263,6 +264,7 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
 static inline void sev_es_stop_this_cpu(void) { }
+static inline bool sev_kexec_supported(void) { return true; }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 1dfb47df5c01..43f5f7e48cbc 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -28,6 +28,7 @@
 #include <asm/setup.h>
 #include <asm/set_memory.h>
 #include <asm/cpu.h>
+#include <asm/sev.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -269,7 +270,7 @@ static void load_segments(void)
 
 static bool machine_kexec_supported(void)
 {
-	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+	if (!sev_kexec_supported())
 		return false;
 
 	return true;
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 30ede17b5a04..e64320507da2 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1463,6 +1463,21 @@ static void __init sev_es_setup_play_dead(void)
 static inline void sev_es_setup_play_dead(void) { }
 #endif
 
+bool sev_kexec_supported(void)
+{
+	if (!cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		return true;
+
+	/*
+	 * KEXEC with SEV-ES and more than one CPU is only supported
+	 * when the AP jump table is installed.
+	 */
+	if (num_possible_cpus() > 1)
+		return sev_ap_jumptable_blob_installed;
+	else
+		return true;
+}
+
 static void __init alloc_runtime_data(int cpu)
 {
 	struct sev_es_runtime_data *data;
-- 
2.34.1


