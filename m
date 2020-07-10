Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8721B9D8
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGJPs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:48:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50247 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728067AbgGJPs0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 11:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594396104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wqDUf4G2rfZBuLfI9I+dpuh0XkyA1XBdq/H6K7aU6xQ=;
        b=RCHrNlSMv4HDtwFwYrKLC8ACEfUrQIFiDvFrUIx+5pnUQMN/0OLB4+Yd6P1m+OEKiPWr+2
        /cuLOdb7b+5MHldXFe1GL7n/LmKGZAwDF+u5CatxW1YWUbWbFjoaodrPVi4oOFNXYf70wd
        hwTcjtdwx6uoJH0aiyhYlfKZlZKFvdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-kVY0tH_8MauYwOmatmaAkA-1; Fri, 10 Jul 2020 11:48:23 -0400
X-MC-Unique: kVY0tH_8MauYwOmatmaAkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8BC9106B24C;
        Fri, 10 Jul 2020 15:48:21 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-235.ams2.redhat.com [10.36.114.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0A787EFA3;
        Fri, 10 Jul 2020 15:48:19 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH v3 1/9] KVM: x86: Add helper functions for illegal GPA checking and page fault injection
Date:   Fri, 10 Jul 2020 17:48:03 +0200
Message-Id: <20200710154811.418214-2-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds two helper functions that will be used to support virtualizing
MAXPHYADDR in both kvm-intel.ko and kvm.ko.

kvm_fixup_and_inject_pf_error() injects a page fault for a user-specified GVA,
while kvm_mmu_is_illegal_gpa() checks whether a GPA exceeds vCPU address limits.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h |  6 ++++++
 arch/x86/kvm/x86.c | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.h |  1 +
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 444bb9c54548..59930231d5d5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
+#include "cpuid.h"
 
 #define PT64_PT_BITS 9
 #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
@@ -158,6 +159,11 @@ static inline bool is_write_protection(struct kvm_vcpu *vcpu)
 	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
 }
 
+static inline bool kvm_mmu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+        return (gpa >= BIT_ULL(cpuid_maxphyaddr(vcpu)));
+}
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..1f5f4074fc59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10699,6 +10699,27 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
+void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
+{
+	struct x86_exception fault;
+
+	if (!(error_code & PFERR_PRESENT_MASK) ||
+	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, error_code, &fault) != UNMAPPED_GVA) {
+		/*
+		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
+		 * tables probably do not match the TLB.  Just proceed
+		 * with the error code that the processor gave.
+		 */
+		fault.vector = PF_VECTOR;
+		fault.error_code_valid = true;
+		fault.error_code = error_code;
+		fault.nested_page_fault = false;
+		fault.address = gva;
+	}
+	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
+}
+EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e97e59f..239ae0f3e40b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -272,6 +272,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 bool kvm_vector_hashing_enabled(void);
+void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
-- 
2.26.2

