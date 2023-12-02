Return-Path: <kvm+bounces-3211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 313DF8018A7
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8281B2118A
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C78BE5D;
	Sat,  2 Dec 2023 00:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="je2wEPOp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE3419BA
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:05:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db584b8fb9cso1388226276.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475513; x=1702080313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sn5K0TUz/ND3xDsLXUagKvVZbAXVyeU2LAAk3nLknAQ=;
        b=je2wEPOphLZAZjfRFJNa2KF5G1I4U0vFNbnTo2yoPrB2K8cpdwT9P/oOWhZTPaw28n
         uQhAAY9AC9BJWydnxGtq5mx6FTmg/V5USlEPqI0eejjscvipmMKPFGt03BHraLShbQoP
         BTEE3n+cOLBPLNd7mpE69gTUf7op+PrbpomO94yyvcqrN9Kl7OsGikkkfOMsnCu2XKoh
         au55mTq38RQENeuktx7odaQq9lh3R+ZZ82eG3Mgh4MRh9C2t0WB358rDnibvG8jgt25g
         0VRtVNx9YzSmVRmnp4M/OMojZmyoWBmLeDsAl1W0av6WKqF9gygN8wv2xg3NfuXG3bwt
         RdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475513; x=1702080313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sn5K0TUz/ND3xDsLXUagKvVZbAXVyeU2LAAk3nLknAQ=;
        b=GwbSlLTRnzcGhBt4UBstmpNInn4spUkxyThs9z75G2D2ZerBP6aVupvZrFUUzC7r4v
         nhUnaKF9hNPiJiLWOubfnx9hANURTMlzLauTCWhhO73VGJ8OWuAiEJxnOgEH1cY4OGuo
         LNyC5h1R/OaT9MLhEDf8q5D/EBnYwq5KNH5aIXffREyTMNaq2FxTj2RMBs1G2nP1SZYk
         +rptCvgskzmAHGQaPzB45zBkWCvkKz0jjIegrJwpUgvaVDMnEyGiZ8EJv/lkwxk9dYpu
         JM+c9K3eK1lUvNpcXbQ5t6AEIgzxmrZ2lmibEo3NK5Ns7vVemwGFZCM5PEWBFPYWcFaK
         G2wA==
X-Gm-Message-State: AOJu0YwTqBKjDyd1n4EVI3H/DuSq7xYKoNCEzxxW9zbnpuYBCUqrgQA0
	3ED92oAKpo1H9qCvgDuV8uXRwX32hCM=
X-Google-Smtp-Source: AGHT+IGU5VUK2zTQkg8a/XGiiJ4Q3YoMqy7bJoHyeFwrZZ6a/+7kCqG4KfTBQRJGcM+jcjHoD9/fRhNhGkk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d6d1:0:b0:db7:dce9:76d3 with SMTP id
 n200-20020a25d6d1000000b00db7dce976d3mr11991ybg.9.1701475512974; Fri, 01 Dec
 2023 16:05:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:16 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-28-seanjc@google.com>
Subject: [PATCH v9 27/28] KVM: selftests: Add helpers for safe and safe+forced
 RDMSR, RDPMC, and XGETBV
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers for safe and safe-with-forced-emulations versions of RDMSR,
RDPMC, and XGETBV.  Use macro shenanigans to eliminate the rather large
amount of boilerplate needed to get values in and out of registers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 40 +++++++++++++------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index fe891424ff55..abac816f6594 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1216,21 +1216,35 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	vector;								\
 })
 
-static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
-{
-	uint64_t error_code;
-	uint8_t vector;
-	uint32_t a, d;
-
-	asm volatile(KVM_ASM_SAFE("rdmsr")
-		     : "=a"(a), "=d"(d), KVM_ASM_SAFE_OUTPUTS(vector, error_code)
-		     : "c"(msr)
-		     : KVM_ASM_SAFE_CLOBBERS);
-
-	*val = (uint64_t)a | ((uint64_t)d << 32);
-	return vector;
+#define BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
+static inline uint8_t insn##_safe ##_fep(uint32_t idx, uint64_t *val)	\
+{									\
+	uint64_t error_code;						\
+	uint8_t vector;							\
+	uint32_t a, d;							\
+									\
+	asm volatile(KVM_ASM_SAFE##_FEP(#insn)				\
+		     : "=a"(a), "=d"(d),				\
+		       KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
+		     : "c"(idx)						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+									\
+	*val = (uint64_t)a | ((uint64_t)d << 32);			\
+	return vector;							\
 }
 
+/*
+ * Generate {insn}_safe() and {insn}_safe_fep() helpers for instructions that
+ * use ECX as in input index, and EDX:EAX as a 64-bit output.
+ */
+#define BUILD_READ_U64_SAFE_HELPERS(insn)				\
+	BUILD_READ_U64_SAFE_HELPER(insn, , )				\
+	BUILD_READ_U64_SAFE_HELPER(insn, _fep, _FEP)			\
+
+BUILD_READ_U64_SAFE_HELPERS(rdmsr)
+BUILD_READ_U64_SAFE_HELPERS(rdpmc)
+BUILD_READ_U64_SAFE_HELPERS(xgetbv)
+
 static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 {
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
-- 
2.43.0.rc2.451.g8631bc7472-goog


