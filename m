Return-Path: <kvm+bounces-48027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4765EAC841A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 850A23BB7BD
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB58257AC8;
	Thu, 29 May 2025 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c2r34V9F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E2821FF51
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557207; cv=none; b=embVcqPBkMKuu0RuQ2T0dHN4Zl877rhFVr44W7dV9bs0m7s/o2TplxOamCLD0CeBk8fQPcyNHSvlOg7AZSeBrLpVo6VC6vN/Vh6PsCF0XqbBoE9wDiQZ2FnyR3BtthhEEOlxgXstr3xf67VrtqJgXiwbvk5LE1LULfZCbDfRZrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557207; c=relaxed/simple;
	bh=N1v0QBW6sWv8xJLTlXamHU232j36EJj1wLeqdROIkTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ddapNrfiDud4/Lt1abnTFZKBgJ12cDx8PwhR/yhsi4qTZvZzabw0aLjk3tbVZK8Ab+4Os+FZKWcY4Knk4+okFAFvlf8CaLvTPIauMXj7FF02/xK5L3Uc8MNvBI0phfwDCogz7LgAo/8VmtVOMQcDNiRRXtD0tJflKq7d0EhmmGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c2r34V9F; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115383fcecso930822a12.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557204; x=1749162004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kksiwJTfpDAL7uAGNPhMF+vj8FOLnKEunyqXmWg1154=;
        b=c2r34V9FdwhPiZWiqfUI07z2Sq9IdIn0x1Ks31T5SlxF2+/00S6+pzeZ7RzpGK3Nul
         Lk1W5eBC0u+y89f+qgbPu/et20rHSAtFXgQMdlxmYfI35EJWEdxnEYeBMnBP/iEEWvpV
         78e4uU3+UzSKNPfUKDH0XertmsZlNCVQVdOLacgRwIWGqaQww5lDPwMnOUZDujfSI1yq
         FbCWmoFqN2SeMZYhcURVigVypbZ746C+is23gFpgUlKiK4hRzfRnzWCpAhCVV77vPk3q
         uDxYevoDzUcrHmgwnj7EIeBXa7kVOpoB3sb9BGYTJDQgvl/GTgyqJVw6oL2YsSj0t6Ug
         4aYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557204; x=1749162004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kksiwJTfpDAL7uAGNPhMF+vj8FOLnKEunyqXmWg1154=;
        b=p3KYaMZlkRFuEhi3KZJCQaSD/8ULhZesEvg77D0ha+Yg4fMwDJryaurqU/gSc29dEX
         HdvfE0blrwVb+VbXFdhA+xC9eL2NK9X0ucbHcEJdIYV/pS1bnACZaOtj0bynCsCkTVou
         0VPZQ8iN1htarY1tQKmP5HOsEQWBZZ/ZPxKyXwtfTn2a8UMLFeUv0p1ys8oosKQ9rz0+
         fsbQ5RELum1JxgZOWb5zSup0q6SBpZApcKKpu0KUBglfKDi+5OHMUb21TGAMfBEaYiLL
         TCf5GRqOl2Tg85/aaKjHckjxWqOwGn0vi5bmRQX+kp3TyqjrcuHdS4xJoKlRGYcthGmM
         FJ6A==
X-Forwarded-Encrypted: i=1; AJvYcCXrA8yb4gOaa3YAho0My/VNmT5QNHC0Nl/X43I9410lI+pRi8XsWC434QJxg0yl5NUP1+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6dT2oxE/FClChYRF/iFsKonuk21AG3RU9nmN7Tg/00hazXYNB
	wtA/caPhFAVg+E9F6Rh4yv3mOJF1Tv+sgoK3BQJB9KO80QbrsoSkvv9dCyhj5N260SEsAdjldwn
	7KNAdaQ==
X-Google-Smtp-Source: AGHT+IHKKaHBRgZknqdVQGWWJiAz+zFT83aijCtSw3EwCIuFxlNev961CCgZ20g1aw/1KKs9yzGP7rIiVy0=
X-Received: from pjbcz13.prod.google.com ([2002:a17:90a:d44d:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:47:b0:30e:6a9d:d787
 with SMTP id 98e67ed59e1d1-31241532ec2mr2010769a91.11.1748557204407; Thu, 29
 May 2025 15:20:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:27 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-15-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 14/16] x86/sev: Use X86_PROPERTY_SEV_C_BIT to
 get the AMD SEV C-bit location
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use X86_PROPERTY_SEV_C_BIT instead of open coding equivalent functionality,
and delete the overly-verbose CPUID_FN_ENCRYPT_MEM_CAPAB macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/amd_sev.c | 10 +---------
 lib/x86/amd_sev.h |  6 ------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 4e89c84c..416e4423 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -33,19 +33,11 @@ bool amd_sev_enabled(void)
 
 efi_status_t setup_amd_sev(void)
 {
-	struct cpuid cpuid_out;
-
 	if (!amd_sev_enabled()) {
 		return EFI_UNSUPPORTED;
 	}
 
-	/*
-	 * Extract C-Bit position from ebx[5:0]
-	 * AMD64 Architecture Programmer's Manual Volume 3
-	 *   - Section " Function 8000_001Fh - Encrypted Memory Capabilities"
-	 */
-	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
-	amd_sev_c_bit_pos = (unsigned short)(cpuid_out.b & 0x3f);
+	amd_sev_c_bit_pos = this_cpu_property(X86_PROPERTY_SEV_C_BIT);
 
 	return EFI_SUCCESS;
 }
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index defcda75..daa33a05 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -19,12 +19,6 @@
 #include "asm/page.h"
 #include "efi.h"
 
-/*
- * AMD Programmer's Manual Volume 3
- *   - Section "Function 8000_001Fh - Encrypted Memory Capabilities"
- */
-#define CPUID_FN_ENCRYPT_MEM_CAPAB    0x8000001f
-
 /*
  * AMD Programmer's Manual Volume 2
  *   - Section "SEV_STATUS MSR"
-- 
2.49.0.1204.g71687c7c1d-goog


