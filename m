Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8430E837
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhBDADK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbhBDADF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:03:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E526C0612F2
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:50 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c13so1526040ybg.8
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Z9PY+ha0iNe1qhtrrDXpdGIAQqM4NawdTmEQfVlKh0A=;
        b=uXPdQJNCax4ScHsyNG6CuYomNtv/cKnz/pychbfxxThSndPFgZ1ZfDnm52ODAY/qGn
         09VhZi3QLmQmrscRMGiymFL2+iaw+pc0tf012Je5T97qs5kob1Gwbg0XGFhcxttGDB2l
         MH5ssPdPA8WcYGOSqHLidXVEnKdYbvPFz1rJ5zNHOWLpuEt8Z08zpRtVHwl4VK+NwOyD
         9YVXYHf5oakMsgvWDfsdGhQpGwZqdKdstc2ty32rzfb7yCd/KLBDvWlgaKACZ6I185ev
         j3iMmMY9+sBsDzjqGM9r1HN8OW/B+Wz11NkP5cPgr5v8/s6LMs642cBx3efzJycb1OKz
         7NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Z9PY+ha0iNe1qhtrrDXpdGIAQqM4NawdTmEQfVlKh0A=;
        b=O1OtW0rS6Z1IfUc5L63FMtfSxkiUVy9lo/diAbKPIf/GTIYEkwaNpWKdr/lRkDa0ZU
         R2AlptVMcs1mQjJcMvmDnKsLvrJi/n0kCQxIBF9btvChFaAAa7AYI/jMVBZszgT4fWJD
         oeR5OAcvtLn070+ckb6qUvUXsDnIm4ZvR+MmIamK9bLQ+Nsql1qTVULZOnOvLg5skYly
         mu8AjNfLHc/GzrZzg1Q2BEpas1nm1kgUNhCZck2/gzz3/UDJ8zUFNW8Dr3kbIOiVKanb
         NkNynjWG9iVTkhfE6/F0zIdO3IgThVAwM97OyJyXtKqm4Nmt5uBkn0XJwx5TLgwvonyC
         ot/A==
X-Gm-Message-State: AOAM532AKjl+LDOJnucVIOUjTG0YHwoPiRLcJZNSyALCw+v1zBN38wXq
        K9bDnQPgsWcyOF8QYYeg88xQe+RzqgQ=
X-Google-Smtp-Source: ABdhPJwvmeMkJuxwu9FcSp7HWHK7vMfbcCJ+yABiDBg9vCaI2ywrOt7JzIJcO4BVv1b3p08eAK1OQ5inVEY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a25:c04d:: with SMTP id c74mr7510990ybf.102.1612396909482;
 Wed, 03 Feb 2021 16:01:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:15 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 10/12] KVM: x86: Add helper to consolidate "raw" reserved GPA
 mask calculations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to generate the mask of reserved GPA bits _without_ any
adjustments for repurposed bits, and use it to replace a variety of
open coded variants in the MTRR and APIC_BASE flows.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 12 +++++++++++-
 arch/x86/kvm/cpuid.h |  1 +
 arch/x86/kvm/mtrr.c  | 12 ++++++------
 arch/x86/kvm/x86.c   |  4 ++--
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d313b1804278..dd9406450696 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -188,7 +188,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.reserved_gpa_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
+	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
@@ -242,6 +242,16 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 	return 36;
 }
 
+/*
+ * This "raw" version returns the reserved GPA bits without any adjustments for
+ * encryption technologies that usurp bits.  The raw mask should be used if and
+ * only if hardware does _not_ strip the usurped bits, e.g. in virtual MTRRs.
+ */
+u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
+{
+	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
+}
+
 /* when an old userspace process fills a new kernel module */
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 			     struct kvm_cpuid *cpuid,
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f673f45bdf52..2a0c5064497f 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -30,6 +30,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool exact_only);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
+u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu);
 
 static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index f472fdb6ae7e..a8502e02f479 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -75,7 +75,7 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	/* variable MTRRs */
 	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));
 
-	mask = (~0ULL) << cpuid_maxphyaddr(vcpu);
+	mask = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 	if ((msr & 1) == 0) {
 		/* MTRR base */
 		if (!valid_mtrr_type(data & 0xff))
@@ -351,14 +351,14 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (var_mtrr_range_is_valid(cur))
 		list_del(&mtrr_state->var_ranges[index].node);
 
-	/* Extend the mask with all 1 bits to the left, since those
-	 * bits must implicitly be 0.  The bits are then cleared
-	 * when reading them.
+	/*
+	 * Set all illegal GPA bits in the mask, since those bits must
+	 * implicitly be 0.  The bits are then cleared when reading them.
 	 */
 	if (!is_mtrr_mask)
 		cur->base = data;
 	else
-		cur->mask = data | (-1LL << cpuid_maxphyaddr(vcpu));
+		cur->mask = data | kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	/* add it to the list if it's enabled. */
 	if (var_mtrr_range_is_valid(cur)) {
@@ -426,7 +426,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		else
 			*pdata = vcpu->arch.mtrr_state.var_ranges[index].mask;
 
-		*pdata &= (1ULL << cpuid_maxphyaddr(vcpu)) - 1;
+		*pdata &= ~kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82a70511c0d3..28fea7ff7a86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -408,7 +408,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
-	u64 reserved_bits = ((~0ULL) << cpuid_maxphyaddr(vcpu)) | 0x2ff |
+	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
 		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
 	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
@@ -10089,7 +10089,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.reserved_gpa_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
+	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-- 
2.30.0.365.g02bc693789-goog

