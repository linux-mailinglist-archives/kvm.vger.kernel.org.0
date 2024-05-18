Return-Path: <kvm+bounces-17721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19DBE8C8EC2
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE2CE1F22490
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBA01D6A5;
	Sat, 18 May 2024 00:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYQ9wfKF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0977B10A1E
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990687; cv=none; b=Fx/TjCgsEdzWmLD1n7SDvEJNOeJ0EY1WFMbGYVaTLQ2z0sT73FAAXfhEBaHZgW+hlpg+UZUtC3RFS15eDu3fTs0oZnj/ZkWtjKSgCtdu6nItCx2gaeJ+I8HBJNNwP74MrlvKtEzuEQ+GfoMwpZYYQLDCSDTTNaK+dW/5/KnROGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990687; c=relaxed/simple;
	bh=4/2HLzcusjSlO0rsq/T4/YEv0mk4XS4XnM4Qi5lbYss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VBr9oMPhPokpOyyR+4l0L9TnAFB3/oLGIvPJEDoukrW1Hb31u9L8Jmy6lKCj9IaO6/XAGevoT6XZfbMwaot9rLKfIPuPDj6BQcmy0NfbjJdoVOrBgQeendDbGq5U9gCLVLIJA7F0MhUrxhByM5A1pGRx7Au4uktUEFMQW2teLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYQ9wfKF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f454878580so9580879b3a.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990684; x=1716595484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QlWrNPMcBNIRjZ1oRUuV/rtUWiyhfC1iM9WcCPk5B74=;
        b=LYQ9wfKF3VBD8azfAFN5KBqS0dei6FaLHfqbNkwe+RREVRBklz1ONbLp0/F9vFB0Bw
         RiZUvJr92W0HSqwzD01xHqbOe+wiPocIIpqvPE6gJl/kYp2dQxFChzWlI7Cpp8cV+pWD
         XHB8V5RMx7hkpDtJOEnofk1m46Ghp7Xwno06HwbkVL+hDcwcnDPhnzylCuwomDikEUcX
         cVJmWr8HC0QYzZ51QnzYGrSwuSZy1K/c33VfwPW5ACGsjyS38TUEpc4UCRtECPavCB6i
         4uRRvzEJ0eBtyFt7xUTjfghs4HhW6fepnOI3QRafWBlaUnGONr0TnACLF2CFYI3g7d9U
         L2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990684; x=1716595484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QlWrNPMcBNIRjZ1oRUuV/rtUWiyhfC1iM9WcCPk5B74=;
        b=o1qc+R1j/qO6Jq3HqP6yhCA/eWoa8rBJjASqBEwhUuKwbEerL4DwbNvv1Vum1GPHiq
         QthilB6HAz1Nq1tBDxLBprVNcdGZ+KxyY90qjhsqJ2XU682M8Hw3+/dtg9lb7snidpy2
         TnaDkjmxUVoge+UNNEHVyn/yDJpp3+SUgikj+AWIes3Wg77X3VcuB5Vy2VdEQriKbXlG
         SmPp2qWXFPpm1uoOBRuQ2smt8rmBqhauyLMhrRX69Bdsq6no2xSXj9w4ePP4EJ197cjH
         bafu2gHw26NUcXbnhC6ggYnGoTJ76dJSh+6dyvoVFvGcA6W915L2XhiAd8J5Blq60Kt7
         FhMg==
X-Gm-Message-State: AOJu0YxgC3h5S7bMSJN0EyY3rgtQkDbd+r0AV2fTOsNk162PK6C2Pkly
	LQ32vrcehN/fXRwAHN6p/1qAd4A8N9/m3Ih6mXwAA2I1qBEM4WM59jWDKxdJ7wOFjYBcbaf1QVR
	GFw==
X-Google-Smtp-Source: AGHT+IGXTb5HJ+lESm2mn7d52eb+nyx9ads/DAkFTkEN0ck3hpsE/NtPnquqJPYm3p9JzsWWbbm5Xh2kiJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a0f:b0:6ea:88cd:67e9 with SMTP id
 d2e1a72fcca58-6f4e0376006mr1193202b3a.4.1715990684360; Fri, 17 May 2024
 17:04:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:25 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: x86/mmu: Add sanity checks that KVM doesn't create
 EPT #VE SPTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Assert that KVM doesn't set a SPTE to a value that could trigger an EPT
Violation #VE on a non-MMIO SPTE, e.g. to help detect bugs even without
KVM_INTEL_PROVE_VE enabled, and to help debug actual #VE failures.

Note, this will run afoul of TDX support, which needs to reflect emulated
MMIO accesses into the guest as #VEs (which was the whole point of adding
EPT Violation #VE support in KVM).  The obvious fix for that is to exempt
MMIO SPTEs, but that's annoyingly difficult now that is_mmio_spte() relies
on a per-VM value.  However, resolving that conundrum is a future problem,
whereas getting KVM_INTEL_PROVE_VE healthy is a current problem.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c      | 3 +++
 arch/x86/kvm/mmu/spte.h     | 9 +++++++++
 arch/x86/kvm/mmu/tdp_iter.h | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5095fb46713e..d2af077d8b34 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -336,16 +336,19 @@ static int is_cpuid_PSE36(void)
 #ifdef CONFIG_X86_64
 static void __set_spte(u64 *sptep, u64 spte)
 {
+	KVM_MMU_WARN_ON(is_ept_ve_possible(spte));
 	WRITE_ONCE(*sptep, spte);
 }
 
 static void __update_clear_spte_fast(u64 *sptep, u64 spte)
 {
+	KVM_MMU_WARN_ON(is_ept_ve_possible(spte));
 	WRITE_ONCE(*sptep, spte);
 }
 
 static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
 {
+	KVM_MMU_WARN_ON(is_ept_ve_possible(spte));
 	return xchg(sptep, spte);
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5dd5405fa07a..52fa004a1fbc 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -3,6 +3,8 @@
 #ifndef KVM_X86_MMU_SPTE_H
 #define KVM_X86_MMU_SPTE_H
 
+#include <asm/vmx.h>
+
 #include "mmu.h"
 #include "mmu_internal.h"
 
@@ -276,6 +278,13 @@ static inline bool is_shadow_present_pte(u64 pte)
 	return !!(pte & SPTE_MMU_PRESENT_MASK);
 }
 
+static inline bool is_ept_ve_possible(u64 spte)
+{
+	return (shadow_present_mask & VMX_EPT_SUPPRESS_VE_BIT) &&
+	       !(spte & VMX_EPT_SUPPRESS_VE_BIT) &&
+	       (spte & VMX_EPT_RWX_MASK) != VMX_EPT_MISCONFIG_WX_VALUE;
+}
+
 /*
  * Returns true if A/D bits are supported in hardware and are enabled by KVM.
  * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..2880fd392e0c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -21,11 +21,13 @@ static inline u64 kvm_tdp_mmu_read_spte(tdp_ptep_t sptep)
 
 static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_ptep_t sptep, u64 new_spte)
 {
+	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
 	return xchg(rcu_dereference(sptep), new_spte);
 }
 
 static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 {
+	KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
 	WRITE_ONCE(*rcu_dereference(sptep), new_spte);
 }
 
-- 
2.45.0.215.g3402c0e53f-goog


