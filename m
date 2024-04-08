Return-Path: <kvm+bounces-13860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 006E989B8CE
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35E8CB230C3
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C9C4E1AD;
	Mon,  8 Apr 2024 07:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ToG8zNHV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381724A9B0;
	Mon,  8 Apr 2024 07:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562083; cv=none; b=mhueOknTdigChUZ3dwyaBfhWk0luwLlLay54h5wFs7FsJCE2lFzCE4uc1FptC0k0/K35j7dslSkGo98KMVc5hZYcqin0WXKBUvi5NLe6mruWFyeajc41ZnzxS7DwSb1EN9FbIqtDecgAAZeTNyPU6hOTUfanTqvcqagJkAcX1h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562083; c=relaxed/simple;
	bh=zYcb4/9WEShY0XRHnrQbKJ01pXJ2G8yIwcM+DsGPPXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AN1RQgoP6UPbvHwg6OxKgrn/rG8qnMTAIfAE8rf1XTNaf7OuwKMuMnv/bbvlpGHb8oww+bN2x3pQwJeqdB5lG3ESwcroWZMN55E2qPsxrjuuiWW7icHh7jkj4poXiwDF4EQ8EYB/7BL4neAIvgD7dFAqGo+0bK6Q6s1EdqTDZ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ToG8zNHV; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3454fbdd88aso1580057f8f.3;
        Mon, 08 Apr 2024 00:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562079; x=1713166879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PtkyqKxJvkp9IMsnHYE4l6zbbRyMrAgNbiaeWO9SXiI=;
        b=ToG8zNHVpGmjsJ7+ceD2NGlDa0LbkZ+18gyiE5ntMqf7B96nk6i7g/z8m8w43T9P9s
         Jii/D0CaIVspfziT6CCgL1TO+KVKqQ7eGk74KG9vIUxrYjdNGULdjx17SMk1XcMPe/0I
         pqEQvn0dwdUwFK3qjryljCpxGsdcqmk0yLobo+FJFVkzIlYgU6r+itl/DFKiTMPMxAWG
         C+ggI4EjjRTn5j3NZSmcbpmuIn4F1qw5stm88LTljDxVpzn5M/YIz/ICt+gxhtnrIG5I
         jRkV48Dq6o65vkVMwzw7iJGmzx+Np2Bqgh1jAlkY0qtHuRaKALCA1xijpxSCdds8oQei
         3j8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562079; x=1713166879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PtkyqKxJvkp9IMsnHYE4l6zbbRyMrAgNbiaeWO9SXiI=;
        b=iMkOVH47gAVOwpNAQENCyet0838hhfRQ7YDNwt36g76UZn3ocXG+kMIK57yCpb1ZHu
         3rxZ4FYf/8Q1qKdOVCHYZWq2gyCtQE7PAu6LGOga7r4kSR7DmFxu3M5MYiIZZ/9sXcrd
         9lI+sh4kQXx7hZ7RHJeO6079ukq+VKIT2Nv33DJ9UIJwApX8gAcWvQIidJvyTkpwJMa3
         1+l8N4eL8n3t8kYs/xeh9SsFLWHD5vqN7AbC5E2v31BVpv+o0BpgEJ3OzXgmbUpf6e7h
         agqb+Ld3b49eVtx6lB7wEVSJWptEf6BXqQlh7sg+jVp+0MuV929NJJTAp1mycZmKCJrs
         c5IA==
X-Forwarded-Encrypted: i=1; AJvYcCUtXTPtfn9bJxUBX2d/WS/T674Z96rz2OTgMNaIILm5lBqFCmt00ASLNyUKq+2UgIcwFUe6AB8p7Jbyuqu0fvqm/KMzxb6P8YnfYuLEfzhrNBMQAWn6MtW+Q9vAhYcIVCBC5fpY3QuFPfL9yB+RJ1HV2tx5avCROgvV
X-Gm-Message-State: AOJu0Yw6Iwpf+ePmmE56mIVgygQ0F4W8OYDOdWTGrF0O21IqD09StXmU
	m/NpXC8HSPr1rK1bYCK24aJo2XtpoaEpfzvHq4AAhfcaTIbV6oP4
X-Google-Smtp-Source: AGHT+IHCtTgtguJAV1/c4MkfZce3ouAm8nkkV1k3lPxle87h5W00nuVVJEZORfw/dl/4V3xbzdiheA==
X-Received: by 2002:a5d:5f46:0:b0:345:bcd4:bc99 with SMTP id cm6-20020a5d5f46000000b00345bcd4bc99mr1264651wrb.11.1712562079618;
        Mon, 08 Apr 2024 00:41:19 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:19 -0700 (PDT)
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
Subject: [PATCH v5 09/10] x86/kexec/64: Support kexec under SEV-ES with AP Jump Table Blob
Date: Mon,  8 Apr 2024 09:40:48 +0200
Message-Id: <20240408074049.7049-10-vsntk18@gmail.com>
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
index dba6cad1f7d3..9c773c272986 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -234,6 +234,7 @@ u64 sev_get_status(void);
 void kdump_sev_callback(void);
 void sev_show_status(void);
 void sev_es_stop_this_cpu(void);
+bool sev_kexec_supported(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -265,6 +266,7 @@ static inline u64 sev_get_status(void) { return 0; }
 static inline void kdump_sev_callback(void) { }
 static inline void sev_show_status(void) { }
 static inline void sev_es_stop_this_cpu(void) { }
+static inline bool sev_kexec_supported(void) { return true; }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4696e149d70d..558266d9bf1d 100644
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
index 36181bb26e25..aa53e8eb4cd5 100644
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


