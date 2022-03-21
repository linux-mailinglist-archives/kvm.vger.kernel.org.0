Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C3A4E34F6
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 00:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiCUXul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiCUXuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:50:39 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3AA1959FD
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:48:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id om8-20020a17090b3a8800b001c68e7ccd5fso431415pjb.9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EhaQr6cKEQxCagUKQDNvVN2gjFiU04Vf3hdo4H9ToT8=;
        b=LRu9JAlfEaGCxcxkVvhOqyuO9Ev7D/vl4Pf/RA6vqjjHKGt5GwqsGD29/SsNRpoMD2
         fzaqBDfIjsRVPD1GLxE+QKzRWJS0n4XxUBoSr0SgfbhcLhvifedWiq10enZOj+mLXHQ+
         uIGH9qwQ32EqaT4uEOGXSlhp6yOwn3Gj33YYYFc/pKC7yOOy/WFhVMeDVnDQ2cvMbkfF
         hb3iHNlf4OmvI270r6uUo5MemY+mxzcLyIhm1hoJ5pjdpKuKnycbIb5xSD9bewlJ4IEN
         c9G2fa1A6WA0dmG1BsWypEshumvmc7O7KRD84r1MQabHReWOmb8oBualQbrN55aK8vMF
         4FvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EhaQr6cKEQxCagUKQDNvVN2gjFiU04Vf3hdo4H9ToT8=;
        b=JGFWFSkZYu+COYTpOOPhTQDC0C6dJPBerUZjCqy0qIBzA3/QqNRl4A1iep/VOwpPVj
         pheTMnflVG4AUiRNosS00j9w/BnfRjoZIQxDaOctCY/cNmbRxttFbhQVwVs8sVIdUNiS
         hzn2698CuKKWOyWUvvZhS8KcR3XAX8BTO8jp/QQ4diZPVOoN7iGyR4Lp4laC/E/8bki1
         JL2cHyead8403jf4i3vLeqShnPAJ/fcFQjpqgHuskzwbjQ7Dr5z5347ofFqyHtH+awCT
         ObUv0n2DCL6yMLtCScfvLlkq+TdVNqEXkrxD/k/Abq0OiRKw4MbF1FfltQEjpcqaUsH1
         dN1g==
X-Gm-Message-State: AOAM533G09/wGfOxb0No1kt2JX4EHtdhjb9RdT6H1/UQsZcST76nkbf3
        Jnyaa0f3YxaOD26p9R2BmyJu6H7/Mdqi
X-Google-Smtp-Source: ABdhPJzMWkUMUv4rGL5tgkTUBmZPs2ef10OquxEsuGHsEHCyEwFTqMNpor1IypFOb3rlkMGnHqPOnA/DdQo/
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:90b:3e8c:b0:1c7:462c:af6b with SMTP id
 rj12-20020a17090b3e8c00b001c7462caf6bmr1691728pjb.150.1647906533585; Mon, 21
 Mar 2022 16:48:53 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:34 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-2-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 01/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
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

From: Ricardo Koller <ricarkol@google.com>

Add a library function to allocate a page-table physical page in a
particular memslot.  The default behavior is to create new page-table
pages in memslot 0.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 92cef0ffb19e..976aaaba8769 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -311,6 +311,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..11a692cf4570 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2425,9 +2425,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 /* Arbitrary minimum physical address used for virtual translation tables. */
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
 
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
+{
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+			pt_memslot);
+}
+
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_alloc_page_table_in_memslot(vm, 0);
 }
 
 /*
-- 
2.35.1.894.gb6a874cedc-goog

