Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAEE53DA81
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350369AbiFEGdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349893AbiFEGdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:33:47 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D844839833;
        Sat,  4 Jun 2022 23:33:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w21so10391147pfc.0;
        Sat, 04 Jun 2022 23:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YvwhpBEVr+JVMGhFVSm13HlZhDft0aOf75cXo07eXkQ=;
        b=IMk0sQHgGvvPa0UgEbBM96DpYC+oyg/kzYecPLGUEo8WIL1tUsf5G+nwCX9er8HKgK
         SPlnECrH3eTy0DGrFeh72HblzEyDQrcIrLxwgrBcZ6b0gvmf2iLknuCwpaFJvkzsV3vk
         v813oLBXjJLkzqttbuav6y0I2lV8gpbGPtMw9FbJxGd/rNT1qaqk9OL4Yqd9h0AKkf6k
         97wW4YyPHjbOgdPzXE5XU2L5s7tT7x65bPaDPMI+EPg1VGLeIGwA1D1+VN36G5ZAizeY
         mpSalOSPAhFyfBRpyCpdBv8eDgWaGR7PTVuc7LX/yF5ivN4eXf9D5oIlnKmu5l7Phn4e
         y6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YvwhpBEVr+JVMGhFVSm13HlZhDft0aOf75cXo07eXkQ=;
        b=vuew2c+zqVKoPXBMhchWGieEc/dI839AWdp5wF5RVtReCsBB4OmoCuvylhVzootOe6
         B9b1/6L6MLHnqA1/wcbcZwEyrdSt8wjl9Bzmwq1uxLIL32U3DiuWjEfYPDC8aWIo9bNp
         fHVOIAyW+RLjLblG33iqioFW5pz6QhhneMVMAz95LHPVlGByhQOCrlBG/zuHQxUQ6UFc
         jH/qa3kKcUmJRrBZRmNT56w5NQb1cFgN6qvVK0UUvKMPoEO8ZmZIAomySTEA5eqGLk+G
         Cs9u27bq7wzjWBEyc311Ck2hOTksWosT0DqoSVCPirKW52GPTpvQxAltiStzOfGK19uf
         JSnw==
X-Gm-Message-State: AOAM532b45bpRa3W2tB3WKC5JQwGqpDsVVZp8KfEfS7Nyeo14pV1xxAp
        LXJ8QzpZz46mPfvXV0Kik7xyXRzmpjY=
X-Google-Smtp-Source: ABdhPJwQ3dNEnHqhPyUif8oNJ68gFVPJJltPU4Yfi0T6n3Bckn7nSLu5ZZ1D4XT01FiiYx0+Yi0GMQ==
X-Received: by 2002:a63:131a:0:b0:3fa:aa7e:b28a with SMTP id i26-20020a63131a000000b003faaa7eb28amr15537460pgl.569.1654410826217;
        Sat, 04 Jun 2022 23:33:46 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id w25-20020aa78599000000b0051bc22c153asm6599970pfn.65.2022.06.04.23.33.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:33:46 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 5/6] KVM: X86/MMU: Remove useless mmu_topup_memory_caches() in kvm_mmu_pte_write()
Date:   Sun,  5 Jun 2022 14:34:16 +0800
Message-Id: <20220605063417.308311-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: <20220605063417.308311-1-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Since the commit c5e2184d1544("KVM: x86/mmu: Remove the defunct
update_pte() paging hook"), kvm_mmu_pte_write() no longer uses the rmap
cache.

So remove mmu_topup_memory_caches() in it.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c935fdfc2544..086f32dffdbe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5326,13 +5326,6 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
-	/*
-	 * No need to care whether allocation memory is successful
-	 * or not since pte prefetch is skipped if it does not have
-	 * enough objects in the cache.
-	 */
-	mmu_topup_memory_caches(vcpu, true);
-
 	write_lock(&vcpu->kvm->mmu_lock);
 
 	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, &bytes);
-- 
2.19.1.6.gb485710b

