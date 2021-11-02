Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4E44260C
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 04:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhKBDdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 23:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhKBDdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 23:33:07 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B91CC061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 20:30:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k9-20020a170902ba8900b00141f601d5c8so2060065pls.1
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 20:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ye4MJZGdJXUzlBLZMPQmwgLxbTVq+U0Mu9cS13H7GgM=;
        b=obILo9tAzj7cKOsaBlCFqclsjvsZ7RoG31phN/Z/um9IycoLdowXakFskImfIcOgNf
         Q0W/nbMyOpT1NCF4wV6IGgVmYs7WhJO9t8McPODG6dacnzaShQR0YtwMZ/JGC9j7GKBS
         aWvCLKzwlGjSVkp6ivlmFcUXQP4xnyXuB8rvHJxw/IvvKF5TfbkNNWnFVxm5ovjx9k/S
         exYmHD6KX38Cqy2FpLYIkNhnfeOp1COHvhq3d2hhTG47fhJMw0C1ylUiSHbIctu2VUO8
         8NqF3x/X5iWEu3LUKr/ahx+Ix9v5Tg3K73HL+7QDnjTflp8O5v5p5dcnhoU3og7Q5cZK
         cYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ye4MJZGdJXUzlBLZMPQmwgLxbTVq+U0Mu9cS13H7GgM=;
        b=ayFIAZe4aGVOav6GVN4gQ2DFSRGHe3l12WYawN9AplfwEf0VlAZ2gvUJXamYDPjBnz
         BtDh2qAmk90hcHBQHseV2OU3YB6uzmAhiuwDEow+gmgsDpSehLlCyJPZ/4e3RD5PEYSA
         hDSu7KvyYYc9XEvhdRWR8Gc8Mq4NfvVVHA4fD2XjhVa8fMqirQBJDXC1N3q5pluALidO
         UK+GZdZ5HnD7LI9KVR1YF1hg94nyyedUMFN3Y4P0aw3HF9eVj5g53Fo1vBm9SQjMdOde
         0ckk25yIbugNykcJRrOOf3Hd7IHHbEiHJv+nfKTwruWwNYayy6FfYdgiM1mVKDC3go3Z
         AG0g==
X-Gm-Message-State: AOAM533kolYdDSFPCEOL5XG+4n7C1J4LyF38LzGsGxPK/ZMr07IFzvs6
        bDu1wTLTKGMa5CkJIiMcXNl2cFUjWlQtqXGQligcSKbR2ZqSqvkWia8v2Zw9p0IulP5YSQjvzEd
        sz5hgXRpaW894S+KffNSc56A1Zq9L2K0U6DpfFy6pizHnot4tKzT8/uEJ5ZHa
X-Google-Smtp-Source: ABdhPJzdjMU/BxuZZKzeWMY/WZu60hZwNZk48KFQZB/eoBLY9k+NmLgYlFHZ3/HZg9M8hDsZyhmkW4JB+Nt8
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:32f1:5593:ece6:4f8c])
 (user=junaids job=sendgmr) by 2002:a05:6a00:2ad:b0:480:fae5:2693 with SMTP id
 q13-20020a056a0002ad00b00480fae52693mr15683081pfs.37.1635823832347; Mon, 01
 Nov 2021 20:30:32 -0700 (PDT)
Date:   Mon,  1 Nov 2021 20:29:00 -0700
Message-Id: <20211102032900.1888262-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH] kvm: mmu: Use fast PF path for access tracking of huge pages
 when possible
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
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..5df9181c5082 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3191,8 +3191,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
@@ -3201,7 +3202,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			 *
 			 * See the comments in kvm_arch_commit_memory_region().
 			 */
-			if (sp->role.level > PG_LEVEL_4K)
+			if (sp->role.level > PG_LEVEL_4K &&
+			    kvm_slot_dirty_track_enabled(fault->slot))
 				break;
 		}
 
-- 
2.33.1.1089.g2158813163f-goog

