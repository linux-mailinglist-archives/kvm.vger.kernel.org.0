Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8352FCBE
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355024AbiEUNRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355255AbiEUNRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:17:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE234562D8;
        Sat, 21 May 2022 06:16:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n10so10175857pjh.5;
        Sat, 21 May 2022 06:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l94TVW3wuVRtc3xT6nzOf4GkBXwrul2+5gv+PMml5Tg=;
        b=ArJqDxgtQTfe25Ba0jETZGtU+VXR9BgSH7Z04f8rxW+4bhYdzcUJYYo1EtSTaRK2Zk
         PLvf/Z3j0pJXXQz3Di7qAnGRCOypjwC0q6Nyf6PQNvuaVYv2qrh+1kgf3ortKP6LiL1f
         5sAr5bBrAhU9Rs31y2I1RML3zC7cXS9rsBoQtaD4XPRDtMCDrObumxoMtoG6ahtA7Y7Z
         0XlT4Fzemv+/PFTR7o3Lla+HC7vXXfl0WOl2sAWVZOoJyAUwM5JLZEjnHdNFav979NFh
         jxlzNHIxcUQvjDYANYeC0AVEcz/S7wlqdMnjgPAKnyj3s/upQxz2SUtDa2PAWdVF41/8
         QI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l94TVW3wuVRtc3xT6nzOf4GkBXwrul2+5gv+PMml5Tg=;
        b=w8d3xsDwnPKePV+ymzqH1BY0LO47m4qx4wgWt5eRoDd9/nGGRw5rhH6GqZtFMc4/GO
         uvC8gM+DVzyDP7krEl2AXMCsZ/DxS4pk50j45nAmOtxkuRnNlyEolSunHsdyf5+2NTY0
         Lf4cjSizJfZNdgrlPkPOr8G6D5dxiT7UfNgEMeLbpqIAeZs3H/jTwb8DtOXmd2JdEtSX
         SCCCqN8MMlUH8OvFPAQF6tQ5wArvfSLu20dGSeKABntbAp468gKyD0Cz9BBLCH5cOc2x
         Ln87UPYIOVAaRCMRR+2Xj4ftDXUPXWx66ymw85QUxWF1kieZxOStvB9E1LwFyZJ8lmOE
         Z4fg==
X-Gm-Message-State: AOAM530BrH3RFcldL/dTTfeaoazlzo+JvgFBf7cxqQG6VQq4aY7isCuL
        5A+5GyeVVoo7q9HgC16saSCAgkAVqAs=
X-Google-Smtp-Source: ABdhPJxmJvyTReInu99O+pz45PFKkztmSo6JBB2Q4B3W6dOhNsqXS6QrnFKLL4MiKOfvE6K0Eh76rg==
X-Received: by 2002:a17:902:d4d2:b0:161:b4f7:385b with SMTP id o18-20020a170902d4d200b00161b4f7385bmr14328082plg.5.1653138998291;
        Sat, 21 May 2022 06:16:38 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090a170a00b001dc1e6db7c2sm3622346pjd.57.2022.05.21.06.16.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:38 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 09/12] KVM: X86/MMU: Move the verifying of NPT's PDPTE in FNAME(fetch)
Date:   Sat, 21 May 2022 21:16:57 +0800
Message-Id: <20220521131700.3661-10-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

FNAME(page_fault) verifies PDPTE for nested NPT in PAE paging mode
because nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE from
memory unconditionally for each call.

The verifying is complicated and it works only when mmu->pae_root
is always used when the guest is PAE paging.

Move the verifying code in FNAME(fetch) and simplify it since the local
shadow page is used and it can be walked in FNAME(fetch) and unlinked
from children via drop_spte().

It also allows for mmu->pae_root NOT to be used when it is NOT required
to be put in a 32bit CR3.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 72 ++++++++++++++++------------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index cd6032e1947c..67c419bce1e5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -659,6 +659,39 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		clear_sp_write_flooding_count(it.sptep);
 		drop_large_spte(vcpu, it.sptep);
 
+		/*
+		 * When nested NPT enabled and L1 is PAE paging,
+		 * mmu->get_pdptrs() which is nested_svm_get_tdp_pdptr() reads
+		 * the guest NPT's PDPTE from memory unconditionally for each
+		 * call.
+		 *
+		 * The guest PAE root page is not write-protected.
+		 *
+		 * The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get
+		 * a value different from previous calls or different from the
+		 * return value of mmu->get_pdptrs() in mmu_alloc_shadow_roots().
+		 *
+		 * It will cause the following code installs the spte in a wrong
+		 * sp or links a sp to a wrong parent if the return value of
+		 * mmu->get_pdptrs() is not verified unchanged since
+		 * FNAME(gpte_changed) can't check this kind of change.
+		 *
+		 * Verify the return value of mmu->get_pdptrs() (only the gfn
+		 * in it needs to be checked) and drop the spte if the gfn isn't
+		 * matched.
+		 *
+		 * Do the verifying unconditionally when the guest is PAE
+		 * paging no matter whether it is nested NPT or not to avoid
+		 * complicated code.
+		 */
+		if (vcpu->arch.mmu->cpu_role.base.level == PT32E_ROOT_LEVEL &&
+		    it.level == PT32E_ROOT_LEVEL &&
+		    is_shadow_present_pte(*it.sptep)) {
+			sp = to_shadow_page(*it.sptep & PT64_BASE_ADDR_MASK);
+			if (gw->table_gfn[it.level - 2] != sp->gfn)
+				drop_spte(vcpu->kvm, it.sptep);
+		}
+
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
@@ -886,44 +919,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
-	/*
-	 * When nested NPT enabled and L1 is PAE paging, mmu->get_pdptrs()
-	 * which is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE
-	 * from memory unconditionally for each call.
-	 *
-	 * The guest PAE root page is not write-protected.
-	 *
-	 * The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get a value
-	 * different from previous calls or different from the return value of
-	 * mmu->get_pdptrs() in mmu_alloc_shadow_roots().
-	 *
-	 * It will cause FNAME(fetch) installs the spte in a wrong sp or links
-	 * a sp to a wrong parent if the return value of mmu->get_pdptrs()
-	 * is not verified unchanged since FNAME(gpte_changed) can't check
-	 * this kind of change.
-	 *
-	 * Verify the return value of mmu->get_pdptrs() (only the gfn in it
-	 * needs to be checked) and do kvm_mmu_free_roots() like load_pdptr()
-	 * if the gfn isn't matched.
-	 *
-	 * Do the verifying unconditionally when the guest is PAE paging no
-	 * matter whether it is nested NPT or not to avoid complicated code.
-	 */
-	if (vcpu->arch.mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
-		u64 pdpte = vcpu->arch.mmu->pae_root[(fault->addr >> 30) & 3];
-		struct kvm_mmu_page *sp = NULL;
-
-		if (IS_VALID_PAE_ROOT(pdpte))
-			sp = to_shadow_page(pdpte & PT64_BASE_ADDR_MASK);
-
-		if (!sp || walker.table_gfn[PT32E_ROOT_LEVEL - 2] != sp->gfn) {
-			write_unlock(&vcpu->kvm->mmu_lock);
-			kvm_mmu_free_roots(vcpu->kvm, vcpu->arch.mmu,
-					   KVM_MMU_ROOT_CURRENT);
-			goto release_clean;
-		}
-	}
-
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
@@ -931,7 +926,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-release_clean:
 	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
-- 
2.19.1.6.gb485710b

