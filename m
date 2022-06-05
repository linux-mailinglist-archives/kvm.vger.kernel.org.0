Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51DC53DA78
	for <lists+kvm@lfdr.de>; Sun,  5 Jun 2022 08:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350793AbiFEGnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jun 2022 02:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350731AbiFEGnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jun 2022 02:43:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DDE43EE5;
        Sat,  4 Jun 2022 23:43:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h1so9822611plf.11;
        Sat, 04 Jun 2022 23:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3eBsFJ18pF1qO1rm3dNSOKE58CjtlgTGIMUN29KX6lU=;
        b=UgOi65DOQaBv9hI+RV62pFeDtA4skU/RXJDEsturdsDrMAwSk+0tvK9/i7ET9jXMIW
         koNE01d9KyPdiXDAyF3zSZj0RgpK1gbbZCkAIaRSLBBlfOm3ocJ6rrF2rPYzwTNhlZxm
         LqpZzlcjp74dDteVnQZBZxDPBomXZTYlSuuYZeXehojq75IwaZiPhOIoJlpz2sXOg3//
         a8bUVpcvn981+a3lopeFsXGuYhAQuLrTcMbIuj+hnKKKCqv8Cjy+Q/buD2xNF4JYmRaB
         Bwg7Npr5dx6O3TLy1XAL7BX69yDMZztZ8xEOcGh5AN8YvkwqmtU0i4lWUqe9i8ArCeBX
         8FmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3eBsFJ18pF1qO1rm3dNSOKE58CjtlgTGIMUN29KX6lU=;
        b=WtmDnkzuLqTg2x3P3h+XJM9SycsZtkx8ImWcwpPnjCAx2hfTqyVgraZas5tkDgm+Pm
         K9KlRIaYRTeTwsQrpJV5miY2/DkY6+l02Shv0F/bAnCZFA67gAesZDzXcn6XoJWDfmaJ
         /LP23QJZIJRkRp7auzcSdx79LrVooW4osal4Zw4NuMHj+2uIhDWtUeVDMMBY6qyPmCYt
         8DTBDxQ/zajv+mJDelRarxUKJCeOP04oPKoKlUSlp63azR86us6VyoOZOqEAAq7H4YOJ
         JA7vC7TLMy8JvFmjK9ePA6m/dBIEVvOYKYSyv2zgJT8aPRcWV2CmbFqAX45T9nUGlls1
         MAYg==
X-Gm-Message-State: AOAM533AUNzN5pq+Hh/2Fpk3YadWppNBSEV9a4VZ4/sTTILm0HkBeV91
        W8nXf1mOdLqrYVUeU/E2WZCN3DKZ668=
X-Google-Smtp-Source: ABdhPJxGi7B52Ale/DMFBtDJYilBopY6YXs1YKD8RSEroiTg/bnC0a2Vmxtjqk1j/at57EXyoJDhfA==
X-Received: by 2002:a17:90b:504:b0:1e6:a0a4:c823 with SMTP id r4-20020a17090b050400b001e6a0a4c823mr15129107pjz.190.1654411391531;
        Sat, 04 Jun 2022 23:43:11 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id k18-20020aa79732000000b0050e006279bfsm8352012pfg.137.2022.06.04.23.43.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Jun 2022 23:43:11 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 05/12] KVM: X86/MMU: Clear unsync bit directly in __mmu_unsync_walk()
Date:   Sun,  5 Jun 2022 14:43:35 +0800
Message-Id: <20220605064342.309219-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220605064342.309219-1-jiangshanlai@gmail.com>
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
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

mmu_unsync_walk() and __mmu_unsync_walk() requires the caller to clear
unsync for the shadow pages in the resulted pvec by synching them or
zapping them.

All callers does so.

Otherwise mmu_unsync_walk() and __mmu_unsync_walk() can't work because
they always walk from the beginning.

It is possible to make mmu_unsync_walk() and __mmu_unsync_walk() lists
unsync shadow pages in the resulted pvec without needing synching them
or zapping them later.  It would require to change mmu_unsync_walk()
and __mmu_unsync_walk() and make it walk from the last visited position
derived from the resulted pvec of the previous call of mmu_unsync_walk().

It would complicate the walk and no callers require the possible new
behavior.

It is better to keep the original behavior.

Since the shadow pages in the resulted pvec will be synced or zapped,
and clear_unsync_child_bit() for parents will be called anyway later.

Call clear_unsync_child_bit() earlier and directly in __mmu_unsync_walk()
to make the code more efficient (the memory of the shadow pages is hot
in the CPU cache, and no need to visit the shadow pages again later).

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f35fd5c59c38..2446ede0b7b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1794,19 +1794,23 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 				return -ENOSPC;
 
 			ret = __mmu_unsync_walk(child, pvec);
-			if (!ret) {
-				clear_unsync_child_bit(sp, i);
-				continue;
-			} else if (ret > 0) {
-				nr_unsync_leaf += ret;
-			} else
+			if (ret < 0)
 				return ret;
-		} else if (child->unsync) {
+			nr_unsync_leaf += ret;
+		}
+
+		/*
+		 * Clear unsync bit for @child directly if @child is fully
+		 * walked and all the unsync shadow pages descended from
+		 * @child (including itself) are added into @pvec, the caller
+		 * must sync or zap all the unsync shadow pages in @pvec.
+		 */
+		clear_unsync_child_bit(sp, i);
+		if (child->unsync) {
 			nr_unsync_leaf++;
 			if (mmu_pages_add(pvec, child, i))
 				return -ENOSPC;
-		} else
-			clear_unsync_child_bit(sp, i);
+		}
 	}
 
 	return nr_unsync_leaf;
-- 
2.19.1.6.gb485710b

