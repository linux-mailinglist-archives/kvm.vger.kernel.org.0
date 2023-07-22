Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C0175D8A6
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 03:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjGVBYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 21:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjGVBX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 21:23:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5C3A82
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:23:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cf4cb742715so2457184276.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689989037; x=1690593837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K8g8ylIBioHABO4UYnvq+eRAgeeK2kAPLMh05XoHYU4=;
        b=d9n714xKJqMwcsAZMI0NHTCtMswGC8ES6vvzsYorFNt0M9xXUeBRyv2a9UkMH2SDBb
         1ScznqmzIh4kjUyE1rSGMt/RSAjUOgBLjmGeokgwc60pdNX308+hKXWH1xXe2eJ1E7UE
         05Os0QeMBsYL+KYrO61vzAUcL8pSdwb+96Z18F1kECGsA94JjKWTeYHXZFmAJjnJ1zha
         vpdW1oLjoY/H5htKcV2jS7OfuDX/CAAY8O0JZDKKDltJ//M2/x0m9xTroHtPNR5sFrHa
         9EfyrhBnD0vt7qK+t8Y0oFu8yMInPvL09a53JrtWtYnKRNKlsMgf/sCN6zvwRwW95iyM
         scGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689989037; x=1690593837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K8g8ylIBioHABO4UYnvq+eRAgeeK2kAPLMh05XoHYU4=;
        b=YQXaB8tmlt4iFZJUA8LpM+DGCBqs/SL9drHpldxI3v6xuCvfYHAsXsSqUUrZmKp0Wj
         5mzQriBHHIMJ0UnGgF+G8aEYCRAUCLFl8NPtq5GvtjHplQ54P4P6p5+IpKLWgxrzcN2u
         5JGhUL/o6ZuFwzPPyyiaJ1O0i5mKtJ0AkS39gOBVmQj7E6fyXI7d7Fzvmfb7SMY2oy9g
         wDwE2Vg7D/QSV2fqnJjWUOZlEJJuBr8/vHm9OAX4l67BUzXPPAuXl1CcHNf2gDm29Leq
         mkaMjRdmUTLNRAwQ7stNUy/zopMX9HsdpdSouAomklqD2igOkDHjZFQbYIMGhUDsxdzC
         Uxtg==
X-Gm-Message-State: ABy/qLa6ToDi6Kzi0M9fUbyC58PS+4yK2LrmKu1VjUSKsJvIFWX5sTzr
        xaOASF7VpTDcPJfYajFQNkTINyf+NRE=
X-Google-Smtp-Source: APBJJlF+A0iIM85uIonjtFc0LBUEjOC6Z7bNRybAKOxeB2niAfBIolVS8Vuvx1nG9NWSwW1CFVKCGR0Ae6s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:245:0:b0:d06:cbd:1f3e with SMTP id
 66-20020a250245000000b00d060cbd1f3emr13920ybc.3.1689989037474; Fri, 21 Jul
 2023 18:23:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 18:23:48 -0700
In-Reply-To: <20230722012350.2371049-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230722012350.2371049-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722012350.2371049-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: x86/mmu: Harden TDP MMU iteration against root w/o
 shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check that tdp_iter_start() is handed a valid shadow page
to harden KVM against bugs where

Opportunistically stop the TDP MMU iteration instead of continuing on
with garbage if the incoming root is bogus.  Attempting to walk a garbage
root is more likely to caused major problems than doing nothing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index d2eb0d4f8710..bd30ebfb2f2c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -39,13 +39,14 @@ void tdp_iter_restart(struct tdp_iter *iter)
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn)
 {
-	int root_level = root->role.level;
-
-	WARN_ON(root_level < 1);
-	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
+	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
+			 (root->role.level > PT64_ROOT_MAX_LEVEL))) {
+		iter->valid = false;
+		return;
+	}
 
 	iter->next_last_level_gfn = next_last_level_gfn;
-	iter->root_level = root_level;
+	iter->root_level = root->role.level;
 	iter->min_level = min_level;
 	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
 	iter->as_id = kvm_mmu_page_as_id(root);
-- 
2.41.0.487.g6d72f3e995-goog

