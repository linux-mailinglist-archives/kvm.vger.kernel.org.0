Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B219B3AFDCA
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFVH1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhFVH1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 03:27:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42228C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:24:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v134-20020a37618c0000b02902fa5329f2b4so2519383qkb.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=BD4lpbPgIYJoxQKzEzU6bqCGaw9muIxLDsW7Q3v9h6k=;
        b=esL8Wgp1T4BxTy0TqGV+jDA5F57PodHBxA6bFbaWmKGQPwRDwaBqhB0QD8a+AEzzIc
         CbAPXjSfXR7KaKvl4yJNzj6r4ti/Z4dwYWc/Ji66CpEuJpXhag2VJwV5oeLdRR1fsBM9
         H9ojzo6rqek2pOe21/j8o60sgq6oMGy9N4KU11E7YOJxWGpGOefyDp7vyuxE2Pn3WSn3
         iSspCTit8s7i4G5DSB0YEtcofXbLo5DVz2XzRWcFAAIts9nwy9Gw/tsZ0YVe4WftZ/pc
         Cs+9wXAg9Xf1n9ODTt4b4BhJGBqeyyFtgXhv1yZNSElx8fX+dozETAipwHmbjTOkF5HY
         KU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=BD4lpbPgIYJoxQKzEzU6bqCGaw9muIxLDsW7Q3v9h6k=;
        b=SPpnkWnLk9EO3Eq8s1e8CUgjSPqBi1pXb8n6ZXkeOKp1Ia6M2ivacZOvy+WzK3whCG
         muylVCSUICKQwfC88YEoEofj6yq1v9dyiwuP4uKQh3T3IfDPsu9tA6OcYkTJ7KWPftls
         StdOPMdKXezwR+rIUEqyCcIYw23qbTAhUyouC/Goxar41TcDcnA9WmVduVNaOXN7zviE
         qH6LAG5kJNTucNKi+tQsdyA6Z20TxEYPEU03+9r/Bv7Au6fXUwPgiCUMfdzFaKhYVKxj
         UAms9md4+3uUSRWRbq1HuhIWc7/tM2y4NyogdJj9qVUJgN1MaN/S9ITEB5CDqwMdGIIk
         jiCw==
X-Gm-Message-State: AOAM532Z82+GzJV7UxxFMUUDcIElgrGKIlMY+eC5YKp3j/Uw0+LHCyXI
        eJGlnBUl1eWVvUuJSAt00LpdhB+d4LI=
X-Google-Smtp-Source: ABdhPJyJj8tlqT95Jr5UGXnlzkZJA+EWDiIPs1qaYV1oUrDbRZ4ZtoVYOfZpGDiXR7pjcX8YU+BBsU153rs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:aba7:: with SMTP id v36mr2898354ybi.124.1624346697403;
 Tue, 22 Jun 2021 00:24:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 00:24:54 -0700
Message-Id: <20210622072454.3449146-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH] KVM: x86/mmu: Don't WARN on a NULL shadow page in TDP MMU check
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Treat a NULL shadow page in the "is a TDP MMU" check as valid, non-TDP
root.  KVM uses a "direct" PAE paging MMU when TDP is disabled and the
guest is running with paging disabled.  In that case, root_hpa points at
the pae_root page (of which only 32 bytes are used), not a standard
shadow page, and the WARN fires (a lot).

Fixes: 0b873fd7fb53 ("KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled check")
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index b981a044ab55..1cae4485b3bc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -94,11 +94,13 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 	if (WARN_ON(!VALID_PAGE(hpa)))
 		return false;
 
+	/*
+	 * A NULL shadow page is legal when shadowing a non-paging guest with
+	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
+	 * pae_root page, not a shadow page.
+	 */
 	sp = to_shadow_page(hpa);
-	if (WARN_ON(!sp))
-		return false;
-
-	return is_tdp_mmu_page(sp) && sp->root_count;
+	return sp && is_tdp_mmu_page(sp) && sp->root_count;
 }
 #else
 static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
-- 
2.32.0.288.g62a8d224e6-goog

