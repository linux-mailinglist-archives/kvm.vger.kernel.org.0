Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED0417896
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347507AbhIXQdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347416AbhIXQdd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3qBSDkkSxaXnwERh9nmkQRCVYCw3rkjz6D3rgLk8m0I=;
        b=VT1x6UBPJkeZImHmOy26n9L+aeE79l6BOfrsQ0XgR2dS7yZaAckcMu4cM90hSQudsEfN1u
        jYIOikaMSYvkKTGWCERraHoMqS37+3W9HvZxypaUUqcoCaLl1oP+ZG/T5ZRm9XwQIYf9V2
        zEwn8ehkPPksmqDjB5sJJuCKLOp4uKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-JpK6WN3jPaqhw_Bv0VghqQ-1; Fri, 24 Sep 2021 12:31:55 -0400
X-MC-Unique: JpK6WN3jPaqhw_Bv0VghqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0401802935;
        Fri, 24 Sep 2021 16:31:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31B3B60E1C;
        Fri, 24 Sep 2021 16:31:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 02/31] KVM: MMU: Introduce struct kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:23 -0400
Message-Id: <20210924163152.289027-3-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index e9688a9f7b57..0553ef92946e 100644
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


