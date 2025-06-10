Return-Path: <kvm+bounces-48878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0FAAAD4357
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2DF23A506E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE48266EEA;
	Tue, 10 Jun 2025 19:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LyN3NoFS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A80266B72
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585281; cv=none; b=WY+ZIktH+TPnE1LRRF5HU/DePmaqnvkMLUWeVaw+pVbSv6tT9Lu8u4Yt8mAU7x3n0fQMNUIkP0J6GnCjKLHGTo9CU2bbqdaYD5SR6YDWejrS54AgEs0lXWb9xbLIF2n8JUnveYlGrqMqnkJZZz1D4iE+1LH58oQ+NKxLr9cMsJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585281; c=relaxed/simple;
	bh=SpGutdmzHKQQW291FPBA6pFXLatmk5gn5cs6y320m4Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KVXVaA4HarKVpcxy752pI/9lHavcXugMjCO+bT6izUSWxN5qETQuniKQJ1G3ln9/gj3bfJOu6acnJPSrIDicPRpXy4aN0qkF7b1dK6RVJlVIFw8q91KkC2MwUPkIUI1zw4fyptCME+L4yEIJju5hU1oFkWXEVeZbkJM4K6pt0kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LyN3NoFS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23507382e64so56463305ad.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585279; x=1750190079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YPdv/KvzWw74fBe0CVq7ACg2uBJ3cXAyZPQhrh+QOes=;
        b=LyN3NoFSLB7SBG4t0AvJuv3/NlYHo5LCQNPVcfS3DFPSFQx1+FsN3HmPKqFLEHrGy5
         h5v6TLjGXT6Sdx4C5OagIqC0+zXyICp0sghH52bacw+tYXfSE+IaAEHjmREX4JKwaoJl
         cDOIbhgfycoa39KvBHEhMLzud8drZHIjTwN51jkLI3FrhgH9nw5xldEdOc2JGiTnN/Gt
         rNsyCim0QiDzepEEcbd5YbAS3leYWa6z+Gkq/IvxNDpNfivxXMe1etb+o1wr6YKsDfYv
         dLFey2teNx3mWaAnHU4ZR05tFhIOovjwBw+3YrFA2fEvnU824KHsLWML+7nDwG7u5PV1
         va1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585279; x=1750190079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YPdv/KvzWw74fBe0CVq7ACg2uBJ3cXAyZPQhrh+QOes=;
        b=R7Mcn069qqH0SUWHttxQMenC10h84LfOs3LMH68HMGM8AUBZn9U77tMvEvpZAykfwf
         tNhijbhZT8InvNW6cbvLb2qjadEsT0ODNnneA8/vBpwJaPpZtrpXqZbwOLYSnzJmUlSy
         R0wVheu5lGrv2IdEFbNAAkxYgKAWGgS+GmusWQT+Aj8L77fyCyc/bD64zkh5i61nlv6S
         thKhAttVNCnel1zQQGygQ98yc25kXT+AE6YUGC0NE3n8n+ojjPL7Md0oI1mXUYH3wq05
         oXdzwcAB6GlZpxhr4KZgiUqqAY04PWm+uoO6ADUald4TDmrNmv1a3KvvZxm0ltVqbehJ
         gJaQ==
X-Gm-Message-State: AOJu0Yy3oS9jWXgyDTdkRyZLcsb5CvQKLSx3BKY0/J2GTgS4Hr0e1iYn
	7XYqae1a7KhYmhVbSsM2bUhP/1cnCluSkhKyUSwS46Xebmnx7b94B8KT2ib8w1CWFAqwW3JEzKc
	jEqQhqg==
X-Google-Smtp-Source: AGHT+IGIjNhhsg6s5O66gbjRRDP+6F38KTKyRf7jeZDRS1zBUc19y3f+VZvEC2AREojjBoU1VbXssNQ3Ds0=
X-Received: from plhl7.prod.google.com ([2002:a17:903:1207:b0:21f:4f0a:c7e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b47:b0:234:b735:dca8
 with SMTP id d9443c01a7336-23641a8ab7emr5563325ad.6.1749585279065; Tue, 10
 Jun 2025 12:54:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:13 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-13-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 12/14] x86/sev: Use X86_PROPERTY_SEV_C_BIT
 to get the AMD SEV C-bit location
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Use X86_PROPERTY_SEV_C_BIT instead of open coding equivalent functionality,
and delete the overly-verbose CPUID_FN_ENCRYPT_MEM_CAPAB macro.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/amd_sev.c | 10 +---------
 lib/x86/amd_sev.h |  6 ------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index b7cefd0f..da0e2077 100644
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
2.50.0.rc0.642.g800a2b2222-goog


