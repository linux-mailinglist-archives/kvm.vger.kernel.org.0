Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2413F6C43
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 01:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhHXXez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 19:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 19:34:55 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB86C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:34:10 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id dw5-20020a17090b094500b00192fa4319b4so1313277pjb.8
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yWR8R2JmIMpMqoJkv4npjP+FInFv3IuBJ/q2uih/I90=;
        b=RjsbJSabKpGfRebTMn4lsqy7+IlDnl4YG9MA4mlbL2vD0mTYU0nLLHqPKhZsYbB8Az
         8otqscLmQ3FVGOzDvsIZVV7UCpRf3PXNG49QZqKk22TquAC7YcBEj0p+9GZy34xWocA3
         J4r5uG8AnzS9ZfymTIGYsaHKTi+JCE1lji3KmX54L4PVUe3zXuy84URcMQQFaMPgVz02
         hwb5Y7AKxm+P5t+TsJPlUK26ax7rmbqJhWGod/wAo7NQrHGG09QVbX2m9A0dotzBDufS
         AtdlD01CWB5UgEAYsCV58mVldm8jzZmAoV0jsg9evH2+q4u6I74Vn9xJfOlbG7+0HTfG
         p9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yWR8R2JmIMpMqoJkv4npjP+FInFv3IuBJ/q2uih/I90=;
        b=XU+NHkLHNTzhptvHqopxvivBBWUVRNmguzNR0uSReTVTHMgOXN1WuJDmIiowxl37wy
         jC9aUa6QcVlZFxF5w/LLSLo9iBdYdJqpUXhOFtROtsY7OetT6gfDUAbMKrMSSEWEiqwY
         O4t5jABW43WBO0AZ3Lwi0CXjJkKc5W6cTb01HxDDTsLxAGinr5LuTda9v9MQa+RcgJM1
         wqkUFCvim43SX98QViKeAv7hZJFS1oBh9NKlp9foXo6SXVhfRcMSurzk11MfQhTtLIAK
         P8O6DUXP8GDSvTOgei8MO88XIzcyNHNMZcloU/FnHKEQS1e4BFH2gItM448x4vIbHh0Q
         /img==
X-Gm-Message-State: AOAM533jBzYMH0DnfaEU7pVbytW0J9mgtbiO/+X/HLZotzt4rxUt7H54
        JI4mY/DVwwe8fOyFDFwEyWYVoezbr2SXZw==
X-Google-Smtp-Source: ABdhPJxaPnXtZu5GIJV7X1tofhDIaKhU+1XsoWVKAtsg20c2J44LS/ZbUqmu5wfEPjgnrKYHR3TYXvmLYmqhUQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:650b:b0:137:3940:ec24 with SMTP
 id b11-20020a170902650b00b001373940ec24mr1936384plk.36.1629848049970; Tue, 24
 Aug 2021 16:34:09 -0700 (PDT)
Date:   Tue, 24 Aug 2021 23:34:07 +0000
Message-Id: <20210824233407.1845924-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: x86/mmu: Refactor slot null check in kvm_mmu_hugepage_adjust
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current code is correct but relies on is_error_noslot_pfn() to
ensure slot is not null. The only reason is_error_noslot_pfn() was
checked instead is because we did not have the slot before
commit 6574422f913e ("KVM: x86/mmu: Pass the memslot around via struct
kvm_page_fault") and looking up the memslot is expensive.

Now that the slot is available, explicitly check if it's null and
get rid of the redundant is_error_noslot_pfn() check.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..9b5424bcb173 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2925,10 +2925,10 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (unlikely(fault->max_level == PG_LEVEL_4K))
 		return;
 
-	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
+	if (!slot || kvm_slot_dirty_track_enabled(slot))
 		return;
 
-	if (kvm_slot_dirty_track_enabled(slot))
+	if (kvm_is_reserved_pfn(fault->pfn))
 		return;
 
 	/*
-- 
2.33.0.rc2.250.ged5fa647cd-goog

