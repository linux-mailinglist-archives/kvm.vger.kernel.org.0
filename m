Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C36BA513
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjCOCST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjCOCSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196832F78F
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536d63d17dbso186987597b3.22
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PspZCzUKPaFAOpAxbY2Ovw8whn5Lj6qp2h/+W5rl0Nw=;
        b=FtE7NUPPDAZpU6HMOhKHMXQBEef1ltjt6HKkrMzk5UsmDjG/njjxE3SprJYef0Focc
         AIAMROMVhqSkeyvtuYlgsa6lJAuppz2Ob7/BimDublG2szvI4SEyODT3W8zk9cNqsFNO
         0dv4g6sMXbtJu0FlA61QnAVYyqBwzmEGbDtq2i5uHvzQh85TkLfOoPpsXS/fb3E1vB2u
         iGnkzZGosWXQlViwny1o7mDgq7pu2POm3+xzgXX2RClZf4JZ4ao7JADJQ6zjHNDK85Qr
         AmNWleJd2pTJ0xqb60nbRQMxC70E8f9lVNlI+MUr47mZICtk8BmM4sJSxV/Y5PMMU1BG
         l9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PspZCzUKPaFAOpAxbY2Ovw8whn5Lj6qp2h/+W5rl0Nw=;
        b=C7jMocixYhpS9fBfBYh2+7O4WwLXOHLQArjnDx17vHf1z3yjwNG1IVg6V3eBcJ1YW3
         nKS7T5uDrCfWPK7QJxeGzfijMWX83ISI22bOJQAC6Doxpa941Hmw/9q19IC0S1uX80hA
         iClID4xeYxHdq3zLe6cJ7W0nCpWBpFmjmwBBauIJPBI4AFXfE2t5eS94zrlWawv2w+KJ
         TinnmwVqCTkKpyxwj7yPRfgJWgjbfIzyYt/RxqPsnFAOSg2tQ71eeEIoQUC4/p1qsHQ3
         yXayMsO5Wp1eaWgKc8fiUZMA8gQBtDKunPzygZ5I03hofsGFm27dcov/uBYdTPWpzNaY
         TDXw==
X-Gm-Message-State: AO0yUKXcfwYung/PjJXj1pG0CfdUMv7tvrZKDPPotmhxGrllDFhNAFNE
        eEqcMJx6Y7vwpaFEQT+Z+J/elkm0OnJTBQ==
X-Google-Smtp-Source: AK7set88lixFsKzxi/PrTdCTgM6mm48cFhmYViig7GrUjxGvtnUZfp8R/105AQWd8fUvHaeveJivsDp2ITohTw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1024:b0:b4a:3896:bc17 with SMTP
 id x4-20020a056902102400b00b4a3896bc17mr1226573ybt.0.1678846688254; Tue, 14
 Mar 2023 19:18:08 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:32 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-9-amoorthy@google.com>
Subject: [WIP Patch v2 08/14] KVM: x86: Implement memory fault exit for FNAME(fetch)
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---
 arch/x86/kvm/mmu/paging_tmpl.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 57f0b75c80f9d..ed996dccc03bf 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -717,7 +717,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
-		return -EFAULT;
+		return kvm_memfault_exit_or_efault(
+			vcpu, fault->gfn * PAGE_SIZE, KVM_PAGES_PER_HPAGE(fault->goal_level),
+			KVM_MEMFAULT_REASON_UNKNOWN);
 
 	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, gw->pte_access,
 			   base_gfn, fault->pfn, fault);
-- 
2.40.0.rc1.284.g88254d51c5-goog

