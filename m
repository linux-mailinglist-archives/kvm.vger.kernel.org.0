Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB504E790B
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 17:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245467AbiCYQkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 12:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243097AbiCYQkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 12:40:01 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B577321801;
        Fri, 25 Mar 2022 09:38:22 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 5so14318991lfp.1;
        Fri, 25 Mar 2022 09:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0333UXko0p5skH7Gomva2kccUTt68Iz1OddCSPNf2js=;
        b=jQgYuAem9ZYHlkccaCCJhjCW8khFDISSGHhsexNPblMgnhrPWV6cZ+LP1hWfT23Y2y
         5XdcS34yhn+TTIdoXcW5n37aTxJrhg9KmsliYM6buKG7yHueuBWcc6ubWkcZECq7RgR8
         uPrXcQ77KZEUNpiPyTNybauYdgNaJTXYWT99kJhv69uzeRMiiRvbw7VssZYC1APWkwWZ
         NAi5JIW+JeT2wgnVsg2/HAxg/+sGpub5ezabhgD5XKOyMQvjJZmGBMstEoT9HeSw99Fv
         VBiidvdDQ4IzS90KBbe2aAMrHgZFzjwdlC38Vvs2TvyHhRahzVgeViBLOqlDDuVDzPfq
         NKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0333UXko0p5skH7Gomva2kccUTt68Iz1OddCSPNf2js=;
        b=79CvEfiISFdRKBTu/IKjoW1rnvKt42io+RyVYdXTOHkoHv6etbNRQvOHXBAMsund/T
         +siMbwiYw86Dx/UNSvcvmRxvyseS5FVSo3ptpulfgPmd5yhSYCs7oTbtOXkoK5KKgYTc
         wr3D+O3uN8ZSEtfUeWKMrVbUq2wO8v0ZX+TZ/4/Nmoq9r/5jq/P9MCJzGwVQXBlMnbAg
         Vc2EpYK1F0eoyVzJLhYfqCaM5Cjlm4PP1TQxA/wEgeG6T9lrTg9J/GRnE9d/arxZvX+b
         bQM3S3g2b87HhwWqNr7REXYWM6kd1uuWVBQFgseAHEh3ztCKRw8cX6S3/FTSgjmCyp+r
         EWaw==
X-Gm-Message-State: AOAM533ABP5KROJNUYsYKSFFFZQk8RETe67ODyw4gfmRFhxbUyZlt+Qq
        TV93UdldLx4iCdWSgk2zHwM=
X-Google-Smtp-Source: ABdhPJx8pJ6C1WooGaA1yRgGm+J6PwJoe8pUYUfcN8+tFB+qD+JiAjBTgkW/Y57geIMTolesj2+now==
X-Received: by 2002:a05:6512:68d:b0:44a:cc2:78b5 with SMTP id t13-20020a056512068d00b0044a0cc278b5mr8057577lfe.43.1648226300542;
        Fri, 25 Mar 2022 09:38:20 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.225])
        by smtp.gmail.com with ESMTPSA id i14-20020a198c4e000000b0044a279d25d2sm755352lfj.244.2022.03.25.09.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 09:38:20 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+717ed82268812a643b28@syzkaller.appspotmail.com
Subject: [RFC PATCH] KVM: x86/mmu: fix general protection fault in kvm_mmu_uninit_tdp_mmu
Date:   Fri, 25 Mar 2022 19:38:15 +0300
Message-Id: <20220325163815.3514-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Syzbot reported GPF in kvm_mmu_uninit_tdp_mmu(), which is caused by
passing NULL pointer to flush_workqueue().

tdp_mmu_zap_wq is allocated via alloc_workqueue() which may fail. There
is no error hanling and kvm_mmu_uninit_tdp_mmu() return value is simply
ignored. Even all kvm_*_init_vm() functions are void, so the easiest
solution is to check that tdp_mmu_zap_wq is valid pointer before passing
it somewhere.

Fixes: 22b94c4b63eb ("KVM: x86/mmu: Zap invalidated roots via asynchronous worker")
Reported-and-tested-by: syzbot+717ed82268812a643b28@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7e7876251b3..b3e8ff7ac5b0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -48,8 +48,10 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
 
-	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
-	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
+	if (kvm->arch.tdp_mmu_zap_wq) {
+		flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
+		destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
+	}
 
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
@@ -119,9 +121,11 @@ static void tdp_mmu_zap_root_work(struct work_struct *work)
 
 static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
-	root->tdp_mmu_async_data = kvm;
-	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
-	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
+	if (kvm->arch.tdp_mmu_zap_wq) {
+		root->tdp_mmu_async_data = kvm;
+		INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
+		queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
+	}
 }
 
 static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
-- 
2.35.1

