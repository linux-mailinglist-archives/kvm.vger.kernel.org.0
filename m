Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13BF52FCB3
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354914AbiEUNQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354795AbiEUNQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F232A1AF22;
        Sat, 21 May 2022 06:16:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 10so5990112plj.0;
        Sat, 21 May 2022 06:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sLeJwTRZqKwsni6KD3sTwNx4zaX7WbD0rQURlwLIxqw=;
        b=qNYBQUMvmkIWvAFd09B6mjeqs0CZHBIWv1m+/Im5RVDENWdlTn9upvNJbBlTUOHRcN
         7C2a6qUjwS23O6suq6mAFVsf7xVcB5stZLNTuQQtjxwQIbrXFhYjNWLYWOR22c9VZe98
         t7giFroEmdlXDNQFHZe6GD1lp5yRz3SbLwEdIUfgv2/OxFjzuR59KcBHSYGqaoBNhFw+
         NTH7GkrCjlCE+awAsQVa4bftDxTuN02nuUWD3tOHa9oJxDkyTCj99giMoltWN/tz8sRP
         jZSJT4S4TGWzGBOLoxKPTWokrn+wp2w5YqwuGymjhi8Jt1UYiDXJhH6lWzC+k04dm8Yo
         O4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sLeJwTRZqKwsni6KD3sTwNx4zaX7WbD0rQURlwLIxqw=;
        b=eRNAnl2NXPpF8twoJsdLsJVWZ/ZEAQN6wFAM8y7HoaTLCl6rpBH5EinYcRTstabzFT
         hLrqsFOI6wCx9ZQPERi6Uw472LB23yjDvjJBxTjOSNILt+hvsYTsqhJTihIZdc0Kbdkm
         fqXb4zmHrLb6e404ZZki15e1Kfe/BOw/KAuoQPmu7P8H+ERY0ykls7P73TtyhXNInNC3
         PPwP9i3ROoDK7Db20Xy8GClgHkK9LknfUaPbF0vBKoS2tK5+49k5k/wozPWzb0KtnRna
         SMQGRAz+HdsnZ191257H6mJrE2+E03ToLPs2J/ow5vVsJ849ec9P7jDppdHZlZHBSayw
         3kbA==
X-Gm-Message-State: AOAM531PvRz918jXoTE4bZMYcH8JBs72kfBTfPkwumHOlbIPPbTUYoXe
        XJvzaY5i3lVN89vuQj6YL79SttpPy8E=
X-Google-Smtp-Source: ABdhPJyK0S8CvG3PwY7JthQT8/D6JlpIGj4RcIl+AZHC7FvxjSCPmxjR+nVOei6lvJu6l9H8jSFfVg==
X-Received: by 2002:a17:902:e193:b0:161:e848:ad57 with SMTP id y19-20020a170902e19300b00161e848ad57mr9970313pla.167.1653138972211;
        Sat, 21 May 2022 06:16:12 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902f60900b0015e8d4eb2adsm1528316plg.247.2022.05.21.06.16.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:12 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 02/12] KVM: X86/MMU: Add using_local_root_page()
Date:   Sat, 21 May 2022 21:16:50 +0800
Message-Id: <20220521131700.3661-3-jiangshanlai@gmail.com>
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

In some cases, local root pages are used for MMU.  It is often using
to_shadow_page(mmu->root.hpa) to check if local root pages are used.

Add using_local_root_page() to directly check if local root pages are
used or needed to be used even mmu->root.hpa is not set.

Prepare for making to_shadow_page(mmu->root.hpa) returns non-NULL via
using local shadow [root] pages.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..624b6d2473f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1690,6 +1690,39 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
+/*
+ * KVM uses the VCPU's local root page (vcpu->mmu->pae_root) when either the
+ * shadow pagetable is using PAE paging or the host is shadowing nested NPT for
+ * 32bit L1 hypervisor.
+ *
+ * It includes cases:
+ *	nonpaging when !tdp_enabled				(direct paging)
+ *	shadow paging for 32 bit guest when !tdp_enabled	(shadow paging)
+ *	NPT in 32bit host (not shadowing nested NPT)		(direct paging)
+ *	shadow nested NPT for 32bit L1 hypervisor in 32bit host (shadow paging)
+ *	shadow nested NPT for 32bit L1 hypervisor in 64bit host (shadow paging)
+ *
+ * For the first four cases, mmu->root_role.level is PT32E_ROOT_LEVEL and the
+ * shadow pagetable is using PAE paging.
+ *
+ * For the last case, it is
+ * 	mmu->root_role.level > PT32E_ROOT_LEVEL &&
+ * 	!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL
+ * And if this condition is true, it must be the last case.
+ *
+ * With the two conditions combined, the checking condition is:
+ * 	mmu->root_role.level == PT32E_ROOT_LEVEL ||
+ * 	(!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL)
+ *
+ * (There is no "mmu->root_role.level > PT32E_ROOT_LEVEL" here, because it is
+ *  already ensured that mmu->root_role.level >= PT32E_ROOT_LEVEL)
+ */
+static bool using_local_root_page(struct kvm_mmu *mmu)
+{
+	return mmu->root_role.level == PT32E_ROOT_LEVEL ||
+	       (!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL);
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
@@ -4252,10 +4285,11 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 {
 	/*
 	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
-	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
-	 * later if necessary.
+	 * having to deal with PDPTEs.  Local roots can not be put into
+	 * mmu->prev_roots[] because mmu->pae_root can not be shared for
+	 * different roots at the same time.
 	 */
-	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
+	if (unlikely(using_local_root_page(mmu)))
 		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
 
 	if (VALID_PAGE(mmu->root.hpa))
-- 
2.19.1.6.gb485710b

