Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F244513FF6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353762AbiD2BHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353758AbiD2BHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:47 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2301BCB42
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:30 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so3490541plh.11
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jRYQ+NLKeR4ZgpGCTvtPE0cYfeNV63Iwo0ARpwv/qPY=;
        b=JhGpL8syvU+MGBw8KnylH1ePm331NSeic9lS7Z5ZF5e7M+15hOH6EFGvCEgcioZEMz
         jeWl8tHkY81V2r9sZsrDcraO0AXwwpmpLDxEYf1zTpi6juZuuj829DVfOOYFQHVz4L78
         C5V2bnBrlGidvmXfsklJlULpLwYuTQCC/ytMTJmV8/HPrkzCywCqhpXBsIUAvyNCqS35
         vOzZySnkbujZuFi1YkM+eoQgFp8VEfEdDERdfzR5uVl2a78uZxK2RT0Don7aQA7l2lQy
         quMSePLzEiNwz7p80QqEvxyLpYH6TjUy0BPS5zExsOSBQ0WElKokq4f+b7roou2nyDfe
         68Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jRYQ+NLKeR4ZgpGCTvtPE0cYfeNV63Iwo0ARpwv/qPY=;
        b=jo/r4NGxDhkUT/xfk75HqthRWl+KFSTYgO5rMi1pKe/2JbkkCZ0lV8i49qRd+HalLO
         PTafC1MSSf2b7LGe5pkXM/jwURb9lBAVcylkDjp7gdqRZ7NXkVO5xKOi0wCRIU9uQUOs
         VPesu2Zy3w/gR8Qy8BMUrfTR8mi3vlBdfUyD6Hr6jnvbE0xJoAQWJ3PpZxBBdYiAy/l3
         0PLBTa+0kEM1wA5zvxbIK7fEMwxl/dbA10N/q2cetHGfu3mDNmGm/qXUl5+OD05mQ2vO
         op5xR4K3NNCxP9k6Br9Yz9WrddQF7+eHJBPd6Wpb4AQTcp6x8WEMnUpDlkfauXtX2FHc
         /VcA==
X-Gm-Message-State: AOAM533R9dOmqyXxOT3RnroKAwPn6ZpT++cM76+Jv/yPd1kHPbc4BgPU
        JRVM2Vgs7jw3VKRMI61UOCl6V37BcFE=
X-Google-Smtp-Source: ABdhPJzrPQf/+XtQJlw+fhpbt6qxsFNut9jsl6arSE5+6bvYrQrbs0GqX9KGmNI0vl2lemqfU/3OXErlNpw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP id
 c18-20020a056a000ad200b004f12734a3d9mr37921713pfl.61.1651194270433; Thu, 28
 Apr 2022 18:04:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:13 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 07/10] KVM: Remove kvm_vcpu_gfn_to_page() and kvm_vcpu_gpa_to_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop helpers to convert a gfn/gpa to a 'struct page' in the context of a
vCPU.  KVM doesn't require that guests be backed by 'struct page' memory,
thus any use of helpers that assume 'struct page' is bound to be flawed,
as was the case for the recently removed last user in x86's nested VMX.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  7 -------
 virt/kvm/kvm_main.c      | 35 +++++++++++++----------------------
 2 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e32fbde79298..7e59bc5ec8c7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1207,7 +1207,6 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
-struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
@@ -1695,12 +1694,6 @@ static inline hpa_t pfn_to_hpa(kvm_pfn_t pfn)
 	return (hpa_t)pfn << PAGE_SHIFT;
 }
 
-static inline struct page *kvm_vcpu_gpa_to_page(struct kvm_vcpu *vcpu,
-						gpa_t gpa)
-{
-	return kvm_vcpu_gfn_to_page(vcpu, gpa_to_gfn(gpa));
-}
-
 static inline bool kvm_is_error_gpa(struct kvm *kvm, gpa_t gpa)
 {
 	unsigned long hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a987188a426f..661390243b9e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2698,24 +2698,25 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 }
 EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
 
-static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
-{
-	if (is_error_noslot_pfn(pfn))
-		return KVM_ERR_PTR_BAD_PAGE;
-
-	if (kvm_is_reserved_pfn(pfn))
-		return KVM_ERR_PTR_BAD_PAGE;
-
-	return pfn_to_page(pfn);
-}
-
+/*
+ * Do not use this helper unless you are absolutely certain the gfn _must_ be
+ * backed by 'struct page'.  A valid example is if the backing memslot is
+ * controlled by KVM.  Note, if the returned page is valid, it's refcount has
+ * been elevated by gfn_to_pfn().
+ */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	kvm_pfn_t pfn;
 
 	pfn = gfn_to_pfn(kvm, gfn);
 
-	return kvm_pfn_to_page(pfn);
+	if (is_error_noslot_pfn(pfn))
+		return KVM_ERR_PTR_BAD_PAGE;
+
+	if (kvm_is_reserved_pfn(pfn))
+		return KVM_ERR_PTR_BAD_PAGE;
+
+	return pfn_to_page(pfn);
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
@@ -2786,16 +2787,6 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
-struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	kvm_pfn_t pfn;
-
-	pfn = kvm_vcpu_gfn_to_pfn(vcpu, gfn);
-
-	return kvm_pfn_to_page(pfn);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_page);
-
 static bool kvm_is_ad_tracked_page(struct page *page)
 {
 	/*
-- 
2.36.0.464.gb9c8b46e94-goog

