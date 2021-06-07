Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143EA39D820
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhFGJE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhFGJE2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhT17Xnws4NBLPwbK/jgRnH8LXjVzbtWOEpkIxa2bDQ=;
        b=BYqK5EuvRpQNE7NgP2EsJ1/WIlr9f4BWa7G4CCmGLYbks9zHxaKzJrQMyLv2ONxe41izk+
        3zGZtCbTEbnb/QMxahyhDKL0kcJ2kGoDNkotQflDegmwnWD+Zf6WZ/4W64+4tsN1hFzuuI
        9uVZsPfICOIdYlkJI/ED1ZDrjk2NXuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-_3sukCT2MsWuNIhbWQjiLA-1; Mon, 07 Jun 2021 05:02:34 -0400
X-MC-Unique: _3sukCT2MsWuNIhbWQjiLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46F9980B71B;
        Mon,  7 Jun 2021 09:02:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0C331045E84;
        Mon,  7 Jun 2021 09:02:27 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 3/8] KVM: x86: Always load PDPTRs on CR3 load for SVM w/o NPT and a PAE guest
Date:   Mon,  7 Jun 2021 12:01:58 +0300
Message-Id: <20210607090203.133058-4-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Kill off pdptrs_changed() and instead go through the full kvm_set_cr3()
for PAE guest, even if the new CR3 is the same as the current CR3.  For
VMX, and SVM with NPT enabled, the PDPTRs are unconditionally marked as
unavailable after VM-Exit, i.e. the optimization is dead code except for
SVM without NPT.

In the unlikely scenario that anyone cares about SVM without NPT _and_ a
PAE guest, they've got bigger problems if their guest is loading the same
CR3 so frequently that the performance of kvm_set_cr3() is notable,
especially since KVM's fast PGD switching means reloading the same CR3
does not require a full rebuild.  Given that PAE and PCID are mutually
exclusive, i.e. a sync and flush are guaranteed in any case, the actual
benefits of the pdptrs_changed() optimization are marginal at best.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/x86.c              | 34 ++-------------------------------
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..83f948bdc59a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,7 +1476,6 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
-bool pdptrs_changed(struct kvm_vcpu *vcpu);
 
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..0be35c37c958 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -778,13 +778,6 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
 
-static int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-			       void *data, int offset, int len, u32 access)
-{
-	return kvm_read_guest_page_mmu(vcpu, vcpu->arch.walk_mmu, gfn,
-				       data, offset, len, access);
-}
-
 static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.reserved_gpa_bits | rsvd_bits(5, 8) | rsvd_bits(1, 2);
@@ -826,30 +819,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 }
 EXPORT_SYMBOL_GPL(load_pdptrs);
 
-bool pdptrs_changed(struct kvm_vcpu *vcpu)
-{
-	u64 pdpte[ARRAY_SIZE(vcpu->arch.walk_mmu->pdptrs)];
-	int offset;
-	gfn_t gfn;
-	int r;
-
-	if (!is_pae_paging(vcpu))
-		return false;
-
-	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
-		return true;
-
-	gfn = (kvm_read_cr3(vcpu) & 0xffffffe0ul) >> PAGE_SHIFT;
-	offset = (kvm_read_cr3(vcpu) & 0xffffffe0ul) & (PAGE_SIZE - 1);
-	r = kvm_read_nested_guest_page(vcpu, gfn, pdpte, offset, sizeof(pdpte),
-				       PFERR_USER_MASK | PFERR_WRITE_MASK);
-	if (r < 0)
-		return true;
-
-	return memcmp(pdpte, vcpu->arch.walk_mmu->pdptrs, sizeof(pdpte)) != 0;
-}
-EXPORT_SYMBOL_GPL(pdptrs_changed);
-
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
 	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
@@ -1096,7 +1065,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 #endif
 
-	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu)) {
+	/* PDPTRs are always reloaded for PAE paging. */
+	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu)) {
 		if (!skip_tlb_flush) {
 			kvm_mmu_sync_roots(vcpu);
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-- 
2.26.3

