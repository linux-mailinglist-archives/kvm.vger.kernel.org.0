Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5361E52FCB7
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354788AbiEUNQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbiEUNQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:10 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5401415828;
        Sat, 21 May 2022 06:16:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v10so9897058pgl.11;
        Sat, 21 May 2022 06:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DgSyS9XK30Wn2a59vfUdW42Ng9nYaYeSTtI+jsDbNeo=;
        b=Hu1eRAuRnh1/exlWZ0YyzqwKhPXSe8MMICiwbdZtrBIrNHTxszx0B8WSd+m67RskFk
         uoIPtuMzYB/gThSkU78UWPN6IR6suz8JpUr9tMk/1gXu5/1uBjNyB15wRNLmeHbHiC87
         2CIeTBEzHRntodLy7OKK6FF2LRijsa0dpU2oathg3tae7PqClObaAP7plsINq2VXKK9o
         9ywwfiPkPqt32boUyRndxi1abMtjal/3qS6dhMLQ8aEXr+GjErA47uV63RmNONY8eKVH
         tOFuAI7aNcIPPOEUGKs9bGFm8uj5kqM3bb7UwS1tMtR7jyBCqA5FJ9DENMf9j9vuF3pG
         dxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DgSyS9XK30Wn2a59vfUdW42Ng9nYaYeSTtI+jsDbNeo=;
        b=dGdgqvhJKfI0uzJO5R7vF0NHJx6fHeXbDLTI1lP+8fs3+UrI1PmLW3xq/pJJcam1r8
         L1j5Qui29mz+WQoUTjoJUbXLST7fq97xFG6D7f0WDYAM3JZN+Axla072ncVx8tJXR7/u
         TTs8+RPrM0geY/U0oc+2Cw3scw8gjanmReasrBbR5c54evUzYGx43LZ5X2G3OANGn99G
         uYGdWYphY/sxJgEXxIk0lJS1PWVjsVPLmFlGKRRRnnm7xcITYaIr/DohUTTEFrIp2I5g
         sxl4QFxfOtaHgWJNpW747Q8c1dr5+6b8969P3eIiHgrRt2j2ovXYLwDk6G1RDErzAmTa
         u33A==
X-Gm-Message-State: AOAM532ypx1A7G4+MrDtKUdkiMPIqB2/4V8hIuOH4oBxjfzLySuVUvFV
        Sav+OywITqD4t5cKVuvfRP1iWhY0ulU=
X-Google-Smtp-Source: ABdhPJyT3QUA6GDPJ7iewGaeV9mmg2L8XHzSl996cM3sUuf23iWfuIz2I9iqPIRcgf9DaivO33IhAQ==
X-Received: by 2002:a63:d054:0:b0:3f2:50df:e008 with SMTP id s20-20020a63d054000000b003f250dfe008mr12656668pgi.317.1653138968692;
        Sat, 21 May 2022 06:16:08 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id g3-20020a1709026b4300b0016211344809sm511203plt.72.2022.05.21.06.16.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:08 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 01/12] KVM: X86/MMU: Verify PDPTE for nested NPT in PAE paging mode when page fault
Date:   Sat, 21 May 2022 21:16:49 +0800
Message-Id: <20220521131700.3661-2-jiangshanlai@gmail.com>
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

When nested NPT enabled and L1 is PAE paging, mmu->get_pdptrs()
which is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE
from memory unconditionally for each call.

The guest PAE root page is not write-protected.

The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get a value
different from previous calls or different from the return value of
mmu->get_pdptrs() in mmu_alloc_shadow_roots().

It will cause FNAME(fetch) installs the spte in a wrong sp or links
a sp to a wrong parent if the return value of mmu->get_pdptrs()
is not verified unchanged since FNAME(gpte_changed) can't check
this kind of change.

Verify the return value of mmu->get_pdptrs() (only the gfn in it
needs to be checked) and do kvm_mmu_free_roots() like load_pdptr()
if the gfn isn't matched.

Do the verifying unconditionally when the guest is PAE paging no
matter whether it is nested NPT or not to avoid complicated code.

The commit e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE
from guest memory") fixs the same problem for non-nested case via
caching the PDPTEs which is also the same way as how hardware caches
the PDPTEs.

Under SVM, however, when the processor is in guest mode with PAE
enabled, the guest PDPTE entries are not cached or validated at this
point, but instead are loaded and checked on demand in the normal course
of address translation, just like page directory and page table entries.
Any reserved bit violations are detected at the point of use, and result
in a page-fault (#PF) exception rather than a general-protection (#GP)
exception.

So using caches can not fix the problem for shadowing nested NPT for
32bit L1.

Fixes: e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE from guest memory")
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index db80f7ccaa4e..6e3df84e8455 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -870,6 +870,44 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault, mmu_seq))
 		goto out_unlock;
 
+	/*
+	 * When nested NPT enabled and L1 is PAE paging, mmu->get_pdptrs()
+	 * which is nested_svm_get_tdp_pdptr() reads the guest NPT's PDPTE
+	 * from memory unconditionally for each call.
+	 *
+	 * The guest PAE root page is not write-protected.
+	 *
+	 * The mmu->get_pdptrs() in FNAME(walk_addr_generic) might get a value
+	 * different from previous calls or different from the return value of
+	 * mmu->get_pdptrs() in mmu_alloc_shadow_roots().
+	 *
+	 * It will cause FNAME(fetch) installs the spte in a wrong sp or links
+	 * a sp to a wrong parent if the return value of mmu->get_pdptrs()
+	 * is not verified unchanged since FNAME(gpte_changed) can't check
+	 * this kind of change.
+	 *
+	 * Verify the return value of mmu->get_pdptrs() (only the gfn in it
+	 * needs to be checked) and do kvm_mmu_free_roots() like load_pdptr()
+	 * if the gfn isn't matched.
+	 *
+	 * Do the verifying unconditionally when the guest is PAE paging no
+	 * matter whether it is nested NPT or not to avoid complicated code.
+	 */
+	if (vcpu->arch.mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
+		u64 pdpte = vcpu->arch.mmu->pae_root[(fault->addr >> 30) & 3];
+		struct kvm_mmu_page *sp = NULL;
+
+		if (IS_VALID_PAE_ROOT(pdpte))
+			sp = to_shadow_page(pdpte & PT64_BASE_ADDR_MASK);
+
+		if (!sp || walker.table_gfn[PT32E_ROOT_LEVEL - 2] != sp->gfn) {
+			write_unlock(&vcpu->kvm->mmu_lock);
+			kvm_mmu_free_roots(vcpu->kvm, vcpu->arch.mmu,
+					   KVM_MMU_ROOT_CURRENT);
+			goto release_clean;
+		}
+	}
+
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
@@ -877,6 +915,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
+release_clean:
 	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
-- 
2.19.1.6.gb485710b

