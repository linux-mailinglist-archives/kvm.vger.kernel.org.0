Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0965C52FCB4
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354917AbiEUNQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355000AbiEUNQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B34D20F7E;
        Sat, 21 May 2022 06:16:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 137so9922631pgb.5;
        Sat, 21 May 2022 06:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NfacmhLdAjJbzvc0zFEh8OxPHT+Y2L5BPF+17U7WCLE=;
        b=js7+NRAg9D+K+VH+fPPrjU/Oz4FLVEqkcIZAdb9sAz+o+U8rU4fwl9qE8LtrJNdcXO
         nes32AirKMLMO//kz5qFvHrM6WiXG5CHa5xC3uUebzaZbG16TKULtDbPcMcZhlbozeQi
         NKATH82Toj/D587xsuUAphrPwq1pOgzAeB583y0ob8TfanBbHK1lVI20U7tcc4rngRYC
         mCDiINV8zEibJTI7QsKcKzDNxC3thMmfkYH2fmxwJ1ridB7p2m6JtZM0vbg2KauQujtu
         /3P0NtUY1aSZtvw97nSWyah1alBq8yzQpKxtwOx94BgbrT8Ztpfq85jYmTUI5hSOQh9v
         h8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NfacmhLdAjJbzvc0zFEh8OxPHT+Y2L5BPF+17U7WCLE=;
        b=G4x1hgBRnRFMdRxXDAzwHxgmApob3sBZr9kthDQt3Hn5k3ad5L3YH+Mz1GdWakujTI
         S/bvsKgSflMJt3VeqwyALVCv3rpXKgVUS25aJQWMSj2IbHII2BkjnLU2/3noRa6UGYdw
         3pHy8O9u89uCIELesxbUxhdWgAp1JSj7PzdnOV/P9vxzjEyegjLjsbhrtzeS6UF0ucha
         za8BUFK+WK9P7etXIMPAE/7bZPdWf2Y3FUwU+dKthaJstK9K0DfFcKUcfZ9z6coJgFN8
         H/u/yMbr4Zvbp9ryrWN7fRF9L/mbxa1Xy/3xZOaN4EJ04TTmkHC8wwDoasWJsarzQoPC
         nqHA==
X-Gm-Message-State: AOAM532cwDLTo2XyvVb9mxgKn+QoOpRNkbk31sIhQd/4SkQu10/MjnJX
        HXdf+B6wC3Vxo/WWK79J5VUL5qy9CM4=
X-Google-Smtp-Source: ABdhPJwD88q0AA0d5wEtfx/f1kQX9cVEEPeMgRUyXs3GJoFgihoWwKnkI4H9dLZBeoDOpJg5+LpRGg==
X-Received: by 2002:a05:6a00:846:b0:50d:f02f:bb46 with SMTP id q6-20020a056a00084600b0050df02fbb46mr14899936pfk.74.1653138975686;
        Sat, 21 May 2022 06:16:15 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id x22-20020aa784d6000000b0050e0dadb28dsm3592815pfn.205.2022.05.21.06.16.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:15 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 03/12] KVM: X86/MMU: Reduce a check in using_local_root_page() for common cases
Date:   Sat, 21 May 2022 21:16:51 +0800
Message-Id: <20220521131700.3661-4-jiangshanlai@gmail.com>
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

For most cases, mmu->root_role.direct is true and mmu->root_role.level
is not PT32E_ROOT_LEVEL which means using_local_root_page() is often
checking for all the three test which is not good in fast paths.

Morph the conditions in using_local_root_page() to an equivalent one
to reduce a check.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 45 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 624b6d2473f7..240ebe589caf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1716,11 +1716,52 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
  *
  * (There is no "mmu->root_role.level > PT32E_ROOT_LEVEL" here, because it is
  *  already ensured that mmu->root_role.level >= PT32E_ROOT_LEVEL)
+ *
+ * But mmu->root_role.direct is normally true and mmu->root_role.level is
+ * normally not PT32E_ROOT_LEVEL.  To reduce a check for the fast path of
+ * fast_pgd_switch() in mormal case, mmu->root_role.direct is checked first.
+ *
+ * The return value is:
+ * 	mmu->root_role.level == PT32E_ROOT_LEVEL ||
+ * 	(!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
+ * =>
+ * 	(mmu->root_role.direct && mmu->root_role.level == PT32E_ROOT_LEVEL) ||
+ * 	(!mmu->root_role.direct && mmu->root_role.level == PT32E_ROOT_LEVEL) ||
+ * 	(!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
+ * =>
+ * 	(mmu->root_role.direct && mmu->root_role.level == PT32E_ROOT_LEVEL) ||
+ * 	(!mmu->root_role.direct &&
+ * 	 (mmu->root_role.level == PT32E_ROOT_LEVEL ||
+ * 	  mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL))
+ * => (for !direct, mmu->root_role.level == PT32E_ROOT_LEVEL implies
+ * 	mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
+ * =>
+ * 	(mmu->root_role.direct && mmu->root_role.level == PT32E_ROOT_LEVEL) ||
+ * 	(!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
+ *
+ * In other words:
+ *
+ * For the first and third cases, it is
+ * 	mmu->root_role.direct && mmu->root_role.level == PT32E_ROOT_LEVEL
+ * And if this condition is true, it must be one of the two cases.
+ *
+ * For the 2nd, 4th and 5th cases, it is
+ * 	!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL
+ * And if this condition is true, it must be one of the three cases although
+ * it is not so intuitive.  It can be split into:
+ * 	mmu->root_role.level == PT32E_ROOT_LEVEL &&
+ * 	(!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
+ * which is for the 2nd and 4th cases and
+ * 	mmu->root_role.level > PT32E_ROOT_LEVEL &&
+ * 	!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL
+ * which is the last case.
  */
 static bool using_local_root_page(struct kvm_mmu *mmu)
 {
-	return mmu->root_role.level == PT32E_ROOT_LEVEL ||
-	       (!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL);
+	if (mmu->root_role.direct)
+		return mmu->root_role.level == PT32E_ROOT_LEVEL;
+	else
+		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
 }
 
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
-- 
2.19.1.6.gb485710b

