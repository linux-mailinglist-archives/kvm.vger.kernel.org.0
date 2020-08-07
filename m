Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB523EEC8
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 16:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgHGOMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 10:12:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56305 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726186AbgHGOMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 10:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596809570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z8FPKtVhC2Cz+23jVlMU7obiTXtmibbxlAC2Ps134PI=;
        b=bJwbqW1V6xahskgZ5BnFyhTYNvl+c0kcmlveScX+5a/haLARxwjUxN5E7+Nct5ANlDOHJo
        xvyKR5OCk3pO7amoj+qBRyGHMmpxC9vsB499rT2ywSrL5TbTWSAnrF9DjfpLEhIraboE/b
        DWbix0I1X9+wQHk0erjUeAcoSleafUo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-_4Wtm20vPi2xsr1euBK3ZA-1; Fri, 07 Aug 2020 10:12:48 -0400
X-MC-Unique: _4Wtm20vPi2xsr1euBK3ZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5656B8C99E3;
        Fri,  7 Aug 2020 14:12:47 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72D4A5C1D3;
        Fri,  7 Aug 2020 14:12:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: x86: move kvm_vcpu_gfn_to_memslot() out of try_async_pf()
Date:   Fri,  7 Aug 2020 16:12:30 +0200
Message-Id: <20200807141232.402895-2-vkuznets@redhat.com>
In-Reply-To: <20200807141232.402895-1-vkuznets@redhat.com>
References: <20200807141232.402895-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended. Slot flags will need to be analyzed
prior to try_async_pf() when KVM_MEM_PCI_HOLE is implemented.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 14 ++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 862bf418214e..fef6956393f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4042,11 +4042,10 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
-static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
-			 bool *writable)
+static bool try_async_pf(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			 bool prefault, gfn_t gfn, gpa_t cr2_or_gpa,
+			 kvm_pfn_t *pfn, bool write, bool *writable)
 {
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
 
 	/* Don't expose private memslots to L2. */
@@ -4082,7 +4081,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	bool exec = error_code & PFERR_FETCH_MASK;
 	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
 	bool map_writable;
-
+	struct kvm_memory_slot *slot;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
@@ -4104,7 +4103,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+
+	if (try_async_pf(vcpu, slot, prefault, gfn, gpa, &pfn, write,
+			 &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0172a949f6a7..5c6a895f67c3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -779,6 +779,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	int write_fault = error_code & PFERR_WRITE_MASK;
 	int user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
+	struct kvm_memory_slot *slot;
 	int r;
 	kvm_pfn_t pfn;
 	unsigned long mmu_seq;
@@ -833,8 +834,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
-			 &map_writable))
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, walker.gfn);
+
+	if (try_async_pf(vcpu, slot, prefault, walker.gfn, addr, &pfn,
+			 write_fault, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
-- 
2.25.4

