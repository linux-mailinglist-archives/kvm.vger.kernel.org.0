Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C7931A913
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhBMAxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhBMAws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:48 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F11C0611BC
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v17so1539718ybq.9
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RgRHrMHpc3mAabRpLEPGgNZ/Y1mqc6HXCjmCsxUVhP0=;
        b=LGW4AnCqosd83PWIGeb5tY9knVOICydIEuP7XSipaBkqC6BBGDxe0SLoOcNH8NU4TL
         hEcYwRMQyFOtUTkY891A/JRUcbcc2EqqODo+4P5Mk4ByApDC7bewFyyAoBsTwgI1ARZY
         dNaAqq1bsK6RotAueD+dNa0+k/2rzzCpH/vs2GTszN+X9ROF7/b/55ea14sQs58Latty
         j/0Ozkwr1okWzg8v2qy5QwUFNAJzOEsm7ue1FU/+L1JtmitKPzfHJNl1QXIxikbzUqIv
         OSXDyQ11ELOCM5l8qHvhv8zdKHpGQCzgq1RAbSrmdRncMCsfA6hjbUDsEl/m8THfF01k
         FtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RgRHrMHpc3mAabRpLEPGgNZ/Y1mqc6HXCjmCsxUVhP0=;
        b=eTOWBfdaezun6plfpkn092zmm4T+i6leFPn388Tea4S/umVwjjzL1yHKqz6pcHLPnJ
         UVPb/f2NVJNJNWBEu5oYGU415wqxoYxtkX2C5cSKBjWwkLw6Dzo3K6g2lTfyYLoIxNle
         RsanE7YQgiRYlfybBpPT8iKb+HW5n+iZ1MajHb2JQygfiVgNQl9UmW1zY6Yr8gRnq1j4
         JafmfeuRJ8lxBKDB4mFC+9pZvFSIKj6ZW/7N5XT8ZJzPLi/3RCVAx8X1EZ/QW8uv8Ttv
         eDD0wHWxHWgOydQlud8yZjZcMTJTHS1tP0JaABXiWhSQNvOnfPlfjY2EOOrYNjHVrOPX
         MuBQ==
X-Gm-Message-State: AOAM530wGJFQCSqZU06ieVTlclckFBA9sIVwevkxT3WyKwmMPodnKmOb
        7BjgFzYln9FKFaY+98+ZiSfrZMr1K0E=
X-Google-Smtp-Source: ABdhPJxLOkH5Z7C2Gw9z1cCsrM4sF2G2OQMItCYQ3W6+OEd8alqx1gK/2aBeWdVihs3Gm++kp3akl3FutLY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:c407:: with SMTP id u7mr7528207ybf.449.1613177454236;
 Fri, 12 Feb 2021 16:50:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:15 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-15-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 14/14] KVM: x86/mmu: Remove a variety of unnecessary exports
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove several exports from the MMU that are no longer necessary.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 35 ++++++++++++++-------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c15d6de8c457..0cf71ff2b2e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1592,7 +1592,6 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6ad0fb1913c6..30e9b0cb9abd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2466,7 +2466,21 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
+
+static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	gpa_t gpa;
+	int r;
+
+	if (vcpu->arch.mmu->direct_map)
+		return 0;
+
+	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
+
+	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+
+	return r;
+}
 
 static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
@@ -3411,7 +3425,6 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gpa_t vaddr,
 				  u32 access, struct x86_exception *exception)
@@ -4977,22 +4990,6 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
-{
-	gpa_t gpa;
-	int r;
-
-	if (vcpu->arch.mmu->direct_map)
-		return 0;
-
-	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
-
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-
-	return r;
-}
-EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
-
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
@@ -5091,7 +5088,6 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		mmu->invlpg(vcpu, gva, root_hpa);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
@@ -5131,7 +5127,6 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	 * for them.
 	 */
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
 		       int tdp_huge_page_level)
-- 
2.30.0.478.g8a0d178c01-goog

