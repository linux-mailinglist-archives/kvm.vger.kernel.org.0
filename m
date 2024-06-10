Return-Path: <kvm+bounces-19175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4BD901F4F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 579AC1F25CFC
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4E9135A6D;
	Mon, 10 Jun 2024 10:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PtcCYO4E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C312FB0A;
	Mon, 10 Jun 2024 10:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014907; cv=none; b=V2+snEMEOf+QJOMy40R0vktWKbkGYhj7kyTc07/Z7Uns8miy9nQsFlciBF/0skKUuhH5kRJHTFgVu5T4ZbSfiTZhpssPEWPOe+iONz4lun301+4ASjNst5AnkqG7pPm2p6w3zN1YeKlruOwXSIQU8vhmuOcF/J/A8aIeIVdKkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014907; c=relaxed/simple;
	bh=RIX6F02RU57kcYISt2QqN6Kv/cJq5+UN3QzaEDCLbYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S6IBigkLXIDRraz8NAgDbZBOWPzhOUegAMKoiXPM+z3Ie5xz0U95PIvyW1MWZHGMKAgXMnFnSf1knwJw4trnLuITYIvvYsPWOvMfbSyPigqHUoT2JNUzN56AH+u3xEP6anUQP0fh5BerIxwe5j40oTd41LO4FRwrCam+kUwRavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PtcCYO4E; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a6f0c3d0792so191413866b.3;
        Mon, 10 Jun 2024 03:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014904; x=1718619704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdG6ACuG1uJUkfwp3EsaLBLMvj3TgqNuoQIAGjhnFXs=;
        b=PtcCYO4E5qVr/55vk4mEM80EOOUOHJWuWDQ6yFxHyDSPZITU9ZFedGSLjqBxqCfgCS
         AfEzc3yEEoiHNikjA1Cv3LvIJbe/Fh8BrCph1rMJytb/QzITmsKUhoyIL1z8G3ZVFj2Q
         6BsF68EjFXF8hKd53Xq7CEhLSOG6/Gk5iCYPm5mpR30PUmNqqAdHmHzauJSsj/t1amu3
         Gy4Jd+7BJO5zINNWcMaE+ausldwsJCPZxp3jGlgpuM6OIXDZyE9TzdXxwwXUqjhgoLcf
         WTmct101ZIBCRBU45qBnLArMwPl1rECxpKwVotyuj2VsVLR396CQ+JeHC2R6eCQzOfMi
         X7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014904; x=1718619704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BdG6ACuG1uJUkfwp3EsaLBLMvj3TgqNuoQIAGjhnFXs=;
        b=wrcr7Dkwovy2mHE5+81jKZ2ilUnCYhcy6UJGLbj30If1Z73+6jWYmFlgoczg3LBov7
         pAcGLjYxUDHIccC6V7f9LBRwl99MfB4rdnct8Hu12ZUmi7jXI9pVo4q8E/l1U+b32gY8
         fQqWj9fmjMpgiwjJVV663G+7RlmaSefIMODpPDl/3IJSJT5ndjkQ7MDVh+a59Hy7hNX5
         Tk0KOXymk1aCb3YhsQCuE2otsF/akKdNBbE0KXV7LNPVt290beZr0UZAJXyZr0KIC7L2
         aO9zM8+f9MpiU9fhw/ZOtGKLO9hhzWWn81pOp6kHpiSfpTypeoEFptEMRZzrKv6PbdZf
         s/hw==
X-Forwarded-Encrypted: i=1; AJvYcCVpH3jNIdSWOBupU4n2Ovu5dHSyP4/drR2RsKWvHiiMPZfa8Y81SUDsQUiXSNxakjOj2G4VH4pbelVucTI9eQhKrqbMrW2tHEpdVLejJsggln9f6ZqqDXqfT/etRESt0+maN3atBrgd90iWWYSdUZIB3Ej5V6mTkfSG
X-Gm-Message-State: AOJu0YzX+z/SLhblB9ZaJG0q64COIBHGPlrS9uDAwKHgFM9pgqLmH9qq
	Ibujj8PjzYhSZfe76s/xpws/BRpg86nKKYmEgZ0dbhPXOoDU2pek
X-Google-Smtp-Source: AGHT+IG+5xSdjmTwqQbKCwcV+YEwd87sFYBvU+bVS0NNITGRecW7wGay6Ao5a2CebEX1GwPUmPMrcw==
X-Received: by 2002:a17:907:9486:b0:a6f:1798:bf80 with SMTP id a640c23a62f3a-a6f1798bfabmr270645066b.52.1718014904098;
        Mon, 10 Jun 2024 03:21:44 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:43 -0700 (PDT)
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
Subject: [PATCH v6 10/10] x86/sev: Exclude AP jump table related code for SEV-SNP guests
Date: Mon, 10 Jun 2024 12:21:13 +0200
Message-Id: <20240610102113.20969-11-vsntk18@gmail.com>
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

From: Vasant Karasulli <vkarasulli@suse.de>

Unlike SEV-ES, AP jump table technique is not used in SEV-SNP
when transitioning from one layer of code to another
(e.g. when going from UEFI to the OS).

Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/kernel/sev.c    | 6 +++++-
 arch/x86/realmode/init.c | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index e64320507da2..a9cf74512269 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1392,7 +1392,8 @@ STACK_FRAME_NON_STANDARD(sev_jumptable_ap_park);
 void sev_es_stop_this_cpu(void)
 {
 	if (!(cc_vendor == CC_VENDOR_AMD) ||
-	    !cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+	    !cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) ||
+	     cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return;
 
 	/* Only park in the AP jump table when the code has been installed */
@@ -1468,6 +1469,9 @@ bool sev_kexec_supported(void)
 	if (!cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
 		return true;
 
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+		return false;
+
 	/*
 	 * KEXEC with SEV-ES and more than one CPU is only supported
 	 * when the AP jump table is installed.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index f9bc444a3064..ed798939be5d 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -80,8 +80,9 @@ static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
 		 */
 		th->start = (u64) secondary_startup_64_no_verify;
 
-		if (sev_es_setup_ap_jump_table(real_mode_header))
-			panic("Failed to get/update SEV-ES AP Jump Table");
+		if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+			if (sev_es_setup_ap_jump_table(real_mode_header))
+				panic("Failed to get/update SEV-ES AP Jump Table");
 	}
 #endif
 }
-- 
2.34.1


