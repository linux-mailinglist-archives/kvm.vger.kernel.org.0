Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D93F554B
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 03:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhHXBFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 21:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237149AbhHXBFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 21:05:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB785C08ED09
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 17:58:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d78-20020a256851000000b00598b2a660e2so8419796ybc.6
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 17:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=eqKZvx2NEWdWUywVE7o+7WbkVltPDxcAK3SK8y8cE5I=;
        b=ideYI6rW0bgrh/fedrB+RL5aHrSk83ztK6diIE4XR3kX5Jz74EC8bDK7Skq5mS0Yxw
         2hF7MDVZKwUkVyookaXigmu87li99XM/Id//oNCduez0RPE9ejijIhULE6ZBcxctzifS
         gvzYSZziHCwpUBLqVKhcXBZQ9nTnCPpoBAodLXqk/UUdTdeKB/ngN4gjd9h0On7uisuO
         nQRWOIzS2/qWFgRHYOzgFiQ8yV3KxVNF3KXX4fpGxMnqoa8LWB9DOeYAHtHymg1BMYiH
         FDCtajxeEaOeBN5xSIcCGqLANgoVqkZL8fFP6POOS8LHweuw4g0ED3t3jNk+Qgk5AMUf
         ++dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=eqKZvx2NEWdWUywVE7o+7WbkVltPDxcAK3SK8y8cE5I=;
        b=fpi/ZNNvut53htwXwQbw6uNSENP7nR8gXR2Jmh3oM0O3Z0ZD6UbIBO/Bm1qJUlrMJR
         yZa1OQO3zxTJntiawZtrHXS779ccqjKNq/4jZinY1EeILJX1tvBpIEhrugLQHY0EYZKO
         VPhZvHT9Y0RnBQDrBrJjRsQoWwX/XsAV3gRXOGrMj8h00aywdAzbbbQQFYNsVdy8a2Ap
         3AAMEHZzh4e0k5/TBWe+7yOaWEBJtYHfaAa0HzkH79XSw/pbZ9VUZ/9KJesdb74VCj+0
         b/5ksGm6Xz6Z/yhqHDrtj3d7snSkSo0R7b/8z+67S5sS7KrcbtaYOeS2f/R8N0ZYFouK
         MsPg==
X-Gm-Message-State: AOAM53205cn0qb0anHgDYJzB/RfdoDqyTKEPghy7omA761cvf2V4BKIn
        Cu6xM0qqhZjeJegm7ZtWv4F8zvoENvI=
X-Google-Smtp-Source: ABdhPJwvhC0fzP6F5HxLL/WkcOnJE1wXciVJSipTLJGumDJ5e7VdUuRva+Jwwap8G6VVHxGKryuGJCeewj4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:109c:7eb8:d5ed:2e59])
 (user=seanjc job=sendgmr) by 2002:a5b:70c:: with SMTP id g12mr39851143ybq.336.1629766737181;
 Mon, 23 Aug 2021 17:58:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Aug 2021 17:58:24 -0700
Message-Id: <20210824005824.205536-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] KVM: x86/mmu: Don't freak out if pml5_root is NULL on 4-level host
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include pml5_root in the set of special roots if and only if the host,
and thus NPT, is using 5-level paging.  mmu_alloc_special_roots() expects
special roots to be allocated as a bundle, i.e. they're either all valid
or all NULL.  But for pml5_root, that expectation only holds true if the
host uses 5-level paging, which causes KVM to WARN about pml5_root being
NULL when the other special roots are valid.

The silver lining of 4-level vs. 5-level NPT being tied to the host
kernel's paging level is that KVM's shadow root level is constant; unlike
VMX's EPT, KVM can't choose 4-level NPT based on guest.MAXPHYADDR.  That
means KVM can still expect pml5_root to be bundled with the other special
roots, it just needs to be conditioned on the shadow root level.

Fixes: cb0f722aff6e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host")
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..39c7b5a587df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3548,6 +3548,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
 	u64 *pml5_root = NULL;
 	u64 *pml4_root = NULL;
 	u64 *pae_root;
@@ -3562,7 +3563,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
 		return 0;
 
-	if (mmu->pae_root && mmu->pml4_root && mmu->pml5_root)
+	/*
+	 * NPT, the only paging mode that uses this horror, uses a fixed number
+	 * of levels for the shadow page tables, e.g. all MMUs are 4-level or
+	 * all MMus are 5-level.  Thus, this can safely require that pml5_root
+	 * is allocated if the other roots are valid and pml5 is needed, as any
+	 * prior MMU would also have required pml5.
+	 */
+	if (mmu->pae_root && mmu->pml4_root && (!need_pml5 || mmu->pml5_root))
 		return 0;
 
 	/*
@@ -3570,7 +3578,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * bail if KVM ends up in a state where only one of the roots is valid.
 	 */
 	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
-			 mmu->pml5_root))
+			 (need_pml5 && mmu->pml5_root)))
 		return -EIO;
 
 	/*
@@ -3586,7 +3594,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (!pml4_root)
 		goto err_pml4;
 
-	if (mmu->shadow_root_level > PT64_ROOT_4LEVEL) {
+	if (need_pml5) {
 		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!pml5_root)
 			goto err_pml5;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

