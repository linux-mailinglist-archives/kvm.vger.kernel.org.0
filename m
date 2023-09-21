Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F2B7AA108
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjIUU4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjIUU4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:56:12 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547D9C1128
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:47 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c5cfd475fbso10568145ad.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328427; x=1695933227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sB11xgPqav8kJOlkOtFOCiG4fm9eEcXZMC+/0AduleA=;
        b=rkStgMBLtwv1RojQ9/AzrLzoUD6XPX/6Q7zZXlfRVRbzsL+dFVV+XnsNsJUMsIpqPE
         6z5X6GiM1FbIWRl8AAW6bMjIDFrwQaVRIi59lU3mS++FdnYzD+5Ox7fIrB4l2wYpdWcy
         BbCNnhkyQPHiVT0yLFOzVvl5eGjZLCm6lh7ZHrvVXcgTHdRGKtbWy3ShYlQQXwWkQKRb
         fGQJyBLynmBe3tQ4YxNsYHWwLsUjOc4qZAMFelFSaJMgNKZKj8qlbbCnpjrgq3l3XXtZ
         prxYHqMS8o10bw6IUXUhgtwt30OPzaykWHnMveciKDjcyjCNwK4rBBI1pc1tnAkg8RVw
         TqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328427; x=1695933227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sB11xgPqav8kJOlkOtFOCiG4fm9eEcXZMC+/0AduleA=;
        b=LY5ZQCQYnVW1YlC7/DbpkMq/4PxovX8OU7ky1qEimSor+8QNc+Hk6w3F0yNMwzMadL
         VJ/AIfIcafxwRWursxNHhmYYxuMb2kIEtbOHOLJOxDY4PtBS8FUugRt+w1VeV0NdF8yq
         Q9sDoL0U3Uf4hNo6iWMSEIXRVwjs8rV/m5CKugvTy9e6DW40V4+ITA1AoBFsNQGoeiau
         IMz3RXtsevf8IIJ25Utv1EYSoXYsW/7NLzqFJM5rlgjPy4A6omCZpfG8fIAByxt9HbJM
         LyjH7dGeXZYNrxcz0JSSHg1PcW7xqUVIVwJqi0a7xGzAS9VF0weBu/i/wLOrRJ8z7+qN
         Vy1w==
X-Gm-Message-State: AOJu0Yx08+017OcXQLoDbZ2H1zLSEIeyCbl2ckWKQDV9GDX9Y/IaF6YH
        /wJ+leE4bIjKlcuvyYcbk+KRDwuxV7g=
X-Google-Smtp-Source: AGHT+IGx7Eb0egTaRgjCjWsoC3+ZOFv+sbP9oLGdFxJ5fYEqfixkRwWHlHwIm7T6uuPwO4ciyM1sX09Mndk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d490:b0:1bc:7c69:925c with SMTP id
 c16-20020a170902d49000b001bc7c69925cmr94808plg.10.1695328426758; Thu, 21 Sep
 2023 13:33:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:24 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-8-seanjc@google.com>
Subject: [PATCH 07/13] KVM: x86/mmu: Track PRIVATE impact on hugepage mappings
 for all memslots
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the effects of private attributes on potential hugepage mappings if
the VM supports private memory, i.e. even if the target memslot can only
ever be mapped shared.  If userspace configures a chunk of memory as
private, KVM must not allow that memory to be mapped shared regardless of
whether or not the *current* memslot can be mapped private.  E.g. if the
guest accesses a private range using a shared memslot, then KVM must exit
to userspace.

Fixes: 5bb0b4e162d1 ("KVM: x86: Disallow hugepages when memory attributes are mixed")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 269d4dc47c98..148931cf9dba 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7314,10 +7314,12 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	lockdep_assert_held(&kvm->slots_lock);
 
 	/*
-	 * KVM x86 currently only supports KVM_MEMORY_ATTRIBUTE_PRIVATE, skip
-	 * the slot if the slot will never consume the PRIVATE attribute.
+	 * Calculate which ranges can be mapped with hugepages even if the slot
+	 * can't map memory PRIVATE.  KVM mustn't create a SHARED hugepage over
+	 * a range that has PRIVATE GFNs, and conversely converting a range to
+	 * SHARED may now allow hugepages.
 	 */
-	if (!kvm_slot_can_be_private(slot))
+	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
 	/*
@@ -7372,7 +7374,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 {
 	int level;
 
-	if (!kvm_slot_can_be_private(slot))
+	if (!kvm_arch_has_private_mem(kvm))
 		return;
 
 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
-- 
2.42.0.515.g380fc7ccd1-goog

