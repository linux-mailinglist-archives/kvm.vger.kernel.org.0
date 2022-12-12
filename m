Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A90649A8E
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 10:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiLLJAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 04:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiLLJAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 04:00:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007FA6317;
        Mon, 12 Dec 2022 01:00:10 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so14974126pjr.3;
        Mon, 12 Dec 2022 01:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NsqQBlG7OALHs9p2W6AkND+AQ3ZkN//jvoUDNbWIbKQ=;
        b=HufF+lFF8AUfjv0wnsSPAksVvIPcOML/MwkmnCkf8sbfeMw1cDXYkx+HSUcP50C2Qj
         OUa4ud1lBI7y7tS9+99H0dV5NFXUTs5maiwW8JtVBlAlv7F/k53HIC/cwirz8jBR0Gl3
         HWnFcPaNfgkHqlooSq/HS6gipH1YnRrx0uYlhEsj5puSiEHbwZ1HJo+IaGHUmiXvprl/
         WlMt+0l+bCZVpTXQ0mTavNI1Gt4ZdTOj+WHBY+u7XoLXmZaBIu6hfbnczzeOv9Ngl9R6
         DxFjYGzjB1DDpHnWmGWPMOMWX6iia5BK7XdRmRmmK4Qu3meSiNgyyUfW4IjQsp/H5XGv
         bQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NsqQBlG7OALHs9p2W6AkND+AQ3ZkN//jvoUDNbWIbKQ=;
        b=z5YFsryKKnULLm60gZZ8cYCLd8/xUFLLzige6vV2TprXB49BhgI6r2Px13cgpidUil
         hzd3YMhmCM64lcibS5dsJ5Hyo60DCJsScPyT9ICnt2JXYn5DTeVND/1qS0Owj0MGBh9m
         GceAySEtWghBaQeuCCuNkah1T2dNlmM+SzdMG+d3cKFkOpudqB6IUgyikRAS0FbF6RFH
         pzjXCu5e9tFekY5jk3/no7+MXlvXOMdlsXyDTi7V9Fp/qvuTm60N+UlleDZ7YZuaavb/
         EG2fGzbG16n0QKO9QlHMXJAvskHd2aqZUmY4S6A0yNH9fgqOeecrLA+etu1AubfFZ5+v
         lnrg==
X-Gm-Message-State: ANoB5pl+JRpujkbZEp+sXzxxr/Gh2NaDoRSzFwQRRwZ73yfBzoEfXc+W
        B1HlLaW5lv/SI4jhI+8iDf3GeMbp9Rw=
X-Google-Smtp-Source: AA0mqf47Wr/e9SYIYG2MxuyNDOFV4K49MbtuZvm5nmlgo9zP+gGxiuyxLSatXOGLxfIwC/L6y1bgqA==
X-Received: by 2002:a17:902:7c8a:b0:189:ed86:178b with SMTP id y10-20020a1709027c8a00b00189ed86178bmr18625085pll.64.1670835610242;
        Mon, 12 Dec 2022 01:00:10 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090301c700b00189bf5dc96dsm5771488plh.230.2022.12.12.01.00.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2022 01:00:09 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/mmu: Warn on linking when sp->unsync_children
Date:   Mon, 12 Dec 2022 17:01:06 +0800
Message-Id: <20221212090106.378206-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Since the commit 65855ed8b034 ("KVM: X86: Synchronize the shadow
pagetable before link it"), no sp would be linked with
sp->unsync_children = 1.

So make it WARN if it is the case.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4d188f056933..15d389370f88 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2367,7 +2367,16 @@ static void __link_shadow_page(struct kvm *kvm,
 
 	mmu_page_add_parent_pte(cache, sp, sptep);
 
-	if (sp->unsync_children || sp->unsync)
+	/*
+	 * The non-direct sub-pagetable must be updated before linking.  For
+	 * L1 sp, the pagetable is updated via kvm_sync_page() in
+	 * kvm_mmu_find_shadow_page() without write-protecting the gfn,
+	 * so sp->unsync can be true or false.  For higher level non-direct
+	 * sp, the pagetable is updated/synced via mmu_sync_children() in
+	 * FNAME(fetch)(), so sp->unsync_children can only be false.
+	 * WARN_ON_ONCE() if anything happens unexpectedly.
+	 */
+	if (WARN_ON_ONCE(sp->unsync_children) || sp->unsync)
 		mark_unsync(sptep);
 }
 
-- 
2.19.1.6.gb485710b

