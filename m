Return-Path: <kvm+bounces-42375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E69DA780C9
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58FD4188CD2B
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63D32147E8;
	Tue,  1 Apr 2025 16:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IB82jXoQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1C9213240
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525804; cv=none; b=acASuH3f8vTJxCSC2RmDONFtSXTN4MJpS/9k1yda5YhtxaP1eHfOVEMcNIa1Rj8M4cDjfz9KBMam7SNTrAmhpXUVPU7vjvZaEKl+yP8kRnXyHJTR07LCYsqjweD7PEybo0TDJagJHqA8m8pn6myT98FA+zkyOr7WQC+7XN7fDus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525804; c=relaxed/simple;
	bh=5iq6Ej0JukMZOt4v5A++8d64xSPyqQ5v5er7/1iuZW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MlHc9kPO/2rrtXvUKUAs6MjEhLqPojKSYKgaFbC4FqNM+o/GiEyQNKY9ryMnl9XV/w5QVHESQupr23sJEypre/dBb3kU873SnygG68yQgDgklZJgSAyVklfZziG2XQ3TcTtiszI2g2TCu5fhSjVsAQnCDJPgh50JP6J2jWad43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IB82jXoQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-223fd6e9408so20635ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743525802; x=1744130602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/XYYrhooXHNQcqBoobC7D5bK0XS2jFQGb7UC9bcI9h8=;
        b=IB82jXoQ/BkQnpCN7Rnwso7yq0sh9Olsv/ISZOjrxCNXY38HN21itGuR8GTyHGf5QT
         elKTjYZKc0bXe7hovNqFTEKchRz5UlBPzDilS+eSSz4Ek6pGZ+j8pDbPHD7rU/xm2IOp
         FfFptLjn4aizDgbDhMESnlL8jF+KDt0ecpZnxYvi9AzUzt1XMMX/5oSc/UHa2owTPg/g
         9jVjaJFdqd1DB7wZJHIg3/bY5u1INOUwXBLOlX+j7yuXxFNWOfK8uj53110xYeHxDJ+w
         iyv0WPoY+M0BnIZRVGN1LSrtD9FctfBHdKZXyOhcomhuWmiWK6wC7DhjuD5O94ELMmIY
         qjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743525802; x=1744130602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/XYYrhooXHNQcqBoobC7D5bK0XS2jFQGb7UC9bcI9h8=;
        b=U+61i11yK9yRJBHZolMyHwsH6sAw2wafLQ8zfOESyvXf3DPp0L45/zbg59PRhlOEQZ
         SnMURS/1at9KOMZfWsDSNfPWgV3p4r9K8cYIErFPwTRHhVQBNC6USFjjM9RSTXhO8KNv
         8o9IAW66roVBuo8s6LlvurZwO7eKSmkU1f/a3o6oqxGvhFS7GBc2ia5atWZwO7hrbgnv
         ETfisNv22T2kyMQAqY1x0EsiV9jE+5Oz/tEKsB9/0ytqbr+Bu3b0pZ4PxYmwMrg7FD9U
         ymJRE57GZnJWDnFLdaNdi6tF/nYldD6UQwYIt8dkh6OmtNSshNcG6hCFbW7KZ2EDp/Ua
         GY9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVBAJ65ATALeiG8KIwrudmE9RpXxEje5enqLZ7EjscmMP7xawPb01QIJextcgn3hONLQKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoyiIUvSkNAIkZ5X97HsbOoptLDubwumCCdN1956UKRu9/66fT
	vfx7kN5bG3uJxUiDWBcgpWEragdhuTOFccG/22KdbuXq9NWpn8XtEuwzOpBtJY8f4IW9dphMiwu
	Qfg==
X-Google-Smtp-Source: AGHT+IFy0IhgEaHcg00977nQlGMuEOMnb3oYwKlOFTc/u3M4G7iMNsSXATt5UTOpWjp44DoW3ZbtcVNrt4s=
X-Received: from pfbfo6.prod.google.com ([2002:a05:6a00:6006:b0:736:3cd5:ba36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8186:b0:736:b400:b58f
 with SMTP id d2e1a72fcca58-739c3f771bcmr873231b3a.0.1743525801845; Tue, 01
 Apr 2025 09:43:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:34:44 -0700
In-Reply-To: <20250401163447.846608-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401163447.846608-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401163447.846608-6-seanjc@google.com>
Subject: [PATCH v2 5/8] KVM: VMX: Process PIR using 64-bit accesses on 64-bit kernels
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Process the PIR at the natural kernel width, i.e. in 64-bit chunks on
64-bit kernels, so that the worst case of having a posted IRQ in each
chunk of the vIRR only requires 4 loads and xchgs from/to the PIR, not 8.

Deliberately use a "continue" to skip empty entries so that the code is a
carbon copy of handle_pending_pir(), in anticipation of deduplicating KVM
and posted MSI logic.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 893e7d06e0e6..e4f182ee9340 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -657,26 +657,32 @@ static u8 count_vectors(void *bitmap)
 
 bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 {
-	u32 *__pir = (void *)pir;
+	unsigned long pir_vals[NR_PIR_WORDS];
+	u32 *__pir = (void *)pir_vals;
 	u32 i, vec;
-	u32 pir_val, irr_val, prev_irr_val;
+	u32 irr_val, prev_irr_val;
 	int max_updated_irr;
 
 	max_updated_irr = -1;
 	*max_irr = -1;
 
+	for (i = 0; i < NR_PIR_WORDS; i++) {
+		pir_vals[i] = READ_ONCE(pir[i]);
+		if (!pir_vals[i])
+			continue;
+
+		pir_vals[i] = xchg(&pir[i], 0);
+	}
+
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
 		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
 
 		irr_val = READ_ONCE(*p_irr);
-		pir_val = READ_ONCE(__pir[i]);
-
-		if (pir_val) {
-			pir_val = xchg(&__pir[i], 0);
 
+		if (__pir[i]) {
 			prev_irr_val = irr_val;
 			do {
-				irr_val = prev_irr_val | pir_val;
+				irr_val = prev_irr_val | __pir[i];
 			} while (prev_irr_val != irr_val &&
 				 !try_cmpxchg(p_irr, &prev_irr_val, irr_val));
 
-- 
2.49.0.472.ge94155a9ec-goog


