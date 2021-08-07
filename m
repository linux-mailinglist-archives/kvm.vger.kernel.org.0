Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51AF3E35A2
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhHGNuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232372AbhHGNuD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YV9HL89pSqp0PtCqOD4/gmmSWtLC0E19+93loFbwPUo=;
        b=efjmnSz59un7RkUYwVvSO9e28jndL8owkKWPIJE3psaWH4SfJcHK9/gaMv+TKY6Oj5V9/w
        miQCj6NCot0h1kxGjfFN5LxerqLFPNmGmrAWJJC1S8Hd56CmvSe8ig3HWKLqDRebKnYcqD
        dcXVNReRhtNwHt3VAkO8uhyL7tL9Ozs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-kg29abJcOwyaF7CXh894Fg-1; Sat, 07 Aug 2021 09:49:44 -0400
X-MC-Unique: kg29abJcOwyaF7CXh894Fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C48B9107465F;
        Sat,  7 Aug 2021 13:49:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 363891700F;
        Sat,  7 Aug 2021 13:49:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 03/16] KVM: MMU: Introduce struct kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:23 -0400
Message-Id: <20210807134936.3083984-4-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a single structure for arguments that are passed from
kvm_mmu_do_page_fault to the page fault handlers.  Later
the structure will grow to include various output parameters
that are passed back to the next steps in the page fault
handling.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 83e6c6965f1e..5c06e059e483 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -114,17 +114,45 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->shadow_root_level);
 }
 
+struct kvm_page_fault {
+	/* arguments to kvm_mmu_do_page_fault.  */
+	const gpa_t addr;
+	const u32 error_code;
+	const bool prefault;
+
+	/* Derived from error_code.  */
+	const bool exec;
+	const bool write;
+	const bool present;
+	const bool rsvd;
+	const bool user;
+
+	/* Derived from mmu.  */
+	const bool is_tdp;
+};
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
 {
+	struct kvm_page_fault fault = {
+		.addr = cr2_or_gpa,
+		.error_code = err,
+		.exec = err & PFERR_FETCH_MASK,
+		.write = err & PFERR_WRITE_MASK,
+		.present = err & PFERR_PRESENT_MASK,
+		.rsvd = err & PFERR_RSVD_MASK,
+		.user = err & PFERR_USER_MASK,
+		.prefault = prefault,
+		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+	};
 #ifdef CONFIG_RETPOLINE
-	if (likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault))
-		return kvm_tdp_page_fault(vcpu, cr2_or_gpa, err, prefault);
+	if (fault.is_tdp)
+		return kvm_tdp_page_fault(vcpu, fault.addr, fault.error_code, fault.prefault);
 #endif
-	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
+	return vcpu->arch.mmu->page_fault(vcpu, fault.addr, fault.error_code, fault.prefault);
 }
 
 /*
-- 
2.27.0


