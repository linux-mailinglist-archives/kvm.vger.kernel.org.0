Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99445179BB
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 00:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiEBWKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 18:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387838AbiEBWIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 18:08:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430A9DEF0
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 15:03:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b6-20020a5b0b46000000b006457d921729so14220906ybr.23
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 15:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2gUboy0WpFlCg1gFI2kR0+guXhO1kfu4J8SY0iPJjDQ=;
        b=GewRa3J35S+FRxNXKKNFgCgf7atU9k5i09pFjVniOagEm8rpyRY7mK3a3MyKONvGMZ
         gNesx2hOixBJwkSpuKBZr1Po+U8aUb/Qb1UO7c2JL7F4D8oofG4pzq2GuXujTlHJpNWt
         pG8PVZxHVVVztANqRqQO0xzma2sAQyz2xZGXKGEMCkWPMpuNzmPIyn44DoiKCbMN/gQW
         Nrm86pDSQkwH8uo5SJHT0q+enzstOYvIvtu5iWpKQdvVrzV01Wy3rTMY0T6G24zBII2+
         8YRJOGw6Ics802QVk8asorbOB7jvWxV15lAvXI6HHNBDcuUdLRq+JZ2a0RGoFc+GRqaJ
         NnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2gUboy0WpFlCg1gFI2kR0+guXhO1kfu4J8SY0iPJjDQ=;
        b=5bjdlwT0EbCVNFevRzxHrUT7v02PrD/2WdLfCHQwcYR577bQbo8BOVxcrbIlAoinR2
         p5oR6M5c40vTpyRQ8EX1yzzfMdg7dnVcYaTBst1duiFxYvasAMbTtjE4lnAdGTdQ7tnd
         Y72VuL+JFE3O06BRs3L3iHZEsA1VNTh9m/i2z/PjzIQuB8OYJwCjb2UY4tSeDUAKxePk
         NoMPV2Oastn5N9DQYS1hp11lFoCyu/C98cR3fLKIbIXbg5645dyjDhNpAPzsgJdtlFrw
         1IiwAHFVSPzicYAOg9y+GRU6hwrDBzob943/kKCFPyX64aTQmF9k5+XHdIorNw+bjlmd
         meUw==
X-Gm-Message-State: AOAM531eNMxgC23kfzMNaAE3GmaARJa5erLYwfaljrHQiYM8RR+bdiRp
        mQjCf6/UEo7U0JZZjUxE9RrDgOmvf57T
X-Google-Smtp-Source: ABdhPJzMjKvSd35EBOdYVwnOBd4B9dGqLkUE0gmUdyvpyWamIAbFHfgnhXf5yZ6H5mWCliCMcfTaEIE80lu+
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a5b:68a:0:b0:648:fcd2:3767 with SMTP id
 j10-20020a5b068a000000b00648fcd23767mr12309259ybq.358.1651529034451; Mon, 02
 May 2022 15:03:54 -0700 (PDT)
Date:   Mon,  2 May 2022 22:03:47 +0000
Message-Id: <20220502220347.174664-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Avoid calling handlers on empty rmap entries and skip to the next non
empty rmap entry.

Empty rmap entries are noop in handlers.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
---

v2:
- Removed noinline from slot_rmap_walk_next signature

v1:
- https://lore.kernel.org/lkml/20220325233125.413634-1-vipinsh@google.com

 arch/x86/kvm/mmu/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 77785587332e..4e8d546431eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1501,9 +1501,11 @@ static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
 
 static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 {
-	if (++iterator->rmap <= iterator->end_rmap) {
+	while (++iterator->rmap <= iterator->end_rmap) {
 		iterator->gfn += (1UL << KVM_HPAGE_GFN_SHIFT(iterator->level));
-		return;
+
+		if (iterator->rmap->val)
+			return;
 	}
 
 	if (++iterator->level > iterator->end_level) {

base-commit: 71d7c575a673d42ad7175ad5fc27c85c80330311
-- 
2.36.0.464.gb9c8b46e94-goog

