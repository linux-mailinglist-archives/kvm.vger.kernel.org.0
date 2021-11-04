Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F3A444CA2
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhKDAgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhKDAgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:36:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197F5C06120A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:34:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g36-20020a25ae64000000b005c1f46f7ee6so6393976ybe.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=70PiLzmA7ox44qCXyRrZgqr9sV1MO+32uzvR0pDHqiM=;
        b=MQnFxn3zvjzlOlEgDeF34DtlBLic5gTwYERVnYw/QGQ5Aib5S9G73CYdM9ziPIgmyM
         txAPvKLIheB1WLYzUGvHNpfF0iq2q9QXbxQHJncld95bLg0uYx1hA2rYh/cXmsW2xXxL
         cnliz/H3noUbEzb+vAI7/0U9yR2LGP6vXdD6Jc3Dggsicx6wUtx3GmwjRBiIIZHs2VwI
         +uq9T/334lyh1GIXBCy/IHXLdQcZpFBkkCxUZP1JhePNPdvoMa5P4DPfSMqJL4TL255J
         lfGS11GOxoL2+LrYRPtJqpDahwUHMwpg2yd97XT7oygrQz49yKXTYD2zDGi/VzJvStUI
         6N/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=70PiLzmA7ox44qCXyRrZgqr9sV1MO+32uzvR0pDHqiM=;
        b=wKCxyRRfv0GfcUukMrBIHVY2zNu2rG0gA7kDIChAAD+6WRrnhpMa+8qg5bggcDOo79
         dJb384IEAcQQ8/FQ4YTLKxFUyPZFa5JI4GKbL9oqRimGZ637wVMfUPX5xvHETGto8b4i
         tfwyuTQF+0GsL2pxBrk5i7tPJi3yEIx33Tnnp6wB4ZNAhsJjLX00xCMPT7Jf3wIPG9ir
         8l5dcD+xU7i38ioGlmn/S4AZP7ZElA6lPoNG4t3bVPT79iGL+m/TcFU1XUv8Rzt8pU40
         MVTR4SeOo50K7U0QNDZm8cVBAO7TAgHn8DbXloLWHjzhj00FQcp1DfEofFcGgU0Ylqca
         xPxA==
X-Gm-Message-State: AOAM5310s+8pLOsrA4jTioPE6fAtMhB0ZY8uCOGl3Lfd725DtDiGnJig
        vph5xGwQl6uiFuHEkSxh9Rqp0VGmt9budhGff61ESi987V8CMb0Bo3Sy5dTyUwHaYzv4kHH/YGX
        tm81kz4FrEA5WCiuyR+B047pe3JvzSF3mf77f6br4csl3eE/AvIRNlQXQ3V6X
X-Google-Smtp-Source: ABdhPJxtMvym8qubxWVRk8j2dc3T5SYxkJkHkWtqZVS6uc5Mo2rBkFxnCri7+9SNo+ud0d9cVsc/SRmx1m4M
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:47a:193a:6575:2692])
 (user=junaids job=sendgmr) by 2002:a25:37ce:: with SMTP id
 e197mr53231627yba.485.1635986048289; Wed, 03 Nov 2021 17:34:08 -0700 (PDT)
Date:   Wed,  3 Nov 2021 17:33:59 -0700
Message-Id: <20211104003359.2201967-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2] kvm: mmu: Use fast PF path for access tracking of huge
 pages when possible
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The fast page fault path bails out on write faults to huge pages in
order to accommodate dirty logging. This change adds a check to do that
only when dirty logging is actually enabled, so that access tracking for
huge pages can still use the fast path for write faults in the common
case.

Signed-off-by: Junaid Shahid <junaids@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
v2:
 - Removed a stale comment

 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..04c00c34517e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3191,17 +3191,17 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			new_spte |= PT_WRITABLE_MASK;
 
 			/*
-			 * Do not fix write-permission on the large spte.  Since
-			 * we only dirty the first page into the dirty-bitmap in
+			 * Do not fix write-permission on the large spte when
+			 * dirty logging is enabled. Since we only dirty the
+			 * first page into the dirty-bitmap in
 			 * fast_pf_fix_direct_spte(), other pages are missed
 			 * if its slot has dirty logging enabled.
 			 *
 			 * Instead, we let the slow page fault path create a
 			 * normal spte to fix the access.
-			 *
-			 * See the comments in kvm_arch_commit_memory_region().
 			 */
-			if (sp->role.level > PG_LEVEL_4K)
+			if (sp->role.level > PG_LEVEL_4K &&
+			    kvm_slot_dirty_track_enabled(fault->slot))
 				break;
 		}
 
-- 
2.33.1.1089.g2158813163f-goog

