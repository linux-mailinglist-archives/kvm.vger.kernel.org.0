Return-Path: <kvm+bounces-48593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EBF1ACF7C7
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7487416511B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F39827CCF3;
	Thu,  5 Jun 2025 19:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xpn9cdJQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663131FDE33
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151361; cv=none; b=AouEdXB7Dv04SeRzSEjMQGXlw9zPskvRoSjpYU2f7kgmR6LwtMt0XK9CJvMcBL4vPyaECOmiBCWNtlPCNMr1VCIxZLgRY4ZixzrWOvaubVP6rxdpk7yiebxFjWkzV9GSNdjk4UgXUEL7pCAtEgfn9te61E49kvBZ/Pc8u9CP8gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151361; c=relaxed/simple;
	bh=G7CaJSmClV0nkQOOMNEsmwJkH1yX+HjSEU8FZW7/MWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ib17WA+5Z2eKfOj7/tKZNQH3QGvKxO7oCKLrpFAcL3xU4EphoYm9DW1P9AwCPAXQAtlSuAe/k/55I3A/PhElplK3DZFzVDrpTythfXthaHKqDWDbvdg6Hkf/wDwFdej/qyItcooYR48MDAy+ZlDJXsJiXejLycLpVeVs9QpgrG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xpn9cdJQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312c33585c2so1376985a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151359; x=1749756159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NuFdCSXIKZqvmQIUB4YuJDA8Ll3UkYMfDm5Y5Zv2NqY=;
        b=xpn9cdJQ6TADjopWb+Y4SfF/O+7dCrVkX4a0qDZCrdaMQXMNXyUn21tBzisnT/whE/
         lk11U6DeDoct5X0DGG/CUqdAoMOk0KVM8METFBHHNtmTOqZkLPBnRX7fm4g8ZLY/YWvc
         jeC06ZPbjn9WFLGLCMDKF0RipsrR96bn2EPMOIMVptrs5Qtx3j/p65GC+Yh8kbRIqUch
         UTPTkU/fCI03i+HEualhlQC/R5ky2K+y/opHNq3qpO4h9gV4BSHrgAzrGSjyrthrIMjW
         aJp/jnHeXsBwbQC5JH3X4JfsoO/qvRD1hYV4D9hbeFYb5oDvNPWtY1sv3/p1rUr0GMuJ
         8uKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151359; x=1749756159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NuFdCSXIKZqvmQIUB4YuJDA8Ll3UkYMfDm5Y5Zv2NqY=;
        b=AA95RDz7lolJElCVU20HNsIFSF6rr+1dHCOzxri8DA2/TwP9t2GfByED4cdbnOD6Zu
         /AJWQJqU+mWmcunUKQ0FoBADk/giBJtLvJTlR7XfnSN0gOGF43vuFzLjvLhRftxSm5fN
         1avD9hGNrGWBieeQChzLh9IUZ58fwsqD2kJqQOl5L3JPWyeVOfrWC65ze5au0Ygz1kN4
         Hc3HsnYaNVvT1EMy1HVvZYIASPlZmYqPtoSf7aBgqVqAtulP0CHjVIvoJH3hon0MRQp2
         ErP3HkAnZ8RiYMaHYscNtDOGS7SqcTgx+O7UKJa2FGztjbrDzNfN4ekW5MI34bLMjGcm
         WJkQ==
X-Gm-Message-State: AOJu0YzhdpqcI4xngIWb/CRY/UTcnVvNRXTUp+MuVBAK1IP+BD4scbR4
	LgiE8fJ2xZfc6sosLfljtUwWKjtUXkwdIB/FpYYTYgx29IUKseOiCO63ilMUaUeSozWEABdglGf
	dGgUBYg==
X-Google-Smtp-Source: AGHT+IH9KhROF8ZJDo6JuYD7dnrlV3XKjZpAn3O3qAI75DPYshk+vxNjbkRntzv8JYv9EvxZG/qP6uxmemg=
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:312:26c4:236])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57c3:b0:313:b1a:3939
 with SMTP id 98e67ed59e1d1-31347409c7amr1383060a91.15.1749151359659; Thu, 05
 Jun 2025 12:22:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:22 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 4/8] x86: Expand the suite of bitops to
 cover all set/clear operations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Provide atomic and non-atomic APIs for clearing and setting bits, along
with "test" versions to return the original value.  Don't bother with
"change" APIs, as they are highly unlikely to be needed.

Opportunistically move the existing definitions to bitops.h so that common
code can access the helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/asm/bitops.h | 86 +++++++++++++++++++++++++++++++++++++++++---
 lib/x86/processor.h  | 12 -------
 2 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
index 54ec9c42..3ece1b67 100644
--- a/lib/x86/asm/bitops.h
+++ b/lib/x86/asm/bitops.h
@@ -13,12 +13,88 @@
 
 #define HAVE_BUILTIN_FLS 1
 
-static inline void test_and_set_bit(long nr, unsigned long *addr)
+/*
+ * Macros to generate condition code outputs from inline assembly,
+ * The output operand must be type "bool".
+ */
+#ifdef __GCC_ASM_FLAG_OUTPUTS__
+# define CC_SET(c) "\n\t/* output condition code " #c "*/\n"
+# define CC_OUT(c) "=@cc" #c
+#else
+# define CC_SET(c) "\n\tset" #c " %[_cc_" #c "]\n"
+# define CC_OUT(c) [_cc_ ## c] "=qm"
+#endif
+
+static inline void __clear_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+
+	__asm__ __volatile__("btr %1, %0"
+			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
+}
+
+static inline void __set_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+
+	__asm__ __volatile__("bts %1, %0"
+			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
+}
+
+static inline bool __test_and_clear_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+	bool v;
+
+	__asm__ __volatile__("btr %2, %1" CC_SET(c)
+			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
+	return v;
+}
+
+static inline bool __test_and_set_bit(int bit, void *__addr)
 {
-	asm volatile("lock; bts %1,%0"
-		     : "+m" (*addr)
-		     : "Ir" (nr)
-		     : "memory");
+	unsigned long *addr = __addr;
+	bool v;
+
+	__asm__ __volatile__("bts %2, %1" CC_SET(c)
+			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
+	return v;
+}
+
+static inline void clear_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+
+	__asm__ __volatile__("lock; btr %1, %0"
+			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
+}
+
+static inline void set_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+
+	__asm__ __volatile__("lock; bts %1, %0"
+			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
+}
+
+static inline bool test_and_clear_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+	bool v;
+
+	__asm__ __volatile__("lock; btr %2, %1" CC_SET(c)
+			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
+	return v;
+}
+
+static inline bool test_and_set_bit(int bit, void *__addr)
+{
+	unsigned long *addr = __addr;
+	bool v;
+
+	__asm__ __volatile__("lock; bts %2, %1" CC_SET(c)
+			     : CC_OUT(c) (v), "+m" (*addr) : "Ir" (bit));
+	return v;
 }
 
 #endif
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index a0be04c5..5bc9ef89 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -914,18 +914,6 @@ static inline bool is_canonical(u64 addr)
 	return (s64)(addr << shift_amt) >> shift_amt == addr;
 }
 
-static inline void clear_bit(int bit, u8 *addr)
-{
-	__asm__ __volatile__("lock; btr %1, %0"
-			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
-}
-
-static inline void set_bit(int bit, u8 *addr)
-{
-	__asm__ __volatile__("lock; bts %1, %0"
-			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
-}
-
 static inline void flush_tlb(void)
 {
 	ulong cr4;
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


