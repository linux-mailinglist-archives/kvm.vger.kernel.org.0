Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C07767A63
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjG2Ayr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjG2AyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:54:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA154C29
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:19 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb962ada0dso17237315ad.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591926; x=1691196726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wviPOsS6wxIVOzMjjv3mWVw+feSBMfs9pmoqRvrXCaY=;
        b=EKB+UIYo3U8JrsxxkoCQHi5oERvy0PlpE5t8T6ECPd1S920laYGLkn5v+VUuZuVRNx
         TNdT8RcQ0UGfrMuKrJodH/v6mmbDBatABlksyCDAMRh43mT0KlZhqGmXtI3C5fpZpBNQ
         iw09XJROxq8kshDmgjI9DCbOP1qWMKVyiMTGDY+VVhxgCX25iLB0Pw1e2eevCGa4nI8D
         xPPeR7CawBIktWLbE6vQ55sQ47znxIYdnLKYz1NKvJ5CiqzCZpN9b1p/ZncxygvkZcDo
         hoRZVAMyaQb6fuI17sz8+UvDEkP3iIAMtdcF+6fpJ1UJnq4Bowf+GNAYZCbq85JAvBIK
         jztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591926; x=1691196726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wviPOsS6wxIVOzMjjv3mWVw+feSBMfs9pmoqRvrXCaY=;
        b=BhD9OhUzO2f3Z+t6YKpFFrILhhd1spJncyLZVjv7uqfK3act6Bk6CgKzt3pINjM0ht
         DPXUXGWqJm+GYAfQaf1rF1I3lb0NCSwtUoKxK/7SkJN5Ezkcsl53cS/UA7dL1OhpVTKa
         U62q8MIvm4PSVSJ7+dVs7h5Nq94oKOY/kwdHdeiLC/PIVw8k98LdcJxrqT4wQNZAfu9n
         kAtSyuzzgOfQHn9ZQRZ+sT9ilrWVcl3ZMb81RWxEH9gZdVoLG25h988F5bKnHm7sG7t9
         LEK6Sp6uFaRTbtJQZrSBdyWa7RY2k69opCuHnM/lE22ZTNIeYTq8522pby/hrhLOvCLE
         R9qQ==
X-Gm-Message-State: ABy/qLY7ojrD6uwwOSpX7rBhrr552buGK3FKD61WSnNvQLjAE9aLMsA5
        r8ctFDywn6tVUGx1KbbYwDeFcF5EK3Y=
X-Google-Smtp-Source: APBJJlE0CwowDKpfUKMMyIjy0kUWIsKqME6oDTVM8ZuAogX6MjovWPA1wKiYfq3gebYS9rwaKEtm1ou/aRc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f990:b0:1bb:1ffd:5cc8 with SMTP id
 ky16-20020a170902f99000b001bb1ffd5cc8mr12038plb.11.1690591925918; Fri, 28 Jul
 2023 17:52:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:51:57 -0700
In-Reply-To: <20230729005200.1057358-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729005200.1057358-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729005200.1057358-3-seanjc@google.com>
Subject: [PATCH v2 2/5] KVM: x86/mmu: Harden new PGD against roots without
 shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Harden kvm_mmu_new_pgd() against NULL pointer dereference bugs by sanity
checking that the target root has an associated shadow page prior to
dereferencing said shadow page.  The code in question is guaranteed to
only see roots with shadow pages as fast_pgd_switch() explicitly frees the
current root if it doesn't have a shadow page, i.e. is a PAE root, and
that in turn prevents valid roots from being cached, but that's all very
subtle.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1eadfcde30be..dd8cc46551b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4560,9 +4560,19 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
-	return (role.direct || pgd == root->pgd) &&
-	       VALID_PAGE(root->hpa) &&
-	       role.word == root_to_sp(root->hpa)->role.word;
+	struct kvm_mmu_page *sp;
+
+	if (!VALID_PAGE(root->hpa))
+		return false;
+
+	if (!role.direct && pgd != root->pgd)
+		return false;
+
+	sp = root_to_sp(root->hpa);
+	if (WARN_ON_ONCE(!sp))
+		return false;
+
+	return role.word == sp->role.word;
 }
 
 /*
@@ -4682,9 +4692,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * If this is a direct root page, it doesn't have a write flooding
 	 * count. Otherwise, clear the write flooding count.
 	 */
-	if (!new_role.direct)
-		__clear_sp_write_flooding_count(
-				root_to_sp(vcpu->arch.mmu->root.hpa));
+	if (!new_role.direct) {
+		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
+
+		if (!WARN_ON_ONCE(!sp))
+			__clear_sp_write_flooding_count(sp);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-- 
2.41.0.487.g6d72f3e995-goog

