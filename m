Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83D6325B1A
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 02:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZBEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 20:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhBZBEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 20:04:16 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ED2C061786
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:36 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a63so8411999yba.2
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 17:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BZaWszN/LLBzcU94c/xowczYk0Zi91gjd6GZk09bLp8=;
        b=Tqbg9PdKVSAx0v9v1M+vUle/2MQJ9wjgId2EgtMTB3GOHfGzXZbdf4Ua4weJGSWKcU
         tcZXuhEBfMr9X7+A+v0/93pFy0mx+Ta5ntmHwHIn8e9k6a0s9V/nYJQ6I3QTMZS9Hdp7
         VQpgETaIivseKcse3lEd2M4Rhg3nMs9FGnzqlHw3wZtkFWQRam41xDYf3XTQJ63bdmkO
         uyWXD8yL3cEWfIOy/hD7gW9HCXw9xZjSd7P526xFqENKjPP0JLFOXsgrDNeV1lJokQrI
         0wIVcXzKHdx3cW/hvn4e83cCKQVAzdtPu0Q0eiUBWLRc0xWMfO3jP9aUonNOUqW0bpqF
         cOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BZaWszN/LLBzcU94c/xowczYk0Zi91gjd6GZk09bLp8=;
        b=gE9qL4elOcsgHkqJoQkkGdOWltzT6Bde5Pqk+JTKtpLENv5D1T1ktn2uCq3xjfNGe0
         Okbl3QwG4B15HpVJmLYau9i9cBT02WUbqhBf1b/xEOolE8SL7bWeT/Bv4EoA1ijeMicl
         TQBeptOGHZMCwUX7TVj741uPKpHXuFU3yDESzw/WHzdDpY/sNAO7S68PSVgH4cfdKUeF
         lDBAaGZLnxlKqmhSSsj/p7VskHl/igKHxQjTQbUdm8G+q+9vCUe+nPDaU3bSQn4WThoZ
         v9kIG0f1PzR4GidW/GWqsGoxlP44u7pE3AOgXDAfBwOA22yg6re8uuo1d/QrWU114N7K
         kqLw==
X-Gm-Message-State: AOAM5311VS802ibS32rfVxS2OsTlTkiJ1sxqamnuobrK3KzLoh/ApFHe
        f8Ao/zxA14eazV0+ayFixZVsa2vyafA=
X-Google-Smtp-Source: ABdhPJzLd/OexlxhpNoqN6h4X4CVKwl6YHyGAR57H9qGFlrTHD2sD39ekg0Z+DEZAKW+a9hlzCBbwk2piJM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:d314:: with SMTP id e20mr814723ybf.155.1614301415676;
 Thu, 25 Feb 2021 17:03:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 17:03:25 -0800
In-Reply-To: <20210226010329.1766033-1-seanjc@google.com>
Message-Id: <20210226010329.1766033-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210226010329.1766033-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 1/5] KVM: x86/mmu: Remove spurious TLB flush from TDP MMU's
 change_pte() hook
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove an unnecessary remote TLB flush from set_tdp_spte(), the TDP MMu's
hook for handling change_pte() invocations from the MMU notifier.  If
the new host PTE is writable, the flush is completely redundant as there
are no futher changes to the SPTE before the post-loop flush.  If the
host PTE is read-only, then the primary MMU is responsible for ensuring
that the contents of the old and new pages are identical, thus it's safe
to let the guest continue reading both the old and new pages.  KVM must
only ensure the old page cannot be referenced after returning from its
callback; this is handled by the post-loop flush.

Fixes: 1d8dd6b3f12b ("kvm: x86/mmu: Support changed pte notifier in tdp MMU")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c926c6b899a1..3290e53fb850 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1044,10 +1044,14 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 		if (!is_shadow_present_pte(iter.old_spte))
 			break;
 
+		/*
+		 * Note, when changing a read-only SPTE, it's not strictly
+		 * necessary to zero the SPTE before setting the new PFN, but
+		 * doing so preserves the invariant that the PFN of a present
+		 * leaf SPTE can never change.  See __handle_changed_spte().
+		 */
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		kvm_flush_remote_tlbs_with_address(kvm, iter.gfn, 1);
-
 		if (!pte_write(*ptep)) {
 			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
 					iter.old_spte, new_pfn);
-- 
2.30.1.766.gb4fecdf3b7-goog

