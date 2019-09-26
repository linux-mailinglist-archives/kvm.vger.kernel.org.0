Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEF9BFBC4
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfIZXSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:33 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:52515 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbfIZXSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:33 -0400
Received: by mail-pg1-f202.google.com with SMTP id e15so2326678pgh.19
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=alYv85ii0NvD8Sm9RlADJhYZlkGEwPi7fJVO0bq7mE4=;
        b=rRxWbiIGWuKCDnOnrQgNuGDQ1dAML0d2NmjR5iKWK7B93mEcRc1Tj+yJCGbD6CvUIj
         kgMTjzIoqTppKcHJoGi1XjLCw+Qj5RM7H9uCOj2g1jgYW6OZjp/TYreghsYizY4df3qh
         8HRRGQjCiJ6i0RY1hNkC2VdOuUX7NFn2hNTtoWb6GaTxVZmiWqvlvkf+scXpdJVnMQBB
         X1fQvoIC6P0hO2gYxAgq23X+pVJRPLfaX/HxCO+aP8p608LB3FRTApL4UQsyrrDCi1Lt
         KJEXRxGpeo1aNX/d6dVHu7dq35eXaGl6v4ek3mcVyTG47USG9j4RQNlfRajts/ZarqCk
         Ihog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=alYv85ii0NvD8Sm9RlADJhYZlkGEwPi7fJVO0bq7mE4=;
        b=URk3pKsZ+R7h7VQagwnLoC2oyBUX3abSLdJ69/aY821aPBxbDyfU7+Nj5m6rIBDBe7
         cgaUszQ9qwOTf3cUkqxRq9c6yLGijmJgi6qLyft/ZOoaX9oi5+Ns6miHjsilSqH5wNKt
         s7XAlWjcwCOsPEc4VgvSyLFGnVhC4tzm7ynYcTkGqh1EQBt0luRcwAhcHbcqXOJUnYPH
         y9pGnzM5ThhFAHtsjDaFHhu/tVFF7TJspF1JVbS6JxGpFjXMJB5jeip/9UStGUNY9iNh
         gRBdSX+Cbeyp7FkaVwM1q0yICDQZKBrDCSZLt6R5rIZS2hlD9f4t1FazpI9fba2/JJoe
         ThBQ==
X-Gm-Message-State: APjAAAVnimH8gN4TlaOrRtrmkFsgiPAObGq5je/muL+JBjYLdLIRIhrl
        li/hA8+7XC9O4USdebAdtgBJVFcFZ/wiQyY+b0endvrBZJ6rv6wbRjmWD6IdB4pGk5tby+s6Kxb
        3gwyrp+K1d0pozNkk/pSnFdEnMl8EK5E2Cr1Z1FwsmS2nnTfbmXEv3f4LIqYr
X-Google-Smtp-Source: APXvYqz4p2Iqb5w9GNKy/8Bg8ZBnbKuEpeDJF9FdRqkqMLI+OO5b7Fey5zsyzazLhJW9r/pjWhp2uXBbQGA3
X-Received: by 2002:a65:678a:: with SMTP id e10mr6134185pgr.184.1569539910571;
 Thu, 26 Sep 2019 16:18:30 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:17:57 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-2-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 01/28] kvm: mmu: Separate generating and setting mmio ptes
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the functions for generating MMIO page table entries from the
function that inserts them into the paging structure. This refactoring
will allow changes to the MMU sychronization model to use atomic
compare / exchanges (which are not guaranteed to succeed) instead of a
monolithic MMU lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5269aa057dfa6..781c2ca7455e3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -390,8 +390,7 @@ static u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
-			   unsigned access)
+static u64 generate_mmio_pte(struct kvm_vcpu *vcpu, u64 gfn, unsigned access)
 {
 	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
 	u64 mask = generation_mmio_spte_mask(gen);
@@ -403,6 +402,17 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< shadow_nonpresent_or_rsvd_mask_len;
 
+	return mask;
+}
+
+static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
+			   unsigned access)
+{
+	u64 mask = generate_mmio_pte(vcpu, gfn, access);
+	unsigned int gen = get_mmio_spte_generation(mask);
+
+	access = mask & ACC_ALL;
+
 	trace_mark_mmio_spte(sptep, gfn, access, gen);
 	mmu_spte_set(sptep, mask);
 }
-- 
2.23.0.444.g18eeb5a265-goog

