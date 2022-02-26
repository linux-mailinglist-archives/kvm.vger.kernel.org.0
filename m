Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D153C4C527A
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240250AbiBZAQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbiBZAQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:42 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5EE223217
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:08 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id v127-20020a622f85000000b004f3dfd386e8so974690pfv.16
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1LwlOnokaTZ070XNVC9qwt/b9mpGNAxjLSfPQpUGhzg=;
        b=QsEqpFIthDCOl+CW8X6crKs61Os+2aEmwyiqRUlI/TlvRi59OYvHUqW1xn12sx6TVB
         737oQCm+hfLDVRTd2EOV0rFDNcHYhX9QzNSaO/IBh/uazLWPCWVojkHoxp05AVNZ1OTT
         n2uwJVBotnOsITVbELerw/16BFamFz+QmMJZEgoW0f/Y95Aoofqfm4hvmSsp8CH3grGC
         7LV2OMHiPwHrnKaPuEUdsjLKK9EIPHTQvcbQ85epOW+obRncKRQToDjsCF6h/+pLc5Wh
         AMV+VJsmzBWE6J9f4CgntUBYnQKp8iCBRWEZ+O8kd8IsYbLfbqLilQfTCOrVQVvQxffz
         /x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1LwlOnokaTZ070XNVC9qwt/b9mpGNAxjLSfPQpUGhzg=;
        b=oGcI0ZhAwDCCSAaSapT88xpGrruj9vpuSw4hCcPb7TTlQQKlR5qeDKJjuL8rec/kw8
         orL4w50c8FRjIQI4AtpG8NHtTMJcKEd2TXIywy5CSiaUEyEq3bfo/lLf1KyEK49ugAbX
         y8zKrHg85tGZ+/tt/Jo/F+f0hAlLesz6nUwro+yY+B65J0GfUiRVlnL0tb2YwjHz03Wq
         g8e8fRd7UK1JrGjjlf8Xeg3KFWciNMUR9XPTF+Fg2UABPejXhXItaZe2MWOh1T27limm
         vfWP/lO8L2vluPO+NYdttk6NC7ET1u2bNnkevMMKA4CXcFQIJPoBX+F9WY+XRN6/c7Cg
         JgeA==
X-Gm-Message-State: AOAM530H4WNRdjE9VWHAIHagRpMnkp9adikiNhCSnkK5+vJeh4A9fj3E
        DXFTIebhQD54qB7hCY9QvtYUWnrnVRo=
X-Google-Smtp-Source: ABdhPJzVf+Iyo3hR1ZTnjDaOKvm9FKY4DHDhSBKkXQndAg3+GsOOkeZ67NqLYNm7sq1hJeioUCFCZeKk2z8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:148f:b0:4bc:fb2d:4b6f with SMTP id
 v15-20020a056a00148f00b004bcfb2d4b6fmr10113984pfu.62.1645834568211; Fri, 25
 Feb 2022 16:16:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:22 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 04/28] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly ignore the result of zap_gfn_range() when putting the last
reference to a TDP MMU root, and add a pile of comments to formalize the
TDP MMU's behavior of deferring TLB flushes to alloc/reuse.  Note, this
only affects the !shared case, as zap_gfn_range() subtly never returns
true for "flush" as the flush is handled by tdp_mmu_zap_spte_atomic().

Putting the root without a flush is ok because even if there are stale
references to the root in the TLB, they are unreachable because KVM will
not run the guest with the same ASID without first flushing (where ASID
in this context refers to both SVM's explicit ASID and Intel's implicit
ASID that is constructed from VPID+PCID+EPT4A+etc...).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 ++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 80607513a1f2..5a931c89d27b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5069,6 +5069,14 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	kvm_mmu_sync_roots(vcpu);
 
 	kvm_mmu_load_pgd(vcpu);
+
+	/*
+	 * Flush any TLB entries for the new root, the provenance of the root
+	 * is unknown.  In theory, even if KVM ensures there are no stale TLB
+	 * entries for a freed root, in theory, an out-of-tree hypervisor could
+	 * have left stale entries.  Flushing on alloc also allows KVM to skip
+	 * the TLB flush when freeing a root (see kvm_tdp_mmu_put_root()).
+	 */
 	static_call(kvm_x86_flush_tlb_current)(vcpu);
 out:
 	return r;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 12866113fb4f..e35bd88d92fd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
+	/*
+	 * A TLB flush is not necessary as KVM performs a local TLB flush when
+	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
+	 * to a different pCPU.  Note, the local TLB flush on reuse also
+	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
+	 * intermediate paging structures, that may be zapped, as such entries
+	 * are associated with the ASID on both VMX and SVM.
+	 */
+	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
-- 
2.35.1.574.g5d30c73bfb-goog

