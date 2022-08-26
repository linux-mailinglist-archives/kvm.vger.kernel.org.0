Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47655A3267
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345443AbiHZXMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345433AbiHZXMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE54E9A9B
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33e1114437fso47203077b3.19
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=ZdVaRkEUTVQaIKJDT/Ddx7gK3/urPJpcKKVV/+iYZKk=;
        b=baz/ChvqaA1ic/giek/4j38FjrCjwyfUIdIepPFprrdCeLvp8yEh6JkYWW49DK3M7C
         cp9S9eruQAdJLXMCSm47CFIVOMGBT6rjZ7SdU1liU4t8QVcPPRJ7+6zWILg/6yFThQR+
         s99AjJN1qnr9sp/+0say2Cg1YI/CFuxC+8O+qOSjG0sepSkl29DjMc8wCqjYojIi09IV
         R2qpqlBjuquno+1mWai8ZWsluUZBQF0cCscGMKpUZBIEnfRLG0N0BStxNsCTfxZdaN55
         Ma669WJHagR3AoxlT4AA3HErdIF8+f+Rz4cLW72U61oIqdsPe3wcRL1AgofZsVBLqAu+
         Go+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ZdVaRkEUTVQaIKJDT/Ddx7gK3/urPJpcKKVV/+iYZKk=;
        b=hSPCh9rQnU2huOhtjaclzDPBWA6GN4C/n8SzIuExWTE3Ag4BNNefAY6m54+KrzNxJ+
         ubEl6U5Ug4K3/BBn5djC8PUKuv0Q3URjpC5FtHzu7uhfpsM+34dhezGpaa4OYra0a4DF
         H5KFG1AE7p7LHTm+eykBXT/qUWYjpcPnQaV2Ox2YJ1ZYWz6lYUN6oQzSeq0J1LFnzibq
         W3UPZ6qZXMnwI0Sejo3q0SlUSaPW62M0bPF12776niIQwSLMdNayBjW3NtjKu8WVmDEI
         s7WumYhvuuSTEr4UQqpl0ySmc39LbqlqFMJ58KTEj6cklBSHAoiBbB+JsiP4tVGDPEpP
         EyBw==
X-Gm-Message-State: ACgBeo1fkheYf3uicE2ofDfH+D5eNbLkfClNjcbj0JoI2t2CHNbxKdXt
        oKdEX2MR9IoD4agTzX+uOVWT6cuOLy4mEw==
X-Google-Smtp-Source: AA6agR7rHVGOeSA3/FNrEeO0s8W3z+dkxeb3bte6aN2PALIH3udZnZ2Pw7ShkuwEFl5arnEFIIUY6I3ulllwTA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:790:0:b0:671:5d18:3a3 with SMTP id
 b16-20020a5b0790000000b006715d1803a3mr1801788ybq.169.1661555561261; Fri, 26
 Aug 2022 16:12:41 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:22 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-6-dmatlack@google.com>
Subject: [PATCH v2 05/10] KVM: x86/mmu: Avoid memslot lookup during
 KVM_PFN_ERR_HWPOISON handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the kvm_page_fault struct down to kvm_handle_error_pfn() to avoid a
memslot lookup when handling KVM_PFN_ERR_HWPOISON. Opportunistically
move the gfn_to_hva_memslot() call and @current down into
kvm_send_hwpoison_signal() to cut down on line lengths.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 273e1771965c..fb30451f4b47 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3139,23 +3139,25 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
-static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *tsk)
+static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
+	unsigned long hva = gfn_to_hva_memslot(slot, gfn);
+
+	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);
 }
 
-static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
 {
 	/*
 	 * Do not cache the mmio info caused by writing the readonly gfn
 	 * into the spte otherwise read access on readonly gfn also can
 	 * caused mmio page fault and treat it as mmio access.
 	 */
-	if (pfn == KVM_PFN_ERR_RO_FAULT)
+	if (fault->pfn == KVM_PFN_ERR_RO_FAULT)
 		return RET_PF_EMULATE;
 
-	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(kvm_vcpu_gfn_to_hva(vcpu, gfn), current);
+	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
+		kvm_send_hwpoison_signal(fault->slot, fault->gfn);
 		return RET_PF_RETRY;
 	}
 
@@ -4197,7 +4199,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return ret;
 
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+		return kvm_handle_error_pfn(fault);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.37.2.672.g94769d06f0-goog

