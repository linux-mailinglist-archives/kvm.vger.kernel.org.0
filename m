Return-Path: <kvm+bounces-48880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC59BAD435A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 916B37AB2DF
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B032676C5;
	Tue, 10 Jun 2025 19:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TK53zCxf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1548F266594
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585284; cv=none; b=GyLtYJrdAxTP9wMWrhxXP3BapHs9f56ARFoKyl9MVjkK9Yp5b+SdpQ3QdAMr7cbPsNrorA0kTcptmayEiYr+JWVCr/3a3MzGDm70rEAp7aLWRy2RJqLri84+F4lDrhjUYeJP69ZWtArNZkBiFBPIDYGrcU4cRHuG/Rnv/Hd1i2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585284; c=relaxed/simple;
	bh=JUdbFincw/xSFLhr2cZgOsjRhZcKlHe92dth+Y3FPjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g/UTtO8P36UF08lMycSvwyO9NyfMe2oYpn8V8L5K3SFAZWuqu7x8JJOquwXtb8s2bOqnGj6q2jvMjUzpWzWa9Fir/9Ans1NBQ/wu4IRhe4Yft9JtGKCOv7NaDRe22ZArkvNwmia3fYeiK9l6UcCj2XCmlY7jPsr+mbMJalmLBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TK53zCxf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2350804a43eso92222355ad.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585282; x=1750190082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LObukk/N1dOKPEmdo+cGzt6O2JhGXqBfSDRNUdi9VGc=;
        b=TK53zCxfDm+56nydQi1C8SzTaebnrZgQVOPijOqjDOE7AMd9SEBfkdkuslj7IADDgP
         0nJ1dD035zOpk9f/ghrsjtzvbNVrZoOr+vhpj0M6o4evSayfJoQNM/La8XWIqPXcPoey
         RMs3Ey9jw7m7df8nOpqlBZ7I9WFyawq7cHlrK4by1fBFPfwRG5Azcl9GmEa8MI0oBRFl
         z4lOZ2mf+cGnuhT895/hrnfpXqTIOErJ8S9h9+zz+Wk418WNiE53rvgDtcyE30Dq7wBS
         kN/lbVmNiaxYHCenkyH8YUMEMcotlZb9nv+4wwffRmIozV9fFo5iFFJrXbtUsJgi+47B
         owGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585282; x=1750190082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LObukk/N1dOKPEmdo+cGzt6O2JhGXqBfSDRNUdi9VGc=;
        b=J03BgKfQUQO6aykvDIBMvKukBZjjj/AszKYqqQXC+1+pEe8mqsNFTYuxX6tAvRh4MR
         3ZJk7aJCBcGL1QPNTwnnxGci58DcldtVaTodrblwPQMDWtWpPSa+0xxTJ0Go570CaFeV
         YB+IB4BjeM7+FLL+NgVrVbwbW5Y/9GYvAnIJB5OkqDZMwRwTsbJMr0FIX35ISpPj3Zvh
         OFdBxT4OShVXRM+xqv6sGh4ll/CdQYUnt4sugrxoNOEoJc+/jFtrWXL4J5vnJPGqMz8f
         3uU+k+28Vql3UubMwtc0xmpSoYy6BCrKH6ZEcjtBIGPYaSF9JHeo4Am5oDcdPvVViLCR
         ulnw==
X-Gm-Message-State: AOJu0YzQVUFit50iro0K/TTNtCz6ADUHfhyuz2R2CfyZTqaH6VbeGndJ
	ZOJmZaGoyEcGGBsaM/X5XV/GLQTyzctWf3QLY6iCwE6DhdAsRlMq89pb1KUXo6tG/bImKctPUyK
	eypxE9g==
X-Google-Smtp-Source: AGHT+IG8uVrglFN28xA/oIdsp3QBQSUcdYx8Agri4sNZHXcKDKakCYg/RUSIBPFoLjRh20FImQUYV0C/gR0=
X-Received: from pghf16.prod.google.com ([2002:a63:e310:0:b0:b2e:c15e:3eb7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4c1:b0:235:e1d6:4e29
 with SMTP id d9443c01a7336-23641b14d6dmr7413505ad.36.1749585282392; Tue, 10
 Jun 2025 12:54:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:15 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-15-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 14/14] x86: Move SEV MSR definitions to msr.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Move the SEV MSR definitions to msr.h so that they're available for non-EFI
builds.  There is nothing EFI specific about the architectural definitions.

Opportunistically massage the names to align with existing style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/amd_sev.c |  6 +++---
 lib/x86/amd_sev.h | 14 --------------
 lib/x86/msr.h     |  6 ++++++
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index da0e2077..7c6d2804 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -25,7 +25,7 @@ bool amd_sev_enabled(void)
 		initialized = true;
 
 		sev_enabled = this_cpu_has(X86_FEATURE_SEV) &&
-			      rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK;
+			      rdmsr(MSR_SEV_STATUS) & SEV_STATUS_SEV_ENABLED;
 	}
 
 	return sev_enabled;
@@ -52,7 +52,7 @@ bool amd_sev_es_enabled(void)
 
 		sev_es_enabled = amd_sev_enabled() &&
 				 this_cpu_has(X86_FEATURE_SEV_ES) &&
-				 rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK;
+				 rdmsr(MSR_SEV_STATUS) & SEV_STATUS_SEV_ES_ENABLED;
 	}
 
 	return sev_es_enabled;
@@ -100,7 +100,7 @@ void setup_ghcb_pte(pgd_t *page_table)
 	pteval_t *pte;
 
 	/* Read the current GHCB page addr */
-	ghcb_addr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+	ghcb_addr = rdmsr(MSR_SEV_ES_GHCB);
 
 	/* Search Level 1 page table entry for GHCB page */
 	pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index daa33a05..9d587e2d 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -19,23 +19,9 @@
 #include "asm/page.h"
 #include "efi.h"
 
-/*
- * AMD Programmer's Manual Volume 2
- *   - Section "SEV_STATUS MSR"
- */
-#define MSR_SEV_STATUS      0xc0010131
-#define SEV_ENABLED_MASK    0b1
-#define SEV_ES_ENABLED_MASK 0b10
-
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
-/*
- * AMD Programmer's Manual Volume 2
- *   - Section "GHCB"
- */
-#define SEV_ES_GHCB_MSR_INDEX 0xc0010130
-
 bool amd_sev_es_enabled(void);
 efi_status_t setup_amd_sev_es(void);
 void setup_ghcb_pte(pgd_t *page_table);
diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 658d237f..ccfd6bdd 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -523,4 +523,10 @@
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
+#define MSR_SEV_STATUS			0xc0010131
+#define SEV_STATUS_SEV_ENABLED		BIT(0)
+#define SEV_STATUS_SEV_ES_ENABLED	BIT(1)
+
+#define MSR_SEV_ES_GHCB			0xc0010130
+
 #endif /* _X86_MSR_H_ */
-- 
2.50.0.rc0.642.g800a2b2222-goog


