Return-Path: <kvm+bounces-63992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A17C769E0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:32:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id E11C129DCC
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EEB22D7B5;
	Thu, 20 Nov 2025 23:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uL6X3U9P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C613B584
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681516; cv=none; b=Yiwvgi9eSUyJXg3fwJo4zN2rMotSilohR1FCaRiwzJ4ij51dz6SfzAFJhHSWBfeODdLJKIiqaBmR1MNF+A500qgmiqAKrEJCZKzu6Fi6OHs3Wm79WNKJDMbcfA730UGRK0iMes7LwsaBAZTVrdliwQB72UtxCcDYE+4bNiQeUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681516; c=relaxed/simple;
	bh=vEKb6LxNA5ekltlTax+a9X6+LDEDoiW7IMMOWJ07f3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qPdTqegadvGMWiD5pHGX1pkbdjqU5AvGZdndTI0dAOp3oYT3pNobnDfcGUqfQgpT+1VRAEErJjc4qIm+x4i6+nP22h2TakN0QkvCIwzY5/2HkHct0eGR04wjA2Lsa4akXnVXooAhD2wRNeKfBYVeRkdI0UEwaaAolsw85+qX1Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uL6X3U9P; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so3003204a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681514; x=1764286314; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/IkK/iKnINJVebMhxOC91iwlfpZIcdCMrvREYbVQa2c=;
        b=uL6X3U9PwQXUWoEf0jWIjLF99N3RpJsIVfqjJp4tJKLMek97eQboi9ORyFx5/1XTw6
         Yhl3sRmRp64I93TSZyNJ3l/nMF6n2kRE2mqAWgAv3No2hiQczAPIiRQxj7oOEk9xyKL5
         iuE6+IjrceNiim5ML6fjupZ69M+Gg8GrsTShEZwe2AsQxvXesVJg+za4jrkiE1FK02DF
         CLq/0K87lnuE7LlqB541JxzNEiG6kLp8UQDrcqJENNR6jW+5wIabWsJK2YXoQjXPmx9Q
         cwRbl4hSgxOBsQGQEPyURfUl/lAbsr8aRCALFvhuLzo8r15FjOcf8IhyMmCQigvXLq5g
         QTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681514; x=1764286314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/IkK/iKnINJVebMhxOC91iwlfpZIcdCMrvREYbVQa2c=;
        b=dyxzE3+A2alb6Bi9rog/4TwHl7op7zK3PMumOMQfU1BPLmwzglUk7ElII1hICuQI82
         X9R6I+0QHJxNobYlbhTGGa1pl1wB0X+nMBtnGhcbtwcgs5YiTbiSvBOfkxn/muApCMnj
         PdxlPRFN+ljsB9HJhaa2ucApyO2kWXH/vSAB8Z/I9tmOsqipxF6ahQIB4Sn0thjbGHyf
         Xj8/jx6I3MeXE5Yf1kRgZkznsFrXIPTA0l7byOE+1GiHnB0PsJFe4b/QQdGQ1AAY/UrQ
         8+KK4CM/fVjwAICJhaqPh66u1T7fW9uMZVh0uoP6ji/LZG2Ds88zsWApHMN0b3doxDqW
         W0hw==
X-Gm-Message-State: AOJu0YyUjB9iXVqOQsIh0o93c1L7f7PyXQyrjQsfbw15mVntV/6ssQl2
	LnCHqBNlGPp+a+lgk5lyHzuAtfntT8Z5Zcdb/T47a2MFuuvX4WeHUrSKqzrtjrNqd4qfbfotPTJ
	ug5aMYw==
X-Google-Smtp-Source: AGHT+IEf5h1SNURzBMgi+LbNEsAgTtjNhaSvlhvDFovhWXdAlJVWl9e3wpqpFEGwyoWCW2XLdqwekuShBZg=
X-Received: from pjbds2.prod.google.com ([2002:a17:90b:8c2:b0:347:2e36:e379])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54c5:b0:341:1ac:84e0
 with SMTP id 98e67ed59e1d1-34733e60682mr267578a91.11.1763681514538; Thu, 20
 Nov 2025 15:31:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Nov 2025 15:31:42 -0800
