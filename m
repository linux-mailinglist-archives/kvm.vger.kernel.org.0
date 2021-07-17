Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE93CC24B
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 11:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhGQJ7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jul 2021 05:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhGQJ7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jul 2021 05:59:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 365016115A;
        Sat, 17 Jul 2021 09:56:12 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m4h3K-00DvkH-Go; Sat, 17 Jul 2021 10:56:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 5/5] KVM: Get rid of kvm_get_pfn()
Date:   Sat, 17 Jul 2021 10:55:41 +0100
Message-Id: <20210717095541.1486210-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210717095541.1486210-1-maz@kernel.org>
References: <20210717095541.1486210-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com, willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nobody is using kvm_get_pfn() anymore. Get rid of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..9818d271c2a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -824,7 +824,6 @@ void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
-void kvm_get_pfn(kvm_pfn_t pfn);
 
 void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e410a8a6a67..0284418c4400 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2215,7 +2215,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Get a reference here because callers of *hva_to_pfn* and
 	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
 	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_get_pfn/kvm_release_pfn_clean pair will
+	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
 	 * simply do nothing for reserved pfns.
 	 *
 	 * Whoever called remap_pfn_range is also going to call e.g.
@@ -2612,13 +2612,6 @@ void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
-void kvm_get_pfn(kvm_pfn_t pfn)
-{
-	if (!kvm_is_reserved_pfn(pfn))
-		get_page(pfn_to_page(pfn));
-}
-EXPORT_SYMBOL_GPL(kvm_get_pfn);
-
 static int next_segment(unsigned long len, int offset)
 {
 	if (len > PAGE_SIZE - offset)
-- 
2.30.2

