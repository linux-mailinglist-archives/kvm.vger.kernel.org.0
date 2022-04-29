Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF92514003
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353786AbiD2BHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353752AbiD2BHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B96BC878
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v9-20020a17090a7c0900b001cb45f88cdcso3331456pjf.0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LY2u2lqaDdU2rtmG5LcPIqbe73WGn22NYde+95hPItE=;
        b=cWLe21WPmchYvaVevotbm3RK57IRXwWPlljEv2giie3TBWz2Dy8eZ8j5HhoeRKHAq3
         tppq79T1ifh2IfAZ3zdBVjqbioSc54vePGtsAJYJLrQ3YGxKKkqXfOAeb8Z6AVevPDzZ
         Wk+OXjGSXGZ/Pnv4zueW4U1FusGST5oBLlP9xX1UUce1el75F2HiEa6lphM4K0Ja4EAh
         9ew+AFPQIpc2IAvgleeicESpsX/Fx9DE9AUes9it8ggC6ewQk57KmSZ0Qf/opTzAoj9S
         oh5CRIZ85IoRKgKMy9ivtUhxEK5KddmdSo3GyGpWc8LhgfIrbrkoYSay1gtYG/1Jp+GK
         xB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LY2u2lqaDdU2rtmG5LcPIqbe73WGn22NYde+95hPItE=;
        b=v8F0/+L3HGISdoNuj4TZlIq4r72IYx26jOhYRalPvatyj6LuhsSVtZnXWOvelqarzs
         Xp3F6ZorcrWCUmn8zNDgmRq6dpMxzknaY3jthejnAy4paLqZV9FIZx4FmI5tZ1VlnQ2B
         xLSa4IkrJ04jXg/9WRDzlaWTNeivEe9NVlf9CskI/F/LaML3sZ/R5QoevXPQEjpaiqOC
         NhuqtXRiZu9LG8+P2N02KXi7rclzVziiK2fuqX8XbYD8/Q5jSKaJIRmZIy/ETacVXrz+
         Bk7267WBq9+sYCjvGHULhx+YPMamk4syT9z2Q60epC0LaxN8i4KFvnY7MjjPMsRYnmph
         9Akw==
X-Gm-Message-State: AOAM533OSE8nNe9NLmIeWzwpmvkTjUmxi8ZS5iuSGLL924RA5ZleKOYY
        npCFBn1/z9st01pdnW1KS1cEqQOBE2k=
X-Google-Smtp-Source: ABdhPJzp5bseGEB5+5vqVGWm2HOpRA28amMeej102P4Z1OOptaZUyUaPxYLudkctFqNfk0NQ1rlfb/KXAJk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a58d:b0:1db:ed34:e46d with SMTP id
 b13-20020a17090aa58d00b001dbed34e46dmr1146636pjq.124.1651194272182; Thu, 28
 Apr 2022 18:04:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:14 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 08/10] KVM: Take a 'struct page', not a pfn in kvm_is_zone_device_page()
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

Operate on a 'struct page' instead of a pfn when checking if a page is a
ZONE_DEVICE page, and rename the helper accordingly.  Generally speaking,
KVM doesn't actually care about ZONE_DEVICE memory, i.e. shouldn't do
anything special for ZONE_DEVICE memory.  Rather, KVM wants to treat
ZONE_DEVICE memory like regular memory, and the need to identify
ZONE_DEVICE memory only arises as an exception to PG_reserved pages. In
other words, KVM should only ever check for ZONE_DEVICE memory after KVM
has already verified that there is a struct page associated with the pfn.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 3 ++-
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 8 ++++----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 904f0faff218..5cf1436adecd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2821,11 +2821,12 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  const struct kvm_memory_slot *slot)
 {
+	struct page *page = pfn_to_page(pfn);
 	unsigned long hva;
 	pte_t *pte;
 	int level;
 
-	if (!PageCompound(pfn_to_page(pfn)) && !kvm_is_zone_device_pfn(pfn))
+	if (!PageCompound(page) && !kvm_is_zone_device_page(page))
 		return PG_LEVEL_4K;
 
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e59bc5ec8c7..4ccc309a43f2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1548,7 +1548,7 @@ void kvm_arch_sync_events(struct kvm *kvm);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
-bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
+bool kvm_is_zone_device_page(struct page *page);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 661390243b9e..cbc6d58081d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -164,7 +164,7 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
-bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
+bool kvm_is_zone_device_page(struct page *page)
 {
 	/*
 	 * The metadata used by is_zone_device_page() to determine whether or
@@ -172,10 +172,10 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
 	 * page_count() is zero to help detect bad usage of this helper.
 	 */
-	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
+	if (WARN_ON_ONCE(!page_count(page)))
 		return false;
 
-	return is_zone_device_page(pfn_to_page(pfn));
+	return is_zone_device_page(page);
 }
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
@@ -188,7 +188,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 	if (pfn_valid(pfn))
 		return PageReserved(pfn_to_page(pfn)) &&
 		       !is_zero_pfn(pfn) &&
-		       !kvm_is_zone_device_pfn(pfn);
+		       !kvm_is_zone_device_page(pfn_to_page(pfn));
 
 	return true;
 }
-- 
2.36.0.464.gb9c8b46e94-goog

