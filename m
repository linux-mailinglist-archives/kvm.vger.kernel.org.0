Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F051D3A20FD
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFIXqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:46:05 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:40763 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhFIXqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:46:02 -0400
Received: by mail-yb1-f201.google.com with SMTP id 67-20020a2514460000b029053a9edba2a6so33544623ybu.7
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=InBM03qDuJbydmZqwKqzqlUqaOkn74aCL0GR1gl20pw=;
        b=OK+CIFOEMmoa4Kw3KkKINDvQzlgD8gX0zYTY8FBWyC46kD/n+9gxplMvqumOjgY1CE
         Wo5O/YldyO4iNeEpEb7uNc9k6P6jNei2jjK0Qii28yktq7sUHNQGuFqOHg6RkNOVFaKu
         E5RD1Pca5/CZxyWCI6bI1u10LwqNiMOQP4D0GqDcBIHq/AOUg+aIFWJeu+Hw+3J3DZi2
         YWgzA/y5SeMn3aPXL/3xID0uh/w9hF1HyaK6TIKKLjNS23UYqlWLBGjkxbOylGUEuHX1
         IerVw+DBVdvOkBghKaf9PTu/hgzzdtjnDoADh+g8++2oqHVt37xIdX5+TF2JPTt1L7bL
         VwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=InBM03qDuJbydmZqwKqzqlUqaOkn74aCL0GR1gl20pw=;
        b=r6ew572mS9ZWwc5nOb4RayrUVVqS9CEM69q5cFygesmt9YqdTbvygbczXvAIfhpVwf
         BeW0QGNirp/Ahh0f3JxtzY/o+TPht9WV4XgjHMBCGM+DoQb5LJ6IGwK7jSo8V3SKhtCn
         SfmR1L/DPThTncNTzB+IlPjtXUq0uatuE6gkOHQBNajJo0+rSjvEHLrwTcrlUiL5ItRz
         agS5KrNYfD190Ht4/Gh2wmIWiTGj5GDs9PsiWCoEdklCic28K3N7uJsv7LJ+26qiDX5H
         3bzrJWsNo5KI9IcRwGz/CE7i29h8HvDFDlwMtXPW9pC/1lCpnGENvM8b9vBAPdjIT9WS
         rWgw==
X-Gm-Message-State: AOAM533UkdH0rU0y/8LTPl7SyJyZ4DDFo0a7ahl3EjfElD5tQPOpGD9/
        stPuskyQqcy+O2nSdcWqSQBpiZi5+zk=
X-Google-Smtp-Source: ABdhPJwGy0x6e/I2p/w7EqDxykx8RTBdU/hpX+eMYgqPqRSpSwFjGlBUKKapmirqU2vewWECZ2SoYSpawm0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a25:8709:: with SMTP id a9mr3770356ybl.395.1623282171518;
 Wed, 09 Jun 2021 16:42:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:24 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 04/15] KVM: x86: Invalidate all PGDs for the current PCID on
 MOV CR3 w/ flush
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flush and sync all PGDs for the current/target PCID on MOV CR3 with a
TLB flush, i.e. without PCID_NOFLUSH set.  Paraphrasing Intel's SDM
regarding the behavior of MOV to CR3:

  - If CR4.PCIDE = 0, invalidates all TLB entries associated with PCID
    000H and all entries in all paging-structure caches associated with
    PCID 000H.

  - If CR4.PCIDE = 1 and NOFLUSH=0, invalidates all TLB entries
    associated with the PCID specified in bits 11:0, and all entries in
    all paging-structure caches associated with that PCID. It is not
    required to invalidate entries in the TLBs and paging-structure
    caches that are associated with other PCIDs.

  - If CR4.PCIDE=1 and NOFLUSH=1, is not required to invalidate any TLB
    entries or entries in paging-structure caches.

Extract and reuse the logic for INVPCID(single) which is effectively the
same flow and works even if CR4.PCIDE=0, as the current PCID will be '0'
in that case, thus honoring the requirement of flushing PCID=0.

Continue passing skip_tlb_flush to kvm_mmu_new_pgd() even though it
_should_ be redundant; the clean up will be done in a future patch.  The
overhead of an unnecessary nop sync is minimal (especially compared to
the actual sync), and the TLB flush is handled via request.  Avoiding the
the negligible overhead is not worth the risk of breaking kernels that
backport the fix.

Fixes: 956bf3531fba ("kvm: x86: Skip shadow page resync on CR3 switch when indicated by guest")
Cc: Junaid Shahid <junaids@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 69 ++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 905de6854efa..e2f6d6a1ba54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1084,25 +1084,45 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
+static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
+{
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	unsigned long roots_to_free = 0;
+	int i;
+
+	/*
+	 * If neither the current CR3 nor any of the prev_roots use the given
+	 * PCID, then nothing needs to be done here because a resync will
+	 * happen anyway before switching to any other CR3.
+	 */
+	if (kvm_get_active_pcid(vcpu) == pcid) {
+		kvm_mmu_sync_roots(vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		if (kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd) == pcid)
+			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+
+	kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
+}
+
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
+	unsigned long pcid = 0;
 #ifdef CONFIG_X86_64
 	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
 
 	if (pcid_enabled) {
 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
 		cr3 &= ~X86_CR3_PCID_NOFLUSH;
+		pcid = cr3 & X86_CR3_PCID_MASK;
 	}
 #endif
 
-	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu)) {
-		if (!skip_tlb_flush) {
-			kvm_mmu_sync_roots(vcpu);
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
-		return 0;
-	}
+	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu))
+		goto handle_tlb_flush;
 
 	/*
 	 * Do not condition the GPA check on long mode, this helper is used to
@@ -1115,10 +1135,23 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
-	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
+	if (cr3 != kvm_read_cr3(vcpu))
+		kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
+
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
+handle_tlb_flush:
+	/*
+	 * A load of CR3 that flushes the TLB flushes only the current PCID,
+	 * even if PCID is disabled, in which case PCID=0 is flushed.  It's a
+	 * moot point in the end because _disabling_ PCID will flush all PCIDs,
+	 * and it's impossible to use a non-zero PCID when PCID is disabled,
+	 * i.e. only PCID=0 can be relevant.
+	 */
+	if (!skip_tlb_flush)
+		kvm_invalidate_pcid(vcpu, pcid);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr3);
@@ -11697,8 +11730,6 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 {
 	bool pcid_enabled;
 	struct x86_exception e;
-	unsigned i;
-	unsigned long roots_to_free = 0;
 	struct {
 		u64 pcid;
 		u64 gla;
@@ -11732,23 +11763,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 			return 1;
 		}
 
-		if (kvm_get_active_pcid(vcpu) == operand.pcid) {
-			kvm_mmu_sync_roots(vcpu);
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
-
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if (kvm_get_pcid(vcpu, vcpu->arch.mmu->prev_roots[i].pgd)
-			    == operand.pcid)
-				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
-
-		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, roots_to_free);
-		/*
-		 * If neither the current cr3 nor any of the prev_roots use the
-		 * given PCID, then nothing needs to be done here because a
-		 * resync will happen anyway before switching to any other CR3.
-		 */
-
+		kvm_invalidate_pcid(vcpu, operand.pcid);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	case INVPCID_TYPE_ALL_NON_GLOBAL:
-- 
2.32.0.rc1.229.g3e70b5a671-goog

