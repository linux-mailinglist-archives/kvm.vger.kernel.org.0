Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272AB594EC1
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiHPCjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiHPCip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:38:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1725D118
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f58599ad3so80072437b3.20
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=4TF4un5rZ4qGVEkGftKNSbAbhoaQj1Cr6s6CkUUZi1w=;
        b=QBLLhl3JXTfGvCSJIYKZ+drpQI0iTzlI01nGXpQJeOTmpywjHkKfdS5BtTiCXQEc1o
         +Yaw5mXrZ6pgiCaWGOUt8imYwRLZottAQWfP3N8DkwxQy2h58HOwuhHa5nby4Z4XeYrc
         Eg6quNCPMbI4HR4dKl6E13dK10P6mOGygZi78YIavcniSG09iDYrw0wX8SOlG5UXyhDi
         evapb1AOSwSxcn1uDbGHRRsynK7+vJBkAre3Yylst1xpNiO+cmkyN1RC2o6PqRabYKKo
         wAImNWAWmMgTw0LOljVDq/ngX2XtjZG+HQ9JsB4dbEv84vaSW1wsQxV55a8II7cUAg7k
         LzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=4TF4un5rZ4qGVEkGftKNSbAbhoaQj1Cr6s6CkUUZi1w=;
        b=Bg6sYfMXMyfyq3A/QdmqkQcCOlLlIwTxTTuGzJtF5WPYtlUZhuzbrbFnZ1uXeT7awo
         3McJhklgR1d5BXm+KJLQ/eNThcynzgXcxP8Uf9/clMghuWLBKJK3OpH1Wzb/M8avvpIR
         n+LVCgmTswl6v3tslrM3CSbH2RbhCv95+UjSaeSusu5FetmhNvEFSjYHEQVFjnATq4ze
         yfJK1AzQQ05ZFCnUcr1i3PjZyBXqoZZRZZE9xdkOlKLcDG7MT4DrzdftYQsZzUOV4z+0
         usnYMN+kYiG8VcI/tUbcTZ5mbH6fXPnq7yxGdQU6za99DtB4bB+0+lFMx7SqgQs41EWj
         HY6A==
X-Gm-Message-State: ACgBeo0nSlNa73mHQ90iJCLon8pfryP8HCwkGfKecST1MUTqGR4slCHL
        NKiIjVLAP5tkacrvstTyo6h11Mijw14gXQ==
X-Google-Smtp-Source: AA6agR5r66GeGZQ8bsPBsBT43JIL9YJadMetqiBvSQabF8GpMjl+dk1mShrUVttgwUEnmVxfi6lvKfSjEJAs1g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:5c4:0:b0:67b:89d6:cbf5 with SMTP id
 w4-20020a5b05c4000000b0067b89d6cbf5mr12891566ybp.286.1660604475382; Mon, 15
 Aug 2022 16:01:15 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:02 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 1/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Delete the module parameter tdp_mmu and force KVM to always use the TDP
MMU when TDP hardware support is enabled.

The TDP MMU was introduced in 5.10 and has been enabled by default since
5.15. At this point there are no known functionality gaps between the
TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
better with the number of vCPUs. In other words, there is no good reason
to disable the TDP MMU.

Dropping the ability to disable the TDP MMU reduces the number of
possible configurations that need to be tested to validate KVM (i.e. no
need to test with tdp_mmu=N), and simplifies the code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c                      | 5 +----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f7561cd494cb..e75d45a42b01 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2418,7 +2418,8 @@
 			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
 			cleared.
 
-			Eager page splitting is only supported when kvm.tdp_mmu=Y.
+			Eager page splitting is only supported when TDP hardware
+			support is enabled.
 
 			Default is Y (on).
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debca..d6c30a648d8d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -10,15 +10,12 @@
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
-static bool __read_mostly tdp_mmu_enabled = true;
-module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
-
 /* Initializes the TDP MMU for the VM, if enabled. */
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
-	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
+	if (!tdp_enabled)
 		return 0;
 
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);

base-commit: 93472b79715378a2386598d6632c654a2223267b
prerequisite-patch-id: 8c230105c8a2f1245dedb5b386327d98865d0bb2
prerequisite-patch-id: 9b4329037e2e880db19f3221e47d956b78acadc8
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.1.595.g718a3a8f04-goog