In-Reply-To: <20251120233149.143657-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120233149.143657-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251120233149.143657-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 1/8] x86/pmu: Add helper to detect Intel
 overcount issues
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Yi Lai <yi1.lai@intel.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: dongsheng <dongsheng.x.zhang@intel.com>

For Intel Atom CPUs, the PMU events "Instruction Retired" or
"Branch Instruction Retired" may be overcounted for some certain
instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
and complex SGX/SMX/CSTATE instructions/flows.

The detailed information can be found in the errata (section SRF7):
https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/

For the Atom platforms before Sierra Forest (including Sierra Forest),
Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
be overcounted on these certain instructions, but for Clearwater Forest
only "Instruction Retired" event is overcounted on these instructions.

So add a helper detect_inst_overcount_flags() to detect whether the
platform has the overcount issue and the later patches would relax the
precise count check by leveraging the gotten overcount flags from this
helper.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
[Rewrite comments and commit message - Dapeng]
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
[sean: put errata detection and tracking in pmu_init()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c       | 39 +++++++++++++++++++++++++++++++++++++++
 lib/x86/pmu.h       |  5 +++++
 lib/x86/processor.h | 26 ++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index fb46b196..67f3b23e 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -2,11 +2,50 @@
 
 struct pmu_caps pmu;
 
+/*
+ * For Intel Atom CPUs, the PMU events "Instruction Retired" or
+ * "Branch Instruction Retired" may be overcounted for some certain
+ * instructions, like FAR CALL/JMP, RETF, IRET, VMENTRY/VMEXIT/VMPTRLD
+ * and complex SGX/SMX/CSTATE instructions/flows.
+ *
+ * The detailed information can be found in the errata (section SRF7):
+ * https://edc.intel.com/content/www/us/en/design/products-and-solutions/processors-and-chipsets/sierra-forest/xeon-6700-series-processor-with-e-cores-specification-update/errata-details/
+ *
+ * For the Atom platforms before Sierra Forest (including Sierra Forest),
+ * Both 2 events "Instruction Retired" and "Branch Instruction Retired" would
+ * be overcounted on these certain instructions, but for Clearwater Forest
+ * only "Instruction Retired" event is overcounted on these instructions.
+ */
+static void pmu_detect_intel_overcount_errata(void)
+{
+	struct cpuid c = cpuid(1);
+
+	if (x86_family(c.a) == 0x6) {
+		switch (x86_model(c.a)) {
+		case 0xDD: /* Clearwater Forest */
+			pmu.errata.instructions_retired_overcount = true;
+			break;
+
+		case 0xAF: /* Sierra Forest */
+		case 0x4D: /* Avaton, Rangely */
+		case 0x5F: /* Denverton */
+		case 0x86: /* Jacobsville */
+			pmu.errata.instructions_retired_overcount = true;
+			pmu.errata.branches_retired_overcount = true;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 void pmu_init(void)
 {
 	pmu.is_intel = is_intel();
 
 	if (pmu.is_intel) {
+		pmu_detect_intel_overcount_errata();
+
 		pmu.version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
 
 		if (pmu.version > 1) {
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index c7dc68c1..e84b37dc 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -73,6 +73,11 @@ struct pmu_caps {
 	u32 msr_global_status_clr;
 
 	u64 perf_cap;
+
+	struct {
+		bool instructions_retired_overcount;
+		bool branches_retired_overcount;
+	} errata;
 };
 
 extern struct pmu_caps pmu;
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 8a73af5e..68bd774b 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -226,6 +226,32 @@ static inline bool is_intel(void)
 	return strcmp((char *)name, "GenuineIntel") == 0;
 }
 
+static inline u32 x86_family(u32 sig)
+{
+	u32 x86;
+
+	x86 = (sig >> 8) & 0xf;
+
+	if (x86 == 0xf)
+		x86 += (sig >> 20) & 0xff;
+
+	return x86;
+}
+
+static inline u32 x86_model(u32 sig)
+{
+	u32 fam, model;
+
+	fam = x86_family(sig);
+
+	model = (sig >> 4) & 0xf;
+
+	if (fam >= 0x6)
+		model += ((sig >> 16) & 0xf) << 4;
+
+	return model;
+}
+
 /*
  * Pack the information into a 64-bit value so that each X86_FEATURE_XXX can be
  * passed by value with no overhead.
-- 
2.52.0.rc2.455.g230fcf2819-goog


