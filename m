Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2DB3DDF43
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhHBSeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231408AbhHBSeC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rVODFKjpHHsWrcOVmStXMEVlb3jc8Z1zSx5UbCY7ylg=;
        b=h3DWc/7z4MMEBSiRP26zuITdUPHoBPrpsR+YBKpHef6cHoQ4rsMDkPMJ7StPvZxC3ByWUY
        dB20+WLhVJMWYTLvV8qHG7DvarS1bHkm9FvQ+mEJmx/itgAYPvfITX28XVoWxTJw400bwO
        6sFTq/BG6WVIp53blTM8z3jHsFMxQ84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-EzleAlbFOcO-I8Nh3aJHSg-1; Mon, 02 Aug 2021 14:33:51 -0400
X-MC-Unique: EzleAlbFOcO-I8Nh3aJHSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 036C710066E6;
        Mon,  2 Aug 2021 18:33:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B29C3AE1;
        Mon,  2 Aug 2021 18:33:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 04/12] KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code
Date:   Mon,  2 Aug 2021 21:33:21 +0300
Message-Id: <20210802183329.2309921-5-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will allow it to return RET_PF_EMULATE for APIC mmio
emulation.

This code is based on a patch from Sean Christopherson:
https://lkml.org/lkml/2021/7/19/2970

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c5e0ecf5f758..6f77f6efd43c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3844,7 +3844,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
-			 bool write, bool *writable)
+			 bool write, bool *writable, int *r)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
@@ -3855,7 +3855,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	 * be zapped before KVM inserts a new MMIO SPTE for the gfn.
 	 */
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
-		return true;
+		goto out_retry;
 
 	/* Don't expose private memslots to L2. */
 	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
@@ -3875,14 +3875,17 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
 			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-			return true;
+			goto out_retry;
 		} else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
-			return true;
+			goto out_retry;
 	}
 
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
 				    write, writable, hva);
-	return false;
+
+out_retry:
+	*r = RET_PF_RETRY;
+	return true;
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
@@ -3913,8 +3916,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	smp_rmb();
 
 	if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva,
-			 write, &map_writable))
-		return RET_PF_RETRY;
+			 write, &map_writable, &r))
+		return r;
 
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
 		return r;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f349eae69bf3..7d03e9b7ccfa 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -882,8 +882,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	smp_rmb();
 
 	if (kvm_faultin_pfn(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
-			 write_fault, &map_writable))
-		return RET_PF_RETRY;
+			 write_fault, &map_writable, &r))
+		return r;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
 		return r;
-- 
2.26.3

