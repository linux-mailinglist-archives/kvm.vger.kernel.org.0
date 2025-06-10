Return-Path: <kvm+bounces-48893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BDC8AD463B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B17FB3A70DF
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D2C2C030E;
	Tue, 10 Jun 2025 22:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HflR/2iq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED232BEC30
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596278; cv=none; b=asR/IxQRMFDr0/OY6+fh1ZlPpww35DOAT4Cfbsfu5v8SOYWcqea6UgRL5qM7Q7SQrbAokc5ngzECqyK26jRPH0iqIjyGXeg2W01mgZIExBUWpqmof7+9LFh3u3AeD2kA5MyUXm7u3Wv14w2fjFqTqxrNCGIqPJrJotzl5Flln5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596278; c=relaxed/simple;
	bh=MDOUH3X6wq/mglGD6uhAQsU6Et3gPFf5mZVecvvR/9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oQaxqAt7Ugab83iwiF6PceZ1iJ7eoBjXXVp3GtmVbp+3fZ7jDn+u2s2yWOYYvZO4+NH9JHFGgTpxPd2sYoDMvwprYS/K3+OHg4lj0eVZc+HI+Q+4vZ2MhttUlrUkJSSijPwn3wuFkKSjnD2s8WFsQxEUMfYbABVsJN2FnYz5rTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HflR/2iq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747af0bf0ebso4598413b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596276; x=1750201076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BWoe3RUxKXBLyv8Si/dsvC7/cgdlk+MDhj94IyKDEDU=;
        b=HflR/2iq7dL2gImevWzs6jvbe047NoKFWpV4a8B+Nqn5auALDCD+p20jVg9sz5VDwn
         UTOw3rdfwQxsSFrzf3+wJb8gdg82CxhBbcvghkccK4jULG49o9rSS0Ie+KAsNhsya3nb
         7htHN/xDEJRSTf4vMc4wz0Cd2/oore/27fCZcpPFg9Umjpz/eU2xHS+4HztFuNZVNyYb
         5HrJO1xp4PHuUZPp1z3dQNkqatBzCy+7FRBiHu10mxcDSV8E+Z1reIfxyW2gB3nRE6ri
         NdQMczDt2gqesZFuZUbRmBr/xgM9XtPjPbtrcYSAiokq8RzrPPF3dS3Akw6PAnMASYYD
         1gyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596276; x=1750201076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BWoe3RUxKXBLyv8Si/dsvC7/cgdlk+MDhj94IyKDEDU=;
        b=RHM5iSb7IT9Q9t/Aztl382AMQSjF99BU7U3fydtsldQbI4Nqqt2M1JBKQMeswoGQ4F
         F2leD39aUdLWV/ZHLSxJDZd6CkHNEFZYFVi911Nb/5K78K5cMx8Jnh+AwberxY7O9Mqo
         IM5UBXQurJlHHYbSI7lRyfshOdEM0NsChhFi5kQ2XOliwwbCjXSc0MFsQjTpZq8a5r0K
         Uz+KVkYSCjjO9NaQ/QWyJIiIHM6JiwU66G+NbBw/y+CDOmLOpWpe57B/tHHUhd1WVxkE
         7ie+yfom+0b2j4ONKbmf+6pdRiSeFT4uF3BD1jPIZzjAXByz7gK2T5Ll6IHEHKX4pv0D
         n80w==
X-Gm-Message-State: AOJu0YxmuADlQLwYUE5hs1XBp0w5zmdb/eCGEREvGfhOMYvq4zKcBblG
	FibaSWN/iBnYjlbJASnGbf6WhebsiiUweyt5nASNEFLF7qEIhpHMNs8gzFWdejTsPbuJOJaQ+Ns
	eDOgwqg==
X-Google-Smtp-Source: AGHT+IEg1w75KYPNRmchxzOO8gESU1MbJ8FnfG5EUTzVHn8nGAguHp/iA+cZNRupVdy01no7GpvgeWcwHnk=
X-Received: from pgbaz4.prod.google.com ([2002:a05:6a02:44:b0:b2f:9d37:5774])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a5:b0:1f5:5a0b:4768
 with SMTP id adf61e73a8af0-21f86703596mr1655744637.21.1749596276465; Tue, 10
 Jun 2025 15:57:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:14 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-10-seanjc@google.com>
Subject: [PATCH v2 09/32] KVM: SVM: Clean up macros related to architectural
 MSRPM definitions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move SVM's MSR Permissions Map macros to svm.h in antipication of adding
helpers that are available to SVM code, and opportunistically replace a
variety of open-coded literals with (hopefully) informative macros.

Opportunistically open code ARRAY_SIZE(msrpm_ranges) instead of wrapping
it as NUM_MSR_MAPS, which is an ambiguous name even if it were qualified
with "SVM_MSRPM".

Deliberately leave the ranges as open coded literals, as using macros to
define the ranges actually introduces more potential failure points, since
both the definitions and the usage have to be careful to use the correct
index.  The lack of clear intent behind the ranges will be addressed in
future patches.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++--------
 arch/x86/kvm/svm/svm.h | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 854904a80b7e..a683602cae22 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -268,22 +268,18 @@ static int tsc_aux_uret_slot __read_mostly = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
-#define NUM_MSR_MAPS ARRAY_SIZE(msrpm_ranges)
-#define MSRS_RANGE_SIZE 2048
-#define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
-
 u32 svm_msrpm_offset(u32 msr)
 {
 	u32 offset;
 	int i;
 
-	for (i = 0; i < NUM_MSR_MAPS; i++) {
+	for (i = 0; i < ARRAY_SIZE(msrpm_ranges); i++) {
 		if (msr < msrpm_ranges[i] ||
-		    msr >= msrpm_ranges[i] + MSRS_IN_RANGE)
+		    msr >= msrpm_ranges[i] + SVM_MSRS_PER_RANGE)
 			continue;
 
-		offset  = (msr - msrpm_ranges[i]) / 4; /* 4 msrs per u8 */
-		offset += (i * MSRS_RANGE_SIZE);       /* add range offset */
+		offset  = (msr - msrpm_ranges[i]) / SVM_MSRS_PER_BYTE;
+		offset += (i * SVM_MSRPM_BYTES_PER_RANGE);  /* add range offset */
 
 		/* Now we have the u8 offset - but need the u32 offset */
 		return offset / 4;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f1e466a10219..086a8c8aae86 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -613,11 +613,22 @@ static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
 	svm_vmgexit_set_return_code(svm, GHCB_HV_RESP_NO_ACTION, data);
 }
 
-/* svm.c */
+/*
+ * The MSRPM is 8KiB in size, divided into four 2KiB ranges (the fourth range
+ * is reserved).  Each MSR within a range is covered by two bits, one each for
+ * read (bit 0) and write (bit 1), where a bit value of '1' means intercepted.
+ */
+#define SVM_MSRPM_BYTES_PER_RANGE 2048
+#define SVM_BITS_PER_MSR 2
+#define SVM_MSRS_PER_BYTE (BITS_PER_BYTE / SVM_BITS_PER_MSR)
+#define SVM_MSRS_PER_RANGE (SVM_MSRPM_BYTES_PER_RANGE * SVM_MSRS_PER_BYTE)
+static_assert(SVM_MSRS_PER_RANGE == 8192);
+
 #define MSR_INVALID				0xffffffffU
 
 #define DEBUGCTL_RESERVED_BITS (~DEBUGCTLMSR_LBR)
 
+/* svm.c */
 extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.50.0.rc0.642.g800a2b2222-goog


