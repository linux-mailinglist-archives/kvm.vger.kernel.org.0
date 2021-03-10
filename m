Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9545433325C
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 01:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhCJAai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 19:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhCJAad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 19:30:33 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5645BC06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 16:30:33 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id e10so11453315qvr.17
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 16:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ZbG3xZb8PBQgiaDoQSCf4y5RYRarcXuHOWtQzEo4Lp4=;
        b=us2FvwuKuUsnKtfzXb/jE9ZyNfz3iRwsk6KoFEfxEIznNEhIADvJky2H+nPDcHEZR/
         vll9/s0EeGTtsOotd350+EnFp+LlDw9a7VzG7Yzup0s7mN88cuVzSHHDWewX+PXJC3U0
         +WhZREu1Dw2O+ti0oRCiF+/PyGn5LBENAwy9wXS7g2VW4IVqT7PkYnyNeJ9A4YmGpCAC
         Ritx82nsW4Kpi/W6N1Sv557L3+x2JRRz6SkRU2WNSl6xG87d717YIRdK0HDQZlmj2MqU
         Hgs1pijsHPN8P3gS1o5ylJOoC4vYeIW/w+qjmVjrPzce/+GcqTGt3dqS0Qlao7bGwccb
         S2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ZbG3xZb8PBQgiaDoQSCf4y5RYRarcXuHOWtQzEo4Lp4=;
        b=judCnNUA5jrEPUvnnPsathWTiPtgn83W+aO0rXozTEK8QuramftkBQ295rrRnLiUNu
         wkxWsJI9M5XMzbzXL2wkmsYV/Tj3d5V4qBhZP1buR64PCk+t3HhvVElcV1OO9jSoxV2n
         r4d95sT0eoKGoUFQN/nvuR6FDBBMs9LgWJi+Zn/dyca2GcekYIwM01myzQIvxRBoKb/M
         H6638L73dvOWdPPQF5QkhcSe/uQ9ie+Zskts5BuspKliSYGSWE+s2kY/1u1Cra74D7id
         P/BOV7bt4soM+HI+vYf/Idj/mvLDKO+e/YInD+raSY/pP/FaAIDNeePNRVTG0SMgYS26
         T4rQ==
X-Gm-Message-State: AOAM533lYxazTmL7Nu+FN3b6WcOyv/5u2+Y2766RW/NqK2+L2OCIY/7T
        KXEJr22y6b4JK/PS/fVU/gzWKdHfRWU=
X-Google-Smtp-Source: ABdhPJz8JBsJ6DNuTmV245LAf4RiHcBxMThlSVNRRXuyrUb6m0zifQoo7EXUCGWd67jnrZzuYtZf609dG5c=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
 (user=seanjc job=sendgmr) by 2002:a0c:b71a:: with SMTP id t26mr558668qvd.38.1615336232507;
 Tue, 09 Mar 2021 16:30:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 16:30:29 -0800
Message-Id: <20210310003029.1250571-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] KVM: x86/mmu: Skip !MMU-present SPTEs when removing SP in
 exclusive mode
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

If mmu_lock is held for write, don't bother setting !PRESENT SPTEs to
REMOVED_SPTE when recursively zapping SPTEs as part of shadow page
removal.  The concurrent write protections provided by REMOVED_SPTE are
not needed, there are no backing page side effects to record, and MMIO
SPTEs can be left as is since they are protected by the memslot
generation, not by ensuring that the MMIO SPTE is unreachable (which
is racy with respect to lockless walks regardless of zapping behavior).

Skipping !PRESENT drastically reduces the number of updates needed to
tear down sparsely populated MMUs, e.g. when tearing down a 6gb VM that
didn't touch much memory, 6929/7168 (~96.6%) of SPTEs were '0' and could
be skipped.

Avoiding the write itself is likely close to a wash, but avoiding
__handle_changed_spte() is a clear-cut win as that involves saving and
restoring all non-volatile GPRs (it's a subtly big function), as well as
several conditional branches before bailing out.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 50ef757c5586..f0c99fa04ef2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -323,7 +323,18 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
 				cpu_relax();
 			}
 		} else {
+			/*
+			 * If the SPTE is not MMU-present, there is no backing
+			 * page associated with the SPTE and so no side effects
+			 * that need to be recorded, and exclusive ownership of
+			 * mmu_lock ensures the SPTE can't be made present.
+			 * Note, zapping MMIO SPTEs is also unnecessary as they
+			 * are guarded by the memslots generation, not by being
+			 * unreachable.
+			 */
 			old_child_spte = READ_ONCE(*sptep);
+			if (!is_shadow_present_pte(old_child_spte))
+				continue;
 
 			/*
 			 * Marking the SPTE as a removed SPTE is not
-- 
2.30.1.766.gb4fecdf3b7-goog

