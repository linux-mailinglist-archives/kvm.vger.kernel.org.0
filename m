Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8FF5C055A
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiIURgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiIURgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B550A286C
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l72-20020a63914b000000b00434ac6f8214so3797360pge.13
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=59+B9TDT/gIROCNhGrod21Ny9r8atdEwg98pahDNmvs=;
        b=JXjYJEPL2haF3Dyco6hklLcIaAtU3LX2tSWPXkyuuUJ8A953BygfoinB1unBlKh4Gs
         rKz+phQyqrGFPT448c4ffKGXIu3wZYnRk8lAXa3ZR7KR49i0MrbLcRAlZyp9N4agaKO5
         m4q6GeoAZyCc0GMcnhMWF3lnawsBsvYllY1r++tW3fQshug/7FBCT6pometAtunuc+2z
         Sh6qh1n4rrpB1s6hEZEjqFkfrkCRff01GtciMj1U4um6J38NzkoNFodFQr7mPQ/LnYC/
         3ExCjHqXOZdKK40UXKJpUcVVE14UwK9EnZK9/GX0YXTN/kTUwD0mrItDCPyPMQMIiSRS
         uwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=59+B9TDT/gIROCNhGrod21Ny9r8atdEwg98pahDNmvs=;
        b=vy4aeFJ1LL2WUK3weREoOf84i68NT5tDX8Nn6WuKVb/K4wHkz/s+ITcGRn2Wn//4oU
         s6nDXyv/XaC2oIhdK8iWwUzXXY6K2OzsOssxpq4w7cbiDHWBrRavnZyyZjk3p6h1jceZ
         nfnmSxm60LrLWMb2G0Sdvg/4QWfPx1IX/RYi5ZbnkaEIBDb/dvZvWQKXVOAWZVEI5vtJ
         Hv5XXkREkT6pUVlV5F2mG9oC4f1f6NWoNyKAyoKRBRh+faK/vfDx17tSP3MO/TUnp6g6
         aLg9RvDAObFwGsbJgvhY/fDpnj92PxoaX8TW6bGWqkzoHwP5Q3W3UN3n6p9QOhCv35wq
         9xjA==
X-Gm-Message-State: ACrzQf0BDvLVmc6jtL1738AxrxPoFoTMGNqfXBu11Vz62wNNiTj6Dkgc
        wuTEuCpKAGXTFNquDzoH+v3LIXur6859Ow==
X-Google-Smtp-Source: AMsMyM5aGmEC1bXhq9ElUQRIPpPaZe7VRvlm9bPw9WOKyArG4lkzYyKCFa5zZjO2U+rxUXRIEiKY650dUY2/vw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr813740pjz.1.1663781759985; Wed, 21 Sep
 2022 10:35:59 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:41 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-6-dmatlack@google.com>
Subject: [PATCH v3 05/10] KVM: x86/mmu: Avoid memslot lookup during
 KVM_PFN_ERR_HWPOISON handling
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 49a5e38ecc5c..b6f84e470677 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3136,23 +3136,25 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
 
@@ -4193,7 +4195,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return ret;
 
 	if (unlikely(is_error_pfn(fault->pfn)))
-		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
+		return kvm_handle_error_pfn(fault);
 
 	return RET_PF_CONTINUE;
 }
-- 
2.37.3.998.g577e59143f-goog

