Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C458141BE41
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 06:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhI2Ebm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 00:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244098AbhI2Ebb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 00:31:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1588AC061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 21:29:51 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y5so650436pll.3
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bA6NN/73uMxgRf2do26zZix4NIbIajvF9h0MlhypsP0=;
        b=D0DhDCankrqgNpGj/wZQ1bIG5lFpI686lVV9x5x7cV5N+TTyY6WG29/QP3px1+RW2E
         qkDXyIM7HJuu7S2dzfC6MbZIJyGpSQFXEArdEgLZLzeDhs9Fxl+nCbS+mIb+M1NN/nsX
         2IiV0ctP8MYuEYzwCB0TW+zCzwm3c2ngkt59k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bA6NN/73uMxgRf2do26zZix4NIbIajvF9h0MlhypsP0=;
        b=B0pBq3WSH98/PpxAW9dNmooYq/wVa+28T6zBG/ZR5U3AWpDYbLkHAIPLQdTzb4xjAx
         YOnuYI/P0gBsMrYicL9yvEvdjwXOAQ5QT4UgjfxbH6BZjRBo7ExmWwzznHVqMB8JPVWw
         pIkmc8CbHLNu5FJDQ9nd+CTq4hPKwzkfUfwKFcOffbo0Y0jJCHNxqCvXdr+ek1iXVf6r
         VRVez8V83w2qnEggCSZ0ROIsJ0mvqO6OXK8FQFikrhHwxuPUAbweOjQTZ2RlHxOoO13D
         Eq02MnpBxqje5cZGisLoWkNnayYudzPEY+NG4PRmro2p9CgwrtEtLX37htv9RrL2G+Gl
         6OdA==
X-Gm-Message-State: AOAM530YrxmJLZCQzqyNpowmRD9Di0uqbaMU5wjknmnjCVG1b+UImyAO
        ChFrNuCy+G3AffwyELNg2vLPWQ==
X-Google-Smtp-Source: ABdhPJxDITqPEpm4RXGmxbl4ubLf862UOuk9hpD6Czqg5k8tUb7xT3tmlnO8vUsHmwXIgQt1huUhKw==
X-Received: by 2002:a17:90a:f98f:: with SMTP id cq15mr4146513pjb.74.1632889790661;
        Tue, 28 Sep 2021 21:29:50 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:f818:368:93ef:fa36])
        by smtp.gmail.com with UTF8SMTPSA id c206sm652324pfc.220.2021.09.28.21.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 21:29:50 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v4 4/4] KVM: mmu: remove over-aggressive warnings
Date:   Wed, 29 Sep 2021 13:29:08 +0900
Message-Id: <20210929042908.1313874-5-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929042908.1313874-1-stevensd@google.com>
References: <20210929042908.1313874-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Remove two warnings that require ref counts for pages to be non-zero, as
mapped pfns from follow_pfn may not have an initialized ref count.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c | 7 -------
 virt/kvm/kvm_main.c    | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a1adcc9cfbc..3b469df63bcf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -617,13 +617,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
 	pfn = spte_to_pfn(old_spte);
 
-	/*
-	 * KVM does not hold the refcount of the page used by
-	 * kvm mmu, before reclaiming the page, we should
-	 * unmap it from mmu first.
-	 */
-	WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
-
 	if (is_accessed_spte(old_spte))
 		kvm_set_pfn_accessed(pfn);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 421146bd1360..c72ad995a359 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -168,7 +168,7 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 	 * the device has been pinned, e.g. by get_user_pages().  WARN if the
 	 * page_count() is zero to help detect bad usage of this helper.
 	 */
-	if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
+	if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))
 		return false;
 
 	return is_zone_device_page(pfn_to_page(pfn));
-- 
2.33.0.685.g46640cef36-goog

