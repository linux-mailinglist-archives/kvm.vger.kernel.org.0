Return-Path: <kvm+bounces-39420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD5FA46FD9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 491C23AA403
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463DC28373;
	Thu, 27 Feb 2025 00:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e2kX9+pl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14259EEC3
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740614837; cv=none; b=cxr7UgfnnUr1geQSuZDgoi/csGHZrMJpABkeUn+87eIpUyr3Ywnl8/0j5kT5PEREAXHz6QtFnB3p6SEe0PVU9eh1o9StF+o33KLbTiGWtofkQ7Vn5q+sn5a9emN9+NMST1W/vrRUQH5qjjy+FQAA3r2m9InOhCZYkL0KYmgTyGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740614837; c=relaxed/simple;
	bh=0OcKgr3Czng9NbWaBwLaNoKEDdd3fZmUTwyjhXF8x4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RXoHnHUmdRvII+PvSwzLHBVba6dMPMxGR/CkgPK9m2lwtRu4elUt0fgH0ZWnEAC6iiOOp1PWvQE+TCdCQ3mzivNaF3BA8MtEsWNHU6L+R6b6exE5wEVQmuvS7KnN5SkM1g9rkxbG8fySX7xvDRJIJPR6UYY9AA/B7GEfG7cyMIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e2kX9+pl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc5a9f18afso820878a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740614835; x=1741219635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OpBLcBPrSK39J8xwLKbfB7MiuFNa+KhFkiMUhKQTXu4=;
        b=e2kX9+pl//35VPfbGU0jT0oZFwAwprk2IhdW5VOdvxXkvoM0o79YWRKxfhUMQQDWCJ
         /2L+jmImp2xRicbqR3WtLzbUZJeKTzs10WDZ/7/TViGZuqmHiQP9YWtvvabPqn4kOgKl
         /wN6jIRIXByfVa7Q8XvtztfbC5fmbMJ30mBEDsPyQkZgYgVuDTLlvHEKtCQhH+6Eh9mg
         ziS3rnyE84rsTmb88VJFEX6xTQC1PtZTkDfi8U0+oq3oZzoV3F20cZhlCJ3P1LGgxgIj
         CDqvgh7TuuCAc6b6WEsVhLhvCjRguHi4RoVA3ShXM8OGnio8PV9s3QR8JvvIhi2XY6Nb
         2xlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740614835; x=1741219635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OpBLcBPrSK39J8xwLKbfB7MiuFNa+KhFkiMUhKQTXu4=;
        b=vDw4Ugqo8BpDVpXulS45V3yRHdoqSoc9j94kKBkRQzdYCfz5KoFPRWorqMtVQLjQHF
         SVubHkx3XfjXX85HhJ4lwWPwfCQExp43VvHoGMWgUK4otFiWaRwC5w/Kwr04SOcxZCtt
         2lm4a8Zq/BBoASQ4cpvcVmNFSpMNhZ6vtbK6mN5M34Gaw4sy7BUJ8sO/cfPl0jBf9vtL
         0UTXNzI5RD4VwRyaRHntOUv5W/429Waf1PU4hcIE+qL9jTiuZAai6TONGSk1kgmv6/VE
         TkNSKT/CKMNBAdW1WasCkI/+i+cdk60LUMqocdtH7rnEGmyMX47eSxUnhDLdyDPR5v6d
         5C4Q==
X-Gm-Message-State: AOJu0YwYhUQMAOCtYCICqEVra1PHNT6aFHpvBfUy/1wcMTP42mdzJ3Y1
	GiZ7Ix/v7Kd0zB1cNXWotBghjZtYStE1BhsumxUtKkcoX7tgqRSOF1f4sYUGPDQWyD3BfMFOFr9
	c1w==
X-Google-Smtp-Source: AGHT+IHvRvyrfuq3N6aeKsAExnrfi6YmDK+XDqxdTsUoJhVn44XGuxYyjmOc7xmxw6spYnjHOgtwHqwO+MQ=
X-Received: from pjbqi7.prod.google.com ([2002:a17:90b:2747:b0:2f5:4762:e778])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:518b:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2fe7e31f509mr8554685a91.11.1740614835389; Wed, 26
 Feb 2025 16:07:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 16:07:05 -0800
In-Reply-To: <20250227000705.3199706-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227000705.3199706-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227000705.3199706-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT Violation
 protection bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nikolay Borisov <nik.borisov@suse.com>, Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="UTF-8"

Define independent macros for the RWX protection bits that are enumerated
via EXIT_QUALIFICATION for EPT Violations, and tie them to the RWX bits in
EPT entries via compile-time asserts.  Piggybacking the EPTE defines works
for now, but it creates holes in the EPT_VIOLATION_xxx macros and will
cause headaches if/when KVM emulates Mode-Based Execution (MBEC), or any
other features that introduces additional protection information.

Opportunistically rename EPT_VIOLATION_RWX_MASK to EPT_VIOLATION_PROT_MASK
so that it doesn't become stale if/when MBEC support is added.

No functional change intended.

Cc: Jon Kohler <jon@nutanix.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h     | 13 +++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index aabc223c6498..8707361b24da 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -580,14 +580,23 @@ enum vm_entry_failure_code {
 /*
  * Exit Qualifications for EPT Violations
  */
-#define EPT_VIOLATION_RWX_SHIFT		3
 #define EPT_VIOLATION_ACC_READ		BIT(0)
 #define EPT_VIOLATION_ACC_WRITE		BIT(1)
 #define EPT_VIOLATION_ACC_INSTR		BIT(2)
-#define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
+#define EPT_VIOLATION_PROT_READ		BIT(3)
+#define EPT_VIOLATION_PROT_WRITE	BIT(4)
+#define EPT_VIOLATION_PROT_EXEC		BIT(5)
+#define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
+					 EPT_VIOLATION_PROT_WRITE | \
+					 EPT_VIOLATION_PROT_EXEC)
 #define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
 #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
+#define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
+
+static_assert(EPT_VIOLATION_RWX_TO_PROT(VMX_EPT_RWX_MASK) ==
+	      (EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_WRITE | EPT_VIOLATION_PROT_EXEC));
+
 /*
  * Exit Qualifications for NOTIFY VM EXIT
  */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f4711674c47b..68e323568e95 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -510,8 +510,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * Note, pte_access holds the raw RWX bits from the EPTE, not
 		 * ACC_*_MASK flags!
 		 */
-		walker->fault.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
-						     EPT_VIOLATION_RWX_SHIFT;
+		walker->fault.exit_qualification |= EPT_VIOLATION_RWX_TO_PROT(pte_access);
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b71392989609..049f28f1b2bc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5821,7 +5821,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
 	/* ept page table entry is present? */
-	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
+	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
 		      ? PFERR_PRESENT_MASK : 0;
 
 	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
-- 
2.48.1.711.g2feabab25a-goog


