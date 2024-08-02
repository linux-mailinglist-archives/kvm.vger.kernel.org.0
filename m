Return-Path: <kvm+bounces-23144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F5E946490
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 963681C21634
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F936132106;
	Fri,  2 Aug 2024 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vTmrSSg2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1287078C88
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631520; cv=none; b=lt3UZpiGY3DKIIvfkOKpB/dCCiMvBPvLV6m1yCapcrSrPh6aLSAN8dchSFMTI6fgpJnhn3Q+KiD6RvYU2R3f2gM43MK2LgsyTrNxWD3c8WSc4PSKNrcWibZM3uL4m20j5hWygYhAhLAR2p2EA22Yw/jTNH81QxPuyRVHCmJkO3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631520; c=relaxed/simple;
	bh=cEmBxHf9lxfhKNujzAja0PlMob6xSKDSsBphNmFY1I8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VW6nvnocus4Nz/vD8JKtrLW5hoc1inXKUyH8fPSgprvwKSPS04bdicb79BCeNVInmhxtpfTYEXir0PxThtOZzGQZvTCzeqEQ0GH7hsk6KgdONOSgi6lLJsqcGZMThrfZyOxGGS7n3LauPRjZNmQBP5A4lM2UBY/VQvgQHuulxAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vTmrSSg2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc52d8bf24so39515725ad.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722631518; x=1723236318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ef/zFHnzH9ziD4r800QDczQlgiF3jMvJYDOovUok0uI=;
        b=vTmrSSg25bm4QZoascZIVHbSyDjR61ae2uHC0PRVm6F2TkQR8jnPLOS6KPclk0tNJP
         NLKcizkkCgFVyTtxzUTlbbUU/pT0ZDJmN7EWe+GcZLr2m+JiGf11MEzw6bd5I07RBXD0
         Bd0+ENeWfucRvzF90Dk5inUm9mxz5Lta39y0atd3UfndejQOS164rwUKW38kqTLb2YVj
         K6vK34xrdNzMkukJiL5W1IvSuAWjYsLwbbzE4lyK+gQcIoGE4R3ogHKhx1KDtI1CSHi5
         gGXar3pYueGE44onnV/yhtyW3WfKOcgDZJ+bNmtFHtcFWghcUpqB5VAf/I8wpnuT/Jvr
         ZvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722631518; x=1723236318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ef/zFHnzH9ziD4r800QDczQlgiF3jMvJYDOovUok0uI=;
        b=M+UM15iMpMPlyIzhub8gP8AfOQkBsYCmNDiXIAHJDmm6fpOuyvtaaToTF/GN/9Zy22
         t3MqZYlXUUbgrzSg4sXD3KEZbslZ0o167Jt0YGyGFMzUm00cHvhvDOLW0fQgrS8ZW0i5
         7wFmLcr1dmKBvzzuEtr4ewqFTeSzlHCErXSpNagfr2rliXHjFju1R0vI3E83Xr5q7+wu
         q03jaooiHF6tQVCTZSiWTNwkAQBuGedZ5lVaVS6QqhbG8dcoM2+SUpSpp6gil41dS58I
         efSY/1UQAsD57LZyfn5UZIkKR6zQhYB/pGV/UU/Vd1Uw/yK1On3thfuSuX+LvyhqdLXh
         803g==
X-Gm-Message-State: AOJu0YzgKbJ8WzMbD8jErrVQ32FZUxkRAy+i2et2DEP9aOi6KSyOIriq
	RLCOnVxg0pBpYQZU0HDxh+c825N56fn5gNYSHMYaVa5ANoD8HBBY/1l0cgEDEY5gc/G1phZwA2e
	Ueg==
X-Google-Smtp-Source: AGHT+IGUaCH5GW1GuzLfD6kYR2Ssu+ja9saSMgach2eDhR8Bt+zw4+jG2/PGa+s1mkXBM9gh1y7A6UyHYEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac5:b0:1f7:516:4235 with SMTP id
 d9443c01a7336-1ff57bed391mr2256355ad.6.1722631518251; Fri, 02 Aug 2024
 13:45:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:45:10 -0700
In-Reply-To: <20240802204511.352017-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802204511.352017-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802204511.352017-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: SVM: Add host SEV-ES save area structure into VMCB
 via a union
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Incorporate the _host_ SEV-ES save area into the VMCB as a union with the
legacy save area.  The SEV-ES variant used to save/load host state is
larger than the legacy save area, but resides at the same offset.  Prefix
the field with "host" to make it as obvious as possible that the SEV-ES
variant in the VMCB is only ever used for host state.  Guest state for
SEV-ES VMs is stored in a completely separate page (VMSA), albeit with
the same layout as the host state.

Add a compile-time assert to ensure the VMCB layout is correct, i.e. that
KVM's layout matches the architectural definitions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..2b59b9951c90 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -516,6 +516,20 @@ struct ghcb {
 	u32 ghcb_usage;
 } __packed;
 
+struct vmcb {
+	struct vmcb_control_area control;
+	union {
+		struct vmcb_save_area save;
+
+		/*
+		 * For SEV-ES VMs, the save area in the VMCB is used only to
+		 * save/load host state.  Guest state resides in a separate
+		 * page, the aptly named VM Save Area (VMSA), that is encrypted
+		 * with the guest's private key.
+		 */
+		struct sev_es_save_area host_sev_es_save;
+	};
+} __packed;
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		744
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
@@ -532,6 +546,7 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_ON(sizeof(struct ghcb_save_area)	!= EXPECTED_GHCB_SAVE_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct sev_es_save_area)	!= EXPECTED_SEV_ES_SAVE_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct vmcb_control_area)	!= EXPECTED_VMCB_CONTROL_AREA_SIZE);
+	BUILD_BUG_ON(offsetof(struct vmcb, save)	!= EXPECTED_VMCB_CONTROL_AREA_SIZE);
 	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
 
 	/* Check offsets of reserved fields */
@@ -568,11 +583,6 @@ static inline void __unused_size_checks(void)
 	BUILD_BUG_RESERVED_OFFSET(ghcb, 0xff0);
 }
 
-struct vmcb {
-	struct vmcb_control_area control;
-	struct vmcb_save_area save;
-} __packed;
-
 #define SVM_CPUID_FUNC 0x8000000a
 
 #define SVM_SELECTOR_S_SHIFT 4
-- 
2.46.0.rc2.264.g509ed76dc8-goog


