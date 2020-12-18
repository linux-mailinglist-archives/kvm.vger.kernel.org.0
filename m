Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F562DDC68
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 01:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgLRAch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 19:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgLRAcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 19:32:35 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E97C06138C
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:31:55 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h75so488221ybg.18
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=78xBxovk70v/fvyU3yhuNQMatP3jPljZeMZVBSc56LA=;
        b=B3R1PQgtNPMxojroBSUthuq4U69no1BV6LHzwIpnP2Sj6puZN3CnpVw+zhGmvxrl0q
         JTXB9JGhODmdNX7TioHy+s5pqQnnqQCPalfctnvEjgn5W9qwjUhUZaExbvBaq7kdOC/r
         SLzRgMkzeohdkhNl847qO3lxdKxwJOXZGcG6R/rkTTQnM+VF70b+CZ6bjYt+85ZGZJTC
         T5tIgphJmEhFlbNu6kTE1h5HXZb8q+Csr2CYJulyeZivzdoh53oNuOTOHul26Xth1BDJ
         II5PlL23t5CZGoqldm2PcxCBrvabKIGbnXjvsLlK2j0K7p0yj4Yr1vW+CGiC9cttDbda
         HM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=78xBxovk70v/fvyU3yhuNQMatP3jPljZeMZVBSc56LA=;
        b=ABKHKFFsoXURaGDlYleIKVGWWghHu91f8ZuCOMHy21GTdjjFGWB6xoVWBXUvHedgze
         3JHpBZqow6CYGOwwSl8yhdKtmIHCycQCCaPAsR6CjqifnDqqps2N4zBBisB4DsUlHkci
         x0KuqdF6fhRFfKq1v8IvtJhEkf/rJn/Te5cbYdg7lxLiVMBpLKuhjZSW3yx/1BYgLgrS
         MNDkN4cxPb3Ps94obOAxlttrI88aJyrHTTqP2XmqAYcah1QwS+Y7cVcY6uve9j2WoNK/
         Mg+J/oBrMnGt+VF3VI4G9HwScMIkrrzT0sbaecCBb8YswHc6HgNrt0lc6QELVcDGZKs/
         J2HQ==
X-Gm-Message-State: AOAM5307JNqEyEWTcKfIt/nVdcRZmT1/Qq98A7EVVVnZWcdfiGcKHufM
        4AfnwC+Npw3Q4NVCxu+Ql7tkrhTsAgU=
X-Google-Smtp-Source: ABdhPJw0//qXhDKO4cdyBbLqZZOdyHdbbb4ewFr2vGZyeBU7kHgf2afeFksObT5u3Pgo2wDrgOG863zVrws=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:db81:: with SMTP id g123mr2924808ybf.277.1608251514431;
 Thu, 17 Dec 2020 16:31:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Dec 2020 16:31:36 -0800
In-Reply-To: <20201218003139.2167891-1-seanjc@google.com>
Message-Id: <20201218003139.2167891-2-seanjc@google.com>
Mime-Version: 1.0
References: <20201218003139.2167891-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH 1/4] KVM: x86/mmu: Use -1 to flag an undefined spte in get_mmio_spte()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return -1 from the get_walk() helpers if the shadow walk doesn't fill at
least one spte, which can theoretically happen if the walk hits a
not-present PTPDR.  Returning the root level in such a case will cause
get_mmio_spte() to return garbage (uninitialized stack data).  In
practice, such a scenario should be impossible as KVM shouldn't get a
reserved-bit page fault with a not-present PDPTR.

Note, using mmu->root_level in get_walk() is wrong for other reasons,
too, but that's now a moot point.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 7 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a6ae9e90bd7..a48cd12c01d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3488,7 +3488,7 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	int leaf = vcpu->arch.mmu->root_level;
+	int leaf = -1;
 	u64 spte;
 
 
@@ -3532,6 +3532,11 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	else
 		leaf = get_walk(vcpu, addr, sptes);
 
+	if (unlikely(leaf < 0)) {
+		*sptep = 0ull;
+		return reserved;
+	}
+
 	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	for (level = root; level >= leaf; level--) {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 84c8f06bec26..50cec7a15ddb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1152,8 +1152,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	int leaf = vcpu->arch.mmu->shadow_root_level;
 	gfn_t gfn = addr >> PAGE_SHIFT;
+	int leaf = -1;
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
-- 
2.29.2.684.gfbc64c5ab5-goog

