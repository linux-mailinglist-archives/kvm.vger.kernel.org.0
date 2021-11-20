Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF88A457B70
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbhKTEzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237032AbhKTEyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:47 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B693BC061373
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:27 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p8-20020a17090a748800b001a6cceee8afso3772345pjk.4
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j/5ilI+p7xSEigUVpkO5IliCCfj3KTwYuc/+FdZNd0I=;
        b=ATulbKNjOj7Ye9EesfBxW6g40JQWfDn6lwpwnpNWGasq3apZnfIOvhO31RyDvdnClS
         dM2/Q3qf8c0Zbmx5QvYpN91D2Fl/9AmTqE2EAGtUvHBuIZDQ37B16puNbZq1Wi8CzPni
         L51GnK+6THHaMBzJQSnXEP/DxlNc7SJsqk9JtQnLps7V6KxdxlC2dBaxAdMjU3FzpJWC
         G4ILf/38Td1UdbmQyfYdQR2CtnuXGH9B3oGp9X7KregpsY45zOdUgCR333PeZL99ALwM
         cj2oHStk+VngvDd5bk9YWbkeNdR42WPgPpiAkuUddFjRoWYlVrOiA0QpnwiqJPdCE49Q
         iTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j/5ilI+p7xSEigUVpkO5IliCCfj3KTwYuc/+FdZNd0I=;
        b=S/DeWr/mg8V8ceYmO38MNnoE/euYNgPNILQLQ04Ex9x+t6Nt8/Eumqv1A/huYUVq6V
         EcO6+/DrI8EtfrVAxqrDMNjIM+AOJGvTSGyRyrOc7HXFxvDtpmLVtcAL0KbjCePKTCeV
         FRi5GWTaadDn6/o2KQEJxPXE1+yZr5xZ0vMtF9Iqyu3oVDvFy/Bx1U1sh6IAtGrKWpEx
         tAIq3AmqHiRW0AT5DtB19bMn22K1xrl8VVHoYwD6V7VYqeICdnDzHP5B/X0BB0LhuvLA
         v+RF8CyxSkU4Oyej/Y5+YPbryOZBdgx8F8NxL7lRQ4O7cT9HcB08hDTnaB5Ql//K1neF
         DmpQ==
X-Gm-Message-State: AOAM531cFy5/2Iq+NAkkgAF/BggKfL3n3CNUgmFRhZk0tYiOekJh3XSw
        SwZJAqj1gH0wEAJ9Q8NliRNH+IvOie0=
X-Google-Smtp-Source: ABdhPJyfieQwpbsF1IWVpOClwVrjHZXYct5Fokol92pQA1zBvl2GvEP1mDpZE1BRaaWab6rPxzg9oiJcXe8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea09:b0:141:ec88:4410 with SMTP id
 s9-20020a170902ea0900b00141ec884410mr85626446plg.51.1637383887252; Fri, 19
 Nov 2021 20:51:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:39 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-22-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 21/28] KVM: x86/mmu: Add TDP MMU helper to zap a root
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a small wrapper to handle zapping a specific root.  For now, it's
little more than syntactic sugar, but in the future it will become a
unique flow with rules specific to zapping an unreachable root.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9449cb5baf0b..31fb622249e5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -79,11 +79,18 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
+static bool tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			     bool shared)
+{
+	return zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
+}
+
 /*
  * Note, putting a root might sleep, i.e. the caller must have IRQs enabled and
  * must not explicitly disable preemption (it will be disabled by virtue of
  * holding mmu_lock, hence the lack of a might_sleep()).
  */
+
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -118,7 +125,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * should have been zapped by kvm_tdp_mmu_zap_invalidated_roots(), and
 	 * inserting new SPTEs under an invalid root is a KVM bug.
 	 */
-	if (zap_gfn_range(kvm, root, 0, -1ull, true, false, shared))
+	if (tdp_mmu_zap_root(kvm, root, shared))
 		WARN_ON_ONCE(root->role.invalid);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -923,7 +930,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
 		 * will still flush on yield, but that's a minor performance
 		 * blip and not a functional issue.
 		 */
-		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
+		(void)tdp_mmu_zap_root(kvm, root, true);
 		kvm_tdp_mmu_put_root(kvm, root, true);
 	}
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

