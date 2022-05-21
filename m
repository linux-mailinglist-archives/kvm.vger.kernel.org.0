Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707E652FCC3
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355329AbiEUNRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355270AbiEUNRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:17:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347F756C10;
        Sat, 21 May 2022 06:16:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l14so10190130pjk.2;
        Sat, 21 May 2022 06:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fQH2zr83sjDai8/bGfNzq6iiSpBWMtWKp/VD1T2j7tI=;
        b=if9OiDwUjIHLte68aGpBhCFJjybVAKpKHLJRYupHCHhxpZFA7lVkHESh3uLvT2whpP
         XvbFCXjcAsgKHmTsoknEqVXg9nwgYgcLc139yCZZRCOzXtn/Q8Xb0aI36QePAoLYzeRR
         Vz5ejrzaSOOskVkhltF3IWummF1TXpS+AOtjN0+/+aopyKI2QPVyFjS3qckPDmbgepnq
         nOO+Z5YzEnqqjAWdrfhbhQn+o3zpHiJSGN7CJ9sMM1I/qDUR14J7TLlTEBYkRcew7xap
         zNy9KYW8lyBdJ//XnzqIlWzvs4ti8MwfZHzMkhamHPsKhXoXnYhOflWTBbYiSHrxrL8Y
         7A6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fQH2zr83sjDai8/bGfNzq6iiSpBWMtWKp/VD1T2j7tI=;
        b=ZgSUiJrQT85wBorTQ72ChSebt1unlbH3PNkolVfFBrlFSBumJ/ijCfuqkelFRT7rQQ
         DyDTmlzP0Bf38IX6GwHrNyZUqUXim585x+xbW9XsdcAk8lGvjTq/sysphNK75E20y2el
         EhCqqbsIeagCRexPZEj1E6Ru6bf/Ax90UlQ6vcYseh8rr3LtfRWn/06cHCTVYFwdKCs4
         QA1M/ee9DIO7eQW7xMyGb6EYzKIPOw91Hzjb+c4cWi21kMwdBSKdhOblSMwUAxrH+Aig
         /lRdjqIuby42fwpX/k+cxgTDCJhEXdEhSvd+kXh/cfcc7SmoMdB4M8eUuSmuiCYKXi0e
         7P6Q==
X-Gm-Message-State: AOAM530+si6Bl5RqYs2M4EwK8oE5SwPnjKSOPEFTd0tJcimhnvBd4MFo
        HoPwvzRxiqP29Z5KcqswZR5ACDk1YV4=
X-Google-Smtp-Source: ABdhPJw/7gk3sgaSQ0NTwi53kntpyz6wS2f1vtenPnoG6rVtpnjJ3Jzh9FXaTyqoImTWS2fMnIo82A==
X-Received: by 2002:a17:902:bb89:b0:161:ffec:a1b3 with SMTP id m9-20020a170902bb8900b00161ffeca1b3mr4565723pls.141.1653139005838;
        Sat, 21 May 2022 06:16:45 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id m5-20020a654385000000b003c14af5062csm1474310pgp.68.2022.05.21.06.16.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:45 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 11/12] KVM: X86/MMU: Don't use mmu->pae_root when shadowing PAE NPT in 64-bit host
Date:   Sat, 21 May 2022 21:16:59 +0800
Message-Id: <20220521131700.3661-12-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
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

Allocate the tables when allocating the local shadow page.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63c2b2c6122c..73e6a8e1e1a9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1809,10 +1809,12 @@ static bool using_local_root_page(struct kvm_mmu *mmu)
  * 2 or 3 levels of local shadow pages on top of non-local shadow pages.
  *
  * Local shadow pages are locally allocated.  If the local shadow page's level
- * is PT32E_ROOT_LEVEL, it will use the preallocated mmu->pae_root for its
- * sp->spt.  Because sp->spt may need to be put in the 32 bits CR3 (even in
- * x86_64) or decrypted.  Using the preallocated one to handle these
- * requirements makes the allocation simpler.
+ * is PT32E_ROOT_LEVEL, and it is not shadowing nested NPT for 32-bit L1 in
+ * 64-bit L0 (or said when the shadow pagetable's level is PT32E_ROOT_LEVEL),
+ * it will use the preallocated mmu->pae_root for its sp->spt.  Because sp->spt
+ * need to be put in the 32-bit CR3 (even in 64-bit host) or decrypted.  Using
+ * the preallocated one to handle these requirements makes the allocation
+ * simpler.
  *
  * Local shadow pages are only visible to local VCPU except through
  * sp->parent_ptes rmap from their children, so they are not in the
@@ -1852,13 +1854,12 @@ kvm_mmu_alloc_local_shadow_page(struct kvm_vcpu *vcpu, union kvm_mmu_page_role r
 	sp->gfn = 0;
 	sp->role = role;
 	/*
-	 * Use the preallocated mmu->pae_root when the shadow page's
-	 * level is PT32E_ROOT_LEVEL which may need to be put in the 32 bits
+	 * Use the preallocated mmu->pae_root when the shadow pagetable's
+	 * level is PT32E_ROOT_LEVEL which need to be put in the 32 bits
 	 * CR3 (even in x86_64) or decrypted.  The preallocated one is prepared
 	 * for the requirements.
 	 */
-	if (role.level == PT32E_ROOT_LEVEL &&
-	    !WARN_ON_ONCE(!vcpu->arch.mmu->pae_root))
+	if (vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL)
 		sp->spt = vcpu->arch.mmu->pae_root;
 	else
 		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-- 
2.19.1.6.gb485710b

