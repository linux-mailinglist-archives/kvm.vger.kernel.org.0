Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D448433C595
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 19:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbhCOS1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 14:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhCOS1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 14:27:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A44FC06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:27:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a63so39111432yba.2
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bVFbFclWH6TVYcwCc+4Ci62XlhbttvVSTzGI6/A6UWQ=;
        b=E0MpwwInBk3iuFdbG0xyFOsZFAmjFiKutWJyHHYpT2jTy9OGAWmOAmh6rBz861KT77
         pqS85PXvPhBS0/Ma0I8sKFO6LwRo6QpIuX1TIq0sfqsJGq613x90B5au2+dFX7girI2l
         e4tKDmfcCzwvNGoQ9FjIx9DMRI7azw4Y3e3OMrYcF5ph6+h0j9z2J/ghhWgpNb2/EGBL
         caR2SMEFQbEu3A8OIY+MN/Hj5NDqJkJwwSh4k3EFwGLmhvIPmcWTrXehdqGmweltGacb
         Jjbt6Z9G8d9Kgx+79BR0+kLvdiHZeUvzuyBeL6UqspGsIPVbe8SatM3deboLak3DZV3N
         4DJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bVFbFclWH6TVYcwCc+4Ci62XlhbttvVSTzGI6/A6UWQ=;
        b=eRsqiyik2DmfIESuioiNj0Y+mYBma5XH0Iwe3Tsnv8i4wyIntoeNOgIB4M5+sMjaFk
         vFWGDdhq1Pg9nsLsIZMbBnfqaW8RQoVcTdxGdDqOg4u3/glzfqDvcCkgndik5FJbwJYu
         +DjbQMiP2lw8Au887KDf/k2TfwIdrjIRs1KTznfWb6EnEbe+TVpyXWcA1pNVo+/SkBrA
         fBsX5rtpm7TNpu0LEO4Fsz3YNhIEZby6fZALRGUkOfOum1equfTXONFiKOaRYCZA0SmU
         t0p543DK4dnI7O2zbMi/yK8xjX1FHwO5D1p5yaXx/u8qLsVNwT35H6N1q8ld1OpV5M+A
         khag==
X-Gm-Message-State: AOAM532fIix3ocs3ID7edZiJV6NT7qDeuRGy9hDdFVgYNhqbZ0j2MdiN
        2OTfvoQdZTuFP9yPLd0uJRJhklgBOZuq
X-Google-Smtp-Source: ABdhPJwp1E7vgZOgmoN96JU0x3OuJxlPoqsceKnb0IVK2p3TjktU1Wz2gkABoEm0DVJLZJoeorFj2wqTV3v0
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:a05:6902:72f:: with SMTP id
 l15mr1392566ybt.519.1615832819867; Mon, 15 Mar 2021 11:26:59 -0700 (PDT)
Date:   Mon, 15 Mar 2021 11:26:41 -0700
In-Reply-To: <20210315182643.2437374-1-bgardon@google.com>
Message-Id: <20210315182643.2437374-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210315182643.2437374-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2 2/4] KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a missing rcu_dereference in tdp_mmu_zap_spte_atomic.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index db2936cca4bf..946da74e069c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -543,7 +543,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * here since the SPTE is going from non-present
 	 * to non-present.
 	 */
-	WRITE_ONCE(*iter->sptep, 0);
+	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
 
 	return true;
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

