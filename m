Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CBA3EAA02
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhHLSOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 14:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237625AbhHLSOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 14:14:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD67C0613D9
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:14:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a62-20020a254d410000b0290592f360b0ccso6799821ybb.14
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=87H+u+foZOMl2+mujsgqMGuyt5hAA18liA/ly4SG1XY=;
        b=F02taAZe2fQ1z+2pLtBzYvDsCRB9FD5aVIbSrGrNnyYnDZitoT1d6qtGgq4rXePdp7
         GZyAr+2PZRWHIFFHkuzapPEiwzP6LXfzGmEQDDQZzrPEwN/BwHVbQNaHdNAg9WK+Q+u5
         +cTLwY9MZepf2TWRRpfDTD5jccwN0i73DjltP7Dx3p5+aqRNVQDt9ehCcJMqTeXms6lk
         jHQln+eMD0nkKM/XJUDCJnKI83Rq1YAQoZT5EC4bgYdTqAgett2uCnGDYUW4XCLfTK9G
         wiufp03J6R3GDoUSh5JXyJRRspeY6evlMnVoyXIGZf+hxp852gw2YLa0P9Yro++wAPlP
         asEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=87H+u+foZOMl2+mujsgqMGuyt5hAA18liA/ly4SG1XY=;
        b=Csw69E+BxzM+a/l1uKPAjBpfKVxfhvoYRiQVUbfk34+KQx33Q1sqDeyl4+oOkdzRGX
         lsbWRTZpk3KqNLeWSF2zlrZTmaLzl0MGTGABXsQwh1TtVfGl6zqkcyANtFiIGDhYfv9l
         H1FwBmsylrVhlMt5s084LYXX1TtMiYhFfcYStecfytvX/R+X23vw9rNlwlEVfRnGIl0Q
         dtA2DUFxkXi9jZnfX4CRNRSBllCsjgXT8B/TjhixFChxWmyX3rHwyejaWghHLrfDR6SN
         yDVzsOf1j3FRucW0FY2CL2wzZw1zyvdVveKlBrWfugJHO9Wm7/uD6OPjvL5eBtErCrVO
         0lsw==
X-Gm-Message-State: AOAM532Mu+UYcQQWiN262YIypV9/35QCcVdCofCymA/27VqYO0MsdVdB
        HKdrdkpYR0gG1fPb/RqsVAgFuxfkEFw=
X-Google-Smtp-Source: ABdhPJxtdOoPPNYyjVtJeijzCT6nqd/vdI70MbGIztPQk866qB5Cl5e33ow/LFSMX5yMwSYUCn+5tOyCBXY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a25:31c5:: with SMTP id x188mr5826688ybx.185.1628792062938;
 Thu, 12 Aug 2021 11:14:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 Aug 2021 11:14:14 -0700
In-Reply-To: <20210812181414.3376143-1-seanjc@google.com>
Message-Id: <20210812181414.3376143-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210812181414.3376143-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 2/2] KVM: x86/mmu: Don't step down in the TDP iterator when
 zapping all SPTEs
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

Set the min_level for the TDP iterator at the root level when zapping all
SPTEs to optimize the iterator's try_step_down().  Zapping a non-leaf
SPTE will recursively zap all its children, thus there is no need for the
iterator to attempt to step down.  This avoids rereading the top-level
SPTEs after they are zapped by causing try_step_down() to short-circuit.

In most cases, optimizing try_step_down() will be in the noise as the cost
of zapping SPTEs completely dominates the overall time.  The optimization
is however helpful if the zap occurs with relatively few SPTEs, e.g. if KVM
is zapping in response to multiple memslot updates when userspace is adding
and removing read-only memslots for option ROMs.  In that case, the task
doing the zapping likely isn't a vCPU thread, but it still holds mmu_lock
for read and thus can be a noisy neighbor of sorts.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4a9d52283ec5..499dadeb45a3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -742,6 +742,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool zap_all = (start == 0 && end >= max_gfn_host);
 	struct tdp_iter iter;
 
+	/*
+	 * No need to try to step down in the iterator when zapping all SPTEs,
+	 * zapping the top-level non-leaf SPTEs will recurse on their children.
+	 */
+	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
+
 	/*
 	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
 	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
@@ -753,7 +759,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_pte(iter, root, start, end) {
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   min_level, start, end) {
 retry:
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
-- 
2.33.0.rc1.237.g0d66db33f3-goog

