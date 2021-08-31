Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8123FCBB5
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 18:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbhHaQnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 12:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240598AbhHaQn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 12:43:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2C9C061760
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:42:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n202-20020a25d6d3000000b005991fd2f912so3776781ybg.20
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=m6ppgzPHX5FTwFdMfEcjDUXpHiFMBtjECxUlkSmxAlA=;
        b=OWa7d9lu++qCSEI/ayjmog6B6Cjl+s5Y5f/cBVkFStNUsXgsOJ6G7JSggAlwVtAXNH
         ZS/+7CPgHz18M/0+aqyxQWHD3BzoPw4edtO/r4Hbjs81l09xD9btnLljhH0CKDyjLdCa
         HvPExGzDFkeq1bIlm88NNufwx0rVnZRM4R2KO6xGVxvdZtQUPeebvy3hzWCIan6B3iw6
         ZHJ11IQAeTBGW3vQpNXE/BcL1ugLLfqbPny6yxw+voygIaabuB5LeLiXxD8JxkM9Jtw/
         zDeZoOJto7WsGXsyMvTpUg7TqL+jJZm74ohdEUrgc9QfbEjapU7lCgQ1nT5Fh/iDjbp0
         35/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=m6ppgzPHX5FTwFdMfEcjDUXpHiFMBtjECxUlkSmxAlA=;
        b=W78Jv5Ne+SRfHXfiBX8gKMaPDeWScH0s4C70QcjBWjyqi6JIs9SWE3F2eYiSXcbUfp
         i09aaE8DsomGyXrlc8WxRsItBXoxgS8MKcNdIrwrmgJFaEhQbw6NyzIhXcT33rOsjrBW
         TVevFaL7045hgdGacdX4w1o9a1GlTYu2gpjLQwzf25VBa685wgV04WNHfEUmTCckbqgn
         6dyatR1GCHsDIyCvHO+v6nFQTfYFnlfZsWrcMMWX8VQtsr0XfaMvQMltsUhtMCohg1x6
         7j2ZMg+WhBUEcJY59OHG4f8eZ4frkelA+Z3dddWVeZTKVhx8cz+Z3cBUSJabaeoTjr/D
         nyQA==
X-Gm-Message-State: AOAM5338I+7g6G+BVJI7VFUJSWk8wYNMpElY5cGb4lOolvTqdxmMTGf4
        6ej40n3SocfQxKCfdkuc0DllpSwo6Co=
X-Google-Smtp-Source: ABdhPJx9yLzJZJ4UoFcp4y62YQWbMPEH/tyAk+TIU0N7Q+QB/7xWMV/D/F87uTMucr4658tPA1WxCatY0qA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ddbd:588d:571:702a])
 (user=seanjc job=sendgmr) by 2002:a25:61d6:: with SMTP id v205mr3447536ybb.262.1630428152476;
 Tue, 31 Aug 2021 09:42:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 31 Aug 2021 09:42:23 -0700
In-Reply-To: <20210831164224.1119728-1-seanjc@google.com>
Message-Id: <20210831164224.1119728-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210831164224.1119728-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 2/3] KVM: x86: Subsume nested GPA read helper into load_pdptrs()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Open code the call to mmu->translate_gpa() when loading nested PDPTRs and
kill off the existing helper, kvm_read_guest_page_mmu(), to discourage
incorrect use.  Reading guest memory straight from an L2 GPA is extremely
rare (as evidenced by the lack of users), as very few constructs in x86
specify physical addresses, even fewer are virtualized by KVM, and even
fewer yet require emulation of L2 by L0 KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 --
 arch/x86/kvm/x86.c              | 56 +++++++++++----------------------
 2 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..ec26a929b94b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1703,9 +1703,6 @@ void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
-int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gfn_t gfn, void *data, int offset, int len,
-			    u32 access);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..8bd76698be52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -790,30 +790,6 @@ bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 }
 EXPORT_SYMBOL_GPL(kvm_require_dr);
 
-/*
- * This function will be used to read from the physical memory of the currently
- * running guest. The difference to kvm_vcpu_read_guest_page is that this function
- * can read from guest physical or from the guest's guest physical memory.
- */
-int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gfn_t ngfn, void *data, int offset, int len,
-			    u32 access)
-{
-	struct x86_exception exception;
-	gfn_t real_gfn;
-	gpa_t ngpa;
-
-	ngpa     = gfn_to_gpa(ngfn);
-	real_gfn = mmu->translate_gpa(vcpu, ngpa, access, &exception);
-	if (real_gfn == UNMAPPED_GVA)
-		return -EFAULT;
-
-	real_gfn = gpa_to_gfn(real_gfn);
-
-	return kvm_vcpu_read_guest_page(vcpu, real_gfn, data, offset, len);
-}
-EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
-
 static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.reserved_gpa_bits | rsvd_bits(5, 8) | rsvd_bits(1, 2);
@@ -825,34 +801,38 @@ static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 {
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
-	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
+	unsigned offset = (((cr3 & (PAGE_SIZE-1)) >> 5) << 2) * sizeof(u64);
+	gpa_t real_gpa;
 	int i;
 	int ret;
 	u64 pdpte[ARRAY_SIZE(mmu->pdptrs)];
 
-	ret = kvm_read_guest_page_mmu(vcpu, mmu, pdpt_gfn, pdpte,
-				      offset * sizeof(u64), sizeof(pdpte),
-				      PFERR_USER_MASK|PFERR_WRITE_MASK);
-	if (ret < 0) {
-		ret = 0;
-		goto out;
-	}
+	/*
+	 * If the MMU is nested, CR3 holds an L2 GPA and needs to be translated
+	 * to an L1 GPA.
+	 */
+	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(pdpt_gfn),
+				      PFERR_USER_MASK | PFERR_WRITE_MASK, NULL);
+	if (real_gpa == UNMAPPED_GVA)
+		return 0;
+
+	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(real_gpa), pdpte,
+				       offset, sizeof(pdpte));
+	if (ret < 0)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
 		if ((pdpte[i] & PT_PRESENT_MASK) &&
 		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
-			ret = 0;
-			goto out;
+			return 0;
 		}
 	}
-	ret = 1;
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 	vcpu->arch.pdptrs_from_userspace = false;
 
-out:
-
-	return ret;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(load_pdptrs);
 
-- 
2.33.0.259.gc128427fd7-goog

