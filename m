Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E9B6D7149
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbjDEAbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbjDEAbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:31:42 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20D444A2
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:31:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id cp21-20020a17090afb9500b0023c061f2bd0so16460035pjb.5
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680654700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QhmadyCW7rZ0IkiRTP5OSx3MvkvEXJ8KKkSyEhLJ39I=;
        b=TjPY9E34iEfwYFaF5STVJtPZRBXPRvz5M/6M3FOVwwDlCAT+skmp6E4KUcFo2kC5Hu
         ESlOwxOIJZ+AwqvwQMPhdUdsgqIyevhBDskiSNXbSRDq/u1OBDUHF6ASpnEVfLI4N3+N
         pHZRQJML+PNb7zf4uLE3Q7dpvrJJYAfzFfa0QbKcQx6BrNCCXnXsQm/JsLHzbGASSxRe
         wZYOH2Zm4q+zVn3QI2GB+hjjaI8H45hFSc8jwNf3wvSzgMQM/Yjwxk5ES7/yWGqsfCP1
         Nn7QeImq972HTDSQRx33gpzp+2JpUGTNBSATvuEScKz5/xred2TKdLfPNPILCI5OkQ4X
         v+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680654700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhmadyCW7rZ0IkiRTP5OSx3MvkvEXJ8KKkSyEhLJ39I=;
        b=Ni7KjF0TTYdxJRZRMcVAC8Z+X6Cy8vh919IgA7K1oe6Wv7jsyQP51gAkzGm5QK89kS
         aAzM61Ji5rFIP96wy0XFXqelG5geULj+dX2cxB/lVrnHhDlwnjpscHnaV9sxPs9YYh/w
         mN4cmSWG5RyWXJFNRgOiNKgxGzp4mCJvkzyf0xBs1of3V+fXcfbKvJmfpQPWuNDnRqtS
         OCOFc4G9hMc+NtLMYQOq4G7IHyYGZY2fs8AKp+4D9nn5O/qIM693dvRCYcD1l9Dz8SU7
         4DVnoquFzuAZfzWIGMTka9nL5XPgOn1dSJfUeYuu/yguJ99Sxdh2FfaUp+qo6CK61rGi
         mgag==
X-Gm-Message-State: AAQBX9erNVNi4tyFUt8qwkAa3deYc25Lvtvo0z30+fm7uLNeG8U6f6/C
        IAjUO2m5vss1YKk1m2sij5cicMPZf6U=
X-Google-Smtp-Source: AKy350ZRhkvVvcfVPJZNFICm5BlfTqckFjlCgk5lnKdeEMpLC+LvRw7dm4CTlKyK0lwXS/mzLak/k+CCUD8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:46c1:b0:23f:a851:4f04 with SMTP id
 jx1-20020a17090b46c100b0023fa8514f04mr1644915pjb.3.1680654700461; Tue, 04 Apr
 2023 17:31:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:31:33 -0700
In-Reply-To: <20230405003133.419177-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405003133.419177-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405003133.419177-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Move filling of Hyper-V's TLB range struct
 into Hyper-V code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor Hyper-V's range-based TLB flushing API to take a gfn+nr_pages
pair instead of a struct, and bury said struct in Hyper-V specific code.

Passing along two params generates much better code for the common case
where KVM is _not_ running on Hyper-V, as forwarding the flush on to
Hyper-V's hv_flush_remote_tlbs_range() from kvm_flush_remote_tlbs_range()
becomes a tail call.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ++-------
 arch/x86/kvm/kvm_onhyperv.c     | 24 ++++++++++++++++++++----
 arch/x86/kvm/kvm_onhyperv.h     |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  8 ++------
 4 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec22101410ee..09eb37853cb1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -482,11 +482,6 @@ struct kvm_mmu {
 	u64 pdptrs[4]; /* pae */
 };
 
-struct kvm_tlb_range {
-	u64 start_gfn;
-	u64 pages;
-};
-
 enum pmc_type {
 	KVM_PMC_GP = 0,
 	KVM_PMC_FIXED,
@@ -1589,8 +1584,8 @@ struct kvm_x86_ops {
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
 	int  (*flush_remote_tlbs)(struct kvm *kvm);
-	int  (*flush_remote_tlbs_range)(struct kvm *kvm,
-					struct kvm_tlb_range *range);
+	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
+					gfn_t nr_pages);
 
 	/*
 	 * Flush any TLB entries associated with the given GVA.
diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index 2e2d08da8a3f..ded0bd688c65 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -10,17 +10,22 @@
 #include "hyperv.h"
 #include "kvm_onhyperv.h"
 
+struct kvm_hv_tlb_range {
+	u64 start_gfn;
+	u64 pages;
+};
+
 static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
 		void *data)
 {
-	struct kvm_tlb_range *range = data;
+	struct kvm_hv_tlb_range *range = data;
 
 	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
 			range->pages);
 }
 
 static inline int hv_remote_flush_root_tdp(hpa_t root_tdp,
-					   struct kvm_tlb_range *range)
+					   struct kvm_hv_tlb_range *range)
 {
 	if (range)
 		return hyperv_flush_guest_mapping_range(root_tdp,
@@ -29,7 +34,8 @@ static inline int hv_remote_flush_root_tdp(hpa_t root_tdp,
 		return hyperv_flush_guest_mapping(root_tdp);
 }
 
-int hv_flush_remote_tlbs_range(struct kvm *kvm, struct kvm_tlb_range *range)
+static int __hv_flush_remote_tlbs_range(struct kvm *kvm,
+					struct kvm_hv_tlb_range *range)
 {
 	struct kvm_arch *kvm_arch = &kvm->arch;
 	struct kvm_vcpu *vcpu;
@@ -85,11 +91,21 @@ int hv_flush_remote_tlbs_range(struct kvm *kvm, struct kvm_tlb_range *range)
 	spin_unlock(&kvm_arch->hv_root_tdp_lock);
 	return ret;
 }
+
+int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, gfn_t nr_pages)
+{
+	struct kvm_hv_tlb_range range = {
+		.start_gfn = start_gfn,
+		.pages = nr_pages,
+	};
+
+	return __hv_flush_remote_tlbs_range(kvm, &range);
+}
 EXPORT_SYMBOL_GPL(hv_flush_remote_tlbs_range);
 
 int hv_flush_remote_tlbs(struct kvm *kvm)
 {
-	return hv_flush_remote_tlbs_range(kvm, NULL);
+	return __hv_flush_remote_tlbs_range(kvm, NULL);
 }
 EXPORT_SYMBOL_GPL(hv_flush_remote_tlbs);
 
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 55d7fcb84cc1..ff127d313242 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -7,7 +7,7 @@
 #define __ARCH_X86_KVM_KVM_ONHYPERV_H__
 
 #if IS_ENABLED(CONFIG_HYPERV)
-int hv_flush_remote_tlbs_range(struct kvm *kvm, struct kvm_tlb_range *range);
+int hv_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, gfn_t nr_pages);
 int hv_flush_remote_tlbs(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7654be48ff69..a7adbac0855c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -278,15 +278,11 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
 				 gfn_t nr_pages)
 {
-	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
 
-	range.start_gfn = start_gfn;
-	range.pages = nr_pages;
-
 	if (kvm_x86_ops.flush_remote_tlbs_range)
-		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, &range);
-
+		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
+								   nr_pages);
 	if (ret)
 		kvm_flush_remote_tlbs(kvm);
 }
-- 
2.40.0.348.gf938b09366-goog

