Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0B1767A56
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjG2AyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbjG2Axe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:53:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A049F0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56336f5dc6cso1776459a12.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591928; x=1691196728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c2hzKspWULGao7+7tlz/GXIKMGwiNk1PKHvUMvBGqxg=;
        b=MnK7365hqYqDmIToHDHmfuIORMIpqw1AhEznKuxs+/8El6VtqwC9A5SoRAWJoYQ7y3
         2j4AMTwoOFp67ycnoR7TGuJFzJ1J2rNVTU18ch/3mPlf7/aI5Nrr373YvoVnVqj3xQjN
         xLmMI0urjdys7Tp+u97p9GcuViNxd4ObxQG1Rd4a4C7R1jjkHzUds/GQuNYS4A1APfwG
         t+SIsYwzsJQ5gMgqOK4U+uPBJhenN3YxYLv7ZRcC1IlDtr7mSkgDmyqJmYU65bPHr1pk
         k3F4LRVQiIz/OvA0gxExBoecq+72mtcMLmTF1MD/bUjclRuDKcLO0e6akXWL6mK2XQwq
         ZFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591928; x=1691196728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c2hzKspWULGao7+7tlz/GXIKMGwiNk1PKHvUMvBGqxg=;
        b=RBqLfPTIpwKQw9Txvar39mS+VSXG9X6fA3d9mEjggr4xAN7XF/EYOxPyXVfzkTG2KG
         VRCBpGCQ2J1jRChZ00SW1QK51iUXHF1KuQo8kBIf8MffpRDT+3wLW4gb8GGYFvM6+PnM
         x+iTyXEwngdC1FpuJkCp5wK6gk6me7mrL/37emiEj/YHX9L3HkhByIXYxktkIkEG2uAg
         1v4GD839Nzx2I7wr7bRLQbmqt9ncO1YPqZsEELsBNZ0aK2kpNsP83bskFTokxwL27+bZ
         THTdsAiHWa9IrGfk5S134VDC4xIqIHWW7DWhbZp+hKiT/at4QLHYaMN8VXFhuVFHn+Bi
         2Tuw==
X-Gm-Message-State: ABy/qLZXoNJK2HpD/k12hmL46YsjGVnirmYOSeSW5JisL7DZO4/lAwie
        dEySi2l9XPRtL73Gd3RpnAWf2Qqz5Vc=
X-Google-Smtp-Source: APBJJlFpTBjpM5mxgOokSEzthSB/OOeb6Z5uW8D4AHTTxbXnnDMnYursd3jBySxjtIVNh0+BjT9PWnDLv78=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e804:b0:1b8:9468:c04 with SMTP id
 u4-20020a170902e80400b001b894680c04mr12249plg.5.1690591927773; Fri, 28 Jul
 2023 17:52:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:51:58 -0700
In-Reply-To: <20230729005200.1057358-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729005200.1057358-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729005200.1057358-4-seanjc@google.com>
Subject: [PATCH v2 3/5] KVM: x86/mmu: Harden TDP MMU iteration against root
 w/o shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check that tdp_iter_start() is handed a valid shadow page
to harden KVM against bugs, e.g. if KVM calls into the TDP MMU with an
invalid or shadow MMU root (which would be a fatal KVM bug), the shadow
page pointer will be NULL.

Opportunistically stop the TDP MMU iteration instead of continuing on
with garbage if the incoming root is bogus.  Attempting to walk a garbage
root is more likely to caused major problems than doing nothing.

Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
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

