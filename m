Return-Path: <kvm+bounces-38248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A3CA36AFE
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A513A3B1ED1
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AD21442F3;
	Sat, 15 Feb 2025 01:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jjVaYD2l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123777DA7F
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583024; cv=none; b=cE/8SDASEQ24JGrf77rycYFMwMEJY1iC7SybLr8PxwuSrPpWvFEHhjjvKHACMzhJpkmGFAjXV5fokrRQNvTa+Yz0Wl2EuL5KMp2TaNIRK1xZkxhS46wLzfkQyvQ9lGq7O4YGtMI/1dMC7e7lvG2e0WFgsiMgMQgZpcCKFMN0b5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583024; c=relaxed/simple;
	bh=RJ9S8m5S/5htwo+Mqn9g29LCmRU5ZxB1OpLhbILNGBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hObHuOUKyTXRYGvhQ79eeRxMOiqjfn3qobTX9oCyldHmjVhIt9sMbiPXI+Nj8Q0BHZdnw8RxgEi4NA7tH3xJJi9c1fabQQtw65oUoK7OqmygorFJMu81mMGqfmD88IMUPlfzTDUQ6HYOvsHYycT9mOBwi6VusxbUrstEcPKrD7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jjVaYD2l; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a4c150bso5372530a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583022; x=1740187822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qfmMC3DUpUVFcoYmpv/vzMrZU9gxNkqownIWIDSwEvc=;
        b=jjVaYD2lngCRzBJUkqhrX1tpaPwOSDOMt9b2RoDrpnQLM/ZlOd3fuBvOfaGFl9BQM7
         RC1LWJtR30BNSaSxguMwkUDOAnAVx6zfudNZY926/dBk+29Bzqj46dJkXNm8i+1057Ct
         qsSUvB1R6bypQTN1lJDOk9vCY8nrldSm8E7YyPYzPhxyPLuKDLURT3jA6+LRiJzpO89/
         CvinPUqi+PBecCQ5l2cUoLU1wLVSETG34iyvtv991EAl9tySXyMFwG5xLM4yBLzSxxkU
         vyr7dBEzbPL3/8nwtmQM5gjiBjjUyDKCIxB2vLRf5KWfdLAQVIYWlvgonQazLTz/j7vU
         TXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583022; x=1740187822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qfmMC3DUpUVFcoYmpv/vzMrZU9gxNkqownIWIDSwEvc=;
        b=QGi1iCngP8caYVJpUNhF33fmLD1GmOLmT6xdtH8Xg6E9O3IsgCy87f87gYgoT7n5Um
         24S8lRksU/CK9tf77BOjXtPAt6urw73lQYU1eKQfXPp0Isa9V/JClmC71wtniBz1ljo+
         Ei4PK3dSr5FFJg7lBGBQnaDD8EEgdc9d6CqMjKFyGe6TdgVLtwZIB3odB8/WYYF8CpbI
         BchXLQ6xwXFDHlpi1LKIAoRs3QAfqAVFqLU6s2rIK3CC+IWMK5HStoKFW2pO+WyFMmox
         v5YVvZkAuHfXs4MyP7iN+9AcuySs9FLQm5WSawNw4l0akcz63GnJR/HG/aEUCMeudUr9
         sQfQ==
X-Gm-Message-State: AOJu0YyQdNPh+rn9kkIy5DPVVHAsTI+xuD+KUFIfjcjfVtVRdOBDCaF2
	e8WK+nHVZXBtuiOeCEQ73Wn7ZSuKuEk7lZcKPmBuPeorYq7U3RS6nPL9KJrEHYSMlD96xFT5ivW
	Cpw==
X-Google-Smtp-Source: AGHT+IFcd+R/fXqORFeTyTE33uFWiAfbQ4ZKNPMt28u8hsrTCZHRMfjMe9BhrCJMr4MeVC784Yr1sbvLu8w=
X-Received: from pjbqa9.prod.google.com ([2002:a17:90b:4fc9:b0:2ef:d136:17fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3812:b0:2ee:ead6:6213
 with SMTP id 98e67ed59e1d1-2fc40f22e0dmr1739559a91.19.1739583022283; Fri, 14
 Feb 2025 17:30:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:13 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 1/6] x86: Add _safe() and _fep_safe()
 variants to segment base load instructions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Add _safe() and _fep_safe() helpers for segment/base instructions; the
helpers will be used to validate various ways of setting the segment bases
and GDT/LDT bases.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240907005440.500075-2-mlevitsk@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.h      |  4 ++--
 lib/x86/processor.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 92c45a48..5349ea57 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -286,8 +286,8 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 #define asm_safe(insn, inputs...)					\
 	__asm_safe("", insn, inputs)
 
-#define asm_fep_safe(insn, output, inputs...)				\
-	__asm_safe_out1(KVM_FEP, insn, output, inputs)
+#define asm_fep_safe(insn, inputs...)				\
+	__asm_safe_out1(KVM_FEP, insn,, inputs)
 
 #define __asm_safe_out1(fep, insn, output, inputs...)			\
 ({									\
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index da1ed662..9248a06b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -468,6 +468,11 @@ static inline int rdmsr_safe(u32 index, uint64_t *val)
 	return rdreg64_safe("rdmsr", index, val);
 }
 
+static inline int rdmsr_fep_safe(u32 index, uint64_t *val)
+{
+	return __rdreg64_safe(KVM_FEP, "rdmsr", index, val);
+}
+
 static inline int wrmsr_safe(u32 index, u64 val)
 {
 	return wrreg64_safe("wrmsr", index, val);
@@ -597,6 +602,16 @@ static inline void lgdt(const struct descriptor_table_ptr *ptr)
 	asm volatile ("lgdt %0" : : "m"(*ptr));
 }
 
+static inline int lgdt_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_safe("lgdt %0", "m"(*ptr));
+}
+
+static inline int lgdt_fep_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_fep_safe("lgdt %0", "m"(*ptr));
+}
+
 static inline void sgdt(struct descriptor_table_ptr *ptr)
 {
 	asm volatile ("sgdt %0" : "=m"(*ptr));
@@ -607,6 +622,16 @@ static inline void lidt(const struct descriptor_table_ptr *ptr)
 	asm volatile ("lidt %0" : : "m"(*ptr));
 }
 
+static inline int lidt_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_safe("lidt %0", "m"(*ptr));
+}
+
+static inline int lidt_fep_safe(const struct descriptor_table_ptr *ptr)
+{
+	return asm_fep_safe("lidt %0", "m"(*ptr));
+}
+
 static inline void sidt(struct descriptor_table_ptr *ptr)
 {
 	asm volatile ("sidt %0" : "=m"(*ptr));
@@ -617,6 +642,16 @@ static inline void lldt(u16 val)
 	asm volatile ("lldt %0" : : "rm"(val));
 }
 
+static inline int lldt_safe(u16 val)
+{
+	return asm_safe("lldt %0", "rm"(val));
+}
+
+static inline int lldt_fep_safe(u16 val)
+{
+	return asm_safe("lldt %0", "rm"(val));
+}
+
 static inline u16 sldt(void)
 {
 	u16 val;
@@ -629,6 +664,16 @@ static inline void ltr(u16 val)
 	asm volatile ("ltr %0" : : "rm"(val));
 }
 
+static inline int ltr_safe(u16 val)
+{
+	return asm_safe("ltr %0", "rm"(val));
+}
+
+static inline int ltr_fep_safe(u16 val)
+{
+	return asm_safe("ltr %0", "rm"(val));
+}
+
 static inline u16 str(void)
 {
 	u16 val;
-- 
2.48.1.601.g30ceb7b040-goog


