Return-Path: <kvm+bounces-13861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C8389B8D2
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2381C220EC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BD94F1E4;
	Mon,  8 Apr 2024 07:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QI+1jMXt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA824CDEB;
	Mon,  8 Apr 2024 07:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562084; cv=none; b=AHWAoeyQctD33MMLSgnfKufOw3/q8n8TzRKb69Owij5mTjIRFvZJ+2wLmrecvTDfSWwEDcRt0ktfRJNHfcdtg1FxO846lOiiR6kwujBf/gdzw29ow06KtunJP5ewhZPIG+GXJYQFzL9XRbJVQilz+o03VyIlF6lFhWvJ7xOXPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562084; c=relaxed/simple;
	bh=nraWtElHPDcy4J/h0QtFNZ3iGaE/9eKaPhhvDhuTS7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rtp+XXSgKdpxWm1FBW264DLZGx/7rfYWXxBj2Oyyl2Nfst1Jh2wX28c+m1+0JriFv40E2ACXgHcLjKy3mbXfJeUEG9gSiYVcJavh9XILZc1ttlmN8SAZ8QPZaKGO4lr6nyxpvcJdvvKj0N3yxwtStfz3TPr1sp6ZR1LaK0ZVirc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QI+1jMXt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-343eb6cc46bso1779572f8f.2;
        Mon, 08 Apr 2024 00:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562082; x=1713166882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vffWxrDfGUfj6Dj40L1W41htTqoat8lNT1P/loOuIyQ=;
        b=QI+1jMXtrOyg9JVBH2Cr6J/COjhVfEtrHoh9D42fi+GJdTGLWU8G1HrxAmlkCJOIFH
         n6i4/3O4CIDYHW0EJdJy/eFAxxHkxuEsP35TYkc14sgH86e6nSs78jMc6Fx3dHDRKEKU
         3EeAhZv7F6RVEY6Aw6Altc4a6Oa/hSVENdtlymy1WSJ1XaG559wvQ7sD2Lm7xIYR0M1x
         QZJDiON87uPXpA/5FS+eYAM1lON2G1IkXyXjZYgBKOuJnNrVUCSfBTY2rTcW2kRlDNEn
         0QkJzK7UALm4SA1Tn0pi7eyWV3JhoOmZFYJYsTUvnw2a9vfm6hH55WauXor6EOlCr+l+
         WJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562082; x=1713166882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vffWxrDfGUfj6Dj40L1W41htTqoat8lNT1P/loOuIyQ=;
        b=u9zbfX6TD8Qd9GuCZTgDbrWUIKJTQIBEgJ7nH2cvfGgMUdQplj340sY2ZJlTMy4OpN
         g2oZYa9shimwebPhyb+I8R/WBQtrAVXdVmIL4JDsYy//Kv+CuAXQDf4EAfb0KL9pEDMM
         Oj2vdc0/OwQqjzW/LbSOzxfR/stnYOlTnaY1VerxVuEeq48xq7M1HdzXr5dngncpXF+d
         EjzS7YsdlqUyu6MkOkRSo4k/dT0s2NWCfZ+ybkuHVLgBv/t3N+ljqK0wSw2IOWJaURcc
         qIoFuKofjl/RH9HkyyYsmgAAeNYEjId/BUY0qqLc0NAwZDNczC/5PX5XCUl4EOChQS99
         9iyA==
X-Forwarded-Encrypted: i=1; AJvYcCUlu4fKySxUn9i2OqnbXHK3YSd0jIWC7qDrdGGStmPHHIlS4FllXIU6eoKDdl5ak0zzsnp/LFs6HdyEtHKZXQE0O8t/4kX9wYCP1W1lSY6Pl8V6ippgWLIiQlYaMpwqPH/aUPjiVaa1+uTDTgmf3ykD1cqc11jF1fG6
X-Gm-Message-State: AOJu0Yxs4GCzCHHOpigPicUSMkhldcxsl53HkkLmxFP1cU9JHnt5sQXy
	+arpeWUjFyHvMUbU+iv2UYagqjSb/ZxOeEcE8cIGm473/sSZC4Q+
X-Google-Smtp-Source: AGHT+IFJ4+QJwRhaWOkJ+xi/SDRYHJSS+dNKUjJlrOrr+g4LrjWQZtOQ6FOdPmbvQsUHzg88XvrMoA==
X-Received: by 2002:a5d:64a2:0:b0:345:b238:534d with SMTP id m2-20020a5d64a2000000b00345b238534dmr1768262wrp.28.1712562081667;
        Mon, 08 Apr 2024 00:41:21 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:20 -0700 (PDT)
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
Subject: [PATCH v5 10/10] x86/sev: Exclude AP jump table related code for SEV-SNP guests
Date: Mon,  8 Apr 2024 09:40:49 +0200
Message-Id: <20240408074049.7049-11-vsntk18@gmail.com>
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
index aa53e8eb4cd5..d915d9158926 100644
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


