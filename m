Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FEF3A4B7D
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFKX7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 19:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFKX7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 19:59:36 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B2BC0613A3
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:28 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b9-20020ac86bc90000b029024a9c2c55b2so883105qtt.15
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=naUUfLFw1Sdu4x0S/DKaQk2Ombp4kYpoKKh+TUQmQU8=;
        b=jb5KUhubSkySRC3x+qAf54PBwP0MYH1Pfsz9zfRfXiEcWcWyTvogHSqK9eO9ONq1nM
         +fDPvWg+vXAEDO8TSl3p4c6UaSLAGCTZ7dU7N0hcsrKOJxgL44HAAQj52u+XRNFnkGAp
         k/WdL7uwCeFL55esTEdguc4GigZoBOxYfGa8gOAUiXoxzTWoL4VZgSdGvBkijFknKme1
         0JT8mVurglPTUjiQMcOaQ2zMD4kT0vJuGhWcaUlXQWCPaW9DTDy04KHwLYtckcKt+uYk
         O7kqLFgZVTM9da7OQUzEDwbVYe0xWBkHTpqEnvxqx4mktEge41pLS/Q47oVSJWpvBCpq
         XRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=naUUfLFw1Sdu4x0S/DKaQk2Ombp4kYpoKKh+TUQmQU8=;
        b=rer17ouJalVOV06bIVoHjWdHX1iqwVunMWpZDnypG+cFFGh8LATHq52BO7POHw5NzB
         SBCR65Igo6F3ZDhC233+EkobFNsJ9Dch2S80bfbz8aDa5ekpy4K6CO9KBkujyAo2+5uo
         Oq7jyoJDZuawEPp+hEGg5y9f2G/x2G26lcc43sLx/XFxDtQxQr/JCpM/7VmxkrDsLkVT
         q1qonqdsKHJtyMNcFFl51HpHUAvPvGLpCchcMZ3HzyY9NKGD2+LXD/ppMZEMgBTHJ/g0
         tBBBoSFh8CErC5edjt7ZxV+/mLTGn88r/Q1GNc9+L4wyeA3hceG7HGrJTzUm3C1wg3n7
         YpLw==
X-Gm-Message-State: AOAM531VK1quEVRKNAWTsRoXvfkvcKiJJZEtoswWDVxcvww/P9/tNh8A
        q9D0VFfJDJTKuNwDO4ujKuLZHeDBUodYwIlW2XlhRPgDOMFooCItzFvPORHGivbMq/gzOaviOs3
        uhV4b7ZMFyBrEo5DvkWNZAKurPKMFqajRZJ1YSepdpPoJ5TNXz4Vn6OT1sNQjrfg=
X-Google-Smtp-Source: ABdhPJyKaiFtMzGhA+PpHuXaFUqGRyK8EKQ4bagNa44YZtpO2l2dHtlPuYw0cZ0H8k2Yvf/SiH59uJwwb1mLEg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:ad4:4bc7:: with SMTP id
 l7mr7421689qvw.7.1623455847214; Fri, 11 Jun 2021 16:57:27 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:58 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 5/8] KVM: x86/mmu: Also record spteps in shadow_page_walk
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to use walk_shadow_page_lockless() in fast_page_fault() we need
to also record the spteps.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 1 +
 arch/x86/kvm/mmu/mmu_internal.h | 3 +++
 arch/x86/kvm/mmu/tdp_mmu.c      | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8140c262f4d3..765f5b01768d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3538,6 +3538,7 @@ static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
 		spte = mmu_spte_get_lockless(it.sptep);
 		walk->last_level = it.level;
 		walk->sptes[it.level] = spte;
+		walk->spteps[it.level] = it.sptep;
 
 		if (!is_shadow_present_pte(spte))
 			break;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 26da6ca30fbf..0fefbd5d6c95 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -178,6 +178,9 @@ struct shadow_page_walk {
 
 	/* The spte value at each level. */
 	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
+
+	/* The spte pointers at each level. */
+	u64 *spteps[PT64_ROOT_MAX_LEVEL + 1];
 };
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 36f4844a5f95..7279d17817a1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1529,6 +1529,7 @@ bool kvm_tdp_mmu_walk_lockless(struct kvm_vcpu *vcpu, u64 addr,
 
 		walk->last_level = iter.level;
 		walk->sptes[iter.level] = iter.old_spte;
+		walk->spteps[iter.level] = iter.sptep;
 	}
 
 	return walk_ok;
-- 
2.32.0.272.g935e593368-goog

